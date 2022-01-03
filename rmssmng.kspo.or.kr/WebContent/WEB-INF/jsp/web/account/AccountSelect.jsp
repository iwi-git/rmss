<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker, #datepicker1").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
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
		
		//전체 선택 해제
		$(document).on("click","input[name=mstChkAll]",function(){
			$(this).parents("table").find("input[name=mstChk]").prop("checked",$(this).is(":checked"));
			$(this).parents("table").find("input[name=mstChk]").attr("checked",$(this).is(":checked"));
		});
		
		//선택 해제
		$(document).on("click","input[name=mstChk]",function(){
			var checked = true;
			$(this).parents("tbody").find("input[name=mstChk]").each(function(){
				if(!$(this).is(":checked")){
					checked = false;
				}
			});
			
			$("input[name=mstChkAll]").prop("checked",checked);
			$("input[name=mstChkAll]").attr("checked",checked);
		});
				
	});
	
	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/account/AccountSelect.kspo",$("#frm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/account/AccountSelectDownload.kspo");
		$("#frm").submit();
	}
	
	//체육단체 계정관리 팝업 열기
	function selectPopOpen(){
		$(".reg03.accountList").addClass("active")
		$("body").css("overflow", "hidden")
	}
	
	//체육단체 계정관리 팝업 닫기
	function selectPopClose() {
		
		$('#mFrm input[name=MNGR_SN]').val("");
		$('#mFrm input[name=MNGR_ID]').val("");
		$('#mFrm input[name=MNGR_NM]').val("");
		$('#mFrm input[name=CPNO]').val("");
		$('#mFrm input[name=TELNO]').val("");
		$('#mFrm input[name=EMAIL]').val("");
		$('#mFrm input[name=LOCGOV_NM]').val("");
		$('#mFrm td[id=REG_DTM]').html("");
		$('#mFrm td[id=RECENT_DT]').html("");
		$("#mFrm input:radio[name=ACNT_STS][value='TA']").prop('checked',false);
		$("#mFrm input:radio[name=ACNT_STS][value='KY']").prop('checked',true);
		$("#mFrm input:radio[name=ACNT_STS][value='KN']").prop('checked',true);
		$("#mFrm input:radio[name=ACNT_STS][value='KX']").prop('checked',true);
		
		$(".reg03.accountList").removeClass("active")
		$("body").css("overflow","auto")
	}
	
	//상세조회
	function fn_Detail(MNGR_SN){
		var param = "MNGR_SN=" + MNGR_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/account/selectAccountDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			if(!dtl){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			selectPopOpen();
			
			$('#mFrm input[name=MNGR_SN]').val(dtl.MNGR_SN);
			$('#mFrm input[name=MNGR_ID]').val(dtl.MNGR_ID);
			$('#mFrm input[name=I_MNGR_NM]').val(dtl.MNGR_NM);
			$('#mFrm select[name=CPNO1]').val(dtl.CPNO1);
			$('#mFrm input[name=CPNO2]').val(dtl.CPNO2);
			$('#mFrm input[name=CPNO3]').val(dtl.CPNO3);
			$('#mFrm input[name=TELNO]').val(dtl.TELNO);
			$('#mFrm input[name=EMAIL1]').val(dtl.EMAIL1);
			$('#mFrm input[name=EMAIL2]').val(dtl.EMAIL2);
			$('#mFrm input[name=LOCGOV_NM]').val(dtl.LOCGOV_NM);
			$('#mFrm td[id=REG_DTM]').html(dtl.REG_DTM);
			$('#mFrm td[id=RECENT_DT]').html(dtl.RECENT_DT);
			$("#mFrm input:radio[name=ACNT_STS][value='"+dtl.ACNT_STS+"']").prop('checked',true);
				
		}
	}
	
	//저장
	function fn_save(){
		
		//전화번호
		if($("#mFrm input[name=TELNO]").val() == "" || $("#mFrm input[name=TELNO]").val() == null){
			fnAlert("전화번호를 입력하시기 바랍니다.");
			return false;
		}

		//휴대폰
		if($("#mFrm select[name=CPNO1]").val() != ""){
			if($("#mFrm select[name=CPNO1]").val() == "" || $("#mFrm select[name=CPNO1]").val() == null
					|| $("#mFrm input[name=CPNO2]").val() == "" || $("#mFrm input[name=CPNO2]").val() == null
					|| $("#mFrm input[name=CPNO3]").val() == "" || $("#mFrm input[name=CPNO3]").val() == null ){
				fnAlert("휴대폰을 입력하시기 바랍니다.");
				return;
			}
		}
		
		var saveUrl = "/account/updateAccountJs.kspo";
	
		var $json = getJsonData("post", saveUrl, $("#mFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("저장되었습니다.");
			fn_search();	
		}
	
	}

	//비밀번호초기화
	function fn_changePW(ACNT_STS){
		
		var saveUrl = "/account/updateChangePwAccountJs.kspo";
	
		var $json = getJsonData("post", saveUrl, $("#mFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("비밀번호가 아이디랑 동일하게 초기화 되었습니다.");
			fn_search();	
		}
	
	}

	//계정승인, 거부, 정지
	function fn_acntSave(ACNT_STS){
		
		var checkedCnt = $('#sFrm input[name=mstChk]:checked').length;

		if(checkedCnt < 1){
			fnAlert("1개이상 체크박스를 선택해주세요.");
			return false;
		}
		
		var saveUrl = "/account/updateAcntStsAccountJs.kspo";
	
		$("#sFrm input[name=ACNT_STS]").val(ACNT_STS);
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			
	        if(ACNT_STS == "KY"){
	        	fnAlert("계정 승인되었습니다.");
	        }else if(ACNT_STS == "KN"){
	        	fnAlert("계정 거부되었습니다.");
	        }else if(ACNT_STS == "KX"){
	        	fnAlert("계정 정지되었습니다.");
	        }else{
	        	fnAlert("계정정보가 변경되었습니다.");
	        }
			
			fn_search();	
		}
	
	}
	
	//휴면계정 해제
	function fn_acntKuSave(){
		
		var checkedCnt = $('#sFrm input[name=mstChk]:checked').length;

		if(checkedCnt < 1){
			fnAlert("1개이상 체크박스를 선택해주세요.");
			return false;
		}
		
		var saveUrl = "/account/updateAcntKuStsAccountJs.kspo";
	
		$("#sFrm input[name=ACNT_STS]").val('HY');
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			
	        fnAlert("휴면 계정이 해지 되었습니다.");
			fn_search();	
		}
	
	}

	//계정삭제
	function fn_del(){
		
		var checkedCnt = $('#sFrm input[name=mstChk]:checked').length;

		if(checkedCnt < 1){
			fnAlert("1개이상 체크박스를 선택해주세요.");
			return false;
		}
		
		var saveUrl = "/account/deleteAccountJs.kspo";
	
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("삭제되었습니다.");
			fn_search();	
		}
	
	}
	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>체육단체 계정관리</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/account/AccountSelect.kspo">
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
			                <td class="t-title">계정상태</td>
			                <td colspan="3">
			                    <ul class="com-radio-list">
	                                <li>
	                                    <input id="radio1" type="radio" value="" name="srchAcntSts" <c:if test="${param.srchAcntSts eq '' or param.srchAcntSts eq null }"> checked </c:if>>
	                                    <label for="radio1">전체</label>
	                                </li>
			                    	<c:forEach items="${acntStsList}" var="subLi">
	                                    <li>
	                                        <input id="${subLi.CNTNT_FST}" type="radio" value="${subLi.ALT_CODE}" name="srchAcntSts" <c:if test="${param.srchAcntSts eq subLi.ALT_CODE}"> checked </c:if>>
	                                        <label for="${subLi.CNTNT_FST}">${subLi.CNTNT_FST}</label>
	                                    </li>
									</c:forEach>
			                    </ul>
			                </td>
			            </tr>
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
			                <td class="t-title">키워드</td>
			                <td>
			                    <ul class="com-radio-list">
									<li>
			                            <select id="keykind" name="keykind" class="smal">
			                            	<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
											<option value="MNGR_ID" <c:if test="${param.keykind eq 'MNGR_ID'}">selected="selected"</c:if>>아이디</option>
											<option value="MNGR_NM" <c:if test="${param.keykind eq 'MNGR_NM'}">selected="selected"</c:if>>이름</option>
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
		    	<button class="btn red rmvcrr" type="button" onclick="fn_acntSave('KY');">계정승인</button>
		        <button class="btn red rmvcrr" type="button" onclick="fn_acntSave('KN');">계정거부</button>
		        <button class="btn red rmvcrr" type="button" onclick="fn_acntSave('KX');">정지</button>
		        <button class="btn red rmvcrr" type="button" onclick="fn_acntKuSave();">휴면계정해제</button>
		        <button class="btn red rmvcrr" type="button" onclick="fn_del();">삭제</button>
		        <button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
		    </div>
		</div>
		</form>
		<form method="post" id="sFrm" name="sFrm" >
			<input type="hidden" name="pageNo" value="${pageInfo.currentPageNo}">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<input type="hidden" name="ACNT_STS" value="">
			<div class="com-grid">
			    <table class="table-grid">
			        <caption></caption>
			        <colgroup>
			            <col style="width:5%">
			            <col style="width:7%">
			            <col style="width:15%">
			            <col style="width:15%">
			            <col style="width:10%">
			            <col style="width:15%">
			            <col style="width:10%">
			            <col style="width:7%">
			            <col style="width:auto">
			        </colgroup>
			        <thead>
			            <tr>
			                <th>
			                    <div class="input-box">
			                        <input type="checkbox" id="checkall"  name="mstChkAll">
			                        <label for="checkall" class="chk-only">전체선택</label>
			                    </div>
			                </th>
			                <th>번호</th>
			                <th>아이디</th>
			                <th>이름</th>
			                <th>사용자그룹</th>
			                <th>소속</th>
			                <th>등록일자</th>
			                <th>계정상태</th>
			                <th>삭제여부</th>
			            </tr>
			        </thead>
			        <tbody>
			        	<c:choose>
							<c:when test="${not empty accountList}">
								<c:forEach items="${accountList}" var="list" varStatus="state">
						            <tr>
						                <td>
						                    <div class="input-box">
												<input id="check01-${state.count}" type="checkbox" name="mstChk" value="${list.MNGR_SN}"/>
												<label for="check01-${state.count}" class="chk-only"></label>
											</div>
						                </td>
						                <td>${list.RNUM}</td>
						                <td>${list.MNGR_ID}</td>
						                <td><a href="javascript:fn_Detail('${list.MNGR_SN}');" class="tit">${list.MNGR_NM}</a></td>
						                <td>${list.GRP_SN}</td>
						                <td>${list.LOCGOV_NM}</td>
						                <td>${list.REG_DTM}</td>
						                <td>${list.ACNT_STS_NM}</td>
						                <td>
						                	<c:choose>
						                		<c:when test="${list.DEL_YN eq 'N'}">
						                			사용
						                		</c:when>
						                		<c:otherwise>
						                			삭제
						                		</c:otherwise>
						                	</c:choose>
						                </td>
						            </tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
					            <tr>
					                <td colspan="9" class="center">등록된 게시물이 없습니다.</td>
					            </tr>
			            	</c:otherwise>
						</c:choose>
			        </tbody>
			    </table>
			</div>
			<div class="com-paging">
			    <ui:pagination paginationInfo = "${pageInfo}" type="text" jsFunction="fnGoPage:frm" />
			</div>
		</form>
	</div>
