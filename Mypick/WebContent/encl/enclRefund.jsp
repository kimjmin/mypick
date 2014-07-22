<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.ctrl.Article"%>
<div class="container">
<% 
Article arc = new Article(); 
out.print(arc.getArticle("REFUND"));
%>
</div>