<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="container">

<div class="row">
	<blockquote>
		<p>단위 변환기</p>
		<small>해외구매시 자주 사용하는 단위로 변환해주는 변환기입니다.</small>
	</blockquote>
</div>

<div class="row">
	<h4>원단위 값 입력 <small>소수점 3자리까지 입력 가능합니다.</small></h4>
</div>

<br/>
<form class="form-horizontal" role="form" action="javascript:transUnit();">
<div class="row">
  <div class="form-group">
    <div class="col-sm-2">
		<input type="number" class="form-control" id="wInput" max="1000000000" min="0" step="0.001" placeholder="무게">
    </div>
    <div class="col-sm-2">
	    <select class="form-control" id="wSel">
			<option value="lb" selected="selected">lb (파운드)</option>
			<option value="kg">kg (킬로그램)</option>
			<option value="g">g (그램)</option>
			<option value="oz">oz (온스)</option>
		</select>		
    </div>
    <div class="col-sm-1">
    	<button type="submit" class="btn btn-primary">확인</button>
    </div>
  </div>
</div>
<div class="row">
	<div class="col-sm-7">
	<table class="table table-bordered text-center">
		<thead >
		<tr class="info">
			<th class="text-center">lb (파운드)</th>
			<th class="text-center">kg (킬로그램)</th>
			<th class="text-center">g (그램)</th>
			<th class="text-center">oz (온스)</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><span id="wlb">0</span></td>
			<td><span id="wkg">0</span></td>
			<td><span id="wg">0</span></td>
			<td><span id="woz">0</span></td>
		</tr>
		</tbody>
	</table>
	</div>
</div>

<br/>
<div class="row">
  <div class="form-group">
    <div class="col-sm-2">
		<input type="number" class="form-control" id="lInput" max="1000000000" min="0" step="0.001" placeholder="길이">
    </div>
    <div class="col-sm-2">
	    <select class="form-control" id="lSel">					
			<option value="cm">cm (센티미터)</option>
			<option value="in">in (인치)</option>
			<option value="ft">ft (피트)</option>
		</select>		
    </div>
    <div class="col-sm-1">
    	<button type="submit" class="btn btn-success">확인</button>
    </div>
  </div>
</div>
<div class="row">
	<div class="col-sm-7">
	<table class="table table-bordered text-center">
		<thead >
		<tr class="success">
			<th class="text-center">cm (센티미터)</th>
			<th class="text-center">in (인치)</th>
			<th class="text-center">ft (피트)</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><span id="lcm">0</span></td>
			<td><span id="lin">0</span></td>
			<td><span id="lft">0</span></td>
		</tr>
		</tbody>
	</table>
	</div>
</div>

<br/>
<div class="row">
  <div class="form-group">
    <div class="col-sm-2">
		<input type="number" class="form-control" id="vInput" max="1000000000" min="0" step="0.001" placeholder="부피">
    </div>
    <div class="col-sm-3">
	    <select class="form-control" id="vSel">
			<option value="floz">fl.oz (액량온스)</option>
			<option value="gal">gal (갤런)</option>
			<option value="l">L (리터)</option>
			<option value="cc">mL (밀리리터) / cc (씨씨)</option>
		</select>
    </div>
    <div class="col-sm-1">
    	<button type="submit" class="btn btn-warning">확인</button>
    </div>
  </div>
</div>
<div class="row">
	<div class="col-sm-7">
	<table class="table table-bordered text-center">
		<thead >
		<tr class="warning">
			<th class="text-center">fl.oz (액량온스)</th>
			<th class="text-center">gal (갤런)</th>
			<th class="text-center">L (리터)</th>
			<th class="text-center">mL (밀리리터) / cc (씨씨)</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><span id="vfloz">0</span></td>
			<td><span id="vgal">0</span></td>
			<td><span id="vl">0</span></td>
			<td><span id="vcc">0</span></td>
		</tr>
		</tbody>
	</table>
	</div>
</div>

</form>
</div>