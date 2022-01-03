package org.kspo.web.owncert.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.SessionUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.framework.util.WebUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 12. 06. SCY
 * @Author 
 * @FileName : OwnCertController.java
 * <pre> 본인인증 컨트롤러
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 06. SCY  : 최초작성
 * 
 * </pre>
 */
@Controller
@RequestMapping("/owncert")
public class OwnCertController {
	

	//로그 출력 객체
	private static Logger log = LoggerFactory.getLogger(OwnCertController.class);
	
	protected String CHECKPLUS_SITE_CODE	= PropertiesUtil.getString("CHECKPLUS_SITE_CODE");
	protected String CHECKPLUS_SITE_PWD 	= PropertiesUtil.getString("CHECKPLUS_SITE_PWD");

	
	
	/**
	 * 휴대폰 본인인증 화면
	 * @param ownCertVo
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkplusMain.kspo")
	public String checkplusMain(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		try {
			NiceID.Check.CPClient niceCheck = new  NiceID.Check.CPClient();
			
			paramMap.put("REQ_SEQ",niceCheck.getRequestNO(CHECKPLUS_SITE_CODE));
			SessionUtil.setSession(request, "REQ_SEQ", paramMap.getStr("REQ_SEQ"));			//해킹등의 방지를 위하여 세션을 쓴다면, 세션에 요청번호를 넣는다.
			
			paramMap.put("returnType",paramMap.getStr("returnType"));
			paramMap.put("AUTH_TYPE","");  			//없으면 기본 선택화면, M: 핸드폰, C: 신용카드, X: 공인인증서
			paramMap.put("POPUP_GUBUN","N");			//Y : 취소버튼 있음 / N : 취소버튼 없음
			paramMap.put("CUSTOMIZE","");				//없으면 기본 웹페이지 / Mobile : 모바일페이지
			paramMap.put("RTN_URL",request.getRequestURL().substring(0, request.getRequestURL().indexOf("/", 2))+"//"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath() + "/owncert/checkplusSuccess.kspo");
			paramMap.put("ERR_URL",request.getRequestURL().substring(0, request.getRequestURL().indexOf("/", 2))+"//"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath() + "/owncert/checkplusFail.kspo");
			
			// 입력될 plain 데이타를 만든다.
			String sPlainData = "7:REQ_SEQ" + paramMap.getStr("REQ_SEQ").getBytes().length + ":" + paramMap.getStr("REQ_SEQ") +
								"8:SITECODE" + CHECKPLUS_SITE_CODE.getBytes().length + ":" + CHECKPLUS_SITE_CODE +
								"9:AUTH_TYPE" + paramMap.getStr("AUTH_TYPE").getBytes().length + ":" + paramMap.getStr("AUTH_TYPE") +
								"7:RTN_URL" + paramMap.getStr("RTN_URL").getBytes().length + ":" + paramMap.getStr("RTN_URL") +
								"7:ERR_URL" + paramMap.getStr("ERR_URL").getBytes().length + ":" + paramMap.getStr("ERR_URL") +
								"9:customize" + paramMap.getStr("CUSTOMIZE").getBytes().length + ":" + paramMap.getStr("CUSTOMIZE");
			 
			int iReturn = niceCheck.fnEncode(CHECKPLUS_SITE_CODE, CHECKPLUS_SITE_PWD, sPlainData);
			
			model.addAttribute("certInfo", paramMap);
			
			if( iReturn == 0 ) {
				
				paramMap.put("ENCODE_DATA",niceCheck.getCipherData());
				model.addAttribute("ENCODE_DATA",niceCheck.getCipherData());
			
			} else if( iReturn == -1) {
				WebUtil.ajaxPrintMsg(response, request, "암호화 시스템 에러입니다.", "");
				return null;
			} else if( iReturn == -2) {
				WebUtil.ajaxPrintMsg(response, request, "암호화 처리오류입니다.", "");
				return null;
			} else if( iReturn == -3) {
				WebUtil.ajaxPrintMsg(response, request, "암호화 데이터 오류입니다.", "");
				return null;
			} else if( iReturn == -9) {
				WebUtil.ajaxPrintMsg(response, request, "입력 데이터 오류입니다.", "");
				return null;
			} else {
				WebUtil.ajaxPrintMsg(response, request, "알수 없는 에러 입니다. iReturn : " + iReturn, "");
				return null;
			}
			
		} catch(Exception e) {
			
			log.debug(e.getMessage());
			
		}
		
		return "web/owncert/checkplus_main";
	}
	
	/**
	 * 휴대폰 본인인증 성공
	 * @param ownCertVo
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkplusSuccess.kspo")
	public String checkplusSuccess(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		KSPOMap paramMap = reqMap.getReqMap();

		String param_r1 = StringUtil.nullToBlank(request.getParameter("param_r1"));

		try {
			NiceID.Check.CPClient niceCheck = new NiceID.Check.CPClient();
			int iReturn = niceCheck.fnDecode(CHECKPLUS_SITE_CODE, CHECKPLUS_SITE_PWD,
					StringUtil.requestReplace(request.getParameter("EncodeData"), "encodeData"));

			if (iReturn == 0) {
				@SuppressWarnings("unchecked")
				HashMap<String, String> mapresult = niceCheck.fnParse(niceCheck.getPlainData());

				paramMap.put("REQ_SEQ", (String) mapresult.get("REQ_SEQ"));
				paramMap.put("RES_SEQ", (String) mapresult.get("RES_SEQ"));
				paramMap.put("AUTH_TYPE", (String) mapresult.get("AUTH_TYPE"));

				if (!paramMap.getStr("REQ_SEQ").equals(SessionUtil.getSession(request, "REQ_SEQ"))) {
					WebUtil.ajaxPrintMsg(response, request, "세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다.", "");
					return null;

				} else {
					String mobile_no = StringUtil.nullToBlank(mapresult.get("MOBILE_NO"));
					String CPNO1 = "";
					String CPNO2 = "";
					String CPNO3 = "";

					StringBuffer mobile_no_buff = new StringBuffer();

					if (mobile_no.length() == 11) {

						CPNO1 = mobile_no.substring(0, 3);
						CPNO2 = mobile_no.substring(3, 7);
						CPNO3 = mobile_no.substring(7);

					} else if (mobile_no.length() == 10) {

						CPNO1 = mobile_no.substring(0, 3);
						CPNO2 = mobile_no.substring(3, 6);
						CPNO3 = mobile_no.substring(6);

					}

					String memb_sex = StringUtil.nullToBlank(mapresult.get("GENDER"));
					if (memb_sex.equals("1")) {
						memb_sex = "M";
					} else if (memb_sex.equals("0")) {
						memb_sex = "F";
					}

					paramMap.put("returnType", param_r1);
					paramMap.put("MNGR_NM", (String) mapresult.get("NAME"));
					paramMap.put("CPNO1", CPNO1);
					paramMap.put("CPNO2", CPNO2);
					paramMap.put("CPNO3", CPNO3);
					paramMap.put("CI", (String) mapresult.get("CI"));
					paramMap.put("DI", (String) mapresult.get("DI"));

					model.addAttribute("certInfo", paramMap);

					// 인증성공 후 인증값을 세션에 보관한다.
					SessionUtil.setSession(request, "S_CERT_NM", mapresult.get("NAME"));
					SessionUtil.setSession(request, "S_CERT_HP", mobile_no_buff.toString());
					SessionUtil.setSession(request, "S_CERT_BIRTHDAY", mapresult.get("BIRTHDATE"));
					SessionUtil.setSession(request, "S_CERT_SEX", memb_sex);
					SessionUtil.setSession(request, "S_CERT_CI", mapresult.get("CI"));
					SessionUtil.setSession(request, "S_CERT_DI", mapresult.get("DI"));
					SessionUtil.setSession(request, "S_CERT_TYPE", "1");

				}

			} else if (iReturn == -1) {
				WebUtil.ajaxPrintMsg(response, request, "복호화 시스템 에러입니다.", "");
				return null;
			} else if (iReturn == -4) {
				WebUtil.ajaxPrintMsg(response, request, "복호화 처리오류입니다.", "");
				return null;
			} else if (iReturn == -5) {
				WebUtil.ajaxPrintMsg(response, request, "복호화 해쉬 오류입니다.", "");
				return null;
			} else if (iReturn == -6) {
				WebUtil.ajaxPrintMsg(response, request, "복호화 데이터 오류입니다.", "");
				return null;
			} else if (iReturn == -9) {
				WebUtil.ajaxPrintMsg(response, request, "입력 데이터 오류입니다.", "");
				return null;
			} else if (iReturn == -12) {
				WebUtil.ajaxPrintMsg(response, request, "사이트 패스워드 오류입니다.", "");
				return null;
			} else {
				WebUtil.ajaxPrintMsg(response, request, "알수 없는 에러 입니다. iReturn : " + iReturn, "");
				return null;
			}

		} catch (Exception e) {

			log.info(e.getMessage());

		}

		return "web/owncert/checkplus_success";
	}
	
	/**
	 * 휴대폰 본인인증 실패
	 * @param ownCertVo
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/checkplusFail.kspo")
	public String checkplusFail(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		KSPOMap paramMap = reqMap.getReqMap();

		String param_r1 = StringUtil.nullToBlank(request.getParameter("param_r1"));

		paramMap.put("ReturnType", param_r1);

		model.addAttribute("ownCert", paramMap);

		return "web/owncert/checkplus_fail";
	}
	
}

