package org.kspo.web.system.user.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : UserDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@RmssMapper("UserDAO")
public interface UserDAO {

	/**
	 * 사용자 관리 사용자 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectUserList(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 관리 사용자 상세 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateUserDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 관리 사용자 상세 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertUserDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 관리 사용자 상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteUserDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 관리 사용자 비밀번호 초기화
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateMngrPassword(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 정보 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectUserInfo(KSPOMap paramMap) throws Exception;

	/**
	 * 비밀번호 오류 횟수 수정(증가)
	 * @param paramMap
	 * @throws Exception
	 */
	void updateLoginErrCntAdd(KSPOMap paramMap) throws Exception;

	/**
	 * 비밀번호 오류 횟수 수정(초기화)및 로그인 시간 체크
	 * @param paramMap
	 * @throws Exception
	 */
	void updateLoginErrCntReset(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 관리 사용자 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectUserDtlList(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자 정보 패스워드 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectUserChk(KSPOMap paramMap) throws Exception;

	/**
	 * 로그인한 회원정보 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectloginUserDtlList(KSPOMap paramMap) throws Exception;
	
}
