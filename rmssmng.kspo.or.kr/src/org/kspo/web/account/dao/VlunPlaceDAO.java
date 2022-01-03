package org.kspo.web.account.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 23.
 * @Author SCY
 * @FileName : VlunPlaceDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 23. SCY : 최초작성
 * </pre>
 */
@RmssMapper("vlunPlaceDAO")
public interface VlunPlaceDAO {

	/**
	 * 공익복무처 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectVlunPlaceList(KSPOMap paramMap) throws Exception;

	/**
	 * 공익복무처 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectVlunPlaceExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무처 상세
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectVlunPlaceDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 공익복무처 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertVlunPlace(KSPOMap paramMap) throws Exception;

	/**
	 * 공익복무처 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateVlunPlace(KSPOMap paramMap) throws Exception;

}
