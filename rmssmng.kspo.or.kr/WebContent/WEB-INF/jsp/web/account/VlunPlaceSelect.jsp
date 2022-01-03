<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	
	//체육단체 계정관리 팝업 열기
	function addPopOpen(){
		
		$("#mFrm input:radio[name=VLUN_PLC_DV][value='P01']").prop('checked',true);
		$("#mFrm input:radio[name=USE_YN][value='Y']").prop('checked',true);
		$(".reg03.vlunPlace").addClass("active")
		$("body").css("overflow", "hidden")
	}
	
	//체육단체 계정관리 팝업 닫기
	function addPopClose() {
		
		$("#mFrm input[name=VLUN_PLC_SN]").val("");
		$("#mFrm input[name=VLUN_PLC_FST]").val("");
		$('#mFrm input[name=VLUN_PLC_SCD]').val("");
		$('#mFrm input[name=VLUN_PLC_NM]').val("");
		$('#mFrm input[name=VLUN_PLC_ADDRESS]').val("");
		$('#mFrm input[name=VLUN_PLC_REPR]').val("");
		$('#mFrm input[name=VLUN_PLC_TEL_NO]').val("");
		$('#mFrm input[name=PLC_MNGR_NM]').val("");
		$('#mFrm input[name=PLC_MNGR_TEL_NO]').val("");
		$('#mFrm input[name=PLC_MNGR_EMAIL]').val("");
		$('#mFrm input[name=PLC_MNGR_CP_NO]').val("");
		$("#mFrm input:radio[name=USE_YN][value='Y']").prop('checked',false);
		$("#mFrm input:radio[name=USE_YN][value='N']").prop('checked',false);
		$("#mFrm input:radio[name=VLUN_PLC_DV][value='P01']").prop('checked',false);
		$("#mFrm input:radio[name=VLUN_PLC_DV][value='P02']").prop('checked',false);
		$('#mFrm input[name=MAIN_ACT_AREA]').val("");
		$('#mFrm input[name=MAIN_TGT]').val("");
		$("#UPDT_DT").text("");
		
		$(".reg03.vlunPlace").removeClass("active")
		$("body").css("overflow","auto")
	}
	
	//검색
	function fn_search(){
		fnPageLoad("/account/VlunPlaceSelect.kspo",$("#frm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/account/VlunPlaceSelectDownload.kspo");
		$("#frm").submit();
	}
	
	//저장
	function fn_save() {
		if(fn_saveValid()){
			
			var saveUrl = "/account/updateVlunPlaceJs.kspo";
			if($("#mFrm input[name=VLUN_PLC_SN]").val() == "" || $("#mFrm input[name=VLUN_PLC_SN]").val() == null){
				saveUrl = "/account/insertVlunPlaceJs.kspo";
			}

			var $json = getJsonData("post", saveUrl, $("#mFrm").serialize());
			
			if($json.statusText == "OK"){
				fnAlert("저장되었습니다.");
				fn_search();	
			}
		}
	}
	
	//벨리데이션 체크
	function fn_saveValid(){
	
		if($("#mFrm input[name=VLUN_PLC_NM]").val() == "" || $("#mFrm input[name=VLUN_PLC_NM]").val() == null){
			fnAlert("단체명을 입력하시기 바랍니다.");
			$("#mFrm input[name=VLUN_PLC_NM]").focus();
			return ;
		}
		
		if($("#mFrm input[name=VLUN_PLC_ADDRESS]").val() == "" || $("#mFrm input[name=VLUN_PLC_ADDRESS]").val() == null){
			fnAlert("주소를 입력하시기 바랍니다.");
			$("#mFrm input[name=VLUN_PLC_ADDRESS]").focus();
			return ;
		}
		
		return true;
	}

	//상세조회
	function fn_Detail(VLUN_PLC_SN){
		var param = "VLUN_PLC_SN=" + VLUN_PLC_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/account/selectVlunPlaceDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			
			addPopOpen();
			
			$("#mFrm input[name=VLUN_PLC_SN]").val(dtl.VLUN_PLC_SN);
			$("#mFrm input[name=VLUN_PLC_FST]").val(dtl.VLUN_PLC_FST);
			$('#mFrm input[name=VLUN_PLC_SCD]').val(dtl.VLUN_PLC_SCD);
			$('#mFrm input[name=VLUN_PLC_NM]').val(dtl.VLUN_PLC_NM);
			$('#mFrm input[name=VLUN_PLC_ADDRESS]').val(dtl.VLUN_PLC_ADDRESS);
			$('#mFrm input[name=VLUN_PLC_REPR]').val(dtl.VLUN_PLC_REPR);
			$('#mFrm input[name=VLUN_PLC_TEL_NO]').val(dtl.VLUN_PLC_TEL_NO);
			$('#mFrm input[name=PLC_MNGR_NM]').val(dtl.PLC_MNGR_NM);
			$('#mFrm input[name=PLC_MNGR_TEL_NO]').val(dtl.PLC_MNGR_TEL_NO);
			$('#mFrm input[name=PLC_MNGR_EMAIL]').val(dtl.PLC_MNGR_EMAIL);
			$('#mFrm input[name=PLC_MNGR_CP_NO]').val(dtl.PLC_MNGR_CP_NO);
			$("#mFrm input:radio[name=USE_YN][value='"+dtl.USE_YN+"']").prop('checked',true);
			$("#mFrm input:radio[name=VLUN_PLC_DV][value='"+dtl.VLUN_PLC_DV+"']").prop('checked',true);
			$('#mFrm input[name=MAIN_ACT_AREA]').val(dtl.MAIN_ACT_AREA);
			$('#mFrm input[name=MAIN_TGT]').val(dtl.MAIN_TGT);
			$("#UPDT_DT").text(dtl.UPDT_DT);
		
		}
			
	}
	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>공익복무처 관리</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/account/VlunPlaceSelect.kspo">
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
			                <td class="t-title">사용유무</td>
			                <td>
			                    <ul class="com-radio-list">
			                        <li>
			                            <input id="radio01" type="radio" value="" name="USE_YN" <c:if test="${param.USE_YN eq '' or param.USE_YN eq null}">checked="checked"</c:if>>
			                            <label for="radio01">전체</label>
			                        </li>
			                        <li>
			                            <input id="radio02" type="radio" value="Y" name="USE_YN" <c:if test="${param.USE_YN eq 'Y'}">checked="checked"</c:if>>
			                            <label for="radio02">사용</label>
			                        </li>
			                        <li>
			                            <input id="radio03" type="radio" value="N" name="USE_YN" <c:if test="${param.USE_YN eq 'N'}">checked="checked"</c:if>>
			                            <label for="radio03">정지</label>
			                        </li>
			                    </ul>
			                </td>
			                <td class="t-title">키워드</td>
			                <td>
			                	<ul class="com-radio-list">
			                        <li>
			                            <select id="keykind" name="keykind" class="smal">
			                            	<option value="" <c:if test="${param.keykind eq '' or param.keykind eq null}">selected="selected"</c:if>>전체</option>
											<option value="VLUN_PLC_NM" <c:if test="${param.keykind eq 'VLUN_PLC_NM'}">selected="selected"</c:if>>공익복무처명</option>
											<option value="PLC_MNGR_NM" <c:if test="${param.keykind eq 'PLC_MNGR_NM'}">selected="selected"</c:if>>담당자이름</option>
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
		    	<button class="btn red rmvcrr" type="button"  onclick="addPopOpen();">신규</button>
		        <button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
		    </div>
		</div>
		
		</form>
		
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:10%">
		            <col style="width:auto">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>공익복무처명</th>
		                <th>담당자</th>
		                <th>연락처</th>
		                <th>이메일</th>
		                <th>등록자</th>
		                <th>등록일자</th>
		                <th>사용유무</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<c:choose>
						<c:when test="${not empty vlunPlaceList}">
							<c:forEach items="${vlunPlaceList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td><a href="javascript:fn_Detail('${list.VLUN_PLC_SN}');" class="tit">${list.VLUN_PLC_NM}</a></td>
					                <td>${list.PLC_MNGR_NM}</td>
					                <td>${list.PLC_MNGR_TEL_NO}</td>
					                <td>${list.PLC_MNGR_EMAIL}</td>
					                <td>${list.UPDR_NM}</td>
					                <td>${list.UPDT_DT}</td>
					                <td>
					                	<c:if test="${list.USE_YN eq 'Y'}">사용</c:if>
					                	<c:if test="${list.USE_YN eq 'N'}">정지</c:if>
					                </td>
					            </tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
				            <tr>
				                <td colspan="8" class="center">등록된 게시물이 없습니다.</td>
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
<form id="mFrm" name="mFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="VLUN_PLC_SN" value="">
	<div class="cpt-popup reg03 vlunPlace"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            공익복무처 관리
	            <button class="pop-close" onclick="addPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="com-h3 add">공익복무처 정보</div>
	
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
	                            <td class="t-title">단체명 <span class="t-red">*</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="VLUN_PLC_NM"></td>
	                            <td class="t-title">구분</td>
	                            <td>
	                                <ul class="com-radio-list">
	                                    <li>
	                                        <input id="P01" type="radio" value="P01" name="VLUN_PLC_DV">
	                                        <label for="P01">국내</label>
	                                    </li>
	                                    <li>
	                                        <input id="P02" type="radio" value="P02" name="VLUN_PLC_DV">
	                                        <label for="P02">국외</label>
	                                    </li>
	                                </ul>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">대표자</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="VLUN_PLC_REPR"></td>
	                            <td class="t-title">전화</td>
	                            <td class="input-td">
	                            	<input type="text" title="휴대전화 입력" name="VLUN_PLC_TEL_NO">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">주소 <span class="t-red">*</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="VLUN_PLC_ADDRESS"></td>
	                            <td class="t-title"></td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">담당자명</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="PLC_MNGR_NM"></td>
	                            <td class="t-title">전화</td>
	                            <td class="input-td">
	                                <input type="text" title="휴대전화 입력" name="PLC_MNGR_TEL_NO">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td">
	                                <div class="email-box">
	                                    <input type="text" name="PLC_MNGR_EMAIL">
	                                </div>
	                            </td>
	                            <td class="t-title">휴대폰</td>
	                             <td class="input-td">
	                                <input type="text" title="휴대전화 입력" name="PLC_MNGR_CP_NO">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">주요 활동분야</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MAIN_ACT_AREA"></td>
	                            <td class="t-title">주요 봉사대상</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MAIN_TGT"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">사용유무</td>
	                            <td>
	                                <ul class="com-radio-list">
	                                    <li>
	                                        <input id="radio11" type="radio" value="Y" name="USE_YN">
	                                        <label for="radio11">사용</label>
	                                    </li>
	                                    <li>
	                                        <input id="radio12" type="radio" value="N" name="USE_YN">
	                                        <label for="radio12">정지</label>
	                                    </li>
	                                </ul>
	                            </td>
	                            <td class="t-title">등록일자</td>
	                            <td class="input-td" id="UPDT_DT"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-btn-group put">
	                <div class="float-r">
	                    <button class="btn red rmvcrr" type="button" onclick="fn_save();">저장</button>
	                    <button class="btn navy rmvcrr userDv2" type="button" onclick="addPopClose();">닫기</button>
	                </div>
	            </div>
	            
	        </div>
	    </div>
	</div>
</form>
<!-- //팝업영역 -->