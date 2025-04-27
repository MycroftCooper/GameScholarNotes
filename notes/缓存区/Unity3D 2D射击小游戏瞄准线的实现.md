---
title: Unity中的标签 层级 静态物体
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 0. 前言

本片文章是对https://www.bilibili.com/video/bv1sY411V7tx视频中瞄准线是如何实现的一个讲解教程，欢迎大家去B站给我一键三连鸭！

这个项目的整个代码和资源已经上传到了GitHub，大家可以去看一下
链接：https://github.com/MycroftCooper/TigerShooting2DGame

# 1. 效果分析

![image-20220220222715775](./attachments/Unity3D 2D射击小游戏瞄准线的实现/8c07982e.png)

![瞄准线](./attachments/Unity3D 2D射击小游戏瞄准线的实现/88cef46c.gif)

根据视频中的瞄准线效果，我们可以分析出，它应该具有以下几个功能：

1. 准星会时刻和玩家鼠标保持位置一致
2. 瞄准线的另一头始终要在枪上
3. 当准星放在敌人身上，瞄准线和准星会变红
4. 当开火时准星会有所变化

# 2. 素材准备

根据以上四个功能，我们就可以知道，其实这个瞄准线的效果应该是分为瞄准线和准星两部分的
所以，我们分别准备好这两部分的素材：
![image-20220220223426285](./attachments/Unity3D 2D射击小游戏瞄准线的实现/efdf05c0.png)

其中Line为瞄准线，而Sight为准星。

## 2.1 瞄准线 Line

瞄准线的素材有两种：

1. 红线：瞄准敌人时使用
2. 白线：没瞄上敌人时使用

准线是要做成预制体放在游戏里的，所以一张图导入Unity后按照Sprite去切就没问题

![image-20220220223646127](./attachments/Unity3D 2D射击小游戏瞄准线的实现/1a92da55.png)

因为是像素游戏，所以记得正确设置**单位像素数**，**网格类型**和**过滤模式**，设置如下：
![image-20220220224440440](./attachments/Unity3D 2D射击小游戏瞄准线的实现/06ba1d67.png)

在切的时候需要注意的是，瞄准线的长度我们想让它是可变的，而且是从固定的一段开始伸缩。所以在用精灵切片的时候需要做两件事：设置**平铺边界**(绿色线)和**锚点**(设到左边)，如下图所示：
![image-20220220224315712](./attachments/Unity3D 2D射击小游戏瞄准线的实现/4ef469ff.png)

如此一来，瞄准线的素材图就导入成功了，接下来就是：

1. 创建一个预制体
2. 添加一个精灵渲染器
3. 将精灵设为刚刚切好的一个瞄准线的精灵图片
4. 设置绘制模式(只有设置成平铺才能任意伸缩)
5. 设置图层顺序(设成-2就能保证瞄准线总是在图层的最前面了)

如下图所示：

![image-20220220224836597](./attachments/Unity3D 2D射击小游戏瞄准线的实现/7c0955bf.png)

瞄准线的素材就准备完毕啦！

## 2.2 准星Sight

准星有四种素材：

1. Sight_Off：没瞄到敌人且没开火的准星
2. Sight_Off_Fire：没瞄到敌人还开火的准星
3. Sight_On：瞄到敌人但没开火的准星
4. Sight_On_Fire：瞄到敌人还开火的准星

准星实际上有两种实现方法：

1. 也做成游戏物体加入场景中
2. 切换游戏光标，让游戏的默认光标变为准星

这里我们采用第二种方法吧，第一种大家肯定是会的。

准星的素材图片最好不要使用精灵，而是有一种专门给准星用的格式：光标(Texture 2D)
这种格式的图片无法切图，所以最好把准星的图片自己提前切好再导入，如下图所示：

![image-20220220225325559](./attachments/Unity3D 2D射击小游戏瞄准线的实现/aedca2bc.png)

![image-20220220225352696](./attachments/Unity3D 2D射击小游戏瞄准线的实现/e1534f4e.png)

这样准星的素材我们也导入完毕了！

## 2.3 素材管理代码

因为在游戏的过程中，我们会根据开火情况和瞄准情况来反复更换准星和瞄准线，所以可以写一份代码来专门管理这两种瞄准线和四种准星的素材。
代码如下：

