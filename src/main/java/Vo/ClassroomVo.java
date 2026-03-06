package Vo;

public class ClassroomVo {
	
	private String room_id, equipment;
	private int capacity;
	
	public ClassroomVo() { }// 기본 생성자

	public ClassroomVo(String room_id, int capacity, String equipment) {
		super();
		this.room_id = room_id;
		this.equipment = equipment;
		this.capacity = capacity;
	}

	public String getRoom_id() {
		return room_id;
	}

	public void setRoom_id(String room_id) {
		this.room_id = room_id;
	}

	public String getEquipment() {
		return equipment;
	}

	public void setEquipment(String equipment) {
		this.equipment = equipment;
	}

	public int getCapacity() {
		return capacity;
	}

	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	
	
	
	
}
