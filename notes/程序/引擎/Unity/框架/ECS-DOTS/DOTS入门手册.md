# DOTS入门手册

# 1. 什么是 DOTS

DOTS （Data-Oriented Technology Stack）是 Unity 提出的一套 **数据导向的高性能开发框架**。目标是在保持 Unity 工作流易用性的基础上，显著提高性能，特别是在大规模实体（如成千上万个单位、粒子、敌人等）管理中。

DOTS 的核心思想是：“**面向数据编程（Data-Oriented Design）**，而不是传统的面向对象编程（OOP）。”

在传统 Unity 工作流中，使用 GameObject + MonoBehaviour 架构进行开发，虽然简单易用，但性能存在以下瓶颈：

- MonoBehaviour 生命周期杂乱，不易并行处理
- GameObject 结构复杂，无法在内存中连续排列
- 大量对象会导致 CPU 瓶颈，GC 压力大

而 DOTS 提供了一种能更好利用 CPU 缓存和多线程的解决方案。

**DOTS的优势**

- **性能优化：**
  传统的面向对象编程模型可能会导致性能瓶颈，尤其是在需要处理大量相似实体（如敌人、项目、粒子等）时。DOTS 通过将数据放在内存中以连续的方式存储并通过实体组件系统（ECS）进行处理，显著提高了内存访问效率和 CPU 利用率。

- **提高并行性：**
  DOTS 中的 Job System 允许开发者轻松地将任务并行化，这样可以充分利用现代CPU多核处理器的优势。通过将游戏逻辑拆分成多个独立的任务，能够同时在多个线程中执行，极大地提高了计算性能。

- **可扩展性：**
  随着游戏复杂性的增加，管理和处理大量实体的需求也随之提高。DOTS 的设计理念使其在处理大规模数据时更加高效，能够轻松支持成百上千的实体而不影响性能。

- **组件化设计：**
  ECS 的组件化模型通过将数据与逻辑分开，提供了更灵活和可重用的代码结构。开发者可以独立修改和组合不同的组件，简化维护和扩展的过程。

- **优化内存使用：**
  DOTS 鼓励以数据驱动的方式组织代码，更少依赖于复杂的对象引用。这样做有助于减少内存碎片，提高内存的整体利用效率。

**案例：**

传统MonoBehaviour在10,000+对象场景下帧率可能低于30FPS，DOTS可实现60FPS以上
硬件利用率提升：多核CPU并行处理效率提升300%+

# 2. 环境安装

**建议 Unity 版本：**2022.3 LTS 及以上

必要包（Unity Package Manager 添加）：

- com.unity.entities
- com.unity.mathematics
- com.unity.rendering.hybrid

# 3. DOTS的结构

DOTS 是一个技术栈，包含以下三个核心模块：

## 3.1 Entities（ECS）——核心架构

Entities 是 DOTS 的主体，实现了 ECS（Entity Component System）架构。

- **Entity**：
  纯数据实体，相当于一个“ID”，代表一个游戏对象。
- **Component（IComponentData）**：
  只存储数据的结构体，附加在 Entity 上，描述状态。
- **System**：
  业务逻辑的执行单元，批量处理拥有某种组件的所有实体。

📌 **特点：**

- 无继承，无行为，仅数据
- 系统操作一批数据，更适合并行处理
- 自动组织内存布局，提高缓存命中率

------

## 3.2 C# Job System（多线程）

Job System 是 Unity 提供的轻量级多线程框架。

- 支持并行执行任务，比如大量单位移动、AI计算等
- 避免手动使用线程，大幅减少同步开销
- 与 ECS 紧密集成，Systems 内部的操作自动转为 Job

📌 **常用接口：**

- `IJob`
- `IJobParallelFor`
- `IJobChunk`（DOTS 专用）

## 3.3 Burst Compiler（编译优化器）

Burst 是 Unity 自研的高性能编译器，可将IL/.NET字节码转换为高度优化的本地代码。它使用业界公认的 LLVM 编译器基础架构，为游戏创作者提供 C# 原生代码的性能。Burst 还暴露了 CPU 的内在特性，从而可以对性能关键代码进行微调。

- 优化 SIMD 指令（如 SSE、AVX）
- 极大提高 Job 性能（尤其在数值密集型任务中）

