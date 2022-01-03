<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

var globalMenuSn = "";

$(document).ready(function(){
	fn_ready();

	//대분류코드 수정 팝업
	$(document).on("click","button[name=btnUpdateMst]",function(){
		$("#mpFrm input[name=UP_MENU_SN]").val("");
		$("#mpFrm input[name=MENU_SN]").val($(this).parents("tr").find("input[name=MENU_SN]").val());
		$("#mpFrm input[name=MENU_NM]").val($(this).parents("tr").find("input[name=MENU_NM]").val());
		$("#mpFrm input[name=ORD]").val($(this).parents("tr").find("input[name=ORD]").val());
		$("#mpFrm select[name=MENU_TY]").val($(this).parents("tr").find("input[name=MENU_TY]").val());
		$("#mpFrm input[name=MENU_URL]").val($(this).parents("tr").find("input[name=MENU_URL]").val());
		$("#mpFrm select[name=USE_YN]").val($(this).parents("tr").find("input[name=USE_YN]").val());
		mstMenuPopOpen("1");
	});
	
	//소분류코드 수정 팝업
	$(document).on("click","button[name=btnUpdateDtl]",function(){
		$("#dpFrm input[name=UP_MENU_SN]").val($(this).parents("tr").find("input[name=UP_MENU_SN]").val());
		$("#dpFrm input[name=MENU_SN]").val($(this).parents("tr").find("input[name=MENU_SN]").val());
		$("#dpFrm input[name=MENU_NM]").val($(this).parents("tr").find("input[name=MENU_NM]").val());
		$("#dpFrm input[name=ORD]").val($(this).parents("tr").find("input[name=ORD]").val());
		$("#dpFrm select[name=MENU_TY]").val($(this).parents("tr").find("input[name=MENU_TY]").val());
		$("#dpFrm input[name=MENU_URL]").val($(this).parents("tr").find("input[name=MENU_URL]").val());
		$("#dpFrm select[name=USE_YN]").val($(this).parents("tr").find("input[name=USE_YN]").val());
		dtlMenuPopOpen("1");
	});
	

	//대메뉴 전체 선택 해제
	$(document).on("click","#mFrm input[name=mstChkAll]",function(){
		$(this).parents("table").find("input[name=CHK]").prop("checked",$(this).is(":checked"));
		$(this).parents("table").find("input[name=CHK]").attr("checked",$(this).is(":checked"));
	});
	
	//대메뉴 선택 해제
	$(document).on("click","#mFrm input[name=CHK]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=CHK]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("input[name=mstChkAll]").prop("checked",checked);
		$("input[name=mstChkAll]").attr("checked",checked);
	});
	
	//소메뉴 전체 선택 해제
	$(document).on("click","#dFrm input[name=dtlChkAll]",function(){
		$(this).parents("table").find("input[name=CHK]").prop("checked",$(this).is(":checked"));
		$(this).parents("table").find("input[name=CHK]").attr("checked",$(this).is(":checked"));
	});

	//소메뉴 선택 해제
	$(document).on("click","#dFrm input[name=CHK]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=CHK]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("input[name=dtlChkAll]").prop("checked",checked);
		$("input[name=dtlChkAll]").attr("checked",checked);
	});
	

	
	
});

//시작시 호출
function fn_ready(){
	
	var MENU_SN = $("#mstTbody").find("input[name=MENU_SN]").eq(0).val();
	if(typeof MENU_SN != "undefined" && MENU_SN != null && MENU_SN != ""){//조회된 값이 있는 경우 소분류코드 조회
		globalMenuSn = MENU_SN;
		fn_DtlList(MENU_SN);
	}
	
}

//초기화
function fn_reset(){
	$("#sFrm input[name=MENU_SN]").val("");
	$("#sFrm input[name=MENU_NM]").val("");
}

//검색
function fn_search(){
	fnPageLoad("${pageContext.request.contextPath}/menu/selectMenuList.kspo",$("#sFrm").serialize());
}


//대메뉴 정보 저장
function fn_preMstSave(){
	if(fnSaveMstVaild()){
		fnSaveMst();
		fn_search();
	}
}

