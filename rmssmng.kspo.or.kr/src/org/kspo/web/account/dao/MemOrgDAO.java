package org.kspo.web.account.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.KSPOList;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : MemOrgDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * </pre>
 */
@RmssMapper("MemOrgDAO")
public interface MemOrgDAO {
	/**
	 * 체육단체 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMemOrgList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMemOrgExcelList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectMemOrgDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertMemOrg(KSPOMap paramMap) throws Exception;

	/**
	 * 체육단체 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateMemOrg(KSPOMap paramMap) throws Exception;

}
