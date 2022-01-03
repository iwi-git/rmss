package org.kspo.framework.pagination;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : KspoPagnationFormatRenderer.java
 * <pre>
 * jsFunction의 Function명과 전송할 FormName를 다음과 같이 같이 전송하면, fnGoPage(1,'sFrm')와 같이 조립해준다.
 * jsFunction="fnGoPage"의 경우는 fnGoPage(1)와 같다.
 * <ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:'sFrm'" />
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class KspoPagnationFormatRenderer extends KspoPaginationRenderer {

	public KspoPagnationFormatRenderer() {}

	public String renderPagination(PaginationInfo paginationInfo, String jsFunction) {
		
		String splitJsFuncAndFormName[] = jsFunction.split(":");
		
		if( splitJsFuncAndFormName.length > 1 ) {
			setFormName();
		}else {
			setDefault();
		}
		
		return super.renderPagination(paginationInfo, jsFunction);
	}

	
	private void setDefault() {
		// 처음
		this.firstPageLabel = "<div class=\"paging-first\"><a href=\"javascript:{0}({1})\">처음으로</a></div>";
		// 이전
		this.previousPageLabel = "<div class=\"paging-prev\"><a href=\"javascript:{0}({1})\">이전</a></div><ul class='paging-num'>";
		// 현재페이지
		this.currentPageLabel = "<li class=\"on\"><a href=\"#\">{0}</a></li>";
		// 현재 페이지를 제외한 다른 페이지
		this.otherPageLabel = "<li><a href=\"javascript:{0}({1})\">{2}</a></li>";
		// 다음
		this.nextPageLabel = "</ul><div class=\"paging-next\"><a href=\"javascript:{0}({1})\">다음</a></div>";
		// 마지막
		this.lastPageLabel = "<div class=\"paging-last\"><a href=\"javascript:{0}({1})\">끝으로</a></div>";				
	}
	
	private void setFormName() {
		// 처음
		this.firstPageLabel = "<div class=\"paging-first\"><a href=\"javascript:{0}({1},{2})\">처음으로</a></div>";
		// 이전
		this.previousPageLabel = "<div class=\"paging-prev\"><a href=\"javascript:{0}({1},{2})\">이전</a></div><ul class='paging-num'>";
		// 현재페이지
		this.currentPageLabel = "<li class=\"on\"><a href=\"#\">{0}</a></li>";
		// 현재 페이지를 제외한 다른 페이지
		this.otherPageLabel = "<li><a href=\"javascript:{0}({1},{3})\">{2}</a></li>";
		// 다음
		this.nextPageLabel = "</ul><div class=\"paging-next\"><a href=\"javascript:{0}({1},{2})\">다음</a></div>";
		// 마지막
		this.lastPageLabel = "<div class=\"paging-last\"><a href=\"javascript:{0}({1},{2})\">끝으로</a></div>";		
	}
}
