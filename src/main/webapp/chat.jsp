<%@ page import="jakarta.persistence.EntityManagerFactory" %>
<%@ page import="jakarta.persistence.Persistence" %>
<%@ page import="models.User" %>
<%@ page import="Daos.UserDAO" %>
<%@ page import="Daos.ChatMessageDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="models.ChatMessage" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .chat {
            width: 100%;
            height: 200px;
            border: 1px solid silver;
            overflow-y: scroll;
        }

        #msg {width: 99%;}

        h1 {text-align: center;}

    </style>
    <script type="text/javascript">
        var username = "<%= session.getAttribute("username") %>";
        var wsUrl;
        if (window.location.protocol == 'http:') {
            wsUrl = 'ws://';
        } else {
            wsUrl = 'wss://';
        }
        var ws = new WebSocket(wsUrl + window.location.host + "/Bogdan_Milojevic_61_2021_PDS_PROJEKAT_war_exploded/chatServer");

        ws.onmessage = function (event) {
            var mySpan = document.getElementById("chat");
            mySpan.innerHTML += event.data + "<br/>";
            scrollToBottom();
        };

        ws.onerror = function (event) {
            console.log("Error ", event)
        }

        function sendMsg() {
            var msg = document.getElementById("msg").value;
            if (msg) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "SaveMessageServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            console.log("Message saved successfully.");
                        } else {
                            console.error("Error saving message:", xhr.statusText);
                        }
                    }
                };
                var params = "message=" + encodeURIComponent(msg);
                xhr.send(params);


                var currentTime = new Date();
                var formattedTime = currentTime.getFullYear() + "-" +
                    String(currentTime.getMonth() + 1).padStart(2, '0') + "-" +
                    String(currentTime.getDate()).padStart(2, '0') + " " +
                    String(currentTime.getHours()).padStart(2, '0') + ":" +
                    String(currentTime.getMinutes()).padStart(2, '0') + ":" +
                    String(currentTime.getSeconds()).padStart(2, '0');

                var formattedMsg = username + ": " + msg +
                    "<span style='float: right;'>" + formattedTime + "</span>";

                ws.send(formattedMsg);
            }
            document.getElementById("msg").value = "";

        }

        function scrollToBottom() {
            var chat = document.getElementById("chat");
            chat.scrollTop = chat.scrollHeight;
        }

        window.onload = function () {
            scrollToBottom();
        };



        function openPopup() {
            var popup = document.getElementById('popup');
            popup.style.display = 'block';
        }

        function closePopup() {
            var popup = document.getElementById('popup');
            popup.style.display = 'none';
        }

    </script>
    <%
        String username = "";
        User user = new User();
        UserDAO userDao = new UserDAO();
        if (session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
            user = userDao.getUserByUsername(username);
        }
        boolean isAdmin = false;
        if(session.getAttribute("isAdmin") != null){
            isAdmin = (boolean)session.getAttribute("isAdmin");
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
                <li><a class="selektovano" href="chat.jsp">CHAT</a></li>
                <div class="right-menu">
                    <% if (!username.equals("")) { %>
                    <li>
                        <a id="username" href="profil.jsp">
                            <img src="<%= user.getProfilePicturePath() %>" alt="Profilna slika" style="width: 20px; height: 20px; padding-right: 5px; border-radius: 50%;">
                            <%= username %>
                        </a>
                    </li>
                    <% if (isAdmin) { %>
                    <li><a href="admin-panel.jsp">ADMIN PANEL</a></li>
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
    <p>Stranica za četovanje. Na ovoj stranici ulogovani korisnik može razmenjivati utiske i mišljenja sa drugim korisnicima, dok gosti nemaju mogućnost slanja poruka.</p>
    <button onclick="closePopup()">Zatvori</button>
</div>
<div class="content">
    <div class="chat-container">
            <div id="chat" class="chat">
                <%
                    ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
                    List<ChatMessage> poruke=chatMessageDAO.getAllMessages();
                    for (ChatMessage poruka : poruke) {
                        out.println(poruka.getUser().getName() + ": " + poruka.getContent() +
                                "<span style='float: right;'>" + poruka.getTime() + "</span><br>");
                    }


                %>
            </div>
            <div>
                <%
                    if(session.getAttribute("username")!=null){
                %>
                <input type="text" name="msg" id="msg" placeholder="Enter message here"/>
                <button onclick="return sendMsg();">Enter</button>
                <%
                    }if(session.getAttribute("username")==null){
                %>
                <input type="text" name="msg" id="msg" placeholder="Morate biti ulogovani." disabled/>
                <%
                    }
                %>
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
