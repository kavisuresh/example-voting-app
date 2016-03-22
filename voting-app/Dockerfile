FROM websphere-liberty:kernel
RUN apt-get update -qq && apt-get install -y maven && apt-get clean
WORKDIR /app
ADD pom.xml /app/pom.xml

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
RUN ["mvn", "dependency:resolve"]

# Adding source, compile and package into a fat jar
ADD . /app
RUN ["mvn", "package"]

RUN cp /app/target/VotingApp.war /opt/ibm/wlp/usr/servers/defaultServer/apps/
COPY server.xml /opt/ibm/wlp/usr/servers/defaultServer/

ENV JAVA_HOME=/opt/ibm/java
RUN installUtility install --acceptLicense defaultServer
