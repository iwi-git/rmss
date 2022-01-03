package org.kspo.web.notice.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author SCY
 * @FileName : NoticeDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * </pre>
 */
@RmssMapper("NoticeDAO")
public interface NoticeDAO {
	
	/**
	 * 게시판 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectNoticeList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 상세 페이지 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectNoticeDetail(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 상세 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertNoticeDJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 상세 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateNoticeDJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteNoticeDJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 조회수 +1
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateNoticeReadNumJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 첨부파일 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int insertNoticeFileJs(KSPOMap paramMap) throws Exception;

	/**
	 * 게시판 게시글 첨부파일 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOList selectNoticeFileList(KSPOMap paramMap) throws Exception;
	
	/**
	 * 게시판 게시글 첨부파일 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteNoticeFileJs(KSPOMap paramMap) throws Exception;
	
	/**
	 * 상단 게시판 긴급공지 조회
	 * @return
	 * @throws Exception
	 */
	KSPOList selectTopNoticeList() throws Exception;

}
