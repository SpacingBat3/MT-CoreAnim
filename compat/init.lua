local function unregister_callback(callback)
    local i = table.indexof(minetest.registered_on_joinplayers, callback)
    -- It is currently unsafe to remove registered callbacks,
    -- replace them with noop function instead.
    minetest.registered_on_joinplayers[i] = function() end
end

local function callback(player)
    unregister_callback(callback)
    local ObjRef = getmetatable(player)
    coreanim.wrap_fn(player,"set_bone_position")
    if table.indexof(minetest.get_modnames(),"mcl_player") >= 0 then
        -- MCL games require separate replacement function, as those
        -- tend to break a bit with the current API logic.
        -- This is a dirty hack, but at least it works.
        local oldfn = player.set_bone_position
        local bone_called = {}
        ObjRef.set_bone_position = function (player,bone,position,rotation)
            if bone_called[bone] then
                coreanim.set_bone_position(player,bone,position,rotation)
            else
                oldfn(player,bone,position,rotation)
                bone_called[bone] = true
            end
        end
    else
        ObjRef.set_bone_position = coreanim.set_bone_position
    end
end

minetest.register_on_joinplayer(callback)