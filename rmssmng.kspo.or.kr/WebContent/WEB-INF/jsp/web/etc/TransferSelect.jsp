<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker, #datepicker1, #datepicker3, #datepicker4, #datepicker7, #datepicker8, #datepicker9").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
// 			$("#datepicker").datepicker('setDate','-D4');
// 			$("#datepicker1").datepicker('setDate','+D3');
			
			
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
		
		//체육요원 신상이동신청 신규 팝업 오픈
		$(document).on("click","button[name=addBtn]",function(){
			
			var param = "gMenuSn=" + $("#frm input[name=gMenuSn]").val();
			var $json = getJsonData("post", "/user/selectloginUserDtlList.kspo", param);
				
			var dtl = $json.responseJSON.loginUserDtl;
			
			//로그인한 담당자 정보 불러오기
			$("#dFrm input[name=MEMORG_SN]").val(dtl.MEMORG_SN);
			$("#dFrm .appl.memorgNm").text(dtl.MEMORG_NM);
			$("#dFrm .appl.memOrgTel").text(dtl.MEMORG_TEL_NO);
				
			// 신규신청시 삭제버튼 비활성화
			if($("#dFrm input[name=TRNS_SN]").val() == null || $("#dFrm input[name=TRNS_SN]").val() == "") {
				$("#delBt").hide();
			} else {
				$("#delBt").show();
			}
			
			addPopOpen();
		});
		
		// 팝업 초기화면 소속변경 checked 여부
		$('#ckb input[name=transferType]').each(function() {
			var divName = $(this).val() + 'Box';

			if ($(this).is(':checked')) {
				$('#' + divName).show();
			} else {
				$('#' + divName).hide();
			}
		});
		

		// checked인 div 영역 toggle
		$(document).on('change', '#ckb input[name=transferType]', function() {
			var divName = $(this).val() + 'Box';

			var checkedYn = $(this).is(':checked');

			if (checkedYn) {
				$('#' + divName).show();
			} else {
				$('#' + divName).hide();
			}

		});
		
		
	});
	
		
	//검색
	function fn_search() {
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/transfer/TransferSelect.kspo", $("#frm").serialize());
	}

	//체육요원 신상이동신청 신규 팝업 열기
	function addPopOpen() {
		$(".add").addClass("active")
		$("body").css("overflow", "hidden")
	}


	//체육요원 신상이동신청 신규 팝업 닫기
	function addPopClose() {
		fn_search();
		$(".add").removeClass("active")
		$("body").css("overflow","auto")
	}

	//체육요원 신상이동신청 상세 팝업 열기
	function selectPopOpen(){
		$(".select").addClass("active")
		$("body").css("overflow", "hidden")
	}

	//체육요원 신상이동신청 상세 팝업 닫기
	function selectPopClose() {
		fn_search();
		$(".select").removeClass("active")
		$("body").css("overflow","auto")
	}

	//저장
	function fn_save(TRNS_STS){
	
			//TRNS_DV
			var TRNS_DV = "";
			$("input[name=transferType]:checked").each(function() {
				if(TRNS_DV == "") {
					TRNS_DV = $(this).val();
				} else {
					TRNS_DV = TRNS_DV + "," + $(this).val();
				}
			});
			$("#dFrm input[name=TRNS_DV]").val(TRNS_DV);
		
			
		if(fn_saveValid()){
			
			var saveUrl = "/transfer/updateTransferJs.kspo";
			if($("#dFrm input[name=TRNS_STS]").val() == "" || $("#dFrm input[name=TRNS_STS]").val() == null){
				saveUrl = "/transfer/insertTransferJs.kspo";
			} 
		
			$("#dFrm input[name=TRNS_STS]").val(TRNS_STS);
		
			var TRNS_STS = $("#dFrm input[name=TRNS_STS]").val();
			
			var $json = getJsonMultiData( saveUrl, "dFrm");
			
			if($json.statusText == "OK"){
				
				fnAlert("저장되었습니다.");
				fn_search();	
				
			}
			
		}
	
	}

	//Validation Check
	function fn_saveValid(){
		
		if($("#dFrm input[name=APPL_NM]").val() == "" || $("#dFrm input[name=APPL_NM]").val() == null){
			fnFocAlert("대상자를 선택하시기 바랍니다.", $("#dFrm input[name=APPL_NM]"));
			return ;
		}
		
		//소속변경 checked
		if ($('#change1').is(':checked')) {
			
			//소속변경 - 변경소속
			if($("#dFrm input[name=MLTR_ORG_TRNS_AFTR]").val() == "" || $("#dFrm input[name=MLTR_ORG_TRNS_AFTR]").val() == null){
				fnFocAlert("변경소속을 입력하시기 바랍니다.", 	$("#dFrm input[name=MLTR_ORG_TRNS_AFTR]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=MLTR_ORG_TRNS_AFTR]").val())>100){
					var length = fnGetTxtLength(100);
					fnFocAlert("변경소속 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", 	$("#dFrm input[name=MLTR_ORG_TRNS_AFTR]"));
					return false;
				}
			}
			
			//소속변경 - 변경국가
			if($("#dFrm input[name=CHANGE_NATION]").val() == "" || $("#dFrm input[name=CHANGE_NATION]").val() == null){
				fnFocAlert("변경국가를 입력하시기 바랍니다.", $("#dFrm input[name=CHANGE_NATION]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=CHANGE_NATION]").val())>100){
					var length = fnGetTxtLength(100);
					fnFocAlert("변경국가 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=CHANGE_NATION]"));
					return false;
				}
			}
			
			//소속변경 - 변경사유
			if($("#dFrm input[name=CHANGE_REASON]").val() == "" || $("#dFrm input[name=CHANGE_REASON]").val() == null){
				fnFocAlert("변경사유를 입력하시기 바랍니다.", $("#dFrm input[name=CHANGE_REASON]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=CHANGE_REASON]").val())>150){
					var length = fnGetTxtLength(150);
					fnFocAlert("변경사유 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=CHANGE_REASON]"));
					return false;
				}
			}
			
			//소속변경 - 적용일자
			if($("#dFrm input[name=PSITN_CHANGE_DT]").val() == "" || $("#dFrm input[name=PSITN_CHANGE_DT]").val() == null){
				fnFocAlert("적용일자를 선택하시기 바랍니다.", $("#dFrm input[name=PSITN_CHANGE_DT]"));
				return ;
			}
		
		}
		
		//형 선고 checked
		if ($('#change2').is(':checked')) {
		
			//형 선고 - 형구분
			if($("#dFrm select[name=ADJU_DV]").val() == "" || $("#dFrm select[name=ADJU_DV]").val() == null){
				fnFocAlert("형 구분을 선택하시기 바랍니다.", $("#dFrm select[name=ADJU_DV]"));
				return ;
			}
			
			//형 선고 - 적용일자
			if($("#dFrm input[name=ADJU_CHANGE_DT]").val() == "" || $("#dFrm input[name=ADJU_CHANGE_DT]").val() == null){
				fnFocAlert("적용일자를 선택하시기 바랍니다.", $("#dFrm input[name=ADJU_CHANGE_DT]"));
				return ;
			}
			
			//형 선고 - 주요내용
			if($("#dFrm input[name=ADJU_CONTENTS]").val() == "" || $("#dFrm input[name=ADJU_CONTENTS]").val() == null){
				fnFocAlert("주요내용을 입력하시기 바랍니다.", $("#dFrm input[name=ADJU_CONTENTS]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=ADJU_CONTENTS]").val())>150){
					var length = fnGetTxtLength(150);
					fnFocAlert("주요내용 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=ADJU_CONTENTS]"));
					return false;
				}
			}
		
		}
		
		//인적사항 checked
		if ($('#change3').is(':checked')) {
		
			//인적사항 변경 - 이름
			if($("#dFrm input[name=TRNS_NM]").val() == "" || $("#dFrm input[name=TRNS_NM]").val() == null){
				fnFocAlert("변경할 이름을 입력하시기 바랍니다.", $("#dFrm input[name=TRNS_NM]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=TRNS_NM]").val())>50){
					var length = fnGetTxtLength(50);
					fnFocAlert("이름 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=TRNS_NM]"));
					return false;
				}
			}
			
			//인적사항 변경 - 주소
			if($("#dFrm input[name=TRNS_ADDR]").val() == "" || $("#dFrm input[name=TRNS_ADDR]").val() == null){
				fnFocAlert("변경할 주소를 입력하시기 바랍니다.", $("#dFrm input[name=TRNS_ADDR]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=TRNS_ADDR]").val())>500){
					var length = fnGetTxtLength(500);
					fnFocAlert("주소 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=TRNS_ADDR]"));
					return false;
				}
			}
			
			//인적사항 변경 - 휴대폰
			if($("#dFrm input[name=TRNS_CP_NO]").val() == "" || $("#dFrm input[name=TRNS_CP_NO]").val() == null){
				fnFocAlert("변경할 휴대폰번호를 입력하시기 바랍니다.", $("#dFrm input[name=TRNS_CP_NO]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=TRNS_CP_NO]").val())>11){
					var length = fnGetTxtLength(11);
					fnFocAlert("휴대폰 번호 길이를 초과하였습니다.<br/>(최대 11자리까지 입력가능)", $("#dFrm input[name=TRNS_CP_NO]"));
					return false;
				}
				
				var valiCpNo = /^[0-9]{3}[0-9]{3,4}[0-9]{4}$/;
				if(!valiCpNo.test($("#dFrm input[name=TRNS_CP_NO]").val())) {
					fnFocAlert("올바른 전화번호 형식이 아닙니다.", $("#dFrm input[name=TRNS_CP_NO]"));
					return false;
				}
				
			}
			
			//인적사항 변경 - 이메일
			if($("#dFrm input[name=TRNS_EMAIL]").val() == "" || $("#dFrm input[name=TRNS_EMAIL]").val() == null){
				fnFocAlert("변경할 이메일을 입력하시기 바랍니다.", $("#dFrm input[name=TRNS_EMAIL]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=TRNS_EMAIL]").val())>128){
					var length = fnGetTxtLength(128);
					fnFocAlert("이메일 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=TRNS_EMAIL]"));
					return false;
				}
				
				var valiEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
				if(!valiEmail.test($("#dFrm input[name=TRNS_EMAIL]").val())) {
					fnFocAlert("올바른 이메일 형식이 아닙니다.", $("#dFrm input[name=TRNS_EMAIL]"));
					return false;
				}
				
			}
			
			//인적사항 변경 - 관할 병무청
			if($("#dFrm select[name=CHANGE_CTRL_MMA]").val() == "" || $("#dFrm select[name=CHANGE_CTRL_MMA]").val() == null){
				fnFocAlert("변경할 관할 병무청을 선택하시기 바랍니다.", $("#dFrm select[name=CHANGE_CTRL_MMA]"));
				return ;
			}
			
			//인적사항 변경 - 변경사유
			if($("#dFrm input[name=HNINFO_CHANGE_PRVONSH]").val() == "" || $("#dFrm input[name=HNINFO_CHANGE_PRVONSH]").val() == null){
				fnFocAlert("인적사항 변경 사유를 입력하시기 바랍니다.", $("#dFrm input[name=HNINFO_CHANGE_PRVONSH]"));
				return ;
			} else {
				if(fnGetByte($("#dFrm input[name=HNINFO_CHANGE_PRVONSH]").val())>150){
					var length = fnGetTxtLength(150);
					fnFocAlert("인적사항 변경 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#dFrm input[name=HNINFO_CHANGE_PRVONSH]"));
					return false;
				}
			}
			
			//인적사항 변경 - 적용일자
			if($("#dFrm input[name=HNINFO_CHANGE_PNTTM]").val() == "" || $("#dFrm input[name=HNINFO_CHANGE_PNTTM]").val() == null){
				fnFocAlert("인적사항 변경 적용일자를 선택하시기 바랍니다.", $("#dFrm input[name=HNINFO_CHANGE_PNTTM]"));
				return ;
			}
			
		}
		
		return true;
	}

	//상세조회
	function fn_Detail(TRNS_SN,TRNS_STS){
		var param = "TRNS_SN=" + TRNS_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/transfer/selectTransferDetailJs.kspo", param);
		
		var grpSn = "${sessionScope.userMap.GRP_SN}";
		
		var type = null;
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			
			var T1fileList = $json.responseJSON.T1fileList;
			var T2fileList = $json.responseJSON.T2fileList;
			
			if(TRNS_STS == 'TP' && grpSn != '1'){
				//신상이동 수정 정보 세팅
				$("#dFrmTxtDiv").html(dtl.TRNS_STS_NM);
				$("#dFrm input[name=TRNS_STS]").val(dtl.TRNS_STS);
				$("#dFrm input[name=REG_DTM]").val(dtl.REG_DTM);
				$("#dFrm input[name=APPL_NM]").val(dtl.APPL_NM);
				$("#dFrm input[name=TRNS_SN]").val(dtl.TRNS_SN);
				$("#dFrm input[name=APPL_SN]").val(dtl.APPL_SN);
				$("#dFrm input[name=REG_DTM]").val(dtl.REG_DTM);
				$("#dFrm input[name=BRTH_DT]").val(dtl.BRTH_DT);
		 		$("#dFrm select[name=ADJU_DV]").val(dtl.ADJU_DV);
				$("#dFrm input[name=ZIP]").val(dtl.ZIP);
				$("#dFrm input[name=ADDR]").val(dtl.ADDR);
				$("#dFrm input[name=EMAIL]").val(dtl.EMAIL);
				$("#dFrm input[name=CP_NO]").val(dtl.CP_NO);
				$("#dFrm input[name=TEAM_NM]").val(dtl.TEAM_NM);
				$("#dFrm input[name=TM_NTN]").val(dtl.TM_NTN);
				$("#dFrm input[name=MLTR_ID]").val(dtl.MLTR_ID);
				$("#dFrm input[name=CTRL_MMA_NM]").val(dtl.CTRL_MMA_NM);
				$("#dFrm input[name=GAME_NM]").val(dtl.GAME_NM);
				$("#dFrm input[name=MEMORG_NM]").val(dtl.MEMORG_NM);
				$("#dFrm input[name=ATCH_FILE_ID1]").val(dtl.ATCH_FILE_ID1);
				$("#dFrm input[name=ATCH_FILE_ID2]").val(dtl.ATCH_FILE_ID2);
				$("#dFrm input[name=MLTR_ORG_TRNS_AFTR]").val(dtl.MLTR_ORG_TRNS_AFTR);
				$("#dFrm input[name=TM_NTN]").val(dtl.TM_NTN);
				$("#dFrm input[name=CHANGE_NATION]").val(dtl.CHANGE_NATION);
				$("#dFrm input[name=CHANGE_REASON]").val(dtl.CHANGE_REASON);
				$("#dFrm input[name=PSITN_CHANGE_DT]").val(dtl.PSITN_CHANGE_DT);
				$("#dFrm input[name=ADJU_CHANGE_DT]").val(dtl.ADJU_CHANGE_DT);
				$("#dFrm input[name=ADJU_CONTENTS]").val(dtl.ADJU_CONTENTS);
				$("#dFrm input[name=TRNS_NM]").val(dtl.TRNS_NM);
				$("#dFrm input[name=TRNS_ZIP]").val(dtl.TRNS_ZIP);
				$("#dFrm input[name=TRNS_ADDR]").val(dtl.TRNS_ADDR);
				$("#dFrm input[name=TRNS_CP_NO]").val(dtl.D_TRNS_CP_NO);
				$("#dFrm input[name=TRNS_EMAIL]").val(dtl.TRNS_EMAIL);
				$("#dFrm select[name=CHANGE_CTRL_MMA]").val(dtl.CHANGE_CTRL_MMA);
				$("#dFrm input[name=HNINFO_CHANGE_PRVONSH]").val(dtl.HNINFO_CHANGE_PRVONSH);
				$("#dFrm input[name=HNINFO_CHANGE_PNTTM]").val(dtl.HNINFO_CHANGE_PNTTM);

				
				if(dtl.TRNS_STS == 'KN') {

					$('#gdDivD').show();
					
					$("#gdDivD td[id=ACPT_UPD_DTM]").html(dtl.ACPT_UPD_DTM);
					$("#transferStsTxtKdTdD").html(dtl.TRNS_STS_NM);
					$("#gdDivD td[id=DSPS_PRVONSH]").html(dtl.DSPS_PRVONSH);
					
				}
				
				// 신상이동구분
				var trnsDv = dtl.TRNS_DV;
				var trnsDvArr = trnsDv.split(',');
				
				$('#dFrm div[id=T1Box], div[id=T2Box], div[id=T3Box]').hide();
				$('#dFrm input[id=change1]').attr("checked", false);
				
				for (var i = 0; i < trnsDvArr.length; i++) {

					if (trnsDvArr[i] == 'T1') {
						$('#dFrm div[id=T1Box]').show();
						$('#dFrm input[id=change1]').attr("checked", true);
					} else if (trnsDvArr[i] == 'T2') {
						$('#dFrm div[id=T2Box]').show();
						$('#dFrm input[id=change2]').attr("checked", true);
					} else if (trnsDvArr[i] == 'T3') {
						$('#dFrm div[id=T3Box]').show();
						$('#dFrm input[id=change3]').attr("checked", true);
					}
				}
				
				
				//첨부파일(소속변경)
				var T1fileObj = "";
				if(T1fileList.length > 0){
					for(var i=0;i<T1fileList.length;i++) {
						T1fileObj += '<tr>';
						T1fileObj += '<td colspan="3" class="adds bdr-0 input-td">';
						T1fileObj += '<a href="javascript:fnDownloadFile('+T1fileList[i].FILE_SN+')"><span class="file-name">'+ T1fileList[i].FILE_ORGIN_NM +'</span></a>';
						T1fileObj += '<button class="file-del" onclick="fn_fileDel(' + T1fileList[i].FILE_SN +', '+T1fileList[i].REFR_COL_NM+', this)"> 삭제</button>';
						T1fileObj += '</td>';
						T1fileObj += '<td class="bdl-0 pdr-0 ft-0">';
						T1fileObj += '<input type="hidden" name="T1_ATCH_FILE_ID value="'+ dtl.ATCH_FILE_ID1 +'">';
						T1fileObj += '</td>';
						T1fileObj += '</tr>';
					}
				} 
				else {
					$("#dFrm input[name=T1_ATCH_FILE_ID]").val("");
				}
				$("#T1fileTbody").before(T1fileObj);

				
				//첨부파일(형선고)
				var T2fileObj = "";
				if(T2fileList.length > 0){
					for(var i=0;i<T2fileList.length;i++) {
						T2fileObj += '<tr>';
 						T2fileObj += '<td colspan="3" class="adds bdr-0 input-td">';
						T2fileObj += '<a href="javascript:fnDownloadFile('+T2fileList[i].FILE_SN+')"><span class="file-name">'+ T2fileList[i].FILE_ORGIN_NM +'</span></a>';
						T2fileObj += '<button class="file-del" onclick="fn_fileDel(' + T2fileList[i].FILE_SN +', '+T2fileList[i].REFR_COL_NM+', this)"> 삭제</button>';
						T2fileObj += '</td>';
						T2fileObj += '<td class="bdl-0 pdr-0 ft-0">';
						T2fileObj += '<input type="hidden" name="T2_ATCH_FILE_ID value="'+ dtl.ATCH_FILE_ID2 +'">';
						T2fileObj += '</td>';
						T2fileObj += '</tr>';
					}
				} 
				else {
					$("#dFrm input[name=T2_ATCH_FILE_ID]").val("");
				}
				$("#T2fileTbody").before(T2fileObj);
				
				
				addPopOpen();
			}else{
				//상세조회 세팅
				$("#sFrmTxtDiv").html(dtl.TRNS_STS_NM);
				$("#sFrm input[name=PROC_STS]").val(dtl.PROC_STS);
				$("#sFrm input[name=TRNS_STS]").val(dtl.TRNS_STS);
				$("#sFrm input[name=TRNS_SN]").val(dtl.TRNS_SN);
				$("#sFrm input[name=REG_DTM]").val(dtl.REG_DTM);
				$("#sFrm td[id=APPL_NM]").html(dtl.APPL_NM);
				$("#sFrm td[id=MLTR_ID]").html(dtl.MLTR_ID);
				$("#sFrm td[id=BRTH_DT]").html(dtl.BRTH_DT);
				$("#sFrm td[id=ZIP]").html(dtl.ZIP);
				$("#sFrm td[id=ADDR]").html(dtl.ADDR);
				$("#sFrm td[id=EMAIL]").html(dtl.EMAIL);
				$("#sFrm td[id=CP_NO]").html(dtl.CP_NO);
				$("#sFrm td[id=GAME_NM]").html(dtl.GAME_NM);
				$("#sFrm td[id=MEMORG_NM]").html(dtl.MEMORG_NM);
				$("#sFrm td[id=TEAM_NM]").html(dtl.TEAM_NM);
				$("#sFrm td[id=MLTR_ORG_TRNS_AFTR]").html(dtl.MLTR_ORG_TRNS_AFTR);
				$("#sFrm td[id=TM_NTN]").html(dtl.TM_NTN);
				$("#sFrm td[id=CHANGE_NATION]").html(dtl.CHANGE_NATION);
				$("#sFrm td[id=CHANGE_REASON]").html(dtl.CHANGE_REASON);
				$("#sFrm td[id=PSITN_CHANGE_DT]").html(dtl.S_PSITN_CHANGE_DT);
				$("#sFrm td[id=ADJU_DV]").html(dtl.ADJU_DV_NM);
				$("#sFrm td[id=ADJU_CHANGE_DT]").html(dtl.S_ADJU_CHANGE_DT);
				$("#sFrm td[id=ADJU_CONTENTS]").html(dtl.ADJU_CONTENTS);
				$("#sFrm td[id=TRNS_NM]").html(dtl.TRNS_NM);
				$("#sFrm td[id=TRNS_ZIP]").html(dtl.TRNS_ZIP);
				$("#sFrm td[id=TRNS_ADDR]").html(dtl.TRNS_ADDR);
				$("#sFrm td[id=TRNS_CP_NO]").html(dtl.TRNS_CP_NO);
				$("#sFrm td[id=TRNS_EMAIL]").html(dtl.TRNS_EMAIL);
				$("#sFrm td[id=CTRL_MMA_NM]").html(dtl.CTRL_MMA_NM);
				$("#sFrm td[id=CHANGE_CTRL_MMA]").html(dtl.CHANGE_CTRL_MMA_NM);
				$("#sFrm td[id=HNINFO_CHANGE_PRVONSH]").html(dtl.HNINFO_CHANGE_PRVONSH);
				$("#sFrm td[id=HNINFO_CHANGE_PNTTM]").html(dtl.S_HNINFO_CHANGE_PNTTM);
				
				
				// 신상이동구분
				var trnsDv = dtl.TRNS_DV;
				var trnsDvArr = trnsDv.split(',');
				
				$('#sFrm div[id=T1Box], div[id=T2Box], div[id=T3Box]').hide();
				
				for (var i = 0; i < trnsDvArr.length; i++) {
					
					if (trnsDvArr[i] == 'T1') {
						$('#sFrm div[id=T1Box]').show();
					} else if (trnsDvArr[i] == 'T2') {
						$('#sFrm div[id=T2Box]').show();
					} else if (trnsDvArr[i] == 'T3') {
						$('#sFrm div[id=T3Box]').show();
					}
				}

				
				//첨부파일(소속변경)
				var T1fileObj = "";
				if(T1fileList.length > 0){
					for(var i=0;i<T1fileList.length;i++) {
						T1fileObj += '<tr>';
						T1fileObj += '<td colspan="3" class="adds bdr-0 input-td">';
						T1fileObj += '<a href="javascript:fnDownloadFile('+T1fileList[i].FILE_SN+')"><span class="file-name">'+ T1fileList[i].FILE_ORGIN_NM +'</span></a>';
						T1fileObj += '</td>';
						T1fileObj += '<td class="bdl-0 pdr-0 ft-0">';
						T1fileObj += '</td>';
						T1fileObj += '</tr>';
					}
				}
				$("#T1sFileTbody").before(T1fileObj);
				
				
				//첨부파일(형선고)
				var T2fileObj = "";
				if(T2fileList.length > 0){
					for(var i=0;i<T2fileList.length;i++) {
						T2fileObj += '<tr>';
						T2fileObj += '<td colspan="3" class="adds bdr-0 input-td">';
						T2fileObj += '<a href="javascript:fnDownloadFile('+T2fileList[i].FILE_SN+')"><span class="file-name">'+ T2fileList[i].FILE_ORGIN_NM +'</span></a>';
						T2fileObj += '</td>';
						T2fileObj += '<td class="bdl-0 pdr-0 ft-0">';
						T2fileObj += '</td>';
						T2fileObj += '</tr>';
					}
				}
				$("#T2sFileTbody").before(T2fileObj);
				
				
				
				$('#gFrm td[id=ACPT_UPD_DTM]').html(dtl.ACPT_UPD_DTM);
				$('#transferStsTxtKdTd').html(dtl.TRNS_STS_NM);
				$('#gFrm textarea[name=DSPS_PRVONSH]').val(dtl.DSPS_PRVONSH);
				
				
				if(grpSn == '1'){//공단 담당자 권한
					if('TP' != dtl.TRNS_STS){
						
						$('#gdDiv').show();	
						
						if('TA' != dtl.TRNS_STS){//신청이 아니면
							$('#btnKdConfirmY').hide();
							$('#btnKdConfirmN').hide();
							
							$('#gFrm textarea[name=DSPS_PRVONSH]').attr("readonly", true);
						} 
// 						else {
// 							var today = new Date();
// 							var year = today.getFullYear();
// 							var month = ('0' + (today.getMonth() + 1)).slice(-2);
// 							var day = ('0' + today.getDate()).slice(-2)
							
// 							var showToday = year + '-' + month + '-' + day;;
							
// 							$('#gFrm td[id=ACPT_UPD_DTM]').html("오늘");
// 						}
					}
					
				} else if(grpSn == '2'){ //체육단체 권한
					if(dtl.TRNS_STS == 'KY' || dtl.TRNS_STS == 'KN') {
						
						$('#gdDiv').show();
						$('#rqd').hide();
						
						$('#btnKdConfirmY').hide();
						$('#btnKdConfirmN').hide();
						
						$('#gFrm textarea[name=DSPS_PRVONSH]').attr("readonly", true);
						
					}
					
				}
				
				selectPopOpen();
			}
			
			//수정이력 표시
			$('#lastUpdateDiv').show();
			$('#lastUpdateLi').html("Last Update. " + dtl.LATEST_NM + " / " + dtl.LATEST_UPDT);
			
		}
	}
	
	
	//파일 다운로드
  	function fnDownloadFile(fileSn){
  		window.location = "${pageContext.request.contextPath}/file/downloadFile.kspo?FILE_SN="+fileSn+"&gMenuSn="+$("#frm input[name=gMenuSn]").val();
  	}
	
	//임시저장 혹은 신청일시 삭제
	function fn_delete(){
		
		if(!confirm("삭제하시겠습니까?")) {
			return false;
		}
		
		var trnsSn = $("#dFrm input[name=TRNS_SN]").val();
		
		if(trnsSn == null || trnsSn == ""){
			trnsSn = $("#sFrm input[name=TRNS_SN]").val();
		}
		var param = "TRNS_SN=" + trnsSn;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/transfer/deleteTransferJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			fnAlert("삭제되었습니다.");
			fn_search();
		}
		
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
			param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();	
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/transfer/selectPersonJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var personInfo = $json.responseJSON.personInfo;
			var htmlStr = "";
			
			if(personInfo == null){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
				
			$("#dFrm input[name=PROC_STS]").val(personInfo.PROC_STS);
			$("#dFrm input[name=TRNS_STS]").val(personInfo.TRNS_STS);
			$("#dFrm input[name=APPL_NM]").val(personInfo.APPL_NM);
			$("#dFrm input[name=TRNS_SN]").val(personInfo.TRNS_SN);
			$("#dFrm input[name=APPL_SN]").val(personInfo.APPL_SN);
			$("#dFrm input[name=TRNS_STS]").val(personInfo.TRNS_STS);
			$("#dFrm input[name=BRTH_DT]").val(personInfo.BRTH_DT);
	 		$("#dFrm input[name=ADJU_DV]").val(personInfo.ADJU_DV);
			$("#dFrm input[name=ZIP]").val(personInfo.ZIP);
			$("#dFrm input[name=ADDR]").val(personInfo.ADDR);
			$("#dFrm input[name=EMAIL]").val(personInfo.EMAIL);
			$("#dFrm input[name=CP_NO]").val(personInfo.CP_NO);
			$("#dFrm input[name=TEAM_NM]").val(personInfo.TEAM_NM);
			$("#dFrm input[name=TM_NTN]").val(personInfo.TM_NTN);
			$("#dFrm input[name=MLTR_ID]").val(personInfo.MLTR_ID);
			$("#dFrm input[name=CTRL_MMA_NM]").val(personInfo.CTRL_MMA_NM);
			$("#dFrm input[name=GAME_NM]").val(personInfo.GAME_NM);
			$("#dFrm input[name=MEMORG_NM]").val(personInfo.MEMORG_NM);
				
			fn_searchPersonPopupClose();
			
		}
		
	}
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
	}
	
	
	
	
	
	// 공단 접수처리
	function fn_transferConfirm(TRNS_STS) {
		
		// 접수처리 Validation
		if($('#gFrm textarea[name=DSPS_PRVONSH]').val() == '') {
			$('#gFrm textarea[name=DSPS_PRVONSH]').focus();
			fnAlert("비고를 입력해주세요.");
			return false;
		}
		
		var confirmMsg = "";
		
		if(TRNS_STS == 'KY') {
			confirmMsg = "접수처리 하시겠습니까?";
		} else if(TRNS_STS == 'KN') {
			confirmMsg = "접수반려 하시겠습니까?";
		} else {
			fnAlert("오류가 발생하였습니다.");
			return false;
		}
		
		if(!confirm(confirmMsg)) {
			return false;
		}
		
		$('#gFrm input[name=TRNS_STS]').val(TRNS_STS);
		$('#gFrm input[name=TRNS_SN]').val($('#sFrm input[name=TRNS_SN]').val());
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/transfer/confirmTransferJs.kspo", $("#gFrm").serialize());
		
		if($json.statusText == "OK") {
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {
				addPopClose();
				fnAlert("처리되었습니다.");
				fn_search();
			} else {
				fnAlert("처리에 실패하였습니다.");
				fn_search();
			}
		}
		
		
	}
	
	
	//첨부파일input 추가
	function fn_addFile(obj, type){
		
		var fileBoxId = type + 'Box';
		
		var fileTrId = type + 'fileTbody';
		
		var fileCnt = $("#"+ fileBoxId + " .uploadBtn2").length;

// 		$("#" + fileTrId).after(fn_addFileObj(fileCnt, type));
		$("#" + fileBoxId + " tbody").append(fn_addFileObj(fileCnt, type));

	}
	
	//첨부파일input 삭제
	function fn_removeFile(obj){
		$(obj).parents("tr").remove();
		if($(".uploadBtn2").length == 0){
			$("#fileTbody").after(fn_addFileObj("0"));
		}
	}
	
	
	//첨부파일 삭제
	function fn_fileDel(FILE_SN, REFR_COL_NM, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&REFR_COL_NM=" + REFR_COL_NM;
			param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			$(fileObj).parent().parent('tr').remove();
		}
	}
	
	
	//파일 생성 오브젝트
	function fn_addFileObj(fileCnt, type){
		var addFileObj = "";
		addFileObj += '<tr>';
		addFileObj += '<td colspan="3" class="adds bdr-0 input-td">';
		addFileObj += '<div class="fileBox">';
		addFileObj += '<input type="text" class="fileName2" readonly="readonly">';
		addFileObj += '<label for="uploadBtn'+fileCnt+'_' + type + '" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>';
		addFileObj += '<input type="file" name="'+ type +'file" id="uploadBtn'+fileCnt+'_' + type + '" class="uploadBtn2">';
		addFileObj += '</div>';
		addFileObj += '</td>';
		addFileObj += '<td class="bdl-0 pdr-0 ft-0">';
		addFileObj += '<button class="btn lightgrey removefile" type="button" onclick="fn_removeFile(this);"></button>';
		addFileObj += '</td>';
		addFileObj += '</tr>';
		
		return addFileObj;
	}
	
	
	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/transfer/selectTransferDownload.kspo");
		$("#frm").submit();
		
		fn_search();
	}
	
	
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
		$("#TRNS_ZIP").val(zipNo);
		$("#TRNS_ADDR").val(roadAddrPart1+ " "+roadAddrPart2+ " " + addrDetail);
			
	}; 
	
	
	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>신상이동신청</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/transfer/TransferSelect.kspo">
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
			                            <input id="datepicker" name="STD_YMD" type="text" class="datepick smal"  value="${STD_YMD}" autocomplete="off" maxlength="8"> ~ 
			                            <input id="datepicker1" name="END_YMD" type="text" class="datepick smal" value="${END_YMD}" autocomplete="off" maxlength="8">
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
			                    <select id="srchTrnsSts" name="srchTrnsSts" class="smal">
			                    	<option value="" <c:if test="${param.srchTrnsSts eq '' or param.srchTrnsSts eq null}">selected="selected"</c:if>>전체</option>
			                        <c:forEach items="${stsList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchTrnsSts eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">편입상태</td>
			                <td>
			                    <ul class="com-radio-list">
			                    	<c:forEach var="subLi" items="${procStsList}" varStatus="sts">
			                    		<c:if test="${subLi.ALT_CODE eq 'AG' || subLi.ALT_CODE eq 'MM' }">
			                    			<li>
					                            <input id="PROC_STS${sts.index}" type="radio" value="${subLi.ALT_CODE}" name="PROC_STS" 
					                            	<c:if test="${subLi.ALT_CODE eq 'AG'}">checked="checked"</c:if>
					                            	<c:if test="${param.PROC_STS eq subLi.ALT_CODE}">checked="checked"</c:if>>
					                            <label for="PROC_STS${sts.index}">
					                            	<c:if test="${subLi.ALT_CODE eq 'AG'}">복무</c:if>
					                            	<c:if test="${subLi.ALT_CODE eq 'MM'}">만료</c:if>
					                            </label>
			                        		</li>
			                    		</c:if>
			                    	</c:forEach>
			                    	<li>
			                            <input id="PROC_STS6" type="radio" value="all" name="PROC_STS"
			                            	<c:if test="${param.PROC_STS eq 'all'}">checked="checked"</c:if>>
			                            <label for="PROC_STS6">전체</label>
			                        </li>
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
			                            <input type="text" class="smal" placeholder="" name="keyword" value="${param.keyword}" onkeydown="if(event.keyCode == 13){fn_search();return false;}">
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
		   	 	<c:if test="${userDtl.USER_DV eq '2'}">
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
		            <col style="width:50px">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:25%">
		            <col style="width:10%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>신청번호</th>
		                <th>처리상태</th>
		                <th>이름</th>
		                <th>생년월일</th>
		                <th>체육단체</th>
		                <th>종목</th>
		                <th>편입상태</th>
		                <th>신상이동유형</th>
		                <th>등록일자</th>
		            </tr>
		        </thead>
		        <tbody>
		            <c:choose>
						<c:when test="${not empty transferList}">
							<c:forEach items="${transferList}" var="list" varStatus="state">
					            <tr>
					                <td>${list.RNUM}</td>
					                <td>${list.TRNS_SN}</td>
					                <td>${list.TRNS_STS_NM}</td>
					                <td><a href="javascript:fn_Detail('${list.TRNS_SN}','${list.TRNS_STS}');" class="tit">${list.APPL_NM}</a></td>
					                <td>${list.BRTH_DT}</td>
					                <td>${list.MEMORG_NM}</td>
					                <td>${list.GAME_NM}</td>
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
				                	<td>${list.TRNS_DV_NM}</td>
					                <td>
					                <c:if test="${list.UPDT_DTM eq '' or list.UPDT_DTM eq null}">
					                	${list.REG_DTM}
					                </c:if>
										${list.UPDT_DTM}
					                </td>
					            </tr>
		            		</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="10" class="blank">검색결과가 존재하지 않습니다.</td></tr>
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

