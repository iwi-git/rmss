package org.kspo.web.main.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.KSPOList;

/**
 * @Since 2021. 3. 15.
 * @Author SCY
 * @FileName : MainDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * </pre>
 */
@RmssMapper("MainDAO")
public interface MainDAO {
	/**
	 * 대시보드 - 업무분야별
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPartCount(KSPOMap paramMap) throws Exception;
	
	/**
	 * 대시보드  - 사용자계정 신규신청 및 승인대기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectApplyCount(KSPOMap paramMap) throws Exception;
	
	/**
	 * 대시보드  - 복무만료 대상자
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectExprMmCount(KSPOMap paramMap) throws Exception;
}
