<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp" %>
<script type="text/javascript">
var returnType = "${ownCert.returnType}";

if( returnType == "new" ) {	// 회원가입
	fnAlert("잠시 뒤 다시 시도해주세요.");
}
window.self.close();
</script>