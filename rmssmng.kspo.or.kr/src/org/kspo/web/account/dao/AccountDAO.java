package org.kspo.web.account.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 24.
 * @Author SCY
 * @FileName : AccountDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 24. SCY : 최초작성
 * </pre>
 */
@RmssMapper("accountDAO")
public interface AccountDAO {

	/**
	 * 체육단체 계정 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAccountList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 계정 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAccountExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectAccountDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 계정 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateAccount(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 비밀번호 초기화
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateChangePwAccount(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 상태 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateAcntStsAccount(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 계정 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteAccount(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 가입된 계정 조회(체육단체, 이름, 휴대폰)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int selectAccountInfo(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 가입된 계정 확인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectAccountCICheck(KSPOMap paramMap) throws Exception;

	/**
	 * 사용자ID 중복확인
	 * @param mngrId
	 * @return
	 * @throws Exception
	 */
	int selectAccountIdCheck(String mngrId) throws Exception;

	/**
	 * 사용자계정 정보
	 * @param mngrId
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAccountDtl(KSPOMap paramMap) throws Exception;
	
	
	/**
	 * 체육단체 계정 탈퇴 - 계정 정보 이동
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertResignAccountJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 탈퇴 - 계정 정보 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteResignAccountJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 휴면 해제 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertAcntStsKyAccount(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육단체 계정 휴면 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteAcntStsKuAccount(KSPOMap paramMap) throws Exception;
}
