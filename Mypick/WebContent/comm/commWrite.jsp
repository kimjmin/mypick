<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.com.MpickParam"%>
<%@page import="mpick.com.MpickUserObj,mpick.com.MpickIO"%>
<%
MpickUserObj userObj = (MpickUserObj) session.getAttribute("mpUserObj");
String bbs = request.getParameter("bbs");
String tNum = request.getParameter("t_num");
MpickDao dao = MpickDao.getInstance();
DataEntity[] cates = dao.getCommCate(bbs);

String commWriter = userObj.getEmail().replaceAll("@", "_");
session.setAttribute("commUri",request.getRequestURI());
session.setAttribute("commWriter",commWriter);
MpickIO mio = MpickIO.getInstance();
// 임시파일 삭제
mio.deleteFile("commPath",commWriter+"/temp");

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

<link rel="stylesheet" href="<%=MpickParam.hostUrl%>/css/jquery.fileupload.css">
<link rel="stylesheet" href="<%=MpickParam.hostUrl%>/css/jquery.fileupload-ui.css">
<!-- CSS adjustments for browsers with JavaScript disabled -->
<noscript>
	<link rel="stylesheet" href="<%=MpickParam.hostUrl%>/css/jquery.fileupload-noscript.css">
</noscript>
<noscript>
	<link rel="stylesheet" href="<%=MpickParam.hostUrl%>/css/jquery.fileupload-ui-noscript.css">
</noscript>

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
<form class="form-horizontal" role="form">
	<div class="form-group">
		<label for="category" class="col-lg-1 control-label">분류</label>
		<div class="col-lg-3">
			<select class="form-control" id="cateFrm">
<% for(int i=0; i < cates.length; i++){ %>
				<option value='<%=cates[i].get("bbs_cate_name")+""%>' <%if(bbsCateName.equals(cates[i].get("bbs_cate_name")+"")){ out.print("selected='selected'");} %>><%=cates[i].get("bbs_cate_name")+""%></option>
<% } %>
			</select>
		</div>
		<div class="col-lg-1"></div>
		<div class="col-lg-2 radio">
			<label>
				<input type="radio" value="ALL" name="tStateFrm" <%if(tState.equals("ALL")){ out.print("checked='checked'");} %>> 전체 조회
			</label>
		</div>
		<div class="col-lg-2 radio">
			<label>
				<input type="radio" value="LOGIN" name="tStateFrm" <%if(tState.equals("LOGIN")){ out.print("checked='checked'");} %>> 로그인 조회
			</label>
		</div>
		<div class="col-lg-2 checkbox">
<% if("ADMIN".equals(userObj.getState())) { %>
			<label>
				<input type="checkbox" value="TRUE" id="tNoticeFrm" <%if(tNotice.equals("TRUE")){ out.print("checked='checked'");} %>> 공지사항
			</label>	
<% } %>
		</div>
	</div>
</form>
<form class="form-horizontal" role="form">
	<div class="form-group">
		<label for="tTitleFrm" class="col-lg-1 control-label">제목</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tTitleFrm" value="<%=tTitle%>">
		</div>
		<div class="col-lg-1"></div>
	</div>
</form>
<form class="form-horizontal" role="form">
	<div class="form-group">
		<label for="tLinkFrm" class="col-lg-1 control-label">링크</label>
		<div class="col-lg-10">
			<input type="text" class="form-control" id="tLinkFrm" value="<%=tLink%>">
		</div>
		<div class="col-lg-1"></div>
	</div>
</form>

<form class="form-horizontal" role="form" id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
	<div class="form-group">
		<label for="" class="col-lg-1 control-label">파일</label>
		<div class="col-lg-10">

