---
title: Electron-桌面程序开发框架
author: MycroftCooper
created: 2025-04-27 23:32
lastModified: 2025-04-27 23:32
tags:
  - 程序
  - Electron
  - 工具
category: 程序/扩展知识
note status: 草稿
---
# 1. 什么是 Electron？

一句话解释：Electron 是一个可以用 **前端技术（HTML/CSS/JavaScript）开发桌面应用程序** 的框架。

它**把 Chrome 浏览器 + Node.js 打包到了一起**，然后：

- 用 Chrome 来渲染界面（前端技术）
- 用 Node.js 来访问本地文件、操作系统（后端能力）

所以，Electron应用：

- 可以像网页一样写界面
- 又可以像本地程序一样，读写文件、操作磁盘、调用本地 API

**简单说，Electron = 浏览器 + 后端 = 桌面应用开发神器**

**Electron的语言支持:**

| 语言                | 用来做什么                                     |
| ------------------- | ---------------------------------------------- |
| **HTML**            | 负责页面结构                                   |
| **CSS**             | 负责页面样式                                   |
| **JavaScript**      | 负责页面逻辑、应用逻辑、操作系统逻辑           |
| (可选) TypeScript   | 如果想要更强的类型检查，Electron也支持         |
| (可选) 其他前端框架 | 你可以搭配 Vue、React、Svelte 等来写更大的项目 |

**总结一句话：** 主要就是**JavaScript + HTML + CSS**。

# 2. 环境搭建

**第1步：初始化项目**

首先，咱们在本地建一个新项目文件夹,然后打开终端（或者VSCode Terminal）：

```bash
cd 你的项目目录
npm init -y
```

这一步生成一个最基本的 `package.json` 文件。

✅ 完成之后，目录里应该有一个 `package.json` 文件了。

**第2步：安装 Electron**

在同一个目录下运行：

```bash
npm install electron --save-dev
```

✅ 这样我们就把 Electron 装到了本地，而不是全局安装，便于版本管理。

检查一下 `package.json`，应该多了：

```json
"devDependencies": {
  "electron": "^版本号"
}
```

**第3步：搭建基础目录结构**

项目目录应该是这样：

```
project-folder/
├─ main.js          # 主进程入口
├─ preload.js       # (可选) 预加载脚本
├─ renderer/        # 渲染进程页面资源
│  ├─ index.html
│  ├─ renderer.js
├─ package.json
├─ .vscode/         # 调试配置
└─ node_modules/
```

✅ 创建好空的 `main.js`、`preload.js`、`renderer/index.html`、`renderer/renderer.js` 文件。

**第4步：编写基础代码**

🔹 main.js

```js
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: true,   // 注意：开发阶段先开着，后面学到安全性再处理
      contextIsolation: false,
      devTools: true
    }
  });

  win.loadFile('renderer/index.html');
  win.webContents.openDevTools();
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
```

🔹 preload.js

```js
// 这里暂时先留空，后面通信部分会加上
```

🔹 renderer/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Electron App</title>
</head>
<body>
  <h1>Hello Electron!</h1>
  <script src="renderer.js"></script>
