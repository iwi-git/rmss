package org.kspo.web.system.auth.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.history.service.HistoryService;
import org.kspo.web.system.auth.dao.AuthDAO;
import org.kspo.web.system.menu.service.MenuService;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : AuthService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service("authService")
public class AuthService extends EgovAbstractServiceImpl{

	@Resource
	private AuthDAO authDAO;

	//이력관리
	@Resource
	private HistoryService historyService;

	//메뉴관리
	@Resource
	private MenuService menuService;
	
	/**
	 * 권한관리 관리 권한그룹 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAuthMstList(KSPOMap paramMap)throws Exception {
		return authDAO.selectAuthMstList(paramMap);
	}

	/**
	 * 권한관리 관리 권한설정 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAuthDtlList(KSPOMap paramMap)throws Exception {
		return authDAO.selectAuthDtlList(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectAuthMst(KSPOMap paramMap) throws Exception {
		return authDAO.selectAuthMst(paramMap);
	}

	/**
	 * 권한관리 관리 권한설정 수정
	 * @param reqList
	 * @param paramMap
	 * @throws Exception
	 */
	public void txUpdateAuthDtl(KSPOList reqList, KSPOMap paramMap) throws Exception{
		
		for(int i=0;i<reqList.size();i++) {
			KSPOMap map = (KSPOMap) reqList.get(i);
			if("I".equals(map.getStr("dataType"))) {
				int insertCheck = menuService.insertCheckByAuthMenu(map);	//권환 관리 권한설정 메뉴 확인
				if(insertCheck == 0) {
					this.insertAuthDtlByOne(map);	
				}
			}else if("U".equals(map.getStr("dataType"))) {
				this.updateAuthDtl(map);
			}
		}
		
		this.deleteAuthDtlByMenu(paramMap);
		
	}
	/**
	 * 권한관리 관리 권한설정 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int updateAuthDtl(KSPOMap paramMap) throws Exception {

		return authDAO.updateAuthDtl(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 등록(단건)
	 * @param paramMap
	 * @return 
	 * @throws Exception
	 */
	private int insertAuthDtlByOne(KSPOMap paramMap)throws Exception {
		return authDAO.insertAuthDtlByOne(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 등록
	 * @param paramMap
	 * @throws Exception
	 */
	public void txInsertAuthMst(KSPOMap paramMap) throws Exception{
		this.insertAuthMst(paramMap);
		this.insertAuthDtl(paramMap);
	}
	/**
	 * 권한관리 관리 권한그룹 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int insertAuthMst(KSPOMap paramMap) throws Exception {
		return authDAO.insertAuthMst(paramMap);
	}

	/**
	 * 권한관리 권한상세 일괄등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int insertAuthDtl(KSPOMap paramMap)throws Exception {
		return authDAO.insertAuthDtl(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 삭제
	 * @param paramMap
	 * @throws Exception
	 */
	public void txDeleteAuthMst(KSPOMap paramMap) throws Exception {
		this.deleteAuthMst(paramMap); 
		this.deleteAuthDtl(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteAuthMst(KSPOMap paramMap)throws Exception {
		return authDAO.deleteAuthMst(paramMap);
	}

	/**
	 * @param paramMap
	 * @throws Exception
	 */
	public void txUpdateAuthMst(KSPOMap paramMap) throws Exception {
		this.updateAuthMst(paramMap);
		historyService.insertAuthMstHis(paramMap);
	}

	/**
	 * 권한관리 관리 권한그룹 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int updateAuthMst(KSPOMap paramMap) throws Exception {
		return authDAO.updateAuthMst(paramMap);
	}

	/**
	 * 권한관리 관리 권한상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteAuthDtl(KSPOMap paramMap) throws Exception {
		return authDAO.deleteAuthDtl(paramMap);
	}

	/**
	 * 권한관리 권한상세 삭제된 메뉴 권한삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteAuthDtlByMenu(KSPOMap paramMap)throws Exception {
		return authDAO.deleteAuthDtlByMenu(paramMap);
	}

	/**
	 * 권한관리 권한그룹 기본 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectDefaultAuthMstList(KSPOMap paramMap) throws Exception {
		return authDAO.selectDefaultAuthMstList(paramMap);
	}

	/**
	 * 해당 메뉴 사용자 권한 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectAuthDtlInfo(KSPOMap paramMap) throws Exception {
		return authDAO.selectAuthDtlInfo(paramMap);
	}
	
	/**
	 * 권한 로그 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertAccessLog(KSPOMap paramMap) throws Exception {
		return authDAO.insertAccessLog(paramMap);
	}


}
