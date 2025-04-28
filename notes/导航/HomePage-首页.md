---
title: HomePage-首页
author: MycroftCooper
created: 2025-04-24 17:30
lastModified: 2025-04-24 17:30
tags:
  - 导航
category: 导航
note status: 终稿
---
# 🏠 游戏开发知识库主页

# 快捷入口


# 知识库总览
```dataviewjs
const pages = dv.pages('"notes"').array();

// 文件数量
const fileCount = pages.length;

// 总字数（用 file.size / 2 估算）
const wordCount = pages
  .map(p => p.file.size ? Math.floor(p.file.size / 2) : 0)
  .reduce((a, b) => a + b, 0);

// 不同作者
const authors = new Set(pages.map(p => p.author).filter(Boolean));

// 草稿数量
const draftCount = pages.filter(p => (p["note status"] ?? "").toLowerCase() === "草稿").length;

// 终稿数量
const finalCount = pages.filter(p => (p["note status"] ?? "").toLowerCase() === "终稿").length;

// 标签数量
const tags = new Set();
for (const page of pages) {
    const pageTags = page.tags;
    if (Array.isArray(pageTags)) {
        pageTags.forEach(tag => tags.add(tag));
    } else if (typeof pageTags === "string") {
        tags.add(pageTags);
    }
}

// 分类数量
const categories = new Set();
for (const page of pages) {
    const category = page.category;
    if (typeof category === "string" && category.trim() !== "") {
        categories.add(category);
    }
}

// 渲染表格
dv.table(["指标", "数量"], [
  ["📄 文章数量", fileCount],
  ["✍️ 总字数（估算）", wordCount],
  ["👥 作者数量", authors.size],
  ["🏷️ 标签数量", tags.size],
  ["📂 分类数量", categories.size],
  ["📝 草稿数量", draftCount],
  ["📃 终稿数量", finalCount]
]);
```

