IncludeScript("fatcat_library")

local thinker = CreateThinker("PowerupThinker", "PowerupThink")
AddThinkToEnt(thinker, "PowerupThink")

function PowerupThink( )
{
	foreach ( player in Players )
	{
		if ( player.IsDead() )
			continue
		UpdateKVs(GlobalGameText, format("Current Powerup: %s", "Powerup" in GetScope( player ) ? GetScope( player ).Powerup : "None"), "255 200 200", 0.02, 0.65)
		GlobalGameText.AcceptInput("Display", "" , player, player)

		if ( player.GetPowerupThink( ) )
		{
			// player.RunPowerupThink() // WHAT THE FUCK
		}
	}

	return 0.1
}

function CTFPlayer::InitalizePowerUps( )
{
	GetScope(this).Powerup <- "None"
	GetScope(this).PowerupThink <- null
	GetScope(this).PowerupFlags <- 0
}

function CTFPlayer::GetPowerup(  )
	return GetScope( this ).Powerup

function CTFPlayer::GetPowerupFlags(  )
	return GetScope( this ).PowerupFlags

function CTFPlayer::GetPowerupThink(  )
	return GetScope( this ).PowerupThink

function CTFPlayer::RunPowerupThink( )
	EntFireNew(this, "RunScriptCode", "self.GetPowerupThink()()")

function CTFPlayer::AddPowerup( powerup_name = "None" )
{ 
	// if ( powerup_name != "None" )
	Assert(powerup_name in PowerupConfigs, format("Attempted to add an unknown powerup type \"%s\"", powerup_name))
	EntFireNew(this, "RunScriptCode", "PowerupConfigs[self.GetPowerup()].Remove( self )")
	EntFireNew(this, "RunScriptCode", format("PowerupConfigs[\"%s\"].Add( self )", powerup_name))
}

::PowerupGameEvents <- {
	function OnGameEvent_HumanSpawn(params)
	{
		params.player.InitalizePowerUps()
	}
	function OnGameEvent_post_inventory_application(params)
	{
		GetPlayerFromUserID(params.userid).InitalizePowerUps()
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		local victim = params.const_entity
		local attacker = params.attacker

		// if ( !victim.IsPlayer( ) ) return
		if ( victim.IsPlayer( ) && victim.IsBot( ) ) return

		if ( attacker && attacker.IsPlayer() && attacker.IsAlive() && attacker != victim && attacker.GetPowerupFlags() & Flags_Powerups.FLAG_DAMAGE )
		{
			if ( params.damage_type & DMG_ACID )
				params.damage *= 1.25
			else 
				params.damage *= 2
		}
	}
}
__CollectGameEventCallbacks( PowerupGameEvents )

enum Flags_Powerups {
	FLAG_DAMAGE = 1
}

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
::PowerupConfigs <- {}
PowerupConfigs["None"] <- {
	function Add( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "None"
		scope.PowerupFlags = 0
		scope.PowerupThink <- null
	}
	// PowerupFlag = Flags_Powerups.FLAG_DAMAGE
	function Remove( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "None"
		scope.PowerupFlags = 0
		scope.PowerupThink <- null
	}
}

PowerupConfigs["Damage"] <- {
	function Add( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "Damage"
		scope.PowerupFlags = scope.PowerupFlags | Flags_Powerups.FLAG_DAMAGE
	}
	// PowerupFlag = Flags_Powerups.FLAG_DAMAGE
	function Remove( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "None"
		scope.PowerupFlags = scope.PowerupFlags & ~Flags_Powerups.FLAG_DAMAGE
	}
}

PowerupConfigs["Happy"] <- {
	function Add( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "Happy"
		scope.PowerupThink <- HappyThink
	}
	function Remove( player )
	{
		local scope = GetScope( player )
		scope.Powerup <- "None"
		scope.PowerupThink <- null
	}
}

function HappyThink()
{
	DebugDrawCircle(self.GetOrigin(), Vector(255,0,0), 50, 700, false, 0.1)
	// "self" is the player who thinks
	foreach ( player in GetAllPlayers( self.GetTeam( ), [ self.GetOrigin(), 700], true ) )
	{
		player.AddCustomAttribute("fire rate bonus HIDDEN", 0.75, 2.5)
		player.AddCustomAttribute("reload time increased hidden", 0.75, 2.5)
	}
}
