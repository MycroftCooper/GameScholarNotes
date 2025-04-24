---
title: CSharp的序列化控制
author: MycroftCooper
created: 2025-04-24 18:30
lastModified: 2025-04-24 18:30
tags:
  - 程序
  - 语言
  - CSharp
category: 程序/语言/CSharp
note status: 终稿
---
# 1. 使用属性控制
## 1.1 [Serializable]

### 1.1.1 用法

**自动序列化**：
在类上添加 `[Serializable]` 属性后，.NET 序列化器（如 `BinaryFormatter`、`SoapFormatter` 等）可以自动序列化该类的实例。
这意味着序列化器会遍历类的所有字段，无需额外编码就能将其转换成一种可存储或传输的格式。

**字段处理**：
默认情况下，序列化器包含类中的所有公共和私有字段。
如果需要排除某些字段，可以使用 `[NonSerialized]` 属性。

**用途：**
适用于简单的数据存储类，不需要在序列化过程中执行复杂逻辑。

**优势：**

- **简洁**：无需编写额外的序列化代码。
- **易用性**：适用于大多数标准序列化场景。

**局限性：**

- **缺乏控制**：无法自定义序列化过程。
- **无法执行额外逻辑**：在序列化或反序列化过程中无法执行自定义代码。

**案例：**

```c#
[Serializable]
public class MyClass{
    public int SerializedField;
}
```

### 1.1.2 和Unity属性的区分

`.NET` 的 `[Serializable]` 属性和 `Unity` 的 `[Serializable]` 属性虽然同名，但它们在用途和工作方式上有所不同。

理解这两者的区别对于正确使用它们非常重要。

|              | .NET 的 `[Serializable]` 属性                                | Unity 的 `[Serializable]` 属性                               |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **用途**     | 用于标记一个类或结构可以被序列化。这是 .NET 中的二进制序列化机制的一部分，主要用于深度复制对象、持久化对象状态、在不同应用程序域之间传递对象等场景。 | 用于标记一个类或结构体，使其实例的字段在 Unity 编辑器的 Inspector 面板中可见。这对于游戏开发过程中调试和调整数据非常有用。 |
| **工作方式** | .NET 的序列化器（如 `BinaryFormatter`）可以自动序列化该类的实例，包括其所有的私有和公共字段。不需要额外编码来指定哪些字段被序列化。 | 公共字段和符合特定条件的私有字段（通常是用 `[SerializeField]` 标记的私有字段）会出现在 Inspector 面板中。这并不意味着它们会被自动序列化到磁盘；它只是使这些字段在编辑器中可编辑。 |
| **环境**     | 用于 .NET 标准环境，如在创建桌面应用程序、Web 应用程序等时。 | 专门用于 Unity 游戏开发环境。                                |

- 在 Unity 中：
  如果你想使一个自定义类的实例在 Inspector 中可编辑，就给这个类添加 `[Serializable]` 属性。
  记住，这并不是为了序列化到文件或进行网络传输，而是为了编辑器的可视化。
- 在 .NET 应用程序中：
  如果你需要对对象进行二进制序列化（例如，通过网络传输，或者保存到文件系统），就使用 .NET 的 `[Serializable]`。

了解这些区别可以帮助你在不同的开发环境中做出恰当的选择，以满足你的序列化需求。

## 1.2 [NonSerialized]

用于字段。
当一个类标记为 `[Serializable]`，但你想排除类中的某些字段不参与序列化时，可以在这些字段上使用 `[NonSerialized]` 属性。

**示例：**

```c#
[Serializable]
public class MyClass{
    public int SerializedField;
    [NonSerialized]
    public string NonSerializedField;
}
```

## 1.3 其它属性

这些属性用于标记在序列化过程的不同阶段调用的方法。

- `[OnSerializing]` 和 `[OnSerialized]` 用于序列化过程。
- `[OnDeserializing]` 和 `[OnDeserialized]` 用于反序列化过程。

这些方法提供了在序列化和反序列化过程中执行自定义逻辑的能力。

- `[OnSerializing]`
  **功能**：
  `[OnSerializing]` 属性用于标记在对象开始序列化之前调用的方法。
  这允许在对象的状态被转换为可序列化格式之前执行自定义逻辑。
  **使用场景**：
  如果你需要在序列化之前准备或调整对象的数据（例如，清理敏感信息，计算某些字段的值），则可以使用此属性。
- `[OnSerialized]`
  **功能**：
  `[OnSerialized]` 属性标记在对象序列化完成之后调用的方法。
  这可以在对象的状态已经被序列化后执行额外操作。
  **使用场景**：
  在序列化后记录日志、恢复序列化前的状态或执行清理操作时很有用。
- `[OnDeserializing]`
  **功能**：
  `[OnDeserializing]` 属性用于标记在对象开始反序列化之前调用的方法。
  这使得在对象的状态从序列化格式转换回对象之前执行自定义逻辑成为可能。
  **使用场景**：
  用于在对象的状态被重构之前进行初始化或设置默认值。
  例如，如果某些字段在较旧的版本中不存在，可以在此阶段为它们设置默认值。
-  `[OnDeserialized]`
  **功能**：
  `[OnDeserialized]` 属性标记在对象反序列化完成之后调用的方法。
  这允许在对象的状态已经从序列化格式重构回来之后执行额外的逻辑。
  **使用场景**：
  可以用于校验数据完整性、执行依赖于对象完整状态的初始化过程或其他后处理操作。

**示例：**

