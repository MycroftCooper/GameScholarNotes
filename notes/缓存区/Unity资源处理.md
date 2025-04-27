---
title: WPF-MVVC
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags: 
category: 缓存区
note status: 草稿
---


# 1. 简介

实际的游戏开发中，其实有相当一部分静态数据是可以放在客户端的。
所以势必会产生要动态读取这些文件的需求，比如csv（其实就是文本文件），xml等等。

做unity3d开发时，都一定要先在editor中去实现基本的功能，再具体到各个移动平台上去调试。
所以作为要读取外部文件的第一步，显然我们要先在editor也就是pc上实现这个功能。

既然是用Unity3D来开发游戏，那么自然要使用Unity3D规定的操作方式，而不是我们在PC上很原始的那种操作方式来操作。

否则就会写出移动端无法使用的很傻的代码来。

# 2. 资源处理分类

Unity中的资源资源的处理种类大致分为：Resources、StreamingAssets、AssetBundle、PersistentDataPath 四类。

## 2.1 Resources

是作为一个Unity的保留文件夹出现的，也就是如果你新建的文件夹的名字叫Resources，那么里面的内容在打包时都会被无条件的打到发布包中。

### 2.1.1 特点

- 只读，即不能动态修改。所以想要动态更新的资源不要放在这里。
- 会将文件夹内的资源打包集成到.asset文件里面。因此建议可以放一些Prefab，因为Prefab在打包时会自动过滤掉不需要的资源，有利于减小资源包的大小。
- 资源读取使用Resources.Load()。

### 2.1.2 使用方法

#### 2.1.2.1 加载

- Resources.Load
  加载Resources目录的一个asset
- Resources.LoadAsync
  Resources.Load的异步方法
- Resources.LoadAll
  类似Resources.Load，但是用于加载某目录下所有asset
- Resources.LoadAssetAtPath
  加载Asset/目录下的资源，只能用于编辑器模式，写打包工具时可能用到

Resources类只能加载Resources文件夹下的资源，若出现嵌套，都会加载

Resources加载资源时应使用相对路径，且不包含扩展名。
如 Resources.Load\<Texture2D\>("images/texture1"); 

> 建议在Assets下放一个Resource文件夹就好；

#### 2.1.2.2 卸载资源：

- Resources.UnloadAsset(Object assetToUnload)
  卸载指定的asset，只能用于从磁盘加载的；
  如果场景中有此asset的引用，Unity会自动重新加载它，CPU开销小。
- Resources.UnloadUnusedAssets
  卸载所有未被引用的asset，可以在画面切换时调用，或定时调用释放全局未使用资源。
  被脚本的静态变量引用的资源不会被卸载。
  尽量避免在游戏进行中调用，因为该接口开销较大，容易引起卡顿
  可尝试用Resources.Unload(obj)逐个卸载，保证游戏的流畅度。

### 2.1.3 案例

需要新建一个Resources目录，并且并将资源放在这目录中。
使用Resources.Load(Path)静态方法加载该目录路径下的资源。

示例：

![image-20210617174912162](./attachments/Unity资源处理/7b64fd2b.png)

```c#
using UnityEngine; 
using System.Collections; 
public class LoadResources : MonoBehaviour 
{ 	
	public Image image; 	
	void Start () 
	{  
		string str = Resources.Load ("Text").ToString(); 
	}
} 
```

## 2.2 StreamingAssets

StreamingAssets和Resources很像。
同样作为一个只读的Unity3D的保留文件夹出现。

不过两者也有很大的区别。
那就是Resources文件夹中的内容在打包时会被压缩和加密。
而StreamingAsset文件夹中的内容则会原封不动的打入包中，因此StreamingAssets主要用来存放一些二进制文件。

### 2.2.1 特点

- 只读不可写。
- 主要用来存放二进制文件。
- 只能用过WWW类来读取。

### 2.2.2 使用方法

首先我们新建一个StreamingAssets目录，并且并将资源放在这目录中。

