<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>

	<title>체육요원 복무관리시스템</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/default.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/layout.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/common.css">
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js?v=2"></script>
	
	<script type="text/javascript">
		//<![CDATA[
			$(document).ready(function() {
				
				$(document).on("keydown","#MNGR_ID",function(key){
					if (key.keyCode == 13) {
		
						$("#PASSWORD").focus();
					}
				});
				
				$(document).on("keydown","#PASSWORD",function(key){
					if (key.keyCode == 13) {
						loginAct();
					}
				});
				
				$(document).on("keydown","#pwFrm input[name=PASSWORD]",function(key){
					if (key.keyCode == 13) {
		
						$("#pwFrm input[name=PASSWORD_CHK]").focus();
					}
				});
				
				$(document).on("keydown","#pwFrm input[name=PASSWORD_CHK]",function(key){
					if (key.keyCode == 13) {
						updatePasswordChangeJs();
					}
				});
				
				$("#MNGR_ID").focus();
			});
			
			function loginValidateCheck(){
				
				if($("#MNGR_ID").val().trim() == ""){
					fnFocAlert("아이디를 입력하여 주시기 바랍니다.", $("#MNGR_ID"));
					return false;
				}
				
				if($("#PASSWORD").val().trim() == ""){
					fnFocAlert("비밀번호를 입력하여 주시기 바랍니다.", $("#PASSWORD"));
					return false;
				}
				return true;
			}
			
			function loginAct(){
				if(loginValidateCheck()){
					
					var $json = getJsonData("post", "/login/loginActJs.kspo", $("#frm").serialize());
					if($json.statusText == "OK"){
						var result = $json.responseJSON.result;
						if(result.resultCode == "0"){
							window.location.href = "${pageContext.request.contextPath}/index.kspo?gMenuSn=30";
						}else if(result.resultCode == "95"){
							$("#pwFrm input[name=MNGR_ID]").val($("#MNGR_ID").val());
							pwpopOpen();
							$("#pwFrm input[name=PASSWORD]").focus();
						}else{
							fnAlert(result.resultMsg);
						}
					}
				}
			}
			
			function pwpopOpen() {
				$(".cpt-popup.pw-change").addClass("active");
				$("body").css("overflow", "hidden");
			}
			
			function pwpopClose() {
				$(".cpt-popup.pw-change").removeClass("active");
				$("body").css("overflow","auto");
			}
			
			//신규계정신청 열기
			function privacyOpen(){
				$("#jFrm input[name=JOIN_MNGR_ID]").val("");
				$("#jFrm input[name=JOIN_PASSWORD]").val("");
				
		  		$(".cpt-popup.privacy").addClass("active")
		  		$("body").css("overflow", "hidden")
		  	}
			//신규계정신청 닫기
			function privacyClose() {
				$(".cpt-popup.privacy").removeClass("active");
				$("body").css("overflow","auto");
			}
			
			//회원가입 열기
			function joinOpen(){
				$("#jFrm input[name=JOIN_MNGR_ID]").val("");
				$("#jFrm input[name=JOIN_PASSWORD]").val("");
				
		  		$(".cpt-popup.reg03.join").addClass("active")
		  		$("body").css("overflow", "hidden")
		  	}
			
			//회원가입 닫기
			function joinClose() {
				
				$("#jFrm input[name=JOIN_MNGR_ID]").val("");
				$("#jFrm select[name=MEMORG_SN]").val("");
				$("#jFrm input[name=USE_YN]").val("N");
				$("#jFrm input[name=DEPT_NM]").val("");
				$("#jFrm input[name=MNGR_NM]").val("");
				$("#jFrm input[name=JOIN_PASSWORD]").val("");
				$("#jFrm input[name=JOIN_PASSWORD2]").val("");
				$("#jFrm input[name=TELNO]").val("");
				$("#jFrm input[name=CPNO]").val("");
				$("#jFrm input[name=EMAIL]").val("");
				$("#jFrm input[name=LOCGOV_NM]").val("");
				
				$(".cpt-popup.reg03.join").removeClass("active");
				$("body").css("overflow","auto");
				privacyClose();
			}
			
			//회원가입시 아이디 체크
			function fn_idCheck(){
				
				//var res1 = (/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/).test($("#jFrm input[name=JOIN_MNGR_ID]").val());
				//var res2 = ( /[~!@\#$%^&*\()\-=+_']/).test($("#jFrm input[name=JOIN_MNGR_ID]").val());
				var regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;

				if($("#jFrm input[name=JOIN_MNGR_ID]").val() == "" || $("#jFrm input[name=JOIN_MNGR_ID]").val() == null){
					fnFocAlert("아이디를 입력하시기 바랍니다.", $("#jFrm input[name=JOIN_MNGR_ID]"));
					return;
				}
				
				if(!regex.test($("#jFrm input[name=JOIN_MNGR_ID]").val())){
					fnFocAlert("아이디는 영문+숫자로 입력해 주세요.", $("#jFrm input[name=JOIN_MNGR_ID]"));
					return;
				}
				
				var saveUrl = "/login/selectIdCheckJs.kspo";
				
				var $json = getJsonData("post", saveUrl, $("#jFrm").serialize());
				if($json.statusText == "OK"){
					var result = $json.responseJSON.result;
					if(result.resultCode == "1"){
						fnAlert("이미 사용중인 아이디입니다.");
						$("#USE_YN").val("N");
						return;
					}else{
						fnAlert("사용가능한 아이디입니다.");
						$("#USE_YN").val("Y");
					}
				}
			}
			
			//계정신청
			function fn_joinSave(){
				
				if(fn_saveValid()){
					
					if(confirm("등록한 정보로 체육단체 사용자계정을 신청하시겠습니까?")){
						
						$('#jFrm select[name=CPNO1]').attr('disabled', false);
						$('#jFrm input[name=CPNO2]').attr('disabled', false);
						$('#jFrm input[name=CPNO3]').attr('disabled', false);
						$('#jFrm input[name=MNGR_NM]').attr('disabled', false);
						
						var saveUrl = "/login/insertJoinJs.kspo";
						var $json = getJsonData("post", saveUrl, $("#jFrm").serialize());
						if($json.statusText == "OK"){
							var result = $json.responseJSON.result;
							if(result.resultCode == "1"){
								fnAlert("이미 사용중인 아이디입니다. 다시 아이디입력해주세요.");
								return;
							}else if(result.resultCode == "2"){
								fnAlert("비밀번호가 서로 일치하지 않습니다.");
								return;
							}else if(result.resultCode == "3"){
								fnAlert("비밀번호는 10자리이상 영문+숫자+특수문자 조합 입니다.");
								return;
							}else if(result.resultCode == "4"){
								fnAlert("비밀번호에 공백이 있습니다 다시 작성해주세요.");
								return;
							}else if(result.resultCode == "5"){
								fnAlert("계정등록이 완료되지 않았습니다. 잠시후 다시시도해주세요.");
								return;
							}else{
								fnAlert("계정신청이 완료되었습니다. 관리자 승인 후 이용가능합니다.");
								joinClose();
							}
						}
					
					}
					
				}
				
			}

			function fn_saveValid(){
				
				//아이디
				if($("#jFrm input[name=JOIN_MNGR_ID]").val() == "" || $("#jFrm input[name=JOIN_MNGR_ID]").val() == null){
					fnAlert("아이디를 입력하시기 바랍니다.");
					$("#jFrm input[name=JOIN_MNGR_ID]").focus();
					return false;
				}
				
				var regexId = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
				
				if(!regexId.test($("#jFrm input[name=JOIN_MNGR_ID]").val())){
					fnFocAlert("아이디는 영문+숫자로 입력해 주세요.", $("#jFrm input[name=JOIN_MNGR_ID]"));
					return;
				}
				if($("#USE_YN").val() == "N"){
					fnAlert("아이디확인 후에 계정신청이 가능합니다.");
					return;
				}
				
				//부서
				if($("#jFrm input[name=DEPT_NM]").val() == "" || $("#jFrm input[name=DEPT_NM]").val() == null){
					fnFocAlert("부서명을 입력하시기 바랍니다.", $("#jFrm input[name=DEPT_NM]"));
					return;
				}
				if(fnGetByte($("#jFrm input[name=DEPT_NM]").val())>100){
					var length = fnGetTxtLength(100);
					fnFocAlert("부서 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#jFrm input[name=DEPT_NM]"));
					return;
				}
				
				//소속
				if($("#jFrm input[name=LOCGOV_NM]").val() == "" || $("#jFrm input[name=LOCGOV_NM]").val() == null){
					fnFocAlert("소속을 입력하시기 바랍니다.", $("#jFrm input[name=LOCGOV_NM]"));
					return;
				}
				if(fnGetByte($("#jFrm input[name=LOCGOV_NM]").val())>100){
					var length = fnGetTxtLength(100);
					fnFocAlert("소속 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#jFrm input[name=LOCGOV_NM]"));
					return;
				}
				
				//이름
				if($("#jFrm input[name=MNGR_NM]").val() == "" || $("#jFrm input[name=MNGR_NM]").val() == null){
					fnFocAlert("이름을 입력하시기 바랍니다.", $("#jFrm input[name=MNGR_NM]"));
					return;
				}
				if(fnGetByte($("#jFrm input[name=MNGR_NM]").val())>50){
					var length = fnGetTxtLength(50);
					fnFocAlert("이름 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#jFrm input[name=MNGR_NM]"));
					return;
				}
				
				//비밀번호
				var regexPw = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?^&])[A-Za-z\d$@$!%*#?^&]{10,}$/;
				if($("#jFrm input[name=JOIN_PASSWORD]").val() == "" || $("#jFrm input[name=JOIN_PASSWORD]").val() == null){
					
					fnFocAlert("비밀번호를 입력하시기 바랍니다.", $("#jFrm input[name=JOIN_PASSWORD]"));
					return;
					
				}else if($("#jFrm input[name=JOIN_PASSWORD2]").val() == ""){
					
					fnFocAlert("비밀번호 확인을 입력하여주시기 바랍니다.", $("#jFrm input[name=JOIN_PASSWORD2]"));
					return;
					
				}else if($("#jFrm input[name=JOIN_PASSWORD]").val() != $("#jFrm input[name=JOIN_PASSWORD2]").val()){
					
					fnFocAlert("비밀번호가 일치하지 않습니다.", $("#jFrm input[name=JOIN_PASSWORD]"));
					return;
					
				}else if(!regexPw.test($("#jFrm input[name=JOIN_PASSWORD]").val())){
					
					fnFocAlert("비밀번호 형식이 올바르지 않습니다.", $("#jFrm input[name=JOIN_PASSWORD]"));
					return;
					
				}else if($("#jFrm input[name=JOIN_PASSWORD]").val().length < 10){
					
					fnFocAlert("비밀번호는 10자리 이상 영문+숫자+특수문자 조합 입니다.", $("#jFrm input[name=JOIN_PASSWORD]"));
					return;
					
				}
				
				//체육단체
				if($("#jFrm select[name=MEMORG_SN]").val() == "" || $("#jFrm select[name=MEMORG_SN]").val() == null){
					fnFocAlert("체육단체를 선택하시기 바랍니다.", $("#jFrm select[name=MEMORG_SN]"));
					return;
				}
				
				//전화번호
				if($("#jFrm select[name=TELNO1]").val() == "" || $("#jFrm select[name=TELNO1]").val() == null
						|| $("#jFrm input[name=TELNO2]").val() == "" || $("#jFrm input[name=TELNO2]").val() == null
						|| $("#jFrm input[name=TELNO3]").val() == "" || $("#jFrm input[name=TELNO3]").val() == null ){
					fnAlert("전화번호를 입력하시기 바랍니다.");
					return false;
				}
				
				//이메일
				if($("#jFrm input[name=EMAIL1]").val() == "" || $("#jFrm input[name=EMAIL1]").val() == null || $("#jFrm input[name=EMAIL2]").val() == "" || $("#jFrm input[name=EMAIL2]").val() == null ){
					fnFocAlert("이메일 입력하시기 바랍니다.", $("#jFrm select[name=EMAIL1]"));
					return;
				}
				
				return true;
			}

			//본인인증
			function ownCert(type){
				
				if(type == "new"){
					if (!$("#ownFrm input:checkbox[name=check001]").is(":checked")) {
						fnAlert("이용약관에 동의 후에 본인인증이 가능합니다.");
						return;
					}
				}else if(type == "mngrInfo"){
					//이름
					if($("#mngrInfoFrm input[name=MNGR_NM]").val() == "" || $("#mngrInfoFrm input[name=MNGR_NM]").val() == null){
						fnAlert("이름을 입력하시기 바랍니다.");
						$("#mngrInfoFrm input[name=MNGR_NM]").focus();
						return false;
					}
					//체육단체
					if($("#mngrInfoFrm select[name=MEMORG_SN]").val() == "" || $("#mngrInfoFrm select[name=MEMORG_SN]").val() == null){
						fnAlert("체육단체를 선택하시기 바랍니다.");
						$("#mngrInfoFrm select[name=MEMORG_SN]").focus();
						return false;
					}
					//휴대폰번호
					if($("#mngrInfoFrm select[name=CPNO1]").val() == "" || $("#mngrInfoFrm select[name=CPNO1]").val() == null
							|| $("#mngrInfoFrm input[name=CPNO2]").val() == "" || $("#mngrInfoFrm input[name=CPNO2]").val() == null
							|| $("#mngrInfoFrm input[name=CPNO3]").val() == "" || $("#mngrInfoFrm input[name=CPNO3]").val() == null ){
						fnAlert("휴대폰번호를 입력하시기 바랍니다.");
						return false;
					}
					
					//이미 가입된 회원인지 체크
					var saveUrl = "/login/selectAccountInfoJs.kspo";
					var $json = getJsonData("post", saveUrl, $("#mngrInfoFrm").serialize());
					
					if($json.statusText == "OK"){
						var result = $json.responseJSON.result;
						if(result.resultCode == "1" ){
							
							fnAlert("조회하신 정보와 일치하는 계정이 없습니다.");
							return;
							
						}else if(result.resultCode == "0"){
							
						}
					}
					
				}
				
				window.open("/owncert/checkplusMain.kspo?returnType="+type+"&gMenuSn="+$("#jFrm input[name=gMenuSn]").val(), "pop", "width=570, height=420, scrollbars=yes, resizable=yes");
			}
			
			//본인인증 후 콜백함수
			function certSuccess(type, certNm,CPNO1,CPNO2,CPNO3) {
				
				if(type == 'new'){
					
					//이미 가입된 회원인지 체크
					var saveUrl = "/login/selectAccountCICheckJs.kspo";
					var param = "";
					var $json = getJsonData("post", saveUrl, param);
					
					if($json.statusText == "OK"){
						var result = $json.responseJSON.result;
						
						if(result.resultCode == "1"){
							fnAlert("이미 등록된 사용자 계정이 있거나, 탈퇴한지 3개월이 지나지 않은 계정이 있습니다. 관리자에게 문의바랍니다.");
							privacyClose();
						}else if(result.resultCode == "0" ){
							$("#jFrm input[name=MNGR_NM]").val(certNm);
							$("#jFrm select[name=CPNO1]").val(CPNO1);
							$("#jFrm input[name=CPNO2]").val(CPNO2);
							$("#jFrm input[name=CPNO3]").val(CPNO3);
							$('#jFrm select[name=CPNO1]').attr('disabled', true);
							joinOpen();
						}
					}
					
				}else if(type == 'mngrInfo'){
					
					//이미 가입된 회원인지 체크
					var saveUrl = "/login/selectMngrInfoPwResetJs.kspo";
					var param = "";
					var $json = getJsonData("post", saveUrl, param);
					
					if($json.statusText == "OK"){
						
						var result = $json.responseJSON.result;
						
						if(result.resultCode == "0"){
							fnAlert("등록된 휴대전화로 임시비밀번호를 전송했습니다.");
						}else if(result.resultCode == "1" ){
							fnAlert("조회하신 정보와 일치하는 계정이 없습니다.");
						}
						
					}
					
					mngrInfoClose();
					
				}
				
			}
			
			//계정찾기
			function mngrInfo(){
		  		$(".cpt-popup.mngrInfo").addClass("active")
		  		$("body").css("overflow", "hidden")
		  		
		  	}

			//계정찾기
			function mngrInfoClose(){
		  		$(".cpt-popup.mngrInfo").removeClass("active");
				$("body").css("overflow","auto");
		  		
		  	}
			
		//]]>
		</script>
	
