var selData;

$(document).ready(function(){
	var paramCurr="cmd=currInfo";
	$.ajax({
		type : "GET",
		data : paramCurr,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataCurr) {
			selData = dataCurr;
			$("#addShipBtn").removeAttr("disabled");
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
	
	var paramShip="cmd=shipInfo";
	$.ajax({
		type : "GET",
		data : paramShip,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataShip) {
			for(var sh=0; sh < dataShip.ship_info.length; sh++){
				$("#shipName").val(dataShip.ship_info[sh].ship_name);
				$("#shipUrl").val(dataShip.ship_info[sh].ship_url);
				$("#shipVals").val(dataShip.ship_info[sh].ship_levs.length);
				addShipItem(dataShip.ship_info[sh].ship_id);
				
				var lvNames = document.getElementsByName("lvName_"+dataShip.ship_info[sh].ship_id);
				var lvVals = document.getElementsByName("lvVal_"+dataShip.ship_info[sh].ship_id);
				for(var vl=0; vl < dataShip.ship_info[sh].ship_levs.length; vl++){
					lvNames[vl].value = dataShip.ship_info[sh].ship_levs[vl].lev_name;
					lvVals[vl].value = dataShip.ship_info[sh].ship_levs[vl].lev_val;
					$(".lvSel_"+dataShip.ship_info[sh].ship_id).eq(vl).val(dataShip.ship_info[sh].ship_levs[vl].lev_unit).attr("selected", "selected");
				}
			}
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});	
});

/**
 * 배송대행지 업체item 추가.
 */
function addShipItem(){
	var shipItemNames = document.getElementsByName("shipItemName");
	for(var sn=0; sn < shipItemNames.length; sn++){
		if(shipItemNames[sn].value === $("#shipName").val()){
			alert("같은 이름의 업체가 존재합니다.");
			return;
		}
	}
	
	//ID 생성 - 랜덤한 8자리 숫자.
	var shipItemId = "";
	if(arguments.length > 0){
		shipItemId = arguments[0];
	} else {
		shipItemId = Math.round(Math.random() * 100000000);
	}
	console.log("shipItemId: "+shipItemId);
	
	var newShip = "";
	newShip += "<tr id='tr_"+shipItemId+"'>";
	
	newShip += "<td>";
	newShip += "<p class='shipLevDelBtn'><button type='button' class='btn btn-danger shipItemRemove' onclick='javascript:shipRemove(\""+shipItemId+"\");'>삭제</button></p>";
	newShip += "</td>";
	
	newShip += "<td>";
	newShip += "<p><input type='text' id='shipName_"+shipItemId+"' name='shipItemName' class='form-control' required='required' value='"+$("#shipName").val()+"' placeholder='업체명'></p>";
	newShip += "<p><input type='text' id='shipUrl_"+shipItemId+"' name='shipItemUrl' class='form-control' required='required' value='"+$("#shipUrl").val()+"' placeholder='홈페이지 URL'></p>";
	
	newShip += "<input type='hidden' name='shipItemId' value='"+shipItemId+"'>";
	newShip += "</td>";
	
	newShip += "<td>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLev lvP_"+shipItemId+"'><input type='text' name='lvName_"+shipItemId+"' class='form-control' required='required' placeholder='Level "+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='12%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevVal lvValP_"+shipItemId+"'><input type='number' name='lvVal_"+shipItemId+"' class='form-control' required='required' placeholder='"+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='15%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevValSel lvSelP_"+shipItemId+"'><select name='lvUnit_"+shipItemId+"' class='form-control levVal lvSel_"+shipItemId+"' >";
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
		newShip += "<p class='shipLevDelBtn lvDelBtnP_"+shipItemId+"' ><button type='button' name='lvDelBtn_"+shipItemId+"' class='btn btn-warning lvDelBtn_"+shipItemId+"' onclick='shipLevRemove(this,\""+shipItemId+"\");'>등급 삭제</button></p>";
	}
	newShip += "<p class='lvAddBtnP_"+shipItemId+"'><button type='button' class='btn btn-success' onclick='shipLevAdd(\""+shipItemId+"\");'>등급 추가</button></p>";
	newShip += "</td>";
	
	newShip += "</tr>";
	
    $("#shipList").append(newShip);
    
    $("#shipName").val('');
    $("#shipUrl").val('http://');
    $("#shipVals").val(1);
}

/**
 * 등급 삭제
 * @param btn
 * @param btnClass
 */
function shipLevRemove(btn,btnClass){
//	console.log("btnClass : "+btnClass);
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
		alert("등급이 1개일 때는 삭제 할 수 없습니다.\n\n등급은 최소 1개 이상 있어야 합니다.");
	}
}

/**
 * 등급 추가
 * @param btnClass
 */
function shipLevAdd(btnClass){
	var td_1 = "<p class='shipLev lvP_"+btnClass+"'><input type='text' name='lvName_"+btnClass+"' class='form-control' required='required' placeholder='New Level'></p>";
	$("#tr_"+btnClass+" td").eq(2).append(td_1);
	
	var td_2 = "<p class='shipLevVal lvValP_"+btnClass+"'><input type='number' name='lvVal_"+btnClass+"' class='form-control' required='required' placeholder='0'></p>";
	$("#tr_"+btnClass+" td:eq(3)").append(td_2);
	
	var td_3 = "";
	td_3 += "<p class='shipLevValSel lvSelP_"+btnClass+"'><select name='lvUnit_"+btnClass+"' class='form-control levVal' >";
	td_3 += "<option value='PERC'>%</option>";
	td_3 += "<option value='KRW'>KRW</option>";
	for(var i=0; i<selData.curr_head.length; i++){
		td_3 += "<option value='"+selData.curr_head[i].curr+"'>"+selData.curr_head[i].curr+"</option>";
	}
	td_3 += "</select></p>";
	$("#tr_"+btnClass+" td:eq(4)").append(td_3);
	
	$(".lvAddBtnP_"+btnClass).remove();
	var td_4 = "<p class='shipLevDelBtn lvDelBtnP_"+btnClass+"' ><button type='button' name='lvDelBtn_"+btnClass+"' class='btn btn-warning lvDelBtn_"+btnClass+"' onclick='shipLevRemove(this,\""+btnClass+"\");'>등급 삭제</button></p>";
	td_4 += "<p class='lvAddBtnP_"+btnClass+"'><button type='button' class='btn btn-success' onclick='shipLevAdd(\""+btnClass+"\");'>등급 추가</button></p>";
	$("#tr_"+btnClass+" td:eq(5)").append(td_4);
}

function shipRemove(shipId){
	if(confirm("업체 "+$("#shipName_"+shipId).val() + " 을 삭제하시겠습니까?")){
		$("#tr_"+shipId).remove();
	}
}

/**
 * 배송대행지 저장
 */
function saveShips(){
	var frm = document.shipList;
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}