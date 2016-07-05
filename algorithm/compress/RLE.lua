-- RLE压缩算法
require("./debug")
util = require("util")

---------------------------------
-- 创建临时文件
---------------------------------
local file_path = "/Users/gxs/Desktop/temp_rle.data"
-- local temp = {}
-- for i=1,10000 do
-- 	temp[i] = (math.random(1,10)) > 9 and 2 or 1
-- end
-- local tempStr = table.concat( temp )
-- local file = io.open( file_path, "w" )
-- file:write(tempStr)
-- file:close()


print("---------")



function RLE_ENCODE( inFile, outFile )
	outFile = outFile or inFile .. ".rle"

	local data = util.readFile( inFile )

	local length = #data
	local checkRep = function ( start, data )    	-- 检查重复
		local last = string.byte( data, start )
		local count = 1
		while( last == string.byte(data, start + count) ) do
			last = string.byte(data, start + count)
			if count == 127 then
				break
			end
			count = count + 1
		end
		return true, count	
	end

	local checkNoRep = function ( start, data ) 		-- 检查不重复
		local last = string.byte( data, start )
		local count = 1
		while( last ~= string.byte(data, start + count) ) do
			last = string.byte(data, start + count)
			if count == 127 then
				break
			end
			count = count + 1
		end
		return true, count
	end


	local file = io.open( outFile, "w" )
	local start = 1
	while( start < length ) do
		local rFlag, count = checkRep( start, data )
		if rFlag then
			local s =  string.byte(data, start) 
			start = start + count
			count = count + 128
			file:write( string.char( count, s ) )
		else
			local s =  string.byte(data, start) 
			local nrFlag, count = checkNoRep( start, data )
			file:write( string.char( count, s ) )
			start = start + count
		end
	end
	file:close()
	return outFile
end

function RLE_DECODE( inFile, outFile )
	outFile = outFile or (inFile .. ".unrle")
	
	local data = util.readFile( inFile )

	local length = #data

	local file = io.open( outFile, "w" )
	local start = 1
	while( start < length ) do
		local flag = string.byte( data, start )
		start = start + 1
		if flag > 127 then 						-- 重复
			local count = flag - 128
			local str = string.char( string.byte( data, start ) )
			file:write( string.rep(str, count) )
			start = start + 1 
		else 									-- 非重复
			local count = flag
			local str = string.sub( data, start, start + count )
			file:write( str )
			start = start + count
		end
	end
	file:close()
	return outFile
end


local outFile1 = RLE_ENCODE( file_path )
local outFile2 = RLE_DECODE( outFile1 )


local data1 = util.readFile( file_path )
local data2 = util.readFile( outFile2 )

-- print( data1, "data1 ==== " )
-- print( data2, "data2 ==== " )

if data1 == data2 then
	print( "compress and uncompress is equal" )
	print( "do success" )
end


 
