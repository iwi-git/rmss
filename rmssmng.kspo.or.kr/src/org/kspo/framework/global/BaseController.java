package org.kspo.framework.global;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.ServerUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.system.code.service.CodeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : BaseController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
public class BaseController {

	private static Logger log = LoggerFactory.getLogger(BaseController.class);

	//코드관리
	@Resource
	private CodeService codeService;
	

	/**
	 * 에러코드와 프로퍼티 메시지를 MAP 형태로 가공한다.
	 * @param errCode
	 * @return
	 */
	protected KSPOMap getErrMessage(String errCode) {
		return this.getErrMessage(null,errCode);
	}
	
	/**
	 * 에러코드와 프로퍼티 메시지를 MAP 형태로 가공한다.
	 * @param errCode
	 * @param errType
	 * @return
	 */
	protected KSPOMap getErrMessage(String errType, String errCode) {
		
		String errMsg = "ERROR_" + errCode;
		if(!StringUtil.isEmpty(errType)) {
			errMsg = errType + "_ERROR_" + errCode;
		}

		KSPOMap errMap = new KSPOMap();
		errMap.put("resultCode", errCode);
		errMap.put("resultMsg", PropertiesUtil.getString(errMsg));
		
		return errMap;
	}
	

	protected KSPOMap getErrMessage(String errCode, Exception e, HttpServletRequest request) {
		return getErrMessage(null, errCode, e, request);
	}
	
	protected KSPOMap getErrMessage(String errType, String errCode, Exception e, HttpServletRequest request) {
		KSPOMap errMap = getErrMessage(errType, errCode);
		
		KSPOMap paramMap  = new KSPOMap(request);
		String clientIp = paramMap.getStr(SystemConst._ClIENT_IP);
		String uri = paramMap.getStr(SystemConst._SERV_URI);
		String ip = (String)ServerUtil.getLocalServerIp();
		log.error("\n############################################################################################################"
				+ "\n" + "SERVER IP : " + ip + ""
			    + "\nclientIp : " + clientIp 
			    + "\nuri : " + uri + ""
			    + "\ncontent : " + e.toString() + ""
	    		+ "\nparameters : " + paramMap.toString() + ""
			    + "\ntrace : " + makeStackTrace(e) + ""
			    + "\n############################################################################################################");
		
		StringBuffer sb = new StringBuffer();
		sb.append("**EXCEPTION_LOG_MSG**");
		sb.append("<br/> SERV ADDR : " + ip + uri);
		sb.append("<br/> ERROR MSG : " + makeStackTrace(e).replace("\n", "<br>") );
		
		errMap.put("exceptionMsg", e.getMessage());
		errMap.put("exceptionCont", sb.toString());
		
		return errMap;
	}
	
	private String makeStackTrace(Throwable t) {
		if (t == null) return "";
		
		try {
			ByteArrayOutputStream bout = new ByteArrayOutputStream();
			t.printStackTrace(new PrintStream(bout));
			bout.flush();
			String error = new String(bout.toByteArray());

			return error;
		} catch(Exception ex) {			
			return "";
		}
	}
	
	/**
	 * 기본 공통코드 조회
	 * @param cmmnSn
	 * @return
	 */
	protected KSPOList cmmnDtlList(String cmmnSn) throws Exception {
		return this.cmmnDtlList(cmmnSn, "O");
	}
	
	/**
	 * 기본 공통코드 조회
	 * @param cmmnSn
	 * @param orderType
	 * @return
	 */
	protected KSPOList cmmnDtlList(String cmmnSn, String orderType) throws Exception {
		return this.cmmnDtlList(cmmnSn, orderType, true);
	}
	
	/**
	 * 기본 공통코드 조회
	 * @param cmmnSn
	 * @param orderType(O:ORD,CF:CNTNT_FST,CS:CNTNT_SND,RF:REFR_FST,RS:REFR_SND)
	 * @param order (true:asc,false:desc)
	 */
	protected KSPOList cmmnDtlList(String cmmnSn, String orderType, Boolean order) throws Exception {
		
		KSPOList selectCmmnDtlList = new KSPOList();
		
		if(!StringUtil.isEmpty(cmmnSn)) {
			KSPOMap cmmnMap = new KSPOMap();
			cmmnMap.put("CMMN_SN", cmmnSn);
			cmmnMap.put("orderType", orderType);
			String ord = "desc";
			if(order) {
				ord = "asc";
			}
			cmmnMap.put("order",ord);
			selectCmmnDtlList = codeService.selectCmmnDtlList(cmmnMap);
		}
		
		return selectCmmnDtlList;
	}

	/**
	 * 올해년월 조회
	 * @return
	 * @throws Exception
	 */
	protected KSPOMap basicYM() throws Exception {
		return codeService.selectBasicYM();
	}
	
	/**
	 * 2019 ~ 올해 연도 조회
	 * @return
	 * @throws Exception
	 */
	protected KSPOList yearList() throws Exception {
		return codeService.selectYearList();
	}
	
	/**
	 * 2019 ~ 올해 연도 +1 조회
	 * @return
	 * @throws Exception
	 */
	protected KSPOList nextYearList() throws Exception {
		return codeService.selectNextYearList();
	}

	/**
	 * 월 조회
	 * @return
	 * @throws Exception
	 */
	protected KSPOList monthList() throws Exception {
		return codeService.selectMonthList();
	}

	/**
	 * 오늘날짜, -7일전 날짜 조회 
	 * @return
	 * @throws Exception
	 */
	protected KSPOMap selectTodaySevenday() throws Exception {
		return codeService.selectTodaySevenday();
	}
	
	/**
	 * 인코딩
	 * @return
	 * @throws Exception
	 */
	protected String getEnc(String str) throws Exception {
		return codeService.selectGetEnc(str);
	}
	
	/**
	 * 디코딩
	 * @return
	 * @throws Exception
	 */
	protected String getDec(String str) throws Exception {
		return codeService.selectGetDec(str);
	}

	/**
	 * 체육단체 조회
	 * @param memOrgList
	 * @param 
	 * @param 
	 */
	protected KSPOList memOrgList(KSPOMap paramMap) throws Exception {
		
		KSPOList selectMemOrgInfoList = new KSPOList();
		
		selectMemOrgInfoList = codeService.selectMemOrgInfoList(paramMap);
				
		return selectMemOrgInfoList;
	}
	
	
	/**
	 * 현재일자의 분기 구하기
	 * @return
	 * @throws Exception
	 */
	protected String getCurrentQtr() throws Exception {
		
		Date today = new Date();
		
		SimpleDateFormat monthFormat = new SimpleDateFormat ("MM");
		
		int currMonth = Integer.parseInt(monthFormat.format(today));
		
		return String.valueOf(Math.round(Math.ceil(currMonth / 3.0)));
		
	}
	
	/**
	 * 종목 공통코드 조회
	 * @param cmmnSn,gameCd
	 * @return
	 */
	protected KSPOList cmmnAltCodeList(String CMMN_SN, String ALT_CODE) throws Exception {
		return codeService.selectCmmnAltCodeList(CMMN_SN, ALT_CODE);
	}
}
