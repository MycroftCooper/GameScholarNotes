---
title: Socket原理
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# Unity 脚本基类 MonoBehaviour 

## 1. MonoBehaviour 简介

**MonoBehaviour** 是 **Unity** 中所有脚本的基类。

如果你使用**JS**的话，脚本会自动继承**MonoBehaviour**。

如果使用**C#**的话，你需要显式继承**MonoBehaviour**。

## 2. 生命周期

下面用一张图来更形象地说明一下这几个类的在**MonoBehaviour**的*生命周期*中是如何被调用的：
![这里写图片描述](./attachments/MonoBehaviour基类/a7c168cd.png)

## 3. 常用方法

### 3.1 不可重写函数：

#### 3.1.1 Invoke函数

`function Invoke (methodName : string, time : float) : void`
在 **time** 秒之后，调用 **methodName** 方法；

```c#
public class example : MonoBehaviour {
public Rigidbody projectile;
void LaunchProjectile() {
    Rigidbody instance = Instantiate(projectile);
    instance.velocity = Random.insideUnitSphere * 5;
}
public void Awake() {
    Invoke("LaunchProjectile", 2);
}
}
```

#### 3.1.2 InvokeRepeating

`function InvokeRepeating (methodName : string, time : float, repeatRate : float) : void`
从第一次调用开始,每隔**repeatRate**时间调用一次.

#### 3.1.3 CancelInvoke

`function CancelInvoke () : void`
取消这个**MonoBehaviour**上的所有调用**Invoke**。

#### 3.1.4 IsInvoking

`function IsInvoking (methodName : string) : bool`
某指定函数是否在等候调用。

#### 3.1.5 StartCoroutine

`function StartCoroutine (routine : IEnumerator) : Coroutine`
一个协同程序在执行过程中,可以在任意位置使用 **yield** 语句。

**yield** 的返回值控制何时恢复协同程序向下执行。

协同程序在对象自有帧执行过程中堪称优秀。协同程序在性能上没有更多的开销。

**StartCoroutine**函数是立刻返回的,但是**yield**可以延迟结果。直到协同程序执行完毕。

#### 3.1.6 StopCoroutine / StopAllCoroutines

### 3.2 可重写函数：

可重写函数会在游戏中发生某些事件的时候被调用。

我们在**Unity**中最常用到的几个可重写函数是这几个：

| 可重写函数    | 描述                                                         |
| :------------ | ------------------------------------------------------------ |
| `Awake`       | 当一个脚本被实例化时，**Awake** 被调用。我们大多在这个类中完成成员变量的初始化。 |
| `Start`       | 仅在 **Update** 函数第一次被调用前调用。因为它是在**Awake** 之后被调用的，我们可以把一些需要依赖 **Awake** 的变量放在**Start**里面初始化。 同时我们还大多在这个类中执行 **StartCoroutine** 进行一些协程的触发。要注意在用C#写脚本时，必须使用 **StartCoroutine** 开始一个协程，但是如果使用的是 **JavaScript**，则不需要这么做。 |
| `Update`      | 当开始播放游戏帧时（此时，**GameObject** 已实例化完毕），其 **Update **在 每一帧 被调用。 |
| `LateUpdate`  | **LateUpdate** 是在所有 **Update** 函数调用后被调用。        |
| `FixedUpdate` | 当 **MonoBehaviour**启用时，其 **FixedUpdate** 在每一固定帧被调用 |
| `OnEnable`    | 当对象变为可用或激活状态时此函数被调用                       |
| `OnDisable`   | 当对象变为不可用或非激活状态时此函数被调用                   |
| `OnDestroy`   | 当 **MonoBehaviour** 将被销毁时，这个函数被调用              |

#### 3.2.1 Update

当 **MonoBehaviour** 实例化完成之后，**Update** 在每一帧被调用。

所以Update函数可以用来实现用户输入、角色移动和角色行动等功能。

基本上大部分游戏逻辑都离不开Update函数。

Unity 提供了非常多的基本方法来读取输入、查找某个游戏物体、查找组件、修改组件信息等，这些方法都可以在Update函数中使用，用来完成实际的游戏功能。

#### 3.2.2 LateUpdate

**LateUpdate** 是在所有 **Update** 函数调用后被调用。这可用于调整脚本执行顺序。

例如:当物体在Update里移动时，跟随物体的相机可以在**LateUpdate**里实现。

#### 3.2.3 FixedUpdate

