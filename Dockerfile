# Stage 1: Build the application using Gradle
FROM gradle:8.8-jdk11 AS build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle 캐시를 활용하기 위해 먼저 필요한 파일만 복사
COPY build.gradle settings.gradle /app/

# 의존성을 먼저 설치
RUN gradle build --no-daemon || return 0

# 나머지 소스 코드 복사
COPY . /app

# 애플리케이션 빌드
RUN gradle clean build --no-daemon

# Stage 2: Run the application with Tomcat
FROM tomcat:9.0-jdk11

# WAR 파일을 Tomcat으로 복사
COPY --from=build /app/build/libs/sample-login-app.war /usr/local/tomcat/webapps/ROOT.war

# 포트 노출
EXPOSE 8080

# Tomcat 실행
CMD ["catalina.sh", "run"]
