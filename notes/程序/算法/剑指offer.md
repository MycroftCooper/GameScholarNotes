---
title: 剑指offer
author: MycroftCooper
created: 2025-04-28 02:36
lastModified: 2025-04-28 02:36
tags:
  - 程序
  - 算法
category: 程序/算法
note status: 终稿
---


# 剑指offer

# 03. 找出数组中重复的数字

21-7-15

**描述：**
找出数组中重复的数字。
在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。
数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。
请找出数组中任意一个重复的数字。

**示例：**
输入：
    [2, 3, 1, 0, 2, 5, 3]
输出：
    2 或 3 
限制：
    2 <= n <= 100000

**解：**

```c++
#include <iostream>
#include <vector>
#include <Map>
using namespace std;

class Solution
{
public:
    int findRepeatNumber1(vector<int>& nums)
        //哈希表法 时间复杂度o(n) 空间复杂度o(n)
    {
        map<int, int> numMap;
        for (int i = 0; i < nums.size(); i++)
        {
            if (numMap.find(nums[i]) == numMap.end())
                numMap.insert(pair<int,int>(nums[i], 0));
            else
                return nums[i];
        }
        return -1;
    }
    
    int findRepeatNumber2(vector<int>& nums)
        //原地置换法 
    {
        for (int i = 0; i < nums.size(); ++i)
        {
            while (nums[i] != nums[nums[i]])
                swap(nums[i], nums[nums[i]]);
            if (nums[i] != i) return nums[i];
        }
        return -1;
    }
};
int main()
{
    Solution s;
    int output;
    vector<int> v({ 2, 3, 1, 0, 2, 5, 3 });
    output =s.findRepeatNumber1(v);
    cout << output << endl;
    output = s.findRepeatNumber2(v);
    cout << output << endl;
}
```

**思路：**

- 要求空间复杂度低
  - 先排序，然后看相邻元素是否有相同的，有直接return。 
    时间复杂度O(nlogn)，空间复杂度O(1)
  - 原地置换
    题目说明尚未被充分使用
    即：在一个长度为 n 的数组 nums 里的所有数字都在 0 ~ n-1 的范围内 
    此说明含义：数组元素的 索引 和 值 是 一对多 的关系。
    因此，可遍历数组并通过交换操作，使元素的 索引 与 值 一一对应（即 nums[i] = inums[i]=i ）。
    因而，就能通过索引映射对应的值，起到与字典等价的作用。
- 均衡的方法
  使用哈希表(map)
  时间复杂度O(n)，空间复杂度O（n）

# 04. 二维数组中的查找

21-7-15

**描述：**
在一个 n * m 的二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。
请完成一个高效的函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

链接：https://leetcode-cn.com/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof

**示例：**
现有矩阵 matrix 如下：
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
给定 target = 5，返回 true。
给定 target = 20，返回 false。

**限制：**
0 <= n <= 1000
0 <= m <= 1000

**解：**

```c++
#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    bool findNumberIn2DArray(vector<vector<int>>& matrix, int target) 
    {
        if (matrix.length == 0 || matrix[0].length == 0) return false;
        int col = matrix[0].size()-1;
        int row = 0;
        while (col > -1 && row<matrix.size())
        {
            if (target == matrix[row][col])
                return true;
            if (target > matrix[row][col])
                row++;
            else
                col--;
        }
        return false;
    }
};
int main()
{
    Solution s;
    vector<int>a1({ 1,   4,  7, 11, 15 });
    vector<int>a2({ 2,   5,  8, 12, 19 });
    vector<int>a3({ 3,   6,  9, 16, 22 });
    vector<int>a4({ 10, 13, 14, 17, 24 });
    vector<int>a5({ 18, 21, 23, 26, 30 });
    vector<vector<int>> inputMatrix({a1,a2,a3,a4,a5});
    int target;
    bool output;

    target = 5;
    output =s.findNumberIn2DArray(inputMatrix,target);
    cout << output << endl;

    target = 20;
    output = s.findNumberIn2DArray(inputMatrix, target);
    cout << output << endl;
}
```

**思路：**

线性查找

从二维数组的右上角开始查找。

- 如果当前元素等于目标值，则返回 true。
- 如果当前元素大于目标值，则移到左边一列。
- 如果当前元素小于目标值，则移到下边一行。
- 若数组为空，返回 false
- 循环体执行完毕仍未找到元素等于 target ，说明不存在这样的元素，返回 false

可以证明这种方法不会错过目标值。

- 如果当前元素大于目标值，说明当前元素的下边的所有元素都一定大于目标值
  因此往下查找不可能找到目标值，往左查找可能找到目标值。
- 如果当前元素小于目标值，说明当前元素的左边的所有元素都一定小于目标值
  因此往左查找不可能找到目标值，往下查找可能找到目标值。

# 05. 替换空格

21-7-15

**描述：**
请实现一个函数，把字符串 s 中的每个空格替换成"%20"。
链接：https://leetcode-cn.com/problems/ti-huan-kong-ge-lcof

**示例：**

输入：s = "We are happy."
输出："We%20are%20happy."

**限制：**
0 <= s 的长度 <= 10000

**解：**

```c++
#include <iostream>
#include <vector>
using namespace std;

class Solution 
{
public:
    string replaceSpace(string s) 
    {
        string output="";
        for (int i = 0; i < s.length(); i++)
        {
            if (s[i] == ' ')
                output += "%20";
            else
                output += s[i];
        }
        return output;
    }
};
int main()
{
    Solution s;
    string target = "We are happy.";
    string output = s.replaceSpace(target);
    cout << output << endl;
}
```

字符串拼接或转为字符数组操作

# 06. 从尾到头打印链表

21-7-15

**描述：**

输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。

链接：https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof

**示例：**
输入：head = [1,3,2]
输出：[2,3,1]

**限制：**
0 <= 链表长度 <= 10000

**解：**

```c++
#include <iostream>
#include <vector>
using namespace std;

struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(NULL) {}
};
class Solution 
{
public:
    
    vector<int> reversePrint1(ListNode* head) {
    //利用vector的insert特性
        if (head == NULL)return *new vector<int>(0);
        vector<int> output;
        ListNode* p = head;
        while (p!=NULL)
        {
            output.insert(output.begin(),p->val);
            p = p->next;
        } 
        return output;
    }
    vector<int> reversePrint2(ListNode* head) {
    //回溯法
        if (head == NULL)return *new vector<int>(0);
        vector<int> output;
        ListNode* p = head;
        flashBack(p, output);
        return output;
    }
    void flashBack(ListNode* p, vector<int>&output)
    {
        if (p->next!= NULL)
        {
            ListNode* q = p->next;
            flashBack(q, output);
        }
        output.push_back(p->val);
    }
};
int main()
{
    Solution s;
    ListNode *target=new ListNode(1);
    target->next = new ListNode(2);
    target->next->next = new ListNode(3);
    vector<int> output = s.reversePrint2(target);
    for (int i = 0; i < output.size(); i++)
    {
        cout << output[i]<<endl;
    }
}
```

法一：回溯法
法二：用栈
法三：利用vector的insert特性

# 07. 重建二叉树

21-7-16

**描述：**
输入某二叉树的前序遍历和中序遍历的结果，请构建该二叉树并返回其根节点。

假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

相关知识点：

- [树的三种遍历与推导](https://www.cnblogs.com/jpfss/p/11141956.html)

链接：https://leetcode-cn.com/problems/zhong-jian-er-cha-shu-lcof

**示例1：**

![image-20210716143123077](attachments/notes/程序/算法/剑指offer/IMG-20250428102905547.png)

**Input:** 
preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]

**Output:**
 [3,9,20,null,null,15,7]

**示例2：**
**Input:** 
preorder = [-1], inorder = [-1]

**Output:** 
[-1]

**限制：**
0 <= 节点个数 <= 5000

**解:**

```c++
#include <iostream>
#include <vector>
#include <map>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}   
};
class Solution 
{
private:
    map<int, int>preMap;
    map<int, int>inoMap;
    vector<int> preorder;
    vector<int> inorder;

public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) 
    {
        if (preorder.size() == 0 || inorder.size() == 0)return NULL;
        TreeNode* root = new TreeNode(preorder[0]);
        for (int i = 0; i < preorder.size(); i++)
        {
            preMap.insert(pair<int,int> (preorder[i],i));
            inoMap.insert(pair<int, int> (inorder[i], i));
        }
        this->preorder = preorder;
        this->inorder = inorder;
        treeBuilder(0,inorder.size()-1, root);
        return root;
    }
    void treeBuilder(int inorderBegin, int inorderEnd, TreeNode* nowRoot)
    {
        int boundary;
        boundary = inoMap[nowRoot->val];

        int leftBegin = inorderBegin;
        int leftEnd = boundary - 1;
        if (leftEnd < inorderBegin)leftEnd = inorderBegin;
        int rightBegin = boundary + 1;
        if (rightBegin > inorderEnd)rightBegin = inorderEnd;
        int rightEnd = inorderEnd;
        if (leftBegin == rightEnd)return;

        if (inorder[leftBegin] != nowRoot->val)
        {
            nowRoot->left=findRootNode(leftBegin, leftEnd);
        }
        if (inorder[rightBegin] != nowRoot->val)
        {
            nowRoot->right = findRootNode(rightBegin,rightEnd);
        }

        if (nowRoot->left !=NULL)
            treeBuilder(leftBegin, leftEnd, nowRoot->left);
        if (nowRoot->right !=NULL)
            treeBuilder(rightBegin, rightEnd, nowRoot->right);
    }
    TreeNode* findRootNode(int begin,int end)
    {
        int root_p = preMap[inorder[begin]];

        for (int j = begin; j <= end; j++)
        {
            if (preMap[inorder[j]] < root_p)
            {
                root_p = preMap[inorder[j]];
            }
        }
        return new TreeNode(preorder[root_p]);
    }
};
int main()
{
    Solution s;
    vector<int> preorder({ 3, 9, 20, 15, 7 });
    vector<int> inorder({ 9, 3, 15, 20, 7 });
    TreeNode* output = s.buildTree(preorder,inorder);
    cout << "ok" << endl;
}
```

**思路:**

**二叉树的遍历:**

二叉树前序遍历的顺序为：

- 先遍历根节点；
- 随后递归地遍历左子树；
- 最后递归地遍历右子树。

二叉树中序遍历的顺序为：

- 先递归地遍历左子树；
- 随后遍历根节点；
- 最后递归地遍历右子树。

在「递归」地遍历某个子树的过程中，我们也是将这颗子树看成一颗全新的树，按照上述的顺序进行遍历。
挖掘「前序遍历」和「中序遍历」的性质，我们就可以得出本题的做法。

**方法一：递归**

对于任意一颗树而言，前序遍历的形式总是

[ 根节点, [左子树的前序遍历结果], [右子树的前序遍历结果] ]
即根节点总是前序遍历中的第一个节点。

而中序遍历的形式总是

[ [左子树的中序遍历结果], 根节点, [右子树的中序遍历结果] ]

只要我们在中序遍历中定位到根节点，那么我们就可以分别知道左子树和右子树中的节点数目。由于同一颗子树的前序遍历和中序遍历的长度显然是相同的，因此我们就可以对应到前序遍历的结果中，对上述形式中的所有左右括号进行定位。

这样以来，我们就知道了左子树的前序遍历和中序遍历结果，以及右子树的前序遍历和中序遍历结果，我们就可以递归地对构造出左子树和右子树，再将这两颗子树接到根节点的左右位置。

> 注意：
> 在中序遍历中对根节点进行定位时，一种简单的方法是直接扫描整个中序遍历的结果并找出根节点，但这样做的时间复杂度较高。
> 我们可以考虑使用哈希表来帮助我们快速地定位根节点。
> 对于哈希映射中的每个键值对，键表示一个元素（节点的值），值表示其在中序遍历中的出现位置。
> 在构造二叉树的过程之前，我们可以对中序遍历的列表进行一遍扫描，就可以构造出这个哈希映射。
> 在此后构造二叉树的过程中，我们就只需要 O(1)O(1) 的时间对根节点进行定位了。

复杂度分析：

- 时间复杂度：O(n)O(n)
  其中 nn 是树中的节点个数。
- 空间复杂度：O(n)O(n)
  除去返回的答案需要的 O(n)O(n) 空间之外，我们还需要使用 O(n)O(n) 的空间存储哈希映射，以及 O(h)O(h)（其中 hh 是树的高度）的空间表示递归时栈空间。
  这里 h < nh<n，所以总空间复杂度为 O(n)O(n)。

**方法二：迭代**

略，详见：链接：https://leetcode-cn.com/problems/zhong-jian-er-cha-shu-lcof/solution/mian-shi-ti-07-zhong-jian-er-cha-shu-by-leetcode-s/

# 09. 用两个栈实现队列

21-7-16

**描述:**
用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 appendTail 和 deleteHead ，分别完成在队列尾部插入整数和在队列头部删除整数的功能。
(若队列中没有元素，deleteHead 操作返回 -1 )

链接：https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof

**示例 1：**

输入：

```
["CQueue","appendTail","deleteHead","deleteHead"]
[[],[3],[],[]]
```

输出：

```
[null,null,3,-1]
```

**示例 2：**

输入：

```
["CQueue","deleteHead","appendTail","appendTail","deleteHead","deleteHead"]
[[],[],[5],[2],[],[]]
```

输出：

```
[null,-1,null,null,5,2]
```

**提示：**
1 <= values <= 10000
最多会对 appendTail、deleteHead 进行 10000 次调用

