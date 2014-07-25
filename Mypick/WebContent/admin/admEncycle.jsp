<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
String enclTab = request.getParameter("enclTab");
if(enclTab == null || "".equals(enclTab)){
	enclTab = "cate";
}

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
				
				var preCate1Val = $("#cate1s option:eq("+i+")").val()+"";
				var cate2Size = $("#cate2s option").size();
				for(var j=(cate2Size-1); j>=0; j--){
					var cate2sVal = $("#cate2s option:eq("+j+")").val() + "";
					var cate2sVals = cate2sVal.split("|");
					var preCate1Vals = preCate1Val.split("|");
					if(cate2sVals[0] === preCate1Vals[0] && cate2sVals[1] === preCate1Vals[1]){
						$("#cate2s option:eq("+j+")").remove();
					}
				}
				$("#cate2cate option:eq("+i+")").remove();
				$("#cate2cateMod option:eq("+i+")").remove();
				
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
			
			var preCate1Val = $("#cate1s option:eq("+i+")").val()+"";
			var preCate1Txt = $("#cate1s option:eq("+i+")").text()+"";
			var preCate1Vals = preCate1Val.split("|");
			var preCate1Txts = preCate1Txt.split("|");
			var cate1IdVal = preCate1Vals[0];
			var cate1NameVal = preCate1Vals[1];
			var cate1IdText = preCate1Txts[0];
			$("#cate2cate option:eq("+i+")").after('<option value="'+cate1IdVal+'|'+cate1NameVal+'" title="'+cate1IdText+' | '+cate1NameVal+'">'+cate1NameVal+'</option>');
			$("#cate2cateMod option:eq("+i+")").after('<option value="'+cate1IdVal+'|'+cate1NameVal+'" title="'+cate1IdText+' | '+cate1NameVal+'">'+cate1NameVal+'</option>');
			$("#cate2cate option:eq("+i+")").remove();
			$("#cate2cateMod option:eq("+i+")").remove();
			var cate2Size = $("#cate2s option").size();
			for(var j=(cate2Size-1); j>=0; j--){
				var cate2sVal = $("#cate2s option:eq("+j+")").val() + "";
				var cate2sVals = cate2sVal.split("|");
				if(cate2sVals[0] === preCate1Vals[0] && cate2sVals[1] === preCate1Vals[1]){
					$("#cate2s option:eq("+j+")").val(cate1IdVal+'|'+cate1NameVal+'|'+cate2sVals[2]);
					$("#cate2s option:eq("+j+")").text(cate1IdText+' | '+cate1NameVal+' | '+cate2sVals[2]);
				}
			}
			
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
		$("#cate2cate option:eq("+ind+")").remove();
		$("#cate2cateMod option:eq("+ind+")").remove();
		$("#cate1s option:eq("+ind+")").remove();
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
			$("#cate2s option:eq("+i+")").val(cateIdVal+'|'+cateNameVal+'|'+cate2sVals[2]);
			$("#cate2s option:eq("+i+")").text(cateIdText+' | '+cateNameVal+' | '+cate2sVals[2]);
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

/**
 * 메뉴, 카테고리 저장.
 */
function saveCate(){
	$("#saveCateBtn").attr("disabled",true);
	var frm = document.encCate;
	var menusVal = "";
	for(var i=0; i<$('#menus option').size(); i++){
		menusVal += $('#menus option:eq('+i+')').val();
		if(i<($('#menus option').size()-1)){
			menusVal += ",";
		}
	}
	var cate1sVal = "";
	for(var i=0; i<$('#cate1s option').size(); i++){
		cate1sVal += $('#cate1s option:eq('+i+')').val();
		if(i<($('#cate1s option').size()-1)){
			cate1sVal += ",";
		}
	}
	var cate2sVal = "";
	for(var i=0; i<$('#cate2s option').size(); i++){
		cate2sVal += $('#cate2s option:eq('+i+')').val();
		if(i<($('#cate2s option').size()-1)){
			cate2sVal += ",";
		}
	}
	$("#menusVal").val(menusVal);
	$("#cate1sVal").val(cate1sVal);
	$("#cate2sVal").val(cate2sVal);
	
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}

var arcCateData;
/**
 * 메뉴, 카테고리 불러오기.
 */
