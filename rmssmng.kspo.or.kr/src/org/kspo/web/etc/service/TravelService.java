package org.kspo.web.etc.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.etc.dao.TravelDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 15.
 * @Author SCY
 * @FileName : TravelService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. SCY : 최초작성
 * </pre>
 */
@Service("travelService")
public class TravelService extends EgovAbstractServiceImpl {
	
	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private TravelDAO travelDAO;

	/**
	 * 체육요원 국외여행 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelSelectList(KSPOMap paramMap) throws Exception {
		return travelDAO.selectTravelSelectList(paramMap);
	}
	
	/**
	 * 체육요원 국외여행 목록 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelSelectExcelList(KSPOMap paramMap) throws Exception {
		return travelDAO.selectTravelSelectExcelList(paramMap);
	}
	
	/**
	 * 체육요원 국외여행 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTravelDetail(KSPOMap paramMap) throws Exception {
		return travelDAO.selectTravelDetail(paramMap);
	}

	/**
	 * 선택한 체육요원 국외여행정보 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelInfoList(KSPOMap paramMap) throws Exception {
		return travelDAO.selectTravelInfoList(paramMap);
	}

	/**
	 * 체육요원 편입신청 임시저장 - 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void txInsertTravel(KSPOMap paramMap)throws Exception {
		 this.insertTravel(paramMap);
		 this.insertTravelRecd(paramMap);
	}
	public int insertTravel(KSPOMap paramMap) throws Exception {
		return travelDAO.insertTravel(paramMap);
	}

	public int insertTravelRecd(KSPOMap paramMap) throws Exception {
		return travelDAO.insertTravelRecd(paramMap);
	}

	/**
	 * 체육요원 편입신청 임시저장 - 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void txUpdateTravel(KSPOMap paramMap)throws Exception {
		 this.updateTravel(paramMap);
		 
		 if(!"".equals(paramMap.getStr("RECD_SN"))) {
			 this.updateTravelRecd(paramMap);
		 }else {
			 //this.deleteTravelRecd(paramMap); 
			 this.insertTravelRecd(paramMap);
		 }
		 
	}
	public int updateTravel(KSPOMap paramMap) throws Exception {
		return travelDAO.updateTravel(paramMap);
	}
	public int updateTravelRecd(KSPOMap paramMap) throws Exception {
		return travelDAO.updateTravelRecd(paramMap);
	}

	/**
	 * 체육요원 극외여행 여행정보 상세 불러오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTravelInfoDetail(KSPOMap paramMap) throws Exception {
		return travelDAO.selectTravelInfoDetail(paramMap);
	}

	/**
	 * 체육요원 선택된 국외여행정보 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTravelRecd(KSPOMap paramMap) throws Exception {
		return travelDAO.deleteTravelRecd(paramMap);
	}

	/**
	 * 체육요원 국외여행정보 신청 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void txDeleteTravelJs(KSPOMap paramMap) throws Exception {
		this.deleteTravelRecd(paramMap);
		this.deleteTravel(paramMap);
	}

	/**
	 * 체육요원 국외여행정보 신청 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTravel(KSPOMap paramMap) throws Exception {
		return travelDAO.deleteTravel(paramMap);
	}

	/**
	 * 체육요원 국외여행 공단 접수 혹은 반려 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTravelReceipt(KSPOMap paramMap) throws Exception {
		return travelDAO.updateTravelReceipt(paramMap);
	}

	/**
	 * 체육요원 국외여행 공단 승인 혹은 미승인 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTravelApproval(KSPOMap paramMap) throws Exception {
		return travelDAO.updateTravelApproval(paramMap);
	}

}