处理 **Rigidbody** 时，需要用**FixedUpdate**代替**Update**。

例如:给刚体加一个作用力时，你必须应用作用力在**FixedUpdate**里的固定帧，而不是**Update**中的帧。(两者帧长不同)

#### 3.2.4 Awake

**Awake** 用于在游戏开始之前初始化变量或游戏状态。在脚本整个生命周期内它仅被调用一次。**Awake** 在所有对象被初始化之后调用，所以你可以安全的与其他对象对话或用诸如 **GameObject.FindWithTag** 这样的函数搜索它们。

每个游戏物体上的**Awke**以随机的顺序被调用。因此，你应该用**Awake**来设置脚本间的引用，并用**Start**来传递信息**Awake**总是在**Start**之前被调用。它不能用来执行协同程序。

C#和Boo用户注意：**Awake** 不同于构造函数，物体被构造时并没有定义组件的序列化状态。**Awake**像构造函数一样只被调用一次。

#### 3.2.5 Start

**Start**在**behaviour**的生命周期中只被调用一次。
它和 **Awake** 的不同是，**Start** 只在脚本实例被启用时调用。你可以按需调整延迟初始化代码。**Awake** 总是在**Start**之前执行。

Start函数适合用来做一些初始化工作。
对有经验的程序编写者来说，要注意脚本组件通常不使用构造函数来做初始化，因为构造函数可控制性较差，会导致调用时机和预想的不一致。 所以最好的方式是遵循Unity的设计惯例。

#### 3.2.6 OnMouseEnter ／OnMouseOver ／ OnMouseExit ／ OnMouseDown ／ OnMouseUp ／ OnMouseDrag

当鼠标进入 ／ 悬浮 ／ 移出 ／ 点击 ／ 释放 ／ 拖拽**GUIElement**(GUI元素)或**Collider**(碰撞体)中时调用**OnMouseEnter**。

#### 3.2.7 OnTriggerEnter／OnTriggerExit／OnTriggerStay

当**Collider**(碰撞体)进入 ／ 退出 ／ 停留在 **trigger**(触发器)时调用**OnTriggerEnter**。

**OnTriggerStay** 将会在每一帧被调用。

#### 3.2.8 OnCollisionEnter／OnCollisionExit／OnCollisionStay

当此**collider/rigidbody**触发另一个**rigidbody/collider**时，被调用。

**OnCollisionStay** 将会在每一帧被调用。



## 4. 脚本与GameObject的关系

被显式添加到 **Hierarchy** 中的 **GameObject** 会被最先实例化，**GameObject** 被实例化的顺序是从下往上。**GameObject** 被实例化的同时，加载其组件 **component** 并实例化，如果挂载了脚本组件，则实例化脚本组件时，将调用脚本的 **Awake** 方法，组件的实例化顺序是也是从下往上。在所有显式的 **GameObject** 及其组件被实例化完成之前，游戏不会开始播放帧。

当 **GameObject** 实例化工作完成之后，将开始播放游戏帧。每个脚本的第一帧都是调用 **Start** 方法，其后每一帧调用 **Update**，而且每个脚本在每一帧中的调用顺序是从下往上。

> 总结：被挂载到 **GameObject** 下面的脚本会被实例化成 **GameObject** 的一个成员。

### 4.1 脚本变量的引用

在脚本中声明另一个脚本的变量。在 **ClassA** 中建立一个 **public** 的变量类型是 **ClassB**。

```c#
// class A
public class classA : MonoBehaviour {

    public classB b;

    // Use this for initialization
    void Start () {

    }

    // Update is called once per frame
    void Update () {

    }
}

// class B
public class classB : MonoBehaviour {

    public classA a;
    // Use this for initialization
    void Start () {

    }

    // Update is called once per frame
    void Update () {

    }
}
```

#### 4.1.1 非同一个 GameObject 的脚本引用

情况如下：

![这里写图片描述](./attachments/MonoBehaviour基类/a9dccf10.png)
![这里写图片描述](./attachments/MonoBehaviour基类/ae1c8bb1.png)



此时，如果 **classA** 中的成员 **B** 想要引用由 **GameObjectB** new 出来的 **classB** 对象，只需要将 **GameObjectB** 拖拽到 **GameObjectA** 中 **classA** 脚本即可。

#### 4.1.2 同一个 GameObject 中互相引用

情况如下：




![这里写图片描述](./attachments/MonoBehaviour基类/2416e0d0.png)



