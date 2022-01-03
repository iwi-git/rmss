package org.kspo.web.system.code.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : CodeDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. SCY
 * </pre>
 */
@RmssMapper("CodeDAO")
public interface CodeDAO {

	/**
	 * 공통코드 관리 대분류 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectCodeMstList(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 소분류 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectCodeDtlList(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 대분류 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectCodeMst(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 소분류 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectCodeDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 대분류 수정(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateCodeMst(KSPOMap paramMap)throws Exception;

	/**
	 * 공통코드 관리 소분류 수정(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateCodeDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 대분류 등록(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertCodeMst(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 소분류 등록(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertCodeDtl(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 대분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteCodeMstList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 공통코드 관리 소분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteCodeDtlMstList(KSPOMap paramMap) throws Exception;

	/**
	 * 공통코드 관리 소분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteCodeDtlList(KSPOMap paramMap) throws Exception;

	/**
	 * 기본 공통코드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectCmmnDtlList(KSPOMap paramMap)throws Exception;

	/**
	 * 시도 조회
	 * @return
	 * @throws Exception
	 */
	KSPOList selectCmmnSidoList() throws Exception;

	/**
	 * 시군구 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectCmmnSignguList(KSPOMap paramMap) throws Exception;

	/**
	 * 등록된 코드인지 확인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int selectCodeDtlCheck(KSPOMap paramMap) throws Exception;
	
	/**
	 * 2019 ~ 올해 연도 +1 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectNextYearList() throws Exception;
	
	/**
	 * 2019 ~ 올해 연도 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectYearList() throws Exception;

	/**
	 * 월 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMonthList() throws Exception;

	/**
	 * 올해년월 조회
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectBasicYM() throws Exception;

	/**
	 * 올해년도 조회
	 * @return
	 * @throws Exception
	 */
	String selectBasicYear() throws Exception;

	/**
	 * 오늘날짜, -7일전 날짜 조회
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectTodaySevenday() throws Exception;

	/**
	 * 인코딩
	 * @param str
	 * @return
	 * @throws Exception
	 */
	String selectGetEnc(String str) throws Exception;
	
	/**
	 * 디코딩
	 * @param str
	 * @return
	 * @throws Exception
	 */
	String selectGetDec(String str) throws Exception;
	
	/**
	 * 체육단체 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectMemOrgInfoList(KSPOMap paramMap) throws Exception;

	/**
	 * 기본 공통코드 조회
	 * @param cmmnSn
	 * @param GAME_CD
	 * @param GAME_CD
	 */
	KSPOList selectCmmnAltCodeList(KSPOMap paramMap) throws Exception;

}
