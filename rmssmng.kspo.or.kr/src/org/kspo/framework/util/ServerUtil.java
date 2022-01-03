package org.kspo.framework.util;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * @Since 2021. 3. 15.
 * @Author yunkidon@kspo.or.kr
 * @FileName : ServerUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. yunkidon@kspo.or.kr : 최초작성
 * </pre>
 */
public class ServerUtil {
	
	private ServerUtil() {}

	/**
	 * <pre>
	 *    getLocalServerIp : 서버 IP 획득
	 * </pre>
	 * @return IP
	 */
	public static String getLocalServerIp() {
		InetAddress Address;
		try {
			Address = InetAddress.getLocalHost();
			String IP = Address.getHostAddress();
			
			return IP;
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
			return null;
		}
	}
}
