FROM store/oracle/serverjre:8 AS development

# Set the /usr/src directory as the WORKING_DIR:
WORKDIR /usr/src

# Set the /usr/src directory as HOME: (So shell history is saved within our project)
ENV HOME=/usr/src

# Install unzip:
RUN yum install -y unzip

# Install Gradle:
ENV GRADLE_VERSION=5.4.1 GRADLE_USER_HOME=/usr/local/gradle
ENV PATH=/opt/gradle/gradle-$GRADLE_VERSION/bin:$PATH
RUN curl -L -o "gradle-${GRADLE_VERSION}-bin.zip" \
  "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
 mkdir -p /opt/gradle /usr/local/gradle && \
 unzip -d /opt/gradle gradle-5.4.1-bin.zip

CMD ["gradle", "bootRun"]

FROM development AS builder

# Set the /usr directory as the WORKING_DIR:
WORKDIR /usr

COPY build.gradle /usr/
COPY src /usr/src

RUN gradle build

FROM store/oracle/serverjre:8 AS release

COPY --from=builder /usr/build/libs/spring-building-a-restful-service-0.1.0.jar .

CMD ["java", "-jar", "spring-building-a-restful-service-0.1.0.jar"]
