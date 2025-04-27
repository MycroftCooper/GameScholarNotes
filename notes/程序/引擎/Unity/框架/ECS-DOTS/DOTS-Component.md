# 1. Component概述

## 所有组件类型

| 接口                   | 说明                           | 典型用途                       | 优点               | 缺点                   | 是否支持并行 Job  |
| ---------------------- | ------------------------------ | ------------------------------ | ------------------ | ---------------------- | ----------------- |
| `IComponentData`       | 普通数据组件（最常用）         | 位置、速度、生命等             | 性能高，灵活       | 需要匹配类型组合来分组 | ✅                 |
| `IBufferElementData`   | 可变长的组件数组               | 背包、路径点、技能槽           | 表示列表数据       | 编程稍复杂             | ✅（注意特殊调度） |
| `ISharedComponentData` | 跨 Chunk 的共享组件            | 材质、动画类型等               | 分组渲染、分组计算 | 不能 Job、慢           | ❌（不能并行）     |
| `IEnableableComponent` | 可启用/禁用组件，而非添加/移除 | 动态切换逻辑分支（如 AI 启用） | 快速切换状态       | 占空间，不如移除彻底   | ✅                 |
| `IComponentData + Tag` | 空组件，用于标记（无字段）     | 标记“敌人”、“需要处理”等       |                    |                        | ✅                 |

## 组件必须是结构体

数据组件必须是结构体（`struct`），所有逻辑数据都应以组件形式附加在 Entity 上。

**为什么必须是 struct？**
ECS 强调数据性能：

- **struct 是值类型**
  - 可连续内存排列（cache-friendly）
  - 无堆分配
  - 无 GC。

- 引用类型（class）则会带来：
  - 内存碎片化
  - 堆分配、GC 压力
  - 破坏线程安全

所以 **所有 Component 必须是 struct，且必须是 blittable（可被 Burst 编译）**

## blittable struct

Blittable（可平移）struct 是一种可以直接在内存中“按字节复制”的结构体。

换句话说：
它在托管（C#）和非托管（原生）内存中的布局是一模一样的，**可以安全地直接拷贝到 Native 内存中、传递给 Job、Burst、Unsafe 代码使用**。

举个最简单的例子

```c#
public struct MyData{
    public float Value;
    public int ID;
}
```

这个结构体只包含基本值类型（float、int），它就是 **blittable 的**，可以直接传入 DOTS 的世界。

非 blittable 的例子：

```c#
public struct BadData{
    public string Name;             // ❌ 引用类型
    public UnityEngine.GameObject GO; // ❌ Unity 引用类型
}
```

这些类型在内存中不是“固定结构”，需要 GC 管理、包含引用头等信息，**不允许用于 DOTS 的组件、Buffer、Job 数据中**。

**为什么要 blittable？**

Unity DOTS 要实现：

- Job 并行（多线程）
- Burst 编译（C# → 高效 Native 汇编）
- NativeArray / Chunk 数据对齐
- Unsafe 操作（没有 GC）

这都要求你用的数据必须是 **“原生结构”**，能被**位拷贝（memcpy）**、**固定布局（layout sequential）**的类型 —— 也就是 **blittable struct**。

**Blittable 类型的判断规则（你只需记住下面这些）**

| 类型                                    | 是否 blittable | 备注                       |
| --------------------------------------- | -------------- | -------------------------- |
| `int`, `float`, `bool`, `byte`, `char`  | ✅ 是           | 基本值类型全部 OK          |
| `fixed` 数组（unsafe context）          | ✅ 是           | 如 `fixed int ids[4]`      |
| `Unity.Mathematics.float3`、`int2`      | ✅ 是           | DOTS 数学库完全 blittable  |
| 包含以上类型字段的 `struct`             | ✅ 是           | 只要不含引用，就 OK        |
| `string`                                | ❌ 否           | 所有引用类型都不行         |
| `object`, `GameObject`, `MonoBehaviour` | ❌ 否           | Unity 的管理对象都不行     |
| 包含上述引用类型字段的 struct           | ❌ 否           | 哪怕一个字段引用类型都不行 |

如何用代码确认一个类型是否 blittable？

 `Unity.Collections.LowLevel.Unsafe.UnsafeUtility.IsBlittable<T>()` 来验证：

```c#
Debug.Log(UnsafeUtility.IsBlittable<MyStruct>());  // 输出 true / false
```

