<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
<script>
var selData;

$(document).ready(function(){
	var paramCurr="cmd=currInfo";
	$.ajax({
		type : "GET",
		data : paramCurr,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataCurr) {
			selData = dataCurr;
			$("#addShipBtn").removeAttr("disabled");
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
	
	var paramShip="cmd=shipInfo";
	$.ajax({
		type : "GET",
		data : paramShip,
		url : "../Control/MpickAjax",
		dataType:"json",
		success : function(dataShip) {
			for(var sh=0; sh < dataShip.ship_info.length; sh++){
				$("#shipName").val(dataShip.ship_info[sh].ship_name);
				$("#shipUrl").val(dataShip.ship_info[sh].ship_url);
				$("#shipVals").val(dataShip.ship_info[sh].ship_levs.length);
				addShipItem(dataShip.ship_info[sh].ship_id);
				
				var lvNames = document.getElementsByName("lvName_"+dataShip.ship_info[sh].ship_id);
				var lvVals = document.getElementsByName("lvVal_"+dataShip.ship_info[sh].ship_id);
				for(var vl=0; vl < dataShip.ship_info[sh].ship_levs.length; vl++){
					lvNames[vl].value = dataShip.ship_info[sh].ship_levs[vl].lev_name;
					lvVals[vl].value = dataShip.ship_info[sh].ship_levs[vl].lev_val;
					$(".lvSel_"+dataShip.ship_info[sh].ship_id).eq(vl).val(dataShip.ship_info[sh].ship_levs[vl].lev_unit).attr("selected", "selected");
				}
			}
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});	
});

/**
 * 배송대행지 업체item 추가.
 */
function addShipItem(){
	var shipItemNames = document.getElementsByName("shipItemName");
	for(var sn=0; sn < shipItemNames.length; sn++){
		if(shipItemNames[sn].value === $("#shipName").val()){
			alert("같은 이름의 업체가 존재합니다.");
			return;
		}
	}
	
	//ID 생성 - 랜덤한 8자리 숫자.
	var shipItemId = "";
	if(arguments.length > 0){
		shipItemId = arguments[0];
	} else {
		shipItemId = Math.round(Math.random() * 100000000);
	}
	console.log("shipItemId: "+shipItemId);
	
	var newShip = "";
	newShip += "<tr id='tr_"+shipItemId+"'>";
	
	newShip += "<td>";
	newShip += "<p class='shipLevDelBtn'><button type='button' class='btn btn-danger shipItemRemove' onclick='javascript:shipRemove(\""+shipItemId+"\");'>삭제</button></p>";
	newShip += "</td>";
	
	newShip += "<td>";
	newShip += "<p><input type='text' id='shipName_"+shipItemId+"' name='shipItemName' class='form-control' required='required' value='"+$("#shipName").val()+"' placeholder='업체명'></p>";
	newShip += "<p><input type='text' id='shipUrl_"+shipItemId+"' name='shipItemUrl' class='form-control' required='required' value='"+$("#shipUrl").val()+"' placeholder='홈페이지 URL'></p>";
	
	newShip += "<input type='hidden' name='shipItemId' value='"+shipItemId+"'>";
	newShip += "</td>";
	
	newShip += "<td>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLev lvP_"+shipItemId+"'><input type='text' name='lvName_"+shipItemId+"' class='form-control' required='required' placeholder='Level "+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='12%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevVal lvValP_"+shipItemId+"'><input type='number' name='lvVal_"+shipItemId+"' class='form-control' required='required' placeholder='"+(sl+1)+"'></p>";
	}
	newShip += "</td>";
	
	newShip += "<td width='15%'>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevValSel lvSelP_"+shipItemId+"'><select name='lvUnit_"+shipItemId+"' class='form-control levVal lvSel_"+shipItemId+"' >";
		newShip += "<option value='PERC'>%</option>";
		newShip += "<option value='KRW'>KRW</option>";
		for(var i=0; i<selData.curr_head.length; i++){
			newShip += "<option value='"+selData.curr_head[i].curr+"'>"+selData.curr_head[i].curr+"</option>";
		}
		newShip += "</select></p>";
	}
	newShip += "</td>";
	
	newShip += "<td>";
	for(var sl=0; sl< $("#shipVals").val() ; sl++){
		newShip += "<p class='shipLevDelBtn lvDelBtnP_"+shipItemId+"' ><button type='button' name='lvDelBtn_"+shipItemId+"' class='btn btn-warning lvDelBtn_"+shipItemId+"' onclick='shipLevRemove(this,\""+shipItemId+"\");'>등급 삭제</button></p>";
	}
	newShip += "<p class='lvAddBtnP_"+shipItemId+"'><button type='button' class='btn btn-success' onclick='shipLevAdd(\""+shipItemId+"\");'>등급 추가</button></p>";
	newShip += "</td>";
	
	newShip += "</tr>";
	
    $("#shipList").append(newShip);
    
    $("#shipName").val('');
    $("#shipUrl").val('http://');
    $("#shipVals").val(1);
}

/**
 * 등급 삭제
 * @param btn
 * @param btnClass
 */
function shipLevRemove(btn,btnClass){
//	console.log("btnClass : "+btnClass);
	var lvDelBtns = document.getElementsByName("lvDelBtn_"+btnClass);
	var lvDelBtnSize = lvDelBtns.length;
	if(lvDelBtnSize > 1){
		for(var lv=0; lv < lvDelBtnSize; lv++){
			if(lvDelBtns[lv] == btn){
				$(".lvP_"+btnClass).eq(lv).remove();
				$(".lvValP_"+btnClass).eq(lv).remove();
				$(".lvSelP_"+btnClass).eq(lv).remove();
				$(".lvDelBtnP_"+btnClass).eq(lv).remove();
			}
		}
	} else {
		alert("등급이 1개일 때는 삭제 할 수 없습니다.\n\n등급은 최소 1개 이상 있어야 합니다.");
	}
}

/**
 * 등급 추가
 * @param btnClass
 */
function shipLevAdd(btnClass){
	var td_1 = "<p class='shipLev lvP_"+btnClass+"'><input type='text' name='lvName_"+btnClass+"' class='form-control' required='required' placeholder='New Level'></p>";
	$("#tr_"+btnClass+" td").eq(2).append(td_1);
	
	var td_2 = "<p class='shipLevVal lvValP_"+btnClass+"'><input type='number' name='lvVal_"+btnClass+"' class='form-control' required='required' placeholder='0'></p>";
	$("#tr_"+btnClass+" td:eq(3)").append(td_2);
	
	var td_3 = "";
	td_3 += "<p class='shipLevValSel lvSelP_"+btnClass+"'><select name='lvUnit_"+btnClass+"' class='form-control levVal' >";
	td_3 += "<option value='PERC'>%</option>";
	td_3 += "<option value='KRW'>KRW</option>";
	for(var i=0; i<selData.curr_head.length; i++){
		td_3 += "<option value='"+selData.curr_head[i].curr+"'>"+selData.curr_head[i].curr+"</option>";
	}
	td_3 += "</select></p>";
	$("#tr_"+btnClass+" td:eq(4)").append(td_3);
	
	$(".lvAddBtnP_"+btnClass).remove();
	var td_4 = "<p class='shipLevDelBtn lvDelBtnP_"+btnClass+"' ><button type='button' name='lvDelBtn_"+btnClass+"' class='btn btn-warning lvDelBtn_"+btnClass+"' onclick='shipLevRemove(this,\""+btnClass+"\");'>등급 삭제</button></p>";
	td_4 += "<p class='lvAddBtnP_"+btnClass+"'><button type='button' class='btn btn-success' onclick='shipLevAdd(\""+btnClass+"\");'>등급 추가</button></p>";
	$("#tr_"+btnClass+" td:eq(5)").append(td_4);
}

function shipRemove(shipId){
	if(confirm("업체 "+$("#shipName_"+shipId).val() + " 을 삭제하시겠습니까?")){
		$("#tr_"+shipId).remove();
	}
}

/**
 * 배송대행지 저장
 */
function saveShips(){
	var frm = document.shipList;
	frm.method="POST";
	frm.action="../Control/Confirm";
	frm.submit();
}
</script>
<div class="col-md-12">

<h3>배송대행지 추가</h3>
<form action="javascript:addShipItem();">
<table class="table">
<thead>
	<tr class="center">
		<th width="30%">업체명</th>
		<th width="40%">홈페이지 URL</th>
		<th width="30%" colspan="2">등급 종류 수</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>
			<input id="shipName" type="text" class="form-control" placeholder="업체명" required="required">
		</td>
		<td>
			<input id="shipUrl" type="text" class="form-control" placeholder="URL" value="http://">
		</td>
		<td width="15%">
			<input id="shipVals" type="number" class="form-control" max="100" min="1" step="1" required="required" value="1">
		</td>
		<td width="15%">
			<button id="addShipBtn" type="submit" class="btn btn-success btn-block" disabled='disabled'>업체 추가</button>
		</td>
	</tr>
</tbody>
</table>
</form>

<form name="shipList" action="javascript:saveShips();">
<div class="row">
	<div class="col-md-9">
		<h3>배송대행지 목록</h3>
	</div>
	<div class="col-md-3">
		<button type="submit" class="btn btn-primary btn-block">배송대행지 저장</button>
	</div>
</div>

<table class="table">
<thead>
	<tr class="center">
		<th width="8%"></th>
		<th width="32%">업체명</th>
		<th width="18%">등급 종류</th>
		<th width="27%" colspan="2">할인율 / 할인금액</th>
		<th width="15%"></th>
	</tr>
</thead>
<tbody id="shipList">
	<tr class="shipItem">
	</tr>
</tbody>
</table>
<input type="hidden" name="cmd" value="saveShip" />
<input type="hidden" name="toUrl" value="../Admin/Ship" />
<div class="row">
	<div class="col-md-9">
	</div>
	<div class="col-md-3">
		<button type="submit" class="btn btn-primary btn-block">배송대행지 저장</button>
	</div>
</div>
</form>

</div>
--%>

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
	