package org.kspo.web.account.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.account.dao.VlunPlaceDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 23.
 * @Author SCY
 * @FileName : VlunPlaceService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 23. SCY : 최초작성
 * </pre>
 */
@Service("vlunPlaceService")
public class VlunPlaceService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private VlunPlaceDAO vlunPlaceDAO;
	
	/**
	 * 공익복무처 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectVlunPlaceList(KSPOMap paramMap) throws Exception {
		return vlunPlaceDAO.selectVlunPlaceList(paramMap);
	}
	
	/**
	 * 공익복무처 목록 엑셀 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectVlunPlaceExcelList(KSPOMap paramMap) throws Exception {
		return vlunPlaceDAO.selectVlunPlaceExcelList(paramMap);
	}

	/**
	 * 공익복무처 상세
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectVlunPlaceDetail(KSPOMap paramMap) throws Exception {
		return vlunPlaceDAO.selectVlunPlaceDetail(paramMap);
	}
	/**
	 * 공익복무처 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertVlunPlace(KSPOMap paramMap) throws Exception {
		return vlunPlaceDAO.insertVlunPlace(paramMap);
	}

	/**
	 * 공익복무처 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateVlunPlace(KSPOMap paramMap) throws Exception {
		return vlunPlaceDAO.updateVlunPlace(paramMap);
	}

}
