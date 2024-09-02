<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Welcome to the Application!</h2>

    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String connectionStatus = "Not connected";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://db:3306/sampledb", "user", "userpassword");
            connectionStatus = "Connected successfully";

            pstmt = conn.prepareStatement("SELECT * FROM users");
            rs = pstmt.executeQuery();
    %>

    <h3>Current Time: <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) %></h3>
    <h3>Database Connection Status: <%= connectionStatus %></h3>

    <h3>User List:</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Created At</th>
        </tr>
        <% while(rs.next()) { %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>
        <% } %>
    </table>

    <%
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {
                out.println("Error closing resources: " + e.getMessage());
            }
        }
    %>
</body>
</html>