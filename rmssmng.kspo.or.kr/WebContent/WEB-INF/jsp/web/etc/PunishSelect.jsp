<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker, #datepicker1, #datepicker2").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true,
		});
		
		if($("#frm input[name=STD_YMD]").val()!= "" && $("#frm input[name=END_YMD]").val() != ""){
			$("#datepicker").datepicker('option','maxDate',$("#frm input[name=END_YMD]").val());
			$("#datepicker1").datepicker('option','minDate',$("#frm input[name=STD_YMD]").val());
		}
		
		$(document).on("change","#datepicker",function(){
			$("#datepicker1").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker").datepicker('option','maxDate',$(this).val());
		});
		//datepicker end
		
	});
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/etc/PunishSelectDownload.kspo");
		$("#frm").submit();
	}
	
	//검색
	function fn_punishSearch(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/etc/PunishSelect.kspo",$("#frm").serialize());
	}
	
	//체육요원 징계관리 팝업 열기
	function punishAddPopOpen(){
		
		$("#fnDelete").hide();
		$(".reg03.punish").addClass("active")
		$("body").css("overflow", "hidden")
	}
	
	//체육요원 징계관리 팝업 닫기
	function punishAddPopClose() {
		fn_punishSearch();
		$(".reg03.punish").removeClass("active")
		$("body").css("overflow","auto")
	}
	
	//체육요원 검색 팝업 활성
	function fn_searchPersonPopupOpen(){
		$('#searchPersonPopDiv').addClass('active');
	}
	
	//체육요원 검색 팝업 비활성
	function fn_searchPersonPopupClose(){
		
		$('#searchPersonFrm select[name=pSrchGameCd]').val('');//종목 초기화
		$('#searchPersonFrm select[name=pSrchKeyKind]').val('');//키워드 종류 초기화
		$('#searchPersonFrm input[name=pSrchKeyword]').val('');//키워드 입력란 초기화
		$('#searchPersonFrm tbody[id=personTbody]').empty();//검색결과 초기화
		$('#searchPersonCnt').html('0');//조회결과 카운트 초기화
		$('#personPagingDiv').empty();//페이징 초기화
		$('#searchPersonPopDiv').removeClass('active');
	}
	
	//체육요원 리스트 검색
	function fn_popPersonSearch(pageNo){

		var pSrchGameCd = $('#searchPersonFrm select[name=pSrchGameCd]').val();
		var pSrchKeyKind = $('#searchPersonFrm select[name=pSrchKeyKind]').val();
		var pSrchKeyword = $('#searchPersonFrm input[name=pSrchKeyword]').val();
		
		var param = "pSrchGameCd=" + pSrchGameCd;
			param += "&pSrchKeyKind=" + pSrchKeyKind;
			param += "&pSrchKeyword=" + pSrchKeyword;
			param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		if(typeof(pageNo) != "undefined"){
			param+= "&pageNo=" + pageNo;	
		}
		
		var $json = getJsonData("post", "/plan/selectPersonListJs.kspo", param);
		
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
	
	//체육요원 선택
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
			
			if(!personInfo){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			$('#mFrm input[name=APPL_SN]').val(personInfo.APPL_SN);
			$('#mFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
			$('#mFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
			$('#mFrm input[name=EXPR_DT]').val(personInfo.EXPR_DT);
			$('#mFrm td[id=MLTR_ID]').html(personInfo.MLTR_ID);
			$('#mFrm td[id=BRTH_DT]').html(personInfo.BRTH_DT);
			$('#mFrm td[id=ADDR]').html(personInfo.ADDR);
			$('#mFrm td[id=EMAIL]').html(personInfo.EMAIL);
			$('#mFrm td[id=CP_NO]').html(personInfo.CP_NO);
			$('#mFrm td[id=GAME_CD_NM]').html(personInfo.GAME_CD_NM);
			$('#mFrm td[id=MEM_ORG_NM]').html(personInfo.MEM_ORG_NM);
			$('#mFrm td[id=CTRL_MMA_CD]').html(personInfo.CTRL_MMA_CD);
			$('#mFrm td[id=PROC_STS_NM]').html(personInfo.PROC_STS_NM);
			$('#mFrm td[id=MEMORG_NM]').html(personInfo.MEMORG_NM);
			
			
			
			
			fn_searchPersonPopupClose();
		}
		
	}
	
	//첨부파일 추가
	function fn_addFile(obj){
		var fileCnt = $(".uploadBtn2").length;
		$("#fileTbody").after(fn_addFileObj(fileCnt));
	}

	//첨부파일 삭제
	function fn_removeFile(obj){
		$(obj).parents("tr").remove();
		if($(".uploadBtn2").length == 0){
			$("#fileTbody").after(fn_addFileObj("0"));
		}
	}
	
	//파일 생성 오브젝트
	function fn_addFileObj(fileCnt){
		var addFileObj = "";
		addFileObj += '<tr>';
		addFileObj += '<td colspan="3" class="adds bdr-0 input-td">';
		addFileObj += '<div class="fileBox">';
		addFileObj += '<input type="text" class="fileName2" readonly="readonly">';
		addFileObj += '<label for="uploadBtn'+fileCnt+'" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>';
		addFileObj += '<input type="file" name="file" id="uploadBtn'+fileCnt+'" class="uploadBtn2">';
		addFileObj += '</div>';
		addFileObj += '</td>';
		addFileObj += '<td class="bdl-0 pdr-0 ft-0">';
		addFileObj += '<button class="btn lightgrey removefile" type="button" onclick="fn_removeFile(this);return false;"></button>';
		addFileObj += '</td>';
		addFileObj += '</tr>';
		
		return addFileObj;
	}
	
	//저장
	function fn_save(DSPL_STS){
	
		if(fn_saveValid()){
		
			var saveUrl = "/etc/updatePunishJs.kspo";
			if($("#mFrm input[name=DSPL_SN]").val() == "" || $("#mFrm input[name=DSPL_SN]").val() == null){
				saveUrl = "/etc/insertPunishJs.kspo";
			}
		
			$("#mFrm input[name=DSPL_STS]").val(DSPL_STS);
		
			var $json = getJsonMultiData( saveUrl, "mFrm");	
			
			if($json.statusText == "OK"){
				
				fnAlert("저장되었습니다.");
				fn_punishSearch();	
					
			}
		}
	
	}
	
	//벨리데이션 체크
	function fn_saveValid(){
	
		if($("#mFrm input[name=APPL_NM]").val() == "" || $("#mFrm input[name=APPL_NM]").val() == null){
			fnAlert("체육요원을 검색해 주시기 바랍니다.");
			return ;
		}

		if($("#mFrm input[name=DSPL_DT]").val() == "" || $("#mFrm input[name=DSPL_DT]").val() == null){
			fnFocAlert("처분일자를 입력해 주시기 바랍니다.", $("#mFrm input[name=DSPL_DT]"));
			return ;
		}
		
		if(fnGetByte($("#mFrm input[name=DSPOVIOL]").val())>1000){
			var length = fnGetTxtLength(1000);
			fnFocAlert("위반사항 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#mFrm input[name=DSPOVIOL]"));
			return false;
		}

		if(fnGetByte($("#mFrm input[name=DSPO]").val())>30){
			var length = fnGetTxtLength(30);
			fnFocAlert("처분결과 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#mFrm input[name=DSPO]"));
			return false;
		}
		
		return true;
	}
	
	//상세조회
	function fn_Detail(DSPL_SN){
		var param = "DSPL_SN=" + DSPL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/selectPunishDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			var fileList = $json.responseJSON.fileList;
			
			punishAddPopOpen();
			
			$('#mFrm input[name=DSPOVIOL]').attr('readonly', false);
			$('#mFrm input[name=DSPO]').attr('readonly', false);
			$('#mFrm input[name=DSPS_REASON]').attr('readonly', false);
			$('#mFrm input[name=FLLWACT]').attr('readonly', false);
			$('#mFrm input[name=RMK]').attr('readonly', false);
			
			$("#mFrm input[name=DSPL_SN]").val(dtl.DSPL_SN);
			$("#mFrm input[name=DSPL_STS]").val(dtl.DSPL_STS);
			$("#mFrm input[name=MLTR_ID]").val(dtl.MLTR_ID);
			$('#mFrm input[name=APPL_NM]').val(dtl.APPL_NM);
			$('#mFrm input[name=ATCH_FILE_ID]').val(dtl.ATCH_FILE_ID);
			$('#mFrm td[id=MLTR_ID]').html(dtl.MLTR_ID);
			$('#mFrm td[id=BRTH_DT]').html(dtl.BRTH_DT);
			$('#mFrm td[id=ADDR]').html(dtl.ADDR);
			$('#mFrm td[id=EMAIL]').html(dtl.EMAIL);
			$('#mFrm td[id=CP_NO]').html(dtl.CP_NO);
			$('#mFrm td[id=GAME_CD_NM]').html(dtl.GAME_CD_NM);
			$('#mFrm td[id=MEM_ORG_NM]').html(dtl.MEM_ORG_NM);
			$('#mFrm td[id=CTRL_MMA_CD]').html(dtl.CTRL_MMA_CD);
			$('#mFrm td[id=PROC_STS_NM]').html(dtl.PROC_STS_NM);
			$('#mFrm td[id=MEMORG_NM]').html(dtl.MEMORG_NM);
			$("#mFrm .t-blue").text(dtl.DSPL_STS_NM);
			
			$('#mFrm input[name=DSPL_DT]').val(dtl.DSPL_DT);
			$('#mFrm input[name=DSPOVIOL]').val(dtl.DSPOVIOL);
			$('#mFrm input[name=DSPO]').val(dtl.DSPO);
			$('#mFrm input[name=DSPS_REASON]').val(dtl.DSPS_REASON);
			$('#mFrm input[name=FLLWACT]').val(dtl.FLLWACT);
			$('#mFrm input[name=RMK]').val(dtl.RMK);
			
			//첨부파일
			var fileObj = "";
			if(fileList.length > 0){
				for(var i=0;i<fileList.length;i++) {
					fileObj += '<tr>';
					fileObj += '	<td colspan="3" class="adds bdr-0 input-td">';
					fileObj += '		<a href="javascript:fnDownloadFile('+fileList[i].FILE_SN+')"><span class="file-name">'+ fileList[i].FILE_ORGIN_NM +'</span></a>';
					if(dtl.DSPL_STS != 'PC'){		
						fileObj += "		<button class='file-del' onclick='fn_fileDel(" + fileList[i].FILE_SN + ", this)'> 삭제</button>";
					}
					fileObj += '	</td>';
					fileObj += '	<td class="bdl-0 pdr-0 ft-0">';
					fileObj += '	</td>';
					fileObj += '</tr>';
				}
			
			}
			$("#fileTbody").before(fileObj);
			
			$("#personSearch").hide();
			$("#fnDelete").show();
			
			if(dtl.DSPL_STS == 'PC'){
				$(".pc").hide();	
				$("#fileTbody").hide();
				$('#mFrm input[name=DSPOVIOL]').attr('readonly', true);
				$('#mFrm input[name=DSPO]').attr('readonly', true);
				$('#mFrm input[name=DSPS_REASON]').attr('readonly', true);
				$('#mFrm input[name=FLLWACT]').attr('readonly', true);
				$('#mFrm input[name=RMK]').attr('readonly', true);
				
			}
			
			var grpSn = "${sessionScope.userMap.GRP_SN}";
			if(grpSn == '2'){
				$('#mFrm input[name=DSPOVIOL]').attr('readonly', true);
				$('#mFrm input[name=DSPO]').attr('readonly', true);
				$('#mFrm input[name=DSPS_REASON]').attr('readonly', true);
				$('#mFrm input[name=FLLWACT]').attr('readonly', true);
				$('#mFrm input[name=RMK]').attr('readonly', true);
			}
		
		}
			
	}
	
	//징계 등록 내용 초기화
	function fn_reset(){
		
		$('#mFrm input[name=DSPL_DT]').val('');
		$('#mFrm input[name=DSPOVIOL]').val('');
		$('#mFrm input[name=DSPO]').val('');
		$('#mFrm input[name=DSPS_REASON]').val('');
		$('#mFrm input[name=FLLWACT]').val('');
		$('#mFrm input[name=RMK]').val('');
	}
	
	//파일 삭제
	function fn_fileDel(FILE_SN, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			$(fileObj).parent().parent('tr').remove();
		}
	}
	
  	//임시저장 혹은 신청일시 삭제
	function fn_delete(){
		
		var DSPL_SN = $("#mFrm input[name=DSPL_SN]").val();
		
		if(DSPL_SN == null || DSPL_SN == ""){
			fnAlert("등록하실 문서가 없습니다 확인부탁드립니다.");
			return;
		}
		
		var param = "DSPL_SN=" + DSPL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/deletePunishJs.kspo", param);
		
		if($json.statusText == "OK"){
			var result = $json.responseJSON.result;
			
			fnAlert("삭제되었습니다.");
			fn_punishSearch();
			
		}
		
	}
	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>징계관리</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/etc/PunishSelect.kspo">
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
			                <td class="t-title">등록일자</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li>
			                            <input id="datepicker" name="STD_YMD" type="text" class="datepick smal" autocomplete="off" value="${STD_YMD}"> ~ 
			                            <input id="datepicker1" name="END_YMD" type="text" class="datepick smal" autocomplete="off" value="${END_YMD}">
			                        </li>
			                    </ul>
			                </td>
			                <td class="t-title">체육단체</td>
			                <td>
			                    <select id="srchMemOrgSn" name="srchMemOrgSn" class="smal">
			                    	<c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
			                        	<option value="" <c:if test="${param.srchMemOrgSn eq '' or param.srchMemOrgSn eq null}">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach items="${memOrgSelect}" var="moLi">
										<option value="${moLi.MEMORG_SN}" <c:if test="${param.srchMemOrgSn eq moLi.MEMORG_SN}">selected="selected"</c:if>>${moLi.MEMORG_NM}</option>
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
			                <td class="t-title">상태</td>
			                <td>
			                    <select id="srchDsplSts" name="srchDsplSts" class="smal">
			                        <option value="" <c:if test="${param.srchDsplSts eq '' or param.srchDsplSts eq null}">selected="selected"</c:if>>전체</option>
									<c:forEach items="${dsplStsList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchDsplSts eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">편입상태</td>
			                <td>
			                    <ul class="com-radio-list">
			                    	<li>
			                            <input id="soldierIncpSts6" type="radio" value="" name="srchProcSts"
			                            	<c:if test="${param.srchProcSts eq '' or param.srchProcSts eq null}">checked="checked"</c:if>>
			                            <label for="soldierIncpSts6">전체</label>
			                        </li>
			                    	<c:forEach var="subLi" items="${procStsList}" varStatus="sts">
			                    		<c:if test="${subLi.ALT_CODE eq 'AG' || subLi.ALT_CODE eq 'MM' }">
			                    			<li>
					                            <input id="soldierIncpSts${sts.index}" type="radio" value="${subLi.ALT_CODE}" name="srchProcSts" <c:if test="${param.srchProcSts eq subLi.ALT_CODE}">checked="checked"</c:if>>
					                            <label for="soldierIncpSts${sts.index}">
					                            	<c:if test="${subLi.ALT_CODE eq 'AG'}">복무</c:if>
					                            	<c:if test="${subLi.ALT_CODE eq 'MM'}">만료</c:if>
					                            </label>
			                        		</li>
			                    		</c:if>
			                    	</c:forEach>
			                	</ul>
			                </td>
			                <td class="t-title">키워드</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li>
			                            <select id="keykind" name="keykind" class="smal">
			                            	<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
											<option value="NAME" <c:if test="${param.keykind eq 'NAME'}">selected="selected"</c:if>>이름</option>
			                            </select>
										<input type="text" name="keyword" class="smal" placeholder="" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_punishSearch();return false;}">
			                        </li>
			                        <li>
			                        </li>
			                    </ul>
			                </td>
			            </tr>
			        </tbody>
			    </table>
			</div>
		
			<div class="com-btn-group center">
			    <button class="btn red write" type="button" onclick="fn_punishSearch();return false;">검색</button>
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
		    	<c:if test="${sessionScope.userMap.GRP_SN ne '2'}"> 
					<button class="btn red rmvcrr" type="button" onclick="punishAddPopOpen();">신규</button>
			    </c:if>
		        <button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
		    </div>
		</div>
		</form>
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:50px">
		            <col style="width:115px">
		            <col style="width:7%">
		            <col style="width:7%">
		            <col style="width:8%">
		            <col style="width:6%">
		            <col style="width:10%">
		            <col style="width:6%">
		            <col style="width:14%">
		            <col style="width:14%">
		            <col style="width:90px">
		            <col style="width:90px">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>징계번호</th>
		                <th>처리상태</th>
		                <th>이름</th>
		                <th>생년월일</th>
		                <th>체육단체</th>
		                <th>관할병무청</th>
		                <th>편입상태</th>
		                <th>처분결과</th>
		                <th>처분사유</th>
		                <th>처분일자</th>
		                <th>등록일자</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<c:choose>
						<c:when test="${not empty punishList}">
							<c:forEach items="${punishList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td>${list.DSPL_SN}</td>
					                <td>${list.DSPL_STS_NM}</td>
					                <td><a href="javascript:fn_Detail('${list.DSPL_SN}');" class="tit">${list.APPL_NM}</a></td>
					                <td>
					                	<fmt:parseDate var="BRTH_DT" value="${list.BRTH_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${BRTH_DT}" pattern="yyyy-MM-dd"/>
					                </td>
					                <td>${list.MEMORG_NM}</td>
					                <td>${list.CTRL_MMA_NM}</td>
					                <td>
					                	<c:choose>
						                	<c:when test="${list.PROC_STS eq 'AG'}">
						                		복무
						                	</c:when>
						                	<c:when test="${list.PROC_STS eq 'MM'}">
						                		만료
						                	</c:when>
					                	</c:choose>
					                </td>
					                <td>${list.DSPO}</td>
					                <td>${list.DSPS_REASON}</td>
					                <td>
					                	<fmt:parseDate var="DSPL_DT" value="${list.DSPL_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${DSPL_DT}" pattern="yyyy-MM-dd"/>
					                </td>
					                <td>${list.REG_DTM}</td>
					            </tr>
		            		</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
				                <td colspan="12" class="center">등록된 게시물이 없습니다.</td>
				            </tr>
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