📌 **特点：**

- 和 Job System 配合使用最有效
- 易于开启，一行代码提升数倍性能

## 3.4 其他配套模块（可选但重要）

- **Unity.Mathematics**
  DOTS 优化版数学库，类似于 shader 的数学函数（`float3`, `quaternion`, `math.mul()` 等），用于替代传统 `Vector3`, `Quaternion`等

- **Hybrid Renderer**
  用于将 Entity 显示在场景中，支持高性能渲染
  基于 SRP（URP/HDRP），结合 GPU Instancing 实现批量渲染

- **Baking**
  在编辑器中将 GameObject “烘焙”成 Entity，构建工作流桥梁
- **SubScene**
  是 DOTS 的场景管理方式，支持大规模数据加载/卸载

# 4. ECS

## 4.1 理论基础

### 基本架构

**ECS 是一种“数据驱动”的游戏开发架构。**

它将游戏对象拆分为三个核心组成部分：

| 名称          | 作用                       | 类比传统 OOP      |
| ------------- | -------------------------- | ----------------- |
| **Entity**    | 标识一个对象的“ID”         | GameObject 的引用 |
| **Component** | 描述实体的“状态/数据”      | 类的字段（属性）  |
| **System**    | 定义作用于组件的“逻辑行为” | 类的方法（函数）  |

ECS 架构让你不再关心“哪个对象做了什么”，而是处理“一类对象如何变化”。

### 数据驱动,数据导向设计

ECS 的核心思想：**数据导向设计**

**与传统OOP思想的对比：**

**OOP（面向对象）方式:**

- 对象自己负责逻辑（封装、继承、多态）
- 强耦合，易于开发小型系统
- 但扩展困难、性能差，尤其在成千上万个对象时

```c#
class Enemy {
    public float health;
    public void TakeDamage(float amount) { ... }
}
```

**ECS（数据导向）方式:**

- 所有数据都是纯数据（Component）
- 所有行为都在独立的 System 中处理
- 可批量、并行、高性能处理数据

```c#
// Component
struct Health : IComponentData {
    public float Value;
}

// System
Entities.ForEach((ref Health health) => {
    health.Value -= 10f;
});
```

| 思维维度     | OOP 开发方式           | ECS 开发方式                            |
| ------------ | ---------------------- | --------------------------------------- |
| 数据结构     | 多个对象实例，含行为   | 扁平化组件，所有数据按结构体排列        |
| 行为分发     | 每个对象管理自己的行为 | 系统批量管理所有对象的行为              |
| 扩展方式     | 子类继承 + 多态        | 新增组件 + 系统组合                     |
| 性能优化方式 | 手动多线程、GC 优化等  | 默认高性能：Cache 优化 + 多线程 + 无 GC |

### 更适合性能优化

- 数据在内存中是连续的（Cache Friendly）

  - 相同组件的数据按块存放，提高 CPU 缓存命中率
  - 少了频繁的指针跳转和对象拆箱装箱

- 批量处理，天然适合并行（Job System）

  - 不是一个个执行对象的方法，而是“一锅端”处理所有符合条件的实体
  - 非常容易使用 Unity Job System 自动并行处理

-  完全解耦，可组合性强

  - 每个 System 只处理特定组件，不依赖对象具体类型

  - 极易扩展、维护和单元测试

## 4.2 Unity DOTS 中 ECS 的实际实现

我们主要介绍 DOTS 中几个关键的类型和模块：

1. **EntityManager & World**
2. **Component 类型**
3. **System 类型**
4. **Entities.ForEach 与 Job 调度**
5. **内置组件（Transform 系统）**
6. **SubScene 与 Baking（过渡工具）**

### EntityManager & World



**World**
`World` 是 DOTS 框架中的“**容器**”对象。
**管理着一组 System、一个 EntityManager 和所有实体数据。**

每个 Unity DOTS 项目都会有一个或多个“World”（默认是 `DefaultWorld`）。
你也可以手动创建多个 World，实现逻辑隔离，例如 DOTS Physics 运行一个独立 World 模拟物理

> World ≠ Scene。
> World 是一个 DOTS 世界（运行时上下文），用于承载一组 ECS 系统 + 实体数据。

**EntityManager**

