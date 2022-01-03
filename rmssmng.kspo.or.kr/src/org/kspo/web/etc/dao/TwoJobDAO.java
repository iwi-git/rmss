package org.kspo.web.etc.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 26.
 * @Author SCY
 * @FileName : TwoJobDAO.java
 * <pre> 겸직허가신청 DAO
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 26. SCY : 최초작성
 * </pre>
 */
@RmssMapper("twoJobDAO")
public interface TwoJobDAO {

	/**
	 * 겸직허가신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTwoJobList(KSPOMap paramMap) throws Exception;

	/**
	 * 겸직허가신청 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTwoJobExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가 신청 최초 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertTwoJob(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가 신청 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateTwoJob(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가 신청 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectTwoJob(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가신청 공단 담당자 승인/반려
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int twoJobKdConfirm(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가신청 문체부 담당자 승인/반려
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int twoJobMcConfirm(KSPOMap paramMap) throws Exception;
	
	/**
	 * 겸직허가신청 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteTwoJob(KSPOMap paramMap) throws Exception;

}
