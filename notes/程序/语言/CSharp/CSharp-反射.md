---
title: CSharp-反射
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - CSharp
  - 程序
  - 语言
category: 程序/语言/CSharp
note status: 终稿
---


# 0. 基础概念

## 0.1 什么是反射

Reflection，中文翻译为反射。
这是.Net中获取运行时类型信息的方式。

> 官方定义：
> 审查元数据并收集关于它的类型信息的能力。
> 元数据（编译以后的最基本数据单元）
> 就是一大堆的表，当编译程序集或者模块时，编译器会创建一个类定义表，一个字段定义表，和一个方法定义表等。

.Net的应用程序的结构由以下几个部分组成：

- 程序集(Assembly)

- 模块(Module)

- 类型(class)

![](attachments/notes/程序/语言/CSharp/CSharp-反射/IMG-20250428105011112.png)

而反射的层次模型也类似上述结构：

- 程序集反射
- 类型反射
- 类型成员反射

![](attachments/notes/程序/语言/CSharp/CSharp-反射/IMG-20250428105011193.png)

而反射提供一种编程的方式，让程序员可以在程序运行期获得这几个组成部分的相关信息。

- Assembly类
  可以获得正在运行的装配件信息，也可以动态的加载装配件，以及在装配件中查找类型信息，并创建该类型的实例。

- Type类
  可以获得对象的类型信息，此信息包含对象的所有要素：方法、构造器、属性等等
  通过Type类可以得到这些要素的信息，并且调用。

- MethodInfo
  包含方法的信息，通过这个类可以得到方法的名称、参数、返回值等等
  并且可以调用。

诸如此类，还有FieldInfo、EventInfo等等，这些类都包含在System.Reflection命名空间下。

## 0.2 命名空间与装配件的关系

- 命名空间类似与Java的包，但又不完全等同
  因为Java的包必须按照目录结构来放置，命名空间则不需要。
- 装配件是.Net应用程序执行的最小单位，编译出来的.dll、.exe都是装配件。

装配件和命名空间的关系不是一一对应，也不互相包含
一个装配件里面可以有多个命名空间，一个命名空间也可以在多个装配件中存在。

例如：

装配件A：

```c#
namespace  N1
{
      public  class  AC1  {…}
      public  class  AC2  {…}
}
namespace  N2
{
      public  class  AC3  {…}
      public  class  AC4{…}
}
```

装配件B：

```c#
namespace  N1
{
      public  class  BC1  {…}
      public  class  BC2  {…}
}
namespace  N2
{
      public  class  BC3  {…}
      public  class  BC4{…}
}
```

这两个装配件中都有N1和N2两个命名空间，而且各声明了两个类，这样是完全可以的

然后我们在一个应用程序中引用装配件A
那么在这个应用程序中，我们能看到N1下面的类为AC1和AC2，N2下面的类为AC3和AC4。

接着我们去掉对A的引用，加上对B的引用
那么我们在这个应用程序下能看到的N1下面的类变成了BC1和BC2，N2下面也一样。

如果我们同时引用这两个装配件
那么N1下面我们就能看到四个类：AC1、AC2、BC1和BC2。

装配件是一个类型 "居住" 的地方，那么在一个程序中要使用一个类，就必须告诉编译器这个类住在哪儿，编译器才能找到它，也就是说必须引用该装配件。

那么如果在编写程序的时候，也许不确定这个类在哪里，仅仅只是知道它的名称，就不能使用了吗？
答案是可以，这就是反射了，就是在程序运行的时候提供该类型的地址，而去找到它。

## 0.3 使用反射的情景

举个例子来说明：
很多软件开发者喜欢在自己的软件中留下一些接口，其他人可以编写一些插件来扩充软件的功能。

比如我有一个媒体播放器，我希望以后可以很方便的扩展识别的格式，那么我声明一个接口：

```c#
public  interface  IMediaFormat
{
   string  Extension  {get;}
   Decoder  GetDecoder();
}
```

这个接口中包含一个Extension属性，这个属性返回支持的扩展名。
另一个方法返回一个解码器的对象（这里我假设了一个Decoder的类，这个类提供把文件流解码的功能，扩展插件可以派生之），通过解码器对象我就可以解释文件流。

