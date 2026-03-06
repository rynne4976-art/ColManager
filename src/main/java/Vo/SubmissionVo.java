package Vo;

import java.sql.Timestamp;

public class SubmissionVo {
    private int submissionId;        // 제출 ID
    private AssignmentVo assignment; // 과제 객체
    private StudentVo student;       // 학생 객체
    private Timestamp submittedDate; // 제출 날짜
    private String feedback;         // 피드백
    private int grade;               // 점수
    
    private int fileId;
	private String fileName;
    private String originalName;
    

    // 기본 생성자
    public SubmissionVo() {}

    // 매개변수 생성자
    public SubmissionVo(int submissionId, AssignmentVo assignment, StudentVo student, Timestamp submittedDate, String feedback, int grade) {
        this.submissionId = submissionId;
        this.assignment = assignment;
        this.student = student;
        this.submittedDate = submittedDate;
        this.feedback = feedback;
        this.grade = grade;
    }

    // Getter & Setter
    public int getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public AssignmentVo getAssignment() {
        return assignment;
    }

    public void setAssignment(AssignmentVo assignment) {
        this.assignment = assignment;
    }

    public StudentVo getStudent() {
        return student;
    }

    public void setStudent(StudentVo student) {
        this.student = student;
    }

    public Timestamp getSubmittedDate() {
        return submittedDate;
    }

    public void setSubmittedDate(Timestamp submittedDate) {
        this.submittedDate = submittedDate;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }
    
    public int getFileId() {
		return fileId;
	}

	public void setFileId(int fileId) {
		this.fileId = fileId;
	}
    
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

}
