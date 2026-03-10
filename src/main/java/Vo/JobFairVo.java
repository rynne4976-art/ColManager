package Vo;

public class JobFairVo {
    private int fairNo;
    private String companyName;
    private String eventTitle;
    private String eventDate;
    private String location;
    private String address;
    private String description;
    private String homepageUrl;
    private String recruitUrl;
    private String mapUrl;
    private String boothInfo;

    public JobFairVo() {
    }

    public JobFairVo(int fairNo, String companyName, String eventTitle, String eventDate,
                     String location, String address, String description,
                     String homepageUrl, String recruitUrl, String mapUrl, String boothInfo) {
        this.fairNo = fairNo;
        this.companyName = companyName;
        this.eventTitle = eventTitle;
        this.eventDate = eventDate;
        this.location = location;
        this.address = address;
        this.description = description;
        this.homepageUrl = homepageUrl;
        this.recruitUrl = recruitUrl;
        this.mapUrl = mapUrl;
        this.boothInfo = boothInfo;
    }

    public int getFairNo() {
        return fairNo;
    }

    public void setFairNo(int fairNo) {
        this.fairNo = fairNo;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getEventTitle() {
        return eventTitle;
    }

    public void setEventTitle(String eventTitle) {
        this.eventTitle = eventTitle;
    }

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHomepageUrl() {
        return homepageUrl;
    }

    public void setHomepageUrl(String homepageUrl) {
        this.homepageUrl = homepageUrl;
    }

    public String getRecruitUrl() {
        return recruitUrl;
    }

    public void setRecruitUrl(String recruitUrl) {
        this.recruitUrl = recruitUrl;
    }

    public String getMapUrl() {
        return mapUrl;
    }

    public void setMapUrl(String mapUrl) {
        this.mapUrl = mapUrl;
    }

    public String getBoothInfo() {
        return boothInfo;
    }

    public void setBoothInfo(String boothInfo) {
        this.boothInfo = boothInfo;
    }
}