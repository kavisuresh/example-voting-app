FROM java:7

RUN apt-get update -qq && apt-get install -y maven && apt-get clean

WORKDIR /code

COPY db2*jar og*jar /code/lib/

ADD pom.xml /code/pom.xml

RUN mvn install:install-file -DlocalRepositoryPath=lib -DcreateChecksum=true -Dpackaging=jar -Dfile=/code/lib/db2jcc_license_cu.jar -DgroupId=com.ibm.db2.jcc -DartifactId=db2jcc_license_cu -Dversion=3.63.123

RUN mvn install:install-file -DlocalRepositoryPath=lib -DcreateChecksum=true -Dpackaging=jar -Dfile=/code/lib/db2jcc4.jar -DgroupId=com.ibm.db2.jcc -DartifactId=db2jcc4 -Dversion=3.63.123

RUN mvn install:install-file -DlocalRepositoryPath=lib -DcreateChecksum=true -Dpackaging=jar -Dfile=/code/lib/ogclient.jar -DgroupId=wxs -DartifactId=ogclient -Dversion=8.6.0.8

RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]

# Adding source, compile and package into a fat jar
ADD src /code/src
RUN ["mvn", "package"]

CMD ["/usr/lib/jvm/java-7-openjdk-amd64/bin/java", "-jar", "target/worker-jar-with-dependencies.jar"]