**解:**
[队列与栈的互相实现](https://blog.csdn.net/cherrydreamsover/article/details/80466781)

复杂度分析

- 时间复杂度：
  对于插入和删除操作，时间复杂度均为 O(1)O(1)。
  插入不多说，对于删除操作，虽然看起来是 O(n)O(n) 的时间复杂度，但是仔细考虑下每个元素只会「至多被插入和弹出 stack2 一次」，因此均摊下来每个元素被删除的时间复杂度仍为 O(1)O(1)。
- 空间复杂度：
  O(n)O(n)。
  需要使用两个栈存储已有的元素。

```
#include <iostream>
#include <stack>
using namespace std;

class CQueue {
private:
    stack<int>a;
    stack<int>b;
    int size;
public:
    CQueue() 
    {
        size = 0;
    }

    void appendTail(int value) 
    {
        a.push(value);
        size++;
    }

    int deleteHead() 
    {
        if (size==0)
            return -1;
        if (b.empty())
        {
            while (!a.empty())
            {
                b.push(a.top());
                a.pop();
            }
        }
        int value = b.top();
        b.pop();
        size--;
        return value;
    }
};
```

# 10-1. 斐波那契数列

21-7-17

**描述:**
写一个函数，输入 n ，求斐波那契（Fibonacci）数列的第 n 项（即 F(N)）。

斐波那契数列的定义如下：
F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1

斐波那契数列由 0 和 1 开始，之后的斐波那契数就是由之前的两数相加而得出。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

**链接：**
https://leetcode-cn.com/problems/fei-bo-na-qi-shu-lie-lcof

**示例 1：**
输入：n = 2
输出：1

**示例 2：**
输入：n = 5
输出：5

**提示：**
0 <= n <= 100

**解:**

斐波那契数列的定义是 f(n + 1) = f(n) + f(n - 1)f(n+1)=f(n)+f(n−1) ，生成第 nn 项的做法有以下几种：

- **递归法：**
  **原理：** 
  把 f(n)f(n) 问题的计算拆分成 f(n-1)f(n−1) 和 f(n-2)f(n−2) 两个子问题的计算，并递归，以 f(0)f(0) 和 f(1)f(1) 为终止条件。
  **缺点：** 
  大量重复的递归计算，例如 f(n)f(n) 和 f(n - 1)f(n−1) 两者向下递归需要 各自计算 f(n - 2)f(n−2) 的值。
- **记忆化递归法：**
  **原理：** 
  在递归法的基础上，新建一个长度为 nn 的数组，用于在递归时存储 f(0)f(0) 至 f(n)f(n) 的数字值，重复遇到某数字则直接从数组取用，避免了重复的递归计算。
  **缺点：** 
  记忆化存储需要使用 O(N)O(N) 的额外空间。
- **动态规划：**
  **原理：** 
  以斐波那契数列性质 f(n + 1) = f(n) + f(n - 1)f(n+1)=f(n)+f(n−1) 为转移方程。
  从计算效率、空间复杂度上看，动态规划是本题的最佳解法。

```c++
#include <iostream>
#include <map>
using namespace std;

class Solution {
    map<int, int>fibMap;
    int mod = 1e9 + 7;
public:
    Solution()
    {
        fibMap.insert(pair<int,int>(0,0));
        fibMap.insert(pair<int, int>(1, 1));
    }
    
    int fib1(int n) //纯递归
    {
        if (n == 0 || n == 1)
            return n;
        return fib1(n-1) + fib1(n-2);
    }
    
    int fib2(int n)//带记录的递归
    {
        if (n == 0 || n == 1)
            return n;
        if (fibMap.find(n) == fibMap.end())
        {
            fibMap.insert(pair<int, int>(n, (fib2(n - 1) + fib2(n - 2)) % mod));
        }
        return (fibMap[n - 1] + fibMap[n - 2]) % mod;
    }
    
    int fib3(int n)//动态规划
    {
        if (n == 0 || n == 1)
            return n;
        int* p = new int[n+1];
        *p = 0;
        *(p + 1) = 1;
        for (int i = 2; i <= n; i++)
        {
            *(p + i) = (*(p + i - 1) + *(p + i - 2))%mod;
        }
        return *(p + n);
    }
};

int main()
{
    Solution s;
    cout << s.fib3(8) << endl;
}
```

# 10-2. 青蛙跳台阶

21-7-17

**描述:**
一只青蛙一次可以跳上1级台阶，也可以跳上2级台阶。求该青蛙跳上一个 n 级的台阶总共有多少种跳法。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

**链接：**
https://leetcode-cn.com/problems/qing-wa-tiao-tai-jie-wen-ti-lcof

**示例 1：**
输入：n = 2
输出：2

**示例 2：**
输入：n = 7
输出：21

**示例 3：**
输入：n = 0
输出：1

**提示：**
0 <= n <= 100

**解:**
同10-2动态规划

```c++
#include <iostream>
#include <map>
using namespace std;

class Solution {
    int mod = 1e9 + 7;
public:
    int numWays(int n) {
        if (n == 0)
            return 1;
        if (n == 1 || n==2)
            return n;
        int* p = new int[n + 1];
        *p = 1;
        *(p + 1) = 1;
        *(p + 2) = 2;
        for (int i = 3; i <= n; i++)
        {
            *(p + i) = (*(p + i - 1) + *(p + i - 2)) % mod;
        }
        return *(p + n);
    }
};

int main()
{
    Solution s;
    cout << s.numWays(8) << endl;
}
```

# 11. 旋转数组的最小数字

21-7-17

**描述:**
把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。
输入一个递增排序的数组的一个旋转，输出旋转数组的最小元素。

例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一个旋转，该数组的最小值为1。  

**链接：**
https://leetcode-cn.com/problems/xuan-zhuan-shu-zu-de-zui-xiao-shu-zi-lcof

**示例 1：**

```
输入：[3,4,5,1,2]
输出：1
```

**示例 2：**

```
输入：[2,2,2,0,1]
输出：0
```

**解:**

```c++
#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    int minArray1(vector<int>& numbers)//线性查找
    {
        if(numbers[0]<numbers[numbers.size() - 1])
            return numbers[0];
        for (int i = numbers.size() - 1; i > 0; i--)
        {
            if (numbers[i - 1] > numbers[i])
                return numbers[i];
        }
        return numbers[0];
    }
    int minArray2(vector<int>& numbers)//二分法
    {
        int size = numbers.size();
        if (size == 0) {
            return 0;
        }
        int left = 0;
        int right = size - 1;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (numbers[mid] > numbers[right]) {
                // [3, 4, 5, 1, 2]，mid 以及 mid 的左边一定不是最小数字
                // 下一轮搜索区间是 [mid + 1, right]
                left = mid + 1;
            }
            else if (numbers[mid] == numbers[right]) {
                // 只能把 right 排除掉，下一轮搜索区间是 [left, right - 1]
                right--;
            }
            else {
                // 此时 numbers[mid] < numbers[right]
                // mid 的右边一定不是最小数字，mid 有可能是，下一轮搜索区间是 [left, mid]
                right = mid;
            }
        }
        return numbers[left];
    }
};

int main()
{
    Solution s;
}
```

二分查找（减治思想）
题目中给出的是半有序数组，虽然传统二分告诉我们二分只能用在有序数组中，但事实上，只要是可以减治的问题，仍然可以使用二分思想。

**思路：**
数组中最特殊的位置是左边位置 left 和右边位置 right，将它们与中间位置 mid 的值进行比较，进而判断最小数字出现在哪里。

用左边位置 left 和中间位置 mid 的值进行比较是否可以？
举例：[3, 4, 5, 1, 2] 与 [1, 2, 3, 4, 5] ，此时，中间位置的值都比左边大，但最小值一个在后面，一个在前面，因此这种做法不能有效地减治。

用右边位置 right 和中间位置 mid 的值进行比较是否可以？
举例：[1, 2, 3, 4, 5]、[3, 4, 5, 1, 2]、[2, 3, 4, 5 ,1]，用右边位置和中间位置的元素比较，可以进一步缩小搜索的范围。

补充说明：遇到 nums[mid] == nums[right] 的时候，不能草率地下定结论最小数字在哪一边，但是可以确定的是，把 right 舍弃掉，并不影响结果。

# 12. 矩阵中的路径

21-7-18

**描述:**
给定一个 m x n 二维字符网格 board 和一个字符串单词 word 。
如果 word 存在于网格中，返回 true ；
否则，返回 false 。

单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。
同一个单元格内的字母不允许被重复使用。

例如，在下面的 3×4 的矩阵中包含单词 "ABCCED"（单词中的字母已标出）。

![image-20210717130732349](attachments/notes/程序/算法/剑指offer/IMG-20250428102905861.png)
链接：https://leetcode-cn.com/problems/ju-zhen-zhong-de-lu-jing-lcof

**示例 1：**
输入：
board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
输出：
true

**示例 2：**
输入：board = [["a","b"],["c","d"]], word = "abcd"
输出：false

**提示：**
1 <= board.length <= 200
1 <= board[i].length <= 200
board 和 word 仅由大小写英文字母组成

**解:**

```c++
#include <iostream>
#include <vector>
using namespace std;

class Solution {
    string word;
    vector<vector<char>>board;
    int rowNum,colNum;
public:
    bool exist(vector<vector<char>>& board, string word) 
    {
        rowNum = board.size();
        colNum = board[0].size();
        
        this->word = word;
        this->board = board;
        for (int i = 0; i < rowNum; i++)
        {
            for (int j = 0; j < colNum; j++)
            {
                if (dfs(i, j, 0))
                    return true;
            }
        }
        return false;
    }
    bool dfs(int i,int j,int k)
    {
        if (i < 0 || j < 0 || i>=rowNum || j>=colNum)//越界判断
            return false;
        if (board[i][j]=='\0')
            return false;
        if (board[i][j] != word[k])
            return false;
        else
        {
            if (k == word.size() - 1)
                return true;

            board[i][j] = '\0';
            if (dfs(i + 1, j, k + 1) || dfs(i - 1, j, k + 1) || dfs(i, j + 1, k + 1) || dfs(i, j - 1, k + 1))
                return true;
            else
            {
                board[i][j] = word[k];
                return false;
            }  
        }
    }
};
int main()
{
    Solution s;
    vector<char> a({'A','B','C','E'});
    vector<char> b({ 'S','F','C','S' });
    vector<char> c({ 'A','D','E','E' });
    vector<vector<char>> board({a,b,c});
    cout << s.exist(board,"ABCCED") << endl;
}
```

**思路:**

本问题是典型的矩阵搜索问题，可使用 深度优先搜索（DFS）+ 剪枝 解决。
![image-20210718125453317](attachments/notes/程序/算法/剑指offer/IMG-20250428102906171.png)

**深度优先搜索：** 
可以理解为暴力法遍历矩阵中所有字符串可能性。
DFS 通过递归，先朝一个方向搜到底，再回溯至上个节点，沿另一个方向搜索，以此类推。

**剪枝：** 
在搜索中，遇到 这条路不可能和目标字符串匹配成功 的情况
（例如：此矩阵元素和目标字符不同、此元素已被访问），则应立即返回，称之为 可行性剪枝 。

**DFS 解析：**

- 递归参数： 
  当前元素在矩阵 board 中的行列索引 i 和 j ，当前目标字符在 word 中的索引 k 。

- 终止条件：

  - 返回 false：
     (1) 行或列索引越界 或 (2) 当前矩阵元素与目标字符不同 或 (3) 当前矩阵元素已访问过 
    （ (3) 可合并至 (2) ） 

  - 返回 true： 
    k = len(word) - 1 ，即字符串 word 已全部匹配。

- 递推工作：
  - 标记当前矩阵元素： 
    将 board\[i][j] 修改为 空字符 '' ，代表此元素已访问过，防止之后搜索时重复访问。
  - 搜索下一单元格： 
    朝当前元素的 上、下、左、右 四个方向开启下层递归，使用 或 连接 （代表只需找到一条可行路径就直接返回，不再做后续 DFS ），并记录结果至 res 。
  - 还原当前矩阵元素： 
    将 board[i][j] 元素还原至初始值，即 word[k] 。
  - 返回值： 
    返回布尔量 res ，代表是否搜索到目标字符串。


> 使用空字符（Python: '' , Java/C++: '\0' ）做标记是为了防止标记字符与矩阵原有字符重复。当存在重复时，此算法会将矩阵原有字符认作标记字符，从而出现错误。

**复杂度分析：**
M, NM,N 分别为矩阵行列大小， KK 为字符串 word 长度。

- **时间复杂度**$O(3^KMN)$：
  最差情况下，需要遍历矩阵中长度为 K 字符串的所有方案，时间复杂度为$O(3^K)$；
  矩阵中共有 MN个起点，时间复杂度为 O(MN) 。
- **方案数计算：**
  设字符串长度为 KK ，搜索中每个字符有上、下、左、右四个方向可以选择，舍弃回头（上个字符）的方向，剩下 33 种选择，因此方案数的复杂度为 $O(3^K)$。
- **空间复杂度** O(K) ： 
  搜索过程中的递归深度不超过 KK ，因此系统因函数调用累计使用的栈空间占用 O(K) （因为函数返回后，系统调用的栈空间会释放）。
  最坏情况下 K = MN ，递归深度为 MN ，此时系统栈使用 O(MN)的额外空间。

# 13. 机器人的运动范围

21-7-18

**描述:**
地上有一个m行n列的方格，从坐标 [0,0] 到坐标 [m-1,n-1] 。
一个机器人从坐标 [0, 0] 的格子开始移动，它每次可以向左、右、上、下移动一格（不能移动到方格外），也不能进入行坐标和列坐标的数位之和大于k的格子。
例如，当k为18时，机器人能够进入方格 [35, 37] ，因为3+5+3+7=18。
但它不能进入方格 [35, 38]，因为3+5+3+8=19。请问该机器人能够到达多少个格子？

**链接：**
https://leetcode-cn.com/problems/ji-qi-ren-de-yun-dong-fan-wei-lcof

**示例 1：**
输入：m = 2, n = 3, k = 1
输出：3

**示例 2：**
输入：m = 3, n = 1, k = 0
输出：1

**提示：**
1 <= n,m <= 100
0 <= k <= 20

**解:**

```c++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;

class Solution {
    int rowNum,colNum;

    int sums(int i,int j)
    {
        int s1 = 0;
        int s2 = 0;
        while (i != 0 || j!=0) 
        {
            if (i != 0)
            {
                s1 += i % 10;
                i = i / 10;
            }
            if (j != 0)
            {
                s2 += j % 10;
                j = j / 10;
            }
        }
        return s1+s2<=k;
    }
    int m, n, k;
    int counter;
    vector<vector<bool>>* visited;
public:
    int movingCount(int m, int n, int k) 
    {
        rowNum = m;
        colNum = n;
        this->k=k;
        counter = 0;
        visited=new vector<vector<bool>>(m, vector<bool>(n, 0));
        bfs();
        return counter;
    }
    void bfs()
    {
        queue<int*>q;
        q.push(new int[2]{ 0,0 });
        while (!q.empty())
        {
            int* p = q.front();
            int i = p[0];
            int j = p[1];
            q.pop();

            if (i >= rowNum || j >= colNum || !sums(i, j) || visited->at(i).at(j))
                continue;
            counter++;
            visited->at(i).at(j) = true;

            q.push(new int[2]{ i + 1,j }); 
            q.push(new int[2]{ i,j + 1 });     
        }
    }
    void dfs(int i, int j)
    {
        if (i >= rowNum || j >= colNum)//越界判断
            return;
        if (visited->at(i).at(j))
            return;
        visited->at(i).at(j) = true;
        if (!sums(i, j))
            return;
        counter++;
        cout << i << "\t" << j << endl;
        dfs(i + 1, j);
        dfs(i, j + 1);
    }
};
int main()
{
    Solution s;
    cout << s.movingCount(3,2,17) << endl;
}
```

类似与12题，深搜与广搜两种解法

# 14. 剪绳子1 

21-7-19

**描述:**
给你一根长度为 n 的绳子，请把绳子剪成整数长度的 m 段（m、n都是整数，n>1并且m>1），每段绳子的长度记为 k[0],k[1]...k[m-1] 。
请问 k[0]*k[1]*...*k[m-1] 可能的最大乘积是多少？

例如，当绳子的长度是8时，我们把它剪成长度分别为2、3、3的三段，此时得到的最大乘积是18。

**链接：**
https://leetcode-cn.com/problems/jian-sheng-zi-lcof

**示例 1：**
输入: 2
输出: 1
解释: 2 = 1 + 1, 1 × 1 = 1

**示例 2:**
输入: 10
输出: 36
解释: 10 = 3 + 3 + 4, 3 × 3 × 4 = 36

**提示：**
2 <= n <= 58

**解:**

```c++
#include <iostream>
#include <algorithm>

using namespace std;

class Solution 
{
public:
    int dpf(int n)//动态规划
    {
        if (n < 4)
            return n - 1;
        int* dp = new int[n + 1];
        dp[1] = 1;
        dp[2] = 2;
        dp[3] = 3;
        for (int i = 4; i <= n; i++)
        {
            int max_val = 0;
            for (int j = 1; j <= i / 2; j++)
            {
                max_val = max(max_val, dp[i - j] * dp[j]);
            }
            dp[i] = max_val;
        }
        return dp[n];
    }
    int greedy(int n)//贪心算法
    {
        if (n < 4)
            return n - 1;
        int a = n / 3;
        int b = n % 3;
        if (b == 0) //能全部拆成3
            return pow(3, a);
        if (b == 1) //余1，少拆个3，换成3+1=4
            return pow(3, a - 1) * 4;
        return pow(3, a) * 2;//余2，直接乘2
    }
};
int main()
{
    Solution s;
    cout << s.dpf(10) << endl;
    cout << s.greedy(10) << endl;
}
```

**思路:**
**动态规划**
**算法流程：**

- 我们想要求长度为n的绳子剪掉后的最大乘积，可以从前面比n小的绳子转移而来
- 用一个dp数组记录从0到n长度的绳子剪掉后的最大乘积，也就是dp[i]表示长度为i的绳子剪成m段后的最大乘积，初始化dp[2] = 1
- 我们先把绳子剪掉第一段（长度为j），如果只剪掉长度为1，对最后的乘积无任何增益，所以从长度为2开始剪
- 剪了第一段后，剩下(i - j)长度可以剪也可以不剪。如果不剪的话长度乘积即为j * (i - j)；如果剪的话长度乘积即为j * dp[i - j]。取两者最大值max(j * (i - j), j * dp[i - j])
- 第一段长度j可以取的区间为[2,i)，对所有j不同的情况取最大值，因此最终dp[i]的转移方程为
  dp[i] = max(dp[i], max(j * (i - j), j * dp[i - j]))
- 最后返回dp[n]即可

**复杂度分析**

- 时间复杂度：O(n ^ 2)*O*(*n*2)
- 空间复杂度：O(n)*O*(*n*)



**贪心算法:**

找规律或数学证明可知： **尽可能将绳子以长度 3 等分为多段时，乘积最大。**

**算法流程：**
当 n≤3 时，按照规则应不切分，但由于题目要求必须剪成 m>1 段，因此必须剪出一段长度为 1 的绳子，即返回 n - 1。
当 n>3时，求 n除以 3 的 整数部分 a 和 余数部分 b（即 n = 3a + b），并分为以下三种情况：

- 当 b = 0时，直接返回 pow(3,a)；
- 当 b = 1时，要将一个 1 + 3 转换为 2+2，因此返回pow(3,a-1)\*4；
- 当 b = 2b=2 时，返回 pow(3,a)\*2 ;

**复杂度分析：**

- 时间复杂度 O(1)： 
  仅有求整、求余、次方运算。
  - 求整和求余运算：
    资料提到不超过机器数的整数可以看作是 O(1)O(1) ；
  - 幂运算：
    查阅资料，提到浮点取幂为 O(1)O(1) 。
- 空间复杂度 O(1)： 变量 a 和 b 使用常数大小额外空间。

# 15. 二进制中1的个数

21-7-19

**描述:**
编写一个函数，输入是一个无符号整数（以二进制串的形式），返回其二进制表达式中数字位数为 '1' 的个数（也被称为 汉明重量).）。

