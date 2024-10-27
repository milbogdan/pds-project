<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Beans.UserBean" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>

<jsp:useBean id="user" class="Beans.UserBean" scope="request">
    <jsp:setProperty name="user" property="*"/>
</jsp:useBean>

<%

    user.setIsDeleted(true);
    UserDAO userDAO = new UserDAO();
    userDAO.updateUser(user);
    if(request.getParameter("page")!=null && request.getParameter("usersPerPage")!=null){
        int currentPage = Integer.parseInt(request.getParameter("page"));
        int usersPerPage = Integer.parseInt(request.getParameter("usersPerPage"));
        response.sendRedirect("admin-panel.jsp?page="+currentPage+"&usersPerPage="+usersPerPage);
    }
    else{
        response.sendRedirect("admin-panel.jsp");
    }
%>
