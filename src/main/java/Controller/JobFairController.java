package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Service.JobFairService;

@WebServlet("/jobfair/*")
public class JobFairController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private JobFairService jobFairService = new JobFairService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        try {
            if (uri.endsWith("/main.do")) {
                request.setAttribute("center", "common/jobFair.jsp");
                request.getRequestDispatcher("/main.jsp").forward(request, response);

            } else if (uri.endsWith("/listAjax.do")) {
                String json = jobFairService.buildJobFairListJson();

                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(json);

            } else if (uri.endsWith("/postingAjax.do")) {
                int fairNo = 0;

                try {
                    String fairNoStr = request.getParameter("fairNo");
                    if (fairNoStr != null && !fairNoStr.trim().isEmpty()) {
                        fairNo = Integer.parseInt(fairNoStr);
                    }
                } catch (Exception e) {
                    fairNo = 0;
                }

                String json = jobFairService.buildJobPostingJson(fairNo);

                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(json);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"취업박람회 정보를 불러오는 중 오류가 발생했습니다.\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}