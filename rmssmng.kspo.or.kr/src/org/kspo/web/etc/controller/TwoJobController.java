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
import org.kspo.web.apply.service.SoldierService;
import org.kspo.web.email.service.EmailService;
import org.kspo.web.etc.service.TwoJobService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.system.code.service.CodeService;
import org.kspo.web.system.user.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : TwoJobController.java
 * <pre> 겸직허가신청
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * 2021. 11. 26. SCY : 개발
 * </pre>
 */
@Controller
@RequestMapping("/etc")
public class TwoJobController extends BaseController{
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	//겸직허가신청
	@Resource
	private TwoJobService twoJobService;
	
	@Resource
	private SoldierService soldierService;
	
	//메일
	@Resource
	private EmailService emailService;
	
	//코드
	@Resource
	private CodeService codeService;

	//사용자
	@Resource
	private UserService userService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	//엑셀다운로드
	@Resource
	private PoiService poiService;
	
	
	/**
	 * 체육요원 겸직 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TwoJobSelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			
			String stdYmd = todaySevenday.getStr("STD_YMD");
			String endYmd = todaySevenday.getStr("END_YMD");
			
			paramMap.put("STD_YMD", stdYmd);
			paramMap.put("END_YMD", endYmd);
		
		}
		
		KSPOList selectTwoJobList = twoJobService.selectTwoJobList(paramMap);
		
		model.addAttribute("twoJobList", selectTwoJobList);
		model.addAttribute("pageInfo",selectTwoJobList.getPageInfo());//페이지 정보	
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("procStsList",this.cmmnDtlList("31")); //편입상태
		model.addAttribute("concStsList",this.cmmnDtlList("202111180000436")); //겸직관리 처리상태
		model.addAttribute("concPrvonshList",this.cmmnDtlList("202111180000435")); //겸직사유코드
		model.addAttribute("concOfcList",this.cmmnDtlList("202111180000434")); //겸직허가 근무형태 처리상태
		model.addAttribute("applDvList",this.cmmnDtlList("202111180000437")); //겸직허가 신청구분
		model.addAttribute("incmYnList", this.cmmnDtlList("202111180000439"));//겸직허가 수입발생여부
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("STD_YMD", paramMap.getStr("STD_YMD")); //등록일 FROM
		model.addAttribute("END_YMD", paramMap.getStr("END_YMD")); //등록일 TO
		
		return "web/etc/TwoJobSelect";
	}
	
	/**
	 * 체육요원 겸직 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TwoJobDownload.kspo")
	public void TwoJobDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//사용자 접속이력 조회
		KSPOList selectTwoJobExcelList = twoJobService.selectTwoJobExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectTwoJobListExcel(selectTwoJobExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=TwoJob.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 겸식허가 신청 저장
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveTwoJobJs.kspo")
	public String saveTwoJobJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMC_CONC_I","ATCH_FILE_ID", WEB_FILE_EXT);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = (paramMap.getStr("ATCH_FILE_ID").isEmpty()) ? fileService.selectFileGrpRefrKey() : paramMap.getStr("ATCH_FILE_ID");
			
			for(int i=0; i<fileList.size(); i++){ 
				KSPOMap fileMap = (KSPOMap) fileList.get(i);
				
				fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
				fileMap.put("REFR_KEY",fileGrpKeyMap);

				fileService.insertFileList(fileMap);
				
				paramMap.put("ATCH_FILE_ID",fileGrpKeyMap);			  

			}
		}
		
		int resultCnt = 0;
		
		if(StringUtil.isEmpty(paramMap.getStr("CONC_SN"))) {
			resultCnt = twoJobService.txInsertTwoJob(paramMap);
		} else {
			resultCnt = twoJobService.txUpdateTwoJob(paramMap);
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 겸직허가신청 상세보기
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTwoJobDetailJs.kspo")
	public String selectTwoJobDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap twoJobInfo = twoJobService.selectTwoJob(paramMap);
		
		model.addAttribute("twoJobInfo", twoJobInfo);
		
		//첨부파일
		KSPOMap fileMap = new KSPOMap();
		fileMap.put("REFR_TABLE_NM", "TRMC_CONC_I");
		fileMap.put("REFR_COL_NM", "ATCH_FILE_ID");
		fileMap.put("REFR_KEY", twoJobInfo.getStr("ATCH_FILE_ID"));
		
		KSPOList fileList = fileService.selectFileList(fileMap);
		
		model.addAttribute("fileList", fileList);
		
		//문체부 첨부파일
		KSPOMap mcFileMap = new KSPOMap();
		mcFileMap.put("REFR_TABLE_NM", "TRMC_CONC_I");
		mcFileMap.put("REFR_COL_NM", "ATCH_FILE_ID2");
		mcFileMap.put("REFR_KEY", twoJobInfo.getStr("ATCH_FILE_ID2"));
		
		KSPOList mcFileList = fileService.selectFileList(mcFileMap);
		
		model.addAttribute("mcFileList", mcFileList);
		
		return "jsonView";
	}
	
	/**
	 * 겸직허가신청 공단 담당자 승인/반려
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/twoJobKdConfirmJs.kspo")
	public String twoJobKdConfirmJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = twoJobService.txTwoJobKdConfirm(paramMap);
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 겸직허가신청 문체부 담당자 승인/반려
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/twoJobMcConfirmJs.kspo")
	public String twoJobMcConfirmJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMC_CONC_I","ATCH_FILE_ID2", WEB_FILE_EXT);
					
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = (paramMap.getStr("ATCH_FILE_ID2").isEmpty()) ? fileService.selectFileGrpRefrKey() : paramMap.getStr("ATCH_FILE_ID2");
			
			for(int i=0; i<fileList.size(); i++){ 
				KSPOMap fileMap = (KSPOMap) fileList.get(i);
				
				fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
				fileMap.put("REFR_KEY",fileGrpKeyMap);

				fileService.insertFileList(fileMap);
				
				paramMap.put("ATCH_FILE_ID2",fileGrpKeyMap);			  

			}
		}
		
		int resultCnt = twoJobService.txTwoJobMcConfirm(paramMap);
		
		if("MY".equals(paramMap.getStr("CONC_STS"))) {
		
			//이메일 발송
			KSPOMap emailRecvInfoMap = soldierService.selectSoldierMngDetail(paramMap);
			
			paramMap.put("TEMP_TYPE", "06");
			KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
			
			KSPOMap emailMap  = reqMap.getReqMap();
			emailMap.put("EMAIL_TYPE","6");			//이메일 유형- 특기활용 공익복무 분기별 실적평가 결과 등록 알림
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
	 * 겸직허가신청 삭제
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteTwoJobJs.kspo")
	public String deleteTwoJobJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = twoJobService.txDeleteTwoJob(paramMap);
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
}
