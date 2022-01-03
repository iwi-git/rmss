<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

var GLOBAL_CMMN_SN = "";

$(document).ready(function(){
	fn_ready();
	
	//대분류코드 수정 팝업
	$(document).on("click","button[name=btnUpdateMst]",function(){
		$("#mpFrm input[name=CMMN_SN]").val($(this).parents("tr").find("input[name=CMMN_SN]").val());
		$("#mpFrm input[name=CMMN_NM]").val($(this).parents("tr").find("input[name=CMMN_NM]").val());
		mstCodePopOpen("1");
	});
	
	//소분류코드 수정 팝업
	$(document).on("click","button[name=btnUpdateDtl]",function(){
		$("#dpFrm input[name=CMMN_SN]").val($(this).parents("tr").find("input[name=CMMN_SN]").val());
		$("#dpFrm input[name=MJRSN]").val($(this).parents("tr").find("input[name=MJRSN]").val());
		$("#dpFrm input[name=CNTNT_FST]").val($(this).parents("tr").find("input[name=CNTNT_FST]").val());
		$("#dpFrm input[name=ALT_CODE]").val($(this).parents("tr").find("input[name=ALT_CODE]").val());
		$("#dpFrm input[name=ORD]").val($(this).parents("tr").find("input[name=ORD]").val());
		$("#dpFrm select[name=USE_YN]").val($(this).parents("tr").find("input[name=USE_YN]").val());
		$("#dpFrm input[name=CNTNT_SND]").val($(this).parents("tr").find("input[name=CNTNT_SND]").val());
		dtlCodePopOpen("1");
	});
	
	//대분류 전체 선택 해제
	$(document).on("click","input[name=mstChkAll]",function(){
		$(this).parents("table").find("input[name=mstChk]").prop("checked",$(this).is(":checked"));
		$(this).parents("table").find("input[name=mstChk]").attr("checked",$(this).is(":checked"));
	});
	
	//대분류 선택 해제
	$(document).on("click","input[name=mstChk]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=mstChk]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("input[name=mstChkAll]").prop("checked",checked);
		$("input[name=mstChkAll]").attr("checked",checked);
	});
	
	//소분류 전체 선택 해제
	$(document).on("click","input[name=dtlChkAll]",function(){
		$(this).parents("table").find("input[name=dtlChk]").prop("checked",$(this).is(":checked"));
		$(this).parents("table").find("input[name=dtlChk]").attr("checked",$(this).is(":checked"));
	});

	//소분류 선택 해제
	$(document).on("click","input[name=dtlChk]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=dtlChk]").each(function(){
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
	
	var CMMN_SN = $("#mstTbody").find("input[name=CMMN_SN]").eq(0).val();
	if(typeof CMMN_SN != "undefined" && CMMN_SN != null && CMMN_SN != ""){//조회된 값이 있는 경우 소분류코드 조회
		GLOBAL_CMMN_SN = CMMN_SN;
		fn_DtlList(CMMN_SN);
	}
	
}

//초기화
function fn_reset(){
	$("#sFrm input[name=CMMN_SN]").val("");
	$("#sFrm input[name=CMMN_NM]").val("");
}

//검색
function fn_search(){
	fnPageLoad("${pageContext.request.contextPath}/code/selectCodeList.kspo",$("#sFrm").serialize());
}

//대분류 저장
function fn_preMstSave(){
	if(fnSaveMstVaild()){
		fnSaveMst();
	}
}

//소분류 저장
function fn_preDtlSave(){
	if(fnSaveDtlVaild()){
		fnSaveDtl();
	}
}

//대분류 정보 삭제
function fn_preMstDel(){
	var $json = getJsonData("post", "${pageContext.request.contextPath}/code/deleteCodeMstJs.kspo", $("#mFrm").serialize());
	if($json.statusText == "OK"){
		fn_search();
	}
}

//소분류 정보 삭제
function fn_preDtlDel(){
	var $json = getJsonData("post", "${pageContext.request.contextPath}/code/deleteCodeDtlJs.kspo", $("#dFrm").serialize());
	if($json.statusText == "OK"){
		fn_DtlList(GLOBAL_CMMN_SN);
	}
}

//소분류코드 조회
function fn_DtlList(CMMN_SN){
	GLOBAL_CMMN_SN = CMMN_SN;
	var param = "CMMN_SN=" + CMMN_SN;
	param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val(); 
	var $json = getJsonData("post", "${pageContext.request.contextPath}/code/selectCodeDtlListJs.kspo", param);
	var dtlObj = "";	
	if($json.statusText == "OK"){
		var dtlList = $json.responseJSON.codeDtlList;
		if(dtlList.length > 0){
			for(var i=0;i<dtlList.length;i++){
				dtlObj += "<tr>";
				dtlObj += "<td>";
				dtlObj += "<input id='check02-" + i + "' name='dtlChk' type='checkbox' value='" + dtlList[i].MJRSN + "'/>";
				dtlObj += "<label for='check02-" + i + "' class='chk-only'></label>";
				dtlObj += "<input type='hidden' name='CMMN_SN' value='" + dtlList[i].CMMN_SN + "'>";
				dtlObj += "<input type='hidden' name='MJRSN' value='" + dtlList[i].MJRSN + "'>";
				dtlObj += "<input type='hidden' name='CNTNT_FST' value='" + dtlList[i].CNTNT_FST + "'>";
				dtlObj += "<input type='hidden' name='ALT_CODE' value='" + dtlList[i].ALT_CODE + "'>";
				dtlObj += "<input type='hidden' name='ORD' value='" + dtlList[i].ORD + "'>";
				dtlObj += "<input type='hidden' name='USE_YN' value='" + dtlList[i].USE_YN + "'>";
				dtlObj += "<input type='hidden' name='CNTNT_SND' value='" + dtlList[i].CNTNT_SND + "'>";
				dtlObj += "</td>";
				dtlObj += "<td>" + dtlList[i].CMMN_SN + "</td>";
				dtlObj += "<td>" + dtlList[i].MJRSN + "</td>";
				dtlObj += "<td class='left'>" + dtlList[i].CNTNT_FST + "</td>";
				dtlObj += "<td>" + dtlList[i].ALT_CODE + "</td>";
				dtlObj += "<td>" + dtlList[i].ORD + "</td>";
				dtlObj += "<td>" + dtlList[i].USE_YN + "</td>";
				dtlObj += "<td>" + dtlList[i].CNTNT_SND + "</td>";
				dtlObj += "<td>" + dtlList[i].REG_DT + "</td>";
				dtlObj += "<td>" + dtlList[i].REGR_ID + "</td>";
				dtlObj += "<td>" + dtlList[i].UPDT_DT + "</td>";
				dtlObj += "<td>" + dtlList[i].UPDR_ID + "</td>";
				dtlObj += "<td class='input-td'><button type='button' class='btn red checking' name='btnUpdateDtl'>수정</button></td>";
				dtlObj += "</tr>";
			}
		}else{
			dtlObj += "<tr><td colspan='12' class='blank'>검색결과가 존재하지 않습니다.</td></tr>";
		}
		$("#dtlTbody").html(dtlObj);
	}
}

//대분류 정보 저장 확인
function fnSaveMstVaild(){
		
	if($("#mpFrm input[name=CMMN_NM]").val() == ""){
		fnAlert("대분류코드명을 입력하시기 바랍니다.");
		$("#mpFrm input[name=CMMN_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#mpFrm input[name=CMMN_NM]").val())>50){
		var length = fnGetTxtLength(50);
		fnAlert("대분류코드명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#mpFrm input[name=CMMN_NM]").focus();
		return false;
	}
	
	return true;
}

//대분류 정보 저장
function fnSaveMst(){
	var CMMN_SN  = $("#mpFrm").find("input[name=CMMN_SN]").val();
	var saveUrl = "${pageContext.request.contextPath}/code/insertCodeMstJs.kspo";
	
	if(typeof CMMN_SN != "undefined" && CMMN_SN != null && CMMN_SN != ""){
		saveUrl = "${pageContext.request.contextPath}/code/updateCodeMstJs.kspo";
	}
	
	var $json = getJsonData("post", saveUrl, $("#mpFrm").serialize());
	if($json.statusText == "OK"){
		mstCodePopClose();
		fn_search();	
	}
}

//소분류 정보 저장 확인
function fnSaveDtlVaild(){
	
	var regexp = /^[0-9]*$/;
	
	if($("#dpFrm input[name=CNTNT_FST]").val() == ""){
		fnAlert("소분류코드명을 입력하시기 바랍니다.");
		$("#dpFrm input[name=CNTNT_FST]").focus();
		return false;
	}
	
	if(fnGetByte($("#dpFrm input[name=CNTNT_FST]").val())>200){
		var length = fnGetTxtLength(200);
		fnAlert("소분류코드명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dpFrm input[name=CNTNT_FST]").focus();
		return false;
	}
	
	if($("#dpFrm input[name=ALT_CODE]").val() == ""){
		fnAlert("값을 입력하시기 바랍니다.");
		$("#dpFrm input[name=ALT_CODE]").focus();
		return false;
	}
	
	if(fnGetByte($("#dpFrm input[name=ALT_CODE]").val())>10){
		var length = fnGetTxtLength(10);
		fnAlert("값 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dpFrm input[name=ALT_CODE]").focus();
		return false;
	}
	
	if($("#dpFrm input[name=ORD]").val() == ""){
		fnAlert("정렬순서를 입력하시기 바랍니다.");
		$("#dpFrm input[name=ORD]").focus();
		return false;
	}
	
	if($("#dpFrm input[name=ORD]").val().length>6){
		fnAlert("정렬순서 길이를 초과하였습니다.<br/>(최대 " + 6 + "자리까지 입력가능)");
		$("#dpFrm input[name=ORD]").focus();
		return false;
	}
	
	if(!regexp.test($("#dpFrm input[name=ORD]").val())){
		fnAlert("숫자만 입력 가능합니다.");
		$("#dpFrm input[name=ORD]").focus();
		return false;
	}
	
	return true;
}

//소분류 정보 저장
function fnSaveDtl(){
	var CMMN_SN  = $("#dpFrm").find("input[name=CMMN_SN]").val();
	var MJRSN  = $("#dpFrm").find("input[name=MJRSN]").val();
	var saveUrl = "${pageContext.request.contextPath}/code/insertCodeDtlJs.kspo";

	if(typeof MJRSN != "undefined" && MJRSN != null && MJRSN != ""){
		saveUrl = "${pageContext.request.contextPath}/code/updateCodeDtlJs.kspo";
	}

	var $json = getJsonData("post", saveUrl, $("#dpFrm").serialize());
	if($json.statusText == "OK"){
		dtlCodePopClose();
		fn_DtlList(CMMN_SN);
	}
}


//대분류코드 등록 수정 팝업 열기
function mstCodePopOpen(saveGbn){
	if(saveGbn == "1"){
		$("button[name=btnMstSave]").html("수정");	
	}else{
		$("button[name=btnMstSave]").html("등록");
	}
	$(".cpt-popup.reg.mstCodePop").addClass("active")
	$("body").css("overflow", "hidden")
}

//대분류코드 등록 수정 팝업 닫기
function mstCodePopClose() {
	$("#mpFrm input[name=CMMN_SN]").val("");
	$("#mpFrm input[name=CMMN_NM]").val("");
	$(".cpt-popup.reg.mstCodePop").removeClass("active")
	$("body").css("overflow","auto")
}

//소분류코드 등록 수정 팝업 열기
function dtlCodePopOpen(saveGbn){
	if(saveGbn == "1"){
		$("button[name=btnDtlSave]").html("수정");	
	}else{
		$("button[name=btnDtlSave]").html("등록");
	}
	
	$("#dpFrm input[name=CMMN_SN]").val(GLOBAL_CMMN_SN);
	$(".cpt-popup.reg.dtlCodePop").addClass("active")
	$("body").css("overflow", "hidden")
}

//소분류코드 등록 수정 팝업 닫기
function dtlCodePopClose() {
	$("#dpFrm input[name=CMMN_SN]").val("");
	$("#dpFrm input[name=MJRSN]").val("");
	$("#dpFrm input[name=CNTNT_FST]").val("");
	$("#dpFrm input[name=ALT_CODE]").val("");
	$("#dpFrm input[name=ORD]").val("");
	$("#dpFrm select[name=USE_YN]").val("Y");
	$("#dpFrm input[name=CNTNT_SND]").val("");
	$(".cpt-popup.reg.dtlCodePop").removeClass("active")
	$("body").css("overflow","auto")
}

</script>
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>공통코드 관리</h2>
	</div>
	<!-- //타이틀 -->

	<!-- 검색/조회 영역 -->
	<div class="cpt-search">
		<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/code/selectCodeList.kspo">
			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<ul class="search-list">
				<li class="search-item">
					<dl>
						<dt>대분류 코드</dt>
						<dd>
							<input type="text" class="expand" title="대분류코드 입력" name="CMMN_SN" value="${param.CMMN_SN}" onkeydown="if(event.keyCode == 13){fn_search();return false;}" >
						</dd>
					</dl>
				</li>
				<li class="search-item">
					<dl>
						<dt>대분류 코드명</dt>
						<dd>
							<input type="text" class="expand" title="코드명 입력" name="CMMN_NM" value="${param.CMMN_NM}" onkeydown="if(event.keyCode == 13){fn_search();return false;}" >
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
			<button class="btn red grid" type="button" onclick="mstCodePopOpen();">추가</button>
		</div>
	</div>
	<!-- //조건/버튼 영역 -->

	<!-- 그리드 영역 (대분류) -->
	<div class="com-grid">
		<form method="post" id="mFrm" name="mFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col width="6.389%" />
					<col width="10.587%" />
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
								<input id="checkall01" type="checkbox" name="mstChkAll"/>
								<label for="checkall01" class="chk-only"></label>
							</div>
						</th>
						<th>대분류코드</th>
						<th>대분류코드명</th>
						<th>생성일자</th>
						<th>생성자</th>
						<th>수정일자</th>
						<th>수정자</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody id="mstTbody">

					<c:choose>
						<c:when test="${not empty codeMstList}">
							<c:forEach items="${codeMstList}" var="mstLi" varStatus="state">
								<tr>
									<td>
										<div class="input-box">
											<input id="check01-${state.count}" type="checkbox" name="mstChk" value="${mstLi.CMMN_SN}"/>
											<label for="check01-${state.count}" class="chk-only"></label>
										</div>
										<input type="hidden" name="CMMN_SN" value="${mstLi.CMMN_SN}">
										<input type="hidden" name="CMMN_NM" value="${mstLi.CMMN_NM}">
									</td>
									<td>${mstLi.CMMN_SN}</td>
									<td class="left"><a href="#" class="tit" onclick="fn_DtlList('${mstLi.CMMN_SN}')">${mstLi.CMMN_NM}</a></td>
									<td>${mstLi.REG_DT}</td>
									<td>${mstLi.REGR_ID}</td>
									<td>${mstLi.UPDT_DT}</td>
									<td>${mstLi.UPDR_ID}</td>
									<td class="input-td"><button type="button" class="btn red checking" name="btnUpdateMst">수정</button></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="8" class="blank">검색결과가 존재하지 않습니다.</td></tr>						
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</form>
	</div>
	<!-- //그리드 영역 (대분류) -->

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
			<button class="btn red grid" type="button" onclick="dtlCodePopOpen();">추가</button>
		</div>
	</div>
	<!-- //조건/버튼 영역 -->

	<!-- 그리드 영역 (소분류) -->
	<div class="com-grid">
		<form method="post" id="dFrm" name="dFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col width="5%" />
					<col width="7%" />
					<col width="10%" />
					<col width="auto" />
					<col width="5%" />
					<col width="6%" />
					<col width="6%" />
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
						<th>대분류코드</th>
						<th>소분류코드</th>
						<th>소분류코드명</th>
						<th>값</th>
						<th>정렬순서</th>
						<th>사용유무</th>
						<th>비고</th>
						<th>생성일자</th>
						<th>생성자</th>
						<th>수정일자</th>
						<th>수정자</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody id="dtlTbody">
					<tr><td colspan="12" class="blank">검색결과가 존재하지 않습니다.</td></tr>
				</tbody>
			</table>
		</form>
	</div>
	<!-- //그리드 영역 (소분류) -->

	<!-- 버튼 영역 -->
	<div class="com-btn-group put">
		<button class="btn navy rmvcrr" type="button" name="btnDeleteDtl" onclick="fn_preDtlDel();">삭제</button>
	</div>
	<!-- //버튼 영역 -->
</div>

<!-- 대분류코드 등록 팝업 영역 -->
<div class="cpt-popup reg mstCodePop">
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			대분류코드
			<button class="pop-close" type="button" onclick="mstCodePopClose();">
				<img src="/common/images/common/icon_close.png" alt="">
			</button>
		</div>
		<form method="post" id="mpFrm" name="mpFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<div class="pop-body">
				<div class="com-table pop-tbl">
					<input type="hidden" name="CMMN_SN">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col width="135px" />
							<col width="auto" />
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">대분류코드명</td>
								<td class="input-td">
									<input type="text" name="CMMN_NM" title="대분류코드명 입력">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button class="btn save" type="button" name="btnMstSave" onclick="fn_preMstSave();">등록</button>
			</div>
		</form>
	</div>
</div>
<!-- //대분류코드 등록 팝업 영역 -->

<!-- 소분류코드 등록 팝업 영역 -->
<div class="cpt-popup reg dtlCodePop">
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			소분류코드
			<button class="pop-close" onclick="dtlCodePopClose();">
				<img src="/common/images/common/icon_close.png" alt="">
			</button>
		</div>
		<form method="post" id="dpFrm" name="dpFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<div class="pop-body">
				<div class="com-table pop-tbl">
					<input type="hidden" name="CMMN_SN">
					<input type="hidden" name="MJRSN">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col width="135px" />
							<col width="auto" />
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">소분류코드명</td>
								<td class="input-td">
									<input type="text" title="소분류코드명 입력" name="CNTNT_FST">
								</td>
							</tr>
							<tr>
								<td class="t-title">값</td>
								<td class="input-td">
									<input type="text" title="값 입력" name="ALT_CODE">
								</td>
							</tr>
							<tr>
								<td class="t-title">정렬순서</td>
								<td class="input-td">
									<input type="text" title="정렬순서 입력" name="ORD">
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
							<tr>
								<td class="t-title">비고</td>
								<td class="input-td">
									<input type="text" title="비고 입력" name="CNTNT_SND">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button class="btn save" type="button" name="btnDtlSave" onclick="fn_preDtlSave();">등록</button>
			</div>
		</form>
	</div>
</div>
<!-- //소분류코드 등록 팝업 영역 -->