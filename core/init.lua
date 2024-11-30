-----------------
--< VARIABLES >--
-----------------

--- Module table
coreanim = {}

--- Default animation step.
local step_default = tonumber(core.settings:get("coreanim_core.step"))

if not step_default or step_default < 0 then
    step_default = tonumber(string.match(
        core.settings:get("dedicated_server_step"),
        "[+-]?%d+[.]?%d*"
    )) or 0.09
end

--[[ @module "helpers" ]]
local helpers,fn_detach = dofile(core.get_modpath(core.get_current_modname()).."/helpers.lua")

-------------------------
--< MODULE DEFINITION >--
-------------------------

--- Override the function used by coreanim.
--- @param player core.ObjectRef
--- @param name string
--- @return false|function
function coreanim.register_fn(player,name)
    -- Protection against non-engine APIs (this could potentially end with self-reference)
    if fn_detach[name] ~= false then
        fn_detach[name] = player[name] or false
    end
    -- Immediate protection against obvious self-reference
    if fn_detach[name] == coreanim[name] then
        error("Self-reference for API '"..name.."'detected!")
    end
    return fn_detach[name]
end

--- Old-alike syntax for bone overrides, mostly compatible with old API.
--- @param player core.ObjectRef
--- @param bone string
--- @param position vector.Vector|nil
--- @param rotation vector.Vector|nil
--- @param scale vector.Vector|nil
--- @param interpolation number|nil
function coreanim.set_bone_position(player,bone,position,rotation,scale,interpolation)
    -- Deterimne the action taken based on bone override API presence
    if helpers.has_api(player,"set_bone_override") then
        interpolation = interpolation or step_default
        -- Transform arguments to proper syntax for the API
        position = helpers.bone_prop(position,interpolation)
        rotation = helpers.bone_prop(rotation,interpolation,math.rad)
        scale = helpers.bone_prop(scale,interpolation)
        helpers.detach_call(player,"set_bone_override",bone,{ position = position, rotation = rotation, scale = scale })
    else
        helpers.detach_call(player,"set_bone_position",bone,position,rotation)
    end
end

--- New syntax with partial compatibility for the old API
--- and interpolation by the default
--- @param player core.ObjectRef
--- @param bone string
--- @param override { ["position"|"rotation"|"scale"]: { vec:vector.Vector|nil, absolute: boolean|nil, interpolation:number|nil }|nil }
function coreanim.set_bone_override(player,bone,override)
    if override then
        helpers.opt_replace(override.position,"interpolation",step_default)
        helpers.opt_replace(override.rotation,"interpolation",step_default)
        helpers.opt_replace(override.scale,"interpolation",step_default)
    end
    if helpers.has_api(player,"set_bone_override") then
        helpers.detach_call(player,"set_bone_override",bone,override)
    else
        helpers.detach_call(player,"set_bone_position",bone,
            override and override.position and override.position.vec,
            override and override.rotation and vector.apply(override.rotation.vec,math.deg)
        )
    end
end