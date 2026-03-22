IncludeScript("fatcat_library")

CreateThinker("MissionCountdown", function() {
	if ( IsWaveStarted() ) return

	local roundtime = GetPropFloat( Gamerules, "m_flRestartRoundTime" )

	if ( roundtime > Time() + value ) {

		local ready = GetPlayerReadyCount()
		if ( ready >= m_aHumans || ( roundtime <= 12.0 ) )
			SetPropFloat( Gamerules, "m_flRestartRoundTime", Time() + value )
	}
}, THINKER_PERSIST)

SetCvar( "tf_bot_escort_range", INT_MAX )
SetCvar( "tf_bot_flag_escort_range", INT_MAX )
SetCvar( "tf_bot_flag_escort_max_count", 0 )

SetCvar( "tf_mvm_buybacks_method", 1 )
SetCvar( "tf_mvm_buybacks_per_wave", 0 )

::EnemyClasses <-
[
	TF_CLASS_SCOUT,
	// TF_CLASS_SOLDIER,
	// TF_CLASS_SNIPER,
	// TF_CLASS_HEAVYWEAPONS,
]

::RobotModels <- [
	"models/bots/scout/bot_scout.mdl",
	"models/bots/scout/bot_scout.mdl",
	"models/bots/sniper/bot_sniper.mdl",
	"models/bots/soldier/bot_soldier.mdl",
	"models/bots/demo/bot_demo.mdl",
	"models/bots/medic/bot_medic.mdl",
	"models/bots/heavy/bot_heavy.mdl",
	"models/bots/pyro/bot_pyro.mdl",
	"models/bots/spy/bot_spy.mdl",
	"models/bots/engineer/bot_engineer.mdl",
]

function RobotModelToGiant(model)
{
	// local data = split(model, "/").slice(2)
	return "models/bots/"+split(model, "/")[2]+"_boss/"+split(split(model, "/")[3], ".mdl")[0]+"_boss.mdl"
}

function RemoveBot(miniboss = false)
{
	local count = GetPropInt(ObjResource, "m_nMannVsMachineWaveClassCounts")
	if (count == 0) 
		return
	count -= 1
	SetPropInt(ObjResource, "m_nMannVsMachineWaveClassCounts", botcount)
}

if("RougeliteEvents" in ROOT) delete ::RougeliteEvents
::RougeliteEvents <- {
	function OnScriptEvent_HumanResupply(params)
	{
		local player = params.player
		SpawnPlayer(player)
		if(player.GetPlayerClass() == TF_CLASS_ENGINEER)
			player.AddCustomAttribute("metal regen", 50, -1)

		local Melee = player.GetWeaponInSlotNew(SLOT_MELEE)
		if(Melee.GetIDX() == 589)
		{
			Melee.AddAttribute("alt fire teleport to spawn", 0, 0)
		} 
	}
	function OnScriptEvent_BotResupply(params)
	{
		local player = params.player
		SpawnBot(player)
	}
	function OnGameEvent_player_disconnect(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		if(params.bot)
			return
	}
	function OnGameEvent_mvm_begin_wave(params)
	{
		StartDaGame()
		SetPropInt( ObjectiveResource, "m_nMannVsMachineWaveCount", 1 )
		RunWithDelay(@() SetPropInt( ObjectiveResource, "m_nMannVsMachineWaveCount", 1 ), 0.015)

		SetPropInt( ObjectiveResource, "m_nMannVsMachineMaxWaveCount", 1 )
		RunWithDelay(@() SetPropInt( ObjectiveResource, "m_nMannVsMachineMaxWaveCount", 1 ), 0.015)
	}
	function OnScriptEvent_BotDeath(params)
	{
		local player = params.victim

		if(player.IsBot())
			RemoveBot(player.IsMiniBoss())
	}
	function OnGameEvent_teamplay_broadcast_audio(params)
	{
		local sound = params.sound

		if(!IsInArray(sound, ["music.mvm_end_last_wave", "Game.YourTeamWon", "Announcer.MVM_Get_To_Upgrade"]))
			return
		foreach(Human in m_aHumans)
			StopSoundOn( sound, Human )
	}
}
__CollectGameEventCallbacks(RougeliteEvents)


function SpawnPlayer(player)
{
	// do stuf
}

EnterArena <- function(self)
	{
		local lumberyard = false
		local ravine = false
		local byre = false
		local spawns = []
		local offset = Vector(0,0,-4)
		local isupgrading = GetPropBool(self,"m_Shared.tfsharedlocaldata.m_bInUpgradeZone")
		local InArena = self.GetScriptScope().hasenteredarena
		if (isupgrading) return

		self.GetScriptScope().PRESERVED.hasenteredarena = true
		if (arenanumber == 0) lumberyard = true
		if (arenanumber == 1) ravine = true
		if (arenanumber == 2) byre = true
		if (lumberyard == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "player_start_lumberyard");)
			{
				spawns.append(entity)
			}
		}
		if (ravine == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "player_start_ravine");)
			{
				spawns.append(entity)
			}
		}
		if (byre == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "player_start_byre");)
			{
				spawns.append(entity)
			}
		}
		if (spawns.len() == 0)
		{
			printl("----------------------------")
			printl("RED's Spawn array returned empty ... How're you supposed to fight now??")
			printl("----------------------------")
			return
		}
		local spawnlocation = spawns[RandomInt(0, spawns.len() - 1)]
		self.Teleport(true,spawnlocation.GetCenter()+offset,true,spawnlocation.GetAbsAngles(),true,spawnlocation.GetAbsVelocity());
		ScreenFade(self,255,255,255,255,1,0,1)
		ScreenShake(self.GetCenter(),16,144,2,48,0,true)
		EmitSoundEx({
			sound_name = "Halloween.TeleportVortex.BookExit",
			origin = self.GetCenter(),
			filter_type = Constants.EScriptRecipientFilter.RECIPIENT_FILTER_DEFAULT
		});
		if (!roundactive)
		{
			EntFireByHandle(Entities.FindByName(null, "notebook"),"Runscriptcode","SetupRound()",5,null,null);
			roundactive = true
		}
		if (roundactive) EntFireByHandle(self,"Runscriptcode","self.AddCondEx(51,5,self)",0.2,null,null);
	}

