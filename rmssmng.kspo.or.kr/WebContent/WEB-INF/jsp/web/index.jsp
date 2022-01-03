<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>

<title>체육요원 복무관리시스템</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/jquery-ui.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/jquery-ui.theme.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/swiper.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/rateit.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/default.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/common.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery-3.4.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/swiper.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery.rateit.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/script.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js?v=2"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery.form.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery-ui.min.js"></script>

</head>
<body class="thema-typeB">
	<script type="text/javascript">
		//새로고침시 datepicker 달력표시 이벤트 안되는문제로 주석
		//window.onkeydown = function(){
		//	var kcode = event.keyCode;
		//	if((event.ctrlKey == true &&(event.keyCode == 78 || event.keyCode == 82))
		//			|| (event.ctrlKey == true && event.shiftKey == true && (event.keyCode == 82))
		//			|| (kcode == 116)){
		//		event.ketCode = 0;
		//		event.cancelBubble = true;
		//		event.returnValue = false;
		//		pageReload();
		//		
		//	}
		//}
		//<![CDATA[	
		
		$(document).ready(function(){
			fn_start();
		}).ajaxStart(function(){
			$(".loading-group").addClass("on");
		}).ajaxStop(function(){
			$(".loading-group").removeClass("on");
		});
		
		
		var grpSn = "${sessionScope.userMap.GRP_SN}";
		
		//로그아웃
		function fnLogout(){
			location.href = "${pageContext.request.contextPath}/login/logout.kspo";
		}

	  	//타임아웃 로그아웃
	  	fnTimeOut = function(){
	  		fnLogout();
	  	}

	  	// 3시간
	  	setInterval(fnTimeOut, 10800000);
	  	
		//시작시 호출
	  	function fn_start(){
	  		
	  		var gMenuSn = $(".menu-item").eq(0).find("a").data("menusn");
	  		var menuUrl = $(".menu-item").eq(0).find("a").data("menuurl");
	  		$("#pageLoadFrm input[name=gMenuSn]").val(gMenuSn);
	  		fnPageLoad("${pageContext.request.contextPath}" + menuUrl,$("#pageLoadFrm").serialize());
  			$('.menu-item').removeClass('on');
	        $('.sub-menu li a').removeClass('on');
  			$(".menu-item").eq(0).addClass("on");
	  		
	  	}

	  	//메뉴 선택시 페이지 이동
	  	function fn_movePage(menuUrl,gMenuSn){
	  		$("#pageLoadFrm input[name=gMenuSn]").val(gMenuSn);
	  		fnPageLoad("${pageContext.request.contextPath}" + menuUrl,$("#pageLoadFrm").serialize());
	  	}
	  	
		//새로고침
		function pageReload(){
			fnPageLoad($("#pageInfoFrm input[name=url]").val(),$("#pageInfoFrm input[name=param]").val());
  			fnNoticeLoad();
		}

		//시작시 또는 새로고침시 공지사항 재호출
		function fnNoticeLoad(){
			var param = "gMenuSn=21"
			var $json = getJsonData("post", "${pageContext.request.contextPath}/notice/selectTopNoticeListJs.kspo", param);
			
			var dtlObj = "";
			if($json.statusText == "OK"){
				var noticeList = $json.responseJSON.noticeList;
				
				if(noticeList.length > 0){
					for(var i=0;i<noticeList.length;i++){
						dtlObj += "<div class='swiper-slide'><a href='javascript:fn_noticeDetail(\"" + noticeList[i].brdDtlSn + "\")'>" + noticeList[i].title + "</a></div>";
					}
				}
			}
			$(".swiper-wrapper").html(dtlObj);
			fnswiperLoad();
		}
		
		//긴급공지 상세 페이지 이동
		function fn_noticeDetail(BRD_DTL_SN){
			var param = "BRD_DTL_SN=" + BRD_DTL_SN;
			param += "&gMenuSn=" + $("#pageLoadFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeDetail.kspo",param);
		}
	  	
		
	  	//비밀번호 변경 팝업 열기
	  	function changepw(){
	  		
	  		if(grpSn == '1'){
	  			fnAlert("체육단체 계정만 사용 가능한 기능입니다.");
	  			return;
	  		}
	  		
	  		$("#pwFrm input[name=PASSWORD]").val("");
	  		$(".cpt-popup.pw-change").addClass("active")
	  		$("body").css("overflow", "hidden")
	  	}
	  
	  	//비밀번호 변경 팝업 닫기
		function changepwClose() {
			$("#pwFrm input[name=PASSWORD]").val("");
			$("#pwFrm input[name=PASSWORDChk]").val("");
			$(".cpt-popup.pw-change").removeClass("active")
			$("body").css("overflow","auto")
		}
	  	
		//비밀번호 변경
		function updateUserPwdChangeJs(){

			//var regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
			var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{10,}$/;
			
			if($("#pwFrm input[name=PASSWORD]").val() == ""){
				fnAlert("비밀번호를 입력하여주시기 바랍니다.");
				$("#pwFrm input[name=PASSWORD]").focus();
			}else if($("#pwFrm input[name=PASSWORDChk]").val() == ""){
				fnAlert("비밀번호를 한번더 입력하여주시기 바랍니다.");
				$("#pwFrm input[name=PASSWORDChk]").focus();
			}else if($("#pwFrm input[name=PASSWORD]").val() != $("#pwFrm input[name=PASSWORDChk]").val()){
				fnAlert("비밀번호가 일치하지 않습니다.");
				$("#pwFrm input[name=PASSWORDChk]").focus();
			}else if(!regex.test($("#pwFrm input[name=PASSWORD]").val())){
				fnAlert("비밀번호 입력 규칙(10자리 이상 영문+숫자+특수문자 포함)에 적합하지 않습니다.");
				$("#pwFrm input[name=PASSWORD]").focus();
			}else if($("#pwFrm input[name=PASSWORD]").val().length < 10){
				fnAlert("비밀번호 입력 규칙(10자리 이상 영문+숫자+특수문자 포함)에 적합하지 않습니다.");
				$("#pwFrm input[name=PASSWORD]").focus();
			}else{
				var $json = getJsonData("post", "/login/updatePasswordChangeJs.kspo", $("#pwFrm").serialize());
				
				var result = $json.responseJSON.result;
				if(result.resultCode == "0"){
					fnAlert("정상처리 되었습니다. 사용자의 보안을 위하여 재로그인 합니다.");
					location.href = "${pageContext.request.contextPath}/login/logout.kspo";
				}else if(result.resultCode == "94"){
					fnAlert(result.resultMsg);
				}else if(result.resultCode == "99"){
					fnAlert(result.resultMsg);
				}else{
					fnAlert(result.resultMsg);
					$(".pop-close").click();
				}
			}
			
		}
		
		//파일 다운로드
		function fnDownloadFile(FILE_SN) {
			window.location = "${pageContext.request.contextPath}/file/downloadFile.kspo?FILE_SN=" + FILE_SN + "&gMenuSn=" + $("#pageLoadFrm input[name=gMenuSn]").val();
		}
	  	
		//체육단체 계정관리 팝업 열기
		function userPopOpen(MNGR_SN){
			var param = "MNGR_SN=" + MNGR_SN;
			param += "&gMenuSn=" + $("#userFrm input[name=gMenuSn]").val();
			var $json = getJsonData("post", "/account/selectAccountDetailJs.kspo", param);
			
			if($json.statusText == "OK"){
				
				var dtl = $json.responseJSON.detail;

				if(!dtl){
					fnAlert("오류가 발생하였습니다.");
					return false;
				}

				$(".reg03.userFrm").addClass("active")
				$("body").css("overflow", "hidden")
				
				$('#userFrm input[name=MNGR_SN]').val(dtl.MNGR_SN);
				$('#userFrm input[name=MNGR_ID]').val(dtl.MNGR_ID);
				$('#userFrm input[name=I_MNGR_NM]').val(dtl.MNGR_NM);
				$('#userFrm input[name=CPNO1]').val(dtl.CPNO1);
				$('#userFrm input[name=CPNO2]').val(dtl.CPNO2);
				$('#userFrm input[name=CPNO3]').val(dtl.CPNO3);
				$('#userFrm input[name=TELNO]').val(dtl.TELNO);
				$('#userFrm input[name=EMAIL]').val(dtl.EMAIL);
				$('#userFrm input[name=LOCGOV_NM]').val(dtl.LOCGOV_NM);
				$('#userFrm td[id=REG_DTM]').html(dtl.REG_DTM);
				$('#userFrm td[id=RECENT_DT]').html(dtl.RECENT_DT);
					
			}
		}
		
		//체육단체 계정관리 팝업 닫기
		function userPopClose() {
			
			$('#userFrm input[name=MNGR_SN]').val("");
			$('#userFrm input[name=MNGR_ID]').val("");
			$('#userFrm input[name=I_MNGR_NM]').val("");
			$('#userFrm input[name=CPNO1]').val("");
			$('#userFrm input[name=CPNO2]').val("");
			$('#userFrm input[name=CPNO3]').val("");
			$('#userFrm input[name=TELNO]').val("");
			$('#userFrm input[name=EMAIL]').val("");
			$('#userFrm input[name=LOCGOV_NM]').val("");
			$('#userFrm td[id=REG_DTM]').html("");
			$('#userFrm td[id=RECENT_DT]').html("");
			
			$(".reg03.userFrm").removeClass("active")
			$("body").css("overflow","auto")
		}
		
		//저장
		function fn_userSave(){
			
			var saveUrl = "/account/updateAccountJs.kspo";
		
			var $json = getJsonData("post", saveUrl, $("#userFrm").serialize());
			
			if($json.statusText == "OK"){
					
				fnAlert("저장되었습니다.");
				userPopClose();
				
			}
		
		}

		//비밀번호초기화
		function fn_userChangePW(){
			
			var saveUrl = "/account/updateChangePwAccountJs.kspo";
		
			var $json = getJsonData("post", saveUrl, $("#userFrm").serialize());
			
			if($json.statusText == "OK"){
					
				fnAlert("비밀번호가 아이디랑 동일하게 초기화 되었습니다.");
				userPopClose();
			}
		
		}
		
		//회원탈퇴
		function fn_userResign(){
			var confirmMsg = "탈퇴 시 30일동안 본인명의로 재 가입이 불가능합니다. 그래도 탈퇴하시겠습니까?";
			
			if(!confirm(confirmMsg)){
				return false;
			}
			
			var saveUrl = "/account/updateResignAccountJs.kspo";
		
			var $json = getJsonData("post", saveUrl, $("#userFrm").serialize());
			
			if($json.statusText == "OK"){
					
				fnAlert("회원탈퇴가 완료되었습니다.");
				userPopClose();
				
				fnLogout();
			}
		
		}
		
		var validateTargetObj = "";//벨리데이션 대상 obj
		//]]>
	</script>
	<div class="wrap">
		<div class="header">
			<div class="cpt-header">
				<div class="header-logo">
					<h1>
						<a href="javascript:fn_start();">체육요원 복무관리시스템</a>
					</h1>
				</div>
				<div class="header-date">
					<dl>
						<dt>긴급공지</dt>
						<dd>
							<div class="swiper-container head-notice">
								<div class="swiper-wrapper">
									<c:forEach items="${noticeList}" var="list" varStatus="state">
										<div class="swiper-slide"><a href="javascript:fn_noticeDetail('${list.BRD_DTL_SN}')">${list.SUBJECT}</a></div>
									</c:forEach>
								</div>
								<!-- Add Arrows -->
								<div class="swiper-button-next" style="transform:rotate(90deg); top:5px; right:23px;"></div>
								<div class="swiper-button-prev" style="transform:rotate(90deg); top:-5px; "></div>
							</div>
						</dd>
					</dl>
				</div>
				 <!-- 20211115 추가 -->
                <div class="header-profile">
                    <div class="profile-info">
                        <div class="company">${sessionScope.userMap.LOCGOV_NM}</div>
                        <div class="name"><b>${sessionScope.userMap.MNGR_NM}</b>님</div>
                    </div>
                    <div class="profile-btn-group">
                        <button class="btn dark profile" type="button" onclick="fnLogout();">로그아웃</button>
                        
