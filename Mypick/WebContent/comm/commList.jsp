<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%@page import="java.text.SimpleDateFormat,java.util.Date,java.util.Locale"%>
<%@page import="mpick.com.MpickUserObj"%>
<% 
MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
String bbs = request.getParameter("bbs");
String cate = request.getParameter("cate");
String pageNumStr = request.getParameter("pageNum");

String schOpt = request.getParameter("schOpt");
String schTxt = request.getParameter("schTxt");

if(cate == null) cate = "";
if(schOpt == null) schOpt = "t_title";
if(schTxt == null) schTxt = "";
MpickDao dao = MpickDao.getInstance();
int pageSize = 10;
int pageCntSize = 5;
int pageNum = 0;
if(pageNumStr != null && !"".equals(pageNumStr)){
	pageNum = Integer.parseInt(pageNumStr) - 1;
	if(pageNum < 0) pageNum = 0;
}
int totalCnt = dao.getCommListCnt(bbs, cate, schOpt, schTxt);
DataEntity[] listData =  dao.getCommList(bbs, cate, schOpt, schTxt, pageSize, pageNum);

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

DataEntity[] msgData = dao.getMenuMsg("Comm",bbs,"TRUE");
%>
<script>
function goPage(pageN){
	var frm = document.pageFrm;
	$("#pageNum").val(pageN);
	frm.method = "POST";
	frm.action = "<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
	frm.submit();
}
function goCate(cate){
	var frm = document.pageFrm;
	$("#cate").val(cate);
	frm.method = "POST";
	frm.action = "<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
	frm.submit();
}
function search(){
	var frm = document.pageFrm;
	frm.method = "POST";
	frm.action = "<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
	frm.submit();
}
</script>

<%if(msgData !=null && msgData.length == 1){ 
String mText = msgData[0].get("m_text")+"";
mText = mText.replaceAll("\r\n", "<br>");
%>
<div class="row">
	<blockquote>
		<p><%=msgData[0].get("m_title")+""%></p>
		<small><%=mText%></small>
	</blockquote>
</div>
<% } %>

<div class="row">
<%
String btnClass = "";
if(cate == null || "".equals(cate)){
	btnClass = "btn-primary";
} else {
	btnClass = "btn-default";
}
%>
<button class="btn btn-xs <%=btnClass%>" onclick="goCate('');">전체</button>
<%
DataEntity[] cateData = dao.getCommCate(bbs);
if(cateData != null){
	for(int i=0; i<cateData.length; i++){
		String cateName = cateData[i].get("bbs_cate_name")+"";
		if(cateName.equals(cate)){
			btnClass = "btn-primary";
		} else {
			btnClass = "btn-default";
		}
%>
<button class="btn btn-xs <%=btnClass%>" onclick="goCate('<%=cateName%>');"><%=cateName%></button>
<%		
	}
}
%>
</div>
<p></p>
<div class="row">
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
	String tNotice = listData[i].get("t_notice")+"";
	String tCate = listData[i].get("bbs_cate_name")+"";
	String tNoticeClass = "";
	if("TRUE".equals(tNotice)){
		tCate = "공지사항";
		tNoticeClass = "class='warning'";
	}
%>
	<tr <%=tNoticeClass%>>
		<td class="text-center"><%=listData[i].get("t_num")+""%></td>
		<td class="">[ <%=tCate%> ]</td>
		
<%if("BLOCK_ALL".equals(listData[i].get("t_state")+"") || "BLOCK_LOGIN".equals(listData[i].get("t_state")+"")){ %>
<% if(userObj != null && "ADMIN".equals(userObj.getState())) { %>
		<td class="text-muted">
			<a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/View/<%=listData[i].get("t_num")+""%>">관리자에 의해 차단된 게시물입니다.</a><% if(replys != null && !"".equals(replys) && !"0".equals(replys)){ %> [<%=replys %>]<% } %>
		</td>
<% } else { %>
		<td class="text-muted">
			관리자에 의해 차단된 게시물입니다.
		</td>
<% } %>
<% } else { %>
		<td class="">
			<a href="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/View/<%=listData[i].get("t_num")+""%>"><%=tTitle%></a><% if(replys != null && !"".equals(replys) && !"0".equals(replys)){ %> [<%=replys %>]<% } %>
		</td>
<% } %>
		<td class="text-center"><%=listData[i].get("nicname")+""%></td>
		<td class="text-center"><%=frmt.format(t_date)%></td>
		<td class="text-center"><%=listData[i].get("t_hit")+""%></td>
	</tr>
<% } %>
</tbody>
</table>
</div>

<form name="pageFrm">

<div class="row">
<div class="col-md-3"></div>
<div class="col-md-6 my-column-unit">
	<div class="col-xs-1"></div>
	<div class="col-xs-3 my-column-unit">
		<select class="form-control" name="schOpt">
			<option value="t_title" <%if("t_title".equals(schOpt)){ out.print("selected='selected'");} %>>제목</option>
			<option value="t_text" <%if("t_text".equals(schOpt)){ out.print("selected='selected'");} %>>내용</option>
		</select>
	</div>
	<div class="col-xs-5 my-column-unit">
		<input id="schTxt" name="schTxt" type="text" class="form-control" value="<%=schTxt%>">
	</div>
	<div class="col-xs-2 my-column-unit">
		<button type="button" class="btn btn-default btn-block" onclick="search();">검색</button>
	</div>
	<div class="col-xs-1"></div>
</div>
<div class="col-md-3"></div>
</div>

<div class="row">
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
<input type="hidden" name="pageNum" id="pageNum" value="<%=pageNum+""%>"/>
<input type="hidden" name="cate" id="cate" value="<%=cate%>"/>
</div>
</form>