//소메뉴 정보 저장
function fn_preDtlSave(){
	if(fnSaveDtlVaild()){
		fnSaveDtl();
		fn_search();
	}
}

//대메뉴 정보 삭제
function fn_preMstDel(){
	var $json = getJsonData("post", "${pageContext.request.contextPath}/menu/deleteMenuMstJs.kspo", $("#mFrm").serialize());
	if($json.statusText == "OK"){
		fn_search();
	}
}

//소메뉴 정보 삭제
function fn_preDtlDel(){
	var $json = getJsonData("post", "${pageContext.request.contextPath}/menu/deleteMenuMstJs.kspo", $("#dFrm").serialize());
	if($json.statusText == "OK"){
		fn_DtlList(globalMenuSn);
	}
}

//상세조회
function fn_DtlList(MENU_SN){
	globalMenuSn = MENU_SN;
	var param = "MENU_SN=" + MENU_SN;
	param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
	var $json = getJsonData("post", "${pageContext.request.contextPath}/menu/selectMenuDtlListJs.kspo", param);
	if($json.statusText == "OK"){
		var dtlList = $json.responseJSON.menuDtlList;
		var dtlObj = "";
		if(dtlList.length > 0){
			for(var i=0;i<dtlList.length;i++){
				dtlObj += "<tr>";
				dtlObj += "<td>";
				dtlObj += "<input id='check02-" + i + "' name='CHK' type='checkbox' value='" + dtlList[i].MENU_SN + "'/>";
				dtlObj += "<label for='check02-" + i + "' class='chk-only'></label>";
				dtlObj += "<input type='hidden' name='MENU_SN' value='" + dtlList[i].MENU_SN + "'>";
				dtlObj += "<input type='hidden' name='UP_MENU_SN' value='" + dtlList[i].UP_MENU_SN + "'>";
				dtlObj += "<input type='hidden' name='MENU_NM' value='" + dtlList[i].MENU_NM + "'>";
				dtlObj += "<input type='hidden' name='ORD' value='" + dtlList[i].ORD + "'>";
				dtlObj += "<input type='hidden' name='MENU_TY' value='" + dtlList[i].MENU_TY + "'>";
				dtlObj += "<input type='hidden' name='MENU_URL' value='" + dtlList[i].MENU_URL + "'>";
				dtlObj += "<input type='hidden' name='USE_YN' value='" + dtlList[i].USE_YN + "'>";
				dtlObj += "</td>";
				dtlObj += "<td>" + dtlList[i].UP_MENU_SN + "</td>";
				dtlObj += "<td>" + dtlList[i].MENU_SN + "</td>";
				dtlObj += "<td class='left'>" + dtlList[i].MENU_NM + "</td>";
				dtlObj += "<td>" + dtlList[i].ORD + "</td>";
				dtlObj += "<td>" + dtlList[i].MENU_TY_NM + "</td>";
				dtlObj += "<td>" + dtlList[i].MENU_URL + "</td>";
				dtlObj += "<td>" + dtlList[i].USE_YN + "</td>";
				dtlObj += "<td>" + dtlList[i].REG_DT + "</td>";
				dtlObj += "<td>" + dtlList[i].REGR_ID + "</td>";
				dtlObj += "<td>" + dtlList[i].UPDT_DT + "</td>";
				dtlObj += "<td>" + dtlList[i].UPDR_ID + "</td>";
				dtlObj += "<td class='input-td'><button type='button' class='btn red checking' name='btnUpdateDtl'>수정</button></td>";
				dtlObj += "</tr>";
			}
		}else{
			dtlObj += "<tr><td colspan='13' class='blank'>검색결과가 존재하지 않습니다.</td></tr>";
		}
		$("#dtlTbody").html(dtlObj);
	}
}

