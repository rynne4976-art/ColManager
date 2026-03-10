package Dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import Vo.ScholarSearchVo;

public class ScholarDAO {

    private static final String API_KEY = "8ac0c79aa4eeacf587de573966a49bcc0e98e20203b0f2fef70ce012db6924bd";
    private static final String BASE_URL = "https://serpapi.com/search?engine=google_scholar";

    public String searchScholarRaw(ScholarSearchVo searchVo) throws Exception {
        String query = buildQuery(searchVo);

        StringBuilder apiUrl = new StringBuilder();
        apiUrl.append(BASE_URL);
        apiUrl.append("&api_key=").append(API_KEY);
        apiUrl.append("&q=").append(URLEncoder.encode(query, "UTF-8"));
        apiUrl.append("&num=").append(searchVo.getSize());
        apiUrl.append("&start=").append(searchVo.getStart());
        apiUrl.append("&hl=en");

        if ("date".equals(searchVo.getSort())) {
            apiUrl.append("&sort=date");
        }

        HttpURLConnection conn = null;
        BufferedReader br = null;
        StringBuilder result = new StringBuilder();

        try {
            URL url = new URL(apiUrl.toString());
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }
        } finally {
            if (br != null) br.close();
            if (conn != null) conn.disconnect();
        }

        return result.toString();
    }

    private String buildQuery(ScholarSearchVo vo) {
        StringBuilder qBuilder = new StringBuilder();

        if (vo.getQ() != null && !vo.getQ().trim().isEmpty()) {
            qBuilder.append(vo.getQ().trim());
        }

        if (vo.getAuthor() != null && !vo.getAuthor().trim().isEmpty()) {
            qBuilder.append(" author:\"").append(vo.getAuthor().trim()).append("\"");
        }

        if (vo.getYear() != null && !vo.getYear().trim().isEmpty()) {
            try {
                int y = Integer.parseInt(vo.getYear().trim());
                qBuilder.append(" after:").append(y);
                qBuilder.append(" before:").append(y + 1);
            } catch (NumberFormatException e) {
                // 연도 형식 아니면 무시
            }
        }

        if (vo.getSite() != null && !vo.getSite().trim().isEmpty()) {
            qBuilder.append(" site:").append(vo.getSite().trim());
        }

        return qBuilder.toString();
    }
}