```dataviewjs
// 📅 设置统计范围：过去1年
const today = new Date();
const yearAgo = new Date(today);
yearAgo.setFullYear(today.getFullYear() - 1);

// 🔢 初始化每天的字数和笔记列表
const dayWordCount = new Map();
const dayNotes = new Map();

for (let d = new Date(yearAgo); d <= today; d.setDate(d.getDate() + 1)) {
    const key = d.toISOString().slice(0,10);
    dayWordCount.set(key, 0);
    dayNotes.set(key, []);
}

// 📋 收集数据
const pages = dv.pages('"notes"').array();
for (const p of pages) {
    const created = new Date(p.file.ctime);
    const key = created.toISOString().slice(0,10);
    const words = p.file.size ? Math.floor(p.file.size / 2) : 0; // 估算字数
    if (dayWordCount.has(key)) {
        dayWordCount.set(key, dayWordCount.get(key) + words);
        dayNotes.get(key).push(p);
    }
}

// 📅 组织成按周的数据结构
const weeks = [];
let currentWeek = [];

for (let d = new Date(yearAgo); d <= today; d.setDate(d.getDate() + 1)) {
    const key = d.toISOString().slice(0,10);
    const count = dayWordCount.get(key) ?? 0;

    currentWeek.push({ date: key, count });

    if (d.getDay() === 6) { // 星期六结束一周
        weeks.push(currentWeek);
        currentWeek = [];
    }
}
if (currentWeek.length > 0) weeks.push(currentWeek);

// 🚀 渲染热力图
const container = dv.container;

// ➡️ 最上方加重置按钮
const topControls = container.createDiv({ cls: "calendar-top-controls" });
const resetButton = topControls.createEl("button", { text: "🔄 重置查看" });
resetButton.style.marginBottom = "10px";
resetButton.style.padding = "5px 10px";
resetButton.style.cursor = "pointer";

// ➡️ 创建热力图容器
const calendar = container.createDiv({ cls: "calendar-heatmap" });
calendar.style.display = "grid";
calendar.style.gridTemplateRows = "repeat(7, 14px)";
calendar.style.gridAutoFlow = "column";
calendar.style.gap = "3px";
calendar.style.alignItems = "start";

// ➡️ 渲染月份标签
let lastMonth = "";
weeks.forEach((week, wIdx) => {
    const firstDay = week[0];
    const month = new Date(firstDay.date).toLocaleString('default', { month: 'short' });
    if (month !== lastMonth) {
        const label = calendar.createDiv({ text: month });
        label.style.gridRow = `1 / span 1`;
        label.style.gridColumn = `${wIdx + 1}`;
        label.style.fontSize = "8px";
        label.style.color = "var(--text-muted)";
        label.style.textAlign = "center";
        label.style.marginBottom = "2px";
        lastMonth = month;
    }
});

// ➡️ 渲染格子
weeks.forEach(week => {
    week.forEach((day, dIdx) => {
        const cell = calendar.createDiv({ cls: "calendar-cell" });
        cell.style.width = "14px";
        cell.style.height = "14px";
        const count = day.count;

        cell.style.backgroundColor = count === 0 ? "#eee" :
            count < 200 ? "#c6e48b" :
            count < 500 ? "#7bc96f" :
            count < 1000 ? "#239a3b" :
            "#196127";

        cell.setAttr("title", `${day.date}: ${count} 字`);

        // 点击格子，显示当天笔记
        cell.addEventListener("click", () => {
            // 清除其他选中
            document.querySelectorAll(".calendar-cell.selected").forEach(c => c.classList.remove("selected"));
            cell.classList.add("selected");

            const notesForDay = dayNotes.get(day.date) ?? [];

            listContainer.innerHTML = "";
            listContainer.createEl("h3", { text: `${day.date} 写了 ${count} 字，${notesForDay.length} 篇文章:` });

            if (notesForDay.length === 0) {
                listContainer.createSpan({ text: "当天没有笔记" });
            } else {
                notesForDay.forEach(note => {
                    const noteDiv = listContainer.createDiv({ cls: "day-note-item" });
                    const link = noteDiv.createEl("a", { 
                        text: `📄 ${note.file.name} - by ${note.author ?? "未知作者"}`,
                        href: "#",
                    });
                    link.addEventListener("click", (e) => {
                        e.preventDefault();
                        app.workspace.openLinkText(note.file.path, "", true);
                    });
                });
            }
        });
    });
});

// 📅 本周字数+文章总结
const weekSummary = container.createDiv({ cls: "calendar-week-summary" });

const todayDate = new Date();
const dayOfWeek = todayDate.getDay();
const monday = new Date(todayDate);
monday.setDate(todayDate.getDate() - ((dayOfWeek + 6) % 7));

let weekTotal = 0;
let weekNotes = 0;
for (let d = new Date(monday); d <= todayDate; d.setDate(d.getDate() + 1)) {
    const key = d.toISOString().slice(0,10);
    weekTotal += dayWordCount.get(key) ?? 0;
    weekNotes += (dayNotes.get(key)?.length ?? 0);
}

weekSummary.createDiv({ text: `📅 本周共写了 ${weekTotal} 字，${weekNotes} 篇文章 ✍️` });

// 🏆 连续写作天数统计
const consecutiveDiv = container.createDiv({ cls: "calendar-consecutive" });
let maxStreak = 0;
let currentStreak = 0;

for (const [date, count] of dayWordCount) {
    if (count > 0) {
        currentStreak++;
        if (currentStreak > maxStreak) {
            maxStreak = currentStreak;
        }
    } else {
        currentStreak = 0;
    }
}
consecutiveDiv.createDiv({ text: `🏆 最长连续写作：${maxStreak}天` });

// ➡️ 创建点击格子后展示当天笔记的容器
const listContainer = container.createDiv({ cls: "calendar-day-notes" });

// ➡️ 重置按钮清空笔记列表和取消高亮
resetButton.addEventListener("click", () => {
    listContainer.innerHTML = "";
    document.querySelectorAll(".calendar-cell.selected").forEach(c => c.classList.remove("selected"));
});
```

