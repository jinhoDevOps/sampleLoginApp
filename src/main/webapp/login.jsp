<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
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
    <h2>Login Page</h2>
    <div id="dbStatusContainer">
        <h3>Database Status</h3>
        <p>Current Time: <span id="currentTime"></span></p>
        <p>Status: <span id="dbStatus"></span></p>
    </div>
    <button onclick="throttledRefresh()">Refresh DB Status</button>
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