<!-- 파일 업로드 시작 -->
        <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="row fileupload-buttonbar">
            <div class="col-md-8">
                <!-- The fileinput-button span is used to style the file input field as button -->
                <span class="btn btn-sm btn-success fileinput-button">
                    <i class="glyphicon glyphicon-plus"></i>
                    <span>파일 추가</span>
                    <input type="file" name="files[]" multiple>
                </span>
                <button type="submit" class="btn btn-sm btn-primary start">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>업로드 시작</span>
                </button>
                <button type="reset" class="btn btn-sm btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>업로드 취소</span>
                </button>
                <button type="button" class="btn btn-sm btn-danger delete">
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>삭제</span>
                </button>
                <input type="checkbox" class="toggle">
                <!-- The global file processing state -->
                <span class="fileupload-process"></span>
            </div>
            <!-- The global progress state -->
            <div class="col-md-4 fileupload-progress fade">
                <!-- The global progress bar -->
                <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
                    <div class="progress-bar progress-bar-success" style="width:0%;"></div>
                </div>
                <!-- The extended global progress state -->
                <div class="progress-extended">&nbsp;</div>
            </div>
        </div>
        <!-- The table listing the files available for upload/download -->
        <table role="presentation" class="table table-striped"><tbody class="files"></tbody></table>

<!-- 파일 업로드 끝 -->

		</div>
		<div class="col-lg-1"></div>
	</div>
</form>
<form class="form-horizontal" role="form">
	<div class="form-group">
		<label for="elm" class="col-lg-1 control-label">내용</label>
		<div class="col-lg-10">
			<textarea id="elm"><%=tText%></textarea>
		</div>
	</div>
</form>
<form role="form" action="javascript:save();" name="commFrm">
	<ul class="pager">
		<li><button type="button" class="btn btn-warning btn-sm" onclick="if(confirm('작성을 취소하시겠습니까?')){window.history.back();}"><span class="glyphicon glyphicon-remove"></span> 취소 </button></li>
		<li><button id="saveBtn" type="submit" class="btn btn-success btn-sm"><span class="glyphicon glyphicon-save"></span> 저장 </button></li>
	</ul>
	
	<input type="hidden" name="cate" id="cate"/>
	<input type="hidden" name="tState" id="tState"/>
	<input type="hidden" name="tNotice" id="tNotice"/>
	<input type="hidden" name="tTitle" id="tTitle"/>
	<input type="hidden" name="tLink" id="tLink"/>
	<input type="hidden" name="tText" id="tText"/>
	
	<input type="hidden" name="menu" value="<%=bbs%>" />
<%if(tNum != null && !"".equals(tNum)){ %>	<input type="hidden" name="tNum" value="<%=tNum%>" /><% } %>
	<input type="hidden" name="cmd" value="saveCommTxt" />
	<input type="hidden" name="toUrl" value="<%=MpickParam.hostUrl%>/Comm/<%=bbs%>" />
</form>

<script>
function save(){
	if($("#tTitleFrm").val() == ""){
		alert("제목을 입력하십시오.");
		$("#tTitleFrm").focus();
		return;
	} else {
		$("#cate").val($("#cateFrm").val());
		$("#tState").val($(":radio[name='tStateFrm']:checked").val());
		$("#tNotice").val($("#tNoticeFrm:checked").val());
		$("#tTitle").val($("#tTitleFrm").val());
		$("#tLink").val($("#tLinkFrm").val());
		$("#tText").val(tinymce.get('elm').getContent());
		
		$("#saveBtn").attr("disabled",true);
		var frm = document.commFrm;
		frm.method="POST";
		frm.action="<%=MpickParam.hostUrl%>/Control/Confirm";
		frm.submit();
	}
}
</script>


<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <p class="name">{%=file.name%}</p>
            <strong class="error text-danger"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
            <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0"><div class="progress-bar progress-bar-success" style="width:0%;"></div></div>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="btn btn-sm btn-primary start" disabled>
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>업로드</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-sm btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>취소</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <p class="name">
                {% if (file.url) { %}
					{%=file.url%}
                {% } else { %}
                    <span>{%=file.name%}</span>
                {% } %}
            </p>
            {% if (file.error) { %}
                <div><span class="label label-danger">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
            {% if (file.deleteUrl) { %}
                <button class="btn btn-sm btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>삭제</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } else { %}
                <button class="btn btn-sm btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>취소</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<script src="<%=MpickParam.hostUrl%>/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="http://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Load-Image/js/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- blueimp Gallery script -->
<script src="http://blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="<%=MpickParam.hostUrl%>/js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="<%=MpickParam.hostUrl%>/js/main_comm.js"></script>
	