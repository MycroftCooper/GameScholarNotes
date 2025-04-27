---
title: UnityShader的结构
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - UnityShader
category: 技术美术/UnityShader
note status: 终稿
---


# 1. 简介

## 1.1 什么是shader

Shader的中文翻译是着色器，是一类面对GPU编程语言的总称。
Shader其实就是一段代码，这段代码的作用是告诉GPU具体怎样去绘制模型的每一个顶点的颜色以及最终每一个像素点的颜色。

更具体的讲：

- GPU流水线上--些可高度编程的阶段,而由着色器编译出来的最终代码是会在GPU.上运行的(对于固定管线的渲染来说，着色器有时等同于--些特定的渲染设置);
- 有一些特定类型的着色器，如顶点着色器、片元着色器等;
- 依靠着色器我们可以控制流水线中的渲染细节,例如用顶点着色器来进行顶点变换以及传递数据，用片元着色器来进行逐像素的渲染。

## 1.2 shader语言有哪些

既然Shader是一段代码，那必然要用一种语言来书写它，目前主流的有三种语言：

- 基于OpenGL
  OpenGL Shading Language，简称GLSL。
- 基于DirectX
  High Level Shading Language,简称HLSL。
- 基于NVIDIA
  C for Graphic，简称Cg语言。

GLSL与HLSL分别是基于OpenGL和Direct3D的接口，两者不能混用。

而Cg语言是用于图形的C语言。
这其实说明了当时设计人员的一个初衷，就是**让基于图形硬件的编程变得和C语言编程一样方便，自由**。
正如C++和 Java的语法是基于C的，Cg语言本身也是基于C语言的。
如果您使用过C、C++、Java其中任意一个，那么Cg的语法也是比较容易掌握的。
Cg语言极力保留了C语言的大部分语义，力图让开发人员从硬件细节中解脱出来，Cg同时拥有高级语言的好处，如代码的易重用性，可读性高等。

> Cg语言是Microsoft和NVIDIA相互协作在标准硬件光照语言的语法和语义上达成了一致。
> 所以，HLSL和Cg其实是同一种语言。

## 1.3 什么是UnityShader

Unity Shader严格来说并不是传统上的Shader,而是Unity自身封装后的一种便于书写的Shader，又称为ShaderLab。

![UnityShader是封装](attachments/notes/技术美术/UnityShader/UnityShader的结构/IMG-20250428024123358.png)

其实在Unity中反而一切变的简单起来了，我们只需关心如何去这实现我们想要的效果就好了，其余的事情全部交给Unity来自动处理。
因为我们在Unity中编写的Shader最终会根据不同的平台来编绎成不同的着色器语言。

官方建议使用Cg/HLSL来编写ShaderLab，因为Cg/HLSL有更好的跨平台性。

# 2. UnityShader的结构

一段完整UnityShader代码的结构应该如下面的例子所示：

```Shader
Shader "Path/ShaderName"
{
	Properties
	{
	
	}
	SubShader
	{
		Pass
		{
		
		}
	}
	FallBack "Diffuse"
	CustomEditor "EditorName"
}
```

从整体来看的话，大致是这样的一个框架结构：

**Shader "name" { [Properties] SubShaders [FallBack] [CustomEditor] }**

> []方括号表示可选

可以拆分成以下几个大部分：

- Shader "name"
- Properties
- SubShaders
- FallBack
- CustomEditor

## 2.1 Shader "name"-路径名称

每个Unity Shader文件的第一行都需要通过Shader语句来指定该Unity Shader 的名字。
当为材质选择使用的UnityShader时,这些名称就会出现在材质面板的下拉列表里。

通过在字符串中添加斜杠(“/”)， 可以控制UnityShader在材质面板中出现的位置
例如:`Shader "Custom/ MyShader" {...}`
那么这个UnityShader在材质面板中的位置就是:Shader -> Custom -> MyShader

> 如果我们把路径名称放在Hidden下面的话
> 比如：`Shader "Hidden/TA/MyFirstShader"`
> 则表示在材质面板中隐藏此Shader,你将无法通过材质下拉列表中找到它。
> 这在做一些不需暴露的Shader时很有用处，可以使Shader下拉列表更精简整洁。

> 而Shader文件的名称，也就是我们在Project面板中的资源文件的名称，是可以与Shader内部的路径名称不一样的，这点与C#是不同的。
> 在定义内部路径名称时，建议统一规划下，不要Shader过多后导致很混乱，不便于美术去使用。

## 2.2 Properties-属性

Properties是UnityShader与材质的桥梁，语句块中的属性会出现在材质面板。

格式如下：
`[Attribute]_Name ("Display Name",Type) = Default Value`

### 2.2.1 Attribute
属性标记，说白了就是Unity内置的几个属性标记关键字，用于对当前这条属性进行一些特殊的处理，在下面会进行详细介绍。

