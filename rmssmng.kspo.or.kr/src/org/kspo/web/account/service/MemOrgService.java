package org.kspo.web.account.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.account.dao.MemOrgDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 16.
 * @Author JHH
 * @FileName : MemOrgService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 16. JHH : 최초작성
 * </pre>
 */
@Service("MemOrgService")
public class MemOrgService extends EgovAbstractServiceImpl{
	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private MemOrgDAO memOrgDAO;
	
	/**
	 * 체육단체 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMemOrgList(KSPOMap paramMap) throws Exception {
		return memOrgDAO.selectMemOrgList(paramMap);
	}
	
	/**
	 * 체육단체 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMemOrgExcelList(KSPOMap paramMap) throws Exception {
		return memOrgDAO.selectMemOrgExcelList(paramMap);
	}
	
	/**
	 * 체육단체 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectMemOrgDetail(KSPOMap paramMap) throws Exception {
		return memOrgDAO.selectMemOrgDetail(paramMap);
	}

	/**
	 * 체육단체 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertMemOrg(KSPOMap paramMap) throws Exception {
		return memOrgDAO.insertMemOrg(paramMap);
	}

	/**
	 * 체육단체 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateMemOrg(KSPOMap paramMap) throws Exception {
		return memOrgDAO.updateMemOrg(paramMap);
	}

}
