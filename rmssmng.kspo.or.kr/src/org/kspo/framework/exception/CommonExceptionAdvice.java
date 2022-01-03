package org.kspo.framework.exception;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import javax.servlet.http.HttpServletRequest;

import org.kspo.framework.global.SystemConst;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.ServerUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

/**
 * @Since 2021. 3. 15.
 * @Author yunkidon@kspo.or.kr
 * @FileName : CommonExceptionAdvice.java
 * <pre>
 * 수정/업그레이드 해서 사용하시기 바랍니다.
 * Exception 발생시는 로깅만 하고, 특정 Exception 발생시만 web.xml에 정의된 error.jsp로 보낼건지 결정하시기 바랍니다. 
 * KSPOExceptionHandler를 참고하시기 바랍니다.
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * </pre>
 */
@ControllerAdvice
public class CommonExceptionAdvice {
	
	private static Logger log = LoggerFactory.getLogger(CommonExceptionAdvice.class);
	
	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public Model NoHandlerFoundExceptionHandler(Exception e, HttpServletRequest request, Model model) {

		KSPOMap paramMap  = new KSPOMap(request);
		String clientIp = paramMap.getStr(SystemConst._ClIENT_IP);
		String uri = paramMap.getStr(SystemConst._SERV_URI);
		String ip = (String)ServerUtil.getLocalServerIp();
		log.error("\n############################################################################################################"
				+ "\n" + "SERVER IP : " + ip + ""
			    + "\nclientIp : " + clientIp 
			    + "\nuri : " + uri + ""
			    + "\ncontent : " + e.toString() + ""
	    		+ "\nparameters : " + paramMap.toString() + ""
			    + "\ntrace : " + makeStackTrace(e) + ""
			    + "\n############################################################################################################");
		
		StringBuffer sb = new StringBuffer();
		sb.append("**EXCEPTION_LOG_MSG**");
		sb.append("<br/> SERV ADDR : " + ip + uri);
		sb.append("<br/> ERROR MSG : " + makeStackTrace(e).replace("\n", "<br>") );
		
		model.addAttribute("exceptionMsg", e.getMessage());
		model.addAttribute("exceptionCont", sb.toString());
	
		return model;		
	}
	

	@ExceptionHandler(Exception.class)
	protected ResponseEntity<KSPOMap> ExceptionHandler(Exception e, HttpServletRequest request, Model model) {
		
		KSPOMap paramMap = new KSPOMap(request);
		String clientIp = paramMap.getStr(SystemConst._ClIENT_IP);
		String uri = paramMap.getStr(SystemConst._SERV_URI);
		String ip = (String)ServerUtil.getLocalServerIp();
		log.error("\n############################################################################################################"
				+ "\n" + "SERVER IP : " + ip + ""
			    + "\nclientIp : " + clientIp 
			    + "\nuri : " + uri + ""
			    + "\ncontent : " + e.toString() + ""
	    		+ "\nparameters : " + paramMap.toString() + ""
			    + "\ntrace : " + makeStackTrace(e) + ""
			    + "\n############################################################################################################");
		
		StringBuffer sb = new StringBuffer();
		sb.append("**EXCEPTION_LOG_MSG**");
		sb.append("<br/> SERV ADDR   : " + ip + uri);
		sb.append("<br/> ERROR MSG   : " + makeStackTrace(e));
		sb.append("<br/> ERROR PARAM : " + paramMap.toString());
		
		paramMap.put("exceptionMsg", PropertiesUtil.getString("ERROR_99"));
		paramMap.put("exceptionCont", sb.toString());
		
		return new ResponseEntity<>(paramMap, HttpStatus.BAD_REQUEST);
	}
	
	/**
	 * <pre>
	 *    
	 * </pre>
	 * @param Throwable
	 * @return error
	 */
	public static String makeStackTrace(Throwable t) {
		if (t == null) return "";
		
		try {
			ByteArrayOutputStream bout = new ByteArrayOutputStream();
			t.printStackTrace(new PrintStream(bout));
			bout.flush();
			String error = new String(bout.toByteArray());
			
			error = error.replace("\r", "");
			error = error.replace("\tat", "");
			error = error.replace("\n", "<br>");
			
			return error;
		} catch(Exception ex) {			
			return "";
		}
	}
	
}

