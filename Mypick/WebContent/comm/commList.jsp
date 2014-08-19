<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%@page import="java.text.SimpleDateFormat,java.util.Date,java.util.Locale"%>
<% 
String bbs = request.getParameter("bbs");
MpickDao dao = MpickDao.getInstance();
String pageNumStr = request.getParameter("pageNum");
int pageSize = 10;
int pageCntSize = 5;
int pageNum = 0;
if(pageNumStr != null && !"".equals(pageNumStr)){
	pageNum = Integer.parseInt(pageNumStr) - 1;
}
int totalCnt = dao.getCommListCnt(bbs, null, null, null);
DataEntity[] listData =  dao.getCommList(bbs, null, null, null, pageSize, pageNum);

int pageCnt = (totalCnt / pageSize)+1;
int srtNum = 0;
int endNum = 0;

if(pageCnt < (pageCntSize+1)){
	if(pageNum > (pageCntSize/2)){
		srtNum = pageNum - (pageCntSize/2);
	}
	endNum = pageCnt;
} else {
	if(pageNum > (pageCntSize/2)){
		srtNum = pageNum - (pageCntSize/2);
	}
	endNum = srtNum + pageCntSize;
	if(endNum > pageCnt){
		endNum = pageCnt;
		srtNum = endNum - pageCntSize;
	}
}
/*
System.out.println("totalCnt: "+totalCnt);
System.out.println("pageCnt: "+pageCnt);
System.out.println("pageSize: "+pageSize);
System.out.println("pageNum: "+pageNum);
System.out.println("srtNum: "+srtNum);
System.out.println("endNum: "+endNum);
*/
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
	String replys = listData[i].get("replys")+"";
	String tTitle = listData[i].get("t_title")+"";
	if(tTitle.length() > 30){
		tTitle = tTitle.substring(0,30)+" ...";
	}
%>
	<tr>
		<td class="text-center"><%=listData[i].get("t_num")+""%></td>
		<td class="">[ <%=listData[i].get("bbs_cate_name")+""%> ]</td>
		<td class=""><a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/View/<%=listData[i].get("t_num")+""%>"><%=tTitle%></a><% if(replys != null && !"".equals(replys) && !"0".equals(replys)){ %> [<%=replys %>]<% } %></td>
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