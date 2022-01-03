<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

	$(document).ready(function(){
		fn_hideDivBtn();
	});
	
	function fn_setform(formId, readonlyFlag){
		$('#' + formId + ' input').prop('readonly', readonlyFlag);
		$('#' + formId + ' textarea').prop('disabled', readonlyFlag);
		$('#' + formId + ' select').prop('disabled', readonlyFlag);
		$('#' + formId + ' input[name=EVAL_RESULT_CD]').prop('disabled', readonlyFlag);
		
		$('input[name=APPL_NM]').prop('readonly', true);
	}
	
	function fn_hideDivBtn(){
		$('button[id=personSrhBtn]').hide();
		
		$('#lastUpdateDiv').hide();//수정이력
		$('#kdConfirmDiv').hide();
		$('#poorReasonDiv').hide();
		$('button[id=saveEvalBtn]').hide();//등록 버튼
		$('button[id=savePoorReasonBtn]').hide();//부진사유버튼
		$('button[id=evalResultBtn]').hide();//평과결과 등록 버튼

		fn_setform('mFrm', true);
		fn_setform('kdFrm', true);
	}
	
	function fn_setttingDivAndBtn(){
		
		fn_hideDivBtn();
		
		var grpSn = "${sessionScope.userMap.GRP_SN}";
		//1	공단사용자
		//2	일반사용자
		//3	문체부사용자
		//4	시스템관리자
			
		var VLUN_EVAL_SN = $('#mFrm input[name=VLUN_EVAL_SN]').val();
		var POOR_REASON = $('#mFrm textarea[name=POOR_REASON]').val(); 
		
		if(VLUN_EVAL_SN.length < 1 && grpSn == "1"){//최초 작성시에만 활성 && 공단 담당자일때
			$('button[id=personSrhBtn]').show();
			$('button[id=saveEvalBtn]').show();
		}
		
		if(VLUN_EVAL_SN.length > 0 && POOR_REASON.length < 1 && ['1','2'].indexOf(grpSn) != -1){//부진사유등록은 체육담당자,공단 담당자 모두가능
			$('#poorReasonDiv').show();
			$('button[id=savePoorReasonBtn]').show();
			fn_setform('mFrm', false);	
			createAtchFileIdTr();
		}
		
		if(VLUN_EVAL_SN.length > 0 && POOR_REASON.length > 0){
			$('#poorReasonDiv').show();
			
			if(grpSn == "1"){
				$('#kdConfirmDiv').show();
				
				if($('#kdFrm input[name=EVAL_RESULT_CD]:checked').length < 1){//평가결과등록 이후에는 등록불가
					$('button[id=evalResultBtn]').show();
					fn_setform('kdFrm', false);	
				}	
			}
		}
		
		$('#lastUpdateDiv').show();
		
	}
	
	//실적평가 조회
	function fn_search(){
		fnPageLoad("/plan/RecordEvalSelect.kspo",$("#searchFrm").serialize());
	}
	
	//실적평가 팝업 활성화
	function fn_evalPopupOpen(type){
		
		if(type == 'ADD'){//등록시에
			var EVAL_YEAR = $('#searchFrm select[name=srchEvalYear]').val();
			var EVAL_QTR = $('#searchFrm select[name=srchEvalQtr]').val();
			
			if(EVAL_YEAR == ''){
				fnAlert("검색년도를 선택해주세요.");
				return false;
			}
			
			if(EVAL_QTR == ''){
				fnAlert("분기를 선택해주세요.");
				return false;
			}
			
			$('#mFrm input[name=EVAL_YEAR]').val(EVAL_YEAR);
			$('#mFrm input[name=EVAL_QTR]').val(EVAL_QTR);	
			
			fn_setttingDivAndBtn();
		}
		
		$('#evalPopDiv').addClass('active');
	}
	
	//실적평가 팝업 비활성
	function fn_evalPopupClose(){
		
		fn_hideDivBtn();
		
		//첨부파일초기화
		$('#ATCH_FILE_ID_TR').parent().find('tr').each(function(){
			if($(this).data('atch_tr_type') == 'default' || $(this).data('atch_tr_type') == 'added'){
				$(this).remove();
			}	
		});
		
		//대상자 인적사항 초기화
		$('#mFrm input[name=APPL_NM]').val('');
		$('#mFrm td[id=TD_APPL_SN]').html('');
		$('#mFrm td[id=TD_BRTH_DT]').html('');
		$('#mFrm td[id=TD_ADDR]').html('');
		$('#mFrm td[id=TD_EMAIL]').html('');
		$('#mFrm td[id=TD_CP_NO]').html('');
		$('#mFrm td[id=TD_GAME_CD_NM]').html('');
		$('#mFrm td[id=TD_MEM_ORG_NM]').html('');
		
		//공익복무 실적 초기화
		var htmlStr = "<tr><td colspan=\"5\">검색을 해주세요.</td></tr>";
		$('#personQtrRecordTbody').empty().append(htmlStr);
		
		//부진사유 입력란 초기화
		$('#mFrm input[name=VLUN_EVAL_SN]').val('');
		$('#mFrm input[name=MLTR_ID]').val('');
		$('#mFrm input[name=EVAL_STS]').val('');
		$('#mFrm input[name=EVAL_STS_NM]').val('');
		$('#mFrm input[name=EVAL_YEAR]').val('');
		$('#mFrm input[name=EVAL_QTR]').val('');
		$('#mFrm input[name=QTR_RESULT_HR]').val('');
		$('#mFrm input[name=QTR_RESULT_MN]').val('');
		$('#mFrm textarea[name=POOR_REASON]').val('');
		$('#mFrm input[name=ATCH_FILE_ID]').val('');
		
		//부진사유평가 초기화
		$('#kdFrm input[name=VLUN_EVAL_SN]').val('');
		$('#kdFrm input[name=MLTR_ID]').val('');
		$('#kdFrm textarea[name=EVAL_RESULT_RMK]').val('');
		
		$('#evalPopDiv').removeClass('active');
	}
	
	//체육요원 검색 팝업 활성
	function fn_searchPersonPopupOpen(){
		$('#searchPersonPopDiv').addClass('active');
	}
	
	//체육요원 검색 팝업 비활성
	function fn_searchPersonPopupClose(){
		
		$('#searchPersonFrm select[name=pSrchKeyKind]').val('');//키워드 종류 초기화
		$('#searchPersonFrm input[name=pSrchKeyword]').val('');//키워드 입력란 초기화
		$('#searchPersonFrm tbody[id=personTbody]').empty();//검색결과 초기화
		$('#searchPersonCnt').html('0');//조회결과 카운트 초기화
		$('#personPagingDiv').empty();//페이징 초기화
		$('#searchPersonPopDiv').removeClass('active');
	}
	
	//체육요원 리스트 검색
	function fn_popPersonSearch(pageNo){

		var pSrchGameCd = $('#searchPersonFrm select[name=pSrchGameCd]').val();
		var pSrchKeyKind = $('#searchPersonFrm select[name=pSrchKeyKind]').val();
		var pSrchKeyword = $('#searchPersonFrm input[name=pSrchKeyword]').val();
		
		var param = "pSrchGameCd=" + pSrchGameCd;
			param += "&pSrchKeyKind=" + pSrchKeyKind;
			param += "&pSrchKeyword=" + pSrchKeyword;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		if(typeof(pageNo) != "undefined"){
			param+= "&pageNo=" + pageNo;	
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonListJs.kspo", param);
		
		if($json.statusText != "OK"){
			fnAlert("오류가 발생하였습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var personList = $json.responseJSON.personList;
		
		var htmlStr = "";
		
		if(personList.length < 1){
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"5\" class=\"center\">일치하는 체육요원이 없습니다.</td>";
			htmlStr += "<tr>";
		}
		
		for(var i = 0; i < personList.length; i++){
			var MLTR_ID = personList[i].MLTR_ID;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"MLTR_ID_GRP\" id=\"MLTR_ID" + i + "\" value=\"" + MLTR_ID + "\">";
			htmlStr += "<label for=\"MLTR_ID" + i + "\" class=\"chk-only\">선택</label>";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td>" + MLTR_ID + "</td>";
			htmlStr += "<td>" + personList[i].APPL_NM + "</td>";
			htmlStr += "<td>" + personList[i].BRTH_DT + "</td>";
			htmlStr += "<td>" + personList[i].GAME_CD_NM + "</td>";
			htmlStr += "</tr>";
		}
		
		$('#personTbody').empty().append(htmlStr);
		
		var pageInfo = $json.responseJSON.pageInfo;
		
		if(personList.length > 0){
			$('#searchPersonCnt').html(personList[0].TOTAL_RECORD_COUNT);
		}
		
		$('#personPagingDiv').empty().append(pageInfo);
		
	}
	
	//체육요원 선택
	function fn_confirmPerson(){
		
		var checkedCnt = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').length;
		
		if(checkedCnt < 1){
			fnAlert("체육요원을 선택해주세요.");
			return false;
		}
		
		if(checkedCnt > 1){
			fnAlert("한명의 체육요원을 선택해주세요.");
			return false;
		}
		
		var MLTR_ID = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').val();
		
		if(MLTR_ID == ''){
			fnAlert("선택된 체육요원의 정보가 올바르지 않습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var param = "MLTR_ID=" + MLTR_ID;
		param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();	
	
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var personInfo = $json.responseJSON.personInfo;
			var htmlStr = "";
			
			if(personInfo == null){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			$('#mFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html(personInfo.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html(personInfo.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html(personInfo.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html(personInfo.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html(personInfo.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html(personInfo.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html(personInfo.MEMORG_NM);
			$('#mFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
		
			fn_getQtrRecord();
			
			fn_searchPersonPopupClose();
		
		} else {
			return false;
		}
	}
	
	//실적 조회
	function fn_getQtrRecord(type){
		
		var param = "MLTR_ID=" + $('#mFrm input[name=MLTR_ID]').val();
		param += "&EVAL_YEAR=" + $('#mFrm input[name=EVAL_YEAR]').val();
		param += "&EVAL_QTR=" + $('#mFrm input[name=EVAL_QTR]').val();
		param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();	

		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonQtrRecordJs.kspo", param);
	
		if($json.statusText == "OK"){
			var recordQtrInfo = $json.responseJSON.recordQtrInfo;
			
			if(recordQtrInfo == null){
				fnAlert("조회된 실적 정보가 존재하지 않습니다.");
				return false;
			}
			
			var MLTR_ID = recordQtrInfo.MLTR_ID;
			var APPL_DT = recordQtrInfo.APPL_DT;
			var EVAL_YEAR = recordQtrInfo.EVAL_YEAR;
			var EVAL_QTR = recordQtrInfo.EVAL_QTR;
			
			//조회시 저장된 데이터로 세팅
			var TOT_ACCEPT_HR = (type == 'OLD') ? $('#mFrm input[name=QTR_RESULT_HR]').val() : recordQtrInfo.TOT_FINAL_TIME_HR;
			var TOT_ACCEPT_MN = (type == 'OLD') ? $('#mFrm input[name=QTR_RESULT_MN]').val() : recordQtrInfo.TOT_FINAL_TIME_MN;
			var EVAL_STS = (type == 'OLD') ? $('#mFrm input[name=EVAL_STS]').val() : recordQtrInfo.EVAL_STS; 
			var EVAL_STS_NM = (type == 'OLD') ? $('#mFrm input[name=EVAL_STS_NM]').val() : recordQtrInfo.EVAL_STS_NM; 
			
			
			var htmlStr = "";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"center\">" + APPL_DT + "</td>";
				htmlStr += "<td class=\"center\">" + EVAL_YEAR + "</td>";
				htmlStr += "<td class=\"center\">" + EVAL_QTR + "</td>";
				htmlStr += "<td class=\"center\">" + TOT_ACCEPT_HR +"시간 " + TOT_ACCEPT_MN + "분</td>";
				htmlStr += "<td class=\"center\">" + EVAL_STS_NM + "</td>";
				htmlStr += "</tr>";
				
				$('#personQtrRecordTbody').empty().append(htmlStr);
				
				//mFrm 세팅
				$('#mFrm input[name=MLTR_ID]').val(MLTR_ID);
				$('#mFrm input[name=EVAL_YEAR]').val(EVAL_YEAR);
				$('#mFrm input[name=EVAL_QTR]').val(EVAL_QTR);
				$('#mFrm input[name=QTR_RESULT_HR]').val(TOT_ACCEPT_HR);
				$('#mFrm input[name=QTR_RESULT_MN]').val(TOT_ACCEPT_MN);
				$('#mFrm input[name=EVAL_STS]').val(EVAL_STS);
				
				fn_searchPersonPopupClose();
		}
	}
	
	//등록
	function fn_saveEval(){
		
		if($('#mFrm input[name=MLTR_ID]').val() == ''){
			fnAlert("체육요원을 선택해주세요.");
			return false;
		}
		
		if(!confirm("등록하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/plan/saveEvalJs.kspo", "mFrm");
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
				
			if(resultCnt > 0) {	
				fn_evalPopupClose();
				fnAlert("저장되었습니다.");
				fn_search();
			} else {
				fnAlert("저장에 실페하였습니다.");
				fn_search();
			}
		}
	}
	
	function fn_savePoorReason(){
		
		if($('#mFrm textarea[name=POOR_REASON]').val() == ''){
			fnFocAlert("부진사유를 입력해주세요.", $('#mFrm textarea[name=POOR_REASON]'));
			return false;
		}
		
		if(!confirm("부진사유를 등록하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/plan/saveEvalPoorReasonJs.kspo", "mFrm");
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
				
			if(resultCnt > 0) {	
				fn_evalPopupClose();
				fnAlert("부진사유가 등록되었습니다.");
				fn_search();
			} else {
				fnAlert("부진사유등록에 실페하였습니다.");
				fn_search();
			}
		}
		
	}
	
	//부진사유평가 등록
	function fn_saveEvalResult(){
		
		if($('#mFrm input[name=VLUN_EVAL_SN]').val() == ''){
			fnAlert("실적평가를 먼저 진행해주세요.");
			return false;
		}
		
		$('#kdFrm input[name=VLUN_EVAL_SN]').val($('#mFrm input[name=VLUN_EVAL_SN]').val());
		$('#kdFrm input[name=MLTR_ID]').val($('#mFrm input[name=MLTR_ID]').val());
		
		if($('#mFrm input[name=MLTR_ID]').val() == ''){
			fnAlert("체육요원을 선택해주세요.");
			return false;
		}
		
		if($('#kdFrm input[name=EVAL_RESULT_CD]:checked').length < 1){
			fnAlert("평과결과를 선택해주세요.");
			return false;
		}
		
		if($('#kdFrm textarea[name=EVAL_RESULT_RMK]').val() == ''){
			fnFocAlert("비고를 입력해주세요.", $('#kdFrm textarea[name=EVAL_RESULT_RMK]'));
			return false;
		}
		
		if(!confirm("평가결과를 등록하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/saveEvalResultJs.kspo", $("#kdFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
				
			if(resultCnt > 0) {	
				fn_evalPopupClose();
				fnAlert("평가결과가 등록되었습니다.");
				fn_search();
			} else {
				fnAlert("평가결과등록에 실페하였습니다.");
				fn_search();
			}
		}
	}
	
	//상세조회
	function fn_detail(VLUN_EVAL_SN){
		
		var param = "VLUN_EVAL_SN=" + VLUN_EVAL_SN;
			param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectEvalDetailJs.kspo", param);
	
		if($json.statusText == "OK"){
		
			var $evalInfo = $json.responseJSON.evalInfo;
			var $fileList = $json.responseJSON.fileList;

			if($evalInfo == null){
				fnAlert("상세보기기 오류가 발생하였습니다.");
				return false;
			}
			
			//대상자 인정사항 정보
			$('#mFrm input[name=APPL_NM]').val($evalInfo.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html($evalInfo.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html($evalInfo.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html($evalInfo.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html($evalInfo.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html($evalInfo.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html($evalInfo.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html($evalInfo.MEMORG_NM);
			
			
			//실적평가 정보 세팅
			$('#mFrm input[name=VLUN_EVAL_SN]').val($evalInfo.VLUN_EVAL_SN);
			$('#mFrm input[name=MLTR_ID]').val($evalInfo.MLTR_ID);
			$('#mFrm input[name=EVAL_YEAR]').val($evalInfo.EVAL_YEAR);
			$('#mFrm input[name=EVAL_QTR]').val($evalInfo.EVAL_QTR);
			$('#mFrm input[name=QTR_RESULT_HR]').val($evalInfo.QTR_RESULT_HR);
			$('#mFrm input[name=QTR_RESULT_MN]').val($evalInfo.QTR_RESULT_MN);
			$('#mFrm textarea[name=POOR_REASON]').val($evalInfo.POOR_REASON);
			$('#mFrm input[name=ATCH_FILE_ID]').val($evalInfo.ATCH_FILE_ID);
			$('#mFrm input[name=EVAL_STS]').val($evalInfo.EVAL_STS);
			$('#mFrm input[name=EVAL_STS_NM]').val($evalInfo.EVAL_STS_NM);
			
			//부진사유 평가 세팅
			$('#kdFrm textarea[name=EVAL_RESULT_RMK]').val($evalInfo.EVAL_RESULT_RMK);
			
			$('#kdFrm input[name=EVAL_RESULT_CD]').each(function(){
				if($(this).val() == $evalInfo.EVAL_RESULT_CD){
					$(this).prop('checked', true);
				} else {
					$(this).prop('checked', false);
				}
			});
			
			fn_getQtrRecord('OLD');
			
			//첨부파일
			var fileHtmlStr = "";

			for(var i = 0; i < $fileList.length; i++){
				fileHtmlStr = "";
				fileHtmlStr += "<tr data-atch_tr_type=\"added\">";
				fileHtmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
				fileHtmlStr += "<a href=\"javascript:fnDownloadFile('" + $fileList[i].FILE_SN + "');\"><span class=\"file-name\">" + $fileList[i].FILE_ORGIN_NM + "</span></a>";
				//fileHtmlStr += "<button class=\"file-del\" onclick=\"fn_fileDel('"+ $fileList[i].FILE_SN + "', this);\"> 삭제</button>";
				fileHtmlStr += "</td>";
				fileHtmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
				fileHtmlStr += "</td>";
				fileHtmlStr += "</tr>";
				
				$('tr[id=ATCH_FILE_ID_TR]').after(fileHtmlStr);
			}
			
			//최근 수정이력 세팅
			$('#lastUpdateLi').html("Last Update. " + $evalInfo.LATEST_NM + " / " + $evalInfo.LATEST_UPDT);
			
			fn_setttingDivAndBtn();
			
			fn_evalPopupOpen();
		}
	}
	
	//기본 첨부파일
	function createAtchFileIdTr(){
		var objId = "uploadBtn1";
		var fileNm = "file";
		
		var htmlStr = "<tr data-atch_tr_type=\"default\">";
			htmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
			htmlStr += "<div class=\"fileBox\">";
			htmlStr += "<input type=\"text\" class=\"fileName2\" readonly=\"readonly\">";
			htmlStr += "<label for=\"" + objId + "\" class=\"btn_file btn navy addlist mrg-0 file-btn\">파일첨부</label>";
			htmlStr += "<input type=\"file\" name=\"" + fileNm + "\" id=\"" + objId + "\" class=\"uploadBtn2\">";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
			htmlStr += "<button class=\"btn lightgrey addfile mrg-5\" type=\"button\" onclick=\"fn_addFile();\"></button>";
			htmlStr += "</td>";
			htmlStr += "</tr>";
		
		$('tr[id=ATCH_FILE_ID_TR]').after(htmlStr);	
	}
	
	//첨부파일 추가
	function fn_addFile(){
		
		var fileNm = "file";
		var fileCnt = $('input[type=file][name=' + fileNm + ']').length;
		
		$('input[type=file][name=' + fileNm + ']').last().parent().parent().parent().after(fn_addFileObj(fileCnt, fileNm));
	}

	//첨부파일 삭제
	function fn_removeFile(obj){
		$(obj).parents("tr").remove();
	}
	
	function fn_addFileObj(fileCnt, fileNm){
		var fileId = "uploadBtn" + (fileCnt + 1);
		
		var addFileObj = "<tr data-atch_tr_type=\"added\">";
			addFileObj += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
			addFileObj += "<div class=\"fileBox\">";
			addFileObj += "<input type=\"text\" class=\"fileName2\" readonly=\"readonly\">";
			addFileObj += "<label for=\"" + fileId + "\" class=\"btn_file btn navy addlist mrg-0 file-btn\">파일첨부</label>";
			addFileObj += "<input type=\"file\" name=\"" + fileNm + "\" id=\"" + fileId + "\" class=\"uploadBtn2\">";
			addFileObj += "</div>";
			addFileObj += "</td>";
			addFileObj += "<td class=\"bdl-0 pdr-0 ft-0\">";
			addFileObj += "<button class=\"btn lightgrey removefile\" type=\"button\" onclick=\"fn_removeFile(this);\"></button>";
			addFileObj += "</td>";
			addFileObj += "</tr>";
			
		return addFileObj
	}
	
	function fn_fileDel(FILE_SN, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			$(fileObj).parent().parent('tr').remove();
		}
	}
	
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/plan/evalDownload.kspo");
		$("#searchFrm").submit();	
	}
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무 실적평가</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form id="searchFrm" method="post" action="${pageContext.request.contextPath}/plan/RecordEvalSelect.kspo">
			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<div class="com-table">
				<table class="table-board">
					<caption></caption>
					<colgroup>
						<col style="width:150px;">
						<col style="width:400px;">
						<col style="width:150px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<td class="t-title">검색연도</td>
							<td>
								<c:set var="nowDt" value="<%=new java.util.Date() %>"/>
								<fmt:formatDate var="currYear" value="${nowDt}" pattern="yyyy"/>
								<select name="srchEvalYear" class="smal">
								<c:forEach var="result" begin="0" end="${currYear - 2015}" step="1">
									<c:set var="yearValue" value="${currYear - result }"/>
									<option value="${yearValue}" <c:if test="${param.srchEvalYear eq yearValue or defEvalYear eq yearValue}">selected="selected"</c:if>>${yearValue}년도</option>
								</c:forEach>
								</select>
								<select name="srchEvalQtr" class="smal">
									<c:forEach var="qtr" begin="1" end="4" step="1">
										<option value="${qtr}" <c:if test="${param.srchEvalQtr eq qtr or defEvalQtr eq qtr}">selected="selected"</c:if>>${qtr}분기</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">체육단체</td>
							<td>
								<select name="srchMemorgCd" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne 2}">
									<option value="" <c:if test="${param.srchMemorgCd eq '' or param.srchMemorgCd eq null }">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach var="subLi" items="${memorgCdList}">
									<option value="${subLi.MEMORG_SN}" <c:if test="${param.srchMemorgCd eq subLi.MEMORG_SN}">selected="selected"</c:if>>${subLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">상태</td>
							<td>
								<select name="srchEvalSts" class="smal">
									<option value="" <c:if test="${param.srchEvalSts eq '' or param.srchEvalSts eq null }">selected="selected"</c:if>>전체</option>
									<c:forEach var="subLi" items="${curEvalStsCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchEvalSts eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">평가결과</td>
							<td colspan="3">
								<select name="srchEvalResultCd" class="smal">
									<option value="" <c:if test="${param.srchEvalResultCd eq '' or param.srchEvalResultCd eq null }">selected="selected"</c:if>>전체</option>
									<c:forEach var="subLi" items="${evalStsCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchEvalResultCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		
		
		<div class="com-btn-group center">
			<button class="btn red write" type="button" onclick="fn_search();">검색</button>
		</div>
		<!-- //검색영역 -->
		
		<div class="com-result">
			<div class="float-l">
				<span class="total-num">조회결과 <b><fmt:formatNumber value="${pageInfo.totalRecordCount}" pattern="#,###"/></b>건</span>
			</div>
			<div class="float-r">
				<select id="srchPageCnt" name="recordCountPerPage" style="height: 42px; width:130px; padding-left: 20px;">
					<c:forEach items="${viewList}" var="subLi">
						<option value="${subLi.ALT_CODE}" <c:if test="${param.recordCountPerPage eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
					</c:forEach>
				</select>&nbsp;&nbsp;
				<c:if test="${sessionScope.userMap.GRP_SN eq 1}"><!--공단 담당자 -->
				<button class="btn red rmvcrr" type="button" onclick="fn_evalPopupOpen('ADD');">등록</button>
				</c:if>
				<button class="btn red type01" type="button" onclick="excel_download();">엑셀데이터 저장하기</button>
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col style="width:50px">
					<col style="width:115px;">
					<col style="width:100px">
					<col style="width:115px;">
					<col style="width:8%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:100px;">
					<col style="width:8%">
					<col style="width:10%">
					<col style="width:auto">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>평가번호</th>
						<th>상태</th>
						<th>이름</th>
						<th>생년월일</th>
						<th>체육단체</th>
						<th>종목</th>
						<th>편입일자</th>
						<th>인정실적</th>
						<th>분기실적</th>
						<th>잔여실적</th>
						<th>부진사유</th>
						<th>평가결과</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty recordEvalList}">
							<c:forEach var="recordEval" items="${recordEvalList}">
							<tr>
								<td>${recordEval.RNUM}</td>
								<td>${recordEval.VLUN_EVAL_SN}</td>
								<td>${recordEval.EVAL_STS_NM}</td>
								<td><a href="javascript:fn_detail('${recordEval.VLUN_EVAL_SN}');" class="tit">${recordEval.APPL_NM}</a></td>
								<td>${recordEval.BRTH_DT}</td>
								<td>${recordEval.MEMORG_NM}</td>
								<td>${recordEval.GAME_CD_NM}</td>
								<td>${recordEval.APPL_DT}</td>
								<td>${recordEval.TOT_FINAL_TIME_HR}시간 ${recordEval.TOT_FINAL_TIME_MN}분</td>
								<td>${recordEval.QTR_RESULT_HR}시간 ${recordEval.QTR_RESULT_MN}분</td>
								<td>${recordEval.FINAL_REMAIN_TIME_HR}시간 ${recordEval.FINAL_REMAIN_TIME_MN}분</td>
								<td>${recordEval.POOR_REASON}</td>
								<td>${recordEval.EVAL_RESULT_CD_NM}</td>
							</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="13" class="center">등록된 게시물이 없습니다.</td>
							</tr>	
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<p class="cmt">※ 분기별 실적이 24시간 미만인 경우 부진상태로 적용됩니다.</p>
		</div>
		
		
		<div class="com-paging">
			<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:searchFrm" />
		</div>
		
		
	</div>
</div>


<!-- 팝업영역 -->
<div class="cpt-popup reg03" id="evalPopDiv"> <!-- class:active 팝업 on/off -->
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			공익복무 실적평가
			<button class="pop-close">
				<img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지" onclick="fn_evalPopupClose();">
			</button>
		</div>
		<div class="pop-body">
			<div class="com-h3">대상자 인적사항</div>
			<form id="mFrm" method="post" onsubmit="return false;" enctype="multipart/form-data">
				<input type="hidden" name="VLUN_EVAL_SN">
				<input type="hidden" name="MLTR_ID">
				<input type="hidden" name="EVAL_YEAR">
				<input type="hidden" name="EVAL_QTR">
				<input type="hidden" name="EVAL_STS">
				<input type="hidden" name="EVAL_STS_NM">
				<input type="hidden" name="QTR_RESULT_HR">
				<input type="hidden" name="QTR_RESULT_MN">
				<input type="hidden" name="ATCH_FILE_ID">
				<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:130px;">
							<col style="width:auto;">
							<col style="width:130px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">이름<span class="t-red"> *</span></td>
								<td class="input-td">
									<div class="search-box">
										<input type="text" name="APPL_NM" readonly="readonly">
										<button type="button" onclick="fn_searchPersonPopupOpen();" id="personSrhBtn">찾기</button>
									</div>
								</td>
								<td class="t-title">관리번호</td>
								<td class="input-td" id="TD_APPL_SN"></td>
							</tr>
							<tr>
								<td class="t-title">생년월일</td>
								<td class="input-td" id="TD_BRTH_DT"></td>
								<td class="t-title">주소</td>
								<td class="input-td" id="TD_ADDR"></td>
							</tr>
							<tr>
								<td class="t-title">이메일</td>
								<td class="input-td" id="TD_EMAIL"></td>
								<td class="t-title">휴대폰</td>
								<td class="input-td" id="TD_CP_NO"></td>
							</tr>
							<tr>
								<td class="t-title">종목</td>
								<td class="input-td" id="TD_GAME_CD_NM"></td>
								<td class="t-title">체육단체</td>
								<td class="input-td" id="TD_MEM_ORG_NM"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="com-h3">공익복무 실적</div>
				<div class="com-grid">
					<table class="table-grid">
						<caption></caption>
						<colgroup>
							<col style="width:20%;">
							<col style="width:20%;">
							<col style="width:20%;">
							<col style="width:20%;">
							<col style="width:auto;">
						</colgroup>
						<thead>
							<tr>
								<th>편입일자</th>
								<th>년도</th>
								<th>분기</th>
								<th>분기실적</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody id="personQtrRecordTbody">
							<tr>
								<td colspan="5">검색을 해주세요.</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="com-h3 add">
					<div class="com-h3 add">
						<div class="right-area">
							<button class="btn red rmvcrr" type="button" onclick="fn_saveEval();" id="saveEvalBtn">등록</button>
						</div>
					</div>
				</div>
				
				<div id="poorReasonDiv">
					<div class="com-h3 add">부진사유
						<div class="right-area">
							<p class="required">필수입력</p>
							<button class="btn red rmvcrr" type="button" onclick="fn_savePoorReason();" id="savePoorReasonBtn">부진사유등록</button>
						</div>
					</div>
					<div class="com-table">
						<table class="table-board">
							<caption></caption>
							<colgroup>
								<col style="width:160px;">
								<col style="width:auto;">
								<col style="width:150px;">
								<col style="width:auto;">
							</colgroup>
							<tbody>
								<tr>
									<td class="t-title">부진사유</td>
									<td colspan="3" class="input-td"><textarea rows="5" name="POOR_REASON"></textarea></td>
								</tr>
								<tr id="ATCH_FILE_ID_TR">
									<td class="t-title" colspan="4">첨부파일</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
			
			<div id="kdConfirmDiv">
				<form id="kdFrm" method="post">
					<input type="hidden" name="VLUN_EVAL_SN">
					<input type="hidden" name="MLTR_ID">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
						<div class="com-h3 add">부진사유 평가
							<div class="right-area">
								<button class="btn red rmvcrr" type="button" id="evalResultBtn" onclick="fn_saveEvalResult();">평가결과등록</button>
							</div>
						</div>
						<div class="com-table">
							<table class="table-board">
								<caption></caption>
								<colgroup>
									<col style="width:130px;">
									<col style="width:auto;">
									<col style="width:130px;">
									<col style="width:auto;">
								</colgroup>
								<tbody>
									<tr>
										<td class="t-title">평가결과</td>
										<td>
											<ul class="com-radio-list">
												<c:forEach var="subLi" items="${evalStsCdList}" varStatus="sts">
												<li>
													<input id="radio${sts.index}" type="radio" value="${subLi.ALT_CODE}" name="EVAL_RESULT_CD">
													<label for="radio${sts.index}">${subLi.CNTNT_FST}</label>
												</li>
												</c:forEach>
											</ul>
										</td>
										<td class="t-title"></td>
										<td></td>
									</tr>
									<tr>
										<td class="t-title">비고</td>
										<td colspan="3" class="input-td"><textarea rows="5" name="EVAL_RESULT_RMK"></textarea></td>
									</tr>
								</tbody>
							</table>
						</div>
				</form>
			</div>

			<div class="com-helf" id="lastUpdateDiv">
				<ol>
					<li id="lastUpdateLi"></li>
				</ol>
			</div>

			<div class="com-btn-group put">
				<div class="float-r">
					<button class="btn grey rmvcrr" type="button" onclick="fn_evalPopupClose();">닫기</button>
				</div>
			</div>
			
		</div>
	</div>
</div>
<!-- //팝업영역 -->

<!-- 팝업영역 --><!-- 체육요원 검색 -->
<div class="cpt-popup" id="searchPersonPopDiv"><!-- class:active 팝업 on/off -->
	<form id="searchPersonFrm" onsubmit="return false;">
		<div class="dim"></div>
		<div class="popup" style="width: 650px;">
			<div class="pop-head">
				체육요원 검색
				<button class="pop-close" onclick="fn_searchPersonPopupClose();">
					<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
				</button>
			</div>
			<div class="pop-body" style="padding: 45px;">
				<!-- 검색영역 -->
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:150px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">종목</td>
								<td>
									<select name="pSrchGameCd" class="tab-sel">
										<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="t-title">키워드</td>
								<td>
									<ul class="com-radio-list">
										<li>
											<select name="pSrchKeyKind" class="smal">
												<option value="">전체</option>
											</select>
											<input type="text" name="pSrchKeyword" class="smal" placeholder="" onkeydown="if(event.keyCode == 13){fn_popPersonSearch();return false;}">
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
	
				<div class="com-btn-group center">
					<button class="btn red write" type="button" onclick="fn_popPersonSearch();">검색</button>
				</div>
				<!-- //검색영역 -->
	
				<div class="com-result">
					<div class="float-l">
						<span class="total-num">조회결과 <b id="searchPersonCnt">0</b>건</span>
					</div>
				</div>
	
				<div class="com-grid type02" style="max-height:271px; overflow-x:hidden; overflow-y: auto;">
					<table class="table-grid">
						<caption></caption>
						<colgroup>
							<col width="50px">
							<col width="25%">
							<col width="30%">
							<col width="20%">
							<col width="auto">
						</colgroup>
						<thead>
							<tr>
								<th>선택</th>
								<th>관리번호</th>
								<th>이름</th>
								<th>생년월일</th>
								<th>종목</th>
							</tr>
						</thead>
						<tbody id="personTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-paging" id="personPagingDiv"></div>
	
				<div class="com-btn-group center">
					<button class="btn grey write" type="button" onclick="fn_searchPersonPopupClose();">취소</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPerson();">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->