<!-- 등록 & 수정 팝업영역 -->
<form method="post" id="dFrm" name="dFrm" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<input type="hidden" name="APPL_SN" value="">
	<input type="hidden" name="TRNS_SN" value="">
	<input type="hidden" name="TRNS_STS" value="">
	<input type="hidden" name="TRNS_DV" value="">
	<input type="hidden" name="UPDT_DTM" value="">
	<input type="hidden" name="REG_DTM" value="">
	
	<div class="cpt-popup reg03 add"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            신상이동신청
	            <button class="pop-close" onclick="addPopClose();">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
	            <div class="process-status">처리상태 : <b class="t-blue" id="dFrmTxtDiv">신규작성</b></div>
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
	                            <td class="t-title">이름</td>
	                            <td class="input-td">
	                            	<div class="search-box">
	                            		<input type="text" name="APPL_NM" value="" readonly>
	                            		<button type="button" onclick="fn_searchPersonPopupOpen();">찾기</button>
                            		</div>
	                            </td>
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td"><input type="text" name="MLTR_ID" value="" class="ip-title" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일</td>
	                            <td class="input-td">
	                            	<input id="datepicker3" name="BRTH_DT" type="text" class="datepick"  value="" maxlength="8" readonly autocomplete="off">
	                            </td>
	                            <td class="t-title">주소</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="ADDR" value="" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="EMAIL" value="" readonly></td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td"><input type="text" name="CP_NO"  value="" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="GAME_NM" value="" readonly></td>
	                            <td class="t-title">체육단체</td>
	                            <td class="input-td"><input type="text" class="ip-title" name="MEMORG_NM" value="" readonly></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">신상이동신청내용</div>
	            <div class="com-table">
	                <table class="table-board">
		                <caption></caption>
	                    <colgroup>
	                        <col style="width:auto;">
	                        <col style="width:auto;">
	                        <col style="width:auto;">
	                    </colgroup>
	                    <tbody id="ckb">
		                	<tr> 
		                		<td style="text-align:center;">
       					            <input id="change1" name="transferType" type="checkbox" value="T1" class="" checked="checked" style="display:none;">
									<label for="change1">소속변경</label>
		                		</td>
		                		<td style="text-align:center;">
       					            <input id="change2" name="transferType" type="checkbox" value="T2" class="t-title" style="display:none;">
									<label for="change2">형 선고</label>
		                		</td>
		                		<td style="text-align:center;">
       					            <input id="change3" name="transferType" type="checkbox" value="T3" class="t-title" style="display:none;">
									<label for="change3">인적사항</label>
		                		</td>
		                	</tr>
	                	</tbody>
	                </table>
                </div>
	            <div id="T1Box">
		            <div class="com-h3 add"> ▶소속변경</div>
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
		                            <td colspan="2" class="t-title">변경 전</td>
		                            <td colspan="2" class="t-title">변경 후</td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">소속</td>
		                            <td class="input-td"><input type="text" class="ip-title" name="TEAM_NM"  value="" readonly></td>
		                            <td class="t-title">소속<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="MLTR_ORG_TRNS_AFTR"  value=""></td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">국가</td>
		                            <td class="input-td"><input type="text" class="ip-title" name="TM_NTN"  value="" readonly></td>
		                            <td class="t-title">국가<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="CHANGE_NATION"  value=""></td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">변경사유<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="CHANGE_REASON"  value=""></td>
		                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<input id="datepicker4" name="PSITN_CHANGE_DT" type="text" class="datepick"  value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" autocomplete="off" readonly>
		                            </td>
		                        </tr>
		                        <tr>
	                       			<td class="t-title" colspan="4">
	                       			<div class="float-l">첨부파일<span class="t-red"> ※ 첨부파일 필요항목 : 이적확인서, 경력증명서, 재직(재학)증명서 등을 첨부합니다.</span></div>
	                       			<div class="float-r">
	                       			<button class="btn red rmvcrr userDv2" type="button" onclick="window.open('${pageContext.request.contextPath}/common/docs/신상이동제출서류.zip')">서류 다운로드</button>
	                       			</div>
	                       			</td>
		                       </tr>
		                       <tr id="T1fileTbody">
									<td colspan="3" class="adds bdr-0 input-td">
										<div class="fileBox">
											<input type="text" class="fileName2" readonly="readonly">
											<label for="uploadBtn0_T1" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>
											<input type="file" name="T1file" id="uploadBtn0_T1" class="uploadBtn2">
											<input type="hidden" name="ATCH_FILE_ID1" id="ATCH_FILE_ID1">
										</div>
									</td>
									<td class="bdl-0 pdr-0 ft-0">
										<button class="btn lightgrey addfile mrg-5" type="button" onclick="fn_addFile(this, 'T1');"></button>
									</td>
								</tr>
		                    </tbody>
		                </table>
		            </div>
	            </div>
	            <div id="T2Box">
	             	<div class="com-h3 add"> ▶징역•금고 • 구류 형 선고</div>
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
		                            <td class="t-title">형 구분<span class="t-red"> *</span></td>
		                            <td class="input-td">
			                            <select class="tab-sel" title="형 구분" name="ADJU_DV">
			                        	 	<option value="">전체</option>
												<c:forEach items="${adjuNmList}" var="subLi">
													<option value="${subLi.ALT_CODE}">${subLi.CNTNT_FST}</option>
												</c:forEach> 
										</select>
		                            </td>
		                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<input id="datepicker8" name="ADJU_CHANGE_DT" type="text" class="datepick"  value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" autocomplete="off" readonly>
		                            </td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">주요내용<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="ADJU_CONTENTS"  value=""></td>
		                        </tr>
		                        <tr>
		                       		<td class="t-title" colspan="4">첨부파일</td>
		                       </tr>
		                       <tr id="T2fileTbody">
									<td colspan="3" class="adds bdr-0 input-td">
										<div class="fileBox">
											<input type="text" class="fileName2" readonly="readonly">
											<label for="uploadBtn0_T2" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>
											<input type="file" name="T2file" id="uploadBtn0_T2" class="uploadBtn2">
											<input type="hidden" name="ATCH_FILE_ID2" id="ATCH_FILE_ID2">
										</div>
									</td>
									<td class="bdl-0 pdr-0 ft-0">
										<button class="btn lightgrey addfile mrg-5" type="button" onclick="fn_addFile(this, 'T2');"></button>
									</td>
								</tr>
		                    </tbody>
		                </table>
		            </div>
	            </div>
	            <div id="T3Box">
		            <div class="com-h3 add"> ▶인적사항 변경</div>
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
		                            <td colspan="2" class="t-title">변경 전</td>
		                            <td colspan="2" class="t-title">변경 후</td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">이름</td>
		                            <td class="input-td"><input type="text" class="ip-title" name="APPL_NM"  value="" readonly></td>
		                            <td class="t-title">이름<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="TRNS_NM"  value=""></td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">주소</td>
		                            <td class="input-td">
			                            <input type="text" class="ip-title" id="ZIP" name="ZIP" value="" readonly>
		                            	<input type="text" class="ip-title" id="ADDR" name="ADDR" value="" readonly>
		                            </td>	
		                            <td class="t-title">주소<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<button class="btn navy rmvcrr" type="button" onclick="jusoSearch();return false;">주소검색</button>
		                            	<input type="text" class="ip-title" id="TRNS_ZIP" name="TRNS_ZIP" value="" readonly>
		                            	<input type="text" class="ip-title" id="TRNS_ADDR" name="TRNS_ADDR" value="" readonly>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">휴대폰</td>
		                            <td class="input-td"><input type="text" name="CP_NO"  value="" readonly></td>
		                            <td class="t-title">휴대폰<span class="t-red"> *</span></td>
	                            	<td class="input-td"><input type="text" name="TRNS_CP_NO"  maxlength="11" value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">이메일</td>
		                            <td class="input-td"><input type="text" class="ip-title" name="EMAIL"  value="" readonly></td>
		                            <td class="t-title">이메일<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="email" class="ip-title" name="TRNS_EMAIL" value=""></td>
		                        </tr>
		                         <tr>
		                            <td class="t-title">관할 병무청</td>
		                            <td class="input-td"><input type="text" class="ip-title" name="CTRL_MMA_NM"  value="" readonly></td>
		                            <td class="t-title">관할 병무청<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<select class="tab-sel" title="관할병무청 선택" name="CHANGE_CTRL_MMA">
					                        <option value="">전체</option>
											<c:forEach items="${insptMltrAdmnList}" var="subli">
												<option value="${subli.ALT_CODE}">${subli.CNTNT_FST}</option>
											</c:forEach>
					                    </select>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td class="t-title">변경사유<span class="t-red"> *</span></td>
		                            <td class="input-td"><input type="text" class="ip-title" name="HNINFO_CHANGE_PRVONSH"  value=""></td>
		                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
		                            <td class="input-td">
		                            	<input id="datepicker9" name="HNINFO_CHANGE_PNTTM" type="text" class="datepick"  value="" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" autocomplete="off" readonly>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
	            </div>
	            <div id="gdDivD" style="display:none;">
					<div class="com-h3 add">공단 접수내역</div>
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
									<td class="input-td" id="ACPT_UPD_DTM"></td>
									<td class="t-title">처리결과</td>
									<td id="transferStsTxtKdTdD"></td>
								</tr>
								<tr>
									<td class="t-title">비고</td>
									<td colspan="3" class="input-td" id="DSPS_PRVONSH"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="com-btn-group put">
	                <div class="float-r">
	                    <button class="btn red rmvcrr userDv2" type="button" onclick="fn_save('TP');">임시저장</button>
	                    <button class="btn red rmvcrr userDv2" type="button" onclick="fn_save('TA');">신청</button>
	                    <button class="btn red rmvcrr userDv2" type="button" id="delBt" onclick="fn_delete();">삭제</button>
	                    <button class="btn navy rmvcrr userDv2" type="button" onclick="addPopClose();">닫기</button>
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
					<button class="btn red write" type="button" onclick="fn_popPersonSearch();">검색</button>
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
					<button class="btn grey write" type="button" onclick="fn_searchPersonPopupClose();">취소</button>
					<button class="btn navy write" type="button" onclick="fn_confirmPerson();">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->



