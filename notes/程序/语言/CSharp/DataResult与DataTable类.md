---
title: Socket原理
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

DataTable和DataSet可以看做是数据容器，比如你查询数据库后得到一些结果，可以放到这种容器里。

那你可能要问：我不用这种容器，自己读到变量或数组里也一样可以存起来啊，为什么用容器？

原因是，这种容器的功能比较强大，除了可以存数据，还可以有更大用途。

举例：
在一个c/s结构的桌面数据库系统里，你可以把前面存放查询结果的容器里的数据显示到你客户端界面上，用户在界面上对数据进行添加、删除、修改，你可以把用户的操作更新到容器。
等用户操作完毕了，要求更新，然后你才把容器整个的数据变化更新到中心数据库。

> 这样做的好处是什么？
> 就是减少了数据库操作，客户端速度提高了，数据库压力减小了。

 DataSet可以比作一个内存中的数据库，DataTable是一个内存中的数据表，DataSet里可以存储多个DataTable。

# 2. DataTable

## 2.1 类成员

### 2.1.1 构造函数

| 函数名                                             | 含义                                            |
| -------------------------------------------------- | ----------------------------------------------- |
| DataTable()                                        | 不带参数初始化DataTable 类的新实例              |
| DataTable(string tableName)                        | 用指定的表名初始化DataTable 类的新实例          |
| DataTable(string tableName, string tableNamespace) | 用指定的表名和命名空间初始化DataTable类的新实例 |

### 2.1.2 常用属性

| 属性名          | 含义                                                         |
| --------------- | ------------------------------------------------------------ |
| CaseSensitive   | 指示表中的字符串比较是否区分大小写                           |
| ChildRelations  | 获取此DataTable 的子关系的集合                               |
| Columns         | 获取属于该表的列的集合                                       |
| Constraints     | 获取由该表维护的约束的集合                                   |
| DataSet         | 获取此表所属的DataSet                                        |
| DefaultView     | 获取可能包括筛选视图或游标位置的表的自定义视图               |
| HasErrors       | 获取一个值，该值指示该表所属的DataSet 的任何表的任何行中是否有错误 |
| MinimumCapacity | 获取或设置该表最初的起始大小。该表中行的最初起始大小。默认值为 50 |
| Rows            | 获取属于该表的行的集合                                       |
| TableName       | 获取或设置DataTable 的名称                                   |

### 2.1.3 常用方法

| 方法名                 | 含义                                                         |
| ---------------------- | ------------------------------------------------------------ |
| AcceptChanges()        | 提交自上次调用AcceptChanges() 以来对该表进行的所有更改       |
| BeginInit()            | 开始初始化在窗体上使用或由另一个组件使用的DataTable。初始化发生在运行时 |
| Clear()                | 清除所有数据的DataTable                                      |
| Clone()                | 克隆DataTable 的结构，包括所有DataTable 架构和约束           |
| EndInit()              | 结束在窗体上使用或由另一个组件使用的DataTable 的初始化。初始化发生在运行时 |
| ImportRow(DataRow row) | 将DataRow 复制到DataTable 中，保留任何属性设置以及初始值和当前值 |
| Merge(DataTable table) | 将指定的DataTable 与当前的DataTable 合并                     |
| NewRow()               | 创建与该表具有相同架构的新DataRow                            |

## 2.2 使用技巧

### 2.2.1 创建表
`DataTable dt = new DataTable("Table_AX"); `

### 2.2.2 添加列属性
方法1：
`dt.Columns.Add("column0", System.Type.GetType("System.String"));`
方法2：

```c#
DataColumn dc = new DataColumn("column1", System.Type.GetType("System.Boolean"));
dt.Columns.Add(dc); 
```

### 2.2.3 添加数据行
初始化行:

```c#
DataRow dr = dt.NewRow();
dr["column0"] = "AX";
dr["column1"] = true;
dt.Rows.Add(dr);
```

空行:

```c#
DataRow dr1 = dt.NewRow();
dt.Rows.Add(dr1);    
```

### 2.2.4 选择数据行
选择表中所有第0列属性为'AX'的数据行
` DataRow[] drss = dt.Select("column0 = 'AX'"); `

> 空属性时用**is null**
> 例：` DataRow[] drs = dt.Select("column1 is null");`

### 2.2.5 复制表(包括数据)

