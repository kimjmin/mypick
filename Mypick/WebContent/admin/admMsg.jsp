<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam,mpick.com.MpickDao,jm.net.DataEntity"%>
<%
MpickDao dao = MpickDao.getInstance();
DataEntity[] msgData = dao.getMenuMsg(null,null,null);
int dLen = msgData.length;
%>
<script>
var rCnt = <%=dLen+""%>;
function addRow(hid,mid,mTitle,mText,mHide){
	if(typeof(hid)==="undefined") hid = "";
	if(typeof(mid)==="undefined") mid = "";
	if(typeof(mTitle)==="undefined") mTitle = "";
	if(typeof(mText)==="undefined") mText = "";
	if(typeof(mHide)==="undefined") mHide = "TRUE";
	var rowTxt = "";
	rowTxt += "<br>";
	rowTxt += "<div class='row' id='div_"+rCnt+"'>";
	rowTxt += "<div class='col-md-2'>";
	rowTxt += "<input type='text' class='form-control' name='hid' value='"+hid+"'/>";
	rowTxt += "<button type='button' class='btn btn-danger btn-block' onclick='delDiv(\"div_"+rCnt+"\")'>삭제</button>";
	rowTxt += "</div>";
	rowTxt += "<div class='col-md-2'>";
	rowTxt += "<input type='text' class='form-control' name='mid' value='"+mid+"'/>";
	rowTxt += "</div>";
	rowTxt += "<div class='col-md-3'>";
	rowTxt += "<input type='text' class='form-control' name='mTitle' value='"+mTitle+"'/>";
	rowTxt += "</div>";
	rowTxt += "<div class='col-md-4'>";
	rowTxt += "<textarea class='form-control' name='mText'>"+mText+"</textarea>";
	rowTxt += "</div>";
	rowTxt += "<div class='col-md-1 text-center'>";
	if(mHide ==="TRUE"){
		rowTxt += "<label>";
		rowTxt += "<input type='radio' name='mHide"+rCnt+"' value='TRUE' checked='checked'/> 보임";
		rowTxt += "</label>";
		rowTxt += "<label>";
		rowTxt += "<input type='radio' name='mHide"+rCnt+"' value='FALSE'/> 숨김";
		rowTxt += "</label>";
	} else {
		rowTxt += "<label>";
		rowTxt += "<input type='radio' name='mHide"+rCnt+"' value='TRUE'/> 보임";
		rowTxt += "</label>";
		rowTxt += "<label>";
		rowTxt += "<input type='radio' name='mHide"+rCnt+"' value='FALSE' checked='checked'/> 숨김";
		rowTxt += "</label>";
	}
	rowTxt += "</div>";
	rowTxt += "</div>";
	$("#mainDiv").append(rowTxt);
	rCnt++;
}
function saveMsg(){
	var frm = document.msgFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
	frm.submit();
}
function delDiv(divId){
	$("#"+divId).remove();
	rCnt--;
}
</script>
<form id='msgFrm' name='msgFrm'>
<div id="mainDiv">
<div class='row'>
	<div class='col-md-8'></div>
	<div class='col-md-2'>
		<button type="button" class="btn btn-success btn-block" onclick="addRow();">추가</button>
	</div>
	<div class='col-md-2'>
		<button type="button" class="btn btn-primary btn-block" onclick="saveMsg()">저장</button>
	</div>
</div>

<br>
<div class='row'>
	<div class='col-md-2 text-center'>
		<label>상단메뉴 id</label>
	</div>
	<div class='col-md-2 text-center'>
		<label>좌측메뉴 id</label>
	</div>
	<div class='col-md-3 text-center'>
		<label>제목</label>
	</div>
	<div class='col-md-4 text-center'>
		<label>설명</label>
	</div>
	<div class='col-md-1 text-center'>
		<label>숨김</label>
	</div>
</div>
<%for(int i=0; i< msgData.length; i++){ %>
<br>
<div class='row' id='div_<%=i+"" %>'>
	<div class='col-md-2'>
		<input type='text' class='form-control' name='hid' value='<%=msgData[i].get("m_hid")+""%>'/>
		<button type="button" class='btn btn-danger btn-block' onclick='delDiv("div_<%=i+"" %>")'>삭제</button>
	</div>
	<div class='col-md-2'>
		<input type='text' class='form-control' name='mid' value='<%=msgData[i].get("m_mid")+""%>'/>
	</div>
	<div class='col-md-3'>
		<input type='text' class='form-control' name='mTitle' value='<%=msgData[i].get("m_title")+""%>'/>
	</div>
	<div class='col-md-4'>
		<textarea class='form-control' name='mText'><%=msgData[i].get("m_text")+""%></textarea>
	</div>
	<div class='col-md-1 text-center'>
		<label>
			<input type='radio' name='mHide<%=i+"" %>' value='TRUE' <%if("TRUE".equals(msgData[i].get("m_visible")+"")){out.print("checked='checked'");} %>/> 보임
		</label>
		<label>
			<input type='radio' name='mHide<%=i+"" %>' value='FALSE' <%if("FALSE".equals(msgData[i].get("m_visible")+"")){out.print("checked='checked'");} %>/> 숨김
		</label>
	</div>
</div>
<%} %>
</div>
<input type="hidden" name="cmd" value="saveMenuMsg" />
<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Admin/Msg" />
</form>