<%--                         <c:if test="${sessionScope.userMap.GRP_SN ne 1}"><!--공단 담당자는 안 보여야함 --> --%>
							<button class="btn red profile change-pw" type="button" onclick="userPopOpen('${sessionScope.userMap.USER}');">체육단체계정관리</button>
							<button class="btn red profile change-pw" type="button" onclick="changepw();">PW 변경</button>
<%-- 						</c:if> --%>
                    </div>
                </div>
                <!-- //20211115 추가 -->
				
			</div>
		</div>
		<div class="container">
			<div class="side-nav">
				<div class="cpt-snav">
					<%-- <div class="snav-top">
						<div class="snav-profile">
							<div class="photo">
								<img src="/common/images/common/icon_profile.png" alt="" />
							</div>
							<div class="name">
								<b>${sessionScope.userMap.MNGR_NM}</b>님
							</div>
							<div class="company">${sessionScope.userMap.LOCGOV_NM}</div>
						</div>
						<div class="snav-btn-group">
							<button class="btn dark profile" type="button" onclick="fnLogout();">로그아웃</button>
							<button class="btn red profile change-pw" type="button" onclick="changepw();">PW 변경</button>
						</div>
						<div class="snav-reset">
                            <button type="button" class="btn reset" onclick="pageReload();">새로고침</button>
                        </div>
					</div> --%>
					<div class="snav-menu">
						<ul class="menu-list">
							<c:forEach items="${leftMenu}" var="li">
								<c:if test="${sessionScope.userMap.GRP_SN eq li.GRP_SN}">
									<c:if test="${empty li.UP_MENU_SN}">
										<c:set var="iconNm" value=""/>
										<c:choose>
											<c:when test="${li.MENU_NM eq '메인'}">
												<c:set var="iconNm" value="icon01"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '체육요원 복무관리'}">
												<c:set var="iconNm" value="icon02"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '공익복무관리'}">
												<c:set var="iconNm" value="icon03"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '기타복무관리'}">
												<c:set var="iconNm" value="icon03"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '통계'}">
												<c:set var="iconNm" value="icon05"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '공지사항'}">
												<c:set var="iconNm" value="icon08"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '시스템 관리'}">
												<c:set var="iconNm" value="icon06"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '샘플'}">
												<c:set var="iconNm" value="icon06"/>
											</c:when>
											<c:when test="${li.MENU_NM eq '정보관리'}">
												<c:set var="iconNm" value="icon03"/>
											</c:when>
										</c:choose>
										<c:set var="upMenuOn" value="drop-down"/>
										<c:set var="menuCnt" value="0"/>
										<c:forEach items="${leftMenu}" var="dLi">
											<c:if test="${li.MENU_SN eq dLi.UP_MENU_SN}">
												<c:set var="menuCnt" value="${menuCnt+1}"/>
												<c:if test="${dLi.MENU_SN eq param.gMenuSn}">
													<c:set var="upMenuOn" value="drop-down on"/>
												</c:if>
											</c:if>
										</c:forEach>
										<c:if test="${menuCnt eq '0'}">
											<c:choose>
												<c:when test="${li.MENU_SN eq param.gMenuSn}">
													<c:set var="upMenuOn" value="on"/>
												</c:when>
												<c:otherwise>
													<c:set var="upMenuOn" value=""/>											
												</c:otherwise>
											</c:choose>
										</c:if>
										<li class="menu-item ${iconNm} ${upMenuOn}">
											<a href="#" data-menuurl="${li.MENU_URL}" data-menusn="${li.MENU_SN}">${li.MENU_NM}</a>
											<c:if test="${menuCnt ne '0'}">
												<ul class="sub-menu">
													<c:forEach items="${leftMenu}" var="dLi">
														<c:if test="${sessionScope.userMap.GRP_SN eq dLi.GRP_SN}">
															<c:if test="${li.MENU_SN eq dLi.UP_MENU_SN}">
																<li><a href="#"data-menuurl="${dLi.MENU_URL}" data-menusn="${dLi.MENU_SN}">- ${dLi.MENU_NM}</a></li>
															</c:if>
														</c:if>
													</c:forEach>
												</ul>
											</c:if>
										</li>
									</c:if>
								</c:if>
							</c:forEach>
						</ul>
					</div>
					<form id="pageLoadFrm" method="post">
						<input type="hidden" name="gMenuSn">
					</form>
					<form id="pageInfoFrm" method="post">
						<input type="hidden" name="url">
						<input type="hidden" name="param">
					</form>
					
				</div>
