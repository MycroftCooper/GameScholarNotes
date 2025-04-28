---
title: Unity-GameObject类
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

GameObject 类是Unity场景中所有实体的基类。

一个GameObject对象通常由多个组件component组成，且至少含有一个transform组件。

详细可见https://blog.csdn.net/a1256242238/article/details/73189101

# 2. 构造方法

- `public GameObject();`

- `public GameObject(string name);`

- `public GameObject(string name,params Type[] components);`

# 3. 常用成员变量

| 变量名     | 作用                                                |
| ---------- | --------------------------------------------------- |
| name       | 继承于父类Object，对象的名称                        |
| tag        | 游戏对象的标签tag                                   |
| layer      | 游戏对象所在的层layer，范围为[0...31]               |
| activeSelf | 游戏对象自身的激活状态                              |
| transform  | 游戏对象上的Transform组件，设置对象位置、旋转、缩放 |
| rigidbody  | 游戏对象上的Rigidbody组件，设置物理引擎的刚体属性   |
| camera     | 游戏对象上的Camera组件，设置相机属性                |
| light      | 游戏对象上的Light组件，设置灯光属性                 |
| animation  | 游戏对象上的Animation组件，设置动画属性             |
| renderer   | 游戏对象上的Renderer组件，渲染物体模型              |
| audio      | 游戏对象上的AudioSource组件，设置声音属性           |

 # 4.常用成员函数

| 函数名                 | 作用                                                        |
| ---------------------- | ----------------------------------------------------------- |
| Find                   | 静态函数，根据名称查找游戏对象                              |
| FindWithTag            | 静态函数，根据标签查找第一个符合条件的游戏对象              |
| FindGameObjectsWithTag | 静态函数，根据标签查找所有符合条件的游戏对象                |
| CreatePrimitive        | 静态函数，创建一个基本形体的游戏对象（如正方体，球体等）    |
| SetActive              | 激活/取消激活游戏对象                                       |
| GetComponent           | 获取游戏对象                                                |
| GetComponentInChildren | 获取游戏对象或其子对象上指定类型的第一个组件                |
| GetComponents          | 获取游戏对象上指定类型的所有组件                            |
| AddComponent           | 为游戏对象添加指定组件                                      |
| SendMessage            | 调用游戏对象上所有MonoBehaviour的指定名称方法               |
| SendMessageUpwards     | 调用游戏对象及其所有父对象上所有MonoBehaviour的指定名称方法 |
| BroadcastMessage       | 调用游戏对象及其所有父对象上所有MonoBehaviour的指定名称方法 |
| CompareTag             | 比较游戏对象的标签                                          |

 # 5. 继承自Object类的常用函数

| 函数名            | 作用                                     |
| ----------------- | ---------------------------------------- |
| Destroy           | 删除一个游戏物体、组件或资源             |
| DestroyImmediate  | 立即销毁物体obj，强烈建议使用Destroy替代 |
| Instantiate       | 克隆原始物体，并返回克隆的物体           |
| DontDestroyOnLoad | 加载新场景的时候使目标不被自动销毁       |
| FindObjectOfType  | 返回Type类型第一个激活的加载的物体       |

## 5.1 Instantiate创建物体

**Instantiate函数**专门用来创建一个新的物体，但是要提供一个预制体或者已经存在的游戏物体作为模板。

代码如下：

```c#
public Gameobject enemy;

void Start() 
{
    //以enemy为模板生成5个敌人
	for (int 1-0; 1<5; 1++)
    {
        Instantiate(enemy);
    }
}
```

可以用已经存在的物体作为模板，更常见的方式是使用预制体作为模板。

创建的物体将会具有和原物体一样的组件、参数。

## 5.2 Destroy销毁物体

可以用Destroy函数来销毁游戏物体或者组件。

例如，下面的代码会在导弹产生碰撞时销毁该导弹，第二个参数0.5f表示在0.5秒之后才执行销毁动作。

```c#
void OnCollisionEnter (Collision otherobj)
{
    if (other0bj.gameObject.tag == "Missile")
    {
        Destroy (gameObject,0.5f);
    }
}
```

> 注意:由于销毁游戏物体和销毁脚本都是使用Destoy函数，所以经常 会出现误删除组件的情况。
>
> 如以下代码：
>
> `Destroy (this);`
