<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.*" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="Daos.ReservationDAO" %>
<%@ page import="Daos.DestinationDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .reservations {
            margin-left: 20px;
        }

        .reservation-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .reservation-table th,
        .reservation-table td {
            padding: 12px 16px;
            text-align: left;
        }

        .reservation-table th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }

        .reservation-table tbody tr:nth-child(even) {
            background-color: rgba(240, 248, 255, 0.38);
        }

        .reservation-table tbody tr:hover {
            background-color: rgba(224, 224, 224, 0.8);
        }

        .reservation-table td:nth-child(5) {
            font-weight: bold;
            color: #007bff;
        }

        .reservation-table td:last-child {
            text-align: right;
            padding-right: 20px;
        }
        .pagination{
            padding-top: 20px;
        }
    </style>


    <%
        String username = "";
        if (session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);

        if (user == null) {
            response.sendRedirect("login.jsp");
        }


        int currentPage = 1;
        int reservationsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        if (request.getParameter("reservationsPerPage") != null) {
            try {
                reservationsPerPage = Integer.parseInt(request.getParameter("reservationsPerPage"));
            } catch (NumberFormatException e) {
                reservationsPerPage = 10;
            }
        }

        DestinationDAO destinationDAO = new DestinationDAO();
        ReservationDAO reservationDAO = new ReservationDAO();
        int totalReservationsCount = reservationDAO.getTotalReservationsCount(user);

        int totalPages = (int) Math.ceil((double) totalReservationsCount / reservationsPerPage);

        int skip = (currentPage - 1) * reservationsPerPage;

        List<Reservation> reservations = reservationDAO.getAllReservationsForUser(user,skip, reservationsPerPage);
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
                        <a class="selektovano" id="username" href="profil.jsp">
                            <img src="<%= user.getProfilePicturePath() %>" alt="Profilna slika" style="width: 20px; height: 20px; padding-right:5px; border-radius: 50%;">
                            <%= username %>
                        </a>
                    </li>
                    <% if(user.isAdmin()) { %>
                    <li><a id="" href="admin-panel.jsp">ADMIN PANEL</a></li>
                    <% } %>
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
    <p>Pregled profila na kome su prikazane osnovne informacije o korisniku. Na ovoj strani korisnik može menjati profilnu sliku i videti dosadašnje rezervacije.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div style="display: flex;" class="content">
    <div class="profile">
        <div class="profile-picture">
            <h3>Profilna slika</h3>
            <% if (user.getProfilePicturePath() != null && !user.getProfilePicturePath().isEmpty()) { %>
            <img id="profile-img"
                 style="width: 150px; height: 150px; border-radius: 50%; border: 2px solid #007bff; transition: filter 0.3s;"
                 src="<%= user.getProfilePicturePath() %>"
                 onclick="document.getElementById('file-input').click();"
                 onmouseover="this.style.filter = 'brightness(80%)';"
                 onmouseout="this.style.filter = 'brightness(100%)';"
                 alt="Profilna slika">
            <% } else { %>
            <div style="width: 100px; height: 100px; border-radius: 50%; border: 2px solid #007bff; display: flex; justify-content: center; align-items: center;">
                <p style="font-size: 14px; color: #007bff;">Nemate postavljenu profilnu sliku.</p>
            </div>
            <% } %>
            <div class="upload-picture">
                <form id="upload-form" action="UploadProfilePicture" method="POST" enctype="multipart/form-data">
                    <input type="file" id="file-input" name="profilePicture" required onchange="document.getElementById('upload-form').submit()">
                    <button type="submit">Upload</button>
                </form>
            </div>
        </div>
        <h2>Korisnički profil</h2>
        <p>Ime: <%= user.getName() %></p>
        <p>Prezime: <%= user.getLastName() %></p>
        <p>E-mail: <%= user.getEmail() %></p>
        <p>Korisničko ime: <%= user.getUsername() %></p>
        <p>Admin: <%= user.isAdmin() ? "Da" : "Ne" %></p>
        <p>Obrisan: <%= user.isDeleted() ? "Da" : "Ne" %></p>
        <p>Datum registracije: <%= user.getDateCreated() %></p>

    </div>
    <div class="reservations">
        <div>
            <h2>Moje rezervacije</h2>
            <table class="reservation-table">
                <thead>
                <tr>
                    <th>Destinacija</th>
                    <th>Broj osoba</th>
                    <th>Broj dana</th>
                    <th>Datum</th>
                    <th>Cena</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (Reservation reservation : reservations) {
                        Destination destination = destinationDAO.getDestinationById(reservation.getDestination().getId());
                %>
                <tr>
                    <td><%= destination.getName() %></td>
                    <td><%= reservation.getBrojOsoba() %></td>
                    <td><%= reservation.getBrojDana() %></td>
                    <td><%= reservation.getDate() %></td>
                    <td><%= reservation.getBrojDana() * reservation.getBrojOsoba() * destination.getPricePerPerson() %> eur</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <div style="
    display: flex;
    align-items: center;
    flex-direction: column; " class="pagination">
            <div>
                <% if (currentPage > 1) { %>
                <form style="display: none" action="profil.jsp" method="POST" id="prevPageForm">
                    <input type="hidden" name="page" value="<%= currentPage - 1 %>">
                    <input type="hidden" name="reservationsPerPage" value="<%= reservationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('prevPageForm').submit(); return false;">Prethodna</a>
                <% } else { %>
                <span>Prethodna</span>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                <% if (i == currentPage) { %>
                <span class="current"><%= i %></span>
                <% } else { %>
                <form style="display: none" action="profil.jsp" method="POST" id="pageForm<%= i %>">
                    <input type="hidden" name="page" value="<%= i %>">
                    <input type="hidden" name="reservationsPerPage" value="<%= reservationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('pageForm<%= i %>').submit(); return false;"><%= i %></a>
                <% } %>
                <% } %>

                <% if (currentPage < totalPages) { %>
                <form style="display: none" action="profil.jsp" method="POST" id="nextPageForm">
                    <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                    <input type="hidden" name="reservationsPerPage" value="<%= reservationsPerPage %>">
                </form>
                <a href="#" onclick="document.getElementById('nextPageForm').submit(); return false;">Sledeća</a>
                <% } else { %>
                <span>Sledeća</span>
                <% } %>
            </div>

            <br>
            <form id="reservationsPerPageForm" action="profil.jsp" method="POST">
                <label for="reservationsPerPage">Broj destinacija po stranici:</label>
                <select style="width: 100%" name="reservationsPerPage" id="reservationsPerPage" onchange="document.getElementById('reservationsPerPageForm').submit();">
                    <option value="5" <%= reservationsPerPage == 5 ? "selected" : "" %>>5</option>
                    <option value="10" <%= reservationsPerPage == 10 ? "selected" : "" %>>10</option>
                    <option value="15" <%= reservationsPerPage == 15 ? "selected" : "" %>>15</option>
                    <option value="20" <%= reservationsPerPage == 20 ? "selected" : "" %>>20</option>
                </select>
                <input type="hidden" name="page" value="<%= currentPage %>">
            </form>
        </div>
    </div>
</div>

<footer>
    <div class="linija"></div>
    <div class="footer-tekst">
        Bogdan Milojević 61/2021
    </div>
</footer>
</body>
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
