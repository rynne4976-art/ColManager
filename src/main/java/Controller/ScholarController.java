package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Service.ScholarService;
import Vo.ScholarSearchVo;

@WebServlet("/scholar/*") 
public class ScholarController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ScholarService scholarService = new ScholarService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        try {
            if (uri.endsWith("/main.do")) {
                request.setAttribute("center", "common/scholarSearch.jsp");
                request.getRequestDispatcher("/main.jsp").forward(request, response);

            } else if (uri.endsWith("/searchAjax.do")) {
                ScholarSearchVo searchVo = buildSearchVo(request);

                if (searchVo.getQ() == null || searchVo.getQ().trim().isEmpty()) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"error\":\"검색어가 필요합니다.\"}");
                    return;
                }

                String jsonResponse = scholarService.buildJsonResponse(searchVo);

                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write(jsonResponse);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"검색 중 오류가 발생했습니다.\"}");
        }
    }

    private ScholarSearchVo buildSearchVo(HttpServletRequest request) {
        ScholarSearchVo vo = new ScholarSearchVo();

        vo.setQ(request.getParameter("q"));
        vo.setAuthor(request.getParameter("author"));
        vo.setYear(request.getParameter("year"));
        vo.setSite(request.getParameter("site"));
        vo.setSort(request.getParameter("sort"));

        int start = 0;

        try {
            String startStr = request.getParameter("start");
            if (startStr != null && !startStr.trim().isEmpty()) {
                start = Integer.parseInt(startStr);
            }
        } catch (Exception e) {
            start = 0;
        }

        vo.setStart(Math.max(start, 0));
        vo.setSize(10);
        vo.setPage((vo.getStart() / vo.getSize()) + 1);

        return vo;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}