package org.kspo.framework.util;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : PagingUtil.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class PagingUtil {

	/**
	 * 페이징
	 * @param list
	 * @param pageNo
	 * @param pageLimit
	 * @param pageBlock
	 * @return
	 * @throws Exception
	 */
	public static String getPageingJs(int totCnt, int pageNo, String formId, int pageLimit, int pageBlock) throws Exception {
		
		String sb = null;
		
		if(totCnt > 0) {
			sb = PagingUtil.pageingJs(totCnt, pageNo, pageLimit, pageBlock,formId);
		}
		
		return sb;
	}
	
	/**
	 * 페이징 총 카운트
	 * @param totCnt
	 * @return
	 * @throws Exception
	 */
	public static int getPageCnt(int totCnt) throws Exception {
		return getPageCnt(totCnt, 10);
	}
	
	/**
	 * 페이징 총 카운트
	 * @param totCnt
	 * @param pageLimit
	 * @return
	 * @throws Exception
	 */
	public static int getPageCnt(int totCnt, int pageLimit) throws Exception {
		int pageCnt = 0;
		if(totCnt > 0) {
			pageCnt = (totCnt - 1) / pageLimit + 1;
		}
		return pageCnt;
	}

	/**
	 * 페이징
	 * @param list
	 * @param pageNo
	 * @param pageLimit
	 * @param pageBlock
	 * @return
	 * @throws Exception
	 */
	public static String pageingJs(int totCnt, int pageNo, int pageLimit, int pageBlock, String formId) {

		StringBuffer sb = new StringBuffer();

		int lastPageNum = (totCnt - 1) / pageLimit + 1; // 전체 페이지 개수
		int startPageNum = ((pageNo - 1) / pageBlock) * pageBlock + 1; // 화면에 보여질 시작 페이지 번호
		int endPageNum = startPageNum + pageBlock - 1; // 화면에 보여질 종료 페이지 번호
		if (endPageNum > lastPageNum)
			endPageNum = lastPageNum; // 종료 페이지 범위 처리

		int prevPageGroup = 1;
		int nextPageGroup = lastPageNum;

		if (startPageNum - pageBlock < 1) {
			prevPageGroup = 1;
		} else {
			prevPageGroup = startPageNum - pageBlock;
			if (prevPageGroup <= 0) {
				prevPageGroup = 1;
			}
		}

		if (endPageNum + 1 > lastPageNum) {
			nextPageGroup = lastPageNum;
		} else {
			nextPageGroup = endPageNum + 1;
		}
		
		
		// 처음 페이지로 이동
		sb.append("<div class='paging-first'><a href='javascript:fnGoPageJs(\"1\",\"" + formId + "\")'>처음으로</a></div>");
		
		//이전 그룹 페이지로 이동
		sb.append("<div class='paging-prev'><a href='javascript:fnGoPageJs(\"" + prevPageGroup + "\",\"" + formId + "\")'>이전</a></div>");
		
		//페이지 번호 표시
		sb.append("<ul class='paging-num'>");
		for (int i = startPageNum; i <= endPageNum; i++) {
			if(i == pageNo){
				sb.append("<li class='on'><a href='javascript:fnGoPageJs(\"" + i + "\",\"" + formId + "\")'>" + i + "</a></li>");
			}else{
				sb.append("<li><a href='javascript:fnGoPageJs(\"" + i + "\",\"" + formId + "\")'>" + i + "</a></li>");
			}
		}
		sb.append("</ul>");
		
		//다음 그룹 페이지로 이동
		sb.append("<div class='paging-next'><a href='javascript:fnGoPageJs(\"" + nextPageGroup + "\",\"" + formId + "\")'>다음</a></div>");
		
		// 마지막 페이지 이동
		sb.append("<div class='paging-last'><a href='javascript:fnGoPageJs(\"" + lastPageNum + "\",\"" + formId + "\")'>끝으로</a></div>");
		
		return sb.toString();
	}

}
