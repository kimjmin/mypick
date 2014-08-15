<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%@page import="java.text.SimpleDateFormat,java.util.Date,java.util.Locale"%>
<% 
String bbs = request.getParameter("bbs");
MpickDao dao = MpickDao.getInstance();
String pageNumStr = request.getParameter("pageNum");
int pageSize = 10;
int pageNum = 0;
if(pageNumStr != null && !"".equals(pageNumStr)){
	pageNum = Integer.parseInt(pageNumStr) - 1;
}
int totalCnt = dao.getCommListCnt(bbs, null, null, null);
DataEntity[] listData =  dao.getCommList(bbs, null, null, null, pageSize, pageNum);

int srtNum = 0;
if(pageNum > 2){
	srtNum = pageNum - 2;
} else {
	srtNum = 0;
}
int endNum = (totalCnt / pageSize) + 1;
if(endNum > 5){
	endNum = 5;
}

%>
<table class="table table-condensed table-hover" id="bbs">
<thead>
	<tr class="info">
		<th class="text-center" width="10%">No</th>
		<th class="text-center" width="15%">Category</th>
		<th class="text-center">Subject</th>
		<th class="text-center" width="10%">Name</th>
		<th class="text-center" width="7%">Date</th>
		<th class="text-center" width="8%">Hit</th>
	</tr>
</thead>
<tbody>
<%
for(int i=0; i<listData.length; i++){
	Date t_date = (Date)listData[i].get("t_date");
	SimpleDateFormat frmt = new SimpleDateFormat("MM-dd", Locale.KOREA);
%>
	<tr>
		<td class="text-center"><%=listData[i].get("t_num")+""%></td>
		<td class="text-center">[ <%=listData[i].get("bbs_cate_name")+""%> ]</td>
		<td class=""><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/View/<%=listData[i].get("t_num")+""%>"><%=listData[i].get("t_title")+""%></a></td>
		<td class="text-center"><%=listData[i].get("nicname")+""%></td>
		<td class="text-center"><%=frmt.format(t_date)%></td>
		<td class="text-center"><%=listData[i].get("t_hit")+""%></td>
	</tr>
<% } %>
</tbody>
</table>

<form name="pageFrm">
<ul class="pager">
	<li class="previous"><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>"><span class="glyphicon glyphicon-align-justify"></span> 목록</a></li>
  	<li class="next"><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/Write"><span class="glyphicon glyphicon-pencil"></span> 글쓰기</a></li>
<%if(pageNum > 0){ %>
  	<li><a href="javascript:goPage('<%=(pageNum)+""%>');">&lt</a></li>
<% } %>
<%
for(int i=srtNum; i < endNum; i++){ %>
	<li <%if(i==pageNum){out.print("class='active'");} %>><a href="javascript:goPage('<%=(i+1)+""%>');"><%=(i+1)+""%></a></li>
<% } %>
<%if(pageNum < (endNum-1)){ %>
	<li><a href="javascript:goPage('<%=(pageNum+2)+""%>');">&gt</a></li>
<% } %>
</ul>
<input type="hidden" name="pageNum" id="pageNum"/>
</form>
<script>
function goPage(pageN){
	var frm = document.pageFrm;
	$("#pageNum").val(pageN);
	frm.method = "POST";
	frm.action = "<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
	frm.submit();
}
</script>