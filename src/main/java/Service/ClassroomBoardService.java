package Service;

import java.util.ArrayList;

import Dao.ClassroomBoardDAO;
import Dao.MemberDAO;
import Vo.ClassroomBoardVo;
import Vo.MemberVo;

public class ClassroomBoardService {
	
	ClassroomBoardDAO classroomBoarddao;
	MemberDAO memberdao;
	
	public ClassroomBoardService() {
		classroomBoarddao = new ClassroomBoardDAO();
		memberdao = new MemberDAO();
	}
	

	//공지사항 전체 목록 조회
	public ArrayList<ClassroomBoardVo> serviceNoticeList(String course_id, String user_name) {
		return classroomBoarddao.noticeList(course_id, user_name);
	}

	//글 한개 조회 
	public ClassroomBoardVo serviceNoticeRead(String notice_id) {
		return classroomBoarddao.noticeRead(notice_id);
	}

	//회원 아이디를 매개변수로 받아서 회원 한명을 조회 후 반환하는 기능의 메소드
	public MemberVo serviceMemberOne(String reply_id_) {
		return memberdao.memberOne(reply_id_);
	}

	//글쓰기
	public int serviceInsertBoard(ClassroomBoardVo vo) {
		return classroomBoarddao.insertBoard(vo);
	}

	//검색
	public ArrayList serviceBoardKeyWord(String key, String word, String course_id) {
		return classroomBoarddao.boardKeyWord(key, word, course_id);
	}

	//수정
	public int serviceUpdateBoard(String notice_id_2, String title_, String content_) {
		return classroomBoarddao.updateBoard(notice_id_2, title_, content_);
	}


	public String serviceDeleteBoard(String delete_notice_id) {
		return classroomBoarddao.deleteBoard(delete_notice_id);
	}


	public void serviceReplyInsertBoard(String super_notice_id, String reply_writer, String reply_title,
			String reply_content, String reply_id, String course_id) {
		classroomBoarddao.replyInsertBoard(super_notice_id,reply_writer, reply_title, reply_content, reply_id, course_id);
		
	}

}
