---
title: Unity-Transform类
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 程序
  - Unity
category: 程序/引擎/Unity/入门基础
note status: 终稿
---


# 1. 概述

**Transform**组件是Unity3D的重点之一，主要用于控制物体的旋转、移动、缩放。

**Unity**规定所有游戏物体都必须**有且只有一个**变换组件(**Transform**)且**不能删除**。

变换组件(**Transform**)实现了Unity的父子关系功能。

那么接下来我们将详细学习下**Transform**类所包含的成员变量和成员函数。

 # 2. 父子关系

## 2.1 简介

父子关系是Uniy中重要的基本概念之一。
当一个物体是另一个物体的父物体时，子物体会严格地随着父物体起移动、 旋转、缩放。
可以将父子关系理解为你的手臂与身体的关系，当身体移动时，手臂也定会跟着一 起移动， 且手臂还可以有自己下一级的子物体，比如手掌就是手名臂的子物体、手指是手掌的子物体等。

> 在unity中带有local字样的属性也就意味着其数值是相对于父物体的。

## 2.2 底层原理与规则

规则：

- 任何物体都可以有多个子物体，但是每个物体都只能有一个父物体。

原理：

这种父子关系组成一个树状的层级结构，最基层的那个物体是唯一不具有父物体的物体，它被称为根节点。

由于物体的移动、旋转、缩放与父子关系密切相关，且游戏物体和变换组件是一一对应的。所以在Unity中，游戏物体的层级结构完全可以理解为变换组件的层级结构。父子关系的操作在脚本中确实是在变换组件上进行的。
子物体的变换组件的参数其实是相对父物体的值，再次考虑之前身体和手臂的例子，无论身体如何移动，手臂和身体的连接处是固定不变的。

## 2.3 关于父子物体的一些现象

### 2.3.1 position：

- 改变父物体的position，父物体连同子物体一起移动；

- 改变子物体的position，父物体不随子物体移动。

- 当子物体的position设置为（0，0，0）时，子物体与父物体中心点重合。

### 2.3.2 rotation：

介绍两个位于unity快捷工具栏右侧的选项：**Pivot**与**Local**

- **Poivt**

  用于调节物体轴心点，有两个子选项

  - Pivot    父物体的中心点

  - Center 当前父子物体的中心点

- **Local**
  用于调节当前被选中物体的坐标轴，有两个子选项

  - Local    自身坐标系

  - World  世界坐标系

### 2.3.3 Scale:

**子物体的真实缩放比例Scale=子物体Scale比例×父物体Scale比例**

可以通过下述代码在unity脚本中直接查看：

```C#
Vector3 _truthScale = this.transform.LossyScale;//此属性为只读属性
```

## 2.4 坐标系的选择

局部坐标与世界坐标各有各的适用情况：

- 在搭建场景时，我们更喜欢使用局部坐标系
  比如移动一个房屋时，屋子里所有的东西都会跟着一起移动;

- 而在编写游戏逻辑时，更多的时候需要获得物体在空间中的实际位置。
  比如我们要将摄像机对准人物的眼睛，这时候眼睛和人物的相对坐标就没有太大价值，而应当让摄像机对准眼睛在世界坐标系中的位置。

所以，在脚本系统中，变换组件的大部分操作都提供了两类操作方式，分别是世界坐标系的和局部坐标系的，我们可以根据需求进行使用。

## 2.5 关于父子物体使用的小技巧

在处理美工交过来的模型时，推荐将模型拉入一个空的gameobject，形成父子物体关系，组件只给空的gameobject上。

这样就可以防止日后更换模型时需要重新上组件的情况。

空物体通常用来管理和控制多个相互之间无关联的游戏物体。

# 3. 成员变量

| position           | 在世界空间坐标transform的位置。                              |
| ------------------ | ------------------------------------------------------------ |
| localPosition      | 相对于父级的变换的位置。  如果该变换没有父级，那么等同于Transform.position。 |
| eulerAngles        | 世界坐标系中的旋转（欧拉角）。                               |
| localEulerAngles   | 相对于父级的变换旋转角度。                                   |
| right              | 世界坐标系中的右方向。  （世界空间坐标变换的红色轴。也就是x轴。） |
| up                 | 世界坐标系中的上方向。  （在世界空间坐标变换的绿色轴。也就是y轴。） |
| forward            | 世界坐标系中的前方向。  （在世界空间坐标变换的蓝色轴。也就是z轴。） |
| rotation           | 世界坐标系中的旋转（四元数）。                               |
| localRotation      | 相对于父级的变换旋转角度。                                   |
| localScale         | 相对于父级的缩放比例。                                       |
| parent             | 父对象Transform组件。                                        |
| worldToLocalMatrix | 矩阵变换的点从世界坐标转为自身坐标（只读）。                 |
| localToWorldMatrix | 矩阵变换的点从自身坐标转为世界坐标（只读）。                 |
| root               | 对象层级关系中的根对象的Transform组件。                      |
| childCount         | 子对象数量。                                                 |
| lossyScale         | 全局缩放比例（只读）。                                       |

 

