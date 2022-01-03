package org.kspo.framework.interceptor;

import java.io.IOException;
import java.util.Enumeration;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.time.StopWatch;
import org.kspo.framework.global.SystemConst;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.framework.util.WebUtil;
import org.kspo.web.notice.service.NoticeService;
import org.kspo.web.system.auth.service.AuthService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : FrontInterceptor.java
 * <pre>
 * 전역변수 : StopWatch stopWatch가 쓰레드 safe하지 않아서 처리해야 한다.
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. yunkidon@kspo.or.kr
 * </pre>
 */
public class FrontInterceptor extends HandlerInterceptorAdapter{

	private static Logger log = LoggerFactory.getLogger(FrontInterceptor.class);

	/**
	 * 특정이상 시간 걸리는 Request 모니터링용으로  0이면 모두 로깅이다. Spring의 properties가 static 지원을 않함.
	 */
	private int REQUEST_OVERTIME = PropertiesUtil.getInt("REQUEST_EXEC_OVERTIME_MILLIS");
	
	//권한관리
	@Resource
	private AuthService authService;

	//게시판
	@Resource
	private NoticeService noticeService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		
		/**
		 * request 부하 모니터링 및 로깅용 변수 생성
		 */
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		
		request.setAttribute("stopWatch", stopWatch);
		
		KSPOMap paramMap = new KSPOMap(request);

		//로그인 여부 확인
		if(this.checkLogin(paramMap)) {
			WebUtil.ajaxPrintMsg(response,request,"96","/login/login.kspo");
			return false;
		}
		
		//ajax 호출 확인
		if(!this.jsUriCheck(paramMap)) {
			request.setAttribute("leftMenu",   SystemConst.getLeftMenu());	//메뉴
			request.setAttribute("noticeList", noticeService.selectTopNoticeList());//상단 긴급공지 리스트
		}
		
		//권한 확인
		String errCode = this.authCheck(paramMap);
		if(!StringUtil.isEmpty(errCode)) {
			WebUtil.ajaxPrintMsg(response,request,errCode,"/index.kspo?gMenuSn=30");
			return false;
		}
		