</div>

<!-- 팝업영역 -->
<form id="mFrm" name="mFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="MNGR_SN" value="">
	<div class="cpt-popup reg03 accountList"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            사용자계정관리
	            <button class="pop-close" onclick="selectPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="com-h3 add">사용자정보</div>
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
	                            <td class="t-title">아이디</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MNGR_ID" readonly></td>
	                            <td class="t-title">이름</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="I_MNGR_NM" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">사용자그룹</td>
	                            <td class="input-td">체육단체</td>
	                            <td class="t-title">소속</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="LOCGOV_NM"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">전화</td>
	                            <td class="input-td">
	                                <input type="text" title="휴대전화 중간자리 입력" name="TELNO" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                            </td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td type03">
	                                <select id="CPNO1" name="CPNO1" class="">
	                                    <option value="">선택</option>
										<c:forEach items="${telList}" var="subLi">
											<option value="${subLi.CNTNT_FST}" <c:if test="${param.CPNO1 eq subLi.CNTNT_FST}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                                <span>-</span> 
	                                <input type="text" title="휴대전화 중간자리 입력" name="CPNO2" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                                <span>-</span>
	                                <input type="text" title="휴대전화 뒷자리 입력" name="CPNO3" maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td">
	                            	<div class="email-box">
	                                    <input type="text" name="EMAIL1">
	                                    <span class="text">@</span>
	                                    <input type="text" name="EMAIL2">
	                                </div>
	                            </td>
	                            
	                            <td class="t-title">등록일자</td>
	                            <td class="input-td" id="REG_DTM"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">계정상태</td>
	                            <td>
	                                <ul class="com-radio-list">
	                                
										<c:forEach items="${acntStsList}" var="subLi">
		                                    <li>
		                                        <input id="${subLi.ALT_CODE}" type="radio" value="${subLi.ALT_CODE}" name="ACNT_STS" <c:if test="${dtl.ACNT_STS eq subLi.ALT_CODE}"> checked </c:if>>
		                                        <label for="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</label>
		                                    </li>
										</c:forEach>
	                                </ul>
	                            </td>
	                            <td class="t-title">최근접속</td>
	                            <td class="input-td" id="RECENT_DT"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-btn-group put">
	                <div class="float-r">
	                	<button class="btn red rmvcrr" type="button" onclick="fn_changePW();">비밀번호초기화</button>
	                    <button class="btn red rmvcrr" type="button" onclick="fn_save();">저장</button>
	                    <button class="btn navy rmvcrr userDv2" type="button" onclick="selectPopClose();">닫기</button>
	                </div>
	            </div>
	            
	        </div>
	    </div>
	</div>
</form>
<!-- //팝업영역 -->