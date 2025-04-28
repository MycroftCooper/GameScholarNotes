---
title: Unity-动画-回调函数接口
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 程序
  - Unity
category: 程序/引擎/Unity/动画
note status: 终稿
---


# 1. 简介

当你想在状态机的某个状态执行中干些什么的时候(增加状态机行为)
比如：播放音效，添加粒子特效，增加逻辑代码等等操作。
那么就可以试一试Unity封装好的回调函数接口：**StateMachineBehaviour**

想要添加（State machine behaviours）状态机行为到状态或子状态机，可以选中某个状态后在inspector中的Add Behaviour按钮。

# 2. 使用该动画回调接口的前置条件

- 必须继承StateMachineBehaviour
- 脚本必须挂在到状态上

# 3. 回调函数接口一览

- **OnStateEnter**
  进入该状态时调用

  ```c#
  override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex){}
  ```

- **OnStateUpdate**
  在该状态下每帧调用
  (MonoBehaviour Updates 更新后)

  ```c#
  override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex){}
  ```

- **OnStateExit**
  在该状态结束退出时调用

  ```c#
  override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex){}
  ```

- **OnStateMove**
  在Animator.OnAnimatorMove()执行后调用(普通动画开始播放后)

  ```c#
  override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex){}
  ```

  > 用于实现处理和影响根运动的代码

- **OnStateIK**
  在Animator.OnAnimatorIK()执行后调用(骨骼动画开始播放后)

  ```c#
  override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex){}
  ```

# 4. 参数解释

- **Animator animator**
  当前动画器，是这个状态机行为的引用。
- **AnimatorStateInfo stateInfo**
  当前状态的详细信息
  - int fullPathHash
    当前状态的全路径哈希值
  - int nameHash
    当前状态名称的哈希值
  - int shortNameHash
    不包括父层名称的短名称哈希值
  - float normalizedTime
    状态的标准化时间
  - float length
    状态当前已经持续的时间
  - float speed
    动画播放速度(1为正常速度)
  - float speedMultiplier
    动画播放倍速
  - int tagHash
    标签的哈希值
  - bool loop
    当前状态是否循环
  - bool IsName(string name)
  - bool IsTag(string tag)
- **int layerIndex**
  是状态机行为状态的layer 层
