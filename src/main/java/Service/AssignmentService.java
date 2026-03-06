package Service;

import java.util.ArrayList;
import java.util.List;

import Dao.AssignmentDAO;
import Vo.AssignmentVo;
import Vo.PeriodVo;
import Vo.SubmissionVo;

public class AssignmentService {
	
	AssignmentDAO assignmentdao;
	
	public AssignmentService() {
		assignmentdao = new AssignmentDAO();
	}

	//----------
	// 교수의 각 강의에서 등록된 과제들을 조회하기 위해 DAO 호출
	public ArrayList<AssignmentVo> serviceAssignmentSearch(String course_id) {
		return assignmentdao.assignmentSearch(course_id);
	}

	//----------
	// 교수의 각 강의에 과제를 등록하기 위해 DAO 호출
	public int serviceCreateAssignment(AssignmentVo assignmentVo, PeriodVo periodVo) {
		return assignmentdao.createAssignmentWithPeriod(assignmentVo, periodVo);
	}

	//----------
	// 교수의 각 강의의 과제를 삭제하기 위해 DAO 호출
	public int serviceDeleteAssignment(String assignment_id) {
		return assignmentdao.deleteAssignment(assignment_id);
	}

	//----------
	// 교수의 각 강의의 과제를 수정하기 위해 DAO 호출
	public int serviceUpdateAssignment(AssignmentVo assignmentVo, PeriodVo periodVo) {
		return assignmentdao.updateAssignment(assignmentVo, periodVo);
	}

	//----------
	// 학생들이 제출한 과제를 조회하기 위해 DAO 호출
	public List<SubmissionVo> serviceGetSubmission(String assignmentId) {
		return assignmentdao.getSubmission(assignmentId);
	}

}