```c#
using System;
using System.Runtime.Serialization;

[Serializable]
public class MySerializableClass : ISerializable{
    public int Value;

    [OnSerializing]
    internal void OnSerializingMethod(StreamingContext context){
        // 在序列化之前执行的代码
    }

    [OnSerialized]
    internal void OnSerializedMethod(StreamingContext context){
        // 在序列化之后执行的代码
    }

    [OnDeserializing]
    internal void OnDeserializingMethod(StreamingContext context){
        // 在反序列化之前执行的代码
    }

    [OnDeserialized]
    internal void OnDeserializedMethod(StreamingContext context){
        // 在反序列化之后执行的代码
    }

    // 其他序列化相关的方法和构造函数...
}
```

这些属性提供了不同层次和不同场景下的序列化控制，使你能够根据具体需求选择合适的序列化机制和控制方式。

# 2. 使用 ISerializable 接口控制

## 2.1 原理

**自定义序列化**：
实现 `ISerializable` 接口意味着你需要提供序列化和反序列化逻辑。

**用途：**
适用于需要精细控制序列化过程的情况。
如序列化的对象包含复杂类型、需要基于条件序列化字段、或需要在序列化过程中执行特殊操作（如加密）。

**优势：**

- **灵活性**：可以精确控制哪些数据被序列化以及如何进行序列化。
- **额外操作**：可以在序列化和反序列化过程中执行自定义逻辑。

**局限性：**

- **复杂性**：实现更为复杂，需要更多的编码工作。
- **易错性**：由于需要手动控制序列化细节，因此更容易出错。

## 2.2 实现

**接口要求实现两部分：**`GetObjectData` 方法和一个特殊的构造函数。

- **`void GetObjectData(SerializationInfo info, StreamingContext context)` 方法**：
  在对象序列化时调用。此方法负责将对象的状态添加到 `SerializationInfo` 对象中。
  **参数：**
  - **SerializationInfo `info`**：
    一个 `SerializationInfo` 对象，用于存储序列化数据。
    你需要将对象的状态（通常是字段或属性的值）添加到这个对象中。
  - **StreamingContext `context`**：
    一个 `StreamingContext` 对象，包含序列化的源或目的地的附加上下文信息。
    这个参数通常在普通序列化场景中不会被使用，但在某些特殊情况下（例如跨 AppDomain 序列化时）可能会用到。
- **构造函数**：
  在对象反序列化时调用。此构造函数使用 `SerializationInfo` 中的数据来重构对象。
  **参数：**
  - **SerializationInfo `info`**：
    同上，你需要将对象的状态从中取出后赋给对象。
  - **StreamingContext `context`**：
    同上

**案例：**

```c#
[Serializable]
public class MyClass : ISerializable{
    public int Property1 { get; set; }
    public string Property2 { get; set; }

    // 序列化方法
    public void GetObjectData(SerializationInfo info, StreamingContext context){
        info.AddValue("Property1", Property1);
        info.AddValue("Property2", Property2);
    }

    // 反序列化构造函数
    protected MyClass(SerializationInfo info, StreamingContext context){
        Property1 = info.GetInt32("Property1");
        Property2 = info.GetString("Property2");
    }
}
```

## 2.3 `SerializationInfo` 类

`SerializationInfo` 类是 .NET 框架中处理对象序列化的一个关键组件。
在 .NET 中是自定义序列化和反序列化过程的核心。
它提供了一种灵活的方式来存储和检索对象的状态，并且是在实现 `ISerializable` 接口时处理对象序列化的标准机制。
通过使用 `SerializationInfo`，开发者可以精确控制对象的序列化表示，以及如何从序列化格式中重建对象的状态。

**作用：**
`SerializationInfo` 类存储所需的数据和上下文，以便序列化和反序列化对象。
它主要用于自定义序列化过程，即当一个类实现 `ISerializable` 接口时，`SerializationInfo` 用于存储和检索对象的状态（字段、属性等）。

**原理：**

- **数据存储**：
  `SerializationInfo` 包含键值对的集合，其中键是数据成员的名称，值是数据成员的值。这个集合用于在序列化过程中保存对象的状态，并在反序列化过程中重建对象。
- **类型安全**：
  `SerializationInfo` 提供了一系列方法，用于以类型安全的方式添加和检索各种类型的数据。

**主要方法：**

- `AddValue(string name, object value)`：
  将名字和值的对添加到 `SerializationInfo` 存储中。
- `GetValue(string name, Type type)`：
  从 `SerializationInfo` 中检索指定类型的值。
- 还有一系列的 `Get` 和 `Add` 方法，针对不同的数据类型
  如 `GetInt32`, `GetBoolean`, `GetString`, `AddInt32`, `AddBoolean`, `AddString` 等。

**适用场景：**

- **自定义序列化**：
  当需要控制类的序列化和反序列化过程时。这通常在处理复杂对象（如含有不可序列化成员的对象）或需要在序列化过程中执行特定操作的情况下发生。
- **跨应用程序域通信**：
  在不同应用程序域之间传递对象时，可通过实现 `ISerializable` 接口和使用 `SerializationInfo` 来确保对象的正确序列化和反序列化。

# 3. 结合使用`[Serializable]` 和 `ISerializable`

在某些情况下，你可能会同时使用 `[Serializable]` 属性和实现 `ISerializable` 接口。这样做的理由通常是，你希望利用默认序列化行为，但对某些部分需要自定义处理。

**比如：**
考虑一个包含敏感数据（如密码）的类，你可能不希望将密码字段直接序列化，而是需要在序列化时对其进行加密。
在这种情况下，实现 `ISerializable` 接口就非常合适，因为它允许你控制序列化过程，确保敏感信息的安全。

# 4. 总结

- 使用 `[Serializable]` 属性是一种简单、自动的序列化方法，适合于不需要特殊序列化逻辑的普通场景。
- 实现 `ISerializable` 接口提供了序列化过程的完全控制，适合于需要定制序列化行为或执行额
