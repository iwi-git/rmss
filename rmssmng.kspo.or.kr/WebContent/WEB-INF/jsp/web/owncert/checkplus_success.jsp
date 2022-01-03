<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp" %>
<html>
<head>
    <title>NICE������ - CheckPlus �Ƚɺ������� �׽�Ʈ</title>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/common/js/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js?v=2"></script>
	
	<script type="text/javascript">
		
		function closeWindow() {
			
			self.opener = self;
			window.close();
			
		}
		
		$(document).ready(function() {
			
		});
		
		//���� �Ϸ� �� returnType ���̽����� �б� ó��
		switch('${certInfo.returnType}') {
			
			case "new" :
				
				opener.location.href = "javascript:certSuccess('new', '${certInfo.MNGR_NM}', '${certInfo.CPNO1}', '${certInfo.CPNO2}', '${certInfo.CPNO3}');";
				closeWindow();
				
				break;
			
			case "mngrInfo" :
				
				opener.location.href = "javascript:certSuccess('mngrInfo', '${certInfo.MNGR_NM}', '${certInfo.CPNO1}', '${certInfo.CPNO2}', '${certInfo.CPNO3}');";
				closeWindow();
				
				break;
				
			default :
				alert("������ ������ϴ� ��õڿ� �̿����ּ���.");
				closeWindow();
				
				break;
				
		}
		
	</script>
</head>
<body>
</body>
</html>