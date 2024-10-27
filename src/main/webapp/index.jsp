<%@ page import="jakarta.persistence.EntityManagerFactory" %>
<%@ page import="jakarta.persistence.Persistence" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Destination" %>
<%@ page import="Daos.DestinationDAO" %>
<%@ page import="Database.DatabaseProvider" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
<%
    DatabaseProvider.provideDatabase();

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");
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
    int currentPage = 1;
    int destinationsPerPage = 6;

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
                <li><a class="selektovano" href="index.jsp">POCETNA</a></li>
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
    <p>Na ovoj strani se nalazi pregled svih destinacija. Ulogovani korisnici imaju mogućnost zakazivanja letovanja, dok gosti imaju samo mogućnost pregleda destinacija.</p>
    <p>Administrator ima opciju za dodavanje destinacije i upravljanje istim.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <h2>Dobrodošli u čarobni svet turizma</h2>
    <p>Putovanja su prilika da istražite svet, upoznate nove kulture i stvorite nezaboravne uspomene. Turizam je spoj avanture, relaksacije i otkrivanja skrivenih dragulja našeg planeta. Bez obzira da li želite da se izgubite u šarenim ulicama evropskih gradova, istražujete divlje predele netaknute prirode ili se opuštate na tirkiznim plažama tropskih destinacija, tu je nešto za svakoga.</p>
    <p>Naša putovanja su dizajnirana da vam pruže najbolje iskustvo. Uživajte u prelepim pejzažima, otkrijte kulturno nasleđe, probajte autentičnu hranu i upoznajte srdačne lokalne stanovnike. Bilo da putujete sami, sa partnerom, prijateljima ili porodicom, imamo širok izbor destinacija i programa koji će ispuniti sva vaša očekivanja.</p>
    <% if (isAdmin) { %>
    <div class="add-destination">
        <button  onclick="window.location.href='dodaj-destinaciju.jsp'">Dodaj destinaciju</button>
        <button  onclick="window.location.href='upravljaj-destinacijama.jsp'">Upravljaj destinacijama</button>
    </div>
    <% } %>
    <div class="gallery">
        <% for (Destination destination : destinations) {
            if(destination.isDeleted()==false){%>
        <div class="image">
            <% if(username.isEmpty()){ %>
            <a href="#" onclick="<%= "if(confirm('Morate biti ulogovani! Želite li se prijaviti?')) { window.location.href='login.jsp'; }" %>">
                <img src="<%= destination.getImagePath() %>" alt="Slika">
            </a>
            <% } %>
            <% if(!username.isEmpty()){ %>
            <form id="destinationForm<%= destination.getId() %>" action="destinacija.jsp" method="POST" style="display: none;">
                <input type="hidden" name="id" value="<%= destination.getId() %>">
                <input type="hidden" name="name" value="<%= destination.getName() %>">
                <input type="hidden" name="pricePerPerson" value="<%= destination.getPricePerPerson() %>">
                <input type="hidden" name="imagePath" value="<%= destination.getImagePath() %>">
                <input type="hidden" name="isDeleted" value="<%= destination.isDeleted() %>">
            </form>
            <a href="#" onclick="document.getElementById('destinationForm<%= destination.getId() %>').submit();">
                <img src="<%= destination.getImagePath() %>" alt="Slika">
            </a>
            <% } %>
            <p><%= destination.getName() %>, <%= destination.getPricePerPerson() %> eur</p>
        </div>
        <% }} %>

    </div>
    <div style="
    display: flex;
    align-items: center;
    flex-direction: column; " class="pagination">
        <div>
            <% if (currentPage > 1) { %>
            <form style="display: none" action="index.jsp" method="POST" id="prevPageForm">
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
            <form style="display: none" action="index.jsp" method="POST" id="pageForm<%= i %>">
                <input type="hidden" name="page" value="<%= i %>">
                <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
            </form>
            <a href="#" onclick="document.getElementById('pageForm<%= i %>').submit(); return false;"><%= i %></a>
            <% } %>
            <% } %>

            <% if (currentPage < totalPages) { %>
            <form style="display: none" action="index.jsp" method="POST" id="nextPageForm">
                <input type="hidden" name="page" value="<%= currentPage + 1 %>">
                <input type="hidden" name="destinationsPerPage" value="<%= destinationsPerPage %>">
            </form>
            <a href="#" onclick="document.getElementById('nextPageForm').submit(); return false;">Sledeća</a>
            <% } else { %>
            <span>Sledeća</span>
            <% } %>
        </div>

        <br>
        <form id="destinationsPerPageForm" action="index.jsp" method="POST">
            <label for="destinationsPerPage">Broj destinacija po stranici:</label>
            <select style="width: 100%" name="destinationsPerPage" id="destinationsPerPage" onchange="document.getElementById('destinationsPerPageForm').submit();">
                <option value="3" <%= destinationsPerPage == 3 ? "selected" : "" %>>3</option>
                <option value="6" <%= destinationsPerPage == 6 ? "selected" : "" %>>6</option>
                <option value="9" <%= destinationsPerPage == 9 ? "selected" : "" %>>9</option>
                <option value="12" <%= destinationsPerPage == 12 ? "selected" : "" %>>12</option>
                <option value="15" <%= destinationsPerPage == 15 ? "selected" : "" %>>15</option>
                <option value="18" <%= destinationsPerPage == 18 ? "selected" : "" %>>18</option>
            </select>
            <input type="hidden" name="page" value="<%= currentPage %>">
        </form>
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
