# 샘플 로그인 애플리케이션

## 소개
이 프로젝트는 간단한 회원가입/로그인 기능을 제공하는 톰캣 애플리케이션을 Docker와 Docker Compose로 패키징하는 과정을 설명합니다. Gradle 프로젝트를 IntelliJ로 생성하고, JDK 11을 사용하며, MySQL 8 컨테이너와 연동합니다.

> 빠른 사용을 원하시면 [배포 방법](#배포-방법) 섹션을 참조하세요.

## 목차
1. [프로젝트 구조](#1-프로젝트-구조)
2. [프로젝트 설정](#2-프로젝트-설정)
3. [애플리케이션 요약](#3-애플리케이션-요약)
4. [Docker 설정](#4-docker-설정)
5. [배포 방법](#5-배포-방법)
6. [샘플 데이터베이스 관리](#6-샘플-데이터베이스-관리)

## 1. 프로젝트 구조
```
sample-login-app/
├── src/
│   └── main/
│       ├── java/
│       │   └── org/
│       │       └── example/
│       │           ├── main/
│       │           │   └── Main.java
│       │           └── servlet/
│       │               ├── LoginServlet.java
│       │               ├── LogoutServlet.java
│       │               └── DBStatusServlet.java
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   └── dbstatus.jsp
│           ├── login.jsp
│           └── welcome.jsp
├── build.gradle
├── Dockerfile
├── docker-compose.yml
└── init.sql
```

## 2. 프로젝트 설정
### `build.gradle`
```groovy
plugins {
    id 'java'
    id 'war'
}

group 'org.example'
version '1.0-SNAPSHOT'

sourceCompatibility = 11

repositories {
    mavenCentral()
}

dependencies {
    compileOnly 'javax.servlet:javax.servlet-api:4.0.1'
    implementation 'javax.servlet.jsp:javax.servlet.jsp-api:2.3.3'
    implementation 'javax.servlet:jstl:1.2'
    implementation 'mysql:mysql-connector-java:8.0.31'
    testImplementation 'junit:junit:4.13.2'
    implementation 'org.json:json:20210307'
}

tasks.withType(JavaCompile).configureEach {
    options.encoding = 'UTF-8'
}

war {
    archiveFileName = 'sample-login-app.war'
}
```

## 3. 애플리케이션 요약
- `Main.java`: 애플리케이션의 메인 클래스
- 서블릿:
    - `LoginServlet.java`: 로그인 처리
    - `LogoutServlet.java`: 로그아웃 처리
    - `DBStatusServlet.java`: 데이터베이스 상태 확인
- JSP 페이지:
    - `login.jsp`: 로그인 페이지
    - `welcome.jsp`: 로그인 성공 후 메인 페이지
- 설정 파일:
    - `web.xml`: 웹 애플리케이션 설정
    - `dbstatus.jsp`: 데이터베이스 상태 표시

## 4. Docker 설정
### `Dockerfile`
```dockerfile
# Stage 1: Build the application using Gradle
FROM gradle:8.8-jdk11 AS build

WORKDIR /app
COPY build.gradle settings.gradle /app/
RUN gradle build --no-daemon || return 0
COPY . /app
RUN gradle clean build --no-daemon

# Stage 2: Run the application with Tomcat
FROM tomcat:9.0-jdk11
COPY --from=build /app/build/libs/sample-login-app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

### `docker-compose.yml`
```yaml
services:
  db:
    image: mysql:8.0
    container_name: mysql-db
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: sampledb
      MYSQL_USER: user
      MYSQL_PASSWORD: userpassword
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - app-network

  web:
    build: .
    container_name: tomcat-app
    ports:
      - "8080:8080"
    networks:
      - app-network
    depends_on:
      - db

networks:
  app-network:

volumes:
  db_data:
```

## 5. 배포 방법
### 5.1 Docker 설치 (RockyOS)
```bash
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker
```

### 5.2 애플리케이션 배포
```bash
git clone https://github.com/jinhoDevOps/sampleLoginApp.git
cd sampleLoginApp
docker-compose up --build
```

## 6. 샘플 데이터베이스 관리
Docker 볼륨을 사용하여 MySQL 데이터를 영구적으로 저장합니다. 샘플 데이터를 변경하려면:

```bash
docker exec -it mysql-db bash
mysql -u user -p
# 비밀번호 입력: userpassword

USE sampledb;
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email) VALUES
('admin', 'password', 'admin@example.com'),
('alice_williams', 'pass123', 'alice@example.com'),
('bob_johnson', 'secret', 'bob@example.com'),
('charlie_smith', 'secure', 'charlie@example.com'),
('diana_brown', 'p@ssw0rd', 'diana@example.com'),
('edward_davis', 'secretcode654','edward@example.com');
```

> 주의: 컨테이너를 삭제해도 MySQL 데이터는 Docker 볼륨에 저장되어 유지됩니다.

## 라이선스
이 프로젝트는 MIT 라이선스 하에 제공됩니다.
