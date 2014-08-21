<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam,mpick.com.MpickDao,jm.net.DataEntity"%>
<%
MpickDao daoF = MpickDao.getInstance();
DataEntity[] linkDataF = daoF.getLinks("FOOTER",null);
%>
<!-- 데스크탑 화면에서 푸터 시작 -->
<div class="footer visible-md visible-lg">
	<div class="container">
		<div class="col-sm-1 text-right">
			<h4><img class="logo logo-foot" src="<%=MpickParam.hostUrl%>/resource/img/mypick.png"></h4>
		</div>
		<div class="col-sm-11">
			<p class="copyright">
<%
if(linkDataF != null){
	for(int i=0; i<linkDataF.length; i++){
%>
				<a href="<%=linkDataF[i].get("m_link")+""%>"><%=linkDataF[i].get("m_title")+""%></a>
<% 
		if(i < linkDataF.length - 1){ %> | <% }
	} 
} 
%>
				<br/>이 사이트의 정보는 참고용으로만 사용하여야 하며, 이로 인해 발생하는 손해에 대해 책임지지 않습니다.
				<br/>myPICK 의 모든 콘텐츠는 저작자의 허락 없이 무단 전재를 금합니다. Copyright 2014 &copy; myPICK ALL RIGHTS RESERVED.
			</p>
		</div>
	</div>
</div>
<!-- 데스크탑 화면에서 푸터 끝 -->

<!-- 태블릿 화면에서 푸터 시작 -->
<div class="footer visible-sm">
	<div class="container">
		<div class="col-sm-2 text-right">
			<h4><img class="logo logo-foot" src="<%=MpickParam.hostUrl%>/resource/img/mypick.png"></h4>
		</div>
		<div class="col-sm-10">
			<p class="copyright">
<%
if(linkDataF != null){
	for(int i=0; i<linkDataF.length; i++){
%>
				<a href="<%=linkDataF[i].get("m_link")+""%>"><%=linkDataF[i].get("m_title")+""%></a>
<% 
		if(i < linkDataF.length - 1){ %> | <% }
	} 
} 
%>
				<br/>이 사이트의 정보는 참고용으로만 사용하여야 하며, 이로 인해 발생하는 손해에 대해 책임지지 않습니다.
				<br/>myPICK 의 모든 콘텐츠는 저작자의 허락 없이 무단 전재를 금합니다. Copyright 2014 &copy; myPICK ALL RIGHTS RESERVED.
			</p>
		</div>
	</div>
</div>
<!-- 태블릿 화면에서 푸터 끝 -->

<!-- 모바일 화면에서 푸터 시작 -->
<div class="footer visible-xs">
	<div class="container">
		<div class="row">
			<div class="col-xs-4 text-center">
				<img class="logo logo-foot" src="<%=MpickParam.hostUrl%>/resource/img/mypick.png">
			</div>
			<div class="col-xs-8" style="padding:2px 0px;">
				<p class="copyright" style="padding:0px; margin:0px;">
					Copyright 2014 &copy; myPICK
					<br/>ALL RIGHTS RESERVED.
				</p>
			</div>
		</div>
		<div class="text-center">
<%
if(linkDataF != null){
	for(int i=0; i<linkDataF.length; i++){
%>
				<a href="<%=linkDataF[i].get("m_link")+""%>"><%=linkDataF[i].get("m_title")+""%></a>
<% 
		if(i < linkDataF.length - 1){ %> | <% }
	} 
} 
%>
		</div>
	</div>
</div>
<!-- 모바일 화면에서 푸터 끝 -->