#!/bin/bash
declare network=janfish
declare pwd=`pwd`
declare pn=${1:-lnmp}
if [ "`docker network ls | grep $network | awk '{print $2}'`" != "$network" ] ; then
   docker network create $network
fi
docker-compose -p $pn -f $pwd/lnmp72/docker-compose.yml up --build -d
echo
echo "======================== your bootstrap script: ========================"
echo
echo " docker-compose -p $pn -f $pwd/lnmp72/docker-compose.yml up -d"
echo
echo "========================================================================"