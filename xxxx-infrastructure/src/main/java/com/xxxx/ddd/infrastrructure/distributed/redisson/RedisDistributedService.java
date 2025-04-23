package com.xxxx.ddd.infrastrructure.distributed.redisson;

public interface RedisDistributedService {
    RedisDistributedLocker getDistributedLock(String lockKey);
}
