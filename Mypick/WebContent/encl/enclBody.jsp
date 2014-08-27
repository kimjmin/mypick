<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jm.net.DataEntity,mpick.com.MpickDao,mpick.ctrl.Article,mpick.com.MpickParam"%>
<%
String selMenu = request.getParameter("menu");
String cate1 = request.getParameter("cate1");
String cate2 = request.getParameter("cate2");
String arcNum = request.getParameter("arcNum");

/*
System.out.println("selMenu: "+selMenu);
System.out.println("cate1: "+cate1);
System.out.println("cate2: "+cate2);
System.out.println("arcNum: "+arcNum);
*/
MpickDao dao = MpickDao.getInstance();
DataEntity[] cate1s = dao.getCate1(selMenu);

%>
<script>
function getArcTxt(cate2,title){
	var cates = cate2.split("|");
	var enclUrl = "";
	if(cates.length == 3){
		enclUrl = cates[0]+"/"+cates[1]+"/"+cates[2];
		if(title != ""){
			enclUrl += "/" + title;
		}
	} else if(cates.length == 2){
		enclUrl = cates[0]+"/"+cates[1];
	}
	window.location.href="<%=MpickParam.getHostUrl()%>/Encl/"+enclUrl;
}

</script>
<div class="row">
<%
String arcTxt = "";
if(cate1s == null || cate1s.length == 0){
	DataEntity[] arcCate1Data = dao.getArticle(selMenu, "", "", "");
	if(arcCate1Data != null && arcCate1Data.length == 1){
		arcTxt = (String)arcCate1Data[0].get("ar_text");
	}
} else {
%>
	<ul id="cate1Tab" class="nav nav-tabs">
<%
if("".equals(cate1)){
	if(cate1s.length > 0){
		cate1=(String)cate1s[0].get("ar_cate_name");
	}
}
int c1Cnt = 0;
for(int i=0; i<cate1s.length; i++){
	String cate1Name = (String)cate1s[i].get("ar_cate_name");
	if(cate1.equals(cate1Name)){
		c1Cnt = i;
	}
%>
		<li <%if(cate1.equals(cate1Name)){out.print("class='active'");}%>><a href='javascript:getArcTxt("<%=selMenu+"|"+cate1Name%>","");'><%=cate1Name%></a></li>
<%
}
%>
	</ul>
	<div id="cate1TabContent" class="tab-content">
<%

	String cate1Name = (String)cate1s[c1Cnt].get("ar_cate_name");	
%>
<!-- <%=cate1Name%> 탭 시작 -->
		<div class="tab-pane active in" id="cate1">
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
	if("".equals(cate2)){
		if(cate2s.length > 0){
			cate2=(String)cate2s[0].get("ar_cate_name");
		}
	}
	for(int j=0; j<cate2s.length; j++){
		String cate2Name = (String)cate2s[j].get("ar_cate_name");
		if(cate2.equals(cate2Name)){
			DataEntity[] arcCate3Data = dao.getArticle(selMenu, cate1Name, cate2Name, "");
			if(arcCate3Data != null && arcCate3Data.length == 1){
				arcTxt = (String)arcCate3Data[0].get("ar_text");
			}
		}
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
		if("".equals(arcNum)){
			if(titles.length > 0){
				arcNum = (String)titles[0].get("ar_title");
			}
		}
		for(int k=0; k<titles.length; k++){
			String title = (String)titles[k].get("ar_title");
			if(cate2.equals(cate2Name) && arcNum.equals(title)){
				DataEntity[] arcData = dao.getArticle(selMenu, cate1Name, cate2Name, title);
				if(arcData != null && arcData.length == 1){
					arcTxt = (String)arcData[0].get("ar_text");
				}
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
		</div>
<!-- <%=cate1Name%> 탭 끝 -->
	</div>
<%
}
%>
<div class="col-md-12">
	<div id="enclTxt"><%=arcTxt%></div>
</div>
</div>