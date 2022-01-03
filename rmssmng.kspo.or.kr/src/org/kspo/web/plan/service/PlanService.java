package org.kspo.web.plan.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.plan.dao.PlanDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("planService")
public class PlanService extends EgovAbstractServiceImpl {

	@Resource
	private PlanDAO planDAO;
	
	/**
	 * 봉사활동 계획 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPlanList(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlanList(paramMap);
	}
	
	/**
	 * 체육요원 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPersonList(KSPOMap paramMap) throws Exception {
		return planDAO.selectPersonList(paramMap);
	}
	
	/**
	 * 체육요원 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPersonInfo(KSPOMap paramMap) throws Exception {
		return planDAO.selectPersonInfo(paramMap);
	}
	
	/**
	 * 대상기관 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPlaceList(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlaceList(paramMap);
	}
	
	/**
	 * 대상기관 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPlace(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlace(paramMap);
	}
	
	/**
	 * 계획관리 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txInsertPlan(KSPOMap paramMap) throws Exception {
		return planDAO.insertPlan(paramMap);
	}
	
	/**
	 * 계획관리 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txUpdatePlan(KSPOMap paramMap) throws Exception {
		return planDAO.updatePlan(paramMap);
	}
	
	/**
	 * 봉사활동 계획 단건 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPlanDetail(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlanDetail(paramMap);
	}
	
	/**
	 * 봉사활동 계획 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txDeletePlan(KSPOMap paramMap) throws Exception {
		return planDAO.deletePlan(paramMap);
	}
	
	/**
	 * 봉사관리 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txConfrimPlan(KSPOMap paramMap) throws Exception {
		return planDAO.confirmPlan(paramMap);
	}
	
	/**
	 * 계획 변경 신청
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txPlanChangeReq(KSPOMap paramMap) throws Exception {
		return planDAO.selectInsertPlan(paramMap);
	}
	
	/**
	 * 공익복무 계획관리 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPlanExcelList(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlanExcelList(paramMap);
	}
	
	/**
	 * 공익복무 계획 기간 일자별로 구해오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPlanDateList(KSPOMap paramMap) throws Exception {
		return planDAO.selectPlanDateList(paramMap);
	}
	
	/**
	 * 공익복무 일괄 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateAllPlanStsJs(KSPOMap paramMap) throws Exception {
		return planDAO.updateAllPlanStsJs(paramMap);
	}
}