$(document).ready(function(){
	var paramCate="cmd=cateInfo";
	$.ajax({
		type : "GET",
		data : paramCate,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataCate) {
			for(var i=0; i < dataCate.menu_info.length; i++){
				$("#menuId").val(dataCate.menu_info[i].menu_id);
				$("#menuName").val(dataCate.menu_info[i].menu_name);
				addMenu();
			}
			for(var i=0; i < dataCate.cate1_info.length; i++){
				$("#cate1Menu").val(dataCate.cate1_info[i].menu_id);
				$("#cate1Name").val(dataCate.cate1_info[i].cate_name);
				addCate1();
			}
			for(var i=0; i < dataCate.cate2_info.length; i++){
				var cate_2_id = dataCate.cate2_info[i].menu_id + '|' + dataCate.cate2_info[i].cate_1_name;
				$("#cate2cate").val(cate_2_id);
				$("#cate2Name").val(dataCate.cate2_info[i].cate_2_name);
				addCate2();
			}
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});	
	
	var paramArcCate="cmd=arcCateInfo";
	$.ajax({
		type : "GET",
		data : paramArcCate,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataArcCate) {
			arcCateData = dataArcCate;
			for(var i=0; i < arcCateData.menu_info.length; i++){
				$("#arcMenu").append('<option value="'+arcCateData.menu_info[i].menu_id+'">'+arcCateData.menu_info[i].menu_name+'</option>');
			}
			arcMenuSel();
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});	
});

function arcMenuSel(){
	$('#arcCate1').find('option').remove().end();
	var menuVal = $("#arcMenu").val()+"";
	for(var i=0; i<arcCateData.menu_info.length; i++){
		if(menuVal === arcCateData.menu_info[i].menu_id){
			var cateObj = arcCateData.menu_info[i].cate1_info;
			for(var j=0; j< cateObj.length; j++){
				$("#arcCate1").append('<option value="'+cateObj[j].menu_id+'|'+cateObj[j].cate_name+'">'+cateObj[j].cate_name+'</option>');
			}
		}
	}
	arcCate1Sel();
}
function arcCate1Sel(){
	$('#arcCate2').find('option').remove().end();
	var menuVal = $("#arcCate1").val()+"";
	var menuVals = menuVal.split('|'); 
	for(var i=0; i<arcCateData.menu_info.length; i++){
		if(menuVals[0] === arcCateData.menu_info[i].menu_id){
			var cateObj = arcCateData.menu_info[i].cate1_info;
			for(var j=0; j< cateObj.length; j++){
				if(menuVals[1] === cateObj[j].cate_name){
					var cate2Obj = cateObj[j].cate2_info;
					for(var k=0; k< cate2Obj.length; k++){
						$("#arcCate2").append('<option value="'+cate2Obj[k].menu_id+'|'+cate2Obj[k].cate_1_name+'|'+cate2Obj[k].cate_2_name+'">'+cate2Obj[k].cate_2_name+'</option>');
					}
				}
			}
		}
	}
	arcCate2Sel();
}
function arcCate2Sel(){
	$('#arcTitleSel').find('option').remove().end();
	$("#arcTitleSel").append('<option value="new">- 새 제목 -</option>');
	var menuVal = $("#arcCate2").val()+"";
	var menuVals = menuVal.split('|');
	
	for(var i=0; i<arcCateData.menu_info.length; i++){
		if(menuVals[0] === arcCateData.menu_info[i].menu_id){
			var cateObj = arcCateData.menu_info[i].cate1_info;
			for(var j=0; j< cateObj.length; j++){
				if(menuVals[1] === cateObj[j].cate_name){
					var cate2Obj = cateObj[j].cate2_info;
					for(var k=0; k< cate2Obj.length; k++){
						if(menuVals[2] === cate2Obj[k].cate_2_name){
							var titleObj = cate2Obj[k].title_info;
							for(var l=0; l< titleObj.length; l++){
								$("#arcTitleSel").append('<option value="'+titleObj[l].title+'">'+titleObj[l].title+'</option>');
							}
						}
					}
				}
			}
		}
	}
}

