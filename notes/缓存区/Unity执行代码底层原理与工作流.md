---
title: Unity资源处理
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# Unity 执行代码的底层原理与工作流

## **1. Unity 执行 C# 代码的整体流程**

Unity 主要使用 **C#** 作为编程语言，C# 代码的执行流程如下：

1. **C# 源代码** -> **编译成 IL（Intermediate Language，中间语言）**
2. IL 代码-> 由 Mono 或 IL2CPP 运行时处理：
   - **Mono（JIT 编译）**：
     直接在运行时编译 IL，并执行（适用于 Unity Editor、PC 平台）。
   - **IL2CPP（AOT 编译）**：
     先将 IL 代码转换为 C++，再编译成机器码（适用于 iOS、Android、主机端）。
3. 最终执行：
   - Mono：JIT 编译后执行。
   - IL2CPP：AOT 预编译后直接运行。

------

## **2. IL（Intermediate Language）**

IL（Intermediate Language，中间语言），也叫 **MSIL（Microsoft Intermediate Language）** 或 **CIL（Common Intermediate Language）**，是 **.NET 运行时（CLR）的中间字节码**。介于高级语言（如 C#）和底层机器码（CPU 指令）之间。IL 代码是 **基于栈的虚拟机指令**，看起来像汇编语言，但是 .NET 运行时可以理解的代码。

它不会直接运行，而是需要 Mono 或 IL2CPP 进一步处理。

**示例**

C# 代码：

```c#
public int Add(int a, int b){
    return a + b;
}
```

编译成 IL：

```
method public hidebysig instance int32 Add(int32 a, int32 b) cil managed{
    .maxstack 2
    ldarg.1
    ldarg.2
    add
    ret
}
```

## 3 JIT 与 AOT

JIT 和 AOT 是两种不同的 IL 代码编译方式：

### 3.1 JIT（Just-In-Time即时编译）

**JIT 编译** 是在**程序运行时**，动态将 IL 代码编译成机器码并执行。

- 优点：
  - 运行时可以动态生成代码（如反射、动态代理）。
  - 开发调试更灵活（无需重新编译整个项目）。
- 缺点：
  - 运行时有额外开销，影响启动速度和性能。
  - iOS 禁止 JIT（因为安全性问题）。

**Unity Mono（JIT）示例**

```c#
Assembly assembly = Assembly.Load(File.ReadAllBytes("hotfix.dll"));
Type type = assembly.GetType("HotfixClass");
object obj = Activator.CreateInstance(type);
```

✅ Mono 允许动态加载 DLL。

### 3.2 AOT（Ahead-Of-Time提前编译）

**AOT 编译** 是在**程序发布前**，**提前**将 IL 代码编译成机器码。

- 优点：
  - 运行时没有 JIT 编译的额外开销，**性能更高**。
  - **适用于 iOS/Android**（因为苹果不允许 JIT）。
- 缺点：
  - 不能动态加载新的 C# 代码（IL2CPP 默认不支持 `Assembly.Load()`）。
  - 反射受限，部分泛型代码可能丢失。

**Unity IL2CPP（AOT）示例**

```c#
// IL2CPP 默认不支持动态加载 DLL，以下代码会失败
Assembly assembly = Assembly.Load(File.ReadAllBytes("hotfix.dll")); // ❌ IL2CPP 下不可用
```

✅ **HybridCLR** 解决了 IL2CPP 无法动态加载 DLL 的问题。

## 4. Mono

Mono 是一个 **开源的 .NET 运行时（Runtime）**，它能够运行 C# 代码，并提供了完整的 **.NET 运行时环境**，包括：

- **C# 代码的 JIT（即时编译）**
- **垃圾回收（GC）**
- **反射（Reflection）**
- **跨平台支持（Windows/Linux/macOS/Android）**

Mono 最早是由 **Xamarin 公司** 开发的，目标是让 C# 可以运行在 Windows 之外的其他平台。后来 Unity 选择 Mono 作为其 C# 运行时，使得 Unity 可以使用 **C# 作为主要编程语言**。

Unity 逐渐弃用 Mono，转向 IL2CPP（C# 转 C++），因为：

- **性能更高**（Mono JIT 运行 IL，IL2CPP 直接运行 C++ 代码）。
- **代码更安全**（Mono 的 IL 代码容易被反编译，IL2CPP 更难破解）。
- **兼容 iOS**（iOS 不允许 JIT，所以必须用 AOT）。
- **跨平台支持更好**（IL2CPP 适用于 iOS、Android、PS、Xbox）。

> **Mono（运行时）和 MonoBehaviour（Unity 的脚本基类）没有直接关系**，但名字相似，容易混淆。

## 4. IL2CPP

### **4.1 编译流程**

当 Unity 使用 **IL2CPP** 作为 Scripting Backend 时，C# 代码的编译流程变为：

1. **C# 代码编译成 IL**（跟 Mono 一样）。
2. **IL2CPP 将 IL 转换为 C++ 代码**。
3. **C++ 代码编译成机器码**（特定平台的可执行文件）。

**示例**

- **原始 C# 代码**

```c#
public int Add(int a, int b){
    return a + b;
}
```

- **IL2CPP 转换后的 C++ 代码**

```c++
int32_t Add(int32_t a, int32_t b) {
    return a + b;
}
```

- **最终编译成二进制机器码**

