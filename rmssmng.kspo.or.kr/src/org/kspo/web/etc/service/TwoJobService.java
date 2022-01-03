package org.kspo.web.etc.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.etc.dao.PunishDAO;
import org.kspo.web.etc.dao.TwoJobDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 26.
 * @Author SCY
 * @FileName : TwoJobService.java
 * <pre> 겸직허가신청 service
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 26. SCY : 최초작성
 * </pre>
 */
@Service("twoJobService")
public class TwoJobService extends EgovAbstractServiceImpl {
	
	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private TwoJobDAO twoJobDAO;

	/**
	 * 겸직허가신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTwoJobList(KSPOMap paramMap) throws Exception {
		return twoJobDAO.selectTwoJobList(paramMap);
	}

	/**
	 * 겸직허가신청 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTwoJobExcelList(KSPOMap paramMap) throws Exception {
		return twoJobDAO.selectTwoJobExcelList(paramMap);
	}
	
	/**
	 * 겸직허가신청 최초저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txInsertTwoJob(KSPOMap paramMap) throws Exception {
		return twoJobDAO.insertTwoJob(paramMap);
	}
	
	/**겸직허가신청 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txUpdateTwoJob(KSPOMap paramMap) throws Exception {
		return twoJobDAO.updateTwoJob(paramMap);
	}
	
	/**
	 * 겸직허가신청 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTwoJob(KSPOMap paramMap) throws Exception {
		return twoJobDAO.selectTwoJob(paramMap);
	}
	
	/**
	 * 겸직허가신청 공단 담당자 승인/반려
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txTwoJobKdConfirm(KSPOMap paramMap) throws Exception {
		return twoJobDAO.twoJobKdConfirm(paramMap);
	}
	
	/**
	 * 겸직허가신청 문체부 담당자 승인/반려
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txTwoJobMcConfirm(KSPOMap paramMap) throws Exception {
		return twoJobDAO.twoJobMcConfirm(paramMap);
	}
	
	/**
	 * 겸직허가신청 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txDeleteTwoJob(KSPOMap paramMap) throws Exception {
		return twoJobDAO.deleteTwoJob(paramMap);
	}

}
