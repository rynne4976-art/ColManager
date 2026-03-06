package Controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Vector;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

import Dao.BoardDAO;
import Service.BoardService;
import Service.MenuItemService;
import Vo.BoardVo;
import Vo.MemberVo;
import Vo.ScheduleVo;

@WebServlet("/Board/*")
public class BoardController extends HttpServlet {
	
	private static final String API_URL = "https://api.odcloud.kr/api/15119003/v1/uddi:1e2e76a4-4f20-4333-b213-ef48bcc229e2"; // 공공 데이터 API URL
    private static final String API_KEY = "iMwPtfguErXt3nsomu%2B9iu%2FU2zBFzQful35yqHJsSfw4Bpjuo1eEihp1oUGZ0SuKJSWklDADykKuQs7SOL8ESA%3D%3D"; // 발급받은 API 키

	private static final long serialVersionUID = 1L;
	BoardService boardservice;

	@Override
	public void init() throws ServletException {
		super.init();
		new BoardDAO();
		boardservice = new BoardService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			doHandle(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			doHandle(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 모든 요청을 처리하는 메인 메서드
	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, Exception {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");

		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String contextPath = request.getContextPath();

		String nextPage = null;
		String center = null;
		String action = request.getPathInfo();

		ArrayList list = null;
		BoardVo vo = null;

		String startDate = null;
		String endDate = null;
		String month = null;

		System.out.println("2단계 요청 주소 : " + action);

		// 액션에 따라 분기 처리
	    switch(action) {
			case "/list.bo": //모든 글 조회 
				String key = (String)request.getParameter("key");
				String word = (String)request.getParameter("word");
				
				if(word == null) {
					//부장 호출!
					list = boardservice.serviceBoardList();
				}else {
					list = boardservice.serviceBoardKeyWord(key, word);
						
				}
				
				//list.jsp페이지의 페이징 처리 부분에서 
				//이전 또는 다음 또는 각페이지 번호중 하나를 클릭했을때 요청받는 값 얻기
				String nowPage = request.getParameter("nowPage");
				String nowBlock = request.getParameter("nowBlock");
				
				// MenuItemService를 사용하여 역할에 맞는 메뉴 HTML 생성
	    		MenuItemService menuService = new MenuItemService();
	    		String role =(String)session.getAttribute("role");
	    		System.out.println(role);
	    		
	    		// MenuItemService.java (서비스)를 호출하여 top메뉴와 sidebar에 표시될 요소를 반환받는다.
	    		String menuHtml = menuService.generateMenuHtml(role, contextPath);
	
	        	System.out.println(contextPath); // EduManager
	            System.out.println(menuHtml);
	
	            center = request.getParameter("center");
	    		request.setAttribute("center", center);
	    		
				request.setAttribute("list", list);
				request.setAttribute("nowPage", nowPage);
				request.setAttribute("nowBlock", nowBlock);
				request.setAttribute("key", key);
			   	request.setAttribute("word", word);
				
				
				
				nextPage = "/main.jsp";
	
				break;
	
				
			case "/searchlist.bo": //검색 키워드로  글조회
				
			 //요청한 값 얻기 (조회를 위해 선택한 Option의 값 , 입력한 검색어)
			 key = request.getParameter("key");
			 word = request.getParameter("word");
			 String role_ = (String)session.getAttribute("role");
				
				
			 //부장 호출
			 //검색 기준열의 값과 입력한 검색어 단어를 포함하고 있는 글목록 조회 명령!
		     list = boardservice.serviceBoardKeyWord(key, word);
				
		     //VIEW중앙화면에 조회된 글목록을 보여주기 위해
		     //request내장객체에 조회된 정보 바인딩
		     request.setAttribute("list", list);
			 request.setAttribute("key", key);
		     request.setAttribute("word", word);
		      
		     if(role_ != null && role_.equals("관리자")) {
			     //VIEW중앙화면 주소경로 바인딩
			     request.setAttribute("center", "view_admin/noticeManage.jsp");
		     }else { 
		    	 request.setAttribute("center", "common/notice/list.jsp");
		     }
		     
		     //재요청할 메인 페이지 주소 경로 변수에 저장
		     nextPage = "/main.jsp";
		     
		     	break;
				
			case "/write.bo"://새글을 입력할수 있는 화면 요청
				
				String memberid = (String)session.getAttribute("id");
				
				//부장호출
				//새글을 입력할수 있는 화면에 로그인한 사람(글쓰는 사람)의 정보를 보여주기 위해
				//조회 해 오자 
				MemberVo membervo = boardservice.serviceMemberOne(memberid);
	
		
				//글쓰기 중앙화면(VIEW)경로를 request내장객체에 바인딩
				request.setAttribute("center", "common/notice/write.jsp");
			
				request.setAttribute("nowPage", request.getParameter("nowPage"));
				request.setAttribute("nowBlock", request.getParameter("nowBlock"));
				
				
				//재요청할 전체 VIEW경로 저장
				nextPage = "/main.jsp";
				
				break;
		     	
			case "/writePro.bo": //입력한 새글 정보 DB에 추가 
				
				//요청한 값 얻기
				String writer = request.getParameter("w");
				String title = request.getParameter("t");
				String content = request.getParameter("c");
				
				//요청한 값들 BoardVo객체의 각변수에 저장
				vo = new BoardVo();
				vo.setAuthor_id(writer);
				vo.setTitle(title);
				vo.setContent(content);
				
				//부장 호출
				//웹브라우저에 응답할 값 마련(DB에 새글 정보 추가에 성공 또는 실패 관련 조건 데이터)
				//result == 1  -> insert 성공
				//result == 0  -> insert 실패  
				int result = boardservice.serviceInsertBoard(vo);
				
				//1 -> "1"로 변환 하거나 또는  0 -> "0"문자열로 변환해서 저장
				String go = String.valueOf(result);
				
				if(go.equals("1")) {//"1"  insert 성공했다면?
					
					out.print(go);//"1"전달    writer.jsp요청한 페이지로 응답
					
				}else {//"0"  insert 실패 했다면? 
					
					out.print(go);//"0"전달  writer.jsp요청한 페이지로 응답 
				}
				
				return;//doHandle메소드 빠져나가게 해서 밑의 포워딩 안되게 
				
			case "/read.bo"://글제목을 클릭해 글번호를 이용한 글조회 요청!
							//조회한 글정보 중앙화면에 보여줍시다
				
				//list.jsp에서 글제목을 클릭했을 때 요청한 3개의 값 얻기
				String notice_id = request.getParameter("notice_id");//글번호
				String nowPage_ = request.getParameter("nowPage");//현재 페이지번호
				String nowBlock_ = request.getParameter("nowBlock");
				//현재 보이고 있는 페이지번호가 속한 
				//블럭위치 번호 
				
				
				//부장 호출
				//글제목을 눌렀을때 조회된 레코드(글)에 관한 글정보 하나 조회 요청
				vo = boardservice.serviceBoardRead(notice_id);
				
				//조회된 글 하나의 정보를 보여줄 중앙 VIEW 경로  request에 바인딩
				request.setAttribute("center", "common/notice/read.jsp");
				
				//조회된 글 하나의 정보(BoardVO객체) request에 바인딩
				request.setAttribute("vo", vo);
				
				//중앙 VIEW board/read.jsp페이지에 전달후 사용하기 위한
				//nowPage, nowBlock, b_idx 각각 바인딩
				request.setAttribute("nowPage", nowPage_);
				request.setAttribute("nowBlock", nowBlock_);
				request.setAttribute("notice_id", notice_id);
				
				nextPage="/main.jsp";
				
			    break;
			    	
			case "/updateBoard.do": //글 수정 요청 
				
				//글 수정시 입력한 값 얻기
				String notice_id_2  = request.getParameter("notice_id");
				String title_  = request.getParameter("title");
				String content_ = request.getParameter("content");
				
				//부장 호출
				//수정시 입력한 위변수값들을 DB의 Board테이블에 있는 열의 값으로 저장되게 수정요청
				int result_ = boardservice.serviceUpdateBoard(notice_id_2, 
															  title_, content_);
				
				
				if(result_ == 1) { //UPDATE성공
					out.write("수정성공");//웹브라우저창을 거쳐서 
										//read.jsp에서 호출한 $.ajax메소드 내부의
										//success:function(data){}의 
									    //data매개변수로 "수정성공" 보낸다 
					return;
				}else {//UPDATE실패
					out.write("수정실패");
					return;
				}
				
			case "/deleteBoard.do": //글 삭제  2단계 요청 주소일때 
				//삭제를 위해 요청한 글번호 얻기
				String delete_notice_id = request.getParameter("notice_id");
				
				//부장 호출
				//글삭제 요청!시 삭제할 글번호를 전달해 
				//삭제에 성공하면 "삭제성공" 메세지 반환받고,
				//삭제에 실패하면 "삭제실패" 메세지를 반환받자
				String result__ = boardservice.serviceDeleteBoard(delete_notice_id);
				
				out.write(result__); //AJAX
				
				return;
				
			case "/reply.do":
				//요청한 주글(부모글) 글번호 얻는다
				String notice_id_ = request.getParameter("notice_id");
				//요청한 답변글을 작성할 사람의 아이디 얻는다
				String reply_id_ = request.getParameter("id");
				
				//부장호출
				//로그인한 회원이 주글에 대한 답변그을 작성할수 있도록 하기 위해
				//로그인 한 회원 아이디를 BoardService의 메소드 호출시 매개변수로 전달해
				//아이디 에 해당하는 회원정보를 조회함
				MemberVo reply_vo = boardservice.serviceMemberOne(reply_id_);
				
				//부모글번호와 조회한 답변글 작성자 정보를  request에 바인딩
				request.setAttribute("notice_id", notice_id_); //주글(부모) 글번호 
				request.setAttribute("vo", reply_vo);//답변글 작성하는 사람 정보 
				
				//중앙화면(답변글을 작성할수 있는 중앙 VIEW) 경로를  request에 바인딩
				request.setAttribute("center", "common/notice/reply.jsp");
				
				nextPage="/main.jsp";
				
				break;
			
				 //주글에 대한 답변글 DB의 Board테이블에 추가 요청
			case "/replyPro.do":	
				
			//요청한 값들( 주글(부모글) 글번호  + 작성한 추가할 답변글 정보   ) 얻기
				
				//주글(부모글) 글번호 
				String super_notice_id = request.getParameter("super_notice_id");
				String reply_writer = request.getParameter("writer");
				String reply_title = request.getParameter("title");
				String reply_content = request.getParameter("content");
				
				String reply_id = (String)session.getAttribute("id");
				
				String role_1 = (String)session.getAttribute("role");
				
				//부장님 호출
				boardservice.serviceReplyInsertBoard(super_notice_id, reply_writer, reply_title, reply_content, reply_id);
	
	//			
				//답변글  추가에 성공하면 
				//다시 전체 글목록 조회 해서 보여주기 위한 재요청 주소를 
				//nextPage변수에 저장
				 if(role_1.equals("관리자")) {
					 nextPage = "/Board/list.bo?center=/view_admin/noticeManage.jsp";
			     }else if(role_1.equals("교수")){
			    	 nextPage = "/Board/list.bo?center=/view_professor/noticeProfessor.jsp";
			     }else {
			    	 nextPage = "/Board/list.bo?center=/view_student/noticeStudent.jsp";
			     }
				
				
				break;
				
			case "/boardCalendar.bo":
	
				center = "/common/calendar.jsp";
	
				request.setAttribute("center", center);
	
				nextPage = "/main.jsp";
	
				break;
	
			case "/boardCalendar.do":
                // 일정 데이터를 JSON 형식으로 응답하는 기능
                startDate = request.getParameter("start");
                endDate = request.getParameter("end");

                try {
                    List<ScheduleVo> eventList = boardservice.getEvents(startDate, endDate);
                    Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
                    List<JsonObject> jsonEvents = new ArrayList<>();
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    for (ScheduleVo event : eventList) {
                        JsonObject jsonEvent = new JsonObject();
                        jsonEvent.addProperty("title", event.getEvent_name());
                        jsonEvent.addProperty("start", dateFormat.format(event.getStart_date()));

                        // end_date 에 하루를 추가하여 저장
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(event.getEnd_date());
                        calendar.add(Calendar.DAY_OF_MONTH, 1);
                        jsonEvent.addProperty("end", dateFormat.format(calendar.getTime()));

                        jsonEvent.addProperty("description", event.getDescription());
                        jsonEvents.add(jsonEvent);
                    }
                    String jsonResponse = gson.toJson(jsonEvents);
                    response.setContentType("application/json;charset=UTF-8");
                    out.print(jsonResponse);
                    out.flush();
                } catch (IllegalArgumentException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    JsonObject error = new JsonObject();
                    error.addProperty("error", e.getMessage());
                    out.write(error.toString());
                } catch (RuntimeException e) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    JsonObject error = new JsonObject();
                    error.addProperty("error", "서버 내부 오류가 발생했습니다.");
                    out.write(error.toString());
                    e.printStackTrace();
                }
                return;
	
			case "/viewSchedule.bo":
		        List<ScheduleVo> scheduleList = new ArrayList<ScheduleVo>();
				month = request.getParameter("month");
				if (month != null && !month.isEmpty()) {
					scheduleList = boardservice.processViewSchedule(request);
				}
	
				center = request.getParameter("center");
				request.setAttribute("scheduleList",scheduleList);
				request.setAttribute("center", "/view_admin/calendarEdit.jsp");
	
				nextPage = "/main.jsp";
	
				break;
	
			case "/addSchedule":
				boardservice.addSchedule(request);
				startDate = request.getParameter("startDate");
				month = startDate.substring(0, 7);
				response.sendRedirect(request.getContextPath()
						+ "/Board/viewSchedule.bo?center=/view_admin/calendarEdit.jsp&month=" + month);
				return;
			case "/updateSchedule":
				boardservice.updateSchedule(request);
				month = request.getParameter("month");
				response.sendRedirect(
						request.getContextPath() + "/Board/viewSchedule.bo?center=/view_admin/calendarEdit.jsp&month="
								+ URLEncoder.encode(month, "UTF-8"));
				return;
			case "/deleteSchedule":
				boardservice.deleteSchedule(request);
				month = request.getParameter("month");
	
				response.sendRedirect(request.getContextPath() + "/Board/viewSchedule.bo?center=/view_admin/calendarEdit.jsp&month=" + URLEncoder.encode(month, "UTF-8"));
				return;
		
	//================================================================================================
	
			case "/bookShopMap.bo":
			    // 모든 데이터를 가져옴
			    List<JSONObject> allData = boardservice.fetchAllData(API_URL, API_KEY);
			    
		        // JSP에 "dataString" 전달
		        request.setAttribute("apiData", allData);
			        
		        center = "/common/bookShopMap.jsp";
		        request.setAttribute("center", center);
		        nextPage = "/main.jsp";
		        
			    break; 
			
	//================================================================================================
			
		default:
			break;
		}

		// 다음 페이지로 포워딩
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);
	}
}
