---
title: Odin快速入门
author: MycroftCooper
created: 2025-04-25 16:07
lastModified: 2025-04-25 16:07
tags:
  - Unity
  - Odin
category: 程序/引擎/Unity
note status: 草稿
---
# 显示属性与字段

## 基础显示

字段：
public的字段会自动显示在监视器
其它权限的字段可以使用【ShowInInspector】标签来显示

属性：
使用【ShowInInspector】标签来显示属性，若属性只有get没有set，则为灰色不可编辑
可以添加【EnableGUI】使只有get的属性变亮，但是仍然不可编辑

案例：
```c#
public class EnableGUIExample : MonoBehaviour
{
    public bool Flag;
    
    [ShowInInspector]
    private int myPrivateInt;

    [ShowInInspector]
    public static bool StaticProperty { get; set; }
    
    [ShowInInspector]
    public int GUIDisabledProperty { get { return 20; } }

    [ShowInInspector, EnableGUI]
    public int GUIEnabledProperty { get { return 10; } }
}
```

若有字段或属性只想显示，不想更改，则可以使用【ReadOnly】使目标变灰无法更改
案例：

```c#
[ReadOnly]
public string MyString = "这将显示为文本";
```

> 注意：
> 请记住，ShowInInspector特性不会序列化任何内容; 这意味着您所做的任何更改都不会仅仅使用ShowInInspector属性进行保存。
>  如果需要序列化，需要配合SerializeField特性使用

## 范围控制

1. MaxValue，MinValue
   限制字段或属性的最大值和最小值
	
   ```csharp
    [MaxValue(18)]
	 public int grilAge;
	
	[MinValue(0)]
	public float studentScore;
	```

2. PropertyRange
   属性范围显示，跟Unity的Range一样，只是这个是对属性的，需要配合ShowInInspector显示出来

   ```csharp
   [ShowInInspector,PropertyRange(0,1)]
   public float Progress { get; set; }
   ```

3. Wrap
   值在指定范围内循环

   ```csharp
   [Wrap(0,10)]
   public int Score;
   ```

## 标题控制

可以使用【Title("标题字符串")】来显示标题
```c#
  [Title("我的标题")]
    public int C;
    public int D;
```

可以使用【Title("标题","副标题")】来显示双层标题
```c#
[Title("Static title", "Static subtitle")]
    public int E;
    public int F;
```

一些标题格式的控制：

- 加粗：
  默认加粗
  不加粗：bold: false
- 分割线
  默认有分割线
  不加分割线：horizontalLine: false
- 不同布局：
  - 右对齐：titleAlignment: TitleAlignments.Right
  - 居中：titleAlignment: TitleAlignments.Centered
  - 左对齐：titleAlignment: TitleAlignments.Left
  - 主左副右：titleAlignment: TitleAlignments.Split

可以使用$与@的语法糖控制动态标题(可以，但没必要)

案例：
```c#
public class TitleAttributeExample : MonoBehaviour
{
    [Title("Titles and Headers")]
    public string MyTitle = "My Dynamic Title";
    public string MySubtitle = "My Dynamic Subtitle";

    [Title("Static title")]
    public int C;
    public int D;

    [Title("Static title", "Static subtitle")]
    public int E;
    public int F;

    [Title("$MyTitle", "$MySubtitle")]
    public int G;
    public int H;

    [Title("Non bold title", "$MySubtitle", bold: false)]
    public int I;
    public int J;

    [Title("Non bold title", "With no line seperator", horizontalLine: false, bold: false)]
    public int K;
    public int L;

    [Title("$MyTitle", "$MySubtitle", TitleAlignments.Right)]
    public int M;
    public int N;

    [Title("$MyTitle", "$MySubtitle", TitleAlignments.Centered)]
    public int O;
    public int P;

    [Title("$MyTitle", "$MySubtitle", titleAlignment: TitleAlignments.Left)]
    public int Q;
    public int R;
    [Title("$MyTitle", "$MySubtitle", titleAlignment: TitleAlignments.Split)]
    public int S;
    public int T;

    [ShowInInspector]
    [Title("Title on a Property")]
    public int U { get; set; }

    [Title("Title on a Method")]
    [Button]
    public void DoNothing()
    { }

    [Title("@DateTime.Now.ToString(\"dd:MM:yyyy\")", "@DateTime.Now.ToString(\"HH:mm:ss\")")]
    public int Expresion;

    public string Combined { get { return this.MyTitle + " - " + this.MySubtitle; } }
}
```

