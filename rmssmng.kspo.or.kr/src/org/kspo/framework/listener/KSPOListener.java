package org.kspo.framework.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Service;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : KSPOListener.java
 * <pre>
 * 서비스 시작시 호출
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service
public class KSPOListener implements ApplicationListener<ContextRefreshedEvent>{

	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		try {
			//서비스 시작 시 호출
			if(event.getApplicationContext().getDisplayName().indexOf("Root WebApplicationContext") > -1) {
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
