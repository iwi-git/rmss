package org.kspo.framework.util;

import java.security.MessageDigest;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : Sha256Util.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class Sha256Util {
	
	/**
	 * SHA256 암호화
	 * @param planText
	 * @return
	 * @throws Exception
	 */
	public static String encryptSHA256(String planText)throws Exception {
		
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        
        md.update(planText.getBytes());
        
        byte byteData[] = md.digest();

        StringBuffer sb = new StringBuffer();
        
        for (int i = 0; i < byteData.length; i++) {
        	
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            
        }
        return sb.toString();
    }
	
}
