package org.kspo.web.email.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.email.dao.EmailDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 12. 06.
 * @Author SCY
 * @FileName : EmailService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 06. SCY : 최초작성
 * </pre>
 */
@Service("emailService")
public class EmailService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private EmailDAO emailDAO;

	/**
	 * 메일 템플릿 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectMailTemplate(KSPOMap paramMap) throws Exception{
		return emailDAO.selectMailTemplate(paramMap);
	}

	/**
	 * 메일 로그
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public void insertEmailLog(KSPOMap paramMap) throws Exception {
		emailDAO.insertEmailLog(paramMap);
	}

}
