package org.kspo.web.account.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.web.file.service.FileService;
import org.kspo.web.account.service.AccHistoryService;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : AccHistoryController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/account")
public class AccHistoryController extends BaseController{
	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	@Resource
	private AccHistoryService accHistoryService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;
	
	/**
	 * 사용자 접속이력 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/AccHistorySelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//접속이력 조회
		KSPOList selectAcHsList = accHistoryService.selectAcHsList(paramMap);
		model.addAttribute("accHsList",selectAcHsList);
		model.addAttribute("pageInfo",selectAcHsList.getPageInfo());//페이지 정보
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/account/AccHistorySelect";
	}
	
	/**
	 * 사용자 접속이력 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/AccHistoryDownload.kspo")
	public void AccHistoryDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//사용자 접속이력 조회
		KSPOList selectAcHsExcelList = accHistoryService.selectAcHsExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectAcHsListExcel(selectAcHsExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=AcHs.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
		
}
