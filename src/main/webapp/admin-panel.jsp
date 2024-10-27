<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <%
        String username = "";
        User loggedUser = new User();
        UserDAO userDao = new UserDAO();
        if (session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
            loggedUser = userDao.getUserByUsername(username);
        }
        boolean isAdmin = false;
        if (session.getAttribute("isAdmin") != null) {
            isAdmin = (boolean) session.getAttribute("isAdmin");
        }
        if(isAdmin==false){
            response.sendRedirect("index.jsp");
        }
        int currentPage = 1;
        int usersPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        if (request.getParameter("usersPerPage") != null) {
            try {
                usersPerPage = Integer.parseInt(request.getParameter("usersPerPage"));
            } catch (NumberFormatException e) {
                usersPerPage = 10;
            }
        }

        UserDAO userDAO = new UserDAO();
        int totalUsersCount = userDAO.getTotalUsersCount();

        int totalPages = (int) Math.ceil((double) totalUsersCount / usersPerPage);

        int skip = (currentPage - 1) * usersPerPage;

        List<User> users = userDAO.getAllUsers(skip, usersPerPage);
    %>
</head>
<body>
<header>
    <nav>
        <div class="menu-container">
            <ul class="menu">
                <li><a href="index.jsp">POCETNA</a></li>
                <li><a href="kontakt.jsp">KONTAKT</a></li>
                <li><a href="onama.jsp">O NAMA</a></li>
                <li><a href="chat.jsp">CHAT</a></li>
                <div class="right-menu">
                    <% if (!username.equals("")) { %>
                    <li>
                        <a id="username" href="profil.jsp">
                            <img src="<%= loggedUser.getProfilePicturePath() %>" alt="Profilna slika" style="width: 20px; height: 20px; padding-right:5px; border-radius: 50%;">
                            <%= username %>
                        </a>
                    </li>
                    <% if (isAdmin) { %>
                    <li><a class="selektovano" id="" href="admin-panel.jsp">ADMIN PANEL</a></li><% } %>
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
    <p>Administratorska strana za upravljanje korisnicima. Administrator na ovoj stranici može pregledati profile drugih korisnika kao i deaktivirati/aktivirati ih.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <div id="searchContainer">
        <h2>Pretraga korisnika</h2>
        <form id="searchForm">
            <input type="text" id="searchInput" name="searchInput" placeholder="Unesite korisničko ime" onkeyup="performSearch()">
        </form>
    </div>

    <div class="admin-panel">
        <div style="display: inline-block;" id="sviKorisnici">
            <h2>Svi korisnici</h2>
            <table id="usersTable">
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
                        <%
                            if(user.isDeleted()==false){
                        %>
                        <form action="deactivateUserHandler.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id" value="<%= user.getId() %>">
                            <input type="hidden" name="username" value="<%= user.getUsername() %>">
                            <input type="hidden" name="password" value="<%= user.getPassword() %>">
                            <input type="hidden" name="isAdmin" value="<%= user.isAdmin() %>">
                            <input type="hidden" name="isDeleted" value="<%= user.isDeleted() %>">
                            <input type="hidden" name="profilePicturePath" value="<%= user.getProfilePicturePath() %>">
                            <input type="hidden" name="dateCreated" value="<%= user.getDateCreated() %>">
                            <input type="hidden" name="sessionId" value="<%= user.getSessionId() %>">

                            <input type="hidden" name="page" value="<%= currentPage %>">
                            <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
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
                        <%
                            }
                        %>
                        <%
                            if(user.isDeleted()==true){
                        %>
                        <form action="activateUserHandler.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id" value="<%= user.getId() %>">
                            <input type="hidden" name="username" value="<%= user.getUsername() %>">
                            <input type="hidden" name="password" value="<%= user.getPassword() %>">
                            <input type="hidden" name="isAdmin" value="<%= user.isAdmin() %>">
                            <input type="hidden" name="isDeleted" value="<%= user.isDeleted() %>">
                            <input type="hidden" name="profilePicturePath" value="<%= user.getProfilePicturePath() %>">
                            <input type="hidden" name="dateCreated" value="<%= user.getDateCreated() %>">
                            <input type="hidden" name="sessionId" value="<%= user.getSessionId() %>">

                            <input type="hidden" name="page" value="<%= currentPage %>">
                            <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
                            <button style="background-color:green; width: 105px;" type="submit">Aktiviraj</button>
                        </form>
                        <%
                            }
                        %>
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

                            <input type="hidden" name="page" value="<%= currentPage %>">
                            <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
                            <button type="submit">Pogledaj profil</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>

            <div style="
    display: flex;
    align-items: center;
    flex-direction: column; " class="pagination">
                <div>
                    <% if (currentPage > 1) { %>
                    <form style="display: none" action="admin-panel.jsp" method="POST" id="prevPageForm">
                        <input type="hidden" name="page" value="<%= currentPage - 1 %>">
                        <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
                    </form>
                    <a href="#" onclick="document.getElementById('prevPageForm').submit(); return false;">Prethodna</a>
                    <% } else { %>
                    <span>Prethodna</span>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) { %>
                    <span class="current"><%= i %></span>
                    <% } else { %>
                    <form style="display: none" action="admin-panel.jsp" method="POST" id="pageForm<%= i %>">
                        <input type="hidden" name="page" value="<%= i %>">
                        <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
                    </form>
                    <a href="#" onclick="document.getElementById('pageForm<%= i %>').submit(); return false;"><%= i %></a>
                    <% } %>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <form style="display: none" action="admin-panel.jsp" method="POST" id="nextPageForm">
                        <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                        <input type="hidden" name="usersPerPage" value="<%= usersPerPage %>">
                    </form>
                    <a href="#" onclick="document.getElementById('nextPageForm').submit(); return false;">Sledeća</a>
                    <% } else { %>
                    <span>Sledeća</span>
                    <% } %>
                </div>

                <form id="usersPerPageForm" action="admin-panel.jsp" method="POST">
                    <label for="usersPerPage">Broj korisnika po stranici:</label>
                    <select style="width: 100%" name="usersPerPage" id="usersPerPage" onchange="document.getElementById('usersPerPageForm').submit();">
                        <option value="5" <%= usersPerPage == 5 ? "selected" : "" %>>5</option>
                        <option value="10" <%= usersPerPage == 10 ? "selected" : "" %>>10</option>
                        <option value="15" <%= usersPerPage == 15 ? "selected" : "" %>>15</option>
                        <option value="20" <%= usersPerPage == 20 ? "selected" : "" %>>20</option>
                    </select>
                    <input type="hidden" name="page" value="<%= currentPage %>">
                </form>
            </div>
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
<script>
    var delayTimer;

    function performSearch() {
        clearTimeout(delayTimer);

        delayTimer = setTimeout(function() {
            var searchValue = document.getElementById('searchInput').value.trim();

            if (searchValue == null) {
                searchValue = '*';
            }

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'searchUser.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        var response = xhr.responseText;
                        document.getElementById('usersTable').innerHTML = response;
                    } else {
                        console.error('Error:', xhr.status);
                    }
                }
            };
            xhr.send('searchInput=' + encodeURIComponent(searchValue));
        }, 300);
    }




    function openPopup() {
        var popup = document.getElementById('popup');
        popup.style.display = 'block';
    }

    function closePopup() {
        var popup = document.getElementById('popup');
        popup.style.display = 'none';
    }
</script>
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
</html>
