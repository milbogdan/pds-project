<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="models.Contact" %>
<%@ page import="Daos.ContactDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja - Upravljanje Kontaktima</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <%
        String username = "";
        User user = new User();
        UserDAO userDao = new UserDAO();
        if(session.getAttribute("username") != null) {
            username = (String)session.getAttribute("username");
            user = userDao.getUserByUsername(username);
        }
        boolean isAdmin = false;
        if(session.getAttribute("isAdmin") != null) {
            isAdmin = (boolean)session.getAttribute("isAdmin");
        }
        if(isAdmin==false){
            response.sendRedirect("index.jsp");
        }
        int currentPage = 1;
        int contactsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        if (request.getParameter("contactsPerPage") != null) {
            try {
                contactsPerPage = Integer.parseInt(request.getParameter("contactsPerPage"));
            } catch (NumberFormatException e) {
                contactsPerPage = 10;
            }
        }
        ContactDAO contactDAO = new ContactDAO();
        int totalContactsCount = contactDAO.getTotalContactsCount();

        int totalPages = (int) Math.ceil((double) totalContactsCount / contactsPerPage);

        int skip = (currentPage - 1) * contactsPerPage;

        List<Contact> contacts = contactDAO.getAllContacts(skip, contactsPerPage);
    %>
</head>
<body>
<header>
    <nav>
        <div class="menu-container">
            <ul class="menu">
                <li><a href="index.jsp">POČETNA</a></li>
                <li><a href="kontakt.jsp">KONTAKT</a></li>
                <li><a href="onama.jsp">O NAMA</a></li>
                <li><a href="chat.jsp">CHAT</a></li>
                <div class="right-menu">
                    <% if (!username.equals("")) { %>
                    <li>
                        <a id="username" href="profil.jsp">
                            <img src="<%= user.getProfilePicturePath() %>" alt="Profilna slika" style="width: 20px; height: 20px; padding-right:5px; border-radius: 50%;">
                            <%= username %>
                        </a>
                    </li>
                    <% if(isAdmin==true) {%>
                    <li><a id="" href="admin-panel.jsp">ADMIN PANEL</a></li><% } %>
                    <li id="logout"><a href="LogoutServlet">IZLOGUJ SE</a></li>
                    <% } else { %>
                    <li id="logout"><a href="login.jsp">PRIJAVI SE</a></li>
                    <% } %>
                </div>
            </ul>
        </div>
    </nav>
</header>

<div class="background"></div>
<button style="position: absolute; margin:20px; background-color:lightskyblue;color:black;" onclick="openPopup()">Help</button>
<div id="popup" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: white; padding: 20px; border: 1px solid black; box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); z-index: 1000;">
    <h2>Uputstva</h2>
    <p>Na ovoj stranici administrator ima uvid u sve kontakte od strane korisnika.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <div style="display: inline-block; width: 100%;">
        <table style="width: 100%;">
            <thead>
            <tr>
                <th>Korisnik</th>
                <th>Email</th>
                <th>Sadržaj</th>
                <th>Vreme</th>
            </tr>
            </thead>
            <tbody>
            <% for (Contact contact : contacts) { %>
            <tr>
                <td><%= contact.getUser().getUsername() %></td>
                <td><%= contact.getUser().getEmail() %></td>
                <td><%= contact.getContent() %></td>
                <td><%= contact.getTime() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <div style="display: flex; align-items: center; flex-direction: column;" class="pagination">
            <div>
                <% if (currentPage > 1) { %>
                <form style="display: none" action="upravljaj-kontaktima.jsp" method="POST" id="prevPageForm">
                    <input type="hidden" name="page" value="<%= currentPage - 1 %>">
                    <input type="hidden" name="contactsPerPage" value="<%= contactsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('prevPageForm').submit(); return false;">Prethodna</a>
                <% } else { %>
                <span>Prethodna</span>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                <% if (i == currentPage) { %>
                <span class="current"><%= i %></span>
                <% } else { %>
                <form style="display: none" action="upravljaj-kontaktima.jsp" method="POST" id="pageForm<%= i %>">
                    <input type="hidden" name="page" value="<%= i %>">
                    <input type="hidden" name="contactsPerPage" value="<%= contactsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('pageForm<%= i %>').submit(); return false;"><%= i %></a>
                <% } %>
                <% } %>
                <% if (currentPage < totalPages) { %>
                <form style="display: none" action="upravljaj-kontaktima.jsp" method="POST" id="nextPageForm">
                    <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                    <input type="hidden" name="contactsPerPage" value="<%= contactsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('nextPageForm').submit(); return false;">Sledeća</a>
                <% } else { %>
                <span>Sledeća</span>
                <% } %>

            </div>
            <br>
            <form id="contactsPerPageForm" action="upravljaj-kontaktima.jsp" method="POST">
                <label for="contactsPerPage">Broj kontakata po stranici:</label>
                <select style="width: 100%" name="contactsPerPage" id="contactsPerPage" onchange="document.getElementById('contactsPerPageForm').submit();">
                    <option value="5" <%= contactsPerPage == 5 ? "selected" : "" %>>5</option>
                    <option value="10" <%= contactsPerPage == 10 ? "selected" : "" %>>10</option>
                    <option value="15" <%= contactsPerPage == 15 ? "selected" : "" %>>15</option>
                    <option value="20" <%= contactsPerPage == 20 ? "selected" : "" %>>20</option>
                </select>
                <input type="hidden" name="page" value="<%= currentPage %>">
            </form>
        </div>
    </div>
</div>

<footer>
    <div class="linija"></div>
    <div class="footer-tekst">
        Bogdan Milojevic 61/2021
    </div>
</footer>
</body>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid black;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #f2f2f2;
    }
</style>
<script>
    function openPopup() {
        var popup = document.getElementById('popup');
        popup.style.display = 'block';
    }

    function closePopup() {
        var popup = document.getElementById('popup');
        popup.style.display = 'none';
    }
</script>
</html>
