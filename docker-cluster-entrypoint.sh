#!/bin/sh
set -e
 
waitStart(){
  echo check redis-server $port
  while true
  do
    sleep 0.1
    redis-cli -p $1 ping > /dev/null
    if [ $? -eq 0 ]; then
      echo redis has started on port $1
      break
    fi
  done
}

for port in $( seq 7000 7005 )
do
  redisdata="/data/redis"$port
  # can't create sub dir after VOLUME instruction in Dockerfile, so we create them in shell script
  if [ ! -d  $redisdata ]; then
    mkdir "$redisdata"
  fi
  chown redis:redis ${redisdata}
  cd ${redisdata}
  echo starting redis-server $port
  gosu redis redis-server /etc/redisclusterconf/${port}/redis.conf > /var/log/redis${port} 2>&1 &
  waitStart ${port}
done

echo "yes" | redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005

tail -f /var/log/redis7000 /var/log/redis7001 /var/log/redis7002 /var/log/redis7003 /var/log/redis7004 /var/log/redis7005

