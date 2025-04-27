# System 类型（业务逻辑执行者）

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

# EntityQuery 深入理解

✅ 章节目标

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

![image-20250328021212018](attachments/notes/程序/引擎/Unity/框架/ECS-DOTS/DOTS-System/IMG-20250425160313743.png)

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

# EntityCommandBuffer

**`EntityCommandBuffer` 是 DOTS 中用于“延迟执行结构性变更（Add/Remove/Create/Destroy）”的命令队列。**

它本质上就是：“你不能在 Job 或 ForEach 中直接改结构，那就先记下来，晚点再统一执行”。

在 DOTS 中，你**不能在并行 Job（或者 ForEach 带 `ScheduleParallel`）中**直接执行这些操作：

```c#
EntityManager.CreateEntity()
EntityManager.AddComponent()
EntityManager.DestroyEntity()
```

💥 因为这些是「结构性变更」，会影响 Archetype/Chunk，**必须在主线程、非 Burst 情况下执行**。

于是就有了 `EntityCommandBuffer`：
你先往里“写命令”，然后**主线程会按顺序安全地执行它们**。

**你可以用它干什么？**

| 操作             | 用 ECB 实现                                  |
| ---------------- | -------------------------------------------- |
| 创建实体         | `ecb.CreateEntity()`                         |
| 添加组件         | `ecb.AddComponent()`                         |
| 移除组件         | `ecb.RemoveComponent()`                      |
| 销毁实体         | `ecb.DestroyEntity()`                        |
| 设置组件值       | `ecb.SetComponent()`                         |
| 追加 Buffer 元素 | `ecb.AppendToBuffer()`（推荐！）             |
| 发出事件实体     | `ecb.CreateEntity() + AddComponent<Event>()` |

**和 EntityManager 的区别？**

| 能力       | EntityManager      | ECB                       |
| ---------- | ------------------ | ------------------------- |
| 创建实体   | ✅ 主线程可用       | ✅ 延迟执行                |
| 并行安全   | ❌                  | ✅ ParallelWriter          |
| Job 中使用 | ❌                  | ✅ ✔️ 推荐！                |
| Burst 可用 | ❌                  | ✅ 写入可以，Playback 不行 |
| 延迟执行   | ❌                  | ✅ ✔️                       |
| 推荐用法   | 编辑器工具、调试时 | 所有结构变更都应该用它！  |

## 用法详解

### 创建 ECB

```c#
EntityCommandBuffer ecb = new EntityCommandBuffer(Allocator.Temp);
```

或者用官方推荐的：

```c#
var ecbSystem = SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem>();
var ecb = ecbSystem.CreateCommandBuffer();
```

> 📌 `EndSimulationEntityCommandBufferSystem` 是 Unity 官方专门为你提供的一帧执行器！

------

### 在 Job 或 ForEach 中记录命令

```c#
Entities
    .WithAll<ShouldDestroy>()
    .ForEach((Entity e) =>
    {
        ecb.DestroyEntity(e); // ⚠️ 不要直接用 EntityManager！
    }).ScheduleParallel();
```

------

### 执行命令（Playback）

在非 Job、主线程上执行：

```c#
ecb.Playback(EntityManager);
ecb.Dispose();
```

> ❗ 如果是用 `EndSimulationEntityCommandBufferSystem` 创建的 ECB，Unity 会在帧末自动调用 Playback！

------

### 多线程安全版：`EntityCommandBuffer.ParallelWriter`

当你使用 `.ScheduleParallel()` 时，**必须**使用：

```c#
var ecb = ecbSystem.CreateCommandBuffer().AsParallelWriter();
```

然后在 ForEach 里这样写：

```c#
Entities
    .ForEach((Entity e, int entityInQueryIndex) =>
    {
        ecb.DestroyEntity(entityInQueryIndex, e);
    }).ScheduleParallel();
```

>  `entityInQueryIndex` 保证线程安全写入，**你必须传进去！**

### 生命周期 & 执行顺序

| 阶段                                 | 动作                |
| ------------------------------------ | ------------------- |
| Frame N 中 Job 调用 ecb.AddComponent | 命令被记录          |
| Frame N 末尾 `ecb.Playback()`        | 命令被按顺序执行    |
| Frame N+1                            | 结果体现在 World 上 |

使用建议与注意事项

| 建议                                          | 原因                                     |
| --------------------------------------------- | ---------------------------------------- |
| 使用 Unity 提供的 `EntityCommandBufferSystem` | 自动 Playback，无需你写 Dispose          |
| Job 中只记录命令，不直接修改结构              | 符合 DOTS 线程安全原则                   |
| 不要在 Burst Job 里 Playback！                | 会崩 / 报错                              |
| 不要在 Playback 后再用这个 ECB                | 会访问已释放内存！                       |
| 每帧用一次，下一帧重新生成                    | ECB 不可复用（除非你真的懂它的生命周期） |

###  推荐写法模板（标准姿势）

