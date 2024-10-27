<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Letovanja</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <% if(session.getAttribute("username")!=null){
        response.sendRedirect("index.jsp");
    } %>
</head>
<body>
<div class="background"></div>
<div class="register-spoljasnji">
    <div class="register-unutrasnji">
        <h2>Registracija</h2>
        <form action="register" method="POST">
            <label for="name">Ime:</label>
            <input type="text" id="name" name="name" required>
            <br>
            <label for="lastName">Prezime:</label>
            <input type="text" id="lastName" name="lastName" required>
            <br>
            <label for="email">E-mail:</label>
            <input type="email" id="email" name="email" required>
            <br>
            <label for="username">Korisničko ime:</label>
            <input type="text" id="username" name="username" required>
            <br>
            <label for="password">Lozinka:</label>
            <input type="password" id="password" name="password" required>
            <br>
            <label for="confirmPassword">Potvrdite lozinku:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
            <br>
            <button type="submit">Registrujte se</button>
        </form>
        <div id="registracijaGost">
            <a id="registracija" href="login.jsp">Uloguj se</a>
            <a id="gost" href="index.jsp">Nastavi kao gost</a>
        </div>
        <% String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("missing_fields")) {
                    out.println("<p style='color:red;'>Molimo popunite sva polja.</p>");
                } else if (error.equals("password_mismatch")) {
                    out.println("<p style='color:red;'>Lozinke se ne podudaraju.</p>");
                } else if (error.equals("database_error")) {
                    out.println("<p style='color:red;'>Došlo je do greške pri unosu u bazu podataka.</p>");
                }
                else if (error.equals("username_exists")) {
                    out.println("<p style='color:red;'>Korisnik sa ovim korisnickim imenom vec posotji.</p>");
                }
            }
        %>
    </div>
</div>
</body>
</html>
