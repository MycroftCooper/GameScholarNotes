--[[
创建一个Lua脚本，执行以下任务：
1. **定义函数**：
   编写一个函数`safeDivision(numerator, denominator)`，该函数接受两个参数：分子`numerator`和分母`denominator`。
2. **错误检查：**
   - 如果分母为零，则使用`error`函数抛出错误。
   - 使用`assert`来断言结果不是无限大。
3. **错误处理：**
   - 使用`xpcall`调用`safeDivision`，并在调用中故意传递一个零作为分母来触发错误。
   - 为`xpcall`提供一个自定义错误处理函数，该函数生成并返回包含错误信息和栈回溯的字符串。
4. **调试信息：**
   在`safeDivision`函数内，使用`debug.getinfo`报告函数被调用时的当前行号和所在的文件。
5. **变量探查：**
   在`safeDivision`内部，使用`debug.getlocal`获取并打印所有局部变量的名称和值。
]]

local function printAllLocalVariant(getinfoFunction)
    local i = 1
    while true do
        local name, value = getinfoFunction(2, i)
        if not name then break end
        print("局部变量名称:"..name, "值:"..value)
        i = i + 1
    end
end

local function safeDivision(numerator, denominator)
    local info = debug.getinfo(1, "Sl")
    print("行数:" .. info.currentline .. "来源文件:" .. info.source)
    
    if denominator == 0 then
        error("除数不能为0")
    end
    local result = numerator / denominator
    assert(result ~= math.huge, "结果无穷大")
    
    printAllLocalVariant(debug.getlocal)

    return result
end

local status, result = xpcall(
    function ()
        local r1 = safeDivision(3,3)
        local r2 = safeDivision(3,0)
        return r1, r2
    end,
    function (error)
        return "函数出错!: " .. error .. "\n" .. debug.traceback()
    end
)
print(result)