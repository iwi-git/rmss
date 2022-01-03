package org.kspo.framework.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.stereotype.Component;

/**
 * @Since 2021. 12. 22.
 * @Author SCY
 * @FileName : SureMapper.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 12. 22. SCY : 최초작성
 * </pre>
 */
@Target({java.lang.annotation.ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface SureMapper {
	public abstract String value();
}