<!-- 팝업영역 -->
<form id="mFrm" name="mFrm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="DSPL_SN" value=""/>
	<input type="hidden" name="APPL_SN" value=""/>
	<input type="hidden" name="MLTR_ID" value=""/>
	<input type="hidden" name="DSPL_STS" value=""/>
	<input type="hidden" name="EXPR_DT" value=""/>
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<div class="cpt-popup reg03 punish"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            징계 등록
	            <button class="pop-close" onclick="punishAddPopClose();return false;">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="process-status">처리상태 : <b class="t-blue">신규</b></div>
	            <div class="com-h3 add">대상자 인적사항
	                <div class="right-area"><p class="required">필수입력</p></div>
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
	                            <td class="t-title">이름<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <div class="search-box">
	                                    <input type="text" name="APPL_NM" readonly="readonly">
	                                    <button type="button" id="personSearch" onclick="fn_searchPersonPopupOpen();">찾기</button>
	                                </div>
	                            </td>
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td" id="MLTR_ID"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일</td>
	                            <td class="input-td" id="BRTH_DT"></td>
	                            <td class="t-title">주소</td>
	                            <td class="input-td" id="ADDR"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td" id="EMAIL"></td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td" id="CP_NO"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목</td>
	                            <td class="input-td" id="GAME_CD_NM"></td>
	                            <td class="t-title">체육단체</td>
	                            <td class="input-td" id="MEMORG_NM"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">관할병무청</td>
	                            <td class="input-td" id="CTRL_MMA_CD"></td>
	                            <td class="t-title">복무상태</td>
	                            <td class="input-td" id="PROC_STS_NM"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">징계 내용
	                <div class="right-area"><p class="required">필수입력</p></div>
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
	                            <td class="t-title">처분일자</td>
	                            <td class="input-td"><input id="datepicker2" type="text" name="DSPL_DT" autocomplete="off" value="" class="datepick smal" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" readonly></td>
	                            <td class="t-title">위반사항</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="DSPOVIOL"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">처분결과</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="DSPO"></td>
	                            <td class="t-title">처분사유</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="DSPS_REASON"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">조치내용</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="FLLWACT"></td>
	                            <td class="t-title">조치기관<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <ul class="com-radio-list">
	                                    <li>
	                                        <input id="radio11" type="radio" value="" name="radio11" checked>
	                                        <label for="radio11">문화체육관광부</label>
	                                    </li>
	                                </ul>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">비고</td>
	                            <td colspan="3" class="input-td"><input type="text" class="ip-title" name="RMK"></td>
	                        </tr>
	                        <tr>
	                       		<td class="t-title" colspan="4">첨부파일<span class="t-red"></span></td>
	                       </tr>
	                       <tr id="fileTbody">
								<td colspan="3" class="adds bdr-0 input-td">
									<div class="fileBox">
										<input type="text" class="fileName2" readonly="readonly">
										<label for="uploadBtn" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>
										<input type="file" name="file" id="uploadBtn" class="uploadBtn2">
										<input type="hidden" name="ATCH_FILE_ID">
									</div>
								</td>
								<td class="bdl-0 pdr-0 ft-0">
									<button class="btn lightgrey addfile mrg-5" type="button" onclick="fn_addFile(this);"></button>
								</td>
							</tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-btn-group put">
	                <div class="float-r">
	                    <button class="btn grey rmvcrr pc" type="button" onclick="fn_reset();">초기화</button>
	                    <button class="btn red rmvcrr pc" type="button" onclick="fn_save('TP');">임시저장</button>
	                    <button class="btn red rmvcrr pc" type="button" onclick="fn_save('PC');">확정</button>
	                    <button class="btn red rmvcrr pc" type="button" id="fnDelete" onclick="fn_delete();">삭제</button>
	                    <button class="btn navy rmvcrr userDv2" type="button" onclick="punishAddPopClose();">닫기</button>
	                </div>
	            </div>
	            
	        </div>
	    </div>
	</div>
</form>
<!-- //팝업영역 -->

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
					<button class="btn navy rmvcrr userDv2" type="button" onclick="fn_searchPersonPopupClose();return false;">취소</button>
					<button class="btn red write" type="button" onclick="fn_confirmPerson();return false;">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->
