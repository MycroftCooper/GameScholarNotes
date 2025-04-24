--[[
    ### 题目 1：协程状态监控
    创建一个协程，并在外部循环中监控并打印其状态。需要涉及到协程的全部状态。
]]
print("题目 1:协程状态监控")
local function subCoroutine(selfCoroutine, mainCoroutine)
    print("主协程状态3:" ,coroutine.status(mainCoroutine))
    print("子协程状态2:", coroutine.status(selfCoroutine))
end

local function mainCoroutine(selfCoroutine)
    print("主协程状态2:" ,coroutine.status(selfCoroutine))
    local subCo = coroutine.create(subCoroutine)
    print("子协程状态1:", coroutine.status(subCo))
    coroutine.resume(subCo, subCo, selfCoroutine)  -- 启动子协程
    print("主协程状态4:" ,coroutine.status(selfCoroutine))
    print("子协程状态3:", coroutine.status(subCo))
end

local mainCo = coroutine.create(mainCoroutine)
print("主协程状态1:" ,coroutine.status(mainCo))
coroutine.resume(mainCo, mainCo)
print("主协程状态5:" ,coroutine.status(mainCo))

--[[
    题目2：计时器
    实现一个协程，能在指定时间后执行某个指定的函数。该计时器可以暂停，恢复，重置，取消等操作。
]]

Timer = {
    timerCoroutine = function (self)
        while true do
            coroutine.yield()
            local now = os.time()
            if now - self.startTime >= self.interval then
                self.callback()
                if self.isLoop then
                    self.startTime = now
                else
                    break
                end
            end
        end
    end,

    new = function (interval, callback, isLoop)
        local self = setmetatable({}, Timer)
        self.interval = interval
        self.callback = callback
        self.isLoop = isLoop or false
        self.isResume = false
        self.startTime = nil
        self.co = coroutine.create(self.timerCoroutine)
        return self
    end,

    -- 启动计时器
    start = function(self)
        self.isResume = true
        self.pausedTime = nil
        self.startTime = os.time()
        self:resume()
    end,

    -- 暂停计时器
    pause = function(self)
        self.isResume = false
        self.pausedTime = os.time()
    end,

    -- 恢复计时器
    resume = function(self)
        if not self.isResume then
            return
        end
        coroutine.resume(self.co, self)
        if not self.pausedTime or os.time() - self.pausedTime >= self.interval then
            self:start()
        else
            self:resumeTimer()
        end
    end,

    -- 重置计时器
    reset = function(self)
        self:pause()
        self:start()
    end,

    -- 取消计时器
    cancel = function(self)
        self.isResume = false
        self.co = nil -- 释放协程
    end
}Timer.__index = Timer

-- 测试代码
local function onTimer()
    print("Timer triggered at " .. os.date("%X"))
end

-- 创建计时器（5秒后触发，循环）
local timer = Timer.new(5, onTimer, true)
timer:start()

-- 测试暂停、恢复和取消
os.execute("sleep " .. tonumber(6))  -- 等待6秒
timer:pause()
print("Timer paused at " .. os.date("%X"))

os.execute("sleep " .. tonumber(3))  -- 等待3秒
timer:resume()
print("Timer resumed at " .. os.date("%X"))

os.execute("sleep " .. tonumber(6))  -- 等待6秒
timer:cancel()
print("Timer canceled at " .. os.date("%X"))