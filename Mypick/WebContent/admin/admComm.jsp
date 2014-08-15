<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam"%>
<script>
function addMenu(){
	if($("#menuId").val() == ""){ alert("메뉴 id를 입력하세요."); $("#menuId").focus(); return; }
	if($("#menuName").val() == ""){ alert("메뉴명을 입력하세요."); $("#menuName").focus(); return; }
	$("#menus").append('<option value="'+$("#menuId").val()+'|'+$("#menuName").val()+'">'+$("#menuId").val()+' - '+$("#menuName").val()+'</option>');
	$("#cateMenu").append('<option value="'+$("#menuId").val()+'">'+$("#menuName").val()+'</option>');
	$("#cateMenuMod").append('<option value="'+$("#menuId").val()+'">'+$("#menuName").val()+'</option>');
	$("#menuId").val(""); $("#menuName").val("");
}
function delMenu(){
	if(confirm("선택하신 메뉴를 정말로 삭제하시겠습니까?\n\n해당 메뉴의 카테고리와 글들도 모두 삭제됩니다.")){
		var ind = $("#menus option").index($("#menus option:selected"));
		var preVal = $("#menus option:eq("+ind+")").val()+"";
		var cateSize = $("#cates option").size();
		for(var i=(cateSize-1); i>=0; i--){
			var catesVal = $("#cates option:eq("+i+")").val() + "";
			var catesVals = catesVal.split("|");
			var preVals = preVal.split("|");
			if(catesVals[0] === preVals[0] ){
				$("#cates option:eq("+i+")").remove();
			}
		}
		
		$("#menus option:eq("+ind+")").remove();
		$("#cateMenu option:eq("+ind+")").remove();
		$("#cateMenuMod option:eq("+ind+")").remove();
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
	var preVals = preVal.split("|");
	$("#commCate").append("<input type='hidden' name='menuChg' value='"+preVals[0]+","+menuIdVal+"'>");
	
	$("#menus option:eq("+ind+")").text(menuIdVal+' - '+menuNameVal);
	$("#menus option:eq("+ind+")").val(menuIdVal+'|'+menuNameVal);
	
	$("#cateMenu option:eq("+ind+")").text(menuNameVal);
	$("#cateMenu option:eq("+ind+")").val(menuIdVal);
	$("#cateMenuMod option:eq("+ind+")").text(menuNameVal);
	$("#cateMenuMod option:eq("+ind+")").val(menuIdVal);
	
	var cateSize = $("#cates option").size();
	for(var i=(cateSize-1); i>=0; i--){
		var catesVal = $("#cates option:eq("+i+")").val() + "";
		var catesVals = catesVal.split("|");
		if(catesVals[0] === preVals[0] ){
			$("#cates option:eq("+i+")").val(menuIdVal+"|"+catesVals[1]);
			$("#cates option:eq("+i+")").text(menuNameVal+" | "+catesVals[1]);
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
		$("#cateMenu option:eq("+ind+")").remove();
		$("#cateMenu option:eq("+(ind-1)+")").before('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
		$("#cateMenuMod option:eq("+ind+")").remove();
		$("#cateMenuMod option:eq("+(ind-1)+")").before('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
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
		$("#cateMenu option:eq("+ind+")").remove();
		$("#cateMenu option:eq("+ind+")").after('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
		$("#cateMenuMod option:eq("+ind+")").remove();
		$("#cateMenuMod option:eq("+ind+")").after('<option value="'+selVals[0]+'">'+selVals[1]+'</option>');
	}
}
/**
 * 카테고리 추가 삭제 변경 시작.
 */
function addCate(){
	if($("#cateMenu").val() == ""){ alert("상위 메뉴를 선택하세요."); $("#cateMenu").focus(); return; }
	if($("#cateName").val() == ""){ alert("카테고리명을 입력하세요."); $("#cateName").focus(); return; }
	$("#cates").append('<option value="'+$("#cateMenu option:selected").val()+'|'+$("#cateName").val()+'">'+$("#cateMenu option:selected").text()+' | '+$("#cateName").val()+'</option>');
	$("#cateName").val("");
}
function delCate(){
	if(confirm("선택하신 카테고리를 정말로 삭제하시겠습니까?\n\n해당 카테고리의 하위 카테고리들도 모두 삭제됩니다.")){
		var ind = $("#cates option").index($("#cates option:selected"));
		$("#cates option:eq("+ind+")").remove();
	}
}
function selCate(){
	var selVal = $("#cates").val() + '';
	var selVals = selVal.split('|');
	$("#cateMenuMod").val(selVals[0]); $("#cateNameMod").val(selVals[1]);
}
function modifyCate(){
	var cateIdVal = $("#cateMenuMod option:selected").val();
	var cateIdText = $("#cateMenuMod option:selected").text();
	var cateNameVal = $("#cateNameMod").val();
	var ind = $("#cates option").index($("#cates option:selected"));
	var preVal = $("#cates option:eq("+ind+")").val()+"";
	
	$("#cates option:eq("+ind+")").text(cateIdText+' | '+cateNameVal);
	$("#cates option:eq("+ind+")").val(cateIdVal+'|'+cateNameVal);
	
	$("#commCate").append("<input type='hidden' name='cage1Chg' value='"+preVal+","+cateIdVal+"|"+cateNameVal+"'>");
}
function upCate(){
	var ind = $("#cates option").index($("#cates option:selected"));
	if(ind > 0){
		var opText = $("#cates option:selected").text();
		var opVal = $("#cates option:selected").val()+"";
		$("#cates option:eq("+(ind-1)+")").before('<option value="'+opVal+'">'+opText+'</option>');
		$("#cates option:selected").remove();
		$("#cates").val(opVal);
	}
}
function downCate(){
	var ind = $("#cates option").index($("#cates option:selected"));
	if(ind < ($("#cates option").size()-1)){
		var opText = $("#cates option:selected").text();
		var opVal = $("#cates option:selected").val()+"";
		$("#cates option:eq("+(ind+1)+")").after('<option value="'+opVal+'">'+opText+'</option>');
		$("#cates option:selected").remove();
		$("#cates").val(opVal);
	}
}


/**
 * 메뉴, 카테고리 저장.
 */
function saveCate(){
	$("#saveCateBtn").attr("disabled",true);
	var frm = document.commCate;
	var menusVal = "";
	for(var i=0; i<$('#menus option').size(); i++){
		menusVal += $('#menus option:eq('+i+')').val();
		if(i<($('#menus option').size()-1)){
			menusVal += ",";
		}
	}
	var catesVal = "";
	for(var i=0; i<$('#cates option').size(); i++){
		catesVal += $('#cates option:eq('+i+')').val();
		if(i<($('#cates option').size()-1)){
			catesVal += ",";
		}
	}
	$("#menusVal").val(menusVal);
	$("#catesVal").val(catesVal);
	
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
	frm.submit();
}

/**
 * 메뉴, 카테고리 불러오기.
 */
$(document).ready(function(){
	var paramCate="cmd=commInfo";
	$.ajax({
		type : "GET",
		data : paramCate,
		url : "<%=MpickParam.hostUrl%>/Control/MpickAjax",
		dataType:"json",
		success : function(dataCate) {
			for(var i=0; i < dataCate.menu_info.length; i++){
				$("#menuId").val(dataCate.menu_info[i].menu_id);
				$("#menuName").val(dataCate.menu_info[i].menu_name);
				addMenu();
			}
			for(var i=0; i < dataCate.cate_info.length; i++){
				$("#cateMenu").val(dataCate.cate_info[i].menu_id);
				$("#cateName").val(dataCate.cate_info[i].cate_name);
				addCate();
			}
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});	
	
});

</script>

<form name="commCate" id="commCate">
	<div class="row">
		<div class="col-md-9">
			<h3>커뮤니티 메뉴 & 카테고리 편집</h3>
			<p class="text-muted">메뉴, 카테고리를 전부 편집 한 후에 저장버튼을 눌러 저장하세요.</p>
		</div>
		<div class="col-md-3">
			<h3>
			<button type="button" class="btn btn-primary btn-block" id="saveCateBtn" onclick="saveCate();">저장</button>
			</h3>
		</div>
		
	</div>
	
	<h4>메뉴</h4>
	<p class="text-muted">메뉴 id - 첫 글자만 대문자인 공백 없는 10자 이내의 영문자로 입력하세요. 접속 URL 주소가 됩니다.
  	<br/>메뉴명 - 20자 이내의 한글/영문자로 입력하세요. | , 특수 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 메뉴 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
	<div class="row">
		<div class="col-md-3">
			<input type="text" class="form-control" id="menuId" placeholder="메뉴 id" maxlength="10">
			<br/>
			<input type="text" class="form-control" id="menuName" placeholder="메뉴명"  maxlength="20">
		</div>
		<div class="col-md-6">
			<select multiple class="form-control" id="menus" onchange="selMenu()"></select>
			<input type="hidden" id="menusVal" name="menus"/>
		</div>
		<div class="col-md-3">
			<input type="text" class="form-control" id="menuIdMod">
			<br/>
			<input type="text" class="form-control" id="menuNameMod">
		</div>
	</div>
<br/>
	<div class="row">
		<div class="col-md-3">
			<button type="button" class="btn btn-info btn-block" onclick="addMenu();">메뉴 추가</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-warning btn-block" onclick="upMenu();">올리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-warning btn-block" onclick="downMenu();">내리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" onclick="delMenu();">삭제</button>
		</div>
		<div class="col-md-3">
			<button type="button" class="btn btn-success btn-block" onclick="modifyMenu();">메뉴명 / id 수정</button>
		</div>
	</div>

<br/>
	<h4>카테고리</h4>
	<p class="text-muted">카테고리가 포함될 메뉴를 선택하세요.
  	<br/>카테고리명 - 20자 이내의 한글/영문자로 입력하세요. | , 특수 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 카테고리 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-3">
			<select class="form-control" id="cateMenu"></select>
			<br/>
			<input type="text" class="form-control" id="cateName" placeholder="카테고리명"  maxlength="20">
		</div>
		<div class="col-md-6">
			<select multiple class="form-control" id="cates" onchange="selCate()"></select>
			<input type="hidden" id="catesVal" name="cates"/>
		</div>
		<div class="col-md-3">
			<select class="form-control" id="cateMenuMod"></select>
			<br/>
			<input type="text" class="form-control" id="cateNameMod">
		</div>
	</div>
<br/>
	<div class="row">
		<div class="col-md-3">
			<button type="button" class="btn btn-info btn-block" onclick="addCate();">카테고리 추가</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-warning btn-block" onclick="upCate();">올리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-warning btn-block" onclick="downCate();">내리기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" onclick="delCate();">삭제</button>
		</div>
		<div class="col-md-3">
			<button type="button" class="btn btn-success btn-block" onclick="modifyCate();">카테고리 수정</button>
		</div>
	</div>
	
	<input type="hidden" name="cmd" value="saveCommCate" />
	<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Admin/Comm" />
</form>