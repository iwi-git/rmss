package org.kspo.web.etc.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 09.
 * @Author UGW
 * @FileName : TransferDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 09. UGW : 최초작성
 * </pre>
 */
@RmssMapper("transferDAO")
public interface TransferDAO {

	/**
	 * 신상이동신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTransferList(KSPOMap paramMap);

	/**
	 * 신상이동신청 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectTransferDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 단건 상세조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPersonInfo(KSPOMap paramMap) throws Exception;
	
	/**
	 * 신상이동신청 임시저장 - 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertTransfer(KSPOMap paramMap) throws Exception;

	/**
	 * 신상이동신청 임시저장 - 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateTransfer(KSPOMap paramMap) throws Exception;

	/**
	 * 신상이동신청 임시저장 혹은 신청시 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteTransfer(KSPOMap paramMap) throws Exception;

	/**
	 * 신상이동신청 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int confirmTransfer(KSPOMap paramMap) throws Exception;

	/**
	 * 신상이동신청 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTransferExcelList(KSPOMap paramMap) throws Exception;
	
	
	
}
