package org.kspo.framework.pagination;

import java.text.MessageFormat;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationRenderer;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : KspoPaginationRenderer.java
 * <pre>
 * jsFunction의 Function명과 전송할 FormName를 다음과 같이 같이 전송하면, fnGoPage(1,'sFrm')와 같이 조립해준다.
 * jsFunction="fnGoPage"의 경우는 fnGoPage(1)와 같다.
 * <ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:'sFrm'" />
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class KspoPaginationRenderer implements PaginationRenderer {

	protected String firstPageLabel;//처음
	protected String previousPageLabel;//이전
	protected String currentPageLabel;//현재페이지
	protected String otherPageLabel;//현재 페이지를 제외한 다른 페이지
	protected String nextPageLabel;//다음
	protected String lastPageLabel;//마지막
	
	@Override
	public String renderPagination(PaginationInfo paginationInfo, String jsFunction) {
		
		String splitJsFuncAndFormName[] = jsFunction.split(":");
		return renderPagination(paginationInfo, splitJsFuncAndFormName[0], (splitJsFuncAndFormName.length > 1) ? splitJsFuncAndFormName[1] : null);

	}
	
	/**
	 * Form Name를 받아서 summit을 통한 Pagination을 한다.
	 * @param paginationInfo
	 * @param jsFunction
	 * @param formName
	 * @return
	 */
	public String renderPagination(PaginationInfo paginationInfo, String jsFunction, String formName) {
		
		StringBuffer strBuff = new StringBuffer();
		
	    int firstPageNo           = paginationInfo.getFirstPageNo();
	    int firstPageNoOnPageList = paginationInfo.getFirstPageNoOnPageList();	//페이지 리스트의 첫 페이지 번호
	    
	    int totalPageCount        = paginationInfo.getTotalPageCount();			//페이지 개수
	    int pageSize              = paginationInfo.getPageSize();				//페이지 리스트에 게시되는 페이지 건수
	    int currentPageNo         = paginationInfo.getCurrentPageNo();			//현재 페이지 번호
	    
	    int lastPageNoOnPageList  = paginationInfo.getLastPageNoOnPageList();	//페이지 리스트의 마지망 페이지 번호
	    int lastPageNo            = paginationInfo.getLastPageNo();
	    
    	if (firstPageNoOnPageList > pageSize) {
    		if(formName == null) {
    	    	strBuff.append(MessageFormat.format(firstPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo) }));
    	    	strBuff.append(MessageFormat.format(previousPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNoOnPageList - 1) }));
    		}else {
    	    	strBuff.append(MessageFormat.format(firstPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo), formName }));
    	    	strBuff.append(MessageFormat.format(previousPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNoOnPageList - 1), formName }));
    		}

    	} else {
    		
    		if(formName == null) {
    	    	strBuff.append(MessageFormat.format(firstPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo) }));
    	    	strBuff.append(MessageFormat.format(previousPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo) }));
    		}else {
    	    	strBuff.append(MessageFormat.format(firstPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo), formName }));
    	    	strBuff.append(MessageFormat.format(previousPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNo), formName }));
    		}    		
    	}

    	for (int i = firstPageNoOnPageList; i <= lastPageNoOnPageList; i++) {
	    	if (i == currentPageNo)
	    		strBuff.append(MessageFormat.format(currentPageLabel, new Object[] { Integer.toString(i) }));
	    	else {
	    		
	    		if(formName == null) {
	    			strBuff.append(MessageFormat.format(otherPageLabel, new Object[] { jsFunction, Integer.toString(i), Integer.toString(i) }));
	    		}else {
	    			strBuff.append(MessageFormat.format(otherPageLabel, new Object[] { jsFunction, Integer.toString(i), Integer.toString(i), formName }));
	    		} 	    		
	    	}
    	}

    	if (lastPageNoOnPageList < totalPageCount) {
    		
    		if(formName == null) {
    	    	strBuff.append(MessageFormat.format(nextPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNoOnPageList + pageSize) }));
    	    	strBuff.append(MessageFormat.format(lastPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo) }));
    		}else {
    	    	strBuff.append(MessageFormat.format(nextPageLabel, new Object[] { jsFunction, Integer.toString(firstPageNoOnPageList + pageSize), formName }));
    	    	strBuff.append(MessageFormat.format(lastPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo), formName }));
    		} 	 

    	} else {
    		
    		if(formName == null) {
    	    	strBuff.append(MessageFormat.format(nextPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo) }));
    	    	strBuff.append(MessageFormat.format(lastPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo) }));
    		}else {
    	    	strBuff.append(MessageFormat.format(nextPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo), formName }));
    	    	strBuff.append(MessageFormat.format(lastPageLabel, new Object[] { jsFunction, Integer.toString(lastPageNo), formName }));
    		} 	 

    	}
    	
    	return strBuff.toString();
	}

}
