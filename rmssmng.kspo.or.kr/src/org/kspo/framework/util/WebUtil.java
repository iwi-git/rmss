package org.kspo.framework.util;

import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.StringUtils;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : WebUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class WebUtil {

	/**
	 * <p>request의 파라미터 값을 조회한다.</p>
	 * @param  request
	 * @param  파라미터 이름
	 * @param  파라미터가 NULL 이거나 공백일 경우 초기 값
	 * @return Object
	 */
	public static Object getParameter(HttpServletRequest request , String name, Object change) {
		if(StringUtils.isEmpty(request.getParameter(name))){
			return change;
		}else{
			return request.getParameter(name);
		}
	}

	/**
	 * 유효하지 않은 단어가 포함되었는지 확인
	 * @param val
	 * @return
	 */
	public static String getMatchInvaildWord(String val) throws Exception {

		String [] limitWords;

		limitWords = new String[] {"<", ">", "&lt;", "&gt;", "script", "iframe", "document", "alert"};

		for(int i=0; i<limitWords.length; i++) {
			if(val != null ){
				if(val.indexOf(limitWords[i]) > -1){
					return limitWords[i];
				}     
			}
		}

		return null;
	}

	/**
	 * AJAX ALERT 처리
	 * @param response
	 * @param request
	 * @param string
	 */
	public static void ajaxPrintMsg(HttpServletResponse response, HttpServletRequest request, String errCd, String url)throws Exception {
		
		String msg = PropertiesUtil.getString("ERROR_" + errCd);
		
		ajaxPrintMsg(response,msg,request.getContextPath() + url);
	}
	/**
	 * AJAX ALERT 처리
	 * @param response
	 * @param msg : 메세지
	 * @param type : B:history.back(), L:location.href
	 * @param url : return url
	 * @throws Exception
	 */
	public static void ajaxPrintMsg(HttpServletResponse response, String msg,String url)throws Exception{
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		StringBuffer sb = new StringBuffer();
		sb.append( "<html lang=\"ko\" xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ko\">" );
		sb.append( "<title>알림</title>" );
		sb.append( "<script language='javascript'>" );
		
		if(msg != null && !"".equals(msg)) {
			sb.append( "fnAlert('" + msg + "','','l','" + url + "');" );
		}
		
		sb.append( "</script>" );
		sb.append( "</html>" );
		out.println( sb.toString() );
		out.flush();
		out.close();
	}
	
	public static HashMap<Object, Object> convertMap(HttpServletRequest request){
		HashMap<Object,Object> hm = new HashMap<Object, Object>();
		
		Enumeration<String> names = request.getParameterNames();
		
		while(names.hasMoreElements())
		{
			String retName = names.nextElement().toString();
			Object obj = request.getParameter(retName);
			Object objs [] = request.getParameterValues(retName);
			
			if(objs != null && objs.length > 1)
			{
				hm.put(retName, objs);
			}else{
				hm.put(retName, obj);
			}
			
		}
			
		return hm;
	}
}