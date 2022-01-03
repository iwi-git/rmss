package org.kspo.web.email.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 12. 06.
 * @Author SCY
 * @FileName : EmailDAO.java
 * <pre>
 * ---------------------------------------------------------n
 * 개정이력
 * 2021. 12. 06. SCY : 최초작성
 * </pre>
 */
@RmssMapper("emailDAO")
public interface EmailDAO {

	/**
	 * 메일 템플릿 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectMailTemplate(KSPOMap paramMap) throws Exception;

	/**
	 * 메일 로그
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	void insertEmailLog(KSPOMap paramMap) throws Exception;

}
