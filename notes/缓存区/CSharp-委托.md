---
title: Socket原理
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. 简介

委托(delegate)是一种存储函数引用的类型。
委托是C#的一个语言级特性，而在Java语言中没有直接的对应，但是java利用反射即可实现委托。

委托最重要的用途在事件和事件处理时才能解释清楚，但这里也将介绍有关委托的许多内容。

委托是一种数据类型，和类是同级别的，我们可以将delegate与class类比：
- class里存放的是一系列方法，属性，字段，事件，索引。
- delegate里存放的是一系列具有相同类型参数和返回回类型的方法的地址的地址。
可以看作为储存方法的载体。

有了引用函数的变量后，就可以执行无法用其他方式完成的操作。
例如，可以把委托变量作为参数传递给-一个函数，这样，该函数就可以使用委托调用它引用的任何函数，而且在运行之前不必知道调用的是哪个函数。下面的示例使用委托访问两个函数中的一个。

> [委托百度百科](https://baike.baidu.com/item/c%23委托/6916387?fr=aladdin)上看的最明白

# 2. 委托的声明

**delegate <函数返回类型> 委托名（函数参数）**   

**例：** `public delegate void myDelegate(string name);`

# 3. 委托的实例化

- **<委托名>实例化名= new <委托名>（注册函数）**

例 : ` myDelegate delegateinstance = new myDelegate(method);`

> 注意：注册函数不包含参数，或者可以直接将一个注册函数赋值给委托

- 匿名方法实例化委托

​        **<委托类型> <实例化名>=delegate(<函数参数>){函数体}**

- 使用lamda表达式实例化委托

实例化例子如下所示：

```c#
class Program   
{     
    //声明委托     
    delegate int MyDelegate(int x, int y);
    static void Main(string[] args)     
    { 
        //实例化委托 
        //1、使用new关键字       
        MyDelegate _myDelegate = new MyDelegate(GetSum);
        //2、使用匿名方法       
        MyDelegate myDelegate = delegate(int x, int y){return x + y;};
        //3、使用Lambda表达式       
        MyDelegate myDelegateLambda = (int x, int y) => { return x + y; };  
    }
    static int GetSum(int x, int y)     
    {       
        return x + y;     
    }   
}
```

# 4.多播委托
实例化委托时必须将一个匹配函数注册到委托上来实例化一个委托对象，但是一个实例化委托不仅可以注册一个函数还可以注册多个函数。注册多个函数后，在执行委托的时候会根据注册函数的注册先后顺序依次执行每一个注册函数。

- 多播委托实际上形成委托链 

  函数注册委托的原型：

  ​			**<委托类型> <实例化名>+=或者-=new <委托类型>(<注册函数>)**
  如果在委托注册了多个函数后，如果委托有返回值，那么调用委托时，返回的将是最后一个注册函数的返回值。
> 注意：委托必须先实例化以后，才能使用+=注册其他方法。如果对注册了函数的委托实例从新使用=号赋值，相当于是重新实例化了委托，之前在上面注册的函数和委托实例之间也不再产生任何关系。

> 多播委托不支持返回值，也不支持数据引用，是单向广播

# 5.泛型委托

委托也支持泛型的使用
泛型委托原型：

- **delegate <T1> <委托名><T1,T2,T3...> (T1 t1,T2 t2,T3 t3...)**

## 5.1 内置泛型委托
delegate      void   Action<T1，T2，T3>	泛型委托是可以达到16个参数的无返回值委托
delegate  Tresult Fun<T1,T2,Tresult>	Fun是内置泛型委托，具有返回值
delegate bool Predicate<T>(T obj)	内置泛型委托，返回bool值

# 6. 委托的清空
1. 在类中申明清空委托方法，依次循环去除委托引用。方法如下：

```c#
public class TestDelegate
{
    public DelegateMethod OnDelegate;
    public void ClearDelegate()
    {
        while (this.OnDelegate != null)
        {
            this.OnDelegate -= this.OnDelegate;
        }
    }
}
```

2. 如果在类中没有申明清空委托的方法，我们可以利用GetInvocationList查询出委托引用，然后进行去除。

   方法如下：

   ```c#
   TestDelegate test = new TestDelegate();
   if (test.OnDelegate != null)
   {
     System.Delegate[] dels = test.OnDelegate.GetInvocationList();
     for (int i = 0; i < dels.Length; i++)
     {
        test.OnDelegate -= dels[i] as DelegateMethod;
     }
   }
   ```

# 7.委托的应用
- 高内聚低耦合
- 用于事件系统
- 用于设计模式——观察者模式开发
