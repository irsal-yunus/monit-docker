#!/bin/bash

# checking container_id web docker
source $HOME/.bashrc 2> /dev/null
DIR_DOCKER=/docker/docker-compose.yml
PID_CONTAINER=/docker/pid/
P_FILE_RABBIT=$CONTAINER_RABBIT.pid
STATUS=$3
CONTAINER_RABBIT=mbsuiterabbit



CONTAINER_LIST_PID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep -E -v "docker_*" | awk '{print $1}'`
CONTAINER_LIST_NAME=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep -E -v "docker_*" | awk -F'/' '{print $2}'`
CONTAINER_LIST_PROSESS=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep -E -v "docker_*" | awk -F'/' '{print $2}' | wc -l`
CONTAINER_LIST_ID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.ID}}' | awk '{print substr($3,1,12)}'`
CONTAINER_LIST_STATUS=`docker ps -q| xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.State.Status}}' | awk '{print $3}'`

# for container rabbit
CONTAINER_RABBIT_PID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep $CONTAINER_RABBIT | awk '{print $1}'`
CONTAINER_RABBIT_NAME=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep $CONTAINER_RABBIT | awk -F'/' '{print $2}'`
CONTAINER_RABBIT_PROSESS=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep $CONTAINER_RABBIT | grep -E -v "docker_*" | awk -F'/' '{print $2}' | wc -l`
CONTAINER_RABBIT_ID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.ID}}' | grep $CONTAINER_RABBIT | awk '{print substr($3,1,12)}'`
CONTAINER_RABBIT_STATUS=`docker ps -q| xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.State.Status}}' | grep $CONTAINER_RABBIT | awk '{print $3}'`


case "$1" in 
start)   
      if [ $CONTAINER_RABBIT_PROSESS -eq 0 ]; then
         docker-compose -f $DIR_DOCKER up -d
         sleep 5          
         echo -e "Service \e[32m mbsuiterabbit is up..\e[0m"        
         docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep mbsuiterabbit | awk '{print $1}' > /docker/pid/$P_FILE_RABBIT;
         # sleep 6
         # echo -e "\e[32m PID $CONTAINER_WEB_NAME: $CONTAINER_WEB_PID\e[0m"
         # echo -e "\e[32m PID $CONTAINER_APP_NAME: $CONTAINER_APP_PID\e[0m"
         # echo -e "\e[32m PID $CONTAINER_RABBIT_NAME: $CONTAINER_RABBIT_PID\e[0m"
         
      else         
         echo -e "\e[32m PID $CONTAINER_RABBIT_NAME: $CONTAINER_RABBIT_PID \e[0m"
         echo -e "\e[32m Service $CONTAINER_RABBIT_NAME already Running.. \e[0m"
      fi  
   ;;
stop)
         
         if [ $CONTAINER_RABBIT_PROSESS -eq 0 ]; then	          	        
	         # stop container rabbit	         
	         echo -e "Service \e[91m mbsuiterabbit Not running.. \e[0m"
         
     	 else     	 	 
	         # stop container rabbit
	         kill -9 $CONTAINER_RABBIT_PID
	         cd $PID_CONTAINER
	         rm -rf $P_FILE_RABBIT;
	   		 echo -e "Service \e[91m $CONTAINER_RABBIT_NAME was Killed..\e[0m"
	   	 fi
   ;;
restart)
         $0 stop
         $0 start
   ;;
status)   

      if [ $CONTAINER_RABBIT_PROSESS -eq 0 ]; then         
         echo -e "Service \e[91m mbsuiterabbit is Down.. \e[0m"
      else        
         echo -e "Service \e[32m $CONTAINER_RABBIT_NAME is Up.. PID: $CONTAINER_RABBIT_PID \e[0m"
      fi
      ;;
*)
         echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 