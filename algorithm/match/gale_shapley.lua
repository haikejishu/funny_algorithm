-- 稳定匹配问题

require("./debug")
util = require("util")

local people = class("people", function ( )
	return {
		name = "*",
		next_ = nil,
		current_ = nil,
		count_ = nil,
		perfect_ = nil,
	}
end)

function people:ctor( ... )
	-- print("people create ------ ")
end

function refresh( ... )
	-- body
end

function people:debugInitWithCount( count )
	self.perfect_ = {}
	for i=1, count do		
		self.perfect_[i] = i
	end
	util.array_break( self.perfect_ )
end

-----------------------------------
-- 算法
---------------------------------
local debug_count = 10
local boys = {}
local girls = {}

for i=1, debug_count do
	local boy = people:new()
	boy:debugInitWithCount( debug_count )
	table.insert( boys, boy )

	local girl = people:new()
	girl:debugInitWithCount( debug_count )
	table.insert( girls, girl )
end

function getFreePerfectGirl( boyIndex, boys, girls )
	local boy = boys[boyIndex]
	local cur = boy.current_ or 0

	for i= cur + 1, #girls do
		local girl = girls[i]
		if girl.current_ == nil then
			return i, girl
		else
			local curValue = girl.perfect_[ boyIndex ]
			local pValue = girl.perfect_[ girl.current_ ]
			if curValue > pValue then
				return i, girl
			end
		end
	end
end

function getFreeBoy( boys )
	for index, boy in ipairs( boys ) do
		if not boy.current_ then
			return index, boy
		end
	end
end

local count = 1
function doMatch( boys, girls )
	while true do
		count = count + 1
		local boyIndex, boy = getFreeBoy( boys )
		if not boyIndex then
			break
		end
		local girlIndex, girl = getFreePerfectGirl( boyIndex, boys, girls )
		if girl.current_ then
			local lboy = boys[ girl.current_ ]
			lboy.current_ = nil
		end

		boy.current_ = girlIndex
		girl.current_ = boyIndex

	end
end

function MatchAndPrint( boys, girls )
	doMatch( boys, girls )
	for index, boy in ipairs( boys ) do
		print( string.format( "match:  boy:%4d ==> girl:%4d", index or 0, boy.current_ or 0 )  )
	end
	print( "all count === ", count )
end


MatchAndPrint( boys, girls )







