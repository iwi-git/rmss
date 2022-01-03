package org.kspo.web.system.menu.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : MenuDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@RmssMapper("MenuDAO")
public interface MenuDAO {

	/**
	 * 메뉴 관리 대메뉴 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMenuMstList(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 소메뉴 조회 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMenuDtlList(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 대메뉴 조회(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectMenuMst(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 소메뉴 조회(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectMenuDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 메뉴 수정(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateMenu(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 메뉴 등록(단건) js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertMenu(KSPOMap paramMap) throws Exception;

	/**
	 * 메뉴 관리 메뉴 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteMenuList(KSPOMap paramMap) throws Exception;

	/**
	 * 권환 관리 권한설정 메뉴 확인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertCheckByAuthMenu(KSPOMap paramMap) throws Exception;

	/**
	 * 회원 권한별 왼쪽 메뉴 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectLeftMenuList() throws Exception;

}
