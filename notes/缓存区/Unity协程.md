---
title: Unity资源处理
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. 简介

unity的**协程（Coroutine）**只是在c#的基础上做了一层封装，其实yield是C#的关键字。

unity协程是一个能够暂停协程执行，暂停后立即返回主函数，执行主函数剩余的部分，直到中断指令完成后，从中断指令的下一行继续执行协程剩余的函数。
函数体全部执行完成，协程结束。
由于中断指令的出现，使得可以将一个函数分割到多个帧里去执行。

协程不是进程，也不是线程，它就是一个特殊的函数——可以在某个地方挂起，并且可以重新在挂起处继续运行。

**协程方法与普通方法的区别：**

- 普通方法
  被调用时，原来执行的部分保留现场，停止执行，然后去执行要调用的方法，并且，被调用的方法执行完之后才能返回到调用前的状态接着往下执行。
- 协同方法
  执行不用等协同方法执行完再执行调用之前原来方法的代码，而是两者异步执行。

协程不是多线程，它与主线程同时运行，它在主线程运行的同时开启另一段逻辑处理。
类似一个子线程单独出来处理一些问题，性能开销较小。
Unity的协程会在每帧结束之后去检测yield的条件是否满足，满足则执行yield return之后的代码。

在一个MonoBehaviour提供的主线程里只能有一个处于运行状态的协程，而其他协程处于休眠状态。
协程实际上是在一个线程中，只不过每个协程对CUP进行分时，协程可以访问和使用unity的所有方法和component。

**性能：**
在性能上相比于一般函数没有更多的开销

**协程的好处：**
让原来要使用异步 + 回调方式写的非人类代码, 可以用看似同步的方式写出来。
能够分步做一个比较耗时的事情，如果需要大量的计算，将计算放到一个随时间进行的协程来处理，能分散计算压力

**协程的坏处：**
协程本质是迭代器，且是基于unity生命周期的，大量开启协程会引起gc
如果同时激活的协程较多，就可能会出现多个高开销的协程挤在同一帧执行导致的卡帧

