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
import org.kspo.web.etc.service.PunishService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : PunishController.java
 * <pre> 징계관리 Controller
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * 2021. 11. 22. SCY : 개발
 * </pre>
 */
@Controller
@RequestMapping("/etc")
public class PunishController extends BaseController{
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	@Resource
	private PunishService punishService;
	
	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;
	
	/**
	 * 체육요원 징계 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/PunishSelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();

		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("THR_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		KSPOList selectPunishList = punishService.selectPunishSelectList(paramMap);
		
		model.addAttribute("punishList", selectPunishList);
		model.addAttribute("pageInfo",selectPunishList.getPageInfo());//페이지 정보
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("procStsList",this.cmmnDtlList("31")); //편입상태
		
//		model.addAttribute("procStsList",this.cmmnDtlList("202111220000534")); //징계관리 편입상태
		model.addAttribute("dsplStsList",this.cmmnDtlList("202111220000535")); //징계관리 처리상태
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/etc/PunishSelect";
	}
	
	/**
	 * 체육요원 징계 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/PunishSelectDownload.kspo")
	public void PunishSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육요원 징계 조회
		KSPOList selectPunishSelectList = punishService.selectPunishSelectExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectPunishSelectListExcel(selectPunishSelectList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=Punish.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 체육요원 징계 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectPunishDetailJs.kspo")
	public String selectPunishDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectPunishDetail = punishService.selectPunishDetail(paramMap);
		
		//파일 조회
		paramMap.put("REFR_TABLE_NM", "TRMD_DSPL_I");
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID");
		paramMap.put("REFR_KEY", selectPunishDetail.getStr("ATCH_FILE_ID"));
		
		KSPOList fileList = fileService.selectFileList(paramMap);

		model.addAttribute("detail", selectPunishDetail);
		model.addAttribute("fileList",fileList);
				
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 징계 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertPunishJs.kspo")
	public String insertPunishJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMD_DSPL_I","ATCH_FILE_ID", WEB_FILE_EXT);
					
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
		
		punishService.txInsertPunish(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육요원 징계 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deletePunishJs.kspo")
	public String deletePunishJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		punishService.deletePunishJs(paramMap);

		paramMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID"));
		paramMap.put("REFR_COL_NM", "ATCH_FILE_ID");
		paramMap.put("REFR_TABLE_NM", "TRMD_DSPL_I");
		 
		fileService.delMFile(paramMap);
		
		return "jsonView";
	}

	/**
	 * 체육요원 징계 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePunishJs.kspo")
	public String updatePunishJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//파일업로드
		KSPOList fileList = fileService.fileUpload(request,"/etc","TRMD_DSPL_I","ATCH_FILE_ID", WEB_FILE_EXT);
					
		if(!fileList.isEmpty()){ //업로드 파일 있을경우
			
			if("".equals(paramMap.get("ATCH_FILE_ID"))){
				String fileGrpKeyMap = fileService.selectFileGrpRefrKey();
				
				paramMap.put("ATCH_FILE_ID",fileGrpKeyMap);
			}	
				
			for(int i=0; i<fileList.size(); i++){ 
			  
			  KSPOMap fileMap = (KSPOMap) fileList.get(i);
			  
			  fileMap.put("EMP_NO",paramMap.getStr("EMP_NO"));
			  fileMap.put("REFR_KEY",paramMap.getStr("ATCH_FILE_ID"));
			  
			  fileService.insertFileList(fileMap);
	  
	  		}
	  	}
		
		punishService.txUpdatePunish(paramMap);
		
		return "jsonView";
	}
	
}