```c#
private static class SightResouses {
  			// 用List存储读取的瞄准线(精灵 Sprite)
        private static List<Sprite> spritesList = 
          new List<Sprite>(Resources.LoadAll<Sprite>("Line"));
  			
  			// 用字典存储读取的准星(2D纹理 Texture2D)
        private static Dictionary<string, Texture2D> textureList = 
          new Dictionary<string, Texture2D>{
            {"Sight_On", Resources.Load<Texture2D>("Sight_On")},
            {"Sight_On_Fire", Resources.Load<Texture2D>("Sight_On_Fire")},
            {"Sight_Off", Resources.Load<Texture2D>("Sight_Off")},
            {"Sight_Off_Fire", Resources.Load<Texture2D>("Sight_Off_Fire")},
        };
  
        private static Sprite GetResouseSprite(string name) =>
            spritesList.Find(x => x.name == name);
  
        public static Texture2D Sight_On { get => textureList["Sight_On"]; }
        public static Texture2D Sight_On_Fire { get => textureList["Sight_On_Fire"]; }
        public static Texture2D Sight_Off { get => textureList["Sight_Off"]; }
        public static Texture2D Sight_Off_Fire { get => textureList["Sight_Off_Fire"]; }
        public static Sprite Sight_On_Line { get => GetResouseSprite("Sight_On_Line"); }
        public static Sprite Sight_Off_Line { get => GetResouseSprite("Sight_Off_Line"); }
    }
```

> 注意：
> 放在预制体里的瞄准线是 **精灵 Sprite** 
> 作为光标素材的准星是 **2D纹理 Texture2D**

这样，通过静态类SightResouses，我们就可以轻松的拿到需要的素材了

# 3. 功能实现

根据之前的效果分析，我们接下来拆分一下功能：

1. 我们需要知道鼠标当前的位置
   让瞄准线伸缩到合适长度
   让瞄准线指向光标(准星)
2. 我们需要知道当前是否处于开火状态
   并且根据开火状态改变瞄准线与准星的素材资源
3. 我们需要知道当前是否处于瞄准敌人的状态
   并且根据瞄准状态改变瞄准线与准星的素材资源

那么我们就一个一个的去实现吧！

## 3.1 伸缩并指向

要想正确的将瞄准线伸缩指向光标，我们需要一下信息：

1. 光标现在在哪(获取光标屏幕坐标->转换坐标得到世界坐标)
2. 瞄准线现在的原点在哪(瞄准线会挂在枪上，所以直接取transform.position就好)

有了两点就可以确定一条直线了！

代码如下：
```c#
public Vector2 MousePos;// 光标世界坐标
public Vector2 SightPos;// 准星原点坐标
public Vector2 StartPosOffset;// 瞄准线起点偏移值
public Vector2 CollisionOffset;// 光标与准星中心的偏移值

// 更新当前光标位置
private void updateMousePos() {
  // 获取光标屏幕坐标
	Vector3 screenMousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0);
  // 转换坐标得到世界坐标
	MousePos = Camera.main.ScreenToWorldPoint(screenMousePos);
  // 光标坐标加上偏移值就是准星的中心
	SightPos = MousePos + CollisionOffset;
}


public float LineWide = 0.15f;
private SpriteRenderer sightLineRenderer;
private void updateLine() {
  // 根据当前瞄准线原点位置加上偏移量(从枪中间移到枪口),就是瞄准线的起点
  Vector2 pos = transform.parent.position + (Vector3)StartPosOffset;
  // 获取两点间距离
  float d = Vector2.Distance(pos, SightPos);
  // 设置精灵渲染器的平铺尺寸来伸缩瞄准线
  sightLineRenderer.size = new Vector2(d + 0.2f, LineWide);
}
```

> 注意：为什么要有两个偏移值？
> StartPosOffset：
> 实际上是瞄准线的起点偏移值，瞄准线的父物体是枪，如果不设这个偏移值，瞄准线就会从枪中心而不是枪口延申出来
> CollisionOffset：
> 实际上是瞄准线的终点偏移值，准星的锚点我们希望它在图片正中间，但是当它作为光标使用时，它的锚点在左上角，所以需要进行偏移

现在我们可以做到瞄准线根据鼠标所在的位置来正确伸缩了！

那么，指向怎么实现？这里的代码我放在了瞄准线的父物体，枪的控制代码中了，但也不难，代码如下：
```c#
private void lookAtSight() {
  // 获取准星的世界坐标
	Vector2 SightPos = SC.SightPos;
  // 先让轴指向准星
	transform.LookAt(new Vector3(SightPos.x, SightPos.y));
  // 再y轴旋转-90度
	transform.Rotate(new Vector3(0, -90, 0));
}
```

> 注意:为什么要旋转-90度？
> 因为 transform.LookAt() 本质上是让本物体的Z轴正方向指向目标点
> 可我们是2D游戏，Z轴正方向会垂直于游戏画面，就看不见了，所以得旋转一下

这样，我们就完成了指向

伸缩和指向两个功能都是实线啦！

## 3.2 状态检测与素材替换

接下来我们需要实现的是：

1. 瞄准状态的检测:有没有瞄着敌人？
2. 开火状态的检测:有没有在开火？
3. 根据状态进行素材替换



