const bhop_version = "1.0.1"

::bunnyhop <- {
	function OnGameEvent_player_spawn(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(IsPlayerABot(player)) return
		AddThinkToEnt(player, null)
		AddThinkToEnt(player, "bunny")

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()

		scope.bunnyhopping <- 0
		scope.rocketjumping <- 0
	}
	function OnGameEvent_player_team(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(IsPlayerABot(player)) return
		AddThinkToEnt(player, null)
		AddThinkToEnt(player, "bunny")

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		scope.toggle <- 0
		scope.bunnyhopping <- 0
		scope.rocketjumping <- 0
		ClientPrint(player, 3, "\x0720BB20[Bhop]\x01 BunnyHop is Enabled By Default,\nUse \x03!bhop\x01 or \x03/bhop\x01 to toggle it!\nOr use \x03!bhop info\x01, or \x03/bhop info\x01 for more information")
	}
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(IsPlayerABot(player)) return
		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		if(params.text == "!bhop" || params.text == "/bhop")
		{
			if (!("toggle" in scope)) 
				scope.toggle <- 0
			
			switch (scope.toggle)
			{
				case 0:
					scope.toggle = 1
					ClientPrint(player, 3, "\x0720BB20[Bhop]\x01 Enabled BunnyHop")
					break;
				case 1:
					scope.toggle = 0
					ClientPrint(player, 3, "\x0720BB20[Bhop]\x01 Disabled BunnyHop")
					break;
			}
		}
		if(params.text == "!bhop info" || params.text == "/bhop info")
		{
			local extra = ""
			if(player.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SCOUT)
			{
				extra = "\n\x07FF2020[Warning]\x07FF8888 Does break double jumps!"
			}

			ClientPrint(player, 3, "\x0720BB20[Bhop - Version " + bhop_version + "]\x01\n - Fixed Market Gardens & Winger jump height increase." + extra)
		}
	}
	function OnGameEvent_rocket_jump(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(IsPlayerABot(player)) return
		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		scope.rocketjumping = 1
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		local player = params.inflictor
		if(IsPlayerABot(player)) return
		local gardener = false
		for(local i = 0 ; i <= 3 ; i++)
		{
			if(GetWeaponIDXInSlot(player, i) == 416)
			{
				gardener = true
				break
			}
		}
		if(!gardener) return

		player.ValidateScriptScope()
		local scope = player.GetScriptScope()
		if(scope.rocketjumping == 1)
		{
			params.damage_type = params.damage_type | Constants.FDmgType.DMG_ACID
		}
	}
}
__CollectGameEventCallbacks(bunnyhop)

function IsPlayerOnGround(player)
{
    return (player.GetFlags() & Constants.FPlayer.FL_ONGROUND)
}
function IsPlayerJumping(player)
{
    return (NetProps.GetPropInt(player, "m_nButtons") & Constants.FButtons.IN_JUMP)
}
function GetWeaponIDXInSlot(player, slot)
{
    return NetProps.GetPropInt(NetProps.GetPropEntityArray(player, "m_hMyWeapons", slot), "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
}
function GetActiveWeaponIDX(player)
{
	return NetProps.GetPropInt(player.GetActiveWeapon(), "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
}
function bunny()
{
	if(IsPlayerABot(self)) return 1000
	local scope = self.GetScriptScope()
	if (!("toggle" in scope))
		scope.toggle <- 0

	if(scope.toggle == 0) return 0
	if(IsPlayerOnGround(self))
	{
		if(IsPlayerJumping(self))
		{
			local jump_speed = 267
			if(GetActiveWeaponIDX(self) == 449)
			{
				jump_speed = jump_speed * 1.25
			}
			scope.bunnyhopping = 1
			local boost = 25
			switch (self.GetPlayerClass())
			{
				case (Constants.ETFClass.TF_CLASS_SCOUT || Constants.ETFClass.TF_CLASS_ENGINEER
				|| Constants.ETFClass.TF_CLASS_SPY):
				{
					boost = 20
				}
				// The Normal speed
				case (Constants.ETFClass.TF_CLASS_PYRO || Constants.ETFClass.TF_CLASS_DEMOMAN ||
				Constants.ETFClass.TF_CLASS_MEDIC || Constants.ETFClass.TF_CLASS_SNIPER ||
				Constants.ETFClass.TF_CLASS_SOLDIER):
				{
					boost = 25
				}
				// Very slow
				case Constants.ETFClass.TF_CLASS_HEAVYWEAPONS:
				{
					boost = 30
				}
			}
			local vel = Vector(self.GetForwardVector().x*boost, self.GetForwardVector().y*boost, jump_speed)
			ClientPrint(self, 4, vel.tostring())
			self.ApplyAbsVelocityImpulse(vel)

			if(scope.rocketjumping == 1)
			{
				self.AddCondEx(Constants.ETFCond.TF_COND_BLASTJUMPING, 5, self)
			}
		}
		else
		{
			scope.bunnyhopping = 0
			scope.rocketjumping = 0
			self.RemoveCondEx(Constants.ETFCond.TF_COND_BLASTJUMPING, true)
		}
	}
	ClientPrint(self, 4, self.GetAbsVelocity().tostring())
	// DebugDrawClear()
	// DebugDrawBox(self.GetOrigin(), self.GetPlayerMins(), self.GetPlayerMaxs(), 0, 0, 255, 15, 1)
	return 0
}