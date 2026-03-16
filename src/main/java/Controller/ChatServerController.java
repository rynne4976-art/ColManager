package Controller;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.HandshakeResponse;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.server.ServerEndpointConfig;

import com.google.gson.JsonObject;

/**
 * WebSocket 채팅 서버 엔드포인트.
 * 경로: /chat  (ws://host/ColManager/chat)
 *
 * - Configurator 내부 클래스: HTTP 세션 → WebSocket 세션 전달 (구 ChatConfigurator)
 * - ChatServerController 본체: 접속·메시지·퇴장 처리 및 JSON 브로드캐스트 (구 ChatController)
 */
@ServerEndpoint(value = "/chat", configurator = ChatServerController.Configurator.class)
public class ChatServerController {

    // ──────────────────────────────────────────────
    // 내부 Configurator (구 ChatConfigurator 흡수)
    // HTTP 핸드셰이크 시 HttpSession을 WebSocket UserProperties에 전달
    // ──────────────────────────────────────────────
    public static class Configurator extends ServerEndpointConfig.Configurator {
        @Override
        public void modifyHandshake(ServerEndpointConfig config,
                                    HandshakeRequest request,
                                    HandshakeResponse response) {
            HttpSession httpSession = (HttpSession) request.getHttpSession();
            if (httpSession != null) {
                config.getUserProperties().put("httpSession", httpSession);
            }
        }
    }

    // ──────────────────────────────────────────────
    // 연결된 클라이언트 세션 → [이름, 역할]
    // ──────────────────────────────────────────────
    private static final Map<Session, String[]> clients =
            Collections.synchronizedMap(new LinkedHashMap<>());

    private static final DateTimeFormatter TIME_FMT =
            DateTimeFormatter.ofPattern("HH:mm");

    // ──────────────────────────────────────────────
    // 1. 클라이언트 접속
    // ──────────────────────────────────────────────
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {

        HttpSession httpSession =
                (HttpSession) config.getUserProperties().get("httpSession");

        String name = "익명";
        String role = "";

        if (httpSession != null) {
            String n = (String) httpSession.getAttribute("name");
            String r = (String) httpSession.getAttribute("role");
            if (n != null) name = n;
            if (r != null) role = r;
        }

        clients.put(session, new String[]{name, role});
        System.out.println("[Chat] 접속: " + name + "(" + role + ") / 현재 " + clients.size() + "명");

        broadcast(buildMessage("join", "시스템", "", name + "님이 입장했습니다."));
    }

    // ──────────────────────────────────────────────
    // 2. 메시지 수신 → 전체 브로드캐스트
    // ──────────────────────────────────────────────
    @OnMessage
    public void onMessage(String message, Session sender) {

        String[] info = clients.get(sender);
        String name = info != null ? info[0] : "익명";
        String role = info != null ? info[1] : "";
        System.out.println("[Chat] [" + name + "]: " + message);

        broadcast(buildMessage("message", name, role, message));
    }

    // ──────────────────────────────────────────────
    // 3. 클라이언트 퇴장
    // ──────────────────────────────────────────────
    @OnClose
    public void onClose(Session session) {
        String[] info = clients.remove(session);
        String name = info != null ? info[0] : "익명";
        System.out.println("[Chat] 퇴장: " + name + " / 현재 " + clients.size() + "명");

        broadcast(buildMessage("leave", "시스템", "", name + "님이 퇴장했습니다."));
    }

    // ──────────────────────────────────────────────
    // 4. 오류 처리
    // ──────────────────────────────────────────────
    @OnError
    public void onError(Session session, Throwable t) {
        System.err.println("[Chat] 오류: " + t.getMessage());
        clients.remove(session);
    }

    // ──────────────────────────────────────────────
    // 내부 유틸 메서드
    // ──────────────────────────────────────────────

    /** 연결된 모든 클라이언트에게 JSON 메시지를 전송한다. */
    private void broadcast(String jsonMsg) {
        synchronized (clients) {
            for (Session s : clients.keySet()) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(jsonMsg);
                    } catch (IOException e) {
                        System.err.println("[Chat] 전송 오류: " + e.getMessage());
                    }
                }
            }
        }
    }

    /** 전송할 JSON 문자열을 빌드한다. */
    private String buildMessage(String type, String sender, String role, String content) {
        JsonObject obj = new JsonObject();
        obj.addProperty("type",      type);
        obj.addProperty("sender",    sender);
        obj.addProperty("role",      role);
        obj.addProperty("content",   content);
        obj.addProperty("time",      LocalTime.now().format(TIME_FMT));
        obj.addProperty("userCount", clients.size());
        return obj.toString();
    }
}
