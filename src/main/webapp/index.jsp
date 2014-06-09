<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    if (request.getParameter("url") != null) {
        Mapper.getInstance().insertSite(request.getParameter("url"));
        response.sendRedirect("./index.jsp");
    }
%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script>
$(function(){
  $(".content .list-group-item.line").hover(function(){
    $(this).children(".icon").animate({ opacity: 1 },100);
  },function(){
    $(this).children(".icon").animate({ opacity: 0 },100);
  });
  $(".content .list-group-item.line").click(function(){
    $(this).next().slideToggle(200, "");
  });
})
</script>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
<a href="#" class="navbar-brand">FeedReader</a>
<div class="navbar-collapse collapse navbar-responsive-collapse">
    <ul class="nav navbar-nav pull-right">
      <li><a href="#"><span class="glyphicon glyphicon-check"></span>全部标记为已读</a></li>
      <li><a href="#"><span class="glyphicon glyphicon-wrench"></span>设置</a></li>
      <li><a href="#"><span class="glyphicon glyphicon-log-out"></span>登出</a></li>
    </ul>
</nav>
  <div class="row" style="margin-top:45px">
    <div class="col-md-3" style="width:20%;">
      <div style="height:90%;width:20%;padding-top:15px; position:fixed; background-color:#f0f0f0">
        <ul class="nav nav-pills nav-stacked">
          <li class="active"><a><span class="glyphicon glyphicon-th-list"></span>全部</a></li>
          <li><a><span class="glyphicon glyphicon-inbox"></span>我的收藏</a></li>
          <li><a><span class="glyphicon glyphicon-user"></span>好友订阅</a></li>
          <li><a><span class="glyphicon glyphicon-fire"></span>推荐文章</a></li>
          <%
            ArrayList<Site> sites = Mapper.getInstance().getAllSites();
            for (Site site : sites) {
          %>
            <li><a><span class="glyphicon glyphicon-fire"></span><%=site.title%></a></li>
          <%
            }
          %>
          <!-- <li><a><span class="glyphicon glyphicon-tags"></span>标签一</a></li>
          <li><a><span class="glyphicon glyphicon-tags"></span>标签二</a></li>
          <li><a><span class="glyphicon glyphicon-tags"></span>标签三</a>
            <ul class="nav nav-pills nav-stacked nav2">
              <li><a>网站一</a></li>
              <li><a>网站二</a></li>
              <li><a>网站三</a></li>
            </ul>
          </li>
          <li><a><span class="glyphicon glyphicon-tags"></span>标签四</a></li> -->
        </ul>
      </div>
      <div style="top:90%;height:10%;width:20%;padding-top:15px; padding-left:20px; position:fixed; background-color:#f0f0f0;border-top: solid 1px #ccc">
        <ul class="nav nav-pills nav-stacked">
          <li>
            <form method="GET">
                <a onclick="$(this).hide(); $('#input_url').show();"><span class="glyphicon glyphicon-plus"></span>添加订阅</a>
                <input type="text" name="url" style="display:none; width: 80%" id="input_url" placeholder="Please input rss url"/>
            </form>
        </li>
        </ul>
      </div>
    </div>
    <div class="col-md-9" style="width:80%;padding-left:10px;">
      <div style="margin-left:20px">
        <h2>全部</h2>
      <div class="list-group content">
      <%
        ArrayList<Article> articles = Mapper.getInstance().getAllArticles();
            DateFormat sdf = new SimpleDateFormat("MMM dd");
        for (Article article : articles) {
            String name = "";
            for (Site site : sites) {
                if (site.id == article.siteId) name = site.title;
            }
      %>
        <a class="list-group-item line">
          <div class="icon" style="opacity:0">
            <span class="glyphicon glyphicon-star-empty"></span>
            <span class="glyphicon glyphicon-thumbs-up"></span>
          </div>
          <div class="website"><%=name%></div>
          <div class="title"><%=article.title%></div>
          <div class="preview">這個是學習編程時的…</div>
          <div class="date"><%=sdf.format(article.publishedDate)%></div>
        </a>
        <div class="list-group-item" style="display:none">
          <div class="post-content">
            <%=article.content%>
          </div>
        </div>
      <%
        }
      %>
      </div>
      </div>
</body>
</html>


