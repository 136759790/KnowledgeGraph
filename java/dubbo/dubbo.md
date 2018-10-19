# dubbo简介
## 层级
+ config配置层，```ServiceConfig```和```ReferenceConfig ```为中心，可以直接初始化也可以交给spring代理初始化。
> 两端的配置类。

+ proxy 服务代理层：服务接口透明代理，生成服务的客户端 Stub 和服务器端 Skeleton, 以 ServiceProxy 为中心，扩展接口为 ProxyFactory
> 通过接口，在consumer端做动态代理。
+ registry 注册中心层：封装服务地址的注册与发现，以服务 URL 为中心，扩展接口为 RegistryFactory, Registry, RegistryService
> 提供者和消费者从注册中心获取接口的信息数据
+ cluster 路由层：封装多个提供者的路由及负载均衡，并桥接注册中心，以 Invoker 为中心，扩展接口为 Cluster, Directory, Router, LoadBalance
> Consumer端的负载
+ monitor 监控层：RPC 调用次数和调用时间监控，以 Statistics 为中心，扩展接口为 MonitorFactory, Monitor, MonitorService。
> 用来监控的，提供给dubboAdmin。
+ protocol 远程调用层：封装 RPC 调用，以 Invocation, Result 为中心，扩展接口为 Protocol, Invoker, Exporter
> 具体的远程调用的逻辑
+ exchange 信息交换层：封装请求响应模式，同步转异步，以 Request, Response 为中心，扩展接口为 Exchanger, ExchangeChannel, ExchangeClient, ExchangeServer
> 用来交换信息。
+ transport 网络传输层：抽象 mina 和 netty 为统一接口，以 Message 为中心，扩展接口为 Channel, Transporter, Client, Server, Codec
> 用来传输数据。
+ serialize 数据序列化层：可复用的一些工具，扩展接口为 Serialization, ObjectInput, ObjectOutput, ThreadPool
> 对象的序列化和反序列化。
## 理解
> dubbo主要角色为Consumer消费端和Provider服务端，只要功能是c端透明调用P端的服务。提供统一接口和类，c代理接口，找服务地址，通过协议调用远程服务。p实现接口，实现业务，注册到中心提供服务。

### 服务端暴露流程
> 服务端启动的时候，实际提供服务的类--->Invoker--->exporter，提供服务。
+ 实际类--->Invoker：ServiceConfig利用factoryProxy生成Invoker
~~~
//ServiceConfig 利用proxyFactory生成Invoker
Invoker<?> invoker = proxyFactory.getInvoker(ref, (Class) interfaceClass, registryURL.addParameterAndEncoded(Constants.EXPORT_KEY, url.toFullString()));
~~~
+ Invoker转为Exporter:ServiceConfig利用Protocol生成Exporter，添加到ServiceConfig的exporters中。
~~~
Exporter<?> exporter = protocol.export(wrapperInvoker);
exporters.add(exporter);
~~~
### 服务消费者消费服务的过程
> 服务根据ReferenceConfig调用Protocol中的refer()方法生成Invoker，Invoker被ProxyFactory生成需要的接口。
+ ReferenceConfig获取Invoker
~~~
//init方法生成代理，调用Protocol生成代理
invoker = refprotocol.refer(interfaceClass, url);
~~~
+ Invoker--->代理，createProxy()生成代理类
~~~
//调用jdk动态代理，生成代理。
proxyFactory.getProxy(invoker)
~~~
#### 服务端Invoker和消费端Invoker
+ 消费端，用户代码-->proxy--->Invoker,这个Invoker是封装了远程调用的动作，包括各种协议解析和远程传输。
+ 服务端，exporter-->Invoker-->服务实现，封装调用本地服务，传给exporter提供对外服务。
## dubbo超时机制
+ 针对消费端，消费端发起请求后得到一个ResponseFuture，然后不断轮训这个future，超时了异常。
+ 配置方式：消费端和提供端都能配置，优先级第一层：消费者优于提供者，第二层：实现类优于接口优于全局配置。原理同样是利用lock+condition做的阻塞。
+ 和服务降级联合使用，当超时异常一般两种解决方案。
   + 捕获异常，根据错误信息返回不同的错误码，消费端根据错误码做相对和逻辑。
   + 发生异常，服务端做降级，返回mock对象。
## ExceptionFilter
> 服务自定义异常抛给全局异常处理器做相应处理。
+ 受检异常直接抛出
+ 方法签名有异常，直接抛出
+ 接口和异常在同一个jar中，直接抛出（接口+Pojo+自定义异常写到api包里边）
+ JDK异常直接抛出。
+ RPC异常（dubbo定义的全局异常）直接抛出。
+ 否则返回包装的RPC异常。