</head>

<body class="thema-typeB">
	<form id="frm" name="frm" method="post">
		<div class="cpt-loginB">
		    <div class="login-box">
		        <div class="lg-tit">
		            <img src="/common/images/common/logo_kspo.png" alt="KSPO">
		            <h1>체육요원 <b>복무관리시스템</b></h1>
		        </div>
		        <div class="lg-form">
		            <input type="text" class="lg-id" id="MNGR_ID" name="MNGR_ID" value="${idSave}" placeholder="아이디"/>
		            <input type="password" class="lg-pw" id="PASSWORD" name="PASSWORD" placeholder="비밀번호"/>
<!-- 		            <div class="lg-ck"> -->
<%-- 		                <input type="checkbox" class="lg-ck" id="login-check" name="idSave" value="Y" <c:if test="${not empty idSave}">checked="checked"</c:if>> --%>
<!-- 						<label for="login-check">아이디 저장</label> -->
<!-- 		            </div> -->
		        </div>
		        <button class="lg-btn" type="button" onclick="loginAct();">로그인</button>
		        <div class="lg-alert">
		            <ul class="alert-group">
		                <li class="item">체육단체 신규 사용자는 계정을 신청하세요.</li>
		                <li class="item">공단 사용자는 시스템관리자에게 문의주세요.</li>
		            </ul>
		        </div>
		        <div class="lg-etc">
		            <ul class="btn-group">
		                <li class="unit">
		                    <a href="javascript:privacyOpen();">신규계정 신청하기</a>
		                </li>
		                <li class="unit">
		                    <a href="javascript:mngrInfo();">사용자 계정조회</a>
		                </li>
		            </ul>
		        </div>
		    </div>
		    <div class="login-copy">
		        05540 서울시 송파구 올림픽로 424 올림픽문화센터(올림픽컨벤션센터)<span> | TEL 02-410-1114 </span><span> | FAX 02-410-1219 </span>
		        <p>COPYRIGHT © 2021 국민체육진흥공단. ALL RIGHT RESERVED.</p>
		    </div>
		</div>
	</form>

	<!-- 팝업영역 - 개인정보 활용동의 -->
	<div class="cpt-popup privacy"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup" style="width: 650px;">
	        <div class="pop-head">
	            체육단체 신규계정신청
	            <button class="pop-close" onclick="privacyClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body" style="padding: 45px;">
	            <div class="com-h3 add">회원약관 및 개인정보보호 활용동의</div>
	
	            <div class="com-table">
	                <table class="table-board">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width:100%;">
	                    </colgroup>
	                    <tbody>
	                        <tr>
	                            <td class="input-td"><textarea rows="10" disabled>제 1 장 총칙

