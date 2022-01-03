package org.kspo.framework.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.kspo.framework.util.PropertiesUtil;
import org.kspo.framework.util.StringUtil;
import org.kspo.web.file.service.FileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * @Since 2021. 3. 15.
 * @Author LGH
 * @FileName : FileProcess.java
 * <pre>
 * ---------------------------------------------------------
 * 개정이력
 * 2021. 3. 15. LGH : 최초작성
 * </pre>
 */
public class FileProcess {

	private static Logger log = LoggerFactory.getLogger(FileService.class);

	protected static String FILE_BASE_PATH = PropertiesUtil.getString("FILE_BASE_PATH");	//파일기본경로
	protected static String FILE_HOME_PATH = PropertiesUtil.getString("FILE_HOME_PATH");	//파일상세경로
	protected static String WEB_FILE_SIZE  = PropertiesUtil.getString("WEB_FILE_SIZE");		//파일사이즈확인
	
	/**
	 * 파일 확장자 확인 및 파일 업로드 진행
	 * @param request
	 * @param extChk 확장자
	 * @param addFilePath 추가파일 경로
	 * @return
	 */
	public static KSPOList fileUpload(HttpServletRequest request, String extChk, String addFilePath) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		KSPOList fileInfo = new KSPOList();
		
		String filePath = FILE_HOME_PATH + FILE_BASE_PATH + addFilePath;
		Path path = Paths.get(FILE_HOME_PATH + FILE_BASE_PATH + addFilePath);
		
		//디렉토리 생성
		File file = new File(filePath);
		
		if(!file.exists()){
			file.mkdirs();
		}
		
		Iterator<String> inputFileNmIt = multipartHttpServletRequest.getFileNames();
		
		
		while(inputFileNmIt.hasNext()) {
			
			String inputFileNm = inputFileNmIt.next();
			List<MultipartFile> fileList = multipartHttpServletRequest.getFiles(inputFileNm);
			
			for(MultipartFile multipartFile : fileList){
				KSPOMap map = new KSPOMap();
				
				long bytes = multipartFile.getSize();
				long kilobyte = bytes/1024;
				long megabyte = kilobyte/1024;
										
				if(megabyte > Long.parseLong(WEB_FILE_SIZE)) {
					throw new Exception("파일 용량을 줄여주시기 바랍니다.(" + WEB_FILE_SIZE + "MB까지 업로드 가능합니다.");
				}

				String[] splitOriginalFilename = multipartFile.getOriginalFilename().split("\\.");	//.으로 자르기
				String fileExt = splitOriginalFilename[splitOriginalFilename.length-1].toLowerCase();	//마지막 .으로 찾은 후 소문자 변경
				
				SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmssSSS");
				Date time = new Date();
				String saveFileName = format1.format(time) + "." + fileExt;
				
				if(webFileExtCheck(multipartFile.getOriginalFilename(),extChk)){
					
					String fileAllPath = filePath + File.separator + saveFileName;
					fileAllPath = StringUtil.filePathSeparatorChange(fileAllPath);
					
					map.put("FILE_PATH", FILE_BASE_PATH + addFilePath);
					map.put("FILE_NM", saveFileName);
					map.put("FILE_ORGIN_NM", multipartFile.getOriginalFilename());
					map.put("FILE_FULL_PATH",fileAllPath);
					map.put("FILE_INPUT_NAME", multipartFile.getName());
					
					fileInfo.add(map);
					
					//저장처리
					multipartFile.transferTo(new File(fileAllPath));
					
				}
			}
		}
		
