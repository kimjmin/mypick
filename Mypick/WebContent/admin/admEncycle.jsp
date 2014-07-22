<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.ctrl.Article"%>
<% 
Article arc = new Article(); 
String encAtoz = arc.getArticle("ATOZ");
String encTax = arc.getArticle("TAX");
String encRefund = arc.getArticle("REFUND");
String encExchange = arc.getArticle("EXCHANGE");
%>
<script src="../js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({
    selector: "textarea#elm",
    theme: "modern",
    width: 800,
    height: 400,
    plugins: [
         "advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
         "save table contextmenu directionality emoticons template paste textcolor"
   ],
   content_css: "css/content.css",
   toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons", 
   style_formats: [
		{title: 'Header 1', block: 'h1'},
		{title: 'Header 2', block: 'h2'},
		{title: 'Header 3', block: 'h3'},
		{title: 'Header 4', block: 'h4'},
        {title: 'Bold text', inline: 'b'},
        {title: 'Red text', inline: 'span', styles: {color: '#ff0000'}}
    ]
});

function saveEnc(encType){
	var frm = document.encArticle;
	$("#encType").val(encType);
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}

/**
 * 메뉴 추가, 삭제, 변경 시작.
 */
function addMenu(){
	if($("#menuId").val() == ""){ alert("메뉴 id를 입력하세요."); $("#menuId").focus(); return; }
	if($("#menuName").val() == ""){ alert("메뉴명을 입력하세요."); $("#menuName").focus(); return; }
	$("#menus").append('<option value="'+$("#menuId").val()+'|'+$("#menuName").val()+'">'+$("#menuId").val()+' - '+$("#menuName").val()+'</option>');
	$("#cate1Menu").append('<option value="'+$("#menuId").val()+'">'+$("#menuName").val()+'</option>');
	$("#cate1MenuMod").append('<option value="'+$("#menuId").val()+'">'+$("#menuName").val()+'</option>');
	$("#menuId").val(""); $("#menuName").val("");
}
function delMenu(){
	if(confirm("선택하신 메뉴를 정말로 삭제하시겠습니까?\n\n해당 메뉴의 카테고리들도 모두 삭제됩니다.")){
		var ind = $("#menus option").index($("#menus option:selected"));
		var preVal = $("#menus option:eq("+ind+")").val()+"";
		var cate1Size = $("#cate1s option").size();
		for(var i=(cate1Size-1); i>=0; i--){
			var cate1sVal = $("#cate1s option:eq("+i+")").val() + "";
			var cate1sVals = cate1sVal.split("|");
			var preVals = preVal.split("|");
			if(cate1sVals[0] === preVals[0] ){
				$("#cate1s option:eq("+i+")").remove();
			}
		}
		
		$("#menus option:eq("+ind+")").remove();
		$("#cate1Menu option:eq("+ind+")").remove();
		$("#cate1MenuMod option:eq("+ind+")").remove();
	}
}
function selMenu(){
	var selVal = $("#menus").val() + '';
	var selVals = selVal.split('|');
	$("#menuIdMod").val(selVals[0]); $("#menuNameMod").val(selVals[1]);
}
function modifyMenu(){
	var menuIdVal = $("#menuIdMod").val();
	var menuNameVal = $("#menuNameMod").val();
	var ind = $("#menus option").index($("#menus option:selected"));
	var preVal = $("#menus option:eq("+ind+")").val()+"";
	$("#menus option:eq("+ind+")").text(menuIdVal+' - '+menuNameVal);
	$("#menus option:eq("+ind+")").val(menuIdVal+'|'+menuNameVal);
	
	$("#cate1Menu option:eq("+ind+")").text(menuNameVal);
	$("#cate1Menu option:eq("+ind+")").val(menuIdVal);
	$("#cate1MenuMod option:eq("+ind+")").text(menuNameVal);
	$("#cate1MenuMod option:eq("+ind+")").val(menuIdVal);
	
	var cate1Size = $("#cate1s option").size();
	for(var i=(cate1Size-1); i>=0; i--){
		var cate1sVal = $("#cate1s option:eq("+i+")").val() + "";
		var cate1sVals = cate1sVal.split("|");
		var preVals = preVal.split("|");
		if(cate1sVals[0] === preVals[0] ){
			$("#cate1s option:eq("+i+")").val(menuIdVal+"|"+cate1sVals[1]);
			$("#cate1s option:eq("+i+")").text(menuNameVal+" | "+cate1sVals[1]);
		}
	}
}
function upMenu(){
	var ind = $("#menus option").index($("#menus option:selected"));
	if(ind > 0){
		var opText = $("#menus option:selected").text();
		var opVal = $("#menus option:selected").val()+"";
		$("#menus option:eq("+(ind-1)+")").before('<option value="'+opVal+'">'+opText+'</option>');
		$("#menus option:selected").remove();
		$("#menus").val(opVal);
		
		var selVals = opVal.split('|');
		$("#cate1Menu option:eq("+ind+")").remove();
		$("#cate1Menu option:eq("+(ind-1)+")").before('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
		$("#cate1MenuMod option:eq("+ind+")").remove();
		$("#cate1MenuMod option:eq("+(ind-1)+")").before('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
	}
}
function downMenu(){
	var ind = $("#menus option").index($("#menus option:selected"));
	if(ind < ($("#menus option").size()-1)){
		var opText = $("#menus option:selected").text();
		var opVal = $("#menus option:selected").val()+"";
		$("#menus option:eq("+(ind+1)+")").after('<option value="'+opVal+'">'+opText+'</option>');
		$("#menus option:selected").remove();
		$("#menus").val(opVal);
		
		var selVals = opVal.split('|');
		$("#cate1Menu option:eq("+ind+")").remove();
		$("#cate1Menu option:eq("+ind+")").after('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
		$("#cate1MenuMod option:eq("+ind+")").remove();
		$("#cate1MenuMod option:eq("+ind+")").after('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
	}
}
/**
 * 카테고리 1 추가 삭제 변경 시작.
 */
function addCate1(){
	if($("#cate1Menu").val() == ""){ alert("상위 메뉴를 선택하세요."); $("#cate1Menu").focus(); return; }
	if($("#cate1Name").val() == ""){ alert("카테고리명을 입력하세요."); $("#cate1Name").focus(); return; }
	$("#cate1s").append('<option value="'+$("#cate1Menu option:selected").val()+'|'+$("#cate1Name").val()+'">'+$("#cate1Menu option:selected").text()+' | '+$("#cate1Name").val()+'</option>');
	$("#cate2cate").append('<option value="'+$("#cate1Menu option:selected").val()+'|'+$("#cate1Name").val()+'" title="'+$("#cate1Menu option:selected").text()+' | '+$("#cate1Name").val()+'">'+$("#cate1Name").val()+'</option>');
	$("#cate2cateMod").append('<option value="'+$("#cate1Menu option:selected").val()+'|'+$("#cate1Name").val()+'" title="'+$("#cate1Menu option:selected").text()+' | '+$("#cate1Name").val()+'">'+$("#cate1Name").val()+'</option>');
	$("#cate1Name").val("");
}
function delCate1(){
	if(confirm("선택하신 카테고리를 정말로 삭제하시겠습니까?\n\n해당 카테고리의 하위 카테고리들도 모두 삭제됩니다.")){
		var ind = $("#cate1s option").index($("#cate1s option:selected"));
		var preVal = $("#cate1s option:eq("+ind+")").val()+"";
		var cate2Size = $("#cate2s option").size();
		for(var i=(cate2Size-1); i>=0; i--){
			var cate2sVal = $("#cate2s option:eq("+i+")").val() + "";
			var cate2sVals = cate2sVal.split("|");
			var preVals = preVal.split("|");
			if(cate2sVals[0] === preVals[0] && cate2sVals[1] === preVals[1]){
				$("#cate2s option:eq("+i+")").remove();
			}
		}
		$("#cate1s option:eq("+ind+")").remove();
		$("#cate2cate option:eq("+ind+")").remove();
		$("#cate2cateMod option:eq("+ind+")").remove();
	}
}
function selCate1(){
	var selVal = $("#cate1s").val() + '';
	var selVals = selVal.split('|');
	$("#cate1MenuMod").val(selVals[0]); $("#cate1NameMod").val(selVals[1]);
}
function modifyCate1(){
	var cateIdVal = $("#cate1MenuMod option:selected").val();
	var cateIdText = $("#cate1MenuMod option:selected").text();
	var cateNameVal = $("#cate1NameMod").val();
	var ind = $("#cate1s option").index($("#cate1s option:selected"));
	var preVal = $("#cate1s option:eq("+ind+")").val()+"";
	$("#cate1s option:eq("+ind+")").text(cateIdText+' | '+cateNameVal);
	$("#cate1s option:eq("+ind+")").val(cateIdVal+'|'+cateNameVal);
	
	$("#cate2cate option:eq("+ind+")").after('<option value="'+cateIdVal+'|'+cateNameVal+'" title="'+cateIdText+' | '+cateNameVal+'">'+cateNameVal+'</option>');
	$("#cate2cateMod option:eq("+ind+")").after('<option value="'+cateIdVal+'|'+cateNameVal+'" title="'+cateIdText+' | '+cateNameVal+'">'+cateNameVal+'</option>');
	$("#cate2cate option:eq("+ind+")").remove();
	$("#cate2cateMod option:eq("+ind+")").remove();
	
	var cate2Size = $("#cate2s option").size();
	for(var i=(cate2Size-1); i>=0; i--){
		var cate2sVal = $("#cate2s option:eq("+i+")").val() + "";
		var cate2sVals = cate2sVal.split("|");
		var preVals = preVal.split("|");
		if(cate2sVals[0] === preVals[0] && cate2sVals[1] === preVals[1]){
			$("#cate2s option:eq("+i+")").val(cateIdVal+'|'+cateNameVal+"|"+cate2sVals[2]);
			$("#cate2s option:eq("+i+")").text(cateIdText+' | '+cateNameVal+" | "+cate2sVals[2]);
		}
	}
}
function upCate1(){
	var ind = $("#cate1s option").index($("#cate1s option:selected"));
	if(ind > 0){
		var opText = $("#cate1s option:selected").text();
		var opVal = $("#cate1s option:selected").val()+"";
		$("#cate1s option:eq("+(ind-1)+")").before('<option value="'+opVal+'">'+opText+'</option>');
		$("#cate1s option:selected").remove();
		$("#cate1s").val(opVal);
		
		var cate2Val = $("#cate2cate option:eq("+ind+")").val();
		var cate2Text = $("#cate2cate option:eq("+ind+")").text();
		$("#cate2cate option:eq("+ind+")").remove();
		$("#cate2cate option:eq("+(ind-1)+")").before('<option value="'+cate2Val+'" title="'+opText+'">'+cate2Text+'</option>');
		$("#cate2cateMod option:eq("+ind+")").remove();
		$("#cate2cateMod option:eq("+(ind-1)+")").before('<option value="'+cate2Val+'" title="'+opText+'">'+cate2Text+'</option>');
	}
}
function downCate1(){
	var ind = $("#cate1s option").index($("#cate1s option:selected"));
	if(ind < ($("#cate1s option").size()-1)){
		var opText = $("#cate1s option:selected").text();
		var opVal = $("#cate1s option:selected").val()+"";
		$("#cate1s option:eq("+(ind+1)+")").after('<option value="'+opVal+'">'+opText+'</option>');
		$("#cate1s option:selected").remove();
		$("#cate1s").val(opVal);
		
		var cate2Val = $("#cate2cate option:eq("+ind+")").val();
		var cate2Text = $("#cate2cate option:eq("+ind+")").text();
		$("#cate2cate option:eq("+ind+")").remove();
		$("#cate2cate option:eq("+ind+")").after('<option value="'+cate2Val+'" title="'+opText+'">'+cate2Text+'</option>');
		$("#cate2cateMod option:eq("+ind+")").remove();
		$("#cate2cateMod option:eq("+ind+")").after('<option value="'+cate2Val+'" title="'+opText+'">'+cate2Text+'</option>');
	}
}

/**
 * 카테고리 2 추가 삭제 변경 시작.
 */
function addCate2(){
	if($("#cate2cate").val() == ""){ alert("상위 카테고리를 선택하세요."); $("#cate2cate").focus(); return; }
	if($("#cate2Name").val() == ""){ alert("카테고리명을 입력하세요."); $("#cate2Name").focus(); return; }
	var menuVal = $("#cate2cate option:selected").val()+'';
	$("#cate1s").val(menuVal);
	var cate1Txt = $("#cate1s option:selected").text();
	$("#cate1s option:selected").removeAttr("selected");
	$("#cate2s").append('<option value="'+$("#cate2cate option:selected").val()+'|'+$("#cate2Name").val()+'">'+cate1Txt+' | '+$("#cate2Name").val()+'</option>');
	$("#cate2Name").val("");
}
function delCate2(){
	if(confirm("선택하신 카테고리를 정말로 삭제하시겠습니까?\n\n해당 카테고리에 속한 글들이 모두 삭제됩니다.")){
		var ind = $("#cate2s option").index($("#cate2s option:selected"));
		$("#cate2s option:eq("+ind+")").remove();
	}
}
function selCate2(){
	var selVal = $("#cate2s").val() + '';
	var selVals = selVal.split('|');
	
	$("#cate2cateMod").val(selVals[0]+'|'+selVals[1]);
	$("#cate2NameMod").val(selVals[2]);
}
function modifyCate2(){
	var cateIdVal = $("#cate2cateMod option:selected").val()+'';
	$("#cate1s").val(cateIdVal);
	var cate1Txt = $("#cate1s option:selected").text();
	$("#cate1s option:selected").removeAttr("selected");
	var cateNameVal = $("#cate2NameMod").val();
	var ind = $("#cate2s option").index($("#cate1s option:selected"));	
	$("#cate2s option:eq("+ind+")").text(cate1Txt+' | '+cateNameVal);
	$("#cate2s option:eq("+ind+")").val(cateIdVal+'|'+cateNameVal);
}
function upCate2(){
	var ind = $("#cate2s option").index($("#cate2s option:selected"));
	if(ind > 0){
		var opText = $("#cate2s option:selected").text();
		var opVal = $("#cate2s option:selected").val()+"";
		$("#cate2s option:eq("+(ind-1)+")").before('<option value="'+opVal+'">'+opText+'</option>');
		$("#cate2s option:selected").remove();
		$("#cate2s").val(opVal);
	}
}
function downCate2(){
	var ind = $("#cate2s option").index($("#cate2s option:selected"));
	if(ind < ($("#cate2s option").size()-1)){
		var opText = $("#cate2s option:selected").text();
		var opVal = $("#cate2s option:selected").val()+"";
		$("#cate2s option:eq("+(ind+1)+")").after('<option value="'+opVal+'">'+opText+'</option>');
		$("#cate2s option:selected").remove();
		$("#cate2s").val(opVal);
	}
}
</script>

<div class="container">
<div class="row">
	<ul id="fldFmtTab" class="nav nav-tabs">
		<li class="active"><a href="#cate" data-toggle="tab">카테고리 편집</a></li>
		<li ><a href="#arc" data-toggle="tab">백과사전 내용 입력</a></li>
	</ul>
	
	<div id="fldFmtTabContent" class="tab-content">

<!-- CSV 형식 시작 -->
<div class="tab-pane fade active in" id="cate">
<form name="encCate">
	<div class="row">
		<div class="col-md-6">
			<h3>카테고리 편집</h3>
			<p class="text-muted">메뉴, 카테고리1, 카테고리 2를 전부 편집 한 후에 저장버튼을 눌러 저장하세요.</p>
		</div>
		<div class="col-md-2">
			<h3>
			<button type="button" class="btn btn-primary btn-block" onclick="saveCate();">저장</button>
			</h3>
		</div>
		<div class="col-md-4"></div>
	</div>
	
<div class="container">
	<h4>메뉴</h4>
	<p class="text-muted">메뉴 id - 첫 글자만 대문자인 공백 없는 10자 이내의 영문자로 입력하세요. 접속 URL 주소가 됩니다.
  	<br/>메뉴명 - 20자 이내의 한글/영문자로 입력하세요. | 문자는 사용하면 안됩니다.
  	<br/>메뉴가 삭제되거나 변경되면 기존 메뉴에 등록된 카테고리들도 수정해야 합니다.
  	<br/>동시에 여러 메뉴 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<input type="text" class="form-control" id="menuId" placeholder="메뉴 id" maxlength="10">
			<br/>
			<input type="text" class="form-control" id="menuName" placeholder="메뉴명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="menus" onChange="selMenu()"></select>
		</div>
		<div class="col-md-2">
			<input type="text" class="form-control" id="menuIdMod">
			<br/>
			<input type="text" class="form-control" id="menuNameMod">
		</div>
	</div>
<br/>
	<div class="row">
		<div class="col-md-2">
			<button type="button" class="btn btn-info btn-block" onclick="addMenu();">메뉴 추가</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="upMenu();">올리기</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="downMenu();">내리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" onclick="delMenu();">선택 메뉴 삭제</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-success btn-block" onclick="modifyMenu();">메뉴명 / id 수정</button>
		</div>
	</div>
</div>

<br/>
<div class="container">
	<h4>카테고리 1</h4>
	<p class="text-muted">카테고리가 포함될 메뉴를 선택하세요.
  	<br/>카테고리명 - 20자 이내의 한글/영문자로 입력하세요. | 문자는 사용하면 안됩니다.
  	<br/>카테고리가 삭제되거나 변경되면 카테고리1에 등록된 카테고리 2 목록들도 수정해야 합니다.
  	<br/>동시에 여러 카테고리 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<select class="form-control" id="cate1Menu"></select>
			<br/>
			<input type="text" class="form-control" id="cate1Name" placeholder="카테고리명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="cate1s" onChange="selCate1()">
			</select>
		</div>
		<div class="col-md-2">
			<select class="form-control" id="cate1MenuMod"></select>
			<br/>
			<input type="text" class="form-control" id="cate1NameMod">
		</div>
	</div>
<br/>
	<div class="row">
		<div class="col-md-2">
			<button type="button" class="btn btn-info btn-block" onclick="addCate1();">카테고리 추가</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="upCate1();">올리기</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="downCate1();">내리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" onclick="delCate1();">선택 카테고리 삭제</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-success btn-block" onclick="modifyCate1();">카테고리 수정</button>
		</div>
	</div>
</div>

<br/>
<div class="container">
	<h4>카테고리 2</h4>
	<p class="text-muted">카테고리가 포함될 상위 카테고리를 선택하세요.
  	<br/>카테고리명 - 20자 이내의 한글/영문자로 입력하세요. | 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 카테고리 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<select class="form-control" id="cate2cate"></select>
			<br/>
			<input type="text" class="form-control" id="cate2Name" placeholder="카테고리명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="cate2s" onChange="selCate2()">
			</select>
		</div>
		<div class="col-md-2">
			<select class="form-control" id="cate2cateMod"></select>
			<br/>
			<input type="text" class="form-control" id="cate2NameMod">
		</div>
	</div>
<br/>
	<div class="row">
		<div class="col-md-2">
			<button type="button" class="btn btn-info btn-block" onclick="addCate2();">카테고리 추가</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="upCate2();">올리기</button>
		</div>
		<div class="col-md-1">
			<button type="button" class="btn btn-warning btn-block" onclick="downCate2();">내리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" onclick="delCate2();">선택 카테고리 삭제</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-success btn-block" onclick="modifyCate2();">카테고리 수정</button>
		</div>
	</div>
</div>
	
</form>
</div>

<div class="tab-pane fade in" id="arc">
<form name="encArticle">
	<div class="row">
		<div class="col-md-6">
			<h3>내용 입력</h3>
		</div>
		<div class="col-md-2">
			<h3>
			<button type="button" class="btn btn-primary btn-block" onclick="saveEnc('TAX');">저장</button>
			</h3>
		</div>
		<div class="col-md-4"></div>
	</div>
	<div class="row">
		<textarea id="elm" name="encText1"><%=encAtoz%></textarea>
	</div>
	<input type="hidden" name="cmd" value="saveEncl" />
	<input type="hidden" name="toUrl" value="../Admin/Encl" />
	<input type="hidden" id="encType" name="encType" />
</form>
</div>

	</div>	
</div>

</div>

<br/><br/>