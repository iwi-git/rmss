<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker, #datepicker1").datepicker({
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
		
	});
	
	//검색
	function fn_search(){
		
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("편입일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		
		fnPageLoad("/apply/SoldierMngSelect.kspo",$("#frm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/apply/SoldierMngDownload.kspo");
		$("#frm").submit();
	}
	
	//체육요원 복무현황 상세 팝업 열기
	function selectPopOpen(){
		$(".detail").addClass("active")
		$("body").css("overflow", "hidden")
	}
	
	//체육요원 복무현황 상세 팝업 닫기
	function selectPopClose() {
		
		$("#sFrm input[name=MLTR_ID]").val("");
		$("#sFrm input[name=APPL_SN]").val("");
		$("#sFrm .uName").text("");
		$("#sFrm input[name=EXPR_DT]").val("");
		$("#sFrm textarea[name=EXPR_REASON]").val("");
		$("#sFrm input[name=APPL_CNCL_DT]").val("");
		$("#sFrm textarea[name=APPL_CNCL_REASON]").val("");
		$("#sFrm input[name=PROC_STS]").val("");
		$("#sFrm .t-blue").text("");
		$("#completion").show();
		
		$(".detail").removeClass("active")
		$("body").css("overflow","auto")
	}
	
	//상세조회
	function fn_Detail(MLTR_ID){
		var param = "MLTR_ID=" + MLTR_ID;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/apply/SoldierMngSelectDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			var recordDtl = $json.responseJSON.recordDtl;
			
			$("#sFrm input[name=MLTR_ID]").val(dtl.MLTR_ID);
			$("#sFrm input[name=APPL_SN]").val(dtl.APPL_SN);
			$("#sFrm input[name=RSVT_DT]").val(dtl.RSVT_DT);
			$('#sFrm input[name=APPL_CNCL_DT]').attr('readonly', false);
			$('#sFrm input[name=EXPR_DT]').attr('readonly', false);
			$('#sFrm textarea[name=EXPR_REASON]').attr('readonly', false);
			$('#sFrm textarea[name=APPL_CNCL_REASON]').attr('readonly', false);
			
			//대상자 인적사항 시작
			var dtlObj = "";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>이름<span class='t-red'> *</span></td>";
				dtlObj += "	<td class='input-td'>" + dtl.APPL_NM + "</td>";
				dtlObj += "	<td class='t-title'>관리번호</td>";
				dtlObj += "	<td class='input-td'>" + dtl.MLTR_ID + "</td>";
				dtlObj += "</tr>";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>생년월일</td>";
				dtlObj += "	<td class='input-td'>" + dtl.BRTH_DT + "</td>";
				dtlObj += "	<td class='t-title'>주소</td>";
				dtlObj += "	<td class='input-td'>" + dtl.ADDR + "</td>";
				dtlObj += "</tr>";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>이메일</td>";
				dtlObj += "	<td class='input-td'>" + dtl.EMAIL + "</td>";
				dtlObj += "	<td class='t-title'>휴대폰</td>";
				dtlObj += "	<td class='input-td'>" + dtl.CP_NO + "</td>";
				dtlObj += "</tr>";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>소속팀</td>";
				dtlObj += "	<td class='input-td'>" + dtl.TEAM_NM + "</td>";
				dtlObj += "	<td class='t-title'>대회명</td>";
				dtlObj += "	<td class='input-td'>" + dtl.CONT_NM + "</td>";
				dtlObj += "</tr>";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>종목</td>";
				dtlObj += "	<td class='input-td'>" + dtl.GAME_NM + "</td>";
				dtlObj += "	<td class='t-title'>등위</td>";
				dtlObj += "	<td class='input-td'>" + dtl.RANK + "</td>";
				dtlObj += "</tr>";
				dtlObj += "<tr>";
				dtlObj += "	<td class='t-title'>세부종목</td>";
				dtlObj += "	<td class='input-td'>" + dtl.GAME_DTL + "</td>";
				dtlObj += "	<td class='t-title'>입상일</td>";
				dtlObj += "	<td class='input-td'>" + dtl.AWRD_DT + "</td>";
				dtlObj += "</tr>";
			$("#person").html(dtlObj);
			//대상자 인적사항 끝
			
			//체육단체 및 담당자 정보 시작
			var memorgObj = "";
				memorgObj += "<tr>";
				memorgObj += "	<td class='t-title'>체육단체<span class='t-red'> *</span></td>";
				memorgObj += "	<td class='input-td'>" + dtl.MEMORG_NM + "</td>";
				memorgObj += "	<td class='t-title'>연락처<span class='t-red'> *</span></td>";
				memorgObj += "	<td class='input-td'>" + dtl.MEMORG_TEL_NO + "</td>";
				memorgObj += "</tr>";
			$("#memorg").html(memorgObj);
			//체육단체 및 담당자 정보 끝

			//편입승인현황 시작
			var applAcptObj = "";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>편입일자<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.ADDM_DT + "</td>";
				applAcptObj += "	<td class='t-title'>복무만료 예정일자<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.S_RSVT_DT + "</td>";
				applAcptObj += "</tr>";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>복무기간<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.SRV_INSTT_CODE_NM + "</td>";
				applAcptObj += "	<td class='t-title'>복무분야<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.SRV_FIELD_NM + "</td>";
				applAcptObj += "</tr>";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>관할병무청<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.CTRL_MMA_NM + "</td>";
				applAcptObj += "	<td class='t-title'>통보근거</td>";
				applAcptObj += "	<td class='input-td'>" + dtl.DSPTH_REASON + "</td>";
				applAcptObj += "</tr>";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>처리일자<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>" + dtl.ACPT_CMPL_DTM + "</td>";
				applAcptObj += "	<td class='t-title'>복무만료일자<span class='t-red'> *</span></td>";
				applAcptObj += "	<td class='input-td'>"+ dtl.S_EXPR_DT +"</td>";
				applAcptObj += "</tr>";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>사유<span class='t-red'> *</span></td>";
				applAcptObj += "	<td colspan='3' class='input-td'>" + dtl.CMPL_REASON + "</td>";
				applAcptObj += "</tr>";
				applAcptObj += "<tr>";
				applAcptObj += "	<td class='t-title'>첨부파일</td>";
				applAcptObj += "	<td colspan='3' class='input-td'><span class='file-name'><a href='javascript:fnDownloadFile("+dtl.ATCH_FILE_ID+")'>"+dtl.ATCH_FILE_NM+"</a></span></td>";
				applAcptObj += "</tr>";
             
			$("#applAcpt").html(applAcptObj);
			//편입승인현황 끝
			
			//공익복무 실적현황 시작
			var recordMngObj = "";
			if(recordDtl.length > 0){
				for(var i=0;i<recordDtl.length;i++) {
					recordMngObj += "<tr>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].RECD_CNT + "</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].RECD_M_CNT + "</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].RECD_D_CNT + "</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].TOT_FINAL_ACT_TIME_HR + "시간 " + recordDtl[i].TOT_FINAL_ACT_TIME_MN + "분</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].TOT_FINAL_WP_MV_TIME + "</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].TOT_FINAL_TIME_HR + "시간 " + recordDtl[i].TOT_FINAL_TIME_MN + "분</td>";
					recordMngObj += "	<td class='center'>" + recordDtl[i].FINAL_REMAIN_ACT_TIME_HR + "시간 " + recordDtl[i].FINAL_REMAIN_ACT_TIME_MN + "분</td>";
					recordMngObj += "</tr>";
				}
			}else{
				recordMngObj += "<tr><td colspan='7' class='blank'>검색결과가 존재하지 않습니다.</td></tr>";
			}
				
			$("#recordMng").html(recordMngObj);
			//공익복무 실적현황 끝
			
			$("#sFrm .uName").text("Last Update. "+dtl.UPDR_NM+" / "+dtl.UPDT_DT);
			$("#sFrm input[name=EXPR_DT]").val(dtl.EXPR_DT);
			$("#sFrm textarea[name=EXPR_REASON]").val(dtl.EXPR_REASON);
			$("#sFrm input[name=APPL_CNCL_DT]").val(dtl.APPL_CNCL_DT);
			$("#sFrm textarea[name=APPL_CNCL_REASON]").val(dtl.APPL_CNCL_REASON);
			$("#sFrm .t-blue").text(dtl.PROC_STS_NM);
			
			if(dtl.PROC_STS == "MM" || dtl.PROC_STS == "AC"){ //복무만료 및 편입취소 처리시 모든 버튼 비활성화
				$("#completion").hide();
				$('#sFrm input[name=APPL_CNCL_DT]').attr('readonly', true);
				$('#sFrm input[name=EXPR_DT]').attr('readonly', true);
				$('#sFrm textarea[name=EXPR_REASON]').attr('readonly', true);
				$('#sFrm textarea[name=APPL_CNCL_REASON]').attr('readonly', true);
			}
			
			var grpSn = "${sessionScope.userMap.GRP_SN}";
			if(grpSn == '2'){
				$('#sFrm input[name=APPL_CNCL_DT]').attr('readonly', true);
				$('#sFrm input[name=EXPR_DT]').attr('readonly', true);
				$('#sFrm textarea[name=EXPR_REASON]').attr('readonly', true);
				$('#sFrm textarea[name=APPL_CNCL_REASON]').attr('readonly', true);
			}
			
			if(grpSn == '1' && dtl.PROC_STS == "AG"){
				$("#datepicker2, #datepicker3").datepicker({
					showOtherMonths: true,
					selectOhterMonth: true
				});
				
				$(document).on("change","#datepicker2",function(){
					$("#datepicker2").datepicker('option','maxDate',0);
				});
				
				$(document).on("change","#datepicker3",function(){
					$("#datepicker3").datepicker('option','maxDate',0);
				});
			}
			
			selectPopOpen();
		}
	}
	
	//복무만료
	function exprSave(){
		
		var now = new Date();
		
		var year = now.getFullYear();
		var month = (now.getMonth()+1); //월은 +1 해줘야됨
		var date = now.getDate();
		
		var day = year+""+month+""+date; 
		
		if($("#sFrm input[name=EXPR_DT]").val() == "" || $("#sFrm input[name=EXPR_DT]").val() == null){
			fnAlert("복무만료일자를 입력하시기 바랍니다.");
			return;	
		}
		
		if($("#sFrm input[name=RSVT_DT]").val() >= day ){
			fnAlert("복무만료예정일이 더 남았습니다 확인후 처리해주세요.");
			return;	
		}
		
		$("#sFrm input[name=PROC_STS]").val("MM");
		
		var saveUrl = "/apply/updateSolidMngExprApplCnclProcJs.kspo";
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("복무만료되었습니다.");
			fn_search();	
		}
	}

	//편입취소
	function applCnclSave(){
		
		if($("#sFrm input[name=APPL_CNCL_DT]").val() == "" || $("#sFrm input[name=APPL_CNCL_DT]").val() == null){
			fnAlert("편입취소일자를 입력하시기 바랍니다.");
			return;	
		}

		if($("#sFrm textarea[name=APPL_CNCL_REASON]").val() == "" || $("#sFrm textarea[name=APPL_CNCL_REASON]").val() == null){
			fnAlert("편입취소사유를 입력하시기 바랍니다.");
			return;	
		}
		
		$("#sFrm input[name=PROC_STS]").val("AC");
		var saveUrl = "/apply/updateSolidMngExprApplCnclProcJs.kspo";
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("편입취소 되었습니다.");
			fn_search();	
		}
	}
	
