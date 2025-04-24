--[[
    1 最大值函数
    编写一个Lua函数，接收一系列数字作为参数，并返回这些数字中的最大值。
]]
function Max(...)
    -- 在这里编写代码
    local result = math.max(...)
    return result
end

print(Max(3, 7, 2, 15, 6))  -- 预期输出 15

--[[
    2 计算圆的面积
    编写一个函数，接受一个圆的半径作为参数，并返回该圆的面积（使用公式：面积 = π * 半径^2）。
]]
function CircleArea(radius)
    -- 在这里编写代码
    local s = math.pi * radius^2
    return s
end

print(CircleArea(5))  -- 预期输出78.539816339745

--[[
    3 斐波那契数列
    编写一个函数，接受一个整数`n`，并返回斐波那契数列的第`n`个数。斐波那契数列的定义为：F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)。
]]
function Fibonacci(n)
    -- 在这里编写代码
    if n < 0 then
        return 0
    end
    if n <= 1 then
        return n
    end
    return Fibonacci(n-1)+Fibonacci(n-2)
end

print(Fibonacci(10))  -- 预期输出55

--[[
    4 检测素数
    编写一个函数，检测一个给定的整数是否是素数（只能被1和自身整除的数）。
]]
function IsPrime(num)
    -- 在这里编写代码
    for i = 2, num - 1, 1 do
        if num % i == 0 then
            return false
        end
    end
    return true
end

print(IsPrime(29))  -- 预期输出 true

--[[
    5 数字倒序
    编写一个函数，接受一个整数，并返回其数字倒序的整数。例如，给定123，返回321。
]]
function ReverseNumber(num)
    -- 在这里编写代码
    local reversed = 0
    while num > 0 do
        local digit = num % 10
        reversed = (reversed * 10) + digit
        num = math.floor(num / 10)
    end
    return reversed
end

print(ReverseNumber(123))  -- 预期输出 321