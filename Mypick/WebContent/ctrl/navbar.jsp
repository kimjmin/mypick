<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickUserObj"%>
<%
	//사용자 로그인 체크하는 로직. 모든 페이지에 반드시 포함할것.
	MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
	
	String toUrl = request.getRequestURI();
	if (toUrl == null || toUrl.equals("")){ toUrl = "Calc/Fee"; }
	String pageName = "";
	if(toUrl.indexOf("Calc") > 0){
		pageName = "Calc";
	} else if (toUrl.indexOf("Encl") > 0){
		pageName = "Encl";
	} else if (toUrl.indexOf("Comm") > 0){
		pageName = "Comm";
	}
%>
<script src="../js/nav.js"></script>

<nav class="navbar navbar-inverse" role="navigation">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
			<span class="sr-only">상단 네비게이션</span>
		</button>
		<a class="navbar-brand" href="#">myPick</a>
	</div>
	
	<div class="collapse navbar-collapse navbar-ex1-collapse">
		<ul class="nav navbar-nav">
			<li id="navLiCal" <%if("Calc".equals(pageName)){ out.print("class=\"active\"");} %>><a href="javascript:goCalc(this.form);"><i class="glyphicon glyphicon-usd"></i> Calculator</a></li>
			<li id="navLiEncycle" <%if("Encl".equals(pageName)){ out.print("class=\"active\"");} %>><a href="javascript:goEncl(this.form);"><i class="glyphicon glyphicon-book"></i> Encyclopedia</a></li>
			<li id="navLiComm" <%if("Comm".equals(pageName)){ out.print("class=\"active\"");} %>><a href="javascript:goComm(this.form);"><i class="glyphicon glyphicon-user"></i> Community</a></li>
		</ul>
<%
if(userObj == null){
%>
		<form id="navFrm" name="navFrm" class="navbar-form navbar-right btn-group" action="javascript:login(this);">
			<div class="form-group">
				<input id="loginEmail" name="loginEmail" type="email" class="form-control" required="required" placeholder="이메일">
				<input id="loginPw" name="loginPw" type="password" class="form-control" required="required" placeholder="비밀번호">
				<button type="submit" class="btn btn-primary">로그인</button>
				<button type="button" class="btn btn-success" onclick="signin(this.form);">회원가입</button>
			</div>
			<input type="hidden" id="cmd" name="cmd" />
			<input type="hidden" id="toUrl" name="toUrl" value="<%=toUrl%>" />
		</form>
<%	
} else {
%>
		<form id="navFrm" name="navFrm" class="navbar-form navbar-right btn-group" role="search">
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<i class="glyphicon glyphicon-cog"></i>
				<span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#">사용자정보 변경</a></li>
				<li><a href="#">환경설정</a></li>
				<li class="divider"></li>
				<li><a href="#">고객지원</a></li>
				<li class="divider"></li>
				<li><a href="javascript:logout();">로그아웃</a></li>
			</ul>
			<input type="hidden" id="cmd" name="cmd" />
			<input type="hidden" id="toUrl" name="toUrl" value="<%=toUrl%>" />
		</form>
		<ul class="nav navbar-nav navbar-right">
			<li class="active"><a><%=userObj.getNicname()%> 님</a></li>
			<li class="active"><a><button class="btn btn-warning btn-xs"><%=userObj.getPoint()%></button></a></li>
		</ul>
<%
}
%>

	</div>
</nav>