package Service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONArray;
import org.json.JSONObject;

import Dao.ScholarDAO;
import Vo.ScholarResultVo;
import Vo.ScholarSearchVo;

public class ScholarService {

    private ScholarDAO scholarDAO = new ScholarDAO();

    public List<ScholarResultVo> searchScholar(ScholarSearchVo searchVo) throws Exception {
        String rawJson = scholarDAO.searchScholarRaw(searchVo);
        return parseScholarResults(rawJson);
    }

    public int getTotalResults(ScholarSearchVo searchVo) throws Exception {
        String rawJson = scholarDAO.searchScholarRaw(searchVo);
        JSONObject json = new JSONObject(rawJson);

        if (json.has("search_information")) {
            JSONObject info = json.getJSONObject("search_information");
            return info.optInt("total_results", 0);
        }

        return 0;
    }

    public String buildJsonResponse(ScholarSearchVo searchVo) throws Exception {
        String rawJson = scholarDAO.searchScholarRaw(searchVo);

        JSONObject root = new JSONObject(rawJson);
        JSONObject resultJson = new JSONObject();

        JSONArray organicResults = root.optJSONArray("organic_results");
        JSONArray resultArray = new JSONArray();

        if (organicResults != null) {
            for (int i = 0; i < organicResults.length(); i++) {
                JSONObject item = organicResults.getJSONObject(i);

                JSONObject resultItem = new JSONObject();
                resultItem.put("title", item.optString("title", ""));
                resultItem.put("link", item.optString("link", ""));
                resultItem.put("snippet", item.optString("snippet", ""));

                String pdfLink = "";
                String pdfSource = "";

                JSONArray resources = item.optJSONArray("resources");
                if (resources != null && resources.length() > 0) {
                    for (int r = 0; r < resources.length(); r++) {
                        JSONObject resource = resources.optJSONObject(r);
                        if (resource == null) continue;

                        String fileFormat = resource.optString("file_format", "");
                        String link = resource.optString("link", "");
                        String source = resource.optString("title", "");

                        if ("PDF".equalsIgnoreCase(fileFormat) && link != null && !link.isEmpty()) {
                            pdfLink = link;
                            pdfSource = source;
                            break;
                        }
                    }
                }
                
                resultItem.put("pdf_link", pdfLink);
                resultItem.put("pdf_source", pdfSource);
                
                
                int citedBy = 0;
                String citedLink = "";
                String relatedLink = "";

                JSONObject inlineLinks = item.optJSONObject("inline_links");

                if (inlineLinks != null) {
                    JSONObject cited = inlineLinks.optJSONObject("cited_by");
                    if (cited != null) {
                        citedBy = cited.optInt("total", 0);
                        citedLink = cited.optString("link", "");
                    }

                    JSONObject related = inlineLinks.optJSONObject("related_pages");
                    if (related != null) {
                        relatedLink = related.optString("link", "");
                    }
                }

                resultItem.put("cited_by", citedBy);
                resultItem.put("cited_link", citedLink);
                resultItem.put("related_link", relatedLink);
                
                
                String authors = "";
                String year = "";

                JSONObject publicationInfo = item.optJSONObject("publication_info");
                if (publicationInfo != null) {
                    JSONArray authorArray = publicationInfo.optJSONArray("authors");
                    if (authorArray != null) {
                        StringBuilder authorBuilder = new StringBuilder();
                        for (int j = 0; j < authorArray.length(); j++) {
                            JSONObject authorObj = authorArray.getJSONObject(j);
                            if (authorBuilder.length() > 0) {
                                authorBuilder.append(", ");
                            }
                            authorBuilder.append(authorObj.optString("name", ""));
                        }
                        authors = authorBuilder.toString();
                    }

                    String summary = publicationInfo.optString("summary", "");
                    year = extractYear(summary);
                }

                JSONObject publicationJson = new JSONObject();
                publicationJson.put("authors", authors);
                publicationJson.put("year", year);

                resultItem.put("publication_info", publicationJson);
                resultArray.put(resultItem);
            }
        }

        resultJson.put("organic_results", resultArray);

        JSONObject searchInfo = new JSONObject();
        searchInfo.put("total_results", extractTotalResults(root));
        resultJson.put("search_information", searchInfo);

        return resultJson.toString();
    }

    private List<ScholarResultVo> parseScholarResults(String rawJson) {
        List<ScholarResultVo> list = new ArrayList<>();

        JSONObject json = new JSONObject(rawJson);
        JSONArray results = json.optJSONArray("organic_results");

        if (results == null) {
            return list;
        }

        for (int i = 0; i < results.length(); i++) {
            JSONObject item = results.getJSONObject(i);

            String title = item.optString("title", "");
            String link = item.optString("link", "");
            String snippet = item.optString("snippet", "");

            String authors = "";
            String year = "";

            JSONObject publicationInfo = item.optJSONObject("publication_info");
            if (publicationInfo != null) {
                JSONArray authorArray = publicationInfo.optJSONArray("authors");
                if (authorArray != null) {
                    StringBuilder authorBuilder = new StringBuilder();
                    for (int j = 0; j < authorArray.length(); j++) {
                        JSONObject authorObj = authorArray.getJSONObject(j);
                        if (authorBuilder.length() > 0) {
                            authorBuilder.append(", ");
                        }
                        authorBuilder.append(authorObj.optString("name", ""));
                    }
                    authors = authorBuilder.toString();
                }

                String summary = publicationInfo.optString("summary", "");
                year = extractYear(summary);
            }

            ScholarResultVo vo = new ScholarResultVo(title, link, authors, year, snippet);
            list.add(vo);
        }

        return list;
    }

    private int extractTotalResults(JSONObject root) {
        JSONObject info = root.optJSONObject("search_information");
        if (info == null) {
            return 0;
        }
        return info.optInt("total_results", 0);
    }

    private String extractYear(String text) {
        if (text == null) {
            return "";
        }

        Pattern pattern = Pattern.compile("\\b\\d{4}\\b");
        Matcher matcher = pattern.matcher(text);

        if (matcher.find()) {
            return matcher.group();
        }

        return "";
    }
}