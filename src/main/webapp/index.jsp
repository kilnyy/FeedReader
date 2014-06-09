<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.*" %>
<%@ page import="java.util.ArrayList" %>
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
      <div style="top:90%;height:10%;width:20%;padding-top:15px; position:fixed; background-color:#f0f0f0;border-top: solid 1px #ccc">
        <ul class="nav nav-pills nav-stacked">
          <li><a><span class="glyphicon glyphicon-plus"></span>添加订阅</a></li>
        </ul>
      </div>
    </div>
    <div class="col-md-9" style="width:80%;padding-left:10px;">
      <div style="margin-left:20px">
        <h2>全部</h2>
      </div>
      <div class="list-group content">
        
        <a class="list-group-item line">
          <div class="icon" style="opacity:0">
            <span class="glyphicon glyphicon-star-empty"></span>
            <span class="glyphicon glyphicon-thumbs-up"></span>
          </div>
          <div class="website">网站一</div>
          <div class="title">約瑟夫問題的O(log n)解法</div>
          <div class="preview">這個是學習編程時的…</div>
          <div class="date">5-28</div>
        </a>
        <div class="list-group-item" style="display:none">
          <div class="post-content">
            <div>
            <h3><a href="#">約瑟夫問題的O(log n)解法</a></h3>
            </div>
            <div class="entry">
                      <p>這個是學習編程時的耳熟能詳的問題了：</p>
              <p><code>n</code>個人(編號爲<code>0,1,...,n-1</code>)圍成圈子，從<code>0</code>號開始依次報數，每數到第<code>m</code>個人，這個人就得自殺，之後從下個人開始繼續報數，直到所有人都死亡爲止。問最後死的人的編號(其實看到別人都死了之後最後剩下的人可以選擇不自殺……)。</p>
              <p>這個問題一般有兩種問法：</p>
              <ul>
              <li>給出自殺順序。不少數據結構初學書都會以這個問題爲習題考驗讀者對線性表的掌握。比較常見的解法是把所有存活的人組織成循環鏈表，這樣做時間複雜度是<code>O(n*m)</code>的。另外可以使用order statistic tree(支持查詢第k小的元素以及詢問元素的排名)優化到<code>O(n log n)</code>。另外有篇1983年的論文<i>An O(n log m) Algorithm for the Josephus Problem</i>，但可惜我沒找到下載鏈接。</li>
              <li>求出最後人的編號。可以套用上一種問法的解法，但另外有更加高效的解法，下文展開討論。</li>
              </ul>
            </div>
          </div>
        </div>
          <%
            ArrayList<Article> articles = Mapper.getInstance().getAllArticles();
            for (Article article : articles) {
          %>
        <a class="list-group-item line">
          <div class="icon" style="opacity:0">
            <span class="glyphicon glyphicon-star-empty"></span>
            <span class="glyphicon glyphicon-thumbs-up"></span>
          </div>
          <div class="website">网站一</div>
          <div class="title"><%=article.title%></div>
          <div class="preview">這個是學習編程時的…</div>
          <div class="date">5-28</div>
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
</body>
</html>

