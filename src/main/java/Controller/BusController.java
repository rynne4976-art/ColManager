package Controller;

import Service.BusService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/bus")
public class BusController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BusService service = new BusService();

        // 추천 버스 계산
        String[] busInfo = service.recommendBus();

        request.setAttribute("busRoute", busInfo[0]);
        request.setAttribute("busTime", busInfo[1]);
        request.setAttribute("remainTime", busInfo[2]);

        request.getRequestDispatcher("/view_start/startcenter.jsp")
                .forward(request, response);
    }
}