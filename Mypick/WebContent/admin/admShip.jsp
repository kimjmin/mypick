<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mpick.com.MpickParam"%>
<link rel="stylesheet" href="<%=MpickParam.getHostUrl()%>/css/jquery.fileupload.css">
<link rel="stylesheet" href="<%=MpickParam.getHostUrl()%>/css/jquery.fileupload-ui.css">
<!-- CSS adjustments for browsers with JavaScript disabled -->
<noscript>
	<link rel="stylesheet" href="<%=MpickParam.getHostUrl()%>/css/jquery.fileupload-noscript.css">
</noscript>
<noscript>
	<link rel="stylesheet" href="<%=MpickParam.getHostUrl()%>/css/jquery.fileupload-ui-noscript.css">
</noscript>

<ul class="list-unstyled">
	<li>파일명은 반드시 영문으로, .xlsx 형식으로 저장하십시오.</li>
	<li>각 Sheet 별로 하나의 배송대행지 정보를 입력하십시오.</li>
	<li>2열에는 업체 id, 업체명, 업체URL, 요율단위, 환율단위가 차례대로 들어갑니다.</li>
	<ul>
		<li>업체 id 는 <span class="text-primary">10자 내의 알파벳 소문자</span>로 입력하십시오.</li>
		<li>요율 단위는 : <code>lb</code>, <code>kg</code>, <code>g</code>, <code>oz</code> 중 하나만, 소문자 알파벳으로만 입력하십시오.</li>
		<li>환율 단위는 : <code>USD</code>, <code>JPY</code>, <code>KRW</code> 과 같이 3자리 알파벳 대문자로 입력하십시오.</li>
	</ul>
	<li>A3 셀은 비워둡니다.</li>
	<li>B3~ 부터 3열에 요율을 입력합니다. 반드시 숫자만 입력합니다.</li>
	<li>A4~ 부터 A행에 등급명을 입력합니다. 등급명은 20자 내로 입력합니다.</li>
	<li>B4~ 부터 각 행/열 의 등급별 요율에 해당하는 금액을 숫자로만 입력합니다.</li>
	<li>자료가 끝날 때 까지 공백 행 또는 열이 있으면 안되며 합쳐진 셀 또한 있으면 안됩니다.</li>
</ul>

<div class="modal fade" id="xStatlModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <div class="modal-body">
      
<div class="progress progress-striped active">
  <div id="xlProgBar" class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100">
    <span id="xlProgTxt"></span>
  </div>
</div>

<textarea id="xlLog" class="form-control" rows="6"></textarea>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
var shNums=0;
var levNums=0;
var levObj = new Object();
function getWorbook(fileName){
	$("#xlLog").val(fileName+" 파일 읽는중\t");
	
	var param="cmd=shipXl";
	param += "&";
	param += "xlCmd=workBook";
	param += "&";
	param += "fileName="+fileName;
	$.ajax({
		type : "GET",
		data : param,
		url : hostUrl+"/Control/MpickAjax",
		dataType:"json",
		success : function(xl) {
			$("#xlLog").val($("#xlLog").val()+"- \t로딩 완료.\n전체 Sheet 수 - "+xl.sheetCnt);
			shNums = Number(xl.sheetCnt);
			getSheet(fileName, 0, 0);
		}, error:function(e){  
			$("#xlLog").append("오류 발생 :\n"+e.responseText);
			console.log(e.responseText);  
		}
	});	
}
function getSheet(fileName, shCnt, levCnt){
	$("#xlLog").val($("#xlLog").val()+"\n\n\tSheet "+(shCnt+1)+": 입력 시작.");
	var param="cmd=shipXl";
	param += "&";
	param += "xlCmd=insShip";
	param += "&";
	param += "fileName="+fileName;
	param += "&";
	param += "shipNum="+shCnt;
	$.ajax({
		type : "GET",
		data : param,
		url : hostUrl+"/Control/MpickAjax",
		dataType:"json",
		success : function(xl) {
			levObj = xl;
			levNums = xl.levs;
			$("#xlLog").val($("#xlLog").val()+"\n\t\t업체명 - "+xl.shipName+"\t/\t전체 등급 수 - "+levNums);
			getRow(fileName, shCnt, levCnt);
		}, error:function(e){  
			$("#xlLog").append("오류 발생 :\n"+e.responseText);
			console.log(e.responseText);  
		}
	});
}
function getRow(fileName, shCnt, levCnt){
	$("#xlLog").val($("#xlLog").val()+"\n\t\t\t"+(levCnt+1)+".\t["+levObj.levNames[levCnt]+"]");
	var param="cmd=shipXl";
	param += "&";
	param += "xlCmd=insLevs";
	param += "&";
	param += "fileName="+fileName;
	param += "&";
	param += "shipNum="+shCnt;
	param += "&";
	param += "levNum="+levCnt;
	$.ajax({
		type : "GET",
		data : param,
		url : hostUrl+"/Control/MpickAjax",
		dataType:"json",
		success : function(xl) {
			$("#xlLog").val($("#xlLog").val()+"\t-\t완료 ");
			$("#xlLog").val($("#xlLog").val()+"\t/\t등급 개수 : "+xl.valNums);
			$("#xlLog").val($("#xlLog").val()+"\t/\t입력 오류 행 : "+xl.errMsg);
			levCnt++;
			if(levCnt < levNums){
				getRow(fileName, shCnt, levCnt);
			} else {
				shCnt++;
				progress(shCnt, shNums);
				if(shCnt < shNums){
					getSheet(fileName, shCnt, 0);
				} else {
					$("#xlLog").val($("#xlLog").val()+"\n\n"+fileName+" 파일 입력 완료.");
					var selBtn = document.getElementById(fileName+"Btn");
					selBtn.removeAttribute("disabled");
				}
			}
		}, error:function(e){  
			$("#xlLog").append("오류 발생 :\n"+e.responseText);
			console.log(e.responseText);  
		}
	});
}

