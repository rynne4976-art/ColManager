package Controller;

import Service.BusService;
import com.google.gson.Gson;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/bus")
public class BusController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BusService service = new BusService();

        List<Map<String,String>> schedule = service.getSchedule();

        List<String> buildings = new ArrayList<>();

        try{

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/colbus",
            "root",
            "0000");

            String sql = "SELECT name FROM building";

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                buildings.add(rs.getString("name"));
            }

            rs.close();
            ps.close();
            conn.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        Map<String,Object> result = new HashMap<>();

        result.put("schedule", schedule);
        result.put("buildings", buildings);

        response.setContentType("application/json;charset=UTF-8");

        String json = new Gson().toJson(result);

        response.getWriter().print(json);
    }
}