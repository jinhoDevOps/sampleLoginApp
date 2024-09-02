<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function refreshDBStatus() {
            $.get("dbstatus", function(data) {
                $("#dbStatusContainer").html(data);
            });
        }
        $(document).ready(function() {
            refreshDBStatus();
        });
    </script>
</head>
<body>
    <h2>Login Page</h2>
    <div id="dbStatusContainer"></div>
    <button onclick="refreshDBStatus()">Refresh DB Status</button>
    <form action="login" method="post">
        Username: <input type="text" name="username"><br>
        Password: <input type="password" name="password"><br>
        <input type="submit" value="Login">
    </form>
    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">Invalid username or password</p>
    <% } %>
</body>
</html>