<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String m = request.getParameter("m"); 
if(m == null || m.equals("")){ m="fee"; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin/MyPick</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="../css/bootstrap.min.css">
<link rel="stylesheet" href="../css/mypick.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/jquery.number.min.js"></script>
</head>
<body>
	<div class="container">

<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->

		<div class="row">
			<div class="col-sm-3">			
<!-- 좌측 메뉴 시작 -->

<h2>Administrator</h2>
<p class="text-muted">관리자 페이지</p>

<!-- 메뉴 링크 목록 시작 -->	
<div class="list-group">
	<a href="../Admin/Ship" class="list-group-item <%if("ship".equals(m)){out.print("active");}%>">배송대행지 관리</a>
	<a href="../Admin/Encl" class="list-group-item <%if("encl".equals(m)){out.print("active");}%>">백과사전 관리</a>
	<a href="../Admin/Comm" class="list-group-item <%if("comm".equals(m)){out.print("active");}%>">커뮤니티 관리</a>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 환율 정보 시작 -->
<%@include file="../ctrl/currinfo.jsp"%>
<!-- 환율 정보 끝 -->
				
<!-- 좌측 메뉴 끝 -->
			</div>
			
			<div class="col-sm-9">
<!-- 우측 내용 시작 -->
<%
if("ship".equals(m)){
%><%@include file="../admin/admShip.jsp"%><%		
} else if("encl".equals(m)){
%><%@include file="../admin/admEncycle.jsp"%><%	
} else if("comm".equals(m)){
%><%@include file="../admin/amdComm.jsp"%><%	
}
%>


<!-- 우측 내용 끝 -->
			</div>

		</div>
	</div>

</body>
</html>
