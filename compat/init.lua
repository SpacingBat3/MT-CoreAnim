-- Whenever function has been registered
local mod_set = false

minetest.register_on_joinplayer(function(player)
    local ObjRef = getmetatable(player)
    if not mod_set then
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
        mod_set = true
    end
end)