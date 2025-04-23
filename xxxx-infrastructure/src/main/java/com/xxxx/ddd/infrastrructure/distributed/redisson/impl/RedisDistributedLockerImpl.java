package com.xxxx.ddd.infrastrructure.distributed.redisson.impl;

import com.xxxx.ddd.infrastrructure.distributed.redisson.RedisDistributedLocker;
import com.xxxx.ddd.infrastrructure.distributed.redisson.RedisDistributedService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class RedisDistributedLockerImpl implements RedisDistributedService {
    @Resource
    private RedissonClient redissonClient;

    @Override
    public RedisDistributedLocker getDistributedLock(String lockKey) {
        RLock rLock = redissonClient.getLock(lockKey);
        return new RedisDistributedLocker() {
            @Override
            public boolean tryLock(long waitTime, long leaseTime, TimeUnit unit) {
                try {
                    boolean isLockedSuccess = rLock.tryLock(waitTime, leaseTime, unit);
                    log.info("tryLock: {}, lockKey: {}", isLockedSuccess, lockKey);
                    return isLockedSuccess;
                } catch (InterruptedException e) {
                    log.error("Interrupted while trying to acquire lock for key: {}", lockKey, e);
                    Thread.currentThread().interrupt();
                    return false;
                }
            }

            @Override
            public void lock(long leaveTime, TimeUnit unit) {
               rLock.lock(leaveTime,unit);
            }

            @Override
            public void unlock() {
                if(isLocked()&&isHeldByCurrentThread()) {
                    rLock.unlock();
                }
            }

            @Override
            public boolean isLocked() {
                return rLock.isLocked();
            }

            @Override
            public boolean isHeldByThread(long threadId) {
                return rLock.isHeldByThread(threadId);
            }

            @Override
            public boolean isHeldByCurrentThread() {
                return rLock.isHeldByCurrentThread();
            }
        };

    }
}
