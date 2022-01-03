package org.kspo.web.file.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kspo.framework.global.BaseController;
import org.kspo.framework.resolver.ReqMap;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.web.file.service.FileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import java.io.File;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : FileFrontController.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
@Controller
@RequestMapping("/file")
public class FileFrontController extends BaseController{

	private static Logger log = LoggerFactory.getLogger(FileFrontController.class);
	protected static String FILE_HOME_PATH 	= PropertiesUtil.getString("FILE_HOME_PATH");	//메일서버 host

	//첨부파일
	@Resource
	private FileService fileService;
	
	/**
	 * 파일 다운로드
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/downloadFile.kspo")
	public void downloadFile(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		KSPOMap paramMap = reqMap.getReqMap();
		fileService.downloadFile(request, response, paramMap); //파일다운로드
	}
	
	/**
	 * 파일 단건 삭제
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delFileJs.kspo")
	public String delFileJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOMap selectDelFileList = fileService.selectFile(paramMap);
		String filePath = "";
		String fileOrgName = "";
		
		if(!"".equals(selectDelFileList)) {
				
				fileOrgName = (String) selectDelFileList.getStr("FILE_NM");
				filePath = (String) selectDelFileList.getStr("FILE_PATH");
				
				File myFile = new File(FILE_HOME_PATH + filePath + "/" + fileOrgName);
			    
				if(myFile.exists()){
			    	myFile.delete();
			    }else{
			    	
			    }
		}
			
		fileService.delFile(paramMap); //파일삭제
			
		return "jsonView";
	}
	
	/**
	 * 파일 여러건 삭제
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delMFileJs.kspo")
	public String delMFileJs(ReqMap reqMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		KSPOMap paramMap = reqMap.getReqMap();
		
		KSPOList selectMDelFileList = fileService.selectFileList(paramMap);
		String filePath = "";
		String fileOrgName = "";
		
		if(selectMDelFileList.size() > 0) {
			for(int i=0; i<selectMDelFileList.size(); i++) {
				KSPOMap delFileMap = (KSPOMap) selectMDelFileList.get(i);
				
				fileOrgName = (String) delFileMap.getStr("FILE_NM");
				filePath = (String) delFileMap.getStr("FILE_PATH");
				
				File myFile = new File(FILE_HOME_PATH + filePath + "/" + fileOrgName);
			    
				if(myFile.exists()){
			    	myFile.delete();
			    }else{
			    	
			    }
				
			}
		}
			
		fileService.delMFile(paramMap); //파일삭제
			
		return "jsonView";
	}

}