## 👥作者贡献
```dataviewjs
const pages = dv.pages('"notes"').array();
const authors = {}; // 作者文章数
const authorCategories = {}; // 作者分类
const authorTags = {}; // 作者标签

for (const p of pages) {
  const author = p.author ?? "未知作者";

  // 统计文章数量
  authors[author] = (authors[author] ?? 0) + 1;

  // 统计根分类
  if (!(author in authorCategories)) authorCategories[author] = {};
  const fullCategory = p.category ?? "未分类";
  const rootCategory = fullCategory.split("/")[0]; // ⭐ 只取第一个根分类
  authorCategories[author][rootCategory] = (authorCategories[author][rootCategory] ?? 0) + 1;

  // 统计标签
  if (!(author in authorTags)) authorTags[author] = {};
  const tags = Array.isArray(p.tags) ? p.tags : (p.tags ? [p.tags] : []);
  for (const tag of tags) {
    authorTags[author][tag] = (authorTags[author][tag] ?? 0) + 1;
  }
}

// 帮助函数：取出现次数最多的前n项
function topN(obj, n) {
  return Object.entries(obj)
    .sort((a, b) => b[1] - a[1])
    .slice(0, n)
    .map(([key, count]) => `${key} (${count})`)
    .join(", ");
}

// 渲染表格
dv.table(
  ["作者", "文章数量", "活跃根分类Top3", "活跃标签Top3"],
  Object.keys(authors).map(author => [
    author,
    authors[author],
    topN(authorCategories[author], 3) || "无",
    topN(authorTags[author], 3) || "无",
  ])
);
```

## 📝待完稿笔记
```dataviewjs
const pages = dv.pages('"notes"')
    .where(p => p["note status"] === "草稿");

const container = dv.container;
const table = container.createEl("table");
const thead = table.createTHead();
const headerRow = thead.insertRow();
["笔记标题", "作者"].forEach(text => {
    const th = document.createElement("th");
    th.textContent = text;
    headerRow.appendChild(th);
});

const tbody = table.createTBody();

for (const page of pages) {
    const row = tbody.insertRow();

    // 笔记链接（手动处理新面板打开）
    const linkCell = row.insertCell();
    const link = linkCell.createEl("a", { text: page.file.name, href: "#" });
    link.addEventListener("click", (e) => {
        e.preventDefault();
        app.workspace.openLinkText(page.file.path, "", true); // ✅ 新面板打开
    });

    // 作者
    const authorCell = row.insertCell();
    authorCell.textContent = page.author ?? "未知作者";
}
```

## 🏷️标签总览

