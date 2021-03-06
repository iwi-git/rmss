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
		
		$('button[id=kdKYBtn]').hide();//????????????
		$('button[id=kdKNBtn]').hide();//????????????
		
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
		//1	???????????????
		//2	???????????????
		//3	??????????????????
		//4	??????????????????
		
		if(grpSn == "1"){//??????????????? ?????????
			if($('#mFrm input[name=VLUN_PLAN_SN]').val().length > 0){
				$('button[id=reportPlanBtn]').show();//????????????????????? ?????????
				
				if(	$('#mFrm input[NAME=ORG_VLUN_PLAN_SN]').val() != '' &&
						$('#mFrm input[NAME=ORG_VLUN_PLAN_SN]').val() != $('#mFrm input[name=VLUN_PLAN_SN]').val()){
					$('button[id=reportChnPlanBtn]').show();//??????????????????????????? ?????????	
				}
			}	
		}
		
		if(type == 'TP'){//????????????
			
			$('#lastUpdateDiv').show();
			fn_setform('mFrm', false);
			$('button[id=personSrhBtn]').show();
			$('button[id=placeSrhBtn]').show();
			
			if(grpSn == '2'){
				$('button[id=saveBtn]').show();//????????????
				$('button[id=applBtn]').show();//??????
				if($('#mFrm input[name=VLUN_PLAN_SN]').val().length > 0){
					$('button[id=delBtn]').show();//??????	
				}
			}
			
		} else if(type == 'AP'){//??????
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//?????? ????????????
			
			if(grpSn == '1'){
				$('button[id=kdKYBtn]').show();//????????????
				$('button[id=kdKNBtn]').show();//????????????
				fn_setform('kdFrm', false);
			} else if(grpSn == '2'){
				$('button[id=chnReqBtn]').show();
			}
			
		} else if(type == 'KY'){//????????????
			
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//?????? ????????????
			
		} else if(type == 'KN'){//????????????
			$('#lastUpdateDiv').show();
			$('#kdConfirmDiv').show();//?????? ????????????
			
		}
	}
	
	//??????
	function fn_search(){
		//????????????????????? ?????? 1????????????
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("????????? ??????????????? ?????? 1???????????? ?????? ???????????????.");
			return;
		}
		
		fnPageLoad("/plan/PlanSelect.kspo",$("#searchFrm").serialize());
	}
	
	//?????? ?????? ?????? ??????
	function fn_planAddPopupOpen(type){
		
		if(type == 'NEW'){//???????????? ?????????
			fn_setttingDivAndBtn('TP');
		}
		
		$('#planAddPopDiv').addClass('active');
	}
	
	//?????? ?????? ?????? ??????
	function fn_planAddPopupClose(){
		
		//????????? ???????????? ?????????
		$('#planStsTxtDiv').html('????????????');
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
		
		//???????????? ?????? ?????? ?????????
		$('#mFrm input[name=VLUN_PLC_SN]').val('');
		$('#mFrm input[name=VLUN_PLC_DV_TYPE]').prop('checked', false);
		$('#mFrm input[name=VLUN_PLC_NA]').val('');
		$('#mFrm input[name=VLUN_PLC_NM]').val('');
		$('#mFrm input[name=PLC_MNGR_NM]').val('');
		$('#mFrm input[name=PLC_MNGR_TEL_NO]').val('');
		$('#mFrm input[name=PLC_MNGR_CP_NO]').val('');
		$('#mFrm input[name=VLUN_PLC_ADDRESS]').val('');
		
		//?????? ?????? ?????????
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
		
		//?????? ???????????? ?????????
		$('#kdFrm input[name=VLUN_PLAN_SN]').val('');
		$('#kdFrm input[name=PLAN_STS]').val('');
		$('#kdFrm input[name=MLTR_ID]').val('');
		$('#kdFrm input[name=RECEIPT_DTM]').val('');
		$('#kdFrm textarea[name=RECEIPT_REASON]').val('');
		$('#planStsTxtKdTd').html('');
		
		//???????????? ?????????
		$('#lastUpdateLi').html('');
		
		fn_hideDivBtn();
		
		$('#planAddPopDiv').removeClass('active');
	}
	
	//???????????? ?????? ?????? ??????
	function fn_searchPersonPopupOpen(){
		$('#searchPersonPopDiv').addClass('active');
	}
	
	//???????????? ?????? ?????? ?????????
	function fn_searchPersonPopupClose(){
		
		$('#searchPersonFrm select[name=pSrchKeyKind]').val('');//????????? ?????? ?????????
		$('#searchPersonFrm input[name=pSrchKeyword]').val('');//????????? ????????? ?????????
		$('#searchPersonFrm tbody[id=personTbody]').empty();//???????????? ?????????
		$('#searchPersonCnt').html('0');//???????????? ????????? ?????????
		$('#personPagingDiv').empty();//????????? ?????????
		$('#searchPersonPopDiv').removeClass('active');
	}
	
	//?????? ?????? ?????? ??????
	function fn_searchPlacePopupOpen(){
		$('#searchPlacePopDiv').addClass('active');
	}
	
	//?????? ?????? ?????? ?????????
	function fn_searchPlacePopupClose(){
		
		$('#searchPlaceFrm select[name=pSrchKeyKind]').val('');//????????? ?????? ?????????
		$('#searchPlaceFrm input[name=pSrchKeyword]').val('');//????????? ????????? ?????????
		$('#searchPlaceFrm tbody[id=placeTbody]').empty();//???????????? ?????????
		$('#searchPlaceCnt').html('0');//???????????? ????????? ?????????
		$('#placePagingDiv').empty();//????????? ?????????
		$('#searchPlacePopDiv').removeClass('active');
	}

	//???????????? ????????? ??????
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
			fnAlert("????????? ?????????????????????. ?????? ??????????????????.");
			return false;
		}
		
		var personList = $json.responseJSON.personList;
		
		var htmlStr = "";
		
		if(personList.length < 1){
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"5\" class=\"center\">???????????? ??????????????? ????????????.</td>";
			htmlStr += "<tr>";
		}
		
		for(var i = 0; i < personList.length; i++){
			var MLTR_ID = personList[i].MLTR_ID;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"MLTR_ID_GRP\" id=\"MLTR_ID" + i + "\" value=\"" + MLTR_ID + "\">";
			htmlStr += "<label for=\"MLTR_ID" + i + "\" class=\"chk-only\">??????</label>";
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
	
	//???????????? ??????
	function fn_confirmPerson(){
		
		var checkedCnt = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').length;

		if(checkedCnt < 1){
			fnAlert("??????????????? ??????????????????.");
			return false;
		}
		
		if(checkedCnt > 1){
			fnAlert("????????? ??????????????? ??????????????????.");
			return false;
		}
		
		var MLTR_ID = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').val();
		
		if(MLTR_ID == ''){
			fnAlert("????????? ??????????????? ????????? ???????????? ????????????. ?????? ??????????????????.");
			return false;
		}
		
		var param = "MLTR_ID=" + MLTR_ID;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();	
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var personInfo = $json.responseJSON.personInfo;
			var htmlStr = "";
			
			if(personInfo == null){
				fnAlert("????????? ?????????????????????.");
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
	
	//???????????? ??????
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
			fnAlert("????????? ?????????????????????. ?????? ??????????????????.");
			return false;
		}
		
		var placeList = $json.responseJSON.placeList;
		
		var htmlStr = "";
		
		if(placeList.length < 1){
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"6\" class=\"center\">???????????? ??????????????? ????????????.</td>";
			htmlStr += "<tr>";
		}
		
		for(var i = 0; i < placeList.length; i++){
			var vlunPlcSn = placeList[i].VLUN_PLC_SN;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"checkPlaceGrp\" id=\"checkPlace" + i + "\" value=\"" + vlunPlcSn + "\">";
			htmlStr += "<label for=\"checkPlace" + i + "\" class=\"chk-only\">??????</label>";
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
			fnAlert("??????????????? ??????????????????.");
			return false;
		}
		
		if(checkCnt > 1){
			fnAlert("????????? ??????????????? ??????????????????.");
			return false;
		}
		
		var vlunPlcSn = $('#searchPlaceFrm input[name=checkPlaceGrp]:checked').val();
		
		if(vlunPlcSn == ''){
			fnAlert("????????? ??????????????? ????????? ???????????? ????????????. ?????? ??????????????????.");
			return false;
		}
		
		var param = "VLUN_PLC_SN=" + vlunPlcSn;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
			
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPlaceJs.kspo", param);
		
		if($json.statusText != "OK"){
			fnAlert("????????? ?????????????????????. ?????? ??????????????????.");
			return false;
		}
		
		var placeInfo = $json.responseJSON.placeInfo;
		var htmlStr = "";
		
		if(placeInfo == null){
			fnAlert("????????? ?????????????????????.");
			return false;
		}
		
		$('#mFrm input[name=VLUN_PLC_SN]').val(placeInfo.VLUN_PLC_SN);//???????????? ??????
		
		var vlunPlcDvType = placeInfo.VLUN_PLC_DV_TYPE;//??????,????????????
		
		$('#mFrm input[name=VLUN_PLC_DV_TYPE]').each(function(){
			if($(this).val() == vlunPlcDvType){
				$(this).prop('checked', true);
			}
		});
		
		$('#mFrm input[name=VLUN_PLC_NA]').val(placeInfo.VLUN_PLC_NA);//??????
		$('#mFrm input[name=VLUN_PLC_NM]').val(placeInfo.VLUN_PLC_NM);//???????????????
		$('#mFrm input[name=PLC_MNGR_NM]').val(placeInfo.PLC_MNGR_NM);//????????????
		$('#mFrm input[name=PLC_MNGR_TEL_NO]').val(placeInfo.PLC_MNGR_TEL_NO);//????????? ?????????1
		$('#mFrm input[name=PLC_MNGR_CP_NO]').val(placeInfo.PLC_MNGR_CP_NO);//????????? ?????????2
		$('#mFrm input[name=VLUN_PLC_ADDRESS]').val(placeInfo.VLUN_PLC_ADDRESS);//???????????? ??????
		
		fn_searchPlacePopupClose();	
	}
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
	}
	
	function searchPlaceFrm(pageNo){
		fn_popPlaceSearch(pageNo);
	}
	
	function fn_planChangeReq(){
		
		if(!confirm("????????????????????? ?????????????????????????")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/planChagneReqJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {	
				fn_planAddPopupClose();
				fnAlert("????????????????????? ???????????????.");
				fn_search();
			} else {
				fnAlert("????????????????????? ?????????????????????.");
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
			confirmMsg = "???????????? ???????????????????";
			resultMsg = "???????????? ???????????????.";
		}else if(PLAN_STS == 'AP'){
			confirmMsg = "?????????????????????????";
			resultMsg = "?????????????????????.";
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
				fnAlert("????????? ?????????????????????.");
				fn_search();
			}
		}
	}
	
	function fn_validate(PLAN_STS){
		
		if(PLAN_STS == 'TP'|| PLAN_STS == 'AP'){//????????????, ??????
			
			//???????????? ?????? ?????? ??????
			if($('#mFrm input[name=MLTR_ID]').val() == ''){
				fnAlert("???????????? ????????? ??????????????????.");
				return false;
			}
		
			//???????????? ?????? ?????? ??????
			if($('#mFrm input[name=VLUN_PLC_SN]').val() == ''){
				fnAlert("???????????? ????????? ??????????????????.");
				return false;
			}
			
			//???????????? ???????????????
			if($('#mFrm select[name=ACT_FIELD]').val() == ''){
				fnFocAlert("??????????????? ??????????????????.", $('#mFrm select[name=ACT_FIELD]'));
				return false;
			}
			
			//???????????? ?????? ???????????????
			if($('#mFrm input[name=VLUN_ACT_START]').val() == ''){
				fnFocAlert("???????????? ?????? ????????? ??????????????????.", $('#mFrm input[name=VLUN_ACT_START]'));
				return false;
			}
			
			//???????????? ?????? ???????????????
			if($('#mFrm input[name=VLUN_ACT_END]').val() == ''){
				fnFocAlert("???????????? ?????? ????????? ??????????????????.", $('#mFrm input[name=VLUN_ACT_END]'));
				return false;
			}
			
			if($('#mFrm input[name=VLUN_ACT_START]').val() > $('#mFrm input[name=VLUN_ACT_END]').val()){
				fnAlert("???????????? ???????????? ????????? ?????? ??? ??? ????????????.");
				return false;
			}
			
			if($('#mFrm input[name=ACT_TIME_HR]').val() == ''){
				fnFocAlert("??????????????? ???????????????.", $('#mFrm input[name=ACT_TIME_HR]'));
				return false;
			}
			
			if($('#mFrm select[name=ACT_TIME_MN]').val() == ''){
				fnFocAlert("??????????????? ???????????????.", $('#mFrm select[name=ACT_TIME_MN]'));
				return false;
			}
			
			if($('#mFrm select[name=VLUN_TGT]').val() == ''){
				fnFocAlert("??????????????? ??????????????????.", $('#mFrm select[name=VLUN_TGT]'));
				return false;
			}
			
			if($('#mFrm input[name=ACT_PLACE]').val() == ''){
				fnFocAlert("??????????????? ??????????????????.", $('#mFrm input[name=ACT_PLACE]'));
				return false;
			}
			
			//if($('#mFrm textarea[name=MAIN_CONTENTS]').val() == ''){
			//	fnFocAlert("????????? ??????????????????.", $('#mFrm textarea[name=MAIN_CONTENTS]'));
			//	return false;
			//}
			
		}
		
		return true;
	}
	
	function fn_detail(VLUN_PLAN_SN){
		
		if(typeof(VLUN_PLAN_SN) == 'undefined'){
			fnAlert("??????????????? ????????? ?????????????????????.");
			return false;
		}
		
		var param = "VLUN_PLAN_SN=" + VLUN_PLAN_SN;
			param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPlanDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var $plan = $json.responseJSON.plan;
			
			if($plan == null){
				fnAlert("??????????????? ????????? ?????????????????????.");
				return false;
			}
			
			
			//???????????? ?????? ??????
			$('#mFrm input[name=APPL_SN]').val($plan.APPL_SN);
			$('#mFrm input[name=APPL_NM]').val($plan.APPL_NM);
			$('#mFrm td[id=TD_APPL_SN]').html($plan.APPL_SN);
			$('#mFrm td[id=TD_BRTH_DT]').html($plan.BRTH_DT);
			$('#mFrm td[id=TD_ADDR]').html($plan.ADDR);
			$('#mFrm td[id=TD_EMAIL]').html($plan.EMAIL);
			$('#mFrm td[id=TD_CP_NO]').html($plan.CP_NO);
			$('#mFrm td[id=TD_GAME_CD_NM]').html($plan.GAME_CD_NM);
			$('#mFrm td[id=TD_MEM_ORG_NM]').html($plan.MEM_ORG_NM);
			
			//???????????? ?????? ??????
			$('#mFrm input[name=VLUN_PLC_SN]').val($plan.VLUN_PLC_SN);//???????????? ??????
			
			var vlunPlcDvType = $plan.VLUN_PLC_DV_TYPE;//??????,????????????
			
			$('#mFrm input[name=VLUN_PLC_DV_TYPE]').each(function(){
				if($(this).val() == vlunPlcDvType){
					$(this).prop('checked', true);
				}
			});
			
			$('#mFrm input[name=VLUN_PLC_NA]').val($plan.VLUN_PLC_NA);//??????
			$('#mFrm input[name=VLUN_PLC_NM]').val($plan.VLUN_PLC_NM);//???????????????
			$('#mFrm input[name=PLC_MNGR_NM]').val($plan.PLC_MNGR_NM);//????????????
			$('#mFrm input[name=PLC_MNGR_TEL_NO]').val($plan.PLC_MNGR_TEL_NO);//????????? ?????????1
			$('#mFrm input[name=PLC_MNGR_CP_NO]').val($plan.PLC_MNGR_CP_NO);//????????? ?????????2
			$('#mFrm input[name=VLUN_PLC_ADDRESS]').val($plan.VLUN_PLC_ADDRESS);//???????????? ??????
			
			
			//?????? ?????? ??????
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
			
			//?????? ???????????? ??????
			$('#kdFrm input[name=RECEIPT_DTM]').val($plan.RECEIPT_DTM);
			$('#kdFrm textarea[name=RECEIPT_REASON]').val($plan.RECEIPT_REASON);
			$('#planStsTxtKdTd').html($plan.PLAN_STS_TXT);
			
			//?????? ???????????? ??????
			$('#lastUpdateLi').html("Last Update. " + $plan.LATEST_NM + " / " + $plan.LATEST_UPDT);
			
			fn_setttingDivAndBtn($('#mFrm input[name=PLAN_STS]').val());
			
			fn_planAddPopupOpen();
		}
	}
	
	function fn_delete(){
		
		var PLAN_STS = $('#mFrm input[name=PLAN_STS]').val();
		
		if(PLAN_STS != 'TP'){
			fnAlert("???????????? ????????? ?????????????????????.");
			return false;
		}
		
		if(!confirm("?????????????????????????")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/deletePlanJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){	
				fn_planAddPopupClose();
				fnAlert("?????????????????????.");
				fn_search();
			} else {
				fnAlert("????????? ?????????????????????.");
				fn_search();
			}
		}
	}
	
	function fn_planConfirm(PLAN_STS){
		
		//if($('#kdFrm input[name=RECEIPT_DTM]').val() == ''){
		//	fnAlert("??????????????? ??????????????????.");
		//	return false;
		//}
		
		if($('#kdFrm textarea[name=RECEIPT_REASON]').val() == ''){
			fnFocAlert("????????? ??????????????????.", $('#kdFrm textarea[name=RECEIPT_REASON]'));
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(PLAN_STS == 'KY'){
			confirmMsg = "???????????? ???????????????????";
			resultMsg = "???????????? ???????????????.";
		}else if(PLAN_STS == 'KN'){
			confirmMsg = "???????????? ???????????????????";
			resultMsg = "???????????? ???????????????.";
		}else {
			fnAlert("????????? ?????????????????????.[PLAN_STS ????????? ??????]");
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
				fnAlert("????????? ?????????????????????.");
				fn_search();
			}
		}
		
	}
	
	//??????????????????
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/plan/planDownload.kspo");
		$("#searchFrm").submit();
	}
	
	//????????????????????? ?????????
	function fn_reportReq(reqType){
		
		var jrfnm = "";//????????? ?????????
		
		if(reqType == "PLAN"){
			jrfnm = "TrmvVlunPlan.jrf";
		}else if(reqType == "CHN_PLAN"){
			jrfnm = "TrmvVlunPlanChange.jrf";
		}
		
		var VLUN_PLAN_SN = $('#mFrm input[name=VLUN_PLAN_SN]').val();
		if(VLUN_PLAN_SN.length < 1){
			fnAlert("??????????????? ????????????????????????.");
			return false;
		}
		
		var arg = "VLUN_PLAN_SN#" + VLUN_PLAN_SN;//?????? ????????????
		
		commnReportReq(jrfnm, arg, $("#searchFrm input[name=gMenuSn]").val());
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- ????????? -->
		<div class="com-title-group">
			<h2>???????????? ????????????</h2>
		</div>
	
		<!-- ???????????? -->
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
							<td class="t-title">?????????</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker1" name="srchRegDtmStart" type="text" value="${srchRegDtmStart}" maxlength="8" autocomplete="off" class="datepick smal"> ~ <input id="datepicker2" name="srchRegDtmEnd" type="text" value="${srchRegDtmEnd}" maxlength="8" autocomplete="off" class="datepick smal">
									</li>
								</ul>
							</td>
							<td class="t-title">????????????</td>
							<td>
								<select name="srchMemorgCd" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne 2}">
									<option value="" <c:if test="${param.srchMemorgCd eq '' or param.srchMemorgCd eq null }">selected="selected"</c:if>>??????</option>
									</c:if>
									<c:forEach var="subLi" items="${memorgCdList}">
									<option value="${subLi.MEMORG_SN}" <c:if test="${param.srchMemorgCd eq subLi.MEMORG_SN}">selected="selected"</c:if>>${subLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">????????????</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<select name="srchVlunActDateType" class="xsm">
											<option value="" <c:if test="${param.srchVlunActDateType eq '' or param.srchVlunActDateType eq null }">selected="selected"</c:if>>??????</option>
											<option value="START" <c:if test="${param.srchVlunActDateType eq 'START' }">selected="selected"</c:if>>?????????</option>
											<option value="END" <c:if test="${param.srchVlunActDateType eq 'END'}">selected="selected"</c:if>>?????????</option>
										</select>
										<input id="datepicker3" type="text" name="srchVlunActDateStart" value="${param.srchVlunActDateStart}" maxlength="8" autocomplete="off" class="datepick xsm"> ~ <input id="datepicker4" type="text" name="srchVlunActDateEnd" value="${param.srchVlunActDateEnd}" maxlength="8" autocomplete="off" class="datepick xsm">
									</li>
								</ul>
							</td>
							<td class="t-title">?????????</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>??????</option> --%>
									<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">????????????</td>
							<td>
								<select name="srchPalnStsCd" class="smal">
									<option value="" <c:if test="${param.srchPalnStsCd eq '' or param.srchPalnStsCd eq null }">selected="selected"</c:if>>??????</option>
									<c:forEach var="subLi" items="${planStsCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchPalnStsCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">??????</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="srchRadio1" type="radio" name="srchVlunPlcDvType" value="" <c:if test="${param.srchVlunPlcDvType eq '' or param.srchVlunPlcDvType eq null }">checked="checked"</c:if>>
										<label for="srchRadio1">??????</label>
									</li>
									<li>
										<input id="srchRadio2" type="radio" name="srchVlunPlcDvType" value="dom" <c:if test="${param.srchVlunPlcDvType eq 'dom' }">checked="checked"</c:if>>
										<label for="srchRadio2">??????</label>
									</li>
									<li>
										<input id="srchRadio3" type="radio" name="srchVlunPlcDvType" value="abr" <c:if test="${param.srchVlunPlcDvType eq 'abr' }">checked="checked"</c:if>>
										<label for="srchRadio3">??????</label>
									</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="t-title">?????????</td>
							<td colspan="3">
								<ul class="com-radio-list">
									<li>
										<select name="keyKind" class="smal">
											<option value="" <c:if test="${param.keyKind eq '' or param.keyKind eq null}">selected="selected"</c:if>>??????</option>
											<option value="USER_NAME" <c:if test="${param.keyKind eq 'USER_NAME'}">selected="selected"</c:if>>??????</option>
											<option value="GAME_NAME" <c:if test="${param.keyKind eq 'GAME_NAME'}">selected="selected"</c:if>>??????</option>
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
			<button class="btn red write" type="button" onclick="fn_search();">??????</button>
		</div>
		<!-- //???????????? -->
		
		<div class="com-result">
			<div class="float-l">
				<span class="total-num">???????????? <b><fmt:formatNumber value="${pageInfo.totalRecordCount}" pattern="#,###"/></b>???</span>
			</div>
			<div class="float-r">
				<select id="srchPageCnt" name="recordCountPerPage" style="height: 42px; width:130px; padding-left: 20px;">
						<c:forEach items="${viewList}" var="subLi">
							<option value="${subLi.ALT_CODE}" <c:if test="${param.recordCountPerPage eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
						</c:forEach>
				</select>&nbsp;&nbsp;
				<c:if test="${sessionScope.userMap.GRP_SN eq 2}"><!--???????????? -->
				<button class="btn red rmvcrr" type="button" onclick="fn_planAddPopupOpen('NEW');">??????</button>
				</c:if>
				<button class="btn red type01" type="button" onclick="excel_download();">??????????????? ????????????</button> <!-- 20211109 ?????? -->
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
						<th>??????</th>
						<th>????????????</th>
						<th>??? ????????????</th>
						<th>??????</th>
						<th>????????????</th>
						<th>??????</th>
						<th>??????</th>
						<th>????????????</th>
						<th>??????????????????</th>
						<th>??????????????????</th>
						<th>????????????</th>
						<th>?????????</th>
						<th>????????????</th>
						<th>????????????</th>
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
								<td colspan="13" class="center">???????????? ???????????? ????????????.</td>
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

<!-- ???????????? --><!-- ???????????? ???????????? -->
<div class="cpt-popup reg03" id="planAddPopDiv"><!-- class:active ?????? on/off -->
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			???????????? ????????????
			<button class="pop-close" onclick="fn_planAddPopupClose();">
				<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="?????? ?????? ?????????">
			</button>
		</div>
		<div class="pop-body">
			<div class="process-status">???????????? : <b class="t-blue" id="planStsTxtDiv">????????????</b></div>
			<div class="com-h3 add">????????? ????????????</div>
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
								<td class="t-title">??????</td>
								<td class="input-td">
									<div class="search-box">
										<input type="text" name="APPL_NM" readonly="readonly">
										<button type="button" onclick="fn_searchPersonPopupOpen();" id="personSrhBtn">??????</button>
									</div>
								</td>
								<td class="t-title">????????????</td>
								<td class="input-td" id="TD_APPL_SN"></td>
							</tr>
							<tr>
								<td class="t-title">????????????</td>
								<td class="input-td" id="TD_BRTH_DT"></td>
								<td class="t-title">??????</td>
								<td class="input-td" id="TD_ADDR"></td>
							</tr>
							<tr>
								<td class="t-title">?????????</td>
								<td class="input-td" id="TD_EMAIL"></td>
								<td class="t-title">?????????</td>
								<td class="input-td" id="TD_CP_NO"></td>
							</tr>
							<tr>
								<td class="t-title">??????</td>
								<td class="input-td" id="TD_GAME_CD_NM"></td>
								<td class="t-title">????????????</td>
								<td class="input-td" id="TD_MEM_ORG_NM"></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="com-h3 add">???????????? ????????????
					<div class="right-area"><p class="required">????????????</p></div>
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
								<td class="t-title">??????<span class="t-red"> *</span></td>
								<td class="input-td">
									<div class="search-box">
										<ul class="com-radio-list">
											<li>
												<input id="radio01" type="radio" name="VLUN_PLC_DV_TYPE" value="dom" disabled="disabled" name="radio01">
												<label for="radio01">??????</label>
											</li>
											<li>
												<input id="radio02" type="radio" name="VLUN_PLC_DV_TYPE" value="abr" disabled="disabled" name="radio01">
												<label for="radio02">??????</label>
											</li>
										</ul>
									
										<button type="button" onclick="fn_searchPlacePopupOpen();" id="placeSrhBtn">??????</button>
									</div>
								</td>
								<td class="t-title">??????<span class="t-red"> *</span></td>
								<td class="input-td">
									<input type="text" name="VLUN_PLC_NA" readonly="readonly" class="ip-title">
								</td>
							</tr>
							<tr>
								<td class="t-title">???????????????</td>
								<td class="input-td">
									<input type="text" name="VLUN_PLC_NM" value="${plan.VLUN_PLC_NM}" readonly="readonly" class="ip-title">
								</td>
								<td class="t-title">????????????</td>
								<td class="input-td"><input type="text" name="PLC_MNGR_NM" readonly="readonly" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">????????? ?????????1</td>
								<td class="input-td type03">
									<input type="text" name="PLC_MNGR_TEL_NO" readonly="readonly" title="????????? ?????????1">
								</td>
								<td class="t-title">????????? ?????????2</td>
								<td class="input-td type03">
									<input type="text" name="PLC_MNGR_CP_NO" readonly="readonly" title="????????? ?????????2">
								</td>
							</tr>
							<tr>
								<td class="t-title">???????????? ??????</td>
								<td colspan="3" class="input-td"><input type="text" name="VLUN_PLC_ADDRESS" readonly="readonly" value="${plan.VLUN_PLC_ADDRESS}" class="ip-title"></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="com-h3 add">???????????? ??????
					<div class="right-area"><p class="required">????????????</p></div>
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
								<td class="t-title">????????????<span class="t-red"> *</span></td>
								<td class="input-td">
									<select name="ACT_FIELD" class="tab-sel" title="?????? ?????????">
										<c:forEach var="subLi" items="${actFieldCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${plan.ACT_FIELD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
								<td class="t-title">????????????<span class="t-red"> *</span></td>
								<td class="input-td">
									<ul class="com-radio-list">
										<li>
											<input id="datepicker5" type="text" name="VLUN_ACT_START" value="${plan.VLUN_ACT_START}" maxlength="8" readonly="readonly" autocomplete="off" class="datepick smal"> ~ <input id="datepicker6" type="text" name="VLUN_ACT_END" value="${plan.VLUN_ACT_END}" maxlength="8" readonly="readonly" autocomplete="off" class="datepick smal">
										</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="t-title">????????????<span class="t-red"> *</span></td>
								<td class="input-td">
									<input type="text" name="ACT_TIME_HR" maxlength="2" class="ip-title" style="width: 70px;">??????
									<select name="ACT_TIME_MN" class="tab-sel" title="???????????? ???" style="width: 130px;">
										<c:forEach var="subLi" items="${actTimeMnCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>???
								</td>
								<td class="t-title">????????????<span class="t-red"> *</span></td>
								<td class="input-td">
									<select name="VLUN_TGT" class="tab-sel" title="????????????">
										<c:forEach var="subLi" items="${vlunTgtCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="t-title">????????????<span class="t-red"> *</span></td>
								<td class="input-td" colspan="3"><input type="text" name="ACT_PLACE" value="${plan.ACT_PLACE}" class="ip-title"></td>
							</tr>
							<tr>
								<td class="t-title">??????</td>
								<td colspan="3" class="input-td"><textarea rows="5" name="MAIN_CONTENTS">${plan.MAIN_CONTENTS}</textarea></td>
							</tr>
						</tbody>
					</table>
				</div>
			</form>
			
			<!-- ?????? ????????? ????????? ?????? -->
			<div id="kdConfirmDiv">
				<form id="kdFrm">
				<input type="hidden" name="VLUN_PLAN_SN"/>
				<input type="hidden" name="PLAN_STS"/>
				<input type="hidden" name="MLTR_ID">
				<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
				
					<div class="com-h3 add">?????? ????????????
						<div class="right-area">
							<p class="required">????????????</p>
							<button class="btn red rmvcrr" type="button" onclick="fn_planConfirm('KY');" id="kdKYBtn">????????????</button>
							<button class="btn red rmvcrr" type="button" onclick="fn_planConfirm('KN');" id="kdKNBtn">????????????</button>
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
									<td class="t-title">????????????</td>
									<td class="input-td"><input type="text" name="RECEIPT_DTM" readonly="readonly" style="border: none;" autocomplete="off"></td>
									<td class="t-title">????????????</td>
									<td  id="planStsTxtKdTd"></td>
								</tr>
								<tr>
									<td class="t-title">??????<span class="t-red"> *</span></td>
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
					<button class="btn navy rmvcrr" type="button" onclick="fn_save('TP');" id="saveBtn">????????????</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_save('AP');" id="applBtn">??????</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_planChangeReq();" id="chnReqBtn">??????????????????</button>
					<button class="btn navy rmvcrr" type="button" onclick="fn_delete();" id="delBtn">??????</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_reportReq('PLAN');" id="reportPlanBtn">?????? ?????????</button>
					<button class="btn red rmvcrr" type="button" onclick="fn_reportReq('CHN_PLAN');" id="reportChnPlanBtn">?????? ?????????</button>
					<button class="btn grey rmvcrr" type="button" onclick="fn_planAddPopupClose();">??????</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //???????????? --><!-- ???????????? ???????????? -->


<!-- ???????????? --><!-- ???????????? ?????? -->
<div class="cpt-popup" id="searchPersonPopDiv"><!-- class:active ?????? on/off -->
	<form id="searchPersonFrm" onsubmit="return false;">
		<div class="dim"></div>
		<div class="popup" style="width: 650px;">
			<div class="pop-head">
				???????????? ??????
				<button class="pop-close" onclick="fn_searchPersonPopupClose();">
					<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="?????? ?????? ?????????">
				</button>
			</div>
			<div class="pop-body" style="padding: 45px;">
				<!-- ???????????? -->
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:150px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">??????</td>
								<td>
									<select name="pSrchGameCd" class="tab-sel">
										<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="t-title">?????????</td>
								<td>
									<ul class="com-radio-list">
										<li>
											<select name="pSrchKeyKind" class="smal">
												<option value="">??????</option>
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
					<button class="btn red write" type="button" onclick="fn_popPersonSearch();">??????</button>
				</div>
				<!-- //???????????? -->
	
				<div class="com-result">
					<div class="float-l">
						<span class="total-num">???????????? <b id="searchPersonCnt">0</b>???</span>
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
								<th>??????</th>
								<th>????????????</th>
								<th>??????</th>
								<th>????????????</th>
								<th>??????</th>
							</tr>
						</thead>
						<tbody id="personTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-paging" id="personPagingDiv"></div>
	
				<div class="com-btn-group center">
					<button class="btn grey write" type="button" onclick="fn_searchPersonPopupClose();">??????</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPerson();">??????</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //???????????? -->

<!-- ???????????? --><!-- ???????????? ?????? -->
<div class="cpt-popup" id="searchPlacePopDiv"><!-- class:active ?????? on/off -->
	<form id="searchPlaceFrm" onsubmit="return false;">
	<input type="hidden" name="pageNo">
	
		<div class="dim"></div>
		<div class="popup" style="width: 1650px;">
			<div class="pop-head">
				???????????? ??????
				<button class="pop-close" onclick="fn_searchPlacePopupClose();">
					<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="?????? ?????? ?????????">
				</button>
			</div>
			<div class="pop-body" style="padding: 45px;">
				<!-- ???????????? -->
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:150px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">?????????</td>
								<td>
									<ul class="com-radio-list">
										<li>
											<select name="pSrchKeyKind" class="smal">
												<option value="">??????</option>
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
					<button class="btn red write" type="button" onclick="fn_popPlaceSearch();">??????</button>
				</div>
				<!-- //???????????? -->
	
				<div class="com-result">
					<div class="float-l">
						<span class="total-num">???????????? <b id="searchPlaceCnt">0</b>???</span>
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
								<th>??????</th>
								<th>??????</th>
								<th>??????</th>
								<th>?????????</th>
								<th>?????????</th>
								<th>??????</th>
							</tr>
						</thead>
						<tbody id="placeTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-paging" id="placePagingDiv"></div>
	
				<div class="com-btn-group center">
					<button class="btn grey write" type="button" onclick="fn_searchPlacePopupClose();">??????</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPlace();">??????</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //???????????? -->