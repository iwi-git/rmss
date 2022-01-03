<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var date = new Date();
		var year = date.getFullYear();
		var month = new String(date.getMonth()+1);
		
		var ym = year + month;
		
		//$("#INSPT_YM").val(ym);
		//$("#EXPR_YEAR").val(year);
	})
	
	//검색
	function fn_search(){
		fnPageLoad("/main/main.kspo",$("#sFrm").serialize());
	}
	
	function fn_gotoPage(){
		fnPageLoad("/account/AccountSelect.kspo",$("#sFrm").serialize());
	}
	
</script>
<div class="body-area">
	<form method="post" id="sFrm" name="sFrm" onsubmit="return false;"action="${pageContext.request.contextPath}/main/main.kspo">
			<input type="hidden" name="gMenuSn" value="${param.gMenuSn}">
			<input type="hidden" name="srchAcntSts" value="TA">
			
		<div class="sub-tit">
		    <div class="float-l">
		        <h3>업무분야별 처리현황</h3>
		    </div>
		</div>
		
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:auto">
		            <col style="width:15%">
		            <col style="width:15%">
		            <col style="width:15%">
		            <col style="width:15%">
		            <col style="width:15%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>업무구분</th>
		                <th>임시저장</th>
		                <th>접수대기</th>
		                <th>승인대기</th>
		                <th>승인완료</th>
		                <th>전체</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<c:choose>
							<c:when test="${not empty partCount}">
								<c:forEach items="${partCount}" var="list" varStatus="state">
									<tr>
						                <td>${list.DASH_NM}</td>					                
						                <td><span class="total-num"><b><fmt:formatNumber value="${list.TP_CNT}" pattern="#,###"/></b>건</span></td>
						                <td><span class="total-num"><b><fmt:formatNumber value="${list.TA_CNT}" pattern="#,###"/></b>건</span></td>
						                <td><span class="total-num"><b><fmt:formatNumber value="${list.KY_CNT}" pattern="#,###"/></b>건</span></td>
						                <td><span class="total-num"><b><fmt:formatNumber value="${list.MY_CNT}" pattern="#,###"/></b>건</span></td>
						                <td><span class="total-num"><b><fmt:formatNumber value="${list.ALL_CNT}" pattern="#,###"/></b>건</span></td>
						            </tr>
								</c:forEach>
							</c:when>
					</c:choose>
		        </tbody>
		    </table>
		</div>
		<c:if test="${sessionScope.userMap.GRP_SN eq 1}"><!--공단 담당자 -->
		<div class="com-caution">
		    <div class="float-l">
		        <div class="message">체육단체 사용자계정 신규신청 및 승인대기가 <span class="total-num"><b><fmt:formatNumber value="${applyCount.APPLY_CNT}" pattern="#,###"/></b></span>건 있습니다.</div>
		    </div>
		    <div class="float-r">
		        <button class="btn-more" onclick="fn_gotoPage()">체육단체 계정관리 바로가기</button>
		    </div>
		</div>
		</c:if>
		<div class="sub-tit">
		    <div class="float-l">
		        <h3>복무만료 대상자 현황</h3>
		    </div>
		</div>
		
		<div class="com-grid">
		    <table class="table-grid">
		        <caption></caption>
		        <colgroup>
		            <col style="width:auto">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		            <col style="width:7.5%">
		        </colgroup>
		        <thead>
		            <tr>
		                <th>전체</th>
		                <th>1월</th>
		                <th>2월</th>
		                <th>3월</th>
		                <th>4월</th>
		                <th>5월</th>
		                <th>6월</th>
		                <th>7월</th>
		                <th>8월</th>
		                <th>9월</th>
		                <th>10월</th>
		                <th>11월</th>
		                <th>12월</th>
		            </tr>
		        </thead>
		        <tbody>
		        	<c:choose>
							<c:when test="${not empty exprMmCount}">
								<tr>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON_ALL_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON01_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON02_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON03_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON04_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON05_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON06_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON07_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON08_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON09_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON10_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON11_CNT}" pattern="#,###"/></b>명</span></td>
					                <td><span class="total-num"><b><fmt:formatNumber value="${exprMmCount.MON12_CNT}" pattern="#,###"/></b>명</span></td>
					            </tr>
							</c:when>
					</c:choose>
		            
		        </tbody>
		    </table>
		</div>
	</form>
</div>
<!-- 팝업영역 -->
<div class="cpt-popup reg03 "> <!-- class:active 팝업 on/off -->
    <div class="dim"></div>
    <div class="popup">
        <div class="pop-head">
            사용자 계정정보
            <button class="pop-close">
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
                            <td class="input-td"><input type="text" class="ip-title"></td>
                            <td class="t-title">이름</td>
                            <td class="input-td"><input type="text" class="ip-title"></td>
                        </tr>
                        <tr>
                            <td class="t-title">비밀번호 변경</td>
                            <td class="input-td"><input type="password" class="ip-title"></td>
                            <td class="t-title">비밀번호 재확인</td>
                            <td class="input-td"><input type="password" class="ip-title"></td>
                        </tr>
                        <tr>
                            <td class="t-title">소속</td>
                            <td class="input-td"><input type="text" class="ip-title"></td>
                            <td class="t-title">부서</td>
                            <td class="input-td"><input type="text" class="ip-title"></td>
                        </tr>
                        <tr>
                            <td class="t-title">전화</td>
                            <td class="input-td type03">
                                <select id="" class="">
                                    <option value="선택">선택</option>
                                </select>
                                <span>-</span>
                                <input type="text" title="휴대전화 중간자리 입력">
                                <span>-</span>
                                <input type="text" title="휴대전화 뒷자리 입력">
                            </td>
                            <td class="t-title">휴대폰</td>
                            <td class="input-td type03">
                                <select id="" class="">
                                    <option value="선택">선택</option>
                                </select>
                                <span>-</span>
                                <input type="text" title="휴대전화 중간자리 입력">
                                <span>-</span>
                                <input type="text" title="휴대전화 뒷자리 입력">
                            </td>
                        </tr>
                        <tr>
                            <td class="t-title">이메일</td>
                            <td class="input-td">
                                <div class="email-box">
                                    <input type="text">
                                    <span class="text">~</span>
                                    <input type="text">
                                </div>
                            </td>
                            <td class="t-title"></td>
                            <td class="input-td"></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="com-btn-group put">
                <div class="float-l">
                    <span class="caution">※ 비밀번호는 영문, 숫자, 특수문자 중 6~16자 혼합사용</span>
                </div>
                <div class="float-r">
                    <button class="btn red rmvcrr" type="button">저장</button>
                    <button class="btn grey rmvcrr" type="button">닫기</button>
                </div>
            </div>
            
        </div>
    </div>
</div>
<!-- //팝업영역 -->