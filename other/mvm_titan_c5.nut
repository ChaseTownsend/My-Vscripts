IncludeScript("fatcat_library")

function securitycheck()
{
	local human = FindByClassnameNearest("player", Vector(1720, 1120, 630), 75)
	if(human == null)
	{
		return 0.5
	}
	if(IsPlayerABot(human))
	{
		return 0.5
	}
	local SteamId = GetPropString(human, "m_szNetworkIDString")
	if (SteamId == "[U:1:101345257]" || SteamId == "[U:1:969530867]")
	{
		EntFire("fort_laser_room_open", "Trigger")
		EntFire("fort_laser_room_close", "Trigger")
	}
	else
	{
		EntFire("fort_laser_room_deny", "Trigger")
	}
	return 0.5
}

function textppr15()
{
	PrintToChatAll("\x07ff5c5c[►]\x07ff3232 Team Powerplay activated.\nPlayers are invulnerable and critboosted for 15 seconds.")
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:15")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr14()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:14")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr13()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:13")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr12()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:12")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr11()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:11")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr10()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:10")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr9()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:09")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr8()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:08")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr7()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:07")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr6()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:06")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr5()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:05")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr4()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:04")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr3()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:03")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr2()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:02")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr1()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:01")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textppr0()
{
	local text = FindByName(null, "text_powerplay")
	text.KeyValueFromString("message", "Team Perk: Powerplay\n0:00")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar45()
{
	PrintToChatAll("\x0719d1ff[►]\x071e8cff Team Radar activated.\nEnemy outlines enabled for 45 seconds.")
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:45")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar44()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:44")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar43()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:43")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar42()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:42")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar41()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:41")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar40()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:40")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar39()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:39")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar38()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:38")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar37()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:37")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar36()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:36")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar35()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:35")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar34()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:34")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar33()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:33")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar32()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:32")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar31()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:31")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar30()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:30")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar29()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:29")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar28()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:28")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar27()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:27")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar26()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:26")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar25()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:25")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar24()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:24")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar23()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:23")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar22()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:22")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar21()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:21")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar20()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:20")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar19()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:19")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar18()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:18")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar17()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:17")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar16()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:16")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar15()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:15")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar14()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:14")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar13()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:13")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar12()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:12")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar11()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:11")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar10()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:10")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar9()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:09")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar8()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:08")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar7()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:07")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar6()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:06")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar5()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:05")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar4()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:04")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar3()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:03")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar2()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:02")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar1()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:01")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function textradar0()
{
	local text = FindByName(null, "text_radar")
	text.KeyValueFromString("message", "Team Perk: Radar\n0:00")
	EnableStringPurge(text)
	text.AcceptInput("Display", null, null, null)
}
function radarrecharged()
{
	PrintToChatAll("\x0719d1ff[►]\x071e8cff Team Radar ready to use.")
}
function pathreroll()
{
	PrintToChatAll("\x0780ff80[►]\x074bff4b Reselecting the bomb path...")
}

::sentryhack <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		if(!params.attacker) return
		local attacker = params.attacker
		if (!attacker || IsPlayerABot(attacker)) return

		if(attacker.GetClassname() == "obj_sentrygun")
		{
			if(attacker.GetName() == "fort_turrets")
			{
				params.damage *= 12
			}
		}
	}
}

::teleporterhack <- {
	function OnGameEvent_player_teleported(params)
	{
		// WARNING:
		// This Will Be Triggered by EVERY teleporter teleport
		local Entrance = FindByName(null, "tele0_1")
		SetPropFloat(Entrance, "m_flCurrentRechargeDuration", 20)
		SetPropFloat(Entrance, "m_flRechargeTime", Time() + 20)
	}
}
__CollectGameEventCallbacks(sentryhack)
__CollectGameEventCallbacks(teleporterhack)

// self is the activator, because we are doing CallScriptFunction on activator on a trigger
function CommitSplash()
{
	if(!self.IsPlayer())
		return

	local splash = SpawnEntityFromTable("info_particle_system", {
		effect_name = "ocean_splash_parent"
		start_active = true
	})
	splash.SetAbsOrigin(Vector(self.GetOrigin().x, self.GetOrigin().y, -574))

	EntFireByHandle(splash, "Kill", "", 2.5, null, null)
}