> StreamingAssets文件夹内的东西并不会被压缩和加密，放进去什么就是什么
> 所以一般是要放二进制文件的
> 在实际操作中切记不要直接把数据文件放到这个目录中打包

示例：

![image-20210617175047000](./attachments/Unity资源处理/87411299.png)

```c#
using UnityEngine; 
using System.Collections; 
public class LoadResources : MonoBehaviour 
{ 	
    string _result;  
    Start () 
    {  	
        StartCoroutine(LoadXML());  
    }  
    IEnumerator LoadXML() 
    { 	
        string sPath= Application.streamingAssetsPath + "/Test.xml"; 	
        WWW www = new WWW(sPath); 	
        yield return www; 	
        _result = www.text; 
    } 
} 
```

## 2.3 AssetBundle

AssetBundle就是把prefab或者二进制文件封装成AssetBundle文件。



### 2.3.1 生存周期

![image-20210617180330593](./attachments/Unity资源处理/41d72498.png)

1.Unity 在使用 WWW 方法时会分配一系列的内存空间来存放 WWW 实例对象、 WebStream 数据。该数据包括原始的 AssetBundle 数据、解压后的 AssetBundle 数据以及一个用于解压的 Decompression Buffer 。（一般情况下， Decompression Buffer 会在原始的 AssetBundle 解压完成后自动销毁，但需要注意的是， Unity 会自动保留一个 Decompression Buffer ，不被系统回收，这样做的好处是不用过于频繁的开辟和销毁解压 Buffer ，从而在一定程度上降低 CPU 的消耗。）
    
2.当把AssetBundle 解压到内存后，可以使用WWW .assetBundle属性来获取AssetBundle 对象，从而可以得到各种Asset，进而对这些Assets进行加载或者实例化操作。加载过程中，Unity 会将AssetBundle 中的数据流转变为引擎可以识别的信息类型(纹理、材质、对象等)。加载完成后，开发者可以对其进行进一步的操作，比如对象的实例化、纹理和材质的复制和替换等。

更新：

游戏一开始运行时，通过文件里面记录的版本号，和服务器上文件中的版本号比对。如果本地版本号低，下载对应的AB包到可读写目录，并对本地资源进行替换，这样进入游戏中加载的就是新下载的AB包资源。

更新流程如下：

       1.  将更新包资源(安装包中的资源)复制到可读写目录下
       2.  复制完成开始比对哈希文件,开始更新资源
       3.  下载添加资源,替换旧资源,删除原来可读写目录下的无用资源
       4.  初始化assetbundle依赖关系
       5.  完成整个流程

更新注意：

       1.  要有下载失败重试几次机制；
       2.  要进行超时检测；
       3.  要记录更新日志，例如哪几个资源时整个更新流程失败。
### 2.3.1 特点

- 是Unity3D定义的一种二进制类型。
- 使用WWW类来下载。

### 2.3.2 使用方法

这里就和上面两个不一样了。

首先我们要把我们的文件Test.xml打成AssetBundle文件，由于本案例AssetBundle的平台选择为Andorid。

如图，我们创建了一个AssetBundle文件，并命名为TextXML。
并且按照二进制文件放入StreamingAssets文件夹中的惯例，将这个AssetBundle文件放入StreamingAssets文件夹。

![image-20210617175300313](./attachments/Unity资源处理/0a1b6978.png)

下面是从AssetBudle中读取Test.xml的代码：

```c#
using EggToolkit;
using System.Xml.Linq;
using System.Xml;
using System.IO;
public class Test : MonoBehaviour {
	private string _result;
	void Start () 
    {
		LoadXML();
	}
	void LoadXML()
	{
		AssetBundle AssetBundleCsv = new AssetBundle();
		//读取放入StreamingAssets文件夹中的bundle文件
		string str = Application.streamingAssetsPath + "/" + "TestXML.bundle";
		WWW www = new WWW(str);
		www = WWW.LoadFromCacheOrDownload(str, 0);	
		AssetBundleCsv = www.assetBundle;
		string path = "Test";
		TextAsset test = AssetBundleCsv.Load(path, typeof(TextAsset)) as TextAsset;
		_result = test.ToString();
	}
}
```

