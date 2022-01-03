package org.kspo.web.sms.service;

import javax.annotation.Resource;

import org.kspo.framework.util.KSPOMap;
import org.kspo.web.sms.dao.SmsDAO;
import org.kspo.web.sms.dao.SureSmsDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : SmsService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * 2021. 3. 15. LGH
 * </pre>
 */
@Service("smsService")
public class SmsService extends EgovAbstractServiceImpl{

	@Resource
	private SmsDAO smsDAO;

	@Resource
	private SureSmsDAO sureSmsDAO;

	/**
	 * SMS 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void insertSms(KSPOMap paramMap) throws Exception {
		sureSmsDAO.insertSms(paramMap);
	}

	/**
	 * SMS 로그저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void insertSmsLog(KSPOMap paramMap) throws Exception {
		smsDAO.insertSmsLog(paramMap);
	}


}
