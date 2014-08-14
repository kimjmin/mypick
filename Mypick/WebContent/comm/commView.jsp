<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%
String tNum = request.getParameter("t_num");
MpickDao vDao = MpickDao.getInstance();
DataEntity[] tData = vDao.getCommText(tNum);
if(tData.length > 0){
	String t_state = (String)tData[0].get("t_state");
	if("LOGIN".equals(t_state)){
		
	}
%>
<%=tData[0].get("t_text")+""%>

뒤로

<%
} else {
%>

<% } %>