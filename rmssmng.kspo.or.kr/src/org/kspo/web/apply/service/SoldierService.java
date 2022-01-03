package org.kspo.web.apply.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.web.apply.dao.SoldierDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 04.
 * @Author SCY
 * @FileName : SoldierService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 04. SCY : 최초작성
 * </pre>
 */
@Service("soldierService")
public class SoldierService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private SoldierDAO soldierDAO;

	/**
	 * 체육요원 편입신청 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectSoldierSelectList(KSPOMap paramMap) throws Exception {
		return soldierDAO.selectSoldierSelectList(paramMap);
	}

	/**
	 * 체육요원 편입신청 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectSoldierSelectExcelList(KSPOMap paramMap)throws Exception {
		return soldierDAO.selectSoldierSelectExcelList(paramMap);
	}
	
	/**
	 * 체육요원 편입신청 임시저장 - 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertSoldierSelect(KSPOMap paramMap) throws Exception {
		return soldierDAO.insertSoldierSelect(paramMap);
	}

	/**
	 * 체육요원 편입신청 임시저장 - 수정
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public int updateSoldierSelect(KSPOMap paramMap) throws Exception {
		return soldierDAO.updateSoldierSelect(paramMap);
	}

	/**
	 * 체육요원 편입신청 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectSoldierSelectDetail(KSPOMap paramMap) throws Exception {
		return soldierDAO.selectSoldierSelectDetail(paramMap);
	} 

	/**
	 * 체육요원 편입신청 문체부승인내역 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectSoldierSelectAcptDetail(KSPOMap paramMap) throws Exception {
		return soldierDAO.selectSoldierSelectAcptDetail(paramMap);
	}

	/**
	 * 체육요원 편입신청 임시저장 혹은 신청시 삭제
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public int deleteSoldierSelect(KSPOMap paramMap) throws Exception{
		return soldierDAO.deleteSoldierSelect(paramMap);
	}

	/**
	 * 체육요원 공단 접수처리 처리상태 변경 js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public int updateSoldierSelectReceipt(KSPOMap paramMap) throws Exception{
		return soldierDAO.updateSoldierSelectReceipt(paramMap);
	}
	
	/**
	 * 체육요원 공단 접수내역 접수처리 등록 js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public void txUpdateSoldierSelectReceipt(KSPOMap paramMap) throws Exception {
		
		this.updateSoldierSelectReceipt(paramMap); //접수 상태 변경
		
		this.insertSoldierSelectApplAcpt(paramMap); //편입관리 insert
		
	}

	/**
	 * 체육요원 공단 접수처리 편입관리 insert js
	 * @param paramMap
	 * @return 
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public int insertSoldierSelectApplAcpt(KSPOMap paramMap) throws Exception {
		return soldierDAO.insertSoldierSelectApplAcpt(paramMap);
	}

	/**
	 * 체육요원 공단 접수내역 접수반려 및 취소 js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public void txUpdateSoldierSelectReceiptDelete(KSPOMap paramMap) throws Exception {
		
		this.updateSoldierSelectReceipt(paramMap); //접수 상태 변경
		
		this.updateSoldierSelectApplAcpt(paramMap); //편입관리 insert
		
	}

	/**
	 * 체육요원 공단 접수반려 및 취소 편입관리 update js
	 * @param paramMap
	 * @return 
	 * @return
	 * @throws Exception
	 */
	public int updateSoldierSelectApplAcpt(KSPOMap paramMap) throws Exception {
		return soldierDAO.updateSoldierSelectApplAcpt(paramMap);
	}

	/**
	 * 편입신청 문체부승인 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public void txUpdateSoldierSelectApproval(KSPOMap paramMap) throws Exception {
		
		this.updateApprovalReceipt(paramMap); //접수 상태 변경
		this.updateSoldierSelectApproval(paramMap); //문체부 승인
		
	}

	/**
	 * 편입신청 문체부승인시 편입신청 테이블 수정
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int updateApprovalReceipt(KSPOMap paramMap) throws Exception {
		return soldierDAO.updateApprovalReceipt(paramMap);
	}

	/**
	 * 편입신청 문체부승인 등록 js
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateSoldierSelectApproval(KSPOMap paramMap) throws Exception {
		return soldierDAO.updateSoldierSelectApproval(paramMap);
	}

	/**
	 * 체육요원 복무현황 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectSoldierMngList(KSPOMap paramMap) throws Exception {
		return soldierDAO.selectSoldierMngList(paramMap);
	}
	
	/**
	 * 체육요원 복무현황 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectSoldierMngExcelList(KSPOMap paramMap)throws Exception {
		return soldierDAO.selectSoldierMngExcelList(paramMap);
	}
	
	/**
	 * 체육요원 복무현황 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectSoldierMngDetail(KSPOMap paramMap) throws Exception {
		return soldierDAO.selectSoldierMngDetail(paramMap);
	}

	/**
	 * 체육요원 복무현황 복무만료 혹은 취소 update
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateSolidMngExprApplCnclProc(KSPOMap paramMap) throws Exception {
		return soldierDAO.updateSolidMngExprApplCnclProc(paramMap);
	}
	
	/**
	 * 봉사활동 실적현황
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList recordDtl(KSPOMap paramMap) throws Exception {
		return soldierDAO.recordDtl(paramMap);
	}

}
