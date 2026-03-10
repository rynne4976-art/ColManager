package Vo;

public class JobPostingVo {
    private int postingNo;
    private int fairNo;
    private String companyName;
    private String title;
    private String jobType;
    private String deadline;
    private String postingUrl;

    public JobPostingVo() {
    }

    public JobPostingVo(int postingNo, int fairNo, String companyName, String title,
                        String jobType, String deadline, String postingUrl) {
        this.postingNo = postingNo;
        this.fairNo = fairNo;
        this.companyName = companyName;
        this.title = title;
        this.jobType = jobType;
        this.deadline = deadline;
        this.postingUrl = postingUrl;
    }

    public int getPostingNo() {
        return postingNo;
    }

    public void setPostingNo(int postingNo) {
        this.postingNo = postingNo;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getDeadline() {
        return deadline;
    }

    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

    public String getPostingUrl() {
        return postingUrl;
    }

    public void setPostingUrl(String postingUrl) {
        this.postingUrl = postingUrl;
    }
}