那么我规定所有的解码插件都必须派生一个解码器，并且实现这个接口，在GetDecoder方法中返回解码器对象，并且将其类型的名称配置到我的配置文件里面。

这样的话，我就不需要在开发播放器的时侯知道将来扩展的格式的类型，只需要从配置文件中获取现在所有解码器的类型名称，而动态的创建媒体格式的对象，将其转换为IMediaFormat接口来使用。

这就是一个反射的典型应用。

# 1. 反射的用途

**反射的作用：**

- 它允许在运行时查看属性（attribute）信息。
- 它允许审查集合中的各种类型，以及实例化这些类型。
- 它允许延迟绑定的方法和属性（property）。
- 它允许在运行时创建新类型，然后使用这些类型执行一些任务。

- 可以使用反射动态地创建类型的实例，将类型绑定到现有对象，或从现有对象中获取类型
- 应用程序需要在运行时从某个特定的程序集中载入一个特定的类型，以便实现某个任务时可以用到反射。
- 反射主要应用于类库，这些类库需要知道一个类型的定义，以便提供更多的功能。

**应用要点：**

- 使用反射动态绑定需要牺牲 性能
- 有些元数据信息是不能通过反射获取的
- 某些反射类型是专门为那些clr 开发编译器的开发使用的
  所以你要意识到不是所有的反射类型都是适合每个人的。

# 2. 反射的使用

## 2.1 使用反射 获取程序集

该操作属于反射层级的第一层，程序集反射。

## 2.2 使用反射 获取类型

该操作属于反射层级的第二层，类型反射。

### 通过实例获取类型信息

这个时侯我仅仅是得到这个实例对象
得到的方式也许是一个object的引用，也许是一个接口的引用
但是我并不知道它的确切类型，我需要了解
那么就可以通过调用System.Object上声明的方法GetType来获取实例对象的类型对象。

比如在某个方法内，我需要判断传递进来的参数是否实现了某个接口，如果实现了，则调用该接口的一个方法：

- 判断是否是继承了某类

```c#
var className = "Text.TexeClass";
Type myType = Type.GetType(className);
if (myType != null)
{
    Console.WriteLine("确实继承Text.TexeClass类");
}
```

- 判断是否继承了某接口

```c#
public void Process(object processObj)
{
	Type t  =  processsObj.GetType();
	if(t.GetInterface(“ITest”)  !=null  )
        Console.WriteLine("确实实现了ITest接口");
}
```

### 通过类型名称字符串获取类型信息

 `Type t = Type.GetType(“System.String”);`

在本装配件中类型可以只写类型名称

> 注意
> 要查找一个类，必须指定它所在的装配件
> 或者在已经获得的Assembly实例上面调用GetType。

一个例外是 **mscorlib.dll**，这个装配件中声明的类型也可以省略装配件名称。
.Net装配件编译的时候，默认都引用了mscorlib.dll，除非在编译的时候明确指定不引用它

比如：

- **System.String** 是在 **mscorlib.dll** 中声明的
  `Type t = Type.GetType(“System.String”)`是正确的
- **System.Data.DataTable** 是在 **System.Data.dll** 中声明的
  `Type.GetType(“System.Data.DataTable”)`就只能得到空引用。
  `Type t = Type.GetType("System.Data.DataTable,System.Data,Version=1.0.3300.0, Culture=neutral, PublicKeyToken=b77a5c561934e089");`这样才可以

## 2.3 使用反射 动态创建对象

该操作属于反射层级的第二层，类型反射。

使用反射动态创建对象有两种方法：

- 使用 **Activator.CreateInstance**
- 使用 **Assembly.CreateInstance**

但实际上在底层都是使用 **Activator.CreateInstance** 来动态创建对象，所以只需要掌握一种即可，下面的内容都是 使用 **Activator.CreateInstance** 来动态创建对象

### 无参数构造

System.Activator提供了方法来根据类型动态创建对象

比如创建一个DataTable：

```c#
Type t = Type.GetType("System.Data.DataTable,System.Data,Version=1.0.3300.0,  Culture=neutral,  PublicKeyToken=b77a5c561934e089");
DataTable table = (DataTable)Activator.CreateInstance(t);
```

