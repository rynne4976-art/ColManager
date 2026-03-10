package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Vo.JobFairVo;
import Vo.JobPostingVo;

public class JobFairDAO {

	private Connection getConnection() throws Exception {

	    javax.naming.Context initContext = new javax.naming.InitialContext();
	    javax.naming.Context envContext = (javax.naming.Context) initContext.lookup("java:/comp/env");

	    javax.sql.DataSource ds = (javax.sql.DataSource) envContext.lookup("jdbc/edumanager");

	    return ds.getConnection();
	}

    public JobFairDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<JobFairVo> getJobFairList() {
        List<JobFairVo> list = new ArrayList<JobFairVo>();

        String sql = "SELECT fair_no, company_name, event_title, event_date, location, address, " +
                     "description, homepage_url, recruit_url, map_url, booth_info " +
                     "FROM job_fair ORDER BY fair_no ASC";

        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                JobFairVo vo = new JobFairVo();
                vo.setFairNo(rs.getInt("fair_no"));
                vo.setCompanyName(rs.getString("company_name"));
                vo.setEventTitle(rs.getString("event_title"));
                vo.setEventDate(rs.getString("event_date"));
                vo.setLocation(rs.getString("location"));
                vo.setAddress(rs.getString("address"));
                vo.setDescription(rs.getString("description"));
                vo.setHomepageUrl(rs.getString("homepage_url"));
                vo.setRecruitUrl(rs.getString("recruit_url"));
                vo.setMapUrl(rs.getString("map_url"));
                vo.setBoothInfo(rs.getString("booth_info"));

                list.add(vo);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<JobPostingVo> getJobPostingList(int fairNo) {
        List<JobPostingVo> list = new ArrayList<JobPostingVo>();

        String sql = "SELECT posting_no, fair_no, company_name, title, job_type, deadline, posting_url " +
                     "FROM job_posting WHERE fair_no = ? ORDER BY posting_no ASC";

        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, fairNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    JobPostingVo vo = new JobPostingVo();
                    vo.setPostingNo(rs.getInt("posting_no"));
                    vo.setFairNo(rs.getInt("fair_no"));
                    vo.setCompanyName(rs.getString("company_name"));
                    vo.setTitle(rs.getString("title"));
                    vo.setJobType(rs.getString("job_type"));
                    vo.setDeadline(rs.getString("deadline"));
                    vo.setPostingUrl(rs.getString("posting_url"));

                    list.add(vo);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public JobFairVo getJobFairDetail(int fairNo) {
        JobFairVo vo = null;

        String sql = "SELECT fair_no, company_name, event_title, event_date, location, address, " +
                     "description, homepage_url, recruit_url, map_url, booth_info " +
                     "FROM job_fair WHERE fair_no = ?";

        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, fairNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    vo = new JobFairVo();
                    vo.setFairNo(rs.getInt("fair_no"));
                    vo.setCompanyName(rs.getString("company_name"));
                    vo.setEventTitle(rs.getString("event_title"));
                    vo.setEventDate(rs.getString("event_date"));
                    vo.setLocation(rs.getString("location"));
                    vo.setAddress(rs.getString("address"));
                    vo.setDescription(rs.getString("description"));
                    vo.setHomepageUrl(rs.getString("homepage_url"));
                    vo.setRecruitUrl(rs.getString("recruit_url"));
                    vo.setMapUrl(rs.getString("map_url"));
                    vo.setBoothInfo(rs.getString("booth_info"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vo;
    }
}