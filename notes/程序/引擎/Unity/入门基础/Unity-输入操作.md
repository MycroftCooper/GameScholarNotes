---
title: Unity-输入操作
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 程序
  - Unity
category: 程序/引擎/Unity/入门基础
note status: 终稿
---


# 1.简介

输入操作是游戏的基础操作之一。

Unity支持的操作方式：

- 鼠标、键盘，小键盘(PC)
- 手柄(主机)
- 触屏操作、重力传感器、手势（移动平台）
- VR，AR
- 麦克风，摄像头

# 2. 虚拟输入轴(Virtual axes)

虚拟控制轴将不同的输入设备(比如键盘或摇杆的按键)都归纳到一个统一的虚拟控制系统中。
(比如键盘的w、S键以及手柄摇杆的上下运动默认都统一映射到竖直(Verica)输入轴上) 
这样就屏蔽了不同设备之间的差异，让开发者可以用一套非常简单的输入逻辑，同时兼容多种输入设备。

使用**输入管理器(Input Manager)**可以查看、修改或增删虚拟轴。

现代的游戏中往往允许玩家在游戏中自定义按键，所以使用Unity的输入管理器就更为重要要了。
通过一层虚拟轴间接操作，可以避免在代码中直接写死操作按钮，而且还能通过动态修改虚拟轴的设置来改变键位的功能。

关于虚拟输入轴，还有一些需要知道的内容：

1. 脚本可以直接通过虚拟轴的名称读取那个轴的输入状态。

2. 创建Unity工程时，默认创建了以下虚拟轴:

   - 横向输入和纵向输入被映射在键盘的W、A、S、 D键以及方向键上
   
   - Fire1、 Fire2、 Fire3这三个按钮映射到了鼠标的左、中、右键以及键盘的Ctrl. AIt等键位上
   
   - 鼠标移动可以模拟摇杆输入(和鼠标光标在屏幕上的位置无关)，且被映射在专门的鼠标偏移轴上
   
   - 其他常用虚拟轴，例如跳跃(Jump) 、确认(Submit) 和取消(Cancel) 
##　2.1 添加和编辑虚拟输入轴

要添加新的虚拟输入轴，只需要单击主菜单的Edit > Projet Setings > Input 选项，单击路街检视窗口中会显示一个输入管理器，在里面就可以修改或添加虚拟轴了。

> 注意:
> 虚拟轴具有正、负两个方向。英文记作Positive和Negative.。
> 某些相反的动作可以只用一个轴来表示。
> 比如，如果摇杆向上为正，那么向下就是同一个轴的负方向。

每个虚拟轴可以映射两个按键，第二个按键作为备用，功能一样，备用的英文为Alterative。

## 2.2 虚拟输入轴属性表

下表是虚拟输入轴的属性表：

| 属性                      | 功能                                                         |
| ------------------------- | ------------------------------------------------------------ |
| Name                      | 轴的名字。在脚本中用这个名字来访问这个轴                     |
| Descriptive Name          | 描述性信息，在某些窗口中显示出来以方便查看(正方向)           |
| Descriptive Negative Name | 描述性信息，在某些窗口中显示出来以方便查看(负方向)           |
| Ncgative Button           | 该轴的负方向，用于绑定某个按键                               |
| Positive Button           | 该轴的正方向，用于绑定某个按键                               |
| Alt Negative Button       | 该轴的负方向，用于绑定某个备用按键                           |
| Alt Positive Button       | 该轴的正方向，用于绑定某个备用按键                           |
| Gravity                   | 轴回中的力度                                                 |
| Dead                      | 轴的死区                                                     |
| Sensitivity               | 敏感度                                                       |
| Snap                      | 保持式按键。比如按住下方向键，则一直保持下的状态，直到再次按上方向键 |
| Invert                    | 如果勾选，则交换正负方向                                     |
| Type                      | 控制该虚拟轴的类型， 比如手柄、键盘是两种不同的类型          |
| Axis                      | 很多手柄的输入不是按钮式的，这时就不能配置到Button里面，而是要配置到这里。可以理解为实际的操作轴 |
| Joy Num                   | 当有多个控制器时，要填写控制器的编号                         |

上表中的Gravity、Dead 等属性需要解释一下。

### 2.2.1 Gravity

现代游戏的方向输入和早期游戏的方向输入不太一样。
早期游戏中，上、中、下都是离散的状态，可以直接用1、0、-1来表示。
而现代游戏输入往往具有中间状态，比如0、0.35、 0.5、0.7、1, 是带有多级梯度的。
比如轻推摇杆代表走路，推到底就是跑步。
所以现代游戏的输入默认都是采用多梯度的模式。

虽然键盘没有多级输入的功能，但Unity依然会模拟这个功能，也就是说当你按住W键时，这个轴的值会以很快的速度逐渐从0增加到1。