제 1 조 (목적)

본 약관은 국민체육진흥공단 체육요원복무관리시스템이 제공하는 모든 서비스(이하 "서비스")의 이용조건 및 절차, 이용자와 체육요원복무관리시스템의 권리, 의무, 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다.

제 2 조 (약관의 효력과 변경)

① 체육요원복무관리시스템은 귀하가 본 약관 내용에 동의하는 경우, 체육요원복무관리시스템의 서비스 제공 행위 및 귀하의 서비스 사용 행위에 본 약관이 우선적으로 적용됩니다.
② 체육요원복무관리시스템은 본 약관을 사전 고지 없이 변경할 수 있으며, 변경된 약관은 체육요원복무관리시스템 내에 공지하거나 e-mail을 통해 회원에게 공지하며, 공지와 동시에 그 효력이 발생됩니다.
③ 회원이 변경된 약관에 동의하지 않는 경우, 본인의 회원등록을 취소(회원탈퇴)할 수 있으며 계속 사용의 경우는 약관 변경에 대한 동의로 간주됩니다.
④ 본 약관에 명시되지 않은 사항은 전기통신기본법, 전기통신사업법, 정보통신윤리위원회 심의규정, 정보통신 윤리강령, 프로그램보호법 및 기타 관련 법령의 규정에 의합니다.