> `[BurstCompile]` 也要求参数 blittable！
> 所以你 Job 中的数据结构如果不 blittable，**Burst 编译会报错**，或者你会被限制使用 Burst。

# 2. IComponentData

```c#
public struct MoveSpeed : IComponentData{
    public float Value;
}
```



 # 3. `IBufferElementData`

IBufferElementData是Unity DOTS 中的“动态数组组件”，它允许你给每个 Entity 挂上一个变长的数据列表。

类比：

```c#
// 普通组件（值类型）
public struct Health : IComponentData{
    public float Value;
}

// Buffer 组件（动态列表）
public struct InventoryItem : IBufferElementData{
    public int ItemID;
}
```

挂载后，每个 Entity 可以拥有一个 `DynamicBuffer<InventoryItem>`，像这样使用：

```c#
DynamicBuffer<InventoryItem> buffer = EntityManager.GetBuffer<InventoryItem>(entity);
buffer.Add(new InventoryItem { ItemID = 42 });
```

**和普通组件有什么区别？**

| 特性                   | 普通组件 `IComponentData` | Buffer 组件 `IBufferElementData` |
| ---------------------- | ------------------------- | -------------------------------- |
| 是否单个值             | ✅ 是                      | ❌ 不是（是数组）                 |
| 是否固定大小           | ✅ 固定结构体              | ❌ 可变长度                       |
| 是否按列存在 Chunk     | ✅ 是                      | ✅ 是，但每行指向独立 Buffer 区域 |
| 每个 Entity 都必须有吗 | ❌ 可选                    | ❌ 可选                           |
| 如何访问               | 通过 `ref`                | 通过 `DynamicBuffer<T>`          |

## 存储原理

每个拥有 Buffer 的 Entity 在其所属 Chunk 中：

- 会在 Chunk 中注册一列 `BufferHeader[]`
- 每一行对应一个 Entity 的 Buffer 实体
- 初始空间通常存在 Chunk 尾部（Inline），可用空间耗尽后自动溢出到 Heap

 Chunk 中实际结构如下：

```
Chunk
├── ComponentA[]
├── ComponentB[]
├── BufferHeader[InventoryItem]
│    ├── Entity 1: [ItemID 12, 44, 76]
│    ├── Entity 2: []
│    ├── Entity 3: [ItemID 99]
│    ...
```

**Buffer 是什么？**
Buffer 就是“Entity 私有的动态列表”，由 Chunk 提供首部管理，数据可能存在 Chunk 或 Heap。

结构类似于：

```
DynamicBuffer<T>
├── Pointer to actual memory
├── Length
├── Capacity
```

它不等于 `List<T>`，但可以类比理解为 C++ 的 small buffer optimization。

## 使用方法

**如何创建 Buffer？**

你必须给它标注 `[InternalBufferCapacity(x)]`：

```c#
[InternalBufferCapacity(8)]
public struct InventoryItem : IBufferElementData{
    public int ItemID;
}
```

这个容量定义了初始 Chunk Inline 存储空间大小，超过后会分配 heap。

**如何读写 Buffer？**

**在 System 中使用：**

```c#
Entities
  .ForEach((Entity entity, ref Translation t, DynamicBuffer<InventoryItem> buffer) =>{
    buffer.Add(new InventoryItem { ItemID = 10 });
    var id = buffer[0].ItemID;
}).Schedule();
```

**在非系统代码中使用：**

```c#
var buffer = EntityManager.GetBuffer<InventoryItem>(entity);
buffer.Clear();
buffer.Add(new InventoryItem { ItemID = 1 });
```

**⚠️ 注意事项**

| 项目                              | 建议                               |
| --------------------------------- | ---------------------------------- |
| 使用前必须 AddBuffer<T>()         | 否则你会取不到数据                 |
| 不支持复杂引用类型                | Buffer 元素必须是 blittable struct |
| 不建议频繁 Add/Remove 超出 Inline | 容易触发 heap 分配，影响性能       |
| 不支持 IJobParallelFor 等并行写入 | 多线程要小心！                     |

**💡 典型应用场景：**

| 用法               | 举例                                    |
| ------------------ | --------------------------------------- |
| 单位背包系统       | InventoryBuffer: List<itemId>           |
| 敌人路径系统       | WaypointBuffer: List<float3>            |
| 连招、技能播放轨迹 | ActionBuffer: List<Command>             |
| 网络同步历史帧     | InputHistoryBuffer: List<InputSnapshot> |

