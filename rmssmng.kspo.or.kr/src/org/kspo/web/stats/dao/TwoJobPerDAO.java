package org.kspo.web.stats.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

@RmssMapper("twoJobPerDAO")
public interface TwoJobPerDAO {
	/**
	 * 겸직허가신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTwoJobPerList(KSPOMap paramMap) throws Exception;

	/**
	 * 겸직허가신청 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTwoJobPerExcelList(KSPOMap paramMap) throws Exception;
}
