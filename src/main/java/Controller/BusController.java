package Controller;

import Service.BusService;
import com.google.gson.Gson;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/bus")
public class BusController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BusService service = new BusService();

        // 버스 시간표
        List<Map<String, String>> schedule = service.getSchedule();

        // 건물 목록
        List<String> buildings = service.getBuildings();

        Map<String, Object> result = new HashMap<>();
        result.put("schedule", schedule);
        result.put("buildings", buildings);

        response.setContentType("application/json;charset=UTF-8");

        Gson gson = new Gson();
        String json = gson.toJson(result);

        response.getWriter().print(json);
    }
}