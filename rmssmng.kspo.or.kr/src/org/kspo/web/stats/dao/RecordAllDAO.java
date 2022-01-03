package org.kspo.web.stats.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

@RmssMapper("recordAllDAO")
public interface RecordAllDAO {
	/**
	 * 공익복무실적 목록 - 총괄
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordAllList(KSPOMap paramMap) throws Exception;

	/**
	 * 공익복무실적 목록 엑셀 조회 - 총괄
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordAllExcelList(KSPOMap paramMap) throws Exception;
}

