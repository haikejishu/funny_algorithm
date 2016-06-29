--[[
    dump_obj(obj [, key ][, sp ][, lv ][, st])
    obj: object to dump
    key: a string identifying the name of the obj, optional.
    sp: space string used for indention, optional(default:'  ').
    lv: for internal use, leave it alone! levels of nested dump.
    st: for internal use, leave it alone! map of saved-table.
 
    it returns a string, which is simply formed just by calling
    'tostring' with any value or sub values of object obj, exc-
    -ept table!.

    eg:
    print(dump_obj(_G))
]]
function dump_obj(obj, key, sp, lv, st)
    sp = sp or '  '
 
    if type(obj) ~= 'table' then
        return sp..(key or '')..' = '..tostring(obj)..'\n'
    end
 
    local ks, vs, s= { mxl = 0 }, {}
    lv, st =  lv or 1, st or {}
 
    st[obj] = key or '.' -- map it!
    key = key or ''
    for k, v in pairs(obj) do
        if type(k) == "string" then
            k = '"' .. k .. '"'
        end
        if type(v)=='table' then
            if st[v] then -- a dumped table?
                table.insert(vs,'['.. st[v]..']')
                s = sp:rep(lv)..tostring(k)
                table.insert(ks, s)
                ks.mxl = math.max(#s, ks.mxl)
            else
                st[v] =key..'.'..k -- map it!
                table.insert(vs,
                    dump_obj(v, st[v], sp, lv+1, st)
                )
                s = sp:rep(lv)..tostring(k)
                table.insert(ks, s)
                ks.mxl = math.max(#s, ks.mxl)
            end
        else
            if type(v)=='string' then
                table.insert(vs,
                    (('%q'):format(v)
                        :gsub('\\\10','\\n')
                        :gsub('\\r\\n', '\\n')
                    )
                )
            elseif type(v)=='userdata' and tolua.type(v) == "util_json"  then
                table.insert(vs,
                    (('%q'):format( v:getFormatBuffer() )
                        :gsub('\\\10','\\n')
                        :gsub('\\r\\n', '\\n')
                    )
                )
            else
                table.insert(vs, tostring(v))
            end
            s = sp:rep(lv)..tostring(k)
            table.insert(ks, s)
            ks.mxl = math.max(#s, ks.mxl);
        end
    end
 
    s = ks.mxl
    for i, v in ipairs(ks) do
        vs[i] = v..(' '):rep(s-#v)..' = '..vs[i]..'\n'
    end
 
    return '{\n'..table.concat(vs)..sp:rep(lv-1)..'}'
end

function Log1( data )
    if type(data) == "table" then
        print( dump_obj(data) )
    else
        print(data)
    end
end