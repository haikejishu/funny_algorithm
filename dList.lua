	-- data = nil,
	-- left = nil,
	-- right = nil,

local dList = {
	data = nil,
}

function dList:addLeft( data )	
	if self.head then
		local temp = { d = data, right = self.head, left = nil }
		self.head.left = temp
		self.head = temp
	else
		self.head = { d = data, left = nil, right = nil }
		self.last = self.head
	end
end

function dList:addRight( data )	
	if self.last then
		local temp = { d = data, left = self.last, right = nil }
		self.last.right = temp
		self.last = temp
	else
		self.last = { d = data, left = nil, right = nil }
		self.head = self.last
	end
end

function dList:getLast( )
	if self.last then
		return self.last.d
	else
		return nil
	end
end

function dList:popLeft( )
	if self.head then
		local data = self.head.d
		self.head = self.head.right
		if self.head == nil then
			self.last = self.head
		else
			self.head.left = nil
		end
		return data
	else
		return nil
	end
end

function dList:popRight( )
	if self.last then
		local data = self.last.d
		self.last = self.last.left
		if self.last == nil then
			self.head = self.last
		else
			self.last.right = nil
		end
		return data
	else
		return nil
	end
end

function dList:dumpLeft( )
	local temp = self.head
	while temp do
		-- print( "list ====", table.unpack(temp.d) )
		print( temp.d.msg )
		temp = temp.right
	end
end

function dList:clearAll( )
	self.head = nil
	self.last = nil
end

function dList:hasData( data )
	local temp = self.head
	while temp do
		if temp.d == data then
			return true
		else
			temp = temp.right
		end
	end
	return false
end

function dList:hasDataByFunc( func )
	local temp = self.head
	while temp do
		if func( temp.d ) then
			return true
		else
			temp = temp.right
		end
	end
	return false
end

function dList:getCount( )
	local temp = self.head
	local count = 0
	while temp do
		count = count + 1
		temp = temp.right
	end
	return count
end


return dList