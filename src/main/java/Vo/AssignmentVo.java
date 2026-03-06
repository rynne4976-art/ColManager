package Vo;

public class AssignmentVo {
    private int assignmentId;      // 과제 ID (기본 키)
    private CourseVo course;       // 강의 객체 (외래키 참조)
    private String title;          // 과제 제목
    private String description;    // 과제 설명
    private PeriodVo period;

    

	// 기본 생성자
    public AssignmentVo() {}
    @Override
    public String toString() {
        return "AssignmentVo {" +
                "assignmentId=" + assignmentId +
                ", course=" + (course != null ? course.toString() : "null") +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", period=" + (period != null ? period.toString() : "null") +
                '}';
    }

    
    // 매개변수 생성자
    public AssignmentVo(int assignmentId, CourseVo course, String title, String description) {
        this.assignmentId = assignmentId;
        this.course = course;
        this.title = title;
        this.description = description;
    }

    // Getter and Setter 메소드
    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public CourseVo getCourse() {
        return course;
    }

    public void setCourse(CourseVo course) {
        this.course = course;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public PeriodVo getPeriod() {
		return period;
	}

	public void setPeriod(PeriodVo period) {
		this.period = period;
	}
}
