package org.example.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/dbstatus")
public class DBStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status;
        String currentTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"))
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss z"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://db:3306/sampledb", "user", "userpassword");
            status = "Connected";
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            status = "Disconnected: " + e.getMessage();
        }

        req.setAttribute("dbStatus", status);
        req.setAttribute("currentTime", currentTime);
        req.getRequestDispatcher("/WEB-INF/dbstatus.jsp").forward(req, resp);
    }
}