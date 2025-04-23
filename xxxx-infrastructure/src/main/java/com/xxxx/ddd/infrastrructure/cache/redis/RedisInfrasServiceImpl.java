package com.xxxx.ddd.infrastrructure.cache.redis;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.Optional;

@Component
@Slf4j
public class RedisInfrasServiceImpl implements RedisInfrasService {
    @Resource
    private RedisTemplate<String, Object> redisTemplate;


    @Override
    public void setString(String key, String value) {
        if (!StringUtils.hasLength(key)) {
            return;
        }
        redisTemplate.opsForValue().set(key, value);
    }

    @Override
    public String getString(String key) {
        return Optional.ofNullable(redisTemplate.opsForValue().get(key))
                .map(Object::toString)
                .orElse(null);
    }

    @Override
    public void setObject(String key, Object value) {
        if (!StringUtils.hasLength(key)) {
            return;
        }
        try {
            redisTemplate.opsForValue().set(key, value);
        } catch (Exception e) {
            log.error("Redis setObject error, key: {}, value: {}", key, value, e);
        }
    }

    @Override
    public <T> T getObject(String key, Class<T> targetClass) {
        Object result = redisTemplate.opsForValue().get(key);
        log.info("Get cache: {}", result);
        if (result == null) {
            return null;
        }
        //if result is linkedHashMap, convert it to targetClass
        if (result instanceof Map) {
            try {
                //convert Map to targetClass
                ObjectMapper objectMapper = new ObjectMapper();
                return objectMapper.convertValue(result, targetClass);
            } catch (IllegalArgumentException e) {
                log.error(" error converting linkedlistMap to object, key: {}, value: {}", key, result, e);
                return null;
            }
        }
        if(result instanceof String){
            try {
                //convert String to targetClass
                ObjectMapper objectMapper = new ObjectMapper();
                return objectMapper.readValue((String) result, targetClass);
            } catch (Exception e) {
                log.error(" error converting string to object, key: {}, value: {}", key, result, e);
                return null;
            }
        }
        return null;
    }
}