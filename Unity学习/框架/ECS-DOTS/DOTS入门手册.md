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

![image-20250328003213318](./image-20250328003213318.png)

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

### Component 类型（IComponentData）

数据组件必须是结构体（`struct`），实现 `IComponentData` 接口。

```c#
public struct MoveSpeed : IComponentData{
    public float Value;
}
```

所有逻辑数据都应以组件形式附加在 Entity 上。

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

还有其他组件接口：

| 接口                   | 说明                           | 典型用途                       | 优点               | 缺点                   | 是否支持并行 Job  |
| ---------------------- | ------------------------------ | ------------------------------ | ------------------ | ---------------------- | ----------------- |
| `IComponentData`       | 普通数据组件（最常用）         | 位置、速度、生命等             | 性能高，灵活       | 需要匹配类型组合来分组 | ✅                 |
| `IEnableableComponent` | 可启用/禁用组件，而非添加/移除 | 动态切换逻辑分支（如 AI 启用） | 快速切换状态       | 占空间，不如移除彻底   | ✅                 |
| `IBufferElementData`   | 可变长的组件数组               | 背包、路径点、技能槽           | 表示列表数据       | 编程稍复杂             | ✅（注意特殊调度） |
| `ISharedComponentData` | 跨 Chunk 的共享组件            | 材质、动画类型等               | 分组渲染、分组计算 | 不能 Job、慢           | ❌（不能并行）     |
| `IComponentData + Tag` | 空组件，用于标记（无字段）     | 标记“敌人”、“需要处理”等       |                    |                        | ✅                 |

### System 类型（业务逻辑执行者）

Unity 提供了三种 System 类型：

| 类型              | 简介                          | 优点                    | 缺点                   | 适用场景                 |
| ----------------- | ----------------------------- | ----------------------- | ---------------------- | ------------------------ |
| `SystemBase`      | 最常用的 DOTS 系统类型        | 语法简单，支持 Job 调度 | 有 GC 分配（捕获变量） | 推荐默认用               |
| `ISystem`         | 高性能、纯结构体系统（C# 8+） | 无 GC、性能极高         | 写法麻烦，调试难       | 极致性能需求（如模拟器） |
| `ComponentSystem` | 旧版系统，不推荐使用          | 早期支持 EntityQuery    | 不支持 Job，性能差     | 已弃用                   |

`SystemBase` 示例

```c#
public partial class MoveSystem : SystemBase{
    protected override void OnUpdate(){
        float deltaTime = SystemAPI.Time.DeltaTime;

        Entities
            .ForEach((ref Translation pos, in MoveSpeed speed) =>{
                pos.Value.y += speed.Value * deltaTime;
            }).ScheduleParallel();
    }
}
```

`Entities.ForEach(...)` 是编写 System 的常见方式。默认是“Job 化”的，Unity 会自动调度为多线程任务。使用 `.ScheduleParallel()` 可以并行处理实体。

```c#
Entities.ForEach((ref Translation pos, in MoveSpeed speed) => {
    pos.Value += speed.Value * deltaTime;
}).ScheduleParallel();
```

System 会自动查找所有拥有匹配组件的实体，并执行逻辑。
它基于Archetype和EntityQuery索引系统，查找的是符合条件的Chunk，而不是逐个判断Entity。

**具体流程是这样的：**

1. **系统**声明想要访问的组件组合（比如：`ref Translation`, `in MoveSpeed`）
2. Unity**自动生成一个EntityQuery**，它会匹配“拥有这些组件的Archetype”
3. Unity 的 ECS 框架中维护着一个`Archetype → Chunk[]`索引表（反查表）
4. **系统不用遍历所有Entity，而是直接拿到了这些条件符合的Chunk列表**
5. 然后再对Chunk内的集群执行批量处理（甚至不关心实体本身，只处理数据列）

#### **Chunk 与 Archetype**（内存优化核心）

在 Unity DOTS 中：

- **Archetype**：
  - 一组特定组件类型的组合，定义实体的“结构”
  - 每个 Entity 都属于某个 Archetype
  - 所有组件类型顺序固定（影响内存结构）
- **Chunk**：
  - 存储具有相同 Archetype 的实体数据的内存块
  - 是一块物理内存区域，最多容纳 16KB 的实体数据。
  - Chunk 中的组件数据按列式结构排列，**非常利于 CPU Cache 命中**

**举个例子：**
假设两个实体：

- A 拥有组件：Position、Velocity
- B 拥有组件：Position、Velocity、Health

它们拥有不同的 Archetype，因此会存储在不同的 Chunk 中。

**优点：**

