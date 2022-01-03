<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!--For Commons Validator Client Side-->
    <script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/cmmn/validator.kspo'/>"></script>
    <validator:javascript formName="sampleVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script type="text/javascript">

$(document).ready(function(){
	fn_ready();
	
	//사용자구분 변경
	$(document).on("change","#dFrm select[name=USER_DV]",function(){
		fn_grpSnList($(this).val());
	});
	
});

//시작시 호출
function fn_ready(){
	var MNGR_SN = $("#mstTbody").find("input[name=MNGR_SN]").eq(0).val();
	if(typeof MNGR_SN != "undefined" && MNGR_SN != null && MNGR_SN != ""){//조회된 값이 있는 경우
		fn_DtlList(MNGR_SN);
	}
}

//검색
function fn_search(){
	fnPageLoad("${pageContext.request.contextPath}/user/selectUserList.kspo",$("#sFrm").serialize());
}

//권한그룹 조회
function fn_grpSnList(USER_DV){
	var param = "USER_DV=" + USER_DV;
	param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
	var $json = getJsonData("post", "${pageContext.request.contextPath}/auth/selectDefaultAuthMstListJs.kspo", param);
	
	var grpSnObj = "<option value=''>선택</option>";
		
	if($json.statusText == "OK"){		
		
		var grpSnList = $json.responseJSON.grpSnList;
		if(grpSnList.length > 0){
			for(var i=0;i<grpSnList.length;i++){
								
				grpSnObj += "<option value='" + grpSnList[i].GRP_SN + "'>" + grpSnList[i].AUTH_GRP_NM + "</option>";
			}
		}
	}
	
	$("#dFrm select[name=GRP_SN]").html(grpSnObj);
}

//상세조회
function fn_DtlList(MNGR_SN){
	var param = "MNGR_SN=" + MNGR_SN;
	param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
	var $json = getJsonData("post", "${pageContext.request.contextPath}/user/selectUserDtlListJs.kspo", param);
	
	var userDvObj = "<option value=''>선택</option>";
	var grpSnObj = "<option value=''>선택</option>";
	
	if($json.statusText == "OK"){
		
		var userDvList = $json.responseJSON.userDvList;
		
		if(userDvList.length > 0){
			for(var i=0;i<userDvList.length;i++){
				userDvObj += "<option value='" + userDvList[i].ALT_CODE + "'>" + userDvList[i].CNTNT_FST + "</option>";
			}
		}
		
		var grpSnList = $json.responseJSON.grpSnList;
		
		if(grpSnList.length > 0){
			for(var i=0;i<grpSnList.length;i++){
				grpSnObj += "<option value='" + grpSnList[i].GRP_SN + "'>" + grpSnList[i].AUTH_GRP_NM + "</option>";
			}
		}
		
		var dtl = $json.responseJSON.userDtlInfo;
		$("#dFrm input[name=MNGR_SN]").val(dtl.MNGR_SN);
		$("#dFrm input[name=MNGR_NM]").val(dtl.MNGR_NM);
		$("#dFrm input[name=LOCGOV_NM]").val(dtl.LOCGOV_NM);
		$("#dFrm input[name=DEPT_NM]").val(dtl.DEPT_NM);
		$("#dFrm input[name=MNGR_ID]").val(dtl.MNGR_ID);
		$("#dFrm select[name=USER_DV]").val(dtl.USER_DV);
		$("#dFrm select[name=GRP_SN]").val(dtl.GRP_SN);
		$("#dFrm select[name=USE_YN]").val(dtl.USE_YN);
		
		$("#dFrm input[name=MNGR_ID]").attr("readonly",true);
		$("#dFrm input[name=MNGR_ID]").prop("readonly",true);
		$("#dFrm select[name=USER_DV]").html(userDvObj);
		$("#dFrm select[name=GRP_SN]").html(grpSnObj);
	}
}

//추가 버튼
function fn_addUser(){
	$("#dFrm input[name=MNGR_SN]").val("");
	$("#dFrm input[name=MNGR_NM]").val("");
	$("#dFrm input[name=LOCGOV_NM]").val("");
	$("#dFrm input[name=DEPT_NM]").val("");
	$("#dFrm input[name=MNGR_ID]").val("");
	$("#dFrm select[name=USER_DV]").val("");
	$("#dFrm select[name=GRP_SN]").val("");
	$("#dFrm select[name=GRP_SN]").html("<option value=''>선택</option>");
	$("#dFrm select[name=USE_YN]").val("Y");
	$("#dFrm input[name=MNGR_ID]").attr("readonly",false);
	$("#dFrm input[name=MNGR_ID]").prop("readonly",false);
}

