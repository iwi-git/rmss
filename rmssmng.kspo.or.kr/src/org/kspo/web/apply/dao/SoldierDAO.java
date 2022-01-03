package org.kspo.web.apply.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.KSPOList;

/**
 * @Since 2021. 11. 04.
 * @Author SCY
 * @FileName : SoldierDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 04. SCY : 최초작성
 * </pre>
 */
@RmssMapper("soldierDAO")
public interface SoldierDAO {

	/**
	 * 체육요원 편입신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectSoldierSelectList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 편입신청 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectSoldierSelectExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 편입신청 임시저장 - 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertSoldierSelect(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 편입신청 임시저장 - 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateSoldierSelect(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 편입신청 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectSoldierSelectDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 편입신청 문체부승인내역 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectSoldierSelectAcptDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 편입신청 임시저장 혹은 신청시 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteSoldierSelect(KSPOMap paramMap) throws Exception;

	/**
	 * 편입신청 접수 등록 js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	int updateSoldierSelectReceipt(KSPOMap paramMap) throws Exception;

	/**
	 * 편입신청 접수처리 insert
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	int insertSoldierSelectApplAcpt(KSPOMap paramMap) throws Exception;

	/**
	 * 편입신청 접수반려 및 취소 update js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	int updateSoldierSelectApplAcpt(KSPOMap paramMap) throws Exception;

	/**
	 * 편입신청 문체부승인 js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	int updateSoldierSelectApproval(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 복무현황 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectSoldierMngList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 복무현황 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectSoldierMngExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 복무현황 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectSoldierMngDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 편입신청 문체부승인시 편입신청 테이블 수정
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateApprovalReceipt(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 복무현황 복무만료 혹은 취소 update
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateSolidMngExprApplCnclProc(KSPOMap paramMap) throws Exception;

	/**
	 * 봉사활동 실적현황
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList recordDtl(KSPOMap paramMap) throws Exception;

}
