---
title: CSharp-序列化
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


# 1. 简介

## 1.1 什么是序列化

序列化 (Serialization)是将对象的状态信息转换为可以存储或传输的形式的过程。
在序列化期间，对象将其当前状态写入到临时或持久性存储区。以后，可以通过从存储区中读取或反序列化对象的状态，重新创建该对象。

## 1.2 序列化的目的

1、方便对象长久存储

2、方便对象传输

3、使程序更具维护性

## 1.3 序列化操作

- 序列化
  将对象转换为字符串或二进制数据，以便存储或传输

- 反序列化
  将字符串或二进制数据还原成对象

- 无序列化
  标明对象的属性中哪些属性不需要序列化
  ![](attachments/notes/程序/语言/CSharp/CSharp-序列化/IMG-20250428105129509.png)

## 1.4 常用的序列化格式

- Binary(二进制)

  - protocol buffer

- XML

- JSON(最先进，最推荐)

  > [在线JSON格式化校验](https://www.bejson.com/)

性能指标：Binary>JSON>XML

# 2. Binary序列化

略，求求你，用json吧！

**protocol buffer**是Google的一种**独立和轻量级**的数据交换格式。以**二进制结构**进行存储。

# 3. XML序列化

略，求求你，用json吧！

**XML** 指可扩展标记语言（e**X**tensible **M**arkup **L**anguage）。是一种**通用和重量级**的数据交换格式。以**文本结构**存储。

格式很像HTML

# 4. JSON序列化

## 4.1 JSON简介

**[JSON](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/JSON)**(**[J](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/JavaScript)**[ava](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/JavaScript)**[S](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/JavaScript)**[cript](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/JavaScript) **O**bject **N**otation, JS 对象简谱) 是一种**通用和轻量级**的数据交换格式。以**文本结构**存储，它是完全独立于语言的。

### 4.1.1 支持的数据结构

Json支持下面两种数据结构：

- 键值对的集合--各种不同的编程语言，都支持这种数据结构；
- 有序的列表类型值的集合--这其中包含数组，集合，矢量，或者序列，等等。

### 4.1.2 表现形式

#### 4.1.2.1 对象

一个没有顺序的“键/值”,一个对象以花括号“{”开始，并以花括号"}"结束，在每一个“键”的后面，有一个冒号，并且使用逗号来分隔多个键值对。

例如：

```json
var user =  {``"name"``:``"Manas"``,``"gender"``:``"Male"``,``"birthday"``:``"1987-8-8"``}
```

#### 4.1.1.2 数组

设置值的顺序，一个数组以中括号"["开始,并以中括号"]"结束，并且所有的值使用逗号分隔

例如：

```json
var userlist = [{``"user"``:{``"name"``:``"Manas"``,``"gender"``:``"Male"``,``"birthday"``:``"1987-8-8"``}}, ``{``"user"``:{``"name"``:``"Mohapatra"``,``"Male"``:``"Female"``,``"birthday"``:``"1987-7-7"``}}]
```

#### 4.1.1.3 字符串

任意数量的Unicode字符，使用引号做标记，并使用反斜杠来分隔。

例如：

```json
var userlist = ``"{\"ID\":1,\"Name\":\"Manas\",\"Address\":\"India\"}"
```

## 4.2 C#使用JSON序列化

**序列化和反序列化有三种方式：**

1. 使用`JavaScriptSerializer`类

2. 使用`DataContractJsonSerializer`类

3. 使用JSON.NET类库

> 第三种最好，求求你直接看第三种吧

### 4.2.1 使用JavaScriptSerializer类

`DataContractJsonSerializer`类帮助我们序列化和反序列化Json，他在程序集` System.Runtime.Serialization.dll`下的`System.Runtime.Serialization.Json`命名空间里。

**首先，这里，我新建一个控制台的程序，新建一个类Student**

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;

namespace JsonSerializerAndDeSerializer
{
 [DataContract]
 public class Student
 {
  [DataMember]
  public int ID { get; set; }

  [DataMember]
  public string Name { get; set; }

  [DataMember]
  public int Age { get; set; }

  [DataMember]
  public string Sex { get; set; }
 }
}
```

**注意：**上面的Student实体中的契约 [DataMember]，[DataContract]，是使用`DataContractJsonSerializer`序列化和反序列化必须要加的，对于其他两种方式不必加，也可以的。

**我们程序的代码：**

要先引用程序集，在引入这个命名空间

```c#
//使用DataContractJsonSerializer方式需要引入的命名空间，在System.Runtime.Serialization.dll.中
using System.Runtime.Serialization.Json;

#region 1.DataContractJsonSerializer方式序列化和反序列化
   Student stu = new Student()
    {
     ID = 1,
     Name = "曹操",
     Sex = "男",
     Age = 1000
    };
   //序列化
   DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(Student));
   MemoryStream msObj = new MemoryStream();
   //将序列化之后的Json格式数据写入流中
   js.WriteObject(msObj, stu);
   msObj.Position = 0;
   //从0这个位置开始读取流中的数据
   StreamReader sr = new StreamReader(msObj, Encoding.UTF8);
   string json = sr.ReadToEnd();
   sr.Close();
   msObj.Close();
   Console.WriteLine(json);

   //反序列化
   string toDes = json;
   //string to = "{\"ID\":\"1\",\"Name\":\"曹操\",\"Sex\":\"男\",\"Age\":\"1230\"}";
   using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(toDes)))
   {
    DataContractJsonSerializer deseralizer = new DataContractJsonSerializer(typeof(Student));
    Student model = (Student)deseralizer.ReadObject(ms);// //反序列化ReadObject
    Console.WriteLine("ID=" + model.ID);
    Console.WriteLine("Name=" + model.Name);
    Console.WriteLine("Age=" + model.Age);
    Console.WriteLine("Sex=" + model.Sex);
   }
   Console.ReadKey(); 
   #endregion
