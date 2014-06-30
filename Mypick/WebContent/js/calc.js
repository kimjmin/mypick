function transUnit(){
	var w = $("#wInput").val();
	var l = $("#lInput").val();
	var v = $("#vInput").val();
	
	var wSel = $("#wSel").val();
	var lSel = $("#lSel").val();
	var vSel = $("#vSel").val();
	
	if(wSel === "lb"){
		$("#wlb").html(Math.round(Number(w)*1000)/1000);
		$("#wkg").html(Math.round(Number(w)*0.45359*1000)/1000);
		$("#wg").html(Math.round(Number(w)*453.592*1000)/1000);
		$("#woz").html(Math.round(Number(w)*16*1000)/1000);
	} else if(wSel === "kg"){
		$("#wlb").html(Math.round(Number(w)*2.20459*1000)/1000);
		$("#wkg").html(Math.round(Number(w)*1000)/1000);
		$("#wg").html(Math.round(Number(w)*1000*1000)/1000);
		$("#woz").html(Math.round(Number(w)*33.273*1000)/1000);
	} else if(wSel === "g"){
		$("#wlb").html(Math.round(Number(w)*0.0022*1000)/1000);
		$("#wkg").html(Math.round(Number(w)*0.001*1000)/1000);
		$("#wg").html(Math.round(Number(w)*1000)/1000);
		$("#woz").html(Math.round(Number(w)*0.03527*1000)/1000);
	} else if(wSel === "oz"){
		$("#wlb").html(Math.round(Number(w)*0.06525*1000)/1000);
		$("#wkg").html(Math.round(Number(w)*0.02835*1000)/1000);
		$("#wg").html(Math.round(Number(w)*28.3495*1000)/1000);
		$("#woz").html(Math.round(Number(w)*1000)/1000);
	}
	
	if(lSel === "cm"){
		$("#lcm").html(Math.round(Number(l)*1000)/1000);
		$("#lin").html(Math.round(Number(l)*0.3937*1000)/1000);
		$("#lft").html(Math.round(Number(l)*0.0328*1000)/1000);
	} else if(lSel === "in"){
		$("#lcm").html(Math.round(Number(l)*2.54*1000)/1000);
		$("#lin").html(Math.round(Number(l)*1000)/1000);
		$("#lft").html(Math.round(Number(l)*0.0833*1000)/1000);
	} else if(lSel === "ft"){
		$("#lcm").html(Math.round(Number(l)*30.48*1000)/1000);
		$("#lin").html(Math.round(Number(l)*12*1000)/1000);
		$("#lft").html(Math.round(Number(l)*1000)/1000);
	}
	
	if(vSel === "floz"){
		$("#vfloz").html(Math.round(Number(v)*1000)/1000);
		$("#vgal").html(Math.round(Number(v)*0.007813*1000)/1000);
		$("#vl").html(Math.round(Number(v)*0.029574*1000)/1000);
		$("#vcc").html(Math.round(Number(v)*29.57353*1000)/1000);
	} else if(vSel === "gal"){
		$("#vfloz").html(Math.round(Number(v)*127.999998*1000)/1000);
		$("#vgal").html(Math.round(Number(v)*1000)/1000);
		$("#vl").html(Math.round(Number(v)*3.785412*1000)/1000);
		$("#vcc").html(Math.round(Number(v)*3785.41178*1000)/1000);
	} else if(vSel === "l"){
		$("#vfloz").html(Math.round(Number(v)*33.814022*1000)/1000);
		$("#vgal").html(Math.round(Number(v)*0.264172*1000)/1000);
		$("#vl").html(Math.round(Number(v)*1000)/1000);
		$("#vcc").html(Math.round(Number(v)*1000*1000)/1000);
	} else if(vSel === "cc"){
		$("#vfloz").html(Math.round(Number(v)*0.033814*1000)/1000);
		$("#vgal").html(Math.round(Number(v)*0.000264*1000)/1000);
		$("#vl").html(Math.round(Number(v)*0.001*1000)/1000);
		$("#vcc").html(Math.round(Number(v)*1000)/1000);
	}	
}

function calVolume(){
	var w = $("#vWidth").val();
	var d = $("#vDepth").val();
	var h = $("#vHeight").val();
	
	var vol = (Number(w)*Number(d)*Number(h))/166;
	vol = Math.round(vol*1000)/1000;
	var res = ''+w+' (inch) x '+d+' (inch) x '+h+' (inch) / 166 = <code>'+vol+'</code> 파운드(lb)';
	$("#vRes").html(res);
}