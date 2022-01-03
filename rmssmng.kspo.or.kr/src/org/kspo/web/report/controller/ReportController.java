package org.kspo.web.report.controller;

import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.jwt.JWTManager;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 리포트 처리 콘트롤러
 * @Since 2021. 12. 15
 * @Author LJW
 * 
 */
@Controller
@RequestMapping("/report")
public class ReportController extends BaseController {
	
	/**
	 * 리포트 서버로 전달할 파라미터를 jwt토큰으로 생성
	 * @param reqMap
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "RequestReport.kspo")
	public String RequestReport(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		JWTManager jwtManager = JWTManager.getInstance();
		
		String jwt = jwtManager.getToken();
		
		KSPOMap reqRepMap = new KSPOMap();
		reqRepMap.put("jrfnm", paramMap.getStr("jrfnm"));
		reqRepMap.put("arg", paramMap.getStr("arg"));
		
		jwt = jwtManager.getToken(reqRepMap, Calendar.MINUTE, 5);
		
		model.addAttribute("resultStr", jwt);
		
		return "jsonView";
	}
	
	
}
