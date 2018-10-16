# Lock
## synchronized的对比
|类别 |synchronized | Lock |
|----| ------ | ------ |
|层面 | JVM层面 | 对线层面|
|释放锁|异常中断、代码执行完成|必须手动释放|
|获取锁|获取不到一直等待|尝试获取，可以加超时时间|
|粒度|粗，不存在读写锁|细，可分为读写锁|

## 接口
~~~
1. void lock() 获取锁，获取不到一直等待。不支持其他线程调用本线程的interrupt()方法中断获取锁。
2. boolean tryLock() 获取锁，获取不到返回fals。
3. boolean tryLock(long time, TimeUnit unit)  获取锁，等待一定时间，获取不到返回false。
4. void unlock() 释放锁。必须手动释放锁。
5. void lockInterruptibly()支持其他线程调用interrupt()方法中断本线程继续获取锁，本线程放弃获取锁，抛出异常。
~~~
## ReentrantLock可重入锁
> java Lock最常用的锁类型，一个线程可多次获取同一个锁。获取多次会在state上加一。默认是非公平锁，性能好。
+ 公平锁（FairSync），根据构造方法传参确定是否公平锁，
~~~
Lock lock_fair = new ReentrantLock(true);
~~~
+ 非公平锁（NonFairSync）
~~~
Lock lock_fair = new ReentrantLock();//默认非公平
~~~
+ 公平锁的实现方式
~~~
通过队列实现。
~~~
## lock的Condition
~~~
Condition c1 = lock.newCondition();
1、一个lock可以创建任意个condition对象。
2、同一lock的condition，可以通过await()和signal()进行通信。
~~~
## 死锁
### 死锁条件