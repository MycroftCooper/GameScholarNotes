---
title: hexo博客中添加音乐播放器
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - hexo
category: 程序/扩展知识/Hexo
note status: 终稿
---


# 1. 简介

本篇文章是介绍基于网易云iframe插件在hexo博客中加装音乐播放器的方法，无需安装任何额外插件。

# 2.安装步骤

1. 在网易云音乐中打开你想要插入的音乐页面，点击 **生成外联播放器**。

2. 在网页中调整好播放器插件后，复制下方的HTML代码。

   如：
   ```html
   <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=1488285208&auto=1&height=66"></iframe>
   ```

3. 打开本地架设hexo博客的文件夹，寻找正在使用主题文件夹下的layout文件夹。

   例如我在使用的fluid主题的路径是：

   ```bash
   F:\MyBlog\node_modules\hexo-theme-fluid\layout
   ```

4. 在layout文件夹下寻找你想要添加音乐播放器位置的ejs文件。

   例如我想放在所有页面的页脚，则ejs文件的路径是：

   ```bash
   \layout\_partial\footer.ejs
   ```
   
5. 打开ejs文件(可以用vscode或者记事本)，找到生成相关位置html文件的代码。

   这些ejs文件相当于是生成html文件的模板。

6. 将复制来的HTML代码加上div加进相关的位置

   例如：
```html
   <footer class="text-center mt-5 py-3">//原本的页脚生成代码
   --------------------------------------------------------
     <div class="music-player">//复制来的外链播放器插件代码
    <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=530 height=86 src="//music.163.com/outchain/player?type=2&id=572328440&auto=1&height=66"></iframe>
     </div>>
   ---------------------------------------------------------
     //原本的页脚生成代码
     <div class="footer-content">
     <%- theme.footer.content %>
    </div>
    <%- partial('_partial/statistics.ejs') %>
    <%- partial('_partial/beian.ejs') %>
    <% if(theme.web_analytics.cnzz) { %>
     *<!-- cnzz Analytics Icon -->*
     <span id="cnzz_stat_icon_<%- theme.web_analytics.cnzz %>" style="display: none"></span>
    <% } %>
   </footer>
```

7. 清理服务器缓存后再重新部署，音乐播放器就出现在对应位置了！

# 3. 注意事项

> 音乐不能是网易云里的VIP音乐，它是不会给你播的

> 当页面转换或者刷新时，播放器状态将被重置，目前还没有办法解决



# 4.其它的实现方法

在hexo框架的基础下，还可以用音乐播放插件**Aplayer**来实现。

相关链接：[**Aplayer**](https://aplayer.js.org/#/zh-Hans/)
