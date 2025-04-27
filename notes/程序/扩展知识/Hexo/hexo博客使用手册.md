---
title: hexo博客使用手册
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - hexo
category: 程序/扩展知识/Hexo
note status: 终稿
---


# 1. 简介

本篇文章是关于hexo框架下博客的使用方法总结，以便更好的学习与使用博客整理笔记。

# 2. 写作

要创建新帖子或新页面，可以运行以下命令：

```bash
$ hexo new [layout] "title"
```

其中`[layout]`是可选参数`布局`，`布局`分为以下几种：

| 布局  | 保存路径       | 用途       |
| :---- | :------------- | ---------- |
| post  | source/_posts  | 创建新文章 |
| page  | source         | 创建新页面 |
| draft | source/_drafts | 创建新草稿 |

该指令可以增加附加选项：

| 选项               | 描述                          |
| :----------------- | :---------------------------- |
| `-p`， `--path`    | 发布路径。自定义帖子的路径。  |
| `-r`， `--replace` | 替换当前帖子（如果存在）。    |
| `-s`， `--slug`    | 文章缩略名，自定义帖子的URL。 |

例如：

```bash
$ hexo new page --path about/me "About me"
```

## 2.1 文档名称

默认情况下，Hexo使用帖子标题作为其文件名。您可以在`_config.yml`中编辑`new_post_name`设置以更改默认文件名。

例如，`:year-:month-:day-:title.md`在文件名前加上创建日期。

您可以使用以下占位符：

| 占位符     | 描述                               |
| :--------- | :--------------------------------- |
| `:title`   | 帖子标题（小写，空格用连字符代替） |
| `:year`    | 创建年份，例如 `2015`              |
| `:month`   | 创建的月份（前导零），例如 `04`    |
| `:i_month` | 创建的月份（无前导零），例如 `4`   |
| `:day`     | 创建日期（前导零），例如 `07`      |
| `:i_day`   | 创建日期（无前导零），例如 `7`     |

## 2.2 文档头

当新建.md文档后，打开文档可以看见如下文件头：

```markdown
title: hexo博客使用手册
date: 2021-02-18 14:11:04
tags: 博客使用手册
categories: 博客使用手册
```
| 参数          | 描述                       |
| :------------ | :------------------------- |
| `title:`      | 帖子标题                   |
| `date:`       | 创建日期                   |
| `tags:`       | 帖子所属标签               |
| `categories:` | 帖子所属分类(需要手动添加) |

当想要新增标签与分类时，直接创建新的文档后在文件头填写参数即可。

多个标签时使用：
```
tags:  

	- [tag1]

	- [tag2]
```
含父子分类时，将父类写在前，子类写在后:
```
categories: 
	- [categorie1]
	- [categorie2]
```


## 2.3 添加图片

关于图片和图片路径的设置，有以下教程。

事先声明，所有博客文件均保存在 `hexo/_posts/`文件夹下

首先在 `hexo > source`目录下建一个文件夹叫images，用来保存博客中的图片。

然后打开Typora的 `文件 > 偏好设置`，进行如下设置。

![插入图片设置](attachments/notes/程序/扩展知识/Hexo/hexo博客使用手册/IMG-20250428025106029.png)

这样的话所有的博客中的图片都将会保存到 `/source/images/该博客md文件名/图片名称`

但是仅仅这样设置还不够，这样设置在typora中倒是能看图片了，但是使用的却是相对于当前md文件的相对路径，可是如果启动hexo，是要用服务器访问的，而服务器显然无法根据这个相对路径正确访问到图片，因此还需要在typora中进行进一步设置。

在typora菜单栏点击 `格式->图像->设置图片根目录`，将`hexo/source`作为其根目录即可。

**一定要先设置了图片根目录后再插入图片，否则图片路径会不正确喔！**

## 2.4 草稿

`draft`布局初始化的帖子将保存到该`source/_drafts`文件夹中。

您可以使用`publish`命令将草稿移至`source/_posts`文件夹。

`publish`命令与`new`命令相似。

```bash
$ hexo publish [layout] <title>
```

默认不显示草稿。

您可以在运行Hexo时添加选项`--draft`，也可以在`_config.yml`中启用`render_drafts`设置以渲染草稿。

```bash
$ hexo --draft
```
显示草稿（存储在`source/_drafts`文件夹中）。


## 2.5 模板

创建帖子时，Hexo将基于文件`scaffolds`夹中的相应模板文件来构建文件。
例如：

```bash
$ hexo new photo "My Gallery"
```

当您运行此命令时，Hexo将尝试在`scaffolds`文件夹中查找`photo.md`，并基于该文件构建帖子。模板中提供以下占位符：

| 占位符   | 描述         |
| :------- | :----------- |
| `layout` | 布局         |
| `title`  | 标题         |
| `date`   | 文件创建日期 |

## 2.6 支持的格式

只要安装了相应的渲染器插件，Hexo支持帖子就可以以任何格式编写。、

本博客支持的编写格式：`markdown`，`ejs`。

# 3. 服务器指令

## 3.1 init 安装指令

```bash
$ hexo init [folder]
```

将hexo框架文件安装到当前/指定文件夹内。

## 3.2 server 本地服务器启动指令

```bash
$ hexo server 或 $ hexo s
```

启动本地服务器。默认情况下，该位置为`http://localhost:4000/`。

| 选项              | 描述                         |
| :---------------- | :--------------------------- |
| `-p`， `--port`   | 覆盖默认端口                 |
| `-s`， `--static` | 仅提供静态文件               |
| `-l`， `--log`    | 启用记录器。覆盖记录器格式。 |

## 3.3 deploy 部署指令

```bash
$ hexo deploy 或 $ hexo d
```

部署您的网站。

| 选项                | 描述       |
| :------------------ | :--------- |
| `-g`， `--generate` | 部署前生成 |

## 3.4 clean 清除缓存指令

```bash
$ hexo clean 
```

清除缓存文件（`db.json`）和生成的文件（`public`）。

## 3.5 version查看版本指令

```bash
$ hexo version 或 $ hexo v
```

显示版本信息。

## 3.6 选项

### 3.6.1 安全模式

```bash
$ hexo --safe
```

禁用加载插件和脚本。如果在安装新插件后遇到问题，请尝试此操作。

### 3.6.2 调试模式

```bash
$ hexo --debug
```

将详细消息记录到终端和`debug.log`。如果遇到Hexo任何问题，请尝试此操作。如果看到错误，请[提出GitHub问题](https://github.com/hexojs/hexo/issues/new)。

### 3.6.3 静音模式

```bash
$ hexo --silent
```

静音输出到终端。

### 3.6.4 自定义配置文件路径

```bash
$ hexo --config custom.yml
```

使用自定义配置文件（而不是`_config.yml`）。

还接受以逗号分隔的JSON或YAML配置文件列表，该列表会将文件合并为一个`_multiconfig.yml`。

```bash
$ hexo --config custom.yml，custom2.json
```

### 3.6.5 自定义CWD

```bash
$ hexo --cwd / path / to / cwd
```

自定义当前工作目录的路径。
