-- This is more or less an example usage of the API.
--
-- I'll probably put it in public domain later, so
-- anyone can use this as a starting point without
-- licensing considerations.

------- VARS
local last = {}
-- A var to adopt player API to the game, if it works differently
local modifier = 1
-- A value to modify interpolation ('0' will disable)
--local interp


------- CONSTS
-- Still required for the old API.
local HEAD_BASE_POS = { x = 0, y = 6 + 1/3, z = 0 }

------- MAIN CODE

----- Blacklist MineClone-based games
-- 1. Those games already have quite smooth animations due to small delay set
--    for server steps.
-- 2. MineClone quite messes around the APIs, preventing me to make it all
--    smooth, at least as long as I don't mess too much with the animations
--    or mcl API.

if table.indexof(core.get_modnames(),"mcl_player") >= 0 then
	core.log("warning","MCL games are not supported by coreanim_head yet.")
else
	core.register_globalstep(function()
		for _, player in pairs(core.get_connected_players()) do
			local name = player:get_player_name()
			local rotation = { x = math.deg(-player:get_look_vertical())*modifier, y = 0, z = 0 }
				local position
				-- NOTE: Old API does not ignore `nil` values.
				if not player.set_bone_override then position = HEAD_BASE_POS end
				coreanim.set_bone_position(player,"Head", position, rotation)--,interp)
		end
	end)
end