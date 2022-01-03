<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

//체육단체 관리 팝업 열기
	function addPopOpen(){
		$(".reg03.memorg").addClass("active")
		$("body").css("overflow", "hidden")
	}
	
	//체육단체 관리 팝업 닫기
	function addPopClose() {
		$("#mFrm input[name=MEMORG_SN]").val("");
		$("#mFrm input[name=MEMORG_NM]").val("");
		$("#mFrm input[name=MEMORG_ADDRESS]").val("");
		$("#mFrm input:radio[name=USE_YN][value='Y']").prop('checked',true);
		$('#mFrm input[name=MEMORG_REPR]').val("");
		$('#mFrm input[name=ORG_MNGR_NM]').val("");
		$('#mFrm input[name=MEMORG_TEL_NO]').val("");
		$('#mFrm input[name=ORG_MNGR_TEL_NO]').val("");
		$('#mFrm input[name=ORG_MNGR_EMAIL]').val("");
		$('#mFrm input[name=ORG_MNGR_CP_NO]').val("");
		$('#mFrm select[name=GAME_CD]').val("");
		$("#MEMORG_REG_DT").text("");
		
		$(".reg03.memorg").removeClass("active")
		$("body").css("overflow","auto")
	}
	
	//검색
	function fn_search(){
		fnPageLoad("/account/MemOrgSelect.kspo",$("#searchFrm").serialize());
	}
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/account/MemOrgSelectDownload.kspo");
		$("#searchFrm").submit();
	}
	
	//저장
	function fn_save() {
		if(fn_saveValid()){
			
			var saveUrl = "/account/updateMemOrgJs.kspo";
			if($("#mFrm input[name=MEMORG_SN]").val() == "" || $("#mFrm input[name=MEMORG_SN]").val() == null){
				saveUrl = "/account/insertMemOrgJs.kspo";
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
	
		if($("#mFrm input[name=MEMORG_NM]").val() == "" || $("#mFrm input[name=MEMORG_NM]").val() == null){
			fnAlert("체육 단체명을 입력하시기 바랍니다.");
			$("#mFrm input[name=MEMORG_NM]").focus();
			return ;
		}
		
		//이메일
		if($("#mFrm input[name=ORG_MNGR_EMAIL]").val() != ""){
			var valiEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;	
			if(!valiEmail.test($("#mFrm input[name=ORG_MNGR_EMAIL]").val())) {	
				fnFocAlert("올바른 이메일 형식이 아닙니다.", $("#mFrm input[name=ORG_MNGR_EMAIL]"));
				return false;
			}
		}
		

		//휴대폰
		if($("#mFrm input[name=ORG_MNGR_CP_NO]").val() != ""){
			var valiCpNo = /^[0-9]{3}[0-9]{3,4}[0-9]{4}$/;
			if(!valiCpNo.test($("#mFrm input[name=ORG_MNGR_CP_NO]").val())) {
				fnFocAlert("올바른 전화번호 형식이 아닙니다.", $("#mFrm input[name=ORG_MNGR_CP_NO]"));
				return false;
			}
		}
		
		return true;
	}
	
	//상세조회
	function fn_Detail(MEMORG_SN){
		
		var param = "memorgSn=" + MEMORG_SN;
		param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/account/selectMemOrgDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			
			addPopOpen();
			
			$("#mFrm input[name=MEMORG_SN]").val(dtl.MEMORG_SN);
			$("#mFrm input[name=MEMORG_NM]").val(dtl.MEMORG_NM);
			$("#mFrm input[name=MEMORG_ADDRESS]").val(dtl.MEMORG_ADDRESS);
			$("#mFrm input:radio[name=USE_YN][value='"+dtl.USE_YN+"']").prop('checked',true);
			$('#mFrm input[name=MEMORG_REPR]').val(dtl.MEMORG_REPR);
			$('#mFrm input[name=ORG_MNGR_NM]').val(dtl.ORG_MNGR_NM);
			$('#mFrm input[name=MEMORG_TEL_NO]').val(dtl.MEMORG_TEL_NO);
			$('#mFrm input[name=ORG_MNGR_TEL_NO]').val(dtl.ORG_MNGR_TEL_NO);
			$('#mFrm input[name=ORG_MNGR_EMAIL]').val(dtl.ORG_MNGR_EMAIL);
			$('#mFrm input[name=ORG_MNGR_CP_NO]').val(dtl.ORG_MNGR_CP_NO);
			$('#mFrm select[name=GAME_CD]').val(dtl.GAME_CD);
			$("#MEMORG_REG_DT").text(dtl.MEMORG_REG_DT);
		
		}
			
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>체육단체관리</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="searchFrm" name="searchFrm" action="${pageContext.request.contextPath}/account/MemOrgSelect.kspo">
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
												<option value="MEMORG_NM" <c:if test="${param.keykind eq 'MEMORG_NM'}">selected="selected"</c:if>>체육단체명</option>
												<option value="ORG_MNGR_NM" <c:if test="${param.keykind eq 'ORG_MNGR_NM'}">selected="selected"</c:if>>담당자명</option>
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
		    	<button class="btn red rmvcrr" type="button" onclick="addPopOpen();">신규</button>
		        <button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
		    </div>
		</div>
		</form>
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:50px">
		            <col style="width:auto">
		            <col style="width:10%">
		            <col style="width:13%">
		            <col style="width:20%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>체육단체명</th>
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
						<c:when test="${not empty memOrgList}">
							<c:forEach items="${memOrgList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td><a href="javascript:fn_Detail('${list.MEMORG_SN}');" class="tit">${list.MEMORG_NM}</a></td>
					                <td>${list.ORG_MNGR_NM}</td>
					                <td>${list.ORG_MNGR_CP_NO}</td>
					                <td>${list.ORG_MNGR_EMAIL}</td>
					                <td>${list.REGR_NM}</td>
					                <td>
					                	<fmt:parseDate var="MEMORG_REG_DT" value="${list.MEMORG_REG_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${MEMORG_REG_DT}" pattern="yyyy-MM-dd"/></td>
					               	<td>
					                	<c:if test="${list.USE_YN eq 'Y'}">사용</c:if>
					                	<c:if test="${list.USE_YN eq 'N'}">정지</c:if>
					                </td>
					            </tr>
		            		</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="8" class="blank">검색결과가 존재하지 않습니다.</td></tr>
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

<!-- 팝업영역 -->
<form id="mFrm" name="mFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="MEMORG_SN" value="">
	<div class="cpt-popup reg03 memorg"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            체육단체관리
	            <button class="pop-close" onclick="addPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="com-h3 add">체육단체정보</div>
	
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
	                            <td class="t-title">체육단체명</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MEMORG_NM"></td>
	                            <td class="t-title">종목</td>
	                            <td class="input-td">
	                               	<select class="tab-sel" title="종목 선택" name="GAME_CD">
										<c:forEach items="${gameNmList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.GAME_CD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
				                    </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">대표자</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MEMORG_REPR"></td>
	                            <td class="t-title">전화</td>
	                            <td class="input-td">
	                            	<input type="text" title="휴대전화 입력" name="MEMORG_TEL_NO" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">주소</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MEMORG_ADDRESS"></td>
	                            <td class="t-title"></td>
	                            <td class="input-td"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">담당자명</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="ORG_MNGR_NM"></td>
	                            <td class="t-title">전화</td>
	                            <td class="input-td">
	                            	<input type="text" title="휴대전화 입력" name="ORG_MNGR_TEL_NO" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td">
	                                <div class="email-box">
	                                    <input type="text" name="ORG_MNGR_EMAIL">
	                                </div>
	                            </td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td">
	                            	<input type="text" title="휴대전화 입력" name="ORG_MNGR_CP_NO" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
	                            </td>
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