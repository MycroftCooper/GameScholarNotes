---
title: Unity-在脚本中访问其他游戏物体
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - Unity
category: 程序/引擎/Unity/入门基础
note status: 终稿
---


# 1. 概述

在实际的游戏开发中，脚本不仅会对当前挂载的物体进行操作，还可能会引用其他物体。
例如，正在追逐玩家角色的敌人角色会-直保留着对玩家角色的引用， 以便随时确定玩家角色的位置。
访问其他游戏物体的方法非常多，使用非常灵活，可以根据不同的情况采用不同的方式。

# 2.常用的4种访问操作

## 2.1 用属性查看器指定参数访问

Unity中获得其他物体最简单、最直接的方式就是为脚本添加一个`publi Gamebiet`变量，不需要设置初始值。
代码如下:

```c#
public class Enemy : MonoBehaviour
{
    public GameObject player;
    // ....
}
```
player变量会显示在检视窗口中，默认值为空。

现在将任何物体或预制体拖曳到player变量的文本框中，就为player变量赋予了初始值。之在脚本中就可以随意使用Player这个游戏物体。
如下所示：

```c#
public class Enemy : MonoBehaviour
{
    public GameObject player;
    
    void Start()
    {
        //读取player的位置并设置本物体的位置在它后方
        transform.position=player.transform.position-Vector3.forward*10f;
    }
}
```
另外，上面说的引用其他物体时，变量类型不仅可以是**GameObject**或一个组件，也可以将戏物体拖到这个变量上，只要被拖曳的物体确实具有这个组件就可以。

`public Transform playerTransform;`

简单地说，可以用何一个组件来指代游戏物体本身。
这是因为组件实体具有“被游戏物体挂载”这样的性质，所通过一个游戏物体可以获得它上面的任何一个组件，通过任何一个组件也可以获得挂载该组件游戏物体。这个对应关系是明确的，因此上面的变量类型可以是组件类型，也可以将游戏物体直接拖上去。

用变量将物体联系起来的做法非常有用，特别是这种联系是持续存在、不易变化的。还可用一个数组或者列表来保存多个游戏物体。

> 如果被引用的物体是游戏运行时才动态添加的，或者被引用的物体会随着游戏进行而变化事先拖曳的方式就不可行了，需要动态指定物体，下面将详细说明。

## 2.2 用父子关系查找子物体

有时需要管理一系列同类型的游戏物体，例如一批敌人、一批寻路点、 多个障碍物等。
如果这时候需要对这些物体进行统一的管理或操作，就需要在脚本中用数组或容器来管理它们。

使用属性查看器指定参数访问的方法，可以将每个物体拖动到检视窗口中，但是这样做不仅低效，而且容易误操作，在物体增加、减少时还需要再次手动操作。

所以，在这种情况下是不合适的，可以用父子关系查找子物体的方法来遍历所有子物体。
在具体实现时，要用父物体的变换组件来查找子物体。
>物体的父子关系访问的属性都在变换组件中，而不在GameObject对象中

以下是遍历所有子物体的例子:

```c#
using UnityEngine;

public class WaypointManager : MonoBehaviour
{
	public Transform[] waypoints;
	
	void Start()
	{
		waypoints = new Transform[transform.childCount];
		int i = 0;
		foreach (Transform t in transform)
		{
			waypoints[i++] = t;
		}
	}
}
```

同样可以使用**transform.Find**方法指定查找某个子物体，代码如下。

` transform.Find ("Gun"); `

> 由于**Find函数**的效率不好估计，可能会遍历所有物体才能查找到指定物体，所以如果可以在**Start函数**中使用，就不要在**Updata函数**中使用。因为**start函数**只执行一次而**updata函数**每帧都会执行。

## 2.3 用标签或名称查找物体

使用**GameObject.Find方法**可以通过名称查找游戏物体。

代码如下：

```c#
GameObject player;

void Start() 
{
    player = GameObject.Find ("ObjectName");
}
```

如果要用标签查找物体，那么就要用到**GameObject.FindWithTag方法** 或**GameObject.FindGameObjectWithTag方法**。

代码如下：

```c#
GameObject player;
GameObject[] enemies;

void Start() 
{
    player = GameObject.FindWithTag("Player");
    enemies =GameObject.FindGameObjectsWithTag("Enemy");
}
```
