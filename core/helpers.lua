local helpers,fn_detach = {},{}


--- @param table table
--- @param key string
--- @param value unknown
function helpers.opt_replace(table,key,value)
    if table and not table[key] then
        table[key] = value
    end
end

--- @param player minetest.ObjectRef
--- @param name string
--- @param ... unknown
function helpers.detach_call(player,name,...)
    if fn_detach[name] == false then
        error("Unavailable engine API: "..name)
    elseif not fn_detach[name] then
        fn_detach[name] = player[name]
    end
    fn_detach[name](player,...)
end

--- Converts value to `set_bone_override` subtable format.
--- @param property vector.Vector|nil
--- @param interpolation number|nil
--- @param modifier function|nil
--- @return {vec:vector.Vector,absolute:boolean,interpolation:number|nil}|nil
function helpers.bone_prop(property,interpolation,modifier)
    return property and {
        vec = modifier and vector.apply(property,modifier) or property,
        absolute = true,
        interpolation = interpolation
    }
end

--- Determine if CoreAnim assumes given API is supported natively by the
--- engine and whenever it wasn't overwritten by any CoreAnim-related mod
--- later in the process.
--- @param player minetest.ObjectRef
--- @param name string
function helpers.has_api(player,name)
    return player[name] and fn_detach[name] ~= false or false
end

return helpers,fn_detach