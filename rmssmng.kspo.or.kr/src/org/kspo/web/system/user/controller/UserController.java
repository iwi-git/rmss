package org.kspo.web.system.user.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.Sha256Util;
import org.kspo.web.account.service.AccountService;
import org.kspo.web.system.auth.service.AuthService;
import org.kspo.web.system.user.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : UserController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/user")
public class UserController extends BaseController {

	//사용자관리
	@Resource
	private UserService userService;
	
	//체육단체 계정관리
	@Resource
	private AccountService accountService;

	//권한관리
	@Resource
	private AuthService authService;
	
	@RequestMapping(value = "../cmmn/validator.kspo")
	public String validate() throws Exception{
		return "/cmmn/validator";
	}
	
	/**
	 * 사용자 관리 사용자 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectUserList.kspo")
	public String selectUserList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();

		KSPOList selectUserList = userService.selectUserList(paramMap);
		model.addAttribute("userList",selectUserList);
		
		model.addAttribute("pageInfo",selectUserList.getPageInfo());//페이지 정보
		
		model.addAttribute("userDvList",this.cmmnDtlList("15"));
		
		return "web/system/user/user";
	}

	/**
	 * 사용자 관리 사용자 상세 수정 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateUserDtlJs.kspo")
	public String updateUserDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		try {
			userService.updateUserDtl(paramMap);
		} catch (Exception e) {
			resultMap = this.getErrMessage("USER","98");
			e.printStackTrace();
		}

		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}

	/**
	 * 사용자 관리 사용자 상세 등록 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/inserUserDtlJs.kspo")
	public String inserUserDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap resultMap = new KSPOMap();
		KSPOMap paramMap  = reqMap.getReqMap();
		
		int selectAccountIdCheck = accountService.selectAccountIdCheck(paramMap.getStr("MNGR_ID"));
		
		if(selectAccountIdCheck > 0) {
			resultMap = this.getErrMessage("USER","98");
		}else {
			String password = Sha256Util.encryptSHA256((String)paramMap.get("MNGR_ID"));
			paramMap.put("password",password);
			userService.insertUserDtl(paramMap);
		}
		
		model.addAttribute("result", resultMap);
		
		return "jsonView";
	}

	/**
	 * 사용자 관리 사용자 상세 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteUserDtlJs.kspo")
	public String deleteUserDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
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
		
		userService.deleteUserDtl(paramMap);
		
		return "jsonView";
	}

	/**
	 * 사용자 관리 사용자 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectUserDtlListJs.kspo")
	public String selectUserDtlListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectUserDtlList = userService.selectUserDtlList(paramMap);
		
		model.addAttribute("userDtlInfo", selectUserDtlList);
		model.addAttribute("userDvList",this.cmmnDtlList("15"));
		
		KSPOMap grpSnMap = new KSPOMap();
		grpSnMap.put("USER_DV", selectUserDtlList.getStr("userDv"));
		model.addAttribute("grpSnList",authService.selectDefaultAuthMstList(grpSnMap));
		
		return "jsonView";
	}

	/**
	 * 로그인한 회원정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectloginUserDtlList.kspo")
	public String selectloginUserDtlList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectloginUserDtl = userService.selectloginUserDtlList(paramMap);
		
		model.addAttribute("loginUserDtl", selectloginUserDtl);
		
		return "jsonView";
	}

}