//사용자 정보 저장
function fn_save(){
	if(!validateSampleVO(document.dFrm)){
        return;
	}
	if(fn_saveValid()){
		var MNGR_SN = $("#dFrm input[name=MNGR_SN]").val();
		var saveUrl = "${pageContext.request.contextPath}/user/inserUserDtlJs.kspo";
		
		if(typeof MNGR_SN != "undefined" && MNGR_SN != null && MNGR_SN != ""){
			saveUrl = "${pageContext.request.contextPath}/user/updateUserDtlJs.kspo";
		}
		
		var $json = getJsonData("post", saveUrl, $("#dFrm").serialize());
		if($json.statusText == "OK"){
			var result = $json.responseJSON.result;
			if(result.resultCode == "98"){
				fnAlert(result.resultMsg);
				if(typeof MNGR_SN != "undefined" && MNGR_SN != null && MNGR_SN != ""){
					fn_search();
				}
			}else{
				fnAlert("저장되었습니다.");
				fn_search();	
			}
		}
	}
}

function fn_saveValid(){
	
	//이름
	if($("#dFrm input[name=MNGR_NM]").val() == "" || $("#dFrm input[name=MNGR_NM]").val() == null){
		fnAlert("이름을 입력하시기 바랍니다.");
		$("#dFrm input[name=MNGR_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#dFrm input[name=MNGR_NM]").val())>50){
		var length = fnGetTxtLength(50);
		fnAlert("이름 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dFrm input[name=MNGR_NM]").focus();
		return false;
	}
	
	//소속
	if($("#dFrm input[name=LOCGOV_NM]").val() == "" || $("#dFrm input[name=LOCGOV_NM]").val() == null){
		fnAlert("소속을 입력하시기 바랍니다.");
		$("#dFrm input[name=LOCGOV_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#dFrm input[name=LOCGOV_NM]").val())>100){
		var length = fnGetTxtLength(100);
		fnAlert("소속 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dFrm input[name=LOCGOV_NM]").focus();
		return false;
	}
	
	//부서
	if($("#dFrm input[name=DEPT_NM]").val() == "" || $("#dFrm input[name=DEPT_NM]").val() == null){
		fnAlert("부서를 입력하시기 바랍니다.");
		$("#dFrm input[name=DEPT_NM]").focus();
		return false;
	}
	
	if(fnGetByte($("#dFrm input[name=DEPT_NM]").val())>100){
		var length = fnGetTxtLength(100);
		fnAlert("부서 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dFrm input[name=DEPT_NM]").focus();
		return false;
	}
	
	//사용자ID
	if($("#dFrm input[name=MNGR_ID]").val() == "" || $("#dFrm input[name=MNGR_ID]").val() == null){
		fnAlert("사용자ID를 입력하시기 바랍니다.");
		$("#dFrm input[name=MNGR_ID]").focus();
		return false;
	}
	
	if(fnGetByte($("#dFrm input[name=MNGR_ID]").val())>50){
		var length = fnGetTxtLength(50);
		fnAlert("사용자ID 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
		$("#dFrm input[name=MNGR_ID]").focus();
		return false;
	}
	
	//사용자구분
	if($("#dFrm select[name=USER_DV]").val() == "" || $("#dFrm select[name=USER_DV]").val() == null){
		fnAlert("사용자구분을 선택하시기 바랍니다.");
		$("#dFrm select[name=USER_DV]").focus();
		return false;
	}
	
	//권한그룹
	if($("#dFrm select[name=GRP_SN]").val() == "" || $("#dFrm select[name=GRP_SN]").val() == null){
		fnAlert("권한그룹을 선택하시기 바랍니다.");
		$("#dFrm select[name=GRP_SN]").focus();
		return false;
	}
	
	//사용여부
	if($("#dFrm select[name=USE_YN]").val() == "" || $("#dFrm select[name=USE_YN]").val() == null){
		fnAlert("사용여부를 선택하시기 바랍니다.");
		$("#dFrm select[name=USE_YN]").focus();
		return false;
	}
	
	return true;
}

// 삭제 버튼
function fn_deleteMng(){
	
	if(confirm("정말 삭제하시겠습니까?")){
		var $json = getJsonData("post", "${pageContext.request.contextPath}/user/deleteUserDtlJs.kspo", $("#mFrm").serialize());
		if($json.statusText == "OK"){
			fn_search();
		}
	}
}

