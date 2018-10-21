# SpringCache
## 注解
+ Cacheable ：读的时候判断是否有缓存，有直接返回，没有数据库获得，再缓存起来，返回结果。
~~~
@Cacheable(value = "models", key = "#testModel.name", condition = "#testModel.address !=  '' ")
// value：缓存的存储名称空间。
// key:缓存中的具体key
// condition: 表示什么情况下才对数据进行缓存
~~~
+ CacheEvict：失效缓存结果。
~~~
@CacheEvict(value = "models", allEntries = true)
@Scheduled(fixedDelay = 10000)
//value：命名空间。
//allEntries：是否删除命名下所有的缓存，默认false。
//key：同Cacheable
~~~
+ @CachePut:先执行方法，然后将返回值放回缓存。可以用作缓存的更新。
## 与redis整合
+ @EnableCaching //加上这个注解是的支持缓存注解
+ 创建管理器
~~~
@Bean
    public RedisCacheManager cacheManager() {
        RedisCacheManager redisCacheManager = new RedisCacheManager(redisTemplate());
        return redisCacheManager;
    }
~~~