```dataviewjs
const vaultName = "GameScholarNotes";
const pages = dv.pages('"notes"').array();
const tagMap = new Map();

// 统计所有标签
for (const page of pages) {
    if (!page.tags) continue;
    const tags = Array.isArray(page.tags) ? page.tags : [page.tags];
    for (const tag of tags) {
        if (!tagMap.has(tag)) tagMap.set(tag, []);
        tagMap.get(tag).push(page);
    }
}

// 找最大数量
const maxCount = Math.max(...tagMap.values().map(pages => pages.length));

// 创建搜索框和重置按钮区域
const searchDiv = dv.container.createDiv({ cls: "tag-search" });
const searchInput = searchDiv.createEl("input", {
    type: "text",
    placeholder: "🔍 搜索标签...",
});
searchInput.style.margin = "10px";
searchInput.style.padding = "5px";
searchInput.style.width = "300px";

const resetButton = searchDiv.createEl("button", {
    text: "🔄 重置",
});
resetButton.style.marginLeft = "10px";
resetButton.style.padding = "5px 10px";
resetButton.style.cursor = "pointer";

// 创建云区
const cloudDiv = dv.container.createDiv({ cls: "tag-cloud" });

function randomColor() {
    return `hsl(${Math.floor(Math.random() * 360)}, 70%, 60%)`;
}

function renderTags(filterText = "") {
    cloudDiv.innerHTML = "";

    const keywords = filterText.trim().toLowerCase().split(/\s+/);

    for (const [tag, pageList] of tagMap.entries()) {
        const tagLower = tag.toLowerCase();

        if (filterText && !keywords.every(kw => tagLower.includes(kw))) continue;

        const fontSize = 14 + (pageList.length / maxCount) * 18;
        const color = randomColor();
        const tagLink = cloudDiv.createEl("a", {
            text: `${tag}(${pageList.length})`,
            href: "#",
        });
        tagLink.classList.add("tag-cloud-item");
        tagLink.style.fontSize = `${fontSize}px`;
        tagLink.style.color = color;
        tagLink.dataset.tagName = tag;
        tagLink.dataset.originalColor = color; // 保存初始颜色
    }
}

renderTags();

// 搜索框监听输入
searchInput.addEventListener("input", (event) => {
    const filterText = event.target.value;
    renderTags(filterText);
});

// 创建下方文章列表容器
const listDiv = dv.container.createDiv({ attr: { id: "tag-article-list" }});

// 点击联动
cloudDiv.addEventListener("click", (event) => {
    const target = event.target;
    if (target.tagName !== "A") return;
    event.preventDefault();

    const selectedTag = target.dataset.tagName;
    const relatedPages = tagMap.get(selectedTag) ?? [];

    // 高亮当前点击的标签
    document.querySelectorAll(".tag-cloud-item").forEach(tag => tag.classList.remove("tag-cloud-selected"));
    target.classList.add("tag-cloud-selected");

    listDiv.innerHTML = "";

    if (relatedPages.length === 0) {
        listDiv.createSpan({ text: `暂无标签【${selectedTag}】的文章。` });
        return;
    }

    for (const page of relatedPages) {
        const line = listDiv.createDiv({ cls: "tag-article-item" });

        const link = line.createEl("a", {
            text: `📄 ${page.file.name}`,
            href: "#",
        });

        link.style.marginLeft = "20px";

        // 新面板打开笔记
        link.addEventListener("click", (e) => {
            e.preventDefault();
            app.workspace.openLinkText(
                page.file.path,
                "",
                true // 新面板
            );
        });
    }
});

// 重置按钮逻辑
resetButton.addEventListener("click", () => {
	searchInput.value = "";

    // 恢复显示所有标签（不重新随机颜色）
    document.querySelectorAll(".tag-cloud-item").forEach(tag => {
        tag.style.display = "inline";  // 之前renderTags是重新渲染，这里只改显示
    });

    listDiv.innerHTML = "";

    // 找到当前被选中的标签
    const selectedTag = document.querySelector(".tag-cloud-selected");
    if (selectedTag) {
        selectedTag.classList.remove("tag-cloud-selected");

        // 只给它随机换颜色
        const newColor = randomColor();
        selectedTag.style.color = newColor;
        selectedTag.dataset.originalColor = newColor;
    }
});

```

