<%@ page contentType="text/html;charset=utf-8" %>
<% 
    String mod = (String)session.getAttribute("mod");
    if (mod == null) mod = "";
    if (mod.equals("unread")) {
        session.setAttribute("mod", "");
    } else {
        session.setAttribute("mod", "unread");
    }
    response.sendRedirect(request.getParameter("next") + "&msg=Toggle%20succeed");
%>
