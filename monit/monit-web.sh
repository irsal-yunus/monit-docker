#!/bin/bash

# checking container_id web docker
source $HOME/.bashrc 2> /dev/null
DIR_DOCKER=/docker/docker-compose.yml
PID_CONTAINER=/docker/pid/
P_FILE_WEB=$CONTAINER_WEB.pid
STATUS=$3
CONTAINER_WEB=candidate-web




CONTAINER_LIST_PID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep -E -v "docker_*" | awk '{print $1}'`
CONTAINER_LIST_NAME=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep -E -v "docker_*" | awk -F'/' '{print $2}'`
CONTAINER_LIST_PROSESS=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep -E -v "docker_*" | awk -F'/' '{print $2}' | wc -l`
CONTAINER_LIST_ID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.ID}}' | awk '{print substr($3,1,12)}'`
CONTAINER_LIST_STATUS=`docker ps -q| xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.State.Status}}' | awk '{print $3}'`

# for container web
CONTAINER_WEB_PID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep $CONTAINER_WEB | awk '{print $1}'`
CONTAINER_WEB_NAME=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep $CONTAINER_WEB | awk -F'/' '{print $2}'`
CONTAINER_WEB_PROSESS=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'| grep $CONTAINER_WEB | grep -E -v "docker_*" | awk -F'/' '{print $2}' | wc -l`
CONTAINER_WEB_ID=`docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.ID}}' | grep $CONTAINER_WEB | awk '{print substr($3,1,12)}'`
CONTAINER_WEB_STATUS=`docker ps -q| xargs docker inspect --format '{{.State.Pid}} {{.Name}} {{.State.Status}}' | grep $CONTAINER_WEB | awk '{print $3}'`



case "$1" in 
start)   
      if [ $CONTAINER_WEB_PROSESS -eq 0 ]; then
         docker-compose -f $DIR_DOCKER up -d
         sleep 5  
         echo -e "Service \e[32m candidate-web is up..\e[0m"                  
         docker ps -q | xargs docker inspect --format '{{.State.Pid}} {{.Name}}'  | grep candidate-web | awk '{print $1}' > /docker/pid/$P_FILE_WEB;
         
         # sleep 6
         # echo -e "\e[32m PID $CONTAINER_WEB_NAME: $CONTAINER_WEB_PID\e[0m"
         # echo -e "\e[32m PID $CONTAINER_APP_NAME: $CONTAINER_APP_PID\e[0m"
         # echo -e "\e[32m PID $CONTAINER_RABBIT_NAME: $CONTAINER_RABBIT_PID\e[0m"
         
      else
         echo -e "\e[32m PID $CONTAINER_WEB_NAME: $CONTAINER_WEB_PID \e[0m"
         echo -e "\e[32m Service $CONTAINER_WEB_NAME already Running.. \e[0m"         
      fi  
   ;;
stop)
         
         if [ $CONTAINER_WEB_PROSESS -eq 0 ]; then	  
         	 # stop container web       
	         echo -e "Service \e[91m candidate-web Not running.. \e[0m"	         
         
     	 else
     	 	 #docker-compose -f $DIR_DOCKER down
     	 	 # stop container web 
     	 	 kill -9 $CONTAINER_WEB_PID
     	 	 cd $PID_CONTAINER
	         rm -rf $P_FILE_WEB;
	     	   echo -e "Service \e[91m $CONTAINER_WEB_NAME was Killed.. \e[0m"	     	
	   	 fi
   ;;
restart)
         $0 stop
         $0 start
   ;;
status)   

      if [ $CONTAINER_WEB_PROSESS -eq 0 ]; then
         echo -e "Service \e[91m candidate-web is Down.. \e[0m"         
      else
         echo -e "Service \e[32m $CONTAINER_WEB_NAME is Up.. PID: $CONTAINER_WEB_PID \e[0m"         
      fi
      ;;
*)
         echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 