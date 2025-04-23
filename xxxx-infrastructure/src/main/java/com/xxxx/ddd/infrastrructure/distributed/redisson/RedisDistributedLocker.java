package com.xxxx.ddd.infrastrructure.distributed.redisson;

import java.util.concurrent.TimeUnit;

public interface RedisDistributedLocker {
    //interface for distributed lock
    boolean tryLock(long waitTime, long leaseTime, TimeUnit unit);
    void lock(long leaveTime, TimeUnit unit);
    void unlock();
    boolean isLocked();
    boolean isHeldByThread(long threadId);
    boolean isHeldByCurrentThread();

}
