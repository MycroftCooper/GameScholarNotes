---
title: Spine速通手册
author: MycroftCooper
created: 2025-04-25 16:08
lastModified: 2025-04-25 16:08
tags:
  - Spine
  - 工具
category: 程序/引擎/Unity/动画
note status: 终稿
---
# Spine动画概念

## 按结构划分

在 Spine 中，附件（Attachments）、槽位（Slots）、骨骼（Bones）和 GameObject 是构成动画的核心元素，它们之间的关系及作用如下：

### 骨架（Skeleton）

### 皮肤（Skins）

皮肤允许动画师为角色创建不同的外观，比如不同的装备或服装。

皮肤是一组可以替换的附件（如图像、网格等）集合，它们定义了角色或对象的不同外观。皮肤可以包含多个替换的图像，这些图像可以分配给同一个槽位，以表示不同的装备或服装选项。

皮肤不是放在槽位里，而是可以被应用到整个骨架上，换句话说，一个皮肤可以影响骨架上多个槽位的外观。

在游戏中，你可以动态切换皮肤来更改角色的外观。

当你在运行时改变皮肤时，Spine 会查找当前皮肤定义中对应各个槽位的附件，并更新槽位以显示新的附件。如果某个槽位在新皮肤中没有对应的附件，则该槽位可能显示为空或保持之前的附件。

### 骨骼（Bones）

骨骼是动画的基础，它们用于构建角色或对象的骨架。骨骼负责定义动画中的运动和变形。

骨骼形成了一个层级结构，槽位和附件附加到骨骼上，随着骨骼的动作而动作。在 Unity 中，骨骼的信息由 `SkeletonAnimation` 或 `SkeletonRenderer` 组件管理。

### 槽位（Slots）

槽位是骨骼的一部分，它们充当容器的角色，用于持有和管理附件。槽位还控制附件的渲染顺序（哪个在上面，哪个在下面）。
槽位被分配给骨骼，它决定附件在骨骼上的位置以及如何随着骨骼移动。

**定义**：
插槽是骨骼动画中的容器，用于持有和管理图像（通常称为“附件”）的显示和排序。它们是分配给特定骨骼的，并且定义了如何以及何时显示与骨骼相关联的图形元素。

**附件**：
附件通常是图像，但也可以是其他类型的对象，如网格、空白图像（用于占位或隐藏）等。附件可以在运行时动态更换，这使得例如换装或道具替换成为可能。

**层级和排序**：
在 Spine 动画中，插槽有一个特定的顺序，这决定了图像在视觉上的层级关系。例如，一个角色的衣服可以放在身体的插槽之上，以确保衣服覆盖身体。

**与骨骼的关系**：
插槽被分配给特定的骨骼，它们随着骨骼的移动和变换而移动。这意味着，如果一个插槽分配给了手臂的骨骼，那么插槽中的图像会随着手臂的动作而动。

**使用场景：**

**换装功能**：
通过在运行时更换附件，可以实现角色的换装功能。例如，你可以为角色更换不同的头盔、衣服或武器。

**动画控制**：
插槽可以用来控制动画中的图像的显示和隐藏，例如，当一个角色需要拿起或放下一个物品时。

**渲染控制**：
通过编程控制插槽，可以实现例如图像的透明度变化或颜色变化等效果。

**如何在 Unity 中使用 Spine 插槽**

在 Unity 的 Spine-Unity 运行时插件中，你可以通过脚本访问和控制插槽。以下是一段示例代码，展示如何在 Unity 中找到并控制插槽：

```c#
SkeletonAnimation skeletonAnimation = GetComponent<SkeletonAnimation>();
Skeleton skeleton = skeletonAnimation.Skeleton; // 获取骨骼

Slot slot = skeleton.FindSlot("weapon"); // 假设有一个名为"weapon"的插槽
slot.Attachment = skeleton.GetAttachment("weapon", "sword"); // 将"weapon"插槽的附件更换为"sword"
```

上面的代码段演示了如何找到一个名为 "weapon" 的插槽，并将其附件更换为名为 "sword" 的图像。
这样的操作通常用于实现换装或道具更换的游戏逻辑。

