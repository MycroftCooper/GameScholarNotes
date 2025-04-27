---
title: Unity-输入操作
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. 简介

自定义编辑器相关类

- EditorGUI
- EditorGUILayout

- Handles扩展

# 2. Gizmos辅助线

https://blog.csdn.net/dengshunhao/article/details/83001076

https://docs.unity.cn/cn/current/Manual/GizmosAndHandles.html

## 2.1 描述

Gizmos辅助图标用于协助在 Scene 视图中进行视觉调试或设置。

Unity本身的编辑器中就自带很多Gizmos辅助线，详细的可以看[Gizmos菜单官方文档](https://docs.unity.cn/cn/current/Manual/GizmosMenu.html)

> 注意：
>
> - 所有Gizmos辅助线的绘制都必须在 [OnDrawGizmos](https://docs.unity.cn/cn/current/ScriptReference/MonoBehaviour.OnDrawGizmos.html) 或 [OnDrawGizmosSelected](https://docs.unity.cn/cn/current/ScriptReference/MonoBehaviour.OnDrawGizmosSelected.html) 函数中实现
> - 脚本必须继承Mono

这两个方法的区别是：

-  [OnDrawGizmos](https://docs.unity.cn/cn/current/ScriptReference/MonoBehaviour.OnDrawGizmos.html)
  每一帧都会调用，其中渲染的所有辅助线都可以选择。
-  [OnDrawGizmosSelected](https://docs.unity.cn/cn/current/ScriptReference/MonoBehaviour.OnDrawGizmosSelected.html)
  仅在选择了附加此脚本的对象时才调用

## 2.2 Gizmos API

- 常用静态变量

|变量名称|作用|
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [color](https://docs.unity.cn/cn/current/ScriptReference/Gizmos-color.html) | 为接下来绘制的辅助图标设置颜色。                             |
| [exposure](https://docs.unity.cn/cn/current/ScriptReference/Gizmos-exposure.html) | 设置包含 LightProbe 辅助图标的曝光校正的纹理。值从纹理中间的红色通道进行采样。 |
| [matrix](https://docs.unity.cn/cn/current/ScriptReference/Gizmos-matrix.html) | 设置 Unity Editor 用于绘制 Gizmos 的 Matrix4x4。             |
| [probeSize](https://docs.unity.cn/cn/current/ScriptReference/Gizmos-probeSize.html) | 设置灯光探测小控件的比例。此比例将用于渲染预览球体。 |

- 常用静态方法

|方法名称|作用|
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [DrawCube](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawCube.html) | 使用 center 和 size 绘制一个实心盒体。                       |
| [DrawFrustum](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawFrustum.html) | 绘制一个摄像机视锥体，并且将当前设置的 Gizmos.matrix 用于其位置和旋转。 |
| [DrawGUITexture](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawGUITexture.html) | 在该场景中绘制一个纹理。                                     |
| [DrawIcon](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawIcon.html) | 在 Scene 视图中的某个位置绘制一个图标。                      |
| [DrawLine](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawLine.html) | 绘制一条从 A坐标 到 B坐标 的线。                    |
| [DrawMesh](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawMesh.html) | 绘制一个网格。                                               |
| [DrawRay](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawRay.html) | 绘制一条从 from 开始到 from + direction 的射线。             |
| [DrawSphere](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawSphere.html) | 使用 center 和 radius 绘制一个实心球体。                     |
| [DrawWireCube](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawWireCube.html) | 使用 center 和 size 绘制一个线框盒体。                       |
| [DrawWireMesh](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawWireMesh.html) | 绘制一个线框网格。                                           |
| [DrawWireSphere](https://docs.unity.cn/cn/current/ScriptReference/Gizmos.DrawWireSphere.html) | 使用 center 和 radius 绘制一个线框球体。                     |

## 2.3 使用案例

效果展示图：
![image-20211108001109538](./attachments/Unity-编辑器扩展-辅助线/34fc5998.png)

### 2.3.1 绘制直线

`Gizmos.DrawLine(Vector3 A , Vector B);`
绘制一条从 A坐标 到 B坐标 的线

```c#
void OnDrawGizmos()
{
    Gizmos.color = Color.green;
    Gizmos.DrawLine( obj1.transform.position , obj2.transform.position );
}
```

### 2.3.2 绘制射线

`Gizmos.DrawRay(Vector3 A, Vector3.up * 10);`
绘制一条从A点出发，向上10个单位长度的射线

```c#
void OnDrawGizmos()
{
    Gizmos.color = Color.gray;
    Gizmos.DrawRay(obj.transform.position, Vector3.up * 10);  //10 是长度
}
```

### 2.3.2 绘制立方体

`Gizmos.DrawCube(Vector3 A , Vector3.one);`

 在 坐标A 绘制一个（1,1,1）大小的立方体

```c#
void OnDrawGizmos()
{
    Gizmos.color = Color.red;
    Gizmos.DrawCube(Vector3.up , Vector3.one);
}
```

### 2.3.6 绘制球体

`Gizmos.DrawSphere(Vector A, float radius);`
在 坐标A 绘制一个半径为 radius 的球体

```c#
void OnDrawGizmos()
{
    Gizmos.color = Color.red;
    Gizmos.DrawSphere(Vector3.zero , 1f);
}
```

### 2.3.5 绘制图片

`Gizmos.DrawIcon(Vector3 A, string IconPath);`
在坐标A处生成 IconPath 路径下的图片作为Icon

```c#
void OnDrawGizmos()
{
    Gizmos.DrawIcon(Vector3.zero , "002IMgZLzy6Mro7r94Ka2&690.jpg");
}
```

> 注意：
> 此图片要放到Assets下的  Gizmos文件夹里才行。

# 3. Handles控制柄

https://docs.unity.cn/cn/current/ScriptReference/Handles.html

https://qianxi.blog.csdn.net/article/details/83000972

## 3.1 描述

Handles控制柄是 Unity 用于操作场景视图中的项的 3D 控件。

内置的 Handle GUI 有很多，如通过变换组件定位、缩放和旋转对象的熟悉的工具。
不过，您也可以自行定义 Handle GUI，以与自定义组件编辑器结合使用。
此类 GUI 对于编辑以程序方式生成的场景内容、“不可见”项和相关对象的组（如路径点和位置标记）非常实用。

您还可以使用覆盖在场景视图上的 2D 按钮和其他控件来补充场景中的 3D 手柄 GUI。
这是通过将标准 Unity GUI 调用封装在 [Editor.OnSceneGUI](https://docs.unity.cn/cn/current/ScriptReference/Editor.OnSceneGUI.html) 函数中的 [Handles.BeginGUI](https://docs.unity.cn/cn/current/ScriptReference/Handles.BeginGUI.html) 和 [Handles.EndGUI](https://docs.unity.cn/cn/current/ScriptReference/Handles.EndGUI.html) 对中完成的。

可以使用 [HandleUtility.GUIPointToWorldRay](https://docs.unity.cn/cn/current/ScriptReference/HandleUtility.GUIPointToWorldRay.html) 和 [HandleUtility.WorldToGUIPoint](https://docs.unity.cn/cn/current/ScriptReference/HandleUtility.WorldToGUIPoint.html) 在 2D GUI 与 3D 世界坐标之间转换坐标。

## 3.2 Handles API

- 静态变量

|变量名称|作用|
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [centerColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-centerColor.html) | 用于表示某物体中心的控制柄的颜色。                          |
| [color](https://docs.unity.cn/cn/current/ScriptReference/Handles-color.html) | 控制柄的颜色。                                              |
| [inverseMatrix](https://docs.unity.cn/cn/current/ScriptReference/Handles-inverseMatrix.html) | 所有控制柄操作的矩阵的逆矩阵。                              |
| [lighting](https://docs.unity.cn/cn/current/ScriptReference/Handles-lighting.html) | 控制柄是否亮起                                            |
| [lineThickness](https://docs.unity.cn/cn/current/ScriptReference/Handles-lineThickness.html) | 控制柄线厚度（只读） |
| [matrix](https://docs.unity.cn/cn/current/ScriptReference/Handles-matrix.html) | 所有控制柄的矩阵。                                      |
| [preselectionColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-preselectionColor.html) | 用于突出显示鼠标指针下当前未选中的控制柄的颜色。            |
| [secondaryColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-secondaryColor.html) | 用于一般物体的柔和色。                                       |
| [selectedColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-selectedColor.html) | 用于当前处于活动状态的控制柄的颜色。                        |
| [xAxisColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-xAxisColor.html) | 用于操纵某物体 X 坐标的控制柄的颜色。                       |
| [yAxisColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-yAxisColor.html) | 用于操纵某物体 Y 坐标的控制柄的颜色。                       |
| [zAxisColor](https://docs.unity.cn/cn/current/ScriptReference/Handles-zAxisColor.html) | 用于操纵某物体 Z 坐标的控制柄的颜色。                       |
| [zTest](https://docs.unity.cn/cn/current/ScriptReference/Handles-zTest.html) | 控制柄的 zTest。                                            |

- 变量

|变量名称|作用|
| ------------------------------------------------------------ | -------------------------------- |
| [currentCamera](https://docs.unity.cn/cn/current/ScriptReference/Handles-currentCamera.html) | 当前摄像机(控制柄移动范围在摄像机视野内) |

- 静态函数

|方法名称|作用|
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [ArrowHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.ArrowHandleCap.html) | 绘制一个类似于移动工具所用箭头的箭头。                       |
| [BeginGUI](https://docs.unity.cn/cn/current/ScriptReference/Handles.BeginGUI.html) | 在 3D 手柄 GUI 内开始一个 2D GUI 块。                        |
| [Button](https://docs.unity.cn/cn/current/ScriptReference/Handles.Button.html) | 创建一个 3D 按钮。                                           |
| [CircleHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.CircleHandleCap.html) | 绘制一个圆形手柄。将此手柄传递给 handle 函数。               |
| [ClearCamera](https://docs.unity.cn/cn/current/ScriptReference/Handles.ClearCamera.html) | 清除摄像机。                                                 |
| [ConeHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.ConeHandleCap.html) | 绘制一个锥体手柄。将此手柄传递给 handle 函数。               |
| [CubeHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.CubeHandleCap.html) | 绘制一个立方体手柄。将此手柄传递给 handle 函数。             |
| [CylinderHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.CylinderHandleCap.html) | 绘制一个圆柱体手柄。将此手柄传递给 handle 函数。             |
| [Disc](https://docs.unity.cn/cn/current/ScriptReference/Handles.Disc.html) | 创建一个可使用鼠标拖动的 3D 圆盘。                           |
| [DotHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.DotHandleCap.html) | 绘制一个圆点手柄。将此手柄传递给 handle 函数。               |
| [DrawAAConvexPolygon](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawAAConvexPolygon.html) | 绘制使用点数组指定的抗锯齿凸多边形。                         |
| [DrawAAPolyLine](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawAAPolyLine.html) | 绘制使用点数组和宽度指定的抗锯齿线。                         |
| [DrawBezier](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawBezier.html) | 绘制通过给定切线的起点和终点的纹理化贝塞尔曲线。             |
| [DrawCamera](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawCamera.html) | 在矩形内绘制一个摄像机。                                     |
| [DrawDottedLine](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawDottedLine.html) | 绘制一条从 p1 到 p2 的虚线。                                 |
| [DrawDottedLines](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawDottedLines.html) | 绘制一系列虚线段。                                           |
| [DrawGizmos](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawGizmos.html) | 为给定摄像机绘制 Gizmos 的子集（在后处理之前或之后）。       |
| [DrawLine](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawLine.html) | 从p1至p2绘制一条线段                    |
| [DrawLines](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawLines.html) | 绘制一系列线段。                                             |
| [DrawPolyLine](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawPolyLine.html) | 绘制一条穿过 points 列表的线。                               |
| [DrawSelectionFrame](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawSelectionFrame.html) | 绘制一个面向选择框的摄像机。                                 |
| [DrawSolidArc](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawSolidArc.html) | 在 3D 空间中绘制一个圆扇形（饼图）。                         |
| [DrawSolidDisc](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawSolidDisc.html) | 在 3D 空间中绘制一个实心平面圆盘。                           |
| [DrawSolidRectangleWithOutline](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawSolidRectangleWithOutline.html) | 在 3D 空间中绘制一个实心轮廓矩形。                           |
| [DrawTexture3DSDF](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawTexture3DSDF.html) | Draws a 3D texture using Signed Distance Field rendering mode in 3D space. |
| [DrawTexture3DSlice](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawTexture3DSlice.html) | Draws a 3D texture using Slice rendering mode in 3D space.   |
| [DrawTexture3DVolume](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawTexture3DVolume.html) | Draws a 3D texture using Volume rendering mode in 3D space.  |
| [DrawWireArc](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawWireArc.html) | Draws a circular arc in 3D space.                            |
| [DrawWireCube](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawWireCube.html) | 使用 center 和 size 绘制一个线框盒体。                       |
| [DrawWireDisc](https://docs.unity.cn/cn/current/ScriptReference/Handles.DrawWireDisc.html) | Draws the outline of a flat disc in 3D space.                |
| [EndGUI](https://docs.unity.cn/cn/current/ScriptReference/Handles.EndGUI.html) | 结束一个 2D GUI 块并返回到 3D 手柄 GUI。                     |
| [FreeMoveHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.FreeMoveHandle.html) | 创建一个不受约束的移动手柄。                                 |
| [FreeRotateHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.FreeRotateHandle.html) | 创建一个不受约束的旋转手柄。                                 |
| [GetMainGameViewSize](https://docs.unity.cn/cn/current/ScriptReference/Handles.GetMainGameViewSize.html) | 获取主游戏视图的宽度和高度。                                 |
| [Label](https://docs.unity.cn/cn/current/ScriptReference/Handles.Label.html) | 在 3D 空间中创建一个文本标签。                               |
| [MakeBezierPoints](https://docs.unity.cn/cn/current/ScriptReference/Handles.MakeBezierPoints.html) | 返回表示贝塞尔曲线的点数组。                                 |
| [PositionHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.PositionHandle.html) | 创建一个位置手柄。                                           |
| [RadiusHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.RadiusHandle.html) | 创建一个场景视图半径手柄。                                   |
| [RectangleHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.RectangleHandleCap.html) | 绘制一个矩形手柄。将此手柄传递给 handle 函数。               |
| [RotationHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.RotationHandle.html) | 创建一个场景视图旋转手柄。                                   |
| [ScaleHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.ScaleHandle.html) | 创建一个场景视图缩放手柄。                                   |
| [ScaleSlider](https://docs.unity.cn/cn/current/ScriptReference/Handles.ScaleSlider.html) | 创建一个定向缩放滑动条。                                     |
| [ScaleValueHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.ScaleValueHandle.html) | 创建一个缩放单个浮点的 3D 手柄。                             |
| [SetCamera](https://docs.unity.cn/cn/current/ScriptReference/Handles.SetCamera.html) | 设置当前摄像机，以便所有手柄和辅助图标均使用相应设置进行绘制。 |
| [ShouldRenderGizmos](https://docs.unity.cn/cn/current/ScriptReference/Handles.ShouldRenderGizmos.html) | 确定是否绘制 Gizmos。                                        |
| [Slider](https://docs.unity.cn/cn/current/ScriptReference/Handles.Slider.html) | 创建一个沿着一个轴移动的 3D 滑动条。                         |
| [Slider2D](https://docs.unity.cn/cn/current/ScriptReference/Handles.Slider2D.html) | 创建一个沿两个轴定义的平面移动的 3D 滑动条。                 |
| [SnapToGrid](https://docs.unity.cn/cn/current/ScriptReference/Handles.SnapToGrid.html) | 将每个 Transform.position 四舍五入到 EditorSnap.move 的最接近倍数。 |
| [SnapValue](https://docs.unity.cn/cn/current/ScriptReference/Handles.SnapValue.html) | 如果对齐为 active，则将 value 四舍五入到 snap 的最接近倍数。注意，snap 只能为正数。 |
| [SphereHandleCap](https://docs.unity.cn/cn/current/ScriptReference/Handles.SphereHandleCap.html) | 绘制一个球体手柄。将此手柄传递给 handle 函数。               |
| [TransformHandle](https://docs.unity.cn/cn/current/ScriptReference/Handles.TransformHandle.html) | 创建变换手柄。                                               |

## 3.3 使用案例

### 3.3.0 准备
Scripts文件夹中创建C#脚本”MyHandles”,在Editor文件夹中创建C#脚本”HandleInspector”,将下小图标保存到Img文件夹中。 

### 3.3.1 绘制半径操作柄

- `Handles.Label(Vector3 position,string name);`
  在position位置绘制内容为name的标签
- `float RadiusHandle (Quaternion rotation, Vector3 position, float radius);`
  在position位置以rotation为角度绘制半径为radius的半径操作柄

在MyHandles.cs脚本中添加一个变量：

```php
public float areaRadius; //半径
```

然后打开HandlesInspector.cs脚本添加：

```csharp
using UnityEngine;
using System.
using UnityEditor;

[CustomEditor(typeof(MyHandles))]
public class HandlesInspector:Editor
{
    MyHandles myHandles;
    void OnEnable()
    {
        myHandles=(MyHandles)target;
    }
     public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
    }
    private void OnSceneGUI()
    {
        //第一个参数为在场景中显示的位置(以物体的中心位置为基准)
        //第二个参数为显示的名字
        //用于在场景中显示设置的名字
        Handles.Label(myHandles.transform.position+new Vector3(0,1,0),"MyHandles");

        //第一个参数为该旋转操作柄的初始旋转角度
        //第二个参数为操作柄显示的位置(以物体的旋转位置为基准)
        //第三个参数为设置操作柄的半径
        //用于在场景中显示半径操作柄
        myHandles.areaRadius = Handles.RadiusHandle(Quaternion.identity,myHandles.transform.position,myHandles.areaRadius);
    }
}
```

将这两个脚本保存，回到Unity中创建一个空物体，并为其添加 MyHandles.cs 脚本。就可以实现了

**作用：**
多用于制作AI，用于判断和指定AI影响范围用的。

### 3.3.2 绘制缩放操作柄

- `float ScaleValueHandle (float value, Vector3 position, Quaternion rotation, float size, Handles.CapFunction capFunction, float snap);`
  - value 该操作柄操作的值
  - position 操作柄的绘制位置
  - rotation 操作柄的指向
  - size 操作柄的大小
  - 操作柄的显示方式(本质上是个函数指针)：
    - ArrowCap 箭头
    - RectangleCap 矩形
    - CircleCap 圆形
    - 等等
  - snap 对齐增量(可以理解为单位长度，不会有比该值还小的值变化)

打开 MyHandles.cs 脚本，添加如下变量：

```php
public float size;//大小
```

然后为 HandlesInspector.cs 脚本添加如下代码：

```c#
myHandles.size = Handles.ScaleValueHandle(
	myHandles.size,
	myHandles.transform.position,
	Quaternion.identity,
	myHandles.size,
	Handles.ArrowCap,
	0.5f
);
```

**作用：**
多用于绘制一些自定义的操作，比如Unity的粒子系统就用到了好多自定义的操作柄，比如粒子系统的Shape参数就用到了该函数的第五个参数来绘制：

### 3.3.3 绘制位置操作柄

MyHandles.cs 脚本，添加如下变量： 

然后为 HandlesInspector.cs 脚本添加如下代码：

### 3.3.4 绘制旋转操作柄

### 3.3.5 绘制连接线

### 3.3.6 绘制贝塞尔曲线

![image-20211108233412915](./attachments/Unity-编辑器扩展-辅助线/38af25e3.png)

在Editor文件夹下创建脚本  HandlerTest  如下

```c#
using UnityEngine;
using System.Collections;
using UnityEditor;
 
[CustomEditor(typeof(Arraw))]
public class HandlerTest : Editor {
 
    Vector3[] positions;
 
    void OnSceneGUI()
    {
        float width = HandleUtility.GetHandleSize(Vector3.zero) * 0.5f;
        Arraw arraw = (Arraw)target;
 
        Handles.DrawBezier(arraw.transform.position, Vector3.zero, new Vector3(20, 20, 20), new Vector3(10, 10, 10), Color.yellow, null, width);
        //参数1 开始点坐标， 参数2，结束点坐标， 参数3 开始切线位置， 参数 4，结束切线位置， 参数 5 线的颜色 ，参数六 线的宽度
 
 
        if (GUI.changed)
        {
            EditorUtility.SetDirty(arraw);
        }
 
    }
}
 
 
Arraw脚本如下，将其拖拽到需要画线的对象即可
using UnityEngine;
using System.Collections;
 
public class Arraw : MonoBehaviour {
 
}
```

### 3.3.7 控制操作柄的显示
