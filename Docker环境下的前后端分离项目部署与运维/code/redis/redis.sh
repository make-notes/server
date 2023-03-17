#!/bin/bash

#在/redis-cluster下生成conf和data目标，并生成配置信息
for port in `seq 6000 6005`; 
do 
  mkdir -p ./${port}/conf && PORT=${port} envsubst < ./redis-cluster.conf > ./${port}/conf/redis.conf && mkdir -p ./${port}/data;
done

#创建6个redis容器
for port in `seq 6000 6005`;
do
  docker run -d -it -p ${port}:${port} -p 1${port}:1${port} -v /home/soft/redis-cluster/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf -v /home/soft/redis-cluster/${port}/data:/data --restart always --name redis-${port} --net redis-net --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf;
done

#查找ip
for port in `seq 6000 6005`;
do
  echo  -n "$(docker inspect --format '{{ (index .NetworkSettings.Networks "redis-net").IPAddress }}' "redis-${port}")":${port}" ";
done

#换行
echo -e "\n"

#输入信息
read -p "请把输入要启动的docker容器名称，默认redis-6000：" DOCKER_NAME

#判断是否为空
if [ ! $DOCKER_NAME ]; 
  then DOCKER_NAME='redis-6000'; 
fi

#进入容器
docker exec -it redis-6000 /bin/bash
