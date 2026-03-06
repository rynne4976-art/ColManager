package Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Dao.BoardDAO;
import Dao.MemberDAO;
import Vo.BoardVo;
import Vo.MemberVo;
import Vo.ScheduleVo;

public class BoardService {

	BoardDAO boarddao;
	MemberDAO memberdao;

	public BoardService() {
		boarddao = new BoardDAO();
		memberdao = new MemberDAO();
	}
	
	//회원 아이디를 매개변수로 받아서 회원 한명을 조회 후 반환하는 기능의 메소드
		public MemberVo serviceMemberOne(String reply_id_) {
			return memberdao.memberOne(reply_id_);
		}
		
		//작성한 새글 정보 하나를 DB의 board테이블에 추가(INSERT)기능의 메소드
		public int serviceInsertBoard(BoardVo vo) {
			 return  boarddao.insertBoard(vo); //1 또는 0을 반환 받아 다시 반환(리턴)
		}
		
		
		//DB의 board테이블에 저장되어 있는 모든 글목록을 조회하는 기능의 메소드
		public ArrayList serviceBoardList() {
			
			return boarddao.boardListAll();
		}
		
		
		//검색기준값과 입력한 검색어를 포함하고 있는 글목록을 조회하는 기능의 메소드
		public ArrayList serviceBoardKeyWord(String key, String word) {
			
			return boarddao.boardList(key,word);//BoardController사장에게 리턴(보고)
		}
		
		//글번호(b_idx)를 이용해 조회 명령하는 기능의 메소드
		 public BoardVo serviceBoardRead(String notice_id) {
			 
			 return boarddao.boardRead(notice_id);
		 }
		
		// 글 수정 요청 UPDATE 하기 위한 메소드 호출!
		public int serviceUpdateBoard(String notice_id_2, String title_, String content_) {
			       //수정에 성공하면 1을 반환 실패하면 0을 반환
			return boarddao.updateBoard(notice_id_2, title_, content_);
		}

		// 글 삭제 요청 DELETE 하기 위한 메소드 호출!
		public String serviceDeleteBoard(String delete_notice_id) {
			
				   //삭제에 성공하면 "삭제성공" 반환 실패하면 "삭제실패" 반환 
			return boarddao.deleteBoard(delete_notice_id);
		}

		//DB의 Board테이블에 입력한 답변글 추가 하기 위해 호출!
		public void serviceReplyInsertBoard(String super_notice_id, String reply_writer, String reply_title, String reply_content, String reply_id) {
			boarddao.replyInsertBoard(super_notice_id, reply_writer, reply_title, reply_content, reply_id);
		}

	// 일정 이벤트 조회 서비스 (캘린더)
	public List<ScheduleVo> getEvents(String startDate, String endDate) throws Exception {
		return boarddao.getEvents(startDate, endDate);
	}
	
	public List<ScheduleVo> processViewSchedule(HttpServletRequest request) {
        String month = request.getParameter("month");
        List<ScheduleVo> scheduleList = new ArrayList<ScheduleVo>();
        if (month != null && !month.isEmpty()) {
            String[] parts = month.split("-");
            if (parts.length == 2) {
                String year = parts[0];
                String monthPart = parts[1];
                scheduleList = boarddao.getEventsByMonth(year, monthPart);
            }
        }
        return scheduleList;
    }
	
	public void addSchedule(HttpServletRequest request) {
		String title = request.getParameter("title");
		Date startDate = Date.valueOf(request.getParameter("startDate"));
		Date endDate = Date.valueOf(request.getParameter("endDate"));
		String content = request.getParameter("content");

		if (boarddao.isValidSchedule(title, startDate, endDate, content)) {
			ScheduleVo newSchedule = new ScheduleVo();
			newSchedule.setEvent_name(title);
			newSchedule.setStart_date(startDate);
			newSchedule.setEnd_date(endDate);
			newSchedule.setDescription(content);

			boarddao.insertSchedule(newSchedule);
		} else {
			throw new IllegalArgumentException("일정 데이터가 유효하지 않습니다.");
		}
	}

	public void updateSchedule(HttpServletRequest request) {
		int scheduleId = Integer.parseInt(request.getParameter("schedule_id"));
		String title = request.getParameter("title");
		Date startDate = Date.valueOf(request.getParameter("startDate"));
		Date endDate = Date.valueOf(request.getParameter("endDate"));
		String content = request.getParameter("content");

		if (boarddao.isValidSchedule(title, startDate, endDate, content)) {
			ScheduleVo updatedSchedule = new ScheduleVo();
			updatedSchedule.setSchedule_id(scheduleId);
			updatedSchedule.setEvent_name(title);
			updatedSchedule.setStart_date(startDate);
			updatedSchedule.setEnd_date(endDate);
			updatedSchedule.setDescription(content);

			boarddao.updateSchedule(updatedSchedule);
		} else {
			throw new IllegalArgumentException("일정 데이터가 유효하지 않습니다.");
		}
	}

	public void deleteSchedule(HttpServletRequest request) {
		String[] deleteIds = request.getParameterValues("deleteIds");
		if (deleteIds != null) {
			for (String id : deleteIds) {
				int scheduleId = Integer.parseInt(id);
				boarddao.deleteSchedule(scheduleId);
			}
		} else {
			throw new IllegalArgumentException("삭제할 일정이 선택되지 않았습니다.");
		}
	}

	//=======================
	// 중고서점 API 사용
	public List<JSONObject> fetchAllData(String apiUrl, String apiKey) {
	    
	    List<JSONObject> allData = new ArrayList<>(); // 데이터를 저장할 리스트
	    int page = 1; // 첫 번째 페이지
	    int perPage = 50; // 한 페이지당 데이터 수를 50으로 설정
//	    boolean hasNextPage = true;
	        
//	    while (hasNextPage) {
	        try {

	            URI uri = new URI(apiUrl + "?serviceKey=" + apiKey + "&page=" + page + "&perPage=" + perPage);
	            URL url = uri.toURL(); // URI를 URL로 변환
	            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	            conn.setRequestMethod("GET");
	            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

	            int responseCode = conn.getResponseCode();
	            if (responseCode == HttpURLConnection.HTTP_OK) { // HTTP 상태 코드 200
	                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
	                StringBuilder response = new StringBuilder();
	                String line;
	                while ((line = br.readLine()) != null) {
	                    response.append(line);
	                }
	                br.close();
	                
	                // JSON 데이터 파싱
	                JSONParser parser = new JSONParser();
	                JSONObject jsonObject = (JSONObject) parser.parse(response.toString());

	                // "data" 배열 가져오기
	                JSONArray dataArray = (JSONArray) jsonObject.get("data");
	                for (Object obj : dataArray) {
	                    allData.add((JSONObject) obj); // 데이터 통합
	                }
	                
	                // 페이징 처리
//	                long currentCount = (long) jsonObject.get("currentCount"); // 현재 가져온 데이터 수
//	                long totalCount = (long) jsonObject.get("totalCount"); // 전체 데이터 수
//	                if (allData.size() >= totalCount || currentCount < perPage) {
//	                    hasNextPage = false; // 더 이상 가져올 데이터가 없음
//	                } else {
//	                    page++; // 다음 페이지 요청
//	                }
//	                
	            } else {
	                System.out.println("API 호출 실패. 응답 코드: " + responseCode);
//	                hasNextPage = false;
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
//	            hasNextPage = false;
	        }
//	    }
	    return allData; // 데이터 반환
	}

}
