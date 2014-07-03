var currData;

function initCurr(){
	$.ajax({
		type : "GET",
		data : "cmd=currInfo",
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(data) {
			currData = data;
			setCurrSel();
		}
	});
}

function setCurrSel(){
	console.log("currData.curr_info.length: "+currData.curr_info.length);
	for(var i=0; i<currData.curr_info.length; i++){
		$("#currSel").append("<option value='"+i+"'>"+currData.curr_info[i].curr_kr+"</option>");
	}
	$("#up_date").html(currData.curr_info[0].up_date);
	$("#up_time").html(currData.curr_info[0].up_time);
	setCurrVal();
}

function setCurrVal(){
	$("#sell_refer").html($.number(currData.curr_info[$("#currSel").val()].sell_refer,3));
	$("#cash_buy").html($.number(currData.curr_info[$("#currSel").val()].cash_buy,3));
	$("#trans_send").html($.number(currData.curr_info[$("#currSel").val()].trans_send,3));
	$("#usd_rate").html($.number(currData.curr_info[$("#currSel").val()].usd_rate,3));
}