package org.kspo.framework.scheduler;

import javax.annotation.Resource;

import org.kspo.framework.global.SystemConst;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.web.system.menu.service.MenuService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : KspoScheduler.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Component
public class KspoScheduler {

	protected static String FILE_HOME_PATH  = PropertiesUtil.getString("FILE_HOME_PATH");		//파일상세경로


	//메뉴관리
	@Resource
	private MenuService menuService;



	/**
	 * Left Menu 갱신
	 * @throws Exception
	 */
//	@Scheduled(fixedDelay = 60000)
	@Scheduled(fixedDelay = 3600000)
	public void setLeftMenu() throws Exception{
		SystemConst.setLeftMenu(menuService.selectLeftMenuList());
	}
	
}