> 提示：
> 请注意，在某些语言（如 Java）中，没有无符号整数类型。
> 在这种情况下，输入和输出都将被指定为有符号整数类型，并且不应影响您的实现，因为无论整数是有符号的还是无符号的，其内部的二进制表示形式都是相同的。
> 在 Java 中，编译器使用 二进制补码 记法来表示有符号整数。
> 因此，在上面的 示例 3 中，输入表示有符号整数 -3。

**链接：**
https://leetcode-cn.com/problems/er-jin-zhi-zhong-1de-ge-shu-lcof

**示例 1：**
输入：n = 11 
(控制台输入 00000000000000000000000000001011)
输出：3
解释：
输入的二进制串 00000000000000000000000000001011 中，共有三位为 '1'。

**示例 2：**
输入：n = 128 
(控制台输入 00000000000000000000000010000000)
输出：1
解释：
输入的二进制串 00000000000000000000000010000000 中，共有一位为 '1'。

**示例 3：**
输入：n = 4294967293
 (控制台输入 11111111111111111111111111111101，部分语言中 n = -3）
输出：31
解释：
输入的二进制串 11111111111111111111111111111101 中，共有 31 位为 '1'。

**提示：**
输入必须是长度为 32 的 二进制串 。

**解:**

```c++
#include <iostream>

using namespace std;

class Solution {
public:
    int hammingWeight(uint32_t n)
    {
        int counter = 0;
        while (n!=0)
        {
            if (n & 1 == 1)
                counter++;
            n = n >> 1;
        }
        return counter;
    }
};
int main()
{
    Solution s;
    cout << s.hammingWeight(4294967293) << endl;
}
```

简单位运算，略

# 16. 数值的整数次方

21-7-26

**描述:**
实现 pow(x, n) ，即计算 x 的 n 次幂函数（即，xn）。

不得使用库函数，同时不需要考虑大数问题。

**链接：**
https://leetcode-cn.com/problems/shu-zhi-de-zheng-shu-ci-fang-lcof

**示例 1：**
输入：x = 2.00000, n = 10
输出：1024.00000

**示例 2：**
输入：x = 2.10000, n = 3
输出：9.26100

**示例 3：**
输入：x = 2.00000, n = -2
输出：0.25000
解释：2-2 = 1/22 = 1/4 = 0.25

**提示：**
-100.0 < x < 100.0
-231 <= n <= 231-1
-104 <= xn <= 104

**解:**

```c++
#include <iostream>

using namespace std;

class Solution 
{
public:
    double myPow1(double x, long n) 
        //递归快速幂+位运算(会爆栈)
    {
        if (x == 0)return 0;
        if (x == 1)return 1;
        if (x == -1)
        {
            if (n % 2 == 0)return 1;
            else return -1;
        }

        if (n == 0)return 1;
        if (n == 1)return x;
        if (n < 0)return 1.0/myPow1(x, -n);

        if((n&1)==1)
            return myPow1(x, n-1)*x;
        n = n >>1;
        double t = myPow1(x, n);
        return t * t;
    }
    double myPow2(double x, long n)
        //迭代快速幂
    {
        if (x == 0)return 0;
        if (x == 1)return 1;
        if (x == -1)
        {
            if (n % 2 == 0)return 1;
            else return -1;
        }

        if (n == 0)return 1;
        if (n == 1)return x;
        if (n == -1)return 1.0 / x;

        if (n < 0)
        {
            n = -n;
            x = 1.0 / x;
        }

        double output = 1;
        
        while (n>0)
        {
            if ((n & 1) == 1)
                output *= x;
            x *= x;
            n = n >> 1;
        }
        return output;
    }
    double myPow3(double x, long n)
        //2分法
    {
        if (n == 0) return 1;
        if (n == 1) return x;
        if (n == -1) return 1 / x;
        double half = myPow3(x, n / 2);
        double mod = myPow3(x, n % 2);
        return half * half * mod;
    }
};
int main()
{
    Solution s;
    cout << s.myPow2(2.00000, -2147483648) << endl;
}
```

- 快速幂
- 二分法
- 位运算
- int类型边界
  -2147483648

# 17. 打印从1到最大的n位数

21-7-26

**描述:**
输入数字 n，按顺序打印出从 1 到最大的 n 位十进制数。

比如输入 3，则打印出 1、2、3 一直到最大的 3 位数 999。

链接：https://leetcode-cn.com/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof

**示例 1:**
输入: n = 1
输出: [1,2,3,4,5,6,7,8,9]

**说明：**
用返回一个整数列表来代替打印
n 为正整数

**解:**

```c++
#include <iostream>
#include <vector>

using namespace std;

class Solution {
    char numChar[10] = { '0','1','2','3','4','5','6','7','8','9' };
    vector<string> output;
    int n;
public:
    vector<int> printNumbers(int n) 
    {
        this->n = n;
        dfs("", 0);
        vector<int>intOutput;
        for (int i = 1; i < output.size(); i++)
        {
            intOutput.push_back(atoi(output[i].c_str()));
        }
        return intOutput;
    }
    void dfs(string num,int x)
    {
        if (x == n)
        {
            output.push_back(num);
            return;
        }
        for (int i = 0; i < 10; i++)
        {
            string str = num+numChar[i];
            dfs(str, x + 1);
        }
    }
};
int main()
{
    Solution s;
    vector<int>intOutput=s.printNumbers(2);
    for (int i = 0; i < intOutput.size(); i++)
    {
        cout << intOutput[i]<<endl;
    }
}
```

本题的主要考点是大数越界情况下的打印。

需要解决以下三个问题：

- 表示大数的变量类型：
  无论是 short / int / long ... 任意变量类型，数字的取值范围都是有限的。因此，大数的表示应用字符串 String 类型。
- 生成数字的字符串集：
  使用 int 类型时，每轮可通过 +1+1 生成下个数字，而此方法无法应用至 String 类型。
  并且， String 类型的数字的进位操作效率较低，例如 "9999" 至 "10000" 需要从个位到千位循环判断，进位 4 次。
  观察可知，生成的列表实际上是 nn 位 00 - 99 的 全排列 ，因此可避开进位操作，通过递归生成数字的 String 列表。
- 递归生成全排列：
  基于分治算法的思想，先固定高位，向低位递归，当个位已被固定时，添加数字的字符串。
  例如当 n = 2n=2 时（数字范围 1 - 991−99 ），固定十位为 00 - 99 ，按顺序依次开启递归，固定个位 00 - 99 ，终止递归并添加数字字符串。

![image-20210726150257820](attachments/notes/程序/算法/剑指offer/IMG-20250428102906496.png)

即：使用深度优先搜索算法(dfs)。

# 18. 删除链表的节点

21-7-26

**描述:**
给定单向链表的头指针和一个要删除的节点的值，定义一个函数删除该节点。
返回删除后的链表的头节点。

**链接：**
https://leetcode-cn.com/problems/shan-chu-lian-biao-de-jie-dian-lcof

**示例 1:**
输入: head = [4,5,1,9], val = 5
输出: [4,1,9]
解释: 给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9.

**示例 2:**
输入: head = [4,5,1,9], val = 1
输出: [4,5,9]
解释: 给定你链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 4 -> 5 -> 9.

**说明：**
题目保证链表中节点的值互不相同
若使用 C 或 C++ 语言，你不需要 free 或 delete 被删除的节点

**解:**

```c++
#include <iostream>
#include <vector>

using namespace std;

struct ListNode
{
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(NULL) {}
};
class Solution
{
    
public:
    ListNode* deleteNode(ListNode* head, int val) 
    {
        if (head == NULL)return NULL;
        if (head->val == val)return head->next;
        ListNode* p, * q;
        p = head;
        q = head->next;
        while (q->next!=NULL)
        {
            if (q->val == val)
            {
                p->next = q->next;
                return head;
            }
            p = p->next;
            q = p->next;
        }
        p->next = NULL;
        return head;
    }
};
    

int main()
{
    Solution s;
    ListNode* head = new ListNode(1);
    ListNode* p = head;
    for (int i = 2; i < 10; i++)
    {
        p->next = new ListNode(i);
        p = p->next;
    }
    p = s.deleteNode(head, 1);
    while (p!=NULL)
    {
        cout << p->val << endl;
        p = p->next;
    }
}
```

简单的链表删除节点，双指针操作

# 19.正则表达式匹配

21-7-26

**描述:**
请实现一个函数用来匹配包含'. '和'*'的正则表达式。*

*模式中的字符'.'表示任意一个字符，而'*'表示它前面的字符可以出现任意次（含0次）。

在本题中，匹配是指字符串的所有字符匹配整个模式。
例如，字符串"aaa"与模式"a.a"和"ab*ac*a"匹配，但与"aa.a"和"ab*a"均不匹配。

**链接：**
https://leetcode-cn.com/problems/zheng-ze-biao-da-shi-pi-pei-lcof

**示例 1:**
输入:
s = "aa"
p = "a"
输出: false
解释: "a" 无法匹配 "aa" 整个字符串。

**示例 2:**
输入:
s = "aa"
p = "a*"
输出: true
解释: 因为 '*' 代表可以匹配零个或多个前面的那一个元素, 在这里前面的元素就是 'a'。因此，字符串 "aa" 可被视为 'a' 重复了一次。

**示例 3:**
输入:
s = "ab"
p = ".*"
输出: true
解释: ".*" 表示可匹配零个或多个（'*'）任意字符（'.'）。

**示例 4:**
输入:
s = "aab"
p = "c*a*b"
输出: true
解释: 因为 '*' 表示零个或多个，这里 'c' 为 0 个, 'a' 被重复一次。因此可以匹配字符串 "aab"。

**示例 5:**
输入:
s = "mississippi"
p = "mis*is*p*."
输出: false

**注意：**

- s 可能为空，且只包含从 a-z 的小写字母。
- p 可能为空，且只包含从 a-z 的小写字母以及字符 . 和 *，无连续的 '\*’。

**解:**

```c++
#include <iostream>
#include <vector>

using namespace std;

class Solution
{
public:
    bool isMatch(string s, string p) 
    {
        int m = s.size()+1;
        int n = p.size()+1;

        vector<vector<bool>> dp(m, vector<bool>(n, false));
        dp[0][0] = true;
        // 初始化首行
        for (int j = 2; j < n; j += 2)
            dp[0][j] = dp[0][j - 2] && p[j - 1] == '*';

        for (int i = 1; i < m; i++)
        {
            for (int j = 1; j < n; j++)
            {
                if (p[j - 1] == '*')
                {
                    if (dp[i][j - 2] ||
                        (dp[i - 1][j] && s[i - 1] == p[j - 2]) ||
                        (dp[i - 1][j] && p[j - 2] == '.'))
                    {
                        dp[i][j] = true;
                        continue;
                    }
                }
                else
                {
                    if ((dp[i - 1][j - 1] && s[i - 1] == p[j - 1]) ||
                        dp[i - 1][j - 1] && p[j - 1] == '.'
                        )
                    {
                        dp[i][j] = true;
                        continue;
                    }   
                }
                dp[i][j] = false;
            }
        }
        return dp[m-1][n-1];
    }
};
    

int main()
{
    Solution s;
    cout << s.isMatch("aa","a") << endl;
}
```

**思路:**

- 状态数组：设二维数组

  ```
  dp[m+1][n+1]
  ```

  ，m和n是s、p的长度

  - 特殊说明：`dp[i][j]`表示s下标为`s[i-1]`的字符，p下标为`p[j-1]`字符

- 初始化：

  ```
  dp[i][j]
  ```

  表示 s的前i个字符和p的前j个字符是否匹配

  - `dp[0][0]=true`，表示s和p的前0个字符均为空串肯定匹配
  - 若s是空串且p 的偶数次下标为$*$,那也是匹配的

- 状态转移：

  - ```
    p.charAt(j - 1) == '*'
    ```

    ,有三种情况匹配

    - `dp[i][j - 2]`，既是`p[j-2]`出现0次
    - `(dp[i - 1][j] && s.charAt(i - 1) == p.charAt(j - 2)`，`p[j-2]`出现1次 且 当前i-1和j-2指向的字符相同
    - `dp[i - 1][j] && p.charAt(j - 2) == '.'`，最特殊情况:`p[j-2]=. p[j-1]=*`时，根据条件知是万能匹配

  - ```
    p.charAt(j - 1) != '*'
    ```

    ,有两种情况匹配

    - `dp[i - 1][j - 1] && s.charAt(i - 1) == p.charAt(j - 1)`，前面元素之前都匹配 且 当前元素也相容
    - `dp[i - 1][j - 1] && p.charAt(j - 1) == '.'`，前面元素之前都匹配 且 p的当期元素是`.`

- 返回值：`dp[m-1][n-1]`

# 20. 表示数值的字符串#

21-7-26

**描述:**
请实现一个函数用来判断字符串是否表示数值（包括整数和小数）。

数值（按顺序）可以分成以下几个部分：

- 若干空格

- 一个 小数 或者 整数

- （可选）一个 'e' 或 'E' ，后面跟着一个 整数

- 若干空格

小数（按顺序）可以分成以下几个部分：

- （可选）一个符号字符（'+' 或 '-'）
- 下述格式之一：
  - 至少一位数字，后面跟着一个点 '.'
  - 至少一位数字，后面跟着一个点 '.' ，后面再跟着至少一位数字
  - 一个点 '.' ，后面跟着至少一位数字

整数（按顺序）可以分成以下几个部分：

- （可选）一个符号字符（'+' 或 '-'）

- 至少一位数字

部分数值列举如下：
- ["+100", "5e2", "-123", "3.1416", "-1E-16", "0123"]

部分非数值列举如下：
- ["12e", "1a3.14", "1.2.3", "+-5", "12e+5.4"]

**链接：**
https://leetcode-cn.com/problems/biao-shi-shu-zhi-de-zi-fu-chuan-lcof

**示例 1：**
输入：s = "0"
输出：true

**示例 2：**
输入：s = "e"
输出：false

**示例 3：**
输入：s = "."
输出：false

**示例 4：**
输入：s = "    .1  "
输出：true

**提示：**
1 <= s.length <= 20
s 仅含英文字母（大写和小写），数字（0-9），加号 '+' ，减号 '-' ，空格 ' ' 或者点 '.' 。



# 21. 调整数组顺序使奇数位于偶数前面

**描述:**
输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有奇数位于数组的前半部分，所有偶数位于数组的后半部分。

**链接：**
https://leetcode-cn.com/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof

**示例：**
输入：nums = [1,2,3,4]
输出：[1,3,2,4] 
注：[3,1,2,4] 也是正确的答案之一。

**提示：**
0 <= nums.length <= 50000
1 <= nums[i] <= 10000

**解:**

双指针

```python
class Solution:
    def exchange(self, nums: List[int]) -> List[int]:
        if len(nums)==0:
            return nums
        iStart = 0
        iEnd = len(nums)-1
        while iStart != iEnd:
            if nums[iStart] % 2 != 0:
                iStart += 1
                continue
            if nums[iEnd] % 2 == 0:
                iEnd -= 1
                continue
            t = nums[iStart]
            nums[iStart] = nums[iEnd]
            nums[iEnd] = t
        return nums
```

# 22. 链表中倒数第k个节点

**描述：**
输入一个链表，输出该链表中倒数第k个节点。
为了符合大多数人的习惯，本题从1开始计数，即链表的尾节点是倒数第1个节点。

例如，一个链表有 6 个节点，从头节点开始，它们的值依次是 1、2、3、4、5、6。
这个链表的倒数第 3 个节点是值为 4 的节点。

**链接：**
https://leetcode-cn.com/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof

**示例：**
给定一个链表: 1->2->3->4->5, 和 k = 2。
返回链表 4->5。

**解：**
快慢双指针

```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def getKthFromEnd(self, head: ListNode, k: int) -> ListNode:
        if head == None:
            return None
        first = head
        last = head
        for i in range(k-1):
            first = first.next
            if first == None:
                return None
        while first.next is not None:
            first = first.next
            last = last.next
        return last
```



# 24.  反转列表

**描述:**
定义一个函数，输入一个链表的头节点，反转该链表并输出反转后链表的头节点。

**链接：**
https://leetcode-cn.com/problems/fan-zhuan-lian-biao-lcof

**示例:**
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL

限制：
0 <= 节点个数 <= 5000

**解:**
快慢三指针

```python
class ListNode:
     def __init__(self, x):
         self.val = x
         self.next = None

class Solution:
    def reverseList(self, head):
        if head == None:
            return None
        if head.next == None:
            return head
        
        first = head
        last = None
        t = head.next
        while t is not None:
            first.next = last
            last = first
            first = t
            t = t.next
        first.next = last
        return first
        

if __name__ == "__main__":
    head = ListNode(1)
    Node1 = ListNode(2)
    head.next = Node1
    Node2 = ListNode(3)
    Node1.next = Node2
    s = Solution()
    output = s.reverseList(head)
    while output is not None:
        print(output.val)
        output = output.next
```



# 25. 合并两个排序的列表

**描述:**

输入两个递增排序的链表，合并这两个链表并使新链表中的节点仍然是递增排序的。

**示例1：**
输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4

**限制：**
0 <= 链表长度 <= 1000

**解:**

归并排序

```python
class ListNode:
     def __init__(self, x):
         self.val = x
         self.next = None

class Solution:
    def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
        if l1 is None and l2 is None:
            return None
        if l1 is None:
            return l2
        if l2 is None:
            return l1
        p1 = l1
        p2 = l2
        head = ListNode(-1)
        p3 = head
        while p1 is not None or p2 is not None:
            if p1 is None:
                p3.next = p2
                p2 = p2.next
                p3 = p3.next
                continue
            if p2 is None:
                p3.next = p1
                p1 = p1.next
                p3 = p3.next
                continue
            if p1.val < p2.val:
                p3.next = p1
                p1 = p1.next
                p3 = p3.next
            else:
                p3.next = p2
                p2 = p2.next
                p3 = p3.next
        return head.next
        

if __name__ == "__main__":
    head1 = ListNode(1)
    Node1 = ListNode(3)
    head1.next = Node1
    Node2 = ListNode(5)
    Node1.next = Node2

    head2 = ListNode(2)
    Node1 = ListNode(4)
    head2.next = Node1
    Node2 = ListNode(6)
    Node1.next = Node2

    s = Solution()
    output = s.mergeTwoLists(head1, head2)
    while output is not None:
        print(output.val)
        output = output.next
```

# 26. 树的子结构

**描述:**
输入两棵二叉树A和B，判断B是不是A的子结构。
(约定空树不是任意一个树的子结构)

B是A的子结构， 即 A中有出现和B相同的结构和节点值。

**例如:**
给定的树 A:

```
 	    3  
	   / \  
	  4   5 
	 / \ 
	1  2
```
给定的树 B：
```
  4  
 / 
1
返回 true，因为 B 与 A 的一个子树拥有相同的结构和节点值。
```
**示例 1：**

```
输入：A = [1,2,3], B = [3,1]
输出：false
```

**示例 2：**

```
输入：A = [3,4,5,1,2], B = [4,1]
输出：true
```

**链接:**
https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof/

**限制：**

```
0 <= 节点个数 <= 10000
```

**解:**
简单的树的搜索

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def isSubStructure(self, A, B):
        if A is None or B is None:
            return False
        self.targetNodeList = list()
        self.dfs(A,B)
        if len(self.targetNodeList) == 0:
            return False
        output = False
        for targetNode in self.targetNodeList:
            if self.isSubTree(targetNode,B):
                output = True
        return output


    def dfs(self,root,target):
        if root is None:
            return
        if root.val == target.val:
            self.targetNodeList.append(root)
        return self.dfs(root.left,target) or self.dfs(root.right,target)
    
    def isSubTree(self,a,b):
        if b is None:
            return True
        if a is None:
            return False
        if a.val != b.val:
            return False
        return self.isSubTree(a.left,b.left) and self.isSubTree(a.right,b.right)
```



# 27. 二叉树的镜像

**描述:**
请完成一个函数，输入一个二叉树，该函数输出它的镜像。

**链接：**
https://leetcode-cn.com/problems/er-cha-shu-de-jing-xiang-lcof

**示例:**

```
例如输入：
     4
   /   \
  2     7
 / \   / \
1   3 6   9

镜像输出：
     4
   /   \
  7     2
 / \   / \
9   6 3   1
```

**示例 1：**

输入：root = [4,2,7,1,3,6,9]
输出：[4,7,2,9,6,3,1]

**限制：**

0 <= 节点个数 <= 1000

**解:**

递归与深度优先搜索

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def mirrorTree(self, root: TreeNode) -> TreeNode:
        if root is None:
            return None
        self.dfs(root)
        return root
    
    def dfs(self,root):
        if root is None:
            return 
        t = root.left
        root.left = root.right
        root.right = t
        self.dfs(root.left)
        self.dfs(root.right)
```

# 28. 对称的二叉树

**描述：**
请实现一个函数，用来判断一棵二叉树是不是对称的。如果一棵二叉树和它的镜像一样，那么它是对称的。

例如，二叉树 [1,2,2,3,4,4,3] 是对称的。
    1
   / \
  2   2
 / \ / \
3  4 4  3
但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:
    1
   / \
  2   2
   \   \
   3    3

链接：https://leetcode-cn.com/problems/dui-cheng-de-er-cha-shu-lcof

**示例 1：**
输入：root = [1,2,2,3,4,4,3]
输出：true

**示例 2：**
输入：root = [1,2,2,null,3,null,3]
输出：false

**限制：**
0 <= 节点个数 <= 1000

**解：**

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetric(self, root: TreeNode) -> bool:
        if root is None:
            return True
        return self.dfs(root.left,root.right)

    def dfs(self,L,R):
        if L is None and R is None:
            return True
        if L is None or R is None:
            return False
        if L.val != R.val:
            return False
        return self.dfs(L.left,R.right) and self.dfs(L.right,R.left)
```

# 29. 顺时针打印矩阵

输入一个矩阵，按照从外向里以顺时针的顺序依次打印出每一个数字。

**示例 1：**

```
输入：matrix = [[1,2,3],[4,5,6],[7,8,9]]
输出：[1,2,3,6,9,8,7,4,5]
```

**示例 2：**

```
输入：matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
输出：[1,2,3,4,8,12,11,10,9,5,6,7]
```

**限制：**

- `0 <= matrix.length <= 100`
- `0 <= matrix[i].length <= 100`

**解：**
模拟法

```python
class Solution:
    def spiralOrder(self, matrix):
        output = list()
        if len(matrix) == 0:
            return output
        l = 0 
        r = len(matrix[0]) - 1
        t = 0
        b = len(matrix) - 1

        while True:
            if l > r:
                break
            for i in range(l, r + 1):
                output.append(matrix[t][i])
            t += 1

            if t > b:
                break
            for j in range(t ,b + 1):
                output.append(matrix[j][r])
            r -= 1

            if l > r:
                break
            for i in range(r, l - 1, -1):
                output.append(matrix[b][i])
            b -= 1

            if  t > b:
                break
            for j in range(b, t - 1, -1):
                output.append(matrix[j][l])
            l += 1

        return output

if __name__ == "__main__":
    s = Solution()
    matrix = [[1,2,3],[4,5,6],[7,8,9]]
    print(s.spiralOrder(matrix))
```

# 30. 包含min函数的栈

**描述：**
定义栈的数据结构，请在该类型中实现一个能够得到栈的最小元素的 min 函数在该栈中，调用 min、push 及 pop 的时间复杂度都是 O(1)。

**示例:**

```
MinStack minStack = new MinStack();
minStack.push(-2);
minStack.push(0);
minStack.push(-3);
minStack.min();   --> 返回 -3.
minStack.pop();
minStack.top();      --> 返回 0.
minStack.min();   --> 返回 -2.
```

 https://leetcode-cn.com/problems/bao-han-minhan-shu-de-zhan-lcof/

**提示：**

1. 各函数的调用总次数不超过 20000 次

**解:**

```python
class MinStack:
    def __init__(self):
        self.stack = list()
        self.minStack = list()

    def push(self, x: int) -> None:
        self.stack.append(x)
        if len(self.minStack) == 0:
            self.minStack.append(x)
        else:
            if x <= self.min():
                self.minStack.append(x)

    def pop(self) -> None:
        if len(self.stack) == 0:
            return None
        x = self.stack.pop(len(self.stack)-1)
        if x == self.min():
            self.minStack.pop(len(self.minStack)-1)
        return x

    def top(self) -> int:
        return self.stack[-1]

    def min(self) -> int:
        return self.minStack[-1]

if __name__ == "__main__":
    s = MinStack()
    s.push(-2)
    s.push(0)
    s.push(-3)
    print(s.min())
    print(s.pop())
    print(s.top())
    print(s.min())
```

**思路：**

使用辅助栈

![image-20210921114403708](attachments/notes/程序/算法/剑指offer/IMG-20250428102906847.png)

# 31. 栈的压入、弹出序列

输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否为该栈的弹出顺序。
假设压入栈的所有数字均不相等。
例如：
序列 {1,2,3,4,5} 是某栈的压栈序列，序列 {4,5,3,2,1} 是该压栈序列对应的一个弹出序列，
但 {4,3,5,1,2} 就不可能是该压栈序列的弹出序列。

**示例 1：**

```
输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
输出：true
解释：我们可以按以下顺序执行：
push(1), push(2), push(3), push(4), pop() -> 4,
push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1
```

**示例 2：**

```
输入：pushed = [1,2,3,4,5], popped = [4,3,5,1,2]
输出：false
解释：1 不能在 2 之前弹出。
```

**提示：**

1. `0 <= pushed.length == popped.length <= 1000`
2. `0 <= pushed[i], popped[i] < 1000`
3. `pushed` 是 `popped` 的排列。

**解：**

模拟法

```python
class Solution:
    def validateStackSequences(self, pushed, popped):
        if len(pushed) == 0 and len(popped) == 0:
            return True  
        queue = list()
        i = 0
        for num in pushed:
            queue.append(num)
            while len(queue) > 0 and queue[-1] == popped[i]:
                queue.pop()
                i += 1
        if len(queue) != 0:
            return False
        return True

if __name__ == "__main__":
    pushed = [1,2,3,4,5]
    popped = [4,3,5,1,2]
    s = Solution()
    print(s.validateStackSequences(pushed,popped))
```

# 32-I. 从上到下打印二叉树

https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/

从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

**例如:**
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回：

```
[3,9,20,15,7]
```

**提示：**

1. `节点总数 <= 1000`

**解：**

简单的广度优先搜索

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def levelOrder(self, root):
        if root is None:
            return []
        queue = list()
        queue.append(root)
        output = list()
        while len(queue) != 0:
            r = queue.pop(0)
            output.append(r.val)
            if r.left is not None:
                queue.append(r.left)
            if r.right is not None:
                queue.append(r.right)
        return output
```

# 32-II. 从上到下打印二叉树

https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof/

从上到下按层打印二叉树，同一层的节点按从左到右的顺序打印，每一层打印到一行。

**例如:**
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回其层次遍历结果：

```
[
  [3],
  [9,20],
  [15,7]
]
```

**提示：**

1. `节点总数 <= 1000`

**解：**
同上题

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None
class Solution:
    def levelOrder(self, root):
        if root is None:
            return []
        queue = list()
        queue.append(root)
        output = list()
        while len(queue) != 0:
            t = list()
            for i in range(len(queue)):
                r = queue.pop(0)
                t.append(r.val)
                if r.left is not None:
                    queue.append(r.left)
                if r.right is not None:
                    queue.append(r.right)            
            output.append(t)
        return output
```

# 32-III. 从上到下打印二叉树

**描述:**
请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

 **链接：**
https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-iii-lcof/)

**例如:**
给定二叉树: `[3,9,20,null,null,15,7]`,

```
    3
   / \
  9  20
    /  \
   15   7
```

返回其层次遍历结果：

```
[
  [3],
  [20,9],
  [15,7]
]
```

**提示：**

1. `节点总数 <= 1000`

**解:**

```python

class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def levelOrder(self, root):
        if root is None:
            return []
        output = list()
        queue = list()
        queue.append(root)
        isBackWord = False
        while len(queue) != 0:
            t = list()
            for i in range(len(queue)):
                r = queue.pop(0)
                if not isBackWord:
                    t.append(r.val)
                else:
                    t.insert(0,r.val)
                if r.left is not None:
                    queue.append(r.left)
                if r.right is not None:
                    queue.append(r.right)
            isBackWord = not isBackWord
            output.append(t)
        return output

if __name__ == "__main__":
    s = Solution()
    head = TreeNode(1)
    head.left = TreeNode(2)
    head.right = TreeNode(3)
    head.left.left = TreeNode(4)
    head.right.right = TreeNode(5)
    output = s.levelOrder(head)
    for i in output:
        print(i)
```

# 33.二叉搜索树的后序遍历序列

**描述:**
输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历结果。如果是则返回 `true`，否则返回 `false`。假设输入的数组的任意两个数字都互不相同。

参考以下这颗二叉搜索树：

```
     5
    / \
   2   6
  / \
 1   3
```

**示例 1：**

```
输入: [1,6,3,2,5]
输出: false
```

**示例 2：**

```
输入: [1,3,2,6,5]
输出: true
```

 **链接:**
https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-hou-xu-bian-li-xu-lie-lcof/

**提示：**

1. `数组长度 <= 1000`

**解：**

辅助单调栈:https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-hou-xu-bian-li-xu-lie-lcof/solution/mian-shi-ti-33-er-cha-sou-suo-shu-de-hou-xu-bian-6/

```python
class Solution:
    def verifyPostorder(self, postorder):
        if len(postorder) < 2:
            return True
        postorder = postorder[::-1]
        if len(postorder) == 2:
            if postorder[0] > postorder[1]:
                return  True
            else:
                return False
        incStack = list()
        root = float('inf')
        for i in range(len(postorder)):
            if postorder[i] >= root:
                return False
            while len(incStack) != 0 and postorder[i] < incStack[-1]:
                root = incStack.pop()
            incStack.append(postorder[i])
        return True
```



# 34.二叉树中和为某一值的路径

**描述:**
输入一棵二叉树和一个整数，打印出二叉树中节点值的和为输入整数的所有路径。从树的根节点开始往下一直到叶节点所经过的节点形成一条路径。

**示例:**
给定如下二叉树，以及目标和 `target = 22`，

```
              5
             / \
            4   8
           /   / \
          11  13  4
         /  \    / \
        7    2  5   1
```

返回:

```
[
   [5,4,11,2],
   [5,8,4,5]
]
```

 **链接:**
https://leetcode-cn.com/problems/er-cha-shu-zhong-he-wei-mou-yi-zhi-de-lu-jing-lcof/

**提示：**

1. `节点总数 <= 10000`

**解：**
深度优先搜索+回溯法
注意，是到叶节点，中间的不算

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution:
    def pathSum(self, root, target):
        if root is None:
            return []
        self.pathList = list()
        path = list()
        self.dfs(root,target,path)
        return self.pathList
        
    def dfs(self, root, target, path):
        if root is None:
            return
        path.append(root.val)
        if root.val == target and root.left is None and root.right is None:
            self.pathList.append(list(path))
        target -= root.val
        self.dfs(root.left, target, path)
        self.dfs(root.right, target, path)
        path.pop()
```



# 35. 复杂链表的复制

**描述:**
请实现 `copyRandomList` 函数，复制一个复杂链表。在复杂链表中，每个节点除了有一个 `next` 指针指向下一个节点，还有一个 `random` 指针指向链表中的任意节点或者 `null`。

**示例 1：**

![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102907174.png)

```
输入：head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
输出：[[7,null],[13,0],[11,4],[10,2],[1,0]]
```

**示例 2：**

![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102907540.png)

```
输入：head = [[1,1],[2,1]]
输出：[[1,1],[2,1]]
```

**示例 3：**

**![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102907870.png)**

```
输入：head = [[3,null],[3,0],[3,null]]
输出：[[3,null],[3,0],[3,null]]
```

**示例 4：**

```
输入：head = []
输出：[]
解释：给定的链表为空（空指针），因此返回 null。
```

 **链接:**
https://leetcode-cn.com/problems/fu-za-lian-biao-de-fu-zhi-lcof/

**提示：**

- `-10000 <= Node.val <= 10000`
- `Node.random` 为空（null）或指向链表中的节点。
- 节点数目不超过 1000 。

**解：**
利用字典把新旧链表对应起来再复制

```python
class Node:
    def __init__(self, x, next = None, random = None):
        self.val = int(x)
        self.next = next
        self.random = random

class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        if not head: return
        dic = {}
        # 3. 复制各节点，并建立 “原节点 -> 新节点” 的 Map 映射
        cur = head
        while cur:
            dic[cur] = Node(cur.val)
            cur = cur.next
        cur = head
        # 4. 构建新节点的 next 和 random 指向
        while cur:
            dic[cur].next = dic.get(cur.next)
            dic[cur].random = dic.get(cur.random)
            cur = cur.next
        # 5. 返回新链表的头节点
        return dic[head]
```

# 36.二叉搜索树与双向链表

**描述:**
输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的循环双向链表。要求不能创建任何新的节点，只能调整树中节点指针的指向。

 为了让您更好地理解问题，以下面的二叉搜索树为例：

 

![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102908232.png)

 

我们希望将这个二叉搜索树转化为双向循环链表。链表中的每个节点都有一个前驱和后继指针。对于双向循环链表，第一个节点的前驱是最后一个节点，最后一个节点的后继是第一个节点。

下图展示了上面的二叉搜索树转化成的链表。“head” 表示指向链表中有最小元素的节点。

 

![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102908517.png)

 

特别地，我们希望可以就地完成转换操作。当转化完成以后，树中节点的左指针需要指向前驱，树中节点的右指针需要指向后继。还需要返回链表中的第一个节点的指针。

**链接：**
https://leetcode-cn.com/problems/er-cha-sou-suo-shu-yu-shuang-xiang-lian-biao-lcof/

**解:**
中序遍历

```python
class Node:
    def __init__(self, val, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def treeToDoublyList(self, root):
        if root is None:
            return None
        self.midOrderList = list()
        self.dfs(root)
        for i in range(1,len(self.midOrderList)):
            self.midOrderList[i].left = self.midOrderList[i-1]
            self.midOrderList[i-1].right = self.midOrderList[i] 
        self.midOrderList[0].left = self.midOrderList[-1]
        self.midOrderList[-1].right = self.midOrderList[0]
        return self.midOrderList[0]

    def dfs(self, root):
        if root is None:
            return
        self.dfs(root.left)
        self.midOrderList.append(root)
        self.dfs(root.right)
```



# 39. 数组中出现次数超过一半的数字

数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。
你可以假设数组是非空的，并且给定的数组总是存在多数元素。

**示例 1:**

```
输入: [1, 2, 3, 2, 2, 2, 5, 4, 2]
输出: 2
```

**限制：**

```
1 <= 数组长度 <= 50000
```

**解：**

```python
class Solution:
    # 摩尔投票法
    def majorityElementByMooreVote(self, nums):
        if len(nums) == 0:
            return None
        if len(nums) == 1:
            return nums[0]
        t = nums[0]
        v = 0
        for i in nums:
            if i == t:
                v += 1
            else:
                v -= 1
            if v < 0:
                t = i
                v = 1
        return t
	
    #快排中位数法
    def majorityElementByQuickSort(self, nums):
        if len(nums) == 0:
            return None
        if len(nums) == 1:
            return nums[0]
        left = 0
        right = len(nums) - 1
        self.quickSort(nums,left,right)
        return nums[len(nums)//2]

    def quickSort(self, arr,left,right):
        if arr is None or len(arr) < 2 or left >= right:
            return
        l = left
        r = right
        p = arr[l]
        while l < r:
            while arr[r] >= p and l < r:
                r -= 1
            if l < r:
                arr[l] = arr[r]
                l += 1
            while arr[l] <= p and l < r:
                l += 1
            if l < r:
                arr[r] = arr[l]
                r -= 1
        arr[l] = p
        self.quickSort(arr,left,l-1)
        self.quickSort(arr,l+1,right)

    # 哈希地图法
    def majorityElementByHashMap(self, nums):
        if len(nums) == 0:
            return None
        if len(nums) == 1:
            return nums[0]
        hashMap = dict()
        for i in nums:
            if hashMap.get(i) is None:
                hashMap[i] = 1
            else:
                hashMap[i] += 1
                if hashMap[i] >= len(nums)/2:
                    return i

if __name__ == "__main__":
    s = Solution()
    print(s.majorityElementByMooreVote([1,2,3,2,2,2,5,4,2]))
```

# 37. 序列化二叉树

**描述:**
请实现两个函数，分别用来序列化和反序列化二叉树。

你需要设计一个算法来实现二叉树的序列化与反序列化。这里不限定你的序列 / 反序列化算法执行逻辑，你只需要保证一个二叉树可以被序列化为一个字符串并且将这个字符串反序列化为原始的树结构。

**提示：**
输入输出格式与 LeetCode 目前使用的方式一致，详情请参阅 [LeetCode 序列化二叉树的格式](https://support.leetcode-cn.com/hc/kb/article/1194353/)。
你并非必须采取这种方式，你也可以采用其他的方法解决这个问题。

**示例：**

![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102908846.jpg)

```
输入：root = [1,2,3,null,null,4,5]
输出：[1,2,3,null,null,4,5]
```

**链接:**
https://leetcode-cn.com/problems/xu-lie-hua-er-cha-shu-lcof/

**解:**

```python
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Codec:
    def serialize(self, root):
        if root is None:
            return '[]'
        queue = list()
        queue.append(root)
        strList = list()
        while len(queue) != 0:
            r = queue.pop(0)
            if r is None:
                strList.append("null")
            else:
                strList.append(str(r.val))
                queue.append(r.left)
                queue.append(r.right)
        return '[' + ','.join(strList) + ']'
        
    def deserialize(self, data):
        if data == '[]':
            return None
        strList = data[1:-1].split(',')
        root = TreeNode(int(strList[0]))
        queue = list()
        queue.append(root)
        p = 1
        while len(queue) != 0:
            r = queue.pop(0)
            if strList[p] != 'null':
                r.left = TreeNode(int(strList[p]))
                queue.append(r.left)
            if strList[p+1] != 'null':
                r.right = TreeNode(int(strList[p+1]))
                queue.append(r.right)
            p += 2
        return root

if __name__ == "__main__":
    s = Codec()
    head = TreeNode(1)
    head.left = TreeNode(2)
    head.right = TreeNode(3)
    head.right.left = TreeNode(4)
    head.right.right = TreeNode(5)
    data = s.serialize(head)
    root = s.deserialize(data)
    print(s.serialize(root))
```

# 38. 字符串的排列

**描述:**
输入一个字符串，打印出该字符串中字符的所有排列。

你可以以任意顺序返回这个字符串数组，但里面不能有重复元素。

 **链接:**
https://leetcode-cn.com/problems/zi-fu-chuan-de-pai-lie-lcof/

**示例:**

```
输入：s = "abc"
输出：["abc","acb","bac","bca","cab","cba"]
```

**限制：**

```
1 <= s 的长度 <= 8
```

**解:**

```python
class Solution:
    def permutation(self, s):
        if len(s) == 0:
            return []
        if len(s) < 1:
            return [s]
        self.lenth = len(s)
        self.resultSet = list()
        self.backtracking(list(),list(s))
        return list(self.resultSet)

    def backtracking(self,accStr,unaccStr):
        if len(accStr) == self.lenth:
            self.resultSet.append(''.join(accStr))
            return
        cutUnaccSet = set()
        for i in range(len(unaccStr)):
            if unaccStr[i] in cutUnaccSet:
                continue
            cutUnaccSet.add(unaccStr[i])
            newAccStr = list(accStr)
            newUnaccStr = list(unaccStr)
            newAccStr.append(unaccStr[i])
            newUnaccStr.pop(i)
            self.backtracking(newAccStr,newUnaccStr)


if __name__ == "__main__":
    s = Solution()
    print(s.permutation("abc"))
```



# 40. 最小的k个数

**描述：**
输入整数数组 arr ，找出其中最小的 k 个数。

例如：
输入4、5、1、6、2、7、3、8这8个数字，则最小的4个数字是1、2、3、4。

**示例 1：**
输入：arr = [3,2,1], k = 2
输出：[1,2] 或者 [2,1]

**示例 2：**
输入：arr = [0,1,2,1], k = 1
输出：[0]

**限制：**
0 <= k <= arr.length <= 10000
0 <= arr[i] <= 10000

[链接](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/)

**解：**

普通解法：
使用双数组，第二个新数组从大到小排列，将旧数组中的数遍历插入到新数组中

```python
class Solution:
    def getNumArr(self, input):
        inputNumStrList = str.split(input,',')
        numList = list()
        for i in range(len(inputNumStrList)):
            numList.append(int(inputNumStrList[i]))
        return numList

    def getLeastNumbers(self, arr, k):
        self.outputList = list()
        self.k = k

        if k == 0 or len(arr) == 0:
            return self.outputList
        
        for i in range(len(arr)):
            self.pushNum(arr[i])
        return self.outputList
    
    def pushNum(self, num):
        print("+++"+str(num))
        print(self.outputList)

        if len(self.outputList) == 0:
            self.outputList.append(num)
            return

        if(len(self.outputList) < self.k):
            for j in range(len(self.outputList)):
                if num > self.outputList[j]:
                    self.outputList.insert(j,num)
                    return
            self.outputList.append(num)
            return

        if num >= self.outputList[0]:
            return

        for j in range(1,len(self.outputList)):
            if num < self.outputList[j-1] and num >= self.outputList[j]:
                self.outputList.insert(j, num)
                self.outputList = self.outputList[1:]
                return
        self.outputList.append(num)
        self.outputList = self.outputList[1:]
            
if __name__ == "__main__":
    s = Solution()
    inputNumList = s.getNumArr("0,1,1,2,4,4,2,3,3,2")
    outputNumList = s.getLeastNumbers(inputNumList,6)
    print(outputNumList)
```

快速排序：

```python
class Solution:
    def getLeastNumbers(self, arr, k):
        if len(arr) < 2:
            return arr
        self.k = k
        self.halfQuickSort(arr,0,len(arr)-1)
        return arr[:k]

    def halfQuickSort(self,arr,left,right):
        if left >= right:
            return
        l = left
        r = right
        p = arr[l]
        while l < r:
            while l < r and arr[r] >= p:
                r -= 1
            if l < r:
                arr[l] = arr[r]
                l += 1
            while l < r and arr[l] <= p:
                l += 1
            if l < r:
                arr[r] = arr[l]
                r -= 1
        arr[l] = p
        if l == self.k:
            return
        if l < self.k:
            self.halfQuickSort(arr,l+1,right)
        else:
            self.halfQuickSort(arr,left,l-1)
            
if __name__ == "__main__":
    NumList = [0,0,1,2,4,2,2,3,1,4]
    s = Solution()
    outputNumList = s.getLeastNumbers(NumList,8)
    print(NumList)
    print(outputNumList)
```

# 41. 数据流中的中位数

**描述:**
如何得到一个数据流中的中位数？
如果从数据流中读出奇数个数值，那么中位数就是所有数值排序之后位于中间的数值。
如果从数据流中读出偶数个数值，那么中位数就是所有数值排序之后中间两个数的平均值。

**例如:**
[2,3,4] 的中位数是 3
[2,3] 的中位数是 (2 + 3) / 2 = 2.5
设计一个支持以下两种操作的数据结构：

- void addNum(int num) - 从数据流中添加一个整数到数据结构中。
- double findMedian() - 返回目前所有元素的中位数。

**示例 1：**

```
输入：
["MedianFinder","addNum","addNum","findMedian","addNum","findMedian"]
[[],[1],[2],[],[3],[]]
输出：[null,null,null,1.50000,null,2.00000]
```

**示例 2：**

```
输入：
["MedianFinder","addNum","findMedian","addNum","findMedian"]
[[],[2],[],[3],[]]
输出：[null,null,2.00000,null,2.50000]
```

 **链接:**
https://leetcode-cn.com/problems/shu-ju-liu-zhong-de-zhong-wei-shu-lcof/

**限制：**

- 最多会对 `addNum、findMedian` 进行 `50000` 次调用。

**解:**

```python
```



# 42连续子数组的最大和

输入一个整型数组，数组中的一个或连续多个整数组成一个子数组。
求所有子数组的和的最大值。

要求时间复杂度为O(n)。

**示例1:**

```
输入: nums = [-2,1,-3,4,-1,2,1,-5,4]
输出: 6
解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。
```

**提示：**

- `1 <= arr.length <= 10^5`
- `-100 <= arr[i] <= 100`

(https://leetcode-cn.com/problems/lian-xu-zi-shu-zu-de-zui-da-he-lcof/)

**解：**

简单的动态规划
**状态定义：** 
设动态规划列表 dp ，dp[i]代表以元素 nums[i]为结尾的连续子数组最大和。

**转移方程：**

- 若nums[i] > dp[i-1]+nums[i]
  则取nums[i]
- 若nums[i] < dp[i-1]+nums[i]
  则取dp[i-1]+nums[i]

**初始状态：** 
dp[0] = nums[0]，即以 nums[0]结尾的连续子数组最大和为nums[0] 。

**返回值：** 
返回 dp列表中的最大值，代表全局最大值。

```python
class Solution:
    def maxSubArray(self, nums):
        if nums is None:
            return 0
        if len(nums) == 1:
            return nums[0]

        output = nums[0]
        dp = [0]*len(nums)
        dp[0] = nums[0]
        for  i in range(1,len(nums)):
            dp[i] = max(nums[i],dp[i-1]+nums[i])
            if dp[i] > output:
                output = dp[i]
        return output
        
if __name__ == "__main__":
	c = Solution()
    print(str(c.maxSubArray([-2,1,-3,4,-1,2,1,-5,4])))
```

# 46.把数字翻译成字符串

https://leetcode-cn.com/problems/ba-shu-zi-fan-yi-cheng-zi-fu-chuan-lcof/

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。
一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

**示例 1:**

```
输入: 12258
输出: 5
解释: 12258有5种不同的翻译，分别是"bccfi", "bwfi", "bczi", "mcfi"和"mzi"
```

**提示：**

- `0 <= num < 231`

**解：**

一维动态规划稍稍变形题

动态规划解析：

**转移方程：**
![image-20210922201844462](attachments/notes/程序/算法/剑指offer/IMG-20250428102909182.png)

**初始状态：** 
dp[0] = 1
dp[1] 也需要求出来

**返回值：** 
dp[n]

```python
class Solution:
    def translateNum(self, num):
        if num < 10:
            return 1
        numList = self.numToNumList(num)
        return self.dpf(numList)
    
    def dpf(self, arr):
        dp = [0]*len(arr)
        dp[0] = 1
        if self.possibilityAnalysis(arr,1):
            dp[1] = 2
        else:
            dp[1] = 1
        for i in range(2,len(arr)):
            if self.possibilityAnalysis(arr,i):
                dp[i] = dp[i-1] + dp[i-2]
            else:
                dp[i] = dp[i-1]
        print(dp)
        return dp[-1]

    def possibilityAnalysis(self, arr, index):
        if arr[index-1] == 0:
            return False
        else:
            n = int(arr[index-1]) * 10 + int(arr[index])
            if n > 0 and n < 26:
                return True
            else: 
                return False  

    def numToNumList(self, num):
        numList = list()
        while num > 0:
            numList.insert(0,num%10)
            num = num // 10
        return numList
        
if __name__ == "__main__":
     s = Solution()
     print(s.translateNum(18822))
```

# 45. 把数组排成最小的数

**描述:**
输入一个非负整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。

**示例 1:**

```
输入: [10,2]
输出: "102"
```

**示例 2:**

```
输入: [3,30,34,5,9]
输出: "3033459"
```

 **链接:**
https://leetcode-cn.com/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof/

**提示:**

- `0 < nums.length <= 100`

**说明:**

- 输出结果可能非常大，所以你需要返回一个字符串而不是整数
- 拼接起来的数字可能会有前导 0，最后结果不需要去掉前导 0

**解:**
自定义排序类型的问题。该种类型解题模板：

1. 定义元素比较规则，确定比较函数
2. 将比较函数套入现有排序算法中(快速排序)
3. 将排序后的元素按要求整理后输出

```python
class Solution:
    def minNumber(self, nums):
        if len(nums) == 0:
            return ""
        if len(nums) == 1:
            return str(nums[0])
        self.quickSort(nums,0,len(nums)-1)
        output = ""
        for i in nums:
            output += str(i)
        return output
    
    def quickSort(self, arr, left, right):
        if left >= right:
            return
        l = left
        r = right
        t = arr[l]
        while l < r:
            while l < r and self.compare(arr[r], t) == 1:
                r -= 1
            if l < r:
                arr[l] = arr[r]
                l += 1
            while l < r and self.compare(arr[l], t) == -1:
                l += 1
            if l < r:
                arr[r] = arr[l]
                r -= 1
            arr[l] = t
        self.quickSort(arr,left,l-1)
        self.quickSort(arr,l+1,right)

    def compare(self, strA ,strB):
        a = int(str(strA)+str(strB))
        b = int(str(strB)+str(strA))
        if a == b:
            return 0
        elif a > b:
            return 1
        else:
            return -1

```

# 44. 数字序列中某一位的数字

**描述:**
数字以0123456789101112131415…的格式序列化到一个字符序列中。
在这个序列中，第5位（从下标0开始计数）是5，第13位是1，第19位是4，等等。

请写一个函数，求任意第n位对应的数字。

**示例 1：**

```
输入：n = 3
输出：3
```

**示例 2：**

```
输入：n = 11
输出：0
```

 **链接:**
https://leetcode-cn.com/problems/shu-zi-xu-lie-zhong-mou-yi-wei-de-shu-zi-lcof/

**限制：**

- `0 <= n < 2^31`

**解:**
这是个纯粹的找规律数学问题
![image-20210925212710412](attachments/notes/程序/算法/剑指offer/IMG-20250428102909486.png)

根据以上分析，可将求解分为三步：

1. 确定 n 所在 数字 的 位数 ，记为 digit ；
2. 确定 n 所在的 数字 ，记为 num ；
3. 确定 n 是num 中的哪一数位，并返回结果。

```python
class Solution:
    def findNthDigit(self, n):
        if n == 0:
            return 0
        digit = 1
        start = 1
        count = 9
        while n > count:
            n -= count
            digit += 1
            start *= 10
            count = digit * start * 9
        
        num = start + (n-1) // digit
        index = (n-1) % digit
        output = int(str(num)[index])
        return output
```



# 47. 礼物的最大价值

https://leetcode-cn.com/problems/li-wu-de-zui-da-jie-zhi-lcof/

在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。
你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。
给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

**示例 1:**

```
输入: 
[
  [1,3,1],
  [1,5,1],
  [4,2,1]
]
输出: 12
解释: 路径 1→3→5→2→1 可以拿到最多价值的礼物
```

**提示：**

- `0 < grid.length <= 200`
- `0 < grid[0].length <= 200`

**解：**

简单的二维动态规划，注意python中二维数组的初始化问题
https://blog.csdn.net/weixin_30023527/article/details/113507419

```python
class Solution:
    def maxValue(self, grid):
        xLen = len(grid[0])
        yLen = len(grid)
        if xLen == 1 and yLen == 1:
            return grid[0][0]
        dp = [[0]* xLen for i in range(yLen)]
        dp[0][0] = grid[0][0]
        for i in range(1,xLen):
            dp[0][i] = dp[0][i-1] + grid[0][i]
        for i in range(1,yLen):
            dp[i][0] = dp[i-1][0] + grid[i][0]
        for i in range(1,yLen):
            for j in range(1,xLen):
                dp[i][j] = max(dp[i-1][j],dp[i][j-1]) + grid[i][j]
        return dp[-1][-1]

if __name__ == "__main__":
    s = Solution()
    grid = [ [1,3,1], [1,5,1], [4,2,1]]
    print(s.maxValue(grid))
```

# 48. 最长不含重复字符的子字符串

请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。

**示例 1:**

```
输入: "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
```

**示例 2:**

```
输入: "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

**示例 3:**

```
输入: "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

**提示：**

- `s.length <= 40000`

**解：**

方法一：
使用双指针与字典(快些)或集合(慢些)：

```python
class Solution:
    def lengthOfLongestSubstring(self, s):
        if len(s) == 0:
            return 0
        if len(s) == 1:
            return 1
        longestLen = 1
        p = 0
        q = 0
        charDict = dict()
        long = 0
        while q < len(s):
            if s[q] in charDict:
                longestLen = max(q-p, longestLen) 
                p = charDict[s[q]] + 1
                charDict[s[q]] = q
                q += 1
                long = q - p
                for key,values in list(charDict.items()):
                    if values < p:
                        charDict.pop(key)   
            else:
                charDict[s[q]] = q
                q += 1
                long += 1
        longestLen = max(long, longestLen)
        return longestLen

if __name__ == "__main__":
    s = Solution()
    print(s.lengthOfLongestSubstring("aab"))
```

# 49. 丑数

**描述:**
我们把只包含质因子 2、3 和 5 的数称作丑数（Ugly Number）。
求按从小到大的顺序的第 n 个丑数。

 **链接:**
https://leetcode-cn.com/problems/chou-shu-lcof/

**示例:**

```
输入: n = 10
输出: 12
解释: 1, 2, 3, 4, 5, 6, 8, 9, 10, 12 是前 10 个丑数。
```

**说明:** 

1. `1` 是丑数。
2. `n` **不超过**1690。

**解:**

```python
class Solution:
    def nthUglyNumber(self, n):
        a=b=c=0
        dp = [0]*n
        dp[0] = 1
        for i in range(1,n):
            n2,n3,n5 = dp[a]*2,dp[b]*3,dp[c]*5
            dp[i] = min(n2,n3,n5)
            if dp[i] == n2:
                a += 1
            if dp[i] == n3:
                b += 1
            if dp[i] == n5:
                c += 1
        return dp[-1]
```



# 50.第一个只出现一次的字符

在字符串 s 中找出第一个只出现一次的字符。
如果没有，返回一个单空格。
 s 只包含小写字母。

**示例 1:**

```
输入：s = "abaccdeff"
输出：'b'
```

**示例 2:**

```
输入：s = "" 
输出：' '
```

**限制：**

```
0 <= s 的长度 <= 50000
```

https://leetcode-cn.com/problems/di-yi-ge-zhi-chu-xian-yi-ci-de-zi-fu-lcof/

**解：**

使用字典(HashMap)

```python
class Solution:
    def firstUniqChar(self, s):
        charDict = dict()
        for c in s:
            if c in charDict:
                charDict[c] = False
            else:
                charDict[c] = True
        for k, v in charDict.items():
            if v: return k
        return ' '
```

# 51. 数组中的逆序对

在数组中的两个数字，如果前面一个数字大于后面的数字，则这两个数字组成一个逆序对。输入一个数组，求出这个数组中的逆序对的总数。

**示例 1:**

```
输入: [7,5,6,4]
输出: 5
```

**限制：**

```
0 <= 数组长度 <= 50000
```

**链接:**
https://leetcode-cn.com/problems/shu-zu-zhong-de-ni-xu-dui-lcof/

**解:**
归并排序变形

```python
class Solution:
    def reversePairs(self, nums):
        if len(nums) < 2:
            return 0
        self.arr = nums
        self.output = 0
        print(self.mergeSort(0,len(nums)-1))
        return self.output

    def mergeSort(self,left,right):
        if left >= right:
            return [self.arr[left]]
        mid = (left+right) // 2
        leftArr = self.mergeSort(left,mid)
        rightArr = self.mergeSort(mid+1,right)
        mergeArr = list()
        p = 0
        q = 0
        while p < len(leftArr) and q < len(rightArr):
            if rightArr[q] < leftArr[p]:
                self.output += len(leftArr) - p
                mergeArr.append(rightArr[q])
                q += 1
            else:
                mergeArr.append(leftArr[p])
                p += 1
        if q < len(rightArr):
            for i in range(q,len(rightArr)):
                mergeArr.append(rightArr[i])
        if p < len(leftArr):
            for i in range(p,len(leftArr)):
                mergeArr.append(leftArr[i])
        return mergeArr
if __name__ == "__main__":
    s = Solution()
    print(s.reversePairs([7,5,6,4]))
```



# 52. 两个链表的第一个公共节点

输入两个链表，找出它们的第一个公共节点。

如下面的两个链表**：**

[![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102909796.png)](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/14/160_statement.png)

在节点 c1 开始相交。

 

**示例 1：**

[![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102910178.png)](https://assets.leetcode.com/uploads/2018/12/13/160_example_1.png)

```
输入：
intersectVal = 8, listA = [4,1,8,4,5], listB = [5,0,1,8,4,5], skipA = 2, skipB = 3
输出：
Reference of the node with value = 8
输入解释：
相交节点的值为 8 （注意，如果两个列表相交则不能为 0）。
从各自的表头开始算起，链表 A 为 [4,1,8,4,5]，链表 B 为 [5,0,1,8,4,5]。在 A 中，相交节点前有 2 个节点；在 B 中，相交节点前有 3 个节点。
```

**示例 2：**

[![img](attachments/notes/程序/算法/剑指offer/IMG-20250428102910492.png)](https://assets.leetcode.com/uploads/2018/12/13/160_example_3.png)

```
输入：
intersectVal = 0, listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
输出：
null
输入解释：
从各自的表头开始算起，链表 A 为 [2,6,4]，链表 B 为 [1,5]。
由于这两个链表不相交，所以 intersectVal 必须为 0，而 skipA 和 skipB 可以是任意值。
解释：
这两个链表不相交，因此返回 null。
```

**注意：**

- 如果两个链表没有交点，返回 `null`.
- 在返回结果后，两个链表仍须保持原有的结构。
- 可假定整个链表结构中没有循环。
- 程序尽量满足 O(*n*) 时间复杂度，且仅用 O(*1*) 内存。

https://leetcode-cn.com/problems/liang-ge-lian-biao-de-di-yi-ge-gong-gong-jie-dian-lcof/

**解：**

双指针交叉

```python
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    def getIntersectionNode(self, headA, headB):
        if headA == None or headB == None:
            return None
        p = headA
        q = headB
        while p != q:
            p = p.next
            q = q.next
            if p == None and q == None:
                return None
            if p == None:
                p = headB
            
            if q == None:
                q = headA
        return p
```

# 53. 在排序数组中查找数字 I

https://leetcode-cn.com/problems/zai-pai-xu-shu-zu-zhong-cha-zhao-shu-zi-lcof/

统计一个数字在排序数组中出现的次数。

**示例 1:**

```
输入: nums = [5,7,7,8,8,10], target = 8
输出: 2
```

**示例 2:**

```
输入: nums = [5,7,7,8,8,10], target = 6
输出: 0
```

**提示：**

- `0 <= nums.length <= 105`
- `-109 <= nums[i] <= 109`
- `nums` 是一个非递减数组
- `-109 <= target <= 109`

**解：**

二分法

```python
class Solution:
    def search(self, nums, target):
        if nums == None or len(nums) == 0:
            return 0
        return self.dichotomous(nums,0,len(nums)-1,target)

    def dichotomous(self, arr, left, right, target):
        if left >= right:
            if arr[left] == target:
                return 1
            else:
                return 0
        mid = left + (right - left) // 2
        return self.dichotomous(arr,left,mid,target) + self.dichotomous(arr,mid+1,right,target)

if __name__ == "__main__":
    s = Solution()
    print(s.search([1,1,2,1],2))
```

# 53. 在排序数组中查找数字 II

一个长度为n-1的递增排序数组中的所有数字都是唯一的，并且每个数字都在范围0～n-1之内。
在范围0～n-1内的n个数字中有且只有一个数字不在该数组中，请找出这个数字。

**示例 1:**
输入: [0,1,3]
输出: 2

**示例 2:**
输入: [0,1,2,3,4,5,6,7,9]
输出: 8

**限制：**
1 <= 数组长度 <= 10000

链接：
https://leetcode-cn.com/problems/que-shi-de-shu-zi-lcof

**解：**

二分法

```python
class Solution:
    def missingNumber(self, nums):
        if len(nums) == 0:
            return 0
        if nums[0] == 1:
            return 0
        l = len(nums)
        if nums[l - 1] == l-1:
            return l

        left = 0
        right = l-1
        while left <= right:
            mid = (left + right) // 2
            if mid == nums[mid]:
                left = mid + 1
                continue
            else:
                right = mid - 1
                continue
        return left


if __name__ == "__main__":
    s = Solution()
    print(s.missingNumber([0,1,2,4]))
```

# 54. 二叉搜索树的第k大节点

给定一棵二叉搜索树，请找出其中第k大的节点。

**示例 1:**

```
输入: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
输出: 4
```

**示例 2:**

```
输入: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
输出: 4
```

**限制：**

1 ≤ k ≤ 二叉搜索树元素个数

**链接：**
https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-di-kda-jie-dian-lcof/

**解：**
二叉树反向的中序遍历

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def kthLargest(self, root, k):
        if root is None:
            return None
        self.rMidOrderList = list()
        self.k = k
        self.reverseMidTraversal(root)
        return self.rMidOrderList[k-1]
    
    def reverseMidTraversal(self, root):
        if root is None or len(self.rMidOrderList) == self.k:
            return
        self.reverseMidTraversal(root.right)
        self.rMidOrderList.append(root.val)
        self.reverseMidTraversal(root.left)

if __name__ == "__main__":
    s = Solution()
    head = TreeNode(3)
    head.left = TreeNode(1)
    head.right = TreeNode(4)
    head.left.right = TreeNode(2)
    s.kthLargest(head,2)
```



# 55. 二叉树的深度

输入一棵二叉树的根节点，求该树的深度。
从根节点到叶节点依次经过的节点（含根、叶节点）形成树的一条路径，最长路径的长度为树的深度。

**例如：**
给定二叉树 [3,9,20,null,null,15,7]，

        3
       / \
      9  20
        /  \
       15   7

返回它的最大深度 3 。

**提示：**
节点总数 <= 10000

**链接：**
https://leetcode-cn.com/problems/er-cha-shu-de-shen-du-lcof

**解：**

二叉树的深度优先搜索或广度优先搜索：

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def maxDepth(self, root):
        if root is None:
            return 0
        self.deep = 0
        self.dfs(root,0)
        return self.deep
        
    def dfs(self, root, d):
        if root is None:
            return
        d += 1
        if d > self.deep:
            self.deep = d
        self.dfs(root.left, d)
        self.dfs(root.right, d)

    def bfs(self, root):
        queue = list()
        queue.append(root)
        deep = 0
        while len(queue) != 0:
            tq = list()
            for node in queue:
                if node.left is not None:
                    tq.append(node.left)
                if node.right is not None:
                    tq.append(node.right)
            queue = tq
            deep += 1
        return deep

if __name__ == "__main__":
    s = Solution()
    head = TreeNode(3)
    head.left = TreeNode(1)
    head.right = TreeNode(4)
    head.left.right = TreeNode(2)
    print(s.maxDepth(head))
```



# 55. II 平衡二叉树

输入一棵二叉树的根节点，判断该树是不是平衡二叉树。
如果某二叉树中任意节点的左右子树的深度相差不超过1，那么它就是一棵平衡二叉树。

**示例 1:**
给定二叉树 `[3,9,20,null,null,15,7]`

```
    3
   / \
  9  20
    /  \
   15   7
```

返回 `true` 。

**示例 2:**
给定二叉树 `[1,2,2,3,3,null,null,4,4]`

```
       1
      / \
     2   2
    / \
   3   3
  / \
 4   4
```

返回 `false` 。

**限制：**

- `0 <= 树的结点个数 <= 10000`

**解：**
先后序遍历再嵌套第55题

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def isBalanced(self, root):
        return self.postOrderTraversal(root)
    def postOrderTraversal(self, root):
        if root is None:
            return True
        ld = self.getDeepByBFS(root.left)
        rd = self.getDeepByBFS(root.right)
        if abs(ld - rd) > 1:
            return False
        return self.postOrderTraversal(root.left) and self.postOrderTraversal(root.right)
        
    def getDeepByBFS(self, root):
        if root is None:
            return 0
        queue = list()
        queue.append(root)
        deep = 0
        while len(queue) != 0:
            t = list()
            for p in queue:
                if p.left is not None:
                    t.append(p.left)
                if p.right is not None:
                    t.append(p.right)
            deep += 1
            queue = t
        return deep

if __name__ == "__main__":
    s = Solution()
    head = TreeNode(3)
    head.left = TreeNode(1)
    head.right = TreeNode(4)
    head.left.right = TreeNode(2)
    print(s.isBalanced(head))
```

# 56. I 数组中数字出现的次数

一个整型数组 `nums` 里除两个数字之外，其他数字都出现了两次。请写程序找出这两个只出现一次的数字。
要求时间复杂度是O(n)，空间复杂度是O(1)。

**示例 1：**

```
输入：nums = [4,1,4,6]
输出：[1,6] 或 [6,1]
```

**示例 2：**

```
输入：nums = [1,2,10,4,1,4,3,3]
输出：[2,10] 或 [10,2]
```

**限制：**

- `2 <= nums.length <= 10000`

**解：**

异或的骚操作，不看题解真想不到

```python
class Solution:
    def singleNumbers(self, nums):
        ox = 0
        for i in nums:
            ox ^= i
        m = 1
        while ox & m == 0:
            ox <<= 1
        x, y = 0, 0
        for i in nums:
            if i & m == 0:
                x ^= i
            else:
                y ^= i
        return x,y

if __name__ == "__main__":
    s = Solution()
    print(s.singleNumbers([4,1,4,6]))
```



# 56.  II 数组中数字出现的次数 

https://leetcode-cn.com/problems/shu-zu-zhong-shu-zi-chu-xian-de-ci-shu-ii-lcof/

在一个数组 `nums` 中除一个数字只出现一次之外，其他数字都出现了三次。
请找出那个只出现一次的数字。

**示例 1：**

```
输入：nums = [3,4,3,3]
输出：4
```

**示例 2：**

```
输入：nums = [9,1,7,9,7,9,7]
输出：1
```

**限制：**

- `1 <= nums.length <= 10000`
- `1 <= nums[i] < 2^31`

**解：**
用集合

```python
class Solution:
    def singleNumber(self, nums):
        if len(nums) == 0:
            return None
        if len(nums) == 1:
            return nums[0]
        oneTimeNumList = list()
        numSet = set()
        for i in nums:
            if i not in numSet:
                numSet.add(i)
                oneTimeNumList.append(i)
            else:
                if i in oneTimeNumList:
                    oneTimeNumList.remove(i)
        return oneTimeNumList.pop()
```



# 57. 和为s的两个数字

输入一个递增排序的数组和一个数字s，在数组中查找两个数，使得它们的和正好是s。
如果有多对数字的和等于s，则输出任意一对即可。

**示例 1：**

```
输入：nums = [2,7,11,15], target = 9
输出：[2,7] 或者 [7,2]
```

**示例 2：**

```
输入：nums = [10,26,30,31,47,60], target = 40
输出：[10,30] 或者 [30,10]
```

**限制：**

- `1 <= nums.length <= 10^5`
- `1 <= nums[i] <= 10^6`

**解：**
先折半查找确定位置，后双指针对撞

```python
class Solution:
    def twoSum(self, nums, target):
        if nums is None or len(nums) == 1 or nums[0] > target:
            return None
        left = 0
        right = self.dichotomous(nums,target)
        while left < right:
            t = nums[left] + nums[right]
            if t == target:
                return [nums[left], nums[right]]
            elif t < target:
                left += 1
            else:
                right -= 1
        return None

    def dichotomous(self, arr, target):
        if arr[len(arr)-1] < target:
            return len(arr)-1
        left = 0
        right = len(arr) - 1
        while(left < right):
            mid = (left + right)//2
            if arr[mid] > target:
                right = mid - 1
            if arr[mid] < target:
                left = mid + 1
            if arr[mid] == target:
                return mid -1
        return left


if __name__ == "__main__":
    s = Solution()
    nums = [2,7,11,15,20]
    print(s.twoSum(nums,12))
```

# 57 . II和为s的连续正数序列

输入一个正整数 `target` ，输出所有和为 `target` 的连续正整数序列（至少含有两个数）。

序列内的数字由小到大排列，不同序列按照首个数字从小到大排列。

**示例 1：**

```
输入：target = 9
输出：[[2,3,4],[4,5]]
```

**示例 2：**

```
输入：target = 15
输出：[[1,2,3,4,5],[4,5,6],[7,8]]
```

**限制：**

- `1 <= target <= 10^5`

**解:**

滑动窗口双指针，用求和公式降低时间复杂度

```python
class Solution:
    def findContinuousSequence(self, target):
        left = 1
        right = int((pow((0.25 + 2*target),0.5) - 0.5))
        output = list()
        while left != right:
            sum = 0
            for i in range(left,right+1):
                sum += i
            if sum > target:
                right -= 1
            elif sum < target:
                left += 1
                right += 1
            else:
                output.append(list(range(left,right+1)))
                left += 1
        return output

if __name__ == "__main__":
    s = Solution()
    output = s.findContinuousSequence(9)
    for i in output:
        print(i)
```

# 58. I 翻转单词顺序

输入一个英文句子，翻转句子中单词的顺序，但单词内字符的顺序不变。
为简单起见，标点符号和普通字母一样处理。
例如输入字符串"I am a student. "，则输出"student. a am I"。

**示例 1：**

```
输入: "the sky is blue"
输出: "blue is sky the"
```

**示例 2：**

```
输入: "  hello world!  "
输出: "world! hello"
解释: 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
```

**示例 3：**

```
输入: "a good   example"
输出: "example good a"
解释: 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。
```

**说明：**

- 无空格字符构成一个单词。
- 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
- 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。

**解：**

用栈，python3特性，双指针都可以解决

```python
class Solution:
    def reverseWordsByStack(self, s):
        stack = list()
        for c in s.split():
            stack.insert(0,c)
        s = ""
        for i in range(len(stack)):
            s += " " + stack.pop(0)
        return s[1:]

    def reverseWordsByPy3(self, s):
        strList = s.split()[::-1]
        s = ""
        for i in strList:
            s += " " + i
        return s[1:]
```

# 59. I 滑动窗口的最大值

给定一个数组 `nums` 和滑动窗口的大小 `k`，请找出所有滑动窗口里的最大值。

**示例:**

```
输入: nums = [1,3,-1,-3,5,3,6,7], 和 k = 3
输出: [3,3,5,5,6,7] 
解释: 

  滑动窗口的位置                最大值
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

 **链接:**
https://leetcode-cn.com/problems/hua-dong-chuang-kou-de-zui-da-zhi-lcof/

**提示：**

你可以假设 *k* 总是有效的，在输入数组不为空的情况下，1 ≤ k ≤ 输入数组的大小。

**解:**

```python
class Solution:
    # 滑动窗口暴力破解
    def maxSlidingWindowByBP(self, nums, k):
        if len(nums) == 0 or k == 0:
            return []
        q = k - 1
        maxList = list()
        maxNum = 0
        for i in range(k):
            if nums[i] > maxNum:
                maxNum = nums[i]
        maxList.append(maxNum)
        for i in range(1,len(nums)):
            q += 1
            if q >= len(nums):
                break
            maxNum = nums[i]
            for j in range(i+1,q+1):
                if nums[j] >  maxNum:
                    maxNum = nums[j]
            maxList.append(maxNum)
        return maxList
    # 单调队列优化解法
    def monoQueuePush(self, monoQueue, element):
        if len(monoQueue) == 0:
            monoQueue.append(element)
            return
        if element <= monoQueue[-1]:
            monoQueue.append(element)
        else:
            while len(monoQueue) != 0 and element > monoQueue[-1]:
                monoQueue.pop()
            monoQueue.append(element)

    def maxSlidingWindowByMonoQueues(self, nums, k):
        if len(nums) == 0 or k == 0:
            return []
        if len(nums) == 1:
            return nums
        maxList = list()
        monoQueue = list()

        monoQueue.append(nums[0])
        for i in range(1,k):
            self.monoQueuePush(monoQueue, nums[i])
        maxList.append(monoQueue[0])

        p = 0
        for i in range(k,len(nums)):
            if monoQueue[0] == nums[p]:
                monoQueue.pop(0)
            p += 1
            self.monoQueuePush(monoQueue, nums[i])
            maxList.append(monoQueue[0])
        return maxList
```



# 59. II 队列的最大值

请定义一个队列并实现函数 max_value 得到队列里的最大值，要求函数max_value、push_back 和 pop_front 的均摊时间复杂度都是O(1)。

若队列为空，pop_front 和 max_value 需要返回 -1

**示例 1：**
输入: 
["MaxQueue","push_back","push_back","max_value","pop_front","max_value"]
[[],[1],[2],[],[],[]]
输出: 
[null,null,null,2,1,2]

**示例 2：**
输入: 
["MaxQueue","pop_front","max_value"]
[[],[],[]]
输出: 
[null,-1,-1]

**限制：**
1 <= push_back,pop_front,max_value的总操作数 <= 10000
1 <= value <= 10^5

**链接：**
https://leetcode-cn.com/problems/dui-lie-de-zui-da-zhi-lcof

**解：**

```python
class MaxQueue:
    def __init__(self):
        self.queue = list()
        self.maxQueue = list()

    def max_value(self):
        if len(self.maxQueue) == 0:
            return -1
        return self.maxQueue[0]

    def push_back(self, value: int):
        self.queue.append(value)
        while len(self.maxQueue) !=0 and self.maxQueue[-1] < value:
            self.maxQueue.pop()
        self.maxQueue.append(value)

    def pop_front(self):
        if len(self.queue) == 0:
            return -1
        x = self.queue.pop(0)
        if x == self.maxQueue[0]:
            self.maxQueue.pop(0)
        return x
```

# 60. n个骰子的点数

**描述:**
把n个骰子扔在地上，所有骰子朝上一面的点数之和为s。
输入n，打印出s的所有可能的值出现的概率。

你需要用一个浮点数数组返回答案，其中第 i 个元素代表这 n 个骰子所能掷出的点数集合中第 i 小的那个的概率。

 **链接:**
https://leetcode-cn.com/problems/nge-tou-zi-de-dian-shu-lcof/

**示例 1:**

```
输入: 1
输出: [0.16667,0.16667,0.16667,0.16667,0.16667,0.16667]
```

**示例 2:**

```
输入: 2
输出: [0.02778,0.05556,0.08333,0.11111,0.13889,0.16667,0.13889,0.11111,0.08333,0.05556,0.02778]
```

**限制：**

```
1 <= n <= 11
```

**解:**

```python
class Solution:
    def dicesProbability(self, n):
        dp = [0]*n
        dp[0] = [1]*6
        for i in range(1,n):
            dp[i] = [0]*((i+1)*6-i)
            p = 0
            q = -1
            for j in range(len(dp[i])):
                if j == 6:
                    print("good6")
                if q == len(dp[i-1])-1:
                    p += 1                  
                else:
                    if q - p == 5:
                        p += 1
                        q += 1
                    else:
                        q += 1
                for k in range(p,q+1):
                    dp[i][j] += dp[i-1][k]
        total = pow(6,n)
        output = dp[-1]
        for i in range(len(output)):
            output[i] = float(output[i] / total)
        return output

if __name__ == "__main__":
    s = Solution()
    print(s.dicesProbability(3))
```



# 63. 股票的最大利润

https://leetcode-cn.com/problems/gu-piao-de-zui-da-li-run-lcof/

假设把某股票的价格按照时间先后顺序存储在数组中，请问买卖该股票一次可能获得的最大利润是多少？

**示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
```

**示例 2:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

**限制：**

```
0 <= 数组长度 <= 10^5
```

**解：**

```python
class Solution:
    def maxProfit(self, prices):
        if len(prices) < 2:
            return 0
        dp = [0]*len(prices)
        dp[0] = 0
        minPrice = prices[0]
        for i in range(1,len(prices)):
            dp[i] = max(dp[i-1],prices[i]-minPrice)
            if prices[i] < minPrice:
                minPrice = prices[i]
        return dp[-1]
```



# 66. 构建乘积数组

**描述:**
给定一个数组 `A[0,1,…,n-1]`，请构建一个数组 `B[0,1,…,n-1]`，其中 `B[i]` 的值是数组 `A` 中除了下标 `i` 以外的元素的积, 即 `B[i]=A[0]×A[1]×…×A[i-1]×A[i+1]×…×A[n-1]`。不能使用除法。

 **链接:**
https://leetcode-cn.com/problems/gou-jian-cheng-ji-shu-zu-lcof/

**示例:**

```
输入: [1,2,3,4,5]
输出: [120,60,40,30,24]
```

**提示：**

- 所有元素乘积之和不会溢出 32 位整数
- `a.length <= 100000`

**解:**

![image-20210925225643388](attachments/notes/程序/算法/剑指offer/IMG-20250428102910844.png)

```python
class Solution:
    def constructArr(self, a):
        if len(a) == 0:
            return []
        if len(a) == 1:
            return a
        b = [1]*len(a)
        t = 1
        for i in range(1,len(a)):
            b[i] = b[i-1] * a[i-1]
        for j in range(len(a)-2, -1, -1):
            t *= a[j+1]
            b[j] *= t
        return b
```



# 67. 把字符串转换成整数

https://leetcode-cn.com/problems/ba-zi-fu-chuan-zhuan-huan-cheng-zheng-shu-lcof/

写一个函数 StrToInt，实现把字符串转换成整数这个功能。不能使用 atoi 或者其他类似的库函数。

首先，该函数会根据需要丢弃无用的开头空格字符，直到寻找到第一个非空格的字符为止。

当我们寻找到的第一个非空字符为正或者负号时，则将该符号与之后面尽可能多的连续数字组合起来，作为该整数的正负号；假如第一个非空字符是数字，则直接将其与之后连续的数字字符组合起来，形成整数。

该字符串除了有效的整数部分之后也可能会存在多余的字符，这些字符可以被忽略，它们对于函数不应该造成影响。

> 注意：
> 假如该字符串中的第一个非空格字符不是一个有效整数字符、字符串为空或字符串仅包含空白字符时，则你的函数不需要进行转换。

在任何情况下，若函数不能进行有效的转换时，请返回 0。

**说明：**

假设我们的环境只能存储 32 位大小的有符号整数，那么其数值范围为 [−231, 231 − 1]。如果数值超过这个范围，请返回  INT_MAX (231 − 1) 或 INT_MIN (−231) 。

**示例 1:**

```
输入: "42"
输出: 42
```

**示例 2:**

```
输入: "   -42"
输出: -42
解释: 第一个非空白字符为 '-', 它是一个负号。
     我们尽可能将负号与后面所有连续出现的数字组合起来，最后得到 -42 。
```

**示例 3:**

```
输入: "4193 with words"
输出: 4193
解释: 转换截止于数字 '3' ，因为它的下一个字符不为数字。
```

**示例 4:**

```
输入: "words and 987"
输出: 0
解释: 第一个非空字符是 'w', 但它不是数字或正、负号。
     因此无法执行有效的转换。
```

**示例 5:**

```
输入: "-91283472332"
输出: -2147483648
解释: 数字 "-91283472332" 超过 32 位有符号整数范围。 
     因此返回 INT_MIN (−231) 。
```

解：

愣做，多考虑特殊情况

```python
class Solution:
    def strToInt(self, str):
        str = str.strip()                      # 删除首尾空格
        if not str: return 0                   # 字符串为空则直接返回
        res, i, sign = 0, 1, 1
        int_max, int_min, bndry = 2 ** 31 - 1, -2 ** 31, 2 ** 31 // 10
        if str[0] == '-': sign = -1            # 保存负号
        elif str[0] != '+': i = 0              # 若无符号位，则需从 i = 0 开始数字拼接
        for c in str[i:]:
            if not '0' <= c <= '9' : break     # 遇到非数字的字符则跳出
            if res > bndry or res == bndry and c > '7': return int_max if sign == 1 else int_min # 数字越界处理
            res = 10 * res + ord(c) - ord('0') # 数字拼接
        return sign * res
```