先看**开火状态的检测**，这个简单，看看鼠标的输入就行，代码如下：

```c#
public bool IsOnFire;
private void updateOnFire() {
  // 判断有没有按着开火键
	if (Input.GetButton("Fire1")) {
		IsOnFire = true;
    // 更新瞄准器素材
		updateSightResouses();
		return;
	}
  // 没按着而且不在开火状态，就不重复换素材了
	if (!IsOnFire) return;
	IsOnFire = false;
  // 更新瞄准器素材
	updateSightResouses();
}
```

> 注意：为啥是Input.GetButton，不是说要看鼠标的输入吗？
> 这个啊，这个叫虚拟输入轴，快去我以前的文章学习一下吧：
> https://mycroftcooper.github.io/2021/03/25/Unity-%E8%BE%93%E5%85%A5%E6%93%8D%E4%BD%9C/



再看**瞄准状态的检测**，这个得用到Physics2D.OverlapCircle，是一种简单的射线检测方式，API如下：[Physics2D.OverlapCircle](https://docs.unity3d.com/cn/2020.2/ScriptReference/Physics2D.OverlapCircle.html)
可以去看看这位老哥写的相关教程：http://www.voycn.com/article/unity2djiancefangfaoverlapcircleyuraycastxiangjie
如果想更加系统化的了解射线检测，可以取看看我之前写的这个文章：
https://mycroftcooper.github.io/2021/09/04/Unity-%E5%B0%84%E7%BA%BF%E6%A3%80%E6%B5%8B/

总而言之，代码如下：
```c#
public bool IsOnEntity;
public LayerMask EnemiesLayer;
public Vector2 CollisionOffset;
public float collisionRadius = 0.25f;
private void updateOnEntity() {
	// 判断有没有瞄着敌人
	Collider2D entity = Physics2D.OverlapCircle((Vector2)MousePos + CollisionOffset, collisionRadius, EnemiesLayer);
	if (entity != null && entity.tag == "Enemies") {
		if (IsOnEntity) return;
			IsOnEntity = true;
			// 更新瞄准器素材
			updateSightResouses();
			return;
		}
	if (!IsOnEntity) return;
	IsOnEntity = false;
	// 更新瞄准器素材
	updateSightResouses();
}
```

如果你想在编辑器中看到你的射线检测范围，可以使用如下代码：
```c#
private void OnDrawGizmos() {
	Gizmos.color = debugCollisionColor;
	Gizmos.DrawWireSphere(SightPos, collisionRadius);
}
```

完成后如下图所示：
![image-20220220234824204](./attachments/Unity3D 2D射击小游戏瞄准线的实现/53e08529.png)

绿圈圈就是你的射线检测范围啦(我这里没改偏移量有点偏，你们记得根据自己的精度需要去设置哦)

这样以来，瞄准线状态的检测就算完成啦，接下来进行素材替换的实现，代码如下：
```c#
private void updateSightResouses() {
	if (IsOnEntity) {
		sightLineRenderer.sprite = SightResouses.Sight_On_Line;
		if (IsOnFire) {
      Cursor.SetCursor(SightResouses.Sight_On_Fire, hotSpot, CursorMode.Auto);
    } else {
      Cursor.SetCursor(SightResouses.Sight_On, hotSpot, CursorMode.Auto);
    }
  } else {
    sightLineRenderer.sprite = SightResouses.Sight_Off_Line;
    if (IsOnFire) {
      Cursor.SetCursor(SightResouses.Sight_Off_Fire, hotSpot, CursorMode.Auto);
    } else {
      Cursor.SetCursor(SightResouses.Sight_Off, hotSpot, CursorMode.Auto);
    }
  }
}
```

之前写的素材管理代码用上了吧！

如此一来，整个瞄准线的功能就实现了，可以把它挂到枪上咯！

![image-20220220235416020](./attachments/Unity3D 2D射击小游戏瞄准线的实现/ce07e951.png)

![image-20220220235337492](./attachments/Unity3D 2D射击小游戏瞄准线的实现/2814386d.png)

# 4. 源代码

```c#
using System.Collections.Generic;
using UnityEngine;

public class SightController : MonoBehaviour {
    private static class SightResouses {
        private static List<Sprite> spritesList = new List<Sprite>(Resources.LoadAll<Sprite>("Line"));
        private static Dictionary<string, Texture2D> textureList = new Dictionary<string, Texture2D>{
            {"Sight_On", Resources.Load<Texture2D>("Sight_On")},
            {"Sight_On_Fire", Resources.Load<Texture2D>("Sight_On_Fire")},
            {"Sight_Off", Resources.Load<Texture2D>("Sight_Off")},
            {"Sight_Off_Fire", Resources.Load<Texture2D>("Sight_Off_Fire")},
        };
        private static Sprite GetResouseSprite(string name) =>
            spritesList.Find(x => x.name == name);
        public static Texture2D Sight_On { get => textureList["Sight_On"]; }
        public static Texture2D Sight_On_Fire { get => textureList["Sight_On_Fire"]; }
        public static Texture2D Sight_Off { get => textureList["Sight_Off"]; }
        public static Texture2D Sight_Off_Fire { get => textureList["Sight_Off_Fire"]; }
        public static Sprite Sight_On_Line { get => GetResouseSprite("Sight_On_Line"); }
        public static Sprite Sight_Off_Line { get => GetResouseSprite("Sight_Off_Line"); }
    }

    public Vector2 MousePos;
    public Vector2 SightPos;
    public Vector2 StartPosOffset;

    void Start() {
        IsOnFire = false;
        IsOnEntity = false;
        sightLineRenderer = GetComponentInChildren<SpriteRenderer>();
        sightLineRenderer.sprite = SightResouses.Sight_Off_Line;
        Cursor.SetCursor(SightResouses.Sight_Off, hotSpot, CursorMode.Auto);
    }

    void Update() {
        updateSight();
        updateLine();
    }
    #region 准星相关
    [Header("Sight")]
    public Vector2 hotSpot;
    public bool IsOnFire;
    public bool IsOnEntity;

    [Header("Collision")]
    public LayerMask EnemiesLayer;
    public Vector2 CollisionOffset;
    public float collisionRadius = 0.25f;
    private Color debugCollisionColor = Color.green;
    private void updateSight() {
        updateMousePos();
        updateOnEntity();
        updateOnFire();
    }
    private void updateMousePos() {
        Vector3 screenMousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0);
        MousePos = Camera.main.ScreenToWorldPoint(screenMousePos);
        SightPos = MousePos + CollisionOffset;
    }
    private void updateSightResouses() {
        if (IsOnEntity) {
            sightLineRenderer.sprite = SightResouses.Sight_On_Line;
            if (IsOnFire) {
                Cursor.SetCursor(SightResouses.Sight_On_Fire, hotSpot, CursorMode.Auto);
            } else {
                Cursor.SetCursor(SightResouses.Sight_On, hotSpot, CursorMode.Auto);
            }
        } else {
            sightLineRenderer.sprite = SightResouses.Sight_Off_Line;
            if (IsOnFire) {
                Cursor.SetCursor(SightResouses.Sight_Off_Fire, hotSpot, CursorMode.Auto);
            } else {
                Cursor.SetCursor(SightResouses.Sight_Off, hotSpot, CursorMode.Auto);
            }
        }
    }
    private void updateOnFire() {
        if (Input.GetButton("Fire1")) {
            if (IsOnFire) return;
            IsOnFire = true;
            updateSightResouses();
            return;
        }
        if (!IsOnFire) return;
        IsOnFire = false;
        updateSightResouses();
    }
    private void updateOnEntity() {
        Collider2D entity = Physics2D.OverlapCircle((Vector2)MousePos + CollisionOffset, collisionRadius, EnemiesLayer);
        if (entity != null && entity.tag == "Enemies") {
            if (IsOnEntity) return;
            IsOnEntity = true;
            updateSightResouses();
            return;
        }
        if (!IsOnEntity) return;
        IsOnEntity = false;
        updateSightResouses();
    }
    private void OnDrawGizmos() {
        Gizmos.color = debugCollisionColor;
        Gizmos.DrawWireSphere(SightPos, collisionRadius);
    }
    #endregion

    #region 准线相关
    public float LineWide = 0.15f;
    private SpriteRenderer sightLineRenderer;
    private void updateLine() {
        Vector2 pos = transform.parent.position + (Vector3)StartPosOffset;

        float d = Vector2.Distance(pos, SightPos);
        sightLineRenderer.size = new Vector2(d + 0.2f, LineWide);
    }
    #endregion
}

```

别忘了父物体枪械上的代码：
```
private void lookAtSight() {
  // 获取准星的世界坐标
	Vector2 SightPos = SC.SightPos;
  // 先让轴指向准星
	transform.LookAt(new Vector3(SightPos.x, SightPos.y));
  // 再y轴旋转-90度
	transform.Rotate(new Vector3(0, -90, 0));
}
```

当然想放在瞄准线的控制代码里也行，如果不需要枪械也同步旋转的话。

# 5. 后语

这个小项目还有其它很多小技术点，感觉后面可以再跟大家分享一下！你们有说明想要交流的也可以直接跟我留言鸭！
B站账号：https://space.bilibili.com/172549987?spm_id_from=333.1007.0.0
CSDN账号：https://blog.csdn.net/qq_44705559?spm=1001.2101.3001.5343
GitHub账号：https://github.com/MycroftCooper
个人博客：https://mycroftcooper.github.io/
