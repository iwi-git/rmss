package org.kspo.web.apply.controller;


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
import org.kspo.web.apply.service.SoldierService;
import org.kspo.web.email.service.EmailService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 04.
 * @Author SCY
 * @FileName : SoldierController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 04. SCY : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/apply")
public class SoldierController extends BaseController{
	
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	//체육요원 편입신청
	@Resource
	private SoldierService soldierService;

	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;

	//엑셀 다운로드
	@Resource
	private PoiService poiService;

	//메일
	@Resource
	private EmailService emailService;
	
	
	/**
	 * 체육요원 편입신청 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SoldierSelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();

		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("STD_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		//체육요원 편입신청 조회
		KSPOList selectSoldierSelectList = soldierService.selectSoldierSelectList(paramMap);
		
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("soldierSelectList",selectSoldierSelectList);
		model.addAttribute("pageInfo",selectSoldierSelectList.getPageInfo());//페이지 정보
		model.addAttribute("nextYearList",codeService.selectNextYearList());//기간
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("userDvList",this.cmmnDtlList("15")); //사용자구분
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("rankList",this.cmmnDtlList("202111050000340")); //등위
		model.addAttribute("fieldList",this.cmmnDtlList("202111050000339")); //복무분야
		model.addAttribute("ApplStsList",this.cmmnDtlList("30")); //처리상태
		model.addAttribute("insptMltrAdmnList",this.cmmnDtlList("202111050000337")); //검사병무청
		model.addAttribute("srvInsttCodeList",this.cmmnDtlList("202111050000338")); //복무기관
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/apply/SoldierSelect";
	}

	/**
	 * 주소검색
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/jusoSearch.kspo")
	public String jusoSearch(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		

		return "web/apply/jusoPopup";
	}

	/**
	 * 체육요원 편입신청 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SoldierSelectDownload.kspo")
	public void SoldierSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육요원 편입신청 조회
		KSPOList selectSoldierExcelSelectList = soldierService.selectSoldierSelectExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectSoldierSelectListExcel(selectSoldierExcelSelectList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=SoldierSelect.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 체육요원 편입신청 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSoldierSelectDetailJs.kspo")
	public String selectSoldierSelectDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectSoldierSelectDetail = soldierService.selectSoldierSelectDetail(paramMap);
		KSPOMap selectSoldierSelectAcptDetail = null;
		
		//파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMM_APPL_I");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
		paramMap.put("REFR_KEY", selectSoldierSelectDetail.getStr("ATCH_FILE_ID1"));
		
		KSPOList fileList = fileService.selectFileList(paramMap);
		model.addAttribute("fileList",fileList);
				
		 if(!"".equals(selectSoldierSelectDetail.getStr("MLTR_ID"))) { 
			  selectSoldierSelectAcptDetail = soldierService.selectSoldierSelectAcptDetail(paramMap);
		  }
			 
		model.addAttribute("detail", selectSoldierSelectDetail);
		model.addAttribute("acptDetail", selectSoldierSelectAcptDetail);
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 편입신청 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertSoldierSelectJs.kspo")
	public String insertSoldierSelectJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/apply","TRMM_APPL_I","ATCH_FILE_ID1", WEB_FILE_EXT);
			 
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",fileGrpKeyMap);
			  			  		  
			  fileService.insertFileList(fileMap);
			  
			  paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap);			  

	  		}
	  	}
		
		soldierService.insertSoldierSelect(paramMap);
				
		
		return "jsonView";
	}

	/**
	 * 체육요원 편입신청 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateSoldierSelectJs.kspo")
	public String updateSoldierSelectJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/apply","TRMM_APPL_I","ATCH_FILE_ID1", WEB_FILE_EXT);
					 
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
			
			if(StringUtil.isEmpty(paramMap.getStr("ATCH_FILE_ID1"))) {	
				paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap);
			}	
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID1"));
			  
			  fileService.insertFileList(fileMap);
	  
	  		}
	  	}
		
		soldierService.updateSoldierSelect(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 편입신청 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteSoldierSelectJs.kspo")
	public String deleteSoldierSelectJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		soldierService.deleteSoldierSelect(paramMap);
		
		
		return "jsonView";
	}

	/**
	 * 편입신청 접수내역 접수처리 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateSoldierSelectReceiptJs.kspo")
	public String updateSoldierSelectReceiptJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		soldierService.txUpdateSoldierSelectReceipt(paramMap);
		
		return "jsonView";
	}

	/**
	 * 편입신청 접수내역 접수반려 및 취소 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteSoldierSelectReceiptJs.kspo")
	public String updateSoldierSelectReceiptDeleteJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		soldierService.txUpdateSoldierSelectReceiptDelete(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 편입신청 문체부승인 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateSoldierSelectApprovalJs.kspo")
	public String updateSoldierSelectApprovalJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/apply","TRMM_APPL_ACPT_I","ATCH_FILE_ID", WEB_FILE_EXT);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
			
			if(StringUtil.isEmpty(paramMap.getStr("ATCH_FILE_ID"))) {				
				paramMap.put("ATCH_FILE_ID", fileGrpKeyMap);
			}
			
		    for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID"));
			  
			  fileService.insertFileList(fileMap);

	  		}
	  	}
		
		soldierService.txUpdateSoldierSelectApproval(paramMap);
		
		if("MY".equals(paramMap.getStr("APPL_STS"))) {
			//문체부 승인시 이메일 발송
				
				KSPOMap selectSoldierSelectDetail = soldierService.selectSoldierSelectDetail(paramMap); //대상자 인적사항
				
				paramMap.put("TEMP_TYPE", "01");
				KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
				
				KSPOMap emailMap  = reqMap.getReqMap();
				emailMap.put("EMAIL_TYPE","1");			//이메일 유형-편입승인알림
				emailMap.put("title",mailTemplate.getStr("TEMP_TITLE"));		//이메일 타이틀
				emailMap.put("sendContents",mailTemplate.getStr("TEMP_CONTENTS"));		//이메일 상세
				emailMap.put("APPL_NM",selectSoldierSelectDetail.getStr("APPL_NM"));		//대상자 
				
				//받는사람 설정
				emailMap.put("recNm",selectSoldierSelectDetail.getStr("MEMORG_NM"));
				emailMap.put("recEmail",selectSoldierSelectDetail.getStr("ORG_MNGR_EMAIL"));
				
				//보내는 사람 설정
				
				SendEmail.createEmailHtml(emailMap);
				
				//이메일 발송로그 기록
				emailService.insertEmailLog(emailMap);
			
		}
		
		return "jsonView";
	}
	
	/**
	 * 편입신청 복무현황 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SoldierMngSelect.kspo")
	public String selectSoldierList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("STD_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		//체육요원 복무현황 조회
		KSPOList selectSoldierMngList = soldierService.selectSoldierMngList(paramMap);
		
		model.addAttribute("soldierMngList",selectSoldierMngList);
		model.addAttribute("pageInfo",selectSoldierMngList.getPageInfo());//페이지 정보
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("userDvList",this.cmmnDtlList("15")); //사용자구분
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("MltrAdmnList",this.cmmnDtlList("202111050000337")); //검사병무청
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("ApplStsList",this.cmmnDtlList("31")); //진행상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/apply/SoldierMngSelect";
	}
	
	/**
	 * 체육요원 복무현황 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SoldierMngDownload.kspo")
	public void SoldierMngDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육요원 복무현황 조회
		KSPOList selectSoldierMngList = soldierService.selectSoldierMngExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectSoldierMngListExcel(selectSoldierMngList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=SoldierMng.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 체육요원 복무현황 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/SoldierMngSelectDetailJs.kspo")
	public String SoldierMngSelectDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//상세정보
		KSPOMap selectSoldierSelectDetail = soldierService.selectSoldierMngDetail(paramMap);

		//봉사활동 실적현황
		KSPOList recordDtl = soldierService.recordDtl(paramMap);
		
		//파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMM_APPL_I");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
		paramMap.put("REFR_KEY", selectSoldierSelectDetail.getStr("ATCH_FILE_ID1"));
		
		KSPOList fileList = fileService.selectFileList(paramMap);

		model.addAttribute("fileList",fileList);
		model.addAttribute("detail", selectSoldierSelectDetail);
		model.addAttribute("recordDtl", recordDtl);
		
		return "jsonView";
	}

	/**
	 * 체육요원 복무현황 복무만료 혹은 편입취소 처리 JS
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateSolidMngExprApplCnclProcJs.kspo")
	public String updateSolidMngExprApplCnclProcJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		soldierService.updateSolidMngExprApplCnclProc(paramMap);
		
		if("MM".equals(paramMap.getStr("PROC_STS"))) {
			//의무복무만료처리시 이메일 발송
				
				KSPOMap selectSoldierMngDetail = soldierService.selectSoldierMngDetail(paramMap); //대상자 인적사항
				
				paramMap.put("TEMP_TYPE", "02");
				KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
				
				KSPOMap emailMap  = reqMap.getReqMap();
				emailMap.put("EMAIL_TYPE","2");			//이메일 유형-의무복무 만료알림
				emailMap.put("title",mailTemplate.getStr("TEMP_TITLE"));		//이메일 타이틀
				emailMap.put("sendContents",mailTemplate.getStr("TEMP_CONTENTS"));		//이메일 상세
				emailMap.put("APPL_NM",selectSoldierMngDetail.getStr("APPL_NM"));		//대상자 
				
				//받는사람 설정
				emailMap.put("recNm",selectSoldierMngDetail.getStr("MEMORG_NM"));
				emailMap.put("recEmail",selectSoldierMngDetail.getStr("ORG_MNGR_EMAIL"));
				
				//보내는 사람 설정
				
				SendEmail.createEmailHtml(emailMap);
				
				//이메일 발송로그 기록
				emailService.insertEmailLog(emailMap);
			
		}
		
		return "jsonView";
	}

}

