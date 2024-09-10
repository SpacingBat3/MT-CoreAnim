local shim = minetest.settings:get_bool("coreanim_compat.shim",true)
local flags = minetest.settings:get_flags("coreanim_compat.flags") or { set_bone_position = true }
local workaround_mcl = minetest.settings:get_bool("coreanim_compat.fixes.mcl",true)
local workaround_nc = minetest.settings:get_bool("coreanim_compat.fixes.nc",true)

local function mod_loaded(name)
    return table.indexof(minetest.get_modnames(),name) >= 0
end

local function unregister_callback(callback)
    local i = table.indexof(minetest.registered_on_joinplayers, callback)
    -- It is currently unsafe to remove registered callbacks,
    -- replace them with noop function instead.
    minetest.registered_on_joinplayers[i] = function() end
end

local function callback(player)
    unregister_callback(callback)
    local ObjRef = getmetatable(player)
    local position_api = coreanim.register_fn(player,"set_bone_position")
    local override_api = coreanim.register_fn(player,"set_bone_override")
    if (shim and not position_api) or flags.set_bone_position then
        if mod_loaded("mcl_player") and workaround_mcl then
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
    if mod_loaded("nc_player_model") and workaround_nc then
        local oldfn = player.set_bone_override
        ObjRef.set_bone_override = function(player,bone,override)
            if bone == "Head" and override and override.rotation and override.rotation.interpolation then
                override.rotation.interpolation = nil
            end
            if (shim and not override_api) or bone_override then
                coreanim.set_bone_override(player,bone,override)
            else
                oldfn.set_bone_override(player,bone,override)
            end
        end
    elseif (shim and not override_api) or bone_override then
        ObjRef.set_bone_override = coreanim.set_bone_override
    end
end

minetest.register_on_joinplayer(callback)