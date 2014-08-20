<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%@page import="mpick.com.MpickUserObj"%>
<%
MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
String bbs = request.getParameter("bbs");
String tNum = request.getParameter("t_num");
MpickDao dao = MpickDao.getInstance();
DataEntity[] cates = dao.getCommCate(bbs);

String tTitle = "";
String bbsCateName = "";
String tLink = "http://";
String tState = "ALL";
String tText = "";
String tNotice = "";
if(tNum != null && !"".equals(tNum)){
	DataEntity[] tDatas = dao.getCommText(bbs,tNum);
	if(tDatas != null && tDatas.length > 0){
		DataEntity tData = tDatas[0];
		MpickUserObj writerObj = dao.getUserObj(tData.get("user_email")+"");
		if(userObj != null && userObj.getEmail().equals(writerObj.getEmail())){
			tTitle = tData.get("t_title")+"";
			bbsCateName = tData.get("bbs_cate_name")+"";
			tLink = tData.get("t_link")+"";
			tState = tData.get("t_state")+"";
			tText = tData.get("t_text")+"";
			tNotice = tData.get("t_notice")+"";
		}
	}
}
%>
<script src="<%=MpickParam.hostUrl%>/js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({
	selector: "textarea#elm",
	theme: "modern",
	width: 700,
	height: 300,
	plugins: [
		"advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
		"searchreplace visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
		"save table contextmenu directionality emoticons template paste textcolor"
	 ],
	 content_css: "css/content.css",
	 toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons", 
	 style_formats: [
		{title: 'Header 2', block: 'h2'},
		{title: 'Header 3', block: 'h3'},
		{title: 'Header 4', block: 'h4'},
		{title: 'Bold text', inline: 'b'},
		{title: 'Red text', inline: 'span', styles: {color: '#ff0000'}}
	]
});

</script>

<form class="form-horizontal" role="form" action="javascript:save();" name="commFrm">
	<div class="form-group">
		<label for="category" class="col-lg-1 control-label">분류</label>
		<div class="col-lg-3">
			<select class="form-control" id="category" name="cate">
<% for(int i=0; i < cates.length; i++){ %>
				<option value='<%=cates[i].get("bbs_cate_name")+""%>' <%if(bbsCateName.equals(cates[i].get("bbs_cate_name")+"")){ out.print("selected='selected'");} %>><%=cates[i].get("bbs_cate_name")+""%></option>
<% } %>
			</select>
		</div>
		<div class="col-lg-1"></div>
		<div class="col-lg-2 radio">
			<label>
				<input type="radio" value="ALL" name="tState" <%if(tState.equals("ALL")){ out.print("checked='checked'");} %>> 전체 조회
			</label>
		</div>
		<div class="col-lg-2 radio">
			<label>
				<input type="radio" value="LOGIN" name="tState" <%if(tState.equals("LOGIN")){ out.print("checked='checked'");} %>> 로그인 조회
			</label>
		</div>
		<div class="col-lg-2 checkbox">
<% if("ADMIN".equals(userObj.getState())) { %>
			<label>
				<input type="checkbox" value="TRUE" name="tNotice" <%if(tNotice.equals("TRUE")){ out.print("checked='checked'");} %>> 공지사항
			</label>	
<% } %>
		</div>
	</div>
	<div class="form-group">
		<label for="tTitle" class="col-lg-1 control-label">제목</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tTitle" name="tTitle" required="required" value="<%=tTitle%>">
		</div>
		<div class="col-lg-1"></div>
	</div>
	<div class="form-group">
		<label for="tLink" class="col-lg-1 control-label">링크</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tLink" name="tLink" value="<%=tLink%>">
		</div>
		<div class="col-lg-1"></div>
	</div>
	<div class="form-group">
		<label for="elm" class="col-lg-1 control-label">내용</label>
		<div class="col-lg-10">
			<textarea id="elm" name="tText"><%=tText%></textarea>
		</div>
	</div>

	<ul class="pager">
		<li><button type="button" class="btn btn-warning btn-sm" onclick="if(confirm('작성을 취소하시겠습니까?')){window.history.back();}"><span class="glyphicon glyphicon-remove"></span> 취소 </button></li>
		<li><button id="saveBtn" type="submit" class="btn btn-success btn-sm"><span class="glyphicon glyphicon-save"></span> 저장 </button></li>
	</ul>
	
	<input type="hidden" name="menu" value="<%=bbs%>" />
<%if(tNum != null && !"".equals(tNum)){ %>	<input type="hidden" name="tNum" value="<%=tNum%>" /><% } %>
	<input type="hidden" name="cmd" value="saveCommTxt" />
	<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>" />
</form>

<script>
function save(){
	$("#saveBtn").attr("disabled",true);
	var frm = document.commFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
	frm.submit();
}
</script>