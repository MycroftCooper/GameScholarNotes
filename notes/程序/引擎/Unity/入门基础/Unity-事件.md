---
title: Unity-事件
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 程序
  - Unity
category: 程序/引擎/Unity/入门基础
note status: 终稿
---


# 1. 简介

Unity在C#Event特性的基础上进行了改良，Event只能用于纯代码编程，而UnityEvent可以和UnityEditor配合使用提高效率。

> 请先学习[C#事件](https://mycroftcooper.github.io/2021/03/21/C%E4%BA%95%E4%BA%8B%E4%BB%B6/)！

# 2. Unity事件的改良

在C#事件中我们举的例子中，可以看出.Net框架下的事件存在以下几个问题：

- 订阅的时机受限
  你必须在事件触发前完成事件的订阅
  事件处理程序将收不到订阅前的事件动态
- 不方便管理
  想要查看所有订阅事件的对象，我们就得查找项目中所有对事件的引用，然后再把每个对象的文件打开，可以说是非常麻烦了

为了避免上述的缺点，Unity使用Serializable（序列化）让用户可以在Editor中直接绑定所有对象的调用，即一目了然又不用担心把握不准订阅的时机，这就是**UnityEvent**。

#　3. UnityEvent类

**UnityEvent** 可添加到任何 **MonoBehaviour**，并从标准 .net 委托之类的代码中执行。当 **UnityEvent**添加到 **MonoBehaviour**时，它会出现在 **Inspector** 中，并可添加持久回调。

## 3.1 方法

| 方法名         | 作用                                   |
| -------------- | -------------------------------------- |
| AddListener    | 将一个非持久性侦听器添加到UnityEvent   |
| Invoke         | 调用所有已注册的回调（运行时和持久的） |
| RemoveListener | 从UnityEvent中删除一个非持久性侦听器   |

## 3.2 继承的成员

普通方法

| 方法名                     | 作用                                  |
| -------------------------- | ------------------------------------- |
| GetPersistentEventCount    | 获取已注册的持久性侦听器的数量        |
| GetPersistentMethodName    | 获取索引为index的侦听器的目标方法名称 |
| GetPersistentTarget        | 在索引index处获取侦听器的目标组件     |
| RemoveAllListeners         | 从事件中删除所有侦听器                |
| SetPersistentListenerState | 修改持久侦听器的执行状态              |

静态方法

| 方法名             | 作用                                             |
| ------------------ | ------------------------------------------------ |
| GetValidMethodInfo | 给定对象，函数名称和参数类型列表；找到匹配的方法 |

## 3.3 UnityEvent的使用

要在 Editor 中配置回调，需执行以下几个步骤：

1. 确保脚本导入/使用 `UnityEngine.Events`。
2. 选择 + 图标为回调添加字段
3. 选择要接收回调的 UnityEngine.Object（可使用对象选择器进行选择）
4. 选择要调用的函数
5. 可为事件添加多个回调

在 **Inspector** 中配置 **UnityEvent** 时，支持两种类型的函数调用：

- 静态。
  静态调用是预配置的调用，具有在 UI 中设置的预配置值。
  这意味着，在调用回调时，使用已在 UI 中输入的参数调用目标函数。
- 动态。
  使用从代码发送的参数调用动态调用，并与正在调用的 UnityEvent 类型相关。
  UI 会过滤回调，仅显示对 UnityEvent 有效的动态调用。

## 3.4 UnityEvent的多态（派生自定义事件）

默认情况下，**Monobehaviour** 中的 UnityEvent 动态绑定到 void 函数。

但不一定非得如此，**UnityEvent** 的子类支持绑定到最多包含 4 个参数的函数。

为此，您可以定义一个支持多个参数的自定义 **UnityEvent** 类。

此定义十分简单：

```c#
[Serializable]
public class StringEvent : UnityEvent <string> {}
```

订阅时订阅此派生类的实例而不是基类 **UnityEvent**，即可回调时传递各种参数。

然后，可通过调用**Invoke()**函数来对其进行调用。

> UnityEvent 可在其通用定义中定义最多 4 个参数。

## 3.5 使用案例：

将C#事件中的用例代码改写成Unity引擎内继承于**UnityEvent**的脚本：

> **Idol.cs**

```
using UnityEngine;
using UnityEngine.Events;

//使用Serializable序列化IdolEvent, 否则无法在Editor中显示
[System.Serializable]
public class IdolEvent : UnityEvent<string> {

}

public class Idol : MonoBehaviour {
    //public delegate void IdolBehaviour(string behaviour);
    //public event IdolBehaviour IdolDoSomethingHandler;
    public IdolEvent idolEvent;

    private void Start()
    {
        //Idol 决定搞事了, 如果他还有粉丝的话, 就必须全部都通知到
        if (idolEvent == null)
        {
            idolEvent = new IdolEvent();
        }
        idolEvent.Invoke("Idol give up writing.");
    }
}
```

> **SubscriberA.cs**

```
using UnityEngine;

public class SubscriberA : MonoBehaviour {
    /// <summary>
    /// 粉丝A是一个脑残粉
    /// </summary>
    /// <param name="idolAction"></param>
    public void LikeIdol(string idolAction)
    {
        print(idolAction + " I will support you forever!");
    }
}
```

> **SubscriberB.cs**

```
using UnityEngine;

public class SubscriberB : MonoBehaviour {
    /// <summary>
    /// 粉丝B是一个无脑黑
    /// </summary>
    /// <param name="idolAction"></param>
    public void HateIdol(string idolAction)
    {
        print(idolAction + " I will hate you forever!");
    }
}
```

将三个脚本绑定在三个GameObject上，此时两个粉丝还未实现订阅。和Event不同，UnityEvent在序列化后可以在Editor上显示，并且可以在Editor上设置好需要执行的函数

![image-20210315164014120](attachments/notes/程序/引擎/Unity/入门基础/Unity-事件/IMG-20250428110730362.png)

运行

![image-20210315160434052](attachments/notes/程序/引擎/Unity/入门基础/Unity-事件/IMG-20250428110730410.png)

除此之外，UnityEvent依然提供和C# Event 类似的运行时绑定的功能，不过不同的是，UnityEvent是一个对象，向其绑定函数是通过AddListener()方法实现的。以SubscriberB为例，我们可以在代码中实现同等效果的绑定：

> **SubscriberB.cs**

```
using UnityEngine;

public class SubscriberB : MonoBehaviour {
    public Idol myIdol;

    /// <summary>
    /// OnEnable在该脚本被启用时调用,你可以把它看做路转粉的开端
    /// </summary>
    private void OnEnable()
    {
        //粉丝通过订阅偶像来获取偶像的咨询, 并在得到讯息后执行相应的动作
        myIdol.idolEvent.AddListener(HateIdol);
    }

    /// <summary>
    /// OnEnable在该脚本被禁用时调用,你可以把它看做粉转路的开端
    /// </summary>
    private void OnDisable()
    {
        myIdol.idolEvent.RemoveListener(HateIdol);
    }

    /// <summary>
    /// 粉丝B是一个无脑黑
    /// </summary>
    /// <param name="idolAction"></param>
    public void HateIdol(string idolAction)
    {
        print(idolAction + " I will hate you forever!");
    }
}
```

> 由于UnityEvent是一个对象，所以自然可以允许我们通过继承实现自己的Event，实际上Unity中包括Button在内的许多UI组件的点击事件都是通过继承自UnityEvent来复写的。
> 可访问性(public/private)决定了UnityEvent的默认值，当可访问性为public时，默认会为其分配空间(new UnityEvent())；当可访问性为private时，默认UnityEvent为null，需要在Start()中为其分配内存。

# 4. EventSystem

EventSystem在Unity中是一个看起来像是专门服务于UGUI系统的组件。
每当在场景里创建UGUI对象时，Unity编辑器都会自动产生一个EventSystem对象放在场景中，与之相对应的也有一个Canvas对象，这两个对象就组成了UGUI系统的基础。
所有开发人员能看到和能用到的UGUI功能都依附于这两个对象。

## 4.1 UGUI中的EventSystem

使用**UGUI**制作游戏界面时，**EventSystem**的作用就像是一个专为**UGUI**设计好的消息中心，它管理着所有能参与消息处理的**UGUI**组件，包括但不仅限于**Panel**，**Image**，**Button**等。

如果在**Unity**创建好**EventSystem**之后观察该对象上附带的组件可以看到，至少有两个组件会被自动添加

- **EventSystem组件**，也就是消息机制的核心；

- **StandaloneInputModule组件**，这个是负责产生输入的组件。
  StandaloneInputModule本身是个继承自BaseInputModule的实现类，而类似的实现类Unity中还有另外几个，甚至用户也能自定义一个实现类用于事件处理。

看起来这个系统似乎缺少一个部分，就是怎么确定某个事件是发给谁的。
因此为了确定操作对象究竟是哪个，一个必不可少的步骤就是检测。

在GUI之外的游戏场景编辑中，要感知当前鼠标对准的物体是哪个，最常用的方法就是射线检测了：
从摄像机对着鼠标指向的方向发出射线，通过碰撞来检测目标。

这个方案简单实用，可以说在游戏中随处可见，而UGUI所使用的机制也就是这一套射线检测，只不过射线的发射和碰撞处理都被隐藏在了组件之中。

所以，缺失的部分就是射线检测模块，这个模块不在EventSystem上，而是在Canvas上挂着。
这很好理解，Canvas是所有UGUI组件的根对象，所以由他来负责射线处理是相当正常的解决方案，至于射线到底碰到了谁，UGUI组件自然有射线接收反馈来确定。

Canvas上挂载的组件叫做GraphicRaycaster，它实际上是BaseRaycaster的实现类，专门负责Canvas之下的图形对象的射线检测与计算问题。

至此，UGUI中的情况就比较清晰了：

- **EventSystem对象**
  负责管理所有事件相关对象
  该对象下挂载了EventSystem组件和StandaloneInputModule组件，前者为管理脚本，后者为输入模块
  
- **Canvas对象**
  下挂载了GraphicRaycaster负责处理射线相关运算
  用户的操作都会通过射线检测来映射到UGUI组件上，InputModule将用户的操作转化为射线检测，Raycaster则找到目标对象并通知EventSystem，最后EventSystem发送事件让目标对象进行响应
  
  如下图所示：
  
  <img src="/images/Unity中的事件/UGUI结构.png" alt="UGUI结构"  />

### 4.1.1 事件响应

UGUI的事件响应处理有多种方式，这里我们介绍两种常用方法

#### 4.1.1.1 实现特定接口处理事件响应

由于Canvas挂载了GraphicRaycaster组件，因此在Canvas对象之下的所有GUI对象都可以通过挂载脚本并且实现一些和事件相关的接口来处理事件，比如常见的IPointerClickHandler接口就是用于处理点击事件的接口。

可以实现的接口列表大概如下所示：

| 接口名                                                      | 作用                                             |
| ----------------------------------------------------------- | ------------------------------------------------ |
| IPointerEnterHandler - OnPointerEnter                       | 当光标进入对象时调用                             |
| IPointerExitHandler - OnPointerExit                         | 当光标退出对象时调用                             |
| IPointerDownHandler - OnPointerDown                         | 在对象上按下指针时调用                           |
| IPointerUpHandler - OnPointerUp                             | 松开鼠标时调用（在指针正在点击的游戏对象上调用） |
| IPointerClickHandler - OnPointerClick                       | 在同一对象上按下再松开指针时调用                 |
| IInitializePotentialDragHandler - OnInitializePotentialDrag | 在找到拖动目标时调用，可用于初始化值             |
| IBeginDragHandler - OnBeginDrag                             | 即将开始拖动时在拖动对象上调用                   |
| IDragHandler - OnDrag                                       | 发生拖动时在拖动对象上调用                       |
| IEndDragHandler - OnEndDrag                                 | 拖动完成时在拖动对象上调用                       |
| IDropHandler - OnDrop                                       | 在拖动目标对象上调用                             |
| IScrollHandler - OnScroll                                   | 当鼠标滚轮滚动时调用                             |
| IUpdateSelectedHandler - OnUpdateSelected                   | 每次勾选时在选定对象上调用                       |
| ISelectHandler - OnSelect                                   | 当对象成为选定对象时调用                         |
| IDeselectHandler - OnDeselect                               | 取消选择选定对象时调用                           |
| IMoveHandler - OnMove                                       | 发生移动事件（上、下、左、右等）时调用           |
| ISubmitHandler - OnSubmit                                   | 按下 Submit 按钮时调用                           |
| ICancelHandler - OnCancel                                   | 按下 Cancel 按钮时调用                           |

只要在挂载的脚本中实现所需要的接口，对应的事件回调也就可以执行了。

代码如下：

```c#
public class EventTest : MonoBehaviour, IPointerClickHandler, IDragHandler, IPointerDownHandler, IPointerUpHandler 
{
    // Execute every update when dragging
    public void OnDrag(PointerEventData eventData) {}

    // quick down and up will perform click
    public void OnPointerClick(PointerEventData eventData) {}

    public void OnPointerDown(PointerEventData eventData) // pointer down

    public void OnPointerUp(PointerEventData eventData) // pointer up

    void Start () {}// Use this for initialization

    void Update () {}// Update is called once per frame
}
```

#### 4.1.1.2  利用EventTrigger组件处理事件响应

EventTrigger组件是一个通用的事件触发器，它可以用来管理单个组件上的所有可能触发的事件。
其使用方法有两种：

- 编辑器设定方法

  指定组件上添加EventTrigger组件，然后为它添加触发事件类型，再为指定类型添加回调方法。

这种做法的操作很简单，而且灵活性也相当高，想要跨脚本调用方法只需要鼠标拖一拖点一点就好。
但是这样在编辑器中设定事件回调会在项目变大时造成比较严重的管理障碍，尤其是当绑定了EventTrigger以及回调指向的物体有修改或者删除情况时，所造成的引用缺失需要花费更多的时间进行处理。

> 略

- 动态设定方法

想要更好地管理大量的事件触发和回调处理，可以尝试采用动态设置的方案。
所谓动态设置其实就是在代码中设置EventTrigger来处理事件回调，方法也很简单

>略

## 4.2 场景中的EventSystem

EventSystem也能在一般的场景中使用。
如果没有实现自己的事件系统而又需要一些回调处理的方案的话，可以试着直接将EventSystem应用到一般的游戏场景中。
要这样使用EventSystem的话，核心在于前文提到过的事件系统三大部分：

- EventSystem
- InputModule
- Raycaster。

通过考察三者各自的作用可知，EventSystem和InputModule都和EventSystem对象紧密结合，而唯有Raycaster是孤零零地在Canvas对象上处理所有Canvas内部的射线检测。

那么想要借助EventSystem的能力来处理场景中的事件传递，肯定不能去动EventSystem对象，毕竟这是建立事件系统时自动创建的对象，不用说一定是要用到的。
那么就只剩下Raycaster了，这个组件在Canvas上挂载，用于处理射线检测，那么如果想要在场景里进行射线检测，应该把组件挂到哪里呢？

一般而言，摄像机是一个不错的选择，因为通常来说游戏大部分时候都只有一个摄像机，而且基本上可以操作的界面也只隶属于一个摄像机，因此将Raycaster挂载到游戏的主摄像机上就是个很自然的考虑了。
​ 而Unity编辑器提供的Raycaster一共有三种

- GraphicRaycaster 界面射线处理器，用于Canvas
- Physics2DRaycaster 2D场景射线处理器，用于2D场景
- PhysicsRaycaster 3D场景射线处理器，用于3D场景

因此要用到的就是后两种了，根据当前场景的特点选择相应的Raycaster并挂载到主摄像机上即可，剩下的就和UGUI中很像了。

不过需要注意的是，在UGUI中想要让组件可以响应事件必须将组件的RaycasterTarget属性勾选上，而场景中则要在需要响应事件的对象上挂载碰撞器，满足需求的任何碰撞器都可以。
然后就和前文讲的一样，实现对应接口或者添加EventTrigger组件来实现各种事件回调。

使用这样的方案实现的回调，其传递的数据PointerEventData中包含的位置参数还是屏幕位置，而且跟像素相关，以屏幕左下角为原点的坐标。
如果希望获取触发事件时的世界坐标，则需要用到PointerEventData类中的pointerCurrentRaycast成员，该成员表示了射线检测的结果，因此其中包含碰撞点的世界坐标。
