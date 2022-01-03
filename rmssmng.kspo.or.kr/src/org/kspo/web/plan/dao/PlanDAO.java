package org.kspo.web.plan.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

@RmssMapper("PlanDAO")
public interface PlanDAO {
	
	/**
	 * 봉사활동 계획 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPlanList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPersonList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPersonInfo(KSPOMap paramMap) throws Exception;
	
	/**
	 * 대상기관 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPlaceList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 대상기관 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPlace(KSPOMap paramMap) throws Exception;
	
	/**
	 * 계획관리 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertPlan(KSPOMap paramMap) throws Exception;
	
	/**
	 * 계획관리 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updatePlan(KSPOMap paramMap) throws Exception;
	
	/**
	 * 봉사활동 계획 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPlanDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 봉사활동 계획 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deletePlan(KSPOMap paramMap) throws Exception;
	
	/**
	 * 봉사관리 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int confirmPlan(KSPOMap paramMap) throws Exception;
	
	/**
	 * 계획 변경 신청
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectInsertPlan(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 계획관리 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPlanExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 계획관리 - 기간 일자 구하기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPlanDateList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 일괄 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateAllPlanStsJs(KSPOMap paramMap) throws Exception;
}
