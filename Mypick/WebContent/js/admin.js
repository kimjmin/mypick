var selData;

$(document).ready(function(){
	var params="cmd=currInfo";
	$.ajax({
		type : "GET",
		data : params,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(data) {
			selData = data;
			$("#addShipBtn").removeAttr("disabled");
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
	
	//.eq(), :eq(2) 를 쓰면 class 모음의 *번째 배열 객체를 구할 수 있음. 
	/*
    var lastItemNo = $("#shipList tr:last").attr("class").replace("item", "");
    console.log("lastItemNo: "+lastItemNo);
    var newShip = $("#shipList tr:eq(1)").clone();
    newShip.removeClass();
    newShip.find("td:eq(0)").attr("rowspan", "1");
    newShip.addClass("item"+(parseInt(lastItemNo)+1));
    */
	/*
	$("#btn").click(function(){
	});
	*/
	
});

/**
 * 배송대행지 업체item 추가.
 */
function addShipItem(){
	//ID 생성 - 랜덤한 8자리 숫자.
	var shipItemId = Math.round(Math.random() * 100000000);
	console.log("shipItemId: "+shipItemId);
	
	var newShip = "";
	newShip += "<tr>";
	
	newShip += "<td>";
	newShip += "<p><input type='text' name='shipItemName' class='form-control' required='required' value='"+$("#shipName").val()+"'></p>";
	newShip += "<p class='shipLevDelBtn'><button type='button' class='btn btn-danger shipItemRemove'>업체 삭제</button></p>";
	newShip += "<input type='hidden' name='shipItemId' value='"+shipItemId+"'>"
	newShip += "<input type='hidden' name='shipItemUrl' value='"+$("#shipUrl").val()+"'>"
	newShip += "</td>";
	
	newShip += "<td>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLev lvP_"+shipItemId+"'><input type='text' class='form-control' required='required' placeholder='Level "+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='15%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevVal lvValP_"+shipItemId+"'><input type='number' class='form-control' required='required' placeholder='"+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='15%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevValSel lvSelP_"+shipItemId+"'><select class='form-control levVal' >";
		
		newShip += "<option value='PERC'>%</option>";
		newShip += "<option value='KRW'>KRW</option>";
		for(var i=0; i<selData.curr_head.length; i++){
			newShip += "<option value='"+selData.curr_head[i].curr+"'>"+selData.curr_head[i].curr+"</option>";
		}
		newShip += "</select></p>";
	}
	newShip += "</td>";
	
	newShip += "<td>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevDelBtn lvDelBtnP_"+shipItemId+"' ><button type='button' name='lvDelBtn_"+shipItemId+"' class='btn btn-danger lvDelBtn_"+shipItemId+"' onclick='shipLevRemove(this,\""+shipItemId+"\");'>등급 삭제</button></p>";
	}
	newShip += "<p class='shipLevAddBtn'><button type='button' class='btn btn-success shipLevAdd'>등급 추가</button></p>";
	newShip += "</td>";
	
	newShip += "</tr>";
	
    $("#shipList").append(newShip);
}

function shipLevRemove(btn,btnClass){
	console.log("btnClass : "+btnClass);
	var lvDelBtns = document.getElementsByName("lvDelBtn_"+btnClass);
	var lvDelBtnSize = lvDelBtns.length;
	if(lvDelBtnSize > 1){
		for(var lv=0; lv < lvDelBtnSize; lv++){
			if(lvDelBtns[lv] == btn){
				$(".lvP_"+btnClass).eq(lv).remove();
				$(".lvValP_"+btnClass).eq(lv).remove();
				$(".lvSelP_"+btnClass).eq(lv).remove();
				$(".lvDelBtnP_"+btnClass).eq(lv).remove();
			}
		}
	} else {
		alert("등급이 1개일 때는 삭제 할 수 없습니다.");
	}
	
}

/**
 * 배송대행지 저장
 */
function saveShips(){
	
}