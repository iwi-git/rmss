package org.kspo.web.etc.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.etc.dao.TransferDAO;
import org.springframework.stereotype.Service;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * @Since 2021. 11. 09. 
 * @Author UGW
 * @FileName : TransferService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 09. UGW : 최초작성
 * </pre>
 */
@Service("transferService")
public class TransferService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());
	
	@Resource
	private TransferDAO transferDAO;

	/**
	 * 신상이동신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTransferList(KSPOMap paramMap) throws Exception {
		return transferDAO.selectTransferList(paramMap);
	}
	
	/**
	 * 신상이동신청 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTransferDetail(KSPOMap paramMap) throws Exception {
		return transferDAO.selectTransferDetail(paramMap);
	}

	/**
	 * 체육요원 단건 상세조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPersonInfo(KSPOMap paramMap) throws Exception {
		return transferDAO.selectPersonInfo(paramMap);
	}
	
	/**
	 * 신상이동신청 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertTransfer(KSPOMap paramMap) throws Exception {
		return transferDAO.insertTransfer(paramMap);
	}

	/**
	 * 신상이동신청 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTransfer(KSPOMap paramMap) throws Exception {
		return transferDAO.updateTransfer(paramMap);
	}

	/**
	 * 신상이동신청 임시저장 혹은 신청시 삭제
	 * @param paramMap
	 * @return 
	 * @throws Exception
	 */
	public int deleteTransfer(KSPOMap paramMap) throws Exception {
		return transferDAO.deleteTransfer(paramMap);
	}

	/**
	 * 신상이동신청 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txConfirmTransfer(KSPOMap paramMap) throws Exception {
		return transferDAO.confirmTransfer(paramMap);
	}

	/**
	 * 신상이동신청 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTransferExcelList(KSPOMap paramMap)throws Exception {
		return transferDAO.selectTransferExcelList(paramMap);
	}
	
	
	
	
	
}