- 用于创建/销毁 Entity，添加/移除组件，读写组件数据等。
- 类似 MonoBehaviour 的“控制中心”。

 示例：创建一个带 Position 和 Speed 的 Entity

```c#
EntityManager em = World.DefaultGameObjectInjectionWorld.EntityManager;

EntityArchetype archetype = em.CreateArchetype(
    typeof(Translation),
    typeof(MoveSpeed)
);

Entity entity = em.CreateEntity(archetype);

em.SetComponentData(entity, new Translation { Value = float3.zero });
em.SetComponentData(entity, new MoveSpeed { Value = 1f });
```

### 常用内置组件（Transform 系列）

Unity DOTS 有一套内建的空间变换组件，用于替代 Mono 的 Transform：

| 组件名            | 功能说明             |
| ----------------- | -------------------- |
| `Translation`     | 位置                 |
| `Rotation`        | 旋转                 |
| `LocalToWorld`    | 世界变换矩阵（只读） |
| `LocalTransform`  | 混合位移/旋转/缩放   |
| `NonUniformScale` | 各轴独立缩放         |

**为什么不直接用 Mono 的 Transform？**

1. **性能问题**：Transform 是引用类型，有复杂的层级、回调和数据同步，无法 Burst 编译，也不适合 Job 并行处理。
2. **线程不安全**：Transform 无法在 Job 中访问（主线程限定）
3. **不支持 Chunk 化存储**：破坏内存布局
4. **ECS 需要更简单、更扁平的数据结构**

因此，Unity 为 DOTS 重写了一套完全结构化的变换系统组件。

### SubScene 与 Baking

Unity DOTS 使用 SubScene 和 Baking 系统将传统 GameObject 工作流集成进 ECS。
（GameObject 向 DOTS 的过渡桥梁）

- **SubScene**
  是一个专门为 DOTS 服务的场景容器。
  进入 Play 模式时自动将内容“烘焙”为 Entity。
- **Baking（烘焙）**
  GameObject + MonoBehavior ➜ 转换为 Entity + ComponentData
  支持 Authoring 脚本（如 `IComponentData + Baker` 配套写法）

```c#
public class MoveSpeedAuthoring : MonoBehaviour{
    public float speed;
    class Baker : Baker<MoveSpeedAuthoring>{
        public override void Bake(MoveSpeedAuthoring authoring){
            AddComponent(new MoveSpeed { Value = authoring.speed });
        }
    }
}
```

## 4.3 ECS实践



# 第四章 · 进阶功能与机制拆解

| 小节编号 | 模块                               | 重点内容                                             |
| -------- | ---------------------------------- | ---------------------------------------------------- |
| 4.1      | EntityQuery 深入理解               | 查询原理、缓存、过滤器、动态组合                     |
| 4.2      | IBufferElementData                 | 动态数组组件，背包、路径点、技能列表等结构支持       |
| 4.3      | ISharedComponentData               | 如何做“跨 Chunk 分组”，渲染分区、行为分类            |
| 4.4      | Enableable Components              | 动态启/停逻辑组件，不再频繁 Add/Remove               |
| 4.5      | Chunk 原理与内存优化               | Chunk 的存储结构、最大尺寸、填充对齐、空间复用等机制 |
| 4.6      | 自定义 SystemGroup & 多 World 管理 | 拓展系统分组逻辑、运行多个 DOTS 世界                 |
| 4.7      | SubScene 流式加载机制              | SceneSystem 加载控制、地址引用、动态卸载             |
| 4.8      | ECS 中的事件系统                   | 如何设计 Event Component、实现全局事件/消息广播      |

# 第四章 · DOTS 进阶机制

## 4.8 📣 DOTS 中的事件系统设计（Event System）

在 ECS 架构中，我们常会遇到这样的需求：

- 敌人被击杀 → 触发掉落逻辑
- 角色释放技能 → 播放动画、扣蓝、进入冷却
- 玩家拾取道具 → 增加背包内容、播放音效

这些本质上都是「**一个 System 产生状态变更，另一个 System 做出响应**」，也就是：
**跨 System 通信 ➜ 事件派发 ➜ 响应处理**

但 ECS 的特点是「数据驱动 + 解耦」，所以不能像 OOP 那样直接调用函数。

