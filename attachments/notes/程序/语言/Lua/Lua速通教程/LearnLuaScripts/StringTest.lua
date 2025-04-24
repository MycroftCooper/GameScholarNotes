--[[
    1 字符串反转
    编写一个Lua函数，接受一个字符串作为参数，并返回这个字符串的反转。
]]
function ReverseString(str)
    -- 在这里编写代码
    local result = ""
    for i = string.len(str), 0, -1 do
        result = result..string.sub(str,i,i)
    end
    return result
end

print(ReverseString("Hello Lua"))  -- 预期输出 "auL olleH"

--[[
    2 单词计数
    编写一个Lua函数，统计并返回给定字符串中单词的数量。这里，你可以假设单词之间由空格分隔。
]]
function CountWords(str)
    -- 在这里编写代码
    local result = 0
    for _ in string.gmatch(str, "%a+") do
        result = result + 1
    end
    return result
end

print(CountWords("Hello Lua world"))  -- 预期输出 3

--[[
    3 字符串中的大写字母
    编写一个Lua函数，接受一个字符串并返回该字符串中大写字母的数量。
]]
function CountUpperCase(str)
    -- 在这里编写代码
    local count = 0
    for _ in string.gmatch(str, "%u") do
        count = count + 1
    end
    return count
end

print(CountUpperCase("Hello Lua"))  -- 预期输出 2

--[[
    4 判断字符串是否是回文
    编写一个Lua函数，检查一个字符串是否是回文（即正着读和反着读都相同）。
]]
function IsPalindrome(str)
    -- 在这里编写代码
    local p = 1
    local q = string.len(str)
    while p ~= q do
        local pCahr = string.sub(str, p, p)
        local qChar = string.sub(str, q, q)
        if pCahr ~= qChar then
           return false 
        end
        p = p + 1
        q = q - 1
    end
    return true
end

print(IsPalindrome("racecar"))  -- 预期输出 true
print(IsPalindrome("hello"))    -- 预期输出 false

--[[
    5 字符串替换
    编写一个Lua函数，替换字符串中的所有指定子串为另一个子串。
]]
function ReplaceString(str, original, replacement)
    -- 在这里编写代码
    local newStr, num = string.gsub(str, original, replacement)
    return newStr
end

print(ReplaceString("cats and dogs", "cats", "birds"))  -- 预期输出 "birds and dogs"