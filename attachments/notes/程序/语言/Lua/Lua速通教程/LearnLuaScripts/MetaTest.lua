--[[
    1：创建一个只读表
    编写一个Lua函数，该函数接收一个表，并返回一个新的表，新表是只读的，任何试图修改它的操作都会抛出错误。
]]
print("1：创建一个只读表")
function CreateReadOnlyTable(t)
    -- 在这里编写代码
    local mt = {
        __index = t,
        __newindex = function (k)
            print("该表只读，无法更改!")
        end
    }
    local readOnlyT = {}
    setmetatable(readOnlyT, mt)
    return readOnlyT
end

local readOnlyT = CreateReadOnlyTable({a = 1, b = 2})
readOnlyT.a = 3  -- 应该抛出错误

--[[
    2：实现一个简单的向量类
    使用表和元表来模拟一个简单的二维向量类，支持向量的加法和字符串表示。
]]
-- 在这里编写代码
print("2：实现一个简单的向量类")
local Vector = {}
Vector.__index = Vector
function Vector:new(x, y)
    local v = { x = x, y = y}
    setmetatable(v, Vector)
    return v
end
-- 加法元方法
function Vector:__add(other)
    return Vector:new(self.x + other.x, self.y + other.y)
end
--减法元方法
function Vector:__sub(other)
    return Vector:new(self.x - other.x, self.y - other.y)
end
-- 字符串表示元方法
function Vector:__tostring()
    return "Vector(" .. self.x .. ", " .. self.y .. ")"
end

local v1 = Vector:new(1, 2)
local v2 = Vector:new(3, 4)
print(v1 + v2)  -- 应该输出 "Vector(4, 6)"
print(v1 - v2)  -- 应该输出 "Vector(-2, -2)"

--[[
    3：自定义迭代器
    创建一个表和相应的元表，使得该表能通过自定义的迭代器进行迭代。
]]
print("3：自定义迭代器")
function CreateIterableTable(t)
    -- 在这里编写代码
    local i = 0
    local mt = {
        __call = function ()
            i = i + 1
            if i <= #t then
                return t[i]
            end
        end
    }
    setmetatable(t, mt)
    return t
end

local itTable = CreateIterableTable({1, 2, 3, 4, 5})
for element in itTable do
    print(element)  -- 应该依次输出 1, 2, 3, 4, 5
end

--[[
    4：表的算术操作
    编写元方法来使得两个表可以进行算术运算，如两个表的元素相加。
]]
print("4：表的算术操作")
function AddTables(t1, t2)
    -- 在这里编写代码
    local result = {}
    local mt = {
        __add = function(a, b)
            for i = 1, math.max(#a, #b) do
                result[i] = (a[i] or 0) + (b[i] or 0)
            end
            return result
        end
    }
    setmetatable(t1, mt)
    return t1 + t2
end

local t1 = {1, 2, 3}
local t2 = {4, 5, 6}
local result = AddTables(t1, t2)
for _, v in ipairs(result) do
    print(v)  -- 应该依次输出 5, 7, 9
end