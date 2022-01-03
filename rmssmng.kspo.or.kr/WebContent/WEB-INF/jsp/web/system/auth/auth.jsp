<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

$(document).ready(function(){
	fn_ready();
	
	
	
	
	
	//수정 팝업 오픈
	$(document).on("click","button[name=btnUpdate]",function(){
		$("#pFrm input[name=P_GRP_SN]").val($(this).parents("tr").find("input[name=PR_GRP_SN]").val());
		$("#pFrm input[name=AUTH_GRP_NM]").val($(this).parents("tr").find("input[name=AUTH_GRP_NM]").val());
		$("#pFrm select[name=USE_YN]").val($(this).parents("tr").find("input[name=USE_YN]").val());
		$("#pFrm select[name=P_USER_DV]").val($(this).parents("tr").find("input[name=P_USER_DV]").val());
		authGrpPopOpen();
	});
	
	//권한그룹 전체 선택 해제
	$(document).on("click","#mFrm input[name=mstChkAll]",function(){
		$(this).parents("table").find("input[name=chk]").prop("checked",$(this).is(":checked"));
		$(this).parents("table").find("input[name=chk]").attr("checked",$(this).is(":checked"));
	});
	
	//권한그룹 선택 해제
	$(document).on("click","#mFrm input[name=chk]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=chk]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("input[name=mstChkAll]").prop("checked",checked);
		$("input[name=mstChkAll]").attr("checked",checked);
	});
	
	//권한상세 선택
	$(document).on("click","#dFrm thead input[type=checkbox]",function(){
		if($(this).val() == "read"){
			$(this).parents("table").find("input[name=READ_YN]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=READ_YN]").attr("checked",$(this).is(":checked"));
		}else if($(this).val() == "write"){
			$(this).parents("table").find("input[name=WRITE_YN]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=WRITE_YN]").attr("checked",$(this).is(":checked"));
		}else if($(this).val() == "prvcMask"){
			$(this).parents("table").find("input[name=PRI_MASK_YN]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=PRI_MASK_YN]").attr("checked",$(this).is(":checked"));
		}else if($(this).val() == "prvc"){
			$(this).parents("table").find("input[name=PRI_INCLS_YN]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=PRI_INCLS_YN]").attr("checked",$(this).is(":checked"));
		}else if($(this).val() == "excel"){
			$(this).parents("table").find("input[name=EXCEL_YN]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=EXCEL_YN]").attr("checked",$(this).is(":checked"));
		}
	});
	
	//읽기
	$(document).on("click","#dFrm input[name=READ_YN]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=READ_YN]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("#checkall01").prop("checked",checked);
		$("#checkall01").attr("checked",checked);
	});
	
	//저장
	$(document).on("click","#dFrm input[name=WRITE_YN]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=WRITE_YN]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("#checkall02").prop("checked",checked);
		$("#checkall02").attr("checked",checked);
	});
	
	//개인정보마스킹
	$(document).on("click","#dFrm input[name=PRI_MASK_YN]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=PRI_MASK_YN]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("#checkall03").prop("checked",checked);
		$("#checkall03").attr("checked",checked);
	});
	
	//개인정보
	$(document).on("click","#dFrm input[name=PRI_INCLS_YN]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=PRI_INCLS_YN]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("#checkall04").prop("checked",checked);
		$("#checkall04").attr("checked",checked);
	});

	//엑셀다운
	$(document).on("click","#dFrm input[name=EXCEL_YN]",function(){
		var checked = true;
		$(this).parents("tbody").find("input[name=EXCEL_YN]").each(function(){
			if(!$(this).is(":checked")){
				checked = false;
			}
		});
		
		$("#checkall05").prop("checked",checked);
		$("#checkall05").attr("checked",checked);
	});
});

//시작시 호출
function fn_ready(){
	var P_GRP_SN = $("#mstTbody").find("input[name=PR_GRP_SN]").eq(0).val();
	if(typeof P_GRP_SN != "undefined" && P_GRP_SN != null && P_GRP_SN != ""){//조회된 값이 있는 경우
		fn_DtlList(P_GRP_SN);
	}
}

//검색
function fn_search(){
	fnPageLoad("${pageContext.request.contextPath}/auth/selectAuthList.kspo",$("#sFrm").serialize());
}

//권한 그룹 저장
function preAuthSave(){
	if(fnSaveVaild()){
		fnSave();
	}
}

