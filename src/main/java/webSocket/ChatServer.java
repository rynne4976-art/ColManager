package webSocket;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class ChatServer {

    private static final String API_URL = "https://openrouter.ai/api/v1/chat/completions";
    private static final String MODEL_NAME = "openrouter/free";

    private String buildSystemPrompt() {
        return ""
            + "당신은 대학교 학사 지원 프로그램의 AI 도우미입니다.\n"
            + "학생, 교수, 교직원이 이해하기 쉽게 답변하세요.\n"
            + "답변은 한국어로 친절하고 간결하게 작성하세요.\n"
            + "수강신청, 성적조회, 강의실, 학사일정, 공지사항, 로그인/회원가입 같은 주제를 우선 안내하세요.\n"
            + "모르는 내용은 추측하지 말고 확인이 필요하다고 답하세요.\n";
    }

    public String ask(String apiKey, String appUrl, String userMessage) throws Exception {
        return ask(apiKey, appUrl, buildSystemPrompt(), userMessage);
    }

    public String ask(String apiKey, String appUrl, String systemPrompt, String userMessage) throws Exception {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            return "AI API 키가 설정되지 않았습니다. config.properties를 확인해주세요.";
        }

        HttpURLConnection conn = null;

        try {
            URL url = new URL(API_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("HTTP-Referer", appUrl == null ? "" : appUrl);
            conn.setRequestProperty("X-Title", "ColManager AI Assistant");
            conn.setDoOutput(true);

            JSONObject body = new JSONObject();
            body.put("model", MODEL_NAME);

            JSONArray messages = new JSONArray();

            JSONObject systemMsg = new JSONObject();
            systemMsg.put("role", "system");
            systemMsg.put("content",
                    systemPrompt == null || systemPrompt.trim().isEmpty()
                            ? buildSystemPrompt()
                            : systemPrompt);
            messages.add(systemMsg);

            JSONObject userMsg = new JSONObject();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage == null ? "" : userMessage);
            messages.add(userMsg);

            body.put("messages", messages);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toJSONString().getBytes(StandardCharsets.UTF_8));
            }

            int code = conn.getResponseCode();
            InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
            String responseText = readAll(is);

            if (code < 200 || code >= 300) {
                return "AI 응답 요청 중 오류가 발생했습니다. (" + code + ")";
            }

            JSONParser parser = new JSONParser();
            JSONObject root = (JSONObject) parser.parse(responseText);
            JSONArray choices = (JSONArray) root.get("choices");

            if (choices == null || choices.isEmpty()) {
                return "AI 응답을 받지 못했습니다.";
            }

            JSONObject first = (JSONObject) choices.get(0);
            JSONObject message = (JSONObject) first.get("message");

            if (message == null) {
                return "AI 응답 형식이 올바르지 않습니다.";
            }

            Object content = message.get("content");
            return content == null ? "AI 응답이 비어 있습니다." : String.valueOf(content).trim();

        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String readAll(InputStream is) throws IOException {
        if (is == null) return "";

        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}