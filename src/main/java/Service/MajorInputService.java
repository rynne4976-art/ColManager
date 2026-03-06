package Service;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;

import Dao.MajorInputDAO;
import Vo.MajorVo;

public class MajorInputService {
	private static final int SUCCESS = 1;
	private static final int FAILURE = 0;
	private static final int NONE = -1;
	private static final int EXISTS = -2;
	// 1 = 성공, 0 =실패, -1 = 없음, -2 = 있음

	MajorInputDAO majorInputDAO;

	public MajorInputService() {
		majorInputDAO = new MajorInputDAO();
	}

	public int majorInput(HttpServletRequest request) {
		String newMajorName = request.getParameter("MajorNameInput");
		String newMajorTel = request.getParameter("MajorTelInput");

		if (newMajorName == null || newMajorName.trim().isEmpty()) {
			return NONE;
		}
		if (newMajorTel == null || newMajorTel.trim().isEmpty()) {
			return NONE;
		}

		// 같은 이름이 있을 경우
		if (majorInputDAO.majorInputValidation(newMajorName) == EXISTS) {
			return EXISTS;
		}
		return majorInputDAO.majorInput(newMajorName, newMajorTel);
	}

	public ArrayList<MajorVo> searchMajor(HttpServletRequest request) {
		return majorInputDAO.searchMajor(request);
	}

	public int editMajorService(HttpServletRequest request) {
		String editMajorCode = request.getParameter("majorCode");
		String editMajorName = request.getParameter("majorName");
		String editMajorTel = request.getParameter("majorTel");
		System.out.println("editMajorService" + editMajorCode);
		System.out.println("editMajorService" + editMajorName);
		System.out.println("editMajorService" + editMajorTel);
		// 데이터 유효성 검사
		// 값이 비었을 경우 deleteMajor를 실행
		// editMajorName이 null 또는 공백인지 먼저 검사
		if (editMajorName == null || editMajorName.trim().isEmpty()) {
			return majorInputDAO.deleteMajor(editMajorCode);
		}

		// majorCode가 존재하는지 여부를 미리 저장하여 사용
		int isCodeExists = majorInputDAO.majorSearchValidationCode(editMajorCode);
		int isNameExists = majorInputDAO.majorSearchValidationName(editMajorName);
		int isTelExists = majorInputDAO.majorSearchValidationTel(editMajorTel);

		if (isCodeExists == EXISTS && isNameExists != EXISTS) {
		    // 코드가 존재하고 이름이 존재하지 않음 (중복 아님), 전체 수정 작업 진행
		    return majorInputDAO.editMajor(editMajorCode, editMajorName, editMajorTel);
		} else if (isCodeExists == EXISTS && isNameExists == EXISTS && isTelExists != EXISTS) {
		    // 코드와 이름이 존재하지만 (중복), 전화번호만 바꼈을 때 전체 수정 작업 진행
			return majorInputDAO.editMajorTel(editMajorCode, editMajorTel);
		} else {
		    // 코드가 존재하지 않거나 기타 실패
		    return FAILURE;
		}
	}

	public JSONArray fetchMajorService() throws SQLException {
		return majorInputDAO.fetchMajor();
	}
}
