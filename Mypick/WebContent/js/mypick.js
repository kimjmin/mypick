function login(navForm){
	if ($("#loginEmail").val().length == 0) {
		alert("이메일을 입력하세요.");
		$("#loginEmail").focus();
		return;
	}
	if ($("#loginPw").val().length == 0) {
		alert("비밀번호를 입력하세요.");
		$("#loginPw").focus();
		return;
	}
	
	$("#cmd").val("login");
//	$("#toUrl").val("index.jsp");
	var frm = document.getElementById("navFrm");
	frm.action="../Confirm";
	frm.method="post";
	frm.submit();	
}

function signin(frm){
	frm.action="../signin.jsp";
	frm.method="post";
	frm.submit();	
}

function logout() {
	var frm = document.getElementById("navFrm");
	frm.cmd.value="logout";
	frm.action="../Confirm";
	frm.submit();
}