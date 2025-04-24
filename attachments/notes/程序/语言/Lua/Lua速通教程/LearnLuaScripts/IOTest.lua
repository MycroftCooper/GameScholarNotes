-- 打开文件用于读取
local inputFile = io.open("example.txt", "r")
if not inputFile then
    print("无法打开文件 'example.txt' 进行读取。")
    os.exit(1)
end
local outputFile = io.open("processed_output.txt", "w")
if not outputFile then
    print("无法打开文件 'processed_output.txt' 进行读取。")
    os.exit(1)
end
local copyFile = io.open("copy_of_example.txt", "w")
if not copyFile then
    print("无法打开文件 'copy_of_example.txt' 进行读取。")
    os.exit(1)
end

local lineNum = 0
for line in inputFile:lines() do
    -- 增加行号并转换为大写
    lineNum = lineNum + 1
    local processedLine = "Line " .. lineNum .. ": " .. line:upper() .. "\n"
    outputFile:write(processedLine)

    -- 复制原始行到另一个文件
    copyFile:write(line .. "\n")
end

-- 关闭所有打开的文件
if inputFile then inputFile:close() end
if outputFile then outputFile:close() end
if copyFile then copyFile:close() end