제 3 조 (용어의 정의)
① 이용계약 : 서비스 이용과 관련하여 체육요원복무관리시스템과 이용자 간에 체결하는 계약
② 가입 : 체육요원복무관리시스템이 제공하는 양식에 해당 정보를 기입하고, 본 약관에 동의하여 서비스 이용계약을 완료시키는 행위
③ 회원 : 체육요원복무관리시스템에 개인 정보를 제공하여 회원 등록을 한 자로서 체육요원복무관리시스템이 제공하는 서비스를 이용할 수 있는 자
④ 아이디(ID) : 이용고객의 식별과 이용자가 서비스 이용을 위하여 이용자가 선정하고 당 사이트가 부여하는 문자와 숫자의 조합
⑤ 비밀번호 : 이용자와 회원ID가 일치하는지를 확인하고 통신상의 자신의 비밀보호를 위하여 이용자 자신이 선정한 문자와 숫자의 조합
⑥ 게시물 : 회원이 서비스를 이용하면서 게시한 글, 이미지 등 각종 파일과 링크 등
⑦ 탈퇴 : 회원이 이용계약을 종료시키는 행위

제 2 장 서비스 제공 및 이용

제 4 조 (이용계약의 성립 및 탈퇴)
① 이용계약은 신청자가 온라인으로 체육요원복무관리시스템에서 제공하는 소정의 가입신청 양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다.
② 체육요원복무관리시스템은 다음 각 호에 해당하는 이용계약에 대하여는 가입을 취소할 수 있습니다. 
1. 다른 사람의 명의를 사용하여 신청하였을 때 
2. 이용계약 신청서의 내용을 허위로 기재하였거나 신청하였을 때 
3. 다른 사람의 체육요원복무관리시스템 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 때 
4. 체육요원복무관리시스템을 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우
5. 기타 체육요원복무관리시스템이 정한 이용신청요건이 미비 되었을 때

