---
title: <% tp.file.title %>
author: MycroftCooper
created: <% tp.date.now("YYYY-MM-DD HH:mm") %>
lastModified: <% tp.date.now("YYYY-MM-DD HH:mm") %>
tags: 
category: <% tp.file.folder(true).startsWith('notes/') ? tp.file.folder(true).slice(6) : tp.file.folder(true) %>
note status: 草稿
---
