#### **Chunk 与 Archetype**（内存优化核心）

# Archetype

- 一组特定组件类型的组合，定义实体的“结构”
- 每个 Entity 都属于某个 Archetype
- 所有组件类型顺序固定（影响内存结构）

**举个例子：**
假设两个实体：

- A 拥有组件：Position、Velocity
- B 拥有组件：Position、Velocity、Health

它们拥有不同的 Archetype，因此会存储在不同的 Chunk 中。

**什么操作会触发 Archetype 改变 ➜ 实体迁移？**

| 操作                                  | 是否迁移？ |                                |
| ------------------------------------- | ---------- | ------------------------------ |
| 创建实体（新 Archetype）              | ✅ 是       | 新建 Chunk                     |
| `AddComponent<T>()`                   | ✅ 是       | 改变了 Archetype，必须换 Chunk |
| `RemoveComponent<T>()`                | ✅ 是       | 改变了 Archetype，必须换 Chunk |
| `SetSharedComponent<T>()`（不同值）   | ✅ 是       | Chunk 迁移，但 Archetype 不变  |
| `Enable/Disable IEnableableComponent` | ❌ 否       | 仅修改启用位，不影响结构       |
| `修改字段值`                          | ❌ 否       | 只改数据，不改结构             |

# Chunk

**Chunk 是 Unity DOTS 中最小的实体批处理单元**，你可以把它看作是一块固定大小的内存容器，用于存储结构一致的实体和它们的组件数据。

- **Chunk**：
  - 存储具有相同 Archetype 的实体数据的内存块
  - 是一块物理内存区域，大小固定（通常为 16KB）。
  - 存储组件数据以 **按列结构（SoA）** 紧密排列，**非常利于 CPU Cache 命中**

**优点：**

- 查询速度极快（不用逐个遍历）
- CPU Cache 命中率高，内存访问快

**DOTS 的 Chunk 是：**

- 高密度（小空间存大量实体）
- 高局部性（查询时只遍历需要的 Chunk）
- 高批处理性（系统按 Chunk 为单位处理）
- 低开销（预分配 + 列式访问）

所以：Unity 非常鼓励你“构造组件组合尽量紧凑”，**避免每个 Entity 挂几十个组件**。
这不仅影响 Archetype 数量，还会导致：

- Chunk 利用率变低
- Query 查询变慢
- 存储压缩变差

## Chunk 的内部结构（高层结构图）

```plaintext
[Chunk] (16KB 固定大小)
├── EntityArray[Count]         ← 实体ID列表
├── ComponentA[Count]          ← 每列是一个组件类型的数据数组
├── ComponentB[Count]
├── ...
├── ChangeVersion[]            ← 每列一个版本，用于变更追踪
├── BufferStorage / Padding    ← 可变长度 buffer（IBufferElementData）
├── ChunkHeader                ← 元信息：Count、Archetype、flags 等
```

Unity 的 Chunk 内部还包含：

| 字段                    | 作用                                                  |
| ----------------------- | ----------------------------------------------------- |
| EntityCount             | 当前存了几个 Entity                                   |
| ArchetypeRef            | 本 Chunk 属于哪个 Archetype                           |
| Flags                   | 标记是否正在使用、是否已空等                          |
| ChangeVersions[]        | 每列组件一个，用于 ChangeFilter                       |
| EnableBits              | 每个 EnableableComponent 都有一列位掩码               |
| SharedComponent Indices | 如果该 Archetype 包含 SharedComponent，记录对应值索引 |

**为什么是 按列布局 而不是按实体排列？**
因为 DOTS 要实现**极致的内存访问效率 + SIMD 向量化 + Cache 局部性**。

按列存储的优势是：

| 对比项       | 按列（SoA）      | 按行（AoS）        |
| ------------ | ---------------- | ------------------ |
| 遍历一个组件 | ✅ 连续内存，极快 | ❌ 内存跳跃         |
| SIMD 支持    | ✅ 易对齐         | ❌ 难对齐           |
| Burst 优化   | ✅ 高效压缩       | ❌ 无法打包加载     |
| 写入多个组件 | ❌ 不如 AoS 连续  | ✅ 一次性写整行更快 |

**Chunk 的容量如何计算？**

Chunk 是**固定大小（默认 16KB）**的，Unity 会计算当前 Archetype 下：
每个 Entity 需要多少字节 = 各组件的 size 加总 + 对齐 padding

然后：

```ini
MaxEntitiesPerChunk = floor( ChunkSize / PerEntitySize )
```

举个例子：

- 如果每个 Entity 占用 256 字节 → Chunk 能存 64 个 Entity
- 如果只占 32 字节 → Chunk 能存 512 个

你可以通过 `Archetype.ChunkCapacity` 获取这个值。