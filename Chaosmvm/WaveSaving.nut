if(!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("WaveSave", "1.0.0")

::CHECKPOINT_ERROR <- "\x07bf4137"

::SECPERMIN 	<- 60
::SECPERHOUR 	<- SECPERMIN*60

::WAVE_SAVE_FILE 	<- "checkpoint.txt"
::SAVE_LIFETIME 	<- (69*SECPERMIN) // 60 mins

::CheckpointCommand <- ""

::WaveVoteCallback <- function(player, ...) {

	local ret = ReadCheckpoint(player)

	if(typeof ret != "integer")
	{
		player.PrintToChat(ret)
		return
	}

	if(!FindByClassname(null, "point_populator_interface"))
		SpawnEntityFromTable("point_populator_interface", {})

	TranslateToChatAll("CHECKPOINT_RESTORE")
	TranslateToHudAll("CHECKPOINT_RESTORE_HUD")

	// ONLY WORKS WITH RAFMOD
	EntFireNew(FindByClassname(null, "point_populator_interface"), "$JumpToWave", ret.tostring())

	RemoveChatTrigger(CheckpointCommand)
}

function ReadCheckpoint(player)
{
	local file = split(FileToString(WAVE_SAVE_FILE), ":")
	foreach (string in file)
	{
		local temp = StringToArray(string)
		while (temp.find("\n") != null)
		{
			local index = temp.find("\n")
			if(index == null)
				break
			temp.remove(index)
		}
		file[file.find(string)] = temp
	}

	if(file.len() != 4)
	{
		player.PrintToChat("Broken Checkpoint File! Resetting file.")
		SaveWaveData(true)
		return
	}

	local map = "FUCK"
	local mission = "FUCK the second"
	local waves = "1/1"
	local command = "0000"
	local valid = false

	try {
	map = ArrayToString(file[0])
	mission = ArrayToString(file[1])
	waves = ArrayToString(file[2])
	command = ArrayToString(file[3])
	}
	catch (e)
	{
		PrintToChatAllF("Something fucked up : %s", e)
		return
	}

	// printl(map)
	// printl(mission)
	// printl(waves)
	// printl(command)

	if(GetMapName() != map)
		return player.GetTranslatedAndFormattedString("CHECKPOINT_WRONG_MAP")

	if(GetPopfileName() != mission)
		return player.GetTranslatedAndFormattedString("CHECKPOINT_WRONG_MISS")

	local starting_wave = waves[0].tointeger()
	local max_wave = waves[1].tointeger()

	if(GetCurrentWaveNumber() == starting_wave)
		return 

	if(max_wave != GetMaximumWaveNumber())
		return "Checkpoints Maximum waves is different from current Maximum!"

	if(!valid)
		return "That Checkpoint is not Valid!"

	return starting_wave
}

function GetTimeOfDay()
{
	local cur_time = {}
	LocalTime(cur_time)

	local ActualTime = 0.0
	ActualTime += cur_time.hour * SECPERHOUR
	ActualTime += cur_time.minute * SECPERMIN
	ActualTime += cur_time.second

	return ActualTime
}

function SaveWaveData(Reset = false)
{
	local save 		= ""
	local wave 		= GetCurrentWaveNumber()
	local max_wave 	= GetMaximumWaveNumber()
	local map_name 	= GetMapName()

	local Command = format("%04d", RandomInt(0, 9999))

	save += map_name + ":\n"
	save += GetPopfileName() + ":\n"

	if(Reset)
	{
		save += (wave + "/" + max_wave) + ":\n"
		save += Command + ":\n"
	}
	else
	{
		save += "1/" + max_wave + ":\n"
		save += "0000:\n"
	}
	StringToFile(WAVE_SAVE_FILE, save)

	return Command
}

function WaveEndLogic()
{
	if(GetCurrentWaveNumber() == GetMaximumWaveNumber())
		return	// final wave complete
	if(CheckpointCommand != "")
		RemoveChatTrigger(CheckpointCommand)
	::CheckpointCommand <- SaveWaveData()
	AddChatTrigger(CheckpointCommand, WaveVoteCallback)

	TranslateToChatAll("CHECKPOINT_CREATED", CheckpointCommand)

	// PrintToChatAllF("\x077c8cc2Checkpoint created:\x078165cf [/%s]", CheckpointCommand)
	// PrintToChatAllF("Use \x03/%s\x01 to return back to this wave on a server Crash / Restart!", CheckpointCommand)
}

if("WaveSaving" in ROOT) ::WaveSaving.clear()
::WaveSaving <- {
	function OnScriptEvent_WaveComplete(_)
	{
		RunWithDelay(@() WaveEndLogic(), 0.1)
	}
}
__CollectGameEventCallbacks(WaveSaving)