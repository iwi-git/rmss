package org.kspo.web.sms.controller;

import javax.annotation.Resource;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.sms.service.SmsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Since 2021. 12. 13.
 * @Author SCY
 * @FileName : SmsController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 13. SCY : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/sms")
public class SmsController extends BaseController {
	
	//SMS
	@Resource
	private SmsService smsService;
	
	
	/**
	 * SMS 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void insertSms(KSPOMap paramMap) throws Exception {
		smsService.insertSms(paramMap);
		
	}
	
	/**
	 * SMS 로그저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void insertSmsLog(KSPOMap paramMap) throws Exception {
		 smsService.insertSmsLog(paramMap);
		 
	}
	
	
}
