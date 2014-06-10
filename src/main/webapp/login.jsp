<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.Mapper" %>
<%@ page import="org.kilnyy.feedreader.User" %>
<% 
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String msg = request.getParameter("msg");
    if (email != null) {
        if (password == null) password = "";
        User user = Mapper.getInstance().getUser(email, password);
        if (user != null) {
            session.setAttribute("user_id", user.id);
            response.sendRedirect("./index.jsp");
            return;
        } else {
            response.sendRedirect("./login.jsp");
            return;
        }
    }
%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
</head>
<body>
<div class="row" style="margin-bottom:100px">
<div class="col-lg-offset-4 col-lg-4 col-md-offset-3 col-md-6">
<div class="row">
<div class="col-lg-12">
<h1 class="page-header text-center">登录</h1>
</div>
</div>
<form action="login.jsp" method="post">
<input style="display:none" type="text" name="next" value="{{next}}" />
<div class="form-group email optional user_email">
  <label class="email optional control-label" for="user_email">Email</label>
  <input autofocus="autofocus" class="string email optional" id="user_email" name="email" size="50" type="email" />
</div>
<div class="form-group password required user_password">
  <label class="password required control-label" for="user_password">
  Password</label>
  <input id="user_password" name="password" placeholder="Password" size="30" type="password" />
</div>
<input class="btn btn-block btn-success" type="submit" value="登录" />
</form>
</div>
</div>
</body>
</html>
