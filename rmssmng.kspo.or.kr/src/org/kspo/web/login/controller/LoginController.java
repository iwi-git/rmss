package org.kspo.web.login.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.global.SystemConst;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.SessionUtil;
import org.kspo.framework.util.Sha256Util;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.account.service.AccountService;
import org.kspo.web.sms.service.SmsService;
import org.kspo.web.system.user.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 11. 01.
 * @Author 
 * @FileName : LoginController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 01.  : 최초작성
 * 
 * </pre>
 */
@Controller
@RequestMapping("/login")
public class LoginController extends BaseController{

	private static Logger log = LoggerFactory.getLogger(LoginController.class);

	//사용자관리
	@Resource
	private UserService userService;
	
	//SMS
	@Resource
	private SmsService smsService;
	
	//체육단체 계정관리
	@Resource
	private AccountService accountService;

	/**
	 * 로그인 화면
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.kspo")
	public String login(ReqMap reqMap,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		SessionUtil.clearSession(request);

		String idSave = "";

		Cookie[] getCookie = request.getCookies();
		if(getCookie != null) {
			for (int i = 0; i < getCookie.length; i++) {
				Cookie cookie = getCookie[i];
				String name   = cookie.getName();
				String value  = cookie.getValue();
				if("idSave".equals(name)) {
					idSave = this.getDec(value);
				}
			}
		}

		model.addAttribute("idSave", idSave);
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("telList",this.cmmnDtlList("202111050000334")); //전화

		return "web/login/login";
	}

	/**
	 * 로그아웃
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/logout.kspo")
	public String logout(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		SessionUtil.clearSession(request);
		return "redirect:/login/login.kspo";
	}

	/**
	 * 로그인 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/loginActJs.kspo")
	public String loginActJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		Map<String,Object> resultMap = new HashMap<String,Object>();
		KSPOMap paramMap  = reqMap.getReqMap();

		try {

			if("".equals(paramMap.getStr("MNGR_ID")) || "".equals(paramMap.getStr("PASSWORD"))) {
				resultMap = this.getErrMessage("LOGIN","98");
			}else {

				KSPOMap userInfo = userService.selectUserInfo(paramMap);//회원 정보 조회

				String loginDataCheck = this.loginDataCheck(userInfo, paramMap);//회원 정보 조회 확인
				
					if(!"0".equals(loginDataCheck)) {
						if("98".equals(loginDataCheck)) {
							userService.updateLoginErrCntAdd(paramMap);
						}
						resultMap = this.getErrMessage("LOGIN", loginDataCheck);
	
					}else {
	
						userService.updateLoginErrCntReset(paramMap);//비밀번호 오류 카운트 초기화 및 로그인 시간 체크
						SessionUtil.setUserInfoSession(userInfo, request);	//화원정보 저장
						SessionUtil.setUserInfoCookie(paramMap, userInfo, request, response);	//화원정보 저장
	
	
						resultMap.put("resultCode","0");
					}
			}
		}catch (Exception e) {
			e.printStackTrace();
			log.error("\n{}",e.getMessage());
			resultMap = this.getErrMessage("LOGIN", "99");
		}

		model.addAttribute("result", resultMap);

		return "jsonView";
	}


	/**
	 * 비밀번호 확인
	 * @param userInfo
	 * @param paramMap
	 * @return
	 */
	private String loginDataCheck(KSPOMap userInfo, KSPOMap paramMap) throws Exception {

		String dbPassword 	= userInfo.getStr("PASSWORD"); //DB 조회된 비밀번호
		String PASSWORD     = Sha256Util.encryptSHA256(paramMap.getStr("PASSWORD")); //입력한 비밀번호
		String ACNT_STS 	= userInfo.getStr("ACNT_STS"); //계정상태
		String GRP_SN 		= userInfo.getStr("GRP_SN");
		
		if("TA".equals(ACNT_STS)){ //승인요청중인 아이디
			return "93";
		}else if("KN".equals(ACNT_STS)){ //승인거부된 아이디
			return "92";
		}else if("KX".equals(ACNT_STS)){ //정지된 아이디
			return "96";
		}else if("KH".equals(ACNT_STS)){ //휴면계정 아이디
			return "100";
		}else if("KU".equals(ACNT_STS)){ //탈퇴한 아이디
			return "101";
		}
		
		if("1".equals(GRP_SN)) {
			if(userInfo.isEmpty()) {//회원 정보 조회
				return "98";
			}
			if(!"Y".equals(userInfo.getStr("USE_YN"))) {//회원 정보 사용 여부 확인
				return "96";
			}
			if(!PASSWORD.equals(dbPassword)) {
				return "98";
			}
			if(userInfo.getInt("LOGIN_ERR_CNT") > 4) {//로그인 에러 카운트 확인
				if(userInfo.getInt("LOGIN_ERR_LIMIT") < SystemConst._LOGIN_INTERVAL_LIMIT) {//5분전 에러
					return "97";
				}
			}
		}else {
			KSPOMap userInfoPwdChk = userService.selectUserChk(paramMap);//회원 정보 조회
					
			if(userInfoPwdChk == null) {//회원 정보 조회
				return "98";
			}else {
				if("Y".equals(userInfo.getStr("DEL_YN"))) {//회원 정보 삭제 여부 확인
					return "91";
				}
				if(!"Y".equals(userInfo.getStr("USE_YN"))) {//회원 정보 사용 여부 확인
					return "96";
				}
				if(userInfo.getInt("LOGIN_ERR_COUNT") > 4) {//로그인 에러 카운트 확인
					if(userInfo.getInt("LOGIN_ERR_LIMIT") < SystemConst._LOGIN_INTERVAL_LIMIT) {//5분전 에러
						return "97";
					}
				}
			}
			
			String E_PASSWORD = userInfoPwdChk.getStr("PASSWORD");
			String E_MNGR_ID  = userInfoPwdChk.getStr("E_MNGR_ID");
			
			if(E_MNGR_ID.equals(E_PASSWORD)) {
				return "95";
			}
		}

		
		
		return "0";
	}