## 📂分类总览
```dataviewjs
const pages = dv.pages('"notes"').array();

// 构建树
const root = {};

for (const page of pages) {
    const pathParts = (page.category ?? "未分类").split("/");
    let node = root;

    for (let i = 0; i < pathParts.length; i++) {
        const part = pathParts[i];

        if (!node[part]) {
            node[part] = { _count: 0, _children: {}, _notes: [] };
        }
        node[part]._count += 1;

        if (i === pathParts.length - 1) {
            node[part]._notes.push({ name: page.file.name, page: page });
        }

        node = node[part]._children;
    }
}

const container = dv.container;

// ➡️ 搜索框 + 重置按钮
const searchDiv = container.createDiv({ cls: "category-search" });
const searchInput = searchDiv.createEl("input", {
    type: "text",
    placeholder: "🔍 搜索分类或笔记...",
});
searchInput.style.margin = "10px";
searchInput.style.padding = "5px";
searchInput.style.width = "300px";

const resetButton = searchDiv.createEl("button", {
    text: "🔄 重置",
});
resetButton.style.marginLeft = "10px";
resetButton.style.padding = "5px 10px";
resetButton.style.cursor = "pointer";

// 树容器
const treeContainer = container.createDiv({ cls: "category-tree" });

// ------------- 动画控制函数 --------------
function collapse(element) {
    const sectionHeight = element.scrollHeight;
    element.style.height = sectionHeight + "px";
    element.style.transition = "height 0.3s ease, opacity 0.3s ease";
    requestAnimationFrame(() => {
        element.style.height = "0";
        element.style.opacity = "0";
    });
}

function expand(element) {
    element.style.height = "auto";
    element.style.opacity = "1";
    element.style.transition = "height 0.3s ease, opacity 0.3s ease";
    const sectionHeight = element.scrollHeight;
    element.style.height = "0"; // 起点是0
    requestAnimationFrame(() => {
        element.style.height = sectionHeight + "px";
        element.style.opacity = "1";
    });
    setTimeout(() => {
        element.style.height = "auto";
    }, 300);
}

// -----------------------------------------

// 渲染树
function renderTree(node, container, filterText = "", depth = 0) {
    let hasVisibleContent = false;

    for (const [key, value] of Object.entries(node)) {
        if (key.startsWith("_")) continue;

        const lowerKey = key.toLowerCase();
        const keywords = filterText.trim().toLowerCase().split(/\s+/);

        const matchesSelf = filterText === "" || keywords.every(kw => lowerKey.includes(kw));

        const details = container.createEl("details");
        const summary = details.createEl("summary", { text: `📁 ${key} (${value._count})` });
        summary.style.paddingLeft = `${depth * 20}px`;

        const contentWrapper = details.createDiv({ cls: "details-content" }); // 子内容包裹器

        let hasVisibleChild = false;

        hasVisibleChild = renderTree(value._children, contentWrapper, filterText, depth + 1) || hasVisibleChild;

        for (const note of value._notes) {
            const lowerNote = note.name.toLowerCase();
            const noteMatches = keywords.every(kw => lowerNote.includes(kw));
            if (filterText === "" || noteMatches) {
                const noteDiv = contentWrapper.createDiv({ cls: "category-note-item" });
                noteDiv.style.paddingLeft = `${(depth + 1) * 20}px`;

                const link = noteDiv.createEl("a", {
                    text: `📄 ${note.name}`,
                    href: "#",
                });

                link.addEventListener("click", (e) => {
                    e.preventDefault();
                    app.workspace.openLinkText(note.page.file.path, "", true);
                });

                hasVisibleChild = true;
            }
        }

        if (!(matchesSelf || hasVisibleChild)) {
            details.remove();
        } else {
            hasVisibleContent = true;

            if (filterText.trim() !== "") {
                details.open = true;
                expand(contentWrapper);
            }
        }

        // ✅ 正确！监听 details 的 toggle 而不是 summary 的 click
        details.addEventListener("toggle", (e) => {
            e.stopPropagation();
            if (details.open) {
                expand(contentWrapper);
            } else {
                collapse(contentWrapper);
            }
        });
    }

    return hasVisibleContent;
}

// 初始化渲染
renderTree(root, treeContainer);

// 搜索输入监听
searchInput.addEventListener("input", (event) => {
    const filterText = event.target.value;
    treeContainer.innerHTML = "";
    renderTree(root, treeContainer, filterText);
});

// 重置按钮监听
resetButton.addEventListener("click", () => {
    searchInput.value = "";
    treeContainer.innerHTML = "";
    renderTree(root, treeContainer);
});
```

## 🕘最近更新
```dataview
table file.mtime as 修改时间
from "notes"
sort file.mtime desc
limit 10
```
