Redis cluster image just for test purpose.

It start 6 instances (3 masters, 3slaves, port 7000-7005) in same container.

Currently only work in linux system and only support client connect from localhost.

use this command to start it:
```
docker run --rm -it -p 7000-7005:7000:7005 --net=host areyouok/redis-cluster
```