于是就需要「事件系统」机制来代替函数调用，做：
**低耦合、延迟触发、跨帧传播** 的消息分发！

**Unity DOTS 并没有官方内建的事件机制！**但它为我们提供了很多**构建事件系统的基础能力**，比如：

| 能力                  | 用于实现                     |
| --------------------- | ---------------------------- |
| `IBufferElementData`  | 事件队列 / 多条事件数据      |
| `EntityCommandBuffer` | 延迟创建/销毁事件实体        |
| `DynamicBuffer<T>`    | 存放一帧/多帧事件            |
| `EnableableComponent` | 标记是否已消费               |
| `Entity`              | 事件也可以是一类“无寿命实体” |

**DOTS 中实现事件系统的主流方案（共三种）**

| 方案                              | 原理                                             | 特点               |
| --------------------------------- | ------------------------------------------------ | ------------------ |
| **事件组件 + 一帧生存**（最常用） | 创建一个 Entity，附加 `Event_XYZ` 组件，下帧销毁 | 简单、高性能、推荐 |
| **Buffer 储存事件**               | 把事件写入 `DynamicBuffer<T>` 中，一帧内消费     | 延迟、稳定、跨帧   |
| ✅**EventBus（纯数据广播）**       | 用静态容器或单例 Entity 收集/广播事件            | 不推荐，耦合高     |

------

## ✅ 推荐方案：**“短生命周期事件组件”**

这是目前**最接近 Unity 官方推荐的方式**：

### 示例：角色受伤事件

#### 定义事件组件（Tag 或含数据）

```
csharp复制编辑public struct DamageEvent : IComponentData
{
    public Entity Target;
    public float Amount;
}
```

#### 创建事件实体（例如在攻击系统中）

```
csharp复制编辑Entity e = ecb.CreateEntity();
ecb.AddComponent(e, new DamageEvent
{
    Target = enemy,
    Amount = 25f
});
```

#### 响应事件（在事件处理系统中）

```
csharp复制编辑public partial class DamageSystem : SystemBase
{
    protected override void OnUpdate()
    {
        Entities.ForEach((Entity e, in DamageEvent evt) =>
        {
            // 找到目标实体，扣血
            var health = GetComponent<Health>(evt.Target);
            health.Value -= evt.Amount;
            SetComponent(evt.Target, health);

            // 销毁事件实体（事件只处理一次）
            EntityManager.DestroyEntity(e);

        }).WithoutBurst().Run(); // 注意：有 EntityManager 操作不能用 Burst
    }
}
```

------

## ✅ 生命周期对照

| 阶段      | 内容                          |
| --------- | ----------------------------- |
| Frame N   | 创建 Event 实体，附加数据组件 |
| Frame N+1 | 被系统消费，执行逻辑后销毁    |
| Frame N+2 | 不再存在，自动清理 ✔️          |

> ✅ 一帧触发 ➜ 一帧响应 ➜ 一帧销毁，**无需标记状态位，无需额外调度机制！**

------

## ✅ 可选优化方式

| 技术                  | 用法                                |
| --------------------- | ----------------------------------- |
| `IBufferElementData`  | 一次创建一个 Entity，挂多个事件记录 |
| `EnableableComponent` | 标记是否已处理（避免误触）          |
| `SharedComponentData` | 分组批量处理特定类型事件            |
| `EntityCommandBuffer` | 延迟执行，避免结构变化              |

------

## 🧠 小贴士：如何处理「事件广播」？

比如一个事件要多个系统处理，怎么办？

你可以：

- 用 `IBufferElementData`，放在一个单例 Entity 上，多个系统消费不同类型事件
- 或者复制多个 Event 实体，各自被不同系统识别（可加 `TagComponent` 来分类）

------

## ✅ 最小事件模式模板

```
csharp复制编辑public struct MyEvent : IComponentData { public float Value; }

public partial class MyEventProducer : SystemBase {
    protected override void OnUpdate() {
        var ecb = new EntityCommandBuffer(Allocator.Temp);
        var e = ecb.CreateEntity();
        ecb.AddComponent(e, new MyEvent { Value = 123f });
        ecb.Playback(EntityManager);
        ecb.Dispose();
    }
}

public partial class MyEventConsumer : SystemBase {
    protected override void OnUpdate() {
        Entities.ForEach((Entity e, in MyEvent evt) => {
            // 处理逻辑...
            EntityManager.DestroyEntity(e);
        }).WithoutBurst().Run();
    }
}
```

