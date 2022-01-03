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
		
		$('#datepicker1').datepicker('setDate', 'today');
	    $('#datepicker2').datepicker('setDate', 'today');
	    $('#datepicker3').datepicker('setDate', 'today');
	    
	});
	
	//검색
	function fn_search(){
		if(fn_searchValid()){
			fnPageLoad("/account/AccHistorySelect.kspo",$("#searchFrm").serialize());
		}		
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/account/AccHistoryDownload.kspo");
		$("#searchFrm").submit();
	}
	
	//삭제기록 검색
	function fn_delSearch(){
		fnPageLoad("/account/AccHistoryDelSelect.kspo",$("#searchFrm").serialize());
	}
	
	function fn_searchValid(){
		//시작일
		if($("#searchFrm input[name=stdYmd]").val() == "" || $("#searchFrm input[name=stdYmd]").val() == null){
			fnAlert("접속일자 시작일을 입력하시기 바랍니다.");
			$('#datepicker1').datepicker('setDate', 'today');
			$("#searchFrm input[name=stdYmd]").focus();
			return false;
		}
		//종료일
		if($("#searchFrm input[name=endYmd]").val() == "" || $("#searchFrm input[name=endYmd]").val() == null){
			fnAlert("접속일자 종료일을 입력하시기 바랍니다.");
			$('#datepicker2').datepicker('setDate', 'today');
			$("#searchFrm input[name=endYmd]").focus();
			return false;
		}
		
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("접속일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		
		return true;
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>사용자 접속이력</h2>
		</div>
		<!-- //타이틀 -->		
		
		<!-- 검색영역 -->
		<form method="post" id="searchFrm" name="searchFrm" action="${pageContext.request.contextPath}/account/AccHistorySelect.kspo">
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
			                <td class="t-title">접속일자</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li>
			                            <input id="datepicker1" name="stdYmd" type="text" class="datepick smal" autocomplete="off" value="${param.stdYmd}"> ~ 
			                            <input id="datepicker2" name="endYmd" type="text" class="datepick smal" autocomplete="off" value="${param.endYmd}">
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
											<option value="USER_ID" <c:if test="${param.keykind eq 'USER_ID'}">selected="selected"</c:if>>아이디</option>
			                            </select>
			                            <input type="text" class="smal" placeholder="" name="keyword" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
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
				    <table class="table-grid">
				        <caption></caption>
				        <colgroup>
				            <col style="width:5%">
				            <col style="width:auto">
				            <col style="width:14%">
				            <col style="width:12%">
				            <col style="width:14%">
				            <col style="width:14%">
				            <col style="width:12%">
				            <col style="width:14%">
				        </colgroup>
				        <thead>
				            <tr>
				                <th>번호</th>
				                <th>접속일자</th>
				                <th>메뉴명</th>
				                <th>아이디</th>
				                <th>이름</th>
				                <th>사용자그룹</th>
				                <th>소속</th>
				                <th>접속IP</th>
				            </tr>
				        </thead>
				        <tbody>
				            <c:choose>
								<c:when test="${not empty accHsList}">
									<c:forEach items="${accHsList}" var="list" varStatus="state">
							            <tr>
							                <td>${list.RNUM}</td>
							                <td>${list.REG_DTM}</td>
							                <td>${list.MENU_NM}</td>
							                <td>${list.ACC_ID}</td>
							                <td>${list.ACC_NM}</td>
							                <td>${list.GRP_NM}</td>
							                <td>${list.LOC_NM}</td>
							                <td>${list.ACC_IP}</td>
							            </tr>
				            		</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td colspan="7" class="blank">검색결과가 존재하지 않습니다.</td></tr>
								</c:otherwise>
							</c:choose>
				        </tbody>
				    </table>
				</div>
		
			<div class="com-paging">
				<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:searchFrm" />
			</div>
			
			<!-- 
			<div class="com-h3 add">접속기록 삭제</div>
			<div class="com-table">
			    <table class="table-board">
			        <caption></caption>
			        <colgroup>
			            <col width="200px">
			            <col width="">
			        </colgroup>
			        <tbody>
			            <tr>
			                <td class="t-title">삭제기록 조회</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li style="width:405px;">
			                            접속일자 <input id="datepicker" type="text" class="datepick hasDatepicker" style="margin-left:10px;"> 일 이전 기록
			                        </li>
			                        <li><button class="btn navy post">조회</button></li>
			                    </ul>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">접속기록 삭제처리</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li style="width:405px;">
			                            조회결과 <b class="t-blue">0000건</b>
			                        </li>
			                        <li><button class="btn navy post">기록삭제</button></li>
			                    </ul>
			                </td>
			            </tr>
			        </tbody>
			    </table>
			</div>
			 -->
	</div>
</div>