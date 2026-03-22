IncludeScript("fatcat_library")
local edict_counter = Entities.FindByName(null, "_EdictWarning")
if(edict_counter == null) edict_counter = SpawnEntityFromTable("info_teleport_destination", { targetname = "_EdictWarning" })
AddThinkToEnt(edict_counter, "EdictWarn")
edict_counter.ValidateScriptScope()
local scope = edict_counter.GetScriptScope()
scope.NextWarnTime <- 0

local NukeAbleEnts = [
	"tf_projectile_arrow",
	"tf_projectile_balloffire",
	"tf_projectile_ball_ornament",
	"tf_projectile_energy_ball"
	"tf_projectile_energy_ring",
	"tf_projectile_flare",
	"tf_projectile_jar",
	"tf_projectile_jar_gas",
	"tf_projectile_jar_milk",
	"tf_projectile_lightningorb",
	"tf_projectile_pipe",
	"tf_projectile_pipe_remote",
	"tf_projectile_rocket",
	"tf_projectile_sentryrocket",
	"tf_projectile_spellbats",
	"tf_projectile_spellfireball",
	"tf_projectile_spellkartbats",
	"tf_projectile_spellkartorb",
	"tf_projectile_spellmeteorshower",
	"tf_projectile_spellmirv",
	"tf_projectile_spellpumpkin",
	"tf_projectile_spellspawnboss",
	"tf_projectile_spellspawnhorde",
	"tf_projectile_spellspawnzombie",
	"tf_projectile_syringe",
	"tf_ragdoll",
]
::PrintEdictWarningLimit <- 1800
::NukeEdictLimit <- 1950

function EdictWarn()
{
	local edicts = CountEdicts()
	local scope = self.GetScriptScope()

	if(edicts >= PrintEdictWarningLimit && Time() >= scope.NextWarnTime)
	{
		SendToServerConsole("sm_play @all ui/system_message_alert.wav")
		//SendToConsole("play ui/system_message_alert.wav")
		ClientPrint(null, 3, "\x07ffff55[EDICT WARNING]\x07ff9944 Approaching Tolerance Limit:\n> " + edicts + "/" + NukeEdictLimit + "\nNon-essential entities will be purged to prevent a server crash.")
		scope.NextWarnTime <- Time() + 15
	}

	if(edicts >= NukeEdictLimit)
	{
        SendToServerConsole("sm_play @all ui/rd_2base_alarm.wav")
		ClientPrint(null, 3, "\x07ffff55[EDICT WARNING]\x07ff5555 Tolerance Limit Exceeded!\nNon-essential entities have been purged.")
		//SendToConsole("play ui/rd_2base_alarm.wav")
		foreach (Classname in NukeAbleEnts)
		{
			for (local ent; ent = FindByClassname(ent, Classname); ) ent.Kill()
		}
	}

	if(edicts >= PrintEdictWarningLimit)
	{
		local players = GetEveryPlayer()
		foreach (player in players)
		{
			/* if(GetPlayerSteamID(player) == TheFatCat || GetPlayerSteamID(player) == ShadowBolt)
			{
				ClientPrint(player, 4, "Server approaching Edict Tolerance Limit : " + edicts + "/" + NukeEdictLimit)
			} */
			ClientPrint(player, 4, "Server approaching Edict Tolerance Limit : " + edicts + "/" + NukeEdictLimit)
		}
	}
	//ClientPrint(null, 4, "Server approaching Edict Tolerance Limit : " + edicts + "/" + 2048)
}