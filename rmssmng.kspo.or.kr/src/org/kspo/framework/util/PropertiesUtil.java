package org.kspo.framework.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : PropertiesUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class PropertiesUtil extends PropertyPlaceholderConfigurer {
	
	private static Map<String, String> propertiesMap;
	
	private static Logger log = LoggerFactory.getLogger(PropertiesUtil.class);
	
	@SuppressWarnings("deprecation")
	@Override
	protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props) throws BeansException {
		
		super.processProperties(beanFactoryToProcess, props);
		
		propertiesMap = new HashMap<String, String>();
		
		for(Object key : props.keySet()) {
			
			try {
				propertiesMap.put((String) key, StringUtil.getEncodingChange(props.getProperty((String) key), "iso-8859-1", "utf-8"));
			} catch (Exception e) {
				e.printStackTrace();
				log.error("{}",e.getMessage());
			}
		}
		log.info("\n\n There are loaded properties.\n{}\n\n",propertiesMap.toString().replace(",", ",\n"));
	}
	
	public static int getInt(String name) {
		int re_val = 0;
		try {
			re_val = Integer.parseInt( String.valueOf(propertiesMap.get(name)));
		} catch (Exception e) {
			re_val = 0;
		}
		
		return re_val;
	}
	
	public static String getString(String name) {
		return String.valueOf(propertiesMap.get(name));
	}
}
