package Service;

import java.sql.*;
import java.util.*;

public class BusService {

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/colbus?serverTimezone=Asia/Seoul",
                "root",
                "0000"
        );
    }

    /* 버스 시간표 */
    public List<Map<String, String>> getSchedule() {

        List<Map<String, String>> list = new ArrayList<>();

        try {
            Connection conn = getConnection();

            String sql = "SELECT start_building, end_building, bus_number, travel_time FROM route ORDER BY travel_time";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String time = rs.getString("travel_time").substring(0, 5);

                String[] t = time.split(":");
                int h = Integer.parseInt(t[0]);
                int m = Integer.parseInt(t[1]);

                // 이동시간 10분 추가
                m += 10;
                if (m >= 60) {
                    h++;
                    m -= 60;
                }

                String arrive = String.format("%02d:%02d", h, m);

                Map<String, String> map = new HashMap<>();
                map.put("route", rs.getString("bus_number"));
                map.put("time", time);
                map.put("start", rs.getString("start_building"));
                map.put("end", rs.getString("end_building"));
                map.put("arrive", arrive);

                list.add(map);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* 건물 목록 */
    public List<String> getBuildings() {

        List<String> list = new ArrayList<>();

        try {
            Connection conn = getConnection();

            String sql = "SELECT name FROM building";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("name"));
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}