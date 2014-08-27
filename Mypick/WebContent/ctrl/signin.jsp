<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>MyPick 회원 가입</title>
<!-- 공통 라이브러리 시작 -->
<%@include file="../ctrl/header.jsp"%>
<!-- 공통 라이브러리 끝 -->
<link rel="stylesheet" href="../css/signin.css">
<script src="../js/signin.js"></script>
</head>
<body>
<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->
<div class="container form-signin">
<h3>회원 가입 <small><span class="text-red">*</span> 표시는 필수 항목입니다.</small></h3>

<form role="form" name="signinFrm" action="javascript:signup();">
	<div class="row center-block">
		<h4>
			<label for="email1"><span class="text-red">*</span> 이메일 <small>아이디로 사용됩니다.</small></label>
		</h4>
		<div class="col-sm-5 form-signin-col">
			<div class="col-sm-5 form-signin-col">
				<input type="text" class="form-control" id="email1" name="email1" required="required" maxlength="60" />
			</div>
			<div class="col-sm-1 form-signin-col text-center"><h5>@</h5></div>
			<div class="col-sm-6 form-signin-col">
				<input type="text" class="form-control" id="email2" name="email2" required="required" maxlength="40" />
			</div>
		</div>
		<div class="col-sm-3 form-signin-col">
		<select class="form-control" id="email3" name="email3" onchange="setMail(this);">
			<option value="write" selected="selected">직접입력</option>
			<option value="gmail.com">gmail.com</option>
			<option value="naver.com">naver.com</option>
			<option value="daum.net">daum.net</option>
			<option value="hotmail.com">hotmail.com</option>
			<option value="nate.com">nate.com</option>
			<option value="empas.com">empas.com</option>
			<option value="dreamwiz.com">dreamwiz.com</option>
		</select>
		</div>
		<div class="col-sm-2">
			<button type="button" class="btn btn-primary btn-block" id="chIdBtn" onclick="checkMail();">중복확인</button>
		</div>
		<input type="hidden" id="email" name="email"/>
	</div>
	
	<div class="row center-block">
		<h4>
			<label for="id"><span class="text-red">*</span> 비밀번호 <small>12자 이내</small></label>
		</h4>
		<div class="col-sm-4 form-signin-col">
			<input type="password" class="form-control" id="passwd" name="passwd" placeholder="비밀번호" required="required" maxlength="12" />
		</div>
	</div>
	
	<div class="row center-block">
		<h4>
			<label for="passwd2"><span class="text-red">*</span> 비밀번호 확인</label>
			<small><span id="chkPw"></span></small>
		</h4>
		<div class="col-sm-4 form-signin-col">
		<input type="password" class="form-control" id="passwd2" name="passwd2" placeholder="비밀번호 확인" required="required" maxlength="12" onkeyup="chkPw();" />
		</div>
	</div>
	
	<div class="row center-block">
		<h4>
			<label for="name"><span class="text-red">*</span> 이름 (본명)</label>
		</h4>
		<div class="col-sm-4 form-signin-col">
			<input type="text" class="form-control" id="name" name="name" placeholder="이름" required="required" maxlength="5" />
		</div>
	</div>
	
	<div class="row center-block">
		<h4>
			<label for="nicname"><span class="text-red">*</span> 닉네임 <small>10자 이내</small></label>
		</h4>
		<div class="col-sm-4 form-signin-col">
			<input type="text" class="form-control" id="nicname" name="nicname" placeholder="닉네임" required="required" maxlength="10" />
		</div>
		<div class="col-sm-2">
			<button type="button" class="btn btn-primary btn-block" id="chNickBtn" onclick="checkNick();">중복확인</button>
		</div>
	</div>
	
	<div class="row center-block">
		<h4>
			<label for="birthday"><span class="text-red">*</span> 생년월일</label>
		</h4>
		<div class="col-sm-2 form-signin-col">
			<div class="col-xs-10 form-signin-col">
				<select class="form-control" id="birthY" name="birthY" onchange="setBDate();"></select>
			</div>
			<div class="col-xs-2 form-signin-col"><h5>년</h5></div> 
		</div>
		<div class="col-sm-2 form-signin-col">
			<div class="col-xs-10 form-signin-col">
				<select class="form-control" id="birthM" name="birthM" onchange="setBDate();"></select>
			</div>
			<div class="col-xs-2 form-signin-col"><h5>월</h5></div> 
		</div> 
		<div class="col-sm-2 form-signin-col">
			<div class="col-xs-10 form-signin-col">
				<select class="form-control" id="birthD" name="birthD"></select>
			</div>
			<div class="col-xs-2 form-signin-col"><h5>일</h5></div> 
		</div>
	
<script>
/** 생년월일 날짜 컨트롤 스크립트. */
var today = new Date();
for(var y = 0; y < 100; y++ ){
	if(y === 25){
		$("#birthY").append("<option value='"+(today.getFullYear()-y)+"' selected='selected'>"+(today.getFullYear()-y)+"</option>");
	} else {
		$("#birthY").append("<option value='"+(today.getFullYear()-y)+"'>"+(today.getFullYear()-y)+"</option>");
	}
}
for(var m = 1; m <= 12; m++ ){
	var mVar = m+"";
	if(m < 10){ mVar = "0"+mVar;}
	$("#birthM").append("<option value='"+mVar+"'>"+mVar+"</option>");
}
for(var d = 1; d <= 31; d++ ){
	var dVar = d+"";
	if(d < 10){ dVar = "0"+dVar;}
	$("#birthD").append("<option value='"+dVar+"'>"+dVar+"</option>");
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
	</div>
	
	<div class="row center-block">
		<h4>
			<label><span class="text-red">*</span> 성별</label>
		</h4>
		<div class="col-sm-2 form-signin-col">
			<input type="radio" id="genderM" name="gender" value="M" required="required" /> <label for="genderM">남성</label>
		</div>
		<div class="col-sm-2 form-signin-col">
			<input type="radio" id="genderF" name="gender" value="F" required="required" /> <label for="genderF">여성</label>
		</div>
	</div>
			
	<div class="row center-block">
		<h4>
			<label for="birthday">연락처 <small>(-) 없이 숫자만 입력하세요.</small></label>
		</h4>
		<div class="col-sm-4 form-signin-col">
			<input type="number" class="form-control" id="phone" name="phone">
		</div>
	</div>
	
	<div class="row center-block">
		<h4></h4>
		<div class="col-sm-2">
			<button type="submit" class="btn btn-success btn-block">회원 가입</button>
		</div>
		<div class="col-sm-2">
			<a type="button" class="btn btn-danger btn-block" href="javascript:history.go(-1);">취소</a>
		</div>
		<input type="hidden" name="cmd" />
		<input type="hidden" name="toUrl" />
	</div>
			
</form>
		
</div>
	
<!-- 하단 푸터 시작 -->
<%@include file="../ctrl/footer.jsp"%>
<!-- 하단 푸터 끝 -->
</body>
</html>
