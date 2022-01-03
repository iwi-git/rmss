/**
 * 
 */
package org.kspo.framework.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.kspo.framework.global.SystemConst;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : SessionUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class SessionUtil {
	
	private static Logger log = LoggerFactory.getLogger(SessionUtil.class);
	
	/**
	 * 세션 전체 삭제
	 * @param request
	 * @param sessionName
	 */
	public static void clearSession(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate();
	}
	
	/**
	 * 세션등록
	 * @param request
	 * @param session_id
	 * @throws Exception
	 */
	public static void setSession(HttpServletRequest request, String session_nm, Object obj) throws Exception {
		HttpSession session = request.getSession();
		session.setAttribute(session_nm, obj);
	}
	
	/**
	 * 세션 조회
	 * @param request
	 * @param String session_id
	 * @param String session_value
	 * @throws Exception
	 */
	public static String getSession(HttpServletRequest request, String session_id) throws Exception {
		HttpSession session = request.getSession();
		
		if(session == null) return "";
		
		return StringUtil.nullToBlank(session.getAttribute(session_id.toUpperCase()));
	}

	public static Object getObjectSession(HttpServletRequest request, String session_id) throws Exception {
		HttpSession session = request.getSession();
		
		if(session == null) return "";
		
		return session.getAttribute(session_id);
	}
	
	/**
	 * 세션등록
	 * @param request
	 * @param session_id
	 * @throws Exception
	 */
	public static void setSession(HttpServletRequest request, String session_id) throws Exception {
		HttpSession session = request.getSession();
		
		session.setAttribute(session_id.toUpperCase(), StringUtil.nullToCustom(request.getParameter(session_id), getSession(request, session_id)));
	}
	
	/**
	 * 세션등록
	 * @param request
	 * @param session_id
	 * @param session_val
	 * @throws Exception
	 */
	public static void setSession(HttpServletRequest request, String session_id, String session_val) throws Exception {
		HttpSession session = request.getSession();
		
		session.setAttribute(session_id.toUpperCase(), StringUtil.nullToBlank(session_val));
	}

	/**
	 * 세션의 유저정보 조회
	 * @param request
	 * @param string
	 * @return
	 * @throws Exception
	 */
	public static KSPOMap getUserInfo(HttpServletRequest request, String sessionId) throws Exception {
		HttpSession session = request.getSession();
		KSPOMap userMap = (KSPOMap) session.getAttribute(sessionId);
		return userMap;
	}

	/**
	 * 회원정보 세션 저장
	 * @param userInfo
	 * @param request 
	 * @throws Exception
	 */
	public static void setUserInfoSession(KSPOMap userInfo, HttpServletRequest request) throws Exception{
		
		log.warn("[MNGR_SN] : " + userInfo.getStr("MNGR_SN") + ", [MNGR_NM] : " + userInfo.getStr("MNGR_NM") + ", [LOCGOV_NM] : " + userInfo.getStr("LOCGOV_NM") + ", [GRP_SN] : " + userInfo.getStr("GRP_SN"));
		
		KSPOMap userMap = new KSPOMap();
		userMap.put(SystemConst._USER,      userInfo.getStr("MNGR_SN"));
		userMap.put(SystemConst._EMP_NO,   userInfo.getStr("MNGR_ID")); //사번추가
		userMap.put(SystemConst._MNGR_NM,   userInfo.getStr("MNGR_NM"));
		userMap.put(SystemConst._GRP_SN,    userInfo.getStr("GRP_SN"));
		userMap.put(SystemConst._MEMORG_SN,    userInfo.getStr("MEMORG_SN"));//가맹단체코드
		userMap.put(SystemConst._USER_DV,    userInfo.getStr("USER_DV"));//사용자구분		
		userMap.put(SystemConst._GAME_CD,    userInfo.getStr("GAME_CD"));//종목		
		SessionUtil.setSession(request, "userMap", userMap);
	}

	/**
	 * 아이디 저장 쿠키 등록
	 * @param paramMap
	 * @param userInfo 
	 * @param request 
	 * @param response
	 */
	public static void setUserInfoCookie(KSPOMap paramMap, KSPOMap userInfo, HttpServletRequest request, HttpServletResponse response)throws Exception {
		if("Y".equals(paramMap.getStr("idSave"))) {
			String mngrId = userInfo.getStr("MNGR_ID_ENC");
			Cookie setCookie = new Cookie("idSave", mngrId);
			response.addCookie(setCookie);
		} else {
			Cookie[] getCookie = request.getCookies();
			if(getCookie != null) {
				for (int i = 0; i < getCookie.length; i++) {
					getCookie[i].setMaxAge(0);
					response.addCookie(getCookie[i]);
				}
			}
		}
	}

}