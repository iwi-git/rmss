package org.kspo.web.account.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.account.service.VlunPlaceService;
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
 * @FileName : VlunPlaceController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 15. JHH : 최초작성
 * 2021. 11. 23. SCY : 개발
 * </pre>
 */
@Controller
@RequestMapping("/account")
public class VlunPlaceController extends BaseController{
	protected static String WEB_FILE_EXT   = PropertiesUtil.getString("WEB_FILE_EXT");		//파일확장자
	
	//공익복무처관리
	@Resource
	private VlunPlaceService vlunPlaceService;

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
	 * 공익복무처 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/VlunPlaceSelect.kspo")
	public String VlunPlaceSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectVlunPlaceList = vlunPlaceService.selectVlunPlaceList(paramMap);
		
		model.addAttribute("vlunPlaceList", selectVlunPlaceList);
		model.addAttribute("pageInfo",selectVlunPlaceList.getPageInfo());//페이지 정보
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/account/VlunPlaceSelect";
	}
	
	/**
	 * 공익복무처 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/VlunPlaceSelectDownload.kspo")
	public void VlunPlaceSelectDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		ModelAndView view = new ModelAndView();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//공익복무처 조회
		KSPOList selectVlunPlaceExcelList = vlunPlaceService.selectVlunPlaceExcelList(paramMap);
		
		
		SXSSFWorkbook wb = poiService.selectvlunPlaceListExcel(selectVlunPlaceExcelList);
//		XSSFWorkbook wb = poiService.selectvlunPlaceListExcel(selectVlunPlaceExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=vlunPlace.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
	/**
	 * 공익복무처 내용 상세
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectVlunPlaceDetailJs.kspo")
	public String selectVlunPlaceDetailJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
			
		KSPOMap selectVlunPlaceDetail = vlunPlaceService.selectVlunPlaceDetail(paramMap); //대상자 인적사항 불러오기
		
		model.addAttribute("detail", selectVlunPlaceDetail);
			
			
		return "jsonView";
	}
	
	/**
	 * 공익복무처 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertVlunPlaceJs.kspo")
	public String insertVlunPlaceJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		vlunPlaceService.insertVlunPlace(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 공익복무처 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateVlunPlaceJs.kspo")
	public String updateVlunPlaceJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		vlunPlaceService.updateVlunPlace(paramMap);

		return "jsonView";
	}
}