```c#
public partial class MySystem : SystemBase{
    private EndSimulationEntityCommandBufferSystem ecbSystem;

    protected override void OnCreate(){
        ecbSystem = World.GetOrCreateSystemManaged<EndSimulationEntityCommandBufferSystem>();
    }

    protected override void OnUpdate(){
        var ecb = ecbSystem.CreateCommandBuffer().AsParallelWriter();

        Entities
            .ForEach((Entity e, int entityInQueryIndex, in TagForDestruction tag) =>{
                ecb.DestroyEntity(entityInQueryIndex, e);
            }).ScheduleParallel();
        // ECB 会在帧末自动 Playback，无需手动调度！
    }
}
```

# SystemGroup

## 1. 什么是 `SystemGroup`？

`SystemGroup` 是 DOTS 中的 **“系统调度容器”**，用于定义一组 System 的执行顺序、依赖、更新频率等。

类似 GameObject 中的：Update → LateUpdate → FixedUpdate。
但你可以自定义分组、插入顺序、控制依赖

**Unity 默认内置的 SystemGroup：**

| 名称                             | 执行阶段     | 常见用途                         |
| -------------------------------- | ------------ | -------------------------------- |
| `InitializationSystemGroup`      | 最先执行     | 初始化、状态同步等               |
| `SimulationSystemGroup`          | 主逻辑处理   | AI、移动、战斗、技能等           |
| `LateSimulationSystemGroup`      | 最后执行     | 状态收尾、动画同步等             |
| `PresentationSystemGroup`        | 渲染数据准备 | 渲染系统（HybridRenderer）插在这 |
| `FixedStepSimulationSystemGroup` | 固定帧率系统 | 物理/服务器帧同步等              |

## 2. 如何将 System 插入指定 Group？

每个 System 默认会被放进 `SimulationSystemGroup`，你可以重定向

用 `[UpdateInGroup(typeof(...))]` 指定所属组：

```c#
[UpdateInGroup(typeof(SimulationSystemGroup))]
public partial class MovementSystem : SystemBase { ... }
```

你还可以控制顺序：

```c#
[UpdateAfter(typeof(PathFindingSystem))]
[UpdateBefore(typeof(AnimationSystem))]
public partial class MovementSystem : SystemBase { ... }
```

调度器会根据你的依赖自动构建一个 DAG（有向无环图）保证执行顺序！

> 没有指定顺序的系统，会按创建顺序执行。

## 3. 如何自定义 SystemGroup？

自定义 SystemGroup 非常简单，就像声明一个普通 System，只需要继承 `ComponentSystemGroup`：

```c#
[UpdateInGroup(typeof(SimulationSystemGroup))]
public partial class CombatSystemGroup : ComponentSystemGroup {}
```

然后把系统放进去：

```c#
[UpdateInGroup(typeof(CombatSystemGroup))]
public partial class AttackSystem : SystemBase {}

[UpdateInGroup(typeof(CombatSystemGroup))]
public partial class DamageSystem : SystemBase {}
```

效果是 CombatGroup 成为 Simulation 的子流程块，你可以控制其更新顺序和生命周期。

**一些小细节补充：**

- SystemGroup 支持嵌套，层级不限
- 如果系统**没在任何 Group 中注册**，它不会自动创建，也不会更新（除非你手动创建/调用）
- 自定义 Group 会被调度器更新（除非 `[DisableAutoCreation]`）
- `SystemBase` 默认会执行 `.RequireForUpdate(query)` 来判断是否启用
- `ISystem`（高性能结构体系统）也支持 `OnCreate`, `OnUpdate`，但用不同方式组织
- 生命周期不会像 Mono 一样有 Awake / OnEnable 分离，它们被合并为 `OnCreate` & `OnStartRunning`

#  World

World 是 DOTS 的**运行时上下文容器**，每个 World 拥有自己的：

- EntityManager
- 所有 Archetype / Chunk / Entity
- 所有注册的 System & SystemGroup

默认会创建一个 `DefaultWorld`，你也可以创建多个世界：

```c#
World newWorld = new World("TestWorld");
World.DefaultGameObjectInjectionWorld = newWorld;
var system = newWorld.CreateSystem<YourSystem>();
```

多 World 使用场景:

| 场景                       | World 用法                                       |
| -------------------------- | ------------------------------------------------ |
| ✅ 客户端 + 服务端 预测世界 | 一个 World 运行真实逻辑，一个 World 运行预测模拟 |
| ✅ 并行模拟多个地图         | 每张地图一个独立 World，互不干扰                 |
| ✅ 编辑器模式下运行临时世界 | SubScene Baking、Prefab Preview、测试            |
| ✅ 多人镜像模拟             | 每个 Player 一份模拟世界用于验证输入             |

**注意事项：**

- 多个 World 共享实体？
  ❌ 不行，每个 World 有独立 EntityManager
- 系统能跨 World 调用？
  ❌ 不推荐（需显式获取目标 World 引用
- 创建 World 会泄露吗？
  ✅ 需手动释放 `world.Dispose()`！

# World-SystemGroup-System 生命周期

![image-20250330043902879](attachments/notes/程序/引擎/Unity/框架/ECS-DOTS/DOTS-System/IMG-20250425160313759.png)