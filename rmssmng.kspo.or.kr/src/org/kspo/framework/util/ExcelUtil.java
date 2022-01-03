package org.kspo.framework.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.poi.POIXMLException;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.util.CollectionUtils;

import org.kspo.framework.file.FileProcess;
//import com.kspo.web.smsalarm.twonum.SmsAlarm;

public class ExcelUtil {
	
	protected static String FILE_BASE_PATH = PropertiesUtil.getString("FILE_BASE_PATH");	//파일기본경로
	protected static String FILE_HOME_PATH = PropertiesUtil.getString("FILE_HOME_PATH");	//파일상세경로
	
	private static final String [] DEFAULT_HEADER_COL = {"휴대폰번호"};
	protected static String[] SMS_VARIABLE_ARR = PropertiesUtil.getString("SMS_VARIABLE").split(",");
	
	//휴대폰번호 체크
	private static final Pattern phPattern = Pattern.compile("^01(?:0|1|[6-9])[.-]?(\\d{3}|\\d{4})[.-]?(\\d{4})$");
	
	public static void SmsAlarmTemplcateExcelDown(String fileName, String sheetName, String [] tmpHeaderCol, HttpServletResponse response) throws Exception {
		
		
		String [] headerCol = mergeArr(tmpHeaderCol);
		
		if(StringUtil.isEmpty(fileName)) {
			fileName = "엑셀_업로드_파일";
		}
		
		if(StringUtil.isEmpty(sheetName)) {
			sheetName = "새시트";
		}
		
		
		//.xls 확장자 지원
		//HSSFWorkbook wb = null;
		//HSSFSheet sheet = null;
		//Row row = null;
		//Cell cell = null;
		
		//.xlsx 확장자 지원
		XSSFWorkbook xssfWb = null; // .xlsx
		XSSFSheet xssfSheet = null; // .xlsx
		XSSFRow xssfRow = null; // .xlsx
		XSSFCell xssfCell = null;// .xlsx
		
			
		int rowIndex = 0;//시작 행 인덱스
		// 워크북 생성
		xssfWb = new XSSFWorkbook();
		xssfSheet = xssfWb.createSheet(sheetName); // 워크시트 이름
		
		//헤더 컬럼 스타일
		CellStyle headerCellStyle = xssfWb.createCellStyle();
		headerCellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		//셀 서식 지정
		XSSFCellStyle cellStyle = xssfWb.createCellStyle();
		XSSFDataFormat format = xssfWb.createDataFormat();
		cellStyle.setDataFormat(format.getFormat("@"));//텍스트 포맷
		
		
		xssfRow = xssfSheet.createRow(rowIndex++);
		
		for(int i = 0; i < headerCol.length; i++) {
			xssfCell = xssfRow.createCell(i);
			xssfCell.setCellStyle(headerCellStyle);
			xssfCell.setCellValue(headerCol[i]);
			xssfSheet.setDefaultColumnStyle(i, cellStyle);//셀 텍스트 포맷 지정
			xssfSheet.autoSizeColumn(i);
			xssfSheet.setColumnWidth(i, (xssfSheet.getColumnWidth(i) + 1000));
		}
		
		response.reset();
		response.setContentType( "application/vnd.ms-excel" );
		response.setHeader( "Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName + ".xlsx", "UTF-8" ) );
		
		xssfWb.write(response.getOutputStream());
			
	}
		
	public static String[] mergeArr(String [] tempHeaderColArr) throws Exception {
		
		if(tempHeaderColArr == null || tempHeaderColArr.length < 1 || tempHeaderColArr[0] == null) {
			return DEFAULT_HEADER_COL;
		}
		
		//휴대폰번호 , + 넘겨받은 컬럼 배열 합치기
		return (String[]) ArrayUtils.addAll(DEFAULT_HEADER_COL, tempHeaderColArr);
		
	}
	
	public static KSPOList excelFileToList(String filePath, String realFileName) throws Exception {
		
		fileValidate(filePath, realFileName);
		
		KSPOList fileInfo = new KSPOList();
		
		String fileExt = getFileExtension(realFileName);

		if(!("xls".equals(fileExt) || "xlsx".equals(fileExt))) {
			throw new Exception("엑셀 확장자가 아닙니다.");
		}
		
		Workbook wb = null;
		FileInputStream fis = null;
		
		try {
			
			fis = new FileInputStream(FILE_HOME_PATH + filePath + File.separator + realFileName);
			
			if("xls".equals(fileExt)) {
				wb = new HSSFWorkbook(fis);
			} else if("xlsx".equals(fileExt)) {
				wb = new XSSFWorkbook(fis);
			}
			
			int totSheetCnt = wb.getNumberOfSheets();
			if(totSheetCnt < 1) {
				throw new Exception("시트가 존재하지 않습니다.");
			}
			
			int max_cheet_cnt = 1;
			int rowIndex = 1;
			int columnIndex = 0;
			
			for(int sheetIndex = 0; sheetIndex < max_cheet_cnt; sheetIndex++) {//시트
				
				Sheet sheet = wb.getSheetAt(sheetIndex);
				int rows = sheet.getLastRowNum() + 1;
				
				int headerCellCnt = sheet.getRow(0).getPhysicalNumberOfCells();
				
				for(rowIndex=1;rowIndex<=rows;rowIndex++) {
					KSPOMap excelMap = new KSPOMap();
					Row row = sheet.getRow(rowIndex);
					
					if(row != null) {
						
						for(columnIndex=0;columnIndex<headerCellCnt;columnIndex++) {
							
							Cell cell = row.getCell(columnIndex);
							String value = "";
							if(cell == null) {
								value = "";
							}else {
								
								switch (cell.getCellType()) {
								case Cell.CELL_TYPE_FORMULA:
									value=cell.getCellFormula();
									break;
								case Cell.CELL_TYPE_NUMERIC:
									if(DateUtil.isCellDateFormatted(cell)) {
										SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
										value = "" + sdf.format(cell.getDateCellValue());
									} else {
										value = "" + String.format("%.0f", new Double(cell.getNumericCellValue()));
									}
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
														
							if(columnIndex == 0) {//셀타입이 일반인 경우 앞의 0이 사라지기 때문에 아래와 같이 작업을 한다.[수신번호]
								String phoneChk = value;
								if(!StringUtil.isEmpty(phoneChk) && !phoneChk.startsWith("0")){
									value = "0" + phoneChk;
								}
							}
							
							//excelMap.put(SmsAlarm.RECV_PARAM_KEY.toString() + columnIndex,value);
						}
						
						fileInfo.add(excelMap);
					}
					
				}
			}
			
		} catch (POIXMLException e) {
			throw new POIXMLException("첨부파일 확인 부탁드립니다.( 문서보안 해제 )");
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if(fis != null) fis.close();
		}
		
		return fileInfo;
		
	}
	
public static KSPOList excelFileToGrpList(String filePath, String realFileName) throws Exception {
		
		fileValidate(filePath, realFileName);
		
		KSPOList fileInfo = new KSPOList();
		
		String fileExt = getFileExtension(realFileName);

		if(!("xls".equals(fileExt) || "xlsx".equals(fileExt))) {
			throw new Exception("엑셀 확장자가 아닙니다.");
		}
		
		Workbook wb = null;
		FileInputStream fis = null;
		
		try {
			
			fis = new FileInputStream(FILE_HOME_PATH + filePath + File.separator + realFileName);
			
			if("xls".equals(fileExt)) {
				wb = new HSSFWorkbook(fis);
			} else if("xlsx".equals(fileExt)) {
				wb = new XSSFWorkbook(fis);
			}
			
			int totSheetCnt = wb.getNumberOfSheets();
			if(totSheetCnt < 1) {
				throw new Exception("시트가 존재하지 않습니다.");
			}
			
			int max_cheet_cnt = 1;
			int rowIndex = 1;
			int columnIndex = 0;
			
			for(int sheetIndex = 0; sheetIndex < max_cheet_cnt; sheetIndex++) {//시트
				
				Sheet sheet = wb.getSheetAt(sheetIndex);
				int rows = sheet.getLastRowNum() + 1;
				
				int headerCellCnt = sheet.getRow(0).getPhysicalNumberOfCells();
				
				for(rowIndex=1;rowIndex<=rows;rowIndex++) {
					KSPOMap excelMap = new KSPOMap();
					Row row = sheet.getRow(rowIndex);
					
					if(row != null) {
						
						for(columnIndex=0;columnIndex<headerCellCnt;columnIndex++) {
							
							Cell cell = row.getCell(columnIndex);
							String value = "";
							if(cell == null) {
								value = "";
							}else {
								
								switch (cell.getCellType()) {
								case Cell.CELL_TYPE_FORMULA:
									value=cell.getCellFormula();
									break;
								case Cell.CELL_TYPE_NUMERIC:
									if(DateUtil.isCellDateFormatted(cell)) {
										SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
										value = "" + sdf.format(cell.getDateCellValue());
									} else {
										value = "" + String.format("%.0f", new Double(cell.getNumericCellValue()));
									}
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
														
							if(columnIndex == 1) {//셀타입이 일반인 경우 앞의 0이 사라지기 때문에 아래와 같이 작업을 한다.[수신번호]
								String phoneChk = value;
								if(!StringUtil.isEmpty(phoneChk) && !phoneChk.startsWith("0")){
									value = "0" + phoneChk;
								}
							}
							
							//excelMap.put(SmsAlarm.RECV_PARAM_KEY.toString() + columnIndex,value);
						}
						fileInfo.add(excelMap);	
					}
					
				}
			}
			
		} catch (POIXMLException e) {
			throw new POIXMLException("첨부파일 확인 부탁드립니다.( 문서보안 해제 )");
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if(fis != null) fis.close();
		}
		
		return fileInfo;
		
	}
		
	private static void fileValidate(String filePath, String realFileName) throws Exception {
		
		if(StringUtil.isEmpty(filePath)) {
			throw new Exception("파일 경로는 필수입니다.");
		}
		if(StringUtil.isEmpty(realFileName)) {
			throw new Exception("파일이름은 필수입니다.");
		}
	}
	
	private static String getFileExtension(String realFileName) throws Exception {
		
		return realFileName.substring(realFileName.lastIndexOf(".") + 1).toLowerCase();
	}
		
	
	public static KSPOMap createInvalidListExcel(String [] tmpHeaderCol, KSPOList validFailList) throws Exception {
		KSPOMap fileInfo = new KSPOMap();
		
		String [] headerCol = mergeArr(tmpHeaderCol);

		//.xlsx 확장자 지원
		XSSFWorkbook xssfWb = null; // .xlsx
		XSSFSheet xssfSheet = null; // .xlsx
		XSSFRow headerRow = null; // .xlsx
		XSSFCell headerCell = null;// .xlsx
		
			
		int rowIndex = 0;//시작 행 인덱스
		// 워크북 생성
		xssfWb = new XSSFWorkbook();
		xssfSheet = xssfWb.createSheet("sheet1"); // 워크시트 이름
		
		//헤더 컬럼 스타일
		CellStyle headerCellStyle = xssfWb.createCellStyle();
		headerCellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		//셀 서식 지정
		XSSFCellStyle cellStyle = xssfWb.createCellStyle();
		XSSFDataFormat format = xssfWb.createDataFormat();
		cellStyle.setDataFormat(format.getFormat("@"));//텍스트 포맷
		
		
		headerRow = xssfSheet.createRow(rowIndex++);
		
		for(int i = 0; i < headerCol.length; i++) {
			headerCell = headerRow.createCell(i);
			headerCell.setCellStyle(headerCellStyle);
			headerCell.setCellValue(headerCol[i]);
			xssfSheet.setDefaultColumnStyle(i, cellStyle);//셀 텍스트 포맷 지정
			xssfSheet.autoSizeColumn(i);
			xssfSheet.setColumnWidth(i, (xssfSheet.getColumnWidth(i) + 1000));
		}
		
		XSSFRow dataRow = null;
		XSSFCell dataCell = null;
		for(Object oRow : validFailList) {
			KSPOMap iRow = (KSPOMap)oRow;
			
			dataRow = xssfSheet.createRow(rowIndex++);
			int colIdx = 0;
			for(String key : iRow.getKeys()) {
				dataCell = dataRow.createCell(colIdx++);
				dataCell.setCellValue(iRow.getStr(key));
			}
		}
		
		
		//파일 이름 생성
		String addFilePath = "/excelUploadAdvice";
		String fileName = UUID.randomUUID().toString();
		String fileExt = ".xlsx";
		
		//디렉토리 생성
		File file = new File(FILE_HOME_PATH + FILE_BASE_PATH + addFilePath);
		if(!file.exists()){
			file.mkdirs();
		}
		
		String fileAllPath = FILE_HOME_PATH + FILE_BASE_PATH + addFilePath + File.separator + fileName + fileExt;
		fileAllPath = StringUtil.filePathSeparatorChange(fileAllPath);
		
		try(FileOutputStream fos = new FileOutputStream(new File(fileAllPath))){
			xssfWb.write(fos);
			
			fileInfo.put("filePath", FILE_BASE_PATH + addFilePath);
			fileInfo.put("fileNm", fileName + fileExt);
			fileInfo.put("fileOrginNm", "엑셀업로드_유효성검사_결과.xlsx");
			fileInfo.put("fileFullPath", fileAllPath);
			
			fileInfo.put("refTb", "ALARM_TEMP");
			fileInfo.put("refCol", "ALARM_TEMP_SEQ");
			fileInfo.put("fileGbCd", "01");
		}catch (Exception e) {
			throw new Exception("전송검사 실패건에 대한 엑셀생성이 실패했습니다.");
		}
		
		return fileInfo;
	}
	
	public static KSPOMap createAddrGrpListExcel(String [] tmpHeaderCol, KSPOList validFailList) throws Exception {
		KSPOMap fileInfo = new KSPOMap();
		
		String [] headerCol = tmpHeaderCol;
		

		//.xlsx 확장자 지원
		XSSFWorkbook xssfWb = null; // .xlsx
		XSSFSheet xssfSheet = null; // .xlsx
		XSSFRow headerRow = null; // .xlsx
		XSSFCell headerCell = null;// .xlsx
		
			
		int rowIndex = 0;//시작 행 인덱스
		// 워크북 생성
		xssfWb = new XSSFWorkbook();
		xssfSheet = xssfWb.createSheet("sheet1"); // 워크시트 이름
		
		//헤더 컬럼 스타일
		CellStyle headerCellStyle = xssfWb.createCellStyle();
		headerCellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		//셀 서식 지정
		XSSFCellStyle cellStyle = xssfWb.createCellStyle();
		XSSFDataFormat format = xssfWb.createDataFormat();
		cellStyle.setDataFormat(format.getFormat("@"));//텍스트 포맷
		
		headerRow = xssfSheet.createRow(rowIndex++);
		
		for(int i = 0; i < headerCol.length; i++) {
			headerCell = headerRow.createCell(i);
			headerCell.setCellStyle(headerCellStyle);
			headerCell.setCellValue(headerCol[i]);
			xssfSheet.setDefaultColumnStyle(i, cellStyle);//셀 텍스트 포맷 지정
			xssfSheet.autoSizeColumn(i);
			xssfSheet.setColumnWidth(i, (xssfSheet.getColumnWidth(i) + 1000));
		}
		XSSFRow dataRow = null;
		XSSFCell dataCell = null;
		for(Object oRow : validFailList) {
			KSPOMap iRow = (KSPOMap)oRow;
			
			dataRow = xssfSheet.createRow(rowIndex++);
			int colIdx = 0;
			for(String key : iRow.getKeys()) {
				dataCell = dataRow.createCell(colIdx++);
				dataCell.setCellValue(iRow.getStr(key));
			}
		}
		//파일 이름 생성
		String addFilePath = "/alarmRecv";
		String fileName = UUID.randomUUID().toString();
		String fileExt = ".xlsx";
		
		//디렉토리 생성
		File file = new File(FILE_HOME_PATH + FILE_BASE_PATH + addFilePath);
		if(!file.exists()){
			file.mkdirs();
		}
		String fileAllPath = FILE_HOME_PATH + FILE_BASE_PATH + addFilePath + File.separator + fileName + fileExt;
		fileAllPath = StringUtil.filePathSeparatorChange(fileAllPath);
		
		try(FileOutputStream fos = new FileOutputStream(new File(fileAllPath))){
			
			xssfWb.write(fos);
			
			fileInfo.put("filePath", FILE_BASE_PATH + addFilePath);
			fileInfo.put("fileNm", fileName + fileExt);
			fileInfo.put("fileOrginNm", "개인_주소록.xlsx");
			fileInfo.put("fileFullPath", fileAllPath);
			
			fileInfo.put("refTb", "ADDR_GRP_TEMP");
			fileInfo.put("refCol", "ADDR_GRP_TEMP_SEQ");
			fileInfo.put("fileGbCd", "01");
		}catch (Exception e) {
			throw new Exception("전체 주소록에 대한 엑셀생성이 실패했습니다.");
		}
		
		return fileInfo;
	}
	
	public static void grpTemplcateExcelDown(String fileName, String sheetName, String [] tmpHeaderCol, HttpServletResponse response) throws Exception {
		
		
		String [] headerCol = tmpHeaderCol;
		
		if(StringUtil.isEmpty(fileName)) {
			fileName = "엑셀_업로드_파일";
		}
		
		if(StringUtil.isEmpty(sheetName)) {
			sheetName = "새시트";
		}
				
		//.xlsx 확장자 지원
		XSSFWorkbook xssfWb = null; // .xlsx
		XSSFSheet xssfSheet = null; // .xlsx
		XSSFRow xssfRow = null; // .xlsx
		XSSFCell xssfCell = null;// .xlsx
		
			
		int rowIndex = 0;//시작 행 인덱스
		// 워크북 생성
		xssfWb = new XSSFWorkbook();
		xssfSheet = xssfWb.createSheet(sheetName); // 워크시트 이름
		
		//헤더 컬럼 스타일
		CellStyle headerCellStyle = xssfWb.createCellStyle();
		headerCellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		//셀 서식 지정
		XSSFCellStyle cellStyle = xssfWb.createCellStyle();
		XSSFDataFormat format = xssfWb.createDataFormat();
		cellStyle.setDataFormat(format.getFormat("@"));//텍스트 포맷
		
		
		xssfRow = xssfSheet.createRow(rowIndex++);
		
		for(int i = 0; i < headerCol.length; i++) {
			xssfCell = xssfRow.createCell(i);
			xssfCell.setCellStyle(headerCellStyle);
			xssfCell.setCellValue(headerCol[i]);
			xssfSheet.setDefaultColumnStyle(i, cellStyle);//셀 텍스트 포맷 지정
			xssfSheet.autoSizeColumn(i);
			xssfSheet.setColumnWidth(i, (xssfSheet.getColumnWidth(i) + 1000));
		}
		
		response.reset();
		response.setContentType( "application/vnd.ms-excel" );
		response.setHeader( "Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName + ".xlsx", "UTF-8" ) );
		
		xssfWb.write(response.getOutputStream());
			
	}

}
