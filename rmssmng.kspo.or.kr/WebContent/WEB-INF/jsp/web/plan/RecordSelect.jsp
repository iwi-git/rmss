<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#datepicker1, #datepicker2, #datepicker3, #datepicker4").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
	});
	
	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("편입일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/plan/RecordSelect.kspo",$("#searchFrm").serialize());
	}
	
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/plan/recordPerDownload.kspo");
		$("#searchFrm").submit();	
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무 실적조회</h2>
		</div>
		<!-- //타이틀 -->

		<!-- 검색영역 -->
		<form id="searchFrm" method="post" action="${pageContext.request.contextPath}/plan/RecordSelect.kspo">
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
							<td class="t-title">편입일자</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker1" type="text" name="srchAddmDtStart" value="${srchAddmDtStart}" maxlength="8" autocomplete="off" class="datepick smal"> ~ <input id="datepicker2" type="text" name="srchAddmDtEnd" value="${srchAddmDtEnd}" maxlength="8" autocomplete="off" class="datepick smal">
									</li>
								</ul>
							</td>
							<td class="t-title">체육단체</td>
							<td>
								<select name="srchMemorgCd" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne 2}">
									<option value="" <c:if test="${param.srchMemorgCd eq '' or param.srchMemorgCd eq null }">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach var="subLi" items="${memorgCdList}">
									<option value="${subLi.MEMORG_SN}" <c:if test="${param.srchMemorgCd eq subLi.MEMORG_SN}">selected="selected"</c:if>>${subLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">복무만료일</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="datepicker3" name="srchExprDtStart" value="${param.srchExprDtStart}" maxlength="8" type="text" autocomplete="off" class="datepick smal"> ~ <input id="datepicker4" type="text" name="srchExprDtEnd" value="${param.srchExprDtEnd}" maxlength="8" autocomplete="off" class="datepick smal">
									</li>
								</ul>
							</td>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">키워드</td>
							<td colspan="3">
								<ul class="com-radio-list">
									<li>
										<select name="keyKind" class="smal">
											<option value="" <c:if test="${param.keyKind eq '' or param.keyKind eq null}">selected="selected"</c:if>>전체</option>
											<option value="USER_NAME" <c:if test="${param.keyKind eq 'USER_NAME'}">selected="selected"</c:if>>이름</option>
											<option value="GAME_NAME" <c:if test="${param.keyKind eq 'GAME_NAME'}">selected="selected"</c:if>>종목</option>
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
				<button class="btn red type01" type="button" onclick="excel_download();">엑셀데이터 저장하기</button> <!-- 20211109 수정 -->
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col style="width:50px">
					<col style="width:115px;">
					<col style="width:115px;">
					<col style="width:7%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:8%">
					<col style="width:8%">
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:120px;">
					<col style="width:5%">
					<col style="width:120px;">
					<col style="width:120px;">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>관리번호</th>
						<th>이름</th>
						<th>생년월일</th>
						<th>체육단체</th>
						<th>종목</th>
						<th>편입일자</th>
						<th>복무만료일</th>
						<th>실적건수</th>
						<th>봉사건수</th>
						<th>활동시간</th>
						<th>이동시간</th>
						<th>합계</th>
						<th>잔여시간</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty recordList}">
							<c:forEach var="record" items="${recordList}">
							<tr>
								<td>${record.RNUM}</td>
								<td>${record.MLTR_ID}</td>
								<td>${record.APPL_NM}</td>
								<td>${record.BRTH_DT}</td>
								<td>${record.MEMORG_NM}</td>
								<td>${record.GAME_NM}</td>
								<td>
									<fmt:parseDate var="ADDM_DT" value="${record.ADDM_DT}" pattern="yyyyMMdd"/>
									<fmt:formatDate value="${ADDM_DT}" pattern="yyyy-MM-dd"/>
								</td>
								<td>${record.EXPR_DT}</td>
								<td>${record.RECD_M_CNT}</td>
								<td>${record.RECD_D_CNT}</td>
								<td>${record.TOT_FINAL_ACT_TIME_HR}시간 ${record.TOT_FINAL_ACT_TIME_MN}분</td>
								<td>${record.TOT_FINAL_WP_MV_TIME}</td>
								<td>${record.TOT_FINAL_TIME_HR} 시간 ${record.TOT_FINAL_TIME_MN}분</td>
								<td>${record.FINAL_REMAIN_TIME_HR}시간 ${record.FINAL_REMAIN_TIME_MN}분</td>
							</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="14" class="center">일치하는 게시물이 없습니다.</td>
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
	