```

运行之后结果是：

![](attachments/notes/程序/语言/CSharp/CSharp-序列化/IMG-20250428105129570.png)

### 4.2.2 使用JavaScriptJsonSerializer类

```c#

//使用JavaScriptSerializer方式需要引入的命名空间，这个在程序集System.Web.Extensions.dll.中
using System.Web.Script.Serialization;
#region 2.JavaScriptSerializer方式实现序列化和反序列化
   Student stu = new Student()
    {
     ID = 1,
     Name = "关羽",
     Age = 2000,
     Sex = "男"
    };

   JavaScriptSerializer js = new JavaScriptSerializer();
   string jsonData = js.Serialize(stu);//序列化
   Console.WriteLine(jsonData);


   ////反序列化方式一：
   string desJson = jsonData;
   //Student model = js.Deserialize<Student>(desJson);// //反序列化
   //string message = string.Format("ID={0},Name={1},Age={2},Sex={3}", model.ID, model.Name, model.Age, model.Sex);
   //Console.WriteLine(message);
   //Console.ReadKey(); 


   ////反序列化方式2
   dynamic modelDy = js.Deserialize<dynamic>(desJson); //反序列化
   string messageDy = string.Format("动态的反序列化,ID={0},Name={1},Age={2},Sex={3}",
    modelDy["ID"], modelDy["Name"], modelDy["Age"], modelDy["Sex"]);//这里要使用索引取值，不能使用对象.属性
   Console.WriteLine(messageDy);
   Console.ReadKey(); 
#endregion 
```

结果：

![](attachments/notes/程序/语言/CSharp/CSharp-序列化/IMG-20250428105129610.png)

### 4.2.3 使用JSON.NET类库(推荐)

首先在NuGet上下载Json.NET类库。

```c#
//使用Json.NET类库需要引入的命名空间
using Newtonsoft.Json;
#region 3.Json.NET序列化
   List<Student> lstStuModel = new List<Student>() 
   {
   
   new Student(){ID=1,Name="张飞",Age=250,Sex="男"},
   new Student(){ID=2,Name="潘金莲",Age=300,Sex="女"}
   };

   //Json.NET序列化
   string jsonData = JsonConvert.SerializeObject(lstStuModel);

   Console.WriteLine(jsonData);
   Console.ReadKey();


   //Json.NET反序列化
   string json = @"{ 'Name':'C#','Age':'3000','ID':'1','Sex':'女'}";
   Student descJsonStu = JsonConvert.DeserializeObject<Student>(json);//反序列化
   Console.WriteLine(string.Format("反序列化： ID={0},Name={1},Sex={2},Sex={3}", descJsonStu.ID, descJsonStu.Name, descJsonStu.Age, descJsonStu.Sex));
   Console.ReadKey(); 
   #endregion
```

运行结果：

![](attachments/notes/程序/语言/CSharp/CSharp-序列化/IMG-20250428105129639.png)