## Label控制

### 隐藏Label

可以隐藏Label只显示值：

- 字段：
  【HideLabel】
  目标字段
- 属性
  【HideLabel】【ShowInInspector】
  目标属性

案例：

```c#
public class HideLabelExample : MonoBehaviour
{
    public string showLabel = "菜鸟海澜";

    [HideLabel]
    public string hideLabel = "隐藏标题";

    [ShowInInspector]
    public string ShowPropertyLabel { get; set; }

    [HideLabel][ShowInInspector]
    public string HidePropertyLabel { get; set; }
}
```

## 顺序控制

可以使用【PropertyOrder(序号)】控制属性或字段的显示顺序

> 注意：
> 序号是纯粹的比大小排序，-1会排在1前面

案例：
```c#
public class PropertyOrderExample : MonoBehaviour
{
    [PropertyOrder(1)]
    public int Second;

    [InfoBox("PropertyOrder用于更改inspector中属性的顺序")]
    [PropertyOrder(-1)]
    public int First;
}
```

## 间距控制

可以使用【PropertySpace】来控制属性之间的间距
与Unity自带的Space基本一样，区别在于：

- 可以应用于任何属性而不仅仅是字段
- 可以控制与前后字段的间距

案例：
```c#
public class PropertySpaceExample : MonoBehaviour
{
    [Space]
    public int unitySpace;

    [Space(5)]
    public int unitySpace1;
    [PropertySpace]
    public int OdinSpace2;

    [ShowInInspector, PropertySpace]
    public int Property { get; set; }

    // 还可以控制PropertySpace属性前后的间距。
    [PropertySpace(SpaceBefore = 30, SpaceAfter = 30)]
    public int BeforeAndAfter;
    [PropertySpace(SpaceBefore = 30, SpaceAfter = 30)]
    public int BeforeAndAfter1;
}
```

## 报错与警告

### 空引用检查器

当属性或字段的引用为空时，可以使用【Required】显示报错或警告信息

与Log相同有四种级别的报错：

- InfoMessageType.None(不显示)
- InfoMessageType.Info(不显示)
- InfoMessageType.Warning
- InfoMessageType.Error

可以使用$的语法糖输出动态的报错内容

案例：

```
public class RequiredExample : MonoBehaviour
{
    [Required]
    public GameObject MyGameObject;

    [Required("自定义错误消息.")]
    public Rigidbody MyRigidbody;

    public string DynamicMessage = "Dynamic Message";
    [Required("$DynamicMessage")]
    public GameObject GameObject_DynamicMessage;

    [Required("$ReturnStringFunction")]
    public GameObject GameObject_DynamicMessage1;
    public string ReturnStringFunction()
    {
        return "菜鸟海澜";
    }

    [Required("$DynamicMessage", InfoMessageType.None)]
    public GameObject GameObject_None;
    [Required("$DynamicMessage", InfoMessageType.Info)]
    public GameObject GameObject_Info;
    [Required("$DynamicMessage", InfoMessageType.Warning)]
    public GameObject GameObject_Warning;
    [Required("$DynamicMessage",InfoMessageType.Error)]
    public GameObject GameObject_Error;
}
```

### 自定义检查器

可以使用【ValidateInput】来自定义一个检查器

使用方法：
[ValidateInput("返回Bool的检查方法名", "报错内容")]
目标检测字段或属性

可以使用$语法糖控制动态报错提示

