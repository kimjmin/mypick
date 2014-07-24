<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Article"%>
<%
String uriM = request.getParameter("uri");
String selMenuM = uriM.substring(uriM.lastIndexOf("Encl/")+5);

MpickDao daoM = MpickDao.getInstance();
DataEntity[] menuDatas = daoM.getMenu();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Calculator/MyPick</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="../css/bootstrap.min.css">
<link rel="stylesheet" href="../css/mypick.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/jquery.number.min.js"></script>
<script src="../js/mypick.js"></script>
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
	<a href="../Encl/<%=menuId%>" class="list-group-item <%if(selMenuM.equals(menuId)){out.print("active");}%>"><%=menuName%></a>
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