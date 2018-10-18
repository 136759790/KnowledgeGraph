# Eureka
> 用作分布式服务的注册中心，提供负载均衡和故障转移。
## Eureka Server
~~~
server 提供服务注册服务，各个节点启动后会在server上进行注册，server的注册表中存储所有的服务注册信息，可在界面查看。
Server集群之间使用复制保持同步，
~~~
## Eureka Client
~~~
Java客户端，简化与Server的交互。
内置负载均衡器，使用轮训算法负载。
和Server保持30s的心跳，三次（90s）无响应的，server剔除掉改服务。
缓存服务信息，server挂掉服务依然可用。
~~~
## 问题
### @EnableDiscoveryClient和@EnableEurekaClient区别
+ @EnableDiscoveryClient 支持多种注册中心，基于spring-commons
+ @EnableEurekaClient 支持eureka，基于eureka