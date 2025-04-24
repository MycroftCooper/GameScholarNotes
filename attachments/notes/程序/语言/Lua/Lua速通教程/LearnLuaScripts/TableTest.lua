--[[
    1: 表的合并
    编写一个Lua函数，接受两个表作为参数，返回一个新表，该表是将这两个表的元素合并在一起。
]]
function MergeTables(t1, t2)
    -- 在这里编写代码
    local output = {}
    for _, value in ipairs(t1) do
        table.insert(output, value)
    end
    for _, value in ipairs(t2) do
        table.insert(output, value)
    end
    return output
end

local result = MergeTables({1, 2, 3}, {4, 5, 6})
for _, v in ipairs(result) do print(v) end  -- 预期输出 1, 2, 3, 4, 5, 6

--[[
    2: 键值反转
    编写一个Lua函数，接受一个表作为参数，返回一个新表，该表的键和值是原表的值和键。
]]
function ReverseKeyValue(t)
    -- 在这里编写代码
    local output = {}
    for key, value in pairs(t) do
        output[value] = key
    end
    return output
end

local result = ReverseKeyValue({a = 1, b = 2, c = 3})
for k, v in pairs(result) do print(k, v) end  -- 预期输出 1 a, 2 b, 3 c

--[[
    3: 表的深度拷贝
    编写一个Lua函数，实现对表的深度拷贝，确保原表和新表完全独立，修改一个不会影响另一个。
]]
function DeepCopy(t)
    -- 在这里编写代码
    local output = {}
    for key, value in pairs(t) do
        if type(value) == "table" then
            output[key] = DeepCopy(value)
        else
            output[key] = value
        end
    end
    return output
end

local original = {a = {1, 2, 3}, b = {4, 5, 6}}
local copy = DeepCopy(original)
copy.a[1] = 10
print(original.a[1])  -- 预期输出 1

--[[
    4: 表中最大值的键
]]
function MaxKey(t)
    -- 在这里编写代码
    local maxValue = math.mininteger
    local output = 0
    for key, value in pairs(t) do
        if value >= maxValue then
            maxValue = value
            output = key
        end
    end
    return output
end

local result = MaxKey({a = 10, b = 20, c = 15})
print(result)  -- 预期输出 'b'

--[[
    5: 表元素的计数
    编写一个Lua函数，接受一个表作为参数，返回一个新表，该表记录了原表中每个元素出现的次数。
]]
function CountElements(t)
    -- 在这里编写代码
    local output = {}
    for _, value in ipairs(t) do
        if output[value] == nil then
            output[value] = 1
        else
            output[value] = output[value] + 1
        end
    end
    return output
end

local result = CountElements({"apple", "banana", "apple", "orange", "banana", "banana"})
for fruit, count in pairs(result) do print(fruit, count) end