# 4. `ISharedComponentData`

Shared Component 是一种 **“值相同者共享、Chunk 分组依据”** 的特殊组件。
它不是用来做数据更新的，而是用来**分组实体，让它们被放进不同 Chunk 的依据之一**。
可以理解为是 ECS 的“逻辑标签 + Chunk 分组键”

**举个例子：**

```c#
public struct Team : ISharedComponentData{
    public int TeamID;
}
```

如果你给 1000 个实体分别赋值 TeamID = 0~9，那 ECS 会把它们放入 10 个不同的 Chunk：

```
[Chunk1] → TeamID = 0 → 100个 Entity
[Chunk2] → TeamID = 1 → 100个 Entity
...
[Chunk10] → TeamID = 9 → 100个 Entity
```

所以：**Shared Component 控制 Chunk 的“横向分区”，每个值唯一的 Shared Component 都会导致新的 Archetype + Chunk 产生**

**它和普通组件的区别是？**

| 特性                     | `IComponentData` | `ISharedComponentData`                   |
| ------------------------ | ---------------- | ---------------------------------------- |
| 是否内联存储在 Chunk 中  | ✅ 是             | ❌ 不是                                   |
| 所有 Entity 拥有独立副本 | ✅ 是             | ❌ 值相同实体共享一份                     |
| 是否可频繁修改           | ✅ 可以           | ❌ 修改会导致移动 Chunk                   |
| 是否参与 Job 中更新      | ✅ 支持           | ❌ 不支持（只能用于分组）                 |
| 可否用于查询过滤         | ✅ 可以           | ✅ 特别适合用来 WithSharedComponentFilter |

## 存储原理

它 **不存在于 Chunk 中的列中**，而是：

- 所有具有相同 SharedComponent 值的实体会被放进一个 Chunk
- SharedComponent 实例存储在 Unity 内部的“SharedComponentStore”
- Chunk 仅引用该 SharedComponent 的索引（类似指针）

这意味着：改变一个实体的 SharedComponent 值 → 它会被移动到另一个 Chunk！

**Chunk 结构图对比：**

```
普通组件：
Chunk
├── Component A[]
├── Component B[]

共享组件：
Chunk
├── Component A[]
├── SharedComponentIndex: 3  → 指向 TeamID = 3
```

> ⚠️ 但注意,SharedComponent 的值参与 Chunk 分组，但不会创建新的 Archetype

**案例：**
我们有组件如下：

- 普通组件 A、B：`IComponentData`
- 共享组件 C：`ISharedComponentData`

我们有 4 个实体：

| 实体 | 拥有组件 |
| ---- | -------- |
| a    | A, C(1)  |
| b    | A, C(2)  |
| c    | A, C(1)  |
| d    | B        |

要注意的是这两个概念的区别：

| 概念           | 定义                                                     | 举例                                            |
| -------------- | -------------------------------------------------------- | ----------------------------------------------- |
| **Archetype**  | 组件类型组合（只看有哪些类型，不管值）                   | `A + C`、`B`                                    |
| **Chunk 分组** | 相同 Archetype 下，**再按 SharedComponent 的值分 Chunk** | A+C(1)、A+C(2) 是同一个 Archetype，但不同 Chunk |

最终的Archetype与Chunk结构：

```
[Archetype A+C]
  ├─ Chunk 1 → SharedComponent C = 1 → 存 a, c
  ├─ Chunk 2 → SharedComponent C = 2 → 存 b

[Archetype B]
  └─ Chunk 3 → 没有 SharedComponent → 存 d
```

## 使用方法

你可以这样使用 Shared Component 来分组：

```c#
Entities
  .WithSharedComponentFilter(new Team { TeamID = 3 })
  .ForEach((ref Translation t) => {
      // 只处理 TeamID 为 3 的实体
  }).Schedule();
```

**⚠️注意事项：**

| 规则                                         | 说明                                             |
| -------------------------------------------- | ------------------------------------------------ |
| ❗ 不适合频繁修改                             | 修改会触发实体迁移（影响性能）                   |
| ✅ 非常适合做 “逻辑分区”、“渲染组” 等固定分类 |                                                  |
| ❌ 不支持 Job 中传入参数                      | 只能用于 `.WithSharedComponentFilter` 过滤后处理 |

**实际使用场景：**

