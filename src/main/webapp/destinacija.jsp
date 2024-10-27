<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<jsp:useBean id="destination" class="Beans.DestinationBean" scope="request">
    <jsp:setProperty name="destination" property="*"/>
</jsp:useBean>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <%
        if(destination.getIsDeleted()==true){
            response.sendRedirect("index.jsp");
        }
        String username = "";
        User user = new User();
        UserDAO userDao = new UserDAO();
        if(session.getAttribute("username")!=null){
            username= (String)session.getAttribute("username");
            user=userDao.getUserByUsername(username);
        }
        if(username.equals("")==true){
            response.sendRedirect("index.jsp");
        }
        boolean isAdmin=false;
        if(session.getAttribute("isAdmin")!=null){
            isAdmin= (boolean)session.getAttribute("isAdmin");
        }
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
<div style="display: flex;" class="content">
    <div class="destination-image">
        <img style="width: 500px; height: 500px;" src="<%= destination.getImagePath() %>" alt="Slika destinacije">
    </div>
    <div style="padding:20px;" class="destination-details">

        <div class="destination-info">
            <h2><%= destination.getName() %></h2>
            <p>Cena po osobi: <%= destination.getPricePerPerson() %> eur</p>
        </div>
        <div class="booking-form">
            <h2>Zakazivanje letovanja</h2>
            <form action="rezervacijaServlet" method="post">
                <input type="hidden" name="destinationId" value="<%= destination.getId() %>">
                <input type="hidden" name="username" value="<%= username %>">
                <label for="brojOsoba">Broj osoba:</label>
                <input type="number" id="brojOsoba" name="brojOsoba" required>
                <label for="brojDana">Broj Dana:</label>
                <input type="number" id="brojDana" name="brojDana" required>
                <label for="datum">Datum:</label>
                <input type="date" id="datum" name="datum" required>
                <button type="submit">Zakaži</button>
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
</html>
