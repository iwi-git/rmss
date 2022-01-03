package org.kspo.web.file.dao;

import org.kspo.framework.annotation.RmssMapper;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : FileDAO.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * 2021. 3. 15. SCY
 * </pre>
 */
@RmssMapper("FileDAO")
public interface FileDAO {
	
	/**
	 * 파일 단건 저장
	 * @param fileVo
	 * @return
	 * @throws Exception
	 */
	int insertFile(KSPOMap map) throws Exception;

	/**
	 * 파일 다건 저장
	 * @param fileVo
	 * @return
	 * @throws Exception
	 */
	int insertFileList(KSPOMap fileMap) throws Exception;

	/**
	 * 파일 다건 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	KSPOList selectFileList(KSPOMap map) throws Exception;

	/**
	 * 파일 단건 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	KSPOMap selectFile(KSPOMap paramMap) throws Exception;

	/**
	 * 파일삭제
	 * @param vo
	 * @throws Exception
	 */
	int delFile(KSPOMap paramMap) throws Exception;

	/**
	 * 등록한 문서에대한 파일 삭제
	 * @param paramMap
	 * @throws Exception
	 */
	int delMFile(KSPOMap paramMap) throws Exception;
	
	/**
	 * 파일 그룹키 생성
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	String selectFileGrpRefrKey() throws Exception;


}
