<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <%

        if(session.getAttribute("username")!=null){
            response.sendRedirect("index.jsp");
        }
    %>
</head>
<body>
<div class="background"></div>
<div class="login-spoljasnji">
    <div class="login-unutrasnji">
        <h2>Prijavite se</h2>
        <form method="POST" action="login">
            <label>Korisničko ime:</label>
            <input type="text" id="korisnicko" name="korisnicko" required>
            <label>Lozinka:</label>
            <input type="password" id="sifra" name="sifra" required>
            <button type="submit" id="loginDugme">Prijavi se</button>
        </form>
        <div id="registracijaGost">
            <a id="registracija" href="registracija.jsp">Registruj se</a>
            <a id="gost" href="index.jsp">Nastavi kao gost</a>
        </div>
        <%
            String success = request.getParameter("success");
            if (success != null && success.equals("registered")) {
                out.println("<p style='color:green;'>Uspešno ste se registrovali. Možete se prijaviti.</p>");
            }
        %>
        <% if (request.getParameter("error") != null) { %>
        <p class="error-message">Neuspešan login. Pokušajte ponovo.</p>
        <% } %>
    </div>
</div>

</body>
</html>
