# Treemap
## 基本知识
+ TreeMap 是一个有序的key-value集合，它是通过红黑树实现的。
+ TreeMap 继承于AbstractMap，所以它是一个Map，即一个key-value集合。
+ TreeMap 实现了NavigableMap接口，意味着它支持一系列的导航方法。比如返回有序的key集合。
+ TreeMap 实现了Cloneable接口，意味着它能被克隆。
+ TreeMap 实现了java.io.Serializable接口，意味着它支持序列化。
+ ```TreeMap内部结构基于红黑树，按照键的自然顺序排序，或者根据构造方法中的排序器```。
~~~
//自然键顺序排序
TreeMap t =new TreeMap();
		t.put(3, "1");
		t.put(1, "3");
		t.put(2, "2");
System.out.println(t.toString());
//根据排序器
TreeMap t =new TreeMap(new Comparator<User>() {
			@Override
			public int compare(User u1, User u2) {
				return u1.getAge() - u2.getAge();
			}
		});
t.put(new User(1, "jim", 15), "1");
t.put(new User(2, "jim", 19), "1");
t.put(new User(3, "jim", 18), "1");
System.out.println(t.toString());
~~~
+ 如何对值进行排序
   + treemap实现了comparable接口
   + 转成List，用collections.sort排序。