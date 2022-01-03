package org.kspo.framework.jwt;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;


/**
 * <pre>
 * jwt를 생성 ==> 파라메터와 함께 전송 ==> 복호화 해서 사용
 * 각 시스템의 접속 권한인증 및 인가 체크를 위해 JWT를  사용
 * 
 * JAVA Web Token 발급 및 검증
 * 1. access Token
 * 2. to-do : refresh Token ? 
- JWT를 생성할 때와 복호화할 때의 비밀키를 다르게 설정: SignatureException 발생
- 위조한 JWT에 대해 복호화를 시도:  MalformedJwtException 발생
- 만료기간이 지난 JWT에 대해 복호화를 시도:  ExpiredJwtException 발생
- OAuth2 방식으로 JWT사용해보기(accesstoken, refreshtoken) 

- Reserved words
 iss(issuer) : 발급자
 sub(subject) : 토큰 제목
 aud(audience) : 토근대상자
 exp(expiration) : 토큰 만료 시간
 iat(issued at) : 토큰 발급 시간
 nbf(not before) : 토큰 활성 날자
 jti(jwt id) : jwt 토큰 실별자, 중복방지를 위해 사용
 *</pre>
 *
 *@author yunkidon@kspo.or.kr
 */

public class JWTManager {

	private static final Logger log  = LoggerFactory.getLogger(JWTManager.class);
	
	// 비밀키
	private String secretKey = "kspo1988!";
	
	private static JWTManager	instance = null;
	
	/**
	 * 싱클톤 패턴
	 * 
	 * use the getInstatce()
	 */
	private JWTManager() {}

	/**
	 * Double Check Lock 구현
	 * @return JWT
	 */
	public static JWTManager getInstance() {
		if (instance == null) {
			synchronized (JWTManager.class) {
				if (instance == null) {
					instance = new JWTManager();
				}
			}
		}
		return instance;
	}
	
	/**
	 * 기본 1분 후 만료 토큰 생성
	 * @return jwt - header.payload.signature
	 */
	public String getToken() {
		return getToken(new HashMap<String, Object>(), Calendar.MINUTE, 1);
	}
	
	
	/**
	 * use getToken(Map, Calendar.MINUTE, 1) ==> 1분 후 만료,
	 * getToken(Map, Calendar.DATE, 1) ==> 1일 후 만료
	 * @param map - Payload에 포함될 사용자정의 Key=value
	 * @param CalendarFildId - Calendar.DATE, Calendar.MINUTE...
	 * @param amount - 만료값 설정을 위한 CalendarFildId의 양
	 * @return JWT
	 */
	public String getToken(HashMap<String, Object> map, int CalendarFildId, int amount) {
		return createToken( map==null ? new HashMap<String, Object>() : map, CalendarFildId, amount);
	}

	/**
	 * jwt 생성
	 * @param map - Payload에 포함될 사용자정의 Key=value
	 * @param CalendarFildId - Calendar.DATE, Calendar.MINUTE...
	 * @param amount - 만료 예정값 설정
	 * @return JWT - header.payload.signature
	 */
    private String createToken(Map<String, Object> map, int CalendarFildId, int amount){

    	Calendar cal = Calendar.getInstance();
    	
    	cal.add(CalendarFildId, amount);

        Claims claims = Jwts.claims()
            .setSubject("access_token")
            .setIssuedAt(new Date())
            .setExpiration(new Date(cal.getTimeInMillis()));
        
		for(String key : map.keySet()) {
			claims.put(key, map.get(key));
		}
        
        String jwt = Jwts.builder()
            .setHeaderParam("typ", "JWT")
            .setClaims(claims)
            .signWith(SignatureAlgorithm.HS256, generateKey(secretKey))
            .compact();

        return jwt;
    }
        
     /**
     * jwt의 내용을 복호화 한다.
     * @param jwt - header.payload.signature
     * @return java.util.Map map
     */
    public Map<String, Object> getJwtContents(String jwt) {
        HashMap<String, Object> hs = null;
        Claims claims = null;
    	try {
    		claims = Jwts.parser()
                    .setSigningKey(generateKey(secretKey))
                    .parseClaimsJws(jwt).getBody();
		} catch (Exception e) {
			hs = new HashMap<String, Object>();
			hs.put("Error message", e.getMessage());
		}

        return claims==null ? hs : claims;
    }
    
	/**
	 * UTF-8 인코딩
	 * @return
	 */
	private byte[] generateKey(String sKey){
		byte[] key = null;
		try {
			key = sKey.getBytes("UTF-8");
		} catch (Exception e) {
			log.error("Making secret Key Error :: ", e);
		}
		return key;
	}
	
	public static void main(String[] args) {
		
		JWTManager jwtManager = JWTManager.getInstance();
		
		try {
			
			String jwt = jwtManager.getToken();
			log.info("\n\njwt = {}\n\n",jwt);
			
			
			HashMap<String, Object> RequstMap = new HashMap<String, Object>(); 
			RequstMap.put("id", "005072");
			RequstMap.put("name", "윤기돈");
			jwt = jwtManager.getToken(RequstMap, Calendar.MINUTE, 5);
			log.info("\n\njwt = {}\n\n",jwt);
			
			//String jwt = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE2MzkwNDk5MDcsImV4cCI6MTYzOTA1MDIwNywibmFtZSI6Im5hbWUiLCJpZCI6IjAwNTA3MiJ9.WiH4O8WRQuFbr_JUEQQcArNGreJeev59gSEBOaeAlM4";
			
			Map<String, Object> Resultmap = jwtManager.getJwtContents(jwt);
			log.info("\n\nmap = {}\n\n",Resultmap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
