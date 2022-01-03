package org.kspo.web.history.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;
/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : HistoryDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@RmssMapper("HistoryDAO")
public interface HistoryDAO  {

	/**
	 * 권한상세 이력 등록
	 * @param paramMap
	 * @throws Exception
	 */
	void insertAuthDtlHis(KSPOMap paramMap) throws Exception;

	/**
	 * 권한그룹 이력 등록
	 * @param paramMap
	 * @throws Exception
	 */
	void insertAuthMstHis(KSPOMap paramMap) throws Exception;

}
