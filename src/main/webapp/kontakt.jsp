<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    %>
</head>
<body>
<header>
    <nav>
        <div class="menu-container">
            <ul class="menu">
                <li><a href="index.jsp">POCETNA</a></li>
                <li><a class="selektovano" href="kontakt.jsp">KONTAKT</a></li>
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
    <p>Na ovoj strani ulogovani korisnici imaju mogućnost da kontaktiraju administratore ukoliko imaju nekih nedoumica, ili u svrhu poboljšanja sajta.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">

    <div>
        <h2>Kontaktirajte nas</h2>
        <p>Hvala vam što ste zainteresovani za kontaktiranje naše kompanije. Mi smo ovde da vam pružimo podršku i odgovorimo na vaša pitanja. Možete nas kontaktirati putem sledećih informacija:</p>

        <ul>
            <li>Telefon: 060 555333</li>
            <li>Email: letovanja@letovanja.com</li>
            <li>Adresa: Radoja Domanovića</li>
        </ul>

        <p>Naš tim stručnjaka je spreman da vam pruži pomoć i informacije koje vam trebaju. Bilo da imate pitanja o našim proizvodima i uslugama, želite da saznate više o cenama ili imate posebne zahteve, slobodno nas kontaktirajte.</p>

        <p>Takođe, možete poslati poruku putem donjeg obrasca. Napišite vaše ime, kontakt detalje i poruku, i mi ćemo vam se javiti u najkraćem mogućem roku.</p>
        <%
            if(isAdmin!=false){
        %>
        <button  onclick="window.location.href='upravljaj-kontaktima.jsp'">Prikaži kontakte</button>
        <%
            }
            if(session.getAttribute("username")==null){
        %>
        <form>
            <label>Ime:</label>
            <input type="text" name="ime" disabled placeholder="Morate biti ulogovani.">
            <br>
            <label>Email:</label>
            <input type="email"  name="email" disabled placeholder="Morate biti ulogovani.">
            <br>
            <label>Poruka:</label>
            <textarea  name="poruka" disabled placeholder="Morate biti ulogovani."></textarea>
            <br>
            <button disabled type="button" value="Prikazi cenu" >Pošalji</button>
        </form>
        <%
            }
        %>
        <%
            if(session.getAttribute("username")!=null){
        %>
        <form action="ContactServlet" method="POST">
            <label>Ime:</label>
            <input type="text" id="kontaktIme" name="ime" value="<%= user.getName()%>" required disabled>
            <br>
            <label>Email:</label>
            <input type="email" id="kontaktEmail" name="email" value="<%= user.getEmail()%>" required disabled>
            <br>
            <label>Poruka:</label>
            <textarea id="kontaktPoruka" name="poruka" required></textarea>
            <br>
            <input type="hidden" name="username" value="<%= username %>">
            <button type="submit" value="Pošalji">Pošalji</button>
        </form>
        <%
            }
        %>
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

