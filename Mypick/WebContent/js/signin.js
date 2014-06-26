
var confVal = {
	"email" : "N",
	"passwd" : "N",
	"nicname" : "N",
};

function setMail(mailVal){
	if(mailVal.value == "write"){
		$("#email2").removeAttr("disabled");
		$("#email2").val("");
	} else {
		$("#email2").attr("disabled", "disabled");
		$("#email2").val(mailVal.value);
	}
}

// ID 중복 확인
function checkMail() {
	var mail1 = $("#email1").val();
	var mail2 = $("#email2").val();
	var tEmail = mail1+"@"+mail2;
	console.log(tEmail);
	$.ajax({
		type : "GET",
		data : "cmd=checkMail&email=" + tEmail,
		url : "MpickAjax",
		dataType:"json",
		success : function(data) {
			console.log(data);
			if (data.result == "OK") {
				alert("가입 가능한 메일입니다.");
				confVal.email = "Y";
			} else {
				alert("이미 가입되어 있는 메일입니다.");
				confVal.email = "N";
			}
		}
	});
}

function checkNick(){
	var nick = $("#nicname").val();
	$.ajax({
		type : "GET",
		data : "cmd=checkNick&nicname=" + nick,
		url : "MpickAjax",
		dataType:"json",
		success : function(data) {
			console.log(data);
			if (data.result == "OK") {
				alert("사용 가능한 닉네임 입니다.");
				confVal.nicname = "Y";
			} else {
				alert("이미 사용중인 닉네임 입니다.");
				confVal.nicname = "N";
			}
		}
	});
}

// PW 확인
function chkPw() {
	if ($("#passwd").val().length == 0) {
		$("#chkPw").text("비밀번호를 입력하세요.");
	} else {
		if ($("#passwd2").val() == $("#passwd").val()) {
			$("#chkPw").text("비밀번호가 일치합니다.");
			$("#chkPw").attr("class", "text-primary");
			
			confVal.passwd = "Y";
		} else {
			$("#chkPw").text("비밀번호가 일치하지 않습니다.");
			$("#chkPw").attr("class", "text-danger");
			confVal.passwd = "N";
		}
	}
}

function signin() {
	var frm = document.signinFrm;
	if(confVal.email == "Y" && confVal.passwd == "Y" && confVal.nicname == "Y"){
		if(confirm("입력하신 정보로 가입하시겠습니까?")){
			$("#email").val($("#email1").val()+"@"+$("#email2").val());
			console.log($("#email").val());
			frm.method="post";
			frm.cmd.value="insert";
			frm.toUrl.value="index.jsp";
			frm.action="Confirm";
			frm.submit();
		}
	} else if(confVal.email == "N"){
		alert("이메일 중복 확인이 되지 않았습니다.\n이메일 중복을 확인하십시오.");
	} else if(confVal.passwd == "N"){
		alert("비밀번호가 일치하지 않습니다.\n비밀번호를 확인하십시오.");
	} else if(confVal.nicname == "N"){
		alert("닉네임 중복 확인이 되지 않았습니다.\n이메일 중복을 확인하십시오.");
	} 
}
