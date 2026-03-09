package Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class BusService {

    // 발급받은 서비스 키
    private static final String SERVICE_KEY =
            "발급받은_SERVICE_KEY";

    // API 기본 주소
    private static final String API_URL =
            "https://api.odcloud.kr/api/3079310/v1/uddi:4eccd3ef-d4ab-4706-bbb9-dad3edd62833_201905271750";


    // 1️⃣ API 호출
    private String callAPI() {

        StringBuilder result = new StringBuilder();

        try {

            String requestURL =
                    API_URL +
                    "?page=1" +
                    "&perPage=50" +
                    "&serviceKey=" + SERVICE_KEY;

            URL url = new URL(requestURL);

            HttpURLConnection conn =
                    (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("GET");

            BufferedReader rd;

            if (conn.getResponseCode() >= 200 &&
                    conn.getResponseCode() <= 300) {

                rd =
                        new BufferedReader(
                                new InputStreamReader(
                                        conn.getInputStream()));

            } else {

                rd =
                        new BufferedReader(
                                new InputStreamReader(
                                        conn.getErrorStream()));
            }

            String line;

            while ((line = rd.readLine()) != null) {

                result.append(line);
            }

            rd.close();
            conn.disconnect();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return result.toString();
    }


    // 2️⃣ JSON 파싱 → 버스 노선 리스트
    private List<String> parseRoutes() {

        List<String> routes = new ArrayList<>();

        try {

            String apiData = callAPI();

            JSONObject json = new JSONObject(apiData);

            JSONArray data = json.getJSONArray("data");

            for (int i = 0; i < data.length(); i++) {

                JSONObject bus = data.getJSONObject(i);

                String route =
                        bus.getString("노선번호");

                routes.add(route);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return routes;
    }


    // 3️⃣ 가상 시간표 생성
    private List<String[]> createSchedule(List<String> routes) {

        List<String[]> schedule = new ArrayList<>();

        LocalTime start = LocalTime.of(8, 0);

        for (String route : routes) {

            LocalTime time = start;

            for (int i = 0; i < 5; i++) {

                schedule.add(new String[]{
                        route,
                        time.toString()
                });

                time = time.plusMinutes(20);
            }
        }

        return schedule;
    }


    // 4️⃣ 추천 버스 계산
    public String[] recommendBus() {

        List<String> routes = parseRoutes();

        List<String[]> schedule = createSchedule(routes);

        LocalTime now = LocalTime.now();

        for (String[] bus : schedule) {

            LocalTime busTime =
                    LocalTime.parse(bus[1]);

            if (busTime.isAfter(now)) {

                long remain =
                        Duration.between(now, busTime)
                                .toMinutes();

                return new String[]{
                        bus[0],
                        bus[1],
                        String.valueOf(remain)
                };
            }
        }

        return new String[]{
                "없음",
                "없음",
                "0"
        };
    }
}
