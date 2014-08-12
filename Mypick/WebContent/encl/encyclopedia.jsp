<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Article"%>
<%
String uriM = request.getParameter("uri");

MpickDao daoM = MpickDao.getInstance();
DataEntity[] menuDatas = daoM.getMenu();
%>
<!DOCTYPE">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Encyclopedia/MyPick</title>
<!-- 공통 라이브러리 시작 -->
<%@include file="../ctrl/header.jsp"%>
<!-- 공통 라이브러리 끝 -->
</head>
<body>
	<div class="container">

<!-- 상단 네비게이션 메뉴 시작 -->
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->

		<div class="row">
			<div class="col-sm-3">
<!-- 좌측 메뉴 시작 -->

<h2>Encyclopedia</h2>
<p class="text-muted">쇼퍼를 위한 백과사전</p>

<!-- 메뉴 링크 목록 시작 -->

<div class="list-group">
<%
for(DataEntity menuData : menuDatas){
	String menuId = (String)menuData.get("ar_menu_id");
	String menuName = (String)menuData.get("ar_menu_name");
%>
	<a href="<%=MpickParam.hostUrl%>/Encl/<%=menuId%>" class="list-group-item <%if(uriM.equals(menuId)){out.print("active");}%>"><%=menuName%></a>
<%	
}
%>
</div>

<!-- 메뉴 링크 목록 끝 -->

<!-- 환율 정보 시작 -->
<%@include file="../ctrl/currinfo.jsp"%>
<!-- 환율 정보 끝 -->

<!-- 좌측 메뉴 끝 -->
			</div>
			
			<div class="col-sm-9">
<!-- 우측 내용 시작 -->
<%@include file="../encl/enclBody.jsp"%>
<!-- 우측 내용 끝 -->
			</div>

		</div>
	</div>

</body>
</html>