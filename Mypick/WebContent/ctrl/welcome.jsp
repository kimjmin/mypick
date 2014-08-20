<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam,mpick.com.MpickDao,jm.net.DataEntity"%>
<%
MpickDao dao = MpickDao.getInstance();
DataEntity[] linkData = dao.getLinks("WELCOME",null);
%>
<!DOCTYPE html>
<html>
<head>
<title>MyPick</title>
<!-- 공통 라이브러리 시작 -->
<%@include file="../ctrl/header.jsp"%>
<!-- 공통 라이브러리 시작 -->
</head>
<body>
<!-- 상단 네비게이션 메뉴 시작 -->	
<%@include file="../ctrl/navbar.jsp"%>
<!-- 상단 네비게이션 메뉴 끝 -->
<div class="container">
<div class="row">
	<div class="col-sm-5">
		<div id="welcome-text" class="visible-md visible-lg">
			<h1>반갑습니다!</h1>
			<h3>스마트한 쇼퍼를 위한 해외직구 정보공유공간<br>myPICK 입니다.</h3>
		</div>
		<div class="visible-sm visible-xs">
			<h4>반갑습니다!</h4>
			<h5>스마트한 쇼퍼를 위한 해외직구 정보공유공간<br>myPICK 입니다.</h5>
		</div>
	</div>
	<div class="col-sm-7">
		<img class="img-responsive" src="<%=MpickParam.hostUrl%>/resource/img/main_img.png">
	</div>
</div>
<br><br>
		<div class="row">
<div class="col-md-6 my-column-in">
	<div class="col-sm-6">
		<div class="panel panel-default panel-primary">
			<div class="panel-body">
				<h3>해외직구가<br>처음이신가요?</h3>
				<p>초보를 위한 A to Z를 통해<br>즐거운 해외직구를<br>경험해보세요.</p>
				<a href="<%if(linkData.length>0){ out.print(linkData[0].get("m_link")+"");}%>">
					<img class="img-responsive pull-right" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_pen.png">
				</a>
			</div>
		</div>
	</div>		
	<div class="col-sm-6">
		<div class="panel panel-default panel-success">
			<div class="panel-body">
				<h3>가장 저렴한<br>배송대행지는 어디?</h3>
				<p>배송대행지 가격비교를 이용해<br>가장 저렴한 배송대행지를<br>찾아보세요.</p>
				<a href="<%if(linkData.length>1){ out.print(linkData[1].get("m_link")+"");}%>">
					<img class="img-responsive pull-right" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_listdown.png">
				</a>
			</div>
		</div>
	</div>
</div>
<div class="col-md-6 my-column-in">
	<div class="col-sm-6">
		<div class="panel panel-default panel-danger">
			<div class="panel-body">
				<h3>이번주의<br>면세상한선은?</h3>
				<p>이번주 관세청 고시환율로<br>얼마까지 면세받을 수 있는지<br>쉽게 알아보세요.</p>
				<a href="<%if(linkData.length>2){ out.print(linkData[2].get("m_link")+"");}%>">
					<img class="img-responsive pull-right" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_limitup.png">
				</a>
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="panel panel-default panel-warning">
			<div class="panel-body">
				<h3>kg? lb? oz?<br>너무 어려워!</h3>
				<p>어려운 단위계산,<br>myPICK 단위 변환기로<br>간편하게!</p>
				<a href="<%if(linkData.length>3){ out.print(linkData[3].get("m_link")+"");}%>">
					<img class="img-responsive pull-right" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_cal.png">
				</a>
			</div>
		</div>
	</div>
</div>

	</div>
</div>
	

<!-- 하단 푸터 시작 -->
<%@include file="../ctrl/footer.jsp"%>
<!-- 하단 푸터 끝 -->
</body>
</html>