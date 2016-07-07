-- 稳定匹配问题

require("./debug")
util = require("util")


local range = { -0.8, 8.0}
local fun = function ( x )
	return 2 * x * x + 3.2 * x - 1.8
end

----------------------------------
-- 二分迭代法
---------------------------------
local PRECISION = 0.0000000000000001   -- 求根进度

local count = 0
function DichotomyEquation( pRange, eRange, func )
	local mid = ( pRange + eRange ) * 0.5
	while( (eRange - pRange) > PRECISION ) do
		count = count + 1
		if func( pRange ) * func(mid) < 0.0 then
			eRange = mid
		else
			pRange = mid
		end
		mid = ( pRange + eRange ) * 0.5
	end
	return mid
end

----------------------------------
-- 牛顿迭代法（牛顿·拉弗森）
---------------------------------

-- 求解函数f在x附近的一阶导数值

function CalcDerivative( func, x )
	return (func(x + 0.000005) - func(x - 0.000005)) / 0.00001
end

local count1 = 0
function NewtonRaphson( func, x0 )
	local x1 = x0 - func(x0) / CalcDerivative(func, x0) 
	while math.abs(x1 - x0) > PRECISION do 
		count1 = count1 + 1
		x0 = x1
		x1 = x0 - func(x0) / CalcDerivative( func, x0 )
	end
	return x1
end

---------------- 测试 -------------------

print("--------------------------------")
print( "二分迭代法：" )
local result = DichotomyEquation( range[1], range[2], fun )
print( "result = ", result )
print( "use count = ", count )
print("--------------------------------\n\n")


print("--------------------------------")
print( "牛顿迭代法：" )
local result = NewtonRaphson( fun, range[2] )
print( "result = ", result )
print( "use count = ", count1 )
print("--------------------------------\n\n")