理解和掌握插槽的使用，对于深入利用 Spine 动画系统来说是非常重要的。通过插槽，开发者能够创建更加动态和灵活的动画，为游戏角色和物体提供丰富的视觉效果。

### 附件（Attachments）

附件通常是指分配给槽位的图像或者其他可视对象，如网格、边界框（bounding box）、点（point）等。
附件被附加到槽位上，它们通过槽位与特定的骨骼关联起来。

### 它们之间的交互

- **附件附着到槽位**：每个附件被分配到一个槽位，这定义了附件的渲染和排序方式。
- **槽位随骨骼移动**：槽位绑定到骨骼上，所以附件随着骨骼的移动和动画而移动。
- **骨骼驱动动画**：骨骼是动画的驱动力，它们之间的父子关系和动作定义了整体的动画效果。
- **GameObject 作为容器**：在 Unity 中，Spine 动画通过附加到 GameObject 上的组件（如 `SkeletonAnimation`）来播放。GameObject 提供了上下文，使得 Spine 动画能够在 Unity 的世界中与其他对象和脚本交互。

总之，骨骼提供动画的结构，槽位和附件提供可视化的内容，而 GameObject 则是将这一切整合到 Unity 环境中的容器。通过这种方式，Spine 动画能够以一种灵活且高效的方式被整合和控制，为游戏或应用程序带来丰富的视觉效果。

# Spine实例化方式

## 概述

三种实例化 Spine skeleton 的方法各自的优缺点和使用场景如下：

### SkeletonAnimation

**优点**:

- **高度可定制**：提供了对 Spine 动画系统的完整访问，包括高级特性如皮肤、事件、附件和约束。
- **MeshRenderer 渲染**：使用 MeshRenderer 进行渲染，可以享受到 Unity Mesh 的所有优势，如遮罩交互和灵活的材质选项。
- **支持 SpriteMask**：可以与 Unity 的 SpriteMask 和其他遮罩类型交互，便于集成到现有的 2D 环境中。

**缺点**:

- **性能开销**：对于复杂的动画，可能比 Unity 内置的动画系统使用更多资源。
- **学习曲线**：需要对 Spine 的动画系统有深入了解，可能需要额外学习时间。

**使用场景**:

- 推荐在需要高度定制动画或使用 Spine 提供的特殊特性时使用。
- 当你需要 Spine 动画与 Unity 的 SpriteMask 等遮罩交互时。
- 如果你的项目是以 Spine 为主的动画工作流。

### SkeletonGraphic (UI)

**优点**:

- **UI 集成**：专为与 Unity 的 Canvas UI 系统一起工作而设计，适用于 UI 元素的动画。
- **UI 遮罩兼容**：与 Unity UI Mask 和 RectMask2D 兼容，适合在 UI 中使用动画。
- **Canvas 渲染**：作为 Canvas 渲染的一部分，可以利用 Canvas 的渲染优化。

**缺点**:

- **灵活性降低**：与 MeshRenderer 相比，UI 系统可能不支持某些材质和渲染特性。
- **性能考量**：Canvas 系统的渲染性能与 MeshRenderer 不同，可能需要优化。

**使用场景**:

- 当你需要在 Unity 的 UI 系统中使用 Spine 动画，例如在菜单、HUD 或其他屏幕元素中。
- 如果你的动画作为 UI 的一部分，需要和其他 UI 元素如按钮或滑块一起工作。

### SkeletonMecanim

**优点**:

- **Mecanim 集成**：与 Unity 的 Animator 控制器和动画状态机（Mecanim）集成，可以利用 Unity 动画系统的功能，如状态转换和混合树。
- **Unity 动画工作流**：适合那些已经熟悉 Unity Mecanim 系统的团队和项目。

**缺点**:

- **功能限制**：与 Spine 的完整动画系统相比，Mecanim 的某些高级特性可能不可用。
- **动画预览差异**：在 Spine Editor 中预览的动画效果可能无法完全一致地在 Unity 中重现。

**使用场景**:

- 如果你更喜欢使用 Unity 的 Mecanim 系统，或者项目中已经广泛使用了 Mecanim 动画。
- 当项目需要整合 Spine 动画与 Unity 原生动画，并且不需要 Spine 的所有高级特性时。

