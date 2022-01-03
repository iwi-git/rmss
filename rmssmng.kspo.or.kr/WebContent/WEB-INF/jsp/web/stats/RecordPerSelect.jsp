<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

	function fn_searchPersonPopupOpen(){
		$('#searchPersonPopDiv').addClass('active');
	}
	
	//체육요원 리스트 검색
	function fn_popPersonSearch(pageNo){

		var pSrchGameCd = $('#searchPersonFrm select[name=pSrchGameCd]').val();
		var pSrchKeyKind = $('#searchPersonFrm select[name=pSrchKeyKind]').val();
		var pSrchKeyword = $('#searchPersonFrm input[name=pSrchKeyword]').val();
		
		var param = "pSrchGameCd=" + pSrchGameCd;
			param += "&pSrchKeyKind=" + pSrchKeyKind;
			param += "&pSrchKeyword=" + pSrchKeyword;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		if(typeof(pageNo) != "undefined"){
			param+= "&pageNo=" + pageNo;	
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonListJs.kspo", param);
		
		if($json.statusText != "OK"){
			fnAlert("오류가 발생하였습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var personList = $json.responseJSON.personList;
		
		var htmlStr = "";
		
		if(personList.length < 1){
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"5\" class=\"center\">일치하는 체육요원이 없습니다.</td>";
			htmlStr += "<tr>";
		}
		
		for(var i = 0; i < personList.length; i++){
			var MLTR_ID = personList[i].MLTR_ID;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"MLTR_ID_GRP\" id=\"MLTR_ID" + i + "\" value=\"" + MLTR_ID + "\">";
			htmlStr += "<label for=\"MLTR_ID" + i + "\" class=\"chk-only\">선택</label>";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td>" + MLTR_ID + "</td>";
			htmlStr += "<td>" + personList[i].APPL_NM + "</td>";
			htmlStr += "<td>" + personList[i].BRTH_DT + "</td>";
			htmlStr += "<td>" + personList[i].GAME_CD_NM + "</td>";
			htmlStr += "</tr>";
		}
		
		$('#personTbody').empty().append(htmlStr);
		
		var pageInfo = $json.responseJSON.pageInfo;
		
		if(personList.length > 0){
			$('#searchPersonCnt').html(personList[0].TOTAL_RECORD_COUNT);
		}
		
		$('#personPagingDiv').empty().append(pageInfo);
		
	}
	
	//체육요원 검색 팝업 비활성
	function fn_searchPersonPopupClose(){
		
		$('#searchPersonFrm select[name=pSrchKeyKind]').val('');//키워드 종류 초기화
		$('#searchPersonFrm input[name=pSrchKeyword]').val('');//키워드 입력란 초기화
		$('#searchPersonFrm tbody[id=personTbody]').empty();//검색결과 초기화
		$('#searchPersonCnt').html('0');//조회결과 카운트 초기화
		$('#personPagingDiv').empty();//페이징 초기화
		$('#searchPersonPopDiv').removeClass('active');
	}
	
	function fn_confirmPerson(){
		
		var checkedCnt = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').length;

		if(checkedCnt < 1){
			fnAlert("체육요원을 선택해주세요.");
			return false;
		}
		
		if(checkedCnt > 1){
			fnAlert("한명의 체육요원을 선택해주세요.");
			return false;
		}
		
		var MLTR_ID = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').val();
		
		if(MLTR_ID == ''){
			fnAlert("선택된 체육요원의 정보가 올바르지 않습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var param = "MLTR_ID=" + MLTR_ID;
		param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();	
	
	var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectPersonJs.kspo", param);
	
		if($json.statusText == "OK"){
			
			var personInfo = $json.responseJSON.personInfo;
			var htmlStr = "";
			
			if(personInfo == null){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			$('#searchFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
			$('#searchFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
			
			fn_searchPersonPopupClose();
		
		}
		
	}
	
	function fn_search(){
		if(!fn_validate()){
			return false;
		}
		
		fnPageLoad("/stats/RecordPerSelect.kspo",$("#searchFrm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		
		if(!fn_validate()){
			return false;
		}
		
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/stats/RecordPerDownload.kspo");
		$("#searchFrm").submit();
	}
	
	function fn_validate(){
		if($('#searchFrm input[name=MLTR_ID]').val().length < 1){
			fnAlert("체육요원을 선택해주세요.");
			return false;
		}
		
		return true;
	}
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무실적 - 개인</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="searchFrm" name="searchFrm" action="${pageContext.request.contextPath}/stats/RecordPerSelect.kspo">
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
								<td class="t-title">이름</td>
								<td class="input-td" colspan="3">
									<div class="search-box">
										<input type="text" class="smal" name="APPL_NM" placeholder="" readonly="readonly" value="${param.APPL_NM}">
										<input type="hidden" name="MLTR_ID" value="${param.MLTR_ID}">
										<button type="button" onclick="fn_searchPersonPopupOpen();">찾기</button>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
		</form>
		
		<div class="com-btn-group center">
			<button class="btn red write" type="button" onclick="fn_search();">검색</button>
		</div>
		<!-- //검색영역 -->
		
		<div class="com-result">
			<div class="float-r">
				<button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
			</div>
		</div>
		
		<div class="com-table">
			<table class="table-board">
				<caption></caption>
				<colgroup>
					<col style="width:130px;">
					<col style="width:auto;">
					<col style="width:130px;">
					<col style="width:auto;">
				</colgroup>
				<tbody>
					<tr>
						<td class="t-title">이름</td>
						<td>${recordPer.APPL_NM}</td>
						<td class="t-title">종목명</td>
						<td>${recordPer.GAME_NM}</td>
					</tr>
					<tr>
						<td class="t-title">인정시간 합계</td>
						<td>${recordPer.TOT_FINAL_TIME_HR}시간 ${recordPer.TOT_FINAL_TIME_MN}분</td>
						<td class="t-title">잔여시간 합계</td>
						<td>${recordPer.FINAL_REMAIN_TIME_HR}시간 ${recordPer.FINAL_REMAIN_TIME_MN}분</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="com-grid" style="overflow-x: auto;">
			<table class="table-grid" style="width:calc(100% - 1px);"> <!-- 사이즈 조절가능-->
				<caption></caption>
				<colgroup>
					<col style="width:9%">
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:7%">
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:10%">
					<col style="width:auto">
					<col style="width:auto">
					<col style="width:10%">
					<col style="width:9%">
				</colgroup>
				<thead>
					<tr>
						<th rowspan="3">활동기간</th>
						<th colspan="5">인정시간</th>
						<th rowspan="3" class="bdl">활동분야</th>
						<th rowspan="3">봉사내용</th>
						<th rowspan="3">대상기관(봉사장소)</th>
						<th rowspan="3">확인자</th>
						<th rowspan="3">보고일자</th>
					</tr>
					<tr>
						<th colspan="2" class="bdt">활동시간</th>
						<th class="bdt">이동시간</th>
						<th colspan="2" class="bdt">합계</th>
					</tr>
					<tr>
						<th class="bdt">시간</th>
						<th class="bdt">분</th>
						<th class="bdt">시간</th>
						<th class="bdt">시간</th>
						<th class="bdt">분</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty recordPerList}">
							<c:forEach items="${recordPerList}" var="list" varStatus="state">
								<tr>
									<td>${list.ACT_DT}</td>
									<td>${list.ACT_TIME_HR}</td>
									<td>${list.ACT_TIME_MN}</td>
									<td>${list.WP_MV_TIME}</td>
									<td>${list.TOT_ACCEPT_TIME_HR}</td>
									<td>${list.TOT_ACCEPT_TIME_MN}</td>
									<td>${list.ACT_FIELD}</td>
									<td>${list.SRVC_CONTENTS}</td>
									<td>${list.VLUN_PLC_NM}</td>
									<td>${list.PLC_MNGR_NM}</td>
									<td>${list.REG_DTM}</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="11" class="blank">검색결과가 존재하지 않습니다.</td></tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>
</div>

<!-- 팝업영역 --><!-- 체육요원 검색 -->
<div class="cpt-popup" id="searchPersonPopDiv"><!-- class:active 팝업 on/off -->
	<form id="searchPersonFrm" onsubmit="return false;">
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
		<div class="dim"></div>
		<div class="popup" style="width: 650px;">
			<div class="pop-head">
				체육요원 검색
				<button class="pop-close" onclick="fn_searchPersonPopupClose();">
					<img src="${pageContext.request.contextPath}/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
				</button>
			</div>
			<div class="pop-body" style="padding: 45px;">
				<!-- 검색영역 -->
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:150px;">
							<col style="width:auto;">
						</colgroup>
						<tbody>
							<tr>
								<td class="t-title">종목</td>
								<td>
									<select name="pSrchGameCd" class="tab-sel">
										<c:forEach var="subLi" items="${gameNmList}">
										<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="t-title">키워드</td>
								<td>
									<ul class="com-radio-list">
										<li>
											<select name="pSrchKeyKind" class="smal">
												<option value="">전체</option>
											</select>
											<input type="text" name="pSrchKeyword" class="smal" placeholder="" onkeydown="if(event.keyCode == 13){fn_popPersonSearch();return false;}">
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
	
				<div class="com-btn-group center">
					<button class="btn red write" type="button" onclick="fn_popPersonSearch();return false;">검색</button>
				</div>
				<!-- //검색영역 -->
	
				<div class="com-result">
					<div class="float-l">
						<span class="total-num">조회결과 <b id="searchPersonCnt">0</b>건</span>
					</div>
				</div>
	
				<div class="com-grid type02" style="max-height:271px; overflow-x:hidden; overflow-y: auto;">
					<table class="table-grid">
						<caption></caption>
						<colgroup>
							<col width="50px">
							<col width="25%">
							<col width="30%">
							<col width="20%">
							<col width="auto">
						</colgroup>
						<thead>
							<tr>
								<th>선택</th>
								<th>관리번호</th>
								<th>이름</th>
								<th>생년월일</th>
								<th>종목</th>
							</tr>
						</thead>
						<tbody id="personTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-paging" id="personPagingDiv"></div>
	
				<div class="com-btn-group center">
					<button class="btn grey write" type="button" onclick="fn_searchPersonPopupClose();return false;">취소</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPerson();return false;">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->