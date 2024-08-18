local step_default = tonumber(minetest.settings:get("dedicated_server_step"))
-- Default step of the engine (API documents this as 0.1s)
if not step_default then step_default = 0.09 end

coreanim = {}

-- Use old-alike syntax for bone overrides
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
        player:set_bone_override(bone, { position = position, rotation = rotation })
    else
        player:set_bone_position(bone, position, rotation)
    end
end