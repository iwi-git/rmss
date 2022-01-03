package org.kspo.web.history.service;

import org.kspo.framework.util.KSPOMap;
import org.kspo.web.history.dao.HistoryDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : HistoryService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service("historyService")
public class HistoryService extends EgovAbstractServiceImpl {

	@Autowired
	private HistoryDAO historyDAO;

	/**
	 * 권한상세 이력 등록
	 * @param paramMap
	 * @throws Exception
	 */
	public void insertAuthDtlHis(KSPOMap paramMap) throws Exception {
		historyDAO.insertAuthDtlHis(paramMap);
	}

	/**
	 * 권한그룹 이력 등록
	 * @param paramMap
	 * @throws Exception
	 */
	public void insertAuthMstHis(KSPOMap paramMap) throws Exception {
//		historyDAO.insertAuthMstHis(paramMap);
	}

}
