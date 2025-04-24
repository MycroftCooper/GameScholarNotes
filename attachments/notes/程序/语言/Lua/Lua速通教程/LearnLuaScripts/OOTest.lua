--[[
    题目 1：定义一个简单的类和实例
    定义一个名为Car的类，它有两个属性：make（制造商）和year（年份）。还要定义一个名为new的方法来创建新实例，并初始化这些属性。
    题目 2：实现一个实例方法
    给Car类添加一个名为getAge的方法，该方法返回车辆的年龄。假设当前年份为2023。
    题目 3：静态属性和静态方法
    为Car类添加一个静态属性totalCars，用于跟踪创建的车辆总数。同时添加一个静态方法getTotalCars，返回创建的车辆总数。
    题目 4：继承
    创建一个ElectricCar类，它继承自Car类，并添加一个额外的属性batterySize。
    题目 5：多态性
    为ElectricCar类重写getAge方法，使其在返回年龄的同时还输出一条消息表明这是一辆电动车。
]]
-- 你的代码
local Car = {
    totalCars = 0,
    getAge = function (self)
        return tonumber(os.date("%Y")) - self.year
    end
}Car.__index = Car

function Car.new(self, make, year)
    local instance = {make = make, year = year}
        setmetatable(instance, self)
        Car.totalCars = Car.totalCars + 1
    	return instance
end

function Car.getTotalCars()
    return Car.totalCars
end


local ElectricCar = {
    new = function (self, make, year, batterySize)
        local instance = setmetatable(Car:new(make, year), self)
        instance.batterySize = batterySize
    	return instance
    end,
    getAge = function (self)
        return "电动车年龄:"..tostring(Car.getAge(self))
    end
}ElectricCar.__index = ElectricCar
setmetatable(ElectricCar, {__index = Car})

-- 测试代码
print("题目1")
local myCar = Car:new("Toyota", 2020)
print(myCar.make)  -- 应输出 "Toyota"
print(myCar.year)  -- 应输出 2020
print("题目2")
print(myCar:getAge())  -- 应输出 3
print("题目3")
local car1 = Car:new("Toyota", 2020)
local car2 = Car:new("Honda", 2018)
print(Car.getTotalCars())  -- 应输出创建的车辆总数:3
print("题目4")
local myElectricCar = ElectricCar:new("Tesla", 2022, 75)
print(myElectricCar.make)  -- 应输出 "Tesla"
print(myElectricCar.batterySize)  -- 应输出 75

print("题目5")
print(myElectricCar:getAge())  -- 应输出年龄和一条关于电动车的消息