package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import webSocket.ChatServer;

@WebServlet("/chatbot/*")
public class ChatBotController extends HttpServlet {

    private String apiKey;
    private String appUrl;
    private ChatServer chatServer;

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

            if (apiKey == null || apiKey.trim().isEmpty()) {
                throw new ServletException("API키가 설정되지 않았습니다.");
            }

        } catch (Exception e) {
            throw new ServletException("config.properties 로딩 실패", e);
        }

        chatServer = new ChatServer();
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
                if (message == null || message.trim().isEmpty()) {
                    json.put("status", "fail");
                    json.put("reply", "질문을 입력해주세요.");
                } else {
                    String reply = chatServer.ask(apiKey, appUrl, message);
                    json.put("status", "success");
                    json.put("reply", reply);
                }
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
