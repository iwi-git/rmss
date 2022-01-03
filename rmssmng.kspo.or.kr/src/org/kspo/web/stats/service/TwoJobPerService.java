package org.kspo.web.stats.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.stats.dao.TwoJobPerDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 30.
 * @Author SCY
 * @FileName : TwoJobPerService.java
 * <pre> 겸직허가신청현황 service
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 30. JHH : 최초작성
 * </pre>
 */
@Service("twoJobPerService")
public class TwoJobPerService extends EgovAbstractServiceImpl {
	@Resource
	private TwoJobPerDAO twoJobPerDAO;

	/**
	 * 겸직허가신청현황 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTwoJobPerList(KSPOMap paramMap) throws Exception {
		return twoJobPerDAO.selectTwoJobPerList(paramMap);
	}

	/**
	 * 겸직허가신청현황 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTwoJobPerExcelList(KSPOMap paramMap) throws Exception {
		return twoJobPerDAO.selectTwoJobPerExcelList(paramMap);
	}
}