```
ADD R0, R1, R2  // 假设是 ARM 指令
```

### 4.2 反射问题

因为 **IL2CPP** 采用的是完全 AOT 编译，同时会进行**代码裁剪（Code Stripping）**，这可能导致部分反射功能无法正常工作。

但并不是所有反射功能都会失效， **IL2CPP**运行时仍然会存储部分元数据，使得部分反射仍然有效。

#### 代码裁切

IL2CPP 在编译时会对代码进行优化，**移除未显式使用的类、方法和字段**，以减少二进制文件大小。
 这可能导致某些反射代码运行失败，因为 IL2CPP **没有为它们生成 C++ 代码**。

**代码裁剪导致的问题**

```c#
Type myType = Type.GetType("MyNamespace.MyClass"); 
MethodInfo method = myType.GetMethod("MyMethod");
method.Invoke(null, null);
```

**⚠️ 可能的问题：**

- **如果 `MyClass` 没有在其他地方直接使用，IL2CPP 可能不会生成它的 C++ 代码，导致 `Type.GetType("MyNamespace.MyClass")` 返回 `null`。**
- **如果 `MyMethod` 没有被直接调用，IL2CPP 可能不会编译它，导致 `method.Invoke()` 失败。**

#### 默认支持的反射

即使是 AOT（IL2CPP），在某些情况下，反射仍然可以使用：

- `Type.GetType("ClassName")` ✅ **（前提是类没有被裁剪）**
- `MethodInfo.Invoke()` ✅ **（方法必须在编译时存在）**
- `PropertyInfo.SetValue()` ✅**（前提是类没有被裁剪）**

**示例**

```c#
Type myType = Type.GetType("MyNamespace.MyClass");
MethodInfo method = myType.GetMethod("MyMethod");
method.Invoke(null, null);
```

**为什么这可以在 IL2CPP 下运行？** IL2CPP **并没有彻底禁用反射**，但它会受限：

1. **静态绑定的类、方法、字段** —— 仍然存在于最终编译出的 C++ 代码里，所以可以被反射。
2. **元数据仍然被保留** —— IL2CPP 仍然存储了一部分 Type 信息，因此 `Type.GetType("ClassName")` 依然可用。

#### 可能失效的反射

当你的代码涉及到 **动态创建类型（JIT 特性）** 时，AOT 下就可能会失败：

- 泛型实例化
  - 例子：`List<T> list = new List<T>();`
  - **如果 `T` 是 AOT 运行时没出现过的类型，IL2CPP 可能不会生成 C++ 代码**
- 动态创建新类型
  - 例子：`Activator.CreateInstance("SomeType")`
  - **如果 SomeType 代码在 AOT 过程中被裁剪（代码裁剪优化），则无法实例化**
- 动态代理
  - 例子：`ProxyGenerator.CreateInterfaceProxyWithTarget()`
  - **Unity AOT 下无法动态生成新类**

#### 如何处理反射

为了避免 AOT 反射失效，IL2CPP 采用了**元数据保留**机制：

- **自动生成绑定代码**（如果代码里用到了反射）

- **手动指定保留类型**（用 `link.xml` 或 `PreserveAttribute`）

  - link.xml 手动保留类型：

    ```xml
    <linker>
        <assembly fullname="Assembly-CSharp">
            <type fullname="MyNamespace.MyClass" preserve="all"/>
        </assembly>
    </linker>
    ```

  - 使用 `PreserveAttribute` 防止类型裁剪

    ```c#
    [Preserve]
    public class MyClass { }
    ```

### 4.3 HybridCLR 让 IL2CPP 也支持动态加载 DLL

HybridCLR **扩展了 IL2CPP，让 IL2CPP 也能 JIT 运行 IL 代码**，从而支持动态加载 C# 热更 DLL。

**HybridCLR 的核心技术**

- **IL2CPP + IL 解释器**：允许 IL2CPP 运行 IL 指令，而不仅仅是 C++ 代码。
- AOT + 解释执行模式：
  - **游戏主逻辑使用 IL2CPP（AOT 编译）**，保证性能。
  - **热更新代码用 HybridCLR 解释执行**，支持 `Assembly.Load()`。
- 手动注册泛型：
  - `HybridCLR.RuntimeApi.RegisterAOTGenericClass(typeof(List<int>));`

**HybridCLR 代码示例**

```c#
Assembly hotfixAssembly = Assembly.Load(File.ReadAllBytes("hotfix.dll"));
Type hotfixType = hotfixAssembly.GetType("HotfixNamespace.HotfixClass");
object instance = Activator.CreateInstance(hotfixType);
```

------

## 6. 总结

| **内容**         | **Mono（JIT）** | **IL2CPP（AOT）**    | **HybridCLR**    |
| ---------------- | --------------- | -------------------- | ---------------- |
| **运行方式**     | 运行时即时编译  | 预编译为 C++         | AOT + IL 解释    |
| **动态加载 DLL** | ✅ 支持          | ❌ 不支持             | ✅ 支持           |
| **反射**         | ✅ 完全支持      | ⚠️ 受限（需手动保留） | ✅ 完全支持       |
| **性能**         | 中等            | 高（接近原生 C++）   | 高（混合模式）   |
| **适用平台**     | PC/Android      | iOS/Android/主机     | iOS/Android/主机 |
