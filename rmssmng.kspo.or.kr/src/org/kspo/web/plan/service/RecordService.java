package org.kspo.web.plan.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.plan.dao.RecordDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("recordService")
public class RecordService extends EgovAbstractServiceImpl {
	
	@Resource
	private RecordDAO recordDAO;
	
	/**
	 * 실적관리 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList RecordMngSelect(KSPOMap paramMap) throws Exception {
		return recordDAO.RecordMngSelect(paramMap);
	}
	
	/**
	 * 봉사활동 실적 - 체육요원 검색 팝업 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPersonList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectPersonList(paramMap);
	}
	
	/**
	 * 실적 헤더 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectRecordM(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordM(paramMap);
	}
	
	/**
	 * 실적 디테일 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordDList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordDList(paramMap);
	}
	
	public void createRecordDList(KSPOMap paramMap) throws Exception {

		//실적상세 기준 키로 데이터 가공 [VLUN_RECD_D_SN]
		KSPOList insertDetailList = paramMap.getMapInList("VLUN_RECD_D_SN");
		
		KSPOMap rowDMap = null;
		
		for(int i = 0; i < insertDetailList.size(); i++) {
			rowDMap = (KSPOMap) insertDetailList.get(i);
			
			//라디오 버튼에 대해서 DB컬럼과 일치하게 세팅
			rowDMap.put("GIFT_YN", rowDMap.getStrArry("GIFT_YN_" + i)[0]);	//사례비수령여부
			rowDMap.put("ACT_DIST", rowDMap.getStrArry("ACT_DIST_" + i)[0]);	//이동거리
			rowDMap.put("DEDUCTION_CD", rowDMap.getStrArry("DEDUCTION_CD_" + i)[0]);	//식사 및 휴식시간 공제여부
			
		}
		
		paramMap.put("insertDetailList", insertDetailList);
		
	}
	
	/**
	 * 실적등록 - 최초 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txInsertRecord(KSPOMap paramMap) throws Exception {
		
		int insertMCnt = recordDAO.insertRecordMaster(paramMap);
		
		KSPOList insertDetailList = (KSPOList) paramMap.get("insertDetailList");
		
		KSPOMap rowDetailMap = null;
		
		for(int i = 0; i < insertDetailList.size(); i++) {
			
			rowDetailMap = (KSPOMap) insertDetailList.get(i);
			rowDetailMap.put("VLUN_RECD_SN", paramMap.getStr("VLUN_RECD_SN"));
			
			recordDAO.insertRecordDetail(rowDetailMap);
			
		}
		
		return insertMCnt;
	}
	
	/**
	 * 실적등록 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txUpdateRecord(KSPOMap paramMap) throws Exception {
		
		int updateMCnt = recordDAO.updateRecordMaster(paramMap);
		
		KSPOList updateDetailList = (KSPOList) paramMap.get("insertDetailList");
		
		KSPOMap rowDetailMap = null;
		
		for(int i = 0; i < updateDetailList.size(); i++) {
			
			rowDetailMap = (KSPOMap) updateDetailList.get(i);
			
			if("".equals(rowDetailMap.getStr("VLUN_RECD_D_SN"))) {//임시저장후 실적추가버튼 클릭시 신규 건에 대해서 처리
				
				recordDAO.insertRecordDetail(rowDetailMap);
				
			} else {//기존 저장된건에 대한 처리
				
				recordDAO.updateRecordDetail(rowDetailMap);
				
			}
		}
		
		return updateMCnt;
	}
	
	/**
	 * 실적 상세 단건 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteOneRecodDetail(KSPOMap paramMap) throws Exception {
		return recordDAO.deleteOneRecodDetail(paramMap);
	}
	
	/**
	 * 실적 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txDeleteRecord(KSPOMap paramMap) throws Exception {
		
		int deleteDCnt = recordDAO.deleteRecordD(paramMap);
		
		recordDAO.deleteRecordM(paramMap);
		
		return deleteDCnt;
	}
	
	/**
	 * 공단 접수 처리
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txConfrimRecord(KSPOMap paramMap) throws Exception {
		return recordDAO.updateConfirmRecord(paramMap);
	}
	
	/**
	 * 인정시간 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txSaveKdAccept(KSPOMap paramMap) throws Exception {
		
		//실적상세 기준 키로 데이터 가공 [VLUN_RECD_D_SN]
		KSPOList updDetailList = paramMap.getMapInList("VLUN_RECD_D_SN");
		
		KSPOMap rowMap = null;
		
		for(int i = 0; i < updDetailList.size(); i++) {
			rowMap = (KSPOMap) updDetailList.get(i);
			rowMap.put("ADMS_ACT_DIST", rowMap.getStrArry("ADMS_ACT_DIST_" + i)[0]);//봉사지까지 이동거리 라디오버튼 처리
			
			recordDAO.updateRecordDAccept(rowMap);
		}
		
		int updateCntM = recordDAO.updateRecordMAccept(paramMap);
		
		return updateCntM;
	}
	
	/**
	 * 문체부 승인,반려
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txMcConfrimRecord(KSPOMap paramMap) throws Exception {
		return recordDAO.updateMcConfirmRecord(paramMap);
	}
	
	/**
	 * 사후정정 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txSaveAfterAccept(KSPOMap paramMap, KSPOList detailList) throws Exception {
		
		KSPOMap rowMap = null;
		
		for(int i = 0; i < detailList.size(); i++) {
			rowMap = (KSPOMap) detailList.get(i);
			rowMap.put("AFT_ACT_DIST", rowMap.getStrArry("AFT_ACT_DIST_" + i)[0]);//봉사지까지 이동거리 라디오버튼 처리
			
			recordDAO.updateRecordDAfterAccept(rowMap);
		}
		
		int updateCntM = recordDAO.updateRecordMAfterAccept(paramMap);
		
		return updateCntM;
	}
	
	/**
	 * 실적조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordSelectList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordSelectList(paramMap);
	}
	
	/**
	 * 실적평가 리스트 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordEvalList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordEvalList(paramMap);
	}
	
	/**
	 * 복무요원의 분기별 실적조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPersonQtrRecord(KSPOMap paramMap) throws Exception {
		return recordDAO.selectPersonQtrRecord(paramMap);
	}
	
	/**
	 * 실적평가 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txInsertEval(KSPOMap paramMap) throws Exception {
		return recordDAO.insertEval(paramMap);
	}
	
	/**
	 * 부진사유 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txUpdateEvalPoorReason(KSPOMap paramMap) throws Exception {
		return recordDAO.updateEvalPoorReason(paramMap);
	}
	
	/**
	 * 실적평가 단건 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectEval(KSPOMap paramMap) throws Exception {
		return recordDAO.selectEval(paramMap);
	}
	
	/**
	 * 실적평가 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteEval(KSPOMap paramMap) throws Exception {
		return recordDAO.deleteEval(paramMap);
	}
	
	/**
	 * 평가결과등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int txUpdateEvalResult(KSPOMap paramMap) throws Exception {
		return recordDAO.updateEvalResult(paramMap);
	}
	
	/**
	 * 공익복무 실적관리 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordExcelList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordExcelList(paramMap);
	}
	
	/**
	 * 공익복무 실적조회 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectRecordPerExcelList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectRecordPerExcelList(paramMap);
	}
	
	/**
	 * 공익복무 실적평가 - 엑셀데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectEvalExcelList(KSPOMap paramMap) throws Exception {
		return recordDAO.selectEvalExcelList(paramMap);
	}
	
}