案例：
```c#
public class ValidateInputAttributeExample : MonoBehaviour
{
    [ValidateInput("MustBeNull", "这个字段应该为空。")]
    public MyScripty DefaultMessage;
    private bool MustBeNull(MyScripty scripty)
    {
        return scripty == null;
    }
    
    public string dynamicMessage = "这个物体不应该为空！";
    [ValidateInput("CheckGameObject", "$dynamicMessage", InfoMessageType.None)]
    public GameObject targetObj_None = null;
    private bool CheckGameObject(GameObject tempObj)
    {
        return tempObj != null;
    }
}
```

## 资源限定

### 限定来源

有两种资源来源：来自场景，来自资源文件：

- 【AssetsOnly】： 
  点击需要序列化的资源字段时，在出现的弹窗中只有Project中的资源文件，不会出现Hierachy（场景）的资源

- 【SceneObjectsOnly】：
  点击需要序列化的资源字段时，在出现的弹窗中只有Hierachy中的资源文件，不会出现Project中的资源

> 注意：
> 若预制体等资源在Scene或者Project中都含有，出现的弹窗中也都会含有对应的资源

案例：

```c#
    [SceneObjectsOnly]
    public List<GameObject> onlySceneObjectList;

    [SceneObjectsOnly]
    public GameObject someSceneObject;

    [SceneObjectsOnly]
    public MeshRenderer someMeshRendererInScene;

    [AssetsOnly]
    public List<GameObject> assetsOnlyPrefabList;

    [AssetsOnly]
    public GameObject ssetsOnlyPrefab;

    [AssetsOnly]
    public Material assetsOnlyMaterial;

    [AssetsOnly]
    public MeshRenderer someMeshRendererOnPrefab;
```

### 限定格式

可以使用【TypeFilter】对输入的value 进行自定义过滤，只显示需要的类型

案例：

```c#
using Sirenix.OdinInspector;
using Sirenix.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TypeFilterExample : MonoBehaviour
{
    [ShowInInspector]
    [TypeFilter("GetFilteredTypeList")]
    public BaseClass A, B;

    [ShowInInspector]
    [TypeFilter("GetFilteredTypeList")]
    public BaseClass[] Array = new BaseClass[3];

    public IEnumerable<Type> GetFilteredTypeList()
    {
        var q = typeof(BaseClass).Assembly.GetTypes()
            .Where(x => !x.IsAbstract)                                          // 不包括 BaseClass
            .Where(x => !x.IsGenericTypeDefinition)                             // 不包括 C1<>
            .Where(x => typeof(BaseClass).IsAssignableFrom(x));                 // 排除不从BaseClass继承的类 

        // Adds various C1<T> type variants.
        q = q.AppendWith(typeof(C1<>).MakeGenericType(typeof(GameObject))); //添加C1泛型为GameObject 的value
        q = q.AppendWith(typeof(C1<>).MakeGenericType(typeof(AnimationCurve)));//添加C1泛型为AnimationCurve 的value
        q = q.AppendWith(typeof(C1<>).MakeGenericType(typeof(List<float>)));//添加C1泛型为List<float> 的value

        return q;
    }

    public abstract class BaseClass
    {
        public int BaseField;
    }

    public class A1 : BaseClass { public int _A1; }
    public class A2 : A1 { public int _A2; }
    public class A3 : A2 { public int _A3; }
    public class B1 : BaseClass { public int _B1; }
    public class B2 : B1 { public int _B2; }
    public class B3 : B2 { public int _B3; }
    public class C1<T> : BaseClass { public T C; }
}
```

## 数值变更回调

- 无延迟回调(数值一变就立马回调)
  - 字段：
    [OnValueChanged ("回调函数名称")]
    目标字段
  - 属性：
    [ShowInInspector]
    [OnValueChanged("回调函数名称")]
    目标属性
- 延迟回调
  延迟赋值，在失去焦点后会触发值改变的方法，拖拽调整时不会触发
  - 字段：
    [Delayed]
    [OnValueChanged ("回调函数名称")]
    目标字段
  - [ShowInInspector, DelayedProperty]
    [OnValueChanged("回调函数名称")]
    目标属性

案例：

