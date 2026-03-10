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

        // 시간표 가져오기
        request.setAttribute("schedule", service.getSchedule());

        // 추천 버스 계산
        String[] bus = service.recommendBus();

        request.setAttribute("busTime", bus[0]);
        request.setAttribute("busRoute", bus[1]);
        request.setAttribute("remainTime", bus[2]);

        request.getRequestDispatcher("/view_start/startcenter.jsp")
                .forward(request, response);
    }
}