---
title: Unity-射线检测
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

射线是3D世界中一个点向一个方向发射的一条无终点的线。在发射的轨迹中，一旦与其他物体发生碰撞，它就会停止。

在游戏中，射线检测可以有如下用途：

- 检测光标位置的三维物体
- 检测角色前面的物体（自动开门）
- 从空中向下检测（凹凸不平的地形的瞬移）
- 测量距离（激光测距）

等等，可以说是相当重要了。

# 2. Ray射线

## 2.1 定义
要想使用射线检测，就要先定义一条射线。而Ray就是Unity提供的一个封装好的射线结构体。

一条无穷的线，开始于origin点，朝向direction方向

> 根据项目验证来看:其默认长度为单位向量，只有对direction进行乘以倍率，才可实现延长射线，而非无穷

## 2.2 结构
Ray是一个结构体：

```c#
static Ray (Vector3 origin,Vector3 direction)
```

其中参数为：

- Origin： 射线的起点    
- direction：射线的方向

初始化方法：

```c#
Ray ray = new Ray(Vector3 origin,Vector3 direction)
```

## 2.3 常见用法

- 从物体中心创建一条指向前方的射线:
  `Ray ray = new Ray(transform.position,transform.forward)`

- 从摄像机产生、指向屏幕上光标的射线
  `Ray camerRay = Camera.main.ScreenPointToRay(Input.mousePosition)`：。

  > 相机为perspective模式:
  > 射线在相机梯形视野内发散；
  > 相机为orthoGraphic模式:
  > 则为垂直与相机面的直线段;

# 3. RaycastHit 光线投射碰撞信息

**定义：**
通过射线检测得到的碰撞信息。

常用信息如下：

**常用参数：**

- collider 
  射线检测到的collider，这个非常常用，因为能根据collider.gameObject获取到对应GameObject
- distance 
  射线发射源与检测到的位置的距离
- normal 
  射线碰撞位置的法线
- point 
  射线碰撞位置的世界坐标
- transform 
  射线碰撞物体的transform组件

# 4. LayerMask 层级蒙版

**Layer与LayerMask的关系:**

- Layer是0-31的数字
- LayerMask是按位对应0-31

> 如>
> Layer9：Enemy
> LayerMask用二进制表示：
> 00000000 00000000 000000**1**0 00000000
> 从右往左第10位，等于表达式：1<<9

这是一种二进制思想，使用mask(掩码)表示时，可以同时表示多个状态的有无。

**根据Layer获取LayerMask:**

- 如果你知道Layer的名字:
  可以通过LayerMask.GetMask()方法获取
  `int mask = LayerMask.GetMask("Player", "NPC");`

  > 注意这个方法可以传入一个或多个string类型参数。

- 如果你知道Layer的数字:
  比如Layer9，可以通过移位操作1<<9来获取

  ```c#
  int playerMask = 1<<9;
  int npcMask = 1<<10;
  int mask = playerMask | npcMask; // 通过位操作“或(|)”同时检测player 和 npc层
  int reverse = ~mask; // 通过位操作"求反(~)"，检测除了player 和 npc的其他层
  ```


# 5. 检测方法

## 5.1 线型检测

在使用射线检测时，调用的是`public static bool Physics.Raycast()`函数

### 5.1.1 Physics.Raycast 光线投射

#### 5.1.1.1 功能
在已有一条射线（也可无）的基础上，使用射线（新建射线）进行一定距离内的定向检测。

- 可修改射线长度
- 可限制其检测的Layer层
- 可得到射线检测到的碰撞信息

> 仅能检测到**第一个被射线碰撞的物体**，后面的物体无法被检测到



**适用场合：**
配合相机坐标转换实现各类交互

#### 5.1.1.2 用法

**用法一：**

 ```c#
 Raycast(
  	transform.position, 
      Vector.forward, 
      distance, 
      LayerMask.GetMask("Enemy")
 );
 ```

  - `transform.position`：
    从物体中心点起
    
  - `Vector.forward`：
    朝向该方向发射一条射线
    
  - `distance`：
    该射线长度为distance
    
  - `LayerMask.GetMask("Enemy")`：
    射线可检测到的层为Enemy层
    
  - 返回bool类型


**用法二：**

```c#
Raycast(
    transform.position, 
    Vector.forward, 
    distance, 
    out RaycastHitInformation ,
    LayerMask.GetMask("Enemy")
)；
```

- 相同参数同上
- `out RaycastHitInformation`：
  将碰撞信息反馈到RaycastHitInformation上

**用法三：**

```c#
Raycast(
    MyRay, 
    distance, 
    LayerMash.GetMask("Enemy")
)
```

- 相同参数同上
- `MyRay`
  从已有的射线MyRay出发
- `distance`
  长度延伸至distance

**用法四：**

```c#
Raycast(
	MyRay, 
    out RaycastHitInformation, 
    distance, 
    LayerMask.GetMask("Enemy")
)
```

