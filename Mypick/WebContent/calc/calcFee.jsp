<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickDao,jm.net.DataEntity"%>
<div class="row">
	<blockquote>
		<p>배송대행 요금비교 및 과세여부 판별기</p>
		<small>배송대행지의 요금비교과 물품가격 및 관부가세 과세여부를 판별해주는 계산기입니다.</small>
	</blockquote>
</div>

<div class="row">
	<h4>구매정보 입력 
		<button class="btn btn-info btn-xs" data-toggle="modal" data-target="#helpModal">도움말</button>
	</h4>
	
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
        <span aria-hidden="true"></span><span class="sr-only">Close</span></button>
        <h4 class="modal-title" id="myModalLabel">구매정보 입력</h4>
      </div>
      <div class="modal-body">
<ul>
	<li>무게 단위를 선택 후, 예상되거나 실측된 무게를 입력합니다.</li>
	<li>업체와 회원 등급을 선택합니다.</li>
	<li>할인 금액 또는 %를 입력 합니다.</li>
</ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="shipModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
        <span aria-hidden="true"></span><span class="sr-only">Close</span></button>
        <h4 class="modal-title" id="myModalLabel">배송대행지 선택</h4>
      </div>
      <div class="modal-body">

	<label>
		<input type="checkbox" id="shipIds"> 전체 선택
	</label>

<%
MpickDao dao = MpickDao.getInstance();
DataEntity[] shMains = dao.getShMain();
for(int i=0; i < shMains.length; i++){
	DataEntity[] shLevs = dao.getShLevs(shMains[i].get("ship_id")+"");
	if(i%3 == 0){
%><br/>
<div class="row"><%
	}
	
%>
<div class="col-md-4">
	<label>
		<input type="checkbox" class="shipId" name="shipId" value="<%=shMains[i].get("ship_id")+""%>"> <%=shMains[i].get("ship_name")+""%>
	</label>
	<select class="form-control" id="<%=shMains[i].get("ship_id")+""%>Sel">
<%
	for(int j=0; j < shLevs.length; j++){
%>		<option value='<%=shLevs[j].get("lev_num")+""%>' <%if(j==0){out.print("selected='selected'");}%>><%=shLevs[j].get("lev_name")+""%></option>
<%		
	}
%>	
	</select>
</div>

<%
	if(i%3 == 2 || i == shMains.length-1){
%></div><%
	}
}
%>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal" id="shipsSelected">선택 완료</button>
      </div>
    </div>
  </div>
</div>

<script>
var shipObj = new Array();
var amtOrderArr = new Array();
var amtOrderObj = new Object();

$(function(){
    $("#shipIds").click(function(){
        var chk = $(this).is(":checked");
        if(chk){
        	$(".shipId").prop('checked', true);
        }
        else{
        	$(".shipId").prop('checked', false);
        }
    });
    
    $("#shipsSelected").click(function(){
    	$("#sortShipBtn").prop("disabled", true);
    	$("#calcShipBtn").prop("disabled", true);
    	
    	var shId = $(".shipId:checked");
    	var sh=0;
    	for(var i=0; i<shId.length; i++){
    		
    		var param="cmd=shipInfo";
    		param += "&";
    		param += "shipId="+shId.eq(i).val();
    		$.ajax({
    			type : "GET",
    			data : param,
    			url : "../Control/MpickAjax",
    			dataType:"json",
    			success : function(dataShip) {
//    				var onum = Number(dataShip.onum);
    				shipObj[sh] = dataShip;
    				sh++;
    				if(sh == shId.length){
    					//전체 종료 후.
    					setShObj();
    				}
    			}, error:function(e){  
    				console.log(e.responseText);  
    			}
    		});	
    	}
    });
});

