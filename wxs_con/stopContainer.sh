#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Container.sh                                                 #
#                                                                                   #
#  Usage : startContainer.sh                                                        #
#                                                                                   #
#####################################################################################

#Check whether catalog server name is provided or use default
if [ "$CATALOG_ENDPOINTS" = "" ]
then
    CATALOG_ENDPOINTS="wxs:2809"
fi

# stop the catalog
/opt/ibm/wxs/ObjectGrid/bin/xscmd.sh -cep $CATALOG_ENDPOINTS -c teardown  -f
