package org.kspo.web.system.code.controller;



import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.code.service.CodeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : CodeCotroller.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. SCY
 * </pre>
 */
@Controller
@RequestMapping("/code")
public class CodeController extends BaseController{

	private static Logger log = LoggerFactory.getLogger(CodeController.class);
	
	//코드관리
	@Resource(name = "codeService")
	private CodeService codeService;

	/**
	 * 공통코드 관리 대분류 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCodeList.kspo")
	public String selectCodeList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();

		KSPOList selectCodeMstList = codeService.selectCodeMstList(paramMap);
		model.addAttribute("codeMstList",selectCodeMstList);
		
		model.addAttribute("pageInfo",selectCodeMstList.getPageInfo());//페이지 정보
		
		return "web/system/code/code";
	}
	
	/**
	 * 공통코드 관리 소분류 조회 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCodeDtlListJs.kspo")
	public String selectCodeDtlListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectCodeDtlList = codeService.selectCodeDtlList(paramMap);
		
		model.addAttribute("codeDtlList", selectCodeDtlList);
		
		return "jsonView";
	}
	
	/**
	 * 공통코드 관리 대분류 조회(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCodeMstJs.kspo")
	public String selectCodeMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOMap selectCodeMst = codeService.selectCodeMst(paramMap);
		
		model.addAttribute("codeMst", selectCodeMst);
		
		
		return "jsonView";
	}
	
	/**
	 * 공통코드 관리 소분류 조회(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCodeDtlJs.kspo")
	public String selectCodeDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOMap selectCodeDtl = (KSPOMap) codeService.selectCodeDtl(paramMap);
		
		model.addAttribute("codeDtl", selectCodeDtl);

		return "jsonView";
	}

	/**
	 * 공통코드 관리 대분류 수정(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCodeMstJs.kspo")
	public String updateCodeMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
			
		KSPOMap paramMap  = reqMap.getReqMap();
		codeService.updateCodeMst(paramMap);
		return "jsonView";
	}

	/**
	 * 공통코드 관리 소분류 수정(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCodeDtlJs.kspo")
	public String updateCodeDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		codeService.updateCodeDtl(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 공통코드 관리 대분류 등록(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertCodeMstJs.kspo")
	public String insertCodeMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		codeService.insertCodeMst(paramMap);
		
//		String cmmnNm = paramMap.getStr("cmmnNm");
//		int cmmnNmLength = cmmnNm.getBytes("UTF-8").length;
//		
//		log.warn("[cmmnNm] : " + cmmnNm + ", [cmmnNmLength] : " + cmmnNmLength);
		
		return "jsonView";
	}

	/**
	 * 공통코드 관리 소분류 등록(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertCodeDtlJs.kspo")
	public String insertCodeDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		codeService.insertCodeDtl(paramMap);
		
		return "jsonView";
	}

	/**
	 * 공통코드 관리 대분류 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 * 
	 * 대분류 코드 삭제 시 소분류 코드도 삭제 진행
	 */
	@RequestMapping(value = "/deleteCodeMstJs.kspo")
	public String deleteCodeMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		List<String> mstChkList = new ArrayList<String>();
		if(paramMap.get("mstChk") instanceof String[]) {
			String[] mstChkArr = paramMap.getStrArry("mstChk");
			for(String mstChk : mstChkArr) {
				mstChkList.add(mstChk);
			}
		}else {
			mstChkList.add(paramMap.getStr("mstChk"));
		}
		paramMap.put("mstChk", mstChkList);
		
		codeService.txDeleteCodeMstList(paramMap);
		
		
		return "jsonView";
	}
	
	/**
	 * 공통코드 관리 소분류 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteCodeDtlJs.kspo")
	public String deleteCodeDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		List<String> dtlChkList = new ArrayList<String>();
		if(paramMap.get("dtlChk") instanceof String[]) {
			String[] dtlChkArr = paramMap.getStrArry("dtlChk");
			for(String dtlChk : dtlChkArr) {
				dtlChkList.add(dtlChk);
			}
		}else {
			dtlChkList.add(paramMap.getStr("dtlChk"));
		}
		paramMap.put("dtlChk", dtlChkList);
		
		codeService.deleteCodeDtlList(paramMap);
		
		return "jsonView";
	}
	
}