제 5 조 (회원정보 사용에 대한 동의)
① 회원의 개인정보는 공공기관의 개인정보보호에 관한 법률에 의해 보호됩니다.
② 체육요원복무관리시스템의 회원 정보는 다음과 같이 사용, 관리, 보호됩니다.
1. 개인정보의 수집 : 체육요원복무관리시스템은 회원이 체육요원복무관리시스템 서비스 가입 시 제공하는 정보를 통하여 정보를 수집합니다.
2. 개인정보의 사용 : 체육요원복무관리시스템은 서비스 제공과 관련해서 수집된 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 단, 전기통신기본법 등 법률의 규정에 의해 국가기관의 요구가 있는 경우, 범죄에 대한 수사상의 목적이 있거나 정보통신윤리위원회의 요청이 있는 경우 또는 기타 관계법령에서 정한 절차에 따른 요청이 있는 경우, 귀하가 체육요원복무관리시스템에 제공한 개인정보를 스스로 공개한 경우에는 그러하지 않습니다.
3. 개인정보의 관리 : 귀하는 개인정보의 보호 및 관리를 위하여 서비스의 개인정보관리에서 수시로 귀하의 개인정보를 수정/삭제할 수 있습니다.
4. 개인정보의 보호 : 귀하의 개인정보는 오직 귀하만이 열람/수정/삭제 할 수 있으며, 이는 전적으로 귀하의 ID와 비밀번호에 의해 관리되고 있습니다. 따라서 타인에게 본인의 ID와 비밀번호를 알려주어서는 안 되며, 작업 종료 시에는 반드시 로그아웃 해주시기 바랍니다.

③ 회원이 본 약관에 따라 이용신청을 하는 것은, 체육요원복무관리시스템이 신청서에 기재된 회원정보를 수집, 이용하는 것에 동의하는 것으로 간주됩니다.

제 6 조 (사용자의 정보 보안)
① 가입 신청자가 체육요원복무관리시스템 서비스 가입 절차를 완료하는 순간부터 귀하는 입력한 정보의 비밀을 유지할 책임이 있으며, 회원의 ID와 비밀번호를 사용하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있습니다.
② ID와 비밀번호에 관한 모든 관리의 책임은 회원에게 있으며, 회원의 ID나 비밀번호가 부정하게 사용되었다는 사실을 발견한 경우에는 즉시 체육요원복무관리시스템에 신고하여야 합니다. 신고를 하지 않음으로 인한 모든 책임은 회원 본인에게 있습니다.
③ 이용자는 체육요원복무관리시스템 서비스의 사용 종료 시마다 정확히 접속을 종료해야 하며, 정확히 종료하지 아니함으로써 제3자가 귀하에 관한 정보를 이용하게 되는 등의 결과로 인해 발생하는 손해 및 손실에 대하여 체육요원복무관리시스템은 책임을 부담하지 아니합니다.

제 7 조 (서비스의 중지)
① 체육요원복무관리시스템은 이용자가 본 약관의 내용에 위배되는 행동을 한 경우, 임의로 서비스 사용을 제한 및 중지할 수 있습니다.
② 체육요원복무관리시스템이 통제할 수 없는 사유로 인한 서비스중단의 경우(시스템관리자의 고의, 과실 없는 디스크장애, 시스템다운 등)에 사전통지가 불가능하며 타인(통신회사, 기간통신사업자 등)의 고의, 과실로 인한 시스템중단 등의 경우에는 통지하지 않습니다.
③ 긴급한 시스템 점검, 증설 및 교체 등 부득이한 사유로 인하여 예고 없이 일시적으로 서비스를 중단할 수 있으며, 새로운 서비스로의 교체 등 당 사이트가 적절하다고 판단하는 사유에 의하여 현재 제공되는 서비스를 완전히 중단할 수 있습니다.
④ 국가비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 제공이 불가능할 경우, 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다. 다만 이 경우 그 사유 및 기간 등을 이용자에게 사전 또는 사후에 공지합니다.

제 8 조 (서비스의 변경 및 해지)
① 체육요원복무관리시스템은 귀하가 서비스를 이용하여 기대하는 손익이나 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지 않으며, 회원이 본 서비스에 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관하여는 책임을 지지 않습니다.
② 체육요원복무관리시스템은 서비스 이용과 관련하여 가입자에게 발생한 손해 중 가입자의 고의, 과실에 의한 손해에 대하여 책임을 부담하지 아니합니다.

제 9 조 (정보 제공 및 홍보물 게재)
① 체육요원복무관리시스템은 서비스를 운영함에 있어서 각종 정보를 체육요원복무관리시스템에 게재하는 방법, 전자우편이나 서신우편, 문자메시지 발송 등으로 회원에게 제공할 수 있습니다.
② 체육요원복무관리시스템은 서비스에 적절하다고 판단되거나 공익성이 있는 홍보물을 게재할 수 있습니다.

제 10 조 (게시물의 저작권)
① 귀하가 게시한 게시물의 내용에 대한 권리는 귀하에게 있습니다.
② 체육요원복무관리시스템은 게시된 내용을 사전 통지 없이 편집, 이동할 수 있는 권리를 보유하며, 게시물운영원칙에 따라 사전 통지 없이 삭제할 수 있습니다.

③ 귀하의 게시물이 타인의 저작권을 침해함으로써 발생하는 민, 형사상의 책임은 전적으로 귀하가 부담하여야 합니다.
제 3 장 의무 및 책임

