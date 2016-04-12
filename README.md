Example Voting App
==================

This is an example Docker app with multiple services. It is run with Docker Compose and uses Docker Networking to connect containers together. You will need Docker Compose 1.6 or later.

More info at https://blog.docker.com/2015/11/docker-toolbox-compose/

Architecture
-----

* A Java webapp which runs in WebSphere Liberty lets you vote between two options
* A WebSphere Extreme Scale cache which collects new votes
* A Java worker which consumes votes and stores them in a database
* A DB2 database backed by a Docker volume
* A Java webapp which runs in WebSphere Liberty shows the results of the voting in real time

Running
-------

Run in this directory:

    $ docker-compose up

The app will be running on port 5000 on your Docker host, and the results will be on port 5001.

