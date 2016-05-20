#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Container.sh                                                 #
#                                                                                   #
#  Usage : startContainer.sh                                                        #
#                                                                                   #
#####################################################################################

#Check whether catalog server name is provided or use default
if [ "$CONTAINER_NAME" = "" ]
then
    CONTAINER_NAME="C1"
fi

#Check whether catalog server name is provided or use default
if [ "$CATALOG_ENDPOINTS" = "" ]
then
    CATALOG_ENDPOINTS="wxs:2809"
fi

#Get the container hostname
 host=`hostname`

/opt/ibm/wxs/ObjectGrid/bin/startXsServer.sh $CONTAINER_NAME -objectGridFile /work/objectGrid.xml -serverProps /work/containerServer.props -deploymentPolicyFile /work/objectGridDeployment.xml -catalogServiceEndpoints $CATALOG_ENDPOINTS  -listenerPort 30110

if [ $? != 0 ]
then
    echo " Container startup failed , exiting......"
    exit 1
fi

while [ `ps -eaf | grep $CONTAINER_NAME | wc -c` -gt 65  ]
do
  sleep 10
done
