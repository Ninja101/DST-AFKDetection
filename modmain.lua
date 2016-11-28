
local host_immunity = GetModConfigData( "host_immunity" )
local afk_time = GetModConfigData( "afk_time" )
local max_afk_time = GetModConfigData( "max_afk_time" )
local max_afk_action = GetModConfigData( "max_afk_action" )
local stop_death = GetModConfigData( "stop_death" )
local stop_hunger = GetModConfigData( "hunger_decrease" )

local last_move = { }

local function OnPlayerPostInit( inst )
	if inst:HasTag( "player" ) and not inst:HasTag( "CLASSIFIED" ) then
		inst:AddComponent( "afk" )

		inst.components.afk.host_immunity = host_immunity
		inst.components.afk.min_afk_time = afk_time
		inst.components.afk.max_afk_time = max_afk_time
		inst.components.afk.max_afk_action = max_afk_action
		inst.components.afk.stop_death = stop_death
		inst.components.afk.stop_hunger = stop_hunger
	end
end

if GLOBAL.TheNet:GetIsServer( ) then
	AddPrefabPostInitAny( OnPlayerPostInit )
end