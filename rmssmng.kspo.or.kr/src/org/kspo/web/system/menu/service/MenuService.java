package org.kspo.web.system.menu.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.menu.dao.MenuDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : MenuService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service("menuService")
public class MenuService extends EgovAbstractServiceImpl{

	private static Logger log = LoggerFactory.getLogger(MenuService.class);
	
	@Resource
	private MenuDAO menuDAO;
	
	private static KSPOList LeftMenu;
	
	/**
	 * 메뉴 관리 대메뉴 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMenuMstList(KSPOMap paramMap)throws Exception {
		return menuDAO.selectMenuMstList(paramMap);
	}

	/**
	 * 메뉴 관리 소메뉴 조회 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMenuDtlList(KSPOMap paramMap)throws Exception {
		return menuDAO.selectMenuDtlList(paramMap);
	}

	/**
	 * 메뉴 관리 대메뉴 조회(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectMenuMst(KSPOMap paramMap)throws Exception {
		return menuDAO.selectMenuMst(paramMap);
	}

	/**
	 * 메뉴 관리 소메뉴 조회(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectMenuDtl(KSPOMap paramMap)throws Exception {
		return menuDAO.selectMenuDtl(paramMap);
	}

	/**
	 * 메뉴 관리 메뉴 수정(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateMenu(KSPOMap paramMap)throws Exception {
		return menuDAO.updateMenu(paramMap);
	}

	/**
	 * 메뉴 관리 메뉴 등록(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertMenu(KSPOMap paramMap)throws Exception {
		return menuDAO.insertMenu(paramMap);
	}

	/**
	 * 메뉴 관리 메뉴 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteMenuList(KSPOMap paramMap)throws Exception {
		return menuDAO.deleteMenuList(paramMap);
	}

	/**
	 * 권환 관리 권한설정 메뉴 확인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertCheckByAuthMenu(KSPOMap paramMap)throws Exception {
		return menuDAO.insertCheckByAuthMenu(paramMap);
	}

	/**
	 * 회원 권한별 왼쪽 메뉴 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectLeftMenuList() throws Exception {
		return menuDAO.selectLeftMenuList();
	}

	/**
	 * 메뉴 호출
	 * @return
	 */
	public KSPOList getLeftMenu() {
		return LeftMenu;
	}

	/**
	 * 메뉴 저장
	 * @param leftMenu
	 */
	public void setLeftMenu(KSPOList leftMenu) {
		LeftMenu = leftMenu;
	}
	
}
