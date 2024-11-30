local shim = core.settings:get_bool("coreanim_compat.shim",true)
local flags_raw = ","..(core.settings:get("coreanim_compat.flags") or "set_bone_position")..",";
local flags = {
    set_bone_position = flags_raw:match(",set_bone_position,") and true or false;
    set_bone_override = flags_raw:match(",set_bone_override,") and true or false;
}
local workaround_mcl = core.settings:get_bool("coreanim_compat.fixes.mcl",true)
local workaround_nc = core.settings:get_bool("coreanim_compat.fixes.nc",true)

local function mod_loaded(name)
    return table.indexof(core.get_modnames(),name) >= 0
end

local function unregister(api,callback)
    local list = core["registered_"..api.."s"]
    local i = table.indexof(list, callback)
    local fn_orig = list[#list]
    -- It's somewhat tricky, but hooking it like that should be safe enough
    -- as a cleanup job.
    list[#list] = function(...)
        table.remove(list,i)
        list[#list] = fn_orig
        return fn_orig(...)
    end
end

local function callback(player)
    unregister("on_joinplayer",callback)
    local ObjRef = getmetatable(player)
    local position_api = coreanim.register_fn(player,"set_bone_position")
    local override_api = coreanim.register_fn(player,"set_bone_override")
    -- Bone position API
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
    -- Bone override API
    if mod_loaded("nc_player_model") and workaround_nc then
        local oldfn = player.set_bone_override
        ObjRef.set_bone_override = function(player,bone,override)
            local workaround_apply = false
            if bone == "Head" and override then
                if override.rotation and override.rotation.interpolation then
                    override.rotation.interpolation = nil
                end
                if override.position and override.position.interpolation then
                    override.position.interpolation = nil
                end
                workaround_apply = true
            end
            if (shim and not override_api) or flags.set_bone_override or workaround_apply then
                coreanim.set_bone_override(player,bone,override)
            else
                oldfn(player,bone,override)
            end
        end
    elseif (shim and not override_api) or flags.set_bone_override then
        ObjRef.set_bone_override = coreanim.set_bone_override
    end
end

core.register_on_joinplayer(callback)