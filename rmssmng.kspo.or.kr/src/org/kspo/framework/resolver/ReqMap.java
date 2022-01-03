package org.kspo.framework.resolver;

import javax.servlet.http.HttpServletRequest;

import org.kspo.framework.util.KSPOMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : ReqMap.java
 * <pre>
 * 1. Request parmeter는 convert2CamelCase 처리하지 않는다.
 * 2. 스프링 프레임웍에 의해 자동으로 Request, Session등의 정보를 관리한다.
 * Restful 방식은 구현이 안되어 있다.
 * method type에는 post와 get 말고도 delete, put, options와 같은 것들이 더 있다. 이를 restful 방식이라고 한다. 
 * post와 get으로 데이터가 넘어올때 request에서 header부분에서 정보가 실려온다.
 * put과 delete는 body 부분에서 정보가 실려온다. 
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. yunkidon@kspo.or.kr
 * </pre>
 */
public class ReqMap {
	
	private static Logger log = LoggerFactory.getLogger(ReqMap.class);
			
	private KSPOMap reqMap = null;

	/**
	 * Request parameter와 Session value들을 가공한다.
	 * @param request
	 */
	public ReqMap(HttpServletRequest request) {
		
		try {
			
			reqMap = new KSPOMap(request);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("{}",e.toString());
		}
		
	}

	public KSPOMap getReqMap(){
		return reqMap;
	}
	
}
