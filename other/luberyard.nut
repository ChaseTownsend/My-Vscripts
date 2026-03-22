///// START MAIN.NUT
if(true)
{
	// Welcome... TO LA ARENA!
	// Here's the stuff we're gonna load

	IncludeScript("popextensions_main.nut", getroottable());
	IncludeScript("saxtadium/hooks.nut",getroottable());
	IncludeScript("saxtadium/toolbox.nut");
	IncludeScript("saxtadium/roundlogic.nut");
	PrecacheScriptSound("Announcer.AM_LastManAlive01");
	PrecacheScriptSound("Announcer.AM_LastManAlive02");
	PrecacheScriptSound("Announcer.AM_LastManAlive03");
	PrecacheScriptSound("Announcer.AM_LastManAlive04");
	PrecacheScriptSound("ui/duel_challenge.wav");
	PrecacheScriptSound("ui/duel_event.wav");
	PrecacheScriptSound("mvm_arena/sexalarm.mp3");
	PrecacheScriptSound("passtime/horn_air1.wav");
	PrecacheScriptSound("misc/tf_crowd_walla_intro.wav");
	PrecacheScriptSound("vo/mvm_game_over_loss09.mp3")
	PrecacheScriptSound("vo/mvm_game_over_loss10.mp3")
	PrecacheScriptSound("vo/mvm_game_over_loss11.mp3")
	PrecacheScriptSound("ambient/explosions/explode_4.wav")
	PrecacheScriptSound("Announcer.MVM_Final_Wave_Start")
	PrecacheScriptSound("Announcer.MVM_Wave_End")
	PrecacheModel("models/weapons/c_models/c_big_mallet/c_big_mallet.mdl")
	PrecacheModel("models/props_frontline/mine_norock.mdl")
	// Precache things
	function Precache()
	{
		printl("Arena main scripts loaded.")
		if (MaxClients().tointeger() < 32) printl("Running below 32 players is not recommended!!")
	} 
}
///// END MAIN.NUT