//대메뉴 정보 저장 확인
function fnSaveMstVaild(){
	
	var regexp = /^[0-9]*$/;
		
	if($("#mpFrm input[name=MENU_NM]").val() == ""){
		fnAlert("대메뉴명을 입력하시기 바랍니다.");
		$("#mpFrm input[name=MENU_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#mpFrm input[name=MENU_NM]").val())>300){
		var length = fnGetTxtLength(300);
		fnAlert("대메뉴명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#mpFrm input[name=MENU_NM]").focus();
		return false;
	}
	
	if($("#mpFrm input[name=ORD]").val() == ""){
		fnAlert("정렬순서를 입력하시기 바랍니다.");
		$("#mpFrm input[name=ORD]").focus();
		return false;
	}
	
	if(!regexp.test($("#mpFrm input[name=ORD]").val())){
		fnAlert("숫자만 입력 가능합니다.");
		$("#mpFrm input[name=ORD]").focus();
		return false;
	}
	
	if($("#mpFrm input[name=MENU_URL]").val() == ""){
		fnAlert("화면URL을 입력하시기 바랍니다.");
		$("#mpFrm input[name=MENU_URL]").focus();
		return false;
	}
	
	if(fnGetByte($("#mpFrm input[name=MENU_URL]").val())>300){
		var length = fnGetTxtLength(300);
		fnAlert("화면URL 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#mpFrm input[name=MENU_URL]").focus();
		return false;
	}
	
	return true;
}

//대메뉴 정보 저장
function fnSaveMst(){
	var MENU_SN  = $("#mpFrm").find("input[name=MENU_SN]").val();
	var saveUrl = "${pageContext.request.contextPath}/menu/insertMenuJs.kspo";

	if(typeof MENU_SN != "undefined" && MENU_SN != null && MENU_SN != ""){
		saveUrl = "${pageContext.request.contextPath}/menu/updateMenuJs.kspo";
	}

	var $json = getJsonData("post", saveUrl, $("#mpFrm").serialize());
	if($json.statusText == "OK"){
		mstMenuPopClose();
	}
}

//소메뉴 정보 저장 확인
function fnSaveDtlVaild(){

	var regexp = /^[0-9]*$/;
	
	if($("#dpFrm input[name=MENU_NM]").val() == ""){
		fnAlert("소메뉴명을 입력하시기 바랍니다.");
		$("#dpFrm input[name=MENU_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#dpFrm input[name=MENU_NM]").val())>300){
		var length = fnGetTxtLength(300);
		fnAlert("소메뉴명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dpFrm input[name=MENU_NM]").focus();
		return false;
	}
	
	if($("#dpFrm input[name=ORD]").val() == ""){
		fnAlert("정렬순서를 입력하시기 바랍니다.");
		$("#dpFrm input[name=ORD]").focus();
		return false;
	}
	
	if(!regexp.test($("#dpFrm input[name=ORD]").val())){
		fnAlert("숫자만 입력 가능합니다.");
		$("#dpFrm input[name=ORD]").focus();
		return false;
	}
	
	if($("#dpFrm input[name=MENU_URL]").val() == ""){
		fnAlert("화면URL을 입력하시기 바랍니다.");
		$("#dpFrm input[name=MENU_URL]").focus();
		return false;
	}
	
	if(fnGetByte($("#dpFrm input[name=MENU_URL]").val())>300){
		var length = fnGetTxtLength(300);
		fnAlert("화면URL 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dpFrm input[name=MENU_URL]").focus();
		return false;
	}
	
	return true;
}

//소메뉴 정보 저장
function fnSaveDtl(){
	var MENU_SN  = $("#dpFrm").find("input[name=MENU_SN]").val();
	var saveUrl = "${pageContext.request.contextPath}/menu/insertMenuJs.kspo";
	
	if(typeof MENU_SN != "undefined" && MENU_SN != null && MENU_SN != ""){
		saveUrl = "${pageContext.request.contextPath}/menu/updateMenuJs.kspo";
	}
	
	var $json = getJsonData("post", saveUrl, $("#dpFrm").serialize());
	if($json.statusText == "OK"){
		dtlMenuPopClose();
	}
}

