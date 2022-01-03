<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
		
	//게시판 작성 취소
	function fn_cancel(){
		if(confirm("등록을 취소하고 목록으로 이동하시겠습니까?")){
			fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeList.kspo",$("#dFrm").serialize());
		}
	}
	
	//게시판 저장
	function noticeSave(){
		if(fn_saveValid()){
			if ($("#dFrm input:checkbox[name=CHK_NTCE_SETUP_YN]").is(":checked")) {
				$("#NTCE_SETUP_YN").val("Y");
			} else if($("#dFrm input:checkbox[name=CHK_NTCE_SETUP_YN]").is(":checked") == false){
				$("#NTCE_SETUP_YN").val("N");
			}
			if ($("#dFrm input:checkbox[name=CHK_MAIN_EXPSR_YN]").is(":checked")) {
				$("#MAIN_EXPSR_YN").val("Y");
			} else if($("#dFrm input:checkbox[name=CHK_MAIN_EXPSR_YN]").is(":checked") == false){
				$("#MAIN_EXPSR_YN").val("N");
			}
			if ($("#dFrm input:checkbox[name=CHK_SMS_YN]").is(":checked")) {
				$("#SMS_YN").val("Y");
			} else if($("#dFrm input:checkbox[name=CHK_SMS_YN]").is(":checked") == false){
				$("#SMS_YN").val("N");
			}

			var brdSn = $("#dFrm input[name=BRD_SN]").val();
			var brdDtlSn = $("#dFrm input[name=BRD_DTL_SN]").val();
			var saveUrl = $('#updateUrl').val();
			
			if (!brdSn) {
				saveUrl = $('#insertUrl').val();
			}
 			var form = $('#dFrm')[0]
			const sendingData = new FormData(form);
			
 			var $json = getJsonMultiData(saveUrl, "dFrm");
 			if($json.statusText == "OK"){
				fnPageLoad("${pageContext.request.contextPath}/notice/selectNoticeList.kspo",$("#dFrm").serialize());
 			}
		}
	}
	
	//게시판 validation
	function fn_saveValid(){
		
		//제목
		if (!$("#dFrm input[name=SUBJECT]").val()) {
			fnAlert("제목을 입력하시기 바랍니다.");
			$("#dFrm input[name=SUBJECT]").focus();
			return false;
		}

		//내용
		if (!$("#dFrm textarea[name=CONTENTS]").val()) {
			fnAlert("내용를 입력하시기 바랍니다.");
			$("#dFrm textarea[name=CONTENTS]").focus();
			return false;
		}
		
		if(fnGetByte($("#dFrm input[name=SUBJECT]").val())>200){
			var length = fnGetTxtLength(200);
			fnAlert("제목 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)");
			$("#dFrm input[name=SUBJECT]").focus();
			return false;
		}
		
		if($('#uploadBtn').val() != ""){
		    if($("input[name=file]").length != "0"){
				// 등록할 전체 파일 사이즈
			    var fileSize = document.getElementById("uploadBtn").files[0];
			    // 등록 가능한 총 파일 사이즈 MB
			    var maxUploadSize = 300*1024*1024;
			    
			    var browser= navigator.appName;
	
			    if(browser == "Microsoft Internet Explorer") {
			    	var oas = new ActiveObject("Scripting.FileSystemObject");
			    	fileSize = fileSize.size;
			    }else{
			    	fileSize = fileSize.size;
			    }
			    
			    if(fileSize > maxUploadSize) {
			    	fnAlert("첨부하신 파일사이즈는 " + fileSize + "입니다. 최대 300MB 이내로 등록가능합니다.");
			    	return false;
			    }
		    }
		}
	    
		return true;
	}
	
	//파일 다운로드
  	function fnDownloadFile(BRD_DTL_SN, BRD_ATCH_FILE_SN){
  		window.location = "${pageContext.request.contextPath}/file/downloadFile.kspo?BRD_DTL_SN=" + BRD_DTL_SN + "&BRD_ATCH_FILE_SN="+BRD_ATCH_FILE_SN+"&gMenuSn="+$("#frm input[name=gMenuSn]").val()+"&file="+"noticeFile";
  	}
	
	//첨부파일 삭제
    function fnDelFile(BRD_DTL_SN, BRD_ATCH_FILE_SN){
    	if(confirm("해당 첨부파일을 삭제하시겠습니까?")){
	    	var param = "BRD_DTL_SN=" + BRD_DTL_SN;
    		param += "&BRD_ATCH_FILE_SN="+BRD_ATCH_FILE_SN;
	    		param += "&gMenuSn=" + $("#dFrm input[name=gMenuSn]").val();
	    	var $json = getJsonData("post", "${pageContext.request.contextPath}/notice/deleteNoticeFileJs.kspo", param);
	    	if($json.statusText == "OK"){
	    		var trObj = "";
		    		trObj += "<td class='t-title'>첨부파일</td>";
		    		trObj += "<td colspan='4' class='adds input-td bdb-0'>";
		    		trObj += "<div class='fileBox'>";
		    		trObj += "<input type='text' class='fileName' readonly='readonly'>";
		    		trObj += "<label for='uploadBtn' class='btn_file btn navy addlist mrg-0 file-btn'>찾기</label>";
		    		trObj += "<input type='file' id='uploadBtn' name='file' class='uploadBtn'>";
		    		trObj += "</div>";
		    		trObj += "</td>";
	    		$("#trFile").html(trObj)
	    	}
    	}
    }
	