## 2.4 PersistentDataPath

这个路径下是可读写。
而且在IOS上就是应用程序的沙盒，但是在Android可以是程序的沙盒，也可以是sdcard。
并且在Android打包的时候，ProjectSetting页面有一个选项Write Access，可以设置它的路径是沙盒还是sdcard。

### 2.4.1 特点

- 内容可读写，不过只能运行时才能写入或者读取。 **提前将数据存入这个路径是不可行的**。
- 无内容限制。你可以从 StreamingAsset 中读取二进制文件或者从 AssetBundle 读取文件来写入 PersistentDataPath 中。
- 写下的文件，可以在电脑上查看。同样也可以清掉。
- 需要使用WWW类来读取。

### 2.4.2 使用方法

之前我们说过，内容可读写，不过只能运行时才能写入或者读取。 **提前将数据存入这个路径是不可行的**。也就是说，PersistentDataPath是在运行时生成的，例如通过网络下载资源存在放PersistentDataPath中。

示例：

```c#
using UnityEngine; 
using System.Collections; 
public class LoadResources : MonoBehaviour 
{ 	
    string _result; 	
    Start () 
    {  	
        StartCoroutine(LoadXML());  
    }  
    IEnumerator LoadXML() 
    { 	
        string sPath= Application.persistentDataPath + "/test.xml"; 	
        sPath = "file://" + sPath; 	WWW www = new WWW(sPath); 	
        yield return www; 	
        _result = www.text; 	
    } 
} 
```

这加载方式看起来与StreamingAssets很相识，但是注意这里多了行`sPath = "file://" + sPath;`
这很重要！！

想要通过WWW类加载PersistentDataPath必须使用**file://**协议实现加载。

# 3. 各平台下的资源路径

想读取文件就必须找到文件所在的目录，我们先来了解一下Unity下各个资源路径的特点和在各平台下资源路径的存放位置吧。

## 3.1 Unity3D中的资源路径

| 路径属性                        | 路径说明                                                     |
| :------------------------------ | :----------------------------------------------------------- |
| Application.dataPath            | 此属性用于返回程序的数据文件所在文件夹的路径。例如在Editor中就是Assets了。 |
| Application.streamingAssetsPath | 此属性用于返回流数据的缓存目录，返回路径为相对路径，适合设置一些外部数据文件的路径。放在Unity工程StreamingAssets文件夹中的资源发布后都可以通过这个路径读取出来。 |
| Application.persistentDataPath  | 此属性用于返回一个持久化数据存储目录的路径，可以在此路径下存储一些持久化的数据文件。 |
| Application.temporaryCachePath  | 此属性用于返回一个临时数据的缓存目录。                       |

## 3.2 android平台

| 路径属性                        | 路径                                          |
| :------------------------------ | :-------------------------------------------- |
| Application.dataPath            | /data/app/xxx.xxx.xxx.apk                     |
| Application.streamingAssetsPath | jar:file:///data/app/xxx.xxx.xxx.apk/!/assets |
| Application.persistentDataPath  | /data/data/xxx.xxx.xxx/files                  |
| Application.temporaryCachePath  | /data/data/xxx.xxx.xxx/cache                  |

## 3.3 ios平台

| 路径属性                        | 路径                                                         |
| :------------------------------ | :----------------------------------------------------------- |
| Application.dataPath            | Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/xxx.app/Data |
| Application.streamingAssetsPath | Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/xxx.app/Data/Raw |
| Application.persistentDataPath  | Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/Documents   |
| Application.temporaryCachePath  | Application/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/Library/Caches |

# 4. 参考

本文90%的内容都是参考：
http://www.tuicool.com/articles/qMNnmm6

https://blog.csdn.net/jfy307596479/article/details/84975736
