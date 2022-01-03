package org.kspo.web.stats.controller;

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
import org.kspo.web.file.service.FileService;
import org.kspo.web.stats.service.TwoJobPerService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.kspo.framework.email.SendEmail;

/**
 * @Since 2021. 11. 24.
 * @Author JHH
 * @FileName : TwoJobPerController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 24. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/stats")
public class TwoJobPerController extends BaseController{
	//코드
	@Resource
	private CodeService codeService;

	//첨부파일
	@Resource
	private FileService fileService;
	
	@Resource
	private TwoJobPerService twoJobPerService;
		
	//엑셀다운로드
	@Resource
	private PoiService poiService;
	
	
	/**
	 * 겸직허가 신청현황
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TwoJobPerSelect.kspo")
	public String TwoJobPerSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		KSPOMap paramMap  = reqMap.getReqMap();
		
		if("".equals(paramMap.getStr("STD_YMD"))) {
			KSPOMap todaySevenday = this.selectTodaySevenday();
			paramMap.put("STD_YMD",todaySevenday.getStr("THR_YMD"));
			paramMap.put("END_YMD",todaySevenday.getStr("END_YMD"));
		}
		
		KSPOList selectTwoJobPerList = twoJobPerService.selectTwoJobPerList(paramMap);
		
		model.addAttribute("towJobPerList", selectTwoJobPerList);
		model.addAttribute("STD_YMD",StringUtil.isEmpty(paramMap.getStr("STD_YMD"))?this.selectTodaySevenday():paramMap.getStr("STD_YMD")); //날짜
		model.addAttribute("END_YMD",StringUtil.isEmpty(paramMap.getStr("END_YMD"))?this.selectTodaySevenday():paramMap.getStr("END_YMD")); //날짜
		model.addAttribute("pageInfo",selectTwoJobPerList.getPageInfo());//페이지 정보	
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		
		return "web/stats/TwoJobPerSelect";
	}
	
	/**
	 * 체육요원 겸직허가현황 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/TwoJobPerDownload.kspo")
	public void TwoJobPerDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		//사용자 접속이력 조회
		KSPOList selectTwoJobPerExcelList = twoJobPerService.selectTwoJobPerExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectTwoJobPerListExcel(selectTwoJobPerExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=TwoJobPer.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
}