	/**
	 * 비밀번호 초기화 및  최초 로그인 시 비밀번호 변경
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePasswordChangeJs.kspo")
	public String updatePasswordChangeJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap  = reqMap.getReqMap();
		try {

			String PASSWORD = paramMap.getStr("PASSWORD");
			String MNGR_ID = paramMap.getStr("MNGR_ID");

			if("".equals(MNGR_ID) || "".equals(PASSWORD)) {
				resultMap = this.getErrMessage("LOGIN", "99");
			}else if(MNGR_ID.equals(PASSWORD)) {
				resultMap = this.getErrMessage("LOGIN", "94");
			}else {

				userService.updatePasswordChange(paramMap);
				resultMap.put("resultCode","0");	
			}

		}catch (Exception e) {
			e.printStackTrace();
			log.error("\n{}",e.getMessage());
			resultMap = this.getErrMessage("LOGIN", "99");
		}

		model.addAttribute("result", resultMap);

		return "jsonView";
	}
	
	/**
	 * 중복 아이디 확인
	 * @param 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/selectIdCheckJs.kspo")
	public String selectIdCheckJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		int selectAccountIdCheck = accountService.selectAccountIdCheck(paramMap.getStr("JOIN_MNGR_ID"));
		
		if(selectAccountIdCheck > 0) {
			resultMap.put("resultCode","1");
		}else {
			resultMap.put("resultCode","0");
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}
	
	/**
	 * 회원가입 계정 신청
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value = "/insertJoinJs.kspo")
	public String insertJoinJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		int selectAccountIdCheck = accountService.selectAccountIdCheck(paramMap.getStr("JOIN_MNGR_ID"));
		
		if(selectAccountIdCheck > 0) {
			resultMap.put("resultCode","1");
		}else {
			
			int password = this.passwordDataCheck(paramMap);
			if(password == 0) {
					
				paramMap.put("PASSWORD",paramMap.get("JOIN_PASSWORD"));
				paramMap.put("MNGR_ID",paramMap.getStr("JOIN_MNGR_ID"));
				
				paramMap.put("CI", SessionUtil.getSession(request, "S_CERT_CI"));
				paramMap.put("DI", SessionUtil.getSession(request, "S_CERT_DI"));
				
				int userDtl =userService.insertUserDtl(paramMap);
				
				if(userDtl == 1) {
					resultMap.put("resultCode","0");
				}else {
					resultMap.put("resultCode","5");
				}
				
			}else if(password == 1) {
				resultMap.put("resultCode","2");
			}else if(password == 2) {
				resultMap.put("resultCode","3");
			}else if(password  == 3) {
				resultMap.put("resultCode","4");
			}
			
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}
	
	/**
	 * 비밀번호 체크
	 * @param userInfo
	 * @param paramMap
	 * @return
	 */
	private int passwordDataCheck(KSPOMap paramMap) throws Exception {

		String dbPassword 	= paramMap.getStr("JOIN_PASSWORD"); //입력한 비번
		String dbPassword2 	= paramMap.getStr("JOIN_PASSWORD2"); //입력한 비번 재확인
		
		String p1 = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?^&])[A-Za-z[0-9]$@$!%*#?^&]{10,16}$";
		
		Matcher m = Pattern.compile(p1).matcher(dbPassword);
		
		if(!dbPassword.equals(dbPassword2)) {
			return 1;
		}else if(!m.find()) {
			return 2;
		}else if(dbPassword.contains(" ")) {
			return 3;
		}

		return 0;
	}
	
	/**
	 * 체육단체 가입된 계정 CI 확인
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccountCICheckJs.kspo")
	public String selectAccountCICheckJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectAccountCICheck = accountService.selectAccountCICheck(paramMap);
		
		if(selectAccountCICheck != null) {
			resultMap.put("resultCode","1");
		}else {
			resultMap.put("resultCode","0");
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}

	/**
	 * 체육단체 가입된 계정 조회(체육단체, 이름, 휴대폰)
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccountInfoJs.kspo")
	public String selectAccountInfoJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap = reqMap.getReqMap();
		
		String CPNO = paramMap.getStr("CPNO1") + paramMap.getStr("CPNO2") + paramMap.getStr("CPNO3");
		
		paramMap.put("CPNO",CPNO);
		
		
		int acountInfo = accountService.selectAccountInfo(paramMap);
		
		if(acountInfo > 0) {
			resultMap.put("resultCode","0");
		}else {
			resultMap.put("resultCode","1");
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육단체 계정조회 및 비밀번호 랜덤 
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMngrInfoPwResetJs.kspo")
	public String selectMngrInfoPwResetJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectAccountCICheck = accountService.selectAccountCICheck(paramMap);
		
		if(selectAccountCICheck != null) {

			//임시 비밀번호 생성
			String strTempPwd = StringUtil.getRandomValue("C", 8);
			
			//임시 비밀번호를 암호화하여 업데이트한다.
			paramMap.put("PASSWORD", StringUtil.nullToBlank(strTempPwd));
			
			paramMap.put("MNGR_ID",selectAccountCICheck.getStr("MNGR_ID"));
			
			userService.updateMngrPassword(paramMap);
			
			if(!"".equals(selectAccountCICheck.getStr("CPNO"))) {
				/**********************
				 * SMS 전송처리 시작
				 **********************/
				/**********************
				 * SMS 전송처리
				 * 필수 패러미터
				 * USERCODE		: 유저코드
				 * REQNAME		: 발송자명
				 * REQPHONE		: 회신번호
				 * CALLNAME		: 수신자명
				 * CALLPHONE	: 수신번호
				 * MSG			: 메세지내용
				 * TEMPLATECODE	: 알림톡 템플릿 코드
				 **********************/
				
				KSPOMap smsMap  = reqMap.getReqMap();
				
				String pMsg = "[체육요원복무관리시스템] \r\n" + 
						"안녕하세요. 국민체육진흥공단입니다.\r\n" + 
						"임시비밀번호 #{변수}가 발급되었습니다. \r\n" + 
						"임시비밀번호로 로그인 후 비밀번호를 변경하시기 바랍니다. 감사합니다.";
				
				pMsg = pMsg.replace("#{변수}", paramMap.getStr("PASSWORD"));
				
				smsMap.put("usercode", PropertiesUtil.getString("USERCODE"));
				smsMap.put("deptcode",PropertiesUtil.getString("DEPTCODE"));
				smsMap.put("yellowidKey",PropertiesUtil.getString("YELLOWKEY"));
				smsMap.put("reqname","국민체육진흥공단");
				smsMap.put("reqphone",PropertiesUtil.getString("REQPHONE"));
				smsMap.put("callname",selectAccountCICheck.getStr("MNGR_NM"));
				smsMap.put("callphone",selectAccountCICheck.getStr("CPNO"));
				smsMap.put("EMP_NO",paramMap.getStr("MNGR_ID"));
				smsMap.put("msg",pMsg); //문자내용
				smsMap.put("templatecode","rmss_002"); //템플릿 코드
				
				smsService.insertSms(smsMap);
				smsService.insertSmsLog(smsMap);
			}
			/**********************
			 * SMS 전송처리 종료
			 **********************/
			
			resultMap.put("resultCode","0");
			
		}else {
			resultMap.put("resultCode","1");
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}
	
}
