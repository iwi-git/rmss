<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

//검색
function fn_search(){
	fnPageLoad("/stats/RecordAllSelect.kspo",$("#frm").serialize());
}

//엑셀다운로드
function excel_download(){
	if(doubleSubmitCheck()) return;
	$("#frm").attr("action","/stats/RecordAllDownload.kspo");
	$("#frm").submit();
}

</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무실적 - 총괄</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/stats/RecordAllSelect.kspo">
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
							<td class="t-title">연도구분</td>
							<td>
								<select name="srchYear" class="smal">
									<c:forEach var="yearLi" items="${srchYearList}">
										<option value="${yearLi.YEAR}" <c:if test="${param.srchYear eq yearLi.YEAR}">selected="selected"</c:if>>${yearLi.YEAR}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">체육단체</td>
							<td>
								<select id="srchMemorgSn" name="srchMemorgSn" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
										<option value="" <c:if test="${param.srchMemorgSn eq '' or param.srchMemorgSn eq null}">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach items="${memOrgSelect}" var="moLi">
										<option value="${moLi.MEMORG_SN}" <c:if test="${param.srchMemorgSn eq moLi.MEMORG_SN}">selected="selected"</c:if>>${moLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
									<c:forEach items="${gameNmList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title"></td>
							<td></td>
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
					<span class="total-num">조회결과 <b>${pageInfo.totalRecordCount}</b>건</span>
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
		
		<div class="com-grid" style="overflow-x: auto;">
			<table class="table-grid" style="width:calc(100% - 1px);"> <!-- 사이즈 조절가능-->
				<caption></caption>
				<colgroup>
					<col style="width:50px">
					<col style="width:13%">
					<col style="width:7%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:9%">
					<col style="width:7%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:auto">
				</colgroup>
				<thead>
					<tr>
						<th rowspan="2">연번</th>
						<th rowspan="2">종목</th>
						<th rowspan="2">이름</th>
						<th rowspan="2">생년월일</th>
						<th rowspan="2">편입일자</th>
						<th rowspan="2">만료일자</th>
						<th rowspan="2">연장만료일자</th>
						<th rowspan="2">의무시간</th>
						<th colspan="2">인정시간(B)</th>
						<th colspan="2">잔여시간(C=A-B)</th>
						<th rowspan="2" class="bdl">비고</th>
					</tr>
					<tr>
						<th class="bdt">시간</th>
						<th class="bdt">분</th>
						<th class="bdt">시간</th>
						<th class="bdt">분</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty recordAllList}">
							<c:forEach items="${recordAllList}" var="list" varStatus="state">
								<tr>
									<td>${list.RNUM}</td>
									<td>${list.GAME_NM}</td>
									<td>${list.APPL_NM}</td>
									<td>${list.BRTH_DT}</td>
									<td>${list.ADDM_DT}</td>
									<td>${list.RSVT_DT}</td>
									<td>${list.EXPR_DT}</td>
									<td>${list.VLUN_DUTY_HR}</td>
									<td>${list.TOT_FINAL_TIME_HR}</td>
									<td>${list.TOT_FINAL_TIME_MN}</td>
									<td>${list.FINAL_REMAIN_TIME_HR}</td>
									<td>${list.FINAL_REMAIN_TIME_MN}</td>
									<td></td>
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
			<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:frm" />
		</div>
	</div>
</div>