package Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import Dao.StudentDAO;
import Vo.BoardVo;
import Vo.ChatbotContextVo;
import Vo.EnrollmentVo;
import Vo.StudentVo;
import webSocket.ChatServer;

public class ChatbotService {

    private final String apiKey;
    private final String appUrl;

    private StudentDAO studentDAO;
    private ClassroomService classroomService;
    private ChatServer chatServer;

    public ChatbotService(String apiKey, String appUrl) {
        this.apiKey = apiKey;
        this.appUrl = appUrl;
        this.studentDAO = new StudentDAO();
        this.classroomService = new ClassroomService();
        this.chatServer = new ChatServer();
    }

    public String getReply(String userMessage, String loginId, String role, String studentId) throws Exception {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "질문을 입력해주세요.";
        }

        ChatbotContextVo context = new ChatbotContextVo();
        context.setLoginId(loginId);
        context.setRole(role);
        context.setStudentId(studentId);
        context.setUserQuestion(userMessage);
        context.setIntent(analyzeIntent(userMessage));

        loadContext(context);

        String systemPrompt = buildSystemPrompt(context);

        return chatServer.ask(apiKey, appUrl, systemPrompt, userMessage);
    }

    private String analyzeIntent(String message) {
        String msg = message == null ? "" : message.trim();

        if (msg.contains("시간표") || msg.contains("수업")) {
            return "TIMETABLE";
        }
        if (msg.contains("성적") || msg.contains("학점") || msg.contains("중간") || msg.contains("기말")) {
            return "GRADE";
        }
        if (msg.contains("수강") || msg.contains("신청") || msg.contains("강의")) {
            return "COURSE";
        }
        if (msg.contains("공지")) {
            return "NOTICE";
        }

        return "GENERAL";
    }

    private void loadContext(ChatbotContextVo context) {
        String role = context.getRole();
        String loginId = context.getLoginId();
        String studentId = context.getStudentId();
        String intent = context.getIntent();

        if ("학생".equals(role) && loginId != null && !loginId.trim().isEmpty()) {
            StudentVo student = studentDAO.getStudentById(loginId);
            context.setStudent(student);
        }

        if ("학생".equals(role) && studentId != null && !studentId.trim().isEmpty()) {

            if ("TIMETABLE".equals(intent) || "COURSE".equals(intent)) {
                ArrayList<EnrollmentVo> enrollments = classroomService.serviceStudentCourseSearch(studentId);
                context.setEnrollmentList(enrollments);
            }

            if ("GRADE".equals(intent)) {
                ArrayList<StudentVo> gradeList = classroomService.serviceGradeSearch(studentId);
                context.setGradeList(gradeList);
            }

            if ("NOTICE".equals(intent)) {
                Map<String, List> dataMap = classroomService.getAssignmentsAndNotices(studentId);
                List noticeRaw = dataMap.get("notices");

                ArrayList<BoardVo> noticeList = new ArrayList<BoardVo>();

                if (noticeRaw != null) {
                    for (Object obj : noticeRaw) {
                        if (obj instanceof BoardVo) {
                            noticeList.add((BoardVo) obj);
                        }
                    }
                }

                context.setNoticeList(noticeList);
            }
        }
    }

    private String buildSystemPrompt(ChatbotContextVo context) {
        StringBuilder sb = new StringBuilder();

        sb.append("당신은 ColManager 학사 지원 프로그램의 AI 도우미입니다.\n");
        sb.append("답변은 반드시 한국어로, 친절하고 정확하고 이해하기 쉽게 작성하세요.\n");
        sb.append("모르는 정보는 추측하지 말고 확인이 필요하다고 답하세요.\n");
        sb.append("질문이 시스템 메뉴 사용법이면 메뉴 경로나 다음 행동을 함께 안내하세요.\n");
        sb.append("로그인 사용자 정보가 있으면 그 정보에 맞춰 개인화해서 답변하세요.\n");
        sb.append("DB에서 조회된 정보가 있으면 그것을 최우선 근거로 사용하세요.\n\n");

        sb.append("[질문 의도]\n");
        sb.append(nvl(context.getIntent())).append("\n\n");

        sb.append("[사용자 권한]\n");
        sb.append(nvl(context.getRole())).append("\n\n");

        if (context.getStudent() != null) {
            StudentVo student = context.getStudent();

            sb.append("[로그인 사용자 정보]\n");
            sb.append("이름: ").append(nvl(student.getUser_name())).append("\n");
            sb.append("아이디: ").append(nvl(student.getUser_id())).append("\n");
            sb.append("학번: ").append(nvl(student.getStudent_id())).append("\n");
            sb.append("전공코드: ").append(nvl(student.getMajorcode())).append("\n");
            sb.append("학년: ").append(student.getGrade()).append("\n");
            sb.append("상태: ").append(nvl(student.getStatus())).append("\n\n");
        }

        if (context.getEnrollmentList() != null && !context.getEnrollmentList().isEmpty()) {
            sb.append("[현재 수강 중인 강의]\n");
            for (EnrollmentVo enrollment : context.getEnrollmentList()) {
                if (enrollment != null && enrollment.getCourse() != null) {
                    sb.append("- ")
                      .append(nvl(enrollment.getCourse().getCourse_name()))
                      .append(" (")
                      .append(nvl(enrollment.getCourse().getCourse_id()))
                      .append(")\n");
                }
            }
            sb.append("\n");
        }

        if (context.getGradeList() != null && !context.getGradeList().isEmpty()) {
            sb.append("[성적 정보]\n");
            for (StudentVo gradeVo : context.getGradeList()) {
                sb.append("- 과목명: ");
                if (gradeVo.getCourse() != null) {
                    sb.append(nvl(gradeVo.getCourse().getCourse_name()));
                }
                sb.append(", 총점: ").append(gradeVo.getScore());
                sb.append(", 중간: ").append(gradeVo.getMidtest_score());
                sb.append(", 기말: ").append(gradeVo.getFinaltest_score());
                sb.append(", 과제: ").append(gradeVo.getAssignment_score());
                sb.append("\n");
            }
            sb.append("\n");
        }

        if (context.getNoticeList() != null && !context.getNoticeList().isEmpty()) {
            sb.append("[최근 공지사항]\n");
            for (BoardVo board : context.getNoticeList()) {
                sb.append("- ");
                if (board.getCourse() != null) {
                    sb.append("[")
                      .append(nvl(board.getCourse().getCourse_name()))
                      .append("] ");
                }
                sb.append(nvl(board.getTitle())).append("\n");
            }
            sb.append("\n");
        }

        sb.append("[응답 규칙]\n");
        sb.append("1. 로그인하지 않았는데 개인 정보가 필요한 질문이면 로그인 후 이용 가능하다고 안내하세요.\n");
        sb.append("2. 학생 정보가 조회되면 그 학생 기준으로 답하세요.\n");
        sb.append("3. 공지사항 질문이면 최근 공지 제목을 우선 알려주세요.\n");
        sb.append("4. 시간표/수강 질문이면 현재 수강 강의를 기준으로 답하세요.\n");
        sb.append("5. 성적 질문이면 조회된 성적 정보를 바탕으로 설명하세요.\n");
        sb.append("6. 불필요하게 길지 않게 답변하세요.\n");

        return sb.toString();
    }

    private String nvl(String str) {
        return str == null ? "" : str;
    }
}