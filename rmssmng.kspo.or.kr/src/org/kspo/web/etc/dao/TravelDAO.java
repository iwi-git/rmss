package org.kspo.web.etc.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 15.
 * @Author SCY
 * @FileName : TravelDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. SCY : 최초작성
 * </pre>
 */
@RmssMapper("travelDAO")
public interface TravelDAO {

	/**
	 * 체육요원 국외여행 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelSelectList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 국외여행 목록 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelSelectExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 선택한 체육요원 국외여행정보 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTravelInfoList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 국외여행 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTravelDetail(KSPOMap paramMap) throws Exception;


	/**
	 * 체육요원 편입신청 임시저장 - 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertTravel(KSPOMap paramMap) throws Exception;
	public int insertTravelRecd(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 편입신청 임시저장 - 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTravel(KSPOMap paramMap) throws Exception;
	public int updateTravelRecd(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 극외여행 여행정보 상세 불러오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTravelInfoDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 선택된 국외여행정보 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTravelRecd(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 국외여행정보 신청 삭제 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTravel(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 국외여행 공단 접수 혹은 반려 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTravelReceipt(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 국외여행 공단 승인 혹은 미승인 js
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateTravelApproval(KSPOMap paramMap) throws Exception;

}