//대메뉴 등록 수정 팝업 열기
function mstMenuPopOpen(saveGbn){
	if(saveGbn == "1"){
		$("button[name=btnSaveMst]").html("수정");	
	}else{
		$("button[name=btnSaveMst]").html("등록");
	}
	
	$(".cpt-popup.reg.mstMenuPop").addClass("active")
	$("body").css("overflow", "hidden")
}

//대메뉴 등록 수정 팝업 닫기
function mstMenuPopClose() {
	$("#mpFrm input[name=UP_MENU_SN]").val("");
	$("#mpFrm input[name=MENU_SN]").val("");
	$("#mpFrm input[name=MENU_NM]").val("");
	$("#mpFrm input[name=ORD]").val("");
	$("#mpFrm select[name=MENU_TY]").val("1");
	$("#mpFrm input[name=MENU_URL]").val("");
	$("#mpFrm select[name=USE_YN]").val("Y");
	$(".cpt-popup.reg.mstMenuPop").removeClass("active")
	$("body").css("overflow","auto")
}

//소메뉴 등록 수정 팝업 열기
function dtlMenuPopOpen(saveGbn){
	if(saveGbn == "1"){
		$("button[name=btnSaveDtl]").html("수정");
	}else{
		$("button[name=btnSaveDtl]").html("등록");
	}
	$("#dpFrm input[name=UP_MENU_SN]").val(globalMenuSn);
	$(".cpt-popup.reg.dtlMenuPop").addClass("active")
	$("body").css("overflow", "hidden")
}

//소메뉴 등록 수정 팝업 닫기
function dtlMenuPopClose() {
	$("#dpFrm input[name=UP_MENU_SN]").val("");
	$("#dpFrm input[name=MENU_SN]").val("");
	$("#dpFrm input[name=MENU_NM]").val("");
	$("#dpFrm input[name=ORD]").val("");
	$("#dpFrm select[name=MENU_TY]").val("1");
	$("#dpFrm input[name=MENU_URL]").val("");
	$("#dpFrm select[name=USE_YN]").val("Y");
	$(".cpt-popup.reg.dtlMenuPop").removeClass("active")
	$("body").css("overflow","auto")
}

