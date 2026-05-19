if(!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("WaveSave", "1.0.2")

::CHECKPOINT_ERROR <- "\x07bf4137"
::WAVE_SAVE_FILE 	<- "checkpoint.txt"

if(!("CheckpointCommand" in ROOT))
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

	printl("RETURNED VALUE!  " + ret.tostring())

	// ONLY WORKS WITH RAFMOD
	EntFireNew(FindByClassname(null, "point_populator_interface"), "$JumpToWave", ret.tostring(), 0.1)
}


function GetFileInfo()
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

	if(file.len() != 5)
	{
		printl(file.len())
		player.PrintToChat("Broken Checkpoint File! Resetting file.")
		SaveWaveData(true)
		return null
	}

	return file
}

function LoadCheckpointCMD()
{
	local file = GetFileInfo()

	local command = "0000"

	try {
	command = ArrayToString(file[3])
	}
	catch (e)
	{
		PrintToChatAllF("Something fucked up : %s", e)
		return
	}

	::CheckpointCommand <- command

	AddChatTrigger(command, WaveVoteCallback)
}


function ReadCheckpoint(player)
{
	local file = GetFileInfo()

	local map = "FUCK"
	local mission = "FUCK the second"
	local waves = "1/1"
	local command = "0000"

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

	local saved_wave = waves.slice(0, 1).tointeger()
	local max_wave = waves.slice(2).tointeger()
	
	// printl("Current Wave Num "+GetCurrentWaveNumber())
	// printl("Saved Wave Num "+saved_wave)
	// printl(max_wave)

	if(GetCurrentWaveNumber() >= saved_wave)
		return player.GetTranslatedAndFormattedString("CHECKPOINT_CURRENT")

	if(max_wave != GetMaximumWaveNumber())
		return "Checkpoints Maximum waves is different from current Maximum!"

	return saved_wave
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
		save += "1/" + max_wave + ":\n"
		save += "0000:\n"
	}
	else
	{
		save += (wave + "/" + max_wave) + ":\n"
		save += Command + ":\n"
	}
	StringToFile(WAVE_SAVE_FILE, save)

	return Command
}

function WaveEndLogic()
{
	if(GetCurrentWaveNumber() == GetMaximumWaveNumber()+1)
		return	// final wave complete
	if(CheckpointCommand != "")
		RemoveChatTrigger(CheckpointCommand)
		
	::CheckpointCommand <- SaveWaveData()
	AddChatTrigger(CheckpointCommand, WaveVoteCallback)

	TranslateToChatAll("CHECKPOINT_CREATED", CheckpointCommand)
}

LoadCheckpointCMD()

if("WaveSaving" in ROOT) ::WaveSaving.clear()
::WaveSaving <- {
	function OnScriptEvent_WaveComplete(_)
	{
		RunWithDelay(@() WaveEndLogic(), 0.1)
	}
}
__CollectGameEventCallbacks(WaveSaving)