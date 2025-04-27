---
title: MarkDown快速入门
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 语言
  - markdown
category: 公共空间
note status: 终稿
---


# 简介

.md即markdown文件的基本常用编写语法,是一种快速标记、快速排版语言。

本博客中的所有文章都是用.md文件编写的，而且很多企业也在在鼓励使用这种编辑方式。

# 1.基本符号：* - +. >

基本上所有的markdown标记都是基于这四个符号或组合，需要注意的是，如果以基本符号开头的标记，注意基本符号后有一个用于分割标记符和内容的空格。

# 2.标题

分别表示h1-h6,只到h6，而且h1下面会有一条横线。

有两种方法，一种是只在前面加#，另一种是闭合式标签，两者效果相同。

例如：

方法一：

```markdown
# 一级标题 
## 二级标题 
### 三级标题 
#### 四级标题 
##### 五级标题 
###### 六级标题
```

方法二：

```markdown
# 一级标题 # 
## 二级标题 ## 
### 三级标题 ### 
#### 四级标题 #### 
##### 五级标题 ##### 
###### 六级标题 #####
```

效果如下：

# 一级标题

## 二级标题

### 三级标题 
#### 四级标题 
##### 五级标题 
###### 六级标题

# 3.列表

## 3.1 无序列表

```markdown
//形式一 
+ a 
+ b 
+ c 
//形式二
- d 
- e 
- f 
//形式三 
* g 
* h 
* i
```

以上三种形式，效果其实都是一样的：

+ a 
+ b 
+ c 
- d 
- e 
- f 
* g 
* h 
* i

## 3.2 有序列表
```markdown
//正常形式
1. abc
2. bcd
3. cde
//错序效果
2. fgh
3. ghi
5. hij
```
效果如下：
1. abc

2. bcd

3. cde

   

4. fgh

5. ghi

6. hij

> 注意，数字后面的点只能是英文的点，有序列表的序号是根据第一行列表的数字顺序来的，错序列表的序号本来是序号是乱的， 但是还是显示 4 5 6

# 4.引用说明区块

对某个部分做的内容做一些说明或者引用某某的话等，可以用这个语法。

## 4.1 正常形式

```markdown
> 引用内容、说明内容。
在语句前面加一个 > ，注意是英文的那个右尖括号，注意空格，引用因为是一个区块，理论上是应该什么内容都可以放，比如说：标题，列表，引用等等。
```

效果如下：

> 引用内容、说明内容。
> 在语句前面加一个 > ，注意是英文的那个右尖括号，注意空格，引用因为是一个区块，理论上是应该什么内容都可以放，比如说：标题，列表，引用等等。

## 4.2 嵌套区块

这里我只介绍一下我常用的方法，也是个人认为比较规范的一种方法，就是给区块的下一级区块多加一个右尖括号：

```markdown
> 一级引用 
>> 二级引用 
>>> 三级引用 
>>>> 四级引用 
>>>>> 五级引用 
>>>>>> 六级引用
```

效果如下：

> 一级引用 
> > 二级引用 
> > > 三级引用 
> > > > 四级引用 
> > > > > 五级引用 
> > > > >
> > > > > > 六级引用

# 5. 代码块

在发布一些技术文章会涉及展示代码的问题，这时候代码块就显得尤为重要。

## 5.1 少量代码，单行使用，直接用`包裹起来就行了

```markdown
 `shaoliangdaima,danhangshiyong` 
```

效果如下：

`shaoliangdaima,danhangshiyong`

## 5.2大量代码，需要多行使用，用```包裹起来
```markdown
​```
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong    
daliangdaima,xuyaoduohangshiyong   
​```
```

效果如下：

```
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong     
daliangdaima,xuyaoduohangshiyong    
daliangdaima,xuyaoduohangshiyong   
```

# 6.链接

## 6.1行内式

链接的文字放在[]中，链接地址放在随后的()中，链接也可以带title属性，链接地址后面空一格，然后用引号引起来。

```markdown
[烤麸的博客](https://mycroftcooper.github.io/"烤麸的博客"), 是烤麸自己学习用的博客
```

## 6.2参数式

链接的文字放在[]中，链接地址放在随后的:后，链接地址后面空一格，然后用引号引起来。

```markdown
[烤麸的博客]: https://mycroftcooper.github.io/"烤麸的博客" 
[烤麸的博客]是烤麸自己学习用的博客。 
//参数定义的其他写法 
[烤麸的博客]: https://mycroftcooper.github.io/ '烤麸的博客' 
[烤麸的博客]: https://mycroftcooper.github.io/ (烤麸的博客) 
[烤麸的博客]: <https://mycroftcooper.github.io/> "烤麸的博客"
```

以上两种方式其效果都是一样的，如下：

[烤麸的博客](https://mycroftcooper.github.io/"烤麸的博客"), 是烤麸自己学习用的博客

# 7.图片

## 7.1 行内式

和链接的形式差不多，图片的名字放在[]中，图片地址放在随后的()中，title属性（图片地址后面空一格，然后用引号引起来）
> 注意的是[]前要加上!

```markdown
![markdown快速入门示例图.png](/markdown快速入门/markdown快速入门示例图.png "markdown快速入门示例图.png")
```
## 7.2 参数式

图片的文字放在[]中，图片地址放在随后的:后，title属性（图片地址后面空一格，然后用引号引起来）,注意引用图片的时候在[]前要加上!

```markdown
[markdown快速入门示例图.png]: /markdown快速入门/markdown快速入门示例图.png "markdown快速入门示例图.png" ![markdown快速入门示例图.png] 
```

以上两种方式其效果图都是一样的，如下：

![markdown快速入门示例图](attachments/notes/公共空间/MarkDown快速入门/IMG-20250428024422310.png)

# 8. 分割线

分割线可以由* - _（星号，减号，底线）这3个符号的至少3个符号表示，注意至少要3个，且不需要连续，有空格也可以

```markdown
--- - - - ------ *** * * * ****** ___ _ _ _ ______
```

以上代码的效果均为：

---

# 9. 其他

## 9.1 强调字体

一个星号或者是一个下划线包起来，会转换为<em>倾斜，如果是2个，会转换为<strong>加粗

```markdown
*md*   **md** _md_   __md__
```

效果：
*md*   
**md** 
_md_ 
__md__

## 9.2 转义

基本上和js转义一样,\加需要转义的字符

```markdown
\\ 
\* 
\+ 
\- 
\` 
\_
```

## 9.3 删除线

用~~把需要显示删除线的字符包裹起来

```markdown
~~删除~~
```

效果：

~~删除~~

# 十、表格

```markdown
//例子一 
|123|234|345| 
|:-|:-:|-:| 
|abc|bcd|cde| 
|abc|bcd|cde| 
|abc|bcd|cde| 
//例子二 
|123|234|345| 
|:---|:---:|---:| 
|abc|bcd|cde| 
|abc|bcd|cde| 
|abc|bcd|cde| 
//例子三 
123|234|345 
:-|:-:|-: 
abc|bcd|cde 
abc|bcd|cde 
abc|bcd|cde
```

上面三个例子的效果一样，由此可得：

1. 表格的格式不一定要对的非常起，但是为了良好的变成风格，尽量对齐是最好的

2. 分割线后面的冒号表示对齐方式，写在左边表示左对齐，右边为右对齐，两边都写表示居中

效果如下：

| 123  | 234  |  345 |
| :--- | :--: | ---: |
| abc  | bcd  |  cde |
| abc  | bcd  |  cde |
| abc  | bcd  |  cde |

整理自：https://www.jianshu.com/p/399e5a3c7cc5
