package org.kspo.web.system.menu.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.system.menu.service.MenuService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : MenuCotroller.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/menu")
public class MenuController extends BaseController {

	//메뉴관리
	@Resource
	private MenuService menuService;

	/**
	 * 메뉴 관리 대메뉴 조회
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMenuList.kspo")
	public String selectMenuList(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectMenuMstList = menuService.selectMenuMstList(paramMap);
		model.addAttribute("menuMstList",selectMenuMstList);
		
		model.addAttribute("pageInfo",selectMenuMstList.getPageInfo());//페이지 정보
		
		model.addAttribute("menuTyList",this.cmmnDtlList("16"));
		
		return "web/system/menu/menu";
	}
	
	/**
	 * 메뉴 관리 소메뉴 조회 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMenuDtlListJs.kspo")
	public String selectMenuDtlListJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOList selectMenuDtlList = menuService.selectMenuDtlList(paramMap);
		
		model.addAttribute("menuDtlList", selectMenuDtlList);
			
		return "jsonView";
	}
	
	/**
	 * 메뉴 관리 대메뉴 조회(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMenuMstJs.kspo")
	public String selectMenuMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{

		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOMap selectMenuMst = menuService.selectMenuMst(paramMap);
		
		model.addAttribute("menuMst", selectMenuMst);
			
		return "jsonView";
	}
	
	/**
	 * 메뉴 관리 소메뉴 조회(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMenuDtlJs.kspo")
	public String selectMenuDtlJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		
		KSPOMap selectMenuDtl = menuService.selectMenuDtl(paramMap);
		
		model.addAttribute("menuDtl", selectMenuDtl);
			
		return "jsonView";
	}

	/**
	 * 메뉴 관리 메뉴 수정(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateMenuJs.kspo")
	public String updateMenuJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		menuService.updateMenu(paramMap);
			
		return "jsonView";
	}

	/**
	 * 메뉴 관리 메뉴 등록(단건) js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertMenuJs.kspo")
	public String insertMenuJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		menuService.insertMenu(paramMap);
		
		return "jsonView";
	}

	/**
	 * 메뉴 관리 메뉴 삭제 js
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteMenuMstJs.kspo")
	public String deleteMenuMstJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap  = reqMap.getReqMap();
		List<String> chkList = new ArrayList<String>();
		if(paramMap.get("CHK") instanceof String[]) {
			String[] chkArr = paramMap.getStrArry("CHK");
			for(String chk : chkArr) {
				chkList.add(chk);
			}
		}else {
			chkList.add(paramMap.getStr("CHK"));
		}
		paramMap.put("CHK", chkList);
		
		menuService.deleteMenuList(paramMap);
		
		return "jsonView";
	}

}