function TeleportToArena(player)
{

}

function SpawnBot(player)
{
	if(!player.IsAlive() || !player.IsValid())
		return
	if(player.HasBotTag("BombHolder"))
		return
	if(!player.HasBotAttribute(REMOVE_ON_DEATH))
		return

	player.AddBotAttribute(REMOVE_ON_DEATH)
	player.AddBotAttribute(DISABLE_DODGE) 
	local Class = EnemyClasses[RandomInt(0, EnemyClasses.len() - 1)]

	player.SetCond(TF_COND_FREEZE_INPUT, 10)

	player.ForceChangeClass(Class, true)

	UpdateModel(player)
	GetBotLoadout(player)
	MoveToSpawnLocation()

	/* 
	GetBotLoadout(self)
	difficulty = difficulty + 0.025
	if (difficulty > 10) difficulty = 10
	MoveToSpawnLocation(self)
	 */
}

function UpdateModel(bot)
{
	// local model = bot.IsMiniBoss() ? RobotModelToGiant(RobotModels[bot.GetPlayerClass()]) : RobotModels[bot.GetPlayerClass()]
	bot.SetCustomModelWithClassAnimations(bot.IsMiniBoss() ? RobotModelToGiant(RobotModels[bot.GetPlayerClass()]) : RobotModels[bot.GetPlayerClass()])
}

function StartDaGame()
{
	foreach (player in GetAllPlayers(TF_TEAM_RED))
	{
		GetScope(player).hasenteredarena <- false
	}
}


function GetBotLoadout(player)
{
	if (GetRoundState() != 4) return
	if (player.HasBotTag("BombHolder")) return
	player.ClearAllWeaponRestrictions()
	local botclass = player.GetPlayerClass()
	local randomizer = RandomInt(1,11)

	if(false)
	{
		// Giant Logic
	}

	if (botclass == TF_CLASS_SCOUT)
	{
		if (randomizer < 6)
		{
			player.AddWeaponRestriction(MELEE_ONLY)
			player.AddBotAttribute(AGGRESSIVE)
			SetFakeClientConVarValue(player, "name", "Scout");
			return
		}
		if (randomizer >= 6)
		{
			player.AddWeaponRestriction(SECONDARY_ONLY)
			player.AddBotAttribute(AGGRESSIVE)
			SetFakeClientConVarValue(player, "name", "Scout");
			return
		}
		throw "!! Scout spawned with no template !!"
		return
	}
}

function MoveToSpawnLocation(bot)
{
	if (GetRoundState() != 4) return
	local spawns = GetAllEntitiesByTargetname("BotSpawn")
	local offset = Vector(0,0,-4)
	if (spawns.len() == 0)
	{
		printl("----------------------------")
		printl("Bot Spawn array returned empty ... What is happening??")
		printl("----------------------------")
		return
	}
	local spawnlocation = spawns[RandomInt(0, spawns.len() - 1)]
	bot.Teleport(true,spawnlocation.GetCenter()+offset,true,spawnlocation.GetAbsAngles(),true,spawnlocation.GetAbsVelocity());
	bot.AddCondEx(5,2,null) // hold in place to apply the stuff
}

::GetNewArena <- function()
	{
		if (hasrolledforarena) return
		hasrolledforarena = true
		local diceroll = RandomInt(0,2)
		if (diceroll == arenanumber)
		{
			printl("wtf don't give the same arena")
			arenanumber += 1
			if (arenanumber > 2) arenanumber = 0
			if (arenanumber == 0) IncludeScript("saxtadium/stagescripts/lumberyard.nut");
			if (arenanumber == 1) IncludeScript("saxtadium/stagescripts/ravine.nut");
			if (arenanumber == 2) IncludeScript("saxtadium/stagescripts/byre.nut");
			EntFire("startdoors_closed", "Disable")
			EntFire("startdoors_open", "Enable")
			return
		}
		if (diceroll != arenanumber) arenanumber = diceroll
		if (arenanumber > 2) currentarena = 0
		
		if (arenanumber == 0) IncludeScript("saxtadium/stagescripts/lumberyard.nut");
		if (arenanumber == 1) IncludeScript("saxtadium/stagescripts/ravine.nut");
		if (arenanumber == 2) IncludeScript("saxtadium/stagescripts/byre.nut");
		EntFire("startdoors_closed", "Disable")
		EntFire("startdoors_open", "Enable")
	}
