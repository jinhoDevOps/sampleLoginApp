<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
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
    <h2>Welcome to the Application!</h2>
    <div id="dbStatusContainer"></div>
    <button onclick="refreshDBStatus()">Refresh DB Status</button>
    <h3>User List</h3>
    <table border="1">
        <tr>
            <th>Username</th>
            <th>Email</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://db:3306/sampledb", "user", "userpassword");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT username, email FROM users");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("username") + "</td>");
                    out.println("<td>" + rs.getString("email") + "</td>");
                    out.println("</tr>");
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("Database error: " + e.getMessage());
            }
        %>
    </table>
    <form action="logout" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>