| 场景                        | 用法                                          |
| --------------------------- | --------------------------------------------- |
| 渲染合批（Hybrid Renderer） | 每种材质用一个 SharedComponent（Material ID） |
| 地图区域划分                | 每个区域一个 ZoneID，方便系统按区块处理       |
| 阵营/阵营 AI 行为           | 不同 Team 用不同 SharedComponent              |
| 粒子系统/动画实例分类       | 同类型归入同一组，优化批处理                  |

# 5. Enableable Components

Enableable Component 就是 **可以在不移除组件的前提下，暂时让组件“失效”** 的 DOTS 新能力。

它是 Unity Entities 1.0 引入的机制，作用是：避免频繁 `AddComponent` / `RemoveComponent` 所带来的 Chunk 移动开销

举个例子：

```c#
public struct Movement : IComponentData, IEnableableComponent{
    public float Speed;
}
```

给实体添加 `Movement` 后，可以：

- 启用：系统能处理它
- 禁用：系统跳过处理，但组件仍在内存中！

**为什么不是所有组件都是 Enableable 的？**
因为：

- 普通组件没有启用位标记
- 启用/禁用本质上是一个额外的“位信息” → 所以你要显式声明 `IEnableableComponent` 接口

**它和 Add/Remove 有啥区别？**

| 项目                 | `Add/RemoveComponent`    | `EnableableComponent`  |
| -------------------- | ------------------------ | ---------------------- |
| 是否改变 Archetype？ | ✅ 会（导致 Chunk 移动）  | ❌ 不会                 |
| 是否清空数据？       | ✅ Remove 会删光          | ❌ Disable 只是临时失效 |
| 能否轻松开关？       | ❌ 有 GC & Chunk 管理开销 | ✅ 非常快，位级操作     |
| 能否保存原始状态？   | ❌ Remove 会丢数据        | ✅ Enable 后仍保留数据  |
| 是否适合频繁切换？   | ❌ 不适合                 | ✅ 非常适合             |

## 存储原理

Enableable Component 其实是：
在 Chunk 的元数据中为每个启用了 `IEnableableComponent` 的类型，**添加一组位掩码（BitField）**

每个 Chunk 会有一个类似：

```
BitField for Movement: 10101010101...
```

每个位表示对应实体是否启用。

查询系统可以用位操作过滤，无需移动 Chunk！

## 使用方法

你可以这样启用或禁用：

```c#
// 启用
EntityManager.SetComponentEnabled<Movement>(entity, true);

// 禁用
EntityManager.SetComponentEnabled<Movement>(entity, false);
```

如何只查询启用的组件？

```c#
Entities
  .WithAll<Movement>() // 只包含启用状态的 Movement
  .ForEach((Entity e, ref Movement m) => {
      // 这里的 m 是启用状态
  }).Schedule();
```

你也可以反过来找“禁用状态”的：

```c#
Entities
  .WithDisabled<Movement>() // 找到 Movement 被 Disable 的实体
```

**应用场景大合集 💡**

| 场景                        | 用法                                        |
| --------------------------- | ------------------------------------------- |
| 暂时关闭移动行为            | Disable `Movement` 组件                     |
| 动画状态切换（播放 / 停止） | Enable / Disable `AnimationPlayback`        |
| 冷却状态（技能失效时）      | Disable `AbilityReady`                      |
| 躲避 AI 检测（潜行时）      | Disable `Targetable`                        |
| 延迟激活物体                | 先加组件但设置为 Disable，等时机到了 Enable |

**⚠注意事项**

| 问题                              | 是否                                           |
| --------------------------------- | ---------------------------------------------- |
| 所有组件都能启用/禁用吗？         | ❌ 只有实现了 `IEnableableComponent` 的组件才行 |
| Enable 后能恢复原值吗？           | ✅ 完全保留之前的数据                           |
| Burst 支持吗？                    | ✅ 支持，位掩码判定非常高效                     |
| 支持多个 EnableableComponent 吗？ | ✅ 可以多个组件各自控制启用状态                 |
| 会影响 Chunk 分组吗？             | ❌ 不会，完全零拷贝、无迁移                     |

总结一句话：
EnableableComponent = “状态开关 + 无性能损耗 + 数据不丢失 + 零内存移动”的行为控制神器。

# 6. `IComponentData + Tag`空组件

在 DOTS 的 `IComponentData` 家族中，还有一类 **极为常用但容易被忽略的**类型，那就是：IComponentData + 空结构体（Tag 组件）。

Tag Component 是一种“无字段”的组件，用来给 Entity 打标签、做逻辑分类、条件查询。

