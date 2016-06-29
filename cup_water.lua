local util = require( "util" )
require( "./debug" )

local count = 0

local cup 	= { 8, 5, 3}
local start_status = { 8, 0, 0 }
local end_status = { 4, 4, 0}

local AllStates = require( "dList" )


local OneState = {  }  -- { state = { cup1, cup2, cup3}, action = { from, to, water }  }


function canDump( state, from, to )
	if from == to then					-- 同一个杯子
		return false
	elseif state[from] == 0 then  			-- 杯子没水
		return false
	elseif state[to] == cup[to] then -- 杯子已满
		return false
	end	
	return true
end

function isProcessedState( states, newState )
	local equalFunc = function ( state2 )
		if newState[1] == state2[1] and newState[2] == state2[2] then
			return true
		end
	end
	return states:hasDataByFunc( equalFunc )
end 


function isFinalState( state )
	-- dump_obj( state, "isFinalState =======  " )
	if state and state[1] == end_status[1] and state[2] == end_status[2] then
		return true
	end
end

local result_count = 0
local minCount = nil
function printResults( states )
	result_count = result_count + 1
	local use = states:getCount()
	if (not minCount) or use < minCount then
		minCount = use
	end
	print("get result ---------------- ", result_count, "use step:", use, "search step :", count)
	states:dumpLeft()
	-- Log1( states )
end

function table_copy( _table )
	local newt = {}
	for k,v in pairs(_table) do
		newt[k] = v
	end
end

function DumpWater( state, from, to )
	local fromW = state[ from ]
	local toW = state[ to ]
	local canW = cup[to] - toW
	local dW 
	if fromW > canW then
		dW = canW
	else
		dW = fromW
	end
	-- dump_obj( state )
	local new_state = util.table_new( state )
	new_state[from] = new_state[from] - dW
	new_state[to] = new_state[to] + dW
	new_state.msg = string.format( "从杯子%d倒%d升水进入杯子%d => %d, %d, %d", from, dW, to, new_state[1], new_state[2], new_state[3] )
	return new_state
end

function SearchStatesOnAction( states, state, from, to )
	if canDump( state, from, to ) then
		local new_state = DumpWater( state, from, to )
		-- dump_obj( new_state, "isProcessedState =======  " )
		if not isProcessedState( states, new_state ) then
			states:addRight( new_state )
			SearchStates( states )
			states:popRight( )
		end
	end
end

function SearchStates( states )
	count = count + 1

	local cur = states:getLast()
	if isFinalState(cur) then
		printResults(states)
		return
	end


	for j=1, #cup  do
		for i=1, #cup  do
			SearchStatesOnAction( states, cur, i, j )
		end
	end
end

AllStates:addRight( start_status )
SearchStates( AllStates )


print("min count:", minCount)



























