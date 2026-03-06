package Service;

import Dao.SubmissionDAO;
import Vo.SubmissionVo;

public class SubmissionService {
	
	SubmissionDAO submissiondao;
	
	public SubmissionService() {
		submissiondao = new SubmissionDAO();
	}

	//----------
	// 학생이 제출한 과제와 해당 과제를 저장하기 위해 DAO 호출
	public int serviceSaveSubmissionWithFile(String assignmentId, String studentId, String filePath, String originalName) {
	    int submissionId = 0;

	    // 1. 과제 제출 정보 저장
	    submissionId = submissiondao.saveSubmission(assignmentId, studentId);
	    
	    if (submissionId > 0) {
	        // 2. 파일 정보 저장
	        int fileResult = submissiondao.saveFile(submissionId, filePath, originalName);

	        return fileResult;
	    }
	    
	    return 0; // 제출 ID 반환
	}
	//----------
	// 학생이 제출한 과제(파일)의 정보를 조회하기 위해 DAO 호출
	public SubmissionVo serviceGetSubmission(String studentId, String assignmentId) {
		return submissiondao.getSubmissions(studentId, assignmentId);
	}

	//----------
	// 학생이 제출한 파일의 id를 조회 하기 위해 DAO 호출
	public SubmissionVo getFileById(String fileId) {
		return submissiondao.getFileById(fileId);
	}

	//----------
	// 학생이 제출한 과제(파일)의 정보를 삭제하기 위해 DAO 호출
	public int deleteFile(String fileId, int submission_id) {
		return submissiondao.deleteFile(fileId, submission_id);
	}

	
	
	
	
}
