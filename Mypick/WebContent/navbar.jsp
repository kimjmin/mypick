<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickUserObj"%>
<%
	//사용자 로그인 체크하는 로직. 모든 페이지에 반드시 포함할것.
	MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
%>
<nav class="navbar navbar-inverse" role="navigation">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
			<span class="sr-only">상단 네비게이션</span>
		</button>
		<a class="navbar-brand" href="#">myPick</a>
	</div>
	
	<div class="collapse navbar-collapse navbar-ex1-collapse">
		<ul class="nav navbar-nav">
			<li id="navLiCal"><a href="#"><i class="glyphicon glyphicon-usd"></i> Calculator</a></li>
			<li id="navLiEncycle"><a href="encyclopedia.jsp"><i class="glyphicon glyphicon-book"></i> Encyclopedia</a></li>
			<li id="navLiComm"><a href="community.jsp"><i class="glyphicon glyphicon-user"></i> Community</a></li>
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
			<input type="hidden" id="toUrl" name="toUrl" />
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
			<input type="hidden" id="toUrl" name="toUrl" />
		</form>
		<ul class="nav navbar-nav navbar-right">
			<li><a><%=userObj.getNicname()%></a></li>
		</ul>
<%
}
%>

	</div>
</nav>