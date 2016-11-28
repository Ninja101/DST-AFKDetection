
local AFK_ACTION_DISABLE = 1
local AFK_ACTION_KICKPLAYER = 2

local AFK = Class( function( self, inst )
	self.inst = inst

	self.host_immunity = false
	self.min_afk_time = 60
	self.max_afk_time = 0
	self.max_afk_action = AFK_ACTION_DISABLE
	self.stop_death = true
	self.stop_hunger = true
	self.stop_sanity = true

	self.afk = false
	self.afk_time = GetTime( )
	self.afk_sanity = 0

	inst:ListenForEvent( "locomote", function( )
		if inst.components.locomotor.wantstomoveforward then
			self:ResetAFKTime( false )
		end
	end )

	local function updateFn( ) self:OnUpdate( 0 ) end
	local function resetFn( ) self:ResetAFKTime( false ) end

	inst:ListenForEvent( "buildstructure", resetFn )
	inst:ListenForEvent( "performaction", resetFn )
	inst:ListenForEvent( "equip", resetFn )
	inst:ListenForEvent( "unequip", resetFn )
	inst:ListenForEvent( "oneatsomething", resetFn )
	inst:ListenForEvent( "performaction", resetFn )
	inst:ListenForEvent( "buildsuccess", resetFn )
	inst:ListenForEvent( "itemget", resetFn )
	-- inst:ListenForEvent( "ontalk", resetFn )

	self.inst:DoPeriodicTask( 1, updateFn )
end )

function AFK:UpdateAFKTime( )
	if self.inst.components.health ~= nil and self.inst.components.health:IsDead( ) then
		return
	end

	if self.inst.sleepingbag ~= nil then
		return -- Asleep
	end

	if not self.afk then
		self.afk = true

		if self.inst.components.sanity ~= nil then
			self.afk_sanity = self.inst.components.sanity:GetPercent( )
		end

		print( "[N101] IsAFK: ", self.inst )
		TheNet:Announce( self.inst.name .. " is AFK" )
	end

	if self.afk then
		if self.inst.components.health ~= nil and self.stop_death then
			self.inst.components.health:SetInvincible( true )
		end

		if self.inst.components.hunger ~= nil and self.stop_hunger then
			self.inst.components.hunger:Pause( )
		end

		if self.inst.components.sanity ~= nil and self.stop_sanity and self.afk_sanity > 0 then
			self.inst.components.sanity:SetPercent( self.afk_sanity )
		end
	end
end

function AFK:ResetAFKTime( exceeded_time )
	self.afk_time = GetTime( )

	if self.afk then
		self.afk = false
		self.afk_sanity = 0

		if exceeded_time then
			self.afk_time = GetTime( ) + 999999 -- Don't let it make them AFK again until the activity hooks have set the value
		else
			print( "[N101] IsNotAFK: ", self.inst )
			TheNet:Announce( self.inst.name .. " is no longer AFK" )
		end

		if self.inst.components.health ~= nil and self.stop_death then
			self.inst.components.health:SetInvincible( false )
		end
		if self.inst.components.hunger ~= nil and self.stop_hunger then
			self.inst.components.hunger:Resume( )
		end
	end
end

function AFK:OnSave( )
	return { }
end

function AFK:OnLoad( data )

end

function AFK:OnUpdate( dt )
	local time = GetTime( )
	local time_afk = ( time - self.afk_time )

	if time_afk >= self.min_afk_time then
		self:UpdateAFKTime( )
	end

	if self.max_afk_time > 0 and time_afk > self.max_afk_time then
		if self.host_immunity and self.inst.Network:IsServerAdmin( ) then
			return
		end

		if self.inst.userid == TheNet:GetUserID( ) then
			self.max_afk_action = AFK_ACTION_DISABLE -- Can't kick host, dummy
		end

		print( "[N101] ExceededAFK: ", self.inst )
		TheNet:Announce( self.inst.name .. " exceeded the maximum AFK duration" )

		if self.max_afk_action == AFK_ACTION_DISABLE then
			self:ResetAFKTime( true )
		elseif self.max_afk_action == AFK_ACTION_KICKPLAYER then
			TheNet:Kick( self.inst.userid )
		end
	end
end

return AFK