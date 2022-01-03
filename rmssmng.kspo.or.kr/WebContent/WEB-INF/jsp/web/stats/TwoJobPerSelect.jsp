<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	//datepicker start
	$("#datepicker1").datepicker({
		showOtherMonths: true,
		selectOhterMonth: true,
	});
	
	$("#datepicker2").datepicker({
		showOtherMonths: true,
		selectOhterMonth: true
	});
	
	if($("#searchFrm input[name=stdYmd]").val()!= "" && $("#searchFrm input[name=endYmd]").val() != ""){
		$("#datepicker1").datepicker('option','maxDate',$("#searchFrm input[name=endYmd]").val());
		$("#datepicker2").datepicker('option','minDate',$("#searchFrm input[name=stdYmd]").val());
	}
	
});

//검색
function fn_search(){
	//조회가능기간은 최대 1년까지만
	if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
		fnAlert("신청일 조회기간은 최대 1년까지만 설정 가능합니다.");
		return;
	}
	fnPageLoad("/stats/TwoJobPerSelect.kspo",$("#searchFrm").serialize());
}

//엑셀다운로드
function excel_download(){
	if(doubleSubmitCheck()) return;
	$("#searchFrm").attr("action","/stats/TwoJobPerDownload.kspo");
	$("#searchFrm").submit();
}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>겸직허가 신청현황</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="searchFrm" name="searchFrm" action="${pageContext.request.contextPath}/stats/TwoJobPerSelect.kspo">
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
							<td class="t-title">신청일자</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker1" name="STD_YMD" type="text" class="datepick smal" autocomplete="off"  value="${STD_YMD}"> ~ 
										<input id="datepicker2" name="END_YMD" type="text" class="datepick smal" autocomplete="off"  value="${END_YMD}">
									</li>
								</ul>
							</td>
							<td class="t-title">키워드</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<select id="keykind" name="keykind" class="smal">
												<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
												<option value="USER_NM" <c:if test="${param.keykind eq 'USER_NM'}">selected="selected"</c:if>>이름</option>
										</select>
										<input type="text" class="smal" placeholder="" name="keyword" value="${param.keyword}"  onkeydown="if(event.keyCode == 13){fn_search();return false;}">
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
				<button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid" > <!-- 사이즈 조절가능-->
				<caption></caption>
				<colgroup>
					<col style="width:50px">
					<col style="width:8%">
					<col style="width:5%">
					<col style="width:100px;">
					<col style="width:5%">
					<col style="width:auto%">
					<col style="width:auto">
					<col style="width:13%">
					<col style="width:auto">
					<col style="width:4%">
					<col style="width:20%">
					<col style="width:5%">
					<col style="width:5%">
				</colgroup>
				<thead>
					<tr>
						<th rowspan="2">연번</th>
						<th colspan="5">신청인</th>
						<th colspan="6">겸직 내용</th>
						<th rowspan="2" class="bdl">승인여부</th>
					</tr>
					<tr>		
						<th class="bdt">종목명</th>
						<th class="bdt">성명</th>
						<th class="bdt">생년월일</th>
						<th class="bdt">소속</th>
						<th class="bdt">관할병무청</th>
		
						<th class="bdt">겸직근무처(기관)</th>
						<th class="bdt">겸직기간</th>
						<th class="bdt">겸직사유</th>
						<th class="bdt">수입발생</th>
						<th class="bdt">겸직내용</th>
						<th class="bdt">담당자<br/>(담당자)</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty towJobPerList}">
							<c:forEach items="${towJobPerList}" var="list" varStatus="state">
								<tr>
									<td>${list.RNUM}</td>
									<td>${list.GAME_NM}</td>
									<td>${list.APPL_NM}</td>
									<td>
										<fmt:parseDate var="BRTH_DT" value="${list.BRTH_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${BRTH_DT}" pattern="yyyy-MM-dd"/>
									</td>
									<td>${list.MEMORG_NM}</td>
									<td>${list.TEAM_NM}</td>
									<td style="text-align:left;">${list.CONC_OFC}</td>
									<td>${list.CONC_DT}</td>
									<td>${list.CONC_PRVONSH_NM}</td>
									<td>${list.INCM_YN}</td>
									<td style="text-align:left;">${list.CONC_REASON}</td>
									<td>${list.REGR_NM}</td>
									<td>${list.DSPTH_REASON}</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="13" class="blank">검색결과가 존재하지 않습니다.</td></tr>
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