所以，上表中Gravity和Sensitivity的含义就不难理解了，它们影响着虚拟轴从1到0、从0到1的速度以及敏感度。
> 具体调试方法这里不再介绍，建议使用默认值

### 2.2.2 Dead

还有死区需要单独说明。

由于实体手柄、摇杆会有一些误差，比如，手柄放着不动时，某些手柄的输出值可能会在0.05 和0.08之间浮动。这个误差有必要在程序中排除。
所以Unity设计了死区的功能，在该值范围内的抖动被忽略为0,这样就可以过滤掉输入设备的误差。

## 2.3 在脚本中处理输入

读取输入轴的方法很简单，代码如下:

`float value = Input.GetAxis ("Horizontal");`

得到的值的范围为-1~1,默认位置为0。
这个读取虚拟轴的方法与具体控制器是键盘还是手柄无关。

> 如果用鼠标控制虚拟轴，就有可能由于移动过快导致值超出-1~1的范围。



> 注意:
> 可以创建多个相同名字的虚拟轴。
> Unity 可以同时管理多个同名的轴，最终结果以变化最大的轴为准。
> 这样做的原因是很多游戏可以同时用多种设备进行操作。
> 比如PC游戏可以用键盘、鼠标或手柄进行操作，手机游戏可以用重力感应器或手柄进行操作。
> 这种设计有助于用户在多种操作设备之间切换，且在脚本中不用去关心这一点。

## 2.4 按键名称

要映射按键到轴上，需要在正方向输入框或者负方向输入框中输入正确的按键名称。
按键名称的规则和例子如下。

- 常规按键: A、B、......

- 数字键: 1、2、......

- 方向键: Up、 Down、 Left、 Right.....

- 小键盘键: [1]、 [2]、 [3]、 [+]、 [equals].....

- 修饰键: Right+Shift、 Lef+Shift、Right+Ctrl、Left+Ctrl、Right+Alt、Left+Alt、Right+Cmd、Left+Cmd....

- 鼠标按钮: mouse 0、mouse 1、mouse2 .....

- 手柄按钮(不指定具体的手柄序号) : joystick button 0、joystick button 1.....

- 手柄按钮(指定具体的手柄序号): joystick 1 button 0、joystick 1 button 1......

- 特殊键: Backspace、 Tab、 Retur、 Escape、 Space、 Delete、 Enter、 Insert、 Home、Page Up.....

- 功能键: FI、F2、.....

  > 可以使用**KeyCode枚举类**型来指定案件，与用字符串的效果一致

# 3. 在PC端输入

unity为开发者提供了input库，来支持键盘事件，鼠标事件以及触摸事件。

## 3.1 键盘事件

一般的PC键盘有104个不同的按键，在程序中通过监听这些按键事件，从而进一步执行逻辑操作。
如：射击游戏中，W表示前进，S表示后退，A表示左移，D表示右移。

### 3.1.1 按下事件

在脚本中，用**input.GetKeyDown( )方法**将按键值作为参数，监听此按键是否被按下。
按下返回true，否者返回false。

例如：

```c#
if (Input.GetKeyDown (KeyCode.W))  
            {  
                Debug.Log("您按下了W键");  
            }  
if (Input.GetKeyDown (KeyCode.Space))  
            {  
                Debug.Log("您按下了空格键");  
            }  
```

### 3.1.2 抬起事件

抬起事件完全依赖于按下事件，因为只有按下才有抬起。

我们用**Input.GetKeyUp( )方法**监听抬起事件
按键抬起后，返回true，否则返回false。

```c#
 if (Input.GetKeyUp (KeyCode.W))  
            {  
                Debug.Log("您抬起了W键");  
            }  
```

### 3.1.3 长按事件

长按事件是监听某一按键是否处于一直按下的状态
通过**Input.GetKey( )**来判断键盘中某一按键是否被一直按着。

```c#
if (Input.GetKey (KeyCode.A))  
            {  
                //记录按下的帧数  
                keyFrame++;  
                Debug.Log("A连按:" + keyFrame+"帧");  
            }  
            if (Input.GetKeyUp (KeyCode.A))  
            {  
                //抬起后清空帧数  
                keyFrame=0;  
                Debug.Log("A按键抬起");  
            }     
```

### 3.1.4 任意键事件

在程序中还可以监听按键中的任意按键是否被按下

常见于加载完游戏后，按任意键进入。

```c#
if(Input.anyKeyDown)  
            {  
                Debug.Log("任意键被按下");  
            }  
```

### 3.1.4实例——组合按键

在经典的格斗游戏中，会有组合键发出牛逼的大招，而这个功能的事件思路其实不难：
在玩家按下某一键后，便开始时间记数，在某一时间内按出所需要的键便发出大招。

