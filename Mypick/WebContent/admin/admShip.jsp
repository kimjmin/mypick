<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="../css/jquery.fileupload.css">
<link rel="stylesheet" href="../css/jquery.fileupload-ui.css">
<!-- CSS adjustments for browsers with JavaScript disabled -->
<noscript>
	<link rel="stylesheet" href="../css/jquery.fileupload-noscript.css">
</noscript>
<noscript>
	<link rel="stylesheet" href="../css/jquery.fileupload-ui-noscript.css">
</noscript>

<blockquote>
  <p>파일명은 반드시 영문으로, .xlsx 형식으로 저장하십시오.<br/>
  각 Sheet 별로 하나의 배송대행지 정보를 입력하십시오.<br/>
  2열에는 업체 id, 업체명, 업체URL, 요율단위, 환율단위가 차례대로 들어갑니다.<br/>
   - 업체 id 는 10자 내의 알파벳 소문자로 입력하십시오.<br/>
   - 요율 단위는 : lb, kg, g, oz 중 하나로 입력한다. 소문자 알파벳으로만 입력하십시오.<br/>
   - 환율 단위는 : USD, JPY, KRW 과 같이 3자리 알파벳 대문자로 입력하십시오.<br/>
  A3 셀은 비워둡니다.<br/>
  B3~ 부터 3열에 요율을 입력합니다. 입력은 반드시 숫자로만 입력합니다.<br/>
  A4~ 부터 A행에 등급명을 입력합니다. 등급명은 20자 내로 입력합니다.<br/>
  B4~ 부터 각 행/열 의 등급별 요율에 해당하는 금액을 숫자로만 입력합니다.<br/>
  자료가 끝날 때 까지 공백 행 또는 열이 있으면 안됩니다.<br/>
  합쳐진 셀이 있으면 안됩니다.</p>
</blockquote>

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
                <button class="btn btn-success delete" data-type="GET" data-url="{%=file.appendUrl%}">
					적용
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
<script src="../js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="http://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Load-Image/js/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="http://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- blueimp Gallery script -->
<script src="http://blueimp.github.io/Gallery/js/jquery.blueimp-gallery.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="../js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="../js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="../js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="../js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="../js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="../js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="../js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="../js/jquery.fileupload-ui.js"></script>
<!-- The main application script -->
<script src="../js/main_ship.js"></script>
	