package org.kspo.web.system.auth.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : AuthDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@RmssMapper("AuthDAO")
public interface AuthDAO {

	/**
	 * 권한관리 관리 권한그룹 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectAuthMstList(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한설정 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectAuthDtlList(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한그룹 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectAuthMst(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한설정 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateAuthDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한상세 등록(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertAuthDtlByOne(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한그룹 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertAuthMst(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한그룹 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteAuthMst(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteAuthDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한상세 등록(다건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertAuthDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 관리 권한그룹 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateAuthMst(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 권한상세 삭제된 메뉴 권한삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteAuthDtlByMenu(KSPOMap paramMap) throws Exception;

	/**
	 * 권한관리 권한그룹 기본 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectDefaultAuthMstList(KSPOMap paramMap) throws Exception;

	/**
	 * 해당 메뉴 사용자 권한 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectAuthDtlInfo(KSPOMap paramMap) throws Exception;

	/**
	 * 권한 로그 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertAccessLog(KSPOMap paramMap) throws Exception;

}
