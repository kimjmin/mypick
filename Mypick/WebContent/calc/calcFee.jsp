<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickDao,jm.net.DataEntity"%>
<div class="col-md-12">

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
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
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
        <button type="button" class="btn btn-danger" data-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<form action="javascript:calcShip();">
<div class="row">
	<div class="col-md-2">
		<button type="button" class="btn btn-success" data-toggle="modal" data-target="#shipModal">배송 대행지 선택</button>
	</div>
	<div class="col-md-2">
		<input type="number" class="form-control" id="wVal" max="1000000000" min="0.001" step="0.001" placeholder="무게" required="required">
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

</div>