<!-- 				<div class="side-logo"> -->
<!-- 					<img src="/common/images/common/sidenav_logo.png" alt=""> -->
<!-- 				</div> -->
			</div>

			<div class="body-cont">
				<!-- 20201214 추가 : 좌메뉴 show / hide 버튼 -->
                <div class="nav-btn">
                    <button>열기/닫기</button> 
                </div>
                <!-- //20201214 추가 : 좌메뉴 show / hide 버튼 -->
				<div id="content"></div>
				<!-- 푸터 -->
				<div class="footer"><span style="color:#ccc;">&copy;체육요원 복무관리시스템, ALL RIGHT RESERVED.</span></div>
				<!-- //푸터 -->
				
			</div>
			
			<!-- 비밀번호 변경 영역 -->
			<div class="cpt-popup pw-change"> <!-- class:active 팝업 on/off -->
				<div class="dim"></div>
				<div class="popup">
					<div class="pop-head">
						비밀번호 변경
						<button class="pop-close" onclick="changepwClose();"><img src="/common/images/common/icon_close.png" alt=""></button>
					</div>
				<form method="post" id="pwFrm" name="pwFrm" onsubmit="return false;">
					<input type="hidden" name="MNGR_ID" value="${sessionScope.userMap.EMP_NO}">
					<div class="pop-body">
						<dl>
							<dt>변경하실 새로운 비밀번호를 입력하세요.(8자리 이상 영문+숫자+특수문자 포함)</dt>
							<dd><input type="PASSWORD" name="PASSWORD"></dd>
						</dl>
						<dl>
							<dt>비밀번호를 한 번 더 입력하세요.</dt>
							<dd><input type="PASSWORD" name="PASSWORDChk"></dd>
						</dl>
						<button class="btn save" name="btnSave" onclick="updateUserPwdChangeJs();">확인</button>
					</div>
				</form>
				</div>
			</div>
			<!-- //비밀번호 변경 영역 -->
			
			<!-- 팝업영역 -->
			<form id="userFrm" name="userFrm" method="post" onsubmit="return false;">
				<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
				<input type="hidden" name="MNGR_SN" value="">
				<div class="cpt-popup reg03 userFrm"> <!-- class:active 팝업 on/off -->
				    <div class="dim"></div>
				    <div class="popup">
				        <div class="pop-head">
				            사용자계정관리
				            <button class="pop-close" onclick="userPopClose();">
				                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
				            </button>
				        </div>
				        <div class="pop-body">
				            <div class="com-h3 add">사용자정보</div>
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
				                            <td class="t-title">아이디</td>
				                            <td class="input-td"><input type="text" class="ip-title" name="MNGR_ID" readonly></td>
				                            <td class="t-title">이름</td>
				                            <td class="input-td"><input type="text" class="ip-title" name="I_MNGR_NM" readonly></td>
				                        </tr>
				                        <tr>
				                            <td class="t-title">사용자그룹</td>
				                            <td class="input-td">체육단체</td>
				                            <td class="t-title">소속</td>
				                            <td class="input-td"><input type="text" class="ip-title" name="LOCGOV_NM"></td>
				                        </tr>
				                         <tr>
				                            <td class="t-title">전화</td>
				                            <td class="input-td">
				                            	<input type="text" title="휴대전화 중간자리 입력" name="TELNO" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
				                            </td>
				                            <td class="t-title">휴대폰</td>
				                            <td class="input-td type03">
				                                <input type="text" title="휴대전화 중간자리 입력" name="CPNO1" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
				                                <span>-</span> 
				                                <input type="text" title="휴대전화 중간자리 입력" name="CPNO2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
				                                <span>-</span>
				                                <input type="text" title="휴대전화 뒷자리 입력" name="CPNO3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
				                            </td>
				                        </tr>
				                        <tr>
				                            <td class="t-title">이메일</td>
				                            <td class="input-td">
				                            	<div class="email-box">
				                                    <input type="text" name="EMAIL1">
				                                    <span class="text">@</span>
				                                    <input type="text" name="EMAIL2">
				                                </div>
				                            </td>
				                            <td class="t-title">등록일자</td>
				                            <td class="input-td" id="REG_DTM"></td>
				                        </tr>
				                        <tr>
				                            <td class="t-title">최근접속</td>
				                            <td class="input-td" id="RECENT_DT"></td>
				                        </tr>
				                    </tbody>
				                </table>
				            </div>
				
				            <div class="com-btn-group put">
				                <c:if test="${sessionScope.userMap.GRP_SN ne 1}">
					                <div class="float-r">
					                <!-- 회원탈퇴 기능은 안정화 때 구현 -->
					                	<!-- button class="btn red rmvcrr" type="button" onclick="fn_userResign();">회원탈퇴</button-->
					                	<button class="btn red rmvcrr" type="button" onclick="fn_userChangePW();">비밀번호초기화</button>
					                    <button class="btn red rmvcrr" type="button" onclick="fn_userSave();">저장</button>
					                    <button class="btn navy rmvcrr userDv2" type="button" onclick="userPopClose();">닫기</button>
					                </div>
				                </c:if>
				            </div>
				            
				        </div>
				    </div>
				</div>
			</form>
			<!-- //팝업영역 -->
                
		</div>
	</div>
	
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
					<button type="button" class="btn save" name="alertCloseBtn"onclick="msgPopClose();">확인</button>
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
	
	<!-- 210311 추가 : 로딩 애니메이션 추가 -->
<!-- 	<div class="loading-area"> -->
<!-- 		<div class="loading-wrap"> -->
<!-- 			<div class="loading-bar"></div> -->
<!-- 			<div class="loading-txt">Loading</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
	<div class="loading-group">
		<div class="loading-bar"></div>
	</div>
	<!-- // 210311 추가 : 로딩 애니메이션 추가 -->
</body>
</html>