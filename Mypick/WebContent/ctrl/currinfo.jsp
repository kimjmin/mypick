<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="../js/curr.js"></script>
<script>
initCurr();
</script>


<div class="pull-right">
	<span class="text-red" id="up_date"></span> <span class="text-red" id="up_time"></span>
</div>

<table class="table">
	<thead>
	<tr>
		<th>통화</th>
		<th>
			<select class="form-control" id="currSel" onchange="setCurrVal();">
		</select>
		</th>
	</tr>
	</thead>
	<tbody>
		<tr>
			<th>기준환율</th>
			<td><span id="sell_refer" class="text-blue"></span></td>
		</tr>
		<tr>
			<th>사실때</th>
			<td><span id="cash_buy" class="text-blue"></span></td>
		</tr>
		<tr>
			<th>보내실때</th>
			<td><span id="trans_send" class="text-blue"></span></td>
		</tr>
		<tr>
			<th>고시환율</th>
			<td><span id="usd_rate" class="text-blue"></span></td>
		</tr>
	</tbody>
</table>