</script>
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>메뉴 관리</h2>
	</div>
	<!-- //타이틀 -->

	<!-- 검색/조회 영역 -->
	<div class="cpt-search">
		<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/menu/selectMenuList.kspo">
			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<ul class="search-list">
				<li class="search-item">
					<dl>
						<dt>대메뉴ID</dt>
						<dd>
							<input type="text" class="expand" title="대메뉴 아이디 입력" name="MENU_SN" value="${param.MENU_SN}"onkeydown="if(event.keyCode == 13){fn_search();return false;}">
						</dd>
					</dl>
				</li>
				<li class="search-item">
					<dl>
						<dt>대메뉴명</dt>
						<dd>
							<input type="text" class="expand" title="대메뉴명 입력" name="MENU_NM" value="${param.MENU_NM}"onkeydown="if(event.keyCode == 13){fn_search();return false;}">
						</dd>
					</dl>
				</li>
				<li class="search-item btngroup">
					<button class="btn grey put-search" type="button" onclick="fn_reset();">초기화</button>
					<button class="btn navy put-search" type="button" onclick="fn_search();">검색</button>
				</li>
			</ul>
		</form>
	</div>
	<!-- //검색/조회 영역 -->

	<!-- 조건/버튼 영역 -->
	<div class="com-result">
		<div class="float-l">
			<span class="total-num">전체<b>${pageInfo.totalRecordCount}</b>개
			</span><span class="now-page bar-front">현재페이지 ${pageInfo.currentPageNo}/${pageInfo.totalPageCount}</span>
		</div>
		<div class="float-r">
			<button class="btn red grid" type="button" onclick="mstMenuPopOpen();">추가</button>
		</div>
	</div>
	<!-- //조건/버튼 영역 -->

	<!-- 그리드 영역 (대메뉴) -->
	<div class="com-grid">
		<form method="post" id="mFrm" name="mFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col width="6.389%" />
					<col width="7.587%" />
					<col width="10.383%" />
					<col width="6.549%" />
					<col width="7.028%" />
					<col width="auto" />
					<col width="7.987%" />
					<col width="7.987%" />
					<col width="7.987%" />
					<col width="7.987%" />
					<col width="9.984%" />
				</colgroup>
				<thead>
					<tr>
						<th>
							<div class="input-box">
								<input type="checkbox" id="checkall01" name="mstChkAll"/>
								<label for="checkall01" class="chk-only"></label>
							</div>
						</th>
						<th>대메뉴ID</th>
						<th>대메뉴명</th>
						<th>정렬순서</th>
						<th>화면유형</th>
						<th>화면URL</th>
						<th>생성일자</th>
						<th>생성자</th>
						<th>수정일자</th>
						<th>수정자</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody id="mstTbody">
					<c:choose>
						<c:when test="${not empty menuMstList}">
							<c:forEach items="${menuMstList}" var="mstLi" varStatus="state">
								<tr>
									<td>
										<div class="input-box">
											<input id="check01-${state.count}" type="checkbox" name="CHK" value="${mstLi.MENU_SN}"/>
											<label for="check01-${state.count}" class="chk-only"></label>
										</div>
										<input type="hidden" name="MENU_SN" value="${mstLi.MENU_SN}">
										<input type="hidden" name="UP_MENU_SN" value="">
										<input type="hidden" name="MENU_NM" value="${mstLi.MENU_NM}">
										<input type="hidden" name="ORD" value="${mstLi.ORD}">
										<input type="hidden" name="MENU_TY" value="${mstLi.MENU_TY}">
										<input type="hidden" name="MENU_URL" value="${mstLi.MENU_URL}">
										<input type="hidden" name="USE_YN" value="${mstLi.USE_YN}">
									</td>
									<td>${mstLi.MENU_SN}</td>
									<td class="left"><a href="#" class="tit" onclick="fn_DtlList('${mstLi.MENU_SN}');">${mstLi.MENU_NM}</a></td>
									<td>${mstLi.ORD}</td>
									<td>${mstLi.MENU_TY_NM}</td>
									<td class="left">${mstLi.MENU_URL}</td>
									<td>${mstLi.REG_DT}</td>
									<td>${mstLi.REGR_ID}</td>
									<td>${mstLi.UPDT_DT}</td>
									<td>${mstLi.UPDR_ID}</td>
									<td class="input-td">
										<button class="btn red checking" type="button" name="btnUpdateMst">수정</button>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="11" class="blank">검색결과가 존재하지 않습니다.</td></tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</form>
	</div>
	<!-- //그리드 영역 (대메뉴) -->

	<!-- 버튼 영역 -->
	<div class="com-btn-group put">
		<button class="btn navy rmvcrr" type="button" name="btnDeleteMst" onclick="fn_preMstDel();">삭제</button>
	</div>
	<!-- //버튼 영역 -->

	<!-- 페이징 영역 -->
	<div class="com-paging">
		<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:sFrm" />
	</div>
	<!-- //페이징 영역 -->

	<!-- 조건/버튼 영역 -->
	<div class="com-result">
		<div class="float-r">
			<button class="btn red grid" type="button" onclick="dtlMenuPopOpen();">추가</button>
		</div>
	</div>
	<!-- //조건/버튼 영역 -->

	<!-- 그리드 영역 (소메뉴) -->
	<div class="com-grid">
		<form method="post" id="dFrm" name="dFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col width="5%" />
					<col width="8%" />
					<col width="8%" />
					<col width="10%" />
					<col width="5%" />
					<col width="5%" />
					<col width="auto" />
					<col width="5%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="9%" />
				</colgroup>
				<thead>
					<tr>
						<th>
							<input id="checkall02" type="checkbox" name="dtlChkAll"/>
							<label for="checkall02" class="chk-only"></label>
						</th>
						<th>대메뉴ID</th>
						<th>소메뉴ID</th>
						<th>소메뉴명</th>
						<th>정렬순서</th>
						<th>화면유형</th>
						<th>화면URL</th>
						<th>사용유무</th>
						<th>생성일자</th>
						<th>생성자</th>
						<th>수정일자</th>
						<th>수정자</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody id="dtlTbody">
					<tr><td colspan="13" class="blank">검색결과가 존재하지 않습니다.</td></tr>
				</tbody>
			</table>
		</form>
	</div>
	<!-- //그리드 영역 (소메뉴) -->

	<!-- 버튼 영역 -->
	<div class="com-btn-group put">
		<button class="btn navy rmvcrr" type="button" name="btnDeleteDtl" onclick="fn_preDtlDel()">삭제</button>
	</div>
	<!-- //버튼 영역 -->
