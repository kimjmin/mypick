<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam,mpick.com.MpickMsg"%>
<%@page import="mpick.com.MpickUserObj"%>
<%@page import="java.text.SimpleDateFormat,java.util.Date,java.util.Locale"%>
<%

MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
String bbs = request.getParameter("bbs");
String tNum = request.getParameter("t_num");
MpickDao dao = MpickDao.getInstance();
DataEntity[] tDatas = dao.getCommText(bbs,tNum);
if(tDatas != null && tDatas.length > 0){
	DataEntity tData = tDatas[0];
	MpickUserObj writerObj = dao.getUserObj(tData.get("user_email")+"");
	Date t_date = (Date)tData.get("t_date");
	SimpleDateFormat frmt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.KOREA);
	
	String tText = tData.get("t_text")+"";
	tText = tText.replaceAll("<img ", "<img class=\"img-responsive\" ");

%>
<table class="table" id="bbs">
<thead>
	<tr class="info">
		<th ><%=writerObj.getNicname()%> 님</th>
		<th class="text-right" width="35%"><%=frmt.format(t_date)%></th>
		<th class="text-center" width="10%">hit : <%=tData.get("t_hit")+""%></th>
		
	</tr>
	<tr>
		<td colspan="4">
			<h4><span class="text-muted">[ <%=tData.get("bbs_cate_name")+""%> ]</span> <%=tData.get("t_title")+""%></h4>
		</td>
	</tr>
</thead>
<tbody>
	<tr>
		<td colspan="3">
<%=tText%>
		</td>
	</tr>
</tbody>
</table>

<ul class="pager">
	<li class="previous"><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>"><span class="glyphicon glyphicon-align-justify"></span> 목록</a></li>
<%
if(userObj != null && userObj.getEmail().equals(writerObj.getEmail())){
%>
  	<li class="next"><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/Write/<%=tNum%>"><span class="glyphicon glyphicon-pencil"></span> 수정</a></li>
<% } %>  	
</ul>
<%
} else {
	out.print(MpickMsg.error("존재하지 않는 글입니다."));
}
%>