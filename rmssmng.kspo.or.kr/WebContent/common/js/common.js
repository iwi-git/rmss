
function getTestJsonData(method, url, param, func) {
	$.ajax({
		 type : method 		// 전송타입
		,url : url 			// 액션
		,data : param 		// 파라미터
		,dataType : "json"	// 데이타타입은 json으로 설정
		,cache : false		// 캐시저장안함
		,success : function(data,status,xhr) { //요청 성공하면
			func(xhr);
		} //success end
		,error : function(xhr, textStatus, errorThrown) { //요청 실패하면
			if(textStatus == "error") {
				setAjaxErrorMsg(xhr);
			}
		} //error end
	}); //ajax end
}

function getJsonData(method, url, param) {
	
	var returnJson = "";
	$.ajax({
		 type : method 		// 전송타입
		,url : url 			// 액션
		,data : param 		// 파라미터
		,dataType : "json"	// 데이타타입은 json으로 설정
		,async : false		// 동기형태로 실행
		,cache : false		// 캐시저장안함
		,beforeSend : function(xhr){

		}
		,success : function(data,status,xhr) { //요청 성공하면
			returnJson = xhr; //return받은 결과를 json 객체로 parsing함.
		} //success end
		,error : function(xhr, textStatus, errorThrown) { //요청 실패하면
			if(textStatus == "error") {
				setAjaxErrorMsg(xhr);
			}
		} //error end
	}); //ajax end

	return returnJson;
}

function getJsonMultiData(url, frm) {
	
	var returnJson = "";
	
	$("#" + frm).ajaxForm({
		url : url,
		enctype : "multipart/form-data",
		dataType : "json",
		processData : false,
		contentType : false,
		async : false,
		success :function(data,status,xhr){
			returnJson = xhr;
		},
		error : function(xhr, textStatus, errorThrown) { //요청 실패하면
			if(textStatus == "error") {
				setAjaxErrorMsg(xhr);
			}
		} //error end
	});
	$("#" + frm).submit();
	
	return returnJson;
}

//메세지 호출
function fnAlert(tit,msg,type,url){
	var headTit = "";
	if("e" == type){
		headTit = "Error";
		$(".cpt-popup.reg04.msgPop .error-btn-field .link-detail").show();
	}else if("i" == type){
		headTit = "정보";
		$(".cpt-popup.reg04.msgPop .error-msg-field").removeClass("on");
		$(".cpt-popup.reg04.msgPop .error-btn-field .link-detail").hide();
	}else if("l" == type){
		headTit = "정보";
		$(".cpt-popup.reg04.msgPop .error-msg-field").removeClass("on");
		$(".cpt-popup.reg04.msgPop .error-btn-field .link-detail").hide();
		$(".cpt-popup.reg04.msgPop input[name=returnUrl]").val(url);
	}else{
		headTit = "정보";
		$(".cpt-popup.reg04.msgPop .error-msg-field").removeClass("on");
		$(".cpt-popup.reg04.msgPop .error-btn-field .link-detail").hide();
	}
	
	$(".cpt-popup.reg04.msgPop .pop-head .error-head-tit").html(headTit);
	$(".cpt-popup.reg04.msgPop .error-tit-field .tit").html(tit);
	$(".cpt-popup.reg04.msgPop .error-msg-field").html(msg);
	msgPopOpen();
}

//업무 저장시 focus 처리 메세지
function fnFocAlert(tit,valFocObj){
	var headTit = "";
	headTit = "정보";

	$(".cpt-popup.reg04.msgPop .error-msg-field").removeClass("on");
	$(".cpt-popup.reg04.msgPop .error-btn-field .link-detail").hide();
	validateTargetObj = valFocObj;//index.jsp 선언
	
	$(".cpt-popup.reg04.msgPop .pop-head .error-head-tit").html(headTit);
	$(".cpt-popup.reg04.msgPop .error-tit-field .tit").html(tit);
	msgPopOpen();
}

//resultCode 99일때 메세지 표출
function setResultCode99Msg(data){
	fnAlert(data.result.resultMsg, data.result.exceptionCont, "e");
}

//AJAX 에러 메세지 세팅
function setAjaxErrorMsg(xhr){
//	$("#errorResponseText").html(xhr.responseJSON.exceptionCont);
//	var tit = "처리중 오류가 발생하였습니다.";
	fnAlert(xhr.responseJSON.exceptionMsg, xhr.responseJSON.exceptionCont, "e");
//	$("#errorResponseText").html("");
}

//메세지 팝업 열기
function msgPopOpen(){
	$(".cpt-popup.reg04.msgPop").addClass("active");
	$("body").css("overflow", "hidden");
	//$("button[name=alertCloseBtn]").focus();
}

//메세지 팝업 닫기
function msgPopClose() {
	$(".cpt-popup.reg04.msgPop").removeClass("active");
	$("body").css("overflow","auto");
	if($(".cpt-popup.reg04.msgPop input[name=returnUrl]").val() != ""){
		location.href = $(".cpt-popup.reg04.msgPop input[name=returnUrl]").val();
	}
	if(validateTargetObj){
		$(validateTargetObj).focus();
	}
	
	validateTargetObj = "";
}

//메세지 팝업 상세보기
function msgPopDtlOpenClose(){
	if($(".cpt-popup.reg04.msgPop .error-msg-field.on").length > 0){
		$(".cpt-popup.reg04.msgPop .error-msg-field").removeClass("on");
	}else{
		$(".cpt-popup.reg04.msgPop .error-msg-field").addClass("on");
	}
}

//AJAX 엑셀다운로드 중복호출 방지
var doubleSubmitFlag = false;
function doubleSubmitCheck(){
	if(doubleSubmitFlag){
		return doubleSubmitFlag;
	}else{
		doubleSubmitFlag = true;
		setTimeout(function(){doubleSubmitFlag = false; }, 1000);
		 
		return false;
	}
}

//바이트 수 계산
function fnGetByte(str){
	var byte = 0;
	for(var i=0;i<str.length;i++){
		if(str.charCodeAt(i)>127){
			byte+=3;
		}else{
			byte++;
		}
	}
	return byte;
}

//최대 등록 가능 길이
function fnGetTxtLength(length){
	return parseInt(length/3);
}

//리포트 서버로 요청
function commnReportReq(jrfnm, arg, gMenuSn){
		//jrfNm = "TrmvVlunPlan.jrf";//리포트 템플릿 파일명
		//arg = "MLTR_ID#20210012406";//파라미터

		var param = "jrfnm=" + jrfnm;
			param += "&arg=" + arg;
			param += "&gMenuSn=" + gMenuSn;

		var $json = getJsonData("post", "/report/RequestReport.kspo", param);
		
		if($json.statusText == "OK"){
			
			var jwtParam = $json.responseJSON.resultStr;
			
			if(jwtParam.length > 1){
				
				if($('#reportFrm').length > 0){
					$('#reportFrm').remove();
				}
				
				var formObj = $('<form>', {'id' : 'reportFrm'
											, 'action' : 'https://report.kspo.or.kr/rmssmng/report/ReportView.kspo'
											, 'method' : 'post'
											, 'target' : '_blank'});
				var inputObj = $('<input>', {'name' : 'param1'
												, 'type' : 'hidden'
												, 'value' : jwtParam});
												
				formObj.append(inputObj);
				$(document.body).append(formObj);
				$('#reportFrm').submit();
				
			}
			
		}
}