# 4. 成员函数

 

## 4.1 LookAt函数

| 函数的多种重载                                               |
| ------------------------------------------------------------ |
| public void LookAt(Transform target);                        |
| public void  LookAt(Vector3 worldPosition);                  |
| public void  LookAt(Vector3 worldPosition, Vector3 worldUp = Vector3.up); |
| public void  LookAt(Transform target, Vector3 worldUp = Vector3.up); |

旋转物体，使物体的z轴指向**target/worldPosition**，对于**worldUp**的描述是，在完成上面的旋转之后，继续旋转自身，使得当前对象的正y轴朝向与worldUp所指向的朝向一致。

 

这里的朝向一致指的是新旋转后的y轴与**worldUp**在该对象初次旋转后的xy平面上的投影向量一致。之所以取投影是因为第一次旋转使物体的z轴指向**target/worldPosition**后，此时的**worldUp**向量可能不在xy平面上，要在z轴指向**target/worldPosition**前提下是y轴朝向与**worldUp**一致，只能取**worldUp**在xy平面上的投影。

 

> 注意：使用**worldPosition向量**时要注意方向，一定是**target-transform.position**，顺序反了会使物体背向目标；若使用**Transform**作为参数，则不必注意。默认情况下，**worldUp**是**Vector3.up**（世界坐标系下的y轴）

##  

## 4.2 Rotate函数

| 函数的多种重载                                               |
| ------------------------------------------------------------ |
| public void  Rotate(Vector3 eulerAngles);                    |
| public void  Rotate(Vector3 eulerAngles, Space relativeTo = Space.Self); |
| public void  Rotate(float xAngle, float yAngle, float zAngle); |
| public void  Rotate(float xAngle, float yAngle, float zAngle, Space relativeTo =  Space.Self); |

旋转一个欧拉角度，它按照zxy的顺序进行旋转，默认情况下局部坐标系下**Space.Self**。

| 函数的多种重载                                               |
| ------------------------------------------------------------ |
| public void  Rotate(Vector3 axis, float angle);              |
| public void  Rotate(Vector3 axis, float angle,Space relativeTo = Space.Self); |

绕axis轴旋转angle角度，默认情况下局部坐标系下**Space.Self**。



**transform.rotation**和**Rotate**有个区别：
- Rotate()方法是： 旋转多少度。

  在原有的基础上累加，即旋转了多少角度。  又旋转了多少角度，是在原有的基础上在旋转

- rotation属性是：  旋转到某个角度，就是是在update中每帧都执行。 

   但每次旋转到的角度都是5，所以是旋转到5度。一直都是。 

比如你只想让他旋转到多少, 用rotation; 假如想让他一直转,可以用Rotate

rotation直接改变了数值, 以达到旋转效果

Rotate应用一个的旋转角度每秒1度慢慢的旋转物体

当然:rotation()还可以通过插值旋转



## 4.3 RotateAround函数

让物体以某一点为轴心成圆周运动。

`public void RotateAround (point : Vector3, axis : Vector3, angle : float) : void`

让物体以**point**为中心，绕**axis**为轴向旋转**angle**度。保持原来与**point**的距离。

 

## 4.4 TransformDirection函数

| 函数的多种重载                                               |
| ------------------------------------------------------------ |
| public Vector3  TransformDirection(Vector3 direction);       |
| public Vector3  TransformDirection(float x, float y, float z); |

从自身坐标到世界坐标变换方向（这个强调的是方向）这个操作不会受到变换的缩放和位置的影响。

返回的向量与**direction**有同样的长度。

 

## 4.5 InverseTransformDirection函数

| 重载的多种函数                                               |
| ------------------------------------------------------------ |
| public Vector3  InverseTransformDirectionTransformDirection (direction : Vector3)  : Vector3 |
| public Vector3  InverseTransformDirectionTransformDirection (x : float, y : float,  z : float) : Vector3 |

