package org.kspo.web.sms.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : SmsDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
@RmssMapper("SmsDAO")
public interface SmsDAO {

	/**
	 * SMS 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	//void insertSms(KSPOMap paramMap) throws Exception;

	/**
	 * SMS 로그저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	void insertSmsLog(KSPOMap paramMap) throws Exception;

}
