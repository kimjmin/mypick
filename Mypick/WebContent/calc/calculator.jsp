<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam,mpick.com.MpickDao,jm.net.DataEntity"%>
<%
String m = request.getParameter("m"); 
if(m == null || m.equals("")){ m="fee"; }

String uri = request.getRequestURI();
String subUri = uri.substring(uri.lastIndexOf("Calc/")+5);
String hid = "Calc";
String mid = "";
if("".equals(subUri)){
	subUri = "mid";
} else {
	mid = subUri; 
}
MpickDao daoM = MpickDao.getInstance();
DataEntity[] msgData = daoM.getMenuMsg(hid,mid,"TRUE");
%>
<!DOCTYPE html>
<html>
<head>
<title>Calculator/MyPick</title>
<!-- 공통 라이브러리 시작 -->
<%@include file="../ctrl/header.jsp"%>
<!-- 공통 라이브러리 끝 -->
<script src="<%=MpickParam.hostUrl%>/js/calc.js"></script>
</head>
<body>
<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->
	<div class="container">
		<div class="row">
			<div class="col-sm-3">			
<!-- 좌측 메뉴 시작 -->

<h2>Calculator</h2>
<p class="text-muted">쇼퍼를 위한 계산기</p>

<!-- 메뉴 링크 목록 시작 -->	
<div class="list-group">
	<a href="../Calc/Fee" class="list-group-item <%if("fee".equals(m)){out.print("active");}%>">배송 대행 요금비교</a>
<%--
	<a href="../Calc/Tax" class="list-group-item <%if("tax".equals(m)){out.print("active");}%>">면세 범위 계산표</a>
--%>
	<a href="../Calc/Trans" class="list-group-item <%if("trans".equals(m)){out.print("active");}%>">단위 변환기</a>
	<a href="../Calc/Volume" class="list-group-item <%if("volume".equals(m)){out.print("active");}%>">부피 / 무게 계산기</a>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 환율 정보 시작 -->
<%@include file="../ctrl/currinfo.jsp"%>
<!-- 환율 정보 끝 -->
				
<!-- 좌측 메뉴 끝 -->
			</div>
			
			<div class="col-sm-9">
<%if(msgData !=null && msgData.length == 1){ 
String mText = msgData[0].get("m_text")+"";
mText = mText.replaceAll("\r\n", "<br>");
%>
<div class="row">
	<blockquote>
		<p><%=msgData[0].get("m_title")+""%></p>
		<small><%=mText%></small>
	</blockquote>
</div>
<% } %>
<!-- 우측 내용 시작 -->
<%
if("fee".equals(m)){
%><%@include file="../calc/calcFee.jsp"%><%		
} else if("tax".equals(m)){
%><%@include file="../calc/calcTax.jsp"%><%	
} else if("trans".equals(m)){
%><%@include file="../calc/calcTrans.jsp"%><%	
} else if("volume".equals(m)){
%><%@include file="../calc/calcVolume.jsp"%><%	
}
%>
<!-- 우측 내용 끝 -->
			</div>

		</div>
	</div>
	
<!-- 하단 푸터 시작 -->
<%@include file="../ctrl/footer.jsp"%>
<!-- 하단 푸터 끝 -->
</body>
</html>
