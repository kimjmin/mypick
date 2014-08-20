<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Comm"%>
<%
String bbsM = request.getParameter("bbs");
String ctrlM = request.getParameter("ctrl");

MpickDao daoM = MpickDao.getInstance();
DataEntity[] menuDatas = daoM.getCommViewMenu();
int admMenuCntM = 0;
if(bbsM != null){
	admMenuCntM = daoM.getCommMenuAdminBbs(bbsM);
}
%>
<!DOCTYPE html>
<html>
<head>
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

<%if(admMenuCntM == 0){ %>
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
<% } %>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 좌측 메뉴 끝 -->			

			</div>

			<div class="col-sm-9">
<!-- 우측 내용 시작 -->
<%if("Write".equals(ctrlM)){ %>
<%@include file="../comm/commWrite.jsp"%>
<%} else if("View".equals(ctrlM)){ %>
<%@include file="../comm/commView.jsp"%>
<%} else { %>
<%@include file="../comm/commList.jsp"%>
<%} %>
<!-- 우측 내용 끝 -->		
			</div>
		</div>
<% } else { %>
<!-- 우측 내용 시작 -->
<%if("Write".equals(ctrlM)){ %>
<%@include file="../comm/commWrite.jsp"%>
<%} else if("View".equals(ctrlM)){ %>
<%@include file="../comm/commView.jsp"%>
<%} else { %>
<%@include file="../comm/commList.jsp"%>
<%} %>
<!-- 우측 내용 끝 -->
<% } %>
	</div>
<!-- 하단 푸터 시작 -->
<%@include file="../ctrl/footer.jsp"%>
<!-- 하단 푸터 끝 -->
</body>
</html>