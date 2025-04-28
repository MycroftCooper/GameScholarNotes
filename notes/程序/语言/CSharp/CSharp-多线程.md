---
title: CSharp-多线程
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - CSharp
  - 程序
  - 语言
category: 程序/语言/CSharp
note status: 终稿
---


# 1.简介

在学习本篇文章前你需要学习的相关知识：
[线程基本知识](https://mycroftcooper.github.io/2021/05/28/%E7%BA%BF%E7%A8%8B%E5%9F%BA%E6%9C%AC%E7%9F%A5%E8%AF%86/)

此篇文章简单总结了C#中主要的多线程实现方法，包括：

- Thread
  线程
- ThreadPool
  线程池
- Parallel
- Task
  任务
- BackgroundWorker组件

# 2. Thread类

## 2.1 概述

- 使用Thread类通过ThreadStart（无参数）或ParameterizedThreadStart（一个输入参数）类型的委托创建一个Thread对象，开启一个新线程，执行该委托传递的任务，此时线程尚未处于运行状态。
- 调用Start()函数启动线程，当前线程继续执行。
- 调用Join()函数可以阻塞当前线程，直到调用Join()的线程终止。

- 调用Abort()方法，如需中止线程，在调用该方法的线程上抛出ThreadAbortException异常，以结束该线程
- 可以通过Thread.ResetAbort()方法阻止线程的中止。

## 2.1 属性表

| 属性                          | 说明                                   |
| ----------------------------- | ------------------------------------ |
| Name                          | 属性，获取或设置线程的名称                |
| Priority                      | 属性，获取或设置线程的优先级              |
| ThreadState                   | 属性，获取线程当前的状态                 |
| IsAlive                       | 属性，获取当前线程是否处于启动状态         |
| IsBackground                  | 属性，获取或设置值，表示该线程是否为后台线程 |
| CurrentThread                 | 属性，获取当前正在运行的线程              |

## 2.2 方法表

| 方法                          | 说明                                   |
| ----------------------------- | ------------------------------------ |
| Start()                       | 方法，启动线程                          |
| Sleep(int millisecondsTimout) | 方法，将当前线程暂停指定的毫秒数           |
| Suspend()                     | 方法，挂起当前线程（已经被弃用）           |
| Join()                        | 方法，阻塞调用线程，直到某个线程终止为止    |
| Interrupt()                   | 方法，中断当前线程                      |
| Resume()                      | 方法，继续已经挂起的线程（已经被弃用）      |
| Abort()                       | 方法，终止线程（已经被弃用）                   |

## 2.3 开启线程

首先用new申请Thread对象，然后对象调用Start()方法启用线程。

代码如下所示：

```c#
class Program
{
    static void DownLoad()
    {
        Console.WriteLine("DownLoad Begin " + Thread.CurrentThread.ManagedThreadId);
        Thread.Sleep(1000);
        Console.WriteLine("DownLoad End");
    }
    static void Main(string[] args)
    {
        //创建Thread对象
        Thread thread = new Thread(DownLoad);
        //启动线程
        thread.Start();
        Console.WriteLine("Main");
        Console.ReadKey();
    }
}
```

> Thread.CurrentThread.ManagedThreadId获取当前线程的ID，便于管理。

用Lambda表达式代替函数调用，也能达到相同的效果
```csharp
class Program
{
    static void Main(string[] args)
    {
        Thread thread = new Thread(() =>
        {
            Console.WriteLine("DownLoad Begin " + Thread.CurrentThread.ManagedThreadId);
            Thread.Sleep(1000);
            Console.WriteLine("DownLoad End");
        });
        thread.Start();
        Console.WriteLine("Main");
        Console.ReadKey();
    }
}
```

## 2.4 传递参数
有两种为线程传递参数的方法：

- Start()函数传参法
- 对象成员方法传参法
- 匿名方法传参法

 ### 2.4.1 Start()函数传参

为某方法创建新线程后，在使用Start()方法启动线程时传递该方法需要的参数。

代码如下：

```c#
class Program
{
    static void DownLoad(object name)
    {
        Console.WriteLine("DownLoad Begin " + name);
        Thread.Sleep(1000);
        Console.WriteLine("DownLoad End");
    }
    static void Main(string[] args)
    {
        //创建Thread对象
        Thread thread = new Thread(DownLoad);
        //启动线程
        thread.Start("April");
        Console.WriteLine("Main");
        Console.ReadKey();
    }
```

### 2.4.1 对象传递
初始化一个对象，然后用对象的方法初始化Thread，这样该线程就可以使用这个对象的所有成员。
```c#
class Program
{
    public class Download
    {
        private int Id;
        private string Name;
        public Download(int id, string name)
        {
            Id = id;
            Name = name;
        }
        public void DownloadFile()
        {
            Console.WriteLine("DownLoad Begin " + "ID: " + Id + " Name: " + Name);
            Thread.Sleep(1000);
            Console.WriteLine("DownLoad End");              
        }
    }
    static void Main(string[] args)
    {
        Download download = new Download(1, "人民日报");
        Thread thread = new Thread(download.DownloadFile);
        thread.Start();
        Console.WriteLine("Main");
        Console.ReadKey();
    }
}
```

### 2.4.5 匿名方法

需要接收多个参数的解决方案是使用一个匿名方法调用，方法如下

```c#
static void Main() {
Thread t = new Thread(delegate() { WriteText ("Hello"); });

t.Start();

}

static void WriteText (stringtext) { Console.WriteLine (text); }
```

它的优点是目标方法（这里是WriteText），可以接收任意数量的参数，并且没有装箱操作。

不过这需要将一个外部变量放入到匿名方法中，如下示例：

```c#
static voidMain() {
stringtext = "Before";

Threadt = new Thread(delegate() { WriteText (text); });

text = "After";

t.Start();

}

static void WriteText (stringtext) { Console.WriteLine (text); }
```

> 需要注意的是:
> 当外部变量的值被修改，匿名方法可能进行无意的互动，导致一些古怪的现象。
> 一旦线程开始运行，外部变量最好被处理成只读的——除非有人愿意使用适当的锁。

## 2.5 线程命名

线程可以通过它的Name属性进行命名，这非常有利于调试：
可以用Console.WriteLine打印出线程的名字
Microsoft Visual Studio可以将线程的名字显示在调试工具栏的位置上。

线程的名字可以在被任何时间设置——但只能设置一次，重命名会引发异常。

程序的主线程也可以被命名，下面例子里主线程通过CurrentThread命名：

```c#
Class ThreadNaming {
static void Main() {
Thread.CurrentThread.Name= "main";

Thread worker = new Thread(Go);

worker.Name= "worker";

worker.Start();

Go();

}

static void Go() {
Console.WriteLine ("Hello from "+ Thread.CurrentThread.Name);

}

}
```

输出

Hellofrom main

Hellofrom worker


## 2.6 前台线程和后台线程

- 前台线程(用户界面线程)
  只要存在有一个前台线程在运行，应用程序就在运行
  通常用来处理用户的输入并响应各种事件和消息
- 后台线程(工作线程)
  应用程序关闭时，如果后台线程没有执行完，会被强制性的关闭
  用来执行程序的后台处理任务，比如计算、调度、对串口的读写操作等

例如：

```
class Program
{
    static void DownLoad()
    {
        Console.WriteLine("DownLoad Begin " + Thread.CurrentThread.ManagedThreadId);
        Thread.Sleep(1000);
        Console.WriteLine("DownLoad End");
    }
    static void Main(string[] args)
    {
        //创建Thread对象
        Thread thread = new Thread(DownLoad);
        //设为后台线程
        thread.IsBackground = true;
        //启动线程
        thread.Start();
        Console.WriteLine("Main");
    }
}
```

在上例中，thread被设置为后台线程。
Main执行完后，没有前台线程了，应用程序就结束，虽然后台线程thread此时尚未执行完，也被终止。

> 改变线程从前台到后台不会以任何方式改变它在CPU协调程序中的优先级和状态。

拥有一个后台工作线程是有益的，
最直接的理由是当提到结束程序它总是可能有最后的发言权。
交织以不会消亡的前台线程，保证程序的正常退出。

抛弃一个前台工作线程是尤为险恶的，尤其对Windows Forms程序，
因为程序直到主线程结束时才退出（至少对用户来说），但是它的进程仍然运行着。
在Windows任务管理器它将从应用程序栏消失不见，但却可以在进程栏找到它。
除非用户找到并结束它，它将继续消耗资源，并可能阻止一个新的实例的运行从开始或影响它的特性。

对于程序失败退出的普遍原因就是存在“被忘记”的前台线程。

| 线程类型 | 动作       | 结束 | 后续处理                  |
| -------- | ---------- | ---- | ------------------------- |
| 前台线程 | 主程序关闭 | 否   | 显示关闭线程/杀掉当前进程 |
| 后台线程 | 主程序关闭 | 是   | 无                        |

## 2.7 注意事项

- Thread类创建的线程默认为前台线程，可以通过IsBackground属性设置其为前台或后台线程。

  > 用Thread类创建的线程是前台线程，线程池中的线程总是后台线程

- 可以通过Priority属性设置线程的优先级。
- 线程内部可以通过try catch捕获该异常，在catch模块中进行一些必要的处理
  如释放持有的锁和文件资源等
- 慎重使用Abort()方法
  如果在当前线程中抛出该异常，其结果是可预测的
  但是对于其他线程，它会中断任何正在执行的代码，有可能中断静态对象的生成，造成不可预测的结果。

# 3. 线程池

## 3.1 概述

ThreadPool类维护一个线程的列表，提供给用户以执行不同的小任务，减少频繁创建线程的开销。
该线程池可用于执行任务、发送工作项、处理异步 I/O、代表其他线程等待以及处理计时器。

线程池其实就是一个存放线程对象的“池子(pool)”，他提供了一些基本方法，如：设置pool中最小/最大线程数量、把要执行的方法排入队列等等。ThreadPool是一个静态类，因此可以直接使用，不用创建对象。

## 3.2 线程池的优点

每新建一个线程都需要占用内存空间和其他资源
而新建了那么多线程，有很多在休眠，或者在等待资源释放；
又有许多线程只是周期性的做一些小工作，如刷新数据等等，太浪费了，划不来。
实际编程中大量线程突发，然后在短时间内结束的情况很少见。

于是，就提出了线程池的概念。

线程池中的线程执行完指定的方法后并不会自动消除，而是以挂起状态返回线程池，如果应用程序再次向线程池发出请求，那么处以挂起状态的线程就会被激活并执行任务，而不会创建新线程，这就节约了很多开销。
只有当线程数达到最大线程数量，系统才会自动销毁线程。

因此，使用线程池可以避免大量的创建和销毁的开支，具有更好的性能和稳定性，其次，开发人员把线程交给系统管理，可以集中精力处理其他任务。

## 3.3 线程池的使用

- 设置线程池最大最小：
  **ThreadPool.SetMaxThreads (int workerThreads,int completionPortThreads)**
  设置可以同时处于活动状态的线程池的请求数目。
  所有大于此数目的请求将保持排队状态，直到线程池线程变为可用。
  还可以设置最小线程数。

- 将任务添加进线程池:
  **ThreadPool.QueueUserWorkItem(new WaitCallback(方法名));**或
  **ThreadPool.QueueUserWorkItem(new WaitCallback(方法名), 参数);**

但是线程池的使用也有一些限制：

- 线程池中的线程均为后台线程，并且不能修改为前台线程
- 不能给入池的线程设置优先级或名称
- 对于COM对象，入池的所有线程都是多线程单元（MTA）线程，许多COM对象都需要单线程单元（STA）  线程
- 入池的线程只适合时间较短的任务，如果线程需要长时间运行，应使用Thread类创建线程或使用Task的LongRunning选项
- .Net下线程池最小默认允许4个工作线程，最大允许2048个工作线程。 
  并发线程启动后，瞬间会启动4个线程。
  而剩下的会依据环境每0.5秒或者1秒启动一个。
  如果同时运行的线程达到Max工作线程，那么剩下的就会挂起
  直到线程池中的线程有空闲得了，才会去执行。

# 4.  Parallel类

## 4.1 概述

整理自https://blog.csdn.net/honantic/article/details/46876871

Parallel和Task类都位于System.Threading.Task命名空间中，是对Thread和ThreadPool类更高级的抽象。

Parrallel类有For()、ForEach()、Invoke()三个方法

- Invoke()
  实现任务并行性
  允许同时调用不同的方法，

- Parallel.For()和 Parallel.ForEach()
  实现数据并行性
  在每次迭代中调用相同的代码

## 4.2 常用方法

### 4.2.1 Parallel.For()

Parallel.For()方法类似于 C#的 for循环语旬,也是多次执行一个任务。
使用Parallel.For()方法,可以并行运行迭代。 

迭代的顺序没有定义，不能保证。

在For()方法中：

- 前两个参数定义了循环的开头和结束。示例从0迭代到 9。
- 第 3个参数是一个Action<int>委托
  是要并行运行迭代的方法
- 整数参数是循环的迭代次数,该参数被传递给Action<int>委托引用的方法。
- Parallel.For()方法的返回类型是ParalleLoopResult结构,它提供了循环是否结束的信息。

案例如下：

```c#
        public static void Main()
        {
            ParallelLoopResult result = Parallel.For(0, 10, i =>
            {
                Console.WriteLine
                ("i:{0}, thread id: {1}", i, Thread.CurrentThread.ManagedThreadId);
                Thread.Sleep(10);
            });

            Console.WriteLine("Is completed: {0}", result.IsCompleted);

            //i: 0, thread id: 9
            //i: 2, thread id: 10
            //i: 1, thread id: 9
            //i: 3, thread id: 10
            //i: 4, thread id: 9
            //i: 6, thread id: 11
            //i: 7, thread id: 10
            //i: 5, thread id: 9
            //i: 8, thread id: 12
            //i: 9, thread id: 11
            //Is completed: True

            Console.ReadKey();
        }
```

同For()循环类似，Parallel.For()方法也可以中断循环的执行。

Parallel.For()方法的一个重载版本接受第3个Action<int, ParallelLoopState>类型的参数。
使用这些参数定义一个方法,就可以调用ParalleLoopState的Break()或Stop()方法,以影响循环的结果。

> 注意,迭代的顺序没有定义

案例如下：

```tsx
        public static void Main()
        {
            ParallelLoopResult result = Parallel.For(0, 100, (i, state) =>
            {
                Console.WriteLine("i:{0}, thread id: {1}", i, Thread.CurrentThread.ManagedThreadId);

                if (i > 10)
                    state.Break();

                Thread.Sleep(10);
            });

            Console.WriteLine("Is completed: {0}", result.IsCompleted);
            Console.WriteLine("Lowest break iteration: {0}", result.LowestBreakIteration);

            //i: 0, thread id: 10
            //i: 25, thread id: 6
            //i: 1, thread id: 10
            //i: 2, thread id: 10
            //i: 3, thread id: 10
            //i: 4, thread id: 10
            //i: 5, thread id: 10
            //i: 6, thread id: 10
            //i: 7, thread id: 10
            //i: 8, thread id: 10
            //i: 9, thread id: 10
            //i: 10, thread id: 10
            //i: 11, thread id: 10
            //Is completed: False
            //Lowest break iteration: 11

            Console.ReadKey();
        }
```

### 4.2.2 Parallel.For < TLocal >
Parallel.For()方法可能使用几个线程来执行循环 。

如果需要对每个线程进行初始化,就可以使用Parallel.For<TLocal>方法。
除了from和to对应的值之外,For()方法的泛型版本还接受3个委托参数:

- 第一个参数的类型是Func< TLocal > 
  因为这里的例子对于TLocal使用字符串,所以该方法需要定义为Func< string >,即返回string的方法。
  这个方法仅对于用于执行迭代的每个线程调用一次

- 第二个委托参数为循环体定义了委托
  在示例中,该参数的类型是Func<int, ParallelLoopState, string, string>。 
  其中第一个参数是循环迭代,第二个参数 ParallelLoopstate允许停止循环,如前所述 。
  循环体方法通过第3个参数接收从init方法返回的值,循环体方法还需要返回一个值,其类型是用泛型for参数定义的。

- For()方法的最后一个参数指定一个委托Action< TLocal >;在该示例中,接收一个字符串。 
  这个方法仅对于每个线程调用一次,这是一个线程退出方法。

案例如下：

```c#
Parallel.For<string>(0, 20,() =>
                {
                    Console.WriteLine("init thread {0},\t task {1}", Thread.CurrentThread.ManagedThreadId, Task.CurrentId);
                    return string.Format("t{0}", Thread.CurrentThread.ManagedThreadId);
                },
            (i, pls, str) =>
            {
                Console.WriteLine("body i {0} \t str {1} \t thread {2} \t task {3}", i, str, Thread.CurrentThread.ManagedThreadId, Task.CurrentId);
                Thread.Sleep(10);
                return string.Format("i \t{0}", i);
            },
            (str) =>
            {
                Console.WriteLine("finally\t {0}", str);
            });
            Console.ReadKey();
```

**Parallel.For<TLocal> 方法 (Int32, Int32, Func<TLocal>, Func<Int32, ParallelLoopState, TLocal, TLocal>, Action<TLocal>)**

参数表：

| 参数名        | 数据类型                                              | 作用                                           |
| ------------- | ----------------------------------------------------- | ---------------------------------------------- |
|               | TLoca                                                 | 线程本地数据的类型                             |
| fromInclusive | System.Int32                                          | 开始索引（含）                                 |
| toExclusive   | System.Int32                                          | 结束索引（不含）                               |
| localInit     | System.Func<TLocal>                                   | 用于返回每个任务的本地数据的初始状态的函数委托 |
| body          | System.Func<Int32, ParallelLoopState, TLocal, TLocal> | 将为每个迭代调用一次的委托                     |
| localFinally  | System.Action<TLocal>                                 | 用于对每个任务的本地状态执行一个最终操作的委托 |
| 返回值        | System.Threading.Tasks.ParallelLoopResult             |                                                |

在迭代范围 (fromInclusive，toExclusive) ，为每个值调用一次body 委托。
为它提供以下参数：

- 迭代次数 (Int32)
- 可用来提前退出循环的ParallelLoopState实例
- 可以在同一线程上执行的迭代之间共享的某些本地状态。

对于参与循环执行的每个任务调用 localInit 委托一次，并返回每个任务的初始本地状态。 
这些初始状态传递给第一个在该任务上 调用的 body。 
然后，每个后续正文调用返回可能修改过的状态值，传递到下一个正文调用。 
最后，每个任务上的最后正文调用返回传递给 localFinally 委托的状态值。 
每个任务调用 localFinally 委托一次，以对每个任务的本地状态执行最终操作。
此委托可以被多个任务同步调用；
因此您必须同步对任何共享变量的访问。

Parallel.For方法比在它执行生存期的线程可能使用更多任务，作为现有的任务完成并被新任务替换。 
这使基础 TaskScheduler 对象有机会添加、更改或移除服务循环的线程。

如果 fromInclusive 大于或等于 toExclusive，则该方法立即返回，而无需执行任何迭代。

### 4.2.3 Parallel.ForEach()
Parallel.ForEach()方法遍历实现了IEnumerable的集合,其方式类似于foreach语句,但以异步方式遍历。
这里也没有确定遍历顺序。

```c#
string[] data = { "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve" };
            ParallelLoopResult result = Parallel.ForEach<string>(data, (s) =>
            {
                Console.WriteLine(s);
            });
            Console.ReadKey();
```



中断循环
如果需要中断循环,就可以使用ForEach()方法的重载版本和ParallelLoopState参数。其方式与前面的For()方法相同。
ForEach()方法的一个重载版本也可以用于访问索引器,从而获得迭代次数
如下所示:　

```c#
string[] data = { "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve" };
            ParallelLoopResult result = Parallel.ForEach<string>(data, (s, pls, l) =>
             {
                 Console.WriteLine("{0}\t{1}", s, l);
                 if (l > 10)
                 {
                     pls.Break();
                 }
             });
            Console.WriteLine("Lowest break iteration: {0}", result.LowestBreakIteration);
            Console.ReadKey();
```

### 4.2.4 Parallel.Invoke()
如果多个任务应并行运行,就可以使用Parallel.Invoke()方法。
Parallel.Invoke()方法允许传递一个Action委托数组,在其中可以指定应运行的方法。
示例代码传递了要并行调用的Foo()和Bar()方法:

```c#
    static void Main(string[] args)
    {
        Parallel.Invoke(Foo, Bar);
        Console.ReadKey();
    }
    static void Foo()
    {
        Console.WriteLine("Foo");
    }

    static void Bar()
    {
        Console.WriteLine("Bar");
    }
```

如需同时执行多个不同的任务，可以使用Parallel.Invoke()方法，它允许传递一个Action委托数组。

```cpp
        public static void Main()
        {
            Parallel.Invoke(Func1, Func2, Func3);
            Console.ReadKey();
        }
```

# 5. Task类

## 5.1 概述

相比于Thread类，Task类为控制线程提供了更大的灵活性。

- Task类可以获取线程的返回值

- 可以定义连续的任务：在一个任务结束结束后开启下一个任务

- 可以在层次结构中安排任务，在父任务中可以创建子任务
  这样就创建了一种依赖关系，如果父任务被取消，子任务也随之取消

>注意：
Task类默认使用线程池中的线程，如果该任务需长期运行，应使用TaskCreationOptions.LongRunning属性告诉任务管理器创建一个新的线程，而不是使用线程池中的线程。

## 5.2 任务Task和线程Thread的区别：

- 任务是架构在线程之上的
  也就是说任务最终还是要**抛给线程**去执行。
- **任务跟线程不是一对一的关系**
  比如开10个任务并不是说会开10个线程，这一点任务有点类似线程池，但是任务相比线程池有很小的开销和精确的控制。
- Task和Thread一样，位于System.Threading命名空间下!

## 5.3 Task的生存周期与状态

| 状态            | 说明                                               |
| --------------- | -------------------------------------------------- |
| Created         | 表示默认初始化任务，但是“工厂创建的”实例直接跳过。 |
| WaitingToRun    | 这种状态表示等待任务调度器分配线程给任务执行。     |
| RanToCompletion | 任务执行完毕。                                     |

```c#
//查看Task中的状态
   var task1 = new Task(() =>
         {
            Console.WriteLine("Begin");
            System.Threading.Thread.Sleep(2000);
            Console.WriteLine("Finish");
         });
         Console.WriteLine("Before start:" + task1.Status);
         task1.Start();
         Console.WriteLine("After start:" + task1.Status);
         task1.Wait();
         Console.WriteLine("After Finish:" + task1.Status);
```

## 5.4 Task的使用方法

###  5.4.1 启动任务

以下程序演示了几种通过Task类启动任务的方式：

- 实例化后手动start()

  ```c#
  var task1 = new Task(() =>
      {
         //TODO you code
      });
     task1.Start();
  ```

- 使用Task工厂对象创建新任务并执行

  ```c#
  TaskFactory tf = new TaskFactory();
  Task t1 = tf.StartNew(TaskMethod.DoTask, "using a task factory");
  ```

- 工厂创建，直接执行

  ```c#
  Task t2 = Task.Factory.StartNew(TaskMethod.DoTask, "factory via a task");
  ```

  

案例如下：

```c#
    public class ThreadExample
    {
        public static void Main()
        {
            TaskFactory tf = new TaskFactory();
            Task t1 = tf.StartNew(TaskMethod.DoTask, "using a task factory");

            Task t2 = Task.Factory.StartNew(TaskMethod.DoTask, "factory via a task");

            Task t3 = new Task(TaskMethod.DoTask, "using a task constructor and start");
            t3.Start();

            //需要.NetFramework 4.5以上
            var t4 = Task.Run(() => TaskMethod.DoTask("using Run method"));

            Console.ReadKey();
        }

   class TaskMethod
    {
        static object taskLock = new object();
        public static void DoTask(object msg)
        {
            lock (taskLock)
            {
                Console.WriteLine(msg);
                Console.WriteLine("Task id:{0}, Thread id :{1}",
                               Task.CurrentId == null ? "no task" : Task.CurrentId.ToString(),
                               Thread.CurrentThread.ManagedThreadId);
            }
        }
    }
```

### 5.4.2 任务控制

#### 5.4.2.1 Task.Wait()
就是等待任务执行（task1）完成，task1的状态变为Completed。

#### 5.4.2.2 Task.WaitAll()
等待所有的任务都执行完成：
例如：

```c#
Task.WaitAll(task,task2,task3...N)
Console.WriteLine("All task finished!");
```

即当task,task2,task3…N全部任务都执行完成之后才会往下执行代码（打印出：“All task finished!”）

#### 5.4.2.3 Task.WaitAny()
同Task.WaitAll，等待任何一个任务完成就继续向下执行，将上面的代码WaitAll替换为WaitAny

```c#
Task.WaitAny(task,task2,task3...N)
Console.WriteLine("Any task finished!");
```

 即当task,task2,task3…N任意一个任务都执行完成之后就会往下执行代码（打印出：” Any task finished!”）

#### 5.4.2.4 Task.ContinueWith()
在第一个Task完成后自动启动下一个Task，实现Task的延续，编写如下代码：

```c#
        public static void Main()
        {
            TaskFactory tf = new TaskFactory();
            Task t1 = tf.StartNew(()=>
            {
                Console.WriteLine("Current Task id = {0}", Task.CurrentId);
                Console.WriteLine("执行任务1\r\n");
                Thread.Sleep(10);
            });

            Task t2 = t1.ContinueWith((t) =>
            {
                Console.WriteLine("Last Task id = {0}", t.Id);
                Console.WriteLine("Current Task id = {0}", Task.CurrentId);
                Console.WriteLine("执行任务2\r\n");
                Thread.Sleep(10);
            });

            Task t3 = t2.ContinueWith(delegate(Task t) 
            {
                Console.WriteLine("Last Task id = {0}", t.Id);
                Console.WriteLine("Current Task id = {0}", Task.CurrentId);
                Console.WriteLine("执行任务3\r\n");
            }, TaskContinuationOptions.OnlyOnRanToCompletion);

            Console.ReadKey(); 
        }
            //执行结果
            //
            //Current Task id = 1
            //执行任务1

            //Last Task id = 1
            //Current Task id = 2
            //执行任务2

            //Last Task id = 2
            //Current Task id = 3
            //执行任务3
```

从执行结果可以看出，任务1，2，3被顺序执行，同时通过 TaskContinuationOptions 还可以指定何种情况下继续执行该任务，常用的值包括OnlyOnFaulted, OnlyOnCanceled, NotOnFaulted, NotOnCanceled等。如将上例中的OnlyOnRanToCompletion改为OnlyOnFaulted，任务2结束之后，任务3将不被执行。

对于ContinueWith()的使用，MSDN演示了更加优雅的“流式”调用方法：

```c#
private void Button1_Click(object sender, EventArgs e)  
{  
   var backgroundScheduler = TaskScheduler.Default;  
   var uiScheduler = TaskScheduler.FromCurrentSynchronizationContext();  
   Task.Factory.StartNew(delegate { DoBackgroundComputation(); },  
                         backgroundScheduler).  
   ContinueWith(delegate { UpdateUI(); }, uiScheduler).  
                ContinueWith(delegate { DoAnotherBackgroundComputation(); },  
                             backgroundScheduler).  
                ContinueWith(delegate { UpdateUIAgain(); }, uiScheduler);  
}  
```

#### 5.4.2.5 RunSynchronously()

用于实现同步调用，直接在当前线程上调用该任务。

```c#
        public static void Main()
        {
            TaskMethod.DoTask("Just Main thread");
            Task t1 = new Task(TaskMethod.DoTask, "using Run Sync");
            t1.RunSynchronously();
            //输出结果
            //Just Main thread
            //Task id: no task, Thread id: 9
            //
            //using Run Sync
            //Task id:1, Thread id :9
        }
```

### 5.4.3 任务取消

当我们启动了一个task,出现异常或者用户点击取消等等，我们可以取消这个任务。

我们通过cancellation的tokens来取消一个Task。
在很多Task的Body里面包含循环，我们可以在轮询的时候判断IsCancellationRequested属性是否为True
如果是True的话就return或者抛出异常，抛出异常后面再说，因为还没有说异常处理的东西。

下面在代码中看下如何实现任务的取消，代码如下：

```c#
　　　　var tokenSource = new CancellationTokenSource();
            var token = tokenSource.Token;
            var task = Task.Factory.StartNew(() =>
            {
                for (var i = 0; i < 1000; i++)
                {
                    System.Threading.Thread.Sleep(1000);
                    if (token.IsCancellationRequested)
                    {
                        Console.WriteLine("Abort mission success!");
                        return;
                    }
                }
            }, token);
            token.Register(() =>
            {
                Console.WriteLine("Canceled");
            });
            Console.WriteLine("Press enter to cancel task...");
            Console.ReadKey();
            tokenSource.Cancel();123456789101112131415161718192021
```

这里开启了一个Task,并给token注册了一个方法，输出一条信息，然后执行ReadKey开始等待用户输入，用户点击回车后，执行tokenSource.Cancel方法，取消任务。

> 注意：
> 因为任务通常运行以异步方式在线程池线程上，创建并启动任务的线程将继续执行，一旦该任务已实例化。 
> 在某些情况下，当调用线程的主应用程序线程，该应用程序可能会终止之前任何任务实际开始执行。
> 其他情况下，应用程序的逻辑可能需要调用线程继续执行，仅当一个或多个任务执行完毕。 
> 您可以同步调用线程的执行，以及异步任务它启动通过调用 Wait 方法来等待要完成的一个或多个任务。 
> 若要等待完成一项任务，可以调用其 Task.Wait 方法。 
> 调用 Wait 方法将一直阻塞调用线程直到单一类实例都已完成执行。

### 5.4.4 接收任务的返回值

对于任务有返回值的情况，可使用Task<TResult>泛型类，TResult定义了返回值的类型，以下代码演示了调用返回int值的任务的方法。

```c#
        public static void Main()
        {
            var t5 = new Task<int>(TaskWithResult, Tuple.Create<int, int>(1, 2));
            t5.Start();
            t5.Wait();
            Console.WriteLine("adder results: {0}", t5.Result);

            Console.ReadKey(); 
        }

        public static int TaskWithResult(object o)
        {
            Tuple<int, int> adder = (Tuple<int, int>)o;
            return adder.Item1 + adder.Item2;
        }
```

## 5.5 任务的层次结构

如果在一个Task内部创建了另一个任务，这两者间就存在父/子的层次结构，当父任务被取消时，子任务也会被取消。

如果不希望使用该层次结构，可在创建子任务时选择TaskCreationOptions.DetachedFromParent。

# 6. BackgroundWorker控件

## 6.1 概述

C#提供了BackgroundWorker控件帮助用户更简单、安全地实现多线程运算。

该控件提供了DoWork, ProgressChanged 和 RunWorkerCompleted事件
为DoWork添加事件处理函数，再调用RunWorkerAsync()方法，即可创建一个新的线程执行DoWork任务

ProgressChanged和RunWorkerCompleted事件均在UI线程中执行，添加相应的处理函数，即可完成任务线程与UI线程间的交互，可用于显示任务的执行状态（完成百分比）、执行结果等。

同时，该控件还提供了CancleAsync()方法，以中断线程的执行
需注意的是，调用该方法后，只是将控件的CancellationPending属性置True，用户需在程序执行过程中查询该属性以判定是否应中断线程。

具体用法可参考MSDN：[BackgroundWorker用法范例](https://docs.microsoft.com/zh-cn/dotnet/api/system.componentmodel.backgroundworker?view=netframework-4.7.2)
可以看的出来，BackgroundWorker组件提供了一种执行异步操作（后台线程）的同时，并且还能妥妥的显示操作进度的解决方案。

## 6.2 属性表

### 6.2.1 WorkerReportsProgress
bool类型，指示BackgroundWorker是否可以报告进度更新。

- True时，可以成功调用ReportProgress方法
- 否则将引发InvalidOperationException异常

用法：

```c#
private BackgroundWorker bgWorker = new BackgroundWorker();
bgWorker.WorkerReportsProgress = true;
```

### 6.2.2 WorkerSupportsCancellation
bool类型，指示BackgroundWorker是否支持异步取消操作

- True时，将可以成功调用CancelAsync方法

- 否则将引发InvalidOperationException异
用法：
```c#
  bgWorker.WorkerSupportsCancellation = true;
```
### 6.2.3 CancellationPending
bool类型，指示应用程序是否已请求取消后台操作。
此属性通常放在用户执行的异步操作内部，用来判断用户是否取消执行异步操作。
当执行BackgroundWorker.CancelAsync()方法时，该属性值将变为True。
用法：

```c#
//在DoWork中键入如下代码
  for (int i = 0; i <= 100; i++)
  {
      if (bgWorker.CancellationPending)
      {
          e.Cancel = true;
          return;
      }
      else
      {
          bgWorker.ReportProgress(i,"Working");
          System.Threading.Thread.Sleep(10);
      }
  }   
```

### 6.2.4 IsBusy
bool类型，指示BackgroundWorker是否正在执行一个异步操作。
此属性通常放在BackgroundWorker.RunWorkerAsync()方法之前，避免多次调用RunWorkerAsync()方法引发异常。
当执行BackgroundWorker.RunWorkerAsync()方法是，该属性值将变为True。

```c#
 //防止重复执行异步操作引发错误
  if (bgWorker.IsBusy)
      return;
  bgWorker.RunWorkerAsync();
```

## 6.3 方法表

### 6.3.1 RunWorkerAsync()
开始执行一个后台操作。

调用该方法后，将触发BackgroundWorker.DoWork事件，并以异步的方式执行DoWork事件中的代码。
该方法还有一个带参数的重载方法：RunWorkerAsync(Object)。
该方法允许传递一个Object类型的参数到后台操作中，并且可以通过DoWork事件的DoWorkEventArgs.Argument属性将该参数提取出来。

> 注：当BackgroundWorker的IsBusy属性为True时，调用该方法将引发InvalidOperationException异常。

```c#
//在启动异步操作的地方键入代码
bgWorker.RunWorkerAsync("hello");
```

### 6.3.2 ReportProgress(Int percentProgress)
报告操作进度。

调用该方法后，将触发BackgroundWorker. ProgressChanged事件。
另外，该方法包含了一个int类型的参数percentProgress，用来表示当前异步操作所执行的进度百分比。

该方法还有一个重载方法：ReportProgress(Int percentProgress, Object userState)。
允许传递一个Object类型的状态对象到 ProgressChanged事件中
并且可以通过ProgressChanged事件的ProgressChangedEventArgs.UserState属性取得参数值。

> 注：调用该方法之前需确保WorkerReportsProgress属性值为True，否则将引发InvalidOperationException异常。

用法：

```c#
for (int i = 0; i <= 100; i++)
{c
    //向ProgressChanged报告进度
    bgWorker.ReportProgress(i,"Working");
    System.Threading.Thread.Sleep(10);
}
```

### 6.3.3 CancelAsync()
请求取消当前正在执行的异步操作。

调用该方法将使BackgroundWorker.CancellationPending属性设置为True。
但需要注意的是，并非每次调用CancelAsync()都能确保异步操作，CancelAsync()通常不适用于取消一个紧密执行的操作，更适用于在循环体中执行。
用法：

```c#
//在需要执行取消操作的地方键入以下代码
bgWorker.CancelAsync();
```

## 6.4 事件表

### 6.4.1 DoWork
用于承载异步操作。当调用BackgroundWorker.RunWorkerAsync()时触发。

需要注意的是：
由于DoWork事件内部的代码运行在非UI线程之上，所以在DoWork事件内部应避免于用户界面交互，
而于用户界面交互的操作应放置在ProgressChanged和RunWorkerCompleted事件中。

### 6.4.2 ProgressChanged
当调用BackgroundWorker.ReportProgress(int percentProgress)方式时触发该事件。
该事件的ProgressChangedEventArgs.ProgressPercentage属性可以接收来自ReportProgress方法传递的percentProgress参数值,ProgressChangedEventArgs.UserState属性可以接收来自ReportProgress方法传递的userState参数。

### 6.4.3 RunWorkerCompleted
异步操作完成或取消时执行的操作，当调用DoWork事件执行完成时触发。

该事件的RunWorkerCompletedEventArgs参数包含三个常用的属性Error,Cancelled,Result。其中，Error表示在执行异步操作期间发生的错误；Cancelled用于判断用户是否取消了异步操作；Result属性接收来自DoWork事件的DoWorkEventArgs参数的Result属性值，可用于传递异步操作的执行结果。

## 6.3 案例

```c#
using System;
using System.ComponentModel;
using System.Threading;
using System.Windows.Forms;
 
namespace bcworker
{
    public partial class Form1 : Form
    {
        //后台工作
        private BackgroundWorker bw = new BackgroundWorker();
 
        public Form1()
        {
            InitializeComponent();
            //后台工作初始化
            bw.WorkerReportsProgress = true;//报告进度
            bw.WorkerSupportsCancellation = true;//支持取消
            bw.DoWork += new DoWorkEventHandler(bgWorker_DoWork);//开始工作
            bw.ProgressChanged += new ProgressChangedEventHandler(bgWorker_ProgessChanged);//进度改变事件
            bw.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bgWorker_WorkerCompleted);//进度完成事件
        }
 
        private void btnStart_Click(object sender, EventArgs e)
        {
            //后台工作运行中，避免重入
            if (bw.IsBusy) return;
            bw.RunWorkerAsync("参数");//触发DoWork事件并异步执行，IsBusy置为True
        }
        //后台工作将异步执行
        public void bgWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            //(string)e.Argument == "参数";
            for (int i = 0; i <= 100; i++)
            {
 
                if (bw.CancellationPending)
                {//用户取消了工作
                    e.Cancel = true;
                    return;
                }
                else
                {
                    bw.ReportProgress(i, "Working");//报告进度，触发ProgressChanged事件
                    Thread.Sleep(10);//模拟工作
                }
            }
        }
        //进度改变事件
        public void bgWorker_ProgessChanged(object sender, ProgressChangedEventArgs e)
        {
            //(string)e.UserState=="Working"
            progressBar1.Value = e.ProgressPercentage;//取得进度更新控件，不用Invoke了
        }
        //后台工作执行完毕,IsBusy置为False
        public void bgWorker_WorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            //e.Error == null 是否发生错误
            //e.Cancelled 完成是由于取消还是正常完成
        }
 
        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (bw.IsBusy) bw.CancelAsync();//设置CancellationPending属性为True
        }
 
    }
}
```
