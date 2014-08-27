<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam"%>
<%
String toUrl = request.getParameter("toUrl");
if (toUrl == null || toUrl.equals("")){ 
	toUrl = MpickParam.getHostUrl() + "/Page/Welcome";
	toUrl = toUrl.replaceAll("//Page", "/Page");
}
response.sendRedirect(toUrl);
%>