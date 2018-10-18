# ConcurrentHashMap
## jdk1.7
分段加锁，默认提供16个segment（相当于16个小hashmap），每个segment上加锁，segment不能扩容，只能扩容segment中的数组大小。
## jdk1.8
相对于1.7有两个变动
+ 直接用transient volatile HashEntry<K,V>[] table保存数据，在数组元素上加锁，进一步减少冲突概率。
+ 数组+链表变成数组+链表/红黑树（个数超过8个）。