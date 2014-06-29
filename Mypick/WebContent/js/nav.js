function goCalc(){
	var frm = document.getElementById("navFrm");
	frm.toUrl.value="Calc";
	frm.method="POST";
	frm.action="../Calc/Fee";
	frm.submit();
}

function goEncl(){
	var frm = document.getElementById("navFrm");
	frm.toUrl.value="Encl";
	frm.method="POST";
	frm.action="../Encl/Atoz";
	frm.submit();
}

function goComm(){
	var frm = document.getElementById("navFrm");
	frm.toUrl.value="Comm";
	frm.method="POST";
	frm.action="../Comm/Mypage";
	frm.submit();
}