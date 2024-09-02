<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Connection Check</title>
</head>
<body>
    <h2>Database Connection Status</h2>

    <%
        Connection conn = null;
        String connectionStatus = "Not connected";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://db:3306/sampledb", "user", "userpassword");
            connectionStatus = "Connected successfully";
        } catch(Exception e) {
            connectionStatus = "Connection failed: " + e.getMessage();
        } finally {
            if(conn != null) {
                try {
                    conn.close();
                } catch(SQLException e) {
                    // 무시
                }
            }
        }
    %>

    <h3>Current Time: <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) %></h3>
    <h3>Database Connection Status: <%= connectionStatus %></h3>

    <form action="check_db.jsp" method="get">
        <input type="submit" value="Refresh">
    </form>

    <br>
    <a href="login.jsp">Go to Login Page</a>
</body>
</html>