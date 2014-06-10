<%
String msg = request.getParameter("msg");
String alert = request.getParameter("alert");
if (msg != null && !msg.equals("")) {
    if (alert == null || alert.equals("")) {
        alert = "success";
    }
%>
<div class="alert alert-<%=alert%>">
  <p><%=msg%></p>
  <a class="close" data-dismiss="alert" href="#">x</a>
</div>
<%
}
%>
