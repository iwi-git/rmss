package org.kspo.web.system.code.service;

import java.util.Map;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.code.dao.CodeDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : CodeService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. SCY
 * </pre>
 */
@Service("codeService")
public class CodeService extends EgovAbstractServiceImpl{
	
	@Resource
	private CodeDAO codeDAO;
	
	/**
	 * 공통코드 관리 대분류 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectCodeMstList(KSPOMap paramMap) throws Exception {
		return codeDAO.selectCodeMstList(paramMap);
	}

	/**
	 * 공통코드 관리 소분류 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectCodeDtlList(KSPOMap paramMap) throws Exception {
		return codeDAO.selectCodeDtlList(paramMap);
	}

	/**
	 * 공통코드 관리 대분류 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectCodeMst(KSPOMap paramMap) throws Exception {
		return codeDAO.selectCodeMst(paramMap);
	}

	/**
	 * 공통코드 관리 소분류 조회(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectCodeDtl(KSPOMap paramMap) throws Exception {
		return codeDAO.selectCodeDtl(paramMap);
	}

	/**
	 * 공통코드 관리 대분류 수정(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateCodeMst(KSPOMap paramMap) throws Exception {
		return codeDAO.updateCodeMst(paramMap);
	}

	/**
	 * 공통코드 관리 소분류 수정(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateCodeDtl(KSPOMap paramMap) throws Exception {
		return codeDAO.updateCodeDtl(paramMap);
	}

	/**
	 * 공통코드 관리 대분류 등록(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 * 
	 * 대분류 코드 채번 :  L + ###
	 */
	public int insertCodeMst(KSPOMap paramMap) throws Exception {
		return codeDAO.insertCodeMst(paramMap);
	}

	/**
	 * 공통코드 관리 소분류 등록(단건)
	 * @param paramMap
	 * @return
	 * @throws Exception
	 * 소분류 코드 채번 : 대분류 코드 + ###
	 */
	public int insertCodeDtl(KSPOMap paramMap) throws Exception {
		return codeDAO.insertCodeDtl(paramMap);
	}

	/**
	 * 공통코드 관리 대분류 삭제
	 * @param paramMap
	 * @throws Exception
	 */
	public void txDeleteCodeMstList(KSPOMap paramMap) throws Exception {
		this.deleteCodeMstList(paramMap);
		this.deleteCodeDtlMstList(paramMap);//대분류 삭제 후 소분류 삭제 진행
	}
	
	/**
	 * 공통코드 관리 대분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteCodeMstList(KSPOMap paramMap) throws Exception {
		return codeDAO.deleteCodeMstList(paramMap);
	}
	
	/**
	 * 공통코드 관리 대분류 삭제 후 소분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteCodeDtlMstList(KSPOMap paramMap) throws Exception {
		return codeDAO.deleteCodeDtlMstList(paramMap);
	}

	/**
	 * 공통코드 관리 소분류 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCodeDtlList(KSPOMap paramMap) throws Exception {
		return codeDAO.deleteCodeDtlList(paramMap);
	}

	/**
	 * 기본 공통코드 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectCmmnDtlList(KSPOMap paramMap)throws Exception {
		return codeDAO.selectCmmnDtlList(paramMap);
	}

	/**
	 * 등록된 코드인지 확인
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int selectCodeDtlCheck(KSPOMap paramMap) throws Exception {
		return codeDAO.selectCodeDtlCheck(paramMap);
	}
	
	/**
	 * 2019 ~ 올해 연도 +1 조회
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectNextYearList() throws Exception {
		return codeDAO.selectNextYearList();
	}

	/**
	 * 2019 ~ 올해 연도 조회
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectYearList() throws Exception {
		return codeDAO.selectYearList();
	}

	/**
	 * 월 조회
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMonthList() throws Exception {
		return codeDAO.selectMonthList();
	}

	/**
	 * 올해년월 조회
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectBasicYM() throws Exception {
		return codeDAO.selectBasicYM();
	}

	/**
	 * 오늘날짜, -7일전 날짜 조회 
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectTodaySevenday() throws Exception {
		return codeDAO.selectTodaySevenday();
	}

	/**
	 * 인코딩
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public String selectGetEnc(String str) throws Exception {
		return codeDAO.selectGetEnc(str);
	}
	
	/**
	 * 디코딩
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public String selectGetDec(String str) throws Exception {
		return codeDAO.selectGetDec(str);
	}
	
	/**
	 * 체육단체 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectMemOrgInfoList(KSPOMap paramMap) throws Exception {
		return codeDAO.selectMemOrgInfoList(paramMap);
	}

	/**
	 * 종목 공통코드 조회
	 * @param cmmnSn,gameCd
	 * @return
	 */
	public KSPOList selectCmmnAltCodeList(String CMMN_SN, String ALT_CODE) throws Exception {
		KSPOMap cmmnMap = new KSPOMap();
		cmmnMap.put("CMMN_SN", CMMN_SN);
		cmmnMap.put("ALT_CODE", ALT_CODE);
		
		return codeDAO.selectCmmnAltCodeList(cmmnMap);
		
	}
	
}
