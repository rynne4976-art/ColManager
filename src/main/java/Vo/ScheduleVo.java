package Vo;

import java.sql.Date;

public class ScheduleVo {
	private int schedule_id;
	private String event_name;
	private String description;
	private Date start_date;
	private Date end_date;

	public ScheduleVo() {
	}

	public ScheduleVo(int schedule_id, String event_name, String description, Date start_date, Date end_date) {
		super();
		this.schedule_id = schedule_id;
		this.event_name = event_name;
		this.description = description;
		this.start_date = start_date;
		this.end_date = end_date;
	}

	@Override
	public String toString() {
		return "ScheduleVo{" + "schedule_id=" + schedule_id + ", event_name='" + event_name + '\'' + ", description='"
				+ description + '\'' + ", start_date=" + start_date + ", end_date=" + end_date + '}';
	}

	public int getSchedule_id() {
		return schedule_id;
	}

	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}

	public String getEvent_name() {
		return event_name;
	}

	public void setEvent_name(String event_name) {
		this.event_name = event_name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getStart_date() {
		return start_date;
	}

	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}

	public Date getEnd_date() {
		return end_date;
	}

	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}
}
