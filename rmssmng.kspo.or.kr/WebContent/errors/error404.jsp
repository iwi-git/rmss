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
        .error .error-cont a {width: 500px; height: 65px; text-align: center; line-height: 65px; color: #fff; font-size: 20px; font-weight: 500; background: #01038a; margin: 30px auto; display: block;}
    </style>
</head>

<body>
	<div class="wrap">
		<div class="container">
            <div class="error">
                <div class="error-cont">
                    <p class="tit">404 죄송합니다. 현재 찾을 수 없는 페이지를 요청하셨습니다.<br/>${exceptionMsg}</p>
                    <p class="error">
                    	${exceptionCont}
                    </p>
                    <p class="detail">
                        방문 원하시는 페이지의 주소가 잘못 입력되었거나,<br>
                        변경 혹은 삭제되어 요청하신 페이지를 찾을 수가 없습니다.
                    </p>
                    <p class="detail">
                        입력하신 페이지의 주소가 정확한지 다시 한번 확인해 주시기 바랍니다.<br>
                        <b>감사합니다.</b>
                    </p>
                    <a href="/login/login.kspo">로그인화면으로 이동</a>
                </div>
            </div>
		</div>
	</div>
</body>
</html>