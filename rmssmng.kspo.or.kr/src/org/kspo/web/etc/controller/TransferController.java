package org.kspo.web.etc.controller;

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
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.etc.service.TransferService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.system.code.service.CodeService;
import org.kspo.web.system.user.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 04.
 * @Author SCY
 * @FileName : MilitaryController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 04. SCY : 최초작성
 * 2021. 11. 11. UGW : TransferSelect작성
 * </pre>
 */
@Controller
@RequestMapping("/transfer")
public class TransferController extends BaseController{
		
	protected static String WEB_FILE_EXT = PropertiesUtil.getString("WEB_FILE_EXT");	// 파일확장자
	
	//체육요원 신상이동신청
	@Resource
	private TransferService transferService;
	
	//코드
	@Resource
	private CodeService codeService;
	
	//사용자
	@Resource
	private UserService userService;
	
	//첨부파일
	@Resource
	private FileService fileService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;
	
		
		/**
		 * 신상이동신청 목록 조회
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/TransferSelect.kspo")
		public String TransferSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			KSPOMap paramMap  = reqMap.getReqMap();
			
			if("".equals(paramMap.getStr("STD_YMD"))) {
				KSPOMap todaySevenday = this.selectTodaySevenday();
				paramMap.put("STD_YMD",todaySevenday.getStr("STD_YMD"));
				paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
			}
			
			//체육요원 신상이동신청 조회
			KSPOList selectTransferList = transferService.selectTransferList(paramMap);
			
			model.addAttribute("userDtl",userService.selectloginUserDtlList(paramMap)); //체육단체 정보
			model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
			model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
			model.addAttribute("transferList",selectTransferList); //신상이동신청리스트
			model.addAttribute("pageInfo",selectTransferList.getPageInfo());//페이지 정보
			model.addAttribute("nextYearList",codeService.selectNextYearList());//기간
			model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
			model.addAttribute("userDvList",this.cmmnDtlList("15")); //사용자구분
			model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
			model.addAttribute("adjuNmList",this.cmmnDtlList("202111150000354")); //형 구분
			model.addAttribute("fieldList",this.cmmnDtlList("202111050000339")); //복무분야
			model.addAttribute("stsList",this.cmmnDtlList("202111240000440")); //처리상태
			model.addAttribute("insptMltrAdmnList",this.cmmnDtlList("202111050000337")); //관할병무청
			model.addAttribute("procStsList",this.cmmnDtlList("31")); //편입상태
			model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
			
			return "web/etc/TransferSelect";
		}

		
		
		/**
		 * 신상이동신청 상세 조회
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/selectTransferDetailJs.kspo")
		public String selectTransferDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
			
			KSPOMap paramMap = reqMap.getReqMap();
			
			KSPOMap selectTransferDetail = transferService.selectTransferDetail(paramMap);
			
			//파일 조회(소속변경)
			paramMap.put("REFR_TABLE_NM", "TRMT_TRNS_I");
			
			paramMap.put("REFR_KEY", selectTransferDetail.getStr("ATCH_FILE_ID1"));
			paramMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
			
			KSPOList T1fileList = fileService.selectFileList(paramMap);
			model.addAttribute("T1fileList",T1fileList);

			//파일 조회(형선고)
			paramMap.put("REFR_KEY", selectTransferDetail.getStr("ATCH_FILE_ID2"));
			paramMap.put("REFR_COL_NM", "ATCH_FILE_ID2");
			
			KSPOList T2fileList = fileService.selectFileList(paramMap);
			model.addAttribute("T2fileList",T2fileList);
			
			 
			model.addAttribute("detail", selectTransferDetail);
			
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
			
			KSPOMap personInfo = transferService.selectPersonInfo(paramMap);
				
			model.addAttribute("personInfo", personInfo);
			
			return "jsonView";
		}
		
		
		/**
		 * 신상이동신청 등록 js
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/insertTransferJs.kspo")
		public String insertTransferJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			KSPOMap paramMap  = reqMap.getReqMap();
			
			//파일업로드
			KSPOList fileList = fileService.fileUpload(request,"/transfer","TRMT_TRNS_I","TRNS_SN", WEB_FILE_EXT);
									
			if(!fileList.isEmpty()){ //업로드 파일 있을경우
				
				String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
				
			  for(int i=0; i<fileList.size(); i++){ 
				  
				  KSPOMap fileMap = (KSPOMap) fileList.get(i);
				  
				  if(fileMap.getStr("FILE_INPUT_NAME").startsWith("T1")) {
					  paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap);
				  } else if (fileMap.getStr("FILE_INPUT_NAME").startsWith("T2")) {
					  paramMap.put("ATCH_FILE_ID2",fileGrpKeyMap);
				  }
				  
				  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));				  
				  
				  if(fileMap.getStr("FILE_INPUT_NAME").startsWith("T1")) {
					  fileMap.put("REFR_COL_NM", "ATCH_FILE_ID1");
					  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID1"));
				  } else if (fileMap.getStr("FILE_INPUT_NAME").startsWith("T2")) {
					  fileMap.put("REFR_COL_NM", "ATCH_FILE_ID2");
					  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID2"));
				  }
				  
				  fileService.insertFileList(fileMap);
		  
		  		}
		  	}
			
			transferService.insertTransfer(paramMap);  					
			
			return "jsonView";
		}
		
		
		/**
		 * 신상이동신청 수정 js
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/updateTransferJs.kspo")
		public String updateTransferJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			KSPOMap paramMap  = reqMap.getReqMap();
			
			//파일업로드
			KSPOList fileList = fileService.fileUpload(request,"/transfer","TRMT_TRNS_I","TRNS_SN", WEB_FILE_EXT);
			

			if(!fileList.isEmpty()){ //업로드 파일 있을경우
				if("".equals(paramMap.get("ATCH_FILE_ID1"))) {
					String fileGrpKeyMap_T1 = fileService.selectFileGrpRefrKey();
					
					paramMap.put("ATCH_FILE_ID1",fileGrpKeyMap_T1);
				}
				if("".equals(paramMap.get("ATCH_FILE_ID2"))) {
					String fileGrpKeyMap_T2 = fileService.selectFileGrpRefrKey();
					
					paramMap.put("ATCH_FILE_ID2",fileGrpKeyMap_T2);
				}				
				
			  for(int i=0; i<fileList.size(); i++){ 
				  
				  KSPOMap fileMap = (KSPOMap) fileList.get(i);
				  
				  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
				  
				  if(fileMap.getStr("FILE_INPUT_NAME").startsWith("T1")) {
					  fileMap.put("REFR_COL_NM", "ATCH_FILE_ID1");  
					  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID1"));
				  } else if (fileMap.getStr("FILE_INPUT_NAME").startsWith("T2")) {
					  fileMap.put("REFR_COL_NM", "ATCH_FILE_ID2");
					  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID2"));
				  }
				  
				  fileService.insertFileList(fileMap);

		  		}
		  	}
			
			transferService.updateTransfer(paramMap);
			
			return "jsonView";
		}
		
		/**
		 * 신상이동신청 삭제 js
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/deleteTransferJs.kspo")
		public String deleteTransferJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			KSPOMap paramMap  = reqMap.getReqMap();
			
			transferService.deleteTransfer(paramMap);
			
			KSPOMap delParamMap = transferService.selectTransferDetail(paramMap);			
			
			paramMap.put("REFR_TABLE_NM", "TRMT_TRNS_I");
			
			//(소속변경 첨부파일 삭제)
			paramMap.put("REFR_KEY",delParamMap.getStr("ATCH_FILE_ID1"));
			paramMap.put("REFR_COL_NM", "ATCH_FILE_ID1");  
			fileService.delMFile(paramMap);
			
			//(형선고 첨부파일 삭제)
			paramMap.put("REFR_KEY",delParamMap.getStr("ATCH_FILE_ID2"));
			paramMap.put("REFR_COL_NM", "ATCH_FILE_ID2");  
			fileService.delMFile(paramMap);
			
			return "jsonView";
		}

		
		/**
		 * 신상이동신청 접수처리 js
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/confirmTransferJs.kspo")
		public String confirmTransferJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			KSPOMap paramMap  = reqMap.getReqMap();
			
			int resultCnt = transferService.txConfirmTransfer(paramMap);

			model.addAttribute("resultCnt", resultCnt);
			
			return "jsonView";
		}
		
		
		
		/**
		 * 신상이동신청 엑셀 다운로드
		 * 
		 * @param request
		 * @param response
		 * @param model
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(value = "/selectTransferDownload.kspo")
		public void SoldierSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
			
			ModelAndView view = new ModelAndView();
			KSPOMap paramMap  = reqMap.getReqMap();
			
			//신상이동신청 조회
			KSPOList selectTransferList = transferService.selectTransferExcelList(paramMap);
			
			XSSFWorkbook wb = poiService.selectTransferListExcel(selectTransferList);
			
			response.setContentType("ms-vnd/excel");
			response.setHeader("Content-Disposition", "attachment;filename=TransferSelect.xlsx");
			
			wb.write(response.getOutputStream());
			response.getOutputStream().close();
			
		}
		
		
		
		
		
		
		
		
		
		
		
}
