-- 妖怪与和尚问题
-- 穷举法
require("class")
require("./debug")
local util = require("util")

local count = 0

local monster_monk = class("monster_monk")

local start_left = { 3, 3 }
local start_right = {0, 0}

local end_right = {3,3}

local cur_state = { 3, 3, 0, 0, 1 }
local cur_boat = { 0, 0}

function monster_monk:canCross( state, monster, monk )
	-- Log1(state)
	if monk > 0 and monster > monk then 			-- 船上面的状态
		return false, "船上的和尚会被吃"
	end
	if monster + monk > 2 then 			-- 船一次最多过两个人
		return false, "船上最多上两个人"
	end
	if state[5] == 1 then   -- 船的位置在左侧
		if monster + monk == 0 then
			return false, "起点不能空船出发"
		end
		if (state[1] - monster) > (state[2] - monk) then   -- 左岸的状态
			return false, "左侧的和尚被吃了"
		end
	elseif state[5] == 2 then    -- 船的位置在右侧
		if (state[3] - monster) > (state[4] - monk) then   -- 左岸的状态
			return false, "右侧的和尚被吃了"
		end
	end
	return true
end

function monster_monk:isProcessedState( states, newState )
	local equalFunc = function ( state2 )
		for k,v in ipairs( newState ) do
			if state2[k] ~= v then
				return false
			end
		end
		return true
	end
	return states:hasDataByFunc( equalFunc )
end 


function monster_monk:isFinalState( state )
	if state and state[3] == end_right[1] and state[4] == end_right[2] then
		return true
	end
end

local result_count = 0
local minCount = nil
function monster_monk:printResults( states )
	result_count = result_count + 1
	local use = states:getCount()
	if (not minCount) or use < minCount then
		minCount = use
	end
	-- print("get result ---------------- ", result_count, "use step:", use, "search step :", count)
	states:dumpLeft()
	-- Log1( states )
end

function monster_monk:crossRole( state, monster, monk )
	local new_state = util.table_new( state )
	if new_state[5] == 1 then
		new_state[1] = new_state[1] - monster
		new_state[2] = new_state[2] - monk
		new_state[3] = new_state[3] + monster
		new_state[4] = new_state[4] + monk
		new_state[5] = 2
	elseif state[5] == 2 then
		new_state[1] = new_state[1] + monster
		new_state[2] = new_state[2] + monk
		new_state[3] = new_state[3] - monster
		new_state[4] = new_state[4] - monk
		new_state[5] = 1
	end
	local pos = new_state[5] == 1 and "右侧" or "左侧"
	new_state.msg = string.format( "从%s: 让%d怪物%d和尚过河  -->  ( %d, %d, %d, %d, %d )", pos, monster, monk, new_state[1], new_state[2], new_state[3], new_state[4], new_state[5] )
	return new_state
end

function monster_monk:tryOneCross( states, state, monster, monk )
	local flag, msg = self:canCross( state, monster, monk )
	-- print( "try ( ", state[1],state[2],state[3],state[4],state[5], ")", monster, monk, flag, msg )
	if self:canCross( state, monster, monk ) then
		local new_state = self:crossRole( state, monster, monk )
		if not self:isProcessedState( states, new_state ) then
			states:addRight( new_state )
			self:SearchStates( states )
			-- states:dumpLeft()
			states:popRight( )
		end
	end
end

function monster_monk:SearchStates( states )
	count = count + 1
	if count > 100000 then
		return 
	end
	local cur = states:getLast()

	if self:isFinalState(cur) then
		self:printResults(states)
		return
	end

	local lastMonster
	local lastMonk
	if cur[5] == 1 then
		lastMonster = cur[1]
		lastMonk = cur[2]
	elseif cur[5] == 2 then
		lastMonster = cur[3]
		lastMonk = cur[4]
	end
	lastMonster = math.min( lastMonster, 2 )
	lastMonk = math.min( lastMonk, 2 )

	for j= 0, lastMonster  do
		for i = 0, lastMonk  do
			self:tryOneCross( states, cur, j, i )
		end
	end
end

local AllStates = dList:new()
AllStates:addRight( cur_state )
monster_monk:SearchStates( AllStates )

AllStates:dumpLeft()

print("min count:", minCount)


