제 11 조 (체육요원복무관리시스템의 의무)
체육요원복무관리시스템은 회원의 개인 신상 정보를 본인의 승낙 없이 타인에게 누설, 배포하지 않습니다. 다만, 전기통신관련법령 등 관계법령에 의하여 관계 국가기관 등의 요구가 있는 경우에는 그러하지 아니합니다.
제 12 조 (회원의 의무)
① 회원은 당 사이트의 사전 승낙 없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.
② 회원 가입 시에 요구되는 정보는 정확하게 기입하여야 합니다. 또한 이미 제공된 귀하에 대한 정보가 정확한 정보가 되도록 유지, 갱신하여야 하며, 회원은 자신의 ID 및 비밀번호를 제3자가 이용하게 해서는 안 됩니다.
③ 회원은 당 사이트 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안 됩니다. 다른 회원의 비밀번호와 ID를 도용하여 부정 사용하는 행위
④ 저속, 음란, 모욕적, 위협적이거나 타인의 사생활를 침해할 수 있는 내용을 전송, 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위 
⑤ 서비스를 통하여 전송된 내용의 출처를 위장하는 행위
⑥ 법률, 계약에 의해 이용할 수 없는 내용을 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위
⑦ 타인의 특허, 상표, 영업비밀, 저작권, 기타 지적재산권을 침해하는 내용을 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위
⑧ 당 사이트의 승인을 받지 아니한 광고, 판촉물, 스팸메일, 행운의 편지, 피라미드 조직, 기타 다른 형태의 권유를 게시, 게재, 전자우편 또는 기타의 방법으로 전송하는 행위
⑨ 다른 사용자의 개인정보를 수립 또는 저장하는 행위
⑩ 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위
⑪ 선량한 풍속, 기타 사회질서를 해하는 행위
⑫ 타인의 명예를 훼손하거나 모욕하는 행위
⑬ 타인의 지적재산권 등의 권리를 침해하는 행위
⑭ 해킹행위 또는 컴퓨터바이러스의 유포행위
⑮ 타인의 의사에 반하여 광고성 정보 등 일정한 내용을 지속적으로 전송하는 행위
⑯ 서비스의 안전적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위
⑰ 당 사이트에 게시된 정보의 변경
⑱ 기타 전기통신사업법 제53조 제1항과 전기통신사업법 시행령 16조(불온통신)에 위배되는 행위

제 4 장 기타

제 13 조 (양도금지)
회원이 서비스의 이용권한, 기타 이용계약 상 지위를 타인에게 양도, 증여할 수 없습니다.

제 14 조 (손해배상)
체육요원복무관리시스템은 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 체육요원복무관리시스템이 고의로 행한 범죄행위를 제외하고 이에 대하여 책임을 부담하지 아니합니다.

제 15 조 (면책조항)
① 체육요원복무관리시스템은 천재지변, 전쟁 및 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다.
② 체육요원복무관리시스템은 기간통신 사업자가 전기통신 서비스를 중지하거나 정상적으로 제공하지 아니하여 손해가 발생한 경우 책임이 면제됩니다.
③ 체육요원복무관리시스템은 서비스용 설비의 보수, 교체, 정기점검, 공사 등 부득이한 사유로 발생한 손해에 대한 책임이 면제됩니다.
④ 체육요원복무관리시스템은 이용자의 컴퓨터 오류에 의해 손해가 발생한 경우, 또는 회원이 신상정보 및 전자우편 주소를 부실하게 기재하여 손해가 발생한 경우 책임을 지지 않습니다.
⑤ 체육요원복무관리시스템은 서비스에 표출된 어떠한 의견이나 정보에 대해 확신이나 대표할 의무가 없으며 회원이나 제3자에 의해 표출된 의견을 승인하거나 반대하거나 수정하지 않습니다. 체육요원복무관리시스템은 어떠한 경우라도 회원의 서비스에 담긴 정보에 의존해 얻은 이득이나 입은 손해에 대해 책임이 없습니다.
⑥ 체육요원복무관리시스템은 회원 간 또는 회원과 제3자 간에 서비스를 매개로 하여 물품거래 혹은 금전적 거래 등과 관련하여 어떠한 책임도 부담하지 아니하고, 회원이 서비스의 이용과 관련하여 기대하는 이익에 관하여 책임을 부담하지 않습니다.
⑦ 체육요원복무관리시스템은 이용자가 서비스를 이용하여 기대하는 손익이나 서비스를 통하여 얻은 자료로 인한 손해에 관하여 책임을 지지 않으며, 회원이 본 서비스에 게재한 정보, 자료, 사실의 신뢰도 등 내용에 관하여는 책임을 지지 않습니다.
⑧ 체육요원복무관리시스템은 서비스 이용과 관련하여 이용자에게 발생한 손해 중 이용자의 고의, 과실에 의한 손해에 대하여 책임을 부담하지 아니합니다.
⑨ 체육요원복무관리시스템은 체육요원복무관리시스템이 제공한 서비스가 아닌 가입자 또는 기타 유관기관이 제공하는 서비스의 내용상의 정확성, 완전성 및 질에 대하여 보장하지 않습니다. 따라서 체육요원복무관리시스템은 이용자가 위의 내용을 이용함으로 인하여 입게 된 모든 종류의 손실이나 손해에 대하여 책임을 부담하지 아니합니다. 또한 체육요원복무관리시스템은 이용자가 서비스를 이용하며 타 이용자로 인해 입게 되는 정신적 피해에 대하여 보상할 책임을 지지 않습니다.

제 16 조 (재판관할)

