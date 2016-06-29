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


return util