function setShObj(){
	$("#shipList").html("");
	setShListTitle();
	for(var sh=0; sh < shipObj.length; sh++){
		setShList(sh);
	}
	$("#calcShipBtn").prop("disabled", false);
}
function setShListTitle(){
	var shList = "";
	
	shList += "<div class='row text-center'>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-md-6'>";
	shList += "			<label>배송 대행지</label>";
	shList += "		</div>";
	shList += "		<div class='col-md-6'>";
	shList += "			<label>등급</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-md-5'>";
	shList += "			<label>기본 배송료</label>";
	shList += "		</div>";
	shList += "		<div class='col-md-7'>";
	shList += "			<label>할인 금액</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-md-10'>";
	shList += "			<label>최종 배송료</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "</div>";
	
	$("#shipList").append(shList);
}
function setShList(sh){
	var shList = "";
	shList += "<div id='shList"+sh+"'>";
	shList += "<div class='row'>";
	shList += "<div class='col-md-4 my-column'>";
	shList += "	<div class='col-md-1 my-column-unit text-right'></div>";
	shList += "	<div class='col-md-5 my-column-in'>";
	shList += "		<h4 class='text-right'><a target='new' href='"+shipObj[sh].ship_url+"'>"+shipObj[sh].ship_name+"</a></h4>";
	shList += "	</div>";
	shList += "	<div class='col-md-6'>";
	shList += "	<select class='form-control' id='"+shipObj[sh].ship_id+"LevSel'>";
	for(var op=0; op < shipObj[sh].ship_levs.length; op++){
		if($("#"+shipObj[sh].ship_id+"Sel").val() === shipObj[sh].ship_levs[op].lev_num){
			shList += "		<option value='"+shipObj[sh].ship_levs[op].lev_num+"' selected='selected'>"+shipObj[sh].ship_levs[op].lev_name+"</option>";
		} else {
			shList += "		<option value='"+shipObj[sh].ship_levs[op].lev_num+"'>"+shipObj[sh].ship_levs[op].lev_name+"</option>";
		}
	}
	shList += "	</select>";
	shList += "</div>";
	shList += "</div>";
	shList += "<div class='col-md-4 my-column'>";
	shList += "<div class='col-md-4 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"BAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-md-2 my-column-unit'>";
	shList += ""+shipObj[sh].aunit+"";
	shList += "</div>";
	
	shList += "<div class='col-md-3 my-column-in'>";
	shList += "<input type='number' class='form-control' id='"+shipObj[sh].ship_id+"DisAmt' max='10000000' min='0' step='0.01' placeholder='할인액'>";
	shList += "</div>";
	shList += "<div class='col-md-3 my-column-in'>";
	shList += "<label class='my-column-in'>";
	shList += "<input type='radio' class='my-column-in "+shipObj[sh].ship_id+"DisRad' name='"+shipObj[sh].ship_id+"DisRad' checked='checked' value='CURR'> "+shipObj[sh].aunit+"";
	shList += "</label><br/>";
	shList += "<label class='my-column-in'>";
	shList += "<input type='radio' class='my-column-in "+shipObj[sh].ship_id+"DisRad' name='"+shipObj[sh].ship_id+"DisRad' value='PERC'> %";
	shList += "</label>";
	shList += "</div>";
	shList += "</div>";
	
	shList += "<div class='col-md-4 my-column'>";
	
	shList += "<div class='col-md-4 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"FAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-md-2 my-column-unit'>";
	shList += ""+shipObj[sh].aunit+"";
	shList += "</div>";
	shList += "<div class='col-md-4 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"FTAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-md-2 my-column-unit'>";
	shList += "KRW";
	shList += "</div>";
	shList += "</div>";
	
	shList += "</div>";
	shList += "</div>";
	$("#shipList").append(shList);
}