它的结构通常长这样：

```c#
public struct SleepingTag : IComponentData { }
```

它没有任何字段，也不存储数据！就像你在 GameObject 里加个空的脚本，只是为了说：“这个对象被打上某种行为标签”

例如：

| 组件                   | 意义                       |
| ---------------------- | -------------------------- |
| `SleepingTag`          | 这个实体目前处于“休眠状态” |
| `DeadTag`              | 这个敌人已经死亡           |
| `MarkedForDestruction` | 系统稍后会清除这个实体     |

你不需要一个 bool 字段、也不需要枚举，只用这个“空组件”就可以完成状态判断。

**为什么不用 bool 字段来判断？**

| 项目                      | `bool IsSleeping`           | `SleepingTag`                    |
| ------------------------- | --------------------------- | -------------------------------- |
| 是否需要写值？            | ✅ 需要                      | ❌ 不需要                         |
| 是否修改组件数据？        | ✅ 会触发 ChangeVersion 更新 | ❌ 不会触发任何修改               |
| 是否改变内存布局？        | ✅ 有字段大小                | ❌ Chunk 内不占任何空间（空列）   |
| 是否更适合 ECS 查询逻辑？ | 一般                        | ✅ 完全匹配 ECS 的 Archetype 模型 |

Tag 组件只改变 Archetype（添加或移除时），**对 Chunk 内部没有任何存储成本。**

**Tag 组件的优缺点总结：**

**优点:**

- 零内存开销
  空 struct 不占 Chunk 空间
- 查询友好
  可以直接 `.WithAll<T>()`、`.WithNone<T>()`
- 不需要改结构体字段
  状态切换只需 Add/Remove 组件即可
- 易读性高
  比 bool 更语义化（如 `DeadTag`）

**缺点：**

- Add/Remove 仍然会改变 Archetype（可能引发 Chunk 移动）
- 不适合频繁切换
  比 EnableableComponent 开销略高（需看使用频率）

 **Tag Component，EnableableComponent，SharedComponent三者对比表**

| 特性 / 类型             | Tag Component     | SharedComponent   | Enableable Component |
| ----------------------- | ----------------- | ----------------- | -------------------- |
| 数据内容                | ❌ 无字段          | ✅ 有值            | ✅ 有字段             |
| 分组依据                | 是否有组件        | 组件值            | 启用/禁用标记        |
| 是否参与 Chunk 分组     | ✅ 是（Archetype） | ✅ 是（Chunk）     | ❌ 否（在位图中）     |
| 是否参与 Archetype 变化 | ✅ 是              | ❌ 否              | ❌ 否                 |
| 是否适合频繁切换        | ❌ 不建议          | ❌ 不建议          | ✅ 非常适合           |
| Job 可读写              | ✅ 完全支持        | ❌ 不支持 Job 读值 | ✅ 支持               |

**实战应用建议：**

| 场景                               | 推荐                                            |
| ---------------------------------- | ----------------------------------------------- |
| AI 行为切换：`Sleeping` / `Active` | ✅ 用 `EnableableComponent` 或 Tag               |
| 阵营分组：TeamID                   | ✅ 用 `SharedComponent`                          |
| 死亡状态：Dead                     | ✅ 用 `DeadTag`（Tag）或 `Enableable<Health>`    |
| 地图分区：RegionID                 | ✅ 用 `SharedComponent`                          |
| 技能冷却中                         | ✅ 用 Enableable（启/禁） 或 CooldownTag（轻量） |

**总结一下「用谁更合适？」**

| 需求类型                                | 推荐                                        |
| --------------------------------------- | ------------------------------------------- |
| ✔️ 你只需要一个“是否有”标签              | 用 Tag Component（更轻、更快）              |
| ✔️ 你需要分成多个组（TeamID / RegionID） | 用 SharedComponentData                      |
| ✔️ 你希望低频切换状态                    | 都可以                                      |
| ❗ 高频状态变化                          | 优先考虑 EnableableComponent（更高性能）    |
| ❌ 你需要在 Job 中读取值                 | Tag ✅，Shared ❌（Shared 不能用于 Job 参数） |

## 用法

你可以通过是否拥有该组件，来判断是否执行逻辑：

```c#
Entities
  .WithAll<SleepingTag>()  // 只处理被标记为 Sleeping 的实体
  .ForEach((Entity e, ref Translation t) => { ... })
  .Schedule();
```



