package org.kspo.web.apply.service;

import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kspo.framework.util.KSPOList;
import org.kspo.framework.util.KSPOMap;
import org.springframework.stereotype.Service;

/**
 * 
 * <pre>
 * <b>History</b>
 *    2021. 11. 29. 작성자 최초작성 <br/>
 * </pre>
 * 
 * @author 송차영
 * @see none
 */
@Service("poiService")
public class PoiService {

	/**
	 * 체육요원 편입신청 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectSoldierSelectListExcel(KSPOList selectSoldierExcelSelectList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("체육요원편입신청");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);

		cell = row.createCell(5);
		cell.setCellValue("주소");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 15000);

		cell = row.createCell(6);
		cell.setCellValue("신청일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);

		cell = row.createCell(7);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);

		cell = row.createCell(8);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		rowNum++;

		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectSoldierExcelSelectList.size(); i++) {
			row = sheet.createRow(rowNum);

			cell = row.createCell(0);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(1);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(2);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(3);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(4);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(5);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "B_ADDR"));
			cell.setCellStyle(getClobDataLeftStyle(wb));

			cell = row.createCell(6);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "APPL_UPD_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(7);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "APPL_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(8);
			cell.setCellValue(selectSoldierExcelSelectList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cellNum = 9;

			rowNum++;

		}
		
		
		return wb;
	}
	
	/**
	 * 체육요원 복무현황 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectSoldierMngListExcel(KSPOList selectSoldierMngList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("체육요원복무현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("주소");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 9000);
		
		cell = row.createCell(6);
		cell.setCellValue("진행상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("관할병무청");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("편입일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("복무만료일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectSoldierMngList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectSoldierMngList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectSoldierMngList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectSoldierMngList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectSoldierMngList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectSoldierMngList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectSoldierMngList.get(i, "B_ADDR"));
			cell.setCellStyle(getDataRightStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectSoldierMngList.get(i, "PROC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectSoldierMngList.get(i, "CTRL_MMA_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectSoldierMngList.get(i, "ADDM_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectSoldierMngList.get(i, "EXPR_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectSoldierMngList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 11;
			
			rowNum++;
			
		}
		
		
		return wb;
	}

	/**
	 * 체육요원 국외여행 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectTravelSelectListExcel(KSPOList selectTravelSelectList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("국외여행신청");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("편입상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("신청구분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectTravelSelectList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectTravelSelectList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectTravelSelectList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectTravelSelectList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectTravelSelectList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectTravelSelectList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectTravelSelectList.get(i, "PROC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectTravelSelectList.get(i, "TRVL_APPL_DV"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectTravelSelectList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectTravelSelectList.get(i, "TRVL_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectTravelSelectList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 10;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 체육요원 징계관리 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectPunishSelectListExcel(KSPOList selectTravelSelectList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("징계관리");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("관할병무청");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 9000);
		
		cell = row.createCell(6);
		cell.setCellValue("편입상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("쳐분결과");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("처분사유");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("처분일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);

		cell = row.createCell(10);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectTravelSelectList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectTravelSelectList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectTravelSelectList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectTravelSelectList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectTravelSelectList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectTravelSelectList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectTravelSelectList.get(i, "CTRL_MMA_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectTravelSelectList.get(i, "PROC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectTravelSelectList.get(i, "DSPO"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectTravelSelectList.get(i, "DSPS_REASON"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectTravelSelectList.get(i, "DSPL_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectTravelSelectList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(selectTravelSelectList.get(i, "DSPL_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(selectTravelSelectList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 13;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 체육단체 계정 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectAccountListExcel(KSPOList selectAccountExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("체육단체계정관리");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("아이디");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("사용자그룹");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("소속");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("계정상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectAccountExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectAccountExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectAccountExcelList.get(i, "MNGR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectAccountExcelList.get(i, "B_MNGR_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectAccountExcelList.get(i, "GRP_SN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectAccountExcelList.get(i, "LOCGOV_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectAccountExcelList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectAccountExcelList.get(i, "ACNT_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 7;
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	/**
	 * 체육단체 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectMemOrgListExcel(KSPOList selectMemOrgExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("체육단체관리");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("체육단체명");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("담당자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("연락처");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("이메일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("등록자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("사용유무");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectMemOrgExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectMemOrgExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectMemOrgExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectMemOrgExcelList.get(i, "B_ORG_MNGR_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectMemOrgExcelList.get(i, "B_ORG_MNGR_CP_NO"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectMemOrgExcelList.get(i, "ORG_MNGR_EMAIL"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectMemOrgExcelList.get(i, "B_REGR_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectMemOrgExcelList.get(i, "MEMORG_REG_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(7);
			cell.setCellValue(selectMemOrgExcelList.get(i, "USE_YN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 8;
			
			rowNum++;
			
		}
		
		
		return wb;
	}

	/**
	 * 공익복무처 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public SXSSFWorkbook selectvlunPlaceListExcel(KSPOList selectVlunPlaceExcelList) throws Exception {
		
		SXSSFWorkbook wb = new SXSSFWorkbook();
//		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무처관리");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("공익복무처명");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("담당자");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("연락처");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("이메일");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("등록자");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("등록일자");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);

		cell = row.createCell(7);
		cell.setCellValue("사용유무");
//		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectVlunPlaceExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "RNUM"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "VLUN_PLC_NM"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "B_PLC_MNGR_NM"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "B_PLC_MNGR_TEL_NO"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "PLC_MNGR_EMAIL"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "B_UPDR_NM"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "UPDT_DT"));
//			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(7);
			cell.setCellValue(selectVlunPlaceExcelList.get(i, "USE_YN"));
//			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 8;
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	/**
	 * 사용자 접속이력 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectAcHsListExcel(KSPOList selectAcHsExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("사용자접속이력");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("접속일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("메뉴명");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("아이디");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("사용자그룹");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("소속");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);

		cell = row.createCell(7);
		cell.setCellValue("접속IP");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectAcHsExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectAcHsExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectAcHsExcelList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectAcHsExcelList.get(i, "MENU_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectAcHsExcelList.get(i, "ACC_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectAcHsExcelList.get(i, "B_ACC_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectAcHsExcelList.get(i, "GRP_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectAcHsExcelList.get(i, "LOC_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(7);
			cell.setCellValue(selectAcHsExcelList.get(i, "ACC_IP"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 8;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 겸직허가신청 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectTwoJobListExcel(KSPOList selectTwoJobExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("겸직허가신청");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("편입상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("신청구분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("겸직근무처");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 8000);
		
		cell = row.createCell(8);
		cell.setCellValue("담당직무");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 8000);
		
		cell = row.createCell(9);
		cell.setCellValue("근무기간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 8000);
		
		cell = row.createCell(10);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectTwoJobExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectTwoJobExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectTwoJobExcelList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectTwoJobExcelList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectTwoJobExcelList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectTwoJobExcelList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectTwoJobExcelList.get(i, "PROC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectTwoJobExcelList.get(i, "APPL_DV_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectTwoJobExcelList.get(i, "CONC_OFC"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectTwoJobExcelList.get(i, "CONC_PRVONSH_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectTwoJobExcelList.get(i, "CONC_START_DT")+"~"+selectTwoJobExcelList.get(i, "CONC_END_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectTwoJobExcelList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(selectTwoJobExcelList.get(i, "CONC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));

			cell = row.createCell(12);
			cell.setCellValue(selectTwoJobExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 8;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 신상이동신청 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public XSSFWorkbook selectTransferListExcel(KSPOList selectTransferList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("신상이동신청");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		int cellNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 2000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("편입상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("등록일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("신상이동유형");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 6000);
		
		cell = row.createCell(8);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectTransferList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectTransferList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectTransferList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectTransferList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectTransferList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectTransferList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectTransferList.get(i, "PROC_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectTransferList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectTransferList.get(i, "TRNS_DV_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectTransferList.get(i, "TRNS_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectTransferList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 11;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 겸직허가신청현황 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public XSSFWorkbook selectTwoJobPerListExcel(KSPOList selectTwoJobPerList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("겸직허가신청현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 1;
		int cellNum = 0;
		
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("연번");
		sheet.setColumnWidth(0, 2000);	
		
		cell = row.createCell(1);
		cell.setCellValue("신청인");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,0,1,5));
		
		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("겸직 내용");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,0,6,11));
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("승인 여부");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		row = sheet.createRow(1);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));	
		
		cell = row.createCell(1);
		cell.setCellValue("종목명");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("성명");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("소속");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("관할병무청");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("겸직근무처(기관)");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("겸직기간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 7000);
		
		cell = row.createCell(8);
		cell.setCellValue("겸직사유");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 7000);
		
		cell = row.createCell(9);
		cell.setCellValue("수입발생");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("겸직내용");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 8000);
		
		cell = row.createCell(11);
		cell.setCellValue("담당자(담당자)");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,12,12));	
		
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectTwoJobPerList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectTwoJobPerList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectTwoJobPerList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectTwoJobPerList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectTwoJobPerList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectTwoJobPerList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectTwoJobPerList.get(i, "TEAM_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectTwoJobPerList.get(i, "CONC_OFC"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectTwoJobPerList.get(i, "CONC_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectTwoJobPerList.get(i, "CONC_PRVONSH_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectTwoJobPerList.get(i, "INCM_YN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectTwoJobPerList.get(i, "CONC_REASON"));
			cell.setCellStyle(getClobDataLeftStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(selectTwoJobPerList.get(i, "B_REGR_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(selectTwoJobPerList.get(i, "DSPTH_REASON"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cellNum = 14;
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 공익복무실적 - 총괄 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public XSSFWorkbook selectRecordAllListExcel(KSPOList selectRecordAllList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무실적-총괄 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 1;
		
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("연번");
		sheet.setColumnWidth(0, 2000);	
		
		cell = row.createCell(1);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 6000);
		
		cell = row.createCell(4);
		cell.setCellValue("편입일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 6000);
		
		cell = row.createCell(5);
		cell.setCellValue("만료일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 6000);
		
		cell = row.createCell(6);
		cell.setCellValue("연장만료일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 6000);
		
		cell = row.createCell(7);
		cell.setCellValue("의무시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("인정시간(B)");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.addMergedRegion(new CellRangeAddress(0,0,8,9));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("잔여시간(C=A-B)");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.addMergedRegion(new CellRangeAddress(0,0,10,11));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("비고");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		row = sheet.createRow(1);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
		
		cell = row.createCell(1);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,1,1));
		
		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,2,2));
		
		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,3,3));
		
		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,4,4));
		
		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,5,5));
		
		cell = row.createCell(6);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,6,6));
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,7,7));
		
		cell = row.createCell(8);
		cell.setCellValue("시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 2000);
		
		cell = row.createCell(9);
		cell.setCellValue("분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 2000);
		
		cell = row.createCell(10);
		cell.setCellValue("시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 2000);
		
		cell = row.createCell(11);
		cell.setCellValue("분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 2000);
		
		cell = row.createCell(12);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 2000);
		sheet.addMergedRegion(new CellRangeAddress(0,1,12,12));

		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectRecordAllList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectRecordAllList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectRecordAllList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectRecordAllList.get(i, "B_APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectRecordAllList.get(i, "B_BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectRecordAllList.get(i, "ADDM_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectRecordAllList.get(i, "RSVT_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectRecordAllList.get(i, "EXPR_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectRecordAllList.get(i, "VLUN_DUTY_HR"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectRecordAllList.get(i, "TOT_FINAL_TIME_HR"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectRecordAllList.get(i, "TOT_FINAL_TIME_MN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectRecordAllList.get(i, "FINAL_REMAIN_TIME_HR"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(selectRecordAllList.get(i, "FINAL_REMAIN_TIME_MN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue("");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	/**
	 * 공익복무실적 - 개인 엑셀다운로드
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public XSSFWorkbook selectRecordPerExcel(KSPOMap recordPer, KSPOList selectRecordPerList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무실적-개인 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 4;
		
		//1라인
		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("이름");
		sheet.setColumnWidth(0, 2000);
		
		cell = row.createCell(1);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue(recordPer.getStr("M_APPL_NM"));
		cell.setCellStyle(getDataCenterStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("종목명");
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue(recordPer.getStr("GAME_NM"));
		cell.setCellStyle(getDataCenterStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("인정시간 합계");
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue(recordPer.getStr("TOT_FINAL_TIME_HR") + "시간 " + recordPer.getStr("TOT_FINAL_TIME_MN") + "분");
		cell.setCellStyle(getDataCenterStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("잔여시간합계");
		sheet.setColumnWidth(6, 7000);
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue(recordPer.getStr("FINAL_REMAIN_TIME_HR") + "시간 " + recordPer.getStr("FINAL_REMAIN_TIME_MN") + "분");
		cell.setCellStyle(getDataCenterStyle(wb));
		sheet.setColumnWidth(7, 13000);
		
		//3라인
		row = sheet.createRow(2);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("활동기간");
		sheet.addMergedRegion(new CellRangeAddress(2,4,0,0));
		sheet.setColumnWidth(0, 4000);	
		
		cell = row.createCell(1);
		cell.setCellValue("인정시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.addMergedRegion(new CellRangeAddress(2,2,1,5));
		sheet.setColumnWidth(1, 4000);

		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);

		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);

		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);

		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("활동분야");
		sheet.addMergedRegion(new CellRangeAddress(2,4,6,6));
		sheet.setColumnWidth(6, 10000);	
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("봉사내용");
		sheet.addMergedRegion(new CellRangeAddress(2,4,7,7));
		sheet.setColumnWidth(7, 20000);
		
		cell = row.createCell(8);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("대상기관(봉사장소)");
		sheet.addMergedRegion(new CellRangeAddress(2,4,8,8));
		sheet.setColumnWidth(8, 6000);
		
		cell = row.createCell(9);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("확인자");
		sheet.addMergedRegion(new CellRangeAddress(2,4,9,9));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("보고일자");
		sheet.addMergedRegion(new CellRangeAddress(2,4,10,10));
		sheet.setColumnWidth(10, 4000);
		
		//4라인
		
		row = sheet.createRow(3);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 2000);
		cell.setCellValue("활동시간");
		sheet.addMergedRegion(new CellRangeAddress(3,3,1,2));
		
		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 2000);
		
		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 2000);
		cell.setCellValue("이동시간");
		
		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("합계");
		sheet.setColumnWidth(4, 2000);
		sheet.addMergedRegion(new CellRangeAddress(3,3,4,5));
		
		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 6000);
		
		cell = row.createCell(6);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 6000);
		
		cell = row.createCell(8);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 6000);
		
		cell = row.createCell(9);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		//5 라인
				
		row = sheet.createRow(4);
		cell = row.createCell(0);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 3000);
		cell.setCellValue("시간");
		
		cell = row.createCell(2);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("분");
		sheet.setColumnWidth(2, 3000);
		
		cell = row.createCell(3);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("시간");
		sheet.setColumnWidth(3, 3000);
		
		cell = row.createCell(4);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("시간");
		sheet.setColumnWidth(4, 3000);
		
		cell = row.createCell(5);
		cell.setCellStyle(getHeaderStyle(wb));
		cell.setCellValue("분");
		sheet.setColumnWidth(5, 3000);
		
		cell = row.createCell(6);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 6000);
		
		cell = row.createCell(8);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 6000);
		
		cell = row.createCell(9);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < selectRecordPerList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(selectRecordPerList.get(i, "ACT_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(selectRecordPerList.get(i, "ACT_TIME_HR"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(selectRecordPerList.get(i, "ACT_TIME_MN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(selectRecordPerList.get(i, "WP_MV_TIME"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(selectRecordPerList.get(i, "TOT_ACCEPT_TIME_HR"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(selectRecordPerList.get(i, "TOT_ACCEPT_TIME_MN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(selectRecordPerList.get(i, "ACT_FIELD"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(selectRecordPerList.get(i, "SRVC_CONTENTS"));
			cell.setCellStyle(getClobDataLeftStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(selectRecordPerList.get(i, "VLUN_PLC_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(selectRecordPerList.get(i, "B_PLC_MNGR_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(selectRecordPerList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		
		return wb;
	}
	
	public XSSFWorkbook selectPlanListExcel(KSPOList planExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무 계획관리 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("계획번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("구분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("활동분야");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("활동시작일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("활동종료일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("대상기관");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 8000);
		
		cell = row.createCell(10);
		cell.setCellValue("등록일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < planExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(planExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(planExcelList.get(i, "VLUN_PLAN_SN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(planExcelList.get(i, "APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(planExcelList.get(i, "BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(planExcelList.get(i, "GAME_CD_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(planExcelList.get(i, "VLUN_PLC_DV_TXT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(planExcelList.get(i, "ACT_FIELD"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(planExcelList.get(i, "VLUN_ACT_START"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(planExcelList.get(i, "VLUN_ACT_END"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(planExcelList.get(i, "VLUN_PLC_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(planExcelList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(planExcelList.get(i, "PLAN_STS"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(planExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	public XSSFWorkbook selectRecordListExcel(KSPOList recordExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무 실적관리 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("계획번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("구분");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("활동분야");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 7000);
		
		cell = row.createCell(7);
		cell.setCellValue("대상기관");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 8000);
		
		cell = row.createCell(8);
		cell.setCellValue("봉사건수");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("등록일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("인정시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("처리상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < recordExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(recordExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(recordExcelList.get(i, "VLUN_RECD_SN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(recordExcelList.get(i, "APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(recordExcelList.get(i, "BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(recordExcelList.get(i, "GAME_CD_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(recordExcelList.get(i, "VLUN_PLC_DV_TXT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(recordExcelList.get(i, "ACT_FIELD"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(recordExcelList.get(i, "VLUN_PLC_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(recordExcelList.get(i, "VLUN_RECD_CNT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(recordExcelList.get(i, "REG_DTM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(recordExcelList.get(i, "FINAL_ACT_TIME_HR") + "시간 " + recordExcelList.get(i, "FINAL_ACT_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(recordExcelList.get(i, "RECD_STS"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(recordExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	public XSSFWorkbook selectRecordPerListExcel(KSPOList recordPerExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무 실적조회 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("관리번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("편입일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("복무만료일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("실적건수");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("봉사건수");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("활동시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("이동시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("합계");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("잔여시간");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		cell = row.createCell(13);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(13, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < recordPerExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(recordPerExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(recordPerExcelList.get(i, "MLTR_ID"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(recordPerExcelList.get(i, "APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(recordPerExcelList.get(i, "BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(recordPerExcelList.get(i, "GAME_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(recordPerExcelList.get(i, "ADDM_F_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(recordPerExcelList.get(i, "EXPR_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(recordPerExcelList.get(i, "RECD_M_CNT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(recordPerExcelList.get(i, "RECD_D_CNT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(recordPerExcelList.get(i, "TOT_FINAL_ACT_TIME_HR") + "시간 " + recordPerExcelList.get(i, "TOT_FINAL_ACT_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(recordPerExcelList.get(i, "TOT_FINAL_WP_MV_TIME"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(recordPerExcelList.get(i, "TOT_FINAL_TIME_HR") + "시간 " + recordPerExcelList.get(i, "TOT_FINAL_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(recordPerExcelList.get(i, "FINAL_REMAIN_TIME_HR") + "시간 " + recordPerExcelList.get(i, "FINAL_REMAIN_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(13);
			cell.setCellValue(recordPerExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	public XSSFWorkbook selectEvalListExcel(KSPOList evalExcelList) throws Exception {
		
		XSSFWorkbook wb = new XSSFWorkbook();
		Sheet sheet = wb.createSheet("공익복무 실적평가 현황");
		Row row = null;
		Cell cell = null;
		int rowNum = 0;
		
		row = sheet.createRow(rowNum);
		cell = row.createCell(0);
		cell.setCellValue("번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(0, 4000);
		
		cell = row.createCell(1);
		cell.setCellValue("평가번호");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(1, 4000);
		
		cell = row.createCell(2);
		cell.setCellValue("이름");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(2, 4000);
		
		cell = row.createCell(3);
		cell.setCellValue("생년월일");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(3, 4000);
		
		cell = row.createCell(4);
		cell.setCellValue("종목");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(4, 4000);
		
		cell = row.createCell(5);
		cell.setCellValue("편입일자");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(5, 4000);
		
		cell = row.createCell(6);
		cell.setCellValue("인정실적");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(6, 4000);
		
		cell = row.createCell(7);
		cell.setCellValue("분기실적");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(7, 4000);
		
		cell = row.createCell(8);
		cell.setCellValue("잔여실적");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(8, 4000);
		
		cell = row.createCell(9);
		cell.setCellValue("상태");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(9, 4000);
		
		cell = row.createCell(10);
		cell.setCellValue("부진사유");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(10, 4000);
		
		cell = row.createCell(11);
		cell.setCellValue("평가결과");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(11, 4000);
		
		cell = row.createCell(12);
		cell.setCellValue("체육단체");
		cell.setCellStyle(getHeaderStyle(wb));
		sheet.setColumnWidth(12, 4000);
		
		rowNum++;
		
		row = sheet.createRow(rowNum);
		
		for (int i = 0; i < evalExcelList.size(); i++) {
			row = sheet.createRow(rowNum);
			
			cell = row.createCell(0);
			cell.setCellValue(evalExcelList.get(i, "RNUM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(1);
			cell.setCellValue(evalExcelList.get(i, "VLUN_EVAL_SN"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(2);
			cell.setCellValue(evalExcelList.get(i, "APPL_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(3);
			cell.setCellValue(evalExcelList.get(i, "BRTH_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(4);
			cell.setCellValue(evalExcelList.get(i, "GAME_CD_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(5);
			cell.setCellValue(evalExcelList.get(i, "APPL_DT"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(6);
			cell.setCellValue(evalExcelList.get(i, "TOT_FINAL_TIME_HR") + "시간 " + evalExcelList.get(i, "TOT_FINAL_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(7);
			cell.setCellValue(evalExcelList.get(i, "QTR_RESULT_HR") + "시간 " + evalExcelList.get(i, "QTR_RESULT_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(8);
			cell.setCellValue(evalExcelList.get(i, "FINAL_REMAIN_TIME_HR") + "시간 " + evalExcelList.get(i, "FINAL_REMAIN_TIME_MN") + "분");
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(9);
			cell.setCellValue(evalExcelList.get(i, "EVAL_STS_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(10);
			cell.setCellValue(evalExcelList.get(i, "POOR_REASON"));
			cell.setCellStyle(getClobDataLeftStyle(wb));
			
			cell = row.createCell(11);
			cell.setCellValue(evalExcelList.get(i, "EVAL_RESULT_CD_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			cell = row.createCell(12);
			cell.setCellValue(evalExcelList.get(i, "MEMORG_NM"));
			cell.setCellStyle(getDataCenterStyle(wb));
			
			rowNum++;
			
		}
		
		return wb;
	}
	
	public XSSFCellStyle getHeaderStyle(XSSFWorkbook wb) throws Exception {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		style.setFillForegroundColor(IndexedColors.GREY_80_PERCENT.index);
		style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		style.setTopBorderColor(IndexedColors.WHITE.index);
		style.setLeftBorderColor(IndexedColors.WHITE.index);
		style.setRightBorderColor(IndexedColors.WHITE.index);
		style.setBottomBorderColor(IndexedColors.WHITE.index);
				
		XSSFFont font = wb.createFont();
		font.setColor(IndexedColors.WHITE.index);
		font.setFontName("맑은고딕");
		font.setFontHeight((short)180);
		style.setFont(font);
		
		return style;
	}
	
	public XSSFCellStyle getDataCenterStyle(XSSFWorkbook wb) throws Exception {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.index);
		
		XSSFFont font = wb.createFont();
		font.setFontName("맑은고딕");
		font.setFontHeight((short)180);
		style.setFont(font);
		
		return style;
	}
	
	public XSSFCellStyle getDataRightStyle(XSSFWorkbook wb) throws Exception {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setAlignment(HorizontalAlignment.RIGHT);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.index);
		
		XSSFFont font = wb.createFont();
		font.setFontName("맑은고딕");
		font.setFontHeight((short)180);
		style.setFont(font);
		
		return style;
	}
	
	public XSSFCellStyle getClobDataLeftStyle(XSSFWorkbook wb) throws Exception {
		XSSFCellStyle style = wb.createCellStyle();
		
		style.setAlignment(HorizontalAlignment.LEFT);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		
		style.setBorderTop(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderBottom(BorderStyle.THIN);
		style.setTopBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setLeftBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setRightBorderColor(IndexedColors.GREY_25_PERCENT.index);
		style.setBottomBorderColor(IndexedColors.GREY_25_PERCENT.index);
		
		XSSFFont font = wb.createFont();
		font.setFontName("맑은고딕");
		font.setFontHeight((short)180);
		style.setFont(font);
		
		style.setWrapText(true);//CLOB 데이터 개행
		
		return style;
	}

}