//권한상세 수정
function preAuthUpd(){
	fn_margeYnData();
	var $json = getJsonData("post", "${pageContext.request.contextPath}/auth/updateAuthDtlJs.kspo", $("#dFrm").serialize());
	if($json.statusText == "OK"){
		fn_DtlList($("#dFrm input[name=P_GRP_SN]").val());
	}
}

//권한그룹 삭제
function preAuthDel(){
	var checkedFlag = false; 	
	
	if($('input[name=chk]:checked').length > 0){
		checkedFlag = true;
	}
	
	if(!checkedFlag){
		fnAlert("삭제할 권한그룹을 선택해주세요.");
		return false;
	} else {
		var $json = getJsonData("post", "${pageContext.request.contextPath}/auth/deleteAuthMstJs.kspo", $("#mFrm").serialize());
		if($json.statusText == "OK"){
			fn_search();
		}	
	}
}

//상세조회
function fn_DtlList(P_GRP_SN){
	$("#dFrm input[name=P_GRP_SN]").val(P_GRP_SN);
	var param = "P_GRP_SN=" + P_GRP_SN;
	param += "&gMenuSn=" + $("#dFrm input[name=gMenuSn]").val();
	var $json = getJsonData("post", "${pageContext.request.contextPath}/auth/selectAuthDtlListJs.kspo", param);
	if($json.statusText == "OK"){
		var dtlObj = "";
		var dtlList = $json.responseJSON.authDtlList;
		
		if(dtlList.length > 0){
			for(var i=0;i<dtlList.length;i++){
				if(dtlList[i].MENU_LEVEL != 1){
					dtlObj += "<tr>";
					dtlObj += "<td class='margeMenuNm'>";
					if(dtlList[i].UP_MENU_NM != null && dtlList[i].UP_MENU_NM != ""){
						dtlObj += dtlList[i].UP_MENU_NM;
					}else{
						dtlObj += dtlList[i].MENU_NM;
					}
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					if(dtlList[i].UP_MENU_NM != null && dtlList[i].UP_MENU_NM != ""){
						dtlObj += dtlList[i].MENU_NM;
					}
					dtlObj += "<input type='hidden' name='DETAIL_SN' value='" + dtlList[i].DETAIL_SN + "'/>";
					dtlObj += "<input type='hidden' name='MENU_SN' value='" + dtlList[i].MENU_SN + "'/>";
					dtlObj += "<input type='hidden' name='ynData'/>";
					dtlObj += "<input type='hidden' name='dataType'/>";
					dtlObj += "<input type='hidden' name='orgData' value='" + dtlList[i].READ_YN + dtlList[i].WRITE_YN + dtlList[i].PRI_MASK_YN + dtlList[i].PRI_INCLS_YN + dtlList[i].EXCEL_YN + "'/>";
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					dtlObj += "<div class='input-box'>";
					dtlObj += "<input id='check01-" + i + "' type='checkbox' name='READ_YN' value='Y'";
					if(dtlList[i].READ_YN == "Y"){
						dtlObj += "checked='checked'";
					}
					dtlObj += "'/>";
					dtlObj += "<label for='check01-" + i + "' class='chk-only'></label>";
					dtlObj += "</div>";
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					dtlObj += "<div class='input-box'>";
					dtlObj += "<input id='check02-" + i + "' type='checkbox' name='WRITE_YN' value='Y'";
					if(dtlList[i].WRITE_YN == "Y"){
						dtlObj += "checked='checked'";
					}
					dtlObj += "'/>";
					dtlObj += "<label for='check02-" + i + "' class='chk-only'></label>";
					dtlObj += "</div>";
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					dtlObj += "<div class='input-box'>";
					dtlObj += "<input id='check03-" + i + "' type='checkbox' name='PRI_MASK_YN' value='Y'";
					if(dtlList[i].PRI_MASK_YN == "Y"){
						dtlObj += "checked='checked'";
					}
					dtlObj += "'/>";
					dtlObj += "<label for='check03-" + i + "' class='chk-only'></label>";
					dtlObj += "</div>";
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					dtlObj += "<div class='input-box'>";
					dtlObj += "<input id='check04-" + i + "' type='checkbox' name='PRI_INCLS_YN' value='Y'";
					if(dtlList[i].PRI_INCLS_YN == "Y"){
						dtlObj += "checked='checked'";
					}
					dtlObj += "'/>";
					dtlObj += "<label for='check04-" + i + "' class='chk-only'></label>";
					dtlObj += "</div>";
					dtlObj += "</td>";
					
					dtlObj += "<td>";
					dtlObj += "<div class='input-box'>";
					dtlObj += "<input id='check05-" + i + "' type='checkbox' name='EXCEL_YN' value='Y'";
					if(dtlList[i].EXCEL_YN == "Y"){
						dtlObj += "checked='checked'";
					}
					dtlObj += "'/>";
					dtlObj += "<label for='check05-" + i + "' class='chk-only'></label>";
					dtlObj += "</div>";
					dtlObj += "</td>";
					
					dtlObj += "</tr>";
				}
			}
		}else{
			dtlObj += "<tr><td colspan='5' class='blank'>검색결과가 존재하지 않습니다.</td></tr>";
		}

		$("#dtlTbody").html(dtlObj);
		fn_margeCell();
	}
	
}

