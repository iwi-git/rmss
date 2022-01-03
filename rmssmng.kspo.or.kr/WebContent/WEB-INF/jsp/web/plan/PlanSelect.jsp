<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#datepicker1, #datepicker2, #datepicker3, #datepicker4, #datepicker5, #datepicker6").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
		if($("#searchFrm input[name=srchVlunApplDtmStart]").val()!= "" && $("#searchFrm input[name=srchVlunApplDtmEnd]").val() != ""){
			$("#datepicker").datepicker('option','maxDate',$("#searchFrm input[name=srchVlunApplDtmEnd]").val());
			$("#datepicker1").datepicker('option','minDate',$("#searchFrm input[name=srchVlunApplDtmStart]").val());
		}
		
		if($("#searchFrm input[name=srchVlunActDateStart]").val()!= "" && $("#searchFrm input[name=srchVlunActDateEnd]").val() != ""){
			$("#datepicker").datepicker('option','maxDate',$("#searchFrm input[name=srchVlunActDateEnd]").val());
			$("#datepicker1").datepicker('option','minDate',$("#searchFrm input[name=srchVlunActDateStart]").val());
		}
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker2").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker2",function(){
			$("#datepicker1").datepicker('option','maxDate',$(this).val());
		});
		
		$(document).on("change","#datepicker3",function(){
			$("#datepicker4").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker4",function(){
			$("#datepicker3").datepicker('option','maxDate',$(this).val());
		});
 		
 		$(document).on("input", "input[name=ACT_TIME_HR]", function(){
 			$(this).val($(this).val().replace(/[^0-9]/g, ''));
 		});
 		
 		$('#mFrm input[name=ACT_TIME_HR]').val("12");
		
 		fn_hideDivBtn();
	});
	
	function fn_hideDivBtn(){
		$('#lastUpdateDiv').hide();
		$('#kdConfirmDiv').hide();
		
		$('button[id=saveBtn]').hide();
		$('button[id=applBtn]').hide();
		$('button[id=chnReqBtn]').hide();
		$('button[id=delBtn]').hide();
		$('button[id=reportPlanBtn]').hide();
		$('button[id=reportChnPlanBtn]').hide();
		
		$('button[id=kdKYBtn]').hide();//공단접수
		$('button[id=kdKNBtn]').hide();//공단반려
		
		$('button[id=personSrhBtn]').hide();
		$('button[id=placeSrhBtn]').hide();
		
		fn_setform('mFrm', true);
		fn_setform('kdFrm', true);
	}
	
	function fn_setform(formId, readonlyFlag){
		$('#' + formId + ' input').prop('readonly', readonlyFlag);
		$('#' + formId + ' textarea').prop('disabled', readonlyFlag);
		$('#' + formId + ' select').prop('disabled', readonlyFlag);
		
		$('input[name=APPL_NM]').prop('readonly', true);
		
		$('input[name=VLUN_ACT_START]').prop('readonly', true);
		$('input[name=VLUN_ACT_END]').prop('readonly', true);
		$('input[name=RECEIPT_DTM]').prop('readonly', true);
		
		$('input[name=VLUN_PLC_NA]').prop('readonly', true);
		$('input[name=VLUN_PLC_NM]').prop('readonly', true);
		$('input[name=PLC_MNGR_NM]').prop('readonly', true);
		$('input[name=PLC_MNGR_TEL_NO]').prop('readonly', true);
		$('input[name=PLC_MNGR_CP_NO]').prop('readonly', true);
		$('input[name=VLUN_PLC_ADDRESS]').prop('readonly', true);
		
	}
	
	function fn_setttingDivAndBtn(type){
		fn_hideDivBtn();
		
		var grpSn = "${sessionScope.userMap.GRP_SN}";
		//1	공단사용자
		//2	일반사용자
		//3	문체부사용자
		//4	시스템관리자
		
		if(grpSn == "1"){//공단사용자 일경우
			if($('#mFrm input[name=VLUN_PLAN_SN]').val().length > 0){
				$('button[id=reportPlanBtn]').show();//봉사활동계획서 리포트
				
				if(	$('#mFrm input[NAME=ORG_VLUN_PLAN_SN]').val() != '' &&
						$('#mFrm input[NAME=ORG_VLUN_PLAN_SN]').val() != $('#mFrm input[name=VLUN_PLAN_SN]').val()){
					$('button[id=reportChnPlanBtn]').show();//봉사활동변경계획서 리포트	
				}
			}	
		}
		
		if(type == 'TP'){//임시저장
			
			$('#lastUpdateDiv').show();
			fn_setform('mFrm', false);
			$('button[id=personSrhBtn]').show();
			$('button[id=placeSrhBtn]').show();
			
			if(grpSn == '2'){
				$('button[id=saveBtn]').show();//임시저장
				$('button[id=applBtn]').show();//신청
				if($('#mFrm input[name=VLUN_PLAN_SN]').val().length > 0){
					$('button[id=delBtn]').show();//삭제	
				}
			}
			
		} else if(type == 'AP'){//신청
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//공단 접수내역
			
			if(grpSn == '1'){
				$('button[id=kdKYBtn]').show();//공단접수
				$('button[id=kdKNBtn]').show();//공단반려
				fn_setform('kdFrm', false);
			} else if(grpSn == '2'){
				$('button[id=chnReqBtn]').show();
			}
			
		} else if(type == 'KY'){//공단접수
			
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//공단 접수내역
			
		} else if(type == 'KN'){//공단반려
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//공단 접수내역
			
		}
	}
	
	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		
		fnPageLoad("/plan/PlanSelect.kspo",$("#searchFrm").serialize());
	}
	
	//계획 작성 팝업 활성
	function fn_planAddPopupOpen(type){
		
		if(type == 'NEW'){//신규버튼 클릭시
			fn_setttingDivAndBtn('TP');
		}
		
		$('#planAddPopDiv').addClass('active');
	}
	
	//계획 작성 팝업 닫기
	function fn_planAddPopupClose(){
		
		//대상자 인적사항 초기화
		$('#planStsTxtDiv').html('신규작성');
		$('#mFrm input[name=MLTR_ID]').val('');
		$('#mFrm input[name=APPL_SN]').val('');
		$('#mFrm input[name=APPL_NM]').val('');
		$('#mFrm td[id=TD_APPL_SN]').html('');
		$('#mFrm td[id=TD_BRTH_DT]').html('');
		$('#mFrm td[id=TD_ADDR]').html('');
		$('#mFrm td[id=TD_EMAIL]').html('');
		$('#mFrm td[id=TD_CP_NO]').html('');
		$('#mFrm td[id=TD_GAME_CD_NM]').html('');
		$('#mFrm td[id=TD_MEM_ORG_NM]').html('');
		
		//공익복무 대상 기관 초기화
		$('#mFrm input[name=VLUN_PLC_SN]').val('');
		$('#mFrm input[name=VLUN_PLC_DV_TYPE]').prop('checked', false);
		$('#mFrm input[name=VLUN_PLC_NA]').val('');
		$('#mFrm input[name=VLUN_PLC_NM]').val('');
		$('#mFrm input[name=PLC_MNGR_NM]').val('');
		$('#mFrm input[name=PLC_MNGR_TEL_NO]').val('');
		$('#mFrm input[name=PLC_MNGR_CP_NO]').val('');
		$('#mFrm input[name=VLUN_PLC_ADDRESS]').val('');
		
		//계획 정보 초기화
		$('#mFrm input[name=PLAN_STS]').val('');
		$('#mFrm input[name=VLUN_PLAN_SN]').val('');
		$('#mFrm select[name=ACT_FIELD]').val('A01');
		$('#mFrm input[name=VLUN_ACT_START]').val('');
		$('#mFrm input[name=VLUN_ACT_END]').val('');
		$('#mFrm input[name=ACT_PLACE]').val('');
		$('#mFrm input[name=ACT_TIME_HR]').val('12');
		$('#mFrm select[name=ACT_TIME_MN]').val('00');
		$('#mFrm select[name=VLUN_TGT]').val('VC');
		$('#mFrm textarea[name=MAIN_CONTENTS]').val('');
		$('#mFrm input[name=ORG_VLUN_PLAN_SN]').val('');
		
		//공단 접수내역 초기화
		$('#kdFrm input[name=VLUN_PLAN_SN]').val('');
		$('#kdFrm input[name=PLAN_STS]').val('');
		$('#kdFrm input[name=MLTR_ID]').val('');
		$('#kdFrm input[name=RECEIPT_DTM]').val('');
		$('#kdFrm textarea[name=RECEIPT_REASON]').val('');
		$('#planStsTxtKdTd').html('');
		
		//수정이력 초기화
		$('#lastUpdateLi').html('');
		
		fn_hideDivBtn();
		
		$('#planAddPopDiv').removeClass('active');
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
	
	//대상 기관 팝업 활성
	function fn_searchPlacePopupOpen(){
		$('#searchPlacePopDiv').addClass('active');
	}
	
	//대상 기관 팝업 비활성
	function fn_searchPlacePopupClose(){
		
		$('#searchPlaceFrm select[name=pSrchKeyKind]').val('');//키워드 종류 초기화
		$('#searchPlaceFrm input[name=pSrchKeyword]').val('');//키워드 입력란 초기화
		$('#searchPlaceFrm tbody[id=placeTbody]').empty();//검색결과 초기화
		$('#searchPlaceCnt').html('0');//조회결과 카운트 초기화
		$('#placePagingDiv').empty();//페이징 초기화
		$('#searchPlacePopDiv').removeClass('active');
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
			
			$('#mFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
			$('#mFrm input[name=APPL_SN]').val(personInfo.APPL_SN);
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
	
	//대상기관 검색
	function fn_popPlaceSearch(pageNo){
		
		var pSrchKeyKind = $('#searchPlaceFrm select[name=pSrchKeyKind]').val();
		var pSrchKeyword = $('#searchPlaceFrm input[name=pSrchKeyword]').val();
		
		var	param = "&pSrchKeyKind=" + pSrchKeyKind;
			param += "&pSrchKeyword=" + pSrchKeyword;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		
		if(typeof(pageNo) != "undefined"){
			param+= "&pageNo=" + pageNo;	
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPlaceListJs.kspo", param);
		
		if($json.statusText != "OK"){
			fnAlert("오류가 발생하였습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var placeList = $json.responseJSON.placeList;
		
		var htmlStr = "";
		
		if(placeList.length < 1){
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"6\" class=\"center\">일치하는 대상기관이 없습니다.</td>";
			htmlStr += "<tr>";
		}
		
		for(var i = 0; i < placeList.length; i++){
			var vlunPlcSn = placeList[i].VLUN_PLC_SN;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"checkPlaceGrp\" id=\"checkPlace" + i + "\" value=\"" + vlunPlcSn + "\">";
			htmlStr += "<label for=\"checkPlace" + i + "\" class=\"chk-only\">선택</label>";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td>" + placeList[i].VLUN_PLC_DV_TXT + "</td>";
			htmlStr += "<td>" + placeList[i].VLUN_PLC_NA + "</td>";
			htmlStr += "<td>" + placeList[i].VLUN_PLC_SCD + "</td>";
			htmlStr += "<td>" + placeList[i].VLUN_PLC_NM + "</td>";
			htmlStr += "<td>" + placeList[i].VLUN_PLC_ADDRESS + "</td>";
			htmlStr += "</tr>";
		}
		
		$('#placeTbody').empty().append(htmlStr);
		
		var pageInfo = $json.responseJSON.pageInfo;
		
		if(placeList.length > 0){
			$('#searchPlaceCnt').html(placeList[0].TOTAL_RECORD_COUNT);
		}
		
		$('#placePagingDiv').empty().append(pageInfo);
		
	}
	
	function fn_confirmPlace(){
		
		var checkCnt = $('#searchPlaceFrm input[name=checkPlaceGrp]:checked').length;
		
		if(checkCnt < 1){
			fnAlert("대상기관을 선택해주세요.");
			return false;
		}
		
		if(checkCnt > 1){
			fnAlert("한개의 대상기관을 선택해주세요.");
			return false;
		}
		
		var vlunPlcSn = $('#searchPlaceFrm input[name=checkPlaceGrp]:checked').val();
		
		if(vlunPlcSn == ''){
			fnAlert("선택된 대상기관의 정보가 올바르지 않습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var param = "VLUN_PLC_SN=" + vlunPlcSn;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
			
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPlaceJs.kspo", param);
		
		if($json.statusText != "OK"){
			fnAlert("오류가 발생하였습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var placeInfo = $json.responseJSON.placeInfo;
		var htmlStr = "";
		
		if(placeInfo == null){
			fnAlert("오류가 발생하였습니다.");
			return false;
		}
		
		$('#mFrm input[name=VLUN_PLC_SN]').val(placeInfo.VLUN_PLC_SN);//수행기관 순번
		
		var vlunPlcDvType = placeInfo.VLUN_PLC_DV_TYPE;//국내,국외구분
		
		$('#mFrm input[name=VLUN_PLC_DV_TYPE]').each(function(){
			if($(this).val() == vlunPlcDvType){
				$(this).prop('checked', true);
			}
		});
		
		$('#mFrm input[name=VLUN_PLC_NA]').val(placeInfo.VLUN_PLC_NA);//국가
		$('#mFrm input[name=VLUN_PLC_NM]').val(placeInfo.VLUN_PLC_NM);//대상기관명
		$('#mFrm input[name=PLC_MNGR_NM]').val(placeInfo.PLC_MNGR_NM);//담당자명
		$('#mFrm input[name=PLC_MNGR_TEL_NO]').val(placeInfo.PLC_MNGR_TEL_NO);//담당자 연락처1
		$('#mFrm input[name=PLC_MNGR_CP_NO]').val(placeInfo.PLC_MNGR_CP_NO);//담당자 연락처2
		$('#mFrm input[name=VLUN_PLC_ADDRESS]').val(placeInfo.VLUN_PLC_ADDRESS);//봉사장소 주소
		
		fn_searchPlacePopupClose();	
	}
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
	}
	
	function searchPlaceFrm(pageNo){
		fn_popPlaceSearch(pageNo);
	}
	
	function fn_planChangeReq(){
		
		if(!confirm("계획변경신청을 진행하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/planChagneReqJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {	
				fn_planAddPopupClose();
				fnAlert("계획변경신청이 되었습니다.");
				fn_search();
			} else {
				fnAlert("계획변경신청이 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	function fn_save(PLAN_STS){
		
		if(!fn_validate(PLAN_STS)){
			return false;
		}	
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(PLAN_STS == 'TP'){
			confirmMsg = "임시저장 하시겠습니까?";
			resultMsg = "임시저장 되었습니다.";
		}else if(PLAN_STS == 'AP'){
			confirmMsg = "신청하시겠습니까?";
			resultMsg = "신청되었습니다.";
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#mFrm input[name=PLAN_STS]').val(PLAN_STS);
		
		var ACT_TIME_HR = $('#mFrm input[name=ACT_TIME_HR]').val(); 
		
		if(ACT_TIME_HR.length == '1'){
			$('#mFrm input[name=ACT_TIME_HR]').val('0' + ACT_TIME_HR);
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/savePlanJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
				
			if(resultCnt > 0) {	
				fn_planAddPopupClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("저장에 실페하였습니다.");
				fn_search();
			}
		}
	}
	
	function fn_validate(PLAN_STS){
		
		if(PLAN_STS == 'TP'|| PLAN_STS == 'AP'){//임시저장, 신청
			
			//체육요원 정보 선택 검증
			if($('#mFrm input[name=MLTR_ID]').val() == ''){
				fnAlert("체육요원 정보를 선택해주세요.");
				return false;
			}
		
			//대상기관 정보 선택 검증
			if($('#mFrm input[name=VLUN_PLC_SN]').val() == ''){
				fnAlert("대상기관 정보를 선택해주세요.");
				return false;
			}
			
			//활동분야 벨리데이션
			if($('#mFrm select[name=ACT_FIELD]').val() == ''){
				fnFocAlert("활동분야를 선택해주세요.", $('#mFrm select[name=ACT_FIELD]'));
				return false;
			}
			
			//활동기간 시작 벨리데이션
			if($('#mFrm input[name=VLUN_ACT_START]').val() == ''){
				fnFocAlert("활동기간 시작 일자를 선택해주세요.", $('#mFrm input[name=VLUN_ACT_START]'));
				return false;
			}
			
			//활동기간 종료 벨리데이션
			if($('#mFrm input[name=VLUN_ACT_END]').val() == ''){
				fnFocAlert("활동기간 종료 일자를 선택해주세요.", $('#mFrm input[name=VLUN_ACT_END]'));
				return false;
			}
			
			if($('#mFrm input[name=VLUN_ACT_START]').val() > $('#mFrm input[name=VLUN_ACT_END]').val()){
				fnAlert("활동기간 시작일이 종료일 이후 일 수 없습니다.");
				return false;
			}
			
			if($('#mFrm input[name=ACT_TIME_HR]').val() == ''){
				fnFocAlert("활동시간은 필수입니다.", $('#mFrm input[name=ACT_TIME_HR]'));
				return false;
			}
			
			if($('#mFrm select[name=ACT_TIME_MN]').val() == ''){
				fnFocAlert("활동시간은 필수입니다.", $('#mFrm select[name=ACT_TIME_MN]'));
				return false;
			}
			
			if($('#mFrm select[name=VLUN_TGT]').val() == ''){
				fnFocAlert("수혜대상을 선택해주세요.", $('#mFrm select[name=VLUN_TGT]'));
				return false;
			}
			
			if($('#mFrm input[name=ACT_PLACE]').val() == ''){
				fnFocAlert("활동장소를 입력해주세요.", $('#mFrm input[name=ACT_PLACE]'));
				return false;
			}
			
			//if($('#mFrm textarea[name=MAIN_CONTENTS]').val() == ''){
			//	fnFocAlert("비고를 입력해주세요.", $('#mFrm textarea[name=MAIN_CONTENTS]'));
			//	return false;
			//}
			
		}
		
		return true;
	}
	
	function fn_detail(VLUN_PLAN_SN){
		
		if(typeof(VLUN_PLAN_SN) == 'undefined'){
			fnAlert("상세보기중 오류가 발생하였습니다.");
			return false;
		}
		
		var param = "VLUN_PLAN_SN=" + VLUN_PLAN_SN;
			param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPlanDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var $plan = $json.responseJSON.plan;
			
			if($plan == null){
				fnAlert("상세보기기 오류가 발생하였습니다.");
				return false;
			}
			
			
			//체육요원 정보 세팅
			$('#mFrm input[name=APPL_SN]').val($plan.APPL_SN);
			$('#mFrm input[name=APPL_NM]').val($plan.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html($plan.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html($plan.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html($plan.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html($plan.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html($plan.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html($plan.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html($plan.MEM_ORG_NM);
			
			//대상기관 정보 세팅
			$('#mFrm input[name=VLUN_PLC_SN]').val($plan.VLUN_PLC_SN);//수행기관 순번
			
			var vlunPlcDvType = $plan.VLUN_PLC_DV_TYPE;//국내,국외구분
			
			$('#mFrm input[name=VLUN_PLC_DV_TYPE]').each(function(){
				if($(this).val() == vlunPlcDvType){
					$(this).prop('checked', true);
				}
			});
			
			$('#mFrm input[name=VLUN_PLC_NA]').val($plan.VLUN_PLC_NA);//국가
			$('#mFrm input[name=VLUN_PLC_NM]').val($plan.VLUN_PLC_NM);//대상기관명
			$('#mFrm input[name=PLC_MNGR_NM]').val($plan.PLC_MNGR_NM);//담당자명
			$('#mFrm input[name=PLC_MNGR_TEL_NO]').val($plan.PLC_MNGR_TEL_NO);//담당자 연락처1
			$('#mFrm input[name=PLC_MNGR_CP_NO]').val($plan.PLC_MNGR_CP_NO);//담당자 연락처2
			$('#mFrm input[name=VLUN_PLC_ADDRESS]').val($plan.VLUN_PLC_ADDRESS);//봉사장소 주소
			
			
			//계획 정보 세팅
			$('#planStsTxtDiv').html($plan.PLAN_STS_TXT);
			$('#mFrm input[name=PLAN_STS]').val($plan.PLAN_STS);
			$('#mFrm input[name=MLTR_ID]').val($plan.MLTR_ID);
			$('#mFrm input[name=VLUN_PLAN_SN]').val($plan.VLUN_PLAN_SN);
			$('#mFrm select[name=ACT_FIELD]').val($plan.ACT_FIELD);
			$('#mFrm input[name=VLUN_ACT_START]').val($plan.VLUN_ACT_START);
			$('#mFrm input[name=VLUN_ACT_END]').val($plan.VLUN_ACT_END);
			$('#mFrm input[name=ACT_PLACE]').val($plan.ACT_PLACE);
			$('#mFrm select[name=VLUN_TGT]').val($plan.VLUN_TGT);
			$('#mFrm input[name=ACT_TIME_HR]').val($plan.ACT_TIME_HR);
			$('#mFrm select[name=ACT_TIME_MN]').val($plan.ACT_TIME_MN);
			$('#mFrm textarea[name=MAIN_CONTENTS]').val($plan.MAIN_CONTENTS);
			$('#mFrm input[name=ORG_VLUN_PLAN_SN]').val($plan.ORG_VLUN_PLAN_SN);
			
			//공단 접수내역 세팅
			$('#kdFrm input[name=RECEIPT_DTM]').val($plan.RECEIPT_DTM);
			$('#kdFrm textarea[name=RECEIPT_REASON]').val($plan.RECEIPT_REASON);
			$('#planStsTxtKdTd').html($plan.PLAN_STS_TXT);
			
			//최근 수정이력 세팅
			$('#lastUpdateLi').html("Last Update. " + $plan.LATEST_NM + " / " + $plan.LATEST_UPDT);
			
			fn_setttingDivAndBtn($('#mFrm input[name=PLAN_STS]').val());
			
			fn_planAddPopupOpen();
		}
	}
	
	function fn_delete(){
		
		var PLAN_STS = $('#mFrm input[name=PLAN_STS]').val();
		
		if(PLAN_STS != 'TP'){
			fnAlert("임시저장 상태만 삭제가능합니다.");
			return false;
		}
		
		if(!confirm("삭제하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/deletePlanJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){	
				fn_planAddPopupClose();
				fnAlert("삭제되었습니다.");
				fn_search();
			} else {
				fnAlert("삭제에 실패하였습니다.");
				fn_search();
			}
		}
	}
	
	function fn_planConfirm(PLAN_STS){
		
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
		
		if(PLAN_STS == 'KY'){
			confirmMsg = "접수처리 하시겠습니까?";
			resultMsg = "접수처리 되었습니다.";
		}else if(PLAN_STS == 'KN'){
			confirmMsg = "접수반려 하시겠습니까?";
			resultMsg = "접수반려 되었습니다.";
		}else {
			fnAlert("오류가 발생하였습니다.[PLAN_STS 상태값 오류]");
			return false;
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#kdFrm input[name=PLAN_STS]').val(PLAN_STS);
		$('#kdFrm input[name=VLUN_PLAN_SN]').val($('#mFrm input[name=VLUN_PLAN_SN]').val());
		$('#kdFrm input[name=MLTR_ID]').val($('#mFrm input[name=MLTR_ID]').val());
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/confirmPlanJs.kspo", $("#kdFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {
				fn_planAddPopupClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("처리에 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/plan/planDownload.kspo");
		$("#searchFrm").submit();
	}
	
	//봉사활동계획서 리포트
	function fn_reportReq(reqType){
		
		var jrfnm = "";//리포트 파일명
		
		if(reqType == "PLAN"){
			jrfnm = "TrmvVlunPlan.jrf";
		}else if(reqType == "CHN_PLAN"){
			jrfnm = "TrmvVlunPlanChange.jrf";
		}
		
		var VLUN_PLAN_SN = $('#mFrm input[name=VLUN_PLAN_SN]').val();
		if(VLUN_PLAN_SN.length < 1){
			fnAlert("관리번호가 존재하지않습니다.");
			return false;
		}
		
		var arg = "VLUN_PLAN_SN#" + VLUN_PLAN_SN;//전달 파타미터
		
		commnReportReq(jrfnm, arg, $("#searchFrm input[name=gMenuSn]").val());
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무 계획관리</h2>
		</div>
	
		<!-- 검색영역 -->
		<form id="searchFrm" method="post" action="${pageContext.request.contextPath}/plan/PlanSelect.kspo">
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
							<td class="t-title">등록일</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker1" name="srchRegDtmStart" type="text" value="${srchRegDtmStart}" maxlength="8" autocomplete="off" class="datepick smal"> ~ <input id="datepicker2" name="srchRegDtmEnd" type="text" value="${srchRegDtmEnd}" maxlength="8" autocomplete="off" class="datepick smal">
									</li>
								</ul>
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
							<td class="t-title">활동기간</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<select name="srchVlunActDateType" class="xsm">
											<option value="" <c:if test="${param.srchVlunActDateType eq '' or param.srchVlunActDateType eq null }">selected="selected"</c:if>>전체</option>
											<option value="START" <c:if test="${param.srchVlunActDateType eq 'START' }">selected="selected"</c:if>>시작일</option>
											<option value="END" <c:if test="${param.srchVlunActDateType eq 'END'}">selected="selected"</c:if>>종료일</option>
										</select>
										<input id="datepicker3" type="text" name="srchVlunActDateStart" value="${param.srchVlunActDateStart}" maxlength="8" autocomplete="off" class="datepick xsm"> ~ <input id="datepicker4" type="text" name="srchVlunActDateEnd" value="${param.srchVlunActDateEnd}" maxlength="8" autocomplete="off" class="datepick xsm">
									</li>
								</ul>
							</td>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">처리상태</td>
							<td>
								<select name="srchPalnStsCd" class="smal">
									<option value="" <c:if test="${param.srchPalnStsCd eq '' or param.srchPalnStsCd eq null }">selected="selected"</c:if>>전체</option>
									<c:forEach var="subLi" items="${planStsCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchPalnStsCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">구분</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="srchRadio1" type="radio" name="srchVlunPlcDvType" value="" <c:if test="${param.srchVlunPlcDvType eq '' or param.srchVlunPlcDvType eq null }">checked="checked"</c:if>>
										<label for="srchRadio1">전체</label>
									</li>
									<li>
										<input id="srchRadio2" type="radio" name="srchVlunPlcDvType" value="dom" <c:if test="${param.srchVlunPlcDvType eq 'dom' }">checked="checked"</c:if>>
										<label for="srchRadio2">국내</label>
									</li>
									<li>
										<input id="srchRadio3" type="radio" name="srchVlunPlcDvType" value="abr" <c:if test="${param.srchVlunPlcDvType eq 'abr' }">checked="checked"</c:if>>
										<label for="srchRadio3">국외</label>
									</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="t-title">키워드</td>
							<td colspan="3">
								<ul class="com-radio-list">
									<li>
										<select name="keyKind" class="smal">
											<option value="" <c:if test="${param.keyKind eq '' or param.keyKind eq null}">selected="selected"</c:if>>전체</option>
											<option value="USER_NAME" <c:if test="${param.keyKind eq 'USER_NAME'}">selected="selected"</c:if>>이름</option>
											<option value="GAME_NAME" <c:if test="${param.keyKind eq 'GAME_NAME'}">selected="selected"</c:if>>종목</option>
										</select>
										<input type="text" name="keyword" class="smal" placeholder="" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
									</li>
								</ul>
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
				<c:if test="${sessionScope.userMap.GRP_SN eq 2}"><!--가맹단체 -->
				<button class="btn red rmvcrr" type="button" onclick="fn_planAddPopupOpen('NEW');">신규</button>
				</c:if>
				<button class="btn red type01" type="button" onclick="excel_download();">엑셀데이터 저장하기</button> <!-- 20211109 수정 -->
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col style="width:60px">
					<col style="width:150px">
					<col style="width:150px">
					<col style="width:10%">
					<col style="width:100px">
					<col style="width:6%">
					<col style="width:60px">
					<col style="width:7%">
					<col style="width:100px">
					<col style="width:100px">
					<col style="width:auto;">
					<col style="width:100px">
					<col style="width:100px">
					<col style="width:8%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>계획번호</th>
						<th>원 계획번호</th>
						<th>이름</th>
						<th>생년월일</th>
						<th>종목</th>
						<th>구분</th>
						<th>활동분야</th>
						<th>활동시작일자</th>
						<th>활동종료일자</th>
						<th>대상기관</th>
						<th>등록일</th>
						<th>처리상태</th>
						<th>체육단체</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty planList}">
							<c:forEach var="plan" items="${planList}">
								<tr>
									<td>${plan.RNUM}</td>
									<td>${plan.VLUN_PLAN_SN}</td>
									<td>${plan.ORG_VLUN_PLAN_SN}</td>
									<td><a href="javascript:fn_detail('${plan.VLUN_PLAN_SN}');" class="tit">${plan.APPL_NM}</a></td>
									<td>${plan.BRTH_DT}</td>
									<td>${plan.GAME_CD_NM}</td>
									<td>${plan.VLUN_PLC_DV_TXT}</td>
									<td>${plan.ACT_FIELD}</td>
									<td>${plan.VLUN_ACT_START}</td>
									<td>${plan.VLUN_ACT_END}</td>
									<td>${plan.VLUN_PLC_NM}</td>
									<td>
										<fmt:parseDate var="REG_DTM" value="${plan.REG_DTM}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${REG_DTM}" pattern="yyyy-MM-dd"/>
									</td>
									<td>${plan.PLAN_STS_NM}</td>
									<td>${plan.MEMORG_NM}</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="13" class="center">일치하는 게시물이 없습니다.</td>
							</tr>	
						</c:otherwise>
					</c:choose>
					
				</tbody>
			</table>
		</div>
		
		<div class="com-paging">
			<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:searchFrm" />
		</div>
		
	</div>
</div>

<!-- 팝업영역 --><!-- 공익복무 계획등록 -->
<div class="cpt-popup reg03" id="planAddPopDiv"><!-- class:active 팝업 on/off -->
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			공익복무 계획등록
			<button class="pop-close" onclick="fn_planAddPopupClose();">
				<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
			</button>
		</div>
		<div class="pop-body">
			<div class="process-status">처리상태 : <b class="t-blue" id="planStsTxtDiv">신규작성</b></div>
			<div class="com-h3 add">대상자 인적사항</div>
			<form id="mFrm" method="post">
				<input type="hidden" name="MLTR_ID"/>
				<input type="hidden" name="VLUN_PLAN_SN"/>
				<input type="hidden" name="APPL_SN"/>
				<input type="hidden" name="VLUN_PLC_SN"/>
				<input type="hidden" name="PLAN_STS"/>
				<input type="hidden" name="ORG_VLUN_PLAN_SN"/>
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
								<td class="t-title">이름</td>
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
				
				<div class="com-h3 add">공익복무 대상기관
					<div class="right-area"><p class="required">필수입력</p></div>
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
								<td class="t-title">구분<span class="t-red"> *</span></td>
								<td class="input-td">
									<div class="search-box">
										<ul class="com-radio-list">
											<li>
												<input id="radio01" type="radio" name="VLUN_PLC_DV_TYPE" value="dom" disabled="disabled" name="radio01">
												<label for="radio01">국내</label>
											</li>
											<li>
												<input id="radio02" type="radio" name="VLUN_PLC_DV_TYPE" value="abr" disabled="disabled" name="radio01">
												<label for="radio02">국외</label>
											</li>
										</ul>
									
										<button type="button" onclick="fn_searchPlacePopupOpen();" id="placeSrhBtn">찾기</button>
									</div>
								</td>
								<td class="t-title">국가<span class="t-red"> *</span></td>
								<td class="input-td">
									<input type="text" name="VLUN_PLC_NA" readonly="readonly" class="ip-title">
								</td>
							</tr>
							<tr>
								<td class="t-title">대상기관명</td>
								<td class="input-td">
									<input type="text" name="VLUN_PLC_NM" value="${plan.VLUN_PLC_NM}" readonly="readonly" class="ip-title">
								</td>
								<td class="t-title">담당자명</td>
								<td class="input-td"><input type="text" name="PLC_MNGR_NM" readonly="readonly" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">담당자 연락처1</td>
								<td class="input-td type03">
									<input type="text" name="PLC_MNGR_TEL_NO" readonly="readonly" title="담당자 연락처1">
								</td>
								<td class="t-title">담당자 연락처2</td>
								<td class="input-td type03">
									<input type="text" name="PLC_MNGR_CP_NO" readonly="readonly" title="담당자 연락처2">
								</td>
							</tr>
							<tr>
								<td class="t-title">봉사장소 주소</td>
								<td colspan="3" class="input-td"><input type="text" name="VLUN_PLC_ADDRESS" readonly="readonly" value="${plan.VLUN_PLC_ADDRESS}" class="ip-title"></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="com-h3 add">공익복무 계획
					<div class="right-area"><p class="required">필수입력</p></div>
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
								<td class="t-title">활동분야<span class="t-red"> *</span></td>
								<td class="input-td">
									<select name="ACT_FIELD" class="tab-sel" title="관할 병무청">
										<c:forEach var="subLi" items="${actFieldCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${plan.ACT_FIELD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
								<td class="t-title">활동기간<span class="t-red"> *</span></td>
								<td class="input-td">
									<ul class="com-radio-list">
										<li>
											<input id="datepicker5" type="text" name="VLUN_ACT_START" value="${plan.VLUN_ACT_START}" maxlength="8" readonly="readonly" autocomplete="off" class="datepick smal"> ~ <input id="datepicker6" type="text" name="VLUN_ACT_END" value="${plan.VLUN_ACT_END}" maxlength="8" readonly="readonly" autocomplete="off" class="datepick smal">
										</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="t-title">활동시간<span class="t-red"> *</span></td>
								<td class="input-td">
									<input type="text" name="ACT_TIME_HR" maxlength="2" class="ip-title" style="width: 70px;">시간
									<select name="ACT_TIME_MN" class="tab-sel" title="활동시간 분" style="width: 130px;">
										<c:forEach var="subLi" items="${actTimeMnCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>분
								</td>
								<td class="t-title">수혜대상<span class="t-red"> *</span></td>
								<td class="input-td">
									<select name="VLUN_TGT" class="tab-sel" title="수혜대상">
										<c:forEach var="subLi" items="${vlunTgtCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="t-title">활동장소<span class="t-red"> *</span></td>
								<td class="input-td" colspan="3"><input type="text" name="ACT_PLACE" value="${plan.ACT_PLACE}" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">비고</td>
								<td colspan="3" class="input-td"><textarea rows="5" name="MAIN_CONTENTS">${plan.MAIN_CONTENTS}</textarea></td>
							</tr>
						</tbody>
					</table>
				</div>
			</form>
			
			<!-- 공단 담당자 일때만 활성 -->
			<div id="kdConfirmDiv">
				<form id="kdFrm">
				<input type="hidden" name="VLUN_PLAN_SN"/>
				<input type="hidden" name="PLAN_STS"/>
				<input type="hidden" name="MLTR_ID">
				<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
				
					<div class="com-h3 add">공단 접수내역
						<div class="right-area">
							<p class="required">필수입력</p>
							<button class="btn red rmvcrr" type="button" onclick="fn_planConfirm('KY');" id="kdKYBtn">접수처리</button>
							<button class="btn red rmvcrr" type="button" onclick="fn_planConfirm('KN');" id="kdKNBtn">접수반려</button>
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
									<td class="t-title">접수일자</td>
									<td class="input-td"><input type="text" name="RECEIPT_DTM" readonly="readonly" style="border: none;" autocomplete="off"></td>
									<td class="t-title">접수결과</td>
									<td  id="planStsTxtKdTd"></td>
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

			<div class="com-helf" id="lastUpdateDiv">
				<ol>
					<li id="lastUpdateLi"></li>
				</ol>
			</div>

			<div class="com-btn-group put">
				<div class="float-r">
					<button class="btn navy rmvcrr" type="button" onclick="fn_save('TP');" id="saveBtn">임시저장</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_save('AP');" id="applBtn">신청</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_planChangeReq();" id="chnReqBtn">계획변경신청</button>
					<button class="btn navy rmvcrr" type="button" onclick="fn_delete();" id="delBtn">삭제</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_reportReq('PLAN');" id="reportPlanBtn">계획 리포트</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_reportReq('CHN_PLAN');" id="reportChnPlanBtn">변경 리포트</button>
					<button class="btn grey rmvcrr" type="button" onclick="fn_planAddPopupClose();">닫기</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //팝업영역 --><!-- 공익복무 계획등록 -->


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

<!-- 팝업영역 --><!-- 대상기관 검색 -->
<div class="cpt-popup" id="searchPlacePopDiv"><!-- class:active 팝업 on/off -->
	<form id="searchPlaceFrm" onsubmit="return false;">
	<input type="hidden" name="pageNo">
	
		<div class="dim"></div>
		<div class="popup" style="width: 1650px;">
			<div class="pop-head">
				대상기관 검색
				<button class="pop-close" onclick="fn_searchPlacePopupClose();">
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
								<td class="t-title">키워드</td>
								<td>
									<ul class="com-radio-list">
										<li>
											<select name="pSrchKeyKind" class="smal">
												<option value="">전체</option>
											</select>
											<input type="text" style="width: 1200px;" name="pSrchKeyword" class="smal" placeholder="" onkeydown="if(event.keyCode == 13){fn_popPlaceSearch();return false;}">
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
	
				<div class="com-btn-group center">
					<button class="btn red write" type="button" onclick="fn_popPlaceSearch();">검색</button>
				</div>
				<!-- //검색영역 -->
	
				<div class="com-result">
					<div class="float-l">
						<span class="total-num">조회결과 <b id="searchPlaceCnt">0</b>건</span>
					</div>
				</div>
	
				<div class="com-grid type02" style="max-height:271px; overflow-x:hidden; overflow-y: auto;">
					<table class="table-grid">
						<caption></caption>
						<colgroup>
							<col width="50px">
							<col width="10%">
							<col width="15%">
							<col width="20%">
							<col width="20%">
							<col width="auto">
						</colgroup>
						<thead>
							<tr>
								<th>선택</th>
								<th>구분</th>
								<th>국가</th>
								<th>시군구</th>
								<th>기관명</th>
								<th>주소</th>
							</tr>
						</thead>
						<tbody id="placeTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-paging" id="placePagingDiv"></div>
	
				<div class="com-btn-group center">
					<button class="btn grey write" type="button" onclick="fn_searchPlacePopupClose();">취소</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPlace();">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->