#!/bin/bash
docker stop redis-6000 redis-6001 redis-6002 redis-6003 redis-6004 redis-6005
docker rm redis-6000 redis-6001 redis-6002 redis-6003 redis-6004 redis-6005
rm -rf 6000 6001 6002 6003 6004 6005
