#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to stop the Catalog server                                                #
#                                                                                   #
#  Usage : stopCatalogServer.sh                                                     #
#                                                                                   #
#####################################################################################

#Check whether catalog server name is provided or use default
if [ "$CATALOG_SERVER_NAME" = "" ]
then
    CATALOG_SERVER_NAME="Catalog01"
fi

#Get the container hostname
 host=`hostname`


# stop the catalog
/opt/ibm/wxs/ObjectGrid/bin/xscmd.sh -cep $host:2809 -c teardown -s $CATALOG_SERVER_NAME -f