------

## ✅ 小结表格

| 特性             | 值                                       |
| ---------------- | ---------------------------------------- |
| 是否 DOTS 原生？ | ❌ 需要自实现                             |
| 是否推荐？       | ✅ 是（事件实体是最佳实践）               |
| 是否可并发？     | ✅ 可通过 `IBufferElementData` + Job 实现 |
| 是否支持多播？   | ✅ 可通过多组件类型/分类 Entity 实现      |

###  第五章：并发与性能（Job + Burst）

- 5.1 C# Job System 原理与写法
- 5.2 IJob vs IJobChunk vs Entities.ForEach
- 5.3 Burst 编译器作用与限制
- 5.4 线程安全、结构变更与内存管理

## 5.1 C# Job System 原理

### ✅ 核心概念

Job 是一段**可并发调度的代码块**，它运行在 Unity Job Scheduler 管理的线程池中。

是 Unity DOTS 的“多线程计算框架”，将原本主线程逻辑拆分成可调度、可并行的小任务块。

### Job 特点：

- 多线程 （最多跑到 8~16 核）

- 零分配 （无 GC）

- 数据局部性 （SoA 内存结构 + 连续访问）

  它解决了：

  - 原本单线程 Update 吞吐瓶颈
  - 自定义多线程调度难维护的问题

 特点：

- 自动分线程调度
- 与 NativeContainer（如 NativeArray）完美协作
- 可与 Burst 编译器配合获得 SIMD 性能

------

### Job 类型一览：

| Job 接口             | 作用                    | DOTS 是否用到                  |
| -------------------- | ----------------------- | ------------------------------ |
| `IJob`               | 单任务                  | ✅ 有时用                       |
| `IJobParallelFor`    | 并行数组                | ✅ 可与 ComponentDataArray 配合 |
| `IJobChunk`          | Chunk 为单位遍历 Entity | ✅ DOTS 专用                    |
| `Entities.ForEach()` | Lambda Job 风格         | ✅ 最主流，推荐                 |

### 示例：IJobEntity

```c#
[BurstCompile]
public partial struct MoveJob : IJobEntity
{
    public float DeltaTime;

    public void Execute(ref LocalTransform transform, in MoveSpeed speed)
    {
        transform.Position += speed.Value * DeltaTime;
    }
}
```

在 System 中调度：

```c#
new MoveJob { DeltaTime = SystemAPI.Time.DeltaTime }.Schedule();
```

### DOTS 推荐写法（Lambda Job）

```c#
Entities
    .WithAll<Tag>()
    .ForEach((ref Translation pos, in MoveSpeed speed) =>
    {
        pos.Value.y += speed.Value * deltaTime;
    })
    .ScheduleParallel();
```

- 会自动转成 Job
- 支持 Burst 编译
- 支持并行处理 + 安全检查

------

## 💥 Job 中不能干的事（结构变更）

在 Job 中不允许做：

- 创建 / 销毁实体
- 添加 / 删除组件
- 非线程安全访问 EntityManager

✅ 正确做法：使用 EntityCommandBuffer 记录，帧末统一执行！

## 什么是 BlobAsset？

### ✅ 概念：

> **BlobAsset** 是 Unity DOTS 提供的一种**高效、只读、连续内存存储结构**，用于存储运行时不变的大量数据（如配置表、地图、骨骼数据等）。

类似于 C++ 中的：

- struct[]
- const array
- memory mapped file

------

### 📦 使用场景：

| 应用                   | 原因                       |
| ---------------------- | -------------------------- |
| 配置表（如敌人属性表） | 需要频繁读、但不会改       |
| 网格数据               | 结构复杂，但一经生成就只读 |
| 动画数据               | 用于 DOTS 的骨骼动画系统   |
| AI 行为树              | 整棵树只读，用于 Job 并行  |

------

### 📚 特点：

