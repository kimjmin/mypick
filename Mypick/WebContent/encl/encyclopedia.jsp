<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String m = request.getParameter("m"); 
if(m == null || m.equals("")){ m="atoz"; }
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
<script src="../js/mypick.js"></script>
</head>
<body>
	<div class="container">

<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->

		<div class="row">
			<div class="col-md-3">
<!-- 좌측 메뉴 시작 -->

<h2>Encyclopedia</h2>
<p class="text-muted">쇼퍼를 위한 백과사전</p>

<!-- 메뉴 링크 목록 시작 -->
<div class="list-group">
	<a href="../Encl/Atoz" class="list-group-item <%if("atoz".equals(m)){out.print("active");}%>">초보를 위한 A to Z</a>
	<a href="../Encl/Tax" class="list-group-item <%if("tax".equals(m)){out.print("active");}%>">요금 / 관 부과세 관련</a>
	<a href="../Encl/Refund" class="list-group-item <%if("refund".equals(m)){out.print("active");}%>">쇼핑 환급 관련</a>
	<a href="../Encl/Exchange" class="list-group-item <%if("exchange".equals(m)){out.print("active");}%>">교환 / 환불 관련</a>
</div>
<!-- 메뉴 링크 목록 끝 -->

<!-- 환율 정보 시작 -->
<table class="table">
	<thead>
	<tr>
		<th>통화</th>
		<th>USD/$</th>
		<th>GBP/￡</th>
	</tr>
	</thead>
	<tbody>
		<tr>
			<th>기준환율</th>
			<td>1,018.10</td>
			<td>1,733.32</td>
		</tr>
		<tr>
			<th>사실때</th>
			<td>1,035.91</td>
			<td>1,767.81</td>
		</tr>
		<tr>
			<th>보낼때</th>
			<td>1,028.00</td>
			<td>1,750.65</td>
		</tr>
		<tr>
			<th>고시환율</th>
			<td>1.00</td>
			<td>1.00</td>
		</tr>
	</tbody>
</table>
<!-- 환율 정보 끝 -->

<!-- 좌측 메뉴 끝 -->
			</div>
			
			<div class="col-md-9">
<!-- 우측 내용 시작 -->
<!-- 우측 내용 끝 -->
			</div>

		</div>
	</div>

</body>
</html>