///// START HOOKS.NUT
if(true)
{
	const RADIUS = 8;
	const DISP_RADIUS = 410;
	const DISP_COOLDOWN = 1;
	if ("SaxtadiumEvents" in getroottable()) delete ::SaxtadiumEvents // this is done to prevent hook stacking
	::SaxtadiumEvents <- 
	{
		function OnGameEvent_post_inventory_application(params)
		{
			local player = GetPlayerFromUserID(params.userid);
			if (player.GetTeam() == 2 && player.IsValid()) // set up the stuffs
			{
				local items = 
				{
					isupgrading = false
				}
				if ("PRESERVED" in player.GetScriptScope())
				{
					foreach (k, v in items)
					player.GetScriptScope().PRESERVED[k] <- v
				}
				PlayerSpawn(player);
				EntFireByHandle(player,"RunScriptCode","ApplyPlayerAttributes(self)",0.1,null,player);
			};
			if (player.GetTeam() == 3 && player.IsValid())
			{
				player.ValidateScriptScope();
				local scope = player.GetScriptScope();
		
				//stuff we want to put in player scope
				local items =
				{
					snipercooldown = 0
					chargecooldown = 0
				}
				foreach (k, v in items)
				player.GetScriptScope()[k] <- v
				EnemySpawn(player);
			}
		} 
		function OnGameEvent_player_changeclass(params)
		{
			local player = GetPlayerFromUserID(params.userid);
			if (player.GetTeam() == 2) EntFireByHandle(player,"RunScriptCode","ApplyPlayerAttributes(self)",0.1,null,player);
		}
		function OnGameEvent_mvm_begin_wave(params)
		{
			InitGameStart()
		}
		function OnGameEvent_player_builtobject(params)
		{
			local object = params.object
			local building = EntIndexToHScript(params.index)
			local builder = GetPlayerFromUserID(params.userid)
			if (object == 1) // teleporters
			{
				SpawnTemplate("Engineer_Landmine",null,building.GetOrigin(),building.GetAbsAngles())
				EmitSoundEx
				({
					sound_name = "Building_Teleporter.Build1",	// this also needs to be precached???
					origin = building.GetCenter(),
					filter_type = Constants.EScriptRecipientFilter.RECIPIENT_FILTER_DEFAULT
				});
				building.Destroy()	// don't allow teleporters
				
			}					
		}
		function OnScriptHook_OnTakeDamage (params)
		{
			local victim = params.const_entity
			local attacker = params.attacker
			local inflictor = params.inflictor
			local damage = params.damage
			local weapon = params.weapon
			
			if (attacker == null || weapon == null || attacker == victim) return
			if (attacker.GetBotType() != 1337) return
			if (attacker.GetDifficulty() > 1)
			{
				if ( attacker.GetPlayerClass() == TF_CLASS_SNIPER && attacker.GetActiveWeapon().GetSlot() == SLOT_PRIMARY && PopExtUtil.GetItemIndex( attacker.GetActiveWeapon() ) != ID_SYDNEY_SLEEPER )
				{
					if ( GetPropInt( victim, "m_LastHitGroup" ) == HITGROUP_HEAD || ( params.damage_stats == TF_DMG_CUSTOM_HEADSHOT && !( params.damage_type & DMG_CRITICAL ) ) )
					{
						params.damage_type = params.damage_type | DMG_CRITICAL //DMG_USE_HITLOCATIONS doesn't actually work here, no headshot icon.
						params.damage_stats = TF_DMG_CUSTOM_HEADSHOT
					}
				}
			}
		}
		function OnGameEvent_player_death(params)
		{
			local deadguy = GetPlayerFromUserID(params.userid)
			local damagebits = params.damagebits
			local attacker = GetPlayerFromUserID(params.attacker)
			// local assister = GetPlayerFromUserID(params.assister)	// unused, everyone gets the same money now
			local botcount = NetProps.GetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts")
			local playerclass = deadguy.GetPlayerClass()
			local multiplier = 1
			if (deadguy.GetTeam() == 3)
			{
				if (deadguy.IsMiniBoss()) ExitStageLeft(true)
				if (!deadguy.IsMiniBoss()) ExitStageLeft(false)
				local payout = 0
				for (local wearable = deadguy.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
				{
					if (wearable.GetClassname() != "tf_wearable")
					continue
					SetPropInt(wearable,"m_nRenderMode",10)
				}
				// kill money
				if (attacker == null) return
				if (attacker.GetTeam() == 2)
				{
					local currency = GetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats.nCreditsAcquired")
					payout = 20
					if (damagebits & DMG_CLUB) // melee
					{
						payout = 50
					}
					if (!deadguy.IsMiniBoss()) multiplier = 1
					if (deadguy.IsMiniBoss()) multiplier = 2
					foreach (player in PopExtUtil.HumanArray)
					{
						player.AddCurrency(payout * multiplier) // assist money
					}
					currency = currency + (payout * multiplier)
					gamemoney = gamemoney + (payout * multiplier)
					SetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats.nCreditsAcquired",currency)
					SetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats",currency)
				}
			}
			if (deadguy.GetTeam() == 2)
			{
				deadguy.SetScriptOverlayMaterial("")
				if (GetRoundState() == 4)
				{
					isperfectround = false
					deadguy.GetScriptScope().PRESERVED.lives -= 1
					if ("lives" in deadguy.GetScriptScope().PRESERVED && deadguy.GetScriptScope().PRESERVED.lives < -1) deadguy.GetScriptScope().PRESERVED.lives = -1
					difficulty -= 0.4
					if (difficulty < 0) difficulty = 0
				}
			//	if (PopExtUtil.CountAlivePlayers() == 1) LastManWarning()
				EntFireByHandle(Entities.FindByName(null, "bots_win"),"runscriptcode","DoGameOverCheck()",2,null,null);
				EntFireByHandle(deadguy,"runscriptcode","for (local entity; entity = Entities.FindByClassname(entity, `entity_revive_marker`);){SetPropBool(entity,`m_bGlowEnabled`,true)}",0.5,null,deadguy);
			}
		}
		function OnScriptHook_OnTakeDamage(params)
		{
			local inflictor = params.inflictor
			local victim = params.const_entity
			local damage = params.damage
			if (inflictor.GetClassname() == "tf_generic_bomb" && victim.GetClassname() == "player" && damage > victim.GetHealth() && victim.GetTeam() == 3)
			{
				local payout = 20
				local multiplier = 1
				local currency = GetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats.nCreditsAcquired")
				if (!victim.IsMiniBoss()) multiplier = 1
				if (victim.IsMiniBoss()) multiplier = 2
				foreach (player in PopExtUtil.HumanArray)
				{
					player.AddCurrency(payout * multiplier) // assist money
				}
				currency = currency + (payout * multiplier)
				gamemoney = gamemoney + (payout * multiplier)
				SetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats.nCreditsAcquired",currency)
				SetPropInt(FindByClassname(null, "tf_mann_vs_machine_stats"),"m_currentWaveStats",currency)
			}
		}
		function OnGameEvent_player_disconnect(params)
		{
			local quitter = GetPlayerFromUserID(params.userid)
			if (quitter == null) return
			if (quitter.GetTeam() == 2)	// no no, no no no no
			{
				EntFireByHandle(Entities.FindByName(null, "bots_win"),"runscriptcode","DoGameOverCheck()",2,null,null);	// try to check if the last guy just quits the server
			}
		}
		function OnGameEvent_teamplay_round_win(params)
		{
			if (params.team == 3) SendGlobalGameEvent("tf_game_over", {})
		}
	}

	__CollectGameEventCallbacks(SaxtadiumEvents)
}
///// END HOOKS.NUT

///// START TOOLBOX.NUT
if(true)
{
	::REMOVE_ON_DEATH <- Constants.FTFBotAttributeType.REMOVE_ON_DEATH
	::DISABLE_DODGE <- Constants.FTFBotAttributeType.DISABLE_DODGE
	local notebook = Entities.FindByName(null, "notebook")
	local respawn_override = Entities.FindByName(null, "respawn_override")
	local checkpoint_relay = Entities.FindByName(null, "checkpoint_relay")
	local checkpoint_relay_boss = Entities.FindByName(null, "checkpoint_relay_boss")
	local navman = FindByName(null, "navman")
	local text_screen_1 = FindByName(null, "text_screen_1")
	local text_screen_2 = FindByName(null, "text_screen_2")
	local arenanumber = -1	// what's our current arena
	local startmoney = 1500
	::gamemoney <- 0
	local hasrolledforarena = false	// don't roll multiple times!!
	::difficulty <- 0		// what's our current difficulty level, determines types of bots
	local recordeddifficulty = 0	// recorded difficulty level, used to update hud
	::roundactive <- false
	::isperfectround <- true		// set to false if RED dies during rounds
	local roundscleared = 0		// how many rounds we cleared on an arena
	local perfectcleared = 0	// how many rounds we cleared without dying
	:: arenascleared <- 0		// how many arenas we've cleared, used for boss health calculation
	const MAX_WEAPONS = 8		// for bot loadout stuff

	if (navman == null)
	{
		navman = SpawnEntityFromTable("tf_point_nav_interface",
		{
			targetname = "navman"
		})
	}
	if (text_screen_1 == null)
		{
			text_screen_1 = SpawnEntityFromTable("game_text",
			{
				targetname = "text_screen_1"
				channel = 1
				color = "255 255 255"
			//	spawnflags = 1
				fadein = 0
				fadeout = 0.2
				holdtime = 1
				message = ""
				x = 0.5
				y = 0.77
			})
			text_screen_2 = SpawnEntityFromTable("game_text",
			{
				targetname = "text_screen_2"
				channel = 1
				color = "255 255 255"
			//	spawnflags = 1
				fadein = 0
				fadeout = 0.2
				holdtime = 1
				message = ""
				x = 0.5
				y = 0.77
			})
		}

	::ModelTable <-
	[
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
	::ModelTable_Boss <-
	[
		"models/bots/scout/bot_scout.mdl",
		"models/bots/scout_boss/bot_scout_boss.mdl",
		"models/bots/sniper_boss/bot_sniper_boss.mdl",
		"models/bots/soldier_boss/bot_soldier_boss.mdl",
		"models/bots/demo_boss/bot_demo_boss.mdl",
		"models/bots/medic_boss/bot_medic_boss.mdl",
		"models/bots/heavy_boss/bot_heavy_boss.mdl",
		"models/bots/pyro_boss/bot_pyro_boss.mdl",
		"models/bots/spy_boss/bot_spy_boss.mdl",
		"models/bots/engineer_boss/bot_engineer_boss.mdl",
	]
	::ArenaTable <-		// not used yet, may replace current arena picker so we can guarantee getting a new arena later
	[
		"Lumberyard",
		"Ravine",
		"Byre",
	]

	// our secret variable stash
	// tfbot weapon restriction types, here for ease of reading
	:: MELEE_ONLY <- 1	
	:: SECONDARY_ONLY <- 4
	////////////////////////////

	::UpdateBotModel <- function(self)	// used to update bot model after class change roulette
	{
		local model = ModelTable[self.GetPlayerClass()]	
		self.SetCustomModelWithClassAnimations(model)
		if (self.IsMiniBoss()) self.SetCustomModelWithClassAnimations(ModelTable_Boss[self.GetPlayerClass()])
	}
	::RoundEnd <- function(activator)
	{
		PopExtUtil.AddThinkToEnt(activator, "RoundEnd_Think")
		for (local node; node = Entities.FindByClassname(node, "point_commentary_node");)
		{
			if (node.IsValid()) node.Destroy()
		}
	}
	::ClearArenaScripts <- function() {}	// obsolete
	::EnemySpawn <- function(self) {}		// error blocker if enemyspawn happens before stagescript loads
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
	::RoundClearCheck <- function()
	{
		local diceroll = RandomInt(0,2)
		if (isbosswave)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				PopExtUtil.PlaySoundOnClient(player,"passtime/horn_air1.wav",0.6,100)
				if (!player.IsAlive()) player.ForceRespawn()
				player.GetScriptScope().PRESERVED.lives = 3
				UpdatePlayerHUD(player,"lives")
			}
			EntFireByHandle(Entities.FindByName(null, "bot_spawner_boss"),"Kill","",0,null,null);
			ArenaClear()
			isperfectround = true
			hasrolledforarena = false
			return
		}
		local flawlesslines =
		[
			"Announcer.AM_FlawlessVictory01",
			"Announcer.AM_FlawlessVictory02",
			"Announcer.AM_FlawlessVictory03",
		]
		if (!isperfectround)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.GetTeam() == 2)
				{
					ClientPrint(player, HUD_PRINTCENTER, "Wave Cleared! Next round begins in 20 seconds!");
					PopExtUtil.PlaySoundOnClient(player,"Announcer.MVM_Wave_End",1.0,100)
					if (arenascleared <= 1)
					{
						player.GetScriptScope().PRESERVED.lives += 1
						if (player.GetScriptScope().PRESERVED.lives > 3) player.GetScriptScope().PRESERVED.lives = 3
					}
					if (player.IsAlive()) UpdatePlayerHUD(player,"lives")
					if (!player.IsAlive()) player.ForceRespawn()
				}
			}
			roundscleared += 1
			RunArenaSpecificEvents()
			isperfectround = true
			EntFireByHandle(Entities.FindByName(null, "round_clear"),"Trigger","",0,null,null);
			EntFireByHandle(Entities.FindByName(null, "round_start"),"Trigger","",20,null,null);
			EntFireByHandle(Entities.FindByName(null, "notebook"),"Runscriptcode","SetupRound()",20,null,null);
			return
		}
		if (isperfectround)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.GetTeam() == 2)
				{
					player.AddCurrency(100)
					PopExtUtil.PlaySoundOnClient(player,flawlesslines[diceroll],1.0,100)
					ClientPrint(player, HUD_PRINTCENTER, "Flawless Victory: $100 bonus!");
					if (arenascleared <= 1)
					{
						player.GetScriptScope().PRESERVED.lives += 1
						if (player.GetScriptScope().PRESERVED.lives > 3) player.GetScriptScope().PRESERVED.lives = 3
					}
					if (player.IsAlive()) UpdatePlayerHUD(player,"lives")
					if (!player.IsAlive()) player.ForceRespawn()
				}
			}
			perfectcleared += 1
			roundscleared += 1
			difficulty += 0.5
			RunArenaSpecificEvents()
			isperfectround = true
			EntFireByHandle(Entities.FindByName(null, "round_clear"),"Trigger","",0,null,null);
			EntFireByHandle(Entities.FindByName(null, "round_start"),"Trigger","",20,null,null);
			EntFireByHandle(Entities.FindByName(null, "notebook"),"Runscriptcode","SetupRound()",20,null,null);
			return
		}
	}
	::ArenaClear <- function()
	{
		if (roundscleared != perfectcleared)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				ClientPrint(player, HUD_PRINTCENTER, "Arena Clear: $200 Bonus and return to lobby!");
				player.AddCurrency(200)
				EntFireByHandle(player,"Runscriptcode","ApplyTeleportEffects(self)",3.5,null,null);
				EntFireByHandle(player,"Runscriptcode","ReturnToLobby(self)",5,null,null);
			}
			roundscleared = 0
			perfectcleared = 0
			arenascleared += 1
			roundactive = false
			EntFire("startdoors_closed", "Enable")
			EntFire("startdoors_open", "Disable")
			return
		}
		if (roundscleared == perfectcleared)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.GetTeam() == 2)
				{
					player.AddCurrency(500)
					PopExtUtil.PlaySoundOnClient(player,"misc/tf_crowd_walla_intro.wav",0.6,100)
					ClientPrint(player, HUD_PRINTCENTER, "Perfect Clear! $500 Bonus and return to lobby!");
					EntFireByHandle(player,"Runscriptcode","ApplyTeleportEffects(self)",3.5,null,null);
					EntFireByHandle(player,"Runscriptcode","ReturnToLobby(self)",5,null,null);
				}
			}
			roundscleared = 0
			perfectcleared = 0
			arenascleared += 1
			roundactive = false
			EntFire("startdoors_closed", "Enable")
			EntFire("startdoors_open", "Disable")
			return
		}
	}
	::DoGameOverCheck <- function()	// how to end the game
	{
		local gameoverlines =
		[
			"vo/mvm_game_over_loss09.mp3",
			"vo/mvm_game_over_loss10.mp3",
			"vo/mvm_game_over_loss11.mp3",
		]
		local diceroll = RandomInt(0,2)
		if (GetRoundState() != 4) return	// NOT YET
		if (PopExtUtil.CountAlivePlayers() == 0)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				local lives = player.GetScriptScope().PRESERVED.lives
				if (player.GetTeam() == 2 && !player.IsAlive() && lives < 0)
				{
					PopExtUtil.PlaySoundOnClient(player,gameoverlines[diceroll],1.0,100)
					EntFireByHandle(Entities.FindByName(null, "bots_win"),"roundwin","",1.5,null,null);
					ClientPrint(player, HUD_PRINTCENTER, "GAME OVER: Out of lives!");
				}
			}
		}
	}
	::RunArenaSpecificEvents <- function()	// check difficulty level and do things
	{
		if (difficulty < 2) return
		if (arenanumber == 0)	// currently only does something for Lumberyard
		{
			if (difficulty > 2 && difficulty < 6)
			{
				EntFireByHandle(Entities.FindByName(null, "door_middle1_1"),"Open","",0,null,null);
				EntFireByHandle(Entities.FindByName(null, "navman"),"RecomputeBlockers","",0.2,null,null);
			}
			if (difficulty > 6)
			{
				EntFireByHandle(Entities.FindByName(null, "door_middle1_1"),"Open","",0,null,null);
				EntFireByHandle(Entities.FindByName(null, "door_middle1_2"),"Open","",0,null,null);
				EntFireByHandle(Entities.FindByName(null, "navman"),"RecomputeBlockers","",0.2,null,null);
			}
		}
	}
	::MoveToSpawnLocation <- function(self)
	{
		if (GetRoundState() != 4) return
		if (self.GetPlayerClass() == "TF_CLASS_SCOUT") return
		local lumberyard = false
		local ravine = false
		local byre = false
		local spawns = []
		local offset = Vector(0,0,-4)
		if (arenanumber == 0) lumberyard = true
		if (arenanumber == 1) ravine = true
		if (arenanumber == 2) byre = true

		if (lumberyard == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "bot_spawn_lumberyard");)
			{
				spawns.append(entity)
			}
		}
		if (ravine == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "bot_spawn_ravine");)
			{
				spawns.append(entity)
			}
		}
		if (byre == true)
		{
			for (local entity; entity = Entities.FindByName(entity, "bot_spawn_byre");)
			{
				spawns.append(entity)
			}
		}
		if (spawns.len() == 0)
		{
			printl("----------------------------")
			printl("Bot Spawn array returned empty ... What is happening??")
			printl("----------------------------")
			return
		}
		local spawnlocation = spawns[RandomInt(0, spawns.len() - 1)]
		self.Teleport(true,spawnlocation.GetCenter()+offset,true,spawnlocation.GetAbsAngles(),true,spawnlocation.GetAbsVelocity());
		self.AddCondEx(5,2,null) // hold in place to apply the stuff
	}
	::UnstuckEntity <- function(entity)
	{
		if (!entity.IsAlive()) return
		::MASK_PLAYERSOLID <- 33636363
		local origin = entity.GetOrigin();
		local trace = 	{
		start = origin,
		end = origin,
		hullmin = entity.GetBoundingMins(),
		hullmax = entity.GetBoundingMaxs(),
		mask = MASK_PLAYERSOLID,
		ignore = entity
						}
		TraceHull(trace);
		if ("startsolid" in trace)
		{
		local dirs = [Vector(1, 0, 0), Vector(-1, 0, 0), Vector(0, 1, 0), Vector(0, -1, 0), Vector(0, 0, 1), Vector(0, 0, -1)];
		for (local i = 16; i <= 96; i += 16)
		{
			foreach (dir in dirs)
			{
				trace.start = origin + dir * i;
				trace.end = trace.start;
				delete trace.startsolid;
				TraceHull(trace);
				if (!("startsolid" in trace))
				{
					entity.SetAbsOrigin(trace.end);
					return true;
				}
			}
		}
		return false;
		}
		return true;
	}
	::ClearBots <- function() // begone, bot
	{
		local generator = SpawnEntityFromTable("tf_logic_training_mode",
		{
			targetname = "bot_wiper"
		})
		EntFireByHandle(Entities.FindByName(null, "bot_wiper"),"KickBots","",0,null,null);
		EntFireByHandle(Entities.FindByName(null, "bot_wiper"),"Kill","",0,null,null);
	}

	::ClearSniperMissions <- function() // || or
	{
		foreach (bot in PopExtUtil.BotArray)
		{
			if (bot.HasMission(MISSION_SNIPER))
			{
				bot.AddWeaponRestriction(MELEE_ONLY)
				bot.AddBotAttribute(AGGRESSIVE)
				bot.SetMission(NO_MISSION,true)
				bot.AcceptInput("speakresponseconcept", "TLK_PLAYER_BATTLECRY", self, self);
			}
			if (bot.HasMission(MISSION_ENGINEER) || bot.GetPlayerClass() == TF_CLASS_ENGINEER)
			{
				bot.AddBotAttribute(AGGRESSIVE)
				bot.SetMission(NO_MISSION,true)
				GetRandomTarget(bot)
				bot.AcceptInput("speakresponseconcept", "TLK_PLAYER_BATTLECRY", self, self);
			}
		}
	}

	::RoundEnd_Think <- function()
	{
		if (PopExtUtil.CountAlivePlayers(true) == 1)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				PopExtUtil.PlaySoundOnClient(player,"passtime/horn_air1.wav",1.0,100)
			}
			RoundClearCheck()
			EntFireByHandle(Entities.FindByName(null, "bot_spawner"),"Kill","",0,null,null);
		}
	}
	::InitGameStart <- function()
	{
		if (GetRoundState() != 4)	return
		local threshold = 2
		foreach (player in PopExtUtil.HumanArray)
		{
			if (player.GetCurrency() == 0)	
			threshold -= 1
			if (threshold == 0)
			{
				startmoney = startmoney - 500
				threshold = 2
			}
			if (startmoney < 500) startmoney = 500
			local items = 
			{							 
				lives = 3
				isupgrading = false
				hasenteredarena = false
				gotstartmoney = false
			}
			if ("PRESERVED" in player.GetScriptScope())
			{
				foreach (k, v in items)
				player.GetScriptScope().PRESERVED[k] <- v
			}
			UpdatePlayerHUD(player,"lives")
			EntFireByHandle(Entities.FindByName(null, "respawn_override_default"), "StartTouch", "", -1, player, player)
		}
		foreach (player in PopExtUtil.HumanArray)	// our second one to give start money
		{
			if (player.GetScriptScope().PRESERVED.gotstartmoney != true)	// check here to make sure we don't setcurrency on people who already started
			{
				player.SetCurrency(startmoney)
				player.GetScriptScope().PRESERVED.gotstartmoney = true
			}
		}
	}
	::LateStartCheck <- function(self)
	{
		if (GetRoundState() != 4)	return	// don't run this yet
		if ("gotstartmoney" in self.GetScriptScope().PRESERVED)
		{
			printl("player already got start money")
			return
		}
		if (GetRoundState() == 4)
		{
			local items = 
			{							 
				lives = 3
				isupgrading = false
				hasenteredarena = false
				gotstartmoney = false
			}
			if ("PRESERVED" in self.GetScriptScope())
			{
				foreach (k, v in items)
				self.GetScriptScope().PRESERVED[k] <- v
			}
			self.SetCurrency(startmoney+gamemoney)
			self.GetScriptScope().PRESERVED.gotstartmoney = true
		}
	}
	::PlayerSpawn <- function(self)
	{
		UpdatePlayerCurrency(self)
		NetProps.SetPropBool(self,"m_bGlowEnabled",true)
		UpdatePlayerHUD(self,"lives")
		if (!"gotstartmoney" in self.GetScriptScope().PRESERVED) LateStartCheck(self)
		if (roundactive) EnterArena(self)
	}
	::UpdatePlayerHUD <- function(user, hudtype)
	{
		if (GetRoundState() != 4) 
		{
			user.SetScriptOverlayMaterial("")
			return
		}
		local scope = user.GetScriptScope().PRESERVED
		if (hudtype == "lives")
		{
			local lifecounter = scope.lives
			if (lifecounter < 0) lifecounter = 0
			if (lifecounter > 3) lifecounter = 3
			local lifetrackers =
			[
				"saxtadium/hud_lifetracker_0",
				"saxtadium/hud_lifetracker_1",
				"saxtadium/hud_lifetracker_2",
				"saxtadium/hud_lifetracker_3",
			]
			user.SetScriptOverlayMaterial(lifetrackers[lifecounter])
			if (lifecounter > 0 ) EntFireByHandle(Entities.FindByName(null, "respawn_override_nolives"), "EndTouch", "", -1, user, user)
			if (lifecounter == 0) EntFireByHandle(Entities.FindByName(null, "respawn_override_nolives"), "StartTouch", "", -1, user, user)
		}
	}
	::UpdatePowerupDurations <- function(self)		// UNUSED from Red Ridge, left here in case I want to use it later
	{
		local scope = self.GetScriptScope().PRESERVED
		local deathmachinetext = ""
		local instakilltext = ""
		local doublepointstext = ""
		local text_powerup = FindByName(null, "__text_powerup")
		
		doublepointstext = format("Double Points: %i", scope.doublepointstime - Time())
		instakilltext = format("Instakill: %i", scope.instakilltime - Time())
		deathmachinetext = format("Death Machine: %i", scope.miniguntime - Time())
		if ((scope.doublepointstime - Time()) <= 0) doublepointstext = ""
		if ((scope.instakilltime - Time()) <= 0) instakilltext = ""
		if ((scope.miniguntime - Time()) <= 0) deathmachinetext = ""
		if (text_powerup == null)
		{
			text_powerup = SpawnEntityFromTable("game_text",
			{
				targetname = "__text_powerup"
				channel = 1
				color = "255 255 255"
			//	spawnflags = 1
				fadein = 0
				fadeout = 0.2
				holdtime = 1
				message = ""	// leave blank in case spawnflags makes this display for everyone??
				x = 0.5
				y = 0.77
			})
		}
		NetProps.SetPropString(text_powerup, "m_iszMessage", format("%s \n %s \n %s", doublepointstext, instakilltext, deathmachinetext))
		text_powerup.AcceptInput("Display","",self,null)
		
		if (scope.instakilltime > Time() || scope.doublepointstime > Time() || scope.miniguntime > Time()) EntFireByHandle(self,"runscriptcode","UpdatePowerupDurations(self)",1,null,self);
	}

	::UpdatePlayerCurrency <- function(self)
	{
		local currency = self.GetCurrency()
		local PlayerManager = Entities.FindByClassname(null, "tf_player_manager")
		SetPropIntArray(PlayerManager,"m_iCurrencyCollected",currency,self.entindex())
	}

	::ApplyTeleportEffects <- function(self)
	{
		ScreenFade(self,255,255,255,255,1.5,0,2)
		ScreenShake(self.GetCenter(),8,128,3,48,0,true)
		self.AddCondEx(51,3,null)
		EmitSoundEx
		({
			sound_name = "Halloween.TeleportVortex.BookSpawn",
			origin = self.GetCenter(),
			filter_type = Constants.EScriptRecipientFilter.RECIPIENT_FILTER_DEFAULT
		});
	}

	::EnterArena <- function(self)
	{
		local lumberyard = false
		local ravine = false
		local byre = false
		local spawns = []
		local offset = Vector(0,0,-4)
		local scope = self.GetScriptScope().PRESERVED
		local isupgrading = GetPropBool(self,"m_Shared.tfsharedlocaldata.m_bInUpgradeZone")
		local isonarena = self.GetScriptScope().PRESERVED.hasenteredarena
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
	::ReturnToLobby <- function(self)
	{
		ClearEngineerBuildings()
		local spawnlocation = Entities.FindByName(null, "red_start")
		local offset = Vector(0,0,-4)
		self.Teleport(true,spawnlocation.GetCenter()+offset,true,spawnlocation.GetAbsAngles(),true,spawnlocation.GetAbsVelocity());
		ScreenFade(self,255,255,255,255,1,0,1)
		ScreenShake(self.GetCenter(),16,144,2,48,0,true)
		self.GetScriptScope().PRESERVED.hasenteredarena = false
		EmitSoundEx
		({
			sound_name = "Halloween.TeleportVortex.BookExit",
			origin = self.GetCenter(),
			filter_type = Constants.EScriptRecipientFilter.RECIPIENT_FILTER_DEFAULT
		});
		EntFireByHandle(Entities.FindByName(null, "notebook"),"Runscriptcode","GetNewArena()",5,null,null);
	//	if (!player.IsAlive()) player.ForceRespawn()
	}
	::IsInFieldOfView <- function (user, target)
	{
		local tolerance = 0.5736 // cos(110/2)
		local eyefwd = user.EyeAngles().Forward()
		local eyepos = user.EyePosition()
		local delta = target.GetOrigin() - eyepos
		delta.Norm()
		if (eyefwd.Dot(delta) >= tolerance)
		return true

		delta = target.GetCenter() - eyepos
		delta.Norm()
		if (eyefwd.Dot(delta) >= tolerance)
		return true

		delta = target.EyePosition() - eyepos
		delta.Norm()
		return (eyefwd.Dot(delta) >= tolerance)
	}
	::IsVisible <- function (user, target)
	{
		local trace =
		{
			start  = user.EyePosition(),
			end    = target.EyePosition(),
			mask   = MASK_OPAQUE,
			ignore = user
		}
		TraceLineEx(trace)
		return !trace.hit
	}
	::IsThreatVisible <- function (user, target)
	{
		return IsInFieldOfView(user, target) && IsVisible(user, target)
	}

	::LastManWarning <- function()
	{
		if (PopExtUtil.CountAlivePlayers() == 1) return
		local diceroll = RandomInt(0,3)
		local warninglines =
		[
			"Announcer.AM_LastManAlive01",
			"Announcer.AM_LastManAlive02",
			"Announcer.AM_LastManAlive03",
			"Announcer.AM_LastManAlive04",
		]
		foreach (player in PopExtUtil.HumanArray)
		{
			if (player.IsAlive() && player.GetTeam() == 2)
			{
				PopExtUtil.PlaySoundOnClient(player,warninglines[diceroll],1.0,100)
				ClientPrint(player, HUD_PRINTCENTER, "You are the last one standing...");
			}
		}
	}

	::ApplyPlayerAttributes <- function(self)
	{
		local playerclass = self.GetPlayerClass()
		if (playerclass == TF_CLASS_SCOUT) EntFireByHandle(Entities.FindByName(null, "respawn_override_default"), "StartTouch", "", -1, self, self)	// override scout's respawn?
		if (playerclass == TF_CLASS_ENGINEER) self.AddCustomAttribute("metal regen" ,50, -1);
		self.SetHealth(self.GetMaxHealth())
	}

	::ClearEngineerBuildings <- function()
	{
		for (local sentry; sentry = Entities.FindByClassname(sentry, "obj_sentrygun");)
		{
			if (sentry.IsValid()) sentry.Destroy()
		}
		for (local dispenser; dispenser = Entities.FindByClassname(dispenser, "obj_dispenser");)
		{
			if (dispenser.IsValid()) dispenser.Destroy()
		}
		for (local mine; mine = Entities.FindByName(mine, "mine*");)
		{
			if (mine.IsValid()) mine.Destroy()
		}
	}
	// bot specific stuff
	::ChargeThink <- function()
	{
		self.ValidateScriptScope()
		local scope = self.GetScriptScope()
		
		if (scope.chargecooldown < Time())
		{
			self.AddCondEx(17,3,self)
			scope.chargecooldown = Time() + 10
		}
	}

	::GivePlayerWeapon <- function(player, classname, item_id)
	{
		if (classname == "tf_wearable" || classname == "tf_wearable_demoshield")
		{
			printl("--------------------")
			printl("!! You're trying to give a wearable weapon to bots, this doesn't work !!")
			printl("--------------------")
			return
		}
		local weapon = Entities.CreateByClassname(classname)
		NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", item_id)
		NetProps.SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
		NetProps.SetPropBool(weapon, "m_bValidatedAttachedEntity", true)
		weapon.SetTeam(player.GetTeam())
		weapon.DispatchSpawn()

		// remove existing weapon in same slot
		for (local i = 0; i < MAX_WEAPONS; i++)
		{
			local held_weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", i)
			if (held_weapon == null)
				continue
			if (held_weapon.GetSlot() != weapon.GetSlot())
				continue
			held_weapon.Destroy()
			NetProps.SetPropEntityArray(player, "m_hMyWeapons", null, i)
			break
		}

		player.Weapon_Equip(weapon)
		player.Weapon_Switch(weapon)

		return weapon
	}
	::GivePlayerCosmetic <- function(player, item_id, model_path = null)
	{
		local weapon = Entities.CreateByClassname("tf_weapon_parachute")
		NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", 1101)
		NetProps.SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
		weapon.SetTeam(player.GetTeam())
		weapon.DispatchSpawn()
		player.Weapon_Equip(weapon)
		local wearable = NetProps.GetPropEntity(weapon, "m_hExtraWearable")
		weapon.Kill()

		NetProps.SetPropInt(wearable, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", item_id)
		NetProps.SetPropBool(wearable, "m_AttributeManager.m_Item.m_bInitialized", true)
		NetProps.SetPropBool(wearable, "m_bValidatedAttachedEntity", true)
		wearable.DispatchSpawn()

		// (optional) Set the model to something new. (Obeys econ's ragdoll physics when ragdolling as well)
		if (model_path)
			wearable.SetModelSimple(model_path)

		// (optional) if one wants to delete the item entity, collect them within the player's scope, then send Kill() to the entities within the scope.
		player.ValidateScriptScope()
		local player_scope = player.GetScriptScope()
		if (!("wearables" in player_scope))
			player_scope.wearables <- []
		player_scope.wearables.append(wearable)

		return wearable
	}
	::CalloutGiant <-function(issentrybuster)
	{
		if (issentrybuster)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.IsAlive())
				{
					player.AcceptInput("speakresponseconcept", "TLK_MVM_SENTRY_BUSTER", self, self);
				}
			}
		}
		if (!issentrybuster)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.IsAlive())
				{
					player.AcceptInput("speakresponseconcept", "TLK_MVM_GIANT_CALLOUT", self, self);
				}
			}
		}
	}
	::GetRandomTarget <- function(user)	// for buster missions: run to random player and explode on them
	{
		local targets = []
		foreach (player in PopExtUtil.HumanArray)
		{
			if (player.GetTeam() == 2 && player.IsAlive())
			{
				targets.append(player)
			}
		}
		if (targets.len() == 0)
		{
			printl("----------------------------")
			printl("Target Array is empty... Is everyone dead??")
			printl("----------------------------")
			return
		}
		local randompick = targets[RandomInt(0, targets.len() - 1)]
		user.SetActionPoint(randompick)
		user.SetMissionTarget(randompick)
	}
	::ShowMessageToPlayers <- function(text)
	{
		foreach (player in PopExtUtil.HumanArray)
		{
			ClientPrint(self, HUD_PRINTCENTER, text)
		}
	}
	::GetBossHealth <- function(user,value)	// apply bonus health to bosses, based on player count and cleared arenas
	{
		local player_count = 0
		local health_per_player = 2000
		local health_per_arena = 2500
		foreach (player in PopExtUtil.HumanArray)
		{
			if (player.IsValid()) player_count++
		}
		local healthbonus = (player_count * health_per_player) + (arenascleared * health_per_arena)
		user.SetHealth(value + healthbonus)
		user.AddCustomAttribute("max health additive bonus" ,value + healthbonus, -1);
		if (!isbossonly)
		{
			foreach (player in PopExtUtil.HumanArray)
			{
				PopExtUtil.PlaySoundOnClient(player,"mvm_arena/sexalarm.mp3",0.6,100)
				ClientPrint(player, HUD_PRINTCENTER, "A Boss Robot has entered the arena!")
			}
		//	NetProps.SetPropString(text_screen_1, "m_iszMessage", format("%s \n %s \n %s", doublepointstext, instakilltext, deathmachinetext))
		//	NetProps.SetPropString(text_screen_1, "m_iszMessage", "A Boss Robot has entered the arena!"))
		//	text_screen_1.AcceptInput("Display","",self,null)
		}
	}
}
///// END TOOLBOX.NUT

