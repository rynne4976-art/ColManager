package Vo;

import java.sql.Timestamp;

public class PeriodVo {

	private int periodId;
	private String type; // 수강 신청 or 과제
	private int referenceId; // 참조 ID
	private Timestamp startDate;
	private Timestamp endDate;
	private String description;
	private Timestamp createdAt;

	@Override
	public String toString() {
	    return "PeriodVo {" +
	            "periodId=" + periodId +
	            ", type='" + type + '\'' +
	            ", referenceId=" + referenceId +
	            ", startDate=" + (startDate != null ? startDate.toString() : "null") +
	            ", endDate=" + (endDate != null ? endDate.toString() : "null") +
	            ", description='" + description + '\'' +
	            ", createdAt=" + (createdAt != null ? createdAt.toString() : "null") +
	            '}';
	}

	
	// Getters and Setters
	public int getPeriodId() {
		return periodId;
	}

	public void setPeriodId(int periodId) {
		this.periodId = periodId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getReferenceId() {
		return referenceId;
	}

	public void setReferenceId(int referenceId) {
		this.referenceId = referenceId;
	}

	public Timestamp getStartDate() {
		return startDate;
	}

	public void setStartDate(Timestamp startDate) {
		this.startDate = startDate;
	}

	public Timestamp getEndDate() {
		return endDate;
	}

	public void setEndDate(Timestamp endDate) {
		this.endDate = endDate;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	
}
