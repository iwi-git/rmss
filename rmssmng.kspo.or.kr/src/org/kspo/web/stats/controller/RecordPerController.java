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
import org.kspo.web.stats.service.RecordPerService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 11. 24.
 * @Author JHH
 * @FileName : RecordPerController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 11. 24. JHH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/stats")
public class RecordPerController extends BaseController{
	//코드
	@Resource
	private CodeService codeService;

	//엑셀다운로드
	@Resource
	private PoiService poiService;
	
	@Resource
	private RecordPerService recordPerService;
	
	/**
	 * 공익복무실적 - 개인
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordPerSelect.kspo")
	public String RecordPerSelect(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		if(!StringUtil.isEmpty(paramMap.getStr("MLTR_ID"))) {
			KSPOMap recordPer = recordPerService.selectRecordPer(paramMap);
			KSPOList recordPerList = recordPerService.selectRecordPerList(paramMap);
			
			model.addAttribute("recordPer", recordPer);
			model.addAttribute("recordPerList", recordPerList);
		}
		
		model.addAttribute("gameNmList",this.cmmnAltCodeList("202111050000341",paramMap.getStr("SESSION_GAME_CD"))); //종목
		
		return "web/stats/RecordPerSelect";
	}
	
	/**
	 * 공익복무실적 - 개인 엑셀 다운로드
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/RecordPerDownload.kspo")
	public void RecordPerDownload(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOMap recordPer = recordPerService.selectRecordPer(paramMap);
		KSPOList selectRecordPerExcelList = recordPerService.selectRecordPerList(paramMap);
		
		XSSFWorkbook wb = poiService.selectRecordPerExcel(recordPer, selectRecordPerExcelList);
		
		response.setContentType("ms-vnd/excel");
		response.setHeader("Content-Disposition", "attachment;filename=RecordPer.xlsx");
		
		wb.write(response.getOutputStream());
		response.getOutputStream().close();
		
	}

}
