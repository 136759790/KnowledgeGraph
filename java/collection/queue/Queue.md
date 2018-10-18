# java自带的队列
## 操作特征
|操作|抛异常|特殊值|阻塞|超时|
|---|---|---|---|---|
|插入|add(e)|offer(e)|put(e)|offer(e,time,unit)|
|删除|remove()|poll()|take()|poll(time,unit)|
|检查|element()|peek()|x|x|
## 阻塞队列原理
> 内置两个锁和两个condition，添加的时候满了（count：atomicInteger 判断）的时候notFull await，take取走后唤醒notFull，让其执行。反之同理。

|属性|作用|
|---|---|
|takeLock|从队列取加锁|
|takeLock.notEmpty|阻塞取的线程|
|putLock|队列加元素锁|
|putLock.notFull|阻塞加的线程|
~~~
    public boolean offer(E e, long timeout, TimeUnit unit) throws InterruptedException {
        if (e == null) throw new NullPointerException();
        //转为纳秒
        long nanos = unit.toNanos(timeout);
        int c = -1;
        final ReentrantLock putLock = this.putLock;
        final AtomicInteger count = this.count;
        putLock.lockInterruptibly();//加锁
        try {
            while (count.get() == capacity) {
                if (nanos <= 0)
                    return false;
                // notFullCondition 等待指定时间或者其他condition唤醒。
                nanos = notFull.awaitNanos(nanos);
            }
            enqueue(new Node<E>(e));
            c = count.getAndIncrement();
            if (c + 1 < capacity)
                notFull.signal();
        } finally {
            putLock.unlock();
        }
        if (c == 0)
            signalNotEmpty();
        return true;
    }
~~~