<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
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
    <p>Na ovoj strani administrator ima opciju da doda novu destinaciju.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <h2>Dodaj novu destinaciju</h2>
    <form action="addDestinationServlet" method="post" enctype="multipart/form-data">
        <label for="destinationName">Ime destinacije:</label>
        <input type="text" id="destinationName" name="destinationName" required><br>

        <label for="destinationImage">Slika destinacije:</label>
        <input type="file" id="destinationImage" name="destinationImage" accept="image/*" required><br>

        <label for="destinationPrice">Cena po osobi:</label>
        <input type="number" id="destinationPrice" name="destinationPrice" required><br>

        <input type="submit" value="Dodaj">
    </form>
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
