---
title: Unity-瓦片地图
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. 简介

UGUI 系统虽然提供了很多封装好的组件，但是要实现一些特定的功能还是显得非常有限，这时候就需要使用事件接口来完成UI功能的实现。

比如我们想实现鼠标移动到图片上时自动显示图片的文字介绍，一般思路会想到写个射线来检测。
但其实这样的检测UGUI已经替我们完成了，我们只需要实现检测到目标对象后所要执行的代码即可！

**事件系统：UnityEngine.EventSystems;**

UI 组件都是基于 UGUI 封装好的类和接口以及一些 Editor 文件来进行封装制作供开发者使用的，开发者利用这些封装好的工具，只需更专注于功能开发即可。

# 2. 事件系统的前置条件

## 2.1 使用该事件系统的条件

- 对象必须是 Canvas 的子对象；
- 对象必须有 Rect 范围；
- 鼠标的操作不分左键 中键 右键；

## 2.2 事件触发条件

- 对象或其子对象所附加的 UI 组件含有 Raycast Target 属性（为 true）

- 鼠标光标进入该对象的 Rect 范围时

## 2.3 事件系统的特殊情况

- **若：**该对象实现事件接口，而其子对象所附加的 UI 组件含有 Raycast Target 		属性且没有实现事件接口
  **则：**只有该对象会触发事件，而其子对象不会触发事件

- **当：**该对象和其子对象同时具有触发事件接口的条件时：
  **若：**该对象的 Rect 范围被其子对象的 Rect 范围完全覆盖掉
  **则：**该对象不会触发事件，只有其子对象会触发事件。

# 3. 事件接口一览

- **IPointerEnterHandler**

  **功能：**
  鼠标移入对象时触发响应函数

  **实现方法：**

  ```c#
  public void OnPointerEnter(PointerEventData eventData){}
  ```

- **IPointerExitHandler**
  **功能：**
  鼠标移出对象时触发响应函数

  **实现方法：**

  ```c#
  public void OnPointerExit(PointerEventData eventData){}
  ```

- **IPointerDownHandler**
  **功能：**
  鼠标在对象范围内按下时触发响应函数

  **实现方法：**

  ```c#
  public void OnPointerDown(PointerEventData eventData){}
  ```

- **IPointerUpHandler**
  **功能**：
  鼠标在对象范围内抬起时触发响应函数

  **实现方法：**

  ```c#
  public void OnPointerUp(PointerEventData eventData){}
  ```
  >注意：
  >
  >- 无论鼠标在何处抬起（即不在A对象中）都会在A对象中响应此事件
  >- 响应此事件的前提是A对象必须响应过OnPointerDown事件
  
- **IPointerClickHandler**
  **功能：**
  鼠标在对象范围内按下并抬起后触发响应函数

  **实现方法：**

  ```c#
  public void OnPointerClick(PointerEventData eventData){}
  ```
  > 注意：
  > 按下和抬起时鼠标要处于同一对象上
  
- **IDragHandler**
  **功能：**
  鼠标在对象范围内按下并拖拽时，对象每帧响应一次此事件
  
  **实现方法：**
  
  ```c#
  public void OnDrag(PointerEventData eventData){}
  ```
  
  > 注意：
  > 如果不实现此接口，则后面的四个接口方法都不会触发

- **IInitializePotentialDragHandler**
  **功能：**
  鼠标在对象范围内按下还没开始拖拽时，对象响应此事件

  > 与IPointerDownHandler接口事件类似

  **实现方法：**

  ```c#
  public void OnInitializePotentialDrag(PointerEventData eventData){}
  ```

- **IBeginDragHandler**
  **功能：**
  当鼠标在对象范围内按下并开始拖拽时，对象响应此事件

  **实现方法：**
  
  ```c#
  public void OnBeginDrag(PointerEventData eventData){}
  ```
  > 注：
  > 此事件在OnInitializePotentialDrag之后响应 OnDrag之前响应

- **IEndDragHandler**
  **功能：**
  当鼠标完成拖拽抬起时，对象响应此事件

  **实现方法：**

  ```c#
  public void OnEndDrag(PointerEventData eventData){}
  ```


- **IDropHandler**
  **功能：**
  当鼠标从A对象上开始拖拽，在B对象上抬起时，B对象响应此事件
  
  **实现方法：**
  
  ```c#
  public void OnDrop(PointerEventData eventData){}
  ```
  
  > 注意：
  >
  > -     A、B对象必须均实现IDropHandler接口，且A至少实现IDragHandler接口
  > -     此时eventData.pointerDrag.name获取到的是B对象的name属性
  > -     eventData.pointerDrag表示发起拖拽的对象（GameObject）

# 4. 参考链接

总结整理自：
https://blog.csdn.net/eazey_wj/article/details/65632664

他这还有很多案例和代码，建议去看看
