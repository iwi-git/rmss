<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	
	//게시판 목록 이동
	function fn_list(){
		fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeList.kspo",$("#frm").serialize());
	}
	
	//게시판 삭제
	function fn_del(){
		if(confirm("정말 삭제 하시겠습니까?")) {
			var $json = getJsonData("post", "${pageContext.request.contextPath}/notice/deleteNoticeJs.kspo", $("#frm").serialize());
			if($json.statusText == "OK"){
				fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeList.kspo",$("#frm").serialize());
			}
		}
	}
	
	//게시판 수정 페이지 이동
	function fn_edit(BRD_DTL_SN){
		if(confirm("수정 하시겠습니까?")) {
			var param = "BRD_DTL_SN=" + BRD_DTL_SN;
			param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
			fnPageLoad("/notice/selectNoticeAdd.kspo",param);
		}
	}
	
	//파일 다운로드
  	function fnDownloadFile(BRD_DTL_SN, BRD_ATCH_FILE_SN){
  		window.location = "/file/downloadFile.kspo?BRD_DTL_SN=" + BRD_DTL_SN + "&BRD_ATCH_FILE_SN="+BRD_ATCH_FILE_SN+"&gMenuSn="+$("#frm input[name=gMenuSn]").val()+"&file="+"noticeFile";
  	}
	
</script>
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>게시판</h2>
	</div>
	<!-- //타이틀 -->
	<form id="frm" name="frm" method="post" action="">
		<input type="hidden" name="BRD_SN" id="BRD_SN" value="${detail.BRD_SN}">
		<input type="hidden" name="BRD_DTL_SN" id="BRD_DTL_SN" value="${detail.BRD_DTL_SN}">
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
		<!-- 테이블 영역 -->
		<div class="com-table">
			<table class="table-board">
				<caption></caption>
					<colgroup>
						<col width="140px">
						<col width="auto">
						<col width="140px">
		                <col width="280px">
		                <col width="140px">
		                <col width="280px">
					</colgroup>
				<tbody>
						<tr>
							<td colspan="6" class="board-tit" style="border-left: 0;">
								<c:if test='${detail.NTCE_SETUP_YN eq "Y"}'>
									<span class="notice">공지</span> <!--  공지가 아닐때는 제거 -->
								</c:if>
								${detail.SUBJECT}
							</td>
						</tr>
						<tr>
							<td class="t-title">작성자</td>
							<td>${detail.REGR_NM}</td>
							<td class="t-title">작성일</td>
							<td>${detail.REGR_DT}</td>
							<td class="t-title">조회수</td>
							<td>${detail.READ_NUM}</td>
						</tr>
						<tr>
	                    	<td class="t-title">첨부파일</td>
	                        <td colspan="5">
	                        	<ul class="added-file">
	                        		<c:if test="${not empty file}">
	                        			<c:forEach items="${file}" var="li">
	                        				<li><a href="javascript:fnDownloadFile('${li.BRD_DTL_SN}','${li.BRD_ATCH_FILE_SN}')">${li.ATCH_FILE_ORG_NM}</a></li>
	                        			</c:forEach>
	                        		</c:if>
	                            </ul>
							</td>
						</tr>
	                    <tr>
	                    	<td colspan="6">
	                        	<div class="contents-ntc-view">
	                            	<pre style="white-space:pre-wrap">${detail.CONTENTS}</pre>
								</div>
	                        </td>
						</tr>
				</tbody>
			</table>
		</div>
		<!-- //테이블 영역 -->
	</form>

	<!-- 버튼 영역 -->
	<div class="com-btn-group right put">
		<c:if test="${sessionScope.userMap.GRP_SN eq '1' or sessionScope.userMap.GRP_SN eq '4'}">
			<button class="btn navy rmvcrr" type="button" onclick="javascript:fn_edit('${detail.BRD_DTL_SN}');">수정</button>
			<button class="btn red rmvcrr" type="button" onclick="javascript:fn_del();">삭제</button>
		</c:if>
	</div>
	<div class="com-btn-group center">
		<button class="btn navy write" type="button" onclick="javascript:fn_list();">목록</button>
	</div>
	<!-- //버튼 영역 -->
</div>