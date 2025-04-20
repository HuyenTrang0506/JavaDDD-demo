package com.xxxx.ddd.infrastrructure.persistency.repository;

import com.xxxx.ddd.domain.repository.HiDomainRepository;
import org.springframework.stereotype.Service;

@Service
public class HiDomainRepositoryImpl implements HiDomainRepository {
    @Override
    public String sayHi(String who) {
        return "Hi infrastructure ";
    }
}
