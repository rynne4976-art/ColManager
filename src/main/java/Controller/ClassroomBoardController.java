package Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Service.ClassroomBoardService;
import Vo.BoardVo;
import Vo.ClassroomBoardVo;
import Vo.MemberVo;

@WebServlet("/classroomboard/*")
public class ClassroomBoardController extends HttpServlet{

	ClassroomBoardService classroomBoardService;

	@Override
	public void init() throws ServletException {
		classroomBoardService = new ClassroomBoardService();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8"); // MIME TYPE 설정
		
		String contextPath = request.getContextPath();
		
		//웹브라우저로 출력할 출력 스트림 생성
	    PrintWriter out = response.getWriter();
	      
	    // 조건에 따라 포워딩 또는 보여줄 VIEW 주소 경로를 저장할 변수
	    String nextPage = null;
	    ClassroomBoardVo vo = null;
	    
	    // 재요청할 경로 주소를 저장할 변수
	    String center = null;
		
	    String action = request.getPathInfo(); // 2단계 요청주소
	    System.out.println("요청한 2단계 주소: " + action);	
	    
	    switch (action) {
		  //==========================================================================================
			
	    	case "/noticeList.bo": //글 전체 목록 조회할때 
	    		
	    		ArrayList<ClassroomBoardVo> noticeList = null;
	    		String course_id = request.getParameter("courseId");
	    		String user_name = (String)session.getAttribute("name");
	    		String key = (String)request.getParameter("key");
	    		String word = (String)request.getParameter("word");
	    		
	    		if(word == null) {
	    			//부장 호출!
					noticeList = classroomBoardService.serviceNoticeList(course_id, user_name);
					request.setAttribute("list", noticeList);
	    		}else {
	    			ArrayList list = null;
			   		//부장 호출
			   		//검색 기준열의 값과 입력한 검색어 단어를 포함하고 있는 글목록 조회 명령!
			   	    list = classroomBoardService.serviceBoardKeyWord(key, word, course_id);
			   	    request.setAttribute("list", list);
	    		}
	    		
	    		
				//list.jsp페이지의 페이징 처리 부분에서 
				//이전 또는 다음 또는 각페이지 번호중 하나를 클릭했을때 요청받는 값 얻기
				String nowPage = request.getParameter("nowPage");
				String nowBlock = request.getParameter("nowBlock");
	
	            center = request.getParameter("center");
	    		request.setAttribute("classroomCenter", center);
	    		
				request.setAttribute("nowPage", nowPage);
				request.setAttribute("nowBlock", nowBlock);
				request.setAttribute("course_id", course_id);
				request.setAttribute("user_name", user_name);
		   	    request.setAttribute("key", key);
		   	    request.setAttribute("word", word);
				
				nextPage = "/view_classroom/classroom.jsp";
	
				break;
				
	    //==========================================================================================

	    	case "/noticeRead.bo": //글제목을 클릭해 글번호를 이용한 글조회 요청!
	   
	    		String notice_id = request.getParameter("notice_id");//글번호
				String nowPage_ = request.getParameter("nowPage");//현재 페이지번호
				String nowBlock_ = request.getParameter("nowBlock");
				course_id = (String)request.getParameter("course_id");
				
				//글제목을 눌렀을때 조회된 레코드(글)에 관한 글정보 하나 조회 요청
				vo = classroomBoardService.serviceNoticeRead(notice_id);
			
				//조회된 글 하나의 정보(BoardVO객체) request에 바인딩
				request.setAttribute("vo", vo);
				
				//중앙 VIEW board/read.jsp페이지에 전달후 사용하기 위한
				//nowPage, nowBlock, b_idx 각각 바인딩
				request.setAttribute("nowPage", nowPage_);
				request.setAttribute("nowBlock", nowBlock_);
				request.setAttribute("notice_id", notice_id);
				request.setAttribute("course_id", course_id);
				 
				center = request.getParameter("center");
				//조회된 글 하나의 정보를 보여줄 중앙 VIEW 경로  request에 바인딩
				request.setAttribute("classroomCenter", center);
				
				nextPage = "/view_classroom/classroom.jsp";
	    		
	    		break;
				
	    //==========================================================================================
	 	
	    	case "/noticeWrite.bo":
	    		
				String reply_id_ = (String)session.getAttribute("id");
				course_id = (String)request.getParameter("course_id");
				
				//부장호출
				//새글을 입력할수 있는 화면에 로그인한 사람(글쓰는 사람)의 정보를 보여주기 위해
				//조회 해 오자 
				MemberVo membervo = classroomBoardService.serviceMemberOne(reply_id_);
		
				center = request.getParameter("center");
				request.setAttribute("classroomCenter", center);
			
				request.setAttribute("nowPage", request.getParameter("nowPage"));
				request.setAttribute("nowBlock", request.getParameter("nowBlock"));
				request.setAttribute("course_id", course_id);
				
				//재요청할 전체 VIEW경로 저장
				nextPage = "/view_classroom/classroom.jsp";
	    		
	    		break;
	    		
	    //==========================================================================================
	    		
	    	case "/noticeWritePro.bo":
	    		
	    		//요청한 값 얻기
				String writer = request.getParameter("w");
				String title = request.getParameter("t");
				String content = request.getParameter("c");
				course_id = (String)request.getParameter("course_id");
				
				//요청한 값들 BoardVo객체의 각변수에 저장
				vo = new ClassroomBoardVo();
				vo.setAuthor_id(writer);
				vo.setTitle(title);
				vo.setContent(content);
				vo.setCourse_id(course_id);
				
				//부장 호출
				//웹브라우저에 응답할 값 마련(DB에 새글 정보 추가에 성공 또는 실패 관련 조건 데이터)
				//result == 1  -> insert 성공
				//result == 0  -> insert 실패  
				int result = classroomBoardService.serviceInsertBoard(vo);
				
				//1 -> "1"로 변환 하거나 또는  0 -> "0"문자열로 변환해서 저장
				String go = String.valueOf(result);
				
				if(go.equals("1")) {//"1"  insert 성공했다면?
					
					out.print(go);//"1"전달    writer.jsp요청한 페이지로 응답
					
				}else {//"0"  insert 실패 했다면? 
					
					out.print(go);//"0"전달  writer.jsp요청한 페이지로 응답 
				}
				
				return;//doHandle메소드 빠져나가게 해서 밑의 포워딩 안되게 
	    		
	    //==========================================================================================

	    	case "/searchlist.bo":
		    	//요청한 값 얻기 (조회를 위해 선택한 Option의 값 , 입력한 검색어)
		   		key = request.getParameter("key");
		   		word = request.getParameter("word");
		   		String role_ = (String)session.getAttribute("role");
		   		course_id = (String)request.getParameter("course_id");
		   		
		   		System.out.println(course_id);
		   		System.out.println(key);
		   		System.out.println(word);
		   		
		   		ArrayList list = null;
		   		//부장 호출
		   		//검색 기준열의 값과 입력한 검색어 단어를 포함하고 있는 글목록 조회 명령!
		   	    list = classroomBoardService.serviceBoardKeyWord(key, word, course_id);
		   			
		   	    //VIEW중앙화면에 조회된 글목록을 보여주기 위해
		   	    //request내장객체에 조회된 정보 바인딩
		   	    request.setAttribute("list", list);
		   	    request.setAttribute("course_id", course_id);
		   	    request.setAttribute("key", key);
		   	    request.setAttribute("word", word);
		   	    
		   
		   		request.setAttribute("classroomCenter", "assignment_notice/professorNotice.jsp");
		   	   
		   	    //재요청할 메인 페이지 주소 경로 변수에 저장
		   	    nextPage = "/view_classroom/classroom.jsp";
		   	     
		   	    break;
				
		//==========================================================================================
		   	    
	    	case "/updateList.do":
	    		//글 수정시 입력한 값 얻기
				String notice_id_2  = request.getParameter("notice_id");
				String title_  = request.getParameter("title");
				String content_ = request.getParameter("content");
				
				//부장 호출
				//수정시 입력한 위변수값들을 DB의 Board테이블에 있는 열의 값으로 저장되게 수정요청
				int result_ = classroomBoardService.serviceUpdateBoard(notice_id_2, title_, content_);
				
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
		   	    
		//==========================================================================================

	    	case "/deleteList.do":
	    		
	    		//삭제를 위해 요청한 글번호 얻기
				String delete_notice_id = request.getParameter("notice_id");
				
				//부장 호출
				//글삭제 요청!시 삭제할 글번호를 전달해 
				//삭제에 성공하면 "삭제성공" 메세지 반환받고,
				//삭제에 실패하면 "삭제실패" 메세지를 반환받자
				String result__ = classroomBoardService.serviceDeleteBoard(delete_notice_id);
				
				out.write(result__); //AJAX
				
				return;
				
		//==========================================================================================

	    	case "/reply.do":
	    		
				//요청한 주글(부모글) 글번호 얻는다
				String notice_id_ = request.getParameter("notice_id");
				//요청한 답변글을 작성할 사람의 아이디 얻는다
				reply_id_ = request.getParameter("id");
				course_id = (String)request.getParameter("course_id");
				
				System.out.println("reply: " +course_id);
				//부장호출
				//로그인한 회원이 주글에 대한 답변그을 작성할수 있도록 하기 위해
				//로그인 한 회원 아이디를 BoardService의 메소드 호출시 매개변수로 전달해
				//아이디 에 해당하는 회원정보를 조회함
				MemberVo reply_vo = classroomBoardService.serviceMemberOne(reply_id_);
				
				//부모글번호와 조회한 답변글 작성자 정보를  request에 바인딩
				request.setAttribute("notice_id", notice_id_); //주글(부모) 글번호 
				request.setAttribute("vo", reply_vo);//답변글 작성하는 사람 정보 
				request.setAttribute("course_id", course_id);
				
				//중앙화면(답변글을 작성할수 있는 중앙 VIEW) 경로를  request에 바인딩
				request.setAttribute("classroomCenter", "assignment_notice/classroomReply.jsp");
				
		   	    nextPage = "/view_classroom/classroom.jsp";
	    		
	    		break;
				
		//==========================================================================================
	    
	    	case "/replyPro.do":	
				
	    		//요청한 값들( 주글(부모글) 글번호  + 작성한 추가할 답변글 정보   ) 얻기
	    			
	    			//주글(부모글) 글번호 
	    			String super_notice_id = request.getParameter("super_notice_id");
	    			String reply_writer = request.getParameter("writer");
	    			String reply_title = request.getParameter("title");
	    			String reply_content = request.getParameter("content");
					course_id = (String)request.getParameter("courseId");
					
					System.out.println("답변 : " + course_id);
	    			
	    			String reply_id = (String)session.getAttribute("id");
	    			
	    			//부장님 호출
	    			classroomBoardService.serviceReplyInsertBoard(super_notice_id, reply_writer, reply_title, reply_content, reply_id, course_id);

//	    			
	    			//답변글  추가에 성공하면 
	    			//다시 전체 글목록 조회 해서 보여주기 위한 재요청 주소를 
	    			//nextPage변수에 저장
	    			nextPage = "/classroomboard/noticeList.bo?center=/view_classroom/assignment_notice/professorNotice.jsp";
	    		     
	    			break;
	    		
	    //==========================================================================================
	    		
	    		
		
			default:
				break;
			}
	    
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response);
		
	}
	
}
