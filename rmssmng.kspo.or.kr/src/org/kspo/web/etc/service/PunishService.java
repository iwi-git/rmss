package org.kspo.web.etc.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.etc.dao.PunishDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 11. 22.
 * @Author SCY
 * @FileName : PunishService.java
 * <pre> 징계관리 service
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. SCY : 최초작성
 * </pre>
 */
@Service("punishService")
public class PunishService extends EgovAbstractServiceImpl {
	
	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private PunishDAO punishDAO;

	/**
	 * 체육요원 징계 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPunishSelectList(KSPOMap paramMap) throws Exception {
		return punishDAO.selectPunishSelectList(paramMap);
	}

	/**
	 * 체육요원 징계 목록 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectPunishSelectExcelList(KSPOMap paramMap) throws Exception {
		return punishDAO.selectPunishSelectExcelList(paramMap);
	}
	
	/**
	 * 체육요원 징계 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectPunishDetail(KSPOMap paramMap) throws Exception {
		return punishDAO.selectPunishDetail(paramMap);
	}

	
	/**
	 * 체육요원 징계 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertPunish(KSPOMap paramMap) throws Exception {
		return punishDAO.insertPunish(paramMap);
	}

	/**
	 * 체육요원 징계 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updatePunish(KSPOMap paramMap) throws Exception {
		return punishDAO.updatePunish(paramMap);
	}

	/**
	 * 체육요원 징계 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deletePunishJs(KSPOMap paramMap) throws Exception {
		return punishDAO.deletePunishJs(paramMap);
	}

	/**
	 * 체육요원 징계 확정일시 복무만료일 +5연장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateApplExprDt(KSPOMap paramMap) throws Exception {
		return punishDAO.updateApplExprDt(paramMap);
	}

	/**
	 * 체육요원 징계 등록 트랜잭션
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void txInsertPunish(KSPOMap paramMap) throws Exception {
		
		this.insertPunish(paramMap);
		if("PC".equals(paramMap.getStr("DSPL_STS"))){ //징계 확정이면 복무일 5일 미뤄짐
			this.updateApplExprDt(paramMap);
		}
		
	}

	/**
	 * 체육요원 징계 수정 트랜잭션
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void txUpdatePunish(KSPOMap paramMap) throws Exception {
		
		this.updatePunish(paramMap);
		if("PC".equals(paramMap.getStr("DSPL_SN"))){ //징계 확정이면 복무일 5일 미뤄짐
			this.updateApplExprDt(paramMap);
		}
		
	}

}
