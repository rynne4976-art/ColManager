package Controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import Service.ChatbotService;

@WebServlet("/chatbot/*")
public class ChatBotController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String apiKey;
    private String appUrl;
    private ChatbotService chatbotService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        try {
            Properties prop = new Properties();
            InputStream is = getClass().getClassLoader().getResourceAsStream("config.properties");

            if (is != null) {
                prop.load(is);
            }

            apiKey = prop.getProperty("openrouter.apiKey");
            appUrl = prop.getProperty("app.url");

            if (appUrl == null || appUrl.trim().isEmpty()) {
                appUrl = "http://localhost:8090/ColManager";
            }

            chatbotService = new ChatbotService(apiKey, appUrl);

        } catch (Exception e) {
            throw new ServletException("config.properties 로딩 실패", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHandle(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHandle(request, response);
    }

    protected void doHandle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();

        if (action == null || "/page.do".equals(action)) {
            request.setAttribute("center", "/common/AIService.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/main.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if ("/send.do".equals(action)) {
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            JSONObject json = new JSONObject();

            try {
                String message = request.getParameter("message");

                HttpSession session = request.getSession(false);
                String loginId = null;
                String role = null;
                String studentId = null;

                if (session != null) {
                    loginId = (String) session.getAttribute("id");
                    role = (String) session.getAttribute("role");
                    studentId = (String) session.getAttribute("student_id");
                }

                String reply = chatbotService.getReply(message, loginId, role, studentId);

                json.put("status", "success");
                json.put("reply", reply);

            } catch (Exception e) {
                e.printStackTrace();
                json.put("status", "fail");
                json.put("reply", "AI 응답 처리 중 오류가 발생했습니다.");
            }

            out.print(json.toJSONString());
            out.flush();
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
}