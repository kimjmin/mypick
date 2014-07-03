<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String m = request.getParameter("m"); 
if(m == null || m.equals("")){ m="fee"; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Calculator/MyPick</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="../css/bootstrap.min.css">
<link rel="stylesheet" href="../css/mypick.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/jquery.number.min.js"></script>
<script src="../js/mypick.js"></script>
</head>
<body>
	<div class="container">

<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->

		<div class="row">
			<div class="col-md-3">
<!-- 좌측 메뉴 시작 -->

<h2>Community</h2>
<p class="text-muted">커뮤니티</p>

<!-- 메뉴 링크 목록 시작 -->	
<div class="list-group">
	<a href="../Calc/Fee" class="list-group-item <%if("fee".equals(m)){out.print("active");}%>">배송 대행 요금비교</a>
	<a href="../Calc/Tax" class="list-group-item <%if("tax".equals(m)){out.print("active");}%>">면세 범위 계산표</a>
	<a href="../Calc/Trans" class="list-group-item <%if("trans".equals(m)){out.print("active");}%>">단위 변환기</a>
	<a href="../Calc/Volume" class="list-group-item <%if("volume".equals(m)){out.print("active");}%>">부피 / 무게 계산기</a>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 환율 정보 시작 -->
<%@include file="../ctrl/currinfo.jsp"%>
<!-- 환율 정보 끝 -->
				
<!-- 좌측 메뉴 끝 -->			

			</div>

			<div class="col-md-9">
				<div class="container">
					<div class="row">
						<blockquote>
							<p>배송대행 요금비교 및 과세여부 판별기</p>
							<small>배송대행지의 요금비교과 물품가격 및 관부가세 과세여부를 판별해주는 계산기입니다.</small>
						</blockquote>

						<p>
							구매정보 입력
							<button type="button" class="btn btn-info btn-xs">도움말</button>
						</p>
					</div>

					<div class="col-md-8">
						<form class="form-inline" role="form">
							<table class="table">
								<thead>
									<tr>
										<th>실제 결재금액</th>
										<th>물품 무게</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>
											<div class="form-group">
												<label class="sr-only" for="amount">실제 결재금액</label>
												<input type="amount" class="form-control" id="amount" placeholder="결재금액">
											</div>
											<div class="form-group">
												<label class="sr-only" for="curr">통화</label>
												<select class="form-control" id="curr">
													<option>USD/$</option>
													<option>GBP/￡</option>
												</select>
											</div>
										</td>
										<td>
											<div class="form-group">
												<label class="sr-only" for="weight">무게</label>
												<input type="number" class="form-control" id="weight" placeholder="무게">
											</div>
											<div class="form-group">
												<label class="sr-only" for="wunit">단위</label>
												<select class="form-control" id="wunit">
													<option>lb</option>
													<option>oz</option>
													<option>kg</option>
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							
<div class="row">
	<ul id="fldFmtTab" class="nav nav-tabs">
		<li class="active"><a href="#shop1" data-toggle="tab">몰테일</a></li>
		<li ><a href="#shop2" data-toggle="tab">유니옥션</a></li>
		<li ><a href="#shop3" data-toggle="tab">쇼핑몰3</a></li>
		<li ><a href="#shop4" data-toggle="tab">쇼핑몰4</a></li>
	</ul>
	
	<div id="fldFmtTabContent" class="tab-content">

<!-- CSV 형식 시작 -->
<div class="tab-pane fade active in" id="shop1">
<br/>
<div class="container">
<div class="form-group">
	<select class="form-control" id="s1lev">
		<option>등급</option>
		<option>일반</option>
		<option>브론즈</option>
		<option>실버</option>
		<option>골드</option>
	</select>
	<input type="number" min="0" max="1000" class="form-control" id="amount" placeholder="할인율"> %
</div>

</div>
</div>

<div class="tab-pane fade" id="shop2">
</div>

<div class="tab-pane fade" id="shop3">
</div>

<div class="tab-pane fade" id="shop4">
</div>


	</div>
</div>

							
							
						</form>

					</div>
				</div>
			</div>

		</div>
	</div>

</body>
</html>