<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mpick.ctrl.Article"%>
<div class="container">
<% 
Article arc = new Article(); 
out.print(arc.getArticle("ATOZ"));
%>
</div>
<h2>초보자를 위한 A to Z</h2>
<ul class="nav nav-tabs">
  <li class="active"><a href="#">카테고리 1</a></li>
  <li><a href="#">카테고리 2</a></li>
  <li><a href="#">카테고리 3</a></li>
  <li><a href="#">카테고리 4</a></li>
</ul>
<br/>
<ul class="nav nav-pills">
  <li><a href="#">카테고리 1-1</a></li>
  <li><a href="#">카테고리 1-2</a></li>
  <li class="active"><a href="#">카테고리 1-3</a></li>
  <li><a href="#">카테고리 1-4</a></li>
</ul>
<br/>
<div class="btn-group">
  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      카테고리 1-3-1
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#">제목 1-3-1-1</a></li>
      <li><a href="#">제목 1-3-1-2</a></li>
    </ul>
  </div>
  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      카테고리 1-3-2
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#">제목 1-3-2-1</a></li>
      <li><a href="#">제목 1-3-2-2</a></li>
    </ul>
  </div>
  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      카테고리 1-3-3
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#">제목 1-3-3-1</a></li>
      <li><a href="#">제목 1-3-3-2</a></li>
    </ul>
  </div>
</div>