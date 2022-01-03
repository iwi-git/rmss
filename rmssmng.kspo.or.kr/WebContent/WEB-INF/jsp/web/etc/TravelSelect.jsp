<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		//datepicker start
		$("#datepicker, #datepicker1, #datepicker2, #datepicker3, #datepicker6, #datepicker7").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
		if($("#frm input[name=STD_YMD]").val()!= "" && $("#frm input[name=END_YMD]").val() != ""){
			$("#datepicker").datepicker('option','maxDate',$("#frm input[name=END_YMD]").val());
			$("#datepicker1").datepicker('option','minDate',$("#frm input[name=STD_YMD]").val());
		}

		if($("#mfrm input[name=TRVL_START_DT]").val()!= "" && $("#mfrm input[name=TRVL_END_DT]").val() != ""){
			$("#datepicker2").datepicker('option','maxDate',$("#mfrm input[name=TRVL_END_DT]").val());
			$("#datepicker3").datepicker('option','minDate',$("#mfrm input[name=TRVL_START_DT]").val());
		}
		
		$(document).on("change","#datepicker",function(){
			$("#datepicker1").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker").datepicker('option','maxDate',$(this).val());
		});

		$(document).on("change","#datepicker2",function(){
			$("#datepicker3").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker3",function(){
			$("#datepicker2").datepicker('option','maxDate',$(this).val());
		});
		//datepicker end
		

	});

	//엑셀다운로드
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#frm").attr("action","/etc/TravelSelectDownload.kspo");
		$("#frm").submit();
	}
	
	//체육요원 편입신청 신규 팝업 오픈
	function travelAddOpen(){
		
		$("#mFrm .t-blue").text('신규');
		$("#fnDelete").hide();
		$(".travelAdd").addClass("active")
		$("body").css("overflow", "auto")
		
	}
	
	//체육요원 국외여행관리 신청 팝업 닫기
	function travelAddClose() {
		fn_search();
		$(".travelAdd").removeClass("active")
		$("body").css("overflow","hidden")
	}

	//체육요원 국외여행관리 상세 팝업 열기
	function selectPopOpen(){
		$(".travelSelect").addClass("active")
		$("body").css("overflow", "auto")
	}
	
	//체육요원 국외여행관리 상세팝업 닫기
	function selectPopClose() {
		fn_search();
		$(".travelSelect").removeClass("active")
		$("body").css("overflow","hidden")
	}
	
	//상세조회
	function fn_Detail(TRVL_SN,TRVL_STS){
		var param = "TRVL_SN=" + TRVL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/selectTravelDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var dtl = $json.responseJSON.detail;
			var travelInfo = $json.responseJSON.travelInfo;

			var grpSn = "${sessionScope.userMap.GRP_SN}";
			
			if(dtl == null){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			if(dtl.TRVL_STS == 'TP'){
				$("#trvlDel").show();
			}else{
				$("#trvlDel").hide();
			}
			if(dtl.TRVL_STS == 'TP' && grpSn == '2'){

				travelAddOpen();
				
				$('#mFrm input[name=TRVL_SN]').val(dtl.TRVL_SN);
				$('#mFrm input[name=APPL_SN]').val(dtl.APPL_SN);
				$('#mFrm input[name=MLTR_ID]').val(dtl.MLTR_ID);
				$('#mFrm input[name=APPL_NM]').val(dtl.APPL_NM);
				$('#mFrm input[name=TRVL_STS]').val(dtl.TRVL_STS);
				$('#mFrm input[name=ATCH_FILE_ID1]').val(dtl.ATCH_FILE_ID1);
				$('#mFrm td[id=MLTR_ID]').html(dtl.MLTR_ID);
				$('#mFrm td[id=BRTH_DT]').html(dtl.BRTH_DT);
				$('#mFrm td[id=ADDR]').html(dtl.ADDR);
				$('#mFrm td[id=EMAIL]').html(dtl.EMAIL);
				$('#mFrm td[id=CP_NO]').html(dtl.CP_NO);
				$('#mFrm td[id=GAME_CD_NM]').html(dtl.GAME_CD_NM);
				$('#mFrm td[id=MEMORG_NM]').html(dtl.MEMORG_NM);
				$('#mFrm td[id=TEAM_NM]').html(dtl.TEAM_NM);
				$('#mFrm td[id=CTRL_MMA_CD]').html(dtl.CTRL_MMA_CD);
				$("#mFrm .t-blue").text(dtl.TRVL_STS_NM);
				
				var travelInfoObj = "";
				//대상자 인적사항 시작
				if(travelInfo.length > 0){
					for(var i=0;i<travelInfo.length;i++){
						travelInfoObj += "<tr>";
						travelInfoObj += "<td>";
						travelInfoObj += "<div class='input-box'>";
						travelInfoObj += "<input type=\"checkbox\" name=\"checkGrp\" id=\"checkPerson" + i + "\" value=\"" + travelInfo[i].RECD_SN + "\">";
						travelInfoObj += "<label for=\"checkPerson" + i + "\" class=\"chk-only\">선택</label>";
						travelInfoObj += "</div>";
						travelInfoObj += "</td>";
						travelInfoObj += "<td><a href='javascript:fn_travelDtl(\""+ travelInfo[i].RECD_SN +"\",\"m\",\"" + travelInfo[i].TRVL_STS +"\")'>"+ travelInfo[i].TRVL_APPL_DV +"</a></td>";
						travelInfoObj += "<td id='TRVL_STS_NM'>"+ travelInfo[i].TRVL_STS_NM +"</td>";
						travelInfoObj += "<td id='TRVL_NATION'>"+ travelInfo[i].TRVL_NATION +"</td>";
						travelInfoObj += "<td id='TRVL_START_DT'>"+ travelInfo[i].TRVL_START_DT +"</td>";
						travelInfoObj += "<td id='TRVL_END_DT'>"+ travelInfo[i].TRVL_END_DT +"</td>";
						travelInfoObj += "<td id='TRVL_GOAL'>"+ travelInfo[i].TRVL_GOAL +"</td>";
						travelInfoObj += "</tr>";
					}
				}else{
					travelInfoObj += "<tr>";
					travelInfoObj += "<td colspan='7' class='center'>등록된 게시물이 없습니다.</td>";
					travelInfoObj += "</tr>";
				}
				$("#iTbody").html(travelInfoObj);
				
				
				$("#personSearch").hide();
				$("#fnDelete").show();
				
				if(dtl.TRVL_STS == 'KC' || dtl.TRVL_STS == 'KN'){
					$(".t-title.name").text("공단반려사유");
					$(".applReasons").text(dtl.RECEIPT_REASON);
					$("#fnDelete").hide();
				}
				
			}else{
				
				$('#sFrm .file-table.uploadBtn2').hide();
				$('#sFrm textarea[name=RECEIPT_REASON]').attr('readonly', false);
				$('#sFrm textarea[name=DSPTH_REASON]').attr('readonly', false);

				$('#sFrm input[name=TRVL_NATION]').attr('readonly', true);
				$('#sFrm input[name=TRVL_START_DT]').attr('readonly', true);
				$('#sFrm input[name=TRVL_END_DT]').attr('readonly', true);
				$('#sFrm input[name=TRVL_GOAL]').attr('readonly', true);
				$('#sFrm input[name=EXTN_REASON]').attr('readonly', true);
				$('#sFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', true);
				
				selectPopOpen();
				$(".btn.navy.rmvcrr.fnDelete").hide();
				$('#sFrm input[name=TRVL_SN]').val(dtl.TRVL_SN);
				$('#sFrm input[name=APPL_SN]').val(dtl.APPL_SN);
				$('#sFrm input[name=TRVL_STS]').val(dtl.TRVL_STS);
				$('#sFrm input[name=MLTR_ID]').val(dtl.MLTR_ID);
				$('#sFrm input[name=APPL_NM]').val(dtl.APPL_NM);
				$("#sFrm #RECEIPT_DTM").html(dtl.RECEIPT_DTM);
				$("#sFrm #DSPTH_DTM").html(dtl.DSPTH_DTM);
				$('#sFrm textarea[name=RECEIPT_REASON]').val(dtl.RECEIPT_REASON);
				$('#sFrm textarea[name=DSPTH_REASON]').val(dtl.DSPTH_REASON);
				$('#sFrm input[name=ATCH_FILE_ID5]').val(dtl.ATCH_FILE_ID5);

				$('#sFrm #ATCH_FILE_ID1').text(dtl.ATCH_FILE_NM1);
				
				$('#sFrm td[id=MLTR_ID]').html(dtl.MLTR_ID);
				$('#sFrm td[id=BRTH_DT]').html(dtl.BRTH_DT);
				$('#sFrm td[id=ADDR]').html(dtl.ADDR);
				$('#sFrm td[id=EMAIL]').html(dtl.EMAIL);
				$('#sFrm td[id=CP_NO]').html(dtl.CP_NO);
				$('#sFrm td[id=GAME_CD_NM]').html(dtl.GAME_CD_NM);
				$('#sFrm td[id=MEMORG_NM]').html(dtl.MEMORG_NM);
				$('#sFrm td[id=TEAM_NM]').html(dtl.TEAM_NM);
				$('#sFrm td[id=CTRL_MMA_CD]').html(dtl.CTRL_MMA_CD);
				$("#sFrm .t-blue").text(dtl.TRVL_STS_NM);
				$("#sFrm .uName").text("Last Update. "+dtl.UPDR_NM+" / "+dtl.UPDT_DT);
				$("#sFrm .travel.result").text(dtl.TRVL_STS_NM);
				
				var travelInfoObj = "";
				//대상자 인적사항 시작
				if(travelInfo.length > 0){
					for(var i=0;i<travelInfo.length;i++){
						travelInfoObj += "<tr>";
						travelInfoObj += "<td>";
						travelInfoObj += "<div class='input-box'>";
						travelInfoObj += "<input type='checkbox' name='checkGrp' id='checkPerson" + i + "' value='" + travelInfo[i].RECD_SN + "'>";
						travelInfoObj += "<label for='checkPerson" + i + "' class='chk-only'>선택</label>";
						travelInfoObj += "</div>";
						travelInfoObj += "</td>";
						travelInfoObj += "<td><a href='javascript:fn_travelDtl(\""+ travelInfo[i].RECD_SN +"\",\"s\",\"" + travelInfo[i].TRVL_STS +"\")'>"+ travelInfo[i].TRVL_APPL_DV +"</a></td>";
						travelInfoObj += "<td id='TRVL_STS_NM'>"+ travelInfo[i].TRVL_STS_NM +"</td>";
						travelInfoObj += "<td id='TRVL_NATION'>"+ travelInfo[i].TRVL_NATION +"</td>";
						travelInfoObj += "<td id='TRVL_START_DT'>"+ travelInfo[i].TRVL_START_DT +"</td>";
						travelInfoObj += "<td id='TRVL_END_DT'>"+ travelInfo[i].TRVL_END_DT +"</td>";
						travelInfoObj += "<td id='TRVL_GOAL'>"+ travelInfo[i].TRVL_GOAL +"</td>";
						travelInfoObj += "</tr>";
					}
				}else{
					travelInfoObj += "<tr>";
					travelInfoObj += "<td colspan='6' class='center'>등록된 게시물이 없습니다.</td>";
					travelInfoObj += "</tr>";
				}
				$("#sTbody").html(travelInfoObj);
				
				//첨부파일
				var acptFileObj = "";
					acptFileObj += '<td class="t-title">첨부파일</td>';
					if(dtl.TRVL_STS == "MY" || dtl.TRVL_STS == "MN" || dtl.TRVL_STS == 'KC' || dtl.TRVL_STS == 'KN' || grpSn == '2'){
						acptFileObj += '<td class="input-td" colspan="3"><a href="javascript:fnDownloadFile('+dtl.ATCH_FILE_ID5+')"><span class="file-name">'+ dtl.ATCH_FILE_NM5 +'</span></a></td>';
					}else{
						acptFileObj += '<td colspan="3" class="input-td">';
						acptFileObj += '<div class="fileBox">';
						acptFileObj += '<input type="text" class="fileName2" readonly="readonly">';
						acptFileObj += '<input type="file" name="file" id="file01" class="file-table uploadBtn2">';
						acptFileObj += '<label for="file01" class="btn red rmvcrr file-btn">파일선택</label>';
						acptFileObj += '</div>';
						acptFileObj += '</td>';
					}
					
				$("#acptFile").html(acptFileObj);
				
				
				if(dtl.TRVL_STS == 'AP'){ //신청시엔 삭제가능
					$(".btn.navy.rmvcrr.fnDelete").show();
					$(".com-h3.add.acpt").hide();
					$(".com-table.acpt").hide();
					$(".cancel").hide();
					$(".userDv1").hide();
				
				}else if(dtl.TRVL_STS == 'KY'){
					$(".receipt").hide();
					$('#sFrm textarea[name=RECEIPT_REASON]').attr('readonly', true);
					
				}
				
				if(dtl.TRVL_STS == 'MY' || dtl.TRVL_STS == 'MN' || dtl.TRVL_STS == 'KC' || dtl.TRVL_STS == 'KN'){  
					$(".userDv1").hide();
					$(".cancel").hide();
					$(".receipt").hide();
					
					$('#sFrm textarea[name=RECEIPT_REASON]').attr('readonly', true);
					$('#sFrm textarea[name=DSPTH_REASON]').attr('readonly', true);
				}

				if(grpSn == '2'){
					
					$('#sFrm textarea[name=RECEIPT_REASON]').attr('readonly', true);
					$('#sFrm textarea[name=DSPTH_REASON]').attr('readonly', true);
				}
				
			}
			
		}
	}
	
	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker").val(), $("#datepicker1").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/etc/TravelSelect.kspo",$("#frm").serialize());
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
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/etc/selectTravelPersonJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var personInfo = $json.responseJSON.personInfo;
			var travelInfo = $json.responseJSON.travelInfo;
			var htmlStr = "";
			
			if(!personInfo){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			
			$('#mFrm input[name=APPL_SN]').val(personInfo.APPL_SN);
			$('#mFrm input[name=MLTR_ID]').val(personInfo.MLTR_ID);
			$('#mFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
			$('#mFrm td[id=MLTR_ID]').html(personInfo.MLTR_ID);
			$('#mFrm td[id=BRTH_DT]').html(personInfo.BRTH_DT);
			$('#mFrm td[id=ADDR]').html(personInfo.ADDR);
			$('#mFrm td[id=EMAIL]').html(personInfo.EMAIL);
			$('#mFrm td[id=CP_NO]').html(personInfo.CP_NO);
			$('#mFrm td[id=GAME_CD_NM]').html(personInfo.GAME_CD_NM);
			$('#mFrm td[id=MEMORG_NM]').html(personInfo.MEMORG_NM);
			$('#mFrm td[id=TEAM_NM]').html(personInfo.TEAM_NM);
			$('#mFrm td[id=CTRL_MMA_CD]').html(personInfo.CTRL_MMA_CD);
			$('#mFrm td[id=MEMORG_NM]').html(personInfo.MEMORG_NM);
			
			
			var travelInfoObj = "";
			//대상자 인적사항 시작
			if(travelInfo.length > 0){
				for(var i=0;i<travelInfo.length;i++){
					travelInfoObj += "<tr>";
					travelInfoObj += "<td>";
					travelInfoObj += "<div class='input-box'>";
					travelInfoObj += "<input type=\"checkbox\" name=\"checkGrp\" id=\"checkPerson" + i + "\" value=\"" + travelInfo[i].RECD_SN + "\">";
					travelInfoObj += "<label for=\"checkPerson" + i + "\" class=\"chk-only\">선택</label>";
					travelInfoObj += "</div>";
					travelInfoObj += "</td>";
					travelInfoObj += "<td><a href='javascript:fn_travelDtl(\""+ travelInfo[i].RECD_SN +"\",\"m\",\"" + travelInfo[i].TRVL_STS +"\")'>"+ travelInfo[i].TRVL_APPL_DV +"</a></td>";
					travelInfoObj += "<td>"+ travelInfo[i].TRVL_STS_NM +"</td>";
					travelInfoObj += "<td>"+ travelInfo[i].TRVL_NATION +"</td>";
					travelInfoObj += "<td>"+ travelInfo[i].TRVL_START_DT +"</td>";
					travelInfoObj += "<td>"+ travelInfo[i].TRVL_END_DT +"</td>";
					travelInfoObj += "<td>"+ travelInfo[i].TRVL_GOAL +"</td>";
					travelInfoObj += "</tr>";
				}
			}else{
				travelInfoObj += "<tr>";
				travelInfoObj += "<td colspan='7' class='center'>등록된 게시물이 없습니다.</td>";
                   travelInfoObj += "</tr>";
			}
			$("#iTbody").html(travelInfoObj);
			
			
			fn_searchPersonPopupClose();
		}
		
	}
	
	//국외여행 여행정보 추가
	function trvl_add(){
		
		if($("#mFrm input[name=APPL_NM]").val() == "" || $("#mFrm input[name=APPL_NM]").val() == null){
			fnAlert("체육요원을 검색해 주시기 바랍니다.");
			return ;
		}
		
		$('#mFrm input[name=RECD_SN]').val("");
		
		//추가를 누를시 신청구분은 자동신규신청이고 연장신청 버튼 안됨 
 		$('#mFrm input:radio[name=TRVL_APPL_DV][value="NW"]').prop('checked',true);
 		$('#mFrm input:radio[name=TRVL_APPL_DV][value="NW"]').prop('disabled',false);
 		$('#mFrm input:radio[name=TRVL_APPL_DV][value="EX"]').prop('disabled',true);
 		
		$('#mFrm input[name=TRVL_NATION]').attr('readonly', false);
		$('#mFrm input[name=TRVL_NATION]').attr('readonly', false);
		$('#mFrm input[name=TRVL_GOAL]').attr('readonly', false);
		$('#mFrm input[name=EXTN_REASON]').attr('readonly', false);
		$('#mFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', false);

		$('#mFrm input[name=TRVL_NATION]').val('');
		$('#mFrm input[name=TRVL_START_DT]').val('');
		$('#mFrm input[name=TRVL_END_DT]').val('');
		$('#mFrm input[name=TRVL_GOAL]').val('');
		$('#mFrm input[name=EXTN_REASON]').val('');
		$('#mFrm textarea[name=BGNN_GRNT_INFO]').val('');
		
		$("#fileDtl").remove();
	}

	//국외여행 여행정보 삭제
	function trvl_del(){
		
		if($("#mFrm input[name=APPL_NM]").val() == "" || $("#mFrm input[name=APPL_NM]").val() == null){
			fnAlert("체육요원을 검색해 주시기 바랍니다.");
			return ;
		}

		var checkedCnt = $('#mFrm input[name=checkGrp]:checked').length;

		if(checkedCnt < 1){
			fnAlert("하나의 체크박스만 선택해주세요.");
			return false;
		}
		
		if(checkedCnt > 1){
			fnAlert("하나의 체크박스만 선택해주세요.");
			return false;
		}
		
		var RECD_SN = $('#mFrm input[name=checkGrp]:checked').val();
		
		if(RECD_SN == ''){
			fnAlert("선택된 여행상세 정보가 올바르지 않습니다. 문의 부탁드립니다.");
			return false;
		}
		
		var param = "RECD_SN=" + RECD_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/deleteTravelRecdJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			fnAlert("삭제되었습니다.");
			
			var param = "&gMenuSn=" + $("mFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
			
		}
		
	}

	//저장
	function fn_save(TRVL_STS){
	
		if(fn_saveValid()){
		
			var saveUrl = "/etc/updateTravelJs.kspo";
			if($("#mFrm input[name=TRVL_SN]").val() == "" || $("#mFrm input[name=TRVL_SN]").val() == null || $("#mFrm input[name=TRVL_STS]").val() == "KC" || $("#mFrm input[name=TRVL_STS]").val() == "KN"){
				saveUrl = "/etc/insertTravelJs.kspo";
			}
		
			$("#mFrm input[name=TRVL_STS]").val(TRVL_STS);
		
			var $json = getJsonMultiData( saveUrl, "mFrm");	
			
			if($json.statusText == "OK"){
				
				fnAlert("저장되었습니다.");

				var param = "&gMenuSn=" + $("mFrm input[name=gMenuSn]").val();
				fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
				
					
			}
		}
	
	}
	
	//벨리데이션 체크
	function fn_saveValid(){
	
		if($("#mFrm input[name=APPL_NM]").val() == "" || $("#mFrm input[name=APPL_NM]").val() == null){
			fnAlert("체육요원을 검색해 주시기 바랍니다.");
			return ;
		}
		
		//여행목적
		if($("#mFrm input[name=TRVL_APPL_DV]:checked").val() != "" || $("#mFrm input[name=TRVL_APPL_DV]:checked").val() != null){
			if($("#mFrm input[name=TRVL_GOAL]").val() == "" || $("#mFrm input[name=TRVL_GOAL]").val() == null){
				fnFocAlert("여행목적을 입력하시기 바랍니다.", $("#mFrm input[name=TRVL_GOAL]"));
				return ;
			}
			
			if(fnGetByte($("#mFrm input[name=TRVL_NATION]").val())>100){
				var length = fnGetTxtLength(100);
				fnFocAlert("여행국가 길이를 초과하였습니다.<br/>(최대 " + length + "자리까지 입력가능)", $("#mFrm input[name=TRVL_NATION]"));
				return false;
			}
			
		}
		
		return true;
	}
	
	//임시저장 혹은 신청일시 삭제
	function fn_delete(){
		
		var TRVL_SN = $("#mFrm input[name=TRVL_SN]").val();
		
		if($("#mFrm input[name=TRVL_SN]").val() == null || $("#mFrm input[name=TRVL_SN]").val() == ""){
			TRVL_SN = $("#sFrm input[name=TRVL_SN]").val();
		}
		
		var param = "TRVL_SN=" + TRVL_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/deleteTravelJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			fnAlert("삭제되었습니다.");
			
			var param = "&gMenuSn=" + $("mFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
			
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
		addFileObj += '	<td colspan="3" class="adds bdr-0 input-td">';
		addFileObj += '		<div class="fileBox">';
		addFileObj += '			<input type="text" class="fileName2" readonly="readonly">';
		addFileObj += '			<label for="uploadBtn'+fileCnt+'" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>';
		addFileObj += '			<input type="file" name="file" id="uploadBtn'+fileCnt+'" class="uploadBtn2">';
		addFileObj += '		</div>';
		addFileObj += '	</td>';
		addFileObj += '	<td class="bdl-0 pdr-0 ft-0">';
		addFileObj += '		<button class="btn lightgrey removefile" type="button" onclick="fn_removeFile(this);"></button>';
		addFileObj += '	</td>';
		addFileObj += '</tr>';
		
		return addFileObj;
	}
	
	//여행정보 상세
	
	function fn_travelDtl(RECD_SN,form,TRVL_STS){
		
		var param = "RECD_SN=" + RECD_SN;
		param += "&gMenuSn=" + $("#frm input[name=gMenuSn]").val();
		var $json = getJsonData("post", "/etc/selectTravelInfoDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			
			var Detail = $json.responseJSON.travelInfoDetail;
			var fileList = $json.responseJSON.fileList;
			
			if(!Detail){
				fnAlert("오류가 발생하였습니다.");
				return false;
			}
			if(form == 'm'){
				
				//기본 초기화 
				$("#fileDtl").remove();
		 		$('#mFrm input:radio[name=TRVL_APPL_DV][value="NW"]').prop('disabled',false);
		 		$('#mFrm input:radio[name=TRVL_APPL_DV][value="EX"]').prop('disabled',false);
		 		
				$('#mFrm input[name=TRVL_NATION]').val('');
				$('#mFrm input[name=TRVL_START_DT]').val('');
				$('#mFrm input[name=TRVL_END_DT]').val('');
				$('#mFrm input[name=ATCH_FILE_ID1]').val('');
				$('#mFrm input[name=TRVL_GOAL]').val('');
				$('#mFrm input[name=EXTN_REASON]').val('');
				$('#mFrm textarea[name=BGNN_GRNT_INFO]').val('');
				$('#mFrm input[name=TRVL_APPL_DV]').attr('readonly', true);
				$('#mFrm input[name=TRVL_NATION]').attr('readonly', true);
				$('#mFrm input[name=TRVL_START_DT]').attr('readonly', true);
				$('#mFrm input[name=TRVL_END_DT]').attr('readonly', true);
				$('#mFrm input[name=TRVL_GOAL]').attr('readonly', true);
				$('#mFrm input[name=EXTN_REASON]').attr('readonly', true);
				$('#mFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', true);
				
				//기본초기화

				$("#mFrm input:radio[name=TRVL_APPL_DV][value='"+Detail.TRVL_APPL_DV+"']").prop('checked',true);
				$('#mFrm input[name=RECD_SN]').val(Detail.RECD_SN);
				$('#mFrm input[name=TRVL_NATION]').val(Detail.TRVL_NATION);
				$('#mFrm input[name=TRVL_START_DT]').val(Detail.TRVL_START_DT);
				$('#mFrm input[name=TRVL_END_DT]').val(Detail.TRVL_END_DT);
				$('#mFrm input[name=TRVL_GOAL]').val(Detail.TRVL_GOAL);
				$('#mFrm input[name=ATCH_FILE_ID1]').val(Detail.ATCH_FILE_ID1);
				$('#mFrm input[name=EXTN_REASON]').val(Detail.EXTN_REASON);
				$('#mFrm textarea[name=BGNN_GRNT_INFO]').val(Detail.BGNN_GRNT_INFO);
				
				if(TRVL_STS == "MY"){
					$("#mFrm input:radio[name=TRVL_APPL_DV][value='"+Detail.TRVL_APPL_DV+"']").prop('disabled',true);
					$('#mFrm input[name=TRVL_APPL_DV]').attr('readonly', false);
					$('#mFrm input[name=TRVL_NATION]').attr('readonly', false);
					$('#mFrm input[name=TRVL_GOAL]').attr('readonly', false);
					$('#mFrm input[name=EXTN_REASON]').attr('readonly', false);
					$('#mFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', false);
				}else if(TRVL_STS == "TP"){
					$("#mFrm input:radio[name=TRVL_APPL_DV]:not(:checked)").prop('disabled',true);
					$('#mFrm input[name=TRVL_APPL_DV]').attr('readonly', false);
					$('#mFrm input[name=TRVL_NATION]').attr('readonly', false);
					$('#mFrm input[name=TRVL_GOAL]').attr('readonly', false);
					$('#mFrm input[name=EXTN_REASON]').attr('readonly', false);
					$('#mFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', false);
				}else{
					$("#mFrm input:radio[name=TRVL_APPL_DV]:not(:checked)").prop('disabled',true);
				}
				
				//첨부파일
				var fileObj = "";
				if(fileList.length > 0){
					for(var i=0;i<fileList.length;i++) {
						fileObj += '<tr id="fileDtl">';
						fileObj += '	<td colspan="3" class="adds bdr-0 input-td">';
						fileObj += '		<a href="javascript:fnDownloadFile('+fileList[i].FILE_SN+')"><span class="file-name">'+ fileList[i].FILE_ORGIN_NM +'</span></a>';
						fileObj += "		<button class='file-del' onclick='fn_fileDel(" + fileList[i].FILE_SN + ", this)'> 삭제</button>";
						fileObj += '	</td>';
						fileObj += '	<td class="bdl-0 pdr-0 ft-0">';
						fileObj += '	</td>';
						fileObj += '</tr>';
					}
				
				}
				
				$("#fileTbody").before(fileObj);
				
			}else if(form == 's'){
				
				///기본 초기화 
				$("#fileDtl").remove();
		 		$('#sFrm input:radio[name=TRVL_APPL_DV][value="NW"]').prop('disabled',false);
		 		$('#sFrm input:radio[name=TRVL_APPL_DV][value="EX"]').prop('disabled',false);
		 		
				$('#sFrm input[name=TRVL_NATION]').val('');
				$('#sFrm input[name=TRVL_START_DT]').val('');
				$('#sFrm input[name=TRVL_END_DT]').val('');
				$('#sFrm input[name=TRVL_GOAL]').val('');
				$('#sFrm input[name=EXTN_REASON]').val('');
				$('#sFrm textarea[name=BGNN_GRNT_INFO]').val('');
				$('#sFrm input[name=TRVL_APPL_DV]').attr('readonly', true);
				$('#sFrm input[name=TRVL_NATION]').attr('readonly', true);
				$('#sFrm input[name=TRVL_START_DT]').attr('readonly', true);
				$('#sFrm input[name=TRVL_END_DT]').attr('readonly', true);
				$('#sFrm input[name=TRVL_GOAL]').attr('readonly', true);
				$('#sFrm input[name=EXTN_REASON]').attr('readonly', true);
				$('#sFrm textarea[name=BGNN_GRNT_INFO]').attr('readonly', true);
				//기본초기화
				
				$("#sFrm input:radio[name=TRVL_APPL_DV][value='"+Detail.TRVL_APPL_DV+"']").prop('checked',true);
				$('#sFrm input[name=RECD_SN]').val(Detail.RECD_SN);
				$('#sFrm input[name=TRVL_NATION]').val(Detail.TRVL_NATION);
				$('#sFrm input[name=TRVL_START_DT]').val(Detail.TRVL_START_DT);
				$('#sFrm input[name=TRVL_END_DT]').val(Detail.TRVL_END_DT);
				$('#sFrm input[name=TRVL_GOAL]').val(Detail.TRVL_GOAL);
				$('#sFrm input[name=EXTN_REASON]').val(Detail.EXTN_REASON);
				$('#sFrm textarea[name=BGNN_GRNT_INFO]').val(Detail.BGNN_GRNT_INFO);
				
				$("#sFrm input:radio[name=TRVL_APPL_DV]:not(:checked)").prop('disabled',true);
				
				//첨부파일
				var fileObj = "";
				if(fileList.length > 0){
					for(var i=0;i<fileList.length;i++) {
						fileObj += '<tr id="fileDtl">';
						fileObj += '	<td colspan="3" class="adds bdr-0 input-td">';
						fileObj += '		<a href="javascript:fnDownloadFile('+fileList[i].FILE_SN+')"><span class="file-name">'+ fileList[i].FILE_ORGIN_NM +'</span></a>';
						fileObj += '	</td>';
						fileObj += '	<td class="bdl-0 pdr-0 ft-0">';
						fileObj += '	</td>';
						fileObj += '</tr>';
					}
				
				}
				
				$("#fileTbody2").before(fileObj);
			
			}
			
		}
		
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
	
	//접수처리
	function fn_receipt(){
		$("#sFrm input[name=TRVL_STS]").val("KY");
		
		var saveUrl = "/etc/updateTravelReceiptJs.kspo";
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		
		if($json.statusText == "OK"){
			fnAlert("접수처리되었습니다.");
			
			var param = "&gMenuSn=" + $("sFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
		}
	}

	//접수반려
	function fn_receCompanion(){
		$("#sFrm input[name=TRVL_STS]").val("KN");
		
		if($("#sFrm textarea[name=RECEIPT_REASON]").val() == "" || $("#sFrm textarea[name=RECEIPT_REASON]").val() == null ){
			fnFocAlert("비고를 입력하시기 바랍니다.", $("#sFrm textarea[name=RECEIPT_REASON]"));
			return;
		}
		
		
		var saveUrl = "/etc/updateTravelReceiptJs.kspo";
		var $json = getJsonData("post", saveUrl, $("#sFrm").serialize());
		if($json.statusText == "OK"){
			fnAlert("접수반려 처리되었습니다.");
			
			var param = "&gMenuSn=" + $("sFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
		}
	
	}
	
	//문체부승인
	function fn_acptOk(){
		
		if($("#sFrm input[name=TRVL_STS]").val() == "KN"){
			fnAlert("접수처리해야 승인이 가능합니다.");
			return;	
		}

		if($("#sFrm textarea[name=DSPTH_REASON]").val() == "" || $("#sFrm textarea[name=DSPTH_REASON]").val() == null ){
			fnFocAlert("통보근거를 입력하시기 바랍니다.", $("#sFrm textarea[name=DSPTH_REASON]"));
			return;
		}
	
		$("#sFrm input[name=TRVL_STS]").val("MY");
		
		var saveUrl = "/etc/updateTravelApprovalJs.kspo";
		
		var $json = getJsonMultiData( saveUrl, "sFrm");
		if($json.statusText == "OK"){
			
			fnAlert("문체부(병무청) 승인되었습니다.");

			var param = "&gMenuSn=" + $("sFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
			
		}
	
	}

	//문체부미승인
	function fn_acptNotOk(){
		
		if($("#sFrm input[name=TRVL_STS]").val() == "KN"){
			fnAlert("접수처리해야 미승인이 가능합니다.");
			return;	
		}

		if($("#sFrm textarea[name=DSPTH_REASON]").val() == "" || $("#sFrm textarea[name=DSPTH_REASON]").val() == null ){
			fnFocAlert("통보근거를 입력하시기 바랍니다.", $("#sFrm textarea[name=DSPTH_REASON]"));
			return;
		}
	
		$("#sFrm input[name=TRVL_STS]").val("MN");
		
		var saveUrl = "/etc/updateTravelApprovalJs.kspo";
		
		var $json = getJsonMultiData( saveUrl, "sFrm");
		if($json.statusText == "OK"){
			
			fnAlert("문체부(병무청) 미승인되었습니다.");
			
			var param = "&gMenuSn=" + $("sFrm input[name=gMenuSn]").val();
			fnPageLoad("${pageContext.request.contextPath}/etc/TravelSelect.kspo",param);
			
		}
	}

	
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
		    <h2>국외여행</h2>
		</div>
		<!-- //타이틀 -->
		
		
		<!-- 검색영역 -->
		<form method="post" id="frm" name="frm" action="${pageContext.request.contextPath}/etc/TravelSelect.kspo">
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
<%-- 			                        <option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach items="${gameNmList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			                <td class="t-title">상태</td>
			                <td>
			                    <select id="srchTrvlSts" name="srchTrvlSts" class="smal">
			                        <option value="" <c:if test="${param.srchTrvlSts eq '' or param.srchTrvlSts eq null}">selected="selected"</c:if>>전체</option>
									<c:forEach items="${trvlStsList}" var="subLi">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchTrvlSts eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
			                    </select>
			                </td>
			            </tr>
			            <tr>
			                <td class="t-title">편입상태</td>
			                <td>
			                    <ul class="com-radio-list">
			                    	<li>
			                            <input id="soldierIncpSts6" type="radio" value="" name="srchProcSts"<c:if test="${param.srchProcSts eq '' or param.srchProcSts eq null}">checked="checked"</c:if>>
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
		    	<c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
					<button class="btn red rmvcrr" type="button" onclick="travelAddOpen();">신규</button>
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
		            <col style="width:auto">
		            <col style="width:10%">
		            <col style="width:10%">
		            <col style="width:10%">
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
		                <th>신청구분</th>
		                <th>등록일자</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<c:choose>
						<c:when test="${not empty travelSelectList}">
							<c:forEach items="${travelSelectList}" var="list" varStatus="state">
					             <tr>
					                <td>${list.RNUM}</td>
					                <td>${list.TRVL_SN}</td>
					                <td>${list.TRVL_STS_NM}</td>
					                <td><a href="javascript:fn_Detail('${list.TRVL_SN}','${list.TRVL_STS}');" class="tit">${list.APPL_NM}</a></td>
					                <td>
					                	<fmt:parseDate var="BRTH_DT" value="${list.BRTH_DT}" pattern="yyyyMMdd"/>
										<fmt:formatDate value="${BRTH_DT}" pattern="yyyy-MM-dd"/>
					                </td>
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
					                <td>${list.TRVL_APPL_DV}</td>
					                <td>${list.REG_DTM}</td>
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
<!-- 팝업영역 신청--><!-- 국외여행 신청 -->
<form id="mFrm" name="mFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="TRVL_SN" value="${detail.TRVL_SN}"/>
	<input type="hidden" name="APPL_SN" value="${detail.APPL_SN}"/>
	<input type="hidden" name="MLTR_ID" value="${detail.MLTR_ID}"/>
	<input type="hidden" name="TRVL_STS" value="${detail.TRVL_STS}"/>
	<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	<div class="cpt-popup reg03 travelAdd"> <!-- class:active 팝업 on/off -->
	    <div class="dim"></div>
	    <div class="popup">
	        <div class="pop-head">
	            국외여행신청
	            <button class="pop-close" onclick="travelAddClose();return false;">
	                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
	            </button>
	        </div>
	        <div class="pop-body">
            	<div class="process-status">처리상태 : <b class="t-blue">
            		<c:choose>
            			<c:when test="${detail.TRVL_STS_NM eq '' or detail.TRVL_STS_NM eq null}">
            				신규
            			</c:when>
            			<c:otherwise>
							${detail.TRVL_STS_NM}
            			</c:otherwise>
            		</c:choose>
            	</b></div>
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
	                                    <input type="text" name="APPL_NM" readonly="readonly" value="${detail.APPL_NM}">
	                                    <c:if test="${detail.APPL_NM eq null or detail.APPL_NM eq ''}">
		                                    <button type="button" id="personSearch" onclick="fn_searchPersonPopupOpen();">찾기</button>
	                                    </c:if>
	                                </div>
	                            </td>
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td" id="MLTR_ID">${detail.MLTR_ID}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일</td>
	                            <td class="input-td" id="BRTH_DT">${detail.BRTH_DT}</td>
	                            <td class="t-title">주소</td>
	                            <td class="input-td" id="ADDR">${detail.ADDR}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td" id="EMAIL">${detail.EMAIL}</td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td" id="CP_NO">${detail.CP_NO}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목</td>
	                            <td class="input-td" id="GAME_CD_NM">${detail.GAME_CD_NM}</td>
	                            <td class="t-title">체육단체</td>
	                            <td class="input-td" id="MEMORG_NM">${detail.MEMORG_NM}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">관할병무청</td>
	                            <td class="input-td" id="CTRL_MMA_CD">${detail.CTRL_MMA_CD}</td>
	                            <td class="t-title">소속팀</td>
	                            <td class="input-td" id="TEAM_NM">${detail.TEAM_NM}</td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	            <div class="com-h3 add">국외여행 여행정보
	            	<div class="rightArea">
	                    <button class="btn icon-info type01" type="button" onclick="trvl_add();">추가</button>
	                    <button class="btn icon-info type01" id="trvlDel" type="button" onclick="trvl_del();" style="display:none">삭제</button>
	                </div>
	            </div>
	            <div class="com-grid type02">
	                <table class="table-grid">
	                    <caption></caption>
	                    <colgroup>
	                        <col width="10%">
	                        <col width="15%">
	                        <col width="15%">
	                        <col width="20%">
	                        <col width="15%">
	                        <col width="15%">
	                        <col width="auto">
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th>
	                                <div class="input-box">
	                                    <input type="checkbox" id="checkall">
	                                    <label for="checkall" class="chk-only">전체선택</label>
	                                </div>
	                            </th>
	                            <th>신청구분</th>
	                            <th>진행상태</th>
	                            <th>여행국명</th>
	                            <th>여행시작일</th>
	                            <th>여행종료일</th>
	                            <th>여행목적</th>
	                        </tr>
	                    </thead>
	                    <tbody id="iTbody">
	                    	<c:choose>
								<c:when test="${not empty travelInfo}">
									<c:forEach items="${travelInfo}" var="travelInfo" varStatus="state">
				                    	<tr>
											<td>
												<div class='input-box'>
													<input type="checkbox" name="checkGrp" id="checkPerson${travelInfo.state}" value="${travelInfo.RECD_SN}">
													<label for="checkPerson${travelInfo.state}" class="chk-only">선택</label>
												</div>
											</td>
											<td><a href='javascript:fn_travelDtl("${travelInfo.RECD_SN}","m","${travelInfo.TRVL_STS}");'>${travelInfo.TRVL_APPL_DV}</a></td>
											<td>${travelInfo.TRVL_STS_NM}</td>
											<td>${travelInfo.TRVL_NATION}</td>
											<td>${travelInfo.TRVL_START_DT}</td>
											<td>${travelInfo.TRVL_END_DT}</td>
											<td>${travelInfo.TRVL_GOAL}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td colspan='7' class='center'>등록된 게시물이 없습니다.</td></tr>
								</c:otherwise>
							</c:choose>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">여행정보 상세</div>
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
	                            <td class="t-title">신청구분</td>
	                            <td class="input-td">
	                                <ul class="com-radio-list">
	                                    <li>
			                                <input type="hidden" value="" name="RECD_SN" />
	                                        <input id="radio01" type="radio" value="NW" name="TRVL_APPL_DV" <c:if test="${param.TRVL_APPL_DV eq 'NW'}">checked</c:if>>
	                                        <label for="radio01">신규신청</label>
	                                    </li>
	                                    <li>
	                                        <input id="radio02" type="radio" value="EX" name="TRVL_APPL_DV" <c:if test="${param.TRVL_APPL_DV eq 'EX'}">checked</c:if>>
	                                        <label for="radio02">연장신청</label>
	                                    </li>
	                                </ul>
	                            </td>
	                            <td class="t-title">소속</td>
	                            <td class="TEAM_NM" id="TEAM_NM">${detail.TEAM_NM}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">여행국명</td>
	                            <td colspan="3" class="input-td"><input type="text" class="smal" name="TRVL_NATION" maxlength="100" readonly><span class="t-red"> ※ 여행국명은 국가명만 작성하고, 여러 나라 입력 시 ‘쉼표(,)’로 구분하여 작성 예) 일본, 미국, 스페인</span></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">여행기간</td>
	                            <td class="input-td">
	                                <ul class="com-radio-list">
	                                    <li>
	                                        <input id="datepicker2" type="text" class="datepick smal" name="TRVL_START_DT" autocomplete="off" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" readonly> ~ 
	                                        <input id="datepicker3" name="TRVL_END_DT" type="text" class="datepick smal" autocomplete="off" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="8" readonly>
	                                    </li>
	                                </ul>
	                            </td>
	                            <td class="t-title">여행목적<span class="t-red"> *</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="TRVL_GOAL" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">변경사유</td>
	                            <td colspan="3" class="input-td"><input type="text" name="EXTN_REASON" class="ip-title" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">당초승인정보</td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="BGNN_GRNT_INFO" readonly></textarea></td>
	                        </tr>
							<tr>
	                       		<td class="t-title" colspan="4">
	                       			<div class="float-l">
	                       			첨부파일<span class="t-red"> ※ 첨부파일 필요항목 : 국외여행허가 신고서, 사업계획서, 경기스케줄, 항공권사본, 병역의무자 국외여행(기간연장) 허가 신청서 등을 첨부합니다.</span>
	                       			</div>
	                       			<div class="float-r">
	                       			<button class="btn red rmvcrr userDv2" type="button" onclick="window.open('${pageContext.request.contextPath}/common/docs/국외여행제출서류.zip')">서류 다운로드</button>
	                       			</div>
	                       		</td>
							</tr>
							<tr id="fileTbody">
								<td colspan="3" class="adds bdr-0 input-td">
									<div class="fileBox">
										<input type="text" class="fileName2" readonly="readonly">
										<label for="uploadBtn" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>
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
				
				<!-- 공단반려 혹은 취소 사유 -->
<%-- 				<c:if test="${detail.TRVL_STS == 'KC' or detail.TRVL_STS == 'KN'}"> --%>
					<div class="com-table applReason" >
		                <table class="table-board">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width:130px;">
		                        <col style="width:auto;">
		                    </colgroup>
		                    <tbody>
		                        <tr>
		                            <td class="t-title name">
		                            	<c:choose>
		                            		<c:when test="${detail.TRVL_STS eq 'KC'}">
				                            	공단취소사유
		                            		</c:when>
		                            		<c:when test="${detail.TRVL_STS eq 'KN'}">
				                            	공단반려사유
		                            		</c:when>
		                            	</c:choose>
		                            </td>
		                            <td class="input-td">
		                            	 <span class="appl applReasons">${detail.RECEIPT_REASON}</span>
		                            </td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
<%-- 				</c:if> --%>
	            <!-- 공단반려 혹은 취소 사유 -->
	            
	            <div class="com-btn-group put">
	                <div class="float-r">
	                	<c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
		                    <button class="btn navy rmvcrr" type="button" onclick="fn_save('TP');">임시저장</button>
		                    <button class="btn red rmvcrr" type="button" onclick="fn_save('AP');">신청</button>
<%-- 	                		<c:if test="${detail.TRVL_STS eq 'TP'}"> --%>
		                    	<button class="btn navy rmvcrr" type="button" id="fnDelete" onclick="fn_delete();">삭제</button>
<%-- 		                    </c:if> --%>
		                </c:if>
	                    <button class="btn grey rmvcrr" type="button" onclick="travelAddClose();">닫기</button>
	                    
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
					<button class="btn navy rmvcrr userDv2" type="button" onclick="fn_searchPersonPopupClose();">취소</button>
					<button class="btn red write" type="button" onclick="fn_confirmPerson();">확인</button>
				</div>
			</div>
		</div>
	</form>
</div>
<!-- //팝업영역 -->

<!-- 팝업영역 조회--><!-- 국외여행 상세 -->
<div class="cpt-popup reg03 travelSelect"> <!-- class:active 팝업 on/off -->
    <div class="dim"></div>
    <div class="popup">
        <div class="pop-head">
            국외여행신청
            <button class="pop-close" onclick="selectPopClose();">
                <img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지">
            </button>
        </div>
        <form id="sFrm" name="sFrm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="TRVL_SN" value="${detail.TRVL_SN}"/>
			<input type="hidden" name="APPL_SN" value="${detail.APPL_SN}"/>
			<input type="hidden" name="MLTR_ID" value="${detail.MLTR_ID}"/>
			<input type="hidden" name="TRVL_STS" value="${detail.TRVL_STS}"/>
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
	        <div class="pop-body">
	            <div class="process-status">처리상태 : <b class="t-blue">${detail.TRVL_STS_NM}</b></div>
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
	                                    <input type="text" name="APPL_NM" readonly="readonly" value="${detail.APPL_NM}">
	                                    <!-- <button type="button" id="personSearch" onclick="fn_searchPersonPopupOpen();">찾기</button> -->
	                                </div>
	                            </td>
	                            <td class="t-title">관리번호</td>
	                            <td class="input-td" id="MLTR_ID">${detail.MLTR_ID}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">생년월일</td>
	                            <td class="input-td" id="BRTH_DT">${detail.BRTH_DT}</td>
	                            <td class="t-title">주소</td>
	                            <td class="input-td" id="ADDR">${detail.ADDR}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">이메일</td>
	                            <td class="input-td" id="EMAIL">${detail.APPL_NM}</td>
	                            <td class="t-title">휴대폰</td>
	                            <td class="input-td" id="CP_NO">${detail.APPL_NM}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">종목</td>
	                            <td class="input-td" id="GAME_CD_NM">${detail.APPL_NM}</td>
	                            <td class="t-title">체육단체</td>
	                            <td class="input-td" id="MEMORG_NM">${detail.APPL_NM}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">관할병무청</td>
	                            <td class="input-td" id="CTRL_MMA_CD">${detail.CTRL_MMA_CD}</td>
	                            <td class="t-title">소속팀</td>
	                            <td class="input-td" id="TEAM_NM">${detail.TEAM_NM}</td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">국외여행 여행정보</div>
	            <div class="com-grid type02">
	                <table class="table-grid">
	                    <caption></caption>
	                    <colgroup>
	                        <col width="50px">
	                        <col width="15%">
	                        <col width="20%">
	                        <col width="15%">
	                        <col width="15%">
	                        <col width="auto">
	                    </colgroup>
	                    <thead>
	                        <tr>
	                            <th>
	                                <div class="input-box">
	                                    <input type="checkbox" id="checkall">
	                                    <label for="checkall" class="chk-only">전체선택</label>
	                                </div>
	                            </th>
	                            <th>신청구분</th>
	                            <th>진행상태</th>
	                            <th>여행국명</th>
	                            <th>여행시작일</th>
	                            <th>여행종료일</th>
	                            <th>여행목적</th>
	                        </tr>
	                    </thead>
	                    <tbody id="sTbody">
	                    	<c:choose>
								<c:when test="${not empty travelInfo}">
									<c:forEach items="${travelInfo}" var="travelInfo" varStatus="state">
				                    	<tr>
											<td>
												<div class='input-box'>
													<input type="checkbox" name="checkGrp" id="checkPerson${travelInfo.state}" value="${travelInfo.RECD_SN}">
													<label for="checkPerson${travelInfo.state}" class="chk-only">선택</label>
												</div>
											</td>
											<td><a href='fn_travelDtl("${travelInfo.RECD_SN}","s","${travelInfo.TRVL_STS}");'>${travelInfo.TRVL_APPL_DV}</a></td>
											<td>${travelInfo.TRVL_STS_NM}</td>
											<td>${travelInfo.TRVL_NATION}</td>
											<td>${travelInfo.TRVL_START_DT}</td>
											<td>${travelInfo.TRVL_END_DT}</td>
											<td>${travelInfo.TRVL_GOAL}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td colspan='7' class='center'>등록된 게시물이 없습니다.</td></tr>
								</c:otherwise>
							</c:choose>
	                    </tbody>
	                </table>
	            </div>
	                        
	            <div class="com-h3 add">여행정보 상세</div>
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
	                            <td class="t-title">신청구분</td>
	                            <td class="input-td">
	                                <ul class="com-radio-list">
	                                   <li>
			                                <input type="hidden" value="" name="RECD_SN" />
	                                        <input id="radio01" type="radio" value="NW" name="TRVL_APPL_DV" <c:if test="${param.TRVL_APPL_DV eq 'NW'}">checked</c:if> disabled>
	                                        <label for="radio01">신규신청</label>
	                                    </li>
	                                    <li>
	                                        <input id="radio02" type="radio" value="EX" name="TRVL_APPL_DV" <c:if test="${param.TRVL_APPL_DV eq 'EX'}">checked</c:if> disabled>
	                                        <label for="radio02">연장신청</label>
	                                    </li>
	                                </ul>
	                            </td>
	                            <td class="t-title">소속</td>
	                            <td class="TEAM_NM" id="TEAM_NM">${detail.TEAM_NM}</td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">여행국명</td>
	                            <td colspan="3" class="input-td"><input type="text" class="smal" name="TRVL_NATION"><span class="t-red"> ※ 여행국명은 국가명만 작성하고, 여러 나라 입력 시 ‘쉼표(,)’로 구분하여 작성 예) 일본, 미국, 스페인</span></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">여행기간</td>
	                            <td class="input-td">
	                                <ul class="com-radio-list">
	                                    <li>
	                                       <input id="datepicker4" type="text" class="datepick smal" name="TRVL_START_DT" autocomplete="off" readonly> ~ 
	                                        <input id="datepicker5" name="TRVL_END_DT" type="text" class="datepick smal" autocomplete="off" readonly>
	                                    </li>
	                                </ul>
	                            </td>
	                            <td class="t-title">여행목적<span class="t-red"> *</span></td>
	                            <td class="input-td"><input type="text" class="ip-title" name="TRVL_GOAL" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">변경사유</td>
	                            <td colspan="3" class="input-td"><input type="text" name="EXTN_REASON" class="ip-title" readonly></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">당초승인정보</td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="BGNN_GRNT_INFO" readonly></textarea></td>
	                        </tr>
	                        <tr>
	                       		<td class="t-title" colspan="4">첨부파일<span class="t-red"></span></td>
							</tr>
							<tr id="fileTbody2">
							</tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add">공단 접수내역
	                <div class="rightArea">
	                    <c:if test="${sessionScope.userMap.GRP_SN eq '2'}">
<%-- 		                	 <c:if test="${detail.TRVL_STS eq 'AP'}"> --%>
			                    <button class="btn navy rmvcrr fnDelete" type="button" onclick="fn_delete();">삭제</button>
<%-- 							</c:if> --%>
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
	                            <td class="input-td" id="RECEIPT_DTM"></td>
	                            <td class="t-title">처리결과</td>
	                            <td class="travel result"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">비고</td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="RECEIPT_REASON" id="RECEIPT_REASON">${detail.RECEIPT_REASON}</textarea></td>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-h3 add acpt">문체부(병무청) 승인내역
	                <div class="right-area">
	                    <p class="required">필수입력</p>
	                    <c:if test="${sessionScope.userMap.GRP_SN ne '2'}">
<%-- 	                    	<c:if test="${detail.TRVL_STS eq 'KY'}"> --%>
			                    <button class="btn red type01 userDv1" type="button" onclick="fn_acptOk();">문체부(병무청)승인</button>
			                    <button class="btn red type01 userDv1" type="button" onclick="fn_acptNotOk();">문체부(병무청)미승인</button>
<%-- 		                    </c:if> --%>
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
	                            <td class="t-title">통보일자<span class="t-red"> *</span></td>
	                            <td class="input-td" id="DSPTH_DTM"></td>
	                            <td class="t-title">처리결과</td>
	                            <td class="travel result"></td>
	                        </tr>
	                        <tr>
	                            <td class="t-title">통보근거<span class="t-red"> *</span></td>
	                            <td colspan="3" class="input-td"><textarea rows="5" name="DSPTH_REASON">${detail.DSPTH_REASON}</textarea></td>
	                        </tr>
	                        <tr id="acptFile">
	                            <td class="t-title">첨부파일</td>
	                           	
	                           	<c:choose>
	                           		<c:when test="${detail.TRVL_STS == 'MY' or detail.TRVL_STS == 'MN'}">
	                           			<td class="input-td" colspan="3"><a href="javascript:fnDownloadFile('${detail.ATCH_FILE_ID5}')"><span class="file-name">${detail.ATCH_FILE_NM5}</span></a></td>
	                           		</c:when>
	                           		<c:otherwise>
			                           	<td colspan="3" class="input-td">
											<div class="fileBox">
												<input type="text" class="fileName2" readonly="readonly">
												<input type="file" id="file01" name="file" class="file-table uploadBtn2">
												<label for="file01" class="btn dark rmvcrr file-btn">파일선택</label>
											</div>
										</td>
	                           		</c:otherwise>
	                           	</c:choose>
	                        </tr>
	                    </tbody>
	                </table>
	            </div>
	
	            <div class="com-helf">
	                <ol>
	                    <li class="uName">Last Update. ${detail.UPDR_NM} / ${detail.UPDT_DT}</li>
	                </ol>
	                <span class="t-red"> ※ 국외여행 최종 승인은 요원의 해당 병무청을 통해 확인하시기 바랍니다.</span>
	            </div>
	                        
	            <div class="com-btn-group put">
	                <div class="float-r">
	                    <button class="btn navy rmvcrr userDv2" type="button" onclick="selectPopClose();">닫기</button>
	                </div>
	            </div>
	        </div>
		</form>
    </div>
</div>
<!-- //팝업영역 -->
