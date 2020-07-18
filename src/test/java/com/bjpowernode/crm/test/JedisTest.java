package com.bjpowernode.crm.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml"})
public class JedisTest {

    @Autowired
    private JedisPool jedisPool;

    @Test
    public void test1(){
        Jedis jedis = jedisPool.getResource();
        System.out.println(jedisPool);
        System.out.println(jedis);

        System.out.println(jedis.lrange("name",0,-1));
    }
}
