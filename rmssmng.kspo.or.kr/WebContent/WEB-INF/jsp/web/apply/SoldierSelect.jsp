<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	
		//datepicker start
		$("#datepicker, #datepicker1, #datepicker3, #datepicker4").datepicker({
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
		
		$(document).on("change","#datepicker4",function(){
			$("#datepicker4").datepicker('option','maxDate',0);
		});
		//datepicker end
		
		//체육요원 편입신청 신규 팝업 오픈
		$(document).on("click","button[name=addBtn]",function(){
			
			var param = "gMenuSn=" + $("#frm input[name=gMenuSn]").val();
			var $json = getJsonData("post", "/user/selectloginUserDtlList.kspo", param);
				
			var dtl = $json.responseJSON.loginUserDtl;
			
			//로그인한 담당자 정보 불러오기
			$("#dFrm input[name=MEMORG_SN]").val(dtl.MEMORG_SN);
			$("#dFrm input[name=MEMORG_TEL_NO]").val(dtl.MEMORG_TEL_NO);
			$("#dFrm .appl.memorgNm").text(dtl.MEMORG_NM);
			$("#dFrm .appl.memOrgTel").text(dtl.MEMORG_TEL_NO);
				
			addPopOpen();
		});
		
	});

	//주소검색
	function jusoSearch(){
		window.open("/apply/jusoSearch.kspo?gMenuSn="+$("#frm input[name=gMenuSn]").val(), "pop", "width=570, height=420, scrollbars=yes, resizable=yes");
	}
	
	// 주소검색을 수행할 팝업 페이지를 호출합니다.
	fnAddrSearch = function(){
		// 호출된 페이지에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		var pop = window.open("/front/juso/jusoPopup.do", "pop", "width=570, height=420, scrollbars=yes, resizable=yes"); 
	};

	// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
	callbackAddress = function(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo){
		$("#ZIP").val(zipNo);
		$("#ADDR").val(roadAddrPart1+ " "+roadAddrPart2+ " " + addrDetail);
			
	}; 
	

	//검색
	function fn_search(){
		
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		
		fnPageLoad("/apply/SoldierSelect.kspo",$("#frm").serialize());
		
	}

	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/apply/SoldierSelectDownload.kspo");
		$("#frm").submit();
	}
	
	//체육요원 편입신청 신규 팝업 열기
	function addPopOpen(){
		$("#delete1").hide();
		$(".add").addClass("active")
		$("body").css("overflow", "hidden")
	}


	//체육요원 편입신청 신규 팝업 닫기
	function addPopClose() {
		fn_search();	
		$(".add").removeClass("active")
		$("body").css("overflow","auto")
	}

	//체육요원 편입신청 상세 팝업 열기
	function selectPopOpen(){
		$(".select").addClass("active")
		$("body").css("overflow", "hidden")
	}

	//체육요원 편입신청 상세 팝업 닫기
	function selectPopClose() {
		fn_search();
		$(".select").removeClass("active")
		$("body").css("overflow","auto")
	}

	//저장
	function fn_save(APPL_STS){
	
		if(fn_saveValid()){
		
			var saveUrl = "/apply/updateSoldierSelectJs.kspo";
			if($("#dFrm input[name=APPL_STS]").val() == "" || $("#dFrm input[name=APPL_STS]").val() == null || $("#dFrm input[name=APPL_STS]").val() == "KN"){
				saveUrl = "/apply/insertSoldierSelectJs.kspo";
			}
		
			$("#dFrm input[name=APPL_STS]").val(APPL_STS);
		
			var APPL_STS = $("#dFrm input[name=APPL_STS]").val();
			
			var $json = getJsonMultiData( saveUrl, "dFrm");
			
			if($json.statusText == "OK"){
					
				fnAlert("저장되었습니다.");
				fn_search();	
				
			}
		}
	
	}

	//벨리데이션 체크
	function fn_saveValid(){
	
		//이름
		if($("#dFrm input[name=APPL_NM]").val() == "" || $("#dFrm input[name=APPL_NM]").val() == null){
			fnFocAlert("이름을 입력하시기 바랍니다.", $("#dFrm input[name=APPL_NM]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=APPL_NM]").val())>50){
				var length = fnGetTxtLength(50);
				fnFocAlert("이름 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=APPL_NM]"));
				return false;
			}
		}
		
		//생년월일
		if($("#dFrm input[name=BRTH_DT]").val() == "" || $("#dFrm input[name=BRTH_DT]").val() == null){
			fnFocAlert("생년월일을 입력하시기 바랍니다.", $("#dFrm input[name=BRTH_DT]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=BRTH_DT]").val())>8){
				var length = fnGetTxtLength(8);
				fnFocAlert("생년월일 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=BRTH_DT]"));
				return false;
			}
		}
		
		//주소
		if($("#dFrm input[name=ADDR]").val() == "" || $("#dFrm input[name=ADDR]").val() == null){
			fnFocAlert("주소을 입력하시기 바랍니다.", $("#dFrm input[name=ADDR]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=ADDR]").val())>500){
				var length = fnGetTxtLength(500);
				fnFocAlert("주소 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=ADDR]"));
				return false;
			}
		}
		
		//이메일
		if($("#dFrm input[name=EMAIL]").val() == "" || $("#dFrm input[name=EMAIL]").val() == null){
			fnFocAlert("이메일을 입력하시기 바랍니다.", $("#dFrm input[name=EMAIL]"));
			return ;
		}else{
			var valiEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;	
			if(!valiEmail.test($("#dFrm input[name=EMAIL]").val())) {	
				fnFocAlert("올바른 이메일 형식이 아닙니다.", $("#dFrm input[name=EMAIL]"));
				return false;
			}
			if(fnGetByte($("#dFrm input[name=EMAIL]").val())>128){
				var length = fnGetTxtLength(128);
				fnFocAlert("이메일 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=EMAIL]"));
				return false;
			}
		}
		
		//휴대폰
		if($("#dFrm input[name=CP_NO]").val() == "" || $("#dFrm input[name=CP_NO]").val() == null ){
			fnFocAlert("휴대폰을 입력하시기 바랍니다.", $("#dFrm input[name=CP_NO]"));
			return ;
		}
		
		//대회명
		if($("#dFrm input[name=CONT_NM]").val() == "" || $("#dFrm input[name=CONT_NM]").val() == null){
			fnFocAlert("대회명을 입력하시기 바랍니다.", $("#dFrm input[name=CONT_NM]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=CONT_NM]").val())>200){
				var length = fnGetTxtLength(200);
				fnFocAlert("대회명 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=CONT_NM]"));
				return false;
			}
		}
		
		//세부종목
		if(fnGetByte($("#dFrm input[name=GAME_DTL]").val())>200){
			var length = fnGetTxtLength(200);
			fnFocAlert("세부종목 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=GAME_DTL]"));
			return false;
		}
		
		//종목
		if($("#dFrm select[name=GAME_CD]").val() == "" || $("#dFrm select[name=GAME_CD]").val() == null){
			fnFocAlert("종목을 입력하시기 바랍니다.", $("#dFrm select[name=GAME_CD]"));
			return ;
		}
		
		//등위
		if($("#dFrm select[name=RANK]").val() == "" || $("#dFrm select[name=RANK]").val() == null){
			fnFocAlert("등위을 입력하시기 바랍니다.", $("#dFrm select[name=RANK]"));
			return ;
		}
		
		var now = new Date();
		
		var year = now.getFullYear();
		var month = (now.getMonth()+1); //월은 +1 해줘야됨
		var date = now.getDate();
		
		var day = year+""+month+""+date; //오늘날짜 
		
		//입상일
		if($("#dFrm input[name=AWRD_DT]").val() == "" || $("#dFrm input[name=AWRD_DT]").val() == null){
			fnFocAlert("입상일을 입력하시기 바랍니다.", $("#dFrm input[name=AWRD_DT]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=AWRD_DT]").val())>8){
				var length = fnGetTxtLength(8);
				fnFocAlert("세부종목 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=AWRD_DT]"));
				return false;
			}
			
			if($("#dFrm input[name=AWRD_DT]").val() > day){
				fnFocAlert("입상일 날짜는 미래일자를 선택할 수 없습니다.", $("#dFrm input[name=AWRD_DT]"));
				return ;
			}
		}
		
		//소속팀
		if($("#dFrm input[name=TEAM_NM]").val() == "" || $("#dFrm input[name=TEAM_NM]").val() == null){
			fnFocAlert("소속팀(근무지)을 입력하시기 바랍니다.", $("#dFrm input[name=TEAM_NM]"));
			return ;
		}else{
			if(fnGetByte($("#dFrm input[name=TEAM_NM]").val())>100){
				var length = fnGetTxtLength(100);
				fnFocAlert("소속팀(근무지) 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=TEAM_NM]"));
				return false;
			}
		}
		
		//역종
		if(fnGetByte($("#dFrm input[name=MLTR_DV]").val())>200){
			var length = fnGetTxtLength(200);
			fnFocAlert("역종 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=MLTR_DV]"));
			return false;
		}

		//소속팀국가
		if(fnGetByte($("#dFrm input[name=TM_NTN]").val())>100){
			var length = fnGetTxtLength(100);
			fnFocAlert("역종 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=TM_NTN]"));
			return;
		}

		//첨부파일
		if($("#dFrm input[name=file]").val() == "" || $("#dFrm input[name=file]").val() == null){
			if($("#dFrm input[name=fileChek]").length < 1){
				fnAlert("첨부파일 필요항목을 확인하고 등록해주세요.");
				return;
			}
		}
		
		return true;
	}

	//상세조회
	function fn_Detail(APPL_SN,APPL_STS){
		var param = "APPL_SN=" + APPL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/apply/selectSoldierSelectDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			var acptDetail = $json.responseJSON.acptDetail;
			var fileList = $json.responseJSON.fileList;
			
			var grpSn = "${sessionScope.userMap.GRP_SN}";
			
			if(dtl.APPL_STS == 'TP' && grpSn == '2'){ //임시저장, 가맹단체일경우
				addPopOpen();
				$("#dFrm input[name=APPL_STS]").val(dtl.APPL_STS);
				$("#dFrm input[name=APPL_NM]").val(dtl.APPL_NM);
				$("#dFrm input[name=APPL_SN]").val(dtl.APPL_SN);
				$("#dFrm input[name=BRTH_DT]").val(dtl.BRTH_DT);
				$("#dFrm input[name=ADDR]").val(dtl.ADDR);
				$("#dFrm input[name=EMAIL]").val(dtl.EMAIL);
				$("#dFrm input[name=CP_NO]").val(dtl.CP_NO);
				$("#dFrm input[name=CONT_NM]").val(dtl.CONT_NM);
				$("#dFrm input[name=RANK]").val(dtl.RANK);
				$("#dFrm input[name=AWRD_DT]").val(dtl.AWRD_DT);
				$("#dFrm input[name=ATCH_FILE_ID1]").val(dtl.ATCH_FILE_ID1);
				$("#dFrm input[name=TEAM_NM]").val(dtl.TEAM_NM);
				$("#dFrm input[name=TM_NTN]").val(dtl.TM_NTN);
				$("#dFrm input[name=INSPT_YR]").val(dtl.INSPT_YR);
				$("#dFrm input[name=INSPT_MLTR_ADMN]").val(dtl.INSPT_MLTR_ADMN);
				$("#dFrm input[name=MLTR_DV]").val(dtl.MLTR_DV);
				$("#dFrm input[name=MEMORG_SN]").val(dtl.MEMORG_SN);
				$("#dFrm .appl.memorgNm").text(dtl.MEMORG_NM);
				$("#dFrm .appl.memOrgTel").text(dtl.MEMORG_TEL_NO);
				$("#dFrm input[name=GAME_DTL]").val(dtl.GAME_DTL);
				$("#dFrm select[name=INSPT_MLTR_ADMN]").val(dtl.INSPT_MLTR_ADMN);
				$("#dFrm select[name=INSPT_YR]").val(dtl.INSPT_YR);
				$("#dFrm select[name=FIELD]").val(dtl.FIELD);
				$("#dFrm select[name=GAME_CD]").val(dtl.GAME_CD);
				$("#dFrm select[name=RANK]").val(dtl.RANK);
				$("#dFrm .uName").text("Last Update. "+dtl.UPDR_NM+" / "+dtl.UPDT_DT);
				$("#dFrm .t-blue").text(dtl.APPL_STS_NM);
				$("#dFrm #MLTR_ID").text(dtl.MLTR_ID);
				
				//첨부파일
				var fileObj = "";
				if(fileList.length > 0){
					for(var i=0;i<fileList.length;i++) {
						fileObj += '<tr>';
						fileObj += '	<td colspan="3" class="adds bdr-0 input-td">';
						fileObj += '		<input type="hidden" name="fileChek" id="fileChek" value="'+fileList[i].FILE_SN+'">';
						fileObj += '		<a href="javascript:fnDownloadFile('+fileList[i].FILE_SN+')"><span class="file-name">'+ fileList[i].FILE_ORGIN_NM +'</span></a>';
						fileObj += "		<button class='file-del' onclick='fn_fileDel(" + fileList[i].FILE_SN + ", this)'> 삭제</button>";
						fileObj += '	</td>';
						fileObj += '	<td class="bdl-0 pdr-0 ft-0">';
						fileObj += '	</td>';
						fileObj += '</tr>';
					}
				
				}
				
				$("#fileTbody").before(fileObj);
				
				$("#delete1").show(); //삭제버튼 보이게
				
				if(dtl.APPL_STS == 'KN'){ //접수취소, 반려일경우 
					 $(".applReason").show();
					 $(".t-title.name").text("공단반려사유");
					 $(".applReasons").text(acptDetail.APPL_REASON);
					$("#delete1").hide(); //삭제버튼 보이게
				}
				
				
			}else{ //신청, 접수, 승인거부, 승인완료 시 
				
				$(".btn.red.type01.receipt").show(); //접수
				$(".btn.red.type01.userDv1").show(); //문체부승인버튼들
				
				$('#sFrm input[name=ACPT_REASON]').attr('readonly', false);
				$('#sFrm input[name=DSPTH_REASON]').attr('readonly', false);
				$('#sFrm input[name=RSVT_DT]').attr('readonly', false);
				$('#sFrm input[name=CMPL_REASON]').attr('readonly', false);
				$('#sFrm select[name=SRV_INSTT_CODE]').attr('disabled', false);
				$('#sFrm select[name=CTRL_MMA_CD]').attr('disabled', false);
				$('#sFrm select[name=SRV_FIELD]').attr('disabled', false);
				
				$("#sFrm input[name=APPL_SN]").val(dtl.APPL_SN);
				$("#sFrm input[name=MLTR_ID]").val(dtl.MLTR_ID);
				$("#sFrm input[name=PROC_STS]").val(dtl.PROC_STS);
				$("#sFrm input[name=APPL_STS]").val(dtl.APPL_STS);
				$("#sFrm input[name=MEMORG_SN]").val(dtl.MEMORG_SN);
				
				$("#sFrm #MLTR_ID").text(dtl.MLTR_ID);
				$("#sFrm #APPL_NM").html(dtl.APPL_NM);
				$("#sFrm #BRTH_DT").html(dtl.S_BRTH_DT);
				$("#sFrm #ADDR").html(dtl.ADDR);
				$("#sFrm #EMAIL").html(dtl.EMAIL);
				$("#sFrm #CP_NO").html(dtl.S_CP_NO);
				$("#sFrm #CONT_NM").html(dtl.CONT_NM);
				$("#sFrm #RANK").html(dtl.RANK_NM);
				$("#sFrm #AWRD_DT").html(dtl.S_AWRD_DT);
				$("#sFrm #TEAM_NM").html(dtl.TEAM_NM);
				$("#sFrm #TM_NTN").html(dtl.TM_NTN);
				$("#sFrm #INSPT_YR").html(dtl.INSPT_YR);
				$("#sFrm #MLTR_DV").html(dtl.MLTR_DV);
				$("#sFrm #MEMORG_SN").html(dtl.MEMORG_SN);
				$("#sFrm #GAME_DTL").html(dtl.GAME_DTL);
				$("#sFrm #INSPT_MLTR_ADMN").html(dtl.INSPT_MLTR_ADMN_NM);
				$("#sFrm #INSPT_YR").html(dtl.INSPT_YR);
				$("#sFrm #FIELD").html(dtl.FIELD_NM);
				$("#sFrm #GAME_CD").html(dtl.GAME_NM);

				$("#sFrm .appl.memorgNm").text(dtl.MEMORG_NM);
				$("#sFrm .appl.memOrgTel").text(dtl.MEMORG_TEL_NO);
				
				$("#sFrm .uName").text("Last Update. "+dtl.UPDR_NM+" / "+dtl.UPDT_DT);
				$("#sFrm .t-blue").text(dtl.APPL_STS_NM);
				$("#sFrm .appl.result").text(dtl.APPL_STS_NM);

				//첨부파일
				var fileObj = "";
				if(fileList.length > 0){
					for(var i=0;i<fileList.length;i++) {
						fileObj += '<tr>';
						fileObj += '<td colspan="3" class="adds bdr-0 input-td">';
						fileObj += '<a href="javascript:fnDownloadFile('+fileList[i].FILE_SN+')"><span class="file-name">'+ fileList[i].FILE_ORGIN_NM +'</span></a>';
						fileObj += '</td>';
						fileObj += '<td class="bdl-0 pdr-0 ft-0">';
						fileObj += '</td>';
						fileObj += '</tr>';
					}
				
				}
				
				$("#sFileTbody").before(fileObj);
				
				
				if(dtl.MLTR_ID != ""){
					
					$("#sFrm #ACPT_UPD_DTM").html(acptDetail.ACPT_UPD_DTM);
					$("#sFrm input[name=ADDM_DT]").val(acptDetail.ADDM_DT);
					$("#sFrm input[name=RSVT_DT]").val(dtl.RSVT_DT);
					$("#sFrm select[name=SRV_INSTT_CODE]").val(acptDetail.SRV_INSTT_CODE);
					$("#sFrm select[name=SRV_FIELD]").val(acptDetail.SRV_FIELD);
					$("#sFrm select[name=CTRL_MMA_CD]").val(acptDetail.CTRL_MMA_CD);
					$("#sFrm input[name=DSPTH_REASON]").val(acptDetail.DSPTH_REASON);
					$("#sFrm input[name=ATCH_FILE_ID]").val(acptDetail.ATCH_FILE_ID);
					$("#sFrm textarea[name=CMPL_REASON]").val(acptDetail.CMPL_REASON);
					$("#sFrm textarea[name=ACPT_REASON]").val(acptDetail.APPL_REASON);
					
					
					//첨부파일
					var acptFileObj = "";
						acptFileObj += '<td class="t-title">첨부파일</td>';
					
					if(dtl.APPL_STS == "MY" || dtl.APPL_STS == "MN" || dtl.APPL_STS == 'KN' || grpSn == '2'){
						acptFileObj += '<td class="input-td" colspan="3"><a href="javascript:fnDownloadFile('+acptDetail.ATCH_FILE_ID+')"><span class="file-name">'+ acptDetail.ATCH_FILE_NM +'</span></a></td>';
					
					}else{
						
						acptFileObj += '<td colspan="3" class="input-td">';
						acptFileObj += '<div class="fileBox">';
						acptFileObj += '<input type="text" class="fileName" readonly="readonly">';
						acptFileObj += '<input type="file" name="file" id="file01" class="file-table uploadBtn">';
						acptFileObj += '<label for="file01" class="btn red rmvcrr file-btn">파일선택</label>';
						acptFileObj += '</div>';
						acptFileObj += '</td>';
							
					}
					$("#acptFile").html(acptFileObj);
				
				}

				if(dtl.APPL_STS != "AP"){ //처리상태가 신청이 아니고 체육단체 로그인이 아닐시
					 $(".btn.red.rmvcrr.delete").hide();
					
				}
				
				if(dtl.APPL_STS == "AP"){ //처리상태 : 편입신청
					 $(".btn.red.type01.userDv1").hide();
					 $(".com-h3.add.acpt").hide();
					 $(".com-table.acpt").hide();
				}else if(dtl.APPL_STS == "KY"){ //처리상태 : 공단접수
					 $(".btn.red.type01.receipt").hide();
					 $(".btn.red.type01.receipt").hide();
					$('#sFrm textarea[name=ACPT_REASON]').attr('readonly', true);

				}
				if(dtl.APPL_STS == "MY" || dtl.APPL_STS == "MN" || dtl.APPL_STS == 'KN'){ //문체부 승인 및 미승인, 공단접수취소, 공단반려시 모든 버튼 비활성화
					$(".btn.red.type01.receipt").hide();
					$(".btn.red.type01.userDv1").hide();
					$('#sFrm textarea[name=ACPT_REASON]').attr('readonly', true);
					$('#sFrm input[name=DSPTH_REASON]').attr('readonly', true);
					$('#sFrm input[name=RSVT_DT]').attr('readonly', true);
					$('#sFrm textarea[name=CMPL_REASON]').attr('readonly', true);
					$('#sFrm select[name=SRV_INSTT_CODE]').attr('disabled', true);
					$('#sFrm select[name=CTRL_MMA_CD]').attr('disabled', true);
					$('#sFrm select[name=SRV_FIELD]').attr('disabled', true);
				}
				
				if(grpSn == '1' && dtl.APPL_STS == "KY"){
					$("#datepicker8, #datepicker9").datepicker({
						showOtherMonths: true,
						selectOhterMonth: true
					});
				}
				
				if(grpSn == '2'){ //가맹단체일경우
					$('#sFrm textarea[name=ACPT_REASON]').attr('readonly', true);
					$('#sFrm input[name=DSPTH_REASON]').attr('readonly', true);
					$('#sFrm input[name=RSVT_DT]').attr('readonly', true);
					$('#sFrm textarea[name=CMPL_REASON]').attr('readonly', true);
					$('#sFrm select[name=SRV_INSTT_CODE]').attr('disabled', true);
					$('#sFrm select[name=CTRL_MMA_CD]').attr('disabled', true);
					$('#sFrm select[name=SRV_FIELD]').attr('disabled', true);
				}
				
				selectPopOpen();
			}
			
		}
	}
	
	//임시저장 혹은 신청일시 삭제
	function fn_delete(){
		
		var applSn = $("#dFrm input[name=APPL_SN]").val();
		
		if(applSn == null || applSn == ""){
			applSn = $("#sFrm input[name=APPL_SN]").val();
		}
		var param = "APPL_SN=" + applSn;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/apply/deleteSoldierSelectJs.kspo", param);
		
		if($json.statusText == "OK"){
			fnAlert("삭제되었습니다.");
			fn_search();
		}
		
	}

	//접수처리
	function fn_receipt(){
		$("#sFrm input[name=APPL_STS]").val("KY");
		$("#sFrm input[name=PROC_STS]").val("AW");
		var saveUrl = "/apply/updateSoldierSelectReceiptJs.kspo";
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		
		if($json.statusText == "OK"){
			fnAlert("접수처리되었습니다.");
			fn_search();	
		}
	}

	//접수반려
	function fn_receCompanion(){
		$("#sFrm input[name=APPL_STS]").val("KN");
		$("#sFrm input[name=PROC_STS]").val("AC");
		
		if($("#sFrm textarea[name=ACPT_REASON]").val() == "" || $("#sFrm textarea[name=ACPT_REASON]").val() == null ){
			fnFocAlert("사유를 입력하시기 바랍니다.", $("#sFrm textarea[name=ACPT_REASON]"));
			return;
		}
		
		var saveUrl = "/apply/updateSoldierSelectReceiptJs.kspo";
		
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("접수 반려되었습니다.");
			fn_search();	
		}
	
	}

	//문체부승인
	function fn_acptOk(){
		
		if($("#sFrm input[name=MLTR_ID]").val() == "" || $("#sFrm input[name=MLTR_ID]").val() == null){
			fnAlert("접수처리해야 승인이 가능합니다.");
			return;	
		}
	
		//편입일자
		if($("#sFrm input[name=ADDM_DT]").val() == "" || $("#sFrm input[name=ADDM_DT]").val() == null ){
			fnFocAlert("편입일자를 입력하시기 바랍니다.", $("#sFrm input[name=ADDM_DT]"));
			return;
		}
	
		//복무만료 예정일자
		if($("#sFrm input[name=RSVT_DT]").val() == "" || $("#sFrm input[name=RSVT_DT]").val() == null ){
			fnFocAlert("복무만료 예정일자를 입력하시기 바랍니다.", $("#sFrm input[name=RSVT_DT]"));
			return;
		}
	
		//복무기관
		if($("#sFrm select[name=SRV_INSTT_CODE]").val() == "" || $("#sFrm select[name=SRV_INSTT_CODE]").val() == null ){
			fnFocAlert("복무기관를 입력하시기 바랍니다.", $("#sFrm select[name=SRV_INSTT_CODE]"));
			return;
		}
	
		//관할병무청
		if($("#sFrm select[name=CTRL_MMA_CD]").val() == "" || $("#sFrm select[name=CTRL_MMA_CD]").val() == null ){
			fnFocAlert("관할병무청를 입력하시기 바랍니다.", $("#sFrm select[name=CTRL_MMA_CD]"));
			return;
		}
	
		$("#sFrm input[name=APPL_STS]").val("MY");
		$("#sFrm input[name=PROC_STS]").val("AG");
		
		var saveUrl = "/apply/updateSoldierSelectApprovalJs.kspo";
		var $json = getJsonMultiData( saveUrl, "sFrm");
		if($json.statusText == "OK"){
			fnAlert("문체부(병무청) 승인되었습니다.");
			fn_search();	
		}
	
	}

	//문체부미승인
	function fn_acptNotOk(){
		
		if($("#sFrm input[name=MLTR_ID]").val() == "" || $("#sFrm input[name=MLTR_ID]").val() == null){
			fnAlert("접수처리해야 미승인이 가능합니다.");
			return;	
		}
		
		//편입일자
		if($("#sFrm input[name=ADDM_DT]").val() == "" || $("#sFrm input[name=ADDM_DT]").val() == null ){
			fnFocAlert("편입일자를 입력하시기 바랍니다.", $("#sFrm input[name=ADDM_DT]"));
			return;
		}
	
		//복무만료 예정일자
		if($("#sFrm input[name=RSVT_DT]").val() == "" || $("#sFrm input[name=RSVT_DT]").val() == null ){
			fnFocAlert("복무만료 예정일자를 입력하시기 바랍니다.", $("#sFrm input[name=RSVT_DT]"));
			return;
		}
	
		//복무기관
		if($("#sFrm select[name=SRV_INSTT_CODE]").val() == "" || $("#sFrm select[name=SRV_INSTT_CODE]").val() == null ){
			fnFocAlert("복무기관를 입력하시기 바랍니다.", $("#sFrm select[name=SRV_INSTT_CODE]"));
			return;
		}
		
		//관할병무청
		if($("#sFrm select[CTRL_MMA_CD]").val() == "" || $("#sFrm select[name=CTRL_MMA_CD]").val() == null ){
			fnFocAlert("관할병무청를 입력하시기 바랍니다.", $("#sFrm select[name=CTRL_MMA_CD]"));
			return;
		}
	
		$("#sFrm input[name=APPL_STS]").val("MN");
		$("#sFrm input[name=PROC_STS]").val("AW");
		
		var saveUrl = "/apply/updateSoldierSelectApprovalJs.kspo";
		var $json = getJsonMultiData( saveUrl, "sFrm");
		if($json.statusText == "OK"){
			fnAlert("문체부(병무청) 미승인 되었습니다.");
			fn_search();	
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
		addFileObj += '<label for="uploadBtn'+fileCnt+'" class="btn_file btn red addlist mrg-0 file-btn">파일첨부</label>';
		addFileObj += '<input type="file" name="file" id="uploadBtn'+fileCnt+'" class="uploadBtn2">';
		addFileObj += '</div>';
		addFileObj += '</td>';
		addFileObj += '<td class="bdl-0 pdr-0 ft-0">';
		addFileObj += '<button class="btn lightgrey removefile" type="button" onclick="fn_removeFile(this);"></button>';
		addFileObj += '</td>';
		addFileObj += '</tr>';
		
		return addFileObj;
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
	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>체육요원 편입신청</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/apply/SoldierSelect.kspo">
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
			                <td class="t-title">등록일</td>
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
			                <td class="t-title">처리상태</td>
			                <td>
			                    <select id="srchApplSts" name="srchApplSts" class="smal">
			                    	<option value="" <c:if test="${param.srchApplSts eq '' or param.srchApplSts eq null}">selected="selected"</c:if>>전체</option>
			                        <c:forEach items="${ApplStsList}" var="asLi">
										<option value="${asLi.ALT_CODE}" <c:if test="${param.srchApplSts eq asLi.ALT_CODE}">selected="selected"</c:if>>${asLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">키워드</td>
			                <td colspan="3">
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
		    	
		    	<c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
					<button class="btn red rmvcrr" type="button" name="addBtn">신규</button>
			    </c:if>
		        <button class="btn red type01" type="button" onclick="javascript:excel_download();">엑셀데이터 저장하기</button>
		    </div>
		</div>
		</form>
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:50px"/>
		            <col style="width:115px"/>
		            <col style="width:115px"/>
		            <col style="width:10%"/>
		            <col style="width:7%"/>
		            <col style="width:7%"/>
		            <col style="width:7%"/>
		            <col style="width:auto"/>
		            <col style="width:10%"/>
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>관리번호</th>
		                <th>처리상태</th>
		                <th>이름</th>
		                <th>생년월일</th>
		                <th>체육단체</th>
		                <th>종목</th>
		                <th>주소</th>
		                <th>신청일</th>
		            </tr>
		        </thead>
		        <tbody>
		            <c:choose>
						<c:when test="${not empty soldierSelectList}">
							<c:forEach items="${soldierSelectList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td>${list.MLTR_ID}</td>
					                <td>${list.APPL_STS_NM}</td>
					                <td><a href="javascript:fn_Detail('${list.APPL_SN}','${list.APPL_STS}');" class="tit">${list.APPL_NM}</a></td>
					                <td>${list.BRTH_DT}</td>
					                <td>${list.MEMORG_NM}</td>
					                <td>${list.GAME_NM}</td>
					                <td style="text-align:left;">${list.ADDR}</td>
					                <td>
					                	<fmt:parseDate var="APPL_UPD_DTM" value="${list.APPL_UPD_DTM}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${APPL_UPD_DTM}" pattern="yyyy-MM-dd"/>
					                </td>
					            </tr>
		            		</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="9" class="blank">검색결과가 존재하지 않습니다.</td></tr>
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
<form method="post" id="dFrm" name="dFrm" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="APPL_SN" value="${detail.APPL_SN}">
	<input type="hidden" name="APPL_STS" value="">
	<input type="hidden" name="APPL_UPD_DTM" value="">
	<input type="hidden" name="PROC_STS" value="AW">
	
	<div class="cpt-popup reg03 add"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            체육요원 편입신청
	            <button class="pop-close" onclick="addPopClose();">
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
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td" id="MLTR_ID"></td>
	                            <td class="t-title">이름<span class="t-red"> *</span></td>
	                            <td class="input-td"><input type="text" name="APPL_NM" value="" class="ip-title"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                            	<input id="datepicker3" name="BRTH_DT" type="text" class="datepick" autocomplete="off" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly maxlength="8">
	                            </td>
	                            <td class="t-title">주소<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                            	<button class="btn red rmvcrr" type="button" onclick="jusoSearch();return false;">주소검색</button>
	                            	<input type="text" class="ip-title" id="ZIP" name="ZIP" value="" readonly>
	                            	<input type="text" class="ip-title" id="ADDR" name="ADDR" value="" readonly>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일<span class="t-red"> *</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="EMAIL" value="" onKeyup="this.value=this.value.replace(/[^a-z0-9@._!#$%^&*]/gi,'');"></td>
	                            <td class="t-title">휴대폰<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <input type="text" name="CP_NO"  value="" onKeyup="this.value=this.value.replace(/[^0-9+]/g,'');">
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">편입신청내용
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
	                            <td class="t-title">대회명<span class="t-red"> *</span></td>
	                            <td colspan="3" class="input-td"><input type="text" class="ip-title" name="CONT_NM"  value=""></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                               	<select class="tab-sel" title="종목 선택" name="GAME_CD">
										<c:forEach items="${gameNmList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.GAME_CD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
				                    </select>
	                            </td>
	                            <td class="t-title">세부종목</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="GAME_DTL"  value=""></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">등위<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="등위" name="RANK">
	                                    <option value="">전체</option>
										<c:forEach items="${rankList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.RANK eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                            <td class="t-title">입상일<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                            	<input id="datepicker4" name="AWRD_DT" type="text" class="datepick" autocomplete="off" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly maxlength="8">
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">복무분야</td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="복무분야" name="FIELD">
	                                    <option value="">전체</option>
										<c:forEach items="${fieldList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.FIELD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                            <td class="t-title">역종</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MLTR_DV"  value=""></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">소속팀(근무지)<span class="t-red"> *</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="TEAM_NM"  value=""></td>
	                            <td class="t-title">소속팀국가</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="TM_NTN"  value=""></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">징병검사연도</td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="징병검사연도" name="INSPT_YR">
	                                    <option value="">전체</option>
										<c:forEach items="${nextYearList}" var="subLi">
											<option value="${subLi.YEAR}" <c:if test="${param.INSPT_YR eq subLi.YEAR}">selected="selected"</c:if>>${subLi.YEAR}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                            <td class="t-title">검사병무청</td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="검사병무청" name="INSPT_MLTR_ADMN">
	                                    <option value="">전체</option>
										<c:forEach items="${insptMltrAdmnList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.INSPT_MLTR_ADMN eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                        </tr>
	                       <tr>
	                       		<td class="t-title" colspan="4">
	                       			<div class="float-l">
	                       			첨부파일<span class="t-red"> ※ 첨부파일 필요항목 : 체육요원 추천서, 재직증명서, 입상확인서, 군복무확인서(해당자만) 등을 첨부합니다.</span>
	                       			</div>
	                       			<div class="float-r">
	                       			<button class="btn red rmvcrr userDv2" type="button" onclick="window.open('${pageContext.request.contextPath}/common/docs/편입제출서류.zip')">서류 다운로드</button>
	                       			</div>
	                       		</td>
	                       </tr>
	                       <tr id="fileTbody">
								<td colspan="3" class="adds bdr-0 input-td">
									<div class="fileBox">
										<input type="text" class="fileName2" readonly="readonly">
										<label for="uploadBtn" class="btn_file btn red addlist mrg-0 file-btn">파일첨부</label>
										<input type="file" name="file" id="uploadBtn" class="uploadBtn2">
										<input type="hidden" name="ATCH_FILE_ID1" id="ATCH_FILE_ID1">
									</div>
								</td>
								<td class="bdl-0 pdr-0 ft-0">
									<button class="btn lightgrey addfile mrg-5" type="button" onclick="fn_addFile(this);"></button>
								</td>
							</tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">체육단체 정보
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
	                            <td class="t-title">체육단체<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                            	 <input type="hidden" name="MEMORG_SN"  value="">
	                            	 <span class="appl memorgNm"></span>
	                            </td>
	                            <td class="t-title">연락처</td>
	                            <td class="input-td">
	                            	 <input type="hidden" name="MEMORG_TEL_NO"  value="">
	                                <span class="appl memorgTel"></span>
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            
	            <div class="com-table applReason" style="display:none;">
	                <table class="table-board">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width:130px;">
	                        <col style="width:auto;">
	                    </colgroup>
	                    <tbody>
	                        <tr>
	                            <td class="t-title name">공단반려사유</td>
	                            <td class="input-td">
	                            	 <span class="appl applReasons"></span>
	                            </td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            
	            <div class="com-helf">
	                <ol>
	                    <li class="uName">
	                    	<!-- Last Update. 홍길동 / 0000-00-00 -->
	                    </li>
	                </ol>
	            </div>
	
	            <div class="com-btn-group put">
	                <div class="float-r">
	                	<c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
		                    <button class="btn red rmvcrr userDv2" type="button" onclick="fn_save('TP');">임시저장</button>
		                    <button class="btn red rmvcrr userDv2" type="button" onclick="fn_save('AP');">신청</button>
		                    <button class="btn red rmvcrr userDv2" type="button" id="delete1" onclick="fn_delete();">삭제</button>
		                    <button class="btn navy rmvcrr" type="button" onclick="addPopClose();">닫기</button>
						</c:if>
	                </div>
	            </div>
	            
	        </div>
	    </div>
	</div>
</form>
<!-- //팝업영역 -->

<!-- 팝업영역 -->
<form method="post" id="sFrm" name="sFrm" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="APPL_SN" value="${detail.APPL_SN}">
	<input type="hidden" name="MLTR_ID" value="">
	<input type="hidden" name="PROC_STS" value="">
	<input type="hidden" name="APPL_STS" value="">
	<div class="cpt-popup reg03 select"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            체육요원 편입신청 조회
	            <button class="pop-close" onclick="selectPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="process-status">처리상태 : <b class="t-blue">공단접수</b></div>
	            <div class="com-h3 add">대상자 인적사항
	                <div class="right-area"></div>
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
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td" id="MLTR_ID"></td>
	                            <td class="t-title">이름<span class="t-red"> *</span></td>
	                            <td class="input-td" id="APPL_NM"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일<span class="t-red"> *</span></td>
	                            <td class="input-td" id="BRTH_DT"></td>
	                            <td class="t-title">주소<span class="t-red"> *</span></td>
	                            <td class="input-td" id="ADDR"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일<span class="t-red"> *</span></td>
	                            <td class="input-td" id="EMAIL"></td>
	                            <td class="t-title">휴대폰<span class="t-red"> *</span></td>
	                            <td class="input-td" id="CP_NO" ></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">편입신청내용
	                <div class="right-area"></div>
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
	                            <td class="t-title">대회명<span class="t-red"> *</span></td>
	                            <td colspan="3" class="input-td" id="CONT_NM"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목<span class="t-red"> *</span></td>
	                            <td class="input-td" id="GAME_CD"></td>
	                            <td class="t-title">세부종목</td>
	                            <td class="input-td" id="GAME_DTL"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">등위<span class="t-red"> *</span></td>
	                            <td class="input-td" id="RANK">
	                            </td>
	                            <td class="t-title">입상일<span class="t-red"> *</span></td>
	                            <td class="input-td" id="AWRD_DT"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">복무분야</td>
	                            <td class="input-td" id="FIELD"></td>
	                            <td class="t-title">역종</td>
	                            <td class="input-td" id="MLTR_DV"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">소속팀(근무지)<span class="t-red"> *</span></td>
	                            <td class="input-td" id="TEAM_NM"></td>
	                            <td class="t-title">소속팀국가</td>
	                            <td class="input-td" id="TM_NTN"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">징병검사연도</td>
	                            <td class="input-td" id="INSPT_YR"></td>
	                            <td class="t-title">검사병무청</td>
	                            <td class="input-td" id="INSPT_MLTR_ADMN"></td>
	                        </tr>
	                        <tr>
	                       		<td class="t-title" colspan="4">첨부파일<span class="t-red"> ※ 첨부파일 필요항목 : 체육요원 추천서, 재직증명서, 입상확인서, 군복무확인서(해당자만) 등을 첨부합니다.</span></td>
	                       </tr>
	                       <tr id="sFileTbody">
								
							</tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">체육단체 정보
	                <div class="right-area"></div>
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
	                            <td class="t-title">체육단체<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                            <input type="hidden" name="MEMORG_SN"  value="">
	                            	<span class="appl memorgNm"></span>
	                            </td>
	                            <td class="t-title">연락처</td>
	                            <td class="input-td">
	                                <span class="appl memorgTel"></span>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">공단 접수내역
	                <div class="right-area">
<!-- 	                    <p class="required">필수입력</p> -->
	                    <c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
		                    <button class="btn red rmvcrr delete" type="button" onclick="fn_delete();">삭제</button>
						</c:if>
	                    <c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
		                    <button class="btn red type01 receipt" type="button" onclick="fn_receipt();">접수처리</button>
		                    <button class="btn red type01 receipt" type="button" onclick="fn_receCompanion();">접수반려</button>
	                    </c:if>
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
								<td class="t-title">처리일자<span class="t-red"> *</span></td>
	                            <td id="ACPT_UPD_DTM"></td>
	                            <td class="t-title">처리결과</td>
	                            <td class="appl result"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">사유</td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="ACPT_REASON"></textarea></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add acpt">문체부(병무청) 승인내역
	                <div class="right-area">
						<c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
		                	<button class="btn red type01 userDv1" type="button" onclick="fn_acptOk();">문체부승인</button>
		                    <button class="btn red type01 userDv1" type="button" onclick="fn_acptNotOk();">문체부미승인</button>
	                    </c:if>
	                </div>
	            </div>
	            <div class="com-table acpt">
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
	                            <td class="t-title">편입일자<span class="t-red"> *</span></td>
	                            <td class="input-td"><input id="datepicker8" type="text" class="datepick" autocomplete="off" name="ADDM_DT" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" readonly></td>
	                            <td class="t-title">복무만료 예정일자<span class="t-red"> *</span></td>
	                            <td class="input-td"><input id="datepicker9" type="text" class="datepick" autocomplete="off" name="RSVT_DT" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">복무기관<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="복무기관" name="SRV_INSTT_CODE">
	                                    <option value="">전체</option>
	                                     <c:forEach items="${srvInsttCodeList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.SRV_INSTT_CODE eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                            <td class="t-title">복무분야</td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="복무분야" name="SRV_FIELD">
										<option value="">전체</option>
	                                     <c:forEach items="${fieldList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.SRV_FIELD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">관할병무청<span class="t-red"> *</span></td>
	                            <td class="input-td">
	                                <select class="tab-sel" title="관할병무청" name="CTRL_MMA_CD">
	                                    <option value="">전체</option>
	                                    <c:forEach items="${insptMltrAdmnList}" var="subLi">
											<option value="${subLi.ALT_CODE}" <c:if test="${param.CTRL_MMA_CD eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
										</c:forEach>
	                                </select>
	                            </td>
	                            <td class="t-title">승인내역</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="DSPTH_REASON" maxlength="1000"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">처리결과</td>
	                            <td colspan="3" class="appl result"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">사유</td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="CMPL_REASON"></textarea></td>
	                        </tr>
	                        <tr id="acptFile">
                                <td class="t-title">첨부파일</td>
                                <td colspan="3" class="input-td">
									<div class="fileBox acpt">
										<input type="text" class="fileName" readonly="readonly">
										<input type="file" id="fileUp05" name="file" class="file-table uploadBtn">
										<label for="fileUp05" class="btn red rmvcrr file-btn">파일선택</label>
									</div>
								</td>
	                        </tr>
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