> 此标记不是必选项，可以不添加，同时一条属性上也可以有多条属性标记。

### 2.2.2 _Name
属性的名称，也就是变量名。
在Shader的CG代码中就是通过这个名称来调用此属性内容的，在外部利用脚本调用时也是这个名称，所以一定要用英文。

**在名称前一定要加上下划线，否则会出现编绎错误！**

> 关于此变量名，有一点很重要！
> 如果此Shader有FallBack的话，一定要将此Shader中的变量名与FallBack中的变量名保持一致，否则会出现FallBack后原有的属性值获取不到的情况
> 切记！

### 2.2.3 Display Name
显示在材质面板上的名称，主要起到说明解释的作用，可用中文

> （正式项目中建议最好还是用英文）

### 2.2.4 Type
属性的类型，常用的有以下几种：

| 属性类型 | 含义 | 例子                     |
| -------- | ---- | ------------------------ |
| Int      | 整数 | _Int("我是Int", Int) = 1|
| Float | 浮点数(小数) |_Float("我是Float", Float) = 0.5|
| Range | 有范围的浮点数(使用滑块) |_Float("我是Float", Range( 0 , 1)) = 0.5|
| PowerSlider | 有曲度变化的Range(非线性滑块) |[PowerSlider(3)]_Float("我是Float", Range( 0 , 1)) = 0.5|
| IntRange | 向下取整(使用滑块) |[IntRange]_Float("我是Float", Range( 0 , 1)) = 1|
| Toggle | 一个checkbook，选中为1，不选为0 |[Toggle]_Float("我是Float", Range( 0 , 1)) = 1|
| Enum | 枚举(下拉列表) |[Enum(UnityEngine.Rendering.CullMode)]_Float("我是Float", Float) = 1|
| Color | RGBA颜色 |_Color("我是Color", Color) = (1,1,1,1)|
| HDR | 带亮度的颜色 |[HDR]_Color("Color", Color) = (1,1,0,1)|
| Vector | 四维向量 |_Vector("我是Vector", Vector) = (0,0,0,0)|
| 2D | 2D纹理 |_MainTex("我是2D纹理", 2D) = "white" {}|
| NoScaleOffset | 没有Tiling (贴图重复度)与Offset (贴图偏移值)的2D纹理 |[NoScaleOffset]_MainTex("我是2D纹理", 2D) = "white" {}|
| Normal | 法线贴图 |[Normal]_MainTex("我是2D纹理", 2D) = "white" {}|
| 3D | 3D纹理 |_MainTex("我是3D纹理", 3d) = "" {}|
| Cube | 立方体纹理 |_MainTex("我是Cube纹理", CUBE) = "" {}|

> 其他属性类型
>
> **[Header]**
>
> ```text
> 	Properties
> 	{
> 		[Header(This is Header )]_Int("我是Int", Int) = 1
> 		_Float("我是Float", Range( 0 , 1)) = 1
> 	}
> ```
>
> 在材质面板上进行标注，通常用作分类组别用，注意只支持英文、数字、空格以及下划线。
>
> **[HideInInspector]**
> 在材质面板中隐藏此条属性，在不希望暴露某条属性时可以快速将其隐藏。

### 2.2.5 Default Value

默认值。
当第一次指定此Shader时，或者在材质面板上执行Reset时，属性的值会自动恢复到默认值。

- Int、 Float、 Range
  其默认值就是一个单独的数字;

- Color和Vector
  默认值是用圆括号包围的一个四维向量;

- 2D、Cube、 3D这3种纹理类型
  默认值的定义稍微复杂，它们的默认值是通过一个字符串 后跟一个花括号来指定的。

  - 字符串要么是空的，要么是内置的纹理名称
    如“white"“black" “gray"或者“bump"。 

> 花括号的用处原本是用于指定一些纹理属性的。
> 例如在Unity 5.0以前的版本中，我们可以通过TexGenCubeReflect、TexGen CubeNormal等选项来控制固定管线的纹理坐标的生成。
> 但在Unity 5.0以后的版本中，这些选项被移除了，如果我们需要类似的功能，就需要自己在顶点着色器中编写计算相应纹理坐标的代码。

### 2.2.6 案例

下面的代码给出了一个展示所有属性类型的例子:

```
Properties
{
	//Numbers and Sliders
	_Int ("Int"， Int) = 2
	Float ("Float", Float) = 1.5
	_Range ("Range" ,Range(0.0, 5.0)) = 3.0
	
   // Colors and Vectors .
	Color ("Color", color) = (1,1,1,1)
	_Vector ("Vector", Vector) = (2, 3, 6, 1)
	
	// Textures
	2D ("2D"， 2D) =”" {}
	Cube ("Cube", Cube) = "white" {}
	_3D ("3D", 3D) = "black" {}
}
```

下图是该案例在属性面板中的显示：

