<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickMsg,java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="description" content="">
<meta name="author" content="">

<title>MyPick 회원정보 수정</title>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="../js/signin.js"></script>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="../css/bootstrap.min.css">
<link rel="stylesheet" href="../css/style.css">
		
</head>
<body>

	<div class="container">
		
<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->
<%
if(userObj == null){
	out.print(MpickMsg.loginError());
} else {
%>

		<div class="container">
		<form class="form-inline" role="form" name="signinFrm" action="javascript:modify();">
		
			<div class="row">
				<div class="container">
					<h4>
						<label for="email1">이메일 <small>이메일은 변경할 수 없습니다.</small></label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="text" class="form-control" id="email1" name="email1" disabled="disabled" value="<%=userObj.getEmail()%>">
					</div>
					<input type="hidden" id="email" name="email" value="<%=userObj.getEmail()%>"/>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="id">기존 비밀번호 <small>기존 비밀번호를 입력하세요</small></label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="password" class="form-control" id="prepasswd" name="prepasswd" placeholder="기존 비밀번호" required="required" maxlength="12" />
					</div>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="id">새 비밀번호 <small>새 비밀번호를 입력하세요. 12자리 이내</small></label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="password" class="form-control" id="passwd" name="passwd" placeholder="새 비밀번호" required="required" maxlength="12" />
					</div>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="passwd2">새 비밀번호 확인</label>
						<small><span id="chkPw"></span></small>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="password" class="form-control" id="passwd2" name="passwd2" placeholder="새 비밀번호 확인" required="required" maxlength="12" onkeyup="chkPw();" />
					</div>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="name">이름(본명)</label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="text" class="form-control" id="name" name="name" placeholder="이름" required="required" maxlength="5"  value="<%=userObj.getName()%>"/>
					</div>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="nicname">닉네임 <small>10자 이내</small></label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="text" class="form-control" id="nicname" name="nicname" placeholder="닉네임" required="required" maxlength="10"  value="<%=userObj.getNicname()%>"/>
						<button type="button" class="btn btn-primary" id="chNickBtn" onclick="checkModifNick('<%=userObj.getNicname()%>');">중복확인</button>
					</div>
				</div>
			</div>
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="birthday">생년월일</label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<select class="form-control" id="birthY" name="birthY" onchange="setBDate();">
						</select> 년 
					</div>
					<div class="form-group">
						<select class="form-control" id="birthM" name="birthM" onchange="setBDate();">
						</select> 월 
					</div> 
					<div class="form-group">
						<select class="form-control" id="birthD" name="birthD">
						</select> 일 
					</div>
				</div>
			</div>
<%
String by = new SimpleDateFormat("yyyy").format(userObj.getBirthday());
String bm = new SimpleDateFormat("MM").format(userObj.getBirthday());
String bd = new SimpleDateFormat("dd").format(userObj.getBirthday());
%>
<script>
/** 생년월일 날짜 컨트롤 스크립트. */
var today = new Date();
for(var y = 0; y < 100; y++ ){
	if((today.getFullYear()-y) === <%=by%>){
		$("#birthY").append("<option value='"+(today.getFullYear()-y)+"' selected='selected'>"+(today.getFullYear()-y)+"</option>");
	} else {
		$("#birthY").append("<option value='"+(today.getFullYear()-y)+"'>"+(today.getFullYear()-y)+"</option>");
	}
}
for(var m = 1; m <= 12; m++ ){
	var mVar = m+"";
	if(m < 10){ mVar = "0"+mVar;}
	if(mVar ==="<%=bm%>"){
		$("#birthM").append("<option value='"+mVar+"' selected='selected'>"+mVar+"</option>");
	} else {
		$("#birthM").append("<option value='"+mVar+"'>"+mVar+"</option>");	
	}
}
for(var d = 1; d <= 31; d++ ){
	var dVar = d+"";
	if(d < 10){ dVar = "0"+dVar;}
	if(dVar === "<%=bd%>"){
		$("#birthD").append("<option value='"+dVar+"' selected='selected'>"+dVar+"</option>");
	} else {
		$("#birthD").append("<option value='"+dVar+"'>"+dVar+"</option>");
	}
}

// 년/월 선택시 일 변경.
function setBDate(){
	var mVal = $("#birthM").val();
	$("#birthD option[value='29']").remove();
	$("#birthD option[value='30']").remove();
	$("#birthD option[value='31']").remove();
	if(mVal==2){
		// 윤달 계산
		if( ($("#birthY").val() % 4 ) == 0 && ($("#birthY").val() % 100 ) !=0 || ($("#birthY").val() % 400 ) == 0){
			$("#birthD").append("<option value='29'>29</option>");
		}
	} else if(mVal==1 || mVal==3 || mVal==5 || mVal==7 || mVal==8 || mVal==10 || mVal==12){
		$("#birthD").append("<option value='29'>29</option>");
		$("#birthD").append("<option value='30'>30</option>");
		$("#birthD").append("<option value='31'>31</option>");
	} else {
		$("#birthD").append("<option value='29'>29</option>");
		$("#birthD").append("<option value='30'>30</option>");
	}
}
</script>

			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label>성별</label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group col-md-1">
						<input type="radio" id="genderM" name="gender" value="M" required="required" <%if("M".equals(userObj.getGender())){out.print("checked=\"checked\"");}%>/> <label for="genderM">남성</label>
					</div>
					<div class="form-group col-md-1">
						<input type="radio" id="genderF" name="gender" value="F" required="required" <%if("F".equals(userObj.getGender())){out.print("checked=\"checked\"");}%>/> <label for="genderF">여성</label>
					</div>
				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<h4>
						<label for="birthday">전화번호 <small>(-) 없이 숫자만 입력하세요.</small></label>
					</h4>
				</div>
				<div class="container">
					<div class="form-group">
						<input type="number" id="phone" name="phone" required="required" value="<%=userObj.getPhone()%>"/>
					</div>

				</div>
			</div>
			
			<br/>
			<div class="row">
				<div class="container">
					<div class="col-md-2">
						<button type="submit" class="btn btn-success btn-block">회원정보 수정</button>
					</div>
					<div class="col-md-2">
						<a type="button" class="btn btn-danger btn-block" href="javascript:history.go(-1);">취소</a>
					</div>
					<input type="hidden" name="cmd" />
					<input type="hidden" name="toUrl" />
				</div>
			</div>
			
		</form>
		
		</div>
	</div>
	
	
</body>
</html>
<% } %>