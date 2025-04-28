---
title: UnityShader的形式
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - UnityShader
category: 技术美术/UnityShader
note status: 终稿
---


# 1. 简介

UnityShader最重要的任务是：指定各种着色器所需的代码

而代码的编写形式有以下三种

# 2. 长子：顶点/片元着色器

在Unity中我们可以使用**CG/HLSL语言**来编写**顶点/片元着色器(Vertex/Fragment Shader)**。
它更复杂也更灵活。

它写在Pass语句块内，格式如下

```
Shader "Unlit/MyFirstShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}
	}	
}
```

#pragma是Unity内置的编绎指令用的命令
在Pass中我们就利用此命令来声明所需要的顶点着色器与片元着色器。

- #pragma vertexName
  定义顶点着色器为*name,*通常情况下会起名为vert。

- #pragma fragmentName
  定义片元着色器为*name,*通常情况下会起名为frag。

## 2.1 顶点着色器

顶点着色器就是处理顶点的着色器，每个顶点都会执行一次顶点着色器。

例如：

```c++
	float4 vert(float4 vertex:POSITION):SV_POSITION
	{
		return UnityObjectToClipPos(vertex);
	}
```

![image-20210523163930947](attachments/notes/技术美术/UnityShader/UnityShader的形式/IMG-20250428024059982.png)

首先呢，我们先来解释下顶点这个函数的结构。

1. 顶点着色器函数的名称，在上面我们已经指定了顶点着色器的名称就是vert，所以这里我们必须要用vert作为名称。
2. 其中float4 vertex是我们自己定义的一个四维向量，名字叫vertex（名字我们可以随便起），仅仅定义一个四维向量并不能使它拥有我们模型的顶点信息，所以这里我们需要为它指定一个语义——POSITION，POSITION就是代表着模型的顶点位置信息。此时变量vertex就表示着我们模型的顶点位置。
3. 在顶色着色器中最主要的事情就是将顶点从模型坐标转换到裁剪坐标（将模型显示在二维显示器上时需要做的一些矩阵转换）。
   不会矩阵转换怎么办，没关系，Unity已经为我们准备好现成的命令了，只需调用UnityObjectToClipPos即可，后面括号中加上我们的顶点位置变量就可以了。
4. 在后面片断着色器中我们需要顶点着色器中的输出结果，所以3中需要加上return来将转换后的顶点返回，float4就是用来定义我们返回的是四维向量。
5. 经过变换后返回的顶点位置，我们也需要利用语义来标记一下，以便片元着色器可以知道哪个是从顶点着色器输出过来的顶点位置信息。所以我们在函数的后面加上: SV_POSITION。

> 简单地说：
> POSITION语义是用于顶点着色器，用来指定模型的顶点位置，是在变换前的顶点的本地空间坐标。
> SV_POSITION语义则用于像素着色器，用来标识经过顶点着色器变换之后的顶点坐标。
>
> 在顶点着色器中处理顶点时，我们首先需要获取到模型的顶点数据（比如顶点位置、法线信息、顶点颜色等等），那么这些数据都是直接存储在模型中的，我们在Shader中只需要通过标识语义就可以自动获得。

此时我们的Shader还不能正常编译，因为了除了顶点着色器外，还们需要一个片断着色器。

## 2.2 片元着色器

片元着色器也被称作像素着色器，主要是处理最终显示在屏幕上的像素结果。

经过顶点着色器的处理，我们已经得到了最终显示在屏幕上的顶点矩阵，内部会自动进行插值计算，以获得当前模型的所有片元像素，然后每个像素都会执行一次片元着色器，得到最终每个像素的颜色值。

例如：

```c++
fixed4 _Color;
fixed4 frag () : SV_Target
{
	return _Color;
}
```

![image-20210523164629339](attachments/notes/技术美术/UnityShader/UnityShader的形式/IMG-20250428024100010.png)

1. 片断着色器的函数名，其中()中是空的，因为在这个简单的示例中我们并不需要额外的数据传过来，所以暂时为空。