**协程书写时的性能优化：**
常见的问题是直接new 一个中断指令，带来不必要的 GC 负担，可以复用一个全局的中断指令对象，优化掉开销；在 Yielders.cs 这个文件里，已经集中地创建了上面这些类型的静态对象
这个链接分析了一下[https://blog.csdn.net/liujunjie612/article/details/70623943](https://link.zhihu.com/?target=https%3A//blog.csdn.net/liujunjie612/article/details/70623943)

**协程是在什么地方执行？**
协程不是线程，不是异步执行；协程和monobehaviour的update函数一样也是在主线程中执行
unity在每一帧都会处理对象上的协程，也就是说，协程跟update一样都是unity每帧会去处理的函数
经过测试，协程至少是每帧的lateUpdate后运行的。
参照unity的生命周期图

**前驱知识：**

- 设计模式——迭代器模式
- C#中的IEnumerator、IEnumerable接口


# 2. 协程的实现

协程的实现需要在Unity中继承MonoBehaviour并使用C#的迭代器IEnumrator，格式如下所示：

```c#
IEnumrator 函数名(形参表)  //最多只能有一个形参 
{   
    yield return xxx; //恢复执行条件
    //方法体
}
```

在IEnumerator类型的方法中写入需要执行的操作，遇到yield后会暂时挂起，等到yield return后的条件满足才继续执行yield语句后面的内容。

# 3. 协程的开启与中止

相关测试：[Unity 协程的一些基本用法及测试](https://blog.csdn.net/qq_37421018/article/details/88560239?utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control)

## 3.1 协程的开启

开启协程需要使用StartCoroutine()方法：

- 开启无参数的协程：
  `StartCoroutine(协程名());`或`StartCoroutine("协程名");`

- 开启单参数的协程：
  `StartCoroutine(协程名(参数));`或`StartCoroutine("协程名",参数);`

- 开启多参数的协程：
  `StartCoroutine(协程名(参数1,......));`
  或
  
  ```c#
  void StartCoroutine()//开启协程的函数
  {
      IEnumerator coroutine = Test(5, 6);
      StartCoroutine(coroutine);
  }
   public IEnumerator Test(int a, int b)//协程
   {
       //等待帧画面渲染结束
       yield return new WaitForEndOfFrame();
       a=2;
       b=3;
  }
  ```
  
  > 用“协程名”启动的方式不允许传入 一个以上的参数

## 3.2 协程的结束

结束协程有两种情况：

- 当协程的方法体执行完毕将会自动结束

- 调用StopCoroutine();方法中止协程执行


中止协程的几种情况：

- 中止所有协程：
  `StopAllCoroutines();`

- 使用对象实例中止指定协程

  ```c#
  Coroutine c;
  void Start()
  {
      c = StartCoroutine(CountSeconds());        
  }
  void Update()
  {
      if (Input.GetKeyDown(KeyCode.J))
      {
          StopCoroutine(c);
      }
  }
  ```

- 使用字符串中止指定协程

  ```c#
  StartCoroutine("协程名");
  StopCoroutine("协程名");
  ```
  >只有以协程名字符串启动的协程可以用此方法中止
  >既：**StartCoroutine("协程名");**或**StartCoroutine("协程名",参数);**
  >
  >允许使用**StopCoroutine("协程名");**中止协程
  
  > 不允许使用直接调用协程方法的方式中止指定协程
  > 既：**StopCoroutine(协程名([参数]));**不被允许

# 4. yield 协程回复条件语句

**快查表：**

| yield语句                                      | 功能                                                         |
| ---------------------------------------------- | ------------------------------------------------------------ |
| yield return null;                             | 下一帧再执行后续代码                                         |
| yield return 0;                                | 下一帧再执行后续代码                                         |
| yield return 6;(任意数字)                      | 下一帧再执行后续代码                                         |
| yield break;                                   | 直接结束该协程的后续操作                                     |
| yield return asyncOperation;                   | 等异步操作结束后再执行后续代码                               |
| yield return StartCoroution(其它协程);         | 调用执行其它协程后再执行后续代码                             |
| yield return WWW();                            | 等待WWW操作完成后再执行后续代码                              |
| yield return new WaitForEndOfFrame();          | 等待帧结束,等待直到所有的摄像机和GUI被渲染完成后，在该帧显示在屏幕之前执行 |
| yield return new WaitForSeconds(0.3f);         | 等待0.3秒，一段指定的时间延迟之后继续执行，在所有的Update函数完成调用的那一帧之后（这里的时间会受到Time.timeScale的影响）; |
| yield return new WaitForSecondsRealtime(0.3f); | 等待0.3秒，一段指定的时间延迟之后继续执行，在所有的Update函数完成调用的那一帧之后（这里的时间不受到Time.timeScale的影响）; |
| yield return WaitForFixedUpdate();             | 等待下一次FixedUpdate开始时再执行后续代码                    |
| yield return new WaitUntil()                   | 将协同执行直到当输入的参数（或者委托）为true的时候           |
| yield return new WaitWhile()                   | 将协同执行直到 当输入的参数（或者委托）为false的时候         |

**生命周期图：**
![](./attachments/Unity协程/bc794556.png)

## 4.1 yield return null;

从生命周期图中可以看到，在GameLogic部分对协程中挂起的条件进行了判断。

也就是说，协程顺序为：
（当前帧为第1帧）
第1帧在start中开启协程，执行协程（自上而下），遇到yield return null 将后面的内容挂起。
这时继续执行第1帧剩下的东西直到第1帧Update执行结束，这时对挂起的协程进行判断 是否满足return条件，
满足则在第2帧Update之后，在LateUpdate前执行协程中yield return 以后的代码；
不满足条件则继续执行第1帧的LateUpdate。
第2帧同第1帧相同。

**测试如下：**

```c#
using System.Collections;
using UnityEngine;
public class CorTest2 : MonoBehaviour
{
    int i = 0;//update中判断次数的变量
    private void Start()
    {
        Debug.Log("start 1");
        //开启协程1
        StartCoroutine(Test());
        Debug.Log("start 2");
    }
    private void Update()
    {
        Debug.Log("第" + ++i + "帧开始");
    }
    private void LateUpdate()
    {
        Debug.Log("第" + i + "帧结束");
    }
    IEnumerator Test()
    {
        while (true)
        {
            Debug.Log("协程1第一次");
            //挂起时机
            yield return null;
            Debug.Log("协程1第二次");
        }
    }
}
```

**结果如下：**

![](./attachments/Unity协程/32c75c43.png)

可以看到，协程运行到一半在第一帧被挂起，第二帧Update执行完后满足条件继续执行。

## 4.2 yield return StartCoroutine();

**测试如下：**

```c#
IEnumerator Test()
   {
       while (true)
       {
           Debug.Log("协程1第一次");
           //挂起时机
           yield return StartCoroutine(Test2());
           Debug.Log("协程1第二次");
       }
   }

   IEnumerator Test2()
   {
       Debug.Log("协程2第一次");
       yield return null;
       Debug.Log("协程2第二次");
   }
```

**结果如下：**
![](./attachments/Unity协程/1480a90f.png)

原理都是一样的，执行完yield return 后挂起（注意不是遇到就挂起，而是执行），在每一帧的update与lateupdate之间对挂起的内容进行判断，满足则继续执行被挂起的协程的剩余部分。

## 4.3 yield return new WaitUntil();

**案例：**

```c#
public int counter;
IEnumerator Start()
{
    counter=20;
    yield return new WaitUntil(TestWait);
    Debug.Log("Start执行完毕");
}
bool TestWait()
{
    return true;
}
```

- 当方法TestWait的返回值为true的时候
  Start会一次性执行完。
- 当方法TestWait的返回值为false的时候
  Start会一直等待着，只要返回值为false，那么Start的最后一句打印就不会执行。

> 可以使用lambda表达式

## 4.4 yield return new WaitWhile()

**案例：**

```c#
public int counter;
IEnumerator Start()
{
    counter=20;
    yield return new WaitWhile(TestWait);
    Debug.Log("Start执行完毕");
}
bool TestWait()
{
    return false;
}
```

- 当方法TestWait的返回值为true的时候
  Start会一直等待着，只要返回值为true，那么Start的最后一句打印就不会执行。
- 当方法TestWait的返回值为false的时候
  Start会一次性执行完。

> 可以使用lambda表达式

# 5. 协程的嵌套

利用`yield return StartCoroution(其它协程);`可以实现多个协程的嵌套使用。
例如：

```c#
IEnumerator SaySomeThings()   
{       
    Debug.Log("The routine has started");       
    yield return StartCoroutine(RepeatMessage(1, 1f, "Hello"));       
    Debug.Log("1 second has passed since the last message");       
    yield return StartCoroutine(RepeatMessage(1, 2.5f, "Hello"));       
    Debug.Log("2.5 seconds have passed since the last message");   
}
```

执行结果：

![](./attachments/Unity协程/22023d96.png)

# 6. 注意

- IEnumerator 类型的方法不能带 ref 或者 out 型的参数，但可以带被传递的引用
- 在函数 Update 和 FixedUpdate 中不能使用 yield 语句，否则会报错， 但是可以启动协程
- 在一个协程中，StartCoroutine()和 yield return StartCoroutine()是不一样的。
  前者仅仅是开始一个新的Coroutine，这个新的Coroutine和现有Coroutine并行执行。
  后者是返回一个新的Coroutine，是一个中断指令，当这个新的Coroutine执行完毕后，才继承执行现有Coroutine。

# 7. 使用案例

## 7.1 运动到某一位置

在Inspector面板中设置目标位置和运动速度，在游戏开始时将一个物体移动到目标位置

```c#
public Vector3 targetPosition;
public float moveSpeed=5;
void Start()
{
    c = StartCoroutine(MoveToPosition(targetPosition));
}
IEnumerator MoveToPosition(Vector3 target)
{
    while (transform.position != target)
    {
        transform.position = Vector3.MoveTowards(transform.position,target,moveSpeed*Time.deltaTime);
        yield return 0;
    }
}
```

## 7.2 按指定路径前进

我们可以让运动到某一位置的程序做更多，不仅仅是一个指定位置，我们还可以通过数组来给它赋值更多的位置，通过MoveToPosition() ，我们可以让它在这些点之间持续运动。

```c#
public List<Vector3> path;    
IEnumerator MoveOnPath(bool loop)
{
    do
    {
        foreach (var point in path)
            yield return StartCoroutine(MoveToPosition(point));
    }
    while (loop);
}
```

## 7.3 倒计时

```c#
IEnumerator CountDown(int time)
{
        for(int t = time;t >= 0;t -= 1)
        {
            print(time);
            time -= 1; 
            yield return new WaitForSecondsRealtime(1f); //WaitForSecondsRealtime不受时间缩放影响
        }
}
```
