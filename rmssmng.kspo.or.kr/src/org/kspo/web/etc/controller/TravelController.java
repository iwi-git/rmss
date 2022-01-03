package org.kspo.web.etc.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.email.SendEmail;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.email.service.EmailService;
import org.kspo.web.etc.service.TravelService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.plan.service.PlanService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : TravelController.java
 * <pre> 국외여행신청
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/etc")
public class TravelController extends BaseController{
protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자

	@Resource
	private TravelService travelService;
	
	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;

	@Resource
	private PlanService planService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;
	
	//메일
	@Resource
	private EmailService emailService;
	
	/**
	 * 체육요원 국외여행 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TravelSelect.kspo")
	public String TravelSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();

		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("STD_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		KSPOList selectTravelSelectList = travelService.selectTravelSelectList(paramMap);
		
		model.addAttribute("travelSelectList", selectTravelSelectList);
		model.addAttribute("pageInfo",selectTravelSelectList.getPageInfo());//페이지 정보
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("trvlStsList",this.cmmnDtlList("202111150000352")); //국외여행 처리상태
		model.addAttribute("procStsList",this.cmmnDtlList("31")); //편입상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		//model.addAttribute("gameNmList",this.cmmnDtlList("202111150000353")); //국외여행 신청구분
		
		return "web/etc/TravelSelect";
	}
	
	/**
	 * 체육요원 국외여행 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TravelSelectDownload.kspo")
	public void TravelSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육요원 국외여행 조회
		KSPOList selectTravelSelectList = travelService.selectTravelSelectExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectTravelSelectListExcel(selectTravelSelectList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=TravelSelect.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}

	/**
	 * 체육요원 국외여행 신청 내용 상세
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectTravelPersonJs.kspo")
	public String selectTravelPersonJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
			
		KSPOMap personInfo = planService.selectPersonInfo(paramMap); //대상자 인적사항 불러오기
		
		//극외여행 여행정보 불러오기
		KSPOList travelInfo = travelService.selectTravelInfoList(paramMap);
		
		model.addAttribute("travelInfo", travelInfo);
		model.addAttribute("personInfo", personInfo);
			
			
		return "jsonView";
	}
	
	/**
	 * 체육요원 국외여행 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTravelDetailJs.kspo")
	public String selectTravelDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectTravelDetail = travelService.selectTravelDetail(paramMap);
		//극외여행 여행정보 불러오기
		KSPOList travelInfo = travelService.selectTravelInfoList(paramMap);
		
		model.addAttribute("travelInfo", travelInfo);
		model.addAttribute("detail", selectTravelDetail);
		
		return "jsonView";
	}

	/**
	 * 체육요원 극외여행 여행정보 상세 불러오기
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTravelInfoDetailJs.kspo")
	public String selectTravelInfoDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//극외여행 여행정보 상세 불러오기
		KSPOMap travelInfoDetail = travelService.selectTravelInfoDetail(paramMap);
		
		//파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMA_TRVL_RECD_I");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
		paramMap.put("REFR_KEY",travelInfoDetail.getStr("ATCH_FILE_ID1"));
		
		KSPOList fileList = fileService.selectFileList(paramMap);
		
		model.addAttribute("fileList",fileList);
		
		model.addAttribute("travelInfoDetail", travelInfoDetail);
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 국외여행 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTravelJs.kspo")
	public String insertTravelJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMA_TRVL_RECD_I","ATCH_FILE_ID1", WEB_FILE_EXT);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			
			String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
			
			paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap);
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID1"));
			  
			  fileService.insertFileList(fileMap);
	  
	  		}
	  	}
		
		travelService.txInsertTravel(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 국외여행 신청 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteTravelJs.kspo")
	public String deleteTravelJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		travelService.txDeleteTravelJs(paramMap);
		
		return "jsonView";
	}

	/**
	 * 체육요원 국외여행 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTravelJs.kspo")
	public String updateTravelJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();

		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMA_TRVL_RECD_I","ATCH_FILE_ID1", WEB_FILE_EXT);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			
			if("".equals(paramMap.get("ATCH_FILE_ID1"))){
				String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
				
				paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap);
			}	
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID1"));
			  
			  fileService.insertFileList(fileMap);
	  
	  		}
	  	}
		
		travelService.txUpdateTravel(paramMap);
		
		return "jsonView";
	}

	/**
	 * 체육요원 선택된 국외여행정보 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteTravelRecdJs.kspo")
	public String deleteTravelRecdJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		travelService.deleteTravelRecd(paramMap);
		
		return "jsonView";
	}

	
	/**
	 * 체육요원 국외여행 공단 접수 혹은 반려 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTravelReceiptJs.kspo")
	public String updateTravelReceiptJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		travelService.updateTravelReceipt(paramMap);
		
		return "jsonView";
	}

	/**
	 * 체육요원 국외여행 문체부 승인 혹은 미승인 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTravelApprovalJs.kspo")
	public String updateTravelApprovalJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMA_TRVL_I","ATCH_FILE_ID5", WEB_FILE_EXT);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			if(StringUtil.isEmpty(paramMap.getStr("ATCH_FILE_ID5"))) {
				String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
				paramMap.put("ATCH_FILE_ID5", fileGrpKeyMap);
			}
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID5"));
			  fileService.insertFileList(fileMap);

	  		}
	  	}
		
		travelService.updateTravelApproval(paramMap);
		
		if("MY".equals(paramMap.getStr("TRVL_STS"))) {
			//문체부승인시 이메일 발송
				
				KSPOMap selectTravelDetail = travelService.selectTravelDetail(paramMap); //대상자 인적사항
				
				paramMap.put("TEMP_TYPE", "05");
				KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
				
				KSPOMap emailMap  = reqMap.getReqMap();
				emailMap.put("EMAIL_TYPE","5");			//이메일 유형-국외여행신청 승인알림
				emailMap.put("title",mailTemplate.getStr("TEMP_TITLE"));		//이메일 타이틀
				emailMap.put("sendContents",mailTemplate.getStr("TEMP_CONTENTS"));		//이메일 상세
				emailMap.put("APPL_NM",selectTravelDetail.getStr("APPL_NM"));		//대상자 
				
				//받는사람 설정
				emailMap.put("recNm",selectTravelDetail.getStr("MEMORG_NM"));
				emailMap.put("recEmail",selectTravelDetail.getStr("ORG_MNGR_EMAIL"));
				
				//보내는 사람 설정
				
				SendEmail.createEmailHtml(emailMap);
				
				//이메일 발송로그 기록
				emailService.insertEmailLog(emailMap);
			
		}
		
		return "jsonView";
	}
	
}