//셀병합
function fn_margeCell(){
	$(".margeMenuNm").each(function(){
		var rows = $(".margeMenuNm:contains('" + $(this).text() +  "')");
		if(rows.length > 1){
			rows.eq(0).attr("rowspan",rows.length);
			rows.not(":eq(0)").hide();
		}
	});
	fn_margeYnData();
}

//권한 그룹 저장 확인
function fnSaveVaild(){

	if($("#pFrm input[name=AUTH_GRP_NM]").val() == ""){
		fnAlert("권한그룹명를 입력하시기 바랍니다.");
		$("#pFrm input[name=AUTH_GRP_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#pFrm input[name=AUTH_GRP_NM]").val())>50){
		var length = fnGetTxtLength(50);
		fnAlert("권한그룹명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#pFrm input[name=AUTH_GRP_NM]").focus();
		return false;
	}
	
	return true;
}

//권한 그룹 저장
function fnSave(){
	var P_GRP_SN  = $("#pFrm").find("input[name=P_GRP_SN]").val();
	var saveUrl = "${pageContext.request.contextPath}/auth/insertAuthMstJs.kspo";
	
	if(typeof P_GRP_SN != "undefined" && P_GRP_SN != null && P_GRP_SN != ""){
		saveUrl = "${pageContext.request.contextPath}/auth/updateAuthMstJs.kspo";
	}
	
	var $json = getJsonData("post", saveUrl, $("#pFrm").serialize());
	
	if($json.statusText == "OK"){
		authGrpPopClose();
		fn_search();
	}
}

//권한정보 업데이트
function fn_margeYnData(){
	$("input[name=ynData]").each(function(){
		var ynData = "";
		
		if($(this).parents("tr").find("input[name=READ_YN]").is(":checked")){
			ynData += "Y";
		}else{
			ynData += "N";
		}
		if($(this).parents("tr").find("input[name=WRITE_YN]").is(":checked")){
			ynData += "Y";
		}else{
			ynData += "N";
		}
		if($(this).parents("tr").find("input[name=PRI_MASK_YN]").is(":checked")){
			ynData += "Y";
		}else{
			ynData += "N";
		}
		if($(this).parents("tr").find("input[name=PRI_INCLS_YN]").is(":checked")){
			ynData += "Y";
		}else{
			ynData += "N";
		}
		if($(this).parents("tr").find("input[name=EXCEL_YN]").is(":checked")){
			ynData += "Y";
		}else{
			ynData += "N";
		}
		$(this).val(ynData);
		if($(this).parents("tr").find("input[name=DETAIL_SN]").val() != "" && $(this).parents("tr").find("input[name=DETAIL_SN]").val() != null){
			if($(this).parents("tr").find("input[name=orgData]").val() != ynData){
				$(this).parents("tr").find("input[name=dataType]").val("U");
			}
		}else{
			$(this).parents("tr").find("input[name=dataType]").val("I");
		}
		
	});
}

//권한그룹 등록 수정 팝업 열기
function authGrpPopOpen(){
	$(".cpt-popup.reg.authGrpPop").addClass("active")
	$("body").css("overflow", "hidden")
}

//권한그룹 등록 수정 팝업 닫기
function authGrpPopClose() {
	$("#pFrm input[name=P_GRP_SN]").val("");
	$("#pFrm input[name=AUTH_GRP_NM]").val("");
	$("#pFrm select[name=USE_YN]").val("Y");
	$("#pFrm select[name=P_USER_DV]").val("1");
	$(".cpt-popup.reg.authGrpPop").removeClass("active")
	$("body").css("overflow","auto")
}