function loadEnc(){
	var arcMenuVal = $("#arcMenu").val()+"";
	var arcCate1Val = $("#arcCate1").val()+"";
	var arcCate2Val = $("#arcCate2").val()+"";
	var arcTitleSelVal = $("#arcTitleSel").val()+"";
	var params = "";
	params += "cmd=arcText";
	params += "&arcMenu="+arcMenuVal;
	params += "&arcCate1="+arcCate1Val;
	params += "&arcCate2="+arcCate2Val;
	params += "&arcTitleSel="+arcTitleSelVal;
	$.ajax({
		type : "GET",
		data : params,
		url : "../Control/MpickAjax",
		dataType:"text",
		success : function(dataArcTxt) {
			tinymce.get('elm').setContent(dataArcTxt);
			$("#arcTitle").val(arcTitleSelVal);
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
}

function saveEnc(){
	$("#saveEncBtn").attr("disabled",true);
	var frm = document.encArticle;
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}

function delEnc(){
	$("#delEncBtn").attr("disabled",true);
	var frm = document.encArticle;
	frm.cmd.value="delEncl";
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}

</script>

<div class="container">
<div class="row">
	<ul id="fldFmtTab" class="nav nav-tabs">
		<li <%if("cate".equals(enclTab)){out.print("class='active'");} %> ><a href="#cate" data-toggle="tab">카테고리 편집</a></li>
		<li <%if("arc".equals(enclTab)){out.print("class='active'");} %> ><a href="#arc" data-toggle="tab">백과사전 내용 입력</a></li>
	</ul>
	
	<div id="fldFmtTabContent" class="tab-content">

<!-- 카테고리 편집 탭 시작 -->
<div class="tab-pane fade <%if("cate".equals(enclTab)){out.print("active");} %> in" id="cate">
<form name="encCate">
	<div class="row">
		<div class="col-md-6">
			<h3>카테고리 편집</h3>
			<p class="text-muted">메뉴, 카테고리1, 카테고리 2를 전부 편집 한 후에 저장버튼을 눌러 저장하세요.</p>
		</div>
		<div class="col-md-2">
			<h3>
			<button type="button" class="btn btn-primary btn-block" id="saveCateBtn" onclick="saveCate();">저장</button>
			</h3>
		</div>
		<div class="col-md-4"></div>
	</div>
	
<div class="container">
	<h4>메뉴</h4>
	<p class="text-muted">메뉴 id - 첫 글자만 대문자인 공백 없는 10자 이내의 영문자로 입력하세요. 접속 URL 주소가 됩니다.
  	<br/>메뉴명 - 20자 이내의 한글/영문자로 입력하세요. | , 특수 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 메뉴 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<input type="text" class="form-control" id="menuId" placeholder="메뉴 id" maxlength="10">
			<br/>
			<input type="text" class="form-control" id="menuName" placeholder="메뉴명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="menus" onchange="selMenu()"></select>
			<input type="hidden" id="menusVal" name="menus"/>
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
  	<br/>카테고리명 - 20자 이내의 한글/영문자로 입력하세요. | , 특수 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 카테고리 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<select class="form-control" id="cate1Menu"></select>
			<br/>
			<input type="text" class="form-control" id="cate1Name" placeholder="카테고리명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="cate1s" name="cate1s" onchange="selCate1()"></select>
			<input type="hidden" id="cate1sVal" name="cate1s"/>
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
  	<br/>카테고리명 - 20자 이내의 한글/영문자로 입력하세요. | , 특수 문자는 사용하면 안됩니다.
  	<br/>동시에 여러 카테고리 목록을 선택해서 작업하지 마세요. 오류가 날 수 있습니다.</p>
  	
	<div class="row">
		<div class="col-md-2">
			<select class="form-control" id="cate2cate"></select>
			<br/>
			<input type="text" class="form-control" id="cate2Name" placeholder="카테고리명"  maxlength="20">
		</div>
		<div class="col-md-4">
			<select multiple class="form-control" id="cate2s" name="cate2s" onchange="selCate2()"></select>
			<input type="hidden" id="cate2sVal" name="cate2s"/>
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
	
	<input type="hidden" name="cmd" value="saveCate" />
	<input type="hidden" name="toUrl" value="../Admin/Encl" />
</form>
</div>
<!-- 카테고리 편집 탭 끝 -->
<!-- 내용 입력 탭 시작 -->
<div class="tab-pane fade <%if("arc".equals(enclTab)){out.print("active");} %> in" id="arc">
<form name="encArticle">
	<br/>
	<div class="row">
		<div class="col-md-2">
			<select class="form-control" id="arcMenu" name="arcMenu" onchange="arcMenuSel();"></select>
		</div>
		<div class="col-md-2">
			<select class="form-control" id="arcCate1" name="arcCate1" onchange="arcCate1Sel();" ></select>
		</div>
		<div class="col-md-2">
			<select class="form-control" id="arcCate2" name="arcCate2" onchange="arcCate2Sel();"></select>
		</div>
		<div class="col-md-2">
			<select class="form-control" id="arcTitleSel" name="arcTitleSel"></select>
		</div>
		<div class="col-md-2"></div>
	</div>
	<br/>
	<div class="row">
		<div class="col-md-2">
			<input type="text" class="form-control" id="arcTitle" name="arcTitle" placeholder="제목"  maxlength="30">
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-success btn-block" onclick="loadEnc();">불러오기</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-primary btn-block" id="saveEncBtn" onclick="saveEnc();">저장</button>
		</div>
		<div class="col-md-2">
			<button type="button" class="btn btn-danger btn-block" id="delEncBtn" onclick="delEnc();">삭제</button>
		</div>
		<div class="col-md-4"></div>
	</div>
	<br/>
	<div class="container">
		<p class="text-muted">제목은 메뉴, 카테고리명으로 표현되는 구분값입니다. 페이지 내용에는 반영되지 않습니다. 
	  	<br/>제목을 표현하려면 내용 창에 &lth1&gt 태그 등을 이용해서 표시하세요.</p>
	</div>
	<div class="row">
		<textarea id="elm" name="encText"></textarea>
	</div>
	<input type="hidden" name="cmd" value="saveEncl" />
	<input type="hidden" name="toUrl" value="../Admin/Encl" />
	<input type="hidden" id="encType" name="encType" />
</form>
</div>
<!-- 내용 입력 탭 끝 -->

	</div>	
</div>

</div>

<br/><br/>