function calcShip(){
	amtOrderObj = new Object();
	var w = $("#wVal").val();
	var wSel = $("#wSel").val();
	console.log("w : "+w);
	var twVal = 0;
	var lbVal = 0;
	var kgVal = 0;
	var gVal = 0;
	var ozVal = 0;
	if(wSel === "lb"){ 
		lbVal = $.number(Number(w),3);
		kgVal = $.number(Number(w)*0.45359,3);
		gVal = $.number(Number(w)*453.592,3);
		ozVal = $.number(Number(w)*16,3);
	} else if(wSel === "kg"){
		lbVal = $.number(Number(w)*2.20459,3);
		kgVal = $.number(Number(w),3);
		gVal = $.number(Number(w)*1000,3);
		ozVal = $.number(Number(w)*33.273,3);
	} else if(wSel === "g"){
		lbVal = $.number(Number(w)*0.0022,3);
		kgVal = $.number(Number(w)*0.001,3);
		gVal = $.number(Number(w),3);
		ozVal = $.number(Number(w)*0.03527,3);
	} else if(wSel === "oz"){
		lbVal = $.number(Number(w)*0.06525,3);
		kgVal = $.number(Number(w)*0.02835,3);
		gVal = $.number(Number(w)*28.3495,3);
		ozVal = $.number(Number(w),3);
	}
	
	for(var sh=0; sh < shipObj.length; sh++){
		if(shipObj[sh].wunit == "lb"){
			twVal = lbVal;
		} else if(shipObj[sh].wunit == "kg"){
			twVal = kgVal;
		} else if(shipObj[sh].wunit == "g"){
			twVal = gVal;
		} else if(shipObj[sh].wunit == "oz"){
			twVal = ozVal;
		}
		console.log(shipObj[sh].ship_name+" 무게 : "+twVal+" ("+shipObj[sh].wunit+")");
		var selLev = Number($("#"+shipObj[sh].ship_id+"LevSel").val());
		console.log(shipObj[sh].ship_name+" 선택 등급 : "+shipObj[sh].ship_levs[selLev].lev_name);
//		console.log("selLev: "+selLev);
		var levCnt = 0;
		var selVal = 0;
		var maxLevCnt = shipObj[sh].ship_levs[selLev].lev_vals.length - 1;
		var maxSelVal = shipObj[sh].ship_levs[selLev].lev_vals[maxLevCnt].val_weight;
//		console.log("maxLevCnt: "+maxLevCnt);
//		console.log("maxSelVal: "+maxSelVal);
		if(maxSelVal <= twVal){
			selVal = maxSelVal;
			levCnt = maxLevCnt;
		} else {
			while(selVal < twVal){
				levCnt++;
				selVal = shipObj[sh].ship_levs[selLev].lev_vals[levCnt].val_weight;
			}
		}
//		console.log("levCnt: "+levCnt);
		var bAmt = shipObj[sh].ship_levs[selLev].lev_vals[levCnt].val_amount;
		console.log(shipObj[sh].ship_name+" 요율 : "+selVal+" ("+shipObj[sh].wunit+")");
		console.log(shipObj[sh].ship_name+" 금액 : "+bAmt+" ("+shipObj[sh].aunit+")");
		
		var disRad = $("."+shipObj[sh].ship_id+"DisRad:checked").val();
		var disAmt = $("#"+shipObj[sh].ship_id+"DisAmt").val();
		var fAmt = 0;
		if(disRad === 'CURR'){
			fAmt = Number(bAmt) - Number(disAmt);
		} else {
			fAmt = Number(bAmt) * ((100-Number(disAmt))/100);
		}
		console.log(shipObj[sh].ship_name+" 할인액 : "+disAmt+" ("+shipObj[sh].aunit+")");
		var ftAmt = 0;
		if(shipObj[sh].aunit === 'KRW'){
			$("#"+shipObj[sh].ship_id+"BAmt").val($.number(bAmt));
			$("#"+shipObj[sh].ship_id+"FAmt").val($.number(fAmt));
			ftAmt = fAmt;
			$("#"+shipObj[sh].ship_id+"FTAmt").val($.number(ftAmt));
		} else {
			$("#"+shipObj[sh].ship_id+"BAmt").val($.number(bAmt,2));
			$("#"+shipObj[sh].ship_id+"FAmt").val($.number(fAmt,2));
			ftAmt = Number(fAmt) * Number(currData.curr_info[shipObj[sh].aunit].sell_refer);
			$("#"+shipObj[sh].ship_id+"FTAmt").val($.number(ftAmt));
		}
		ftAmt = Math.round(ftAmt * 10000) / 10000;
		while(typeof(amtOrderObj[""+ftAmt]) != "undefined"){
			ftAmt = Math.round((ftAmt + 0.0001) * 10000) / 10000;
			console.log("ftAmt: "+ftAmt);
		}
		amtOrderObj[""+ftAmt] = {};
		amtOrderObj[""+ftAmt].sh = sh;
		amtOrderObj[""+ftAmt].lev_num = shipObj[sh].ship_levs[selLev].lev_num;
		amtOrderObj[""+ftAmt].disAmt = disAmt;
		amtOrderObj[""+ftAmt].disRad = disRad;
		amtOrderArr[sh] = ftAmt;
	}
	amtOrderArr.sort(function(a, b){ return a-b; });
//	console.log(amtOrderArr);
//	console.log(amtOrderObj);
	$("#sortShipBtn").prop("disabled", false);
}

function sortShip(){
	calcShip();
	$("#shipList").html("");
	setShListTitle();
	for(var i=0; i<amtOrderArr.length; i++){
		var sh = amtOrderObj[""+amtOrderArr[i]].sh;
		setShList(sh);
		$("#"+shipObj[sh].ship_id+"LevSel").val(amtOrderObj[""+amtOrderArr[i]].lev_num);
		var disRad = amtOrderObj[""+amtOrderArr[i]].disRad;
		$("."+shipObj[sh].ship_id+"DisRad:input[value='"+disRad+"']").attr('checked', 'checked');
		$("#"+shipObj[sh].ship_id+"DisAmt").val(amtOrderObj[""+amtOrderArr[i]].disAmt);
	}
	calcShip();
}
</script>

<form action="javascript:calcShip();">
<div class="row">
	<div class="col-md-2">
		<button type="button" class="btn btn-success" data-toggle="modal" data-target="#shipModal">배송 대행지 선택</button>
	</div>
	<div class="col-md-2">
		<input type="number" class="form-control" id="wVal" max="1000000000" min="0.001" step="0.001" placeholder="무게">
	</div>
	<div class="col-md-3">
		<select class="form-control" id="wSel">
			<option value="lb" selected="selected">lb (파운드)</option>
			<option value="kg">kg (킬로그램)</option>
			<option value="g">g (그램)</option>
			<option value="oz">oz (온스)</option>
		</select>
	</div>
	<div class="col-md-2"></div>
	<div class="col-md-3">
		<button type="submit" id="calcShipBtn" class="btn btn-primary" disabled="disabled">요금 계산</button>
		<button type="button" id="sortShipBtn" class="btn btn-danger" onclick="sortShip();" disabled="disabled">최소금액 정렬</button>
	</div>
</div>

<br/>
<div id="shipList"></div>
</form>