此时，发现没法通过拖拽的方式建立 **classA** 和 **classB** 的引用。因为 **Unity** 编辑器里面的拖拽绑定方式是 **GameObject** 级别的。

那么此时如何解决互相引用的问题呢？此时，需要用到 **gameObject** 这个变量。

被挂载到 **GameObject** 中的脚本，被实例化时，其内部继承自 **Monobehavior** 的 **gameObject** 成员会绑定所挂载的 **GameObject** 对象。可以注意到，在本例中，**classA** 和 **classB** 都是同一个 **GameObject** 下的组件，所以通过 **GetComponent** 便可以获得另一个脚本变量的引用。

```c#
// class A
public class classA : MonoBehaviour {

    public classB b;

    // Use this for initialization
    void Start () {
        b = gameObject.GetComponent ("ClassB") as ClassB;
    }

    // Update is called once per frame
    void Update () {

    }
}

// class B
public class classB : MonoBehaviour {

    public classA a;
    // Use this for initialization
    void Start () {
       a = gameObject.GetComponent ("ClassA") as ClassA;
    }

    // Update is called once per frame
    void Update () {

    }
}
```

#### 4.1.3 父子关系的 GameObject 中引用

把问题引申一步,还是那两个脚本**ClassA**,**ClassB**,不过这回不是绑在同一个**GameObject**上面，而是分辨绑定在两个**GameObject**：Parent(ClassA),Child(ClassB)




![这里写图片描述](./attachments/MonoBehaviour基类/703f4988.png)



首先还是来尝试拖拽，虽然无法在Unity的编辑器中通过拖拽互相引用脚本(Componet),不过绑定 **GameObject** 是可以的。所以只需要建立两个**public**的变量，然后类型都是 **GameObject**，在Unity里面互相拖拽引用,最后在 **Start** 函数时候通过已经绑定好的 **gameObject** 调用其 **GetComponent** 方法即可。

的确，这个方法是可行，不过有个更好的方法就是使用 **Transform**。**Transform** 是一个很特殊的**Component**，其内部保留着 **GameObject**之间的显示树结构.所以就上面的例子来说，当要从 **Child** 访问到 **Parent**，只需要在 **Child** 对应的脚本里面写 `transform.parent.gameObject.GetComponent() `即可

返过来就相对麻烦一点,因为无法保证一个**parent**只有一个**child**，所以无法简单的使用 **transform.child.gameObject**这样访问, 但是Unity给我们提供了一个很方便的函数，那就是**Find**。

需要注意的是**Find**只能查找其**Child**,举个复杂点的例子

**Parent->ChildA->ChildB->ChildC**

当在 **Patent** 中想要找到 **ChildC**中的一个**Component**时候，调用 `transform.Find(“ChildA/ChildB/ChildC”).gameObject;`

## 5. 普通类与继承MonoBehaviour类的区别：

- 1.继承**MonoBehaviour**的类不需要创建它的实例，也不能自己创建(用new)，因为从**MonoBehaviour**继承过来的类Unity会自动创建实例，并且调用被重载的函数(Awake，Start.....)。

  如果用new会出现警告，警告说的很明显，就是如果继承了MonoBehaviour就不允许你用new创建，你可以用添加组件的方式替代，或者根本没有基类(不继承MonoBehaviour的普通类)，但是好像并不影响程序，这点很奇怪。

- 2.不继承MonoBehaviour不能使用Invoke，Coroutine，print以及生命周期函数等。

- 3.不继承MonoBehaviour不能挂在到Inspector上，也就是说不能当组件使用也不能看到一些数据。

## 6. MonoBehaviour 的那些坑

- **私有（private）**和**保护（protected）**变量只能在**专家模式**中显示。属性不被序列化或显示在检视面板。
- 不要使用**命名空间（namespace）**
- 记得使用 缓存组件查找， 即在**MonoBehaviour**的长远方法中经常被访问的组件最好在把它当作一个私有成员变量存储起来。
- 在游戏里经常出现需要检测敌人和我方距离的问题，这时如果要寻找所有的敌人，显然要消耗的运算量太大了，所以最好的办法是将攻击范围使用**Collider**表示，然后将**Collider**的**isTrigger**设置为**True**。最后使用**OnTriggerEnter**来做攻击范围内的距离检测，这样会极大提升程序性能。

>整理自: https://blog.csdn.net/hihozoo/article/details/66970467