</script>
<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>체육요원 복무현황</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/apply/SoldierMngSelect.kspo">
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
			                <td class="t-title">편입일</td>
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
<%-- 			                        <option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach items="${gameNmList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			                <td class="t-title">관할병무청</td>
			                <td>
			                    <select id="srchMltrAdmn" name="srchMltrAdmn" class="smal">
			                        <option value="" <c:if test="${param.srchMltrAdmn eq '' or param.srchMltrAdmn eq null}">selected="selected"</c:if>>전체</option>
									<c:forEach items="${MltrAdmnList}" var="maLi">
										<option value="${maLi.ALT_CODE}" <c:if test="${param.srchMltrAdmn eq maLi.ALT_CODE}">selected="selected"</c:if>>${maLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">진행상태</td>
			                <td>
			                    <select id="srchApplSts" name="srchApplSts" class="smal">
			                        <option value="" <c:if test="${param.srchApplSts eq '' or param.srchApplSts eq null}">selected="selected"</c:if>>전체</option>
									<c:forEach items="${ApplStsList}" var="asLi">
										<option value="${asLi.ALT_CODE}" <c:if test="${param.srchApplSts eq asLi.ALT_CODE}">selected="selected"</c:if>>${asLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			                <td class="t-title">키워드</td>
			                <td>
			                    <ul class="com-radio-list">
			                       <li>
			                            <select id="keykind" name="keykind" class="smal">
			                            	<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
											<option value="NAME" <c:if test="${param.keykind eq 'NAME'}">selected="selected"</c:if>>이름</option>
											<option value="ADDR" <c:if test="${param.keykind eq 'ADDR'}">selected="selected"</c:if>>주소</option>
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
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:50px">
		            <col style="width:115px">
		            <col style="width:115px">
		            <col style="width:115px">
		            <col style="width:7%">
		            <col style="width:7%">
		            <col style="width:7%">
		            <col style="width:auto">
		            <col style="width:10%">
		            <col style="width:7%">
		            <col style="width:7%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>관리번호</th>
		                <th>진행상태</th>
		                <th>이름</th>
		                <th>생년월일</th>
		                <th>체육단체</th>
		                <th>종목</th>
		                <th>주소</th>
		                <th>관할병무청</th>
		                <th>편입일</th>
		                <th>복무만료일</th>
		            </tr>
		        </thead>
		        <tbody>
		            <c:choose>
						<c:when test="${not empty soldierMngList}">
							<c:forEach items="${soldierMngList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td>${list.MLTR_ID}</td>
					                <td>${list.PROC_STS_NM}</td>
					                <td><a href="javascript:fn_Detail('${list.MLTR_ID}');" class="tit">${list.APPL_NM}</a></td>
					                <td>${list.BRTH_DT}</td>        
					                <td>${list.MEMORG_NM}</td>
					                <td>${list.GAME_NM}</td>
					                <td style="text-align:left;">${list.ADDR}</td>
					                <td>${list.CTRL_MMA_NM}</td>
					                <td>
					                	<fmt:parseDate var="ADDM_DT" value="${list.ADDM_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${ADDM_DT}" pattern="yyyy-MM-dd"/>
					                </td>
					                <td <c:if test="${list.EXPR_DT ne list.RSVT_DT}">style="color:red;"</c:if>>
					                	<fmt:parseDate var="EXPR_DT" value="${list.EXPR_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${EXPR_DT}" pattern="yyyy-MM-dd"/>
					                </td>					        
					            </tr>
		            		</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="11" class="blank">검색결과가 존재하지 않습니다.</td></tr>
						</c:otherwise>
					</c:choose>
		        </tbody>			        
		        <tr height="10">
			    </tr>		        
		    </table>
		</div>
		
		<div class="com-paging">
			<ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:frm" />
		</div>
	</div>
</div>

<!-- 팝업영역 -->
<form method="post" id="sFrm" name="sFrm" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="MLTR_ID" value="${detail.MLTR_ID}">
	<input type="hidden" name="APPL_SN" value="">
	<input type="hidden" name="PROC_STS" value="">
	<input type="hidden" name="RSVT_DT" value="">
	<div class="cpt-popup reg03 detail"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            체육요원 복무현황
	            <button class="pop-close" onclick="selectPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="process-status">처리상태 : <b class="t-blue">복무중</b></div>
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
	                    <tbody id="person">
	                        <tr>
	                            <td class="t-title">이름<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일</td>
	                            <td class="input-td"></td>
	                            <td class="t-title">주소</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td"></td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">소속팀</td>
	                            <td class="input-td"></td>
	                            <td class="t-title">대회명</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목</td>
	                            <td class="input-td"></td>
	                            <td class="t-title">등위</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">세부종목</td>
	                            <td class="input-td"></td>
	                            <td class="t-title">입상일</td>
	                            <td class="input-td"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            
	            <div class="com-h3 add">체육단체 및 담당자 정보
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
	                    <tbody id="memorg">
	                        <tr>
	                            <td class="t-title">체육단체<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title">연락처<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">편입승인현황
	                <div class="right-area"><p class="required">필수입력</p></div>
	            </div>
	            <div class="com-table">
	                <table class="table-board">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width:130px;">
	                        <col style="width:auto;">
	                        <col style="width:170px;">
	                        <col style="width:auto;">
	                    </colgroup>
	                    <tbody id="applAcpt">
	                        <tr>
	                            <td class="t-title">편입일자<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title">복무만료 예정일자<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">복무기간<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title">복무분야<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">관할병무청<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title">승인내역</td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">처리일자<span class="t-red"> *</span></td>
	                            <td class="input-td"></td>
	                            <td class="t-title"></td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">사유<span class="t-red"> *</span></td>
	                            <td colspan="3" class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">첨부파일</td>
	                            <td colspan="3" class="input-td">
	                                <table class="table-board">
	                                    <caption></caption>
	                                    <colgroup>
	                                        <col style="width:200px;">
	                                        <col style="width:auto;">
	                                        <col style="width:130px;">
	                                    </colgroup>
	                                    <tbody>
	                                        <tr>
	                                            <td class="t-title">체육요원추천서<span class="t-red"> *</span></td>
	                                            <td class="input-td"><span class="file-name">파일명.pdf<button class="file-del">삭제</button></span></td>
	                                            <td class="input-td center">
	                                                <input id="fileUp01" class="file-table" type="file" />
	                                                <label for="fileUp01" class="btn dark rmvcrr">파일선택</label>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td class="t-title">재직증명서<span class="t-red"> *</span></td>
	                                            <td class="input-td"><span class="file-name">파일명.pdf<button class="file-del">삭제</button></span></td>
	                                            <td class="input-td center">
	                                                <input id="fileUp02" class="file-table" type="file" />
	                                                <label for="fileUp02" class="btn dark rmvcrr">파일선택</label>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td class="t-title">입상확인서<span class="t-red"> *</span></td>
	                                            <td class="input-td"><span class="file-name">파일명.pdf<button class="file-del">삭제</button></span></td>
	                                            <td class="input-td center">
	                                                <input id="fileUp03" class="file-table" type="file" />
	                                                <label for="fileUp03" class="btn dark rmvcrr">파일선택</label>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td class="t-title">군복무확인서</td>
	                                            <td class="input-td"><span class="file-name">파일명.pdf<button class="file-del">삭제</button></span></td>
	                                            <td class="input-td center">
	                                                <input id="fileUp04" class="file-table" type="file" />
	                                                <label for="fileUp04" class="btn dark rmvcrr">파일선택</label>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <td class="t-title">기타</td>
	                                            <td class="input-td"><span class="file-name">파일명.pdf<button class="file-del">삭제</button></span></td>
	                                            <td class="input-td center">
	                                                <input id="fileUp05" class="file-table" type="file" />
	                                                <label for="fileUp05" class="btn dark rmvcrr">파일선택</label>
	                                            </td>
	                                        </tr>
	                                    </tbody>
	                                </table>
	                                <span class="t-red">※ 첨부파일 필요항목 : 체육요원 추천서, 재직증명서, 입상확인서, 군복무확인서(해당자만) 등을 첨부합니다.</span>
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            
	            <div class="com-h3">봉사활동 실적현황</div>
	                                
	            <div class="com-grid"> <!-- 20211108 수정 -->
	                <table class="table-grid"> <!-- 20211108 수정 -->
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width:12.5%;">
	                        <col style="width:12.5%;">
	                        <col style="width:12.5%;">
	                        <col style="width:12.5%;">
	                        <col style="width:12.5%;">
	                        <col style="width:12.5%;">
	                        <col style="width:auto;">
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th>계획</th>
	                            <th>실적건수</th>
	                            <th>봉사건수</th>
	                            <th>활동시간</th>
	                            <th>이동시간</th>
	                            <th>합계</th>
	                            <th>잔여시간</th>
	                        </tr>
	                    </thead>
	                    <tbody id="recordMng">
	                        <tr>
	                        	<c:forEach var="recordDtl" items="${recordDtl}">
									<tr>
			                            <td class="center">${recordDtl.RNUM}</td>
			                            <td class="center">${recordDtl.RECD_M_CNT}</td>
			                            <td class="center">${recordDtl.RECD_D_CNT}</td>
			                            <td class="center">${recordDtl.TOT_FINAL_ACT_TIME_HR}시간 ${recordDtl.TOT_FINAL_ACT_TIME_MN}분</td>
			                            <td class="center">${recordDtl.TOT_FINAL_WP_MV_TIME}</td>
			                            <td class="center">${recordDtl.TOT_FINAL_TIME_HR} 시간 ${recordDtl.TOT_FINAL_TIME_MN}분</td>
			                            <td class="center">${recordDtl.FINAL_REMAIN_ACT_TIME_HR}시간 ${recordDtl.FINAL_REMAIN_ACT_TIME_MN}분</td>
									</tr>
								</c:forEach>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">복무만료 및 편입취소 처리
	                <div class="right-area"><p class="required">필수입력</p></div>
	            </div>
	            <div class="com-table">
	                <table class="table-board">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width:150px;">
	                        <col style="width:auto;">
	                        <col style="width:150px;">
	                        <col style="width:auto;">
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th colspan="2">복무만료</th>
	                            <th colspan="2">편입취소</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <tr>
	                            <td class="t-title">복무만료일자<span class="t-red"> *</span></td>
	                            <td class="input-td"><input id="datepicker2" type="text" class="datepick" autocomplete="off" name="EXPR_DT" value="" readonly></td>
	                            <td class="t-title">편입취소일자<span class="t-red"> *</span></td>
	                            <td class="input-td"><input id="datepicker3" type="text" class="datepick" autocomplete="off" name="APPL_CNCL_DT" value="" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">비고</td>
	                            <td class="input-td"><textarea rows="5" name="EXPR_REASON"></textarea></td>
	                            <td class="t-title">편입취소사유<span class="t-red"> *</span></td>
	                            <td class="input-td"><textarea rows="5" name="APPL_CNCL_REASON"></textarea></td>
	                        </tr>
	                        <c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
		                        <tr id="completion">
		                            <td colspan="2" class="center"><button class="btn dark put-search" onclick="exprSave();">의무복무만료처리</button></td>
		                            <td colspan="2" class="center"><button class="btn dark put-search" onclick="applCnclSave();">편입취소처리</button></td>
		                        </tr>
	                        </c:if>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-helf">
	                <ol>
	                    <li class="uName">Last Update. 홍길동 / 0000-00-00</li>
	                </ol>
	            </div>
	
	            <div class="com-btn-group put">
	                <div class="float-r">
	                    <button class="btn navy rmvcrr" type="button" onclick="selectPopClose();">닫기</button>
	                </div>
	            </div>
	            
	        </div>
	    </div>
	</div>
</form>
<!-- //팝업영역 -->