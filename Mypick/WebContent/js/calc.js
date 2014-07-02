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