### 总结

每种方法都有其特定的用例和优势。选择哪种方法取决于你的项目需求、团队的熟悉度以及你是否需要 Spine 提供的特定功能。通常情况下，如果你需要 Spine 的高级特性和最好的可定制性，`SkeletonAnimation` 是首选。而如果你在制作一个 UI 重的应用或游戏，并且动画是 UI 的一部分，那么 `SkeletonGraphic` 是更好的选择。最后，如果你希望将 Spine 动画集

## SkeletonAnimation组件

 `SkeletonAnimation` 组件，这是最常用的 Spine 组件， 它是 Spine 在 Unity 中最核心的组件之一，用于控制和播放 Spine 动画。通过它可以控制动画的播放、暂停、停止，以及切换不同的动画。

### Inspector参数

- **SkeletonData Asset**
   指定 Spine 动画数据的来源，即你导入的 `.skel` 或 `.json` 文件。
   当你需要为 GameObject 指定动画时使用。

- **Initial Skin**
   选择初始应用于骨骼的皮肤。
   如果你的 Spine 动画有多个皮肤变体，你可以在这里选择一个作为默认显示。

- **Sorting Layer / Order in Layer**
   决定渲染顺序，类似于 Unity 中的其他渲染组件。
   在有多个动画或其他渲染对象叠加的场景中，调整这些值以获得正确的层次顺序。

- **Mask Interaction**
   定义如何与 Sprite Mask 交互。
   当你需要动画与 UI 遮罩或场景中的其他遮罩元素互动时。

- **Advanced**

   这个部分包含一系列高级选项，通常默认设置就足够，但可以根据特定需求进行调整。

   - **Renderer and Update Settings**
      控制渲染和更新行为。
      调整动画的渲染和更新方式，如需要在对象不可见时更新动画，或优化渲染性能。
      - **Animation Update**
         更新动画的时机
         - **In Update**: 
           这意味着动画的更新将在 Unity 的标准更新循环中进行，也就是每个帧的 `Update()` 调用时。
      - **Update When Invisible**：
         不可见时也更新动画
      - **Use Single Submesh**
         如果勾选，所有的图形都会被绘制在一个单独的子网格中。这在某些情况下可以提高渲染效率。
      - **Fix Draw Order**
         当启用时，如果动画中的绘制顺序发生了错误，这个选项可以修复它。
      - **Immutable Triangles**
         如果勾选，意味着三角形数据是不可变的。这对于性能优化有好处，因为不需要重新计算三角形数据，但这限制了在运行时更改图形拓扑的能力。
      - **Clear State On Disable**
         当 GameObject 被禁用时，如果勾选，将会清除动画状态。
         这意味着当 GameObject 重新启用时，动画会从初始状态开始。
   - **Fix Prefab Overr. MeshFilter**
      当您使用预制件并且对 MeshFilter 进行了重写时，这个选项可以保证这些重写被正确地应用。
   - **Separator Slot Names**
      它允许你将骨骼动画的某些部分分离到不同的渲染层或网格中。
      这可以用来解决渲染排序问题，或者是为了在特定的插槽上实现特殊的效果。
   - **Z Spacing**
      在渲染时给每个部分添加的空间量，有助于解决 Z-fighting 问题。
      当元素在同一平面上但需要给出层次感时使用。
   - **Vertex Data**
      包含有关顶点信息的选项，如颜色和法线。
      特别是在使用灯光或需要精确控制渲染效果时。
      - **PMA Vertex Colors **
        PMA 代表预乘 Alpha，这是一种处理透明度和颜色混合的技术。
      - **Tint Black**
        （或称为 “Two Color Tint”）允许 Spine 在渲染时使用额外的颜色通道来实现更复杂的着色效果，尤其是对于阴影和光照的模拟。
        当你的 Spine 动画在 Spine 编辑器中使用了黑色色调或其他高级着色效果，需要在 Unity 中重现这些效果时启用此选项。
      - **Add Normals**
        此选项会为网格顶点数据添加法线信息。法线是影响光照和着色的重要因素，特别是当场景中有光源影响动画对象时。
        如果你在场景中使用了光源，并且希望 Spine 动画受到光照影响，就需要启用这个选项。
      - **Solve Tangents**
        为网格顶点数据计算切线。切线通常与法线一起使用，用于正确渲染具有法线贴图的材料，以模拟更复杂的光照效果，如凹凸贴图。
        如果你的材质使用了法线贴图，需要切线信息来确保贴图正确显示，这时就需要启用此选项。