</script>
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>권한 관리</h2>
	</div>
	<!-- //타이틀 -->
	<!-- 탭 컨텐츠 -->
	<ul class="tab-contents type02 tabsystem">
		<li class="user-set">
			<div class="user-list">
				<div class="com-h3">
					권한 그룹 목록
				</div>
				<div class="box-area">
					<!-- 검색/조회 영역 -->
					<div class="cpt-search type03 mgb-15">
						<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/auth/selectAuthList.kspo">
							<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
							<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
							<ul class="search-list">
								<li class="search-item">
									<dl>
										<dt>사용자구분</dt>
										<dd>
											<select title="사용자구분 선택" name="S_USER_DV">
												<option value="" <c:if test="${param.S_USER_DV eq '' or param.S_USER_DV eq null}">selected="selected"</c:if>>전체</option>
												<c:forEach items="${userDvList}" var="subLi">
													<option value="${subLi.ALT_CODE}" <c:if test="${param.S_USER_DV eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
												</c:forEach>
											</select>
										</dd>
									</dl>
								</li>
								<li class="search-item">
									<dl>
										<dt>사용여부</dt>
										<dd>
											<select title="사용여부 선택" name="USE_YN">
												<option value="" <c:if test="${param.USE_YN eq '' or param.USE_YN eq null}">selected="selected"</c:if>>전체</option>
												<option value="Y" <c:if test="${param.USE_YN eq 'Y'}">selected="selected"</c:if>>예</option>
												<option value="N" <c:if test="${param.USE_YN eq 'N'}">selected="selected"</c:if>>아니요</option>
											</select>
										</dd>
									</dl>
								</li>
								<li class="search-item">
									<dl>
										<dt>그룹명</dt>
										<dd>
											<input type="text" title="그룹명 입력" name="AUTH_GRP_NM" value="${param.AUTH_GRP_NM}" onkeydown="if(event.keyCode == 13){fn_search();return false;}" >
										</dd>
									</dl>
								</li>
								<li class="search-item search-btn">
									<button class="btn navy put-search" type="button" onclick="fn_search();">검색</button>
								</li>
							</ul>
						</form>
					</div>
					<!-- //검색/조회 영역 -->

					<!-- 조건/버튼 영역 -->
					<div class="com-result">
						<div class="float-l">
							<span class="total-num">전체<b>${pageInfo.totalRecordCount}</b>개</span>
							<span class="now-page bar-front">현재페이지 ${pageInfo.currentPageNo}/${pageInfo.totalPageCount}</span>
						</div>
						<div class="float-r">
							<button class="btn red grid" type="button" onclick="authGrpPopOpen();">추가</button>
						</div>
					</div>
					<!-- //조건/버튼 영역 -->

					<!-- 그리드 영역 (권한그룹목록) -->
					<div class="com-grid user-grid02">
						<form method="post" id="mFrm" name="mFrm" onsubmit="return false;">
							<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
							<table class="table-grid">
								<caption></caption>
								<colgroup>
									<col width="6.065%" />
									<col width="11.958%" />
									<col width="auto" />
									<col width="10.745%" />
									<col width="17.331%" />
									<col width="15.424%" />
									<col width="11.265%" />
									<col width="12%" />
								</colgroup>
								<thead>
									<tr>
										<th>
											<div class="input-box">
												<input id="checkall" type="checkbox" name="mstChkAll"/>
												<label for="checkall" class="chk-only"></label>
											</div>
										</th>
										<th>그룹ID</th>
										<th>권한그룹명</th>
										<th>사용여부</th>
										<th>사용자구분</th>
										<th>생성일자</th>
										<th>생성자</th>
										<th>수정</th>
									</tr>
								</thead>
								<tbody id="mstTbody">
									<c:choose>
										<c:when test="${not empty authList}">
											<c:forEach items="${authList}" var="li" varStatus="state">
												<tr>
													<td>
														<div class="input-box">
															<input id="check${state.count}" type="checkbox" name="chk" value="${li.P_GRP_SN}"/>
															<label for="check${state.count}" class="chk-only"></label>
														</div>
														<input type="hidden" name="PR_GRP_SN" value="${li.P_GRP_SN}">
														<input type="hidden" name="AUTH_GRP_NM" value="${li.AUTH_GRP_NM}">
														<input type="hidden" name="USE_YN" value="${li.USE_YN}">
														<input type="hidden" name="P_USER_DV" value="${li.P_USER_DV}">
													</td>
													<td>${li.P_GRP_SN}</td>
													<td><a href="javascript:fn_DtlList('${li.P_GRP_SN}');" class="tit">${li.AUTH_GRP_NM}</a></td>
													<td>${li.USE_YN}</td>
													<td>${li.USER_DV_NM}</td>
													<td>${li.REG_DTM}</td>
													<td>${li.REGR_ID}</td>
													<td class="input-td">
														<button class="btn red checking" type="button" name="btnUpdate">수정</button>
													</td>
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
					<!-- //그리드 영역 (권한그룹목록) -->

					<!-- 버튼 영역 -->
					<div class="com-btn-group put">
						<button class="btn navy rmvcrr" type="button" name="btnDelete" onclick="preAuthDel();">삭제</button>
					</div>
					<!-- //버튼 영역 -->

					<!-- 페이징 영역 -->
					<div class="com-paging">
						<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:sFrm" />
					</div>
					<!-- //페이징 영역 -->
				</div>
			</div>
			<div class="user-info">
				<div class="com-h3">
					권한 설정
					<!-- <p class="required">필수입력</p> -->
				</div>
				<div class="box-area">
					<!-- 그리드 영역 (권한설정)-->
					<div class="com-grid user-grid02">
						<form method="post" id="dFrm" name="dFrm" onsubmit="return false;">
							<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
							<input type="hidden" name="P_GRP_SN">
							<table class="table-grid">
								<caption></caption>
								<colgroup>
									<col width="13%" />
									<col width="auto" />
									<col width="12%" />
									<col width="12%" />
									<col width="17%" />
									<col width="13%" />
									<col width="13%" />
								</colgroup>
								<thead>
									<tr>
										<th>대메뉴명</th>
										<th>소메뉴명</th>
										<th>
											<div class="input-box">
												<input id="checkall01" type="checkbox" value="read"/>
												<label for="checkall01">읽기</label>
											</div>
										</th>
										<th>
											<div class="input-box">
												<input id="checkall02" type="checkbox" value="write"/>
												<label for="checkall02">저장</label>
											</div>
										</th>
										<th>
											<div class="input-box">
												<input id="checkall03" type="checkbox" value="prvcMask"/>
												<label for="checkall03">개인정보마스킹</label>
											</div>
										</th>
										<th>
											<div class="input-box">
												<input id="checkall04" type="checkbox" value="prvc"/>
												<label for="checkall04">개인정보</label>
											</div>
										</th>
										<th>
											<div class="input-box">
												<input id="checkall05" type="checkbox" value="excel"/>
												<label for="checkall05">엑셀다운</label>
											</div>
										</th>
									</tr>
								</thead>
								<tbody id="dtlTbody">
									<tr><td colspan="5" class="blank">검색결과가 존재하지 않습니다.</td></tr>
								</tbody>
							</table>
						</form>
					</div>
					<!-- //그리드 영역 (권한설정) -->
				</div>
			</div>
			<div class="com-btn-group user-save">
				<button class="btn red write" type="button" name="btnDtlSave" onclick="preAuthUpd();">저장</button>
			</div>
		</li>
	</ul>
	<!-- //탭 컨텐츠 -->
