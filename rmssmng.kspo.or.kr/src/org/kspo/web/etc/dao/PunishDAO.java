package org.kspo.web.etc.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 11. 22.
 * @Author SCY
 * @FileName : PunishDAO.java
 * <pre> 징계관리 DAO
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 22. SCY : 최초작성
 * </pre>
 */
@RmssMapper("punishDAO")
public interface PunishDAO {

	/**
	 * 체육요원 징계 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPunishSelectList(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 징계 목록 엑셀다운로드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectPunishSelectExcelList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 체육요원 징계 상세 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectPunishDetail(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 징계 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertPunish(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 징계 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updatePunish(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 징계 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deletePunishJs(KSPOMap paramMap) throws Exception;

	/**
	 * 체육요원 징계 확정일시 복무만료일 +5연장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateApplExprDt(KSPOMap paramMap) throws Exception;

}
