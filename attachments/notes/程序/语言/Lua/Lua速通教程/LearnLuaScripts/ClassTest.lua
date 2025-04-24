-- 1.类的定义
print("1.类的定义")
local MyClass = {
    param1 = 'a', param2 = 'b',-- 定义字段并初始化(可选)
    new = function(self, param1, param2)-- 构造函数
        local instance = setmetatable({}, self)
    	instance.param1 = param1
    	instance.param2 = param2
    	return instance
	end,
    method1 = function(self)-- 定义方法1
        print(self.param1)
    end,
    
    __gc = function()-- 定义析构函数
        print("对象析构")
    end
}MyClass.__index = MyClass -- 设置类的元方法__index为自己

function MyClass:method2()-- 定义方法2
    print(self.param2)
end

function MyClass.method3(self, param)-- 定义方法3
    print(self.param1..self.param2)
end

local obj = MyClass:new("Hello", "World")-- 实例化类，产生对象
obj.method1(obj)
obj:method2()
obj:method3()

-- 2. 类的继承
print("2. 类的继承")
local BaseClass = {-- 基类定义
    new = function(self)-- 基类构造函数
    	local instance = setmetatable({}, self)
    	return instance
	end,
 
    baseMethod = function()-- 基类方法定义
    	print("调用基类方法")
	end
}BaseClass.__index = BaseClass

local DerivedClass = {-- 子类定义
    new = function(self)-- 子类构造函数
        -- *设置基类实例为子类的元表
    	local instance = setmetatable(BaseClass:new(), self)
    	return instance
	end,
    
    baseMethod = function()-- 重写基类方法
        print("调用派生类方法")
        BaseClass.baseMethod()-- 调用基类方法
	end,
    
	derivedMethod = function()
    	print("调用派生类方法")
	end
}DerivedClass.__index = DerivedClass
-- *设置子类的元表为基类模拟继承
setmetatable(DerivedClass, {__index = BaseClass})

local obj = DerivedClass:new()
obj:baseMethod()    -- 输出：调用派生类方法调用基类方法
obj:derivedMethod() -- 调用派生类方法

-- 3.类的多继承
print("3.类的多继承")
local BaseClass1 = {
    new = function(self)
        local instance = setmetatable({}, self)
        return instance
    end,

    baseMethod1 = function()
        print("调用BaseClass1的方法")
    end
}BaseClass1.__index = BaseClass1

local BaseClass2 = {
    new = function(self)
        local instance = setmetatable({}, self)
        return instance
    end,

    baseMethod2 = function()
        print("调用BaseClass2的方法")
    end
}BaseClass2.__index = BaseClass2

function MultipleInheritance(...)
    local classes = {...}
    local derived = {}
    derived.__index = function(table, key)
        -- 首先检查是否在派生类自身中定义了方法
        if derived[key] then
            return derived[key]
        end
        -- 然后检查基类中的方法
        for _, class in ipairs(classes) do
            if class[key] then
                return class[key]
            end
        end
    end
    return derived
end

local DerivedClass = MultipleInheritance(BaseClass1, BaseClass2)

function DerivedClass:new()
    local instance = setmetatable({}, DerivedClass)
    return instance
end

function DerivedClass:derivedMethod()
    print("调用DerivedClass自己的方法")
end

local obj = DerivedClass:new()
obj:baseMethod1()  -- 调用BaseClass1的方法
obj:baseMethod2()  -- 调用BaseClass2的方法
obj:derivedMethod() -- 调用DerivedClass自己的方法

--4. 静态方法
print("4. 静态方法")
local StaticClass = {
    count = 0,
    new = function (self)
        local instance = setmetatable({}, self)
        return instance
    end,
    instanceMethod = function (self)
        self.count = self.count + 1
    end
}StaticClass.__index = StaticClass
function StaticClass.staticMethod ()
    StaticClass.count = StaticClass.count + 1
end 

local function printCount(class, instance1, instance2)
    print("StaticClass:"..class.count.." instance1:"..instance1.count.." instance2:"..instance2.count)
end

local instance1 = StaticClass:new()
local instance2 = StaticClass:new()
printCount(StaticClass, instance1, instance2)
instance1:instanceMethod()
printCount(StaticClass, instance1, instance2)
instance1.staticMethod()
printCount(StaticClass, instance1, instance2)
StaticClass.staticMethod()
printCount(StaticClass, instance1, instance2)
instance2:instanceMethod()
printCount(StaticClass, instance1, instance2)

-- 5.接口模拟
print("5.接口模拟")
local IShape = {-- 接口定义
    draw = function(self)
        print("接口draw未实现！")
    end,
    area = function(self) 
        print("接口area未实现！")
    end,
    type = function(self) 
        print("接口type未实现！")
    end
}IShape.__index = IShape

local Circle = {-- 实现接口的子类定义
    radius = 0,
    new = function(self, radius)
        local obj = setmetatable({radius = radius}, {__index = self})
        return obj
    end,
    draw = function() -- 接口的实现
        print("Drawing a circle.")
    end,
    area = function(self) -- 接口的实现
        return math.pi * self.radius ^ 2
    end
}Circle.__index = Circle
setmetatable(Circle, {__index = IShape})

local circle = Circle:new(5)
circle:draw()
print(circle:area())
circle:type()

--6. 闭包模拟私有性
print("6. 闭包模拟私有性")
local function MyClass()
    local privteTable = { -- 私有表
        privateVariable = "我是私有属性",-- 私有属性
        privateMethod = function ()-- 私有方法
            print("我是私有方法")
        end
    }privteTable.__index = privteTable
    
    -- 公开的方法和属性
    local publicTable = { -- 公有表
        publicMethod = function()-- 公开方法可以访问私有成员
            print(privteTable.privateVariable)
        end
    }publicTable.__index = publicTable
    return publicTable
end

local instance = MyClass()
instance.publicMethod()  -- 输出: 我是私有属性
-- instance.privateVariable 在这里是不可访问的
-- instance.privateMethod   在这里是不可访问的

-- 7.对偶表示模拟私有性
print("7.对偶表示模拟私有性")
local privateInfos = {}-- 外部表存储私有数据
PersonInfo = {
    new = function (self, name, age)
        local instance = setmetatable({}, self)
        instance.name = name-- name是公有字段
        local privateInfo = {age = age}-- age是私有字段，存储到外部表
        privateInfos[instance] = privateInfo
        return instance
    end,
    getAge = function (self)-- 通过公有方法来获取私有属性
        return privateInfos[self].age
    end
}PersonInfo.__index = PersonInfo

local tom = PersonInfo:new("tom", 17)
print(tom.name)
print(tom:getAge())