| 特性                          | 描述                                |
| ----------------------------- | ----------------------------------- |
| ✅ 高性能                      | 存在一段连续的原生内存中，缓存友好  |
| ✅ Job 可访问                  | 支持在多线程 Job 中访问（因为只读） |
| ✅ 可嵌套结构                  | 支持嵌套数组、指针、复杂结构体      |
| ✅ 必须通过 `BlobBuilder` 构建 | 不可手动创建，需要提前构造          |

------

### 🔨 构建方式：

```
csharp复制编辑BlobBuilder builder = new BlobBuilder(Allocator.Temp);
ref MyBlobData root = ref builder.ConstructRoot<MyBlobData>();
var array = builder.Allocate(ref root.MyArray, count);
...
BlobAssetReference<MyBlobData> blobAsset = builder.CreateBlobAssetReference<MyBlobData>(Allocator.Persistent);
builder.Dispose();
```

------

### 🔍 使用方式：

```
csharp复制编辑var config = myBlobAssetReference.Value;
int health = config.EnemyConfigArray[enemyId].Health;
```

因为是**只读结构**，可以在线程中、Job 中并发安全访问。

------

### 🛑 注意事项：

- BlobAsset 的内存不托管，需要手动 `.Dispose()` 释放
- 如果想要嵌入组件，通常配合 `BlobAssetReference<T>` 使用

**只读 + 不变的数据（Immutable）** = 最适合用 `BlobAsset`

### 🚨 为什么？

在 DOTS 多线程 Job 中：

| 数据来源                         | 是否线程安全？                     | 备注 |
| -------------------------------- | ---------------------------------- | ---- |
| 普通 class/struct                | ❌ 不安全，不能直接用               |      |
| MonoBehaviour / ScriptableObject | ❌ 完全不允许 Job 中访问            |      |
| Entity ComponentData             | ✅ 安全，但需要 ECS 世界管理        |      |
| `BlobAssetReference<T>`          | ✅ 完美：只读 + Job 安全 + 内存友好 |      |

------

## 📦 常见外部数据是否需要转为 BlobAsset

| 数据类型                       | 推荐转为 BlobAsset？ | 原因                                                     |
| ------------------------------ | -------------------- | -------------------------------------------------------- |
| 📘 配置表（如敌人属性）         | ✅ 强烈推荐           | 数据量大且只读，频繁访问，缓存友好                       |
| 🎮 预制体（Prefab Entity）      | ❌ 不需要             | Prefab 本身是 ECS 世界的“实体模板”，用 `Entity` 引用即可 |
| 🎵 音频/纹理/资源路径           | 🔶 视情况而定         | 可以只保存引用 ID/path，也可以用 BlobAsset 管理映射表    |
| 📊 地图数据（地形网格、高度图） | ✅ 推荐               | 数据大，结构复杂，纯读                                   |
| 🧠 行为树/AI逻辑表              | ✅ 推荐               | 树形结构，非常适合转为 `Blob` 结构嵌套                   |
| 🌀 曲线数据（动画、特效曲线）   | ✅ 推荐               | Job 中要访问动画值或轨迹，Blob 读取最安全                |

------

## 🚀 BlobAsset 的优势总结

| 特性               | 好处                                    |
| ------------------ | --------------------------------------- |
| ✅ Job 中可直接使用 | 支持多线程读取，不需要复制/调度         |
| ✅ 内存连续         | 非常适合大量访问（如 EnemyConfigArray） |
| ✅ 无 GC 压力       | 没有托管内存，生命周期完全可控          |
| ✅ 支持嵌套结构     | 数组、子对象、链表都可以做进去          |
| ✅ 可跨 Entity 使用 | 多个 Entity 可以共享一份配置数据        |

------

## ❗ 但注意：BlobAsset 的最佳场景是**“只读+共享+结构复杂”**

并不是所有数据都一定需要转为 BlobAsset，比如：

- 会频繁改变的状态（比如血量、位置） → ❌ 不适合 Blob
- 每个实体都唯一的数据 → ❌ 不适合共享
- 仅在主线程用的数据 → ❌ 直接 class/ScriptableObject 更方便

------

## ✅ 结论（你说的 + 我的补充）：

> 是的，在 DOTS 中，**凡是要在 Job 中跨帧共享访问的、只读的外部数据**，**都推荐转换为 BlobAsset**，这不仅保证了 Job 安全，还提升了缓存效率，是 DOTS 性能设计的重要一环。