```c#
    using UnityEngine;  
    using System.Collections.Generic;  
    using System;  

    public class Script_07_05 : MonoBehaviour   
    {  
        //方向键上的贴图  
        public Texture imageUp;  
        //方向键下的贴图  
        public Texture imageDown;  
        //方向键左的贴图  
        public Texture imageLeft;  
        //方向键右的贴图  
        public Texture imageRight;  
        //按键成功的贴图  
        public Texture imageSuccess; 
        
        //自定义方向键的储存值  
        public const int KEY_UP = 0;  
        public const int KEY_DOWN = 1;  
        public const int KEY_LEFT = 2;  
        public const int KEY_RIGHT = 3;  
        public const int KEY_FIRT = 4;  
        
        //连续按键的事件限制  
        public const int FRAME_COUNT = 100;  

        //仓库中储存技能的数量  
        public const int SAMPLE_SIZE = 3;  

        //每组技能的按键数量  
        public const int SAMPLE_COUNT = 5;  

        //技能仓库  
        int[,] Sample =   
        {  
            //下 + 前 + 下 + 前 + 拳  
            {KEY_DOWN,KEY_RIGHT,KEY_DOWN,KEY_RIGHT,KEY_FIRT},  
            //下 + 前 + 下 + 后 + 拳  
            {KEY_DOWN,KEY_RIGHT,KEY_DOWN,KEY_LEFT,KEY_FIRT},  
            //下 + 后 + 下 + 后 + 拳  
            {KEY_DOWN,KEY_LEFT,KEY_DOWN,KEY_LEFT,KEY_FIRT},  
        };  
        //记录当前按下按键的键值  
        int  currentkeyCode =0;  
        //标志是否开启监听按键  
        bool startFrame = false;  
        //记录当前开启监听到现在的时间  
        int  currentFrame = 0;  
        //保存一段时间内玩家输入的按键组合  
        List<int> playerSample;  
        //标志完成操作  
        bool isSuccess= false;  
        void Start()  
        {  
            //初始话按键组合链表  
            playerSample  = new List<int>();  
        }  
        void OnGUI()  
        {  
            //获得按键组合链表中储存按键的数量  
            int size = playerSample.Count;  
            //遍历该按键组合链表  
            for(int i = 0; i< size; i++)  
            {  
                //将按下按键对应的图片显示在屏幕中  
                int key = playerSample[i];  
                Texture temp = null;  
                switch(key)  
                {  
                    case KEY_UP:  
                        temp = imageUp;  
                        break;  
                    case KEY_DOWN:
                        temp = imageDown;
                        break;
                    case KEY_LEFT:
                        temp = imageLeft;
                        break;
                    case KEY_RIGHT:
                        temp = imageRight;
                        break;
                }
                if(temp != null)  
                {
                    GUILayout.Label(temp);  
                }  
            }
            if(isSuccess)
            {
                //显示成功贴图
                GUILayout.Label(imageSuccess);
            }
            //默认提示信息
            GUILayout.Label("连续组合按键1：下、前、下、前、拳");
            GUILayout.Label("连续组合按键2：下、前、下、后、拳");
            GUILayout.Label("连续组合按键2：下、后、下、后、拳");
        }
        void Update ()
        {
            //更新按键
            UpdateKey();
            if(Input.anyKeyDown)
            {
                if(isSuccess)
                {
                    //按键成功后重置
                    isSuccess = false;
                    Reset();
                }
                if(!startFrame)
                {
                    //启动时间计数器
                    startFrame = true;
                }  
                //将按键值添加如链表中  
                playerSample.Add(currentkeyCode);  
                //遍历链表  
                int size = playerSample.Count;  
                if(size == SAMPLE_COUNT)  
                {  
                    for(int i = 0; i< SAMPLE_SIZE; i++)  
                    {  
                        int SuccessCount = 0;  
                        for(int j = 0; j< SAMPLE_COUNT; j++)  
                        {  
                            int temp = playerSample[j];  
                            if(temp== Sample[i,j])
                            {  
                                SuccessCount++;  
                            }  
                        }  
//玩家按下的组合按键与仓库中的按键组合相同表示释放技能成功
                        if(SuccessCount ==SAMPLE_COUNT)  
                        {  
                            isSuccess = true;  
                            break;  
                        }  
                    }  
                }  
            }  
            if(startFrame)  
            {  
                //计数器++  
                currentFrame++;  
            }  
            if(currentFrame >= FRAME_COUNT)  
            { 
                //计数器超时  
                if(!isSuccess)  
                {  
                    Reset();  
                }  
            }  
        }  
         void Reset ()  
         {  
            //重置按键相关信息  
            currentFrame = 0;  
            startFrame = false;  
            playerSample.Clear();  
         }  
        void UpdateKey() 
        {  
            //获取当前键盘的按键信息  
            if (Input.GetKeyDown (KeyCode.W))  
            {  
                currentkeyCode = KEY_UP;  
            }  
            if (Input.GetKeyDown (KeyCode.S))  
            {  
                currentkeyCode = KEY_DOWN;  
            }  
            if (Input.GetKeyDown (KeyCode.A))  
            {  
                currentkeyCode = KEY_LEFT;  
            }  
            if (Input.GetKeyDown (KeyCode.D))  
            {  
                currentkeyCode = KEY_RIGHT;  
            }  
            if (Input.GetKeyDown (KeyCode.Space))  
            {  
               currentkeyCode = KEY_FIRT;  
            }  
        }  
    }  
```