</script>
<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>사용자 관리</h2>
		</div>
		<!-- //타이틀 -->
		<!-- 탭 컨텐츠 -->
		<ul class="tab-contents type02 tabsystem">
			<li class="user-set">
				<div class="user-list">
					<div class="com-h3">
						사용자 목록
					</div>
					<div class="box-area">
						<!-- 검색/조회 영역 -->
						<div class="cpt-search type03 mgb-15">
							<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/user/selectUserList.kspo">
								<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
								<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
								<ul class="search-list">
									<li class="search-item">
										<dl>
											<dt>사용자구분</dt>
											<dd>
												<select title="사용자구분 선택" name="USER_DV">
													<option value="" <c:if test="${param.USER_DV eq '' or param.USER_DV eq null}">selected="selected"</c:if>>전체</option>
													<c:forEach items="${userDvList}" var="subLi">
														<option value="${subLi.ALT_CODE}" <c:if test="${param.USER_DV eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
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
											<dt>키워드</dt>
											<dd>
												<select title="키워드 선택" class="category" name="keykind">
													<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
													<option value="MNGR_ID" <c:if test="${param.keykind eq 'MNGR_ID'}">selected="selected"</c:if>>사용자ID</option>
													<option value="MNGR_NM" <c:if test="${param.keykind eq 'MNGR_NM'}">selected="selected"</c:if>>이름</option>
													<option value="LOCGOV_NM" <c:if test="${param.keykind eq 'LOCGOV_NM'}">selected="selected"</c:if>>소속</option>
													<option value="DEPT_NM" <c:if test="${param.keykind eq 'DEPT_NM'}">selected="selected"</c:if>>부서</option>
												</select>
												<input type="text" style="width: 227px;" name="keyword" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
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
								<span class="total-num">전체<b>${pageInfo.totalRecordCount}</b>개
								</span><span class="now-page bar-front">현재페이지 ${pageInfo.currentPageNo}/${pageInfo.totalPageCount}</span>
							</div>
							<div class="float-r">
								<button class="btn red grid" type="button" onclick="fn_addUser();">추가</button>
							</div>
						</div>
						<!-- //조건/버튼 영역 -->

						<!-- 그리드 영역 (사용자목록) -->
						<div class="com-grid user-grid02">
							<form method="post" id="mFrm" name="mFrm" onsubmit="return false;">
								<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
								<table class="table-grid">
									<caption></caption>
									<colgroup>
										<col width="5.156%" />
										<col width="13.944%" />
										<col width="11.049%" />
										<col width="auto" />
										<col width="15.418%" />
										<col width="20.891%" />
										<col width="9.944%" />
									</colgroup>
									<thead>
										<tr>
											<th>
												<div class="input-box">
													<input id="checkall" type="checkbox" />
													<label for="checkall" class="chk-only"></label>
												</div>
											</th>
											<th>이름</th>
											<th>소속</th>
											<th>부서</th>
											<th>사용자ID</th>
											<th>사용자구분</th>
											<th>사용여부</th>
										</tr>
									</thead>
									<tbody id="mstTbody">
										<c:choose>
											<c:when test="${not empty userList}">
												<c:forEach items="${userList}" var="li" varStatus="state">
													<tr onclick="fn_DtlList('${li.MNGR_SN}');">
														<td>
															<div class="input-box">
																<input id="check${state.count}" type="checkbox" name="chk" value="${li.MNGR_SN}"/>
																<label for="check${state.count}" class="chk-only"></label>
															</div>
															<input type="hidden" name="MNGR_SN" value="${li.MNGR_SN}">
														</td>
														<td>${li.MNGR_NM}</td>
														<td>${li.LOCGOV_NM}</td>
														<td>${li.DEPT_NM}</td>
														<td>${li.MNGR_ID}</td>
														<td>${li.USER_DV_NM}</td>
														<td>${li.USE_YN}</td>
													</tr>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<tr><td colspan="9" class="blank">검색결과가 존재하지 않습니다.</td></tr>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</form>
						</div>
						<!-- //그리드 영역 (사용자목록) -->

						<!-- 버튼 영역 
						<div class="com-btn-group put">
							<button class="btn navy rmvcrr" type="button" onclick="fn_deleteMng();">삭제</button>
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
						사용자 정보
						<!-- <p class="required">필수입력</p> -->
					</div>
					<form:form commandName="sampleVO" method="post" id="dFrm" name="dFrm" onsubmit="return false;">
						<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
						<input type="hidden" name="MNGR_SN"/>
						<div class="box-area">
							<div class="infos">
								<dl class="information wdth100 mail">
									<dt>이름 </dt>
									<dd>
										<input type="text" title="이름 입력" name="MNGR_NM"/>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>소속</dt>
									<dd>
										<input type="text" title="소속 입력" name="LOCGOV_NM"/>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>부서</dt>
									<dd>
										<input type="text" title="부서 입력" name="DEPT_NM"/>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>사용자ID</dt>
									<dd>
										<input type="text" title="아이디 입력" name="MNGR_ID"/>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>사용자구분</dt>
									<dd>
										<select title="사용자구분 선택" name="USER_DV">
											<option value="">선택</option>
											<c:forEach items="${userDvList}" var="subLi">
												<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
											</c:forEach>
										</select>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>권한그룹</dt>
									<dd>
										<select title="권한그룹 선택" name="GRP_SN">
											<option value="">선택</option>
										</select>
									</dd>
								</dl>
								<dl class="information wdth100 mail">
									<dt>사용여부</dt>
									<dd>
										<select title="사용 여부" name="USE_YN">
											<option value="Y">예</option>
											<option value="N">아니오</option>
										</select>
									</dd>
								</dl>
							</div>
						</div>
					</form:form>
				</div>
				<!-- 
				<div class="com-btn-group user-save">
					<button class="btn red write" type="button" onclick="fn_save();">저장</button>
				</div>
				 -->
			</li>
		</ul>
		<!-- //탭 컨텐츠 -->
	</div>
</div>