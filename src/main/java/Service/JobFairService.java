package Service;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import Dao.JobFairDAO;
import Vo.JobFairVo;
import Vo.JobPostingVo;

public class JobFairService {

    private JobFairDAO jobFairDAO = new JobFairDAO();

    public List<JobFairVo> getJobFairList() {
        return jobFairDAO.getJobFairList();
    }

    public JobFairVo getJobFairDetail(int fairNo) {
        return jobFairDAO.getJobFairDetail(fairNo);
    }

    public List<JobPostingVo> getJobPostingList(int fairNo) {
        return jobFairDAO.getJobPostingList(fairNo);
    }

    public String buildJobFairListJson() {
        List<JobFairVo> list = jobFairDAO.getJobFairList();

        JSONObject root = new JSONObject();
        JSONArray fairArray = new JSONArray();

        for (JobFairVo vo : list) {
            JSONObject item = new JSONObject();
            item.put("fairNo", vo.getFairNo());
            item.put("companyName", vo.getCompanyName());
            item.put("eventTitle", vo.getEventTitle());
            item.put("eventDate", vo.getEventDate());
            item.put("location", vo.getLocation());
            item.put("address", vo.getAddress());
            item.put("description", vo.getDescription());
            item.put("homepageUrl", vo.getHomepageUrl());
            item.put("recruitUrl", vo.getRecruitUrl());
            item.put("mapUrl", vo.getMapUrl());
            item.put("boothInfo", vo.getBoothInfo());

            fairArray.put(item);
        }

        root.put("job_fair_list", fairArray);
        root.put("count", list.size());

        return root.toString();
    }

    public String buildJobPostingJson(int fairNo) {
        List<JobPostingVo> list = jobFairDAO.getJobPostingList(fairNo);

        JSONObject root = new JSONObject();
        JSONArray postingArray = new JSONArray();

        for (JobPostingVo vo : list) {
            JSONObject item = new JSONObject();
            item.put("postingNo", vo.getPostingNo());
            item.put("fairNo", vo.getFairNo());
            item.put("companyName", vo.getCompanyName());
            item.put("title", vo.getTitle());
            item.put("jobType", vo.getJobType());
            item.put("deadline", vo.getDeadline());
            item.put("postingUrl", vo.getPostingUrl());

            postingArray.put(item);
        }

        root.put("job_posting_list", postingArray);
        root.put("count", list.size());

        return root.toString();
    }
}