</body>
</html>
```

🔹 renderer/renderer.js

```js
console.log("Renderer process started!");
```

**第5步：配置 npm scripts**

打开 `package.json`，添加一段：

```js
"scripts": {
  "dev": "electron ."
}
```

✅ 这样以后就可以直接 `npm run dev` 启动 Electron，而不用自己敲 `npx electron .`

**第6步：配置 VSCode 断点调试**

现在我们来配置 `.vscode/launch.json` 文件：

1. 在 VSCode 里，点左边的“运行和调试”面板。
2. 选择 “创建 launch.json” -> 选 Node.js 类型。
3. 填写为：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Electron Main Process",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/main.js",
      "runtimeExecutable": "${workspaceFolder}/node_modules/.bin/electron",
      "windows": {
        "runtimeExecutable": "${workspaceFolder}/node_modules/.bin/electron.cmd"
      },
      "cwd": "${workspaceFolder}",
      "outFiles": [
        "${workspaceFolder}/**/*.js"
      ],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

✅ 配置好以后，**你可以在 `main.js` 里打断点，直接 F5 调试运行！**

**第7步：启动测试**

现在可以试试：

- **在 `main.js` 里任意地方打个断点**（比如 `createWindow()` 里）
- 按 F5 或点击 "启动调试"
- 应该 Electron 窗口能正常启动
- 应该到断点时能停下来！

另外，在 Electron 窗口打开后：

- 按 `Ctrl+Shift+I`
- 打开 DevTools
- 在 Sources 面板看到 `renderer.js`
- 可以打断点调试前端页面逻辑

✅ 完成！

# 3. Electron 项目的基本架构

## 3.1 主进程与渲染进程

### 主进程
就是 Electron 程序的 **大脑**，它负责：

- 创建窗口
- 监听程序生命周期（比如程序启动、退出）
- 调用 Node.js 的能力（比如访问文件系统）
- 管理多个窗口之间的通讯
- 控制整个应用的行为

🧠 **你可以理解成 “后端/操作系统管理者”。**

主进程对应的通常是你的 `main.js` 文件。

### 渲染进程
就是 **每一个 Electron 窗口里跑的前端页面**。

比如：

- 一个 `BrowserWindow` 就是一个渲染进程
- 渲染进程里就像浏览器页面，跑的是 HTML + CSS + JS

🖥️ **你可以理解成 “前端界面”**。

**每个窗口**都是一个独立的渲染进程（互不干扰）。

| 项目     | 主进程                       | 渲染进程                       |
| -------- | ---------------------------- | ------------------------------ |
| 角色     | 管理员                       | 页面                           |
| 运行内容 | Node.js 脚本                 | 网页 (HTML/CSS/JS)             |
| 控制对象 | 整个应用                     | 单个窗口的界面                 |
| 能力     | Node.js 能力、系统 API       | 前端操作（部分可以用 Node.js） |
| 例子     | 创建 BrowserWindow，监听退出 | 显示按钮、处理用户输入         |

### 主进程和渲染进程之间的通信

在 Electron 里，**主进程**（Main）和**渲染进程**（Renderer）
 本质上是**两个独立的进程**，所以它们之间不能直接互相调用代码。

为了通信，Electron 提供了**专门的机制**：
 **IPC（Inter-Process Communication，进程间通信）**

Electron的官方模块是：

| 模块          | 用途             |
| ------------- | ---------------- |
| `ipcMain`     | 主进程监听消息   |
| `ipcRenderer` | 渲染进程发送消息 |

**也就是说：**

- 渲染进程用 `ipcRenderer.invoke()` 向主进程发消息
- 主进程用 `ipcMain.on()` 收到消息
- 反过来，主进程可以用 `event.reply()` 回复渲染进程

#### preload.js

**preload.js 是起“中间人”的作用**！

- 你可以在 preload.js 里使用 **Node.js API + ipcRenderer**
- 然后把需要的能力，**通过安全的 API**挂到渲染进程的 `window` 上
- 这样**渲染进程就不用直接接触 ipcRenderer 和 Node.js 了**，更安全！

所以，preload.js 是：

- 连接 渲染进程 和 主进程 的桥梁
- 把 ipcRenderer 包起来，防止渲染进程滥用

**示例：**

1. **渲染进程 --> preload.js --> 主进程**

在 `preload.js` 里暴露安全方法：

```js
const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('myAPI', {
  readFile: (path) => ipcRenderer.invoke('read-file', path),
});
```

2. **主进程 main.js 里监听**

```js
const { ipcMain } = require('electron');
const fs = require('fs');

