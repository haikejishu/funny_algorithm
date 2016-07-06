-- 公历

local calender = {}

function calender:isLeapYear( year )
	return ( year % 4 == 0 ) and ( year % 10 ~= 0) or ( year % 400 == 0)
end

local month_day = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

function calender:printValender( year, month )
	local day = month_day[month]
	if month == 2 then
		if self:isLeapYear( year ) then
			day = 28
		end
	end

	local __week = require( "algorithm.calender.week" )
	local week = __week:getTrueWeek( year, month, 1 )

	local days = {  }
	for i=1, week - 1  do
		table.insert( days, {} )
	end

	local tday = 1
	while tday <= day do 
		table.insert( days, { day = tday, week = (week + tday - 1) %7 } )
		tday = tday + 1
	end

	local count = 0
	while count < #days do 
		local msg = ""
		for i=1, 7 do
			local t = days[count + i]
			if t.day then
				msg = msg .. string.format( " %d/%d ", t.day, t.week ) 
			else
				msg = msg .. "      "
			end
			msg = msg .. "\t\t"
		end
		count = count + 7
		print( msg )
	end
end




--------- 测试
local years = {  1500, 1964, 2000, 2100 }
for i, year in ipairs( years ) do
	print( year, "is leap year flag:", calender:isLeapYear( year ) )
end

print("\n\n\n")

calender:printValender( 2016, 07 )





return calender
