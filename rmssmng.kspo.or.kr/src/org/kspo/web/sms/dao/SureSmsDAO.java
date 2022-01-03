package org.kspo.web.sms.dao;

import org.kspo.framework.annotation.SureMapper;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 12. 25.
 * @Author SCY
 * @FileName : SureSmsDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
@SureMapper("SureSmsDAO")
public interface SureSmsDAO {

	/**
	 * SMS 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	void insertSms(KSPOMap paramMap) throws Exception;

}
