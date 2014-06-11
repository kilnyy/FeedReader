<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    Integer id = (Integer)session.getAttribute("user_id");
    User user;
    user = Mapper.getInstance().getUser(id);
    if (user != null) {
        Integer articleId = Integer.parseInt(request.getParameter("article_id")==null?"0":request.getParameter("article_id"));
        String action = request.getParameter("action");
        if (articleId != 0 && action != null) {
            Article article = Mapper.getInstance().actArticle(user, articleId, action);
            if (article != null) {
%>
true
<%
                return;
            }
        }
%>
false
