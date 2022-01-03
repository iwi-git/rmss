package org.kspo.web.plan.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.email.SendEmail;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.pagination.KspoPagnationFormatRenderer;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.apply.service.SoldierService;
import org.kspo.web.email.service.EmailService;
import org.kspo.web.plan.service.PlanService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 공익복무 계획 계획관리
 * @Since 2021. 11. 09
 * @Author LJW
 * @FileName : PlanController.java
 */
@Controller
@RequestMapping("/plan")
public class PlanController extends BaseController {

	@Resource
	private PlanService planService;
	
	@Resource
	private SoldierService soldierService;
	
	@Resource
	private PoiService poiService;
	
	//메일
	@Resource
	private EmailService emailService;
	
	
	/**
	 * 봉사활동 계획 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/PlanSelect.kspo")
	public String selectPlanList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		KSPOMap paramMap = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("srchRegDtmStart"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			
			String stdYmd = todaySevenday.getStr("STD_YMD");
			String endYmd = todaySevenday.getStr("END_YMD");
			
			paramMap.put("srchRegDtmStart", stdYmd);
			paramMap.put("srchRegDtmEnd", endYmd);
		
		}
		
		KSPOList planList = planService.selectPlanList(paramMap);
		
		model.addAttribute("planList", planList);//계획관리 리스트
		model.addAttribute("pageInfo", planList.getPageInfo());//페이지 정보
		model.addAttribute("gameNmCdList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("planStsCdList", this.cmmnDtlList("202111090000350"));//처리상태
		model.addAttribute("actFieldCdList", this.cmmnDtlList("202111050000342"));//활동분야
		model.addAttribute("vlunTgtCdList", this.cmmnDtlList("202111150000351"));//수혜대상
		model.addAttribute("actTimeMnCdList", this.cmmnDtlList("202111050000344"));//활동시간 - 분단위
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("memorgCdList", this.memOrgList(paramMap));//체육단체
		model.addAttribute("srchRegDtmStart", paramMap.getStr("srchRegDtmStart")); //등록일 FROM
		model.addAttribute("srchRegDtmEnd", paramMap.getStr("srchRegDtmEnd")); //등록일 TO
		
		return "web/plan/PlanSelect";
	}
	
	/**
	 * 체육요원 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPersonListJs.kspo")
	public String selectPersonListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList personList = planService.selectPersonList(paramMap);
		
		model.addAttribute("personList", personList);
		
		KspoPagnationFormatRenderer renderer =  new KspoPagnationFormatRenderer();
		model.addAttribute("pageInfo",renderer.renderPagination(personList.getPageInfo(), "searchPersonFrm"));
		
		return "jsonView";
	}
	
	
	/**
	 * 체육요원 단건 상세조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectPersonJs.kspo")
	public String selectPersonJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap personInfo = planService.selectPersonInfo(paramMap);
			
		model.addAttribute("personInfo", personInfo);
		
		return "jsonView";
	}
	
	
	/**
	 * 대상기관 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPlaceListJs.kspo")
	public String selectPlaceListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList placeList = planService.selectPlaceList(paramMap);
		
		model.addAttribute("placeList", placeList);
		
		KspoPagnationFormatRenderer renderer =  new KspoPagnationFormatRenderer();
		model.addAttribute("pageInfo",renderer.renderPagination(placeList.getPageInfo(), "searchPlaceFrm"));
		
		return "jsonView";
	}
	
	
	/**
	 * 대상기관 단건 상세조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPlaceJs.kspo")
	public String selectPlaceJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap placeInfo = planService.selectPlace(paramMap);
		
		model.addAttribute("placeInfo", placeInfo);
		
		return "jsonView";
	}
	
	/**
	 * 봉사활동 계획 저장,수정
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/savePlanJs.kspo")
	public String savePlanJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = 0 ;
		
		if(StringUtil.isEmpty(paramMap.getStr("VLUN_PLAN_SN"))) {
			//봉사활동 기간별 날짜를 구한다.
			KSPOList planDateList = planService.selectPlanDateList(paramMap);
			
			if(!planDateList.isEmpty()){ //업로드 파일 있을경우
			    for(int i=0; i<planDateList.size(); i++){ 
			    	KSPOMap dateMap = (KSPOMap) planDateList.get(i);
			    	
			    	  if(planDateList.size() > 1) {
			    							  
						  paramMap.put("VLUN_ACT_START",dateMap.getStr("PLAN_DT"));
						  paramMap.put("VLUN_ACT_END",dateMap.getStr("PLAN_DT"));
						  paramMap.put("ACT_TIME_HR","12");
						  paramMap.put("ACT_TIME_MN","00");						  
						  
			    	  }else {
			    		  paramMap.put("VLUN_ACT_START",dateMap.getStr("PLAN_DT"));
						  paramMap.put("VLUN_ACT_END",dateMap.getStr("PLAN_DT"));
			    	  }
			    	  
			    	  resultCnt = planService.txInsertPlan(paramMap);
					  
		  		}
		  	}
		} else {
			resultCnt = planService.txUpdatePlan(paramMap);
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 봉사활동 계획 단건 상세조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPlanDetailJs.kspo")
	public String selectPlanDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap plan = planService.selectPlanDetail(paramMap);
		
		model.addAttribute("plan", plan);
		
		return "jsonView";
	}
	
	/**
	 * 봉사활동 계획 삭제 
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deletePlanJs.kspo")
	public String deletePlanJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = planService.txDeletePlan(paramMap);
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 봉사관리 접수 처리
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/confirmPlanJs.kspo")
	public String confirmPlanJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
			
		int resultCnt = planService.txConfrimPlan(paramMap);
		
		if("KY".equals(paramMap.getStr("PLAN_STS"))) {
			//공단 승인시 이메일 발송
			KSPOMap emailRecvInfoMap = soldierService.selectSoldierMngDetail(paramMap);
			
			paramMap.put("TEMP_TYPE", "03");
			KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
			
			KSPOMap emailMap  = reqMap.getReqMap();
			emailMap.put("EMAIL_TYPE","3");			//이메일 유형- 공익복무 계획 승인 알림
			emailMap.put("title",mailTemplate.getStr("TEMP_TITLE"));		//이메일 타이틀
			emailMap.put("sendContents",mailTemplate.getStr("TEMP_CONTENTS"));		//이메일 상세
			emailMap.put("APPL_NM",emailRecvInfoMap.getStr("APPL_NM"));		//대상자 
			
			//받는사람 설정
			emailMap.put("recNm",emailRecvInfoMap.getStr("MEMORG_NM"));
			emailMap.put("recEmail",emailRecvInfoMap.getStr("ORG_MNGR_EMAIL"));
			
			//보내는 사람 설정
			
			SendEmail.createEmailHtml(emailMap);
			
			//이메일 발송로그 기록
			emailService.insertEmailLog(emailMap);
			 
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	
	/**
	 * 계획 변경 신청
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/planChagneReqJs.kspo")
	public String planChagneReqJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = planService.txPlanChangeReq(paramMap);
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 봉사활동 계획 조회JS
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPlanListJs.kspo")
	public String selectPlanListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList planList = planService.selectPlanList(paramMap);
		
		model.addAttribute("planList", planList);
		
		KspoPagnationFormatRenderer renderer =  new KspoPagnationFormatRenderer();
		model.addAttribute("pageInfo",renderer.renderPagination(planList.getPageInfo(), "searchPlaceFrm"));
		
		return "jsonView";
	}
	
	/**
	 * 공익복무 계획관리 - 엑셀데이터 저장
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/planDownload.kspo")
	public void planDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList planExcelList = planService.selectPlanExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectPlanListExcel(planExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=Plan.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 공익복무 일괄 처리 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAllPlanStsJs.kspo")
	public String updateAllPlanStsJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		List<String> mstChkList = new ArrayList<String>();
		
		if(paramMap.get("mstChk") instanceof String[]) {
			paramMap.getList("mstChk");
		}else {
			mstChkList.add(paramMap.getStr("mstChk"));
			paramMap.put("mstChk", mstChkList);
		}
		
		planService.updateAllPlanStsJs(paramMap);
				
		return "jsonView";
	}

}
