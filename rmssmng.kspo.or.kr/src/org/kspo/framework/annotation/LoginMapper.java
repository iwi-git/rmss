package org.kspo.framework.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.stereotype.Component;

/**
 * @Since 2021. 3. 15.
 * @Author KJS
 * @FileName : LoginMapper.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. KJS : 최초작성
 * </pre>
 */
@Target({java.lang.annotation.ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface LoginMapper {
	public abstract String value();
}