///// START ROUNDLOGIC.NUT
if(true)
{
	player_count <- 0;                        	// how many players we have
	players_counted <- 0;                        // how many players we counted last time
	zombie_count <- 13;                       	// how many zombies do we have to spawn
	special_count <- 0;							// for boss rounds
	round_number <- 0;
	max_active <- 15										// gets +1 per wave until hits the bot cap
	bot_cap <- Convars.GetInt("tf_mvm_max_invaders")	// bot cap via existing Convar
	::boss_timer <- 0								// how many waves to boss
	//boss_multiplier <- 0						//	how many times has boss round come around
	spawn_interval <- 1.5; 					// starting value, gap between spawns

	::SetupRound <- function()
	{
		IncrementWaveNumber();
		GetPlayerCount();
		
		foreach (player in PopExtUtil.HumanArray)
		{
			local isonarena = player.GetScriptScope().PRESERVED.hasenteredarena
			if (!player.GetScriptScope().PRESERVED.hasenteredarena)
			{
				EnterArena(player)
			}
		}
		
		if (boss_timer > 0)
		{
			SpawnEntityFromTable("point_commentary_node", {origin = "-1266 -142 -2315"})
			if (round_number == 1)
			{
				local player_multiplier = 3 + player_count
				zombie_count = zombie_count + player_multiplier
				SpawnEntityFromTable("point_commentary_node", {origin = "-1266 -142 -2315"})
				spawn_interval = spawn_interval - (0.10 * player_count)
				if (spawn_interval < 0.50) spawn_interval = 0.50	// security check for the odd chance someone runs this with a lot of REDs
			}
			if (round_number > 1)
			{
				if (player_count <= 3) zombie_count = zombie_count + (player_count + RandomInt(1,3))
				if (player_count > 3) zombie_count = zombie_count + player_count
				if (zombie_count > 255) zombie_count = 255
			}
			if (spawn_interval > 0.50)
			{
				spawn_interval = spawn_interval - 0.05
			}
			NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts", zombie_count)
			NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveEnemyCount", zombie_count)
			// spawn a bot_generator later with values from here
			local generator = SpawnEntityFromTable("bot_generator",
			{
				useTeamSpawnPoint = 1
				maxActive = max_active
				difficulty = 1
				disableDodge = 1
				interval = spawn_interval // gap between spawns, adjust to be faster per wave?
			//	spawnflags = 512 // ignore sentries
				count = zombie_count
				team = "blue"
				targetname = "bot_spawner"
				"OnExpended#1" : "bot_spawner,RunScriptCode,RoundEnd(activator),0,-1"
				"OnExpended#2" : "bot_spawner,RunScriptCode,ClearSniperMissions(),1,-1"
			})
			NetProps.SetPropString(generator, "m_className", "heavyweapons") // class is a reserved kv so we have to do this workaround to appease squirrel god
			EntFireByHandle(Entities.FindByName(null, "bot_spawner"),"setdisabledodge","1",0,null,null);
			EntFireByHandle(Entities.FindByName(null, "bot_spawner"),"enable","",1,null,null);
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.IsAlive())
				{
					PopExtUtil.PlaySoundOnClient(player,"ui/duel_challenge.wav",1.0,100)
					PopExtUtil.PlaySoundOnClient(player,"Announcer.AM_RoundStartRandom",1.0,100)
				}
			}
		}
		if (boss_timer == 0)
		{
			//	special_count = (6 + player_count * 2) + boss_multiplier
			isbosswave = true
			if (special_count > 255) special_count = 255
			SpawnEntityFromTable("point_commentary_node", {origin = "-1266 -142 -2315"})
			//	boss_multiplier = special_count * 1.3
			if (isbossonly)
			{
				local generator = SpawnEntityFromTable("bot_generator",
				{
					useTeamSpawnPoint = 1
					maxActive = max_active
					difficulty = 2
					disableDodge = 1
					interval = 1.3 // gap between spawns, adjust to be faster per wave?
					//	spawnflags = 512 // ignore sentries
					count = 1
					team = "blue"
					targetname = "bot_spawner_boss"
					"OnExpended#1" : "bot_spawner_boss,RunScriptCode,RoundEnd(activator),0,-1"
				})	// put something in for bosses to do a funny cinematic, if they're a boss only wave?
			NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts", 1)
			NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveEnemyCount", 1)
			}
			if (!isbossonly)
			{
				local generator = SpawnEntityFromTable("bot_generator",
				{
					useTeamSpawnPoint = 1
					maxActive = max_active
					difficulty = 2
					disableDodge = 1
					interval = 1.3 // gap between spawns, adjust to be faster per wave?
					//	spawnflags = 512 // ignore sentries
					count = zombie_count
					team = "blue"
					targetname = "bot_spawner_boss"
					"OnExpended#1" : "bot_spawner_boss,RunScriptCode,RoundEnd(activator),0,-1"
					"OnExpended#2" : "bot_spawner_boss,RunScriptCode,ClearSniperMissions(),0,-1"
				})
				NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts", zombie_count)
				NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveEnemyCount", zombie_count)
			}
			NetProps.SetPropString(Entities.FindByName(null, "bot_spawner_boss"), "m_className", "heavyweapons") // class is a reserved kv so we have to do this workaround to appease squirrel god
			EntFireByHandle(Entities.FindByName(null, "bot_spawner_boss"),"setdisabledodge","1",0,null,null);
			EntFireByHandle(Entities.FindByName(null, "bot_spawner_boss"),"enable","1",1,null,null);
			foreach (player in PopExtUtil.HumanArray)
			{
				if (player.IsAlive())
				{
					PopExtUtil.PlaySoundOnClient(player,"ui/mm_round_end_stalemate_music.wav",1.0,100)
					PopExtUtil.PlaySoundOnClient(player,"Announcer.MVM_Final_Wave_Start",1.0,100)
					foreach (player in PopExtUtil.HumanArray)
					{
						ClientPrint(self, HUD_PRINTCENTER, "FINAL WAVE")
					}
				}
			}
		}
	}
	function GetPlayerCount()
	{
		if (!PopExtUtil.IsWaveStarted) return
		player_count = 0 // reset player_count before doing re-count

		foreach (player in PopExtUtil.HumanArray)
		{
			if (player.IsValid()) player_count++
		}
		if (round_number == 1) players_counted = player_count
		if (round_number > 1)
		{
			if (player_count > players_counted)
			{
				local diff = player_count - players_counted
				zombie_count = zombie_count + (1.5 * diff)
			}
			if (player_count < players_counted)
			{
				local diff2 = players_counted - player_count
				zombie_count = zombie_count - (1.5 * diff2)
			}
			players_counted = player_count
		}
	}

	function IncrementWaveNumber()
	{
		//	local text_gameover_2 = Entities.FindByName(null, "text_gameover_2")
		round_number = NetProps.GetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveCount")
		round_number+= 1
		NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveCount", round_number)
		//	NetProps.SetPropString(text_gameover_2, "m_iszMessage", format("You survived %d waves", (round_number-1)))
		boss_timer -= 1
		if (max_active < bot_cap) max_active += 1
		if (max_active > 30) max_active = 30		// someone will try maxplayers 101 eventually
		ClientPrint(null,HUD_PRINTTALK,"Run's current difficulty level:")
		ClientPrint(null,HUD_PRINTTALK,difficulty.tostring())
	}
}
///// END ROUNDLOGIC.NUT


