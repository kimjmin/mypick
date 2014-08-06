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
	<li>결제통화 단위를 선택 후, 실제로 결제한 금액을 입력합니다.<br/>
		(물건금액+현지배송비+현지세금, 적립금 또는 기프트카드를 사용하였을 경우 해당금액포함.)
	</li>
	<li>무게 단위를 선택 후, 예상되거나 실측된 무게를 입력합니다.</li>
	<li>회원등급을 선택하지 않으시면 가장낮은 회원등급으로 계산됩니다.</li>
	<li>회원등급 옆칸에는 쿠폰 할인율을 입력하시고, 없을 경우 입력하지 않으셔도 됩니다.</li>
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
    	var shList = "";
    	var shId = $(".shipId:checked");
    	for(var i=0; i<shId.length; i++){
    		
    		var param="cmd=shipInfo";
    		param += "&";
    		param += "shipId="+shId.eq(i).val();
    		$.ajax({
    			type : "GET",
    			data : param,
    			url : "../Control/MpickAjax",
    			dataType:"json",
    			success : function(dataCate) {
    				
    			}, error:function(e){  
    				console.log(e.responseText);  
    			}
    		});	
    		
    		
    		shList += "<br/> "+shId.eq(i).val();
    		var shSel = $("#"+shId.eq(i).val()+"Sel");
    		shList += " "+shSel.val();
    	}
    	
    	$("#shipList").append(shList);
    });
});
</script>



<div class="row">
	<div class="col-md-2">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#shipModal">배송대행지 선택</button>
	</div>
	<div class="col-md-2">
		<input type="number" class="form-control" id="wVal" max="1000000000" min="0" step="0.001" placeholder="무게">
	</div>
	<div class="col-md-2">
		<select class="form-control" id="wSel">
			<option value="lb" selected="selected">lb (파운드)</option>
			<option value="kg">kg (킬로그램)</option>
			<option value="g">g (그램)</option>
			<option value="oz">oz (온스)</option>
		</select>
	</div>
</div>

<div id="shipList"></div>

<br/>
	<label>
		<input type="checkbox"> 몰테일 (kg)
	</label>
<div class="row">
	<div class="col-md-2">
		<select class="form-control" id="lev0">
			<option value="lb" selected="selected">lb (파운드)</option>
			<option value="kg">kg (킬로그램)</option>
			<option value="g">g (그램)</option>
			<option value="oz">oz (온스)</option>
		</select>
	</div>
	<div class="col-md-2">
		<input type="number" class="form-control" disabled="disabled" value="112">
	</div>
	<div class="col-md-2">
		<input type="number" class="form-control" id="disc0" max="1000000000" min="0" step="0.01" placeholder="할인금액">
	</div>
</div>


</div>
