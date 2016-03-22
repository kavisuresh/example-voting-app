FROM websphere-liberty:kernel
RUN apt-get update -qq && apt-get install -y maven && apt-get clean && apt-get -y install openjdk-7-jdk
WORKDIR /app
ADD pom.xml /app/pom.xml

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
RUN ["mvn", "dependency:resolve"]

# Adding source, compile and package into a fat jar
ADD . /app
RUN ["mvn", "package"]

RUN cp /app/target/ResultApp.war /opt/ibm/wlp/usr/servers/defaultServer/apps/
COPY postgresql-9.4-1206.jdbc4.jar  /opt/ibm/wlp/usr/shared/resources/PostgresLibs/
COPY server.xml /opt/ibm/wlp/usr/servers/defaultServer/

ENV JAVA_HOME=/opt/ibm/java
RUN installUtility install --acceptLicense defaultServer
