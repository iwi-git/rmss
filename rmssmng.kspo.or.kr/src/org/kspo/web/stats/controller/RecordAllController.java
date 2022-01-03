package org.kspo.web.stats.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hsqldb.lib.StringUtil;
import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.apply.service.PoiService;
import org.kspo.web.file.service.FileService;
import org.kspo.web.stats.service.RecordAllService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Since 2021. 11. 24.
 * @Author JHH
 * @FileName : RecordAllController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 24. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/stats")
public class RecordAllController extends BaseController{
	
	//공익복무실적
	@Resource
	private RecordAllService recordAllService;
	
	//코드
	@Resource
	private CodeService codeService;

	//엑셀다운로드
	@Resource
	private PoiService poiService;
	
	/**
	 * 공익복무실적 - 총괄
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordAllSelect.kspo")
	public String RecordAllSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList srchYearList = this.yearList();//조회년도
		
		if(StringUtil.isEmpty(paramMap.getStr("srchYear"))) {
			KSPOMap defYearMap = (KSPOMap) srchYearList.get(0);
			paramMap.put("srchYear", defYearMap.getStr("YEAR"));
		}
		
		KSPOList selectRecordAllList = recordAllService.selectRecordAllList(paramMap);
		
		model.addAttribute("recordAllList", selectRecordAllList);
		model.addAttribute("pageInfo",selectRecordAllList.getPageInfo());//페이지 정보
		model.addAttribute("memOrgSelect",this.memOrgList(paramMap));//체육단체
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		model.addAttribute("viewList",this.cmmnDtlList("202112020000543")); //뷰카운트
		model.addAttribute("srchYearList", srchYearList);//조회년도
		
		return "web/stats/RecordAllSelect";
	}
	
	/**
	 * 체육요원 공익복무실적 엑셀 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordAllDownload.kspo")
	public void RecordAllDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectRecordAllExcelList = recordAllService.selectRecordAllExcelList(paramMap);
		
		XSSFWorkbook wb = poiService.selectRecordAllListExcel(selectRecordAllExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=RecordAll.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}
	
}
