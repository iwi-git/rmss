package org.kspo.web.system.auth.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.auth.service.AuthService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : AuthController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/auth")
public class AuthController extends BaseController {


	//권한관리
	@Resource
	private AuthService authService;


	/**
	 * 권한관리 관리 권한그룹 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAuthList.kspo")
	public String selectAuthList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList selectAuthMstList = authService.selectAuthMstList(paramMap);
		model.addAttribute("authList",selectAuthMstList);
		
		model.addAttribute("pageInfo",selectAuthMstList.getPageInfo());//페이지 정보
		
		model.addAttribute("userDvList",this.cmmnDtlList("15"));
		
		return "web/system/auth/auth";
	}

	/**
	 * 권한관리 관리 권한설정 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAuthDtlListJs.kspo")
	public String selectAuthDtlListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList selectAuthDtlList = authService.selectAuthDtlList(paramMap);
		
		model.addAttribute("authDtlList", selectAuthDtlList);
			
		return "jsonView";
	}

	/**
	 * 권한관리 관리 권한그룹 조회(단건)
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAuthMstJs.kspo")
	public String selectAuthMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
	
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectAuthMst = authService.selectAuthMst(paramMap);
		
		model.addAttribute("authMst", selectAuthMst);
			
		return "jsonView";
	}

	/**
	 * 권한관리 관리 권한설정 수정
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAuthDtlJs.kspo")
	public String updateAuthDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList reqList = paramMap.getMapInList("DETAIL_SN");
		authService.txUpdateAuthDtl(reqList, paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 권한관리 관리 권한그룹 등록
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertAuthMstJs.kspo")
	public String insertAuthMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		authService.txInsertAuthMst(paramMap);
		
		return "jsonView";
	}

	/**
	 * 권한관리 관리 권한그룹 삭제
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteAuthMstJs.kspo")
	public String deleteAuthMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		List<String> chkList = new ArrayList<String>();
		if(paramMap.get("chk") instanceof String[]) {
			String[] chkArr = paramMap.getStrArry("chk");
			for(String chk : chkArr) {
				chkList.add(chk);
			}
		}else {
			chkList.add(paramMap.getStr("chk"));
		}
		paramMap.put("chk", chkList);
		
		authService.txDeleteAuthMst(paramMap);
		
		return "jsonView";
	}

	/**
	 * 권한관리 관리 권한그룹 수정
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAuthMstJs.kspo")
	public String updateAuthMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		authService.txUpdateAuthMst(paramMap);
		
		return "jsonView";
	}
	
	/**
	 * 권한관리 권한그룹 기본 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDefaultAuthMstListJs.kspo")
	public String selectDefaultAuthMstListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectDefaultAuthMstList = authService.selectDefaultAuthMstList(paramMap);
		
		model.addAttribute("grpSnList", selectDefaultAuthMstList);
			
		return "jsonView";
	}
	
}
