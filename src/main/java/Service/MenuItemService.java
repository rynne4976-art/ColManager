package Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Vo.MenuItemVo;

public class MenuItemService {
	
	private Map<String, List<MenuItemVo>> roleMenuMap;

	public MenuItemService() {
		initializeRoleMenuMap();
	}
	
	private void initializeRoleMenuMap() {
		
		roleMenuMap = new HashMap<>(); 
		
		// 관리자 메뉴
        roleMenuMap.put("관리자", Arrays.asList(
        		
            new MenuItemVo("사용자 관리", "/student/studentManage.bo?center=/view_admin/studentManager/studentManage.jsp", Arrays.asList(
            	new MenuItemVo("학생 등록", "/student/studentManage.bo?center=/view_admin/studentManager/studentManage.jsp"),
                new MenuItemVo("학생 조회", "/student/viewStudentList.do?"),
                
                new MenuItemVo("교수 등록", "/professor/professorAdd.bo?center=/view_admin/professorManager/professoradd.jsp"),
                new MenuItemVo("교수 조회", "/professor/professorquiry.do?center=/view_admin/professorManager/professorinquiry.jsp"),
                
                new MenuItemVo("관리자 등록", "/admin/adminjoin.bo?center=/view_admin/adminManager/adminjoin.jsp"),
                new MenuItemVo("관리자 조회", "/admin/managerview.do?center=/view_admin/adminManager/adminquiry.jsp")
            )),
            
            new MenuItemVo("학사 관리", "/major/MajorInput.do", Arrays.asList(
                new MenuItemVo("학과 관리", "/major/MajorInput.do"),
                new MenuItemVo("학과 수정/삭제", "/major/searchMajor.do"),

            	new MenuItemVo("강의실 등록", "/classroom/roomRegister.bo"),
            	new MenuItemVo("강의실 조회", "/classroom/roomSearch.bo"),
            	
            	new MenuItemVo("수강신청 기간 설정", "/classroom/enrollmentPeriodPage.bo")
            	
            )),
            
            new MenuItemVo("정보 관리", "/Board/list.bo?center=/view_admin/noticeManage.jsp", Arrays.asList(
                new MenuItemVo("공지사항 관리", "/Board/list.bo?center=/view_admin/noticeManage.jsp"),
                new MenuItemVo("학사일정 관리", "/Board/viewSchedule.bo?center=/view_admin/calendarEdit.jsp")
            ))
        ));
        
        // 학생 메뉴
        roleMenuMap.put("학생", Arrays.asList(
            new MenuItemVo("강의실", "/classroom/allAssignNotice.do"),
            new MenuItemVo("마이페이지", "/student/myPage.bo?center=/view_admin/studentManager/myPage.jsp"),
            new MenuItemVo("공지사항", "/Board/list.bo?center=/common/notice/list.jsp"),
            new MenuItemVo("학사일정", "/Board/boardCalendar.bo"),
            new MenuItemVo("중고책방", "/Book/bookpostboard.bo?center=/view_student/booktradingboard.jsp"),
            new MenuItemVo("중고서점 찾아보기", "/Board/bookShopMap.bo")
        ));

        // 교수 메뉴
        roleMenuMap.put("교수", Arrays.asList(
            new MenuItemVo("강의실", "/classroom/classroom.bo?classroomCenter=professorMyCourse.jsp"),
            new MenuItemVo("공지 사항", "/Board/list.bo?center=/common/notice/list.jsp")
        ));
        
	}
	
	
	public String generateMenuHtml (String userRole, String contextPath) {
		
		StringBuilder htmlLoad = new StringBuilder();		
		List<MenuItemVo> menus = roleMenuMap.get(userRole);
		
		if (menus != null) {
	        htmlLoad.append("<ul>");
	        for (MenuItemVo menu : menus) {

	            htmlLoad.append("<li><a href=")
                	.append(contextPath)
	                .append(menu.getPage())
	                .append(">")
	                .append(menu.getName())
	                .append("</a>");

	            if (!menu.getSubMenus().isEmpty()) {
	                htmlLoad.append("<ul>");
	                for (MenuItemVo subMenu : menu.getSubMenus()) {
	                    htmlLoad.append("<li><a href=\"")
	                        .append(contextPath)
	                        .append(subMenu.getPage())
	                        .append("\">")
	                        .append(subMenu.getName())
	                        .append("</a></li>");
	                    
//	                    // 하위 메뉴의 하위 메뉴 처리
//	                    if (!subMenu.getSubMenus().isEmpty()) {
//	                        htmlLoad.append("<ul>");
//	                        for (MenuItemVo subSubMenu : subMenu.getSubMenus()) {
//	                            htmlLoad.append("<li><a href=\"")
//	                                .append(contextPath)
//	                                .append(subSubMenu.getPage())
//	                                .append("\">")
//	                                .append(subSubMenu.getName())
//	                                .append("</a></li>");
//	                        }
//	                        htmlLoad.append("</ul>");
//	                    }
	                    
	                }
	                htmlLoad.append("</ul>");
	            }
	            htmlLoad.append("</li>");
	        }
	        htmlLoad.append("</ul>");
	    }
		
        return htmlLoad.toString();
		
	}
}
