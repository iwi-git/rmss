package org.kspo.web.main.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.main.service.MainService;
import org.kspo.web.system.code.service.CodeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : MainController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
@Controller
@RequestMapping("/main")
public class MainController extends BaseController {

	//메인
	@Resource
	private MainService mainService;
	
	//코드
	@Resource
	private CodeService codeService;

	/**
	 * 메인 화면 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main.kspo")
	public String main(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectCurYear = codeService.selectBasicYM();
						
		String INSPT_YEAR = paramMap.getStr("INSPT_YEAR");
		if("".equals(INSPT_YEAR)) {
			paramMap.put("INSPT_YEAR",selectCurYear.get("YEAR"));
		}
		String EXPR_YEAR = paramMap.getStr("EXPR_YEAR");
		if("".equals(EXPR_YEAR)) {
			paramMap.put("EXPR_YEAR",selectCurYear.get("YEAR"));
		}
		
		model.addAttribute("paramList",paramMap);
		model.addAttribute("partCount",mainService.selectPartCount(paramMap));//편입신청
		model.addAttribute("applyCount",mainService.selectApplyCount(paramMap));//사용자계정 신규신청 및 승인대기
		model.addAttribute("exprMmCount",mainService.selectExprMmCount(paramMap));//편입신청
		
		return "web/main/main";
	}

	
}
