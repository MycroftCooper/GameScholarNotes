---
title: Socket原理
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. C#类型的转换

在c#中类型的转换分两种：显式和隐式，基本的规则如下：

- 基类对象转化为子类对象，必须显式转换，规则：(类型名) 对象。
- 值类型和引用类型的转换采用装箱(boxing)或拆箱(unboxing).
- 子类转化为基类对象。
- 基本类型互相之间转化可以用Covent类来实现。
- 字符串类型转换为对应的基本类型用Parse方法，除了String类型外其他的类型都可以用Parse方法。
- 用GetType可以取得对象的精确类型。
- 子类转化为基类，采用隐式转换。

# 2. C#中的is

检查一个对象是否兼容于其他指定的类型,并返回一个Bool值,如果一个对象是某个类型或是其父类型的话就返回为true，否则的话就会返回为false。永远不会抛出异常
如果对象引用为null，那么is操作符总是返回为false，因为没有对象可以检查其类型。

　　代码如下:

```c#
object o = new object();
　　if (o is Label)
　　{
  　 Label lb = (Label)o;
  　　Response.Write("类型转换成功");
　　}
　　else
　　{
  　　Response.Write("类型转换失败");  
　　}
```

# 3. C#中as的转换规则

- 检查对象类型的兼容性，并返回转换结果，如果不兼容则返回null；
- 不会抛出异常；
- 如果结果判断为空，则强制执行类型转换将抛出NullReferenceException异常；
- 用as来进行类型转换的时候，所要转换的对象类型必须是目标类型或者转换目标类型的派生类型

代码如下:

```c#
object o = new object();  
　　Label lb = o as Label;  
　　if (lb == null)
　　{
  　　Response.Write("类型转换失败");
　　}
　　else
　　{   
  　 Response.Write("类型转换成功"); 
　　}
```

使用as操作符有如下几点限制

第一个就是，不用在类型之间进行类型转化，即如下编写就会出现编译错误。

代码如下:

```c#
NewType newValue = new NewType();
NewType1 newValue = newValue as NewType1;
```

第二个就是，不能应用在值类型数据，即不能如下写（也会出现编译错误）。

代码如下:

```c#
object objTest = 11;
int nValue = objTest as int;
```

# 4. as与is的区别

- AS在转换的同事兼判断兼容性
  如果无法进行转换，则 as 返回 null（没有产生新的对象）而不是引发异常。
  有了AS我想以后就不要再用try-catch来做类型转换的判断了。
  因此as转换成功要判断是否为null。

- AS是引用类型类型的转换或者装箱转换，不能用与值类型的转换
  如果是值类型只能结合is来强制转换

- IS只是做类型兼容判断，并不执行真正的类型转换
  返回true或false，不会返回null，对象为null也会返回false。

- AS模式的效率要比IS模式的高
  因为借助IS进行类型转换的化，需要执行两次类型兼容检查。
  而AS只需要做一次类型兼容，一次null检查，null检查要比类型兼容检查快。

# 5. (int)，Int32.Parse()，Convert.ToInt32()的区别

- (int)转换：
  用在数值范围大的类型转换成数值范围小的类型时使用
  但是如果被转换的数值大于或者小于数值范围，则得到一个错误的结果
  利用这种转换方式不能将string转换成int，会报错。
- Int32.Parse()转换：
  在符合数字格式的string到int类型转换过程中使用，并可以对错误的string数字格式的抛出相应的异常。
- Convert.ToInt32()转换：
  使用这种转换，所提供的字符串必须是数值的有效表达方式，该数还必须不是溢出的数。否则抛出异常。

# 6. 常用类型转换

- Object => 已知引用类型
  使用as操作符来完成

- Object => 已知值类型
  先使用is操作符来进行判断，再用类型强转方式进行转换

- 已知引用类型之间转换
  首先需要相应类型提供转换函数，再用类型强转方式进行转换

- 已知值类型之间转换
  最好使用系统提供的Convert类所涉及的静态方法



希望本文所述对大家的C#程序设计有所帮助。

转载自：http://www.jb51.net/article/56657.htm。
