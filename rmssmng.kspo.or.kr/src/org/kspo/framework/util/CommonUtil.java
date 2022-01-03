package org.kspo.framework.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : CommonUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class CommonUtil {

	/**
	 * 만나이 구하기
	 * @param rrn 주민번호
	 * @return
	 */
	public static String getAge(String rrn) {
		
		if(!StringUtil.formatCheck("rrn",rrn)) return "";
		
		String today = "";
		int age      = 0;
		
		try {

			rrn = StringUtil.getOnlyNumberString(rrn);

			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			today = format.format(new Date());
			
			int tYear  = Integer.parseInt(today.substring(0, 4));
			int tMonth = Integer.parseInt(today.substring(4, 6));
			int tDay   = Integer.parseInt(today.substring(6, 8));
			
			int sYear  = Integer.parseInt(rrn.substring(0, 2));
			int sMonth = Integer.parseInt(rrn.substring(2, 4));
			int sDay   = Integer.parseInt(rrn.substring(4, 6));
			
			if(rrn.charAt(6) == '0' || rrn.charAt(6) == '9') {
				sYear += 1800;
			} else if(rrn.charAt(6) == '1' || rrn.charAt(6) == '2' || rrn.charAt(6) == '5' || rrn.charAt(6) == '6') {
				sYear += 1900;
			} else {
				sYear += 2000;
			}
			
			age = tYear - sYear;
			
			if(tMonth < sMonth) {
				age--;
			}else if(tMonth == sMonth) {
				if(tDay < sDay) {
					age--;
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return String.valueOf(age);
	}
	
}
