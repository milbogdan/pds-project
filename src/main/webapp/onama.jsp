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
    %>
</head>
<body>
<header>
    <nav>
        <div class="menu-container">
            <ul class="menu">
                <li><a href="index.jsp">POCETNA</a></li>
                <li><a href="kontakt.jsp">KONTAKT</a></li>
                <li><a class="selektovano"  href="onama.jsp">O NAMA</a></li>
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
    <p>Informativna stranica, na kojoj se korisnik može bolje informisati.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <h1>O nama</h1>
    <p>
        Dobrodošli u našu turističku agenciju!
    </p>
    <p>
        Mi smo strastvena ekipa putničkih entuzijasta koja je posvećena pružanju vrhunskog iskustva putovanja našim klijentima. Sa dugogodišnjim iskustvom u industriji, naš cilj je da vam omogućimo nezaboravne avanture, bogate kulturološke doživljaje i relaksaciju na najlepšim destinacijama širom sveta.
    </p>
    <p>
        Naš tim stručnih putničkih savetnika pažljivo osmišljava svako putovanje, uzimajući u obzir vaše interese, budžet i posebne zahteve. Sa našim širokim izborom destinacija i raznovrsnim ponudama, možemo vam pomoći da stvorite savršeno putovanje prilagođeno baš vama.
    </p>
    <p>
        <strong>Šta nas čini posebnima?</strong>
    </p>
    <ol>
        <li>Iskustvo</li>
        <li>Personalizacija</li>
        <li>Kvalitet i pouzdanost</li>
        <li>Raznolikost destinacija</li>
    </ol>
    <p>
        Naša misija je da vam pružimo nezaboravno putovanje koje će vas inspirisati, obogatiti i stvoriti uspomene za ceo život. Sa nama, putovanje postaje više od samo putovanja - postaje nezaboravna avantura.
    </p>
    <p>
        Hvala vam što ste odabrali našu turističku agenciju. Radujemo se što ćemo vam pomoći da ostvarite vaše snove o putovanjima!
    </p>
    <div id="mapa">
        <iframe id="mapaa" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1120.6361109032626!2d20.922543759207393!3d44.015408415469024!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x475101b2526ad8d7%3A0x6ed67583be4391e4!2sRadoja%20Domanovi%C4%87a%2C%20Kragujevac!5e0!3m2!1sen!2srs!4v1622616207291!5m2!1sen!2srs" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
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
