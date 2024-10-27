<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Daos.DestinationDAO" %>

<jsp:useBean id="destination" class="Beans.DestinationBean" scope="request">
    <jsp:setProperty name="destination" property="*"/>
</jsp:useBean>

<%
    DestinationDAO destinationDAO = new DestinationDAO();
    destination.setIsDeleted(false);
    destinationDAO.updateDestination(destination);
    if(request.getParameter("page")!=null && request.getParameter("destinationsPerPage")!=null){
        int currentPage = Integer.parseInt(request.getParameter("page"));
        int destinationsPerPage = Integer.parseInt(request.getParameter("destinationsPerPage"));
        response.sendRedirect("upravljaj-destinacijama.jsp?page="+currentPage+"&destinationsPerPage="+destinationsPerPage);
    }
    else{
        response.sendRedirect("upravljaj-destinacijama.jsp");
    }
%>
