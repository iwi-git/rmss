package org.kspo.web.plan.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

@RmssMapper("RecordDAO")
public interface RecordDAO {
	
	/**
	 * 실적관리 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList RecordMngSelect(KSPOMap paramMap) throws Exception;
	
	/**
	 * selectPersonList
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPersonList(KSPOMap paramMap) throws Exception;
		
	/**
	 * 실적관리 헤더 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertRecordMaster(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적관리 디테일 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertRecordDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적관리 헤더 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordMaster(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적관리 디테일 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적 헤더 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectRecordM(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적 디테일 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordDList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적 상세 단건 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteOneRecodDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적 마스터 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteRecordM(KSPOMap paramMap) throws Exception;

	/**
	 * 실적 디테일 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteRecordD(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공단 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateConfirmRecord(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공단 인정 시간 수정 디테일
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordDAccept(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공단 인정 시간 수정 헤더
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordMAccept(KSPOMap paramMap) throws Exception;
	
	/**
	 * 문체부 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateMcConfirmRecord(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordSelectList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 사후정정 디테일
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordDAfterAccept(KSPOMap paramMap) throws Exception;
	
	/**
	 * 사후정정 마스터
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateRecordMAfterAccept(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적평가 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordEvalList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 복무요원의 분기별 실적 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPersonQtrRecord(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적평가 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertEval(KSPOMap paramMap) throws Exception;
	
	int updateEvalPoorReason(KSPOMap paramMap) throws Exception;
	
	/**
	 * 부진사유 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateEval(KSPOMap paramMap) throws Exception;
	
	/**
	 * 실적 평가 상세보기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectEval(KSPOMap paramMap) throws Exception;
	
	/**
	 * 평과결과등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateEvalResult(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 실적관리 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 실적조회 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectRecordPerExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공익복무 실적평가 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectEvalExcelList(KSPOMap paramMap) throws Exception;
	
	int deleteEval(KSPOMap paramMap) throws Exception;
}
