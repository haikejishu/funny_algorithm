-- 星期算法

-- 儒略日算法
function getJulianWeek( year, month, day, hour, min, sec )
	local floor = math.floor
	hour = hour or 0
	min = min or 0
	sec = sec or 1
	local a = floor( ( 14 - month ) / 12 )
	local y = year + 4800 - a
	local m = month + 12 * a - 3
	local days = day 
		+ floor((135 * m + 2) / 5) 
		+ 365 * y 
		+ floor(y / 4) 
		- floor(y / 100) 
		+ floor(y / 400) 
		- 32045
	days = days - 0.5 + hour / 24.0 + min / 1440.0 + sec / 86400.0
	days = floor( days )
	local week = ((days) % 7) + 1 
	return week
end


-- 蔡勒公式
function getZellerWeek( year, month, day )
	local m = month
	local d = day
	if month <= 2 then
		m = month + 12
		year = year - 1
	end

	local floor = math.floor
	local y = year % 100
	local c = floor( year / 100 )

	local w = floor( y + floor( y / 4 ) + floor( c / 4 ) - 2 * c + floor( 13 * (m + 1) / 5) + d - 1  ) % 7
	if w <= 0 then
		w = w + 7
	end
	return w
end


local week = {}

function week:getTrueWeek( year, month, day, hour, min, sec  )
	return getZellerWeek(  year, month, day, hour, min, sec   )
end


---------------------------------
-- test
---------------------------------

-- print( getJulianWeek( 1977, 03, 27, 12 ) )
-- print( getJulianWeek( 2005, 05, 31, 12 ) )
-- print( getJulianWeek( 2016, 03, 05, 12 ) )
-- print( getJulianWeek( 2016, 07, 05, 12 ) )

-- print( " ------------ ")

-- print( getZellerWeek( 1977, 03, 27, 12 ) )
-- print( getZellerWeek( 2005, 05, 31, 12 ) )
-- print( getZellerWeek( 2016, 03, 05, 12 ) )
-- print( getZellerWeek( 2016, 07, 05, 12 ) )

-- print( getZellerWeek( 2016, 07, 05 + 4, 12 ) )
-- print( getZellerWeek( 2016, 07, 05 + 5, 12 ) )
-- print( getZellerWeek( 2016, 07, 05 + 6, 12 ) )

return week
 
