<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam,mpick.com.MpickMsg"%>
<%@page import="mpick.com.MpickUserObj"%>
<%@page import="java.text.SimpleDateFormat,java.util.Date,java.util.Locale"%>
<%

MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
String bbs = request.getParameter("bbs");
String tNum = request.getParameter("t_num");
MpickDao dao = MpickDao.getInstance();
dao.plusCommHit(tNum);
DataEntity[] tDatas = dao.getCommText(bbs,tNum);
int admMenuCnt = dao.getCommMenuAdminBbs(bbs);
if(tDatas != null && tDatas.length > 0){
	DataEntity tData = tDatas[0];
	MpickUserObj writerObj = dao.getUserObj(tData.get("user_email")+"");
	Date t_date = (Date)tData.get("t_date");
	SimpleDateFormat frmt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.KOREA);
	String tText = tData.get("t_text")+"";
	tText = tText.replaceAll("<img ", "<img class=\"img-responsive\" ");
	String tLink = tData.get("t_link")+"";
	tLink = tLink.replaceAll("http://", "");
	
	DataEntity[] msgData = dao.getMenuMsg("Comm",bbs,"TRUE");
%>
<script>
function reply(rnum1, rnum2, tText){
	var txtArea = document.getElementById(tText);
	if(txtArea.value == ""){
		alert("댓글 내용을 입력하십시오.");
		txtArea.focus();
		return;
	} else {
		$(".btn-reply").attr("disabled",true);
		var frm = document.commFrm;
		frm.rNum.value = rnum1;
		frm.rNum2.value = rnum2;
		frm.tText.value = txtArea.value;
		
		frm.method="POST";
		frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
		frm.submit();
	}
}

function rreply(rnum1,rDiv){
	var inHtml = "";
	inHtml += "<div class='col-md-10'>";
	inHtml += "<textarea id='t_"+rDiv+"' class='form-control form-reply' rows='2'></textarea>";
	inHtml += "</div>";
	inHtml += "<div class='col-md-2'>";
	inHtml += "<button id=\"r_"+rDiv+"Btn\" type=\"button\" class=\"btn btn-primary btn-sm btn-block btn-reply\" onclick=\"reply('"+rnum1+"','','t_"+rDiv+"');\">댓글 달기</button>";
	inHtml += "<button id=\"c_"+rDiv+"Btn\" type=\"button\" class=\"btn btn-danger btn-sm btn-block btn-reply\" onclick=\"rCancel('"+rDiv+"');\">취소</button>";
	inHtml += "</div>";
	$("#"+rDiv).html(inHtml);
}
function rCancel(rDiv){
	$("#"+rDiv).html("");
}
function rDelete(rnum1,rnum2){
	if(confirm("댓글을 삭제하시겠습니까?")){
		$(".btn-reply").attr("disabled",true);
		var frm = document.commFrm;
		frm.rNum.value = rnum1;
		frm.rNum2.value = rnum2;
		frm.cmd.value = "deleteCommReply";
		
		frm.method="POST";
		frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
		frm.submit();
	}
}
var tempTxt;
function rModify(rnum1,rnum2,rDiv){
	var inTxt = $("#"+rDiv).html();
	tempTxt = inTxt;
	inTxt = replaceAll(inTxt,"<br>","\r\n");
	inTxt = replaceAll(inTxt,"<br/>","\r\n");
	var inHtml = "";
	inHtml += "<div class='col-md-10'>";
	inHtml += "<textarea id='t_"+rDiv+"' class='form-control form-reply' rows='2'>";
	inHtml += inTxt;
	inHtml += "</textarea>";
	inHtml += "</div>";
	inHtml += "<div class='col-md-2'>";
	inHtml += "<button id=\"r_"+rDiv+"Btn\" type=\"button\" class=\"btn btn-success btn-sm btn-block btn-reply\" onclick=\"reply('"+rnum1+"','"+rnum2+"','t_"+rDiv+"');\">댓글 수정</button>";
	inHtml += "<button id=\"c_"+rDiv+"Btn\" type=\"button\" class=\"btn btn-danger btn-sm btn-block btn-reply\" onclick=\"rmCancel('"+rDiv+"');\">취소</button>";
	inHtml += "</div>";
	$("#"+rDiv).html(inHtml);
}
function rmCancel(rDiv){
	$("#"+rDiv).html(tempTxt);
}

