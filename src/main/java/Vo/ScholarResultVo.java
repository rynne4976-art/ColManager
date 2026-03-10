package Vo;

public class ScholarResultVo {
    private String title;
    private String link;
    private String authors;
    private String year;
    private String snippet;

    public ScholarResultVo() {
    }

    public ScholarResultVo(String title, String link, String authors, String year, String snippet) {
        this.title = title;
        this.link = link;
        this.authors = authors;
        this.year = year;
        this.snippet = snippet;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getAuthors() {
        return authors;
    }

    public void setAuthors(String authors) {
        this.authors = authors;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getSnippet() {
        return snippet;
    }

    public void setSnippet(String snippet) {
        this.snippet = snippet;
    }
}