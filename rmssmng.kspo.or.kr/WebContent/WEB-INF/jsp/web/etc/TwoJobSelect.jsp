<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker1, #datepicker2, #datepicker3, #datepicker4, #datepicker5, #datepicker6").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true,
		});
		
		if($("#frm input[name=STD_YMD]").val()!= "" && $("#frm input[name=END_YMD]").val() != ""){
			$("#datepicker1").datepicker('option','maxDate',$("#frm input[name=END_YMD]").val());
			$("#datepicker2").datepicker('option','minDate',$("#frm input[name=STD_YMD]").val());
		}
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker2").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker1").datepicker('option','maxDate',$(this).val());
		});
		//datepicker end
		
		fn_hideDivBtn();
		
	});
	
	function fn_setform(formId, readonlyFlag){
		$('#' + formId + ' input').prop('readonly', readonlyFlag);
		$('#' + formId + ' textarea').prop('disabled', readonlyFlag);
		$('#' + formId + ' select').prop('disabled', readonlyFlag);

		//라디오
		$('#' + formId + ' input[name=WORK_TYPE]').prop('disabled', readonlyFlag);
		$('#' + formId + ' input[name=CONC_PRVONSH_CD]').prop('disabled', readonlyFlag);
		$('#' + formId + ' input[name=INCM_YN]').prop('disabled', readonlyFlag);
		
		
		$('#' + formId + ' input[name=APPL_NM]').prop('readonly', true);
		$('input[name=CONC_START_DT]').prop('readonly', true);
		$('input[name=CONC_END_DT]').prop('readonly', true);
		$('input[name=RECEIPT_DTM]').prop('readonly', true);
		$('input[name=DSPTH_DTM]').prop('readonly', true);
	}
	
	function fn_setttingDivAndBtn(type){
		
		fn_hideDivBtn();
		
		var grpSn = "${sessionScope.userMap.GRP_SN}";
		//1	공단사용자
		//2	일반사용자
		//3	문체부사용자
		//4	시스템관리자
		
		if(type == 'TP'){//임시저장
			if(grpSn == '2'){
				fn_setform('mFrm', false);
				fn_setform('changeReqFrm', false);

				$('button[id=personSrhBtn]').show();
				$('button[id=saveBtn]').show();//임시저장
				$('button[id=applBtn]').show();//신청
				if($('#mFrm input[name=CONC_SN]').val().length > 0){
					$('button[id=delBtn]').show();//삭제	
				}
				
				//첨부파일
				createAtchFileIdTr('NW');
				
			}
		} else if(type == 'TA'){//신청
			$('#kdConfirmDiv').show();//공단 접수내역
			
			if(grpSn == '1'){
				$('button[id=kdKYBtn]').show();//공단접수
				$('button[id=kdKNBtn]').show();//공단반려
				fn_setform('kdFrm', false);
			}
			
		} else if(type == 'KY'){//공단접수
			$('#kdConfirmDiv').show();//공단 접수내역
			$('#mcConfirmDiv').show();//문체부 승인내역
			
			if(grpSn == '1'){
				$('button[id=mcMYBtn]').show();//문체부 승인
				$('button[id=mcMNBtn]').show();//문체부 반려
				fn_setform('mcFrm', false);
				createMcConfirmFileObj();
			}
		} else if(type == 'KN'){//공단반려
			$('#kdConfirmDiv').show();//공단 접수내역
			$('#mcConfirmDiv').show();//문체부 승인내역
		} else if(type == 'MY'){//문체부 승인
			$('#kdConfirmDiv').show();//공단 접수내역
			$('#mcConfirmDiv').show();//문체부 승인내역
			if(grpSn == '2'){
				$('button[id=changeReqBtn]').show();//변경신청
			}
		} else if(type == 'MN'){//문체부 반려
			$('#kdConfirmDiv').show();//공단 접수내역
			$('#mcConfirmDiv').show();//문체부 승인내역
		}
	}
	
	//화면 영역 및 버튼 숨김처리
	function fn_hideDivBtn(){
		$('#kdConfirmDiv').hide();//공단 접수내역
		$('#mcConfirmDiv').hide();//문체부 승인내역
		$('#changeReq').hide();//변경 신청내용
		
		$('button[id=saveBtn]').hide();//임시저장
		$('button[id=applBtn]').hide();//신청
		$('button[id=delBtn]').hide();//삭제
		
		$('button[id=changeReqBtn]').hide();//변경신청
		$('button[id=cancelBtn]').hide();//변경취소
		
		$('button[id=kdKYBtn]').hide();//공단접수
		$('button[id=kdKNBtn]').hide();//공단반려
		
		$('button[id=mcMYBtn]').hide();//문체부 승인
		$('button[id=mcMNBtn]').hide();//문체부 반려
		
		$('button[id=personSrhBtn]').hide();
		
		fn_setform('mFrm', true);
		fn_setform('kdFrm', true);
		fn_setform('mcFrm', true);
		
	}
	
	//겸직허가 신청 팝업 오픈
	function addPopOpen(type){
		
		if(type == 'NEW'){//신규버튼 클릭시
			fn_setttingDivAndBtn('TP');
			$('#mFrm input[name=APPL_DV]').val('NW');//신청시에 신규로 구분 세팅
		}
		
		$("#twoJobPopDiv").addClass("active");
		$("body").css("overflow", "hidden");
	}
	
	//체육요원 겸직허가신청 팝업 닫기
	function addPopClose() {
		
		//겸직허가 신청
		$('#concStsTxtDiv').html('신규작성');
		$('#mFrm input[name=CONC_SN]').val('');
		$('#mFrm input[name=ORG_CONC_SN]').val('');
		$('#mFrm input[name=ATCH_FILE_ID]').val('');
		$('#mFrm input[name=ATCH_FILE_ID2]').val('');
		$('#mFrm input[name=CONC_STS]').val('');
		$('#mFrm input[name=MLTR_ID]').val('');
		$('#mFrm input[name=APPL_DV]').val('');
		$('#mFrm input[name=WORK_TYPE]').prop('checked', false);
		$('#mFrm input[name=CONC_WORK]').val('');
		$('#mFrm input[name=CONC_OFC]').val('');
		$('#mFrm input[name=CONC_OFC_TEL_NO]').val('');
		$('#mFrm input[name=CONC_START_DT]').val('');
		$('#mFrm input[name=CONC_END_DT]').val('');
		$('#mFrm input[name=CONC_WORK_TIME]').val('');
		$('#mFrm input[name=CONC_PRVONSH_CD]').prop('checked', false);
		$('#mFrm textarea[name=CONC_REASON]').val('');
		$('#mFrm input[name=INCM_YN]').prop('checked', false);
		
		//대상자 인적정보
		$('#mFrm input[name=APPL_NM]').val('');
		$('#mFrm td[id=TD_APPL_SN]').html('');
		$('#mFrm td[id=TD_BRTH_DT]').html('');
		$('#mFrm td[id=TD_ADDR]').html('');
		$('#mFrm td[id=TD_EMAIL]').html('');
		$('#mFrm td[id=TD_CP_NO]').html('');
		$('#mFrm td[id=TD_GAME_CD_NM]').html('');
		$('#mFrm td[id=TD_MEM_ORG_NM]').html('');
		
		//공단 승인내역
		$('#kdFrm input[name=RECEIPT_DTM]').val('');
		$('#kdFrm textarea[name=RECEIPT_REASON]').val('');
		$('#kdConcStsNm').html('');
		
		//문체부 승인내역
		$('#mcFrm input[name=DSPTH_DTM]').val('');
		$('#mcFrm textarea[name=DSPTH_REASON]').val('');
		$('#mcFrm input[name=MLTR_ID]').val('');
		$('#mcConcStsNm').html('');
		
		fn_hideDivBtn();
		
		//첨부파일초기화
		$('#ATCH_FILE_ID_TR').parent().find('tr').each(function(){
			if($(this).data('atch_tr_type') == 'default' || $(this).data('atch_tr_type') == 'added'){
				$(this).remove();
			}	
		});
		
		$('#CHANGE_ATCH_FILE_ID_TR').parent().find('tr').each(function(){
			if($(this).data('atch_tr_type') == 'default' || $(this).data('atch_tr_type') == 'added'){
				$(this).remove();
			}	
		});
		
		//변경신청 초기화
		$('#changeReqFrm input[name=ORG_CONC_SN]').val('');
		$('#changeReqFrm input[name=ATCH_FILE_ID]').val('');
		$('#changeReqFrm input[name=ATCH_FILE_ID2]').val('');
		$('#changeReqFrm input[name=MLTR_ID]').val('');
		$('#changeReqFrm input[name=APPL_DV]').val('');
		$('#changeReqFrm input[name=CONC_SN]').val('');
		$('#changeReqFrm input[name=CONC_STS]').val('');
		$('#changeReqFrm input[name=APPL_DV]').val('');
		$('#changeReqFrm input[name=WORK_TYPE]').prop('checked', false);
		$('#changeReqFrm input[name=CONC_WORK]').val('');
		$('#changeReqFrm input[name=CONC_OFC]').val('');
		$('#changeReqFrm input[name=CONC_OFC_TEL_NO]').val('');
		$('#changeReqFrm input[name=CONC_START_DT]').val('');
		$('#changeReqFrm input[name=CONC_END_DT]').val('');
		$('#changeReqFrm input[name=CONC_WORK_TIME]').val('');
		$('#changeReqFrm input[name=CONC_PRVONSH_CD]').prop('checked', false);
		$('#changeReqFrm textarea[name=CONC_REASON]').val('');
		$('#changeReqFrm input[name=INCM_YN]').prop('checked', false);
		
		$("#twoJobPopDiv").removeClass("active")
		$("body").css("overflow","auto")
	}

	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/etc/TwoJobSelect.kspo",$("#frm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/etc/TwoJobDownload.kspo");
		$("#frm").submit();
	}
	
	//체육요원 검색 팝업
	function fn_searchPersonPopupOpen(){
		
		if($('#changeReqFrm input[name=APPL_DV]').val() == 'CH'){
			fnAlert("변경신청시 체육요원을 변경 할수 없습니다.");
			return false;
		}
		
		$('#searchPersonPopDiv').addClass('active');
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
	
	//체육요원 검색 팝업 비활성
	function fn_searchPersonPopupClose(){
		
		$('#searchPersonFrm select[name=pSrchKeyKind]').val('');//키워드 종류 초기화
		$('#searchPersonFrm input[name=pSrchKeyword]').val('');//키워드 입력란 초기화
		$('#searchPersonFrm tbody[id=personTbody]').empty();//검색결과 초기화
		$('#searchPersonCnt').html('0');//조회결과 카운트 초기화
		$('#personPagingDiv').empty();//페이징 초기화
		$('#searchPersonPopDiv').removeClass('active');
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
			
			$('#mFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
			$('#mFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html(personInfo.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html(personInfo.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html(personInfo.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html(personInfo.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html(personInfo.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html(personInfo.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html(personInfo.MEMORG_NM);
			
			fn_searchPersonPopupClose();
		
		}
		
	}
	
	function fn_addFile(type){
		
		var objId = "uploadBtn1" + type;
		var fileNm = type + "_ATCH_FILE_ID";
		var fileCnt = $('input[type=file][name=' + fileNm + ']').length;
		
		$('input[type=file][name=' + fileNm + ']').last().parent().parent().parent().after(fn_addFileObj(fileCnt, type, fileNm));
	}
	
	function fn_addFileObj(fileCnt, type, fileNm){
		var fileId = "uploadBtn" + (fileCnt + 1) + type;
		
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
	
	function fn_removeFile(obj){
		$(obj).parents("tr").remove();
	}
	
	function fn_fileDel(FILE_SN, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			fnAlert("파일이 삭제되었습니다.");
			$(fileObj).parent().parent('tr').remove();
		}
	}
	
	//기본 첨부파일
	function createAtchFileIdTr(type){
		var objId = "uploadBtn1" + type;
		var fileNm = type + "_ATCH_FILE_ID";
		
		var htmlStr = "<tr data-atch_tr_type=\"default\">";
			htmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
			htmlStr += "<div class=\"fileBox\">";
			htmlStr += "<input type=\"text\" class=\"fileName2\" readonly=\"readonly\">";
			htmlStr += "<label for=\"" + objId + "\" class=\"btn_file btn navy addlist mrg-0 file-btn\">파일첨부</label>";
			htmlStr += "<input type=\"file\" name=\"" + fileNm + "\" id=\"" + objId + "\" class=\"uploadBtn2\">";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
			htmlStr += "<button class=\"btn lightgrey addfile mrg-5\" type=\"button\" onclick=\"fn_addFile('" + type + "');\"></button>";
			htmlStr += "</td>";
			htmlStr += "</tr>";
		
		if(type == 'NW'){
			$('tr[id=ATCH_FILE_ID_TR]').after(htmlStr);	
		} else if(type == 'CH'){
			$('tr[id=CHANGE_ATCH_FILE_ID_TR]').after(htmlStr);	
		}
	}
	
	function fn_save(CONC_STS){
		
		var targetFormId = "";//신규신청 form id : mFrm
							  //변경신청 form id : changeReqFrm
		
		var APPL_DV = $('#changeReqFrm input[name=APPL_DV]').val();
		
		if(APPL_DV == 'CH'){
			targetFormId = 'changeReqFrm';
		} else {
			targetFormId = 'mFrm';
		}
		
		
		if(!fn_validate(targetFormId)){
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(CONC_STS == 'TP'){
			confirmMsg = "임시저장 하시겠습니까?";
			resultMsg = "임시저장 되었습니다.";
		}else if(CONC_STS == 'TA'){
			confirmMsg = "신청하시겠습니까?";
			resultMsg = "신청되었습니다.";
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#' + targetFormId + ' input[name=CONC_STS]').val(CONC_STS);
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/etc/saveTwoJobJs.kspo", targetFormId);
		
		if($json.statusText == "OK"){

			var resultCnt = $json.responseJSON.resultCnt;

			if(resultCnt > 0) {
				addPopClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("저장에 실패하였습니다.");
				fn_search();
			}
		}
	}
	
	function fn_validate(targetFormId){
		
		if($('#' + targetFormId + ' input[name=MLTR_ID]').val() == ''){
			fnAlert("체육복무 요원을 선택해주세요.");
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=WORK_TYPE]:checked').length < 1){
			fnAlert("근무형태를 선택해주세요.");
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=CONC_WORK]').val() == ''){
			fnFocAlert("담당직무를 입력해주세요.", $('#' + targetFormId + ' input[name=CONC_WORK]'));
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=CONC_OFC]').val() == ''){
			fnFocAlert("겸직근무처를 입력해주세요.", $('#' + targetFormId + ' input[name=CONC_OFC]'));
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=CONC_OFC_TEL_NO]').val() == ''){
			fnFocAlert("전화번호를 입력해주세요.", $('#' + targetFormId + ' input[name=CONC_OFC_TEL_NO]'));
			return false;
		}
		
		var CONC_START_DT = $('#' + targetFormId + ' input[name=CONC_START_DT]').val();
		var CONC_END_DT = $('#' + targetFormId + ' input[name=CONC_END_DT]').val();
		
		if(CONC_START_DT == ''){
			fnFocAlert("근무기간 시작일자를 선택해주세요.", $('#' + targetFormId + ' input[name=CONC_START_DT]'));
			return false;
		}
		
		if(CONC_END_DT == ''){
			fnFocAlert("근무기간 종료일자를 선택해주세요.", $('#' + targetFormId + ' input[name=CONC_END_DT]'));
			return false;
		}
		
		if(CONC_START_DT > CONC_END_DT){
			fnAlert("근무기간의 시작일이 종료일 이후 일수 없습니다.");
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=CONC_WORK_TIME]').val() == ''){
			fnFocAlert("근무시간을 입력해주세요.", $('#' + targetFormId + ' input[name=CONC_WORK_TIME]'));
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=CONC_PRVONSH_CD]:checked').length < 1){
			fnAlert("겸직사유를 선택해주세요.");
			return false;
		}
		
		if($('#' + targetFormId + ' textarea[name=CONC_REASON]').val() == ''){
			fnFocAlert("겸직내용을 입력해주세요.", $('#' + targetFormId + ' textarea[name=CONC_REASON]'));
			return false;
		}
		
		if($('#' + targetFormId + ' input[name=INCM_YN]:checked').length < 1){
			fnAlert("수입발생여부를 선택해주세요.");
			return false;
		}
		
		return true;
	}
	
	function fn_detail(CONC_SN){
		
		var param = "CONC_SN=" + CONC_SN;
			param += "&gMenuSn=" + $('#mFrm input[name=gMenuSn]').val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/etc/selectTwoJobDetailJs.kspo", param);
	
		if($json.statusText == "OK"){
			var $twoJobInfo = $json.responseJSON.twoJobInfo;
			var $twoJobFileList = $json.responseJSON.fileList;
			var $twoJobMcFileList = $json.responseJSON.mcFileList;
			
			
			//겸직허가신청 세팅
			$('#mFrm input[name=CONC_SN]').val($twoJobInfo.CONC_SN);
			$('#mFrm input[name=CONC_STS]').val($twoJobInfo.CONC_STS);
			$('#mFrm input[name=ATCH_FILE_ID]').val($twoJobInfo.ATCH_FILE_ID);
			$('#concStsTxtDiv').html($twoJobInfo.CONC_STS_NM);
			$('#mFrm input[name=MLTR_ID]').val($twoJobInfo.MLTR_ID);
			$('#mFrm input[name=APPL_DV]').val($twoJobInfo.APPL_DV);
			$('#mFrm input[name=WORK_TYPE]').each(function(){
				if($(this).val() == $twoJobInfo.WORK_TYPE){
					$(this).prop('checked', true);
				}
			});
			$('#mFrm input[name=CONC_WORK]').val($twoJobInfo.CONC_WORK);
			$('#mFrm input[name=CONC_OFC]').val($twoJobInfo.CONC_OFC);
			$('#mFrm input[name=CONC_OFC_TEL_NO]').val($twoJobInfo.CONC_OFC_TEL_NO);
			$('#mFrm input[name=CONC_START_DT]').val($twoJobInfo.CONC_START_DT);
			$('#mFrm input[name=CONC_END_DT]').val($twoJobInfo.CONC_END_DT);
			$('#mFrm input[name=CONC_WORK_TIME]').val($twoJobInfo.CONC_WORK_TIME);
			$('#mFrm input[name=CONC_PRVONSH_CD]').each(function(){
				if($(this).val() == $twoJobInfo.CONC_PRVONSH_CD){
					$(this).prop('checked', true);
				}
			});
			$('#mFrm textarea[name=CONC_REASON]').val($twoJobInfo.CONC_REASON);
			$('#mFrm input[name=INCM_YN]').each(function(){
				if($(this).val() == $twoJobInfo.INCM_YN){
					$(this).prop('checked', true);
				}
			});
			
			//대상자 인적사항 정보세팅
			$('#mFrm input[name=MLTR_ID]').val($twoJobInfo.MLTR_ID);
			$('#mFrm input[name=APPL_NM]').val($twoJobInfo.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html($twoJobInfo.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html($twoJobInfo.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html($twoJobInfo.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html($twoJobInfo.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html($twoJobInfo.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html($twoJobInfo.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html($twoJobInfo.MEMORG_NM);
			
			//공단 접수내역 정보 세팅
			$('#kdFrm input[name=RECEIPT_DTM]').val($twoJobInfo.RECEIPT_DTM);
			$('#kdFrm textarea[name=RECEIPT_REASON]').val($twoJobInfo.RECEIPT_REASON);
			$('#kdConcStsNm').html($twoJobInfo.CONC_STS_NM);
			
			//문체부 접수내역 정보 세팅
			$('#mcFrm input[name=DSPTH_DTM]').val($twoJobInfo.DSPTH_DTM);
			$('#mcFrm textarea[name=DSPTH_REASON]').val($twoJobInfo.DSPTH_REASON);
			$('#mcFrm input[name=MLTR_ID]').val($twoJobInfo.MLTR_ID);
			$('#mcConcStsNm').html($twoJobInfo.CONC_STS_NM);
			
			$('#kdConfirmDiv').show();//공단 접수내역
			$('#mcConfirmDiv').show();//문체부 승인내역
			
			//첨부파일
			var fileHtmlStr = "";

			for(var i = 0; i < $twoJobFileList.length; i++){
				fileHtmlStr = "";
				fileHtmlStr += "<tr data-atch_tr_type=\"added\">";
				fileHtmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
				fileHtmlStr += "<a href=\"javascript:fnDownloadFile('" + $twoJobFileList[i].FILE_SN + "');\"><span class=\"file-name\">" + $twoJobFileList[i].FILE_ORGIN_NM + "</span></a>";
				
				if($('#mFrm input[name=CONC_STS]').val() == 'TP'){//임시저장일때만
					fileHtmlStr += "<button class=\"file-del\" onclick=\"fn_fileDel('"+ $twoJobFileList[i].FILE_SN + "', this);\"> 삭제</button>";
				}
				
				fileHtmlStr += "</td>";
				fileHtmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
				fileHtmlStr += "</td>";
				fileHtmlStr += "</tr>";
				
				$('tr[id=ATCH_FILE_ID_TR]').after(fileHtmlStr);
			}
			
			var mcFileStr = "";
			for(var k = 0; k < $twoJobMcFileList.length; k++){
				mcFileStr += "<td class=\"t-title\">첨부파일</td>";
				mcFileStr += "<td class=\"input-td\" colspan=\"3\"><a href=\"javascript:fnDownloadFile('" + $twoJobMcFileList[k].FILE_SN + "');\"><span class=\"file-name\">" + $twoJobMcFileList[k].FILE_ORGIN_NM + "</span></a></td>";
			}
			
			$('#mcConfirmFileTr').empty().append(mcFileStr);
		
			fn_setttingDivAndBtn($('#mFrm input[name=CONC_STS]').val());
			
			addPopOpen();
		}
		
	}
	
	//공단 담당자 승인,반려
	function fn_kdConfirm(CONC_STS){
		
		//if($('#kdFrm input[name=RECEIPT_DTM]').val() == ''){
		//	fnAlert("처리일자를 선택해주세요.");
		//	return false;
		//}
		
		if($('#kdFrm textarea[name=RECEIPT_REASON]').val() == ''){
			fnFocAlert("비고를 입력해주세요.", $('#kdFrm textarea[name=RECEIPT_REASON]'));
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(CONC_STS == 'KY'){
			confirmMsg = "접수처리 하시겠습니까?";
			resultMsg = "접수처리 되었습니다.";
		}else if(CONC_STS == 'KN'){
			confirmMsg = "접수반려 하시겠습니까?";
			resultMsg = "접수반려 되었습니다.";
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#kdFrm input[name=CONC_STS]').val(CONC_STS);
		$('#kdFrm input[name=CONC_SN]').val($('#mFrm input[name=CONC_SN]').val());
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/etc/twoJobKdConfirmJs.kspo", $("#kdFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				addPopClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("접수/반려 처리에 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	function fn_mcConfirm(CONC_STS){
		
		if($('#mcFrm textarea[name=DSPTH_REASON]').val() == ''){
			fnFocAlert("비고를 입력해주세요.", $('#mcFrm textarea[name=DSPTH_REASON]'));
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(CONC_STS == 'MY'){
			confirmMsg = "문체부승인 하시겠습니까?";
			resultMsg = "문체부 승인 되었습니다.";
		}else if(CONC_STS == 'MN'){
			confirmMsg = "문체부 미승인 하시겠습니까?";
			resultMsg = "문체부 미승인 되었습니다.";
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#mcFrm input[name=CONC_STS]').val(CONC_STS);
		$('#mcFrm input[name=CONC_SN]').val($('#mFrm input[name=CONC_SN]').val());
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/etc/twoJobMcConfirmJs.kspo", "mcFrm");
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				addPopClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("접수/반려 처리에 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	//변경신청시 화면에 변경 신청내용 화면 활성
	function activeChangeReqView(){
		
		if($('#mFrm input[name=CONC_STS]').val() != 'MY'){
			fnAlert("승인완료 상태만 가능합니다.");
			return false;
		}
		
		createAtchFileIdTr('CH');
		$('#changeReq').show();
		
		$('#changeReqFrm input[name=ORG_CONC_SN]').val($('#mFrm input[name=CONC_SN]').val());
		$('#changeReqFrm input[name=MLTR_ID]').val($('#mFrm input[name=MLTR_ID]').val());
		$('#changeReqFrm input[name=APPL_DV]').val("CH");//변경
		
		//저장, 신청 버튼 활성화
		$('#saveBtn').show();
		$('#applBtn').show();
	}
	
	function createMcConfirmFileObj(){
		
		var htmlStr = "<td class=\"t-title\">첨부파일</td>";
			htmlStr += "<td colspan=\"3\" class=\"input-td\">";
			htmlStr += "<div class=\"fileBox\">";
			htmlStr += "<input type=\"text\" class=\"fileName\" readonly=\"readonly\">";
			htmlStr += "<input type=\"file\" id=\"mcFile\" name=\"file\" class=\"file-table uploadBtn\">";
			htmlStr += "<label for=\"mcFile\" class=\"btn red rmvcrr file-btn\">파일선택</label>";
			htmlStr += "</div>";
			htmlStr += "</td>";
		
		$('#mcConfirmFileTr').empty().append(htmlStr);	
	}
	
	function fn_delete(){
		
		var CONC_STS = $('#mFrm input[name=CONC_STS]').val();
		
		if(CONC_STS != 'TP'){
			fnAlert("임시저장 상태만 삭제가능합니다.");
			return false;
		}
		
		if(!confirm("삭제하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/etc/deleteTwoJobJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				fnAlert("삭제되었습니다.");
				addPopClose();
				fn_search();
			} else {
				fnAlert("삭제에 실패하였습니다.");
			}
		}
		
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>겸직허가신청</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/etc/TwoJobSelect.kspo">
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
							<td class="t-title">등록일자</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker1" name="STD_YMD" type="text" class="datepick smal"  value="${STD_YMD}" autocomplete="off"> ~ 
										<input id="datepicker2" name="END_YMD" type="text" class="datepick smal" value="${END_YMD}" autocomplete="off">
									</li>
								</ul>
							</td>
							<td class="t-title">체육단체</td>
							<td>
								<select id="srchMemOrgSn" name="srchMemOrgSn" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne 2}">
									<option value="" <c:if test="${param.srchMemOrgSn eq '' or param.srchMemOrgSn eq null}">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach items="${memOrgSelect}" var="moLi">
										<option value="${moLi.MEMORG_SN}" <c:if test="${param.srchMemOrgSn eq moLi.MEMORG_SN}">selected="selected"</c:if>>${moLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach items="${gameNmList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">상태</td>
							<td>
								<select id="srchConcSts" name="srchConcSts" class="smal">
									<option value="" <c:if test="${param.srchConcSts eq '' or param.srchConcSts eq null}">selected="selected"</c:if>>전체</option>
									<c:forEach items="${concStsList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchConcSts eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">편입상태</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="soldierIncpSts6" type="radio" value="" name="srchProcSts"
											<c:if test="${param.srchProcSts eq '' or param.srchProcSts eq null}">checked="checked"</c:if>>
										<label for="soldierIncpSts6">전체</label>
									</li>
									<c:forEach var="subLi" items="${procStsList}" varStatus="sts">
										<c:if test="${subLi.ALT_CODE eq 'AG' || subLi.ALT_CODE eq 'MM' }">
											<li>
												<input id="soldierIncpSts${sts.index}" type="radio" value="${subLi.ALT_CODE}" name="srchProcSts" <c:if test="${param.srchProcSts eq subLi.ALT_CODE}">checked="checked"</c:if>>
												<label for="soldierIncpSts${sts.index}">
													<c:if test="${subLi.ALT_CODE eq 'AG'}">복무</c:if>
													<c:if test="${subLi.ALT_CODE eq 'MM'}">만료</c:if>
												</label>
											</li>
										</c:if>
									</c:forEach>
								</ul>
							</td>
							<td class="t-title">키워드</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<select id="keykind" name="keykind" class="smal">
											<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
											<option value="NAME" <c:if test="${param.keykind eq 'NAME'}">selected="selected"</c:if>>이름</option>
										</select>
										<input type="text" name="keyword" class="smal" placeholder="" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
									</li>
									<li>
									</li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="com-btn-group center">
				<button class="btn red write" type="button" onclick="fn_search();return false;">검색</button>
			</div>
		<!-- //검색영역 -->
		
		<div class="com-result">
			<div class="float-l">
				<span class="total-num">조회결과 <b>${pageInfo.totalRecordCount}</b>건</span>
			</div>
			<div class="float-r">
				<select id="srchPageCnt" name="recordCountPerPage" style="height: 42px; width:130px; padding-left: 20px;">
					<c:forEach items="${viewList}" var="subLi">
						<option value="${subLi.ALT_CODE}" <c:if test="${param.recordCountPerPage eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
					</c:forEach>
				</select>&nbsp;&nbsp;
				<c:if test="${sessionScope.userMap.GRP_SN eq 2}"><!--가맹단체 -->
					<button class="btn red type01" type="button" onclick="javascript:addPopOpen('NEW');">신규</button>
				</c:if>
				<button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col style="width:50px;">
					<col style="width:115px;">
					<col style="width:115px;">
					<col style="width:80px;">
					<col style="width:6%">
					<col style="width:90px;">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:auto">
					<col style="width:8%">
					<col style="width:220px;">
					<col style="width:13%">
					<col style="width:90px;">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>신청번호</th>
						<th>원 신청번호</th>
						<th>처리상태</th>
						<th>이름</th>
						<th>생년월일</th>
						<th>체육단체</th>
						<th>편입상태</th>
						<th>신청구분</th>
						<th>겸직근무처</th>
						<th>담당직무</th>
						<th>근무기간</th>
						<th>등록일자</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty twoJobList}">
							<c:forEach items="${twoJobList}" var="list" varStatus="state">
								 <tr>
									<td>${list.RNUM}</td>
									<td>${list.CONC_SN}</td>
									<td>${list.ORG_CONC_SN}</td>
									<td>${list.CONC_STS_NM}</td>
									<td><a href="javascript:fn_detail('${list.CONC_SN}');" class="tit">${list.APPL_NM}</a></td>
									<td>
										<fmt:parseDate var="BRTH_DT" value="${list.BRTH_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${BRTH_DT}" pattern="yyyy-MM-dd"/>
									</td>
									<td>${list.MEMORG_NM}</td>
									<td>
										<c:choose>
											<c:when test="${list.PROC_STS eq 'AG'}">
												복무
											</c:when>
											<c:when test="${list.PROC_STS eq 'MM'}">
												만료
											</c:when>
										</c:choose>
									</td>
									<td>${list.APPL_DV_NM}</td>
									<td>${list.CONC_OFC}</td>
									<td>${list.CONC_PRVONSH_NM}</td>
									<td>${list.CONC_START_DT} ~ ${list.CONC_END_DT}</td>
									<td>${list.REG_DTM}</td>
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
		</div>
		
		<div class="com-paging">
			<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:frm" />
		</div>
	</div>
</div>

<!-- 팝업영역 -->
<div class="cpt-popup reg03" id="twoJobPopDiv"> <!-- class:active 팝업 on/off -->
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			겸직허가신청
			<button class="pop-close" onclick="addPopClose(); return false;">
				<img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
			</button>
		</div>
		<div class="pop-body">
			<form id="mFrm" name="mFrm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="CONC_SN">
			<input type="hidden" name="ORG_CONC_SN">
			<input type="hidden" name="ATCH_FILE_ID">
			<input type="hidden" name="ATCH_FILE_ID2">
			<input type="hidden" name="CONC_STS">
			<input type="hidden" name="MLTR_ID">
			<input type="hidden" name="APPL_DV">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
				<div class="process-status">처리상태 : <b class="t-blue" id="concStsTxtDiv">신규작성</b></div>
				<div class="com-h3 add">대상자 인적사항
					<div class="right-area"><p class="required">필수입력</p></div>
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
							<tr>
								<td class="t-title">복무부서</td>
								<td class="input-td"></td>
								<td class="t-title">복무분야</td>
								<td class="input-td"></td>
							</tr>
						</tbody>
					</table>
				</div>
	
				<div class="com-h3 add">겸직허가 신청내용
					<div class="right-area">
						<p class="required">필수입력</p>
						<button class="btn red rmvcrr" type="button" id="changeReqBtn" onclick="activeChangeReqView();">변경신청</button>
						<button class="btn red rmvcrr" type="button" id="cancelBtn">신청취소</button>
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
								<td class="t-title">근무형태</td>
								<td class="input-td">
									<ul class="com-radio-list">
										<c:forEach var="subLi" items="${concOfcList}" varStatus="sts">
											<li>
												<c:set var="WORK_TYPE_R_ID" value="WORK_TYPE_R_${sts.index}"/>
												<input id="${WORK_TYPE_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="WORK_TYPE">
												<label for="${WORK_TYPE_R_ID}">${subLi.CNTNT_FST}</label>
											</li>
										</c:forEach>
										
									</ul>
								</td>
								<td class="t-title">담당직무</td>
								<td class="input-td"><input type="text" name="CONC_WORK" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">겸직근무처</td>
								<td class="input-td"><input type="text" class="ip-title" name="CONC_OFC"></td>
								<td class="t-title">전화번호<span class="t-red"> *</span></td>
								<td class="input-td">
									<input type="text" title="휴대전화 입력" name="CONC_OFC_TEL_NO" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
								</td>
							</tr>
							<tr>
								<td class="t-title">근무기간</td>
								<td class="input-td">
									<ul class="com-radio-list">
										<li>
											<input id="datepicker3" maxlength="8" type="text" class="datepick smal" name="CONC_START_DT" readonly="readonly" autocomplete="off"> ~ <input id="datepicker4" type="text" maxlength="8" class="datepick smal" name="CONC_END_DT" readonly="readonly" autocomplete="off">
										</li>
									</ul>
								</td>
								<td class="t-title">근무시간<span class="t-red"> *</span></td>
								<td class="input-td"><input type="text" name="CONC_WORK_TIME" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">겸직사유</td>
								<td class="input-td">
									<ul class="com-radio-list">
										<c:forEach var="subLi" items="${concPrvonshList}" varStatus="sts">
											<c:set var="CONS_PRVONSH_R_ID" value="CONS_PRVONSH_R_${sts.index}"/>
											<li>
												<input id="${CONS_PRVONSH_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="CONC_PRVONSH_CD">
												<label for="${CONS_PRVONSH_R_ID}">${subLi.CNTNT_FST}</label>
											</li>
										</c:forEach>
									</ul>
								</td>
								<td class="t-title">겸직내용</td>
								<td class="input-td">
									<textarea rows="5" name="CONC_REASON"></textarea><br />
									<span class="t-red"> ※ 6하 원칙에 따라 구체적으로 작성하세요. - 누가, 언제, 어디서, 무엇을, 어떻게 등</span>
								</td>
							</tr>
							
							<tr>
								<td class="t-title">수입발생여부</td>
								<td class="input-td">
									<ul class="com-radio-list">
										<c:forEach var="subLi" items="${incmYnList}" varStatus="sts">
											<c:set var="INCM_YN_R_ID" value="INCM_YN_R_${sts.index}" />
											<li>
												<input id="${INCM_YN_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="INCM_YN">
												<label for="${INCM_YN_R_ID}">${subLi.CNTNT_FST}</label>
											</li>
											</c:forEach>
									</ul>
								</td>
								<td class="t-title"></td>
								<td class="input-td"></td>
							</tr>
							<tr id="ATCH_FILE_ID_TR">
								<td class="t-title" colspan="4">
								<div class="float-l">
	                       			첨부파일<span class="t-red"> ※ 첨부파일 필요항목 : 겸직허가(취소,변경)신청서를 첨부합니다.</span>
	                       			</div>
	                       			<div class="float-r">
	                       			<button class="btn red rmvcrr userDv2" type="button" onclick="window.open('${pageContext.request.contextPath}/common/docs/겸직제출서류.zip')">서류 다운로드</button>
	                       			</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</form>			
				
				<div id="changeReq">
					<form id="changeReqFrm" name="chagneReqFrm" method="post" enctype="multipart/form-data">
					<input type="hidden" name="CONC_SN">
					<input type="hidden" name="ORG_CONC_SN">
					<input type="hidden" name="ATCH_FILE_ID">
					<input type="hidden" name="ATCH_FILE_ID2">
					<input type="hidden" name="CONC_STS">
					<input type="hidden" name="MLTR_ID">
					<input type="hidden" name="APPL_DV">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
						<div class="com-h3 add">겸직허가 변경 신청내용	
							<div class="right-area">
								<p class="required">필수입력</p>
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
										<td class="t-title">근무형태</td>
										<td class="input-td">
											<ul class="com-radio-list">
												<c:forEach var="subLi" items="${concOfcList}" varStatus="sts">
													<li>
														<c:set var="CHANGE_WORK_TYPE_R_ID" value="CHANGE_WORK_TYPE_R_${sts.index}"/>
														<input id="${CHANGE_WORK_TYPE_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="WORK_TYPE">
														<label for="${CHANGE_WORK_TYPE_R_ID}">${subLi.CNTNT_FST}</label>
													</li>
												</c:forEach>
												
											</ul>
										</td>
										<td class="t-title">담당직무</td>
										<td class="input-td"><input type="text" name="CONC_WORK" class="ip-title"></td>
									</tr>
									<tr>
										<td class="t-title">겸직근무처</td>
										<td class="input-td"><input type="text" class="ip-title" name="CONC_OFC"></td>
										<td class="t-title">전화번호</td>
										<td class="input-td">
											<input type="text" title="휴대전화 입력" name="CONC_OFC_TEL_NO">
										</td>
									</tr>
									<tr>
										<td class="t-title">근무기간</td>
										<td class="input-td">
											<ul class="com-radio-list">
												<li>
													<input id="datepicker5" maxlength="8" type="text" class="datepick smal" name="CONC_START_DT" autocomplete="off"> ~ <input id="datepicker6" type="text" maxlength="8" class="datepick smal" name="CONC_END_DT" autocomplete="off">
												</li>
											</ul>
										</td>
										<td class="t-title">근무시간<span class="t-red"> *</span></td>
										<td class="input-td"><input type="text" name="CONC_WORK_TIME" class="ip-title"></td>
									</tr>
									<tr>
										<td class="t-title">겸직사유</td>
										<td class="input-td">
											<ul class="com-radio-list">
												<c:forEach var="subLi" items="${concPrvonshList}" varStatus="sts">
													<c:set var="CHANGE_CONS_PRVONSH_R_ID" value="CHANGE_CONS_PRVONSH_R_${sts.index}"/>
													<li>
														<input id="${CHANGE_CONS_PRVONSH_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="CONC_PRVONSH_CD">
														<label for="${CHANGE_CONS_PRVONSH_R_ID}">${subLi.CNTNT_FST}</label>
													</li>
												</c:forEach>
											</ul>
										</td>
										<td class="t-title">겸직내용</td>
										<td class="input-td">
											<textarea rows="5" name="CONC_REASON"></textarea><br />
											<span class="t-red"> ※ 6하 원칙에 따라 구체적으로 작성하세요. - 누가, 언제, 어디서, 무엇을, 어떻게 등</span>
										</td>
									</tr>
									
									<tr>
										<td class="t-title">수입발생여부</td>
										<td class="input-td">
											<ul class="com-radio-list">
												<c:forEach var="subLi" items="${incmYnList}" varStatus="sts">
													<c:set var="CHANGE_INCM_YN_R_ID" value="CHANGE_INCM_YN_R_${sts.index}" />
													<li>
														<input id="${CHANGE_INCM_YN_R_ID}" type="radio" value="${subLi.ALT_CODE}" name="INCM_YN">
														<label for="${CHANGE_INCM_YN_R_ID}">${subLi.CNTNT_FST}</label>
													</li>
													</c:forEach>
											</ul>
										</td>
										<td class="t-title"></td>
										<td class="input-td"></td>
									</tr>
									<tr id="CHANGE_ATCH_FILE_ID_TR">
										<td class="t-title" colspan="4">첨부파일<span class="t-red">※ 첨부파일 필요항목 : 체육요원 추천서, 재직증명서, 입상확인서, 군복무확인서(해당자만) 등을 첨부합니다.</span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</form>
				</div>
	
				<div id="kdConfirmDiv">
					<form id="kdFrm" method="post">
					<input type="hidden" name="CONC_SN">
					<input type="hidden" name="CONC_STS">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
						<div class="com-h3 add">공단 접수내역
							<div class="rightArea">
								<button class="btn red type01" type="button" onclick="fn_kdConfirm('KY');" id="kdKYBtn">접수처리</button>
								<button class="btn red type01" type="button" onclick="fn_kdConfirm('KN');" id="kdKNBtn">접수반려</button>
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
										<td class="t-title">처리일자</td>
										<td class="input-td"><input type="text" name="RECEIPT_DTM" readonly="readonly" style="border: none;" autocomplete="off" class="datepick"></td>
										<td class="t-title">처리결과</td>
										<td id="kdConcStsNm"></td>
									</tr>
									<tr>
										<td class="t-title">비고<span class="t-red"> *</span></td>
										<td colspan="3" class="input-td"><textarea rows="5" name="RECEIPT_REASON"></textarea></td>
									</tr>
								</tbody>
							</table>
						</div>
					</form>
				</div>
				
				<div id="mcConfirmDiv">
					<form id="mcFrm" method="post" enctype="multipart/form-data">
					<input type="hidden" name="CONC_SN">
					<input type="hidden" name="CONC_STS">
					<input type="hidden" name="MLTR_ID">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
						<div class="com-h3 add">문체부 승인내역
							<div class="right-area">
								<p class="required">필수입력</p>
								<button class="btn red type01" type="button" onclick="fn_mcConfirm('MY');" id="mcMYBtn">문체부 승인</button>
								<button class="btn red type01" type="button" onclick="fn_mcConfirm('MN');" id="mcMNBtn">문체부 미승인</button>
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
										<td class="t-title">승인일자</td>
										<td class="input-td"><input type="text" name="DSPTH_DTM" readonly="readonly" class="datepick" autocomplete="off"></td>
										<td class="t-title">처리결과</td>
										<td id="mcConcStsNm"></td>
									</tr>
									<tr>
										<td class="t-title">승인내역<span class="t-red"> *</span></td>
										<td colspan="3" class="input-td"><textarea rows="5" name="DSPTH_REASON"></textarea></td>
									</tr>
									<tr id="mcConfirmFileTr"></tr>
								</tbody>
							</table>
						</div>
					</form>
				</div>
							
				<div class="com-btn-group put">
					<div class="float-r">
						<button class="btn navy rmvcrr" type="button" onclick="fn_save('TP');" id="saveBtn">임시저장</button>
						<button class="btn red rmvcrr" type="button" onclick="fn_save('TA');" id="applBtn">신청</button>
						<button class="btn navy rmvcrr" type="button" onclick="fn_delete();" id="delBtn">삭제</button>
						<button class="btn grey rmvcrr" type="button" onclick="addPopClose();">닫기</button>
					</div>
				</div>
		</div>
	</div>
</div>


<!-- //팝업영역 -->

<!-- 팝업영역 --><!-- 체육요원 검색 -->
<div class="cpt-popup" id="searchPersonPopDiv"><!-- class:active 팝업 on/off -->
	<form id="searchPersonFrm" onsubmit="return false;">
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
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
										<c:forEach var="subLi" items="${gameNmList}">
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
					<button class="btn red write" type="button" onclick="fn_popPersonSearch();return false;">검색</button>
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
					<button class="btn grey write" type="button" onclick="fn_searchPersonPopupClose();return false;">취소</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPerson();return false;">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->