- 相同参数同上

### 5.1.2 Physics.RaycastAll 所有光线投射

#### 5.1.2.1 功能

机理用法大致同Raycast，区别在于可检测射线路径上的**所有物体**，**返回RaycastHit[]** 。
其他带All后缀的方法也同理

**适用场合：**
穿透性检测

#### 5.1.2.2 用法

**用法一：**

```c#
RaycastHit[] hits = RaycastAll(
    Vector3.zero, 
    Vector.forward, 
    distance, 
    LayerMask.GetMask("Enemy")
)
```

**用法二：**

```c#
RaycastHit[] hits = RaycastAll(
    MyRay, 
    distance, 
    LayerMash.GetMask("Enemy")
)
```

### 5.1.3 线段投射

#### 5.1.3.1 功能

建立**某两点之间**的射线进行检测，返回bool类型

**适用场合：**
特定地点局部距离射线检测

#### 5.1.3.2 用法

**用法一：**

```c#
Linecast(
    startPos, 
    endPos, 
    LayerMask.GetMask("Enemy")
)
```

**用法二：**

```c#
Linecast(
	startPos, 
    endPos, 
    out RaycastHit, 
    LayerMask.GetMask("Enemy")
)
```

## 5.2 体型检测

### 5.2.1 Physics.XXXCast 体投射

#### 5.2.1.1 BoxCast 立方体投射

**功能：**
检测范围是正立方，返回bool。

**适用场合：**
检测目的地是否可抵达，从而判断可移动性

**用法：**

````c#
BoxCast(
    originPos, 
    halfExtents, 
    direction, 
    out RaycastHit, 
    distance, 
    LayerMask.GetMask("Enemy")
);
````

- originPos, halfExtents：
  在originPos点创建半径halfBoxLength的立方体
  （Vector3型，代表为正立方体在三个方向上的大小，一般用localScale/2）
- direction, distance:
  以朝向direction方向的平面为起始面（另一面舍弃）
  移动distance距离，期间经过的区域即为检测区域。

#### 5.2.1.2 SphereCast 球体投射

**功能：**
扩展检测范围为球形，返回bool类型。

**用法一：**

```c#
SphereCast(
    originPos, 
    originPos, 
    direction, 
    out RaycastHit, 
    distance, 
    LayerMask.GetMask("Enemy")
)
```

- originPos, originPos:
  在originPos点创建半径为radius的球体

- direction, distance:
  以朝向direction方向的球面为起始面（另一面舍弃）
  移动distance距离
  期间半球面经过的区域即为检测区域。

那么originPos到originPos+radius内的半球区域呢？
答案是舍弃，用官方的话来说，**是边界而不是包围体** 。

> 立体结构：
> 以左右球球心为轴线，建立半径为radius、高为distance的圆柱体
> 左球挖去右半体积，右球添加右半体积

**用法二：**

```c#
SphereCast (
    Ray, 
    radius, 
    out RaycastHit, 
    distance, 
    LayerMask.GetMask("Enemy")
)
```

#### 5.2.1.3 CapsuleCast 胶囊体投射

**功能：**
检测范围是胶囊体，返回bool

**用法一：**

```c#
Physics.CapsuleCast(
    pos1, 
    pos2, 
    radius, 
    direction, 
    out RaycastHit, 
    maxDistance, 
    LayerMask.GetMask("Anchor")
)
```

- 机理和SphereCast类似

- pos1, pos2, radius:
  在pos1、pos2两点创建半径为0.5f的球体，以此作为胶囊体模型两端；

- direction, maxDistance:
  以朝向direction方向的半胶囊体面为起始面，移动maxDistance距离
  期间该面经过的区域即为检测区域。

  > 注：
  > maxDistance和上面的distance必须非0否则无用

##### 5.2.1.4 XXXCastAll 穿透投射

**功能：**
上述三种投射都只返回bool，只能检测单个物体，但是All方法的可检测射线上的所有物体，返回 **RaycastHit[]**

> 慎用，**产生GC极多**

### 5.2.2 Physics.OverlapXXX 相交体

#### 5.2.2.1 OverlapBox 相交盒

**功能：**
检测与正立方体接触、重叠、或者处于其内的所有collider

**适用场合：**
检测挂载物体范围内是否存在碰撞，常用方法

**用法：**

```c#
Collider[] hits = OverlapBox(
    Pos, 
    halfExtents, 
    Quaternion.identity, 
    LayerMask.GetMask("Enemy")
)
```

- Pos, halfExtents:
  以Pos点为中心创建三维半径halfExtents的正立方体
- Quaternion.identity：
  不对其进行旋转

#### 5.2.2.2 OverlapSphere 相交球

**功能：**
检测与球体接触、重叠、或者处于其内的所有collider，即**包围体**。

> 注意:
> **自身collider也会被检测**到（下列Overlap方法都是）

**用法：**

