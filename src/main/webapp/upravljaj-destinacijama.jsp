<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="models.Destination" %>
<%@ page import="Daos.DestinationDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <%
        String username = "";
        User user = new User();
        UserDAO userDao = new UserDAO();
        if(session.getAttribute("username")!=null){
            username= (String)session.getAttribute("username");
            user=userDao.getUserByUsername(username);
        }
        boolean isAdmin=false;
        if(session.getAttribute("isAdmin")!=null){
            isAdmin= (boolean)session.getAttribute("isAdmin");
        }
        if(isAdmin==false){
            response.sendRedirect("index.jsp");
        }
        int currentPage = 1;
        int destinationsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        if (request.getParameter("destinationsPerPage") != null) {
            try {
                destinationsPerPage = Integer.parseInt(request.getParameter("destinationsPerPage"));
            } catch (NumberFormatException e) {
                destinationsPerPage = 10;
            }
        }
        DestinationDAO destinationDAO = new DestinationDAO();
        int totalUsersCount = destinationDAO.getTotalDestinationsCount();

        int totalPages = (int) Math.ceil((double) totalUsersCount / destinationsPerPage);

        int skip = (currentPage - 1) * destinationsPerPage;

        List<Destination> destinations = destinationDAO.getAllDestinations(skip, destinationsPerPage);
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
    <p>Na ovoj stranici administrator ima uvid u sve destinacije, kao i opciju da ih deaktivira.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <div style="display: inline-block;width: 100%;">
        <table>
            <thead>
            <tr>
                <th>Ime destinacije</th>
                <th>Cena po osobi</th>
                <th>Obrisano</th>
                <th>Akcija</th>
            </tr>
            </thead>
            <tbody>
            <% for (Destination destination : destinations) { %>
            <tr>
                <td><%= destination.getName() %></td>
                <td><%= destination.getPricePerPerson() %> EUR</td>
                <td><%= destination.isDeleted()? "Da" : "Ne" %></td>
                <td>
                    <%
                        if(destination.isDeleted()==false){
                    %>
                    <form action="deactivateDestinationHandler.jsp" method="GET" style="display:inline;">
                        <input type="hidden" name="id" value="<%= destination.getId() %>">
                        <input type="hidden" name="name" value="<%= destination.getName() %>">
                        <input type="hidden" name="imagePath" value="<%= destination.getImagePath() %>">
                        <input type="hidden" name="pricePerPerson" value="<%= destination.getPricePerPerson() %>">
                        <input type="hidden" name="isDeleted" value="<%= destination.isDeleted() %>">
                        <input type="hidden" name="page" value="<%= currentPage %>">
                        <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
                        <button type="submit"
                                style="background-color: red; width: 105px;" >Deaktiviraj</button>
                    </form>
                    <%
                        }
                        if(destination.isDeleted()==true){
                    %>
                    <form action="activateDestinationHandler.jsp" method="POST" style="display:inline;">
                        <input type="hidden" name="id" value="<%= destination.getId() %>">
                        <input type="hidden" name="name" value="<%= destination.getName() %>">
                        <input type="hidden" name="imagePath" value="<%= destination.getImagePath() %>">
                        <input type="hidden" name="pricePerPerson" value="<%= destination.getPricePerPerson() %>">
                        <input type="hidden" name="isDeleted" value="<%= destination.isDeleted() %>">
                        <input type="hidden" name="page" value="<%= currentPage %>">
                        <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
                        <button type="submit"
                                style="background-color: green; width: 105px;">Aktiviraj</button>
                    </form>
                    <%
                        }
                    %>
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
                <form style="display: none" action="upravljaj-destinacijama.jsp" method="POST" id="prevPageForm">
                    <input type="hidden" name="page" value="<%= currentPage - 1 %>">
                    <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('prevPageForm').submit(); return false;">Prethodna</a>
                <% } else { %>
                <span>Prethodna</span>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                <% if (i == currentPage) { %>
                <span class="current"><%= i %></span>
                <% } else { %>
                <form style="display: none" action="upravljaj-destinacijama.jsp" method="POST" id="pageForm<%= i %>">
                    <input type="hidden" name="page" value="<%= i %>">
                    <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('pageForm<%= i %>').submit(); return false;"><%= i %></a>
                <% } %>
                <% } %>
                <% if (currentPage < totalPages) { %>
                <form style="display: none" action="upravljaj-destinacijama.jsp" method="POST" id="nextPageForm">
                    <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                    <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('nextPageForm').submit(); return false;">Sledeća</a>
                <% } else { %>
                <span>Sledeća</span>
                <% } %>

            </div>
            <br>
            <form id="destinationsPerPageForm" action="upravljaj-destinacijama.jsp" method="GET">
                <label for="destinationsPerPage">Broj destinacija po stranici:</label>
                <select style="width: 100%" name="destinationsPerPage" id="destinationsPerPage" onchange="document.getElementById('destinationsPerPageForm').submit();">
                    <option value="5" <%= destinationsPerPage == 5 ? "selected" : "" %>>5</option>
                    <option value="10" <%= destinationsPerPage == 10 ? "selected" : "" %>>10</option>
                    <option value="15" <%= destinationsPerPage == 15 ? "selected" : "" %>>15</option>
                    <option value="20" <%= destinationsPerPage == 20 ? "selected" : "" %>>20</option>
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