- **Animation Name**
   选择要播放的动画。
   在运行时或在场景开始时指定默认播放的动画。

- **Loop**
   决定当前选择的动画是否循环播放。
   对于循环进行的动画（如行走、跑步）设置为循环，对于一次性动作（如攻击、跳跃）则不循环。

- **Time Scale**
   控制动画播放的速度。
   当你想加速或减慢动画时调整这个值。

- **Unscaled Time**
   如果勾选，动画时间将不受时间缩放的影响（即 `Time.timeScale`）。
   在游戏暂停或全局时间缩放时，如果你仍然希望动画正常播放，使用这个选项。

- **Root Motion**
   Root Motion 通常用于将动画中的某个对象（如角色的“根”骨骼）的移动应用到 GameObject 的实际位置和旋转上。这样，动画本身就可以驱动角色的移动，而不仅仅是视觉上的。
   如果动画包含了角色位置的改变，你可以通过启用 Root Motion 来将这些位置变化应用到 Unity GameObject 的移动上。这对于那些动画中包含实际移动（如走路、跳跃）的情况特别有用。
   它会给当前GameObject添加一个SkeletonRootMotion组件来实现以上功能。

**额外说明：**

这些参数大多数在初始设置时配置一次，之后在游戏运行时通过代码进行控制。
例如，你可能会在游戏中根据用户输入或其他游戏事件来改变动画（通过更改 `AnimationName`），或调整动画速度（通过更改 `Time Scale`）。
对于大部分游戏项目，除非你有特殊的需求，否则很多参数可以保持默认设置。

### API

在 Unity 中使用 Spine 提供的 `SkeletonAnimation` 组件时，可以通过 C# 脚本访问和控制各种动画功能。
这些 API 提供了丰富的动画控制能力，包括但不限于播放、停止、暂停动画，以及监听动画事件等。
以下是一些关键的 API 和它们的用法：

**AnimationName**
获取或设置当前播放的动画名称。
示例：`skeletonAnimation.AnimationName = "run";`

#### 生命周期相关