- 查询速度极快（不用逐个遍历）
- CPU Cache 命中率高，内存访问快

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

## 4.1 EntityQuery 深入理解

### ✅ 章节目标

你已经知道了：

> `Entities.ForEach(...).Schedule()` 背后就是 Unity 为你构造了一个 **EntityQuery**

这一小节我们要搞清楚的是：

| 你将掌握的核心点             | 举例说明                               |
| ---------------------------- | -------------------------------------- |
| ✅ EntityQuery 是什么？       | 系统用来筛选哪些 Entity 参与运行的规则 |
| ✅ 它是怎么匹配实体的？       | 组件组合 + 可读/可写权限               |
| ✅ 如何手动构造 EntityQuery？ | 更复杂的条件控制                       |
| ✅ 查询缓存是如何优化性能的？ | Chunk 缓存、Query 复用机制             |
| ✅ Query 的动态组合方式       | 用布尔操作构建复杂 Query               |

------

## 1. 什么是 EntityQuery？

EntityQuery 是 Unity ECS 中的一个**查询条件描述器**，用于告诉系统：

> “我只想处理符合**这些组件组合**的实体”

你在 `Entities.ForEach(...)` 里声明的组件，其实就是在背后隐式创建了一个 EntityQuery。

```c#
Entities
  .ForEach((ref Translation t, in MoveSpeed s) => { ... })
```

等价于：

```c#
var query = GetEntityQuery(
    ComponentType.ReadWrite<Translation>(),
    ComponentType.ReadOnly<MoveSpeed>()
);
```

EntityQuery 是**缓存友好型的结构**：

- 每个 EntityQuery 创建后会**缓存匹配的 Archetype 集合**
- 查询时只需要访问缓存列表，无需重新计算
- 同一个查询条件只创建一次（可以存字段复用）
- 如果 Archetype 更新（如新实体被创建），系统会**自动更新 Query 缓存**

## 2. EntityQuery 是如何匹配实体的？

它的原理是：

> ✅ 通过组件组合（Archetype）来**快速反查**，找到所有拥有这些组件的 Chunk

而不是遍历所有 Entity 一个个判断。

EntityQuery 只要说：“我要 Translation + MoveSpeed”，系统就立刻找到所有符合这个 Archetype 的 Chunk，进行批处理。

![image-20250328021212018](./image-20250328021212018.png)

## 3. 如何手动创建 EntityQuery？

如果你需要复用查询逻辑，可以在 System 初始化时创建：

```c#
EntityQuery _moveQuery;

protected override void OnCreate()
{
    _moveQuery = GetEntityQuery(
        ComponentType.ReadWrite<Translation>(),
        ComponentType.ReadOnly<MoveSpeed>()
    );
}
```

然后在 OnUpdate 中使用：

```c#
Entities
  .WithStoreEntityQueryInField(ref _moveQuery)
  .ForEach((...) => { ... })
  .Schedule();
```

------

## 4. EntityQuery 支持哪些查询条件？

| 查询条件类型        | 作用                                 |
| ------------------- | ------------------------------------ |
| `WithAll<T>()`      | Entity 必须拥有 T                    |
| `WithNone<T>()`     | Entity 必须没有 T                    |
| `WithAny<T>()`      | Entity 至少拥有其中一个 T            |
| `WithDisabled<T>()` | 包含已被禁用的组件                   |
| `WithAbsent<T>()`   | Entity 未拥有某组件（不等于 Remove） |

也可以组合使用：

```c#
Entities
  .WithAll<A, B>()
  .WithNone<C>()
  .WithAny<D, E>()
```

##  6. 高阶用法：布尔组合查询

你可以通过 `EntityQueryDesc[]` 创建复杂组合：

```c#
EntityQueryDesc[] queryDescs = new EntityQueryDesc[]{
    new EntityQueryDesc {
        All = new ComponentType[] { typeof(Translation), typeof(MoveSpeed) },
        None = new ComponentType[] { typeof(SleepingTag) }
    }
};

var query = EntityManager.CreateEntityQuery(queryDescs);
```

小技巧：

| 场景                     | 建议                                                   |
| ------------------------ | ------------------------------------------------------ |
| 有多个系统处理同一类实体 | 把 EntityQuery 抽成字段复用                            |
| 想精确控制哪些实体被处理 | 手动写 Query，更灵活                                   |
| 性能优化                 | 用 `WithAll<>` 限定组件组合，避免遍历过多 Chunk        |
| Debug                    | 使用 `query.CalculateEntityCount()` 观察当前匹配实体数 |



# 5. JobSystem



# 6. Burst Compiler