2. 在Cg/HLSL中使用Properties中的变量前还需要在Cg/HLSL中再重新声明一次，名称要求一致。
   这是死规则，我们只能按照要求来执行。
   float、half、fixed，这三都是浮点数的表示，只是分别对应的精度不一样，主要用此可以进行更进一步的优化。

3. 直接返回_Color,也就是直接返回我们在材质面板中定义的颜色，这也是我们这个小例子想要的效果。

4. 返回的值是个四维向量，我们用float4来表示，如果想优化的话就用fixed4来表示，精度问题，这里不是重点。

5. SV_TARGET是系统值，表示该函数返回的是用于下一个阶段输出的颜色值，也就是我们最终输出到显示器上的值。

## 2.3 最终代码

```text
Shader "Unlit/MyFirstShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			
			float4 vert ( float4 vertex : POSITION ) : SV_POSITION
			{
				return UnityObjectToClipPos(vertex);
			}
			
			fixed4 frag () : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}	
}
```

此时我们已经可以正常编译并实时更换颜色得到反馈了。

## 2.4 注意

顶点着色器与片断着色器的执行并不是1:1的

例如:
一个三角面片，只有三个顶点，顶点着色器只需执行3次，而片断着色器由最终的像素数来决定，执行几百上千都是很正常的。

所以从性能的角度来考虑，我们要尽量把计算放在顶点着色器中去执行。
其次在片断着色器中也要尽量的简化算法，节省开支。

# 3. 宠儿：表面着色器

表面着色器(Surface Shader)是Unity自己创造的一种着色器代码类型。

特点是：

- 代码量少，使用方便简单

- 渲染代价大

实际上，表面着色器在运行时会被Unity编译成对应的顶点/片元着色器。
我们可以理解为表面着色器是Unity对顶点/片元着色器的封装抽象。

一个非常简单的表面着色器示例代码如下:

```c
Shader "Custom/simple surface Shader" 
{
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf Lambert
		struct Input 
		{
			float4 color : COLOR;
		};
		void surf (Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = 1;
		}
		ENDCG
	}
	Fallback "Di ffuse" 
}
```

从上述程序中可以看出，表面着色器被定义在SubShader语义块(而非Pass语义块)中的CGPROGRAM和ENDCG之间。
因为表面着色器不需要开发者关心使用多少个Pass每个如何渲染等问题，Unity 会在背后为我们做好这些事情。

> 注意：
> 这里的Cg/HLSL是Unity经封装后提供的，它的语法和标准的CgHLSL语法几乎一样， 但还是有细微的不同
> 例如有些原生的函数和用法Unity并没有提供支持。

# 4. 孤儿：固定函数着色器

上述两种UnityShader形式都使用了可编程管线，而对于一些不支持可编程管线的旧设备，就需要用**固定函数着色器(Fixed Function Shader)**。

这种着色器往往只能完成非常简单的效果。

固定函数着色器的代码被定义在Pass语句块中，且只是用ShaderLab的语法，不支持Cg/HLSL。

因为时代变了，现在大多数GPU都支持可编程管线，所以固定函数着色器成了孤儿。
实际上，固定函数着色器在运行时会被Unity编译成对应的顶点/片元着色器，因此真正的固定函数着色器已经不存在了。

> 所以就略过吧，别学，没用的。

# 5. 着色器的选择

- 除非你有非常明确的需求必须要使用固定函数着色器
  例如需要在非常旧的设备上运行你的游戏(这些设备非常少见)
  否则**不要使用固定函数着色器**
- 如果你想和**各种光源**打交道
  使用表面着色器
  但需要小心它在**移动平台的性能表现**
- 如果你使用的**光照数目非常少**
  使用顶点/片元着色器
- 如果你有**很多自定义的渲染效果**
  请选择顶点/片元着色器

> 其它两种着色器在编译时都会编译成顶点/片选着色器
> 因此从本质上来讲，Unity中只存在顶点/片选着色器