ipcMain.handle('read-file', async (event, path) => {
  const content = fs.readFileSync(path, 'utf-8');
  return content;
});
```

3. **渲染进程使用**

在 `renderer.js` 里调用：

```js
async function readFileContent() {
  const content = await window.myAPI.readFile('somefile.txt');
  console.log(content);
}
```

**为什么要 preload?**

- **不建议直接在渲染进程用 ipcRenderer.send**，因为渲染进程是可以被网页攻击的（跨站脚本攻击）。
- 正确做法是用 preload.js 暴露有限的、安全的API，防止渲染进程能乱调用系统API。

✅preload.js 是 **主进程运行的脚本**，但**在渲染进程的上下文中提前注入变量**。
 这样能让渲染页面只拿到“过滤后的安全功能”。

## 3.2 项目结构

标准一个简单的 Electron 项目，通常长这样：

```bash
project-folder/
├─ main.js          # 主进程入口
├─ preload.js       # (可选)预加载脚本，注入给渲染进程用
├─ renderer/        # 渲染进程页面资源
│  ├─ index.html    # 界面 HTML
│  ├─ renderer.js   # 界面逻辑
├─ modules/         # 你的业务逻辑模块
├─ package.json     # npm包管理，定义 Electron 版本和启动脚本
├─ .vscode/         # 调试配置
├─ node_modules/    # 依赖库
```

各部分的作用：

| 目录/文件      | 作用                                           |
| -------------- | ---------------------------------------------- |
| `main.js`      | 负责启动 Electron 应用，管理窗口、监听事件     |
| `preload.js`   | （可选）在渲染进程加载前，提前注入安全接口     |
| `renderer/`    | 界面显示和界面逻辑（渲染进程代码）             |
| `modules/`     | 存放封装的工具模块，比如处理图片、处理 YAML 等 |
| `package.json` | 定义应用信息、依赖、Electron版本、启动命令等   |

启动 Electron 应用后，它的流程大概是这样的：

1. 运行 `main.js` （主进程启动）
2. `main.js` 创建一个新的 `BrowserWindow`
3. `BrowserWindow` 加载你的 `index.html`
4. `index.html` 里运行 `renderer.js` （渲染进程逻辑）
5. 如果有 `preload.js`，在渲染进程开始之前注入特定的 Node.js 能力（防止直接暴露 Node）
6. 主进程监听窗口关闭、应用退出等等事件
7. 渲染进程响应用户操作，比如按钮、输入框

### Electron架构与MVC

| 层                           | 作用               | 类似传统MVC里哪个角色 |
| ---------------------------- | ------------------ | --------------------- |
| 主进程（Main Process）       | 应用管理，像“后端” | Model / Controller    |
| 渲染进程（Renderer Process） | 页面展示、交互     | View / Controller     |

可以这么分：

- **Model**：放在主进程 / modules 里，比如：
  - 文件管理（fileService）
  - 配置管理（configService）
  - 网络通信（networkService）
- **View**：放在渲染进程的 HTML + CSS + JS 页面，比如：
  - 按钮、列表、弹窗、界面布局
- **Controller**：
  - 主进程管理应用行为（打开窗口、关闭窗口）
  - 渲染进程管理用户操作（点击按钮 -> 调用 preload 暴露的 API）

### 代码分类

| 代码类型          | 属于什么进程？   | 典型文件                          |
| ----------------- | ---------------- | --------------------------------- |
| 主进程代码        | Main Process     | main.js                           |
| 预加载脚本        | Preload Script   | preload.js                        |
| 渲染进程页面代码  | Renderer Process | renderer/index.html + renderer.js |
| 动态require的模块 | 由调用位置决定   | modules/*.js                      |

# 4.调试方法

## 4.1 主进程代码（main.js）

**特点：**

- 主进程就是 Node.js 运行的进程
- 完全可以直接用 **VSCode内置调试器**断点调试

**打断点方法：**

- 配置 `.vscode/launch.json`
- `type: node`
- `program: main.js`
- 按 `F5` 启动，直接在 VSCode 打断点，100%生效。

✅ 主进程调试 = **和普通 Node.js 项目一模一样**

## 4.2 预加载脚本（preload.js）

**特点：**

- preload.js 是在**主进程创建 BrowserWindow 时运行**的
- 但是执行环境是**渲染进程的上下文**

**打断点方法：**

- **如果 preload.js 是用 `require` 加载的**，可以在 VSCode直接断点！
- preload 里跑的逻辑，最好配合 DevTools 也能看（因为是注入到页面里的）

**小细节补充：**

- preload 本质上是 **主进程打包渲染前**提前执行的小脚本
- 它和主进程本身关系密切，所以调试方式和 main.js 类似

✅ preload 调试 = **VSCode可以打断点，但更准确的是结合 DevTools查看 window注入内容。**

## 4.3 渲染进程页面代码（renderer/*.js）

**特点：**

- 是 Chromium 浏览器加载的 HTML/JS 页面
- 和前端网页一样，只能在浏览器环境调试

**打断点方法：**

- **打开Electron窗口后，按 `Ctrl+Shift+I` 打开 DevTools**
- 在 DevTools 的 Sources 面板里找到你的 `renderer.js`
- 在里面打断点
- 页面执行到相应逻辑时，断点会命中

✅ 渲染进程调试 = **用 Electron窗口里的 DevTools打断点（就像调网页一样）**

## 4.4 动态require的模块（modules/*.js）

**特点：**

- modules 可能被主进程、预加载脚本、渲染进程require
- **它属于哪个进程，取决于谁require它**

## 4.5 总结

**打断点方法：**

| 谁 require modules/*.js？                      | 打断点方式                       |
| ---------------------------------------------- | -------------------------------- |
| main.js require                                | VSCode断点调试                   |
| preload.js require                             | VSCode断点调试（但注意执行时机） |
| renderer.js require（如果nodeIntegration开着） | Electron DevTools打断点          |

✅ modules调试 = **看调用者是谁，跟着那个进程的调试方式走！**

**为什么有时候打不上断点？**

几个常见原因总结：

| 问题                                                 | 解释                                              |
| ---------------------------------------------------- | ------------------------------------------------- |
| 打在主进程文件上，但 Electron 是普通运行（没调试器） | 必须用 VSCode launch.json启动调试模式，否则打不上 |
| 打在渲染进程文件上，但没打开 DevTools                | 渲染进程必须用 DevTools断点                       |
| modules文件打断点，但调用者是渲染进程                | 应该去 DevTools里打，而不是VSCode里打             |
| 文件映射错误（比如用webpack打包了）                  | 需要正确的 source-map 和 outFiles 配置            |

# Electron程序打包（用 electron-builder）

**最终目标：**

- 把开发完成的 Electron 项目
- 打成 `.exe` 安装程序（Windows）
- 或 `.dmg` 安装包（Mac）
- 不用 Node、不用 VSCode，普通电脑直接安装、运行！

**第1步：安装 electron-builder**

在你的项目目录下，执行：

```bash
npm install electron-builder --save-dev
```

✅ 这样就把 `electron-builder` 装到开发依赖里了。

**第2步：修改 package.json**

打开你的 `package.json`，做两件事：

1. **加上打包配置（`build` 字段）**

在 `package.json` 里，添加一段新的字段 `build`：

```json
"build": {
  "appId": "com.yourcompany.yourapp",
  "productName": "SmartMDImporter", 
  "directories": {
    "output": "dist"
  },
  "files": [
    "**/*"
  ],
  "win": {
    "target": "nsis"
  },
  "mac": {
    "target": "dmg"
  }
}
```

🔹 参数解释：

| 参数                 | 意义                                     |
| -------------------- | ---------------------------------------- |
| `appId`              | 应用唯一ID，规范写法是 com.公司名.应用名 |
| `productName`        | 应用显示名称（安装包、窗口标题会用）     |
| `directories.output` | 打包后输出的目录                         |
| `files`              | 指定要打包进去的文件                     |
| `win.target`         | Windows 平台打成 NSIS安装程序            |
| `mac.target`         | Mac 平台打成 dmg镜像                     |

✅ 这样 Electron-Builder 知道要怎么打包你的应用了！

2. **加上打包脚本**

在 `scripts` 部分加两个指令：

```json
"scripts": {
  "dev": "electron .",
  "build": "electron-builder",
  "build:win": "electron-builder --win",
  "build:mac": "electron-builder --mac"
}
```

这样你可以直接用：

- `npm run build`：打包当前平台（比如 Windows）
- `npm run build:win`：只打包 Windows 安装程序
- `npm run build:mac`：只打包 Mac 安装包

如果你想换应用图标（默认是 Electron图标🪐），可以在 build 字段加上：

```json
"win": {
  "icon": "build/icon.ico",
  "target": "nsis"
}
```

然后放一张 `.ico` 格式的图标文件到 `build/` 文件夹里。

**第3步：执行打包**

现在你可以直接执行打包命令了！

```bash
npm run build
```

Electron-Builder会自动：

- 检查你的 `main.js`、`renderer/` 这些文件
- 打成一个安装程序，比如 `dist/SmartMDImporter Setup 1.0.0.exe`

✅ 完成！

打包完以后，`dist/` 目录大概是这样：

```
bash复制编辑dist/
├─ SmartMDImporter Setup 1.0.0.exe   # 安装程序
├─ SmartMDImporter-1.0.0.exe         # 绿色版可执行文件
├─ SmartMDImporter-1.0.0/            # 解压后的文件夹
```

你可以直接拿 `.exe` 发给别人！或者自己双击 `.exe` 安装体验！

**打包常见问题**

| 问题                   | 解决办法                                                     |
| ---------------------- | ------------------------------------------------------------ |
| 打包时出错找不到依赖   | 确认 `node_modules` 里的模块存在                             |
| 打包后运行时报路径错误 | 确认用了 `path.join(__dirname, xxx)`，不要用相对路径         |
| 窗口打不开             | 检查 `main.js` 有没有正确 `loadFile()` 指向 renderer/index.html |
| 想让打包出的窗口无菜单 | `win.setMenu(null);` 加在 `BrowserWindow` 里                 |

