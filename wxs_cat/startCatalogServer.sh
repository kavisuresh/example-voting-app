#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Catalog server                                               #
#                                                                                   #
#  Usage : startCatalogServer.sh                                                    #
#                                                                                   #
#####################################################################################

#Check whether catalog server name is provided or use default
if [ "$CATALOG_SERVER_NAME" = "" ]
then
    CATALOG_SERVER_NAME="Catalog01"
fi

#Get the container hostname
 host=`hostname`

/opt/ibm/wxs/ObjectGrid/bin/startXsServer.sh $CATALOG_SERVER_NAME  -serverProps /work/catalogServer.props -catalogServiceEndPoints $CATALOG_SERVER_NAME:$host:6600:6601 -listenerPort 2809 -JMXServicePort 20210

if [ $? != 0 ]
then
    echo " Catalog Server startup failed , exiting......"
    exit 1
fi

while [ `ps -eaf | grep $CATALOG_SERVER_NAME | wc -c` -gt 65  ]
do
  sleep 10
done
