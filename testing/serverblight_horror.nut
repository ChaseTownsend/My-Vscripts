// ======================================================
// SERVERBLIGHT HORROR CONTROLLER
// TF2 VScript Horror System
// ======================================================

::HorrorController <- {}

::World <- Entities.First()

World.ValidateScriptScope()

// -----------------------------
// CONFIG
// -----------------------------

// Light storage
HorrorController.lightEntities <- []

// Creepy ambient sounds
HorrorController.creepySounds <- [
	"ambient/creepy/metal_scrape1.mp3",
	"ambient/creepy/creak1.mp3",
	"ambient/creepy/echo1.mp3",
	"ambient/levels/citadel/metal1.mp3"

]

// TF2 class laugh sounds
HorrorController.laughSounds <- [

	"vo/scout_laughshort01.mp3",
	"vo/scout_laughshort02.mp3",

	"vo/soldier_laughshort01.mp3",
	"vo/soldier_laughshort02.mp3",

	"vo/pyro_laughhappy01.mp3",

	"vo/demoman_laughshort01.mp3",

	"vo/heavy_laughshort01.mp3",

	"vo/engineer_laughshort01.mp3",

	"vo/medic_laughshort01.mp3",

	"vo/sniper_laughshort01.mp3",

	"vo/spy_laughshort01.mp3"

]

// Jump scare sound
HorrorController.jumpScareSound <- 
	"ambient/alarms/klaxon1.wav"


// -----------------------------
// INIT
// -----------------------------

function HorrorController::Init()
{
	printl("ServerBlight Horror Script Loaded")

	creepySounds.extend(laughSounds).append(jumpScareSound)

	foreach (sound in creepySounds.extend(laughSounds).append(jumpScareSound)) {
		PrecacheSound(sound)
	}

	FindLights()

	AmbientThink()
}


// -----------------------------
// FIND LIGHTS
// -----------------------------

function FindLights()
{
	local ent = null

	while (ent = Entities.FindByClassname(ent, "env_lightglow*"))
	{
		HorrorController.lightEntities.append(ent)
	}
	while (ent = Entities.FindByClassname(ent, "beam*"))
	{
		HorrorController.lightEntities.append(ent)
	}

	printl( "Lights Found: " + HorrorController.lightEntities.len() )
}


// -----------------------------
// LIGHT FLICKER
// -----------------------------

// function FlickerLights()
// {
// 	foreach (light in HorrorController.lightEntities)
// 	{
// 		if (RandomInt(0,1) == 1)
// 		{
// 			EntFireByHandle(
// 				light,
// 				"TurnOff",
// 				"",
// 				0,
// 				null,
// 				null
// 			)

// 			EntFireByHandle(
// 				light,
// 				"TurnOn",
// 				"",
// 				RandomFloat(0.1,0.6),
// 				null,
// 				null
// 			)
// 		}
// 	}
// }


// -----------------------------
// RANDOM CREEPY SOUND
// -----------------------------

function PlayCreepySound(player)
{
	local snd = HorrorController.creepySounds[RandomInt(0, HorrorController.creepySounds.len() - 1)]
	EmitSoundEx({
		sound_name = snd,
		channel = 2
		volume = RandomFloat(0.5, 1.0)
		sound_level = RandomInt(50, 100)
		pitch = RandomInt(80, 120)
		origin = player.GetOrigin() + MATH.RandomVec(-300, 300)
		entity = player
		filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
	})
}


// -----------------------------
// RANDOM LAUGH SOUND
// -----------------------------

function PlayRandomLaugh(player)
{
	local snd = HorrorController.laughSounds[RandomInt(0, HorrorController.laughSounds.len() - 1 )]
	EmitSoundEx({
		sound_name = snd
		channel = 2
		volume = RandomFloat(0.5, 1.0)
		sound_level = RandomInt(50, 100)
		pitch = RandomInt(80, 120)
		origin = player.GetOrigin() + MATH.RandomVec(-300, 300)
		entity = player
		filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
	})
}


// -----------------------------
// JUMPSCARE
// -----------------------------

function JumpScare(player)
{
	EmitSoundEx({
		sound_name = jumpScareSound,
		channel = 2
		volume = RandomFloat(0.5, 1.0)
		sound_level = RandomInt(50, 100)
		pitch = RandomInt(80, 120)
		origin = player.GetOrigin() + MATH.RandomVec(-300, 300)
		entity = player
		filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
	})

	ScreenShake(player.GetOrigin() + MATH.RandomVec(-150, 150), RandomFloat(5.0, 15.0), 5.0, RandomInt(2, 6), 50, 0, true)
}


// -----------------------------
// GET RANDOM PLAYER
// -----------------------------

function GetRandomPlayer()
{
	local players = []

	for (local i = 1; i <= MaxClients().tointeger(); i++)
	{
		local p = PlayerInstanceFromIndex(i)

		if (p != null)
			players.append(p)
	}

	if (players.len() == 0)
		return null

	return players[RandomInt( 0, players.len() - 1 )]
}


// -----------------------------
// MAIN AMBIENT THINK LOOP
// -----------------------------

function AmbientThink()
{
	PrintToHudAll(Time())

	local player = GetRandomPlayer()

	if(player == null)
		return RandomFloat(8, 16)

	// Creepy sounds
	if (RandomInt(1,3) == 1)
		PlayCreepySound(player)

	// Random laughs
	if (RandomInt(1,15) == 1)
		PlayRandomLaugh(player)

	// Jump scare
	if (RandomInt(1,10) == 1)
		JumpScare(player)

	return RandomFloat(8, 16)
}


// -----------------------------
// START SCRIPT
// -----------------------------
local DUMMY = FindByName(null, "FICK")||SpawnEntityFromTable("info_target", {targetname = "FICK"})

DUMMY.TerminateScriptScope()
DUMMY.ValidateScriptScope()

local scope = DUMMY.GetScriptScope()

foreach (k, v in HorrorController)
{
	scope[k] <- v
}

// DUMMY.GetScriptScope().HorrorController <- HorrorController

// DUMMY.GetScriptScope().HorrorController.Init()
DUMMY.GetScriptScope().Think <- function() {
	printl("yug")
	return 1.0
}

PrintTable(scope)

// World.GetScriptScope().Think <- World.GetScriptScope().HorrorController.AmbientThink

AddThinkToEnt(DUMMY, "Think")
{

}