```c#
using Sirenix.OdinInspector;
using UnityEngine;

public class DelayedPropertyExample : MonoBehaviour
{

    [OnValueChanged("ValueChangeCallBack")]
    public int field;
 
    [ShowInInspector]
    [OnValueChanged("ValueChangeCallBack")]
    public string property { get; set; }


    // 延迟和延迟属性实际上是相同的
    [Delayed]
    [OnValueChanged ("ValueChangeCallBack")]
    public int delayedField;

    //但是，正如名称所示，DelayedProperty应用于属性。
    [ShowInInspector, DelayedProperty]
    [OnValueChanged("ValueChangeCallBack")]
    public string delayedProperty { get; set; }

    public void ValueChangeCallBack()
    {
        Debug.Log("数值有变化");
    }
}
```

# 下拉菜单

## 基本菜单

1. 使用[ValueDropdown("选项名称")]来显示一个下拉菜单
   选项名称所指的选项可以有两种：
   
   - 可以是一个数组(直接数值显示)
   
   - 可以是一个枚举器(Key-Value)
   
2. 使用SortDropdownItems = true可以让选项自动升序排序

3. 使用DropdownTitle = "下拉条标题"可以给菜单加个标题(不可选)

案例：

```c#
// 数值显示下拉菜单
[ValueDropdown("TextureSizes")]
public int SomeSize1;
private static int[] TextureSizes = new int[] { 32, 64, 128, 256, 512, 1024, 2048, 4096 };	

// Key-Value 显示下拉菜单
[ValueDropdown("SortList1", SortDropdownItems = true),DropdownTitle = "下拉条标题")]
public int SomeSize3;
private IEnumerable SortList1 = new ValueDropdownList<int>(){
	{ "Small", 256 },
	{ "Medium", 512 },
	{ "Large", 1024 },
	{ "A", 128 },
};
```

4. 设置下拉菜单的格式
   - 设置高度 
     DropdownHeight = 80
   - 设置宽度 
     DropdownWidth = 100
   - 使用平铺树形结构 
     FlattenTreeView = true
     默认为false，如果设置为true则禁用树形结构使用平铺模式
   - 内容是否默认全部展开
     ExpandAllMenuItems = false
   - 将下拉菜单在新的窗口中打开
     DisableListAddButtonBehaviour = true

5. 设置为多选菜单
   IsUniqueList = false

## 资源下拉菜单 Asset List

用于列表和数组以及Unity type的单个元素，并将默认列表Drop替换为具有指定过滤器的所有可能资产的列表。使用此选项可以过滤并在列表或数组中包含或排除资产，而无需导航项目窗口。

可用数据结构：

- 多选
  - 列表(List)
  - 数组(Array)
- 单选
  - Unity资源类型

1. 限定资源类型
   ```c#
   // 限定为2D贴图的资源类型
   [AssetList]
   public Texture2D SingleObject;
   ```

2. 多选

   ```c#
   [AssetList]
   public List<ScriptableObject> AssetList;
   ```

3. 限定筛选路径

   ```c#
   [AssetList(Path = "Plugins/Sirenix/")]
   public UnityEngine.Object Object;
   ```

4. 限定层级
   ```c#
   [AssetList(LayerNames = "MyLayerName")]
   public GameObject PrefabsWithLayerName;
   ```

5. 限定标签
   ```c#
    [AssetList(Tags = "TagA,TagB",Path = "/TutorialAsset")]
   public List<GameObject> GameObjectsWithTag;
   ```

6. 限定资源名称前缀
   ```c#
    [AssetList(AssetNamePrefix = "前缀")]
   public List<GameObject> PrefabsStartingWithPrefix;
   ```

7. 设置自动填充
   AutoPopulate = true
   设置为true则自动填充符合规则的资源,false为只显示不填充
   默认填充

8. 设置自定义过滤函数
   ```c#
   [AssetList(CustomFilterMethod = "HasRigidbodyComponent")]
   public List<GameObject> MyRigidbodyPrefabs;
   
   private bool HasRigidbodyComponent(GameObject obj){
   	return obj.GetComponent<Rigidbody>() != null;
   }
   ```

# 按钮

# 

# 更多个性化显示

## 彩色显示

使用【GUIColor】来改变任意UI的颜色
有三种写法：

- 固定颜色
  [GUIColor(0.3f, 0.8f, 0.8f, 1f)]
  分别是RGBA四通道的值

- 动态颜色

  - 使用返回Color的回调方法

    [GUIColor("一个返回Color的回调方法名称")]

  - 使用@语法糖
    [GUIColor("@Color.Lerp(Color.red, Color.green, Mathf.Sin((float)EditorApplication.timeSinceStartup))")]

案例：
```c#
public class GUIColorExample : MonoBehaviour
{
    [GUIColor(0.3f, 0.8f, 0.8f, 1f)]
    public int ColoredInt1;

    [GUIColor(0.3f, 0.8f, 0.8f, 1f)]
    public int ColoredInt2;

    [ButtonGroup]
    [GUIColor(0, 1, 0)]
    private void Apply()
    {
        Debug.Log("应用");
    }

    [ButtonGroup]
    [GUIColor(1, 0.6f, 0.4f)]
    private void Cancel()
    {
        Debug.Log("取消");
    }

    [GUIColor("GetButtonColor")]
    [Button(ButtonSizes.Gigantic)]
    private static void IAmFabulous()
    {
    }

    private static Color GetButtonColor()
    {
        Sirenix.Utilities.Editor.GUIHelper.RequestRepaint();
        return Color.HSVToRGB(Mathf.Cos((float)UnityEditor.EditorApplication.timeSinceStartup + 1f) * 0.225f + 0.325f, 1, 1);
    }


    // [GUIColor("@Color.Lerp(Color.red, Color.green, Mathf.Sin((float)EditorApplication.timeSinceStartup))")]
    // [GUIColor("CustomColor")]
    // 这两个写法相等
    [Button(ButtonSizes.Large)]
    [GUIColor("@Color.Lerp(Color.red, Color.green, Mathf.Sin((float)EditorApplication.timeSinceStartup))")]
    private static void Expressive_One()
    {
    }

    [Button(ButtonSizes.Large)]
    [GUIColor("CustomColor")]
    private static void Expressive_Two()
    {
    }

# if UNITY_EDITOR
    public Color CustomColor()
    {
        return Color.Lerp(Color.red, Color.green, Mathf.Sin((float)EditorApplication.timeSinceStartup));
    }
# endif
}
```

## 自定义绘制

【CustomValueDrawerAttribute】 特性，允许用户自定义一个绘制方法，字段将以自定的绘制方式展示在Inspector中，非常灵活。

案例：
```c#
using Sirenix.OdinInspector;
using UnityEditor;
using UnityEngine;

public class CustomValueDrawerExample : MonoBehaviour
{
    public float Max = 100, Min = 0;

    [CustomValueDrawer("MyStaticCustomDrawerStatic")]
    public float CustomDrawerStatic;
    private static float MyStaticCustomDrawerStatic(float value, GUIContent label)
    {
        return EditorGUILayout.Slider(label, value, 0f, 10f);
    }

    [CustomValueDrawer("MyStaticCustomDrawerInstance")]
    public float CustomDrawerInstance;

    private float MyStaticCustomDrawerInstance(float value, GUIContent label)
    {
        return EditorGUILayout.Slider(label, value, this.Min, this.Max);
    }

    [CustomValueDrawer("MyStaticCustomDrawerArray")]
    public float[] CustomDrawerArray = new float[] { 3f, 5f, 6f };


    private float MyStaticCustomDrawerArray(float value, GUIContent label)
    {
        return EditorGUILayout.Slider(value, this.Min, this.Max);
    }

    [CustomValueDrawer("HaveLabelNameFunction")]
    public string HaveLabelName;
    [CustomValueDrawer("NoLabelNameFunction")]
    public string NoLabelName;

    public string HaveLabelNameFunction(string tempName, GUIContent label)
    {
        return EditorGUILayout.TextField(tempName);
    }
    public string NoLabelNameFunction(string tempName, GUIContent label)
    {
        return EditorGUILayout.TextField(label,tempName);
    }
}
```

