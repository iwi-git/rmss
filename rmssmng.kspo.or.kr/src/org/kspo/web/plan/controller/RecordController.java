package org.kspo.web.plan.controller;

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
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.apply.service.SoldierService;
import org.kspo.web.email.service.EmailService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.plan.service.PlanService;
import org.kspo.web.plan.service.RecordService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 11. 15
 * @Author LJW
 * @FileName : RecordController.java
 */
@Controller
@RequestMapping("/plan")
public class RecordController extends BaseController {
	
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	@Resource
	private RecordService recordService;
	
	@Resource
	private PlanService planService;
	
	@Resource
	private SoldierService soldierService;
	
	@Resource
	private PoiService poiService;
	
	//첨부파일
	@Resource
	private FileService fileService;
	
	//코드
	@Resource
	private CodeService codeService;
	
	//메일
	@Resource
	private EmailService emailService;
	
	/**
	 * 실적관리 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordMngSelect.kspo")
	public String RecordMngSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("srchRegDtmStart"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			
			String stdYmd = todaySevenday.getStr("THR_YMD");
			String endYmd = todaySevenday.getStr("END_YMD");
			
			paramMap.put("srchRegDtmStart", stdYmd);
			paramMap.put("srchRegDtmEnd", endYmd);
		
		}
		
		KSPOList recordList = recordService.RecordMngSelect(paramMap);
		
		model.addAttribute("recordList", recordList);//공익복무 실적 리스트
		model.addAttribute("pageInfo", recordList.getPageInfo());//페이지 정보
		model.addAttribute("gameNmCdList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("recdStsCdList", this.cmmnDtlList("202111050000347"));//처리상태
		model.addAttribute("deductionCdList", this.cmmnDtlList("202111170000355"));//식사 및 휴식 시간 공제 여부
		model.addAttribute("actTimeMnCdList", this.cmmnDtlList("202111050000344"));//분 선택
		model.addAttribute("actDistCdList", this.cmmnDtlList("202111170000357"));//이동거리
		model.addAttribute("giftYnCdList", this.cmmnDtlList("202111170000356"));//사례비 수령여부(예/아니요)
		model.addAttribute("actTimeMnCdList", this.cmmnDtlList("202111050000344"));//활동시간 - 분단위
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("memorgCdList", this.memOrgList(paramMap));//체육단체
		model.addAttribute("srchRegDtmStart", paramMap.getStr("srchRegDtmStart")); //등록일 FROM
		model.addAttribute("srchRegDtmEnd", paramMap.getStr("srchRegDtmEnd")); //등록일 TO
		
		return "web/plan/RecordMngSelect";
	}
	
	/**
	 * 봉사활동 실적 - 체육요원 검색 팝업 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRecordPersonListJs.kspo")
	public String selectRecordPersonListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList personList = recordService.selectPersonList(paramMap);
		
		model.addAttribute("personList", personList);
		
		KspoPagnationFormatRenderer renderer =  new KspoPagnationFormatRenderer();
		model.addAttribute("pageInfo",renderer.renderPagination(personList.getPageInfo(), "searchPersonFrm"));
		
		return "jsonView";
	}
	
	/**
	 * 실적등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveRecordJs.kspo")
	public String saveRecordJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/recd","TRMV_VLUN_RECD_D","ATCH_FILE_ID", WEB_FILE_EXT);
		
		recordService.createRecordDList(paramMap);
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			
			KSPOList recdDetailList = (KSPOList) paramMap.get("insertDetailList");
			
			for(Object fileObj : fileList) {
				KSPOMap fileMap = (KSPOMap) fileObj;
				
				for(Object recdDObj : recdDetailList) {
					KSPOMap recdDMap = (KSPOMap) recdDObj;
					
					String fileInputName = "file_" + recdDMap.getStr("TB_ID");
					
					if(fileMap.getStr("FILE_INPUT_NAME").equals(fileInputName)) {
						String fileGrpKeyMap = (recdDMap.getStr("ATCH_FILE_ID").isEmpty()) ? fileService.selectFileGrpRefrKey() : recdDMap.getStr("ATCH_FILE_ID");
						
						fileMap.put("EMP_NO", paramMap.getStr("EMP_NO"));
						fileMap.put("REFR_KEY", fileGrpKeyMap);
						
						fileService.insertFileList(fileMap);
						
						recdDMap.put("ATCH_FILE_ID", fileGrpKeyMap);
					}
				}
			}
		}
		
		int resultCnt = 0;
		
		if(StringUtil.isEmpty(paramMap.getStr("VLUN_RECD_SN"))) {

			resultCnt = recordService.txInsertRecord(paramMap);
			
		} else {
			
			resultCnt = recordService.txUpdateRecord(paramMap);
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 실적 상세보기
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRecordDetailJs.kspo")
	public String selectRecordDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap recordM = recordService.selectRecordM(paramMap);
		KSPOList recordD = recordService.selectRecordDList(paramMap);
		
		//문체부 첨부파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMV_VLUN_RECD_M");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID");
		paramMap.put("REFR_KEY", recordM.get("ATCH_FILE_ID"));
		KSPOList mcFileList = fileService.selectFileList(paramMap);
		recordM.put("MC_FILE_LIST", mcFileList);
		
		//첨부파일 조회
		for(Object rowObj : recordD) {
			//실적 상세별 첨부파일 조회
			KSPOMap rowMap = (KSPOMap) rowObj;
			rowMap.put("REFR_TABLE_NM", "TRMV_VLUN_RECD_D");
			rowMap.put("REFR_COL_NM", "ATCH_FILE_ID");
			rowMap.put("REFR_KEY", rowMap.getStr("ATCH_FILE_ID"));
			
			KSPOList fileList = fileService.selectFileList(rowMap);
			rowMap.put("FILE_LIST", fileList);
			
			//사후 정정 첨부파일 조회
			rowMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
			rowMap.put("REFR_KEY", rowMap.getStr("ATCH_FILE_ID1"));
			
			KSPOList aftFileList = fileService.selectFileList(rowMap);
			rowMap.put("AFT_FILE_LIST", aftFileList);
		}
			
		//대상자 인적사항, 계획정보 세팅
		paramMap.put("APPL_SN", recordM.getStr("APPL_SN"));
		paramMap.put("VLUN_PLAN_SN", recordM.getStr("VLUN_PLAN_SN"));
		paramMap.put("MLTR_ID", recordM.getStr("MLTR_ID"));
		
		KSPOMap personInfo = planService.selectPersonInfo(paramMap);
		KSPOList planList = planService.selectPlanList(paramMap);
		
		model.addAttribute("recordM", recordM);
		model.addAttribute("recordD", recordD);
		model.addAttribute("personInfo", personInfo);
		model.addAttribute("planList", planList);
		
		return "jsonView";
	}
	
	/**
	 * 실적 상세 단건 삭제
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteRecodDetailJs.kspo")
	public String deleteRecodDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
	
		int resultCnt = recordService.deleteOneRecodDetail(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 실적관리 삭제
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteRecordJs.kspo")
	public String deleteRecordJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = recordService.txDeleteRecord(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 공단 접수 처리
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/kdConfirmJs.kspo")
	public String kdConfirmJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
			
		int resultCnt = recordService.txConfrimRecord(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 인정 시간 등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveKdAcceptJs.kspo")
	public String saveKdAcceptJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
	
		int resultCnt = recordService.txSaveKdAccept(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 문체부 승인,반려
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mcConfirmJs.kspo")
	public String mcConfirmJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/recd","TRMV_VLUN_RECD_M","ATCH_FILE_ID", WEB_FILE_EXT);
		
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
			
		int resultCnt = recordService.txMcConfrimRecord(paramMap);
		
		model.addAttribute("resultCnt" , resultCnt);
		
		return "jsonView";
	}

	/**
	 * 사후정정 등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveAfterAcceptJs.kspo")
	public String saveAfterAcceptJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/recd","TRMV_VLUN_RECD_D","ATCH_FILE_ID1", WEB_FILE_EXT);
		
		String inputFileNm = "";
		String fileGrpKeyMap = "";
		
		KSPOList detailList = paramMap.getMapInList("VLUN_RECD_D_SN");
		
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			//실적상세 기준 키로 데이터 가공 [VLUN_RECD_D_SN]
			
			for(Object fileObj : fileList) {
				KSPOMap fileMap = (KSPOMap) fileObj;
				
				for(Object dObj : detailList) {
					KSPOMap dMap = (KSPOMap) dObj;
					
					inputFileNm = "afterFile_" + dMap.getStr("VLUN_RECD_D_SN");
					
					if(fileMap.getStr("FILE_INPUT_NAME").equals(inputFileNm)) {
						fileGrpKeyMap = (dMap.getStr("ATCH_FILE_ID1").isEmpty()) ? fileService.selectFileGrpRefrKey() : dMap.getStr("ATCH_FILE_ID1");
						
						fileMap.put("EMP_NO", paramMap.getStr("EMP_NO"));
						fileMap.put("REFR_KEY", fileGrpKeyMap);
						
						fileService.insertFileList(fileMap);
						
						dMap.put("ATCH_FILE_ID1", fileGrpKeyMap);
					}
					
				}
				
			}
			
		}
	
		int resultCnt = recordService.txSaveAfterAccept(paramMap, detailList);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 실적조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordSelect.kspo")
	public String recordSelectList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("srchAddmDtStart"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			
			String stdYmd = todaySevenday.getStr("THR_YMD");
			String endYmd = todaySevenday.getStr("END_YMD");
			
			paramMap.put("srchAddmDtStart", stdYmd);
			paramMap.put("srchAddmDtEnd", endYmd);
		
		}
		
		KSPOList recordList = recordService.selectRecordSelectList(paramMap);
		
		model.addAttribute("recordList", recordList);//공익복무 실적 리스트
		model.addAttribute("pageInfo", recordList.getPageInfo());//페이지 정보
		model.addAttribute("gameNmCdList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("recdStsCdList", this.cmmnDtlList("202111050000347"));//처리상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("memorgCdList", this.memOrgList(paramMap));//체육단체
		model.addAttribute("srchAddmDtStart", paramMap.getStr("srchAddmDtStart")); //편입일자 FROM
		model.addAttribute("srchAddmDtEnd", paramMap.getStr("srchAddmDtEnd")); //편입일자 TO
		
		return "web/plan/RecordSelect";
	}
	
	/**
	 * 실적평가 리스트 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordEvalSelect.kspo")
	public String RecordEvalSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		KSPOMap selectCurYear = codeService.selectBasicYM();
		
		if(StringUtil.isEmpty(paramMap.getStr("srchEvalYear"))) {
			paramMap.put("srchEvalYear", selectCurYear.get("YEAR"));
			model.addAttribute("defEvalYear", paramMap.getStr("srchEvalYear"));
		}
		
		if(StringUtil.isEmpty(paramMap.getStr("srchEvalQtr"))) {
			paramMap.put("srchEvalQtr", this.getCurrentQtr());
			model.addAttribute("defEvalQtr", paramMap.getStr("srchEvalQtr"));
		}
		
		KSPOList recordEvalList = recordService.selectRecordEvalList(paramMap);
		
		model.addAttribute("recordEvalList", recordEvalList);//공익복무 실적평가 리스트
		model.addAttribute("pageInfo", recordEvalList.getPageInfo());//페이지 정보
		model.addAttribute("gameNmCdList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("evalStsCdList", this.cmmnDtlList("202111260000538"));//공익복무 실적결과
		model.addAttribute("curEvalStsCdList", this.cmmnDtlList("202111260000537"));//공익복무 실적상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("memorgCdList", this.memOrgList(paramMap));//체육단체
		
		return "web/plan/RecordEvalSelect";
	}
	
	/**
	 * 복무요원의 분기별 실적 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPersonQtrRecordJs.kspo")
	public String selectPersonQtrRecordJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
	
		KSPOMap recordQtrInfo = recordService.selectPersonQtrRecord(paramMap);
	
		model.addAttribute("recordQtrInfo", recordQtrInfo);
		
		return "jsonView";
	}
	
	/**
	 * 부진사유 등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEvalJs.kspo")
	public String saveEvalJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = 0;

		resultCnt = recordService.txInsertEval(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	
	
	/**
	 * 부진사유등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEvalPoorReasonJs.kspo")
	public String saveEvalPoorReasonJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/eval", "TRMV_VLUN_EVAL_I","ATCH_FILE_ID", WEB_FILE_EXT);
					 
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
			
			for(int i=0; i<fileList.size(); i++){ 
				KSPOMap fileMap = (KSPOMap) fileList.get(i);
				
				fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
				fileMap.put("REFR_KEY",fileGrpKeyMap);
							  		  
				fileService.insertFileList(fileMap);
				
				paramMap.put("ATCH_FILE_ID",fileGrpKeyMap);			  

			}
		}
		
		int resultCnt = 0;

		resultCnt = recordService.txUpdateEvalPoorReason(paramMap);
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 실적평가 상세 조회
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectEvalDetailJs.kspo")
	public String selectEvalDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap evalInfo = recordService.selectEval(paramMap);
		
		model.addAttribute("evalInfo", evalInfo);
		
		//파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMV_VLUN_EVAL_I");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID");
		paramMap.put("REFR_KEY", evalInfo.getStr("ATCH_FILE_ID"));
		
		KSPOList fileList = fileService.selectFileList(paramMap);
		model.addAttribute("fileList",fileList);
		
		return "jsonView";
	}
	
	
	/**
	 * 평과결과 등록
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveEvalResultJs.kspo")
	public String saveEvalResultJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		int resultCnt = recordService.txUpdateEvalResult(paramMap);
		
		//이메일 발송
		KSPOMap emailRecvInfoMap = soldierService.selectSoldierMngDetail(paramMap);
		
		paramMap.put("TEMP_TYPE", "04");
		KSPOMap mailTemplate = emailService.selectMailTemplate(paramMap); //템플릿 가져오기
		
		KSPOMap emailMap  = reqMap.getReqMap();
		emailMap.put("EMAIL_TYPE","4");			//이메일 유형- 특기활용 공익복무 분기별 실적평가 결과 등록 알림
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
		
	
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	/**
	 * 공익복무 실적관리 - 엑셀데이터 저장
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/recordDownload.kspo")
	public void recordDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList recordExcelList = recordService.selectRecordExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectRecordListExcel(recordExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=Record.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 공익복무 실적조회 - 엑셀데이터 저장
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/recordPerDownload.kspo")
	public void recordPerDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList recordPerExcelList = recordService.selectRecordPerExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectRecordPerListExcel(recordPerExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=RecordPer.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 공익복무 실적평가 - 엑셀데이터 저장
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/evalDownload.kspo")
	public void evalDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList evalExcelList = recordService.selectEvalExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectEvalListExcel(evalExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=eval.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}

}
