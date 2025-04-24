--[[
   1.阶乘函数
   编写一个Lua函数，计算并返回一个给定整数的阶乘。
]] 
function Factorial(n)
    -- 在这里编写代码
    if n == 1 then
        return 1
    end
    return n * Factorial(n-1)
end

print(Factorial(5))  -- 预期输出 120

--[[
    2.高阶函数映射
    编写一个Lua函数，接受一个函数和一个数组，返回一个新数组，该数组是将原始数组中的每个元素通过给定函数转换后的结果。
]]
function Map(func, array)
    -- 在这里编写代码
    local result = {}
    for index, value in ipairs(array) do
        result[index] = func(value)
    end
    return result
end

local result = Map(function(x) return x * 2 end, {1, 2, 3})
for _, v in ipairs(result) do print(v) end  -- 预期输出 2, 4, 6

--[[
    3.闭包计数器
    编写一个Lua函数，返回一个闭包，该闭包每次被调用时返回一个递增的整数。
]]
function CreateCounter()
    -- 在这里编写代码
    local count = 0
    return function() 
        count = count + 1 
        return count 
    end
end

local counter = CreateCounter()
print(counter())  -- 预期输出 1
print(counter())  -- 预期输出 2

--[[
    4.组合函数
    编写一个Lua函数，它接受两个函数f和g作为参数，并返回一个新的函数。这个新函数在被调用时，应先将其参数传递给g，然后将g的结果传递给f，最后返回f的结果。    
]]
function Compose(f, g)
    -- 在这里编写代码
    return function(...)
        return f(g(...))
    end
end

local function Square(x)
    return x * x
end

local function Increment(x)
    return x + 1
end

local squareAfterIncrementing = Compose(Square, Increment)
print(squareAfterIncrementing(4))  -- 预期输出 25 (即 (4 + 1) ^ 2)

--[[
    5. 可变参数 - 求和
    编写一个Lua函数，接受任意数量的参数，并返回它们的总和。
]]
function Sum(...)
    -- 在这里编写代码
    local result = 0
    for _, value in ipairs({...}) do
        result = result + value
    end
    return result
end

print(Sum(1, 2, 3, 4, 5))  -- 预期输出 15