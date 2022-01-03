package org.kspo.framework.pagination;

import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.DefaultPaginationRenderer;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationManager;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationRenderer;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : KspoPaginationManager.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class KspoPaginationManager implements PaginationManager {

	private Map<String, PaginationRenderer> rendererType;

	public void setRendererType(Map<String, PaginationRenderer> rendererType) {
		this.rendererType = rendererType;
	}

	public PaginationRenderer getRendererType(String type) {
		return (this.rendererType != null) && (this.rendererType.containsKey(type)) ? (PaginationRenderer) this.rendererType.get(type) : new DefaultPaginationRenderer();
	}

}
