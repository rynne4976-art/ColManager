package Service;

import java.util.List;

import Dao.ProfessorDAO;
import Vo.ProfessorVo;

public class ProfessorService {

	ProfessorDAO professorDao;

	public ProfessorService() {
		professorDao = new ProfessorDAO();
	}

	// 교수등록
	public int serviceInsertProsess(ProfessorVo vo) {

		return professorDao.insertProfessor(vo);
	}

	// 전체 교수 조회 서비스
	public List<ProfessorVo> getProfessors(String prof_id, String majorCode) {

		// 교수 조회 처리 Dao시킴
		return professorDao.getProfessorList(prof_id, majorCode);
	}

	// 교수 정보 수정
	public boolean updateProfessor(ProfessorVo professor) {

		return professorDao.updateProfessor(professor);
	}

	// 교수 삭제
	public boolean deleteProfessor(String professorId) {

		// 삭제에 성공하면 "삭제성공" 반환 실패하면 "삭제실패" 반환
		return professorDao.deleteProfessor(professorId);

	}
	//============================================================
	// 교수가 강의 평가 조회
	public List<ProfessorVo> getEvaluationsByProfessorId(String loggedInProfessorId) {
		// DAO에서 강의 평가 리스트를 가져옴
        return professorDao.getEvaluationsByProfessorId(loggedInProfessorId);
	}
	
	
	
	
	
	
	
	//============================================================
	// 교수가 담당한 강의 목록 가져오기
	public List<ProfessorVo> getCoursesByProfessorId(String searchProfessorId) {
	    return professorDao.getCoursesByProfessorId(searchProfessorId);
	}

	// 선택된 강의의 평가 목록 가져오기
	public List<ProfessorVo> getEvaluationsByCourseId(String courseId) {
	    return professorDao.getEvaluationsByCourseId(courseId);
	}

}