		return true;
	}


	/**
	 * 로그인 여부 체크
	 * @param paramMap - a map contains with request parameter, session values, etc... 
	 * @return boolean - ture or flase
	 */
	private boolean checkLogin(KSPOMap paramMap) {
		log.warn("[_USER] : " + paramMap.getStr(SystemConst._USER));
		return "".equals(paramMap.getStr(SystemConst._USER)) ? true : false ;		
	}
	
	
	/**
	 * ajax 호출 확인
	 * @param paramMap
	 * @return
	 */
	private boolean jsUriCheck(KSPOMap paramMap) {
		
		String ajaxPattern = "^\\S*(Js)+.(kspo)$";
		String servUri = paramMap.getStr(SystemConst._SERV_URI);
		
		return servUri.matches(ajaxPattern);
	}

	/**
	 * 권한 체크
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	private String authCheck(KSPOMap paramMap) throws Exception {
		  
		String errCode = "";
		
		KSPOMap authMap = authService.selectAuthDtlInfo(paramMap);
		
		if(authMap != null) {
			
			errCode = getAuthCheckErrCode(paramMap, authMap);
			
			accessLog(paramMap, authMap);
			
		}
		
		return errCode;
	}

	/**
	 * 권한 개인정보, 엑셀 다운 체크
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	private void accessLog(KSPOMap paramMap, KSPOMap authMap)throws Exception {

		String servUri = paramMap.getStr(SystemConst._SERV_URI);

		String PRI_INCLS_YN = authMap.getStr("PRI_INCLS_YN");
		
		String EXCEL_YN       = authMap.getStr("EXCEL_YN");
		
		String excelPattern  = "^\\S*(select)\\S+ExcelDownload.(kspo)$";
		boolean excelMatches = servUri.matches(excelPattern);
		
		if("Y".equals(EXCEL_YN) && excelMatches) {
			
			paramMap.put("dataGbCd","E");
			paramMap.put("accParam",paramMap.toString());
			authService.insertAccessLog(paramMap);
			
		} else if("Y".equals(PRI_INCLS_YN)) {
			
			paramMap.put("dataGbCd","W");
			paramMap.put("accParam",paramMap.toString());
			authService.insertAccessLog(paramMap);
			
		}
		
	}

	/**
	 * 권한 에러 체크
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	private String getAuthCheckErrCode(KSPOMap paramMap, KSPOMap authMap) {

		String errCode = "";
		
		String servUri = paramMap.getStr(SystemConst._SERV_URI);
		
		String READ_YN  = authMap.getStr("READ_YN");
		String WRITE_YN = authMap.getStr("WRITE_YN");
		String EXCEL_YN = authMap.getStr("EXCEL_YN");
		
		String readPattern = "^\\S*(select)\\S+.(kspo)$";
		String writePattern = "^\\S*(update|insert|delete)\\S+.(kspo)$";
		String excelPattern = "^\\S*(select)\\S+ExcelDownload.(kspo)$";
		
		boolean readMatches = servUri.matches(readPattern);
		boolean writeMatches = servUri.matches(writePattern);
		boolean excelMatches = servUri.matches(excelPattern);
		
		if("N".equals(READ_YN) && readMatches) {
			errCode = "98";
		}
		if("N".equals(WRITE_YN) && writeMatches) {
			errCode = "97";
		}
		if("N".equals(EXCEL_YN) && excelMatches) {
			errCode = "95";
		}
		
		return errCode;
	}


	/**
	 * 컨트롤러가 요청을 실행한 후 처리, view(jsp)로 forward되기 전에 리턴값 : void 컨트롤러 실행도중 예외 발생인
	 * 경우 postHandle()는 실행되지 않음
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object controller, ModelAndView modelAndView) throws Exception {

	}

	/**
	 * 클라이언트의 요청을 처리한 뒤에 실행 리턴값 : void 컨트롤러 처리 도중이나 view 생성과정 중에 예외가 발생하더라도
	 * afterCompletion()은 실행됨
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {		

		StopWatch stopWatch = (StopWatch)request.getAttribute("stopWatch");
		
		if( stopWatch!=null && stopWatch.isStarted()) {
			stopWatch.stop();
			doLoging(request, response, stopWatch);
		}
		
	}

	/**
	 * 특정 수행시간 이상일 경우 로깅을 남긴다.
	 * @param request
	 * @param response
	 * @throws IOException
	 * @throws ServletException
	 */
	public void doLoging(ServletRequest request, ServletResponse response, StopWatch stopWatch) {
		HttpServletRequest req = (HttpServletRequest) request;
		
		try {
			
		    if (((stopWatch.getTime())) >= REQUEST_OVERTIME) {
		    	log.error(
						"\n\n\n\n********************************** Tunning the Request! ******************************************"
						+ "\n request execution Time : " + stopWatch.toString()	    	
				        +"\n" + getParameters(req)
			            +"\n--------------------------------------------------------------------------------------------------------------------"
					    + "\nElapsed time : "+ ((stopWatch.getTime()) / 1000.0) +" second"
					    +"\n" + getURI(request) //+ "\n" //+ getParameters(req)
					    + "\n--------------------------------------------------------------------------------------------------------------------\n\n");				
		    }else {
		    	log.info("\n\n--------------------------------------------------------------------------------------------------------------------"
				    + "\nElapsed time : "+ ((stopWatch.getTime()) / 1000.0) +" second"
				    +"\n" + getURI(request) + "\n" + getParameters(req)
				    + "\n--------------------------------------------------------------------------------------------------------------------\n\n");
		    }
		}catch(Exception e) {
			log.error("" + e.getMessage());
		}
			
	}

	/**
	 * <pre>
	 *    파라미터 획득(로그용)
	 * </pre>
	 * @param request
	 * @return String request
	 * @exception Exception
	 */
	protected String getParameters(HttpServletRequest request) {
		StringBuffer sb = new StringBuffer();
		
		try {
			Enumeration<?> parameterNames = request.getParameterNames();
			
			sb.append("\n**************** request Params ****************");
			sb.append("\nIP : " + request.getRemoteAddr());
			while (parameterNames.hasMoreElements()) {
			    String key = (String)parameterNames.nextElement();
			    String val = request.getParameter(key);
			    
			    sb.append(",\n " + key + " : " + val + "");
			}
			sb.append("\n**************** request Params ****************");
			
			HttpSession session = request.getSession(true);
			
			Enumeration<?> em = session.getAttributeNames();
			
			sb.append("\n**************** Session values ****************");
			while (em.hasMoreElements()) {
				String se = (String) em.nextElement();
				
				sb.append(",\n " + se + " : " + session.getAttribute(se) + "");
			}			
			sb.append("\n**************** Session values ****************");			
		} catch (Exception e) {
			log.error("" + e.getMessage());
		}

		return sb.toString();
	}

	/**
	 * <pre>
	 *    URI 획득
	 * </pre>
	 * @param request
	 * @return String
	 */
	protected String getURI(ServletRequest request) {
		if (request instanceof HttpServletRequest) {
			return ((HttpServletRequest) request).getRequestURI();
		} else {
			return "Not an HttpServletRequest";
		}
	}		

}