		return fileInfo;
	}

	/**
	 * 확장자 확인
	 * @param originalFilename
	 * @param extChk 
	 * @return
	 */
	private static boolean webFileExtCheck(String originalFilename, String extChk) throws Exception {
		
		String[] splitOriginalFilename = originalFilename.split("\\.");	//.으로 자르기
		String fileExt = splitOriginalFilename[splitOriginalFilename.length-1].toLowerCase();	//마지막 .으로 찾은 후 소문자 변경
		
		String[] splitWebFileExt = extChk.split(",");
		for (int i = 0; i < splitWebFileExt.length; i++) {
			String ext = splitWebFileExt[i];
			if(ext.equals(fileExt)){
				return true;
			}
		}
		
		return false;
	}

	/**
	 * @param request
	 * @param response
	 * @param filePath 저장된 파일 경로
	 * @param realFilNm 실제 파일명
	 * @param viewFileNm 기존 파일명
	 * @throws Exception
	 */
	public static void fileDownload(HttpServletRequest request, HttpServletResponse response, String filePath, String realFilNm, String viewFileNm) throws Exception {
		
		File file = new File( filePath +File.separator + realFilNm);
		if (file.exists() && file.isFile()) {
			
			response.setContentType("application/octet-stream; charset=utf-8");
			response.setContentLength((int) file.length());
			
			String browser     = getBrowser(request);
			String disposition = getDisposition(viewFileNm, browser);
			
			response.setHeader("Content-Disposition", disposition);
			response.setHeader("Content-Transfer-Encoding", "binary");
			
			OutputStream out    = response.getOutputStream();
			FileInputStream fis = null;
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			if (fis != null)
				fis.close();
			out.flush();
			out.close();
		}
	}

	/**
	 * 브라우저 확인
	 * @param request
	 * @return
	 */
	private static String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1)
			return "MSIE";
		else if (header.indexOf("Chrome") > -1)
			return "Chrome";
		else if (header.indexOf("Opera") > -1)
			return "Opera";
		return "Firefox";
	}

	/**
	 * 다운로드될 파일명 저장
	 * @param filename
	 * @param browser
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	private static String getDisposition(String filename, String browser) throws UnsupportedEncodingException {
		
		String dispositionPrefix = "attachment;filename=";
		
		String encodedFilename = null;
		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		}
		return dispositionPrefix + encodedFilename;
	}


	/**
	 * 파일 이동
	 * @param fileFullPath 이동할 파일 전체 경로 및 파일
	 * @param fileMoveFullDirectoryPath 이동할 디렉토리 경로
	 * @throws Exception
	 */
	public void fileMove(String fileFullPath, String fileMoveFullDirectoryPath) throws Exception {
		File file = new File(fileFullPath);
		File fileMove = new File(fileMoveFullDirectoryPath);
		FileUtils.moveFileToDirectory(file, fileMove, true);
	}

	/**
	 * 지정된 파일 경로에 파일 조회
	 * @param dirPath
	 * @throws Exception
	 */
	public void fileDirectoryLoad(String dirPath) throws Exception {
		fileDirectoryLoadDtl(dirPath);
	}

	/**
	 * 지정된 파일 경로에 파일 조회
	 * 하위 파일까지 검색
	 * @param dirPath
	 */
	private static void fileDirectoryLoadDtl(String dirPath) {

		File dir = new File(dirPath);
		File files[] = dir.listFiles();
		
		for(int i=0;i<files.length;i++) {
			File file = files[i];
			if(file.isDirectory()) {
				fileDirectoryLoadDtl(file.getPath());
			}else {
				log.warn("[file] : " + file);
			}
		}
	}

	/**
	 * 엑셀 파일 로드
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static KSPOList excelfileLoad(HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		KSPOList fileInfo = new KSPOList();
		
		List<MultipartFile> fileList = multipartHttpServletRequest.getFiles("file");
		
		for(MultipartFile multipartFile : fileList){
			
			FileInputStream excelFile = new FileInputStream(multipartFile.getOriginalFilename());
			XSSFWorkbook workbook = new XSSFWorkbook(excelFile);
			
			int rowindex = 0;
			int columnindex = 0;
			int sheetCnt = workbook.getNumberOfSheets();
			for(int i=0;i<sheetCnt;i++) {
				
				XSSFSheet sheet = workbook.getSheetAt(i);
				int rows = sheet.getPhysicalNumberOfRows();
				
				for(rowindex=1;rowindex<rows;rowindex++) {
					KSPOMap excelMap = new KSPOMap();
					XSSFRow row = sheet.getRow(rowindex);
					
					if(row != null) {
						
						int cells = row.getPhysicalNumberOfCells();
						
						for(columnindex=0;columnindex<=cells;columnindex++) {
							
							XSSFCell cell = row.getCell(columnindex);
							String value = "";
							
							if(cell == null) {
								continue;
							}else {
								
								switch (cell.getCellType()) {
								case Cell.CELL_TYPE_FORMULA:
									value=cell.getCellFormula();
									break;
								case Cell.CELL_TYPE_NUMERIC:
									value=cell.getNumericCellValue()+"";
									break;
								case Cell.CELL_TYPE_STRING:
									value=cell.getStringCellValue();
									break;
								case Cell.CELL_TYPE_BLANK:
									value="";
									break;
								case Cell.CELL_TYPE_ERROR:
									value=cell.getErrorCellValue()+"";
									break;
								}
								
							}
							excelMap.put("key" + columnindex,value);
						}
					}
					fileInfo.add(excelMap);
				}
			}
		}
		
		return fileInfo;
	}

}
