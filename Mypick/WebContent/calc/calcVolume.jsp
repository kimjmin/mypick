<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<blockquote>
	<p>부피무게 계산기</p>
	<small>부피무게를 계산 해 주는 계산기입니다.</small>
</blockquote>

<h4>길이 값 입력 </h4>

<br/>
<form class="form-horizontal" role="form" action="javascript:calVolume();">

<div class="form-group">
	<div class="col-lg-6">
		<label for="vWidth" class="col-xs-5 control-label">가로 (inch)</label>
		<div class="col-xs-7">
			<input type="number" class="form-control" id="vWidth" max="1000000000" min="0" step="0.001" placeholder="가로" required="required">
		</div>
	</div>
	<div class="col-lg-6"></div>
</div>

<div class="form-group">
	<div class="col-lg-6">
		<label for="vDepth" class="col-xs-5 control-label">세로 (inch)</label>
		<div class="col-xs-7">
			<input type="number" class="form-control" id="vDepth" max="1000000000" min="0" step="0.001" placeholder="세로" required="required">
		</div>
	</div>
	<div class="col-lg-6"></div>
</div>

<div class="form-group">
	<div class="col-lg-6">
		<label for="vHeight" class="col-xs-5 control-label">높이 (inch)</label>
		<div class="col-xs-7">
			<input type="number" class="form-control" id="vHeight" max="1000000000" min="0" step="0.001" placeholder="높이" required="required">
		</div>
	</div>
	<div class="col-lg-6"></div>
</div>

<div class="form-group">
	<div class="col-lg-6">
		<div class="col-lg-12">
			<button type="submit" class="btn btn-success btn-block">확인</button>
		</div>
	</div>
	<div class="col-lg-6"></div>
</div>
</form>

<hr/>
<div class="row">
	<h4>부피무게 계산 결과</h4>
	<h4 id="vForm"></h4>
	<h3 id="vRes"></h3>
</div>