![属性面板](attachments/notes/技术美术/UnityShader/UnityShader的结构/IMG-20250428024123406.jpg)

## 2.3 SubShaders-子着色器

每个Shader中都可以包含多个SubShader，不可以没有，必须至少有一个。

Shader的核心算法实现就是在SubShader中来实现的。

在加载Shader时，Unity将遍历所有SubShader列表，并最终选择用户机器支持的第一个。

作用：
我们都知道不同的硬件性能是不一样的，游戏内通常把机器配置分为高中低三种，假如我们做了一个效果很好的Shader，但只能在高配机上有较好的性能表现，中低端就显的太费性能，SubShader在这时就可以派上用场了，我们可以在这个Shader内做三个SubShader，分别对应于高中低不同的配置。

SubShaders语句块中包含的定义通常如下：

```
SubShader
{
	[Tags]//可选的
	[RenderSetup]//可选的
	Pass
	{
		...
	}
	//可有多个Pass
}
```

由此可见，SubShader语句块由以下三个部分组成

- Tags 标签

- RenderSetup状态

- Pass

### 2.3.1 Tags 标签

标签(Tags) 是一个键值对(Key/Value Pair),它的键和值都是字符串类型。
这些键值对是SubShader和渲染引擎之间的沟通桥梁。
它们用来告诉Unity的渲染引擎:我希望怎样以及何时渲染这个对象。

标签的结构如下:
`Tags {"TagNamo1"="Value1" "TagNamo2"="Value2"}`

![](attachments/notes/技术美术/UnityShader/UnityShader的结构/IMG-20250428024123453.png)

> 注意:
> 上述标签仅可以在SubShader中声明，而不可以在Pass块中声明。
> Pass块虽然也可以定义标签，但这些标签是不同于SubShader的标签类型。这是我们下面将要讲到的。

### 2.3.2 RenderSetup 状态

ShaderLab提供了一系列渲染状态的设置指令， 这些指令可以设置显卡的各种状态，例如是否开启混合/深度测试等。

下表给出了ShaderLab中常见的渲染状态设置选项。

| 状态名称 | 设置指令                                                     | 解释                                |
| -------- | ------------------------------------------------------------ | ----------------------------------- |
| Cull     | Cull Back \|Front \|Off                                      | 设置剔除模式:剔除背面/正面/关闭剔除 |
| ZTest    | ZTest Less Greater \|LEqual \|GEqual I Equal \|NotEqual \|Always | 设置深度测试时使用的函数            |
| ZWrite   | ZWrite On \|Off                                              | 开启/关闭深度写入                   |
| Blend    | Blend SrcFactor DstFactor                                    | 开启并设置混合模式                  |

当在SubShader块中设置了上述渲染状态时，将会应用到所有的Pass。
如果我们不想这样，可以在Pass语义块中单独进行上面的设置。

### 2.3.3 Pass语句块

#### 2.3.3.1 Pass的结构

Pass语句块的格式如下

```
Pass
{
	[Name]
	[Tags]
	[RenderSetup]
	
	//code
	CGPROGRAM
	...
	ENDCG
}
```

- [Name]
  规定该Pass的名称，如`Name "MyPassName"`
  通过名称可以使用UsePass直接调用其它UnityShader中的Pass，如：`UsePase "MyShader/MYPASSNAME"`

  > 使用UsePage指令时必须使用大写形式的名字

- [Tags]标签

  用于告诉渲染引擎如何渲染物体
  暂略，没看懂

- [RenderSetup] 状态
  与SubShader中的相同
  
- CGPROGRAM-ENDCG
  CG代码段

#### 2.3.3.2 Pass的分类

- Pass 
  普通的Pass
- UsePass 
  复用其它UnityShader中的Pass
- GrabPass 
  抓取屏幕，将结果存在一张纹理中以便后续的Pass处理

## 2.4 FallBack指令

当我们写的Shader在一些机器上不支持时（最终显示成粉红色），只要添加了FallBack，并在双引号内写上了其它Shader的有效路径名称，那么在碰到不支持的硬件时这个Shader就会自动切换成FallBack内的Shader。

如果FallBack内的Shader也不支持呢，那就继续从FallBack内的Shader中再找FallBack......

```
FallBack "name"
//或者
FallBack Off//关闭fallback功能
```

> FallBack会影响阴影的投射
> 在渲染阴影纹理时，Unity 会在每个Unity Shader中寻找一个阴影投射的Pass。
> 通常情况下，我们不需要自己专门实现一个Pass。
> 这是因为Fallback使用的内置Shader中包含了这样一个通用的Pass。
> 因此，为每个Unity Shader正确设置Fallback是非常重要的。

## 2.5 CustomEditor-自定义面板编辑器

自定义界面，也就是说我们可以通过这个功能来自由定义材质面板的显示结果，它可以改写Properties中定义的显示方式。
