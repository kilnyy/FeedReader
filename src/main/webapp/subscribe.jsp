<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.kilnyy.feedreader.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    if (request.getParameter("url") != null) {
        Site site = Mapper.getInstance().subscribeSite(user, request.getParameter("url"));
        if (site != null) {
            response.sendRedirect("./index.jsp?msg=Subscribe%20succeed");
        } else {
            response.sendRedirect("./index.jsp?msg=Subscribe%20failed&alert=danger");
        }
    }
%>
