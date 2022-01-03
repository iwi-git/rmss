package org.kspo.web.account.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.KSPOList;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : AccHistoryDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * </pre>
 */
@RmssMapper("AccHistoryDAO")
public interface AccHistoryDAO {
	/**
	 * 접속이력 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectAcHsList(KSPOMap paramMap) throws Exception;

	/**
	 * 접속이력 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectAcHsExcelList(KSPOMap paramMap) throws Exception;
	
}
