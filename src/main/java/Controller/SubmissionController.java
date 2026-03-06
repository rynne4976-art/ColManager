package Controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Service.SubmissionService;
import Vo.SubmissionVo;

@WebServlet("/submit/*")
public class SubmissionController extends HttpServlet {


	SubmissionService submissionservice;
	
	@Override
	public void init() throws ServletException {
		submissionservice = new SubmissionService();
	}
	
	// doGet doPost 메소드 오버라이딩
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	protected void doHandle(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {

        HttpSession session = request.getSession();
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8"); // MIME TYPE 설정
		
		//웹브라우저로 출력할 출력 스트림 생성
	    PrintWriter out = null;
	      
	    // 조건에 따라 포워딩 또는 보여줄 VIEW 주소 경로를 저장할 변수
	    String nextPage = null;
	    
	    // 재요청할 경로 주소를 저장할 변수
	    String center = null;
		
	    String action = request.getPathInfo(); // 2단계 요청주소
	    System.out.println("요청한 2단계 주소: " + action);
	    
	    
	    switch(action) {

		//==========================================================================================
	    
	    	case "/submitAssignmentPage.bo": // 학생의 과제를 제출하는 화면을 보여주는 2단계 요청 주소를 받으면
	    		
	    		String assignment_id = request.getParameter("assignmentId");
	    		if(assignment_id == null) {
	    			assignment_id = (String)request.getAttribute("assignmentId");
	    		}
	    		
	    		String courseId = request.getParameter("courseId");
	    		if(courseId == null) {
	    			courseId = (String)request.getAttribute("courseId");
	    		}
	    		
	    		String assignment_title = request.getParameter("assignmentTitle");
	    		if(assignment_title == null) {
	    			assignment_title = (String)request.getAttribute("assignmentTitle");
	    		}
	    		
	    		String message = (String)request.getAttribute("message");
	    		assignment_title = URLDecoder.decode(assignment_title, "UTF-8");
	    		center = "/view_classroom/assignment_submission/submitAssignment.jsp";
	    		
	    		request.setAttribute("classroomCenter", center);
	    		request.setAttribute("assignmentId", assignment_id);
	    		request.setAttribute("assignment_title", assignment_title);
	    		request.setAttribute("message", message);
	    		request.setAttribute("courseId", courseId);
	    		
	    		nextPage = "/view_classroom/classroom.jsp";
	    		
	    		break;
	    		
	    //==========================================================================================
	    	    
	    	case "/uploadAssignment.do": // 학생이 파일을 제출하기 위한 2단계 요청 주소를 받으면
	    		
	    		String uploadPath = getServletContext().getRealPath("") + File.separator + "submitUploads";
	    		File uploadDir = new File(uploadPath);

	    		if (!uploadDir.exists()) {
	    			uploadDir.mkdir(); // 업로드 디렉토리 생성
	    		}
	    	    
	    		int maxSize = 1024 * 1024 * 1024;
	    		
	    		MultipartRequest multipartRequest = new MultipartRequest(request, uploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
	    		
	    		String assignmentId = multipartRequest.getParameter("assignmentId"); 
	    		String assignmentTitle = multipartRequest.getParameter("assignmentTitle");
	    		String studentId = (String)session.getAttribute("student_id"); // 학생 ID
	    		courseId = multipartRequest.getParameter("courseId");
	    		
	    		// 실제 업로드 하기 전의  파일업로드를 하기 위해 jsp에서 선택했던 원본파일명 얻기
	    		String original_name = multipartRequest.getOriginalFileName("assignmentFile");
	    		// 실제 업로드폴더(실제 서버 업로드폴더경로)에  업로드된 실제 파일명 얻기 
	    		String file_path = multipartRequest.getFilesystemName("assignmentFile");
	    		
	    		// 서비스 호출
	    		int result = submissionservice.serviceSaveSubmissionWithFile(assignmentId, studentId, file_path, original_name);
	    		if(result == 1) {
				    request.setAttribute("message", "과제 제출이 완료되었습니다.");
				} else {
					request.setAttribute("message", "과제 제출에 실패했습니다.");
				}
	    		
	    		request.setAttribute("assignmentId", assignmentId);
	    		request.setAttribute("courseId", courseId);
	    		request.setAttribute("assignmentTitle", URLEncoder.encode(assignmentTitle, "UTF-8"));
	    		
	    		nextPage = "/submit/submitAssignmentPage.bo";
	    		
	    		break;
	    		
	    //==========================================================================================
	    		
	    	case "/getSubmittedAssignments.do":  // 학생이 제출한 과제의 정보를 조회하기 위한 2단계 요청 주소
	    	    studentId = (String) session.getAttribute("student_id"); // 학생 ID
	    	    assignment_id = request.getParameter("assignmentId");
	    	    
	    	    response.setContentType("application/json;charset=utf-8");
	    	    
	    	    out = response.getWriter();
	    	    
	    	    SubmissionVo submission = submissionservice.serviceGetSubmission(studentId, assignment_id);
	    	    if (submission != null) {
	    	        // JSON 데이터 생성
	    	        JSONObject jsonObject = new JSONObject();
	    	        jsonObject.put("fileId", submission.getFileId());
	    	        jsonObject.put("originalName", submission.getOriginalName());
	    	        jsonObject.put("submittedDate", submission.getSubmittedDate().toString());
	    	        jsonObject.put("fileName", submission.getFileName());

	    	        response.setContentType("application/json;charset=utf-8");
	    	        out.print(jsonObject);
	    	        out.flush();
	    	        out.close();

	    	        return;
	    	    } else {
	    	        response.setContentType("application/json;charset=utf-8");
	    	        out.print("null");
	    	        out.flush();
	    	        out.close();
	    	        return;
	    	    }
	    	    
	    		
	    //==========================================================================================
	    		
	    	case "/downloadAssignment.do": // 제출한 파일을 다운로드하기 위한 2단계 요청 주소
	    		String fileId = request.getParameter("fileId"); // fileId를 파라미터로 받음

	    	    // 파일 정보 조회 (fileId를 사용하여 데이터베이스에서 조회)
	    	    SubmissionVo fileInfo = submissionservice.getFileById(fileId);
	    	    
	    	    String fileName = fileInfo.getFileName();
	    	    String originalName = fileInfo.getOriginalName();

	    	    File file = new File(getServletContext().getRealPath("/submitUploads") + File.separator + fileName);
	    	    if (file.exists()) {
	    	        response.setContentType("application/octet-stream");
	    	        response.setContentLength((int) file.length());
	    	        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(originalName, "UTF-8") + "\";");

	    	        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
	    	             BufferedOutputStream file_out = new BufferedOutputStream(response.getOutputStream())) {

	    	            byte[] buffer = new byte[1024];
	    	            int bytesRead;
	    	            while ((bytesRead = in.read(buffer)) != -1) {
	    	            	file_out.write(buffer, 0, bytesRead);
	    	            }
	    	            file_out.flush();
	    	            return;
	    	        } catch (IOException e) {
	    	            e.printStackTrace();
	    	        }
	    	    } else {
	    	        response.setContentType("text/html;charset=UTF-8");
	    	        response.getWriter().write("<script>alert('파일을 찾을 수 없습니다.'); history.back();</script>");
	    	        return;
	    	    }
	    		
	    //==========================================================================================
	    		
	    	case "/deleteFile.do": // 학생이 제출한 파일 삭제하기 위한 2단계 요청 주소
	    	    fileId = request.getParameter("fileId"); // 클라이언트에서 전달된 파일 ID
	    	    // 파일 정보 조회 및 권한 확인
	    	    SubmissionVo fileData = submissionservice.getFileById(fileId);
	    	    int submission_id = fileData.getSubmissionId();
	    	    
	    	    // 실제 파일 삭제
	    	    String filePath = getServletContext().getRealPath("/submitUploads") + File.separator + fileData.getFileName();
	    	    file = new File(filePath);
	    	    boolean fileDeleted = file.exists() && file.delete();

	    	    // 데이터베이스에서 파일 정보 삭제
	    	    if (fileDeleted) {
	    	        result = submissionservice.deleteFile(fileId, submission_id);
	    	        if (result == 2) {
	    	            response.getWriter().write("파일이 성공적으로 삭제되었습니다.");
	    	        } else {
	    	            response.getWriter().write("파일 삭제는 완료되었으나, 데이터베이스에서 완전히 삭제되지 않았습니다.");
	    	        }
	    	    } else {
	    	        response.getWriter().write("파일을 삭제할 수 없습니다.");
	    	    }
	    	    
	    	    return;
	    		
	    //==========================================================================================
	    		
	    	default :
	    		break;
	    }
	    
	    // 디스패처 방식 포워딩(재요청)
	 	RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
	 	dispatch.forward(request, response);
	 		
	 } // doHandle 메소드
	
	
}
