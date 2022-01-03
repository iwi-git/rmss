package org.kspo.web.file.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.file.FileProcess;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.web.file.dao.FileDAO;
import org.kspo.web.notice.service.NoticeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : FileService.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Service("fileService")
public class FileService extends EgovAbstractServiceImpl {

	private static Logger log = LoggerFactory.getLogger(FileService.class);

	protected static String FILE_BASE_PATH = PropertiesUtil.getString("FILE_BASE_PATH");	//파일기본경로
	protected static String FILE_HOME_PATH = PropertiesUtil.getString("FILE_HOME_PATH");		//파일상세경로
	protected static String WEB_FILE_SIZE  = PropertiesUtil.getString("WEB_FILE_SIZE");		//파일사이즈확인
	
	@Resource
	private FileDAO fileDAO;
	
	//게시판
	@Resource
	private NoticeService noticeService;
	
	/**
	 * 파일 단건 저장
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int insertFile(KSPOMap map) throws Exception {
		return fileDAO.insertFile(map);
	}
	
	/**
	 * 파일 업로드
	 * @param request
	 * @param addFilePath
	 * @param refTb
	 * @param refCol
	 * @param extChk
	 * @return
	 * @throws Exception
	 */
	public KSPOList fileUpload(HttpServletRequest request, String addFilePath, String REFR_TABLE_NM, String REFR_COL_NM, String extChk) throws Exception {

		KSPOList fileInfo = FileProcess.fileUpload(request, extChk, addFilePath);
		fileInfo = setAddFileData(fileInfo, REFR_TABLE_NM, REFR_COL_NM);
		
		return fileInfo;
	}

	/**
	 * 파일 추가 데이터 등록
	 * @param fileInfo
	 * @param refTb 참조 테이블
	 * @param refCol 참조 컬럼
	 * @return
	 */
	private KSPOList setAddFileData(KSPOList fileInfo, String REFR_TABLE_NM, String REFR_COL_NM) {
		
		for(int i = 0; i < fileInfo.size(); i++) {
			
			KSPOMap map = (KSPOMap) fileInfo.get(i);
			
			map.put("REFR_TABLE_NM", REFR_TABLE_NM);
			map.put("REFR_COL_NM",  REFR_COL_NM);
			map.put("FILE_GB_CD", "01");
			
		}
		
		return fileInfo;
	}

	/**
	 * 파일 다건 저장
	 * @param list
	 * @throws Exception
	 */
	public int insertFileList(KSPOMap fileMap) throws Exception {
		return fileDAO.insertFileList(fileMap);
	}

	/**
	 * 파일 다건 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public KSPOList selectFileList(KSPOMap map) throws Exception {
		return fileDAO.selectFileList(map);
	}

	/**
	 * 파일 다운로드
	 * @param request
	 * @param response
	 * @param vo
	 * @throws Exception
	 */
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, KSPOMap paramMap) throws Exception {
		
		KSPOMap fileMap = new KSPOMap(); 
		String filePath   = "";//저장된 파일 경로
		String realFilNm  = "";					//실제 파일명
		String viewFileNm = "";				//기존 파일명
				
		if("noticeFile".equals(paramMap.getStr("file"))) {
			KSPOList fileList = noticeService.selectNoticeFileList(paramMap);
			fileMap = (KSPOMap) fileList.get(0);
			filePath   = FILE_HOME_PATH + fileMap.getStr("ATCH_FILE_PATH");//저장된 파일 경로
			realFilNm  = fileMap.getStr("ATCH_FILE_NM");					//실제 파일명
			viewFileNm = fileMap.getStr("ATCH_FILE_ORG_NM");				//기존 파일명
		}else {
			fileMap = this.selectFile(paramMap);
			filePath   = FILE_HOME_PATH + fileMap.getStr("FILE_PATH");//저장된 파일 경로
			realFilNm  = fileMap.getStr("FILE_NM");					//실제 파일명
			viewFileNm = fileMap.getStr("FILE_ORGIN_NM");				//기존 파일명
			
		}
		
		FileProcess.fileDownload(request,response,filePath,realFilNm,viewFileNm);
		
	}

	/**
	 * 파일 단건 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public KSPOMap selectFile(KSPOMap paramMap) throws Exception {
		return fileDAO.selectFile(paramMap);
	}
	
	/**
	 * 파일삭제
	 * @param request
	 * @param vo
	 * @throws Exception
	 */
	public int delFile(KSPOMap paramMap) throws Exception {
		return fileDAO.delFile(paramMap);
	}

	/**
	 * 등록한 문서에대한 파일 삭제
	 * @param request
	 * @param paramMap
	 * @throws Exception
	 */
	public int delMFile(KSPOMap paramMap) throws Exception {
		return fileDAO.delMFile(paramMap);
	}
	
	
	/**
	 * 파일 그룹 채번
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public String selectFileGrpRefrKey() throws Exception {
		return fileDAO.selectFileGrpRefrKey();
	}
}
