<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String toUrl = request.getParameter("toUrl");
/*
if (toUrl == null || toUrl.equals("")){ toUrl = "Calc/Fee"; }
*/
if (toUrl == null || toUrl.equals("")){ toUrl = "Control/Ready"; }
response.sendRedirect(toUrl);
%>