</div>

<!-- 권한 그룹 등록 팝업 영역 -->
<div class="cpt-popup reg authGrpPop">
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			권한 그룹 등록
			<button class="pop-close" type="button" onclick="authGrpPopClose();">
				<img src="/common/images/common/icon_close.png" alt="">
			</button>
		</div>
		<form method="post" id="pFrm" name="pFrm" onsubmit="return false;">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<input type="hidden" name="P_GRP_SN">
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
								<td class="t-title">권한그룹명</td>
								<td class="input-td">
									<input type="text" name="AUTH_GRP_NM" title="권한그룹명 입력">
								</td>
							</tr>
							<tr>
								<td class="t-title">사용여부</td>
								<td class="input-td">
									<div class="com-select-list">
										<select name="USE_YN" title="사용여부 선택">
											<option value="Y">예</option>
											<option value="N">아니오</option>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td class="t-title">사용자구분</td>
								<td class="input-td">
									<div class="com-select-list">
										<select name="P_USER_DV" title="사용자구분 선택">
											<c:forEach items="${userDvList}" var="subLi">
												<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
											</c:forEach>
										</select>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<button class="btn save" type="button" id="authBtnSave" onclick="preAuthSave();">등록</button>
			</div>
		</form>
	</div>
</div>
<!-- //권한 그룹 등록 팝업 영역 -->