</script>
<div class="body-area">
	<!-- 타이틀 -->
	<div class="com-title-group">
		<h2>게시판</h2>
	</div>
	<!-- //타이틀 -->
	<form method="post" id="dFrm" name="dFrm" enctype="multipart/form-data">
		<input type="hidden" name="BRD_SN" value="${detail.BRD_SN}">	
		<input type="hidden" name="BRD_DTL_SN" value="${detail.BRD_DTL_SN}">	
		<input type="hidden" name="USER" value="${sessionScope.userMap.USER}">
		<input type="hidden" name="REGR_NM" value="${sessionScope.userMap.MNGR_NM}">
		<input type="hidden" name="NTCE_SETUP_YN" id="NTCE_SETUP_YN" value="${detail.NTCE_SETUP_YN}">
		<input type="hidden" name="MAIN_EXPSR_YN" id="MAIN_EXPSR_YN" value="${detail.MAIN_EXPSR_YN}">
		<input type="hidden" name="SMS_YN" id="SMS_YN" value="${detail.SMS_YN}">
		
		<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">

		<input type="hidden" name="updateUrl" id="updateUrl" value="${pageContext.request.contextPath}/notice/updateNoticeJs.kspo">
		<input type="hidden" name="insertUrl" id="insertUrl" value="${pageContext.request.contextPath}/notice/insertNoticeJs.kspo">


		<!-- 테이블 영역 -->
		<div class="com-table">
			<table class="table-board">
				<caption></caption>
				<colgroup>
					<col width="118px">
					<col width="auto">
					<col width="135px">
                    <col width="440px">
                    <col width="114px">
				</colgroup>
				<tbody>
					<tr>
					    <td class="t-title">제목</td>
					    <td colspan="4" class="input-td"><input type="text" class="ip-title" name="SUBJECT" value="${detail.SUBJECT}"></td>
					</tr>
					<tr>
					    <td class="t-title">SMS전송설정</td>
					    <td>
					    	<c:choose>
						    	<c:when test="${detail.BRD_DTL_SN eq '' or detail.BRD_DTL_SN eq null}">
									<ul class="com-check-list">
										<li>
											<input id="smsYn" type="checkbox" value="Y" name="CHK_SMS_YN" <c:if test='${detail.SMS_YN eq "Y"}'>checked</c:if>>
											<label for="smsYn">SMS전송</label>
										</li>
									</ul>
						    	</c:when>
						    	<c:otherwise>
						    		수정시엔 SMS 전송 선택을 할 수 없습니다.
						    	</c:otherwise>
					    	</c:choose>
						</td>
					</tr>
					<tr>
					    <td class="t-title">공지설정</td>
					    <td>
							<ul class="com-check-list">
								<li>
									<input id="chkNoticeYn" type="checkbox" value="Y" name="CHK_NTCE_SETUP_YN" <c:if test='${detail.NTCE_SETUP_YN eq "Y"}'>checked</c:if>>
									<label for="chkNoticeYn">최상단 고정 함</label>
								</li>
							</ul>
						</td>
						<td class="t-title">긴급 공지설정</td>
						<td colspan="2">
						    <ul class="com-check-list">
								<li>
									<input id="chkMainOpenYn" type="checkbox" value="Y" name="CHK_MAIN_EXPSR_YN" <c:if test='${detail.MAIN_EXPSR_YN eq "Y"}'>checked</c:if>>
									<label for="chkMainOpenYn">메인 상단 노출함</label>
								</li>
							</ul>
						</td>
					</tr>
					<tr id="trFile">
					    <td class="t-title">첨부파일</td>
						<c:choose>
							<c:when test="${empty file}">
							    <td colspan="4" class="adds input-td bdb-0">
									<div class="fileBox">
										<input type="text" class="fileName" readonly="readonly">
										<label for="uploadBtn" class="btn_file btn navy addlist mrg-0 file-btn">찾기</label>
										<input type="file" name="file" id="uploadBtn" class="uploadBtn">
									</div>
								</td>
							</c:when>
							<c:otherwise>
									<td colspan="4" class="add-remove">
										<c:if test="${not empty file}">
											<c:forEach items="${file}" var="li">
											<div class="added">
												<a href="javascript:fnDownloadFile('${li.BRD_DTL_SN}','${li.BRD_ATCH_FILE_SN}')">${li.ATCH_FILE_ORG_NM}</a>
											</div>
											<a href="javascript:fnDelFile('${li.BRD_DTL_SN}','${li.BRD_ATCH_FILE_SN}')">첨부파일 삭제</a>		
											</c:forEach>
										</c:if>
									</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<tr>
					    <td colspan="5" class="input-td">
					        <textarea rows="20" name="CONTENTS">${detail.CONTENTS}</textarea>
					    </td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
	<!-- //테이블 영역 -->

	<!-- 버튼 영역 -->
	<div class="com-btn-group center">
		<button class="btn navy write" type="button" onclick="javascript:fn_cancel();">취소</button>
		<c:choose>
			<c:when test="${empty detail.brdSn}">
				<button class="btn red write" type="button" onclick="javascript:noticeSave();">등록</button>
			</c:when>
			<c:otherwise>
				<button class="btn red write" type="button" onclick="javascript:noticeSave();">수정</button>
						
			</c:otherwise>
		</c:choose>
	</div>
	<!-- //버튼 영역 -->
</div>