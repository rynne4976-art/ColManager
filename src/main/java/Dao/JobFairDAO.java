package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import Vo.JobFairVo;
import Vo.JobPostingVo;

public class JobFairDAO {

    Connection con;
    PreparedStatement pstmt;
    ResultSet rs;
    DataSource ds;

    public JobFairDAO() {
        try {
            Context ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:/comp/env/jdbc/edumanager");
        } catch (Exception e) {
            System.out.println("JobFairDAO 커넥션풀 얻기 실패 : " + e.toString());
        }
    }

    private void closeResource() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<JobFairVo> getJobFairList() {

        List<JobFairVo> list = new ArrayList<JobFairVo>();

        String sql =
            "SELECT fair_no, company_name, event_title, event_date, location, address, " +
            "description, homepage_url, recruit_url, map_url, booth_info " +
            "FROM job_fair ORDER BY fair_no ASC";

        try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

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
            System.out.println("JobFairDAO의 getJobFairList 메소드에서 오류");
            e.printStackTrace();
        } finally {
            closeResource();
        }

        return list;
    }

    public List<JobPostingVo> getJobPostingList(int fairNo) {

        List<JobPostingVo> list = new ArrayList<JobPostingVo>();

        String sql =
            "SELECT posting_no, fair_no, company_name, title, job_type, deadline, posting_url " +
            "FROM job_posting WHERE fair_no = ? ORDER BY posting_no ASC";

        try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, fairNo);
            rs = pstmt.executeQuery();

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

        } catch (Exception e) {
            System.out.println("JobFairDAO의 getJobPostingList 메소드에서 오류");
            e.printStackTrace();
        } finally {
            closeResource();
        }

        return list;
    }

    public JobFairVo getJobFairDetail(int fairNo) {

        JobFairVo vo = null;

        String sql =
            "SELECT fair_no, company_name, event_title, event_date, location, address, " +
            "description, homepage_url, recruit_url, map_url, booth_info " +
            "FROM job_fair WHERE fair_no = ?";

        try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, fairNo);
            rs = pstmt.executeQuery();

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

        } catch (Exception e) {
            System.out.println("JobFairDAO의 getJobFairDetail 메소드에서 오류");
            e.printStackTrace();
        } finally {
            closeResource();
        }

        return vo;
    }
}