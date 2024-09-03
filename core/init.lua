--- Default animation step. Works best with globalstep-interval animations.
local step_default = tonumber(
    string.match(
        minetest.settings:get("dedicated_server_step"),
        "[+-]?%d+[.]?%d*"
    )
) or 0.09

coreanim = {}

--- Use detached functions, so coreanim can be used to replace detachinal API
local fn_detach = {};

-- Helper functions

local function opt_replace(obj,key,value)
    if obj and not obj[key] then
        obj[key] = value;
    end
end

local function detach_call(player,name,...)
    if not fn_detach[name] then
        fn_detach[name] = player[name]
    end
    fn_detach[name](player,...)
end

local function bone_prop(prop,interp,mod)
    return prop and {
        vec = mod and vector.apply(prop,mod) or prop,
        absolute = true,
        interpolation = interp
    }
end

--- Override the function used by coreanim
--- TODO: Consider making this API access protected/internal for modpack
--- @param player minetest.ObjectRef
--- @param name string
function coreanim.wrap_fn(player,name)
    fn_detach[name] = player[name]
end

--- Old-alike syntax for bone overrides, mostly compatible with old API.
--- @param player minetest.ObjectRef
--- @param bone string
--- @param position vector.Vector|nil
--- @param rotation vector.Vector|nil
--- @param scale vector.Vector|nil
--- @param interpolation number|nil
function coreanim.set_bone_position(player,bone,position,rotation,scale,interpolation)
    -- Deterimne the action taken based on bone override API presence
    if player.set_bone_override then
        interpolation = interpolation or step_default
        -- Transform arguments to proper syntax for the API
        position = bone_prop(position,interpolation)
        rotation = bone_prop(rotation,interpolation,math.rad)
        scale = bone_prop(scale,interpolation)
        detach_call(player,"set_bone_override",bone,{ position = position, rotation = rotation, scale = scale })
    else
        detach_call(player,"set_bone_position",bone,position,rotation)
    end
end

--- New syntax with partial compatibility for the old API
--- and interpolation by the default
--- @param player minetest.ObjectRef
--- @param bone string
--- @param override { ["position"|"rotation"|"scale"]: { vec:vector.Vector|nil, absolute: boolean|nil, interpolation:number|nil }|nil }
function coreanim.set_bone_override(player,bone,override)
    if override then
        opt_replace(override.position,"interpolation",step_default)
        opt_replace(override.rotation,"interpolation",step_default)
        opt_replace(override.scale,"interpolation",step_default)
    end
    if player.set_bone_override then
        detach_call(player,"set_bone_override",bone,override)
    else
        detach_call(player,"set_bone_position",bone,
            override and override.position and override.position.vec,
            override and override.rotation and vector.apply(override.rotation.vec,math.deg)
        )
    end
end