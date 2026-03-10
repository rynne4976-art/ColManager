package Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.SocketTimeoutException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

import Dao.EmailDao;

/**
 * JAR 없이 Java SE 표준 라이브러리만으로 구현한 네이버 SMTP 이메일 전송 서비스.
 * 포트 465 직접 SSL 방식 사용 (STARTTLS 불필요).
 * EmailDao를 통해 발신자의 실제 이메일을 DB에서 조회하여 Reply-To 헤더에 설정.
 */
public class EmailService {

    private static final String SMTP_HOST  = "smtp.naver.com";
    private static final int    SMTP_PORT  = 465;
    private static final int    TIMEOUT_MS = 15000;             // 15초 소켓 타임아웃
    private static final String NAVER_ID   = "sjtpals0111@naver.com";
    private static final String NAVER_PW   = "D4DK1YHUJVZM";

    // 수신자 기본값 (미입력 시 사용)
    private static final String DEFAULT_TO = "info@yourschool.edu";

    // DB에서 사용자 이메일을 조회하는 DAO
    private EmailDao emailDao;

    public EmailService() {
        emailDao = new EmailDao();
    }

    /**
     * 이메일을 전송합니다.
     * - to가 null이거나 비어 있으면 기본 수신자(info@yourschool.edu)로 전송합니다.
     * - senderUserId를 이용해 DB에서 발신자의 실제 이메일을 조회하여 Reply-To 헤더에 설정합니다.
     *   (학교 담당자가 답장 시 학생의 이메일로 회신됩니다.)
     *
     * @param to           수신자 이메일 주소 (null 또는 빈 값이면 기본값 사용)
     * @param subject      제목
     * @param body         본문
     * @param senderName   발신자 이름 (세션의 name 속성)
     * @param senderUserId 발신자 user_id (세션의 id 속성) — DB 이메일 조회에 사용
     * @return 전송 성공 여부
     */
    public boolean sendEmail(String to, String subject, String body,
                             String senderName, String senderUserId) {

        // 1. 수신자 기본값 처리 (비즈니스 규칙이므로 Service에서 담당)
        if (to == null || to.trim().isEmpty()) {
            to = DEFAULT_TO;
        }

        // 2. DB에서 발신자의 실제 이메일 조회 (Reply-To 헤더용)
        String senderEmail = emailDao.getEmailByUserId(senderUserId);
        log("DB 조회 발신자 이메일: " + senderEmail);

        SSLSocket socket = null;

        try {
            // 3. SSL 소켓 직접 연결 (포트 465)
            log("SMTP 연결 시도: " + SMTP_HOST + ":" + SMTP_PORT);
            SSLSocketFactory sf = (SSLSocketFactory) SSLSocketFactory.getDefault();
            socket = (SSLSocket) sf.createSocket(SMTP_HOST, SMTP_PORT);
            socket.setSoTimeout(TIMEOUT_MS);
            socket.startHandshake(); 
            log("SSL 핸드셰이크 완료: " + socket.getSession().getProtocol());

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
            PrintWriter writer = new PrintWriter(
                    new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8), true);

            // 4. 서버 인사말 수신
            String greeting = readResponse(reader);
            if (!greeting.startsWith("220")) {
                log("서버 인사말 오류: " + greeting);
                return false;
            }

            // 5. EHLO
            send(writer, "EHLO localhost");
            String ehloResp = readResponse(reader);
            if (!ehloResp.contains("250")) {
                log("EHLO 오류: " + ehloResp);
                return false;
            }

            // 6. AUTH LOGIN
            send(writer, "AUTH LOGIN");
            readResponse(reader); // "334 VXNlcm5hbWU6" (Username:)
            send(writer, base64(NAVER_ID));
            readResponse(reader); // "334 UGFzc3dvcmQ6" (Password:)
            send(writer, base64(NAVER_PW));
            String authResp = readResponse(reader);
            if (!authResp.startsWith("235")) {
                log("인증 실패: " + authResp);
                return false;
            }
            log("인증 성공");

            // 7. 발신자 설정
            send(writer, "MAIL FROM:<" + NAVER_ID + ">");
            String mailFromResp = readResponse(reader);
            if (!mailFromResp.startsWith("250")) {
                log("MAIL FROM 실패: " + mailFromResp);
                return false;
            }

            // 8. 수신자 설정
            send(writer, "RCPT TO:<" + to + ">");
            String rcptResp = readResponse(reader);
            if (!rcptResp.startsWith("250")) {
                log("RCPT TO 실패: " + rcptResp);
                return false;
            }

            // 9. 메일 본문 시작
            send(writer, "DATA");
            String dataStartResp = readResponse(reader);
            if (!dataStartResp.startsWith("354")) {
                log("DATA 시작 실패: " + dataStartResp);
                return false;
            }

            // 10. 헤더 + 본문 작성 (RFC 2822)
            writer.println("From: " + encodeHeader(senderName) + " <" + NAVER_ID + ">");
            writer.println("To: " + to);
            writer.println("Subject: " + encodeHeader(subject));

            // Reply-To: DB에서 조회한 발신자의 실제 이메일 설정
            // → 학교 담당자가 답장 시 학생의 이메일로 회신됨
            if (senderEmail != null && !senderEmail.trim().isEmpty()) {
                writer.println("Reply-To: " + encodeHeader(senderName) + " <" + senderEmail + ">");
            }

            writer.println("MIME-Version: 1.0");
            writer.println("Content-Type: text/plain; charset=UTF-8");
            writer.println("Content-Transfer-Encoding: base64");
            writer.println(); // 헤더-본문 구분 빈 줄
            writer.println(Base64.getMimeEncoder(76, new byte[]{'\r', '\n'})
                    .encodeToString(body.getBytes(StandardCharsets.UTF_8)));
            writer.println("."); // 본문 종료

            String dataEndResp = readResponse(reader);
            if (!dataEndResp.startsWith("250")) {
                log("메일 전송 실패: " + dataEndResp);
                return false;
            }

            // 11. 연결 종료
            send(writer, "QUIT");
            readResponse(reader);

            log("이메일 전송 성공 → " + to);
            return true;

        } catch (SocketTimeoutException e) {
            log("타임아웃 오류 (" + TIMEOUT_MS + "ms 초과): " + e.getMessage());
            return false;
        } catch (IOException e) {
            log("IO 오류 [" + e.getClass().getSimpleName() + "]: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (socket != null && !socket.isClosed()) {
                try { socket.close(); } catch (IOException ignored) {}
            }
        }
    }

    private void send(PrintWriter writer, String command) {
        System.out.println("[SMTP→] " + command);
        writer.println(command);
    }

    private String readResponse(BufferedReader reader) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
            if (line.length() >= 4 && line.charAt(3) == ' ') break;
            if (line.length() == 3) break;
        }
        System.out.println("[SMTP←] " + sb.toString().trim());
        return sb.toString().trim();
    }

    private String base64(String text) {
        return Base64.getEncoder().encodeToString(text.getBytes(StandardCharsets.UTF_8));
    }

    private String encodeHeader(String text) {
        if (text == null || text.isEmpty()) return "";
        return "=?UTF-8?B?" + base64(text) + "?=";
    }

    private void log(String msg) {
        System.out.println("[EmailService] " + msg);
    }
}