按s,d,s,d,空格：![img](./images/Unity-输入操作/20160426162352358.jpg)

## 3.2 鼠标事件

和键盘事件一样，鼠标一般只有3个按键，左键、右键和中键。

具体如下：

### 3.2.1 按下事件

`Input.GetMouseButtonDown()`
来判断鼠标哪个按键被按下：

- 返回值为0代表鼠标左键被按下
- 返回值为1代表鼠标右键被按下
- 返回值为2代表鼠标中键被按下

### 3.2.2 抬起事件

`Input.GetMouseButtonUp()`
方法监听鼠标按键的抬起事件

### 3.2.3 长按事件

`Input.GetMouseButton()`

监听鼠标某个按键是否一直处于按下状态

# 4. 在移动端输入

对于移动设备来说，Ioput类还提供了触屏、加速度计以及访问地理位置的功能。
此外，移动设备上还经常会用到虚拟键盘，即在屏幕上操作的键盘，Uity中也有相应的访问方法。

本小节专门讨论移动设备特有的输入方式。

## 4.1 多点触摸
iPhone、iPad、安卓等设备提供同时捕捉多个手指触摸操作的功能，通常可以处理最多5根手指同时触摸屏幕的情况。
通过访问Input.touches属性，可以以数组的方式处理多个手指当前的位置等信息。

安卓设备上多点触摸的规范相对灵活，不同的设备能捕捉的多点触摸操作的数量不尽相同。

- 较老的设备可能只支持1到2个点同时触摸

- 新设备可能会支持5个点同时触摸

每一个手指的触摸信息以Input.Touch结构体来表示。
**Input.Touch的属性列表：**

| 属性          | 功能                                                         |
| ------------- | ------------------------------------------------------------ |
| fingerld      | 该触摸的序号                                                 |
| position      | 触摸在屏幕上的位置                                           |
| dcllaPosition | 当前触摸位置和前一个触摸位置的差距                           |
| doltaTime     | 最近两次改变触摸位置之间的操作时间的间隔                     |
| tapCount      | IPhone/Ipad设备会记录用户短时间内单击屏幕的次数，它表示用户多次单击操作且没有将手拿开的次数。安卓设备没有这个功能，该值保持为1 |
| phase         | 触摸的阶段。可以用它来判断是刚开始触摸、触摸时移动，还是手指刚刚离开屏幕 |

phase的取值是个枚举，枚举值如下：

- Began
  手指刚接触到屏幕
- Moved
  手指在屏幕上滑动
- Stationary
  手指接触到屏幕但还未滑动
- Ended
  手指离开了屏幕。
  这个状态代表着一次触摸操作的结束
- Cancceled
  系统取滑了这次触屏操作。
  例如当用户拿起手机进行通话，或者触损点多于9个的时候，这次触摸操作就会被取消。
  这个状态也代表这次触摸操作结束

## 4.2 模拟鼠标操作
绝大部分移动设备可以用触屏模拟鼠标操作。
比如使用Input.mousePosition属性不仅可以获得鼠标光标的位置，也可以获得移动设备上触摸的位置。
这个功能的原理不难理解，毕竟触屏可以支持多点触摸，而鼠标则是单点操作，这个功能属于向下兼容。

在移动平台的游戏的开发阶段可以暂时用鼠标操作代替触屏操作，但是稍后应当修改为触屏专用的方式，因为操作手感和功能会有很大区别。

## 4.3 加速度计
当移动设备移动时，内置的加速度计会持续报告当前加速度的值，这个值是一个三维向量，因为物体的运动是任意方向的。
这个数值和重力加速度的表示方法类似：

- 在某个轴方向上，1.0代表该轴具有+1.0g的加速度

- 而负值则代表该轴具有相反方向的加速度。

正常竖直持手机(Home键在下方)时：

- X轴的正方向朝右

- Y轴的正方向朝上

- Z轴的正方向从手机指向用户

通过Input.aceleation属性可以直接访问加速度计当前的数值。