체육요원복무관리시스템과 이용자 간에 발생한 서비스 이용에 관한 분쟁에 대하여는 대한민국 법을 적용하며, 본 분쟁으로 인한 소는 대한민국의 법원에 제기합니다.</textarea></td>
	                        </tr>
	                        <tr>
	                            <td class="input-td"><textarea rows="10" disabled>1. 개인정보 수집 및 이용 목적
서울올림픽기념국민체육진흥공단 체육요원복무관리시스템은 아래와 같은 목적으로 개인정보를 수집·이용합니다.
가. 회원가입, 회원활동 실적 관리, 회원탈퇴 의사 확인 등 회원관리
나. 가맹단체에 소속된 체육요원의 복무 활동 관리 
다. 분쟁 조정을 위한 기록보존, 고지사항 전달 등
									
2. 수집하는 항목
가. 필수정보: 아이디, 비밀번호, 성명, 휴대폰번호, 관련체육시설정보
나. 선택정보: 이메일
다. 서비스 이용 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
ㅇ 접속로그, 접속IP정보, 방문 일시, 서비스 이용기록을 기록
									
3. 개인정보 처리 위탁
가. 개인정보 취급위탁을 받는 자 : 이벤트 경품 발송 및 배송업체
나. 제인정보를 제공받는 자의 개인정보 이용 목적
- 홈페이지 이벤트 참여 후 이벤트 경품 발송 및 배송을 위한 자료로 활용한다. 
다. 개인정보를 제공받는 자의 개인정보 보유 및 이용기간
- 이용자의 개인정보는 3개월 동안 보유 및 이용하며, 원칙적으로 개인정보의 수집 및 이용목적 달성 시 지체없이 파기함
									
4. 개인정보의 보유 및 이용기간
이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 따라서 최종 로그인 후 1년이 경과하였거나 회원 탈퇴 신청 시 회원의 개인정보를 지체 없이 파기합니다.
									
