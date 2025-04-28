---
title: Unity-2D移动幻影的实现
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - Unity
  - 2D
category: 程序/引擎/Unity/功能实现
note status: 草稿
---

# 0. 前言

本片文章是对https://www.bilibili.com/video/bv1sY411V7tx视频中移动幻影是如何实现的一个讲解教程，欢迎大家去B站给我一键三连鸭！

这个项目的整个代码和资源已经上传到了GitHub，大家可以去看一下
链接：https://github.com/MycroftCooper/TigerShooting2DGame

# 1. 效果分析

![移动拖影](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216773.gif)

![image-20220302233640359](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216815.png)

根据上图的移动幻影效果，我们可以分析出，它应该具有以下几个功能：

1. 在小老虎冲刺的时候，产生幻影
2. 幻影的精灵图片应该是那一帧小老虎的动作
3. 幻影要能定时消失
4. 幻影的透明度要低于正常的精灵

# 2. 素材准备

根据以上的四个功能，我们可以知道，实际上幻影的效果可以直接用精灵去实现。

首先我们需要准备好小老虎翻滚的帧动画，并且实现翻滚的功能(此处略过)
![image-20220305001822640](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216850.png)然后我们创建一个幻影的预制体，并为它加上精灵渲染器组件，如下图所示(想要有几个幻影就复制几个预制体)

![image-20220303000051726](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216880.png)

![image-20220303000107408](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216911.png)

其中精灵是哪张图片无所谓，反正最后要用代码去动态的控制，其中的材质也是精灵图片的默认材质，如下图所示：
![image-20220304233846358](attachments/notes/程序/引擎/Unity/功能实现/Unity-2D移动幻影的实现/IMG-20250428120216944.png)

# 2. 功能实现

## 2.1 产生幻影

这个功能很简单，就是把预制体移动到小老虎的位置坐标，然后让材质的透明度提升到半透明状态即可：

```c#
// 小老虎的动画控制器
private PlayerAnimaController anim;    

public void AddGhost(SpriteRenderer sr) {
  // 把幻影位置设置为小老虎的位置坐标
  sr.transform.position = anim.transform.position;
  // 通过材质的颜色设置，使幻影半透明(更改透明度alpha值)
  sr.material.color = new Color(sr.color.r, sr.color.g, sr.color.b, 0.6f);
  // 使幻影的反转与小老虎一样
  sr.flipX = anim.IsFlip;
  // 使幻影的精灵图片与当前小老虎的一致
  sr.sprite = anim.sr.sprite;
}
```

## 2.2 按时间产生与消失

想要让三个幻影从小老虎翻滚开始，按照固定的时间间隔产生，再按照相同的时间间隔消失，这个有很多种方法可以做到。
能立马想到的有：协程，计时器(Timer)等等。
但实际上，我使用的是DoTween里的动画队列Sequence。

代码如下：

```c#
using DG.Tweening;

public float ghostInterval;// 幻影出现的时间间隙
public float fadeTime;// 幻影消失的时间间隙

public void ShowGhost() {
  // 初始化一个动画队列
    Sequence s = DOTween.Sequence();

  // 产生幻影的动画队列
    for (int i = 0; i < transform.childCount; i++) {
        Transform currentGhost = transform.GetChild(i);
    SpriteRenderer sr = currentGhost.GetComponent<SpriteRenderer>();
    s.AppendCallback(() => AddGhost(sr));
    s.AppendInterval(ghostInterval);
  }

  // 幻影消失的动画队列
  for (int i = 0; i < transform.childCount; i++) {
    Transform currentGhost = transform.GetChild(i);
    SpriteRenderer sr = currentGhost.GetComponent<SpriteRenderer>();
    s.AppendCallback(() => sr.material.DOColor(new Color(sr.color.r, sr.color.g, sr.color.b, 0), fadeTime));
    s.AppendInterval(fadeTime);
  }
}
```

> DoTween是一个非常好用且免费的Unity插件，它一般用于解决补间动画的程序控制，在Unity资源商店就可以获得，后面我也会出一期对应的教程！

# 3. 源代码

```c#
using DG.Tweening;
using UnityEngine;

public class GhostTrail : MonoBehaviour {
    private PlayerAnimaController anim;
    public float ghostInterval;
    public float fadeTime;

    private void Start() {
        for (int i = 0; i < transform.childCount; i++) {
            Transform currentGhost = transform.GetChild(i);
            SpriteRenderer sr = currentGhost.GetComponent<SpriteRenderer>();
            sr.color = new Color(sr.color.r, sr.color.g, sr.color.b, 1f);
            sr.material.color = new Color(sr.color.r, sr.color.g, sr.color.b, 0f);
        }
        anim = FindObjectOfType<PlayerAnimaController>();
    }

    public void ShowGhost() {
        Sequence s = DOTween.Sequence();
        for (int i = 0; i < transform.childCount; i++) {
            Transform currentGhost = transform.GetChild(i);
            SpriteRenderer sr = currentGhost.GetComponent<SpriteRenderer>();
            s.AppendCallback(() => AddGhost(sr));
            s.AppendInterval(ghostInterval);
        }
        for (int i = 0; i < transform.childCount; i++) {
            Transform currentGhost = transform.GetChild(i);
            SpriteRenderer sr = currentGhost.GetComponent<SpriteRenderer>();
            s.AppendCallback(() => sr.material.DOColor(new Color(sr.color.r, sr.color.g, sr.color.b, 0), fadeTime));
            s.AppendInterval(fadeTime);
        }
    }

    public void AddGhost(SpriteRenderer sr) {
        sr.transform.position = anim.transform.position;
        sr.material.color = new Color(sr.color.r, sr.color.g, sr.color.b, 0.6f);
        sr.flipX = anim.IsFlip;
        sr.sprite = anim.sr.sprite;
    }
```

# 5. 后语

这个小项目还有其它很多小技术点，感觉后面可以再跟大家分享一下！你们有说明想要交流的也可以直接跟我留言鸭！
B站账号：https://space.bilibili.com/172549987?spm_id_from=333.1007.0.0
CSDN账号：https://blog.csdn.net/qq_44705559?spm=1001.2101.3001.5343
GitHub账号：https://github.com/MycroftCooper
个人博客：https://mycroftcooper.github.io/
