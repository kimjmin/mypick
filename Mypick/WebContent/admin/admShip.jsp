<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="container">
<scrpit src="../js/admin.js"></scrpit>
<script>
//initLevSel();
</script>
<div class="col-sm-7">

<form action="javascript:addShipItem();">
<table class="table">
<thead>
	<tr class="center">
		<th width="30%">업체명</th>
		<th width="40%">홈페이지 URL</th>
		<th width="15%">등급 종류 수</th>
		<th width="15%"></th>
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
		<td>
			<input id="shipVals" type="number" class="form-control" max="100" min="1" step="1" required="required" value="1">
		</td>
		<td>
			<button id="addShipBtn" type="submit" class="btn btn-success btn-block" disabled='disabled'>업체 추가</button>
		</td>
	</tr>
</tbody>
</table>
</form>

<form action="javascript:saveShips();">
<table class="table">
<thead>
	<tr class="center">
		<th width="30%">업체명</th>
		<th width="25%">등급 종류</th>
		<th width="30%" colspan="2">할인율 / 할인금액</th>
		<th width="15%"></th>
	</tr>
</thead>
<tbody id="shipList">
	<tr class="shipItem">
	</tr>
</tbody>
</table>
</form>

</div>

</div>