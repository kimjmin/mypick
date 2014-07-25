<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container">
<script src="../js/admShip.js"></script>
<script></script>
<div class="col-sm-7">

<h3>배송대행지 추가</h3>
<form action="javascript:addShipItem();">
<table class="table">
<thead>
	<tr class="center">
		<th width="30%">업체명</th>
		<th width="40%">홈페이지 URL</th>
		<th width="30%" colspan="2">등급 종류 수</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>
			<input id="shipName" type="text" class="form-control" placeholder="업체명" required="required">
		</td>
		<td>
			<input id="shipUrl" type="text" class="form-control" placeholder="URL" value="http://">
		</td>
		<td width="15%">
			<input id="shipVals" type="number" class="form-control" max="100" min="1" step="1" required="required" value="1">
		</td>
		<td width="15%">
			<button id="addShipBtn" type="submit" class="btn btn-success btn-block" disabled='disabled'>업체 추가</button>
		</td>
	</tr>
</tbody>
</table>
</form>

<form name="shipList" action="javascript:saveShips();">
<div class="row">
	<div class="col-md-8">
		<h3>배송대행지 목록</h3>
	</div>
	<div class="col-md-4">
		<button type="submit" class="btn btn-primary btn-block">배송대행지 저장</button>
	</div>
</div>

<table class="table">
<thead>
	<tr class="center">
		<th width="8%"></th>
		<th width="32%">업체명</th>
		<th width="18%">등급 종류</th>
		<th width="27%" colspan="2">할인율 / 할인금액</th>
		<th width="15%"></th>
	</tr>
</thead>
<tbody id="shipList">
	<tr class="shipItem">
	</tr>
</tbody>
</table>
<input type="hidden" name="cmd" value="saveShip" />
<input type="hidden" name="toUrl" value="../Admin/Ship" />
<div class="row">
	<div class="col-md-8">
	</div>
	<div class="col-md-4">
		<button type="submit" class="btn btn-primary btn-block">배송대행지 저장</button>
	</div>
</div>
</form>

</div>

</div>