<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="models.User" %>

<%
    String searchInput = request.getParameter("searchInput");
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.searchUsersByUsername(searchInput);
%>
<table>
    <thead>
    <tr>
        <th>Korisničko ime</th>
        <th>Ime</th>
        <th>Prezime</th>
        <th>E-mail</th>
        <th>Admin</th>
        <th>Obrisan</th>
        <th>Datum kreiranja</th>
        <th>Akcije</th>
    </tr>
    </thead>
    <tbody>
    <% for (User user : users) { %>
    <tr>
        <td><%= user.getUsername() %></td>
        <td><%= user.getName() %></td>
        <td><%= user.getLastName() %></td>
        <td><%= user.getEmail() %></td>
        <td><%= user.isAdmin() ? "Da" : "Ne" %></td>
        <td><%= user.isDeleted() ? "Da" : "Ne" %></td>
        <td><%= user.getDateCreated() %></td>
        <td>
            <% if (!user.isDeleted()) { %>
            <form action="deactivateUserHandler.jsp" method="POST" style="display:inline;">
                <input type="hidden" name="id" value="<%= user.getId() %>">
                <input type="hidden" name="username" value="<%= user.getUsername() %>">
                <input type="hidden" name="password" value="<%= user.getPassword() %>">
                <input type="hidden" name="isAdmin" value="<%= user.isAdmin() %>">
                <input type="hidden" name="isDeleted" value="true">
                <input type="hidden" name="profilePicturePath" value="<%= user.getProfilePicturePath() %>">
                <input type="hidden" name="dateCreated" value="<%= user.getDateCreated() %>">
                <input type="hidden" name="sessionId" value="<%= user.getSessionId() %>">
                <%
                if(user.isAdmin()==false){
                %>
                <button style="background-color:red; width: 105px;" type="submit">Deaktiviraj</button>
                <%
                    }
                    if(user.isAdmin()==true){
                %>
                <button style="background-color:gray; width: 105px;" type="button">Deaktiviraj</button>
                <%
                    }
                %>
            </form>
            <% } else { %>
            <form action="activateUserHandler.jsp" method="POST" style="display:inline;">
                <input type="hidden" name="id" value="<%= user.getId() %>">
                <input type="hidden" name="username" value="<%= user.getUsername() %>">
                <input type="hidden" name="password" value="<%= user.getPassword() %>">
                <input type="hidden" name="isAdmin" value="<%= user.isAdmin() %>">
                <input type="hidden" name="isDeleted" value="false">
                <input type="hidden" name="profilePicturePath" value="<%= user.getProfilePicturePath() %>">
                <input type="hidden" name="dateCreated" value="<%= user.getDateCreated() %>">
                <input type="hidden" name="sessionId" value="<%= user.getSessionId() %>">
                <button style="background-color:green; width: 105px;" type="submit">Aktiviraj</button>
            </form>
            <% } %>
            <form action="korisnikovProfil.jsp" method="POST" style="display:inline;">
                <input type="hidden" name="id" value="<%= user.getId() %>">
                <input type="hidden" name="username" value="<%= user.getUsername() %>">
                <input type="hidden" name="name" value="<%= user.getName() %>">
                <input type="hidden" name="lastName" value="<%= user.getLastName() %>">
                <input type="hidden" name="email" value="<%= user.getEmail() %>">
                <input type="hidden" name="password" value="<%= user.getPassword() %>">
                <input type="hidden" name="isAdmin" value="<%= user.isAdmin() %>">
                <input type="hidden" name="isDeleted" value="<%= user.isDeleted() %>">
                <input type="hidden" name="profilePicturePath" value="<%= user.getProfilePicturePath() %>">
                <input type="hidden" name="dateCreated" value="<%= user.getDateCreated() %>">
                <input type="hidden" name="sessionId" value="<%= user.getSessionId() %>">
                <button type="submit">Pogledaj profil</button>
            </form>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
