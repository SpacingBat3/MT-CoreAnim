local step_default = tonumber(minetest.settings:get("dedicated_server_step"))
-- Default step of the engine (API documents this as 0.1s)
if not step_default then step_default = 0.09 end

coreanim = {}

-- Use detached functions, so coreanim can be used to replace detachinal API
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

-- Override the function used by coreanim
-- TODO: Consider making this API access protected/internal for modpack
function coreanim.wrap_fn(player,name)
    fn_detach[name] = player[name]
end

-- Old-alike syntax for bone overrides, mostly compatible with old API.
function coreanim.set_bone_position(player,bone,position,rotation,scale,interpolation)
    if player.set_bone_override then
        interpolation = interpolation or step_default
        position = position and {
        	vec = position,
            absolute = true,
            interpolation = interpolation
        }
        rotation = rotation and {
        	vec = vector.apply(rotation,math.rad),
            absolute = true,
            interpolation = interpolation
        }
        scale = scale and {
            vec = scale,
            absolute = true,
            interpolation = interpolation
        }
        if not fn_detach.set_bone_override then
            fn_detach.set_bone_override = player.set_bone_override
        end
        detach_call(player,"set_bone_override",bone,{ position = position, rotation = rotation })
    else
        detach_call(player,"set_bone_position",bone,position,rotation)
    end
end

-- New syntax with partial compatibility for the old API
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
            override and override.rotation and vector.apply(override.rotation.vec,math.lab)
        )
    end
end