local player = self;
local giantcount = 0	// amount of giants on field, keep count so we can maxactive them
local maxgiants = (2 + arenascleared)		// max amount of giants, morph later around playercount / difficulty level?
local giantcooldown = 1 // amount of spawns before we send in a giant, keep above one
local giantwait = 8		// how many bots need to spawn after a giant to spawn another one
local bosswait = RandomInt(10,25)	// how many bots need to spawn before the boss can spawn, is IGNORED if it's bossonly
local round_number = NetProps.GetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveCount")
::isbosswave <- false
::isbossonly <- false
::hasbossspawned <- false
// lets try unique wave counts?
::boss_timer <- 7	// how many waves to boss wave

::EnemyTable <-
[
	TF_CLASS_SCOUT,
	TF_CLASS_SOLDIER,
	TF_CLASS_SNIPER,
	TF_CLASS_HEAVYWEAPONS,
]
::GiantTable <-
[
	TF_CLASS_DEMOMAN,
]
::BossTable <-
[
	TF_CLASS_HEAVYWEAPONS,
]
::ExitStageLeft <- function(miniboss) // remove bot from wave counter
{ 
	local botcount = NetProps.GetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts")
	if (botcount == 0) return
	
	botcount-= 1
	NetProps.SetPropInt(PopExtUtil.ObjectiveResource, "m_nMannVsMachineWaveClassCounts", botcount)
	if (miniboss) giantcount -= 1
}

