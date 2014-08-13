<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Comm"%>
<%
String bbsM = request.getParameter("bbs");
String m = request.getParameter("m");
if(bbsM == null || bbsM.equals("")){ bbsM="news"; }
if(m == null || m.equals("")){ m="list"; }

MpickDao daoM = MpickDao.getInstance();
DataEntity[] menuDatas = daoM.getCommMenu();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Community/MyPick</title>
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

<h2>Community</h2>
<p class="text-muted">커뮤니티</p>

<!-- 메뉴 링크 목록 시작 -->	
<div class="list-group">
<%
for(DataEntity menuData : menuDatas){
	String menuId = (String)menuData.get("bbs_menu_id");
	String menuName = (String)menuData.get("bbs_menu_name");
%>
	<a href="<%=MpickParam.hostUrl%>/Comm/<%=menuId%>" class="list-group-item <%if(bbsM.equals(menuId)){out.print("active");}%>"><%=menuName%></a>
<%	
}
%>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 좌측 메뉴 끝 -->			

			</div>

			<div class="col-sm-9">
<!-- 우측 내용 시작 -->
<%if("write".equals(m)){ %>
<%@include file="../comm/commWrite.jsp"%>
<%} else if("modyfy".equals(m)){ %>
<%@include file="../comm/commList.jsp"%>
<%} else { %>
<%@include file="../comm/commList.jsp"%>
<%} %>

<!-- 우측 내용 끝 -->		
			</div>
		</div>
	</div>

</body>
</html>