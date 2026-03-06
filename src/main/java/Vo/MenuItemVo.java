package Vo;

import java.util.ArrayList;
import java.util.List;

// top.jsp와 sidebar.jsp에서 페이지 이동을 효율적으로 하기 위한 Vo 클래스
public class MenuItemVo {
	
	private String name;
	private String page;
	private List<MenuItemVo> subMenus;
	
	// 하위 메뉴가 없는 경우 -> 네비게이션 바
	public MenuItemVo(String name, String page) {
		this.name = name;
		this.page = page;
		this.subMenus = new ArrayList<>();
	}
	
	// 생성자 (하위 메뉴 포함하는 경우) -> 사이드 바
    public MenuItemVo(String name, String page, List<MenuItemVo> subMenus) {
        this.name = name;
        this.page = page;
        this.subMenus = subMenus;
    }

    
    // getter, setter
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public List<MenuItemVo> getSubMenus() {
		return subMenus;
	}

	public void setSubMenus(List<MenuItemVo> subMenus) {
		this.subMenus = subMenus;
	}
    
    

}
