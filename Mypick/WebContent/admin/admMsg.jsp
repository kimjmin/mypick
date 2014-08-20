<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.com.MpickParam,mpick.com.MpickDao,jm.net.DataEntity"%>
<%
String msgTab = request.getParameter("msgTab");
if(msgTab == null || "".equals(msgTab)){
	msgTab = "msg";
}
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
function saveLink(){
	var frm = document.linkFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
	frm.submit();
}
</script>

<ul id="fldFmtTab" class="nav nav-tabs">
	<li <%if("msg".equals(msgTab)){out.print("class='active'");} %> ><a href="#msg" data-toggle="tab">메시지 입력</a></li>
	<li <%if("link".equals(msgTab)){out.print("class='active'");} %> ><a href="#link" data-toggle="tab">링크 입력</a></li>
</ul>
<div id="fldFmtTabContent" class="tab-content">

<!-- 메시지 입력 탭 시작 -->
<div class="tab-pane fade <%if("msg".equals(msgTab)){out.print("active");} %> in" id="msg">
<form id='msgFrm' name='msgFrm'>
<div id="mainDiv">
<br>
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
</div>
<!-- 메시지 입력 탭 끝 -->
<!-- 링크 입력 탭 시작 -->
<div class="tab-pane fade <%if("link".equals(msgTab)){out.print("active");} %> in" id="link">
<%
DataEntity[] linkData = dao.getLinks(null,null);

%>

<form id='linkFrm' name='linkFrm'>
<br>
<div class='row'>
	<div class='col-md-8'></div>
	<div class='col-md-2'>
	</div>
	<div class='col-md-2'>
		<button type="button" class="btn btn-primary btn-block" onclick="saveLink()">저장</button>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2 text-center'>
		<label>구분</label>
	</div>
	<div class='col-md-3 text-center'>
		<label>메시지명</label>
	</div>
	<div class='col-md-7 text-center'>
		<label>링크</label>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='WELCOME'/>
		<input type='hidden' name='mTitle' value='<%if(linkData.length>0){ out.print(linkData[0].get("m_title")+"");}%>'/>
		첫 화면
	</div>
	<div class='col-md-3'>
		<img class="img-responsive panel-primary" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_pen.png"/>
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>0){ out.print(linkData[0].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='WELCOME'/>
		<input type='hidden' name='mTitle' value='<%if(linkData.length>1){ out.print(linkData[1].get("m_title")+"");}%>'/>
		첫 화면
	</div>
	<div class='col-md-3'>
		<img class="img-responsive panel-success" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_listdown.png">
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>1){ out.print(linkData[1].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='WELCOME'/>
		<input type='hidden' name='mTitle' value='<%if(linkData.length>2){ out.print(linkData[2].get("m_title")+"");}%>'/>
		첫 화면
	</div>
	<div class='col-md-3'>
		<img class="img-responsive panel-danger" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_limitup.png">
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>2){ out.print(linkData[2].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='WELCOME'/>
		<input type='hidden' name='mTitle' value='<%if(linkData.length>3){ out.print(linkData[3].get("m_title")+"");}%>'/>
		첫 화면
	</div>
	<div class='col-md-3'>
		<img class="img-responsive panel-warning" src="<%=MpickParam.hostUrl%>/resource/img/bg_icon_cal.png">
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>3){ out.print(linkData[3].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='FOOTER'/>
		하단 푸터
	</div>
	<div class='col-md-3'>
		<input type='text' class='form-control' name='mTitle' required="required" value='<%if(linkData.length>4){ out.print(linkData[4].get("m_title")+"");}%>'/>
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>4){ out.print(linkData[4].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='FOOTER'/>
		하단 푸터
	</div>
	<div class='col-md-3'>
		<input type='text' class='form-control' name='mTitle' required="required" value='<%if(linkData.length>5){ out.print(linkData[5].get("m_title")+"");}%>'/>
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>5){ out.print(linkData[5].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='FOOTER'/>
		하단 푸터
	</div>
	<div class='col-md-3'>
		<input type='text' class='form-control' name='mTitle' required="required" value='<%if(linkData.length>6){ out.print(linkData[6].get("m_title")+"");}%>'/>
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>6){ out.print(linkData[6].get("m_link")+"");}%>'/>
	</div>
</div>
<br>
<div class='row'>
	<div class='col-md-2'>
		<input type='hidden' name='mType' value='FOOTER'/>
		하단 푸터
	</div>
	<div class='col-md-3'>
		<input type='text' class='form-control' name='mTitle' required="required" value='<%if(linkData.length>7){ out.print(linkData[7].get("m_title")+"");}%>'/>
	</div>
	<div class='col-md-7'>
		<input type='text' class='form-control' name='mLink' value='<%if(linkData.length>7){ out.print(linkData[7].get("m_link")+"");}%>'/>
	</div>
</div>
<input type="hidden" name="cmd" value="saveMenuLink" />
<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Admin/Msg" />
</form>
</div>
<!-- 링크 입력 탭 끝 -->

</div>