## 5.3 Burst Compiler 是什么？

> Burst 是 Unity 的 LLVM 编译器后端，它会将你的 Job 编译为原生 SIMD 汇编，极致优化 CPU 性能。

### 特点：

| 特性      | 说明                              |
| --------- | --------------------------------- |
| LLVM 优化 | 向量化、循环展开、去分支          |
| 平台兼容  | 可编译成多平台汇编                |
| 性能      | 通常可获得 10-100x 加速           |
| 使用方法  | 在 Job 上加 `[BurstCompile]` 即可 |

------

### 注意事项：

- 只能编译 struct Job（不能编译 class）
- 不能捕获托管对象（如 `this`, `List<T>`）
- 不能用 Debug.Log / UnityEngine API
- 调试时可禁用 Burst 查看区别

------

## ✅ 5.4 Job + ECS 的配合方式

```
plaintext


复制编辑
System → Job → Entity 数据处理 → EntityCommandBuffer（变更记录）→ World更新
```

数据传递方式：

- 用 `Entities.ForEach()` 或 `IJobEntity`
- Job 输入参数为 `in`, `ref`, `out` 的组件字段
- Job 中不允许结构变更（需用 ECB）

------

## ✅ 5.5 多线程注意事项与安全性

| 问题                       | 解法                                                  |
| -------------------------- | ----------------------------------------------------- |
| 结构性变更不允许？         | ✅ 用 ECB 延迟执行                                     |
| NativeArray 是否线程安全？ | ✅ 读写时需标明只读 or 并行访问                        |
| Job 依赖怎么解决？         | ✅ 用 `.Schedule(dep)` 或 `.WithDisposeOnCompletion()` |
| 是否可以嵌套 Job？         | ❌ 不支持，Job 不能调度 Job                            |
| 是否能和 Burst 一起调试？  | ❌ 建议 Burst 开关切换（不可断点）                     |

## Burst 优化范围总览：

**Burst 只能优化被 Burst 编译器“接管”的方法**。
 ✅ **大多数 Job（如 IJob、IJobEntity）是默认受支持的**，而普通 ECS 查询代码（非 Job）**默认不受 Burst 优化**。

| 代码类型                                               | Burst 支持        | 说明                                      |
| ------------------------------------------------------ | ----------------- | ----------------------------------------- |
| ✅ `IJob`, `IJobEntity`, `IJobChunk`, `IJobParallelFor` | ✔️ 全面支持        | Burst 编译为原生代码                      |
| ✅ `Entities.ForEach().WithBurst()`                     | ✔️ 支持            | 自动生成 Job 并 Burst 编译                |
| ✅ 自定义 `[BurstCompile]` 的静态方法                   | ✔️ 支持            | 但方法中不能捕获托管对象                  |
| ⚠️ 普通 C# 方法（非 Job 中）                            | ❌ 不会优化        | 仍走 Mono/IL2CPP 解释执行路径             |
| ⚠️ SystemBase.OnUpdate 内部逻辑                         | ❌ 不会 Burst 编译 | 除非你显式调用一个被 Burst 支持的方法     |
| ⚠️ 非 Job 的 EntityQuery 查询                           | ❌ 不支持 Burst    | 属于主线程 ECS API 调用，不是数据并行计算 |

### 🧱 第六章：DOTS Physics 与 Unity.Physics 使用

- 6.1 RigidBody、Collider、Trigger 结构
- 6.2 物理世界（PhysicsWorld）与调度系统
- 6.3 碰撞事件监听与自定义处理（ICollisionEventsJob）
- 6.4 软体、约束、多形状支持

### 🖼 第七章：Hybrid Renderer（DOTS 渲染系统）

- 7.1 RenderMesh + RenderMeshArray
- 7.2 MaterialProperty、实例渲染与剔除优化
- 7.3 与 SubScene 资源打通
- 7.4 自定义 Shader + 绑定 Entity 数据

### 📁 第八章：BlobAsset、资源与数据管理

- 8.1 BlobAsset 架构（只读高性能数据结构）
- 8.2 实体引用资源、材质、文本
- 8.3 Addressables + SubScene + .entities 的联合打包
- 8.4 热更新方案与数据稳定性