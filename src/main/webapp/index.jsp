<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URL" %>
<% 
    Integer id = (Integer)session.getAttribute("user_id");
    User user;
    if (id == null) {
        response.sendRedirect("./login.jsp");
        return;
    } else {
        user = Mapper.getInstance().getUser(id);
        if (user == null) {
            response.sendRedirect("./login.jsp");
            return;
        }
    }
    Integer siteId = Integer.parseInt((request.getParameter("site_id")==null)?"0":request.getParameter("site_id"));
    String type = request.getParameter("type");
    if (type == null) type = "";
    Site curSite = null;
    if (siteId != 0) {
        curSite = new Site(siteId);
        if (curSite.id == -1) curSite = null;
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
    $(this).css("background-color", "#f5f5f5");
  },function(){
    $(this).children(".icon").animate({ opacity: 0 },100);
    $(this).css("background-color", "#FFF");
  });
  $(".content .list-group-item.line .info, .content .list-group-item.line .website, .content .list-group-item.line .date").click(function(){
    $(this).parent().next().slideToggle(200, "");
    var articleId = $(this).parent().attr("articleId");
    if ($(this).parent().find(".title").hasClass("not-read")){
        $(this).parent().find(".title").removeClass("not-read");
        $.get("./action.jsp?action=read&article_id=" + articleId);
    }
  });
  $(".content .list-group-item.line .glyphicon-star-empty").click(function(){
    $(this).next().slideToggle(200, "");
    var articleId = $(this).attr("articleId");
    if ($(this).hasClass("glyphicon-star-empty")){
        $(this).removeClass("glyphicon-star-empty");
        $(this).addClass("glyphicon-star");
        $.get("./action.jsp?action=star&article_id=" + articleId);
    }
  });
})
</script>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
<a href="#" class="navbar-brand">FeedReader</a>
<div class="navbar-collapse collapse navbar-responsive-collapse">
    <ul class="nav navbar-nav pull-right">
      <li><a href="#"><span class="glyphicon glyphicon-wrench"></span>设置</a></li>
      <li><a href="logout.jsp"><span class="glyphicon glyphicon-log-out"></span>登出</a></li>
    </ul>
</nav>
  <div class="row" style="margin-top:45px">
    <div class="col-md-3" style="width:20%;">
      <div style="height:90%;width:20%;padding-top:15px; position:fixed; background-color:#f0f0f0">
        <ul class="nav nav-pills nav-stacked">
          <li class="<%=siteId==0&&!type.equals("star")?"active":""%>"><a href="./"><span class="glyphicon glyphicon-th-list"></span>全部</a></li>
          <li class="<%=type.equals("star")?"active":""%>"><a href="./?type=star"><span class="glyphicon glyphicon-inbox"></span>我的收藏</a></li>
          <%
            ArrayList<Site> sites = Mapper.getInstance().getAllSites(user);
            for (Site site : sites) {
                URL url = new URL(site.url);
                String icon = url.getProtocol() + "://" + url.getHost() + "/favicon.ico";
          %>
            <li class="<%=siteId==site.id?"active":""%>"><a href="./?site_id=<%=site.id%>"><img style="margin-right:10px;height:15px" src="<%=icon%>"></img><%=site.title%></a></li>
          <%
            }
          %>
        </ul>
      </div>
      <div style="top:90%;height:10%;width:20%;padding-top:15px; padding-left:20px; position:fixed; background-color:#f0f0f0;border-top: solid 1px #ccc">
        <ul class="nav nav-pills nav-stacked">
          <li>
            <form method="GET" action="subscribe.jsp">
                <a onclick="$(this).hide(); $('#input_url').show();"><span class="glyphicon glyphicon-plus"></span>添加订阅</a>
                <input type="text" name="url" style="display:none; width: 80%" id="input_url" placeholder="Please input rss url"/>
            </form>
        </li>
        </ul>
      </div>
    </div>
    <div class="col-md-9" style="width:80%;padding-left:10px;">
    <%@ include file="flash.jsp" %>
      <div style="margin-left:20px">
        <h2><%=(curSite==null)?(type.equals("star")?"我的收藏":"全部"):curSite.title%></h2>
      <div class="list-group content">
      <%
        ArrayList<Article> readedArticles = Mapper.getInstance().getActedArticles(user, "read");
        ArrayList<Article> staredArticles = Mapper.getInstance().getActedArticles(user, "star");
        ArrayList<Article> articles = siteId == 0 ? (type.equals("star") ? Mapper.getInstance().getActedArticles(user, "star") : Mapper.getInstance().getAllArticles(user)) : Mapper.getInstance().getAllArticles(siteId);
            DateFormat sdf = new SimpleDateFormat("MMM dd");
            DateFormat sdf2 = new SimpleDateFormat("HH:mm");
            String today = sdf.format(new Timestamp((new Date()).getTime()));
        for (Article article : articles) {
            String name = "";
            String notRead = "not-read";
            String star = "-empty";
            for (Site site : sites) {
                if (site.id == article.siteId) name = site.title;
            }
            for (Article sa : staredArticles) {
                if (sa.id.equals(article.id)) {
                    star = "";
                }
            }
            for (Article ra : readedArticles) {
                if (ra.id.equals(article.id)) {
                    notRead = "";
                }
            }
      %>
        <div class="row list-group-item line" articleId="<%=article.id%>">
          <div class="icon" style="opacity:0">
            <a href="javascript:void(0)"><span class="glyphicon glyphicon-star<%=star%>" articleId="<%=article.id%>"></span></a>
          </div>
          <div class="website"><%=name%></div>
          <div class="info">
          <span class="title <%=notRead%>"><%=article.title%></span>
          <!--<span class="preview">這個是學習編程時的…</span>-->
          </div>
          <div class="date"><%=sdf.format(article.publishedDate).equals(today) ? sdf2.format(article.publishedDate) : today%></div>
        </div>
        <div class="list-group-item" style="display:none">
          <div class="post-content">
          <div class="info">
            <h3 class="title <%=notRead%>"><%=article.title%></h3>
          <span class="title <%=notRead%>"><%=name%></span> ·
          <span class="date"><%=sdf.format(article.publishedDate).equals(today) ? sdf2.format(article.publishedDate) : today%></span>
          </div>
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

