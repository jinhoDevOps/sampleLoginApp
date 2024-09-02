<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    var lastRefreshTime = 0;
    var refreshInterval = 5000; // 5초
    var throttleDelay = 1000; // 1초

    function throttle(callback, delay) {
        return function() {
            var now = new Date().getTime();
            if (now - lastRefreshTime < delay) {
                return;
            }
            lastRefreshTime = now;
            callback.apply(null, arguments);
        };
    }

    function refreshDBStatus() {
        $.ajax({
            url: "dbstatus",
            method: "GET",
            dataType: "json",
            success: function(data) {
                $("#dbStatus").text(data.status);
                $("#currentTime").text(data.time);
                if (data.status.startsWith("Connected")) {
                    refreshUserList();
                } else {
                    $("#userList").html("<tr><td colspan='2'>Database connection failed. Unable to fetch user list.</td></tr>");
                }
            },
            error: function() {
                $("#dbStatus").text("Error checking database status");
                $("#currentTime").text(new Date().toLocaleString("en-US", {timeZone: "Asia/Seoul"}));
                $("#userList").html("<tr><td colspan='2'>Error checking database status. Unable to fetch user list.</td></tr>");
            }
        });
    }

    function refreshUserList() {
        $.ajax({
            url: "userlist",
            method: "GET",
            dataType: "json",
            success: function(data) {
                var userListHtml = "";
                for (var i = 0; i < data.length; i++) {
                    userListHtml += "<tr><td>" + data[i].username + "</td><td>" + data[i].email + "</td></tr>";
                }
                $("#userList").html(userListHtml);
            },
            error: function() {
                $("#userList").html("<tr><td colspan='2'>Error fetching user list</td></tr>");
            }
        });
    }

    var throttledRefresh = throttle(refreshDBStatus, throttleDelay);

    $(document).ready(function() {
        refreshDBStatus();
        setInterval(refreshDBStatus, refreshInterval);
    });
</script>
</head>
<body>
    <h2>Welcome to the Application!</h2>
    <div id="dbStatusContainer">
        <h3>Database Status</h3>
        <p>Current Time: <span id="currentTime"></span></p>
        <p>Status: <span id="dbStatus"></span></p>
    </div>
    <button onclick="throttledRefresh()">Refresh DB Status</button>
    <h3>User List</h3>
    <table border="1">
        <tr>
            <th>Username</th>
            <th>Email</th>
        </tr>
        <tbody id="userList">
        </tbody>
    </table>
    <form action="logout" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>