与**TransformDirection**相反，从世界坐标转换到自身相对坐标。

 

## 4.6 TransformPoint函数

| public Vector3  TransformPoint(Vector3 position);          |
| ---------------------------------------------------------- |
| public Vector3  TransformPoint(float x, float y, float z); |

变换位置从自身坐标到世界坐标。

注意，返回位置受缩放影响

 

## 4.7 InverseTransformPoint函数

| public  Vector3 InverseTransformPoint (position : Vector3)  : Vector3 |
| ------------------------------------------------------------ |
| public  Vector3 InverseTransformPoint (x : float, y : float, z  : float) : Vector3 |

把一个点从时间坐标转换到自身坐标的位置。

 

## 4.8 TransformVector函数

| public Vector3  TransformVector(Vector3 vector);            |
| ----------------------------------------------------------- |
| public Vector3  TransformVector(float x, float y, float z); |

变换一个向量从局部坐标空间到世界坐标空间。

这个操作不受变换位置的影响，但是受缩放的影响

 

## 4.9 Translate函数

| public void  Translate(Vector3 translation);                 |
| ------------------------------------------------------------ |
| public void  Translate(Vector3 translation, Space relativeTo = Space.Self); |

沿着**translation**方向移动**translation**向量长度的距离。

如果**relativeTo**留空或者设置为**Space.Self**，移动被应用相对于自身坐标系

 

| public void  Translate(float x, float y, float z);           |
| ------------------------------------------------------------ |
| public void  Translate(float x, float y, float z, Space relativeTo = Space.Self); |

移动变换由x沿着x轴，y沿着y轴，z沿着z轴。

如果**relativeTo**留空或者设置为**Space.Self**，移动被应用相对于自身坐标系

 

| public void  Translate(Vector3 translation, Transform relativeTo); |
| ------------------------------------------------------------ |
| public void  Translate(float x, float y, float z, Transform relativeTo); |

第一个参数的解释跟前面的一样，重点在移动**relativeTo**，解释为被应用相对于（relativeTo :Transform）的自身坐标系统。

日光相对于为**null**，则移动被应用相对于世界坐标系统

例子：

```c#
void Update()

{

//相对于摄像机每秒1单位向右移动物体

transform.Translate(Vector3.right * Time.deltaTime, Camera.main.transform);

}
```



## 4.10 DetachChildren函数

`public void DetachChildren () : void`

把自身所有的子物体的父物体都设成世界，也就是跟自己的所有子物体接触父子关系。

 

## 4.11 **Find** **函数**

`public Transform Find (name : string) : Transform`

找到一个名字是name的物体并返回

如果没有找到则返回null。如果字符串被/隔离，函数则会像文件路径一样逐级下查。

```c#
// The magical rotating finger

function Update() {

aFinger = transform.Find("LeftShoulder/Arm/Hand/Finger");

aFinger.Rotate(Time.deltaTime*20, 0, 0);

}
```

## 4.12 IsChildOf函数

`public bool IsChildOf (parent : Transform) : bool`

如果物体是**parent**的父子层级关系下的一员，返回**true**;

# 5. 组件使用注意事项

## 5.1 非等比缩放的问题

某些组件不完全支持非等比缩放，在非等比缩放的情况下可能会出现意想不到的结果。
因为当该游戏物体具有一个球体或者胶囊体的外壳，而这些外壳的大小是通过一个半径参数指定的。
在物体或者父物体被拉伸或压扁的时候，这些组件的球体范围并不会跟着压扁成椭球体，它们实际上仍然是球体或胶囊体。
所以当物体中具有这类组件时，由于组件形状和物体形状不一致，可能会导致穿透模型被意外阻挡等情况发生。

例如，碰撞体、角色控制器这些组件和灯光、音源。

这些问题不致命，但是会引起奇怪的bug。

## 5.2 其它注意事项

- 当为一个物体添加子物体时， 可以考虑先将父物体的位置设置为原点，这样子物体的局部坐标系就和世界坐标系重合，方便我们指定子物体的准确位置。
- 粒子系统不会受变换组件的缩放系数的影响。要改变- -个粒子的整体比例，还是需要在粒子系统中适当改变相关参数。
- 修改物体缩放比例时不仅会直接影响子物体的比例，还会影响子物体的实际位置(因为要保证相对位置不变)。
