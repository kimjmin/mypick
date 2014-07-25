<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Article"%>
<%
String uri = request.getParameter("uri");
String selMenu = uri.substring(uri.lastIndexOf("Encl/")+5);

MpickDao dao = MpickDao.getInstance();
DataEntity[] cate1s = dao.getCate1(selMenu);
%>
<script>

function getArcTxt(cate2,title){
	var params = "";
	params += "cmd=arcText";
	params += "&arcCate2="+cate2;
	params += "&arcTitleSel="+title;
	$.ajax({
		type : "GET",
		data : params,
		url : "../Control/MpickAjax",
		dataType:"text",
		success : function(dataArcTxt) {
			$("#arcTxt").html(dataArcTxt);
		}, error:function(e){  
			console.log(e.responseText);  
		}
	});
}
</script>

<div class="container">
<div class="row">
<div class="row">
	<div class="col-md-8">
<%
if(cate1s == null || cate1s.length == 0){
	String arcTabTxt = "";
	DataEntity[] arcCate1Data = dao.getArticle(selMenu, "", "", "");
	if(arcCate1Data != null && arcCate1Data.length == 1){
		arcTabTxt = (String)arcCate1Data[0].get("ar_text");
	}
%>
		<div><%=arcTabTxt%></div>
<%	
} else {
%>
	<ul id="cate1Tab" class="nav nav-tabs">
<%
for(int i=0; i<cate1s.length; i++){
	String cate1Name = (String)cate1s[i].get("ar_cate_name");
%>
		<li <%if(i==0){out.print("class='active'");}%>><a href="#cate1_<%=i+""%>" data-toggle="tab"><%=cate1Name%></a></li>
<%
}
%>
	</ul>
	<div id="cate1TabContent" class="tab-content">
<%
for(int i=0; i<cate1s.length; i++){
	String cate1Name = (String)cate1s[i].get("ar_cate_name");	
	String arcTxt = "";
%>
<!-- <%=cate1Name%> 탭 시작 -->
		<div class="tab-pane fade <%if(i==0){out.print("active");}%> in" id="cate1_<%=i+""%>">
<%
DataEntity[] cate2s = dao.getCate2(selMenu, cate1Name);
if(cate2s == null || cate2s.length == 0){
	DataEntity[] arcCate2Data = dao.getArticle(selMenu, cate1Name, "", "");
	if(arcCate2Data != null && arcCate2Data.length == 1){
		arcTxt = (String)arcCate2Data[0].get("ar_text");
	}
} else {
%>
<div class="btn-group">
	<%
	for(int j=0; j<cate2s.length; j++){
		String cate2Name = (String)cate2s[j].get("ar_cate_name");
	%>
<div class="btn-group">
	<%
	DataEntity[] titles = dao.getArcTitles(selMenu, cate1Name, cate2Name);
	if(titles != null && titles.length == 1 && "".equals((String)titles[0].get("ar_title"))){
	%>
	<button type="button" class="btn btn-info" onclick='getArcTxt("<%=selMenu+"|"+cate1Name+"|"+cate2Name%>","");'><%=cate2Name%></button>
	<%
	} else {
	%>
	<button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">
	<%=cate2Name%>
	</button>
	<ul class="dropdown-menu">
		<%
		for(int k=0; k<titles.length; k++){
			String title = (String)titles[k].get("ar_title");
			if(j==0 && k==0){
				DataEntity[] arcData = dao.getArticle(selMenu, cate1Name, cate2Name, title);
				arcTxt = (String)arcData[0].get("ar_text");
			}
		%>
		<li><a href='javascript:getArcTxt("<%=selMenu+"|"+cate1Name+"|"+cate2Name%>","<%=title%>");'><%=title%></a></li>
		<%
		}
		%>
	</ul>
	<%
	}
	%>
</div>
	<%
	}
	%>
</div>
<%
}
%>
<div class="row">
	<div class="col-md-8">
		<div id='arcTxt'><%=arcTxt%></div>
	</div>
</div>

		</div>
<!-- <%=cate1Name%> 탭 끝 -->
<%
}
%>
	</div>
<%
}
%>
</div>
</div>

</div>
</div>