在 [SkeletonAnimation](https://zh.esotericsoftware.com/spine-unity#SkeletonAnimation组件) 组件中, AnimationState保存了所有当前播放的和队列中的动画状态.
每一次 `Update`, AnimationState都会被更新,从而使动画在时间上向前推进. 然后, 新一帧作为一个新的pose被应用于Skeleton上.

你的脚本可以在SkeletonAnimation的 `Update` 之前或之后运行. 如果你的代码在SkeletonAnimation的更新之前获取Skeleton或骨骼的值, 你的代码会读取上一帧而不是当前帧的值.

该组件将事件回调委托暴露为属性, 这样就能在计算所有骨骼的世界transforms之前和之后介入该生命周期. 你可以绑定这些委托来修改骨骼的位置和其他方面, 而无需关注角色和组件的更新顺序.

**SkeletonAnimation Update 回调:**

- `SkeletonAnimation.BeforeApply` 
  在应用该帧动画之前被引发. 当你想在动画应用到skeleton上之前改变skeleton的状态时, 请使用这个回调.
- `SkeletonAnimation.UpdateLocal` 
  在该帧动画更新完成并应用于skeleton的局部值之后被引发. 如果你需要读取或修改骨骼的局部值, 请使用它.
- `SkeletonAnimation.UpdateComplete` 
  在计算完Skeleton中所有骨骼的世界值后被引发. SkeletonAnimation在这之后不会在Update中做进一步的操作. 如果你只需要读取骨骼的世界值, 就使用它. 如果有代码在SkeletonAnimation的Update之后修改了这些值, 这些值可能仍会发生变化.
- `SkeletonAnimation.UpdateWorld` 
  是在计算了Skeleton中所有骨骼的世界值后引发的. 若订阅了该事件则将二次调用
- `skeleton.UpdateWorldTransform`
   如果你的skeleton复杂或正在执行其他计算, 那这将是多余甚至是浪费的行为. 如果需要根据骨骼的世界值来修改骨骼的局部值, 请使用该事件. 它在Unity代码中实现自定义约束很有用.
- `OnMeshAndMaterialsUpdated` 
  在 `LateUpdate()` 结束后,在网格和所有materials都被更新后引发.

#### 动画状态相关

`state` 属性提供了对 `AnimationState` 对象的引用，这是动画播放的核心类。

- **SetAnimation**
  在指定的轨道上播放一个动画，并可选择是否循环。
  示例：`skeletonAnimation.state.SetAnimation(0, "jump", false);`

- **TimeScale**
  设置动画播放速度
  `skeletonAnimation.state.TimeScale = 0.5f;`
- **AddAnimation**
  在当前动画之后添加一个动画到播放队列。
  示例：`skeletonAnimation.state.AddAnimation(0, "run", true, 0);`
- **SetEmptyAnimation**
  清空指定轨道上的当前动画，可选择淡出时间。
  示例：`skeletonAnimation.state.SetEmptyAnimation(0, 0.5f);`
- **ClearTrack** 和 **ClearTracks**
  清除指定轨道上的所有动画或清除所有轨道上的动画。
  示例：
  `skeletonAnimation.state.ClearTrack(0);`
  `skeletonAnimation.state.ClearTracks();`

**事件监听相关：**

- **Start, Interrupt, End, Dispose**
  添加监听器以响应动画的开始、中断、结束和释放事件。
  示例：`skeletonAnimation.state.Start += OnAnimationStart;`
- **Complete**
  添加监听器以响应动画播放完成事件。
  示例：`skeletonAnimation.state.Complete += OnAnimationComplete;`
- **Event**
  添加监听器以响应动画中定义的特定事件。
  示例：`skeletonAnimation.state.Event += OnEventReceived;`

#### 控制骨骼和插槽

**Skeleton**
获取当前的 `Skeleton` 对象，它包含了所有骨骼、插槽和当前附件的状态。
通过Skeleton可以设置皮肤、附件、重置骨骼为setup pose、比例以及翻转整个skeleton.

- **FindBone**
  在 Skeleton 中查找并返回具有指定名称的骨骼。
  示例：`Bone head = skeletonAnimation.Skeleton.FindBone("head");`
- **FindSlot**
  查找并返回具有指定名称的插槽。
  示例：`Slot weaponSlot = skeletonAnimation.Skeleton.FindSlot("weapon");`
- **SetAttachment**
  更改插槽上的附件（图像）。
  示例：`skeletonAnimation.Skeleton.SetAttachment("weapon", "sword");`
  参数：(插槽名称，附件名称)
- **SetToSetupPose**
  将 Skeleton 的状态重置为“初始设置姿势”。
  - 重置整个骨架`skeleton.SetToSetupPose();`
  - 重置全部骨骼`skeleton.SetBonesToSetupPose();`
  - 重置全部插槽`skeleton.SetSlotsToSetupPose();`

- **SetSkin**
  设置骨架皮肤
  `bool  success = skeletonAnimation.Skeleton.SetSkin("skinName");`
  也可以从多个皮肤中抽取部分来组合成新皮肤：

  ```c#
  var skeleton = skeletonAnimation.Skeleton;
  var skeletonData = skeleton.Data;
  var mixAndMatchSkin = new Skin("custom-girl");
  mixAndMatchSkin.AddSkin(skeletonData.FindSkin("skin-base"));
  mixAndMatchSkin.AddSkin(skeletonData.FindSkin("nose/short"));
  mixAndMatchSkin.AddSkin(skeletonData.FindSkin("eyelids/girly"));
  skeleton.SetSkin(mixAndMatchSkin);
  skeleton.SetSlotsToSetupPose();
  skeletonAnimation.AnimationState.Apply(skeletonAnimation.Skeleton); // skeletonMecanim.Update() for SkeletonMecanim
  ```