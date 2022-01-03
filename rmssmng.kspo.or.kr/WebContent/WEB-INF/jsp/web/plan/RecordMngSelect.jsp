<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">

	$(document).ready(function(){
		
		$("#datepicker1, #datepicker2").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
		if($("#searchFrm input[name=srchRegDtmStart]").val()!= "" && $("#searchFrm input[name=srchRegDtmEnd]").val() != ""){
			$("#datepicker1").datepicker('option','maxDate',$("#searchFrm input[name=srchRegDtmEnd]").val());
			$("#datepicker2").datepicker('option','minDate',$("#searchFrm input[name=srchRegDtmStart]").val());
		}
		
		$(document).on("change","#datepicker1",function(){
			$("#datepicker2").datepicker('option','minDate',$(this).val());
		});
		
		$(document).on("change","#datepicker2",function(){
			$("#datepicker1").datepicker('option','maxDate',$(this).val());
		});
		
		$(document).on("input", "input[name=ACT_TIME_HR], input[name=PC_ACT_TIME_HR], input[name=PC_ACT_TIME_HR], input[name=AFT_ACT_TIME_HR]", function(){
 			$(this).val($(this).val().replace(/[^0-9]/g, ''));
 		});
		
		fn_hideDivBtn();
	});
	
	//활동시간 분 콤보 세팅
	var actTimeCdList = new Array();
	var rowCodeObj = null;
	<c:forEach var="rowCode" items="${actTimeMnCdList}">
		rowCodeObj = new Object(); 
		rowCodeObj.ALT_CODE = "${rowCode.ALT_CODE}";
		rowCodeObj.CNTNT_FST = "${rowCode.CNTNT_FST}";
		
		actTimeCdList.push(rowCodeObj);
	</c:forEach>
	
	//검색
	function fn_search(){
		//조회가능기간은 최대 1년까지만
		if(dateUtil.getDiffDay($("#datepicker1").val(), $("#datepicker2").val()) > 365) {
			fnAlert("등록일 조회기간은 최대 1년까지만 설정 가능합니다.");
			return;
		}
		fnPageLoad("/plan/RecordMngSelect.kspo",$("#searchFrm").serialize());
	}
	
	//실적등록 팝업 활성화
	function fn_recordAddPopupOpen(){
		
		fn_hideDivBtn();
		
		//버튼 제어
		var btnHtmlStr = "";
		
		var VLUN_RECD_SN = $('#mFrm input[name=VLUN_RECD_SN]').val(); 
		var RECD_STS = $('#mFrm input[name=RECD_STS]').val();
		
		$('button[name=recdDeleteDetailBtn]').hide();
		$('button[name=recdAddBtn]').hide();
		
		if(RECD_STS == 'TP' || VLUN_RECD_SN == ''){
			$('button[id=personSrhBtn]').show();
			fn_setform('mFrm', false);
		}
		
		if('2' == "${sessionScope.userMap.GRP_SN}"){//체육담당자
			if(VLUN_RECD_SN == '' || RECD_STS == 'TP'){//신규작성,임시저장
				btnHtmlStr += "<button class=\"btn navy rmvcrr userDv2\" type=\"button\" onclick=\"fn_save('TP');\">임시저장</button>";
				btnHtmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_save('TA');\">신청</button>";
				
			}
			
			if($('#mFrm input[name=VLUN_RECD_SN]').val() != '' && RECD_STS == 'TP'){//임시 저장 상태일때만
				btnHtmlStr += "<button class=\"btn navy rmvcrr userDv2\" type=\"button\" onclick=\"fn_delete();\">삭제</button>";
				
			}
					
			if(RECD_STS == 'TP' || (RECD_STS == '' || RECD_STS == null )){
				$('button[name=recdAddBtn]').show();
				$('button[name=recdDeleteDetailBtn]').show();
				
			}
			
		} else if('1' == "${sessionScope.userMap.GRP_SN}"){//공단 담당자
			
			if(RECD_STS == 'TA'){
				fn_setform('kdFrm', false);
			} else if(RECD_STS == 'KY'){
				fn_setform('kdFrm', false);
				$('#kdFrm textarea[name=RECEIPT_REASON]').prop('disabled', true);
				$('button[id=kdAcceptBtn]').show();
				
				fn_setform('mcFrm', false);
			} else if(RECD_STS == 'MY'){
				fn_setform('afterFrm', false);
				$('button[id=kdAftAcceptBtn]').show();
			}
			
		} else {
			
		}
		
		if($('#mFrm input[name=RECD_STS]').val() == 'MY'){//문체부 승인시에 활성
			btnHtmlStr += "<button class=\"btn red rmvcrr\" type=\"button\" onclick=\"fn_reportReq();\">실적 리포트</button>";
		}
		
		btnHtmlStr += "<button class=\"btn grey rmvcrr\" type=\"button\" onclick=\"fn_recordAddPopupClose();\">닫기</button>";
		
		$('#recordButtonDiv').empty().append(btnHtmlStr);
		
		$('#recordAddPopDiv').addClass('active');
	}
	
	//실적 팝업 닫기
	function fn_recordAddPopupClose(){
		
		//대상자 인적 사항 초기화
		$('#recordStsTxtDiv').html('신규작성');
		$('#mFrm input[name=VLUN_RECD_SN]').val('');
		$('#mFrm input[name=RECD_STS]').val('');
		$('#mFrm input[name=APPL_SN]').val('');
		$('#mFrm input[name=APPL_NM]').val('');
		$('#mFrm input[name=CHK_VLUN_PLC_NM]').val('');
		$('#mFrm input[name=CHK_ACT_FIELD]').val('');
		$('#mFrm input[name=CHK_ACT_PLACE]').val('');
		$('#mFrm input[name=CHK_VLUN_PLC_ADDRESS]').val('');
		$('#mFrm input[name=CHK_VLUN_TGT_TXT]').val('');
		$('#mFrm input[name=CHK_PLC_MNGR_NM]').val('');
		$('#mFrm input[name=CHK_PLC_MNGR_TEL_NO]').val('');
		$('#mFrm input[name=CHK_VLUN_ACT_START]').val('');
		$('#mFrm input[name=CHK_VLUN_ACT_END]').val('');
		$('#mFrm input[name=KD_ACCEPT_FLAG]').val('');
		
		$('#mFrm td[id=TD_APPL_SN]').html('');
		$('#mFrm td[id=TD_BRTH_DT]').html('');
		$('#mFrm td[id=TD_ADDR]').html('');
		$('#mFrm td[id=TD_EMAIL]').html('');
		$('#mFrm td[id=TD_CP_NO]').html('');
		$('#mFrm td[id=TD_GAME_CD_NM]').html('');
		$('#mFrm td[id=TD_MEM_ORG_NM]').html('');
		
		//공익복무 계획 초기화
		$('#planTbody').empty();
		$('#mFrm input[name=VLUN_PLAN_SN]').val('');
	
		//실적 초기화
		$('#recordAddDiv').empty();
		
		//공단 접수 초기화
		$('#kdConfirmDiv').empty();
		
		//문체부 접수 초기화
		$('#mcConfirmDiv').empty();
		
		//사후정정 초기화
		$('#afterConfirmDiv').empty();
		
		//최근 수정 정보 숨김
		$('#lastUpdateDiv').hide();
		
		//공익복무 실적등록 팝업 비활성
		$('#recordAddPopDiv').removeClass('active');
	}
	
	//체육요원 검색 팝업 활성
	function fn_searchPersonPopupOpen(){
		$('#searchPersonPopDiv').addClass('active');
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
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectRecordPersonListJs.kspo", param);
		
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
			var VLUN_PLAN_SN = personList[i].VLUN_PLAN_SN;
			
			htmlStr += "<tr>";
			htmlStr += "<td>";
			htmlStr += "<div class=\"input-box\">";
			htmlStr += "<input type=\"checkbox\" name=\"MLTR_ID_GRP\" id=\"MLTR_ID" + i + "\" value=\"" + MLTR_ID + "\">";
			htmlStr += "<label for=\"MLTR_ID" + i + "\" class=\"chk-only\">선택</label>";
			htmlStr += "<input type=\"hidden\" name=\"checkVlunPlanSnGrp\" value=\"" + VLUN_PLAN_SN + "\">";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "<td>" + VLUN_PLAN_SN + "</td>";
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
	
	function searchPersonFrm(pageNo){
		fn_popPersonSearch(pageNo);
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
		var VLUN_PLAN_SN = $('#searchPersonFrm input[name=MLTR_ID_GRP]:checked').siblings('input[name=checkVlunPlanSnGrp]').val();
		
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
			
			fn_setPsersonInfo(personInfo);
			
			fn_searchPersonPopupClose();
			
			//공익복무 계획 조회
			if(VLUN_PLAN_SN == ''){
				fnAlert("선택된 체육요원의 공익복무 계획 정보가 올바르지 않습니다. 문의 부탁드립니다.");
				return false;
			}
			
			var param = "VLUN_PLAN_SN=" + VLUN_PLAN_SN;
				param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
			
			var $json = getJsonData("post", "${pageCotnext.request.contextPath}/plan/selectPlanListJs.kspo", param);
			
			if($json.statusText != "OK"){
				fnAlert("오류가 발생하였습니다. 문의 부탁드립니다.");
				return false;
			}
			
			var planList = $json.responseJSON.planList;
			
			fn_createPlanList(planList);
				
		}
		
	}
	
	//실적 추가
	function fn_addRecord(){
		
		var APPL_SN = $('#mFrm input[name=APPL_SN]').val();
		
		if(APPL_SN == ''){
			fnAlert("체육복무요원을 선택해주세요.");
			return false;
		}
		
		$('#mFrm input[name=VLUN_PLAN_SN]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').val());
		$('#mFrm input[name=CHK_VLUN_PLC_NM]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=vlunPlcNmGrp]').val());//대상기관
		$('#mFrm input[name=CHK_ACT_FIELD]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=actFieldGrp]').val());//활동분야
		$('#mFrm input[name=CHK_ACT_PLACE]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=actPlaceGrp]').val());//봉사장소
		$('#mFrm input[name=CHK_VLUN_PLC_ADDRESS]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=vlunPlcAddressGrp]').val());//봉사장소 주소
		$('#mFrm input[name=CHK_VLUN_TGT_TXT]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=vlunTgtGrp]').val());//복무대상
		$('#mFrm input[name=CHK_PLC_MNGR_NM]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=plcMngrNmGrp]').val());//기관담당자
		$('#mFrm input[name=CHK_PLC_MNGR_TEL_NO]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=plcMngrTelNoGrp]').val());//기관담당자 연락처
		$('#mFrm input[name=CHK_VLUN_ACT_START]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=vlunActStartGrp]').val());
		$('#mFrm input[name=CHK_VLUN_ACT_END]').val($('#mFrm input[name=vlunPlanSnGrp]:checked').siblings('input[name=vlunActEndGrp]').val());
		
		var VLUN_PLAN_SN = $('#mFrm input[name=VLUN_PLAN_SN]').val();
		
		if(VLUN_PLAN_SN == ''){
			fnAlert("선택된 공익복무 계획이 존재하지 않습니다.");
			return false;
		}
		
		fn_createRecordTb('ADD');
		
	}
	
	//실적 삭제
	function fn_deleteRecord(tbId){
		
		if(!confirm("선택하신 공익복무 실적을 삭제하시겠습니까?")){
			return false;
		}
		
		var VLUN_RECD_D_SN = $('#tbRecord' + tbId).find('input[name=VLUN_RECD_D_SN').val();
		
		if(VLUN_RECD_D_SN != ''){
			
			var param = "VLUN_RECD_D_SN=" + VLUN_RECD_D_SN;
				param += "&gMenuSn=" + $("#mFrm input[name=gMenuSn]").val();
			
			var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/deleteRecodDetailJs.kspo", param);
			
			if($json.statusText == "OK"){
				
				var resultCnt = $json.responseJSON.resultCnt;
				
				if(resultCnt > 0){
					delRecordAfter(tbId);
				} else {
					fnAlert("삭제에 실패하였습니다.");
				}
			}
		} else {
			delRecordAfter(tbId);
		}
		
	}
	
	//
	function delRecordAfter(tbId){
		fnAlert("삭제되었습니다.");
		$('#tbRecord' + tbId).remove();
	}
	
	//저장
	function fn_save(RECD_STS){
		
		if(!fn_validate()){
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(RECD_STS == 'TP'){
			confirmMsg = "임시저장 하시겠습니까?";
			resultMsg = "임시저장 되었습니다.";
		}else if(RECD_STS == 'TA'){
			confirmMsg = "신청하시겠습니까?";
			resultMsg = "신청되었습니다.";
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#mFrm input[name=RECD_STS]').val(RECD_STS);
		
		$('#mFrm input[name=ACT_TIME_HR]').each(function(){
			var ACT_TIME_HR = $(this).val();
			if(ACT_TIME_HR.length == 1){
				$(this).val('0' + ACT_TIME_HR);
			}	
		});
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/plan/saveRecordJs.kspo", "mFrm");
		
		if($json.statusText == "OK"){

			var resultCnt = $json.responseJSON.resultCnt;

			if(resultCnt > 0) {
				fn_recordAddPopupClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("저장에 실피하였습니다.");
				fn_search();
			}
		}
	}
	
	//벨리데이션
	function fn_validate(){
		
		var recordDCnt = $('#mFrm input[name=VLUN_RECD_D_SN]').length;
		
		if(recordDCnt < 1){
			fnAlert("실적을 추가해주세요.");
			return false;
		}
		
		var isPassed = true;
		
		var CHK_VLUN_ACT_START = $('#mFrm input[name=CHK_VLUN_ACT_START]').val();
		var CHK_VLUN_ACT_END = $('#mFrm input[name=CHK_VLUN_ACT_END]').val();
		
		//봉사일자
		$('#mFrm input[name=ACT_DT]').each(function(idx){
			if($(this).val() == ''){
				fnFocAlert((idx+1) + "번째의 봉사일자를 선택해주세요.", $(this));
				isPassed = false;
				return false;
			}
			
			if($(this).val() < CHK_VLUN_ACT_START || $(this).val() > CHK_VLUN_ACT_END){
				fnFocAlert((idx+1) + "번째의 봉사일자는 활동시작일, 종료일의 사이 기간 이여야합니다.", $(this));
				isPassed = false;
				return false;
			}
		});
		
		if(!isPassed){
			return false;
		}
		
		//봉사장소
		$('#mFrm input[name=ACT_PLACE]').each(function(idx){
			if($(this).val() == ''){
				fnFocAlert((idx+1) + "번째의 봉사장소를 입력해주세요.", $(this));
				isPassed = false;
				return false;
			}
		});
		
		if(!isPassed){
			return false;
		}
		
		//활동내용
		$('#mFrm textarea[name=SRVC_CONTENTS]').each(function(idx){
			if($(this).val() == ''){
				fnFocAlert((idx+1) + "번째의 활동내용을 입력해주세요.", $(this));
				isPassed = false;
				return false;
			}
		});
		
		if(!isPassed){
			return false;
		}
		
		//식사 및 휴식시간 공제여부
		for(var i = 0; i < recordDCnt; i++){
			if(!$('input[name=DEDUCTION_CD_' + i + ']').is(':checked')){
				fnAlert((i+1) + "번째의 식사 및 휴식시간 공제여부를 선택해주세요.");
				isPassed = false;
				return false;
			}	
		}
		
		if(!isPassed){
			return false;
		}
		
		//활동시간[시]
		$('#mFrm input[name=ACT_TIME_HR]').each(function(idx){
			if($(this).val() == ''){
				fnFocAlert((idx+1) + "번째의 활동시간을 입력해주세요.", $(this));
				isPassed = false;
				return false;
			}
		});
		
		if(!isPassed){
			return false;
		}
		
		//활동시간[분]
		$('#mFrm select[name=ACT_TIME_MN]').each(function(idx){
			if($(this).val() == ''){
				fnFocAlert((idx+1) + "번째의 활동시간[분]을 선택해주세요.", $(this));
				isPassed = false;
				return false;
			}
		});
		
		if(!isPassed){
			return false;
		}
		
		//사례비 수령여부
		for(var i = 0; i < recordDCnt; i++){
			if(!$('input[name=GIFT_YN_' + i + ']').is(':checked')){
				fnAlert((i+1) + "번째의 사례비 수령여부를 선택해주세요.");
				isPassed = false;
				return false;
			}	
		}
		
		if(!isPassed){
			return false;
		}
		
		//이동거리
		for(var i = 0; i <recordDCnt; i++){
			if(!$('input[name=ACT_DIST_' + i + ']').is(':checked')){
				fnAlert((i+1) + "번째의 이동거리를 선택해주세요.");
				isPassed = false;
				return false;
			}	
		}
		
		if(!isPassed){
			return false;
		}
		
		//활동시간 + 이동거리시간의 합계가 12시간을 초과 할수 없음
		//이동거리시간은 D1[편도 100KM 미만] 일때 1시간 
		//			D2[편도 100KM 이상 200KM이하] 일때 2시간
		//			D3[편도 200KM 이상 300KM이하] 일때 3시간
		//			D4[편도 300KM이상] 일때 4시간
		
		
		for(var i = 0; i < recordDCnt; i++){
			var totTimeMn = 0;
			
			totTimeMn += Number($($('#mFrm input[name=ACT_TIME_HR]')[i]).val()) * 60;//활동시간 분으로
			totTimeMn += Number($($('#mFrm select[name=ACT_TIME_MN]')[i]).val());//활동시간 분
			var ACT_DIST = $('input[name=ACT_DIST_' + i + ']:checked').val();//이동거리 코드
			
			if(ACT_DIST == 'D1'){//이동거리에 따른 분처리
				totTimeMn += 60;
			} else if(ACT_DIST == 'D2'){
				totTimeMn += 120;
			} else if(ACT_DIST == 'D3'){
				totTimeMn += 180;
			} else if(ACT_DIST == 'D4'){
				totTimeMn += 240;
			} 
			
			if(totTimeMn > 60 * 12){
				fnAlert((i+1) + "번째의 활동시간 + 이동거리시간의 합이 12시간을 초과할수 없습니다.<br><br>편도 100km 미만 : 1시간<br>편도 100km 이상 200km미만 : 2시간<br>편도 200km 이상 300km이하 : 3시간<br>편도 300km 이상 : 4시간");
				return false;
			}
		}
		
		
		return true;
	}
	
	//상세보기
	function fn_detail(VLUN_RECD_SN){
		
		if(typeof(VLUN_RECD_SN) == 'undefined'){
			fnAlert("상세보기중 오류가 발생하였습니다.");
			return false;
		}
		
		var param = "VLUN_RECD_SN=" + VLUN_RECD_SN;
			param += "&gMenuSn=" + $('#mFrm input[name=gMenuSn]').val();
			
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/selectRecordDetailJs.kspo", param);
		
		if($json.statusText == "OK"){
			var $recordM = $json.responseJSON.recordM;
			var $recordD = $json.responseJSON.recordD;
			var $personInfo = $json.responseJSON.personInfo;
			var $planList = $json.responseJSON.planList;
			
			
			fn_setRecordM($recordM);
			fn_setPsersonInfo($personInfo);
			fn_createPlanList($planList);
			fn_createRecordTb('', $recordD);
			
			if($recordM.RECD_STS != 'TP'){
				fn_createKdConfirmDiv($recordM, $recordD);
			}
			
			if($recordM.RECD_STS == 'KY' || $recordM.RECD_STS == 'MY' || $recordM.RECD_STS == 'MN'){//공단접수,문체부승인완료, 문체부 승인거부
				fn_createMcConfirmDiv($recordM);
				
				if('1' == "${sessionScope.userMap.GRP_SN}" && $recordM.RECD_STS == 'MY'){
					fn_createAfterDiv($recordM, $recordD);
				}
				
			}
			
			fn_recordAddPopupOpen();
		}
	}
	
	//대상자 인적사항 정보 세팅
	function fn_setPsersonInfo(personInfo){
		
		$('#mFrm input[name=APPL_SN]').val(personInfo.APPL_SN);
		$('#mFrm input[name=APPL_NM]').val(personInfo.APPL_NM);
		$('#mFrm td[id=TD_APPL_SN]').html(personInfo.APPL_SN);
		$('#mFrm td[id=TD_BRTH_DT]').html(personInfo.BRTH_DT);
		$('#mFrm td[id=TD_ADDR]').html(personInfo.ADDR);
		$('#mFrm td[id=TD_EMAIL]').html(personInfo.EMAIL);
		$('#mFrm td[id=TD_CP_NO]').html(personInfo.CP_NO);
		$('#mFrm td[id=TD_GAME_CD_NM]').html(personInfo.GAME_CD_NM);
		$('#mFrm td[id=TD_MEM_ORG_NM]').html(personInfo.MEMORG_NM);
		
	}
	
	//실적 마스터 정보 세팅
	function fn_setRecordM(recordMObj){
		$('#mFrm input[name=VLUN_RECD_SN]').val(recordMObj.VLUN_RECD_SN);
		$('#mFrm input[name=VLUN_PLAN_SN]').val(recordMObj.VLUN_PLAN_SN);
		$('#mFrm input[name=APPL_SN]').val(recordMObj.APPL_SN);
		$('#mFrm input[name=RECD_STS]').val(recordMObj.RECD_STS);
		$('#mFrm input[name=KD_ACCEPT_FLAG]').val(recordMObj.KD_ACCEPT_FLAG);
		$('#recordStsTxtDiv').html(recordMObj.RECD_STS_TXT);
		
		//최근 수정 정보 세팅
		$('#lastUpdateDiv').show();
		$('#lastUpdateLi').html('Last Update. ' + recordMObj.LAST_UPDATE_NM + ' / ' + recordMObj.LAST_UPDATE_DT);
	}
	
	//공익복무 계획 리스트 생성
	function fn_createPlanList(planList){
		
		var htmlStr = "";
		
		if(planList == null || planList.length < 1){
			htmlStr += "<tr>";
			htmlSTr += "<td colspan=\"10\" class=\"center\">승인된 공익복무 계획이 없습니다.</td>";
			htmlStr += "</tr>";
		}
		
		for(var i = 0; i < planList.length; i++){
			
			htmlStr += "<tr>";
			htmlStr += "<td>" + planList[i].RNUM + "</td>";
			htmlStr += "<td>" + planList[i].VLUN_PLC_DV_TXT + "</td>";
			htmlStr += "<td>" + planList[i].ACT_FIELD + "</td>";
			htmlStr += "<td>" + planList[i].VLUN_PLC_NM + "</td>";
			htmlStr += "<td>" + "작성자" + "</td>";
			htmlStr += "<td>" + planList[i].VLUN_ACT_START + "</td>";
			htmlStr += "<td>" + planList[i].VLUN_ACT_END + "</td>";
			htmlStr += "<td>" + planList[i].VLUN_APPL_DTM + "</td>";
			htmlStr += "<td>" + planList[i].PLAN_STS_NM + "</td>";
			htmlStr += "<td><div class=\"input-box\">"; 
			htmlStr += "<input type=\"checkbox\" name=\"vlunPlanSnGrp\" id=\"vlunPlanSn" + i + "\" value=\"" + planList[i].VLUN_PLAN_SN + "\">";
			htmlStr += "<label for=\"vlunPlanSn" + i + "\" class=\"chk-only\">선택</label>";
			htmlStr += "<input type=\"hidden\" name=\"vlunPlcNmGrp\"  value=\"" + planList[i].VLUN_PLC_NM + "\">";
			htmlStr += "<input type=\"hidden\" name=\"actFieldGrp\"  value=\"" + planList[i].ACT_FIELD + "\">";
			htmlStr += "<input type=\"hidden\" name=\"actPlaceGrp\"  value=\"" + planList[i].ACT_PLACE + "\">";
			htmlStr += "<input type=\"hidden\" name=\"vlunPlcAddressGrp\"  value=\"" + planList[i].VLUN_PLC_ADDRESS + "\">";
			htmlStr += "<input type=\"hidden\" name=\"vlunTgtGrp\"  value=\"" + planList[i].VLUN_TGT_TXT + "\">";
			htmlStr += "<input type=\"hidden\" name=\"plcMngrNmGrp\"  value=\"" + planList[i].PLC_MNGR_NM + "\">";
			htmlStr += "<input type=\"hidden\" name=\"plcMngrTelNoGrp\"  value=\"" + planList[i].PLC_MNGR_TEL_NO + "\">";
			htmlStr += "<input type=\"hidden\" name=\"vlunActStartGrp\"  value=\"" + planList[i].VLUN_ACT_START.replace(/-/gi, "") + "\">";
			htmlStr += "<input type=\"hidden\" name=\"vlunActEndGrp\"  value=\"" + planList[i].VLUN_ACT_END.replace(/-/gi, "") + "\">";
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "</tr>";
			
		}
		
		$('#planTbody').empty().append(htmlStr);
		
		$('#mFrm input[name=CHK_VLUN_PLC_NM]').val(planList[0].VLUN_PLC_NM);
		$('#mFrm input[name=CHK_ACT_FIELD]').val(planList[0].ACT_FIELD);
		$('#mFrm input[name=CHK_ACT_PLACE]').val(planList[0].ACT_PLACE);
		$('#mFrm input[name=CHK_VLUN_PLC_ADDRESS]').val(planList[0].VLUN_PLC_ADDRESS);
		$('#mFrm input[name=CHK_VLUN_TGT_TXT]').val(planList[0].VLUN_TGT_TXT);
		$('#mFrm input[name=CHK_PLC_MNGR_NM]').val(planList[0].PLC_MNGR_NM);
		$('#mFrm input[name=CHK_PLC_MNGR_TEL_NO]').val(planList[0].PLC_MNGR_TEL_NO);
		$('#mFrm input[name=CHK_VLUN_ACT_START]').val(planList[0].VLUN_ACT_START.replace(/-/gi, ""));
		$('#mFrm input[name=CHK_VLUN_ACT_END]').val(planList[0].VLUN_ACT_END.replace(/-/gi, ""));
		
	}
	
	//실적 상세정보 세팅
	function fn_createRecordTb(type, recordDList){
		
		var roopCnt = (type == 'ADD') ? 1 : recordDList.length;
		
		var CHK_RECD_STS = $('#mFrm input[name=RECD_STS]').val();
		var CHK_VLUN_PLC_NM = $('#mFrm input[name=CHK_VLUN_PLC_NM]').val();
		var CHK_ACT_FIELD = $('#mFrm input[name=CHK_ACT_FIELD]').val();
		var CHK_ACT_PLACE = $('#mFrm input[name=CHK_ACT_PLACE]').val();
		var CHK_VLUN_PLC_ADDRESS = $('#mFrm input[name=CHK_VLUN_PLC_ADDRESS]').val(); 
		var CHK_VLUN_TGT_TXT = $('#mFrm input[name=CHK_VLUN_TGT_TXT]').val();
		var CHK_PLC_MNGR_NM = $('#mFrm input[name=CHK_PLC_MNGR_NM]').val();
		var CHK_PLC_MNGR_TEL_NO = $('#mFrm input[name=CHK_PLC_MNGR_TEL_NO]').val();
		
		for(var i = 0; i < roopCnt; i++){
			
			var tbId = new Date().getTime();
			
			var totRecordCnt = (type == 'ADD') ? $('#recordAddDiv').children('table').length : i;
			
			var htmlStr = "";
				htmlStr += "<table class=\"table-board\" id=\"tbRecord" + tbId + "\">";
				htmlStr += "<caption></caption>";
				htmlStr += "<colgroup>";
				htmlStr += "<col style=\"width:160px;\">";
				htmlStr += "<col style=\"width:auto;\">";
				htmlStr += "<col style=\"width:150px;\">";
				htmlStr += "<col style=\"width:auto;\">";
				htmlStr += "</colgroup>";
				htmlStr += "<thead>";
				htmlStr += "<tr>";
				htmlStr += "<th colspan=\"4\" class=\"add-btn\">공익복무";
				htmlStr += "<div class=\"right-area\">";
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" name=\"recdDeleteDetailBtn\" onclick=\"fn_deleteRecord('" + tbId + "');return false;\">실적삭제</button>";
				htmlStr += "</div>";
				htmlStr += "</th>";
				htmlStr += "</tr>";
				htmlStr += "</thead>";
				htmlStr += "<tbody>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">대상기관</td>";
				htmlStr += "<td class=\"input-td\">" + CHK_VLUN_PLC_NM + "</td>";
				htmlStr += "<td class=\"t-title\">봉사일자<span class=\"t-red\"> *</span></td>";
				
				if(type == 'ADD'){
					htmlStr += "<td class=\"input-td\"><input id=\"datepicker" + tbId + "\" type=\"text\" name=\"ACT_DT\" maxlength=\"8\" readonly=\"readonly\" autocomplete=\"off\" class=\"datepick smal\">";	
				} else {
					htmlStr += "<td class=\"input-td\"><input id=\"datepicker" + tbId + "\" type=\"text\" name=\"ACT_DT\" readonly=\"readonly\" value=\"" + recordDList[i].ACT_DT + "\" maxlength=\"8\" autocomplete=\"off\" class=\"datepick smal\">";
				}
				
				
				if(type == 'ADD'){
					htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_D_SN\"/>";
					htmlStr += "<input type=\"hidden\" name=\"ATCH_FILE_ID\">";
					
				} else {
					htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_D_SN\" value=\"" + recordDList[i].VLUN_RECD_D_SN + "\"/>";
					htmlStr += "<input type=\"hidden\" name=\"ATCH_FILE_ID\" value=\"" + recordDList[i].ATCH_FILE_ID + "\">";
				}
				
				htmlStr += "<input type=\"hidden\" name=\"TB_ID\" value=\"" + tbId + "\">";
				
				htmlStr += "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">활동분야<span class=\"t-red\">*</span></td>";
				htmlStr += "<td class=\"input-td\">" + CHK_ACT_FIELD + "</td>";
				htmlStr += "<td class=\"t-title\">봉사장소<span class=\"t-red\">*</span></td>";
				
				if(type == 'ADD'){
					htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"ACT_PLACE\" value=\"" + CHK_ACT_PLACE + "\"></td>";	
				} else {
					htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"ACT_PLACE\" value=\"" + recordDList[i].ACT_PLACE + "\"></td>";
				}
				
				
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">복무대상<span class=\"t-red\">*</span></td>";
				htmlStr += "<td class=\"input-td\">" + CHK_VLUN_TGT_TXT + "</td>";
				htmlStr += "<td class=\"t-title\">봉사장소 주소<span class=\"t-red\">*</span></td>";
				htmlStr += "<td class=\"input-td\">" + CHK_VLUN_PLC_ADDRESS + "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">기관 담당자</td>";
				htmlStr += "<td class=\"input-td\">" + CHK_PLC_MNGR_NM + "</td>";
				htmlStr += "<td class=\"t-title\">연락처</td>";
				htmlStr += "<td class=\"input-td\">" + CHK_PLC_MNGR_TEL_NO + "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">활동내용<span class=\"t-red\"> *</span></td>";
				
				if(type == 'ADD'){
					htmlStr += "<td colspan=\"3\" class=\"input-td\"><textarea name=\"SRVC_CONTENTS\" rows=\"5\"></textarea></td>";	
				} else {
					htmlStr += "<td colspan=\"3\" class=\"input-td\"><textarea name=\"SRVC_CONTENTS\" rows=\"5\">" + recordDList[i].SRVC_CONTENTS + "</textarea></td>";
				}
				
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">식사 및 휴식시간 공제여부<span class=\"t-red\"> *</span></td>";
				htmlStr += "<td>";
				htmlStr += "<ul class=\"com-radio-list\">";
	
				<c:forEach var="deductionCd" items="${deductionCdList}" varStatus="sts">
					var deductionRIdx = "deductionRIdx"+ tbId + ${sts.index}; 
					
					htmlStr += "<li>";
					htmlStr += "<input id=\"" + deductionRIdx + "\"  type=\"radio\" value=\"${deductionCd.ALT_CODE}\" name=\"DEDUCTION_CD_" + totRecordCnt + "\">";
					htmlStr += "<label for=\"" + deductionRIdx + "\">${deductionCd.CNTNT_FST}</label>";
					htmlStr += "</li>";	
				</c:forEach>
				
				htmlStr += "</ul>";
				htmlStr += "</td>";
				htmlStr += "<td class=\"t-title\">활동시간<span class=\"t-red\"> *</span></td>";
				htmlStr += "<td class=\"input-td\">";
				
				if(type == 'ADD'){
					htmlStr += "<input type=\"text\" name=\"ACT_TIME_HR\" style=\"width:50px;\">시간 ";	
				} else{
					htmlStr += "<input type=\"text\" name=\"ACT_TIME_HR\" style=\"width:50px;\" value=\"" + recordDList[i].ACT_TIME_HR + "\">시간 ";
				}
				
				htmlStr += "<select class=\"tab-sel\" id=\"ACT_TIME_MN_" + totRecordCnt + "\" name=\"ACT_TIME_MN\" title=\"활동시간\" style=\"width:80px;\">";
				
				<c:forEach var="actTimeMnCd" items="${actTimeMnCdList}">
				htmlStr += "<option value=\"${actTimeMnCd.ALT_CODE}\">${actTimeMnCd.CNTNT_FST}</option>";
				</c:forEach>
				
				htmlStr += "</select>";
				htmlStr += "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">사례비 수령여부<span class=\"t-red\"> *</span></td>";
				htmlStr += "<td>";
				htmlStr += "<ul class=\"com-radio-list\">";
				
				
				<c:forEach var="giftYnCd" items="${giftYnCdList}" varStatus="sts">
				var giftYnRIdx = "giftYnRIdx" + tbId + ${sts.index}; 
				
				htmlStr += "<li>";
				htmlStr += "<input id=\"" + giftYnRIdx + "\"  type=\"radio\" value=\"${giftYnCd.ALT_CODE}\" name=\"GIFT_YN_" + totRecordCnt + "\">";
				htmlStr += "<label for=\"" + giftYnRIdx + "\">${giftYnCd.CNTNT_FST}</label>";
				htmlStr += "</li>";	
				</c:forEach>
				
				htmlStr += "</ul>";
				htmlStr += "</td>";
				htmlStr += "<td class=\"t-title\"></td>";
				htmlStr += "<td></td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">이동거리<span class=\"t-red\"> *</span></td>";
				htmlStr += "<td>";
				htmlStr += "<ul class=\"com-radio-list\">";
				
				<c:forEach var="actDistCd" items="${actDistCdList}" varStatus="sts">
				var actDistRIdx = "actDistRIdx" + tbId + ${sts.index}; 
				
				htmlStr += "<li>";
				htmlStr += "<input id=\"" + actDistRIdx + "\"  type=\"radio\" value=\"${actDistCd.ALT_CODE}\" name=\"ACT_DIST_" + totRecordCnt + "\">";
				htmlStr += "<label for=\"" + actDistRIdx + "\">${actDistCd.CNTNT_FST}</label>";
				htmlStr += "</li>";	
				</c:forEach>
				
				htmlStr += "</ul>";
				htmlStr += "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\" colspan=\"4\"><div class=\"float-l\">첨부파일<br><span class=\"t-red\"> ※ 첨부파일 필요항목 : 특기활용 공익복무확인서(복무수행기관용), 특기활용 공익복무확인대장, 특기활용 공익복무 사진증빙, 체육요원 특기활용 공익복무 이동내역 등을 첨부합니다.</span></div>";
				htmlStr += "<div class=\"float-r\"><button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"window.open('${pageContext.request.contextPath}/common/docs/공익복무실적제출서류.zip')\">서류 다운로드</button></div></td>";
				htmlStr += "</tr>";
				
				if(CHK_RECD_STS == 'TP' || (CHK_RECD_STS == null || CHK_RECD_STS == '')){ //임시저장일때만 첨부파일 보이게
					htmlStr += "<tr id=\"" + tbId + "fileTr\">";
					htmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
					htmlStr += "<div class=\"fileBox\">";
					htmlStr += "<input type=\"text\" class=\"fileName2\" readonly=\"readonly\">";
					htmlStr += "<label for=\"" + tbId + "uploadBtn\" class=\"btn_file btn navy addlist mrg-0 file-btn\">파일첨부</label>";
					htmlStr += "<input type=\"file\" name=\"file_"+ tbId + "\" id=\"" + tbId + "uploadBtn\" class=\"uploadBtn2\">";
					htmlStr += "</div>";
					htmlStr += "</td>";
					htmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
					htmlStr +=	"<button class=\"btn lightgrey addfile mrg-5\" type=\"button\" onclick=\"fn_addFile('" + tbId + "');\"></button>";
					htmlStr += "</td>"
					htmlStr += "</tr>";
					
					if(type != 'ADD'){
						//봉사실적 상세별 첨부파일 세팅
						if(recordDList[i].FILE_LIST != null){
							
							for(var k= 0 ;k < recordDList[i].FILE_LIST.length ;k++) {
								htmlStr += "<tr>";
								htmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
								htmlStr += "<a href=\"javascript:fnDownloadFile('" + recordDList[i].FILE_LIST[k].FILE_SN + "');\"><span class=\"file-name\">" + recordDList[i].FILE_LIST[k].FILE_ORGIN_NM + "</span></a>";
								
								if($('#mFrm input[name=RECD_STS]').val() == 'TP'){//임시저장일때만
								htmlStr += "<button class=\"file-del\" onclick=\"fn_fileDel('"+ recordDList[i].FILE_LIST[k].FILE_SN + "', this);\"> 삭제</button>";
								}
								
								htmlStr += "</td>";
								htmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
								htmlStr += "</td>";
								htmlStr += "</tr>";
							}
						}
					}
					
				}else{
					//봉사실적 상세별 첨부파일 세팅
					if(recordDList[i].FILE_LIST != null){
						
						for(var k= 0 ;k < recordDList[i].FILE_LIST.length ;k++) {
							htmlStr += "<tr>";
							htmlStr += "<td colspan=\"3\" class=\"adds bdr-0 input-td\">";
							htmlStr += "<a href=\"javascript:fnDownloadFile('" + recordDList[i].FILE_LIST[k].FILE_SN + "');\"><span class=\"file-name\">" + recordDList[i].FILE_LIST[k].FILE_ORGIN_NM + "</span></a>";
							
							if($('#mFrm input[name=RECD_STS]').val() == 'TP'){//임시저장일때만
							htmlStr += "<button class=\"file-del\" onclick=\"fn_fileDel('"+ recordDList[i].FILE_LIST[k].FILE_SN + "', this);\"> 삭제</button>";
							}
							
							htmlStr += "</td>";
							htmlStr += "<td class=\"bdl-0 pdr-0 ft-0\">";
							htmlStr += "</td>";
							htmlStr += "</tr>";
						}
					}
				}
				
				htmlStr += "</tbody>";
				htmlStr += "</table>";
			
			$('#recordAddDiv').append(htmlStr);
			
			//봉사일자
			$("#datepicker" + tbId).datepicker({
				showOtherMonths: true,
				selectOhterMonth: true
			});
			
			if(type != 'ADD'){
				//라디오,콤보 박스 데이터 세팅
				//식사 및 휴식 시간 공제여부
				$('input[type=radio][name=DEDUCTION_CD_' + totRecordCnt + ']').each(function(){
					if($(this).val() == recordDList[i].DEDUCTION_CD){
						$(this).prop('checked', true);
					}
				});
				
				//사례비 수령여부
				$('input[type=radio][name=GIFT_YN_' + totRecordCnt + ']').each(function(){
					if($(this).val() == recordDList[i].GIFT_YN){
						$(this).prop('checked', true);
					}
				});
				
				//이동거리
				$('input[type=radio][name=ACT_DIST_' + totRecordCnt + ']').each(function(){
					if($(this).val() == recordDList[i].ACT_DIST){
						$(this).prop('checked', true);
					}
				});
				
				//활동시간
				$('select[id=ACT_TIME_MN_' + totRecordCnt + ']').val(recordDList[i].ACT_TIME_MN);
			}
			
		}
	}
	
	//실적 삭제
	function fn_delete(){
		
		var RECD_STS = $('#mFrm input[name=RECD_STS]').val();
		
		if(RECD_STS != 'TP'){
			fnAlert("임시저장 상태만 삭제가능합니다.");
			return false;
		}
		
		if(!confirm("삭제하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/deleteRecordJs.kspo", $("#mFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				fnAlert("삭제되었습니다.");
				fn_recordAddPopupClose();
				fn_search();
			} else {
				fnAlert("삭제에 실패하였습니다.");
			}
		}
		
	}
	
	//공단 담당자 승인,반려
	function fn_kdConfirm(RECD_STS){
		
		//if($('#kdFrm input[name=RECEIPT_DTM]').val() == ''){
		//	fnAlert("처리일자를 선택해주세요.");
		//	return false;
		//}
		
		if($('#kdFrm textarea[name=RECEIPT_REASON]').val() == ''){
			fnFocAlert("비고를 입력해주세요.", $('#kdFrm textarea[name=RECEIPT_REASON]'));
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(RECD_STS == 'KY'){
			confirmMsg = "접수처리 하시겠습니까?";
			resultMsg = "접수처리 되었습니다.";
		}else if(RECD_STS == 'KN'){
			confirmMsg = "접수반려 하시겠습니까?";
			resultMsg = "접수반려 되었습니다.";
		}else {
			fnAlert("오류가 발생하였습니다.[RECD_STS 상태값 오류]");
			return false;
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#kdFrm input[name=RECD_STS]').val(RECD_STS);
		$('#kdFrm input[name=VLUN_RECD_SN]').val($('#mFrm input[name=VLUN_RECD_SN]').val());
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/kdConfirmJs.kspo", $("#kdFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				fn_recordAddPopupClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("접수/반려 처리에 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	//공단 승인/반려 화면 생성
	function fn_createKdConfirmDiv($recordM, $recordD){
		
		var htmlStr = "<form id=\"kdFrm\" method=\"post\">";
			htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_SN\"/ value=\"" + $recordM.VLUN_RECD_SN + "\">";
			htmlStr += "<input type=\"hidden\" name=\"RECD_STS\"/>"
			htmlStr += "<input type=\"hidden\" name=\"gMenuSn\" value=\"${param.gMenuSn}\">";
			htmlStr += "<!-- //공단 접수내용 -->";
			htmlStr += "<div class=\"com-h3 add\">공단 접수내역";
			htmlStr += "<div class=\"right-area\">";
			htmlStr += "<p class=\"required\">필수입력</p>";
			
			if($recordM.RECD_STS == 'TA' && '1' == "${sessionScope.userMap.GRP_SN}"){//신청이고 공단 담당자일때
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_kdConfirm('KY');\">접수처리</button>";
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_kdConfirm('KN');\">접수반려</button>";	
			}
			htmlStr += "</div>";
			htmlStr += "</div>";
			htmlStr += "<div class=\"com-table\">";
			htmlStr += "<table class=\"table-board\">";
			htmlStr += "<caption></caption>";
			htmlStr += "<colgroup>";
			htmlStr += "<col style=\"width:130px;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:130px;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "</colgroup>";
			htmlStr += "<tbody>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">처리일자</td>";
			htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"RECEIPT_DTM\" value=\"" + $recordM.RECEIPT_DTM + "\" readonly=\"readonly\" autocomplete=\"off\" style=\"border: none;\"></td>";
			htmlStr += "<td class=\"t-title\">처리결과</td>";
			htmlStr += "<td>" + $recordM.RECD_STS_TXT + "</td>";
			htmlStr += "</tr>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">비고<span class=\"t-red\"> *</span></td>";
			htmlStr += "<td colspan=\"3\" class=\"input-td\"><textarea rows=\"5\" name=\"RECEIPT_REASON\">" + $recordM.RECEIPT_REASON + "</textarea></td>";
			htmlStr += "</tr>";
			htmlStr += "</tbody>";
			htmlStr += "</table>";
			htmlStr += "</div>";
			htmlStr += "<!-- //공단 접수내용 -->";
			
			if('1' == "${sessionScope.userMap.GRP_SN}" && ['KY', 'MY', 'MC'].indexOf($recordM.RECD_STS) != -1){//공단 담당자일때
				htmlStr += "<!-- 공단 인정시간 등록 -->";
				htmlStr += "<div class=\"com-h3 add\">공단 인정시간 등록";
				htmlStr += "<div class=\"right-area\">";
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_saveKdAccept();\" id=\"kdAcceptBtn\">인정시간 저장</button>";
				htmlStr += "</div>";
				htmlStr += "</div>";
				htmlStr += "<div class=\"com-table\">";
				htmlStr += "<table class=\"table-board\">";
				htmlStr += "<caption></caption>";
				htmlStr += "<colgroup>";
				htmlStr += "<col style=\"width:130px;\">";
				htmlStr += "<col style=\"width:auto;\">";
				htmlStr += "<col style=\"width:auto;\">";
				htmlStr += "</colgroup>";
				htmlStr += "<tbody>";
				htmlStr += "<tr>";
				htmlStr += "<td rowspan=\"2\" class=\"t-title\">인정시간</td>";
				htmlStr += "<td class=\"input-td\" colspan=\"2\">";
				htmlStr += "<table class=\"table-board\">";
				htmlStr += "<caption></caption>";
				htmlStr += "<colgroup>";
				htmlStr += "<col style=\"width:auto;\">";
				htmlStr += "<col style=\"width:200px;\">";
				htmlStr += "<col style=\"width:400px;\">";
				htmlStr += "<col style=\"width:200px;\">";
				htmlStr += "</colgroup>";
				htmlStr += "<head>";
				htmlStr += "<tr>";
				htmlStr += "<th>활동구분</th>";
				htmlStr += "<th>활동시간</th>";
				htmlStr += "<th>봉사지까지 거리</th>";
				htmlStr += "<th>봉사지까지 이동시간</th>";
				htmlStr += "</tr>";
				htmlStr += "</head>";
				htmlStr += "<tbody>";
				
				var PC_ACT_TIME_HR_TOT = 0;
				var PC_ACT_TIME_MN_TOT = 0;
				var ADMS_ACT_DIST_TOT = 0;
				var PC_REC_WP_MV_MV_TIME_TOT = 0;
				
				for(var i = 0; i < $recordD.length; i++){
					htmlStr += "<tr>";
					
					htmlStr += "<td class=\"t-title\">" + $recordD[i].ACT_PLACE;
					htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_D_SN\" value=\"" + $recordD[i].VLUN_RECD_D_SN + "\">";
					htmlStr += "</td>";
					htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"PC_ACT_TIME_HR\" value=\"" + $recordD[i].PC_ACT_TIME_HR + "\" class=\"xs\" style=\"width:40px;\"> 시간";
					htmlStr += "<select name=\"PC_ACT_TIME_MN\" class=\"smal\" style=\"width:100px;\">";
					
					var PC_ACT_TIME_MN = $recordD[i].PC_ACT_TIME_MN;
					
					for(var k = 0; k < actTimeCdList.length; k++){
						var altCode = actTimeCdList[k].ALT_CODE;
						var selected = (PC_ACT_TIME_MN == altCode) ? 'selected=\"selected\"' : '';
						
						htmlStr += "<option value=\"" + altCode + "\"" + selected + ">" + actTimeCdList[k].CNTNT_FST + "</option>";
					}
					
					htmlStr += "</td>";
					htmlStr += "<td class=\"input-td\">";
					htmlStr += "<ul class=\"com-radio-list\">";
	
					<c:forEach var="actDistCd" items="${actDistCdList}" varStatus="sts">
					var admsActDistRIdx = "admsActDistRIdx_" + i + "_${sts.index}";
					var checkedFlag = ("${actDistCd.ALT_CODE}" == $recordD[i].ADMS_ACT_DIST) ? "checked=\"checked\"" : "";
					
					htmlStr += "<li>";
					htmlStr += "<input id=\"" + admsActDistRIdx + "\"  type=\"radio\" value=\"${actDistCd.ALT_CODE}\" name=\"ADMS_ACT_DIST_" + i + "\"" + checkedFlag + " onchange=\"fn_actDistChg(this, 'accept');\">";
					htmlStr += "<label for=\"" + admsActDistRIdx + "\">${actDistCd.CNTNT_FST}</label>";
					htmlStr += "</li>";	
					</c:forEach>
					
					htmlStr += "</ul>";
					htmlStr += "</td>";
					
					htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"PC_REC_WP_MV_TIME\" value=\"" + $recordD[i].PC_REC_WP_MV_TIME + "\" class=\"xs\" readonly=\"readonly\"> 시간</td>";
					htmlStr += "</tr>";
					
					PC_ACT_TIME_HR_TOT += Number($recordD[i].PC_ACT_TIME_HR);				//활동시간 시간 합계
					PC_ACT_TIME_MN_TOT += Number($recordD[i].PC_ACT_TIME_MN);				//활동시간 분 합계
					
					ADMS_ACT_DIST_TOT += Number($recordD[i].ADMS_ACT_DIST);				//봉사지까지 이동거리	합계
					PC_REC_WP_MV_MV_TIME_TOT += Number($recordD[i].PC_REC_WP_MV_TIME);	//봉사지까지 이동시간	합계
				}
				
				//시간관련 계산
				var addedHr = Math.floor(PC_ACT_TIME_MN_TOT / 60);
				var remainMn = PC_ACT_TIME_MN_TOT % 60;
				PC_ACT_TIME_HR_TOT = PC_ACT_TIME_HR_TOT + addedHr;
				
				var totTimeHr = PC_ACT_TIME_HR_TOT + PC_REC_WP_MV_MV_TIME_TOT; 
				
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">합계</td>";
				htmlStr += "<td id=\"PC_INPUT_ACT_TIME_TOT_TD\">" + PC_ACT_TIME_HR_TOT + " 시간 " + remainMn + " 분</td>";
				htmlStr += "<td></td>";
				htmlStr += "<td id=\"PC_REC_WP_MV_TIME_TOT_TD\">" + PC_REC_WP_MV_MV_TIME_TOT +" 시간</td>";
				htmlStr += "</tr>";
				htmlStr += "</tbody>";
				htmlStr += "</table>";
				htmlStr += "</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td colspan=\"2\" class=\"center\">합계 : " + totTimeHr + " 시간 " + remainMn + "분</td>";
				htmlStr += "</tr>";
				htmlStr += "<tr>";
				htmlStr += "<td class=\"t-title\">비고</td>";
				htmlStr += "<td colspan=\"2\" class=\"input-td\"><textarea name=\"ADMS_RMK\" rows=\"5\">" + $recordM.ADMS_RMK + "</textarea></td>";
				htmlStr += "</tr>";
				htmlStr += "</tbody>";
				htmlStr += "</table>";
				htmlStr += "</div>";
				
				htmlStr += "<!-- //공단 인정시간 등록 -->";
			}	
			
			htmlStr += "</form>";
			
		$('#kdConfirmDiv').empty().append(htmlStr);	
			
	}
	
	//인정시간 저장
	function fn_saveKdAccept(){
		
		if(!fn_kdValidate()){
			return false;
		}
		
		if(!confirm("인정시간을 저장 하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/plan/saveKdAcceptJs.kspo", $("#kdFrm").serialize());
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {
				fn_recordAddPopupClose();
				fnAlert("인정 시간 등록에 성공하였습니다.");
				fn_search();
			} else {
				fnAlert("인정시간 등록에 실패하였습니다.");
				fn_search();
			}
		}	
	}
	
	//문체부 승인 화면 생성
	function fn_createMcConfirmDiv($recordM){
			
		var RECD_STS = $recordM.RECD_STS
		
		var htmlStr = "";
			htmlStr += "<form id=\"mcFrm\" method=\"post\" enctype=\"multipart/form-data\">";
			htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_SN\"/ value=\"" + $recordM.VLUN_RECD_SN + "\">";
			htmlStr += "<input type=\"hidden\" name=\"RECD_STS\"/>"
			htmlStr += "<input type=\"hidden\" name=\"gMenuSn\" value=\"${param.gMenuSn}\">";
			htmlStr += "<div class=\"com-h3 add\">문체부 승인내역";
			htmlStr += "<div class=\"right-area\">";
			htmlStr += "<p class=\"required\">필수입력</p>";
			
			if(RECD_STS == 'KY' && '1' == "${sessionScope.userMap.GRP_SN}"){//공단접수 상태일때만
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_mcConfirm('MY');\">문체부 승인</button>";
				htmlStr += "<button class=\"btn red rmvcrr userDv2\" type=\"button\" onclick=\"fn_mcConfirm('MN');\">문체부 미승인</button>";
			}
			htmlStr += "</div>";
			htmlStr += "</div>";
			htmlStr += "<div class=\"com-table\">";
			htmlStr += "<table class=\"table-board\">";
			htmlStr += "<caption></caption>";
			htmlStr += "<colgroup>";
			htmlStr += "<col style=\"width:130px;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:130px;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "</colgroup>";
			htmlStr += "<tbody>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">승인일자<span class=\"t-red\"> *</span></td>";
			htmlStr += "<td class=\"input-td\"><input id=\"datepicker3\" type=\"text\" name=\"DSPTH_DTM\" value=\"" + $recordM.DSPTH_DTM + "\" readonly=\"readonly\" autocomplete=\"off\" class=\"datepick smal\"></td>";
			htmlStr += "<td class=\"t-title\">처리결과</td>";
			htmlStr += "<td>" + $recordM.RECD_STS_TXT + "</td>";
			htmlStr += "</tr>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">비고<span class=\"t-red\"> *</span></td>";
			htmlStr += "<td colspan=\"3\" class=\"input-td\"><textarea rows=\"5\" name=\"DSPTH_REASON\">" + $recordM.DSPTH_REASON + "</textarea></td>";
			htmlStr += "</tr>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">첨부파일</td>";
			htmlStr += "<td colspan=\"3\" class=\"input-td\">";
			htmlStr += "<div class=\"fileBox\">";
			
			if(RECD_STS == 'KY' && "${sessionScope.userMap.GRP_SN}" == '1'){//공단접수 상태일때만
				htmlStr += "<input type=\"text\" class=\"fileName\" readonly=\"readonly\">";
				htmlStr += "<input type=\"file\" id=\"fileUp05\" name=\"file\" class=\"file-table uploadBtn\">";
				htmlStr += "<label for=\"fileUp05\" class=\"btn dark rmvcrr file-btn\">파일선택</label>";
			} else {
				var mcFileList = $recordM.MC_FILE_LIST;
				for(var i = 0; i < mcFileList.length; i++){
					htmlStr += "<a href=\"javascript:fnDownloadFile('" + mcFileList[i].FILE_SN + "');\"><span class=\"file-name\">"+ mcFileList[i].FILE_ORGIN_NM + "</span></a>";	
				}
				
			}
			
			htmlStr += "</div>";
			htmlStr += "</td>";
			htmlStr += "</tr>";
			htmlStr += "</tbody>";
			htmlStr += "</table>";
			htmlStr += "<div>";
			htmlStr += "</form>";
			
		$('#mcConfirmDiv').empty().append(htmlStr);	
		
		$("#datepicker3").datepicker({
			showOtherMonths: true,
			selectOhterMonth: true
		});
		
	}
	
	//문체부 담당자 승인,반려
	function fn_mcConfirm(RECD_STS){
		
		if($('#mFrm input[name=KD_ACCEPT_FLAG]').val() != 'Y'){
			fnAlert("공단 인정시간 등록을 진행해주시기 바랍니다.");
			return false;
		}
		
		if($('#mcFrm input[name=DSPTH_DTM]').val() == ''){
			fnFocAlert("승인일자를 선택해주세요.", $('#mcFrm input[name=DSPTH_DTM]'));
			return false;
		}
		
		if($('#mcFrm textarea[name=DSPTH_REASON]').val() == ''){
			fnFocAlert("비고를 입력해주세요.", $('#mcFrm textarea[name=DSPTH_REASON]'));
			return false;
		}
		
		var confirmMsg = "";
		var resultMsg = "";
		
		if(RECD_STS == 'MY'){
			confirmMsg = "문체부 승인 하시겠습니까?";
			resultMsg = "문체부 승인 되었습니다.";
		}else if(RECD_STS == 'MN'){
			confirmMsg = "문체부 미승인 하시겠습니까?";
			resultMsg = "문체부 미승인 되었습니다.";
		}else {
			fnAlert("오류가 발생하였습니다.[RECD_STS 상태값 오류]");
			return false;
		}
		
		if(!confirm(confirmMsg)){
			return false;
		}
		
		$('#mcFrm input[name=RECD_STS]').val(RECD_STS);
		$('#mcFrm input[name=VLUN_RECD_SN]').val($('#mFrm input[name=VLUN_RECD_SN]').val());
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/plan/mcConfirmJs.kspo", "mcFrm");
		
		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0){
				fn_recordAddPopupClose();
				fnAlert(resultMsg);
				fn_search();
			} else {
				fnAlert("접수/반려 처리에 실패하였습니다.");
				fn_search();
			}
		}
		
	}
	
	//첨부파일 추가
	function fn_addFile(tbId){
		var fileTrId = tbId + 'fileTr';
		
		var fileCnt = $('#tbRecord' + tbId).find('.uploadBtn2').length;
		$("#" + fileTrId).after(fn_addFileObj(fileCnt, tbId));
	}

	//첨부파일 삭제
	function fn_removeFile(obj){
		$(obj).parents("tr").remove();
	}
	
	
	//파일 생성 오브젝트
	function fn_addFileObj(fileCnt, tbId){
		var uploadBtnId = tbId + 'uploadBtn' + fileCnt;
		var addFileObj = "";
		addFileObj += '<tr>';
		addFileObj += '<td colspan="3" class="adds bdr-0 input-td">';
		addFileObj += '<div class="fileBox">';
		addFileObj += '<input type="text" class="fileName2" readonly="readonly">';
		addFileObj += '<label for="'+ uploadBtnId +'" class="btn_file btn navy addlist mrg-0 file-btn">파일첨부</label>';
		addFileObj += '<input type="file" name="file_' + tbId + '" id="' + uploadBtnId + '" class="uploadBtn2">';
		addFileObj += '</div>';
		addFileObj += '</td>';
		addFileObj += '<td class="bdl-0 pdr-0 ft-0">';
		addFileObj += '<button class="btn lightgrey removefile" type="button" onclick="fn_removeFile(this);"></button>';
		addFileObj += '</td>';
		addFileObj += '</tr>';
		
		return addFileObj;
	}
	
	
	//공익복무 사후 정정 화면 생성
	function fn_createAfterDiv($recordM, $recordD){

		var htmlStr = "";
			htmlStr += "<form id=\"afterFrm\" method=\"post\" enctype=\"multipart/form-data\">";
			htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_SN\"/ value=\"" + $recordM.VLUN_RECD_SN + "\">";
			htmlStr += "<input type=\"hidden\" name=\"RECD_STS\"/>"
			htmlStr += "<input type=\"hidden\" name=\"gMenuSn\" value=\"${param.gMenuSn}\">";
			htmlStr += "<div class=\"com-h3 add\">공익복무 사후정정";
			htmlStr += "<div class=\"rightArea\">";
			if('1' == "${sessionScope.userMap.GRP_SN}"){//공단 담당자일때
				htmlStr += "<button class=\"btn red type01\" type=\"button\" onclick=\"fn_saveAfterAccept();\" id=\"kdAftAcceptBtn\">사후정정 시간 저장</button>";
			}
			htmlStr += "</div>";
			htmlStr += "</div>";
			htmlStr += "<div class=\"com-table\">";
			htmlStr += "<table class=\"table-board\">";
			htmlStr += "<caption></caption>";
			htmlStr += "<colgroup>";
			htmlStr += "<col style=\"width:130px;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "</colgroup>";
			htmlStr += "<tbody>";
			htmlStr += "<tr>";
			htmlStr += "<td rowspan=\"2\" class=\"t-title\">인정시간</td>";
			htmlStr += "<td class=\"input-td\" colspan=\"2\">";
			htmlStr += "<table class=\"table-board\">";
			htmlStr += "<caption></caption>";
			htmlStr += "<colgroup>";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "<col style=\"width:auto;\">";
			htmlStr += "</colgroup>";
			htmlStr += "<head>";
			htmlStr += "<tr>";
			htmlStr += "<th>활동구분</th>";
			htmlStr += "<th>활동시간</th>";
			htmlStr += "<th>봉사지까지 거리</th>";
			htmlStr += "<th>봉사지까지 이동시간</th>";
			htmlStr += "<th>첨부파일</th>";
			htmlStr += "</tr>";
			htmlStr += "</head>";
			htmlStr += "<tbody>";
			
			var AFT_ACT_TIME_HR_TOT = 0;//사후정정 활동시간 합 - 시
			var AFT_ACT_TIME_MN_TOT = 0;//사후정정 활동시간 합 - 분
			var AFT_ACT_DIST_TOT = 0;	//사후정정 이동거리 합
			var AFT_WP_MV_TIME_TOT = 0;//사후정정 이동시간 합
			
			for(var i = 0; i < $recordD.length; i++){
				htmlStr += "<tr>";
				
				htmlStr += "<td class=\"t-title\">" + $recordD[i].ACT_PLACE;
				htmlStr += "<input type=\"hidden\" name=\"VLUN_RECD_D_SN\" value=\"" + $recordD[i].VLUN_RECD_D_SN + "\">";
				htmlStr += "<input type=\"hidden\" name=\"ATCH_FILE_ID1\" value=\"" + $recordD[i].ATCH_FILE_ID1 + "\">";
				htmlStr += "</td>";
				htmlStr += "<td class=\"input-td\"><input type=\"text\" name=\"AFT_ACT_TIME_HR\" value=\"" + $recordD[i].AFT_ACT_TIME_HR + "\" class=\"xs\" style=\"width:40px;\"> 시간";
				htmlStr += "<select name=\"AFT_ACT_TIME_MN\" class=\"smal\" style=\"width:100px;\">";
				
				var AFT_ACT_TIME_MN = $recordD[i].AFT_ACT_TIME_MN;
				
				for(var k = 0; k < actTimeCdList.length; k++){
					var altCode = actTimeCdList[k].ALT_CODE;
					var selected = (AFT_ACT_TIME_MN == altCode) ? 'selected=\"selected\"' : '';
					
					htmlStr += "<option value=\"" + altCode + "\"" + selected + ">" + actTimeCdList[k].CNTNT_FST + "</option>";
				}
				
				htmlStr += "</td>";
				htmlStr += "<td class=\"input-td\">";
				htmlStr += "<ul class=\"com-radio-list\">";

				<c:forEach var="actDistCd" items="${actDistCdList}" varStatus="sts">
				var aftActDistRIdx = "aftActDistRIdx_" + i + "_${sts.index}";
				var checkedFlag = ("${actDistCd.ALT_CODE}" == $recordD[i].AFT_ACT_DIST) ? "checked=\"checked\"" : "";
				
				htmlStr += "<li>";
				htmlStr += "<input id=\"" + aftActDistRIdx + "\"  type=\"radio\" value=\"${actDistCd.ALT_CODE}\" name=\"AFT_ACT_DIST_" + i + "\"" + checkedFlag + " onchange=\"fn_actDistChg(this, 'after');\">";
				htmlStr += "<label for=\"" + aftActDistRIdx + "\">${actDistCd.CNTNT_FST}</label>";
				htmlStr += "</li>";	
				</c:forEach>
				
				htmlStr += "</ul>";
				htmlStr += "</td>";
				
				htmlStr += "<td class=\"input-td\" style=\"text-align:center;\"><input type=\"text\" name=\"AFT_WP_MV_TIME\" value=\"" + $recordD[i].AFT_WP_MV_TIME + "\" class=\"xs\" readonly=\"readonly\"> 시간</td>";
				htmlStr += "<td class=\"input-td\" id=\"aftFileTd_" + $recordD[i].VLUN_RECD_D_SN + "\">";

				if($recordD[i].AFT_FILE_LIST.length == 0){//파일추가

					htmlStr += createAftFileAttach($recordD[i].VLUN_RECD_D_SN);
				
				} else {
					for(var k = 0; k < $recordD[i].AFT_FILE_LIST.length; k++){
						htmlStr += "<a href=\"javascript:fnDownloadFile('" + $recordD[i].AFT_FILE_LIST[k].FILE_SN + "');\"><span class=\"file-name\">" + $recordD[i].AFT_FILE_LIST[k].FILE_ORGIN_NM + "</span></a>";
						htmlStr += "<button class=\"file-del\" onclick=\"fn_aftFileDel('"+ $recordD[i].AFT_FILE_LIST[k].FILE_SN + "','" + $recordD[i].VLUN_RECD_D_SN + "', this);\"> 삭제</button>";
					}
				}
				
				htmlStr += "</td>";
				htmlStr += "</tr>";
				
				
				AFT_ACT_TIME_HR_TOT += Number($recordD[i].AFT_ACT_TIME_HR);				//활동시간 시간 합계
				AFT_ACT_TIME_MN_TOT += Number($recordD[i].AFT_ACT_TIME_MN);				//활동시간 분 합계
				
				AFT_WP_MV_TIME_TOT += Number($recordD[i].AFT_WP_MV_TIME);	//봉사지까지 이동시간	합계
			}
			
			//시간관련 계산
			var addedHr = Math.floor(AFT_ACT_TIME_MN_TOT / 60);
			var remainMn = AFT_ACT_TIME_MN_TOT % 60;
			AFT_ACT_TIME_HR_TOT = AFT_ACT_TIME_HR_TOT + addedHr;
			
			var totTimeHr = AFT_ACT_TIME_HR_TOT; 
			
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">합계</td>";
			htmlStr += "<td id=\"AFT_ACT_TIME_HR_TOT_TD\">" + AFT_ACT_TIME_HR_TOT + " 시간 " + remainMn + " 분</td>";
			htmlStr += "<td id=\"AFT_WP_MV_TIME_TOT_TD\">" + AFT_WP_MV_TIME_TOT +" 시간</td>";
			htmlStr += "</tr>";
			htmlStr += "</tbody>";
			htmlStr += "</table>";
			htmlStr += "</td>";
			htmlStr += "</tr>";
			htmlStr += "<tr>";
			htmlStr += "<td colspan=\"2\" class=\"center\">합계 : " + totTimeHr + " 시간 " + remainMn + "분</td>";
			htmlStr += "</tr>";
			htmlStr += "<tr>";
			htmlStr += "<td class=\"t-title\">비고</td>";
			htmlStr += "<td colspan=\"2\" class=\"input-td\"><textarea name=\"TOT_AFT_ACT_REASON\" rows=\"5\">" + $recordM.TOT_AFT_ACT_REASON + "</textarea></td>";
			htmlStr += "</tr>";
			htmlStr += "</tbody>";
			htmlStr += "</table>";
			htmlStr += "</div>";
			htmlStr += "</form>";
			htmlStr += "<!-- //공단 인정시간 등록 -->";
			
		$('#afterConfirmDiv').empty().append(htmlStr);	
		
	}
	
	function fn_actDistChg(obj, type){
		var value = $(obj).val();
		var time = 0;

		if(value == 'D1'){
			time = '1';
		} else if(value == 'D2'){
			time = '2';
		} else if(value == 'D3'){
			time = '3';
		} else if(value == 'D4'){
			time = '4';
		} else {
			fnAlert("봉사지까지 거리 코드에 문제가 발생하였습니다.");
			return false;
		}
		
		if(type == 'accept'){//공단 인정시간
			$(obj).parent().parent().parent().parent().find('input[name=PC_REC_WP_MV_TIME]').val(time);	
		} else if(type == 'after'){//사후정정
			$(obj).parent().parent().parent().parent().find('input[name=AFT_WP_MV_TIME]').val(time);
		}
		
	}
	
	//사후정정
	function fn_saveAfterAccept(){
		
		if(!fn_aftValidate()){
			return false;
		}
		
		if(!confirm("사후정정 시간을 저장 하시겠습니까?")){
			return false;
		}
		
		var $json = getJsonMultiData("${pageContext.request.contextPath}/plan/saveAfterAcceptJs.kspo", "afterFrm");

		if($json.statusText == "OK"){
			
			var resultCnt = $json.responseJSON.resultCnt;
			
			if(resultCnt > 0) {
				fn_recordAddPopupClose();
				fnAlert("사후인정 등록에 성공하였습니다.");
				fn_search();
			} else {
				fnAlert("사후정정 등록에 실패하였습니다.");
				fn_search();
			}
		}	
		
	}
	
	function fn_fileDel(FILE_SN, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			$(fileObj).parent().parent('tr').remove();
		}
	}
	
	function excel_download(){
		if(doubleSubmitCheck()) return;
		$("#searchFrm").attr("action","/plan/recordDownload.kspo");
		$("#searchFrm").submit();	
	}
	
	function fn_reportReq(){
		var jrfnm = "TrmvVlunConfirm.jrf";//리포트 파일명
		
		var VLUN_RECD_SN = $('#mFrm input[name=VLUN_RECD_SN]').val();
		if(VLUN_RECD_SN.length < 1){
			fnAlert("공익복무실적 순번이 존재하지않습니다.");
			return false;
		}
		
		var arg = "VLUN_RECD_SN#" + VLUN_RECD_SN;//전달 파타미터
		
		commnReportReq(jrfnm, arg, $("#searchFrm input[name=gMenuSn]").val());
	}
	
	function fn_hideDivBtn(){
		$('button[id=personSrhBtn]').hide();
		$('button[id=kdAcceptBtn]').hide();
		$('button[id=kdAftAcceptBtn]').hide();
		
		fn_setform('mFrm', true);
		fn_setform('kdFrm', true);
		fn_setform('mcFrm', true);
		fn_setform('afterFrm', true);
	}
	
	function fn_setform(formId, readonlyFlag){
		$('#' + formId + ' input').prop('readonly', readonlyFlag);
		$('#' + formId + ' input[type=radio]').prop('disabled', readonlyFlag);
		$('#' + formId + ' textarea').prop('disabled', readonlyFlag);
		$('#' + formId + ' select').prop('disabled', readonlyFlag);
		
		$('#kdFrm input[name=RECEIPT_DTM]').prop('readonly', true);
		$('#kdFrm input[name=PC_REC_WP_MV_TIME').prop('readonly', true);
		$('#afterFrm input[name=AFT_WP_MV_TIME]').prop('readonly', true);
		$('#afterFrm input[name=fileName]').prop('readonly', true);
		$('#mcFrm input[name=DSPTH_DTM]').prop('readonly', true);
	}
	
	function createAftFileAttach(VLUN_RECD_D_SN){
		var fileId = "afterFile_" + VLUN_RECD_D_SN;
		
		var htmlStr = "<div class=\"fileBox\">";
			htmlStr += "<input type=\"text\" class=\"fileName\" name=\"fileName\" readonly=\"readonly\" style=\"width:auto;\">";
			htmlStr += "<input type=\"file\" id=\"" + fileId + "\" name=\"" + fileId + "\" class=\"file-table uploadBtn\">";
			htmlStr += "<br><br><label for=\"" + fileId + "\" class=\"btn red rmvcrr file-btn\">파일선택</label>";
			htmlStr += "</div>";
		
		return htmlStr;
	}
	
	function fn_aftFileDel(FILE_SN, VLUN_RECD_D_SN, fileObj){
		
		if(!confirm("파일을 삭제하시겠습니까?")){
			return false;
		}
		
		var param = "FILE_SN=" + FILE_SN;
			param += "&gMenuSn=" + $("#searchFrm input[name=gMenuSn]").val();
		
		var $json = getJsonData("post", "${pageContext.request.contextPath}/file/delFileJs.kspo", param);
		
		if($json.statusText == "OK"){
			$(fileObj).parent().empty();
			$("#aftFileTd_" + VLUN_RECD_D_SN).append(createAftFileAttach(VLUN_RECD_D_SN));
		}
	}
	
	function fn_kdValidate(){
		
		//활동시간 + 이동거리시간의 합계가 12시간을 초과 할수 없음
		//이동거리시간은 D1[편도 100KM 미만] 일때 1시간 
		//			D2[편도 100KM 이상 200KM이하] 일때 2시간
		//			D3[편도 200KM 이상 300KM이하] 일때 3시간
		//			D4[편도 300KM이상] 일때 4시간
		
		var cnt = $('#kdFrm input[name=VLUN_RECD_D_SN]').length;
		
		for(var i = 0; i < cnt; i++){
			
			var PC_ACT_TIME_HR = $($('#kdFrm input[name=PC_ACT_TIME_HR]')[i]).val();
			var PC_ACT_TIME_MN = $($('#kdFrm select[name=PC_ACT_TIME_MN]')[i]).val();
			
			if(PC_ACT_TIME_HR == ''){
				fnFocAlert("활동시간을 입력해주세요.", $('#kdFrm input[name=PC_ACT_TIME_HR]')[i]);
				return false;
			}
			
			if(PC_ACT_TIME_MN == ''){
				fnFocAlert("활동시간의 분을 선택해주세요.", $('#kdFrm select[name=PC_ACT_TIME_MN]')[i]);
				return false;
			}
			
			var totTimeMn = 0;
			
			totTimeMn += Number(PC_ACT_TIME_HR) * 60;//활동시간 분으로
			totTimeMn += Number(PC_ACT_TIME_MN);//활동시간 분
			var ACT_DIST = $('input[name=ADMS_ACT_DIST_' + i + ']:checked').val();//이동거리 코드
			
			if(ACT_DIST == 'D1'){//이동거리에 따른 분처리
				totTimeMn += 60;
			} else if(ACT_DIST == 'D2'){
				totTimeMn += 120;
			} else if(ACT_DIST == 'D3'){
				totTimeMn += 180;
			} else if(ACT_DIST == 'D4'){
				totTimeMn += 240;
			} 
			
			if(totTimeMn > 60 * 12){
				fnAlert((i+1) + "번째의 활동시간 + 이동거리시간의 합이 12시간을 초과할수 없습니다.<br><br>편도 100km 미만 : 1시간<br>편도 100km 이상 200km미만 : 2시간<br>편도 200km 이상 300km이하 : 3시간<br>편도 300km 이상 : 4시간");
				return false;
			}
		}
		
		return true;
	}
	
	function fn_aftValidate(){
		
		//활동시간 + 이동거리시간의 합계가 12시간을 초과 할수 없음
		//이동거리시간은 D1[편도 100KM 미만] 일때 1시간 
		//			D2[편도 100KM 이상 200KM이하] 일때 2시간
		//			D3[편도 200KM 이상 300KM이하] 일때 3시간
		//			D4[편도 300KM이상] 일때 4시간
		
		var cnt = $('#afterFrm input[name=VLUN_RECD_D_SN]').length;
		
		for(var i = 0; i < cnt; i++){
			
			var AFT_ACT_TIME_HR = $($('#afterFrm input[name=AFT_ACT_TIME_HR]')[i]).val();
			var AFT_ACT_TIME_MN = $($('#afterFrm select[name=AFT_ACT_TIME_MN]')[i]).val();
			
			if(AFT_ACT_TIME_HR == ''){
				fnFocAlert("활동시간을 입력해주세요.", $('#afterFrm input[name=AFT_ACT_TIME_HR]')[i]);
				return false;
			}
			
			if(AFT_ACT_TIME_MN == ''){
				fnFocAlert("활동시간의 분을 선택해주세요.", $('#afterFrm select[name=AFT_ACT_TIME_MN]')[i]);
				return false;
			}
			
			var totTimeMn = 0;
			
			totTimeMn += Number(AFT_ACT_TIME_HR) * 60;//활동시간 분으로
			totTimeMn += Number(AFT_ACT_TIME_MN);//활동시간 분
			var ACT_DIST = $('input[name=AFT_ACT_DIST_' + i + ']:checked').val();//이동거리 코드
			
			if(ACT_DIST == '' || typeof(ACT_DIST) == 'undefined'){
				fnAlert("봉사지까지 거리를 선택해주세요.");
				return false;
			}
			
			if(ACT_DIST == 'D1'){//이동거리에 따른 분처리
				totTimeMn += 60;
			} else if(ACT_DIST == 'D2'){
				totTimeMn += 120;
			} else if(ACT_DIST == 'D3'){
				totTimeMn += 180;
			} else if(ACT_DIST == 'D4'){
				totTimeMn += 240;
			} 
			
			if(totTimeMn > 60 * 12){
				fnAlert((i+1) + "번째의 활동시간 + 이동거리시간의 합이 12시간을 초과할수 없습니다.<br><br>편도 100km 미만 : 1시간<br>편도 100km 이상 200km미만 : 2시간<br>편도 200km 이상 300km이하 : 3시간<br>편도 300km 이상 : 4시간");
				return false;
			}
		}
		
		return true;
	}
</script>

<div class="body-cont">
	<div class="body-area">
		<!-- 타이틀 -->
		<div class="com-title-group">
			<h2>공익복무 실적관리</h2>
		</div>
		<!-- //타이틀 -->
		
		<!-- 검색영역 -->
		<form id="searchFrm" method="post" action="${pageContext.request.contextPath}/plan/RecordMngSelect.kspo">
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
										<input id="datepicker1" name="srchRegDtmStart" type="text" value="${srchRegDtmStart}" maxlength="8" autocomplete="off" class="datepick smal"> ~ 
										<input id="datepicker2" name="srchRegDtmEnd" type="text" value="${srchRegDtmEnd}" maxlength="8" autocomplete="off" class="datepick smal">
									</li>
								</ul>
							</td>
							<td class="t-title">체육단체</td>
							<td>
								<select name="srchMemorgCd" class="smal">
									<c:if test="${sessionScope.userMap.GRP_SN ne 2}">
									<option value="" <c:if test="${param.srchMemorgCd eq '' or param.srchMemorgCd eq null }">selected="selected"</c:if>>전체</option>
									</c:if>
									<c:forEach var="subLi" items="${memorgCdList}">
									<option value="${subLi.MEMORG_SN}" <c:if test="${param.srchMemorgCd eq subLi.MEMORG_SN}">selected="selected"</c:if>>${subLi.MEMORG_NM}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">대상기관</td>
							<td><input type="text"  name="srchVlunPlcNm" value="${param.srchVlunPlcNm}" class="smal" placeholder="" onkeydown="if(event.keyCode == 13){fn_search();return false;}"></td>
							<td class="t-title">종목명</td>
							<td>
								<select id="srchGameCd" name="srchGameCd" class="smal">
<%-- 									<option value="" <c:if test="${param.srchGameCd eq '' or param.srchGameCd eq null}">selected="selected"</c:if>>전체</option> --%>
									<c:forEach var="subLi" items="${gameNmCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchGameCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="t-title">처리상태</td>
							<td>
								<select name="srchRecdStsCd" class="smal">
									<option value="" <c:if test="${param.srchRecdStsCd eq '' or param.srchRecdStsCd eq null }">selected="selected"</c:if>>전체</option>
									<c:forEach var="subLi" items="${recdStsCdList}">
										<option value="${subLi.ALT_CODE}" <c:if test="${param.srchRecdStsCd eq subLi.ALT_CODE}">selected="selected"</c:if>>${subLi.CNTNT_FST}</option>
									</c:forEach>
								</select>
							</td>
							<td class="t-title">구분</td>
							<td>
								<ul class="com-radio-list">
									<li>
										<input id="srchRadio1" type="radio" name="srchVlunPlcDvType" value="" <c:if test="${param.srchVlunPlcDvType eq '' or param.srchVlunPlcDvType eq null }">checked="checked"</c:if>>
										<label for="srchRadio1">전체</label>
									</li>
									<li>
										<input id="srchRadio2" type="radio" name="srchVlunPlcDvType" value="dom" <c:if test="${param.srchVlunPlcDvType eq 'dom' }">checked="checked"</c:if>>
										<label for="srchRadio2">국내</label>
									</li>
									<li>
										<input id="srchRadio3" type="radio" name="srchVlunPlcDvType" value="abr" <c:if test="${param.srchVlunPlcDvType eq 'abr' }">checked="checked"</c:if>>
										<label for="srchRadio3">국외</label>
									</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="t-title">키워드</td>
							<td colspan="3">
								<ul class="com-radio-list">
									<li>
										<select name="keyKind" class="smal">
											<option value="" <c:if test="${param.keyKind eq '' or param.keyKind eq null}">selected="selected"</c:if>>전체</option>
											<option value="USER_NAME" <c:if test="${param.keyKind eq 'USER_NAME'}">selected="selected"</c:if>>이름</option>
											<option value="GAME_NAME" <c:if test="${param.keyKind eq 'GAME_NAME'}">selected="selected"</c:if>>종목</option>
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
				<c:if test="${sessionScope.userMap.GRP_SN eq 2}"><!--가맹단체 -->
				<button class="btn red rmvcrr" type="button" onclick="fn_recordAddPopupOpen();">신규</button>
				</c:if>
				<button class="btn red type01" type="button" onclick="excel_download();">엑셀데이터 저장하기</button> <!-- 20211109 수정 -->
			</div>
		</div>
		</form>
		<div class="com-grid">
			<table class="table-grid">
				<caption></caption>
				<colgroup>
					<col style="width:50px">
					<col style="width:115px;">
					<col style="width:115px;">
					<col style="width:115px;">
					<col style="width:7%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:6%">
					<col style="width:115px">
					<col style="width:auto;">
					<col style="width:90px;">
					<col style="width:100px;">
					<col style="width:8%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>실적번호</th>
						<th>처리상태</th>
						<th>이름</th>
						<th>생년월일</th>
						<th>체육단체</th>
						<th>종목</th>
						<th>구분</th>
						<th>대상기관</th>
						<th>활동분야</th>
						<th>봉사건수</th>
						<th>인정시간</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty recordList}">
							<c:forEach var="record" items="${recordList}">
							<tr>
								<td>${record.RNUM}</td>
								<td>${record.VLUN_RECD_SN}</td>
								<td>${record.RECD_STS_NM}</td>
								<td><a href="javascript:fn_detail('${record.VLUN_RECD_SN}');" class="tit">${record.APPL_NM}</a></td>
								<td>${record.BRTH_DT}</td>
								<td>${record.MEMORG_NM}</td>
								<td>${record.GAME_CD_NM}</td>
								<td>${record.VLUN_PLC_DV_TXT}</td>
								<td>${record.VLUN_PLC_NM}</td>
								<td>${record.ACT_FIELD}</td>
								<td>${record.VLUN_RECD_CNT}</td>
								<td><c:if test="${empty record.FINAL_TIME_HR && empty record.FINAL_TIME_MN}">인정시간<br>미등록</c:if>
									<c:if test="${ not empty record.FINAL_TIME_HR}">${record.FINAL_TIME_HR}시간</c:if>
									<c:if test="${ not empty record.FINAL_TIME_MN}">${record.FINAL_TIME_MN}분</c:if>
								</td>	
								<td>
									<fmt:parseDate var="REG_DTM" value="${record.REG_DTM}" pattern="yyyyMMdd"/>
									<fmt:formatDate value="${REG_DTM}" pattern="yyyy-MM-dd"/>
								</td>
							</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="13" class="center">일치하는 게시물이 없습니다.</td>
							</tr>	
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
<div class="cpt-popup reg03" id="recordAddPopDiv"> <!-- class:active 팝업 on/off -->
	<div class="dim"></div>
	<div class="popup">
		<div class="pop-head">
			공익복무 실적등록
			<button class="pop-close">
				<img src="/common/images/common/icon_close.png" alt="닫기 버튼 이미지" onclick="fn_recordAddPopupClose();">
			</button>
		</div>
		<div class="pop-body">
			<div class="process-status">처리상태 : <b class="t-blue" id="recordStsTxtDiv">임시저장</b></div>
			<div class="com-h3 add">대상자 인적사항
				<div class="right-area"><p class="required">필수입력</p></div>
			</div>
			<form id="mFrm" method="post" onsubmit="return false;" enctype="multipart/form-data">
				<input type="hidden" name="VLUN_RECD_SN"/>
				<input type="hidden" name="RECD_STS"/>
				<input type="hidden" name="VLUN_PLAN_SN"/>
				<input type="hidden" name="APPL_SN"/>
				<input type="hidden" name="CHK_VLUN_PLC_NM"/>
				<input type="hidden" name="CHK_ACT_FIELD"/>
				<input type="hidden" name="CHK_ACT_PLACE"/>
				<input type="hidden" name="CHK_VLUN_PLC_ADDRESS"/>
				<input type="hidden" name="CHK_VLUN_TGT_TXT"/>
				<input type="hidden" name="CHK_PLC_MNGR_NM"/>
				<input type="hidden" name="CHK_PLC_MNGR_TEL_NO"/>
				<input type="hidden" name="CHK_VLUN_ACT_START"/>
				<input type="hidden" name="CHK_VLUN_ACT_END"/>
				<input type="hidden" name="KD_ACCEPT_FLAG"/>
				<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">

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
										<button type="button" onclick="fn_searchPersonPopupOpen();" id="personSrhBtn">찾기</button>
									</div>
								</td>
								<td class="t-title">관리번호</td>
								<td class="input-td" id="TD_APPL_SN"></td>
							</tr>
							<tr>
								<td class="t-title">생년월일</td>
								<td class="input-td" id="TD_BRTH_DT"></td>
								<td class="t-title">주소</td>
								<td class="input-td" id="TD_ADDR"></td>
							</tr>
							<tr>
								<td class="t-title">이메일</td>
								<td class="input-td" id="TD_EMAIL"></td>
								<td class="t-title">휴대폰</td>
								<td class="input-td" id="TD_CP_NO"></td>
							</tr>
							<tr>
								<td class="t-title">종목</td>
								<td class="input-td" id="TD_GAME_CD_NM"></td>
								<td class="t-title">체육단체</td>
								<td class="input-td" id="TD_MEM_ORG_NM"></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="com-h3 add">공익복무 계획
					<div class="right-area"><p class="t-red">※검색한 체육요원 대상의 승인된 공익복무계획 목록입니다.</p></div>
				</div>
				<div class="com-grid">
					<table class="table-grid">
						<caption></caption>
						<colgroup>
							<col style="width:50px">
							<col style="width:7%">
							<col style="width:11%">
							<col style="width:11%">
							<col style="width:11%">
							<col style="width:13%">
							<col style="width:13%">
							<col style="width:13%">
							<col style="width:10%">
							<col style="width:auto">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>구분</th>
								<th>활동분야</th>
								<th>대상기관</th>
								<th>담당자</th>
								<th>활동시작일자</th>
								<th>활동종료일자</th>
								<th>신청일</th>
								<th>처리상태</th>
								<th>선택</th>
							</tr>
						</thead>
						<tbody id="planTbody">
						</tbody>
					</table>
				</div>
				
				<div class="com-h3 add">공익복무 실적
					<div class="right-area"><p class="required">필수입력</p><p class="t-red">※위 공익복무계획을 선택하고 아래 실적을 등록하세요.</p></div>
				</div>

				<div class="com-table" id="recordAddDiv"></div>
	
				<div class="com-table">
					<table class="table-board">
						<caption></caption>
						<colgroup>
							<col style="width:160px;">
							<col style="width:auto;">
							<col style="width:150px;">
							<col style="width:auto;">
						</colgroup>
						<thead>
							<tr>
								<th colspan="4" class="add-btn">
									<div class="right-area">
										<button class="btn red rmvcrr userDv2" name="recdAddBtn" onclick="fn_addRecord();return false;">실적추가</button>
									</div>
								</th>
							</tr>
						</thead>
					</table>
				</div>
			</form>
				
			<!-- 공단 접수내용 -->
			<div id="kdConfirmDiv"></div>
			
			<!--  문체부 승인내역 -->
			<div id="mcConfirmDiv"></div>
			
			<!-- 공익복무 사후정정 -->
			<div id="afterConfirmDiv"></div>

			<div class="com-helf" id="lastUpdateDiv">
				<ol>
				<li  id="lastUpdateLi"></li>
				</ol>
			</div>
				
				<div class="com-btn-group put">
					<div class="float-r" id="recordButtonDiv"></div>
				</div>
		</div>
	</div>
</div>
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
										<c:forEach var="subLi" items="${gameNmCdList}">
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
								<th>계획 관리번호</th>
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