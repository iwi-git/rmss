package org.kspo.web.account.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.account.service.MemOrgService;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 15.
 * @Author JHH
 * @FileName : MemOrgController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/account")
public class MemOrgController extends BaseController{

	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	//체육단체
	@Resource
	private MemOrgService memOrgService;
	
	//엑셀 다운로드
	@Resource
	private PoiService poiService;
	
	/**
	 * 체육단체 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/MemOrgSelect.kspo")
	public String SoldierSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();

		//체육단체 조회
		KSPOList selectMemOrgList = memOrgService.selectMemOrgList(paramMap);
		
		model.addAttribute("memOrgList",selectMemOrgList);
		model.addAttribute("pageInfo",selectMemOrgList.getPageInfo());//페이지 정보
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/account/MemOrgSelect";
	}
	
	/**
	 * 체육단체 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/MemOrgSelectDownload.kspo")
	public void MemOrgSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//체육단체 조회
		KSPOList selectMemOrgExcelList = memOrgService.selectMemOrgExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectMemOrgListExcel(selectMemOrgExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=MemOrg.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 체육단체 내용 상세
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectMemOrgDetailJs.kspo")
	public String selectMemOrgDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
			
		KSPOMap selectMemOrgDetail = memOrgService.selectMemOrgDetail(paramMap); //대상자 인적사항 불러오기
		
		model.addAttribute("detail", selectMemOrgDetail);
			
			
		return "jsonView";
	}
	
	/**
	 * 체육단체 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertMemOrgJs.kspo")
	public String insertMemOrgJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		memOrgService.insertMemOrg(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 체육단체 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateMemOrgJs.kspo")
	public String updateMemOrgJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		memOrgService.updateMemOrg(paramMap);

		return "jsonView";
	}
}
