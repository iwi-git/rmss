<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp" %>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

	<title>체육요원 복무관리시스템</title>

    <style>
        /* 본고딕 Regular */
        @font-face {
        font-family: "NotoSans";
        font-style: normal;
        font-weight: 400;
        src: url("/common/webfont/NotoSansKR-Regular.eot");
        src: url("/common/webfont/NotoSansKR-Regular.eot?#iefix") format("embedded-opentype"), 
            url("/common/webfont/NotoSansKR-Regular.woff") format("woff");
        }
        /* 본고딕 Medium */
        @font-face {
        font-family: "NotoSans";
        font-style: normal;
        font-weight: 500;
        src: url("/common/webfont/NotoSansKR-Medium.eot");
        src: url("/common/webfont/NotoSansKR-Medium.eot?#iefix") format("embedded-opentype"), 
            url("/common/webfont/NotoSansKR-Medium.woff") format("woff");
        }
        /* 본고딕 Bold */
        @font-face {
        font-family: "NotoSans";
        font-style: normal;
        font-weight: 700;
        src: url("/common/webfont/NotoSansKR-Bold.eot");
        src: url("/common/webfont/NotoSansKR-Bold.eot?#iefix") format("embedded-opentype"), 
            url("/common/webfont/NotoSansKR-Bold.woff") format("woff");
        }
        html, body, div, span, h1, h2, h3, h4, h5, h6, p, b, i, dl, dt, dd, ol, ul, li {margin: 0;  padding: 0;  border: 0;  outline: 0;  font-size: 100%;  vertical-align: baseline;  background: transparent;}

        body {font-family: "NotoSans"; font-style: normal; font-weight: 400;}
        * {margin: 0;  padding: 0;  -webkit-text-size-adjust: none;  word-break: break-all; letter-spacing: -0.6px; -webkit-moz-box-sizing: border-box;  -ms-moz-box-sizing: border-box;  -o-moz-box-sizing: border-box;  box-sizing: border-box;}
        .wrap {min-width: 1580px; width: 100%;}
        .container {}
        .error {padding-top: 165px;}
        .error .error-cont {padding-top: 234px; background: url(/common/images/common/icon_error.png) center top no-repeat;}
        .error .error-cont p {margin-bottom: 28px; text-align: center;}
        .error .error-cont p:last-child {margin-bottom: 0;}
        .error .error-cont .tit {color: #1b2735; letter-spacing: -1.3px; font-size: 24px; font-weight: 700;}
        .error .error-cont .error {color: #444444; letter-spacing: -1px; font-size: 16px; text-align: left; padding: 0 0 0 150px;}
        .error .error-cont .detail {color: #444444; letter-spacing: -1px; font-size: 16px;}
        .error .error-cont .detail b {font-weight: 500;}
    </style>
</head>

<body>
	<div class="wrap">
		<div class="container">
            <div class="error">
                <div class="error-cont">
                    <p class="tit">503 죄송합니다. 현재 서버 과부하 또는 사용자 폭주로 인해 접속이 원활하지 않습니다.<br/>${exceptionMsg}</p>
                    <p class="error">
                    	${exceptionCont}
                    </p>
                    <p class="detail">
                        잠시 후  다시 한번 확인해 주시기 바랍니다.<br>
                        <b>감사합니다.</b>
                    </p>
                </div>
            </div>
		</div>
	</div>
</body>
</html>