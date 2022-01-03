package org.kspo.web.stats.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.stats.dao.RecordAllDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 12. 02.
 * @Author SCY
 * @FileName : RecordAllService.java
 * <pre> 공익복무실적 service
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 02. SCY : 최초작성
 * </pre>
 */
@Service("recordAllService")
public class RecordAllService extends EgovAbstractServiceImpl {
	
	//공익복무실적
	@Resource
	private RecordAllDAO recordAllDAO;

	/**
	 * 공익복무실적 목록 - 총괄
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordAllList(KSPOMap paramMap) throws Exception {
		return recordAllDAO.selectRecordAllList(paramMap);
	}

	/**
	 * 공익복무실적 목록 엑셀 조회 - 총괄
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordAllExcelList(KSPOMap paramMap) throws Exception {
		return recordAllDAO.selectRecordAllExcelList(paramMap);
	}
}