5. 동의 거부 권리 사실 및 불이익 내용
이용자는 동의를 거부할 권리가 있습니다. 동의를 거부할 경우에는 서비스 이용에 제한(회원가입불가)됨을 알려드립니다.</textarea></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <form id="ownFrm" name="ownFrm" method="post" onsubmit="return false;">
		            <p class="com-text normal" style="margin:-30px 0 30px;">
		                <input id="check001" name="check001" type="checkbox" /><label for="check001">위 이용약관에 동의합니다.</label>
		            </p>
				</form>
	            <div class="com-btn-group center">
	                <button class="btn red write" type="button" onclick="ownCert('new');return false;">본인인증</button>
	            </div>
	            
	        </div>
	    </div>
	</div>
	<!-- //팝업영역 -->

	<!-- 팝업영역 -->
	<form id="jFrm" name="jFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="USE_YN" name="USE_YN" value="N">
		<input type="hidden" id="GRP_SN" name="GRP_SN" value="2">
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
		<div class="cpt-popup reg03 join"> <!-- class:active 팝업 on/off -->
		    <div class="dim"></div>
		    <div class="popup">
		        <div class="pop-head">
		            체육단체 신규계정신청
		            <button class="pop-close" onclick="joinClose();">
		                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
		            </button>
		        </div>
		        <div class="pop-body">
		            <div class="com-h3 add">사용자정보
		                <div class="right-area"><p class="required">필수입력</p></div>
		            </div>
		
		            <div class="com-table">
		                <table class="table-board">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width:170px;">
		                        <col style="width:auto;">
		                        <col style="width:130px;">
		                        <col style="width:auto;">
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <td class="t-title">체육단체<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                                <select id="MEMORG_SN" name="MEMORG_SN" class="tab-sel">
					                        <option value="" <c:if test="${param.MEMORG_SN eq '' or param.MEMORG_SN eq null}">selected="selected"</c:if>>전체</option>
											<c:forEach items="${memOrgSelect}" var="moLi">
												<option value="${moLi.MEMORG_SN}" <c:if test="${param.MEMORG_SN eq moLi.MEMORG_SN}">selected="selected"</c:if>>${moLi.MEMORG_NM}</option>
											</c:forEach>
					                    </select>
		                            </td>
		                            <td class="t-title">부서<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="DEPT_NM"></td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">이름<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="MNGR_NM" disabled></td>
		                            <td class="t-title">소속<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="LOCGOV_NM"></td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">아이디<span class="t-red"> *</span></td>
		                            <td colspan="3" class="input-td">
		                                <input type="text" class="smal" name="JOIN_MNGR_ID">
		                                <button class="btn red write" onclick="fn_idCheck();return false;">아이디 확인</button>
		                                <span class="t-red"> ※ 영문소문자, 숫자를 사용하여  6~12자 혼합사용</span>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">비밀번호<span class="t-red"> *</span></td>
		                            <td colspan="3" class="input-td">
		                                <input type="password" class="smal" name="JOIN_PASSWORD">
		                                <span class="t-red"> ※ 영문, 숫자, 특수문자를 조합하여 최소 10자리 이상 </span>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">비밀번호 재확인<span class="t-red"> *</span></td>
		                            <td colspan="3" class="input-td">
		                                <input type="password" class="smal" name="JOIN_PASSWORD2">
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">전화<span class="t-red"> *</span></td>
		                            <td class="input-td type03">
		                                <select id="TELNO1" name="TELNO1" class="">
		                                    <option value="">선택</option>
		                                    <c:forEach items="${telList}" var="subLi">
												<option value="${subLi.CNTNT_FST}" <c:if test="${param.TELNO1 eq subLi.CNTNT_FST}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
											</c:forEach>
		                                </select>
		                                <span>-</span>
		                                <input type="text" title="휴대전화 중간자리 입력" name="TELNO2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		                                <span>-</span>
		                                <input type="text" title="휴대전화 뒷자리 입력" name="TELNO3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		                            </td>
		                            <td class="t-title">휴대폰</td>
		                            <td class="input-td type03">
		                                <select id="CPNO1" name="CPNO1" class="">
		                                    <option value="">선택</option>
											<c:forEach items="${telList}" var="subLi">
												<option value="${subLi.CNTNT_FST}" <c:if test="${param.CPNO1 eq subLi.CNTNT_FST}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
											</c:forEach>
		                                </select>
		                                <span>-</span> 
		                                <input type="text" title="휴대전화 중간자리 입력" name="CPNO2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" disabled>
		                                <span>-</span>
		                                <input type="text" title="휴대전화 뒷자리 입력" name="CPNO3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" disabled>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">이메일<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<div class="email-box">
		                                    <input type="text" name="EMAIL1">
		                                    <span class="text">@</span>
		                                    <input type="text" name="EMAIL2">
		                                </div>
		                            </td>
		                            <td class="t-title"></td>
		                            <td class="input-td"></td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
		
		            <div class="com-caution line" style="margin-top:-30px;">
		                <div class="float-l">
		                    <div class="message">체육단체 사용자계정을 신청하면 관리자의 승인 후에 이용할 수 있습니다.</div>
		                </div>
		            </div>
		
		            <div class="com-btn-group center">
						<button class="btn red write" type="button" onclick="fn_joinSave();">계정신청</button>
		            </div>
		            
		        </div>
		    </div>
		</div>
	</form>
	<!-- //팝업영역 -->
	
	<!-- 팝업영역 -->
	<div class="cpt-popup mngrInfo">
	    <div class="dim"></div>
	    <div class="popup" style="width: 650px;">
	        <div class="pop-head">
	            체육단체 계정조회
	            <button class="pop-close" onclick="mngrInfoClose();">
	                <img src="/common/images/common/icon_close.png" alt="">
	            </button>
	        </div>
	        <div class="pop-body" style="padding: 45px;">
	            
	            <div class="com-h3 add">사용자계정 조회
	                <div class="right-area"><p class="required">필수입력</p></div>
	            </div>
	
				<form id="mngrInfoFrm" name="mngrInfoFrm" method="post" onsubmit="return false;">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
		            <div class="com-table">
		                <table class="table-board">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width:130px;">
		                        <col style="width:auto;">
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <td class="t-title">체육단체<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                                <select id="MEMORG_SN" name="MEMORG_SN" class="tab-sel">
					                        <option value="" <c:if test="${param.MEMORG_SN eq '' or param.MEMORG_SN eq null}">selected="selected"</c:if>>전체</option>
											<c:forEach items="${memOrgSelect}" var="moLi">
												<option value="${moLi.MEMORG_SN}" <c:if test="${param.MEMORG_SN eq moLi.MEMORG_SN}">selected="selected"</c:if>>${moLi.MEMORG_NM}</option>
											</c:forEach>
					                    </select>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">이름<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="MNGR_NM"></td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">휴대폰<span class="t-red"> *</span></td>
		                            <td class="input-td type03">
										<select id="CPNO1" name="CPNO1" class="">
		                                	<option value="">선택</option>
											<c:forEach items="${telList}" var="subLi">
												<option value="${subLi.CNTNT_FST}">${subLi.CNTNT_FST}</option>
											</c:forEach>
		                                </select>
		                                <span>-</span> 
		                                <input type="text" title="휴대전화 중간자리 입력" name="CPNO2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		                                <span>-</span>
		                                <input type="text" title="휴대전화 뒷자리 입력" name="CPNO3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
				</form>
	
	            <div class="com-btn-group center">
	                <button class="btn navy rmvcrr" type="button" onclick="ownCert('mngrInfo');return false;">본인인증</button>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- //팝업영역 -->
	
	<!-- 210226 추가 : 오류 팝업 영역 추가 -->
	<div class="cpt-popup reg04 msgPop">
		<!-- class:active 팝업 on/off -->
		<div class="dim"></div>
		<div class="popup">
			<input type="hidden" name="returnUrl">
			<div class="pop-head">
				<p class="error-head-tit">Error</p>
				<button class="pop-close" type="button" onclick="msgPopClose()">
					<img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
				</button>
			</div>
			<div class="pop-body">
				<div class="error-tit-field">
					<div class="tit">
						<strong>오류관련 컨텐츠 영역</strong>
					</div>
				</div>
				<div class="error-btn-field">
					<a href="javascript:msgPopDtlOpenClose();" class="link-detail">
						<span class="arrow">>></span>자세히보기
					</a>
					<button type="button" class="btn save" onclick="msgPopClose();">확인</button>
				</div>
				<!-- 오류 상세내용 영역 -->
				<div class="error-msg-field" style="height: 300px;">
					<!-- 210226 수정 : 필요 시 height 값 조정 -->
					ERROR LOG EXAMPLE<br> ERROR LOG EXAMPLE<br> ERROR LOG
					EXAMPLE<br> ERROR LOG EXAMPLE<br> ERROR LOG EXAMPLE<br>
					ERROR LOG EXAMPLE<br> ERROR LOG EXAMPLE<br> ERROR LOG
					EXAMPLE<br> ERROR LOG EXAMPLE<br> ERROR LOG EXAMPLE<br>
					ERROR LOG EXAMPLE<br> ERROR LOG EXAMPLE<br>
				</div>
				<!-- //오류 상세내용 영역 -->
			</div>
		</div>
	</div>
	<!-- //210226 추가 : 오류 팝업 영역 추가 -->
	
	<div id="errorResponseText" style="display: none;"></div>
	
</body>
</html>
