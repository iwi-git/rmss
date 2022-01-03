package org.kspo.web.stats.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

@RmssMapper("recordPerDAO")
public interface RecordPerDAO {
	
	/**
	 * 공익복무실적 - 개인 조회[헤더]
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectRecordPer(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무실적 - 개인 조회[상세리스트]
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordPerList(KSPOMap paramMap) throws Exception;

}