<!-- 조회 & 접수처리 팝업영역 -->
<div class="cpt-popup reg03 select"> <!-- class:active 팝업 on/off -->
    <div class="dim"></div>
    <div class="popup">
        <div class="pop-head">
            신상이동신청
            <button class="pop-close" onclick="selectPopClose();">
                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
            </button>
        </div>
        <div class="pop-body">
            <div class="process-status">처리상태 : <b class="t-blue" id="sFrmTxtDiv">신청</b></div>
            <div class="com-h3 add">대상자 인적사항 </div>
              	<form method="post" id="sFrm" name="sFrm" enctype="multipart/form-data" onsubmit="return false;">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
					<input type="hidden" name="TRNS_SN" value="">
					<input type="hidden" name="APPL_SN" value="">
					<input type="hidden" name="TRNS_STS" value="">
					<input type="hidden" name="TRNS_DV" value="">
					<input type="hidden" name="UPDT_DTM" value="">
					<input type="hidden" name="REG_DTM" value="">
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
                            <td class="input-td" id="APPL_NM"></td>
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
                            <td class="input-td" id="GAME_NM"></td>
                            <td class="t-title">체육단체</td>
                            <td class="input-td" id="MEMORG_NM"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="com-h3 add">신상이동신청내용</div>
            <div id="T1Box">
	            <div class="com-h3 add"> ▶소속변경</div>
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
	                            <td colspan="2" class="t-title">변경 전</td>
	                            <td colspan="2" class="t-title">변경 후</td>
	                        </tr>
	                         <tr>
	                            <td class="t-title">소속</td>
	                            <td class="input-td" id="TEAM_NM"></td>
	                            <td class="t-title">소속<span class="t-red"> *</span></td>
	                            <td class="input-td" id="MLTR_ORG_TRNS_AFTR"></td>
	                        </tr>
	                         <tr>
	                            <td class="t-title">국가</td>
	                            <td class="input-td" id="TM_NTN"></td>
	                            <td class="t-title">국가<span class="t-red"> *</span></td>
	                            <td class="input-td" id="CHANGE_NATION"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">변경사유<span class="t-red"> *</span></td>
	                            <td class="input-td" id="CHANGE_REASON"></td>
	                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
	                            <td class="input-td" id="PSITN_CHANGE_DT"></td>
	                        </tr>
	                        <tr>
	                       		<td class="t-title" colspan="4">첨부파일</td>
	                        </tr>
	                        <tr id="T1sFileTbody">
								
							</tr>
	                    </tbody>
	                </table>
	            </div>
            </div>
            <div id="T2Box">
             	<div class="com-h3 add"> ▶징역•금고 • 구류 형 선고</div>
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
	                            <td class="t-title">형 구분<span class="t-red"> *</span></td>
	                            <td class="input-td" id="ADJU_DV"></td>
	                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
	                            <td class="input-td" id="ADJU_CHANGE_DT"></td>
	                        </tr>
	                         <tr>
	                            <td class="t-title">주요내용<span class="t-red"> *</span></td>
	                            <td class="input-td" id="ADJU_CONTENTS"></td>
	                        </tr>
	                        <tr>
	                       		<td class="t-title" colspan="4">첨부파일</td>
	                        </tr>
	                        <tr id="T2sFileTbody">
								
							</tr>
	                    </tbody>
	                </table>
	            </div>
            </div>
            <div id="T3Box">
	            <div class="com-h3 add"> ▶인적사항 변경</div>
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
	                            <td colspan="2" class="t-title">변경 전</td>
	                            <td colspan="2" class="t-title">변경 후</td>
	                        </tr>
	                         <tr>
	                            <td class="t-title">이름</td>
	                            <td class="input-td" id="APPL_NM"></td>
	                            <td class="t-title">이름<span class="t-red"> *</span></td>
	                            <td class="input-td" id="TRNS_NM"></td>
	                        </tr>
	                        <tr>
	                            <td rowspan="2" class="t-title">주소</td>
	                            <td class="input-td" id="ZIP"></td>
	                            <td rowspan="2" class="t-title">주소<span class="t-red"> *</span></td>
	                            <td class="input-td" id="TRNS_ZIP"></td>
	                        </tr>
	                         <tr>
	                            <td class="input-td" id="ADDR"></td>
	                            <td class="input-td" id="TRNS_ADDR"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td" id="CP_NO"></td>
	                            <td class="t-title">휴대폰<span class="t-red"> *</span></td>
                            	<td class="input-td" id="TRNS_CP_NO"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td" id="EMAIL"></td>
	                            <td class="t-title">이메일<span class="t-red"> *</span></td>
	                            <td class="input-td" id="TRNS_EMAIL"></td>
	                        </tr>
	                         <tr>
	                            <td class="t-title">관할 병무청</td>
	                            <td class="input-td" id="CTRL_MMA_NM"></td>
	                            <td class="t-title">관할 병무청<span class="t-red"> *</span></td>
	                            <td class="input-td" id="CHANGE_CTRL_MMA"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">변경사유<span class="t-red"> *</span></td>
	                            <td class="input-td" id="HNINFO_CHANGE_PRVONSH"></td>
	                            <td class="t-title">적용일자<span class="t-red"> *</span></td>
	                            <td class="input-td" id="HNINFO_CHANGE_PNTTM"></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
            </div>
            </form>
            
			<!-- 공단 담당자 일때만 활성 -->
			<div id="gdDiv"  style="display:none;">
				<form id="gFrm">
					<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
					<input type="hidden" name="TRNS_SN" value="">
					<input type="hidden" name="TRNS_STS" value="">
				
					<div class="com-h3 add">공단 접수내역
						<div class="right-area">
							<p class="required" id="rqd">필수입력</p>
							<button class="btn red type01 receipt" type="button" onclick="fn_transferConfirm('KY');" id="btnKdConfirmY">접수처리</button>
							<button class="btn red type01 receipt" type="button" onclick="fn_transferConfirm('KN');" id="btnKdConfirmN">접수반려</button>
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
									<td class="t-title">처리일자</td>
									<td class="input-td" id="ACPT_UPD_DTM"></td>
									<td class="t-title">처리결과</td>
									<td id="transferStsTxtKdTd"></td>
								</tr>
								<tr>
									<td class="t-title">비고<span class="t-red"> *</span></td>
									<td colspan="3" class="input-td"><textarea rows="5" name="DSPS_PRVONSH"></textarea></td>
								</tr>
							</tbody>
						</table>
					</div>
				</form>
			</div>

			<div class="com-helf" id="lastUpdateDiv" style="display:none;">
				<ol>
					<li id="lastUpdateLi"></li>
				</ol>
			</div>
            
            <div class="com-btn-group put">
                <div class="float-r">
                    <button class="btn navy rmvcrr userDv2" type="button" onclick="selectPopClose();">닫기</button>
                </div>
            </div>
            
        </div>
    </div>
</div>

<!-- //팝업영역 -->


