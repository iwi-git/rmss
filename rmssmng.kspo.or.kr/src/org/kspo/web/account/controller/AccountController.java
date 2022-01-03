package org.kspo.web.account.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.account.service.AccountService;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.sms.service.SmsService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : AccountController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * 2021. 11. 25. SCY : 개발
 * </pre>
 */
@Controller
@RequestMapping("/account")
public class AccountController extends BaseController{
protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	//체육단체 계정관리
	@Resource
	private AccountService accountService;

	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;

	//SMS
	@Resource
	private SmsService smsService;
	
	/**
	 * 체육단체 계정 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/AccountSelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("THR_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		KSPOList selectAccountList = accountService.selectAccountList(paramMap);
		
		model.addAttribute("accountList", selectAccountList);
		model.addAttribute("pageInfo",selectAccountList.getPageInfo());//페이지 정보
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("acntStsList",this.cmmnDtlList("202111250000442")); //계정상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("telList",this.cmmnDtlList("202111050000334")); //전화
		 
		return "web/account/AccountSelect";
	}
	
	/**
	 * 체육단체 계정 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/AccountSelectDownload.kspo")
	public void AccountSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육단체 계정 조회
		KSPOList selectAccountExcelList = accountService.selectAccountExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectAccountListExcel(selectAccountExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=Account.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 체육단체 계정 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccountDetailJs.kspo")
	public String selectAccountDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectAccountDetail = accountService.selectAccountDetail(paramMap);
		
		model.addAttribute("detail", selectAccountDetail);
		
		return "jsonView";
	}
	
	/**
	 * 체육단체 계정 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAccountJs.kspo")
	public String updateAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		accountService.updateAccount(paramMap);

		return "jsonView";
	}
	
	/**
	 * 체육단체 계정 비밀번호 초기화 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateChangePwAccountJs.kspo")
	public String updateChangePwAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		accountService.updateChangePwAccount(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육단체 계정 상태 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAcntStsAccountJs.kspo")
	public String updateAcntStsAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		List<String> mstChkList = new ArrayList<String>();
		
		if(paramMap.get("mstChk") instanceof String[]) {
			paramMap.getList("mstChk");
		}else {
			mstChkList.add(paramMap.getStr("mstChk"));
			paramMap.put("mstChk", mstChkList);
		}
		
		accountService.updateAcntStsAccount(paramMap);
		
		/**********************
		 * SMS 전송처리 시작
		 **********************/
		if("KY".equals(paramMap.getStr("ACNT_STS"))) {
			KSPOList selectAccountDtl = accountService.selectAccountDtl(paramMap);
			
			for(int i=0; i < selectAccountDtl.size(); i++) {
				KSPOMap dtlMap = (KSPOMap) selectAccountDtl.get(i);
				
				if(!"".equals(dtlMap.getStr("CPNO"))) {
				
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
							"체육단체 담당자계정 신청 건이 승인되었습니다.\r\n" + 
							"감사합니다.";
									
					smsMap.put("usercode", PropertiesUtil.getString("USERCODE"));
					smsMap.put("deptcode",PropertiesUtil.getString("DEPTCODE"));
					smsMap.put("yellowidKey",PropertiesUtil.getString("YELLOWKEY"));
					smsMap.put("reqname","국민체육진흥공단");
					smsMap.put("reqphone",PropertiesUtil.getString("REQPHONE"));
					smsMap.put("callname",dtlMap.getStr("MNGR_NM"));
					smsMap.put("callphone",dtlMap.getStr("CPNO"));
					smsMap.put("msg",pMsg); //문자내용
					smsMap.put("templatecode","rmss_001"); //템플릿 코드
					
					smsService.insertSms(smsMap);
					smsService.insertSmsLog(smsMap);
					
				}
				
			}
			
		}
		/**********************
		 * SMS 전송처리 종료
		 **********************/
			
		
		return "jsonView";
	}

	/**
	 * 체육단체 계정 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteAccountJs.kspo")
	public String deleteAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		List<String> mstChkList = new ArrayList<String>();
		
		if(paramMap.get("mstChk") instanceof String[]) {
			paramMap.getList("mstChk");
		}else {
			mstChkList.add(paramMap.getStr("mstChk"));
			paramMap.put("mstChk", mstChkList);
		}
		
		accountService.deleteAccount(paramMap);
		
		return "jsonView";
	}
	
	
	/**
	 * 체육단체 계정 탈퇴 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateResignAccountJs.kspo")
	public String updateResignAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		//계정 정보 이동
		accountService.insertResignAccountJs(paramMap);
		//계정 정보 삭제
		accountService.deleteResignAccountJs(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육단체 계정 상태 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAcntKuStsAccountJs.kspo")
	public String updateAcntKuStsAccountJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		List<String> mstChkList = new ArrayList<String>();
		
		if(paramMap.get("mstChk") instanceof String[]) {
			paramMap.getList("mstChk");
		}else {
			mstChkList.add(paramMap.getStr("mstChk"));
			paramMap.put("mstChk", mstChkList);
		}
		
		accountService.insertAcntStsKyAccount(paramMap);
		
		accountService.deleteAcntStsKuAccount(paramMap);
				
		return "jsonView";
	}
}
