package org.kspo.web.account.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.account.dao.AccHistoryDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : AccHystoryService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 04. JHH : 최초작성
 * </pre>
 */
@Service("AccHistoryService")
public class AccHistoryService extends EgovAbstractServiceImpl{
	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private AccHistoryDAO accHistoryDAO;
	
	/**
	 * 접속이력 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAcHsList(KSPOMap paramMap) throws Exception {
		return accHistoryDAO.selectAcHsList(paramMap);
	}

	/**
	 * 접속이력 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectAcHsExcelList(KSPOMap paramMap) throws Exception {
		return accHistoryDAO.selectAcHsExcelList(paramMap);
	}
	
}