</div>

<!-- 대메뉴 등록 팝업 영역 -->
<div class="cpt-popup reg mstMenuPop">
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			대메뉴
			<button class="pop-close" type="button" onclick="mstMenuPopClose();">
				<img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
			</button>
		</div>
		<form method="post" id="mpFrm" name="mpFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<input type="hidden" name="UP_MENU_SN">
			<input type="hidden" name="MENU_SN">
			<div class="pop-body">
				<div class="com-table pop-tbl">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col width="135px" />
							<col width="auto" />
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">대메뉴명</td>
								<td class="input-td"><input type="text" title="대메뉴명 입력" name="MENU_NM">
								</td>
							</tr>
							<tr>
								<td class="t-title">정렬순서</td>
								<td class="input-td"><input type="text" title="정렬순서 입력" name="ORD">
								</td>
							</tr>
							<tr>
								<td class="t-title">화면유형</td>
								<td class="input-td">
									<div class="com-select-list">
										<select title="화면유형 선택" name="MENU_TY">
											<c:forEach items="${menuTyList}" var="subLi">
												<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
											</c:forEach>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td class="t-title">화면URL</td>
								<td class="input-td"><input type="text" title="화면URL 입력" name="MENU_URL">
								</td>
							</tr>
							<tr>
								<td class="t-title">사용유무</td>
								<td class="input-td">
									<div class="com-select-list">
										<select title="사용유무 선택" name="USE_YN">
											<option value="Y">예</option>
											<option value="N">아니오</option>
										</select>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button class="btn save" type="button" name="btnSaveMst" onclick="fn_preMstSave()">등록</button>
			</div>
		</form>
	</div>
</div>
<!-- //대메뉴 등록 팝업 영역 -->

<!-- 소메뉴 등록 팝업 영역 -->
<div class="cpt-popup reg dtlMenuPop">
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			소메뉴
			<button class="pop-close" type="button" onclick="dtlMenuPopClose();">
				<img src="/common/images/common/icon_close.png" alt="">
			</button>
		</div>
		<form method="post" id="dpFrm" name="dpFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<input type="hidden" name="UP_MENU_SN">
			<input type="hidden" name="MENU_SN">
			<div class="pop-body">
				<div class="com-table pop-tbl">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col width="135px" />
							<col width="auto" />
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">소메뉴명</td>
								<td class="input-td"><input type="text" title="소메뉴명 입력" name="MENU_NM">
								</td>
							</tr>
							<tr>
								<td class="t-title">정렬순서</td>
								<td class="input-td"><input type="text" title="정렬순서 입력" name="ORD">
								</td>
							</tr>
							<tr>
								<td class="t-title">화면유형</td>
								<td class="input-td">
									<div class="com-select-list">
										<select title="화면유형 선택" name="MENU_TY">
											<c:forEach items="${menuTyList}" var="subLi">
												<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
											</c:forEach>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td class="t-title">화면URL</td>
								<td class="input-td"><input type="text" title="화면URL 입력" name="MENU_URL">
								</td>
							</tr>
							<tr>
								<td class="t-title">사용유무</td>
								<td class="input-td">
									<div class="com-select-list">
										<select title="사용유무 선택" name="USE_YN">
											<option value="Y">예</option>
											<option value="N">아니오</option>
										</select>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button class="btn save" type="button" name="btnSaveDtl" onclick="fn_preDtlSave()">등록</button>
			</div>
		</form>
	</div>
</div>
<!-- //소메뉴 등록 팝업 영역 -->