::EnemySpawn <- function(self)
{
	EntFireByHandle(self,"runscriptcode","SelectEnemyType(self)",0.5,null,self);
}
	
::SelectEnemyType <- function(self)
{
	if (self.HasBotTag("Cooldude")) return
	if (!self.IsAlive) return
	if (!self.IsValid) return
	if (self.HasBotAttribute(REMOVE_ON_DEATH)) return // we don't want this running multiple times
	local diceroll = RandomInt(0, EnemyTable.len() - 1)
	self.AddBotAttribute(REMOVE_ON_DEATH)
	self.AddBotAttribute(DISABLE_DODGE) // I suspect this is not carrying over from bot_generator
	self.AddCondEx(87,10,null) // hold in place to apply the stuff
	
	self.SetPlayerClass(EnemyTable[diceroll])
	NetProps.SetPropInt(self,"m_Shared.m_iDesiredPlayerClass",EnemyTable[diceroll])
	self.ForceRegenerateAndRespawn()
	
	UpdateBotModel(self)
	GetBotLoadout(self)
	difficulty = difficulty + 0.025
	if (difficulty > 10) difficulty = 10
	MoveToSpawnLocation(self)
}

::BecomeGiant <- function(self)
{
	if (self.IsMiniBoss()) return // we don't want this running multiple times
	local diceroll = RandomInt(0, GiantTable.len() - 1)
	local diceroll_boss = RandomInt(0, BossTable.len() - 1)
	if (isbossonly) bosswait = 0
	self.AddBotAttribute(REMOVE_ON_DEATH)
	self.AddBotAttribute(DISABLE_DODGE) // I suspect this is not carrying over from bot_generator
	
	self.SetPlayerClass(GiantTable[diceroll])
	NetProps.SetPropInt(self,"m_Shared.m_iDesiredPlayerClass",GiantTable[diceroll])
	if (isbosswave && bosswait <= 0 && !hasbossspawned)
	{
		self.SetPlayerClass(BossTable[diceroll_boss])
		NetProps.SetPropInt(self,"m_Shared.m_iDesiredPlayerClass",BossTable[diceroll_boss])
		self.ForceRegenerateAndRespawn()
		self.SetIsMiniBoss(true)
		self.AddBotTag("bot_boss")
		self.SetScaleOverride(1.75)
		UpdateBotModel(self)
		GetBotLoadout(self)
		MoveToSpawnLocation(self)
		giantcount += 1
		return
	}
	self.ForceRegenerateAndRespawn()
	
	self.SetIsMiniBoss(true)	// all this needs to run after our above trick so they don't get cleared
	self.SetDifficulty(EXPERT)
	UpdateBotModel(self)
	self.AddBotTag("bot_giant")
	self.SetScaleOverride(1.5)	// needs this because lumberyard
	GetBotLoadout(self)			
	difficulty = difficulty + 0.025
	if (difficulty > 10) difficulty = 10
	MoveToSpawnLocation(self)
}
::GetBotLoadout <- function(self)
{
	if (GetRoundState() != 4) return
	if (self.HasBotTag("Cooldude")) return
	self.ClearAllWeaponRestrictions()
	local botclass = self.GetPlayerClass()
	local randomizer = RandomInt(1,11)
	if (giantcooldown == 0 && giantcount < maxgiants)
	{
		giantcooldown = giantwait
		if (difficulty < 6) giantwait = 8
		if (difficulty >= 6 && difficulty < 9) giantwait = 8
		if (difficulty >= 9) giantwait = 7
		BecomeGiant(self)
		return
	}
	if (self.HasBotTag("bot_boss"))
	{
		GetBossHealth(self,20000)
		GivePlayerWeapon(self,"tf_weapon_minigun",811)
		self.AddBotAttribute(AGGRESSIVE)
		self.AddBotAttribute(USE_BOSS_HEALTH_BAR)	// find a way to make this work later
		self.AddCustomAttribute("move speed bonus" ,0.4, -1);
		self.AddCustomAttribute("override footstep sound set" ,2, -1);
		self.AddCustomAttribute("damage force reduction" ,0.1, -1);
		self.AddCustomAttribute("airblast vulnerability multiplier" ,0.1, -1);
		self.SetScaleOverride(1.55)
		self.GetActiveWeapon().AddAttribute("bullets per shot bonus" ,3, -1);
		self.GetActiveWeapon().AddAttribute("damage bonus" ,1.5, -1);
		self.GetActiveWeapon().AddAttribute("Set DamageType Ignite" ,1, -1);
		self.GetActiveWeapon().AddAttribute("fire rate bonus" ,1.2, -1);
		GivePlayerCosmetic(self,9911,"models/workshop/player/items/heavy/robo_heavy_chief/robo_heavy_chief.mdl")
		SetFakeClientConVarValue(self, "name", "Chief Forest Fire");
		CalloutGiant(false)
		hasbossspawned = true
		return
	}
	if (difficulty <= 2)
	{
		if (botclass == TF_CLASS_SCOUT)
		{
			if (randomizer < 6)
			{
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Scout");
				return
			}
			if (randomizer >= 6)
			{
				self.AddWeaponRestriction(SECONDARY_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Scout");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Scout spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_SOLDIER)
		{
			if (randomizer < 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Soldier spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_SNIPER)
		{
			if (randomizer < 6)
			{
				self.AddWeaponRestriction(SECONDARY_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Gunman");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetMission(MISSION_SNIPER,true)
				SetFakeClientConVarValue(self, "name", "Sniper");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Sniper spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_HEAVYWEAPONS)
		{
			if (randomizer < 5)
			{
				GivePlayerWeapon(self,"tf_weapon_fists",43)											// kind of crap but still works?
				GivePlayerCosmetic(self,9911,"models/player/items/heavy/pugilist_protector.mdl")	// this supports any modelpath given to it
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavyweight Champ");
				return
			}
			if (randomizer >= 5)
			{
				self.AddWeaponRestriction(SECONDARY_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.AddCustomAttribute("faster reload rate" ,0.1, -1);	// stock weapons under weapon restriction don't work with GetActiveWeapon()
				self.AddCustomAttribute("fire rate bonus" ,2.5, -1);		// lets apply weapon stats to the body instead
				self.AddCustomAttribute("bullets per shot bonus" ,3, -1);
				self.AddCustomAttribute("damage bonus" ,0.33, -1);
				SetFakeClientConVarValue(self, "name", "Shotgun Heavy");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Heavy spawned with no template !!")
			return
		}
	}
	if (difficulty > 2 && difficulty <= 4)
	{
		giantcooldown -= 1
		if (botclass == TF_CLASS_SCOUT)
		{
			self.AddWeaponRestriction(MELEE_ONLY)
			self.AddBotAttribute(AGGRESSIVE)
			SetFakeClientConVarValue(self, "name", "Scout");
			return
		}
		if (botclass == TF_CLASS_SOLDIER)
		{
			if (randomizer < 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			if (randomizer >= 6)
			{
				GivePlayerWeapon(self,"tf_weapon_rocketlauncher_directhit",127)
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.GetActiveWeapon().AddAttribute("rocket specialist" ,1, -1);
				SetFakeClientConVarValue(self, "name", "Direct Hit Soldier");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Soldier spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_SNIPER)
		{
			if (randomizer < 8)
			{
				GivePlayerWeapon(self,"tf_weapon_compound_bow",56)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Bowman");
				return
			}
			if (randomizer >= 8)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetMission(MISSION_SNIPER,true)
				SetFakeClientConVarValue(self, "name", "Sniper");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Sniper spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_HEAVYWEAPONS)
		{
			if (randomizer < 6)
			{
				GivePlayerWeapon(self,"tf_weapon_fists",43)
				GivePlayerCosmetic(self,9911,"models/player/items/heavy/pugilist_protector.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavyweight Champ");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavy");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Heavy spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_DEMOMAN)
		{
			if (randomizer <= 7)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(HOLD_FIRE_UNTIL_FULL_RELOAD)
				self.SetHealth(3000)
				self.AddCustomAttribute("move speed bonus" ,0.5, -1);
				self.AddCustomAttribute("override footstep sound set" ,4, -1);
				self.AddCustomAttribute("damage force reduction" ,0.5, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.5, -1);
				self.AddCustomAttribute("max health additive bonus" ,3000, -1);
				self.GetActiveWeapon().AddAttribute("faster reload rate" ,-0.4, -1);
				self.GetActiveWeapon().AddAttribute("fire rate bonus" ,0.75, -1);
				SetFakeClientConVarValue(self, "name", "Giant Demoman");
				CalloutGiant(false)
				return
			}
			if (randomizer > 7)
			{
				GivePlayerWeapon(self,"tf_weapon_stickbomb",307)
				self.SetCustomModelWithClassAnimations("models/bots/demo/bot_sentry_buster.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetHealth(2500)
				self.AddCustomAttribute("move speed bonus" ,2, -1);
				self.AddCustomAttribute("override footstep sound set" ,7, -1);
				self.AddCustomAttribute("damage force reduction" ,0.25, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.25, -1);
				self.AddCustomAttribute("max health additive bonus" ,2500, -1);
				self.AddCustomAttribute("cannot be backstabbed",1,-1)
				SetFakeClientConVarValue(self, "name", "Target Buster");
				GetRandomTarget(self)
				self.SetMission(MISSION_DESTROY_SENTRIES,true)
				CalloutGiant(true)
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Demo spawned with no template !!")
			return
		}
	}
	if (difficulty > 4 && difficulty <= 6)
	{
		giantcooldown -= 1
		if (botclass == TF_CLASS_SCOUT)
		{
			self.AddBotAttribute(AGGRESSIVE)
			SetFakeClientConVarValue(self, "name", "Scout");
			return
		}
		if (botclass == TF_CLASS_SOLDIER)
		{
			if (randomizer < 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			if (randomizer >= 6 && randomizer < 9)
			{
				GivePlayerWeapon(self,"tf_weapon_rocketlauncher_directhit",127)
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.GetActiveWeapon().AddAttribute("rocket specialist" ,1, -1);
				SetFakeClientConVarValue(self, "name", "Direct Hit Soldier");
				return
			}
			if (randomizer >= 9)
			{
				GivePlayerWeapon(self,"tf_weapon_buff_item",354)	// conch
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(SPAWN_WITH_FULL_CHARGE)
				self.AddCustomAttribute("mod rage on hit bonus" ,100, -1);
				SetFakeClientConVarValue(self, "name", "Conch Soldier");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Soldier spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_SNIPER)
		{
			if (randomizer < 8)
			{
				GivePlayerWeapon(self,"tf_weapon_compound_bow",56)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Bowman");
				return
			}
			if (randomizer >= 8)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetMission(MISSION_SNIPER,true)
				SetFakeClientConVarValue(self, "name", "Sniper");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Sniper spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_HEAVYWEAPONS)
		{
			if (randomizer < 6)
			{
				GivePlayerWeapon(self,"tf_weapon_fists",43)
				GivePlayerCosmetic(self,9911,"models/player/items/heavy/pugilist_protector.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavyweight Champ");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavy");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Heavy spawned with no template !!")
			return
		}
		if (botclass == TF_CLASS_DEMOMAN)
		{
			if (randomizer <= 7)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(HOLD_FIRE_UNTIL_FULL_RELOAD)
				self.SetHealth(3000)
				self.AddCustomAttribute("move speed bonus" ,0.5, -1);
				self.AddCustomAttribute("override footstep sound set" ,4, -1);
				self.AddCustomAttribute("damage force reduction" ,0.5, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.5, -1);
				self.AddCustomAttribute("max health additive bonus" ,3000, -1);
				self.GetActiveWeapon().AddAttribute("faster reload rate" ,-0.4, -1);
				self.GetActiveWeapon().AddAttribute("fire rate bonus" ,0.75, -1);
				SetFakeClientConVarValue(self, "name", "Giant Demoman");
				CalloutGiant(false)
				return
			}
			if (randomizer > 7)
			{
				GivePlayerWeapon(self,"tf_weapon_stickbomb",307)
				self.SetCustomModelWithClassAnimations("models/bots/demo/bot_sentry_buster.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetHealth(2500)
				self.AddCustomAttribute("move speed bonus" ,2, -1);
				self.AddCustomAttribute("override footstep sound set" ,7, -1);
				self.AddCustomAttribute("damage force reduction" ,0.25, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.25, -1);
				self.AddCustomAttribute("max health additive bonus" ,2500, -1);
				self.AddCustomAttribute("cannot be backstabbed",1,-1)
				SetFakeClientConVarValue(self, "name", "Target Buster");
				GetRandomTarget(self)
				self.SetMission(MISSION_DESTROY_SENTRIES,true)
				CalloutGiant(true)
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Demo spawned with no template !!")
			return
		}
	}
	if (difficulty > 6 && difficulty <= 8)
	{
		giantcooldown -= 1
		if (isbosswave && !isbossonly && !hasbossspawned) bosswait -= 1
		if (botclass == TF_CLASS_SCOUT)
		{
			self.AddBotAttribute(AGGRESSIVE)
			SetFakeClientConVarValue(self, "name", "Scout");
			return
		}
		if (botclass == TF_CLASS_SOLDIER)
		{
			if (randomizer < 3)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			if (randomizer >= 3 && randomizer < 6)
			{
				GivePlayerWeapon(self,"tf_weapon_rocketlauncher_directhit",127)
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.GetActiveWeapon().AddAttribute("rocket specialist" ,1, -1);
				SetFakeClientConVarValue(self, "name", "Direct Hit Soldier");
				return
			}
			if (randomizer >= 6 && randomizer < 8)
			{
				GivePlayerWeapon(self,"tf_weapon_buff_item",354)	// conch
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.AddBotAttribute(SPAWN_WITH_FULL_CHARGE)
				self.AddCustomAttribute("mod rage on hit bonus" ,100, -1);
				SetFakeClientConVarValue(self, "name", "Conch Soldier");
				return
			}
			if (randomizer >= 8)
			{
				GivePlayerWeapon(self,"tf_weapon_buff_item",129)	// buff
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/medic/hwn2016_burly_beast/hwn2016_burly_beast.mdl")
				GivePlayerCosmetic(self,30817,"models/player/items/soldier/ro_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.AddBotAttribute(SPAWN_WITH_FULL_CHARGE)
				self.AddCustomAttribute("mod rage on hit bonus" ,100, -1);
				SetFakeClientConVarValue(self, "name", "Buff Soldier");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Soldier spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_SNIPER)
		{
			if (randomizer < 8)
			{
				GivePlayerWeapon(self,"tf_weapon_compound_bow",56)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				SetFakeClientConVarValue(self, "name", "Bowman");
				return
			}
			if (randomizer >= 8)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetMission(MISSION_SNIPER,true)
				SetFakeClientConVarValue(self, "name", "Sniper");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Sniper spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_HEAVYWEAPONS)
		{
			if (randomizer < 6)
			{
				GivePlayerWeapon(self,"tf_weapon_fists",43)
				GivePlayerCosmetic(self,9911,"models/player/items/heavy/pugilist_protector.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				SetFakeClientConVarValue(self, "name", "Heavyweight Champ");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				SetFakeClientConVarValue(self, "name", "Heavy");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Heavy spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_DEMOMAN)
		{
			if (randomizer <= 7)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(HOLD_FIRE_UNTIL_FULL_RELOAD)
				self.SetHealth(3000)
				self.AddCustomAttribute("move speed bonus" ,0.5, -1);
				self.AddCustomAttribute("override footstep sound set" ,4, -1);
				self.AddCustomAttribute("damage force reduction" ,0.5, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.5, -1);
				self.AddCustomAttribute("max health additive bonus" ,3000, -1);
				self.GetActiveWeapon().AddAttribute("faster reload rate" ,-0.4, -1);
				self.GetActiveWeapon().AddAttribute("fire rate bonus" ,0.75, -1);
				SetFakeClientConVarValue(self, "name", "Giant Demoman");
				CalloutGiant(false)
				return
			}
			if (randomizer > 7)
			{
				GivePlayerWeapon(self,"tf_weapon_stickbomb",307)
				self.SetCustomModelWithClassAnimations("models/bots/demo/bot_sentry_buster.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetHealth(2500)
				self.AddCustomAttribute("move speed bonus" ,2, -1);
				self.AddCustomAttribute("override footstep sound set" ,7, -1);
				self.AddCustomAttribute("damage force reduction" ,0.25, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.25, -1);
				self.AddCustomAttribute("max health additive bonus" ,2500, -1);
				self.AddCustomAttribute("cannot be backstabbed",1,-1)
				SetFakeClientConVarValue(self, "name", "Target Buster");
				GetRandomTarget(self)
				self.SetMission(MISSION_DESTROY_SENTRIES,true)
				CalloutGiant(true)
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Demo spawned with no template !!")
			return
		}
	}
	if (difficulty >= 8)
	{
		giantcooldown -= 1
		if (isbosswave && !isbossonly && !hasbossspawned) bosswait -= 1
		if (botclass == TF_CLASS_SCOUT)
		{
			self.AddBotAttribute(AGGRESSIVE)
			self.SetDifficulty(HARD)
			SetFakeClientConVarValue(self, "name", "Scout");
			return
		}
		if (botclass == TF_CLASS_SOLDIER)
		{
			if (randomizer < 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				SetFakeClientConVarValue(self, "name", "Soldier");
				return
			}
			if (randomizer >= 6 && randomizer < 9)
			{
				GivePlayerWeapon(self,"tf_weapon_rocketlauncher_directhit",127)
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.GetActiveWeapon().AddAttribute("rocket specialist" ,1, -1);
				SetFakeClientConVarValue(self, "name", "Direct Hit Soldier");
				return
			}
			if (randomizer >= 9)	// figure out how to give backpacks full rage
			{
				GivePlayerWeapon(self,"tf_weapon_buff_item",354)	// conch
				GivePlayerCosmetic(self,9911,"models/workshop/player/items/soldier/tw_soldierbot_helmet/tw_soldierbot_helmet.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.AddBotAttribute(SPAWN_WITH_FULL_CHARGE)
				self.AddCustomAttribute("mod rage on hit bonus" ,100, -1);
				SetFakeClientConVarValue(self, "name", "Conch Soldier");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Soldier spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_SNIPER)
		{
			if (randomizer < 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				GivePlayerWeapon(self,"tf_weapon_compound_bow",56)
				SetFakeClientConVarValue(self, "name", "Bowman");
				return
			}
			if (randomizer >= 6)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(EXPERT)
				self.SetMission(MISSION_SNIPER,true)
				SetFakeClientConVarValue(self, "name", "Sniper");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Sniper spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_HEAVYWEAPONS)
		{
			if (randomizer < 6)
			{
				GivePlayerWeapon(self,"tf_weapon_fists",43)
				GivePlayerCosmetic(self,9911,"models/player/items/heavy/pugilist_protector.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(ALWAYS_CRIT)
				self.SetDifficulty(HARD)
				SetFakeClientConVarValue(self, "name", "Heavyweight Champ");
				return
			}
			if (randomizer >= 6)
			{
				GivePlayerWeapon(self,"tf_weapon_minigun",850)
				GivePlayerCosmetic(self,9911,"models/player/items/mvm_loot/heavy/robo_ushanka.mdl")
				self.AddBotAttribute(AGGRESSIVE)
				self.SetDifficulty(HARD)
				self.GetActiveWeapon().AddAttribute("attack projectiles" ,1, -1);
				SetFakeClientConVarValue(self, "name", "Deflector Heavy");
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Heavy spawned with no template !!")
			
			return
		}
		if (botclass == TF_CLASS_DEMOMAN)
		{
			if (randomizer <= 3)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(HOLD_FIRE_UNTIL_FULL_RELOAD)
				self.SetHealth(3000)
				self.AddCustomAttribute("move speed bonus" ,0.5, -1);
				self.AddCustomAttribute("override footstep sound set" ,4, -1);
				self.AddCustomAttribute("damage force reduction" ,0.5, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.5, -1);
				self.AddCustomAttribute("max health additive bonus" ,3000, -1);
				self.GetActiveWeapon().AddAttribute("faster reload rate" ,-0.4, -1);
				self.GetActiveWeapon().AddAttribute("fire rate bonus" ,0.75, -1);
				SetFakeClientConVarValue(self, "name", "Giant Demoman");
				CalloutGiant(false)
				return
			}
			if (randomizer > 3 && randomizer <= 7)
			{
				GivePlayerWeapon(self,"tf_weapon_stickbomb",307)
				self.SetCustomModelWithClassAnimations("models/bots/demo/bot_sentry_buster.mdl")
				self.AddWeaponRestriction(MELEE_ONLY)
				self.AddBotAttribute(AGGRESSIVE)
				self.SetHealth(2500)
				self.AddCustomAttribute("move speed bonus" ,2, -1);
				self.AddCustomAttribute("override footstep sound set" ,7, -1);
				self.AddCustomAttribute("damage force reduction" ,0.25, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.25, -1);
				self.AddCustomAttribute("max health additive bonus" ,2500, -1);
				self.AddCustomAttribute("cannot be backstabbed",1,-1)
				SetFakeClientConVarValue(self, "name", "Target Buster");
				GetRandomTarget(self)
				self.SetMission(MISSION_DESTROY_SENTRIES,true)
				CalloutGiant(true)
				return
			}
			if (randomizer > 7)
			{
				self.AddBotAttribute(AGGRESSIVE)
				self.AddBotAttribute(HOLD_FIRE_UNTIL_FULL_RELOAD)
				self.AddBotAttribute(ALWAYS_CRIT)
				self.SetHealth(3000)
				self.AddCustomAttribute("move speed bonus" ,0.5, -1);
				self.AddCustomAttribute("override footstep sound set" ,4, -1);
				self.AddCustomAttribute("damage force reduction" ,0.5, -1);
				self.AddCustomAttribute("airblast vulnerability multiplier" ,0.5, -1);
				self.AddCustomAttribute("max health additive bonus" ,3000, -1);
				self.GetActiveWeapon().AddAttribute("faster reload rate" ,-0.4, -1);
				self.GetActiveWeapon().AddAttribute("fire rate bonus" ,0.75, -1);
				SetFakeClientConVarValue(self, "name", "Giant Charged Demoman");
				CalloutGiant(false)
				return
			}
			ClientPrint(null,HUD_PRINTTALK,"!! Demo spawned with no template !!")
			return
		}
	}
}