<% if(userObj != null && userObj.getEmail().equals(writerObj.getEmail())){ %>
function delTxt(){
	if(confirm("이 글을 삭제하시겠습니까?")){
		$(".btn-reply").attr("disabled",true);
		var frm = document.commFrm;
		frm.cmd.value = "deleteCommTxt";
		frm.toUrl.value="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
		frm.method="POST";
		frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
		frm.submit();
	}
}

function goModify(){
	var frm = document.commFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>/Write/<%=tNum%>";
	frm.submit();
}
<% } %>
function goList(){
	var frm = document.commFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>";
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

<form role="form" name="commFrm">
<table class="table table-noline" id="bbs">
<thead>
	<tr class="info">
		<th ><%=writerObj.getNicname()%> 님</th>
		<th class="text-right" width="35%"><%=frmt.format(t_date)%></th>
		<th class="text-center" width="10%">hit : <%=tData.get("t_hit")+""%></th>
	</tr>
<% if(!"".equals(tLink)){ %>
	<tr>
		<td colspan="3"><a href="http://<%=tLink%>" target="_new">http://<%=tLink%></a></td>
	</tr>
<% } %>	
	<tr>
		<td colspan="3">
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
	<tr>
		<td colspan="3">
		
<%if(userObj != null && !"".equals(userObj.getEmail()) && admMenuCnt == 0){ %>
<label for="t_reply" class="col-lg-2 control-label"><%=userObj.getNicname()%> 님</label>
<div class="col-md-8">
	<textarea id="tReply" class="form-control form-reply" rows="2"></textarea>
</div>
<div class="col-md-2">
	<button id="replyBtn" type="button" class="btn btn-primary btn-block btn-reply" onclick="reply('','','tReply');">댓글 달기</button>
</div>
<% } %>

		</td>
	</tr>
<%
DataEntity[] rDatas = dao.getCommReplys(tNum, null, "0");
if(rDatas != null && rDatas.length > 0){
	
	for(int r=0; r < rDatas.length; r++){
		Date r_date = (Date)rDatas[r].get("t_date");
		
		String rText = rDatas[r].get("t_text")+"";
		rText = rText.replaceAll("<", "&lt");
		rText = rText.replaceAll(">", "&gt");
		rText = rText.replaceAll("\r\n", "<br/>");
		
		String rEmail = rDatas[r].get("email")+""; 
%>
	<tr>
		<td colspan="3">
		
<table class="table table-condensed table-reply table-noline">
	<thead>
		<tr class="active">
			<th colspan="2"><%=rDatas[r].get("nicname")+""%> 님 (<%=frmt.format(r_date)%>)</th>
			<th class="text-right" width="35%">
<%if(userObj != null && !"".equals(userObj.getEmail())){ %>
				<button type="button" class="btn btn-primary btn-xs btn-reply" onclick="rreply('<%=rDatas[r].get("t_rep_num")+""%>','rr_<%=rDatas[r].get("t_rep_num")+"_"+rDatas[r].get("t_rep2_num")%>');">댓글 달기</button>
<% 	if(rEmail.equals(userObj.getEmail())){ %>
				<button type="button" class="btn btn-success btn-xs btn-reply" onclick="rModify('<%=rDatas[r].get("t_rep_num")+""%>','<%=rDatas[r].get("t_rep2_num")+""%>','r_<%=rDatas[r].get("t_rep_num")+"_"+rDatas[r].get("t_rep2_num")%>');">수정</button>
				 <button type="button" class="btn btn-danger btn-xs btn-reply" onclick="rDelete('<%=rDatas[r].get("t_rep_num")+""%>','<%=rDatas[r].get("t_rep2_num")+""%>');">삭제</button>
<% 	} %>
<% } %>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="3" id="r_<%=rDatas[r].get("t_rep_num")+"_"+rDatas[r].get("t_rep2_num")%>"><%=rText%></td>
		</tr>
		<tr>
			<td width="20px"></td>
			<td colspan="2" id="rr_<%=rDatas[r].get("t_rep_num")+"_"+rDatas[r].get("t_rep2_num")%>"></td>
		</tr>
		<tr>
			<td width="20px"></td>
			<td colspan="2">
<%
DataEntity[] rrDatas = dao.getCommReplys(tNum, rDatas[r].get("t_rep_num")+"");
if(rrDatas != null && rrDatas.length > 1){
	for(int rr=1; rr < rrDatas.length; rr++){
		Date rr_date = (Date)rrDatas[rr].get("t_date");
		String rrText = rrDatas[rr].get("t_text")+"";
		rrText = rrText.replaceAll("<", "&lt");
		rrText = rrText.replaceAll(">", "&gt");
		rrText = rrText.replaceAll("\r\n", "<br/>");
		String rrEmail = rrDatas[rr].get("email")+"";
%>
<table class="table table-condensed table-reply table-noline">
	<thead>
		<tr class="active">
			<th><%=rrDatas[rr].get("nicname")+""%> 님 (<%=frmt.format(rr_date)%>)</th>
			<th class="text-right" width="40%">
<% if(userObj != null && rrEmail.equals(userObj.getEmail())){ %>
				<button type="button" class="btn btn-success btn-xs btn-reply" onclick="rModify('<%=rrDatas[rr].get("t_rep_num")+""%>','<%=rrDatas[rr].get("t_rep2_num")+""%>','r_<%=rrDatas[rr].get("t_rep_num")+"_"+rrDatas[rr].get("t_rep2_num")%>');">수정</button>
				 <button type="button" class="btn btn-danger btn-xs btn-reply" onclick="rDelete('<%=rrDatas[rr].get("t_rep_num")+""%>','<%=rrDatas[rr].get("t_rep2_num")+""%>');">삭제</button>
<% } %>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="3" id="r_<%=rrDatas[rr].get("t_rep_num")+"_"+rrDatas[rr].get("t_rep2_num")%>"><%=rrText%></td>
		</tr>
	</tbody>
</table>	
<%
	}
}
%>
			</td>
		</tr>
	</tbody>
</table>
		
		</td>
	</tr>
<%
	} 
}
%>
	
	</tbody>
</table>

<div class="col-md-8">
	<button class="btn btn-sm btn-default" onclick="goList();"><span class="glyphicon glyphicon-align-justify"></span> 목록</button>
</div>
<div class="col-md-4 text-right">
<% if(userObj != null && userObj.getEmail().equals(writerObj.getEmail())){ %>
	<button class="btn btn-sm btn-success" onclick="goModify();"><span class="glyphicon glyphicon-pencil"></span> 수정</button>
	<button class="btn btn-sm btn-danger" onclick="delTxt();"><span class="glyphicon glyphicon-remove"></span> 삭제</button>
<% } %>
</div>


	<input type="hidden" name="menu" value="<%=bbs%>" />
<%if(tNum != null && !"".equals(tNum)){ %>	<input type="hidden" name="tNum" value="<%=tNum%>" /><% } %>
	<input type="hidden" name="cmd" value="saveCommReply" />
	<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>" />
	<input type="hidden" id="rNum" name="rNum"/>
	<input type="hidden" id="rNum2" name="rNum2"/>
	<input type="hidden" id="tText" name="tText"/>
</form>

<%
} else {
	out.print(MpickMsg.error("존재하지 않는 글입니다."));
}
%>