package org.kspo.web.notice.service;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.web.notice.dao.NoticeDAO;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author SCY
 * @FileName : NoticeService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. SCY : 최초작성
 * </pre>
 */
@Service("noticeService")
public class NoticeService extends EgovAbstractServiceImpl {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource
	private NoticeDAO noticeDAO;

	/**
	 * 게시판 목록 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectNoticeList(KSPOMap paramMap)throws Exception {
		return noticeDAO.selectNoticeList(paramMap);
	}
	
	/**
	 * 게시판 상세 페이지 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectNoticeDetail(KSPOMap paramMap) throws Exception{
		return noticeDAO.selectNoticeDetail(paramMap);
	}
	/**
	 * 게시판 게시글 상세 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertNoticeDJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.insertNoticeDJs(paramMap);
	}
	
	/**
	 * 게시판 게시글 상세 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateNoticeDJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.updateNoticeDJs(paramMap);
	}

	/**
	 * 게시판 게시글 상세 삭제
	 * @param paramMap
	 * @throws Exception
	 */
	public void txDeleteNoticeDJs(KSPOMap paramMap) throws Exception {
		this.deleteNoticeDJs(paramMap);
		this.deleteNoticeFileJs(paramMap);
	}
	
	/**
	 * 게시판 게시글 상세 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private int deleteNoticeDJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.deleteNoticeDJs(paramMap);
	}
	
	/**
	 * 게시판 게시글 조회수 +1
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int updateNoticeReadNumJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.updateNoticeReadNumJs(paramMap);
	}
	
	/**
	 * 게시판 게시글 첨부파일 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertNoticeFileJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.insertNoticeFileJs(paramMap);
	}

	/**
	 * 게시판 게시글 첨부파일 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectNoticeFileList(KSPOMap paramMap) throws Exception {
		return noticeDAO.selectNoticeFileList(paramMap);
	}
	
	/**
	 * 게시판 게시글 첨부파일 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteNoticeFileJs(KSPOMap paramMap) throws Exception {
		return noticeDAO.deleteNoticeFileJs(paramMap);
	}
	
	/**
	 * 상단 게시판 긴급공지 조회
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectTopNoticeList() throws Exception {
		return noticeDAO.selectTopNoticeList();
	}

}
