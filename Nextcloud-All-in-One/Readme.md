###
STOP ALL CONTAINERS 
sudo docker stop $(sudo docker ps -q --filter "name=nextcloud-aio-")
sudo docker ps --filter "status=exited"
sudo docker container prune
sudo docker network rm nextcloud-aio
sudo docker volume ls --filter "dangling=true"
sudo docker volume prune --filter all=1