```c#
Collider[] hits = Physics.OverlapSphere(
    Pos, 
    radius, 
    LayerMask.GetMask("Enemy")
);
```

- Pos, radius：
  以Pos为原点，创建半径为radius的球形
  检测区域为整个球形包围体（实心）
  返回所有碰撞物体的collider而不是RaycastHit

  > 注意：
  > 存在于球内部的物体也会被检测到

#### 5.2.2.3 OverlapCapsule 相交胶囊体

**功能：**
检测与胶囊体接触、重叠、或者处于其内的所有collider

**用法：**

```c#
Collider[] hits = OverlapCapsule(
    pos1, 
    pos2, 
    radius, 
    LayerMask.GetMask("Enemy")
)
```

- 在pos1、pos2两点创建半径为radius的球体，加上中间部分组成胶囊体

### 5.2.3 Physics.OverlapXXXNonAlloc 无GC相交体

#### 5.2.3.1 OverlapBoxNonAlloc 无GC相交盒

**功能：**
实现OverlapBox的所有功能，但是另**传递进colliders[]** ，**返回相交物体数量**，从而**杜绝GC的产生**

**用法：**

```c#
CollAmount = Physics.OverlapBoxNonAlloc(
    Pos, 
    halfExtents, 
    colliders, 
    Quaternion.identity, 
    LayerMask.GetMask("Enemy")
)
```

#### 5.2.3.2 OverlapSphereNonAlloc 无GC相交球

**功能：**同上

**用法：**

```c#
CollAmount = OverlapSphereNonAlloc(
    Pos, 
    radius, 
    colliders, 
    LayerMask.GetMask("Enemy")
)
```

#### 5.2.3.3 OverlapCapsuleNonAlloc 无GC相交胶囊体

**功能：**同上

**用法：**

```c#
CollAmount = OverlapCapsuleNonAlloc(
    pos1, 
    pos2, 
    radius, 
    colliders, 
    LayerMask.GetMask("Enemy")
)
```

### 5.2.4 Physics.CheckXXX 检验体

#### 5.2.4.1 CheckBox 检验盒

**功能：**
创建检测盒，检测是否被碰撞。
较比与上面的检测方法，该类方法特点在于:
	**检验是否发生了碰撞**，而**不是取得碰撞体信息**，效率最高。

> 注:
> 此方法同样也会检验自身collider

**用法：**

```c#
IsOverlapAnyCollider = Physics.CheckBox(
    transform.position, 
    transform.localScale / 2, 
    Quaternion.identity, 
    LayerMask.GetMask("Enemy")
)
```

- 在物体中心创建检验盒，一定大小，不旋转，检测Enemy层，若有检测到碰撞则返回True

#### 5.2.4.2 CheckSphere 检验球

**功能：**同上

**用法：**

```c#
IsOverlapAnyCollider = Physics.CheckSphere(
	transform.position, 
    radius, 
    LayerMask.GetMask("Enemy")
)
```

#### 5.2.4.3 CheckCapsule 检验胶囊体

**功能：**同上

**用法：**

```c#
IsOverlapAnyCollider = Physics.CheckCapsule(
	pos1, 
	pos2，
    radius, 
    LayerMask.
    GetMask("Enemy")
)
```

### 5.2.5 Physics.IgnoreCollision 忽略碰撞

**功能：**
屏蔽两个collider的碰撞，第三个参数为bool

**用法：**

```c#
IgnoreCollision (collider1, collider2, ignore)
```

# 6. 调试小技巧

## 6.1 绘制线段

- `DrawLine(startPos, endPos, color)`：
  绘制一条从startPos到endPos点、颜色为color的线段

## 6.2 绘制射线

使用Debug.DrawRay()方法可以在Scene中画出射线或者检测到的位置，更好的方便调试。

- `DrawRay(startPos, direction, color)`：
  绘制一条从startPos出发，指向direction的、颜色color的射线

  > 默认长度为单位向量，再乘以倍率即可边长
  > 在下一次绘制才会覆盖上一次的射线

- `Debug.DrawRay(startPos , direction, color, duration)` ：
  同理绘制一定方向射线，但射线持续时间为duration 

## 6.3 Gimos.DrawXXX方法

```c#
void OnDrawGizmos() 
{ 
    Gizmos.DrawCube(transform.position, transform.localScale);
}
```

# 7. GC开销问题

从上面对几种检测方法的分析及对比其**返回值**不难发现：
**不同方法产生GC情况相差甚远**

因此在工程项目上应该慎重使用。

此处引用网友 [HONT](https://www.cnblogs.com/hont/p/6180822.html)的测试作为GC情况参考：

- 同方法下不同模型GC开销：**Box < Sphere < Capsule**
- 同模型下不同方法GC开销：**CheckXXX < OverlapXXX < XXXCast**

# 8. 参考

- https://www.cnblogs.com/SouthBegonia/p/11732340.html
