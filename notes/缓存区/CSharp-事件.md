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

C#事件的核心思想是基于windows消息处理机制的，只是封装的更好，让开发者无须知道底层的消息处理机制，就可以开发出强大的基于事件的应用程序来。

关于事件，比较形象的比喻就是广播者和订阅者。事件执行时会广播给订阅他函数，告诉每个函数该运行了，但不管函数的实现细节。

事件类似于异常，因为它们都由对象引发(抛出)，并且都可以通过我们提供的代码来处理。
但它们也有个重要区别：事件并没有与tny. catch类似的结构来处理事件，你必须订阅(Subseribe)它们。

订阅一个事件的含义是提供代码，在事件发生时执行这些代码，它们称为事件处理程序。

单个事件可供多个处理程序订阅，在该事件发生时，这些处理程序都会被调用，事件处理程序可以在引发事件的类中，也可以在其他类中。

事件处理程序本身都是简单方法。对事件处理方法的唯一限制是它必须匹配事件所要求的返回类型和参数，这个限制是事件定义的一部分，由一个委托指定。

> 学习事件前请先学习
> [委托](https://mycroftcooper.github.io/2021/03/21/C%E4%BA%95%E5%A7%94%E6%89%98/)

# 2. 事件与委托的关系与区别

**事件Event**是在**多播委托multicast delegate**的基础上演变而来。

- event是升级版delegate，用event实现的功能用delegate同样可以实现。
- event较之delegate具有继承方面的安全性。
  用event，别的类只能订阅/取消订阅，如果用一个 public delegate成员变量，别的类可以调用或者覆盖我们的delegate变量。
- 一般来说，如果你要创建一个包含多个类的动态体系，使用event而不是delegate。

# 3. 使用事件的优点

在以往我们编程时，往往采用等待机制，为了等待某件事情的发生，需要不断地检测某些判断变量，而引入事件编程后，大大简化了这种过程：

- 可以很方便地确定程序执行顺序。

- 当事件驱动程序等待事件时，它不占用很多资源。
  事件驱动程序与过程式程序最大的不同就在于，程序不再不停地检查输入设备，而是呆着不动，等待消息的到来,每个输入的消息会被排进队列，等待程序处理它。
  如果没有消息在等待，则程序会把控制交回给操作系统，以运行其他程序。

- 简化了编程。
  操作系统只是简单地将消息传送给对象，由对象的事件驱动程序确定事件的处理方法。
  操作系统不必知道程序的内部工作机制，只是需要知道如何与对象进行对话，也就是如何传递消息。
- 在事件源和事件接收器之间启用非常小的耦合。 
  这两个组件可能不会由同一个组织编写，甚至可能会通过完全不同的计划进行更新。
- 订阅事件并从同一事件取消订阅应该非常简单。
- 事件源应支持多个事件订阅服务器。 
  它还应支持不附加任何事件订阅服务器。

# 4. 使用事件需要的步骤

我们编写一个偶像搞事事件来描述使用事件的步骤。

代码与步骤如下：
## 4.1 创建一个委托

```c#
//Idol.cs
public delegate void IdolBehaviour(string behaviour);
```

> 编写在**Idol.cs**中的偶像行为委托，参数是行为字符串，返回值为空

## 4.2 将委托与已有或自定义事件关联

.Net类库中的很多事件都是已经定制好的，所以他们也就有相应的一个委托，在编写关联事件处理程序——也就是当有事件发生时我们要执行的方法的时候我们需要和这个委托有相同的签名

```c#
//Idol.cs
public static event IdolBehaviour IdolDoSomethingHandler;
```

> 编写在**Idol.cs**中的偶像搞事事件，与IdolBehaviour偶像行为委托关联

## 4.3 编写事件处理程序

```c#
//SubscriberA.cs
public void LikeIdol(string idolAction)
{
    print(idolAction + " I will support you forever!");
}
//SubscriberB.cs
public void HateIdol(string idolAction)
{
    print(idolAction + " I will hate you forever!");
}
```

> 分别编写在**SubscriberA.cs**与**SubscriberB.cs**的两个事件处理程序函数

## 4.4 生成委托实例

```c#
//Idol.cs
IdolBehaviour myIdolBehaviour=new IdolBehaviour();
```

> 这步可以省略
> 我们在声明event delegate时并没有给它分配内存，使用时直接赋值或添加即可

## 4.5 订阅事件

把这个委托实例添加到产生事件对象的事件列表中去，这个过程又叫订阅事件

```c#
//SubscriberA.cs
// OnEnable在该脚本被启用时调用,你可以把它看做路转粉的开端
private void OnEnable()
{
    //粉丝通过订阅偶像来获取偶像的咨询, 并在得到讯息后执行相应的动作
    Idol.IdolDoSomethingHandler += LikeIdol;
}
// OnEnable在该脚本被禁用时调用,你可以把它看做粉转路的开端
private void OnDisable()
{
    Idol.IdolDoSomethingHandler -= LikeIdol;
}
```

```c#
//SubscriberB.cs
//OnEnable在该脚本被启用时调用,你可以把它看做路转粉的开端
private void OnEnable()
{
    //粉丝通过订阅偶像来获取偶像的咨询, 并在得到讯息后执行相应的动作
    Idol.IdolDoSomethingHandler += HateIdol;
}
// OnEnable在该脚本被禁用时调用,你可以把它看做粉转路的开端
private void OnDisable()
{
    Idol.IdolDoSomethingHandler -= HateIdol;
}
```

> 分别编写在**SubscriberA.cs**与**SubscriberB.cs**中用于事件订阅

## 4.6 事件触发

```c#
//Idol.cs
if (IdolDoSomethingHandler != null)
{
    IdolDoSomethingHandler("Idol give up writing.");
}
```

> 别编写在**Idol.cs**中需要触发事件的地方，Idol 决定搞事了, 如果他还有粉丝的话, 就必须全部都通知到
## 4.7 代码汇总

结果以上6个步骤后，一个自定义事件就完成了，代码汇总如下：

> **Idol.cs**

```c#
using UnityEngine;
public class Idol : MonoBehaviour 
{
    public delegate void IdolBehaviour(string behaviour);
    public static event IdolBehaviour IdolDoSomethingHandler;

    private void Start()
    {
        //Idol 决定搞事了, 如果他还有粉丝的话, 就必须全部都通知到
        if (IdolDoSomethingHandler != null)
        {
            IdolDoSomethingHandler("Idol give up writing.");
        }
    }
}
```

> **SubscriberA.cs**

```c#
using UnityEngine;
public class SubscriberA : MonoBehaviour 
{
    // OnEnable在该脚本被启用时调用,你可以把它看做路转粉的开端
    private void OnEnable()
    {
        //粉丝通过订阅偶像来获取偶像的咨询, 并在得到讯息后执行相应的动作
        Idol.IdolDoSomethingHandler += LikeIdol;
    }

    // OnEnable在该脚本被禁用时调用,你可以把它看做粉转路的开端
    private void OnDisable()
    {
        Idol.IdolDoSomethingHandler -= LikeIdol;
    }

    // 粉丝A是一个脑残粉
    // <param name="idolAction"></param>
    public void LikeIdol(string idolAction)
    {
        print(idolAction + " I will support you forever!");
    }
}
```

> **SubscriberB.cs**

```c#
using UnityEngine;
public class SubscriberB : MonoBehaviour 
{
    // OnEnable在该脚本被启用时调用,你可以把它看做路转粉的开端
    private void OnEnable()
    {
        //粉丝通过订阅偶像来获取偶像的咨询, 并在得到讯息后执行相应的动作
        Idol.IdolDoSomethingHandler += HateIdol;
    }
    // OnEnable在该脚本被禁用时调用,你可以把它看做粉转路的开端
    private void OnDisable()
    {
        Idol.IdolDoSomethingHandler -= HateIdol;
    }
    // 粉丝B是一个无脑黑
    // <param name="idolAction"></param>
    public void HateIdol(string idolAction)
    {
        print(idolAction + " I will hate you forever!");
    }
}
```
# 5.事件产生和实现的流程

1. 定义A为产生事件的实例，a为A产生的一个事件

2. 定义B为接收事件的实例，b为处理事件的方法

3. A由于用户(程序编写者或程序使用者)或者系统产生一个a事件(例如点击一个Button，产生一个Click事件)

4. A通过事件列表中的委托对象将这个事件通知给B

5. B接到一个事件通知(实际是B.b利用委托来实现事件的接收)

6. 调用B.b方法完成事件处理

# 6. 参考网站
- https://www.jb51.net/article/133032.htm
-  https://fgrain.github.io/2021/03/14/UnityEvent%E5%92%8C%E4%BA%8B%E4%BB%B6%E7%B3%BB%E7%BB%9F/