function insertXl(fileName){
	console.log(fileName);
	$('#xStatlModal').modal();
	progress(0, 1);
	getWorbook(fileName);
}
function progress(don,tot){
	var donPer = 0;
	if(tot > 0){
		donPer = (don / tot) * 100;
	}
	$("#xlProgBar").attr("style","width: "+donPer+"%");
	$("#xlProgTxt").html("("+don + "/" +tot+") 완료");
}
</script>

<br/>
	<form id="fileupload" action="//jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
        <!-- Redirect browsers with JavaScript disabled to the origin page -->
        <noscript><input type="hidden" name="redirect" value="http://blueimp.github.io/jQuery-File-Upload/"></noscript>
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
        <div class="row fileupload-buttonbar">
            <div class="col-md-8">
                <!-- The fileinput-button span is used to style the file input field as button -->
                <span class="btn btn-success fileinput-button">
                    <i class="glyphicon glyphicon-plus"></i>
                    <span>파일 추가</span>
                    <input type="file" name="files[]" multiple>
                </span>
                <button type="submit" class="btn btn-primary start">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>업로드 시작</span>
                </button>
                <button type="reset" class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>업로드 취소</span>
                </button>
                <button type="button" class="btn btn-danger delete">
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
    </form>
    <br>
    
<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td>
            <span class="preview"></span>
        </td>
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
                <button class="btn btn-primary start" disabled>
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>업로드</span>
                </button>
            {% } %}
            {% if (!i) { %}
                <button class="btn btn-warning cancel">
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
            <span class="preview">
                <button class="btn btn-info start" id="{%=file.name%}Btn" onclick="insertXl('{%=file.name%}',this);">
					엑셀자료 입력
				</button>
            </span>
        </td>
        <td>
            <p class="name">
                {% if (file.url) { %}
					<a href="{%=file.url%}" title="{%=file.name%}">{%=file.name%}</a>
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
                <button class="btn btn-danger delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>
                    <i class="glyphicon glyphicon-trash"></i>
                    <span>삭제</span>
                </button>
                <input type="checkbox" name="delete" value="1" class="toggle">
            {% } else { %}
                <button class="btn btn-warning cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>취소</span>
                </button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>

<%--
<script src="<%=MpickParam.getHostUrl()%>/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="http://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Load-Image/js/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- blueimp Gallery script -->
<script src="http://blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="<%=MpickParam.getHostUrl()%>/js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="<%=MpickParam.getHostUrl()%>/js/main_ship.js"></script>
 --%>
 
<script src="/resource/fileuploader/blueimp/jquery.min.js"></script>
<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="/resource/fileuploader/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="/resource/fileuploader/blueimp/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="/resource/fileuploader/blueimp/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="/resource/fileuploader/blueimp/canvas-to-blob.min.js"></script>
<!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
<script src="/resource/fileuploader/blueimp/bootstrap.min.js"></script>
<!-- blueimp Gallery script -->
<script src="/resource/fileuploader/blueimp/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="/resource/fileuploader/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="/resource/fileuploader/js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="/resource/fileuploader/js/main.js"></script>
