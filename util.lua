--- util 工具类
local util = {}

-- 复制table
function util.table_copy( _table_ )
	if(type(_table_) ~= "table") then
		return _table_;
	end
	local new_table = {};
	for i,v in pairs(_table_) do
		if(type(v) == "table") then
			new_table[i] = M.table_copy(v);
		else
			new_table[i] = v;
		end
	end
	return new_table;
end

function util.table_new( _table_)
    return util.table_copy(_table_)
end

-- 洗牌，把数组里面的元素打乱
function util.array_break( _array )
	local count = #_array
	for i=1, count do
		local r1 = math.random( 1, count )
		local r2 = math.random( 1, count )
		_array[r1], _array[r2] = _array[r2], _array[r1]
	end
end


function util.readFile( file_path )
	local data
	local file = io.open( file_path, "r" )
	if file then
		data = file:read("*a")
		file:close()
	end
	return data
end

return util