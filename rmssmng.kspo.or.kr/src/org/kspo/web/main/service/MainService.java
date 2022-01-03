package org.kspo.web.main.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.main.dao.MainDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author SCY
 * @FileName : MainService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * </pre>
 */
@Service("mainService")
public class MainService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private MainDAO mainDAO;
	
	/**
	 * 대시보드  - 업무분야별
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPartCount(KSPOMap paramMap) throws Exception {
		return mainDAO.selectPartCount(paramMap);
	} 
	
	/**
	 * 대시보드  - 사용자계정 신규신청 및 승인대기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectApplyCount(KSPOMap paramMap) throws Exception {
		return mainDAO.selectApplyCount(paramMap);
	} 
	
	/**
	 * 대시보드  - 복무만료 대상자
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectExprMmCount(KSPOMap paramMap) throws Exception {
		return mainDAO.selectExprMmCount(paramMap);
	} 
}
