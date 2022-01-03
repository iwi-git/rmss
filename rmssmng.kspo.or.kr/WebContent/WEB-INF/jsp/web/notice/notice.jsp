<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	
	
	//게시판 글쓰기 페이지 이동
	function fn_add(){
		fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeAdd.kspo",$("#sFrm").serialize());
	}
	
	//검색
	function fn_search(){
		fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeList.kspo",$("#sFrm").serialize());
	}
	
	//검색 초기화
	function fn_reset(){
		$("#sFrm").find("input, select").each(function(){
			$(this).val("");
			$("#sFrm select[name=keyKind]").val("ALL");
		});
	}
	
	//게시판 상세 페이지 이동
	function fn_Detail(BRD_DTL_SN){
		var param = "BRD_DTL_SN=" + BRD_DTL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeDetail.kspo",param)
	}
	
    function fn_egov_link_page(pageNo){
    	fnGoPage(pageNo,"sFrm");
    }	
	
</script>
<div class="body-cont">
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>공지사항</h2>
	</div>
	<!-- //타이틀 -->

	<!-- 검색/조회 영역 -->
<!-- 	<div class="cpt-search board"> -->
<%-- 		<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/notice/selectNoticeList.kspo"> --%>
<%-- 			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}"> --%>
<%-- 			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}"> --%>
<!-- 			<ul class="search-list"> -->
<!-- 				<li class="search-item"> -->
<!-- 					<select name="keykind"> -->
<%-- 					    <option value="ALL" <c:if test="${param.keykind eq 'ALL'}">selected="selected"</c:if>>전체</option> --%>
<%-- 						<option value="TITLE" <c:if test="${param.keykind eq 'SUBJECT'}">selected="selected"</c:if>>제목</option> --%>
<%-- 						<option value="CONTENTS" <c:if test="${param.keykind eq 'CONTENTS'}">selected="selected"</c:if>>내용</option> --%>
<%-- 						<option value="REGR_NM" <c:if test="${param.keykind eq 'REGR_NM'}">selected="selected"</c:if>>작성자</option> --%>
<!-- 					</select> -->
<!-- 				</li> -->
<!-- 				<li class="search-item"> -->
<%--                     <input type="text" title="키워드 입력" name="keyword" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}"> --%>
<!--                 </li> -->
<!--                 <li class="search-item"> -->
<!--                     <div class="com-btn-group"> -->
<!--                         <button class="btn grey put-search02" type="button" onclick="fn_reset();">초기화</button> -->
<!--                         <button class="btn navy put-search02" type="button" onclick="fn_search();">검색</button> -->
<!--                     </div> -->
<!--                 </li> -->
<!-- 			</ul> -->
<!-- 		</form> -->
<!-- 	</div> -->
	<!-- //검색/조회 영역 -->
	
	<!-- 검색영역 -->
	<div class="com-table">
		<form method="post" id="sFrm" name="sFrm" action="${pageContext.request.contextPath}/notice/selectNoticeList.kspo">
			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
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
			                <td class="t-title">키워드</td>
			                <td colspan="3">
			                    <ul class="com-radio-list">
			                        <li>
			                            <select name="keyKind" class="smal">
			                                <option value="ALL" <c:if test="${param.keyKind eq 'ALL'}">selected="selected"</c:if>>전체</option>
											<option value="SUBJECT" <c:if test="${param.keyKind eq 'SUBJECT'}">selected="selected"</c:if>>제목</option>
											<option value="CONTENTS" <c:if test="${param.keyKind eq 'CONTENTS'}">selected="selected"</c:if>>내용</option>
											<option value="REGR_NM" <c:if test="${param.keyKind eq 'REGR_NM'}">selected="selected"</c:if>>작성자</option>
			                            </select>
			                            <input type="text" class="smal" title="키워드 입력" name="keyword" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
			                        </li>
			                        <li>
			                        </li>
			                    </ul>
			                </td>
			            </tr>
			        </tbody>
			    </table>
		</form>
	</div>
	
	<div class="com-btn-group center">
	    <button class="btn red write" type="button" onclick="fn_search();">검색</button>
	</div>
	<!-- //검색영역 -->

	<!-- 조건/버튼 영역 -->
	<div class="com-result">
		<div class="float-l">
			<span class="total-num">전체<b>${pageInfo.totalRecordCount}</b>개</span><span class="now-page bar-front">현재페이지 ${pageInfo.currentPageNo}/${pageInfo.totalPageCount}</span>
		</div>
	</div>
	<!-- //조건/버튼 영역 -->
	
	<!-- 테이블 영역 -->
	<form method="post" id="frm" name="frm">
		<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
		<div class="com-table">
			<table class="table-list">
				<caption></caption>
				<colgroup>
					<col width="100px">
					<col width="">
					<col width="150px">
					<col width="140px">
					<col width="160px">
				</colgroup>
				<thead>
					<tr>
						<th>
							<div class="th-bdr">번호</div>
						</th>
						<th>
							<div class="th-bdr">제목</div>
						</th>
						<th>
							<div class="th-bdr">작성자</div>
						</th>
						<th>
							<div class="th-bdr">작성일</div>
						</th>
						<th>
							<div class="th-bdr">조회</div>
						</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty noticeList}">
							<c:forEach items="${noticeList}" var="list" varStatus="state">
								<tr>
									<td>
										<c:choose>
											<c:when test='${list.NTCE_SETUP_YN eq "Y"}'>
												<div class="mark navy notice">공지</div>
											</c:when>
											<c:when test='${list.MAIN_EXPSR_YN eq "Y"}'>
												<div class="mark border-r emergen">긴급</div>
											</c:when>
											<c:otherwise>
												${list.RNUM}
											</c:otherwise>
										</c:choose>
									</td>
									<td class="left">
										<a href="javascript:fn_Detail('${list.BRD_DTL_SN}')">${list.SUBJECT}</a>
									</td>
									<td>${list.REGR_NM}</td>
									<td>${list.REGR_DT}</td>
									<td>${list.READ_NUM}</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="5" class="blank">검색결과가 존재하지 않습니다.</td></tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</form>
	<!-- 버튼 영역 -->
	<c:if test="${sessionScope.userMap.GRP_SN eq '1' or sessionScope.userMap.GRP_SN eq '4'}">
		<div class="com-btn-group put right">
			<button class="btn navy rmvcrr" type="button" onclick="javascript:fn_add();">글쓰기</button>
		</div>
	</c:if>
	<!-- //버튼 영역 -->

	<!-- 페이징 영역 -->
	<div class="com-paging">
		<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:sFrm" />
	</div>
	<!-- //페이징 영역 -->
</div>
</div>