### 有参数构造

```c#
namespace  TestSpace  
{
    public  class  TestClass
    {
        private  string  _value;
        public  TestClass(string  value)  
        {
            _value=value;
      	}
  	}
}
Type t = Type.GetType(“TestSpace.TestClass”);
Object[] constructParms = new object[] {“hello”};  //构造器参数
TestClass obj = (TestClass)Activator.CreateInstance(t,constructParms);
```

把参数按照顺序放入一个Object数组中即可

## 2.4 使用反射 操作类成员

该操作属于反射层级的第三层，类型成员反射。

该操作有三种方法

1. 使用Type类的InvokeMember()方法
   [方法一案例](https://blog.csdn.net/zxcvb036/article/details/114693060)
2. 使用FieldInfo,MethodInfo...等类的Invoke方法
3. 通过使用委托对反射进行优化
4. 使用.NET 4.0出现了一个新的关键字：dynamic

综合考虑下来，代码精简度以及耗费时间，建议尽量使用dynamic关键字来处理反射。

下面主要讨论 方法2 与 方法4

### 2.4.1 方法2

```c#
namespace TestSpace
{
    public class TestClass  
    {
        private  string  _value;
        public TestClass(){}
        public TestClass(string value)
            => _value = value;
        
        public string Value  
        {
            set {_value=value;}
            get 
            {
   				if(_value==null)return  "NULL";
   				else return  _value;
   			}
        }
        public string GetValue(stringprefix)
        {
            if(_value==null) return  "NULL";
            else return  prefix+" : "+_value;
        }
    }
}
```

上面是一个简单的TestClass类，包含：

- 一个默认构造函数
- 一个有参数的构造函数
- 一个_value字段
- 一个Value属性
- 一个GetValue的方法

1. 获取程序集

   ```c#
   Assembly ass = Assembly.Load("TestDll");
   ```
   
2. 获取类型信息

   ```c#
   Type myType = ass.GetType("TestSpace.TestClass");
   ```

3. 根据类型创建对象

   ```c#
   object[] constuctParms = new object[]{"timmy"};
   object dObj = Activator.CreateInstance(myType,constuctParms);
   ```

4. 操作类成员

- 类字段
  使用 **FieldInfo 类** 访问修改类对象的字段
  [官方文档](https://docs.microsoft.com/zh-cn/dotnet/api/system.reflection.fieldinfo?view=net-5.0)

  ```c#
  // 获取对象指定字段
  FieldInfo mfi = myType.GetField("_value");
  // 获取字段值
  mfi.GetVaL();
  // 更改字段值
  mfi.SetVal(dObj,"ok");
  ```

- 类属性
  使用 **PropertyInfo 类** 访问修改类对象的属性
  [官方文档](https://docs.microsoft.com/zh-cn/dotnet/api/system.reflection.propertyinfo?view=net-5.0)

  ```c#
  PropertyInfo mpi = myType.GetProperty("Value",typeof(string));
  mpi.SetValue(dObj,"ok",null);
  PropertyInfo mpi2 = myType.GetProperty("Value");
  Console.WriteLine(mpi2.GetValue(dObj,null));
  ```

- 类方法
  使用 **MethodInfo 类** 调用类对象的方法
  [官方文档](https://docs.microsoft.com/zh-cn/dotnet/api/system.reflection.methodinfo?view=net-5.0)
  
  ```c#
  //获取方法的信息
  MethodInfo method = myType.GetMethod("GetValue");
  //调用方法的一些标志位，这里的含义是Public并且是实例方法，这也是默认的值
  BindingFlags flag = BindingFlags.Public | BindingFlags.Instance;
  //GetValue方法的参数
  object[] parameters = new object[]{"Hello"};
  //调用方法，用一个object接收返回值
  object returnValue = method.Invoke(dObj,flag,Type.DefaultBinder,parameters,null);
  ```

### 2.4.2 方法4 - 关键字dynamic

[官方文档](https://docs.microsoft.com/zh-cn/dotnet/csharp/programming-guide/types/using-type-dynamic)

[教程](https://www.cnblogs.com/gygtech/p/9915367.html)

> 性能较好，速度快

1. 获取程序集

   ```c#
   Assembly ass = Assembly.Load("TestDll");
   ```

2. 获取类型信息

   ```c#
   Type myType = ass.GetType("TestSpace.TestClass");
   ```

3. 根据类型创建对象

   ```c#
   object[] constuctParms = new object[]{"timmy"};
   dynamic dObj = Activator.CreateInstance(myType,constuctParms);
   ```

4. 操作类成员

   使用了 dynamic 后可以和普通对象一样通过.使用类对象成员

   ```c#
   dObj._value = "good";
   ```

## 2.6 动态创建委托

​    委托是C#中实现事件的基础，有时候不可避免的要动态的创建委托，实际上委托也是一种类型：System.Delegate，所有的委托都是从这个类派生的
​    System.Delegate提供了一些静态方法来动态创建一个委托，比如一个委托：

```c#
namespace TestSpace  
{
    delegate string TestDelegate(string value);
    public class TestClass  
    {
        public TestClass(){}
        public void GetValue(string value)
            => return value;
    }
}
```

使用示例：

```c#
TestClass obj = new TestClass();
//获取类型，实际上这里也可以直接用typeof来获取类型
Type t = Type.GetType(“TestSpace.TestClass”);
//创建代理，传入类型、创建代理的对象以及方法名称
TestDelegate method =(TestDelegate)Delegate.CreateDelegate(t,obj,”GetValue”);
String returnValue = method(“hello”);
```

# 3. 反射中主要用到的类

System.reflection命名空间包含的几个类，允许你反射（解析）这些元数据表的代码  

- **System.Reflection.Assembly** 
  使用Assembly定义和加载程序集
  加载在程序集清单中列出模块,以及从此程序集中查找类型并创建该类型的实例。
- **System.Reflection.MemberInfo**
- **System.Reflection.EventInfo**
  了解事件的名称、事件处理程序数据类型、自定义属性、声明类型和反射类型等,添加或移除事件处理程序
- **System.Reflection.FieldInfo**
  了解字段的名称、访问修饰符(如public或private)和实现详细信息(如static)等
  并获取或设置字段值。
- **System.Reflection.MethodBase**
- **System.Reflection.ConstructorInfo**
  使用ConstructorInfo了解构造函数的名称、参数、访问修饰符(如pulic 或private)和实现详细信息(如abstract或virtual)等。
- **System.Reflection.MethodInfo**
  了解方法的名称、返回类型、参数、访问修饰符(如pulic 或private)和实现详细信息(如abstract或virtual)等。
- **System.Reflection.PropertyInfo**
  了解属性的名称、数据类型、声明类型、反射类型和只读或可写状态等,获取或设置属性值
- **System.Type**
- **ParameterInfo**
  了解参数的名称、数据类型、是输入参数还是输出参数
  以及参数在方法签名中的位置等。
- **Module**
  了解包含模块的程序集以及模块中的类等
  还可以获取在模块上定义的所有全局方法或其他特定的非全局方法。

## 3.1 System.Type 类

[官方文档](https://docs.microsoft.com/zh-cn/dotnet/api/system.type?view=net-5.0#constructors)

通过这个类可以访问任何给定数据类型的信息。

System.Type 类对于反射起着核心的作用。
但它是一个抽象的基类,Type有与每种数据类型对应的派生类,我们使用这个派生类的对象的方法、字段、属性来查找有关该类型的所有信息。

### 获取Type的方法

获取给定类型的Type引用有3种常用方式:

- 使用 **typeof运算符**
  `Type t = typrof(string);`
  该字符串必须指定类型的完整名称（包括其命名空间）
- 使用对象 **GetType()方法**
  `string s; Type t = s.GetType();`
- 使用Type **静态方法GetType()**
  `Type t  = Type.GetType("System.String");`

### Type类的常用属性

| 属性名称    | 属性类型 | 含义                                 |
| ----------- | -------- | ------------------------------------ |
| Name        | string   | 数据类型名                           |
| FullName    | string   | 数据类型的完全限定名(包括命名空间名) |
| Namespace   | string   | 定义数据类型的命名空间名             |
| IsAbstract  | bool     | 指示该类型是否是抽象类型             |
| IsArray     | bool     | 指示该类型是否是数组                 |
| IsClass     | bool     | 指示该类型是否是类                   |
| IsEnum      | bool     | 指示该类型是否是枚举                 |
| IsInterface | bool     | 指示该类型是否是接口                 |
| IsPublic    | bool     | 指示该类型是否是公有的               |
| IsSealed    | bool     | 指示该类型是否是密封类               |
| IsValueType | bool     | 指示该类型是否是值类型               |

### Type类的方法

- `GetConstructor()`
  `GetConstructors()`
  返回ConstructorInfo类型,用于取得该类的构造函数的信息
- `GetEvent()`
  `GetEvents()`
  返回EventInfo类型,用于取得该类的事件的信息
- `GetField()`
  `GetFields()`
  返回FieldInfo类型,用于取得该类的字段(成员变量)的信息
- `GetInterface()`
  `GetInterfaces()`
  返回InterfaceInfo类型,用于取得该类实现的接口的信息
- `GetMember()`
  `GetMembers()`
  返回MemberInfo类型,用于取得该类的所有成员的信息
- `GetMethod()`
  `GetMethods()`
  返回MethodInfo类型,用于取得该类的方法的信息
- `GetProperty()`
  `GetProperties()`
  返回PropertyInfo类型,用于取得该类的属性的信息可以调用这些成员
  其方式是调用Type的InvokeMember()方法,或者调用MethodInfo, PropertyInfo和其他类的Invoke()方法。

## 3.2 System.Reflection.Assembly类

Assembly类可以获得程序集的信息,也可以动态的加载程序集,以及在程序集中查找类型信息,并创建该类型的实例。

使用Assembly类可以降低程序集之间的耦合,有利于软件结构的合理化。

### 获取Assembly对象的方法

- 通过程序集名称返回Assembly对象
  `Assembly ass = Assembly.Load("ClassLibrary831");`
  load方法有多个重载，还可以通过流的方式获取程序集

- 通过DLL文件名称返回Assembly对象
  `Assembly ass = Assembly.LoadFile("ClassLibrary831.dll");`
  LoadFile这个方法的参数是程序集的绝对路径，通过点击程序集shift+鼠标右键复制路径即可。
  在项目中，主要用来取相对路径，因为很多项目的程序集会被生成在一个文件夹里，此时取相对路径不容易出错。

- 通过Assembly获取程序集中类
  `Type t = ass.GetType("ClassLibrary831.NewClass");`

  > //参数必须是完全类名：命名空间+类名

- 通过Assembly获取程序集中所有的类
  `Type[] t = ass.GetTypes();`

# 4. 反射的性能

[反射性能测试](https://zhuanlan.zhihu.com/p/268547492)

使用反射来调用类型或者触发方法，或者访问一个字段或者属性时clr 需要做更多的工作(校验参数，检查权限等等)所以速度是非常慢的。

所以尽量不要使用反射进行编程。

对于打算编写一个动态构造类型（晚绑定）的应用程序，可以采取以下的几种方式进行代替：

- 通过类的继承关系。
  让该类型从一个编译时可知的基础类型派生出来，在运行时生成该类型的一个实例，将对其的引用放到其基础类型的一个变量中，然后调用该基础类型的虚方法。
- 通过接口实现。
  在运行时，构建该类型的一个实例，将对其的引用放到其接口类型的一个变量中，然后调用该接口定义的虚方法。
- 通过委托实现。
  让该类型实现一个方法，其名称和原型都与一个在编译时就已知的委托相符。
  在运行时先构造该类型的实例，然后在用该方法的对象及名称构造出该委托的实例，接着通过委托调用你想要的方法。
  这个方法相对与前面两个方法所作的工作要多一些，效率更低一些。

# 参考

https://docs.microsoft.com/zh-cn/dotnet/csharp/programming-guide/concepts/reflection

https://zhuanlan.zhihu.com/p/41282759

https://www.sohu.com/a/363591840_468635

https://www.cnblogs.com/vaevvaev/p/6995639.html

https://www.cnblogs.com/loveleaf/p/9923970.html
