<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%

String bbs = request.getParameter("bbs");
MpickDao dao = MpickDao.getInstance();
DataEntity[] cates = dao.getCommCate(bbs);

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
<%
for(int i=0; i < cates.length; i++){
%>
				<option value="<%=cates[i].get("bbs_cate_name")+""%>"><%=cates[i].get("bbs_cate_name")+""%></option>
<%
}
%>
			</select>
		</div>
		<label for="tState" class="col-lg-1 control-label">조회</label>
		<div class="col-lg-3">
			<select class="form-control" id="tState" name="tState">
				<option value="ALL" selected="selected">전체</option>
				<option value="LOGIN">로그인 사용자</option>
			</select>
		</div>
		<div class="col-lg-3"></div>
	</div>
	<div class="form-group">
		<label for="tTitle" class="col-lg-1 control-label">제목</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tTitle" name="tTitle" required="required">
		</div>
		<div class="col-lg-1"></div>
	</div>
	<div class="form-group">
		<label for="tLink" class="col-lg-1 control-label">링크</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tLink" name="tLink" value="http://">
		</div>
		<div class="col-lg-1"></div>
	</div>
	<div class="form-group">
		<label for="elm" class="col-lg-1 control-label">내용</label>
		<div class="col-lg-10">
			<textarea id="elm" name="tText"></textarea>
		</div>
	</div>

	<ul class="pager">
		<li><button type="button" class="btn btn-warning btn-sm" onclick="if(confirm('작성을 취소하시겠습니까?')){window.history.back();}"><span class="glyphicon glyphicon-remove"></span> 취소 </button></li>
		<li><button type="submit" class="btn btn-success btn-sm"><span class="glyphicon glyphicon-save"></span> 저장 </button></li>
	</ul>
	
	<input type="hidden" name="menu" value="<%=bbs%>" />
	<input type="hidden" name="cmd" value="saveCommTxt" />
	<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>" />
</form>

<script>
function save(){
	var frm = document.commFrm;
	frm.method="POST";
	frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
	frm.submit();
}
</script>