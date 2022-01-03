package org.kspo.web.stats.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.stats.dao.RecordPerDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 12. 06.
 * @Author LJW
 * @FileName : RecordPerService.java
 * <pre> 공익복무실적 개인 service
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 06. LJW : 최초작성
 * </pre>
 */
@Service("recordPerService")
public class RecordPerService extends EgovAbstractServiceImpl{

	@Resource
	private RecordPerDAO recordPerDAO;
	
	/**
	 * 공익복무실적 - 개인 조회[헤더]
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectRecordPer(KSPOMap paramMap) throws Exception {
		return recordPerDAO.selectRecordPer(paramMap);
	}
	
	/**
	 * 공익복무실적 - 개인 조회[리스트]
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordPerList(KSPOMap paramMap) throws Exception {
		return recordPerDAO.selectRecordPerList(paramMap);
	}
}
