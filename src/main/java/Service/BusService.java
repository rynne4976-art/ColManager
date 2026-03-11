package Service;

import java.sql.*;
import java.util.*;

public class BusService {

    public List<Map<String,String>> getSchedule(){

        List<Map<String,String>> list = new ArrayList<>();

        try{

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn =
            DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/colbus",
            "root",
            "0000");

            String sql =
            "SELECT start_building, end_building, bus_number, travel_time FROM route ORDER BY travel_time";

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                Map<String,String> map = new HashMap<>();

                map.put("start", rs.getString("start_building"));
                map.put("end", rs.getString("end_building"));
                map.put("route", rs.getString("bus_number"));
                map.put("time", rs.getString("travel_time").substring(0,5));

                list.add(map);

            }

            rs.close();
            ps.close();
            conn.close();

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}