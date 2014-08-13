/**
 * 단위 변환기 
 */
function transUnit(){
	var w = $("#wInput").val();
	var l = $("#lInput").val();
	var v = $("#vInput").val();
	
	var wSel = $("#wSel").val();
	var lSel = $("#lSel").val();
	var vSel = $("#vSel").val();
	
	if(wSel === "lb"){
		$("#wlb").html($.number(Number(w),3));
		$("#wkg").html($.number(Number(w)*0.45359,3));
		$("#wg").html($.number(Number(w)*453.592,3));
		$("#woz").html($.number(Number(w)*16,3));
	} else if(wSel === "kg"){
		$("#wlb").html($.number(Number(w)*2.20459,3));
		$("#wkg").html($.number(Number(w),3));
		$("#wg").html($.number(Number(w)*1000,3));
		$("#woz").html($.number(Number(w)*33.273,3));
	} else if(wSel === "g"){
		$("#wlb").html($.number(Number(w)*0.0022,3));
		$("#wkg").html($.number(Number(w)*0.001,3));
		$("#wg").html($.number(Number(w),3));
		$("#woz").html($.number(Number(w)*0.03527,3));
	} else if(wSel === "oz"){
		$("#wlb").html($.number(Number(w)*0.06525,3));
		$("#wkg").html($.number(Number(w)*0.02835,3));
		$("#wg").html($.number(Number(w)*28.3495,3));
		$("#woz").html($.number(Number(w),3));
	}
	
	if(lSel === "cm"){
		$("#lcm").html($.number(Number(l),3));
		$("#lin").html($.number(Number(l)*0.3937,3));
		$("#lft").html($.number(Number(l)*0.0328,3));
	} else if(lSel === "in"){
		$("#lcm").html($.number(Number(l)*2.54,3));
		$("#lin").html($.number(Number(l),3));
		$("#lft").html($.number(Number(l)*0.0833,3));
	} else if(lSel === "ft"){
		$("#lcm").html($.number(Number(l)*30.48,3));
		$("#lin").html($.number(Number(l)*12,3));
		$("#lft").html($.number(Number(l),3));
	}
	
	if(vSel === "floz"){
		$("#vfloz").html($.number(Number(v),3));
		$("#vgal").html($.number(Number(v)*0.007813,3));
		$("#vl").html($.number(Number(v)*0.029574,3));
		$("#vcc").html($.number(Number(v)*29.57353,3));
	} else if(vSel === "gal"){
		$("#vfloz").html($.number(Number(v)*127.999998,3));
		$("#vgal").html($.number(Number(v),3));
		$("#vl").html($.number(Number(v)*3.785412,3));
		$("#vcc").html($.number(Number(v)*3785.41178,3));
	} else if(vSel === "l"){
		$("#vfloz").html($.number(Number(v)*33.814022,3));
		$("#vgal").html($.number(Number(v)*0.264172,3));
		$("#vl").html($.number(Number(v),3));
		$("#vcc").html($.number(Number(v)*1000,3));
	} else if(vSel === "cc"){
		$("#vfloz").html($.number(Number(v)*0.033814,3));
		$("#vgal").html($.number(Number(v)*0.000264,3));
		$("#vl").html($.number(Number(v)*0.001,3));
		$("#vcc").html($.number(Number(v),3));
	}	
}

/**
 * 부피무게 계산기
 */
function calVolume(){
	var w = $("#vWidth").val();
	var d = $("#vDepth").val();
	var h = $("#vHeight").val();
	
	var vol = (Number(w)*Number(d)*Number(h))/166;
	vol = $.number(vol,3);
	var formu = '<code>'+$.number(w,3)+'</code> x <code>'+$.number(d,3)+'</code> x <code>'+$.number(h,3)+'</code> / 166';
	var res = '= <code>'+vol+'</code> <small>파운드(lb)</small>';
	$("#vForm").html(formu);
	$("#vRes").html(res);
}

/**
 * 배송대행 요금비교 사용 객체들.
 */
var shipObj = new Array();
var amtOrderArr = new Array();
var amtOrderObj = new Object();

/**
 * 배송대행 요금비교 버튼 함수
 */
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
    	
    	shipObj = new Array();
    	amtOrderObj = new Object();
    	$("#shipList").html("");
    	
    	for(var i=0; i<shId.length; i++){
    		
    		var param="cmd=shipInfo";
    		param += "&";
    		param += "shipId="+shId.eq(i).val();
    		$.ajax({
    			type : "GET",
    			data : param,
    			url : hostUrl+"/Control/MpickAjax",
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

/**
 * 배송대행지 선택 후 추가.
 */
function setShObj(){
	setShListTitle();
	for(var sh=0; sh < shipObj.length; sh++){
		setShList(sh);
	}
	$("#calcShipBtn").prop("disabled", false);
}

/**
 * 배송대행지 헤더 추가.
 */
function setShListTitle(){
	var shList = "";
	
	shList += "<div class='row'>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>배송 대행지</label>";
	shList += "		</div>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>등급</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>기본 배송료</label>";
	shList += "		</div>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>할인 금액</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "	<div class='col-md-4'>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>최종 배송료</label>";
	shList += "		</div>";
	shList += "		<div class='col-xs-6'>";
	shList += "			<label>환산 배송료</label>";
	shList += "		</div>";
	shList += "	</div>";
	shList += "</div>";
	
	$("#shipList").append(shList);
}
function setShList(sh,lowVal){
	var shList = "";
	shList += "<div id='shList"+sh+"'>";
	
	var lovValCss = "";
	if(typeof(lowVal) != "undefined"){
		if(sh === amtOrderObj[""+lowVal].sh){
			lovValCss = " bg-info";
		}
	}
	shList += "<div class='row "+lovValCss+"'>";
	
	shList += "<div class='col-md-4 my-column'>";
	shList += "	<div class='col-md-6'>";
	shList += "		<h4><a target='new' href='"+shipObj[sh].ship_url+"'>"+shipObj[sh].ship_name+"</a></h4>";
	shList += "	</div>";
	shList += "<div class='col-md-6'>";
	shList += "<select class='form-control' id='"+shipObj[sh].ship_id+"LevSel'>";
	for(var op=0; op < shipObj[sh].ship_levs.length; op++){
		if($("#"+shipObj[sh].ship_id+"Sel").val() === shipObj[sh].ship_levs[op].lev_num){
			shList += "		<option value='"+shipObj[sh].ship_levs[op].lev_num+"' selected='selected'>"+shipObj[sh].ship_levs[op].lev_name+"</option>";
		} else {
			shList += "		<option value='"+shipObj[sh].ship_levs[op].lev_num+"'>"+shipObj[sh].ship_levs[op].lev_name+"</option>";
		}
	}
	shList += "</select>";
	shList += "</div>";
	shList += "</div>";
	
	shList += "<div class='col-md-4'>";
	shList += "<div class='col-xs-6 my-column-in'>";
	shList += "<div class='col-xs-9 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"BAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-xs-3 my-column-unit'>";
	shList += ""+shipObj[sh].aunit+"";
	shList += "</div>";
	shList += "</div>";
	shList += "<div class='col-xs-6 my-column-in'>";
	shList += "<div class='col-xs-7 my-column-in'>";
	shList += "<input type='number' class='form-control' id='"+shipObj[sh].ship_id+"DisAmt' max='10000000' min='0' step='0.01' placeholder='할인액'>";
	shList += "</div>";
	shList += "<div class='col-xs-5 my-column-in'>";
	shList += "<label class='my-column-check'>";
	shList += "<input type='radio' class='my-column-in "+shipObj[sh].ship_id+"DisRad' name='"+shipObj[sh].ship_id+"DisRad' checked='checked' value='CURR'> "+shipObj[sh].aunit+"";
	shList += "</label><br/>";
	shList += "<label class='my-column-check'>";
	shList += "<input type='radio' class='my-column-in "+shipObj[sh].ship_id+"DisRad' name='"+shipObj[sh].ship_id+"DisRad' value='PERC'> %";
	shList += "</label>";
	shList += "</div>";
	shList += "</div>";
	shList += "</div>";
	
	shList += "<div class='col-md-4'>";
	shList += "<div class='col-xs-6 my-column-in'>";
	shList += "<div class='col-xs-9 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"FAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-xs-3 my-column-unit'>";
	shList += ""+shipObj[sh].aunit+"";
	shList += "</div>";
	shList += "</div>";
	shList += "<div class='col-xs-6 my-column-in'>";
	shList += "<div class='col-xs-9 my-column-in'>";
	shList += "<input type='text' id='"+shipObj[sh].ship_id+"FTAmt' class='form-control' disabled='disabled'>";
	shList += "</div>";
	shList += "<div class='col-xs-3 my-column-unit'>";
	shList += "KRW";
	shList += "</div>";
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
//	console.log("w : "+w);
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
		console.log(" =========== "+shipObj[sh].ship_name+" 시작 =========== ");
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
			ftAmt = Number(fAmt) * Number(currData.curr_info[shipObj[sh].aunit].trans_send);
			$("#"+shipObj[sh].ship_id+"FTAmt").val($.number(ftAmt));
		}
		ftAmt = Math.round(ftAmt * 10000) / 10000;
		while(typeof(amtOrderObj[""+ftAmt]) != "undefined"){
			ftAmt = Math.round((ftAmt + 0.0001) * 10000) / 10000;
//			console.log("ftAmt: "+ftAmt);
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
		setShList(sh,amtOrderArr[0]);
		$("#"+shipObj[sh].ship_id+"LevSel").val(amtOrderObj[""+amtOrderArr[i]].lev_num);
		var disRad = amtOrderObj[""+amtOrderArr[i]].disRad;
		$("."+shipObj[sh].ship_id+"DisRad:input[value='"+disRad+"']").attr('checked', 'checked');
		$("#"+shipObj[sh].ship_id+"DisAmt").val(amtOrderObj[""+amtOrderArr[i]].disAmt);
	}
	calcShip();
}