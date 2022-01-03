
package org.kspo.web.system.user.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.user.dao.UserDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : UserService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service("userService")
public class UserService extends EgovAbstractServiceImpl{

	@Resource
	private UserDAO userDAO;
	
	/**
	 * 사용자 관리 사용자 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectUserList(KSPOMap paramMap) throws Exception {
		return userDAO.selectUserList(paramMap);
	}

	/**
	 * 사용자 관리 사용자 상세 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateUserDtl(KSPOMap paramMap) throws Exception {
		return userDAO.updateUserDtl(paramMap);
	}

	/**
	 * 사용자 관리 사용자 상세 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertUserDtl(KSPOMap paramMap) throws Exception {
		return userDAO.insertUserDtl(paramMap);
	}

	/**
	 * 사용자 관리 사용자 상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteUserDtl(KSPOMap paramMap)throws Exception {
		return userDAO.deleteUserDtl(paramMap);
	}

	/**
	 * 사용자 관리 사용자 비밀번호 초기화
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateMngrPassword(KSPOMap paramMap) throws Exception {
		return userDAO.updateMngrPassword(paramMap);
	}

	/**
	 * 사용자 정보 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectUserInfo(KSPOMap paramMap) throws Exception {
		return (KSPOMap) userDAO.selectUserInfo(paramMap);
	}

	/**
	 * 비밀번호 오류 횟수 수정(증가)
	 * @param paramMap
	 * @throws Exception
	 */
	public void updateLoginErrCntAdd(KSPOMap paramMap) throws Exception {
		userDAO.updateLoginErrCntAdd(paramMap);
	}

	/**
	 * 비밀번호 오류 횟수 수정(초기화) 및 로그인 시간 체크
	 * @param paramMap
	 * @throws Exception
	 */
	public void updateLoginErrCntReset(KSPOMap paramMap) throws Exception {
		userDAO.updateLoginErrCntReset(paramMap);
	}

	/**
	 * 비밀번호 초기화 및  최초 로그인 시 비밀번호 변경
	 * @param paramMap
	 * @throws Exception
	 */
	public void updatePasswordChange(KSPOMap paramMap) throws Exception {
		userDAO.updateMngrPassword(paramMap);
	}

	/**
	 * 사용자 관리 사용자 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectUserDtlList(KSPOMap paramMap) throws Exception {
		return userDAO.selectUserDtlList(paramMap);
	}

	/**
	 * 사용자 정보 패스워트 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectUserChk(KSPOMap paramMap) throws Exception {
		return (KSPOMap) userDAO.selectUserChk(paramMap);
	}
	
	/**
	 * 로그인한 회원정보 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectloginUserDtlList(KSPOMap paramMap) throws Exception {
		return userDAO.selectloginUserDtlList(paramMap);
	}
	
}