` DataTable dtNew = dt.Copy(); `

### 2.2.6 复制表(仅结构)

`DataTable dtOnlyScheme = dt.Clone(); `

### 2.2.7 数据行操作    

- 方法一

  ```c#
  DataRow drOperate = dt.Rows[0];
  drOperate["column0"] = "AXzhz";
  drOperate["column1"] = false;
  ```

- 方法二

  ```c#
  drOperate[0] = "AXzhz";
  drOperate[1] = false;
  ```

- 方法三

  ```c#
  dt.Rows[0]["column0"] = "AXzhz";
  dt.Rows[0]["column1"] = false;
  ```

- 方法四

  ```c#
  dt.Rows[0][0] = "AXzhz";
  dt.Rows[0][1] = false; 
  ```

- 遍历

  ```c#
  foreach (DataRow row in dt.Rows) 
  { 
    foreach (DataColumn column in dt.Columns) 
    { 
  	 Console.WriteLine(row[column]); 
    } 
  }
  ```

  row[column] 中的column是检索出来的表个列名。

  如果想把某列的值拼接字符串，那就去掉内层循环就行了：

  ```c#
  StringBuilder mailList = new StringBuilder(); 
  foreach (DataRow row in dt.Rows) 
  { 
     mailList.Append(row["Email"]); 
     mailList.Append(";"); 
  }
  ```

### 2.2.8 复制数据行到当前数据表

`dtOnlyScheme.Rows.Add(dt.Rows[0].ItemArray); `

### 2.2.9 转换为字符串

```c#
System.IO.StringWriter sw = new System.IO.StringWriter();
System.Xml.XmlTextWriter xw = new System.Xml.XmlTextWriter(sw);
dt.WriteXml(xw);
string s = sw.ToString();
```

### 2.2.10 筛选数据表

```c#
dt.DefaultView.RowFilter = "column1 <> true";
dt.DefaultView.RowFilter = "column1 = true";
```

### 2.2.11 行排序

```c#
dt.DefaultView.Sort = "ID ,Name ASC";
dt=dt.DefaultView.ToTable();   
```

### 2.2.12 绑定数据表
```c#
gvTestDataTable.DataSource = dt;
gvTestDataTable.DataBind();
```

> 绑定的其实是DefaultView

### 2.2.13 判断一个字符串是否为数据表的列名

`dtInfo.Columns.Contains("AX");`

### 2.2.14 序列化

```c#
DataTable convert to XML and XML convert to DataTable
     protected void Page_Load(object sender, EventArgs e)
     {
       DataTable dt_AX = new DataTable();
       //dt_AX.Columns.Add("Sex", typeof(System.Boolean));
       //DataRow dr = dt_AX.NewRow();
       //dr["Sex"] = true;
       //dt_AX.Rows.Add(dr);
       string xml=ConvertBetweenDataTableAndXML_AX(dt_AX);
       DataTable dt = ConvertBetweenDataTableAndXML_AX(xml);
     }
     public string ConvertBetweenDataTableAndXML_AX(DataTable dtNeedCoveret)
    {
       System.IO.TextWriter tw = new System.IO.StringWriter();
       //if TableName is empty, WriteXml() will throw Exception.         

dtNeedCoveret.TableName=dtNeedCoveret.TableName.Length==0?"Table_AX":dtNeedCoveret.TableName;
       dtNeedCoveret.WriteXml(tw);
       dtNeedCoveret.WriteXmlSchema(tw);
       return tw.ToString();
    }
     public DataTable ConvertBetweenDataTableAndXML_AX(string xml)
    {
       System.IO.TextReader trDataTable = new System.IO.StringReader(xml.Substring(0, xml.IndexOf("<?xml")));
       System.IO.TextReader trSchema = new System.IO.StringReader(xml.Substring(xml.IndexOf("<?xml")));
       DataTable dtReturn = new DataTable();
       dtReturn.ReadXmlSchema(trSchema);
       dtReturn.ReadXml(trDataTable);
       return dtReturn;
    }
 dt.Compute("sum(SaleNum)", "true") ; 
// 对列SaleNum 汇总支持所以sql 聚合函数 如：sum(),count(),avg()等等。。。  

linq

var productNames = from products in dt.AsEnumerable() select products.Field<string>("ProductName");
```
