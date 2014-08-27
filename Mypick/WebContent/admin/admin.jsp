<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String m = request.getParameter("m"); 
if(m == null || m.equals("")){ m="fee"; }
%>
<!DOCTYPE html>
<html>
<head>
<title>Administrator/MyPick</title>
<!-- 공통 라이브러리 시작 -->
<%@include file="../ctrl/header.jsp"%>
<!-- 공통 라이브러리 끝 -->
</head>
<body>
<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->
	<div class="container">
		<div class="row">
			<div class="col-sm-3">			
<!-- 좌측 메뉴 시작 -->

<h2>Administrator</h2>
<p class="text-muted">관리자 페이지</p>

<!-- 메뉴 링크 목록 시작 -->	
<div class="list-group">
	<a href="<%=MpickParam.getHostUrl()%>/Admin/Ship" class="list-group-item <%if("ship".equals(m)){out.print("active");}%>">배송대행지 관리</a>
	<a href="<%=MpickParam.getHostUrl()%>/Admin/Encl" class="list-group-item <%if("encl".equals(m)){out.print("active");}%>">백과사전 관리</a>
	<a href="<%=MpickParam.getHostUrl()%>/Admin/Comm" class="list-group-item <%if("comm".equals(m)){out.print("active");}%>">커뮤니티 관리</a>
	<a href="<%=MpickParam.getHostUrl()%>/Admin/Msg" class="list-group-item <%if("msg".equals(m)){out.print("active");}%>">메시지/링크 관리</a>
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
%><%@include file="../admin/admComm.jsp"%><%	
} else if("msg".equals(m)){
%><%@include file="../admin/admMsg.jsp"%><%	
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
