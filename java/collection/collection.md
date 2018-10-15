# Java集合框架
~~~
                List
collection      Queue
                Set
                HashMap
map             SortedMap
                
~~~
## HashMap [传送门](http://www.importnew.com/28263.html)
> HashTable，ConcurrentHashMap，collections.synchronizedMap区别。
+ HashTable:所有方法都是同步的。
+ synchronizedMap：返回一个SynchronizedMap对象，也是利用synchronized关键字保证安全的。
+ concurrentHashMap：分段加锁技术。
   + jdk1.7：由segment数组构成，segment继承自ReentrantLock，利用其加锁，每次锁住的是一个segment，默认16个segment，初始化完成后不可扩容。put操作根据哈希值获取segment，然后再在内部put。