---
title: UnityShader 开发笔记：椭圆阴影
author: MycroftCooper
created: 2025-04-29 18:28
lastModified: 2025-04-29 18:28
tags:
  - UnityShader
category: 技术美术/UnityShader/功能实现
note status: 终稿
---
## 一、功能概述

本Shader用于在2D游戏中绘制一个灵活的椭圆形阴影效果。它不仅能实现椭圆形状的缩放控制，还能够实现内向模糊（边缘渐隐）、像素化风格，以及描边效果。同时，还对多个实例的绘制进行了优化，支持GPU Instancing以提升性能。

**适用场景**：

- 2D游戏中的角色、道具或UI元素阴影表现。
    
- UI 装饰元素，强调视觉风格与层次感。
    
- 需要快速调整阴影效果（如模糊度、像素化程度）的开发场景。
    

![[attachments/notes/技术美术/UnityShader/功能实现/UnityShader 开发笔记：椭圆阴影/IMG-20250430144026111.png]]
![[attachments/notes/技术美术/UnityShader/功能实现/UnityShader 开发笔记：椭圆阴影/IMG-20250430144137368.png]]
## 二、核心功能拆解

### 1. 椭圆阴影形状

椭圆阴影的实现是通过修改Shader中的UV坐标完成的，利用两个关键参数：

- `_ScaleX`：横向缩放椭圆形阴影。
    
- `_ScaleY`：纵向缩放椭圆形阴影。
    

在顶点着色器中对UV坐标进行处理，使阴影可以在横纵轴方向灵活调整：

```hlsl
float sx = UNITY_ACCESS_INSTANCED_PROP(Props, _ScaleX); float sy = UNITY_ACCESS_INSTANCED_PROP(Props, _ScaleY);  float2 centered = v.uv - 0.5; centered.x *= sx; centered.y *= sy; o.uv = centered + 0.5;
```


### 2. 内向模糊效果（Inward Blur）

内向模糊效果用于实现阴影的边缘柔和渐隐，避免过于生硬的边缘视觉。

具体实现步骤如下：

- 计算椭圆的中心坐标，进而计算像素距离中心的归一化距离。
    
- 使用 `_Blur` 参数控制模糊半径，通过此参数实现边缘渐隐效果。
    

关键代码：

`float b = max(blur, 1e-4); float grad = saturate((1.0 - dist) / b);`

当`_Blur` 值增大时，阴影边缘渐变区域变宽，视觉效果更为柔和。

### 3. 描边与像素化效果（Outline & Pixelate）

#### 描边效果

描边用于增强阴影的视觉轮廓清晰度，通过两个参数控制：

- `_OutlineColor` 控制描边颜色。
    
- `_OutlineWidth` 控制描边宽度。
    

#### 像素化效果

提供像素化风格，以适配不同游戏的视觉风格，具体参数为：

- `_Pixelate` 控制是否启用像素化效果（0为关闭，1为完全像素化）。
    
- `_PixelSize` 决定每个像素块的尺寸（像素化颗粒的大小）。
    

#### 实现方式与叠加处理

将描边与像素化通过计算后的UV坐标共同实现，最终进行颜色叠加：

```hlsl
// 像素化计算 float2 pixUV = floor(uv * pixelSize) / pixelSize + (0.5 / pixelSize);
float2 finalUV = lerp(uv, pixUV, saturate(pixelate));  // 描边与阴影掩码计算 
float inner = 1.0 - outlineWidth; float shadowMask = step(dist, inner); 
float outlineMask = step(inner, dist);  // 颜色叠加 
fixed4 shadowCol  = color * (grad * shadowMask); fixed4 outlineCol = outlineColor * (grad * outlineMask); return shadowCol + outlineCol;
```

## 三、使用示例与参数配置建议

### 推荐参数示例：

|参数|推荐值范围|常见场景描述|
|---|---|---|
|_ScaleX, _ScaleY|(0.5 ~ 3.0)|常规角色或物体阴影缩放|
|_Blur|(0.05 ~ 0.2)|柔和的自然阴影效果|
|_Pixelate|0 或 0.5~1.0|像素风格游戏的视觉表现|
|_PixelSize|8, 16, 32|控制像素块的大小（通常为8~32）|
|_OutlineWidth|0 或 0.02~0.1|增强视觉表现，可选轮廓描边效果|

### 快速调参建议：

- 从默认值入手，先调整椭圆缩放，再逐步微调模糊参数。
    
- 像素化效果通常作为风格化展示，不建议过度使用。
    
- 描边效果应谨慎使用，以防止过于突兀，推荐采用低透明度颜色。
    
### 常见问题与解决方法（FAQ）：

- **边缘过于生硬？**  
    增加`_Blur`值使其更柔和。
    
- **性能下降明显？**  
    尽可能关闭像素化或减少模糊程度；合理使用Instancing批处理。
    

## 四、Instancing 优化与性能扩展

### GPU Instancing 优化

本Shader使用Unity的GPU Instancing技术来批量渲染多个阴影实例，显著提升性能。

**实现方式：** 通过定义`UNITY_INSTANCING_BUFFER`实现每个实例单独设置属性：

```hlsl
UNITY_INSTANCING_BUFFER_START(Props)     
UNITY_DEFINE_INSTANCED_PROP(float4, _Color)     
UNITY_DEFINE_INSTANCED_PROP(float,  _ScaleX)    
UNITY_DEFINE_INSTANCED_PROP(float,  _ScaleY)    
UNITY_DEFINE_INSTANCED_PROP(float,  _Blur)     
UNITY_DEFINE_INSTANCED_PROP(float,  _Pixelate)    
UNITY_DEFINE_INSTANCED_PROP(float,  _PixelSize)    
UNITY_DEFINE_INSTANCED_PROP(float4, _OutlineColor)    
UNITY_DEFINE_INSTANCED_PROP(float,  _OutlineWidth)
UNITY_INSTANCING_BUFFER_END(Props)
```

实例化后的属性获取示例：
`float sx = UNITY_ACCESS_INSTANCED_PROP(Props, _ScaleX); float4 color = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);`

### 性能表现与优化策略：

- 适当减少 ALU 操作数，避免复杂的数学运算。
    
- 尽量避免大量高精度像素化操作，合理设置`_PixelSize`。
    
- 若无需像素化或描边，建议关闭对应功能（设置参数为0），以节省性能。
    

### 未来扩展功能设想：

- 支持更多的变形效果（如渐变、动态闪烁）。
    
- 增加法线或高度模拟，以便更具立体效果。
    
- 与动态光源联动，增强动态光影表现力。
    