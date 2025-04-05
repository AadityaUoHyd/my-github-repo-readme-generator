FROM eclipse-temurin:21-alpine
VOLUME /tmp
COPY target/my-github-repo-readme-generator-0.0.1-SNAPSHOT.jar my-github-repo-readme-generator.jar
ENTRYPOINT ["java","-jar","/my-github-repo-readme-generator.jar"]
