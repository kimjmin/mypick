var currData;

function initCurr(){
	var params="cmd=currInfo";
	$.ajax({
		type : "GET",
		data : params,
		url : hostUrl+"/Control/MpickAjax",
		dataType:"json",
		success : function(data) {
			currData = data;
			setCurrSel();
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
}

function setCurrSel(){
//	console.log("currData.curr_head.length: "+currData.curr_head.length);
	for(var i=0; i<currData.curr_head.length; i++){
		$("#currSel").append("<option value='"+currData.curr_head[i].curr+"'>"+currData.curr_head[i].curr_kr+"</option>");
	}
	$("#up_date").html(currData.up_date);
	$("#up_time").html(currData.up_time);
	setCurrVal();
}

function setCurrVal(){
	$("#sell_refer").html($.number(currData.curr_info[$("#currSel").val()].sell_refer,2));
	$("#cash_buy").html($.number(currData.curr_info[$("#currSel").val()].cash_buy,2));
	$("#trans_send").html($.number(currData.curr_info[$("#currSel").val()].trans_send,2));
	$("#usd_rate").html($.number(currData.curr_info[$("#currSel").val()].tax_rate,2));
//	$("#usd_rate").html($.number(currData.curr_info[$("#currSel").val()].usd_rate*1000,2));
}