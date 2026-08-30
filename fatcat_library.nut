/* 
Syntax Sugar for uploading

	Replace all `if(` 		with `if (`
	Replace all `for(`		with `for (`
	Replace all `foreach(`	with `foreach (`


More Explicit Sugar Makes use of VSCode's built in Regex

	This will add spaces between opening and closing parentheses for function defenitions
	Find: ^(?!.*\\b)(.*?\bfunction\b.*?\()(\S(?:.*?\S)?)\)
	Replace: $1 $2 )

	As in, if it has `function` with () then add spaces inbetween parentheses if they are lacking
	`function test(player)`
	Into:
	`function test( player )`

	This will add spaces after commas
	Find: ^(?!.*\\b)(.*?\bfunction\b.*?\(.+?,)(\S)
	Replace: $1 $2

	As in, if it has `function` with () and comma's with no space after it, add a space
	`function test( bob,joe )`
	Into:
	`function test( bob, joe )`
 */

::CONST <- getconsttable()
::ROOT <- getroottable()

::FATCATLIB_PREFIX 		<- "\x07D000D0► FatCatLib ◄\x01 "
::FATCATLIB_CON_PREFIX 	<- "► FatCatLib ◄ "

::MOD_TF2 <- "Team Fortress 2"
::MOD_TF2C <- "Team Fortress 2 Classified"
::MOD_L4D2 <- "Left 4 Dead 2"

/* if (!("__DoIncludeScript" in ROOT))
{
	ROOT.__DoIncludeScript <- DoIncludeScript

	function ROOT::DoIncludeScript( file, scope = null )
	{
		if (file != "fatcat_library")
		{
			if (file == "trace_filter")
				SetScriptVersion(file, "- DEPENDENCY -")
			else
				SetScriptVersion(file, "unknown")
		}
		__DoIncludeScript(file, scope)
	}
} */

::MOTD_OVERRIDE <- ""
::MOTD_FUNC <- null
// Use example below
// ALWAYS validate the player
/**@param {CTFPlayer} player */
// function ROOT::MOTD_FUNC( player )
// {
// 	if (!IsValidPlayer(player))
// 		return

// 	player.EmitSoundTo("ui/system_message_alert.wav")
// }

function ROOT::PrintGarbage()
{
	local garbage = resurrectunreachable()
	if (!garbage)
		return printl("Garbage Returned Nothing!")
	printf("Found %d garbage. Printing Garbage!\n", garbage.len())
	foreach (object in garbage)
	{
		printl(object)
	}
}


if ("GetModName" in ROOT)
{
	// local Mod = GetModName()
	// if (Mod == MOD_TF2C)
	// {
	// 	IncludeScript("TF2C Fix") // not good rn
	// }
}
else
{
	function ROOT::GetModName()
		return MOD_TF2
}

function ROOT::IsTF2()
	return GetModName() == MOD_TF2

function ROOT::IsTF2C()
	return GetModName() == MOD_TF2C

/**
 * Sets the library version
 * @param 	{string} 	lib_version 	The Library version to set to.
 * @param 	{integer} 	subversion 		The Library subversion to set to.
 * @param 	{bool} 		fail_msg 		If we want to include a fail message.
 * @param 	{bool} 		force_include 	If we Force include this library version.
 * 
 * @return 	{bool} 		If the library version was modified
 */

// lib_version is the current installment of this version
function ROOT::SetLibraryVersion( lib_version, subversion = 0, fail_msg = true, force_include = false )
{
	local force = false
	if ("FatCatLibForce" in ROOT)
		force = FatCatLibForce

	if (force_include || force)
	{
		printl("Force Included Library")
		::FatCatLibVersion <- {
			version = lib_version
			sub_version = subversion
			forced = "true"
		}
		return true
	}
	if (!("FatCatLibVersion" in ROOT))
	{
		::FatCatLibVersion <- {
			version = 0
			sub_version = 0
			forced = "false"
		}
	}
	if (FatCatLibVersion.version == lib_version)
	{
		if (FatCatLibVersion.sub_version == subversion)
		{
			if (fail_msg)
				printl("Library Version is the same as old version. Not Including")
			return false
		}
		else if ( FatCatLibVersion.sub_version > subversion)
		{
			if (fail_msg)
				printl("Uh oh, you are decremeting subversion without incrementing version!")
			return false
		}
		else
		{
			::FatCatLibVersion <- {
				version = lib_version
				sub_version = subversion
				forced = "false"
			}
			return true
		}
	}
	else
	{
		::FatCatLibVersion <- {
			version = lib_version
			sub_version = subversion
			forced = "false"
		}
		return true
	}
	return false
}
if (!("FatCatLibScriptsVersion" in ROOT))
	::FatCatLibScriptsVersion <- {}

function ROOT::SetScriptVersion( item, version )
	FatCatLibScriptsVersion[item] <- version

::ValidLibrarySettings <- {
	// If True removes the unused spy watch viewmodel from every bot on spawn
	// -1 Edict per bot
	"KillWatchViewmodels" : false

	// Only Print Errors to Console
	"ConsoleErrors" : false

	// Print a different Error Message to All Clients
	"PublicErrors" : true

	// Tracks Better Statistics
	"BetterStatTracking" : true

	// Prevent Non Admins from using Noclip
	"NoclipAntiCheat" : true

	// Allows Callbacks for after a cond is applied (maximum delay 1-3 frame)
	// reload library after setting this
	"OnCondPostHooks" : false

	// test
	"TestPurgeString" : false
}

function IsValidSetting( setting )
	return setting in ValidLibrarySettings

function ROOT::ReloadLibrary()
{
	local flag = "FatCatLibForce" in ROOT ? FatCatLibForce : false

	if (flag == false)
		ToggleForceFlag(true)
	IncludeScript("fatcat_library")
	if (flag == false)
		ToggleForceFlag(false)
}

function ROOT::SetLibrarySettings( settings_table = {} )
{
	if (!("FatCatLibSettings" in ROOT))
	{
		::FatCatLibSettings <-{}
		foreach (setting, def in ValidLibrarySettings)
		{
			FatCatLibSettings[setting] <- def
		}
	}

	foreach (setting, def in ValidLibrarySettings)
	{
		if (!(setting in FatCatLibSettings))
			FatCatLibSettings[setting] <- def
	}

	foreach (setting, value in settings_table)
	{
		if (!IsValidSetting(setting))
			continue

		if (FatCatLibSettings[setting] == settings_table[setting])
			continue

		FatCatLibSettings[setting] <- settings_table[setting]

		local ChatPrint = @(message) ("PrintToChatAll" in ROOT ? PrintToChatAll(message) : ClientPrint(null, 3, message))
		ChatPrint(format(FATCATLIB_PREFIX+"Set \x03%s\x01 to \"\x05%s\x01\"\n", setting.tostring(), value.tostring()))
		printl(format(FATCATLIB_PREFIX+"Set %s to \"%s\"\n", setting.tostring(), value.tostring()))
	}
}

function ROOT::ToggleForceFlag( bool )
	::FatCatLibForce <- bool

// month.day.year.hour(24format) (GMT-5)
if (!SetLibraryVersion("08.28.2026.20", 0))
	return

SetLibrarySettings({})

if (!("ConstantNamingConvention" in ROOT)) // make sure folding is only done once
{
	foreach (enum_table in Constants)
	{
		foreach (name, value in enum_table)
		{
			if (value == null)
				value = 0

			CONST[name] <- value
			ROOT[name] <- value
		}
	}
}

if (!("FoldedNetProps" in ROOT)) // make sure folding is only done once
{
	ROOT["FoldedNetProps"] <- "Folds all NetProps to Not require 'NetProps.'"
	foreach (name, method in ::NetProps.getclass())
	{
		// Every 'class' has this
		if (name != "IsValid")
		{
			ROOT[name] <- method.bindenv(::NetProps)
		}
	}
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} value
 * @param {integer} index
 */
function ROOT::SetPropInt( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	NetProps.SetPropIntArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {integer} -1 if not found
 */
function ROOT::GetPropInt( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	return NetProps.GetPropIntArray(entity, prop, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {float} value
 * @param {integer} index
 */
function ROOT::SetPropFloat( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	NetProps.SetPropFloatArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {float} -1.0 if not found
 */
function ROOT::GetPropFloat( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	return NetProps.GetPropFloatArray(entity, prop, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {CBaseEntity} value
 * @param {integer} index
 */
function ROOT::SetPropEntity( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	EnableStringPurge(value)
	NetProps.SetPropEntityArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {CBaseEntity|null} null if not found
 */
function ROOT::GetPropEntity( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	local new_ent = NetProps.GetPropEntityArray(entity, prop, index)
	EnableStringPurge(new_ent)
	return new_ent
}


/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {string} value
 * @param {integer} index
 */
function ROOT::SetPropString( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	NetProps.SetPropStringArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {string} "" if not found
 */
function ROOT::GetPropString( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	return NetProps.GetPropStringArray(entity, prop, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {bool} value
 * @param {integer} index
 */
function ROOT::SetPropBool( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	NetProps.SetPropBoolArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {bool} false if not found
 */
function ROOT::GetPropBool( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	return NetProps.GetPropBoolArray(entity, prop, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {Vector} value
 * @param {integer} index
 */
function ROOT::SetPropVector( entity, prop, value, index = 0 )
{
	EnableStringPurge(entity)
	NetProps.SetPropVectorArray(entity, prop, value, index)
}

/** 
 * @param {CBaseEntity} entity
 * @param {string} prop
 * @param {integer} index
 * @returns {Vector} Vector(0,0,0) if not found
 */
function ROOT::GetPropVector( entity, prop, index = 0 )
{
	EnableStringPurge(entity)
	return NetProps.GetPropVectorArray(entity, prop, index)
}

/** 
 * @param {CBaseEntity|null} entity
 * @param {string} prop
 * @returns {bool}
 */
function ROOT::HasProp( entity, prop )
{
	EnableStringPurge(entity)
	return NetProps.HasProp(entity, prop)
}

if (!("SetPropIntArray" in ROOT))
	ROOT["SetPropIntArray"] <- SetPropInt

if (!("GetPropIntArray" in ROOT))
	ROOT["GetPropIntArray"] <- GetPropInt


if (!("SetPropFloatArray" in ROOT))
	ROOT["SetPropFloatArray"] <- SetPropFloat

if (!("GetPropFloatArray" in ROOT))
	ROOT["GetPropFloatArray"] <- GetPropFloat


if (!("SetPropBoolArray" in ROOT))
	ROOT["SetPropBoolArray"] <- SetPropBool

if (!("GetPropBoolArray" in ROOT))
	ROOT["GetPropBoolArray"] <- GetPropBool


if (!("SetPropEntityArray" in ROOT))
	ROOT["SetPropEntityArray"] <- SetPropEntity

if (!("GetPropEntityArray" in ROOT))
	ROOT["GetPropEntityArray"] <- GetPropEntity


if (!("SetPropVectorArray" in ROOT))
	ROOT["SetPropVectorArray"] <- SetPropVector

if (!("GetPropVectorArray" in ROOT))
	ROOT["GetPropVectorArray"] <- GetPropVector


/*
  =================
  === CONSTANTS ===
  =================
*/

////////////// DEFINES ////////////////
::IS_64BIT 		<- _intsize_ == 8
::IS_WIN		<- RAND_MAX == 0x7FFF

//////// Slot indexs
::SLOT_PRIMARY   <- 0
::SLOT_SECONDARY <- 1
::SLOT_MELEE     <- 2
::SLOT_UTILITY   <- 3
::SLOT_BUILDING  <- 4
::SLOT_PDA       <- 5
::SLOT_PDA2      <- 6
::SLOT_COUNT     <- 7
//////// Strip slot Flags
::STRIPSLOT_PRIMARY		<- (1)		// 1
::STRIPSLOT_SECONDARY	<- (1 << 1)	// 2
::STRIPSLOT_MELEE		<- (1 << 2)	// 4
::STRIPSLOT_PDA			<- (1 << 3)	// 8
::STRIPSLOT_PDA2		<- (1 << 4)	// 16
::STRIPSLOT_ACTION		<- (1 << 5)	// 32
::STRIPSLOT_COSMETICS	<- (1 << 6)	// 64
// combine these flags to remove multiple slots

//////// MathLib
::DEG2RAD	<- 0.0174532924
::RAD2DEG	<- 57.295779513
::FLT_MIN	<- 1.175494e-38
::FLT_MAX	<- 3.402823466e+38
if (IS_64BIT)
{
	::INT_MIN	<- 1 << 63
	::INT_MAX	<- ~(1 << 63)
}
else
{
	::INT_MIN	<- 1 << 31
	::INT_MAX	<- ~(1 << 31) // magic, turns bits 100000... into 011111...
}

//////// MASK'S
::MASK_ALL						<- (INT_MAX)
::MASK_SOLID					<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
::MASK_PLAYERSOLID				<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_PLAYERCLIP|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
::MASK_NPCSOLID					<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTERCLIP|CONTENTS_WINDOW|CONTENTS_MONSTER|CONTENTS_GRATE)
::MASK_WATER					<- (CONTENTS_WATER|CONTENTS_MOVEABLE|CONTENTS_SLIME)
::MASK_OPAQUE					<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_OPAQUE)
::MASK_OPAQUE_AND_NPCS			<- (MASK_OPAQUE|CONTENTS_MONSTER)
::MASK_BLOCKLOS					<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_BLOCKLOS)
::MASK_BLOCKLOS_AND_NPCS		<- (MASK_BLOCKLOS|CONTENTS_MONSTER)
::MASK_VISIBLE					<- (MASK_OPAQUE|CONTENTS_IGNORE_NODRAW_OPAQUE)
::MASK_VISIBLE_AND_NPCS			<- (MASK_OPAQUE_AND_NPCS|CONTENTS_IGNORE_NODRAW_OPAQUE)
::MASK_SHOT						<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_HITBOX)
::MASK_SHOT_HULL				<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE)
::MASK_SHOT_PORTAL				<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW)
::MASK_SOLID_BRUSHONLY			<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_GRATE)
::MASK_PLAYERSOLID_BRUSHONLY	<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_PLAYERCLIP|CONTENTS_GRATE)
::MASK_NPCSOLID_BRUSHONLY		<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW|CONTENTS_MONSTERCLIP|CONTENTS_GRATE)
::MASK_NPCWORLDSTATIC			<- (CONTENTS_SOLID|CONTENTS_WINDOW|CONTENTS_MONSTERCLIP|CONTENTS_GRATE)
::MASK_SPLITAREAPORTAL			<- (CONTENTS_WATER|CONTENTS_SLIME)
/// CUSTOM SOLID TYPES
::MASK_CUSTOM_PLAYERSOLID		<- 67190795 // uh, what did i use here?
::MASK_WORLD 					<- (CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_WINDOW)
///////// TFCOLLISION_GROUP
::TFCOLLISION_GROUP_GRENADES							<- 20
::TFCOLLISION_GROUP_OBJECT								<- 21
::TFCOLLISION_GROUP_OBJECT_SOLIDTOPLAYERMOVEMENT		<- 22
::TFCOLLISION_GROUP_COMBATOBJECT						<- 23
::TFCOLLISION_GROUP_ROCKETS								<- 24
::TFCOLLISION_GROUP_RESPAWNROOMS						<- 25
::TFCOLLISION_GROUP_PUMPKIN_BOMB						<- 26
::TFCOLLISION_GROUP_ROCKET_BUT_NOT_WITH_OTHER_ROCKETS	<- 27

///////// Spell Index's
::TF_SPELL_NONE					<- -2
::TF_SPELL_ROLL					<- -2
::TF_SPELL_UNKNOWN				<- -2
::TF_SPELL_EMPTY				<- -1
::TF_SPELL_FIREBALL 			<- 0
::TF_SPELL_BATS					<- 1
::TF_SPELL_HEAL					<- 2
::TF_SPELL_MIRV 				<- 3
::TF_SPELL_BLAST				<- 4
::TF_SPELL_STEALTH				<- 5
::TF_SPELL_TELEPORT				<- 6
::TF_SPELL_LIGHTNING			<- 7
::TF_SPELL_MINIFY				<- 8
::TF_SPELL_METEOR				<- 9
::TF_SPELL_MONOCULUS			<- 10
::TF_SPELL_SKELETON				<- 11
::TF_SPELL_BOXING_KART			<- 12
::TF_SPELL_BASE_JUMP_KART		<- 13
::TF_SPELL_OVERHEAL_KART		<- 14
::TF_SPELL_BOMB_HEAD_KART		<- 15

///////// TeamNums
/* 
TF2C ETFTeam constants
(table : 0x0000000111663080) 
{
	TEAM_ANY : -2
	TEAM_INVALID : -1
	TEAM_UNASSIGNED : null
	TEAM_SPECTATOR : 1
	TF_TEAM_RED : 2
	TF_TEAM_PVE_DEFENDERS : 2
	TF_TEAM_BLUE : 3
	TF_TEAM_PVE_INVADERS : 3
	TF_TEAM_COUNT : 6				// they changed the internal value, but did not add any more constants
	TF_TEAM_PVE_INVADERS_GIANTS : 6
}
 */
::TF_TEAM_ANY 					<- -2
::TF_TEAM_INVALID 				<- -1
::TF_TEAM_UNASSIGNED 			<- 0
::TF_TEAM_SPECTATOR 			<- 1
// ::TF_TEAM_RED 					<- 2
// ::TF_TEAM_PVE_DEFENDERS 		<- TF_TEAM_RED
// ::TF_TEAM_BLUE 					<- 3
// ::TF_TEAM_PVE_INVADERS 			<- TF_TEAM_BLUE
// ::TF_TEAM_PVE_INVADERS_GIANTS 	<- 4
// ::TF_TEAM_COUNT 				<- 4
::TF_TEAM_HALLOWEEN 			<- 5

///////// Stun Flags
::TF_STUN_NONE					<- 0
::TF_STUN_MOVEMENT				<- (1<<0)
::TF_STUN_CONTROLS				<- (1<<1)
::TF_STUN_MOVEMENT_FORWARD_ONLY	<- (1<<2)
::TF_STUN_SPECIAL_SOUND			<- (1<<3)
::TF_STUN_DODGE_COOLDOWN		<- (1<<4)
::TF_STUN_NO_EFFECTS			<- (1<<5)
::TF_STUN_LOSER_STATE			<- (1<<6)
::TF_STUN_BY_TRIGGER			<- (1<<7)
::TF_STUN_BOTH					<- TF_STUN_MOVEMENT | TF_STUN_CONTROLS
::TF_STUN_SOUND					<- (1<<8)

///////// Flag Status
::FLAG_HOME						<- 0
::FLAG_PICKED_UP				<- 1
::FLAG_DROPPED					<- 2

///////// m_takedamage
::DAMAGE_NO						<- 0
::DAMAGE_EVENTS_ONLY			<- 1
::DAMAGE_YES					<- 2
::DAMAGE_AIM					<- 3

///////// Object Types
::OBJ_DISPENSER 				<- 0
::OBJ_TELEPORTER				<- 1
::OBJ_SENTRY 					<- 2
::OBJ_SAPPER 					<- 3

///////// kBonusEffect
::kBonusEffect_Crit 				<- 0
::kBonusEffect_MiniCrit				<- 1
::kBonusEffect_DoubleDonk			<- 2
::kBonusEffect_WaterBalloonSploosh	<- 3
::kBonusEffect_None					<- 4
::kBonusEffect_DragonsFury			<- 5
::kBonusEffect_Stomp				<- 6
::kBonusEffect_Count				<- 7
///////// BonusEffect // remap bonus effect to correct values
::BONUS_EFFECT_NONE 			<- 0	// default: 4
::BONUS_EFFECT_CRIT 			<- 1	// default: 0
::BONUS_EFFECT_MINICRIT			<- 2	// default: 1
::BONUS_EFFECT_DOUBLEDONK		<- 3	// default: 2
::BONUS_EFFECT_WATERBALLOON		<- 4 	// default: 3 // Unused
::BONUS_EFFECT_DRAGONS_FURY		<- 5	// default: 5
::BONUS_EFFECT_STOMP			<- 6	// default: 6
::BONUS_EFFECT_REMAP <- array(7, 0)
BONUS_EFFECT_REMAP[kBonusEffect_Crit] 					= BONUS_EFFECT_CRIT
BONUS_EFFECT_REMAP[kBonusEffect_MiniCrit] 				= BONUS_EFFECT_MINICRIT
BONUS_EFFECT_REMAP[kBonusEffect_DoubleDonk] 			= BONUS_EFFECT_DOUBLEDONK
BONUS_EFFECT_REMAP[kBonusEffect_WaterBalloonSploosh] 	= BONUS_EFFECT_WATERBALLOON
BONUS_EFFECT_REMAP[kBonusEffect_None] 					= BONUS_EFFECT_NONE
BONUS_EFFECT_REMAP[kBonusEffect_DragonsFury] 			= BONUS_EFFECT_DRAGONS_FURY
BONUS_EFFECT_REMAP[kBonusEffect_Stomp] 					= BONUS_EFFECT_STOMP

///////// TF_DEATH
::TF_DEATH_NONE					<- 0
::TF_DEATH_DOMINATION			<- (1<<0)
::TF_DEATH_ASSISTER_DOMINATION 	<- (1<<1)
::TF_DEATH_REVENGE 				<- (1<<2)
::TF_DEATH_ASSISTER_REVENGE 	<- (1<<3)
::TF_DEATH_FIRST_BLOOD 			<- (1<<4)
::TF_DEATH_FEIGN_DEATH 			<- (1<<5)
::TF_DEATH_INTERRUPTED 			<- (1<<6)
::TF_DEATH_GIBBED 				<- (1<<7)
::TF_DEATH_PURGATORY 			<- (1<<8)
::TF_DEATH_MINIBOSS 			<- (1<<9)
::TF_DEATH_AUSTRALIUM 			<- (1<<10)


////////// TF_AMMO
::TF_AMMO_UNDEFINED	<- 0
::TF_AMMO_NONE		<- 0
::TF_AMMO_DUMMY		<- 0
::TF_AMMO_PRIMARY	<- 1
::TF_AMMO_SECONDARY	<- 2
::TF_AMMO_METAL		<- 3
::TF_AMMO_GRENADES1	<- 4
::TF_AMMO_GRENADES2	<- 5
::TF_AMMO_GRENADES3	<- 6
::TF_AMMO_COUNT		<- 7

///////// Misc Weapon Index's
::TF_WEAPON_BLUTSAUGER 					<- 36
::TF_WEAPON_SOUTHERN_HOSPITALITY		<- 155
::TF_WEAPON_TRIBALMANS_SHIV				<- 171
::TF_WEAPON_VITA_SAW					<- 173
::TF_WEAPON_WARRIOR_SPIRIT 				<- 310
::TF_WEAPON_CANDY_CANE	 				<- 317
::TF_WEAPON_CLAIDHEAMH_MOR 				<- 327
::TF_WEAPON_FIST_OF_STEEL 				<- 331
::TF_WEAPON_TOMISLAV 					<- 424
::TF_WEAPON_POSTAL_PLUMBER 				<- 457
::TF_WEAPON_CONSCIENTIOUS_OBJECTOR		<- 474
::TF_WEAPON_SHORT_CIRCUT				<- 528
::TF_WEAPON_EUREKA_EFFECT				<- 589
::TF_WEAPON_UNARMED_COMBAT				<- 572
::TF_WEAPON_WANGA_PRICK 				<- 574
::TF_WEAPON_POMSON 						<- 588
::TF_WEAPON_LOLLICHOP					<- 739
::TF_WEAPON_BABYFACE					<- 772
::TF_WEAPON_NEON_ANNIHILATOR			<- 813
::TF_WEAPON_NEON_ANNIHILATOR_GENUINE	<- 834
::TF_WEAPON_BREAD_BITE	 				<- 1100
::TF_WEAPON_AIR_STRIKE	 				<- 1104
::TF_WEAPON_NECRO_SMASHER 				<- 1123

///////// TFBOT_BEHAVIOR
::TFBOT_NONE 						<- 0
::TFBOT_IGNORE_ENEMY_SCOUTS 		<- (1<<0)
::TFBOT_IGNORE_ENEMY_SOLDIERS 		<- (1<<1)
::TFBOT_IGNORE_ENEMY_PYROS 			<- (1<<2)
::TFBOT_IGNORE_ENEMY_DEMOMEN 		<- (1<<3)
::TFBOT_IGNORE_ENEMY_HEAVIES 		<- (1<<3)
::TFBOT_IGNORE_ENEMY_MEDICS 		<- (1<<4)
::TFBOT_IGNORE_ENEMY_ENGINEERS 		<- (1<<5)
::TFBOT_IGNORE_ENEMY_SNIPERS 		<- (1<<6)
::TFBOT_IGNORE_ENEMY_SPIES 			<- (1<<7)
::TFBOT_IGNORE_ENEMY_SENTRY_GUNS 	<- (1<<8)
::TFBOT_IGNORE_SCENARIO_GOALS 		<- (1<<9) // does not function

////////// Ability
::ABILITY_REMOVE 	<- -1
::ABILITY_TIME 		<- 0
::ABILITY_DAMAGE 	<- 1

///////// Ability Weapon Index's
::TF_ABILITY_BASE 				<- -1
::TF_ABILITY_HEAVY_RAGE 		<- 43
::TF_ABILITY_CHEERS 			<- 1013
::TF_ABILITY_KART 				<- 1123
::TF_ABILITY_IRON_CURTAIN		<- 298
::TF_ABILITY_BAZARR				<- 402
::TF_ABILITYS <- {
	TF_ABILITY_BASE 		= -1
	TF_ABILITY_HEAVY_RAGE	= 43
	TF_ABILITY_CHEERS		= 1013
	TF_ABILITY_KART 		= 1123
	TF_ABILITY_IRON_CURTAIN = 298
	TF_ABILITY_BAZARR		= 402
}

///////// Misc Taunt Index's
::TF_TAUNT_SECOND_RATE_SORCERY  	<- 30816
::TF_TAUNT_CHEERS 			   		<- 31412
::TF_TAUNT_UNLEASHED_RAGE	   		<- 31441

///////// Redefined DMG_ types
::DMG_USE_HITLOCATIONS 							<- DMG_AIRBOAT
::DMG_HALF_FALLOFF 								<- DMG_RADIATION
::DMG_CRITICAL 									<- DMG_ACID
::DMG_RADIUS_MAX 								<- DMG_ENERGYBEAM
::DMG_IGNITE 									<- DMG_PLASMA
::DMG_FROM_OTHER_SAPPER 						<- DMG_PLASMA
::DMG_USEDISTANCEMOD 							<- DMG_SLOWBURN
::DMG_NOCLOSEDISTANCEMOD 						<- DMG_POISON
::DMG_MELEE 									<- DMG_BLAST_SURFACE
::DMG_DONT_COUNT_DAMAGE_TOWARDS_CRIT_RATE 		<- DMG_DISSOLVE

////////// Particle Attachment
::PATTACH_ABSORIGIN 		<- 0 
::PATTACH_ABSORIGIN_FOLLOW 	<- 1
::PATTACH_CUSTOMORIGIN 		<- 2
::PATTACH_POINT 			<- 3
::PATTACH_POINT_FOLLOW 		<- 4
::PATTACH_WORLDORIGIN 		<- 5
::PATTACH_ROOTBONE_FOLLOW 	<- 6

////////// Trigger spawnflags
::SF_TRIGGER_NONE 							<- 0
::SF_TRIGGER_ALLOW_CLIENTS 					<- 1
::SF_TRIGGER_ALLOW_NPCS 					<- (1<<1)
::SF_TRIGGER_ALLOW_PUSHABLES	 			<- (1<<2)
::SF_TRIGGER_ALLOW_PHYSICS 					<- (1<<3)
::SF_TRIGGER_ONLY_PLAYER_ALLY_NPCS 			<- (1<<4)
::SF_TRIGGER_ONLY_CLIENTS_IN_VEHICLES 		<- (1<<5)
::SF_TRIGGER_ALLOW_ALL 						<- (1<<6)
::SF_TRIGGER_PUSH_ONCE 						<- (1<<7)
::SF_TRIGGER_PUSH_AFFECT_PLAYER_ON_LADDER 	<- (1<<8)
::SF_TRIGGER_ONLY_CLIENTS_OUT_OF_VEHICLES 	<- (1<<9)
::SF_TRIGGER_TOUCH_DEBRIS 					<- (1<<10)
::SF_TRIGGER_ONLY_NPCS_IN_VEHICLES 			<- (1<<11)
::SF_TRIGGER_DISALLOW_BOTS 					<- (1<<12)

////////// Custom DamageCustoms
::TF_DMG_CUSTOM_RANGE					<- TF_DMG_CUSTOM_END+1
::TF_DMG_CUSTOM_IGNORE_EVENTS 			<- (1<<7)
::TF_DMG_CUSTOM_NO_CALLBACKS 			<- (1<<8)
::TF_DMG_CUSTOM_NO_CALLBACKS_IGNORE 	<- (TF_DMG_CUSTOM_IGNORE_EVENTS|TF_DMG_CUSTOM_NO_CALLBACKS)
::TF_DMG_CUSTOM_IGNORE_INTERNAL 		<- (1<<31)

function ROOT::IsCustomFlags( dmg_custom )
	return dmg_custom >= (1<<7)

function ROOT::HasCustomFlag( dmg_custom, flag )
	return IsCustomFlags(dmg_custom) && (dmg_custom & flag)

////////// RUNES
::RUNE_NONE 				<- -1
::RUNE_STRENGTH 			<- 0
::RUNE_HASTE 				<- 1
::RUNE_REGEN 				<- 2
::RUNE_RESIST 				<- 3
::RUNE_VAMPIRE 				<- 4
::RUNE_REFLECT 				<- 5
::RUNE_PRECISION 			<- 6
::RUNE_AGILITY 				<- 7
::RUNE_KNOCKOUT 			<- 8
::RUNE_KING 				<- 9
::RUNE_PLAGUE 				<- 10
::RUNE_SUPERNOVA 			<- 11

/**
 * @param {integer} rune
 */
function ROOT::GetRuneCondition( rune )
{
	switch (rune)
	{
	case RUNE_NONE:			return TF_COND_INVALID;
	case RUNE_STRENGTH:		return TF_COND_RUNE_STRENGTH;
	case RUNE_HASTE:		return TF_COND_RUNE_HASTE;
	case RUNE_REGEN:		return TF_COND_RUNE_REGEN;
	case RUNE_RESIST:		return TF_COND_RUNE_RESIST;
	case RUNE_VAMPIRE:		return TF_COND_RUNE_VAMPIRE;
	case RUNE_REFLECT:		return TF_COND_RUNE_REFLECT;
	case RUNE_PRECISION:	return TF_COND_RUNE_PRECISION;
	case RUNE_AGILITY:		return TF_COND_RUNE_AGILITY;
	case RUNE_KNOCKOUT:		return TF_COND_RUNE_KNOCKOUT;
	case RUNE_KING:			return TF_COND_RUNE_KING;
	case RUNE_PLAGUE:		return TF_COND_RUNE_PLAGUE;
	case RUNE_SUPERNOVA:	return TF_COND_RUNE_SUPERNOVA;
	}
	return TF_COND_INVALID;
}

////////// team chat colors
::TF_TEAM_COLOR_DEFAULT 	<- "\x07FBECCB"
::TF_TEAM_COLOR_RED 		<- "\x07FF3F3F"
::TF_TEAM_COLOR_BLUE 		<- "\x0799CCFF"
::TF_TEAM_COLOR_REPROG_B 	<- "\x0766AAFF"
::TF_TEAM_COLOR_SPEC 		<- "\x07CCCCCC"

////////// HealPlayer types
::T_HEAL_NONE 	<- -1
::T_HEAL_HEALER <- 0
::T_HEAL_PACK 	<- 1

//////////
::TF_WPN_TYPE_PRIMARY 			<- 0
::TF_WPN_TYPE_SECONDARY			<- 1
::TF_WPN_TYPE_MELEE				<- 2
::TF_WPN_TYPE_GRENADE			<- 3
::TF_WPN_TYPE_BUILDING			<- 4
::TF_WPN_TYPE_PDA				<- 5
::TF_WPN_TYPE_ITEM1				<- 6
::TF_WPN_TYPE_ITEM2				<- 7
::TF_WPN_TYPE_HEAD				<- 8
::TF_WPN_TYPE_MISC				<- 9
::TF_WPN_TYPE_MELEE_ALLCLASS	<- 10
::TF_WPN_TYPE_SECONDARY2		<- 11
::TF_WPN_TYPE_PRIMARY2			<- 12
::TF_WPN_TYPE_ITEM3				<- 13
::TF_WPN_TYPE_ITEM4				<- 14

// i aint remaking this shit
enum ProjectileType_t
{
	TF_PROJECTILE_NONE,
	TF_PROJECTILE_BULLET,
	TF_PROJECTILE_ROCKET,
	TF_PROJECTILE_PIPEBOMB,
	TF_PROJECTILE_PIPEBOMB_REMOTE,
	TF_PROJECTILE_SYRINGE,
	TF_PROJECTILE_FLARE,
	TF_PROJECTILE_JAR,
	TF_PROJECTILE_ARROW,
	TF_PROJECTILE_FLAME_ROCKET,
	TF_PROJECTILE_JAR_MILK,
	TF_PROJECTILE_HEALING_BOLT,
	TF_PROJECTILE_ENERGY_BALL,
	TF_PROJECTILE_ENERGY_RING,
	TF_PROJECTILE_PIPEBOMB_PRACTICE,
	TF_PROJECTILE_CLEAVER,
	TF_PROJECTILE_STICKY_BALL,
	TF_PROJECTILE_CANNONBALL,
	TF_PROJECTILE_BUILDING_REPAIR_BOLT,
	TF_PROJECTILE_FESTIVE_ARROW,
	TF_PROJECTILE_THROWABLE,
	TF_PROJECTILE_SPELL,
	TF_PROJECTILE_FESTIVE_JAR,
	TF_PROJECTILE_FESTIVE_HEALING_BOLT,
	TF_PROJECTILE_BREADMONSTER_JARATE,
	TF_PROJECTILE_BREADMONSTER_MADMILK,
	TF_PROJECTILE_GRAPPLINGHOOK,
	TF_PROJECTILE_SENTRY_ROCKET,
	TF_PROJECTILE_BREAD_MONSTER,
	TF_PROJECTILE_JAR_GAS,
	TF_PROJECTILE_FLAME_BALL,	

	// Add new entries here!

	TF_NUM_PROJECTILES
}

::g_szProjectileNames <- [
	"",
	"projectile_bullet",
	"projectile_rocket",
	"projectile_pipe",
	"projectile_pipe_remote",
	"projectile_syringe",
	"projectile_flare",
	"projectile_jar",
	"projectile_arrow",
	"projectile_flame_rocket",
	"projectile_jar_milk",
	"projectile_healing_bolt",
	"projectile_energy_ball",
	"projectile_energy_ring",
	"projectile_pipe_remote_practice",
	"projectile_cleaver",
	"projectile_sticky_ball",
	"projectile_cannonball",
	"projectile_building_repair_bolt",
	"projectile_festive_arrow",
	"projectile_throwable",
	"projectile_spellfireball",
	"projectile_festive_urine",
	"projectile_festive_healing_bolt",
	"projectfile_breadmonster_jarate",
	"projectfile_breadmonster_madmilk",
	"projectile_grapplinghook",
	"projectile_sentry_rocket",
	"projectile_bread_monster",
	"projectile_jar_gas",
	"tf_projectile_balloffire",
]

///// MISC
// Should be 51 for
// 40 Bots, 8 Players, 2 Spec, 1 SourceTV
::MAX_CLIENTS	 		<- MaxClients().tointeger() 
::TF_CLASS_MAXNORMAL 	<- IsTF2C() ? TF_CLASS_CIVILIAN : 9
::MAX_WEAPONS			<- 8
::TICKRATE 				<- 66
::TICK_DUR 				<- 1.0/TICKRATE
::TWO_TICKS 			<- TICK_DUR * 2.0
::THREE_TICKS 			<- TICK_DUR * 3.0
::FIVE_TICKS 			<- TICK_DUR * 5.0
::TEN_TICKS 			<- TICK_DUR * 10.0
::MAX_DECAPITATIONS 	<- 4
::MAX_USER_MSG_DATA 	<- 255
::MAX_CLIENT_PRINT_DATA <- MAX_USER_MSG_DATA-6
::TF_COND_RANGE 		<- 131
::TF_COND_LAST 			<- 130
::TF_JUMP_MIN_SPEED		<- 268.3281572999747
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN 	<- 50 
::TF_WEAPON_SNIPERRIFLE_DAMAGE_MAX 	<- 150
::WEAPON_NOCLIP <- 1
::TRACE_MAX <- 65536
::VALVE_RAND_MAX <- 0x7FFF

::ITEM_FLAG_SELECTONEMPTY		<- (1<<0)
::ITEM_FLAG_NOAUTORELOAD		<- (1<<1)
::ITEM_FLAG_NOAUTOSWITCHEMPTY	<- (1<<2)
::ITEM_FLAG_LIMITINWORLD		<- (1<<3)
::ITEM_FLAG_EXHAUSTIBLE			<- (1<<4)	// A player can totally exhaust their ammo supply and lose this weapon
::ITEM_FLAG_DOHITLOCATIONDMG	<- (1<<5)	// This weapon take hit location into account when applying damage
::ITEM_FLAG_NOAMMOPICKUPS		<- (1<<6)	// Don't draw ammo pickup sprites/sounds when ammo is received
::ITEM_FLAG_NOITEMPICKUP		<- (1<<7)	// Don't draw weapon pickup when this weapon is picked up by the player


::Host <- GetListenServerHost()

///
::PROP_MEDIGUN_CHARGE 	<- "LocalTFWeaponMedigunData.m_flChargeLevel"
::PROP_ITEM_DEF_IDX 	<- "m_AttributeManager.m_Item.m_iItemDefinitionIndex"
::PROP_CHARGE_TIME 		<- "LocalActiveTFWeaponData.m_flEffectBarRegenTime"
::PROP_PLAYER_AMMO 		<- "m_iAmmo"
::PROP_SPELL_CHARGES 	<- "m_iSpellCharges"
::PROP_SPELL_INDEX 		<- "m_iSelectedSpellIndex"
::PROP_PLAYER_STEAMID	<- "m_szNetworkIDString"

::Invincible_Conds <- [
	TF_COND_PHASE,
	TF_COND_INVULNERABLE,
	TF_COND_INVULNERABLE_WEARINGOFF,
	TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED,
	TF_COND_INVULNERABLE_USER_BUFF,
	TF_COND_INVULNERABLE_CARD_EFFECT
]

::WearableIDXs <- {
	Primarys = [
		405, 608
	],
	Secondarys = [
		57, 131, 133,
		231, 406, 444, 
		642, 1099, 1144
	]
}

::SpellDefaults <- [
	-1,	-1, // Unknown, Empty
	2,	2, 	// Fireball, Bats
	1,	1, 	// Heal, Mirv
	2,	1, 	// Blast, Stealth
	2,	1, 	// teleport, lightning
	1,	1, 	// minify, meteor
	1,	1, 	// monoculus, skeleton
	1, 		// idk
]

::PRIMARY_AMMO_TABLE <- {
	"minigun" : 200
	"flamethrower" : 200
	"rocketlauncher_fireball" : 200
	//
	"crossbow" : 150
	"syringegun_medic" : 150
	//
	"compound_bow" : 25
	"sniperrifle" : 25
	"sniperrifle_decap" : 25 
	"sniperrifle_classic" : 25
	//
	"revolver" : 24
	//
	"rocketlauncher" : 20
	"rocketlauncher_airstrike" : 20
	"rocketlauncher_directhit" : 20
	//
	"cannon" : 16
	"grenadelauncher" : 16
	//
	"drg_pomson" : -1
	"particle_cannon" : -1
	"parachute_primary" : -1
	"tf_wearable" : -1
}

::SECONDARY_AMMO_TABLE <- {
	"pistol" : 200
	//
	"smg" : 75
	"charged_smg" : 75
	//
	"handgun_scout_secondary" : 36
	"pistol_scout" : 36
	//
	"revolver" : 24
	"pipebomblauncher" : 24
	//
	"builder" : 0
	//
	"drg_pomson" : -1
	"particle_cannon" : -1
	"parachute_primary" : -1
	"tf_wearable" : -1
	"tf_wearable" : -1
	"cleaver" : -1
	"lunchbox_drink" : -1
	"jar_milk" : -1
	"buff_item" : -1
	"raygun" : -1
	"jar_gas" : -1
	"flaregun_revenge" : -1
	"rocketpack" : -1
	"tf_wearable_demoshield" : -1
	"lunchbox" : -1
	"mechanical_arm" : -1
	"laser_pointer" : -1
	"medigun" : -1
	"tf_wearable_razorback" : -1
	"jar" : -1
}

::SpellWeapons <- {
	"lollichop" 						: TF_WEAPON_LOLLICHOP
	"short_circuit" 					: TF_WEAPON_SHORT_CIRCUT
	"tf_projectile_mechanicalarmorb" 	: TF_WEAPON_SHORT_CIRCUT
	"claidheamohmor" 					: TF_WEAPON_CLAIDHEAMH_MOR
	"unarmed_combat" 					: TF_WEAPON_UNARMED_COMBAT
	"nonnonviolent_protest" 			: TF_WEAPON_CONSCIENTIOUS_OBJECTOR
	"sharp_dresser" 							: 638
}

::CallMedicScenes <- array(TF_CLASS_MAXNORMAL+1)
CallMedicScenes[TF_CLASS_SCOUT] = [
	438,
	439,
	440
]
CallMedicScenes[TF_CLASS_SOLDIER] = [
	1139,
	1140,
	1141
]
CallMedicScenes[TF_CLASS_PYRO] = [
	1489
]
CallMedicScenes[TF_CLASS_DEMOMAN] = [
	957,
	958,
	959
]
CallMedicScenes[TF_CLASS_HEAVYWEAPONS] = [
	274,
	275,
	276
]
CallMedicScenes[TF_CLASS_ENGINEER] = [
	109,
	107,
	108
]
CallMedicScenes[TF_CLASS_MEDIC] = [
	611,
	612,
	613
]
CallMedicScenes[TF_CLASS_SNIPER] = [
	1678,
	1679
]
CallMedicScenes[TF_CLASS_SPY] = [
	779,
	780,
	781
]

/** @type {class} */
class ::color32 {
	/** @type {integer} */
	r = 0
	/** @type {integer} */
	g = 0
	/** @type {integer} */
	b = 0
	/** @type {integer} */
	a = 0

	/** 
	 * @param {integer} _r
	 * @param {integer} _g
	 * @param {integer} _b
	 * @param {integer} _a
	 */
	constructor(_r, _g, _b, _a = 0)
	{
		this.r = MATH.Clamp(_r, 0, 0xff).tointeger()
		this.g = MATH.Clamp(_g, 0, 0xff).tointeger()
		this.b = MATH.Clamp(_b, 0, 0xff).tointeger()
		this.a = MATH.Clamp(_a, 0, 0xff).tointeger()
	}
}

/** @type {class} */
class ::Corrosion {
	/** @type {CTFPlayer|null} */
	m_hOuter 		= null
	bActive 		= false

	/** @type {CTFPlayer|null} */
	hAttacker 		= null
	/** @type {CTFWeaponBase|null} */
	hWeapon 		= null
	flNextTick 		= 0.0
	flTickDur 		= 0.0
	flDmgPerc 		= 0.0
	iDmgAdd 		= 0
	bMakesPuddle 	= false

	/** 
	 * @param {CTFPlayer} outer
	 */
	constructor(outer)
	{
		if (!IsValidPlayer(m_hOuter))
			m_hOuter = outer
	}	

	function CreateCorrosion( attacker, weapon, exdata = false )
	{
		this.hAttacker 		= attacker
		this.hWeapon 		= weapon

		InitVars()

		if (weapon)
		{
			this.flNextTick 	= Time() + weapon.GetAttribute("corrosion tick duration", 1.0)
			this.flTickDur 		= weapon.GetAttribute("corrosion tick duration", 1.0)
			this.flDmgPerc 		= weapon.GetAttribute("corrosion damage percent", 0.25) / 100.0
			this.iDmgAdd 		= weapon.GetAttribute("corrosion damage add", 250)
			this.bMakesPuddle 	= weapon.GetAttribute("corrosion drop puddle", 0) != 0

			if (!IsValidPlayer(this.hAttacker) && IsWeaponClass(weapon, "tf_weap") && IsValidPlayer(weapon.GetOwner()))
				this.hAttacker = weapon.GetOwner()

			Enable()
		}
		else if (exdata)
		{
			this.flNextTick		= Time() + ("tick duration" in exdata ? exdata["tick duration"] : 1.0)
			this.flTickDur		= ("tick duration" in exdata ? exdata["tick duration"] : 1.0)
			this.flDmgPerc		= ("damage percent" in exdata ? exdata["damage percent"] : 0.25) / 100
			this.iDmgAdd		= ("damage add" in exdata ? exdata["damage add"] : 0.25)
			this.bMakesPuddle	= ("drop puddle" in exdata ? true : false)

			Enable()
		}

		// both a valid attacker && weapon
		// if (IsValidPlayer(attacker) && IsWeaponClass(weapon, "tf_weap"))
			// Enable()
	}

	function Enable()
		bActive = true

	function Disable()
		bActive = false

	function InitVars()
	{
		flNextTick 		= 0.0
		flTickDur 		= 0.0
		flDmgPerc 		= 0.0
		iDmgAdd 		= 0
		bMakesPuddle 	= false
	}

	function InitAllVars()
	{
		/** @type {CTFPlayer|null} */
		hAttacker 		= null
		/** @type {CTFWeaponBase|null} */
		hWeapon 		= null
		flNextTick 		= 0.0
		flTickDur 		= 0.0
		flDmgPerc 		= 0.0
		iDmgAdd 		= 0
		bMakesPuddle 	= false
	}

	/** 
	 * Is this Corrosion Active
	 * @returns {bool}
	 */
	function HasCorrosion()
		return bActive

	/** 
	 * Should we remove our corrosion
	 * @returns {bool}
	 */
	function ShouldRemoveCorrosion()
		return m_hOuter.ShouldRemoveCorrosion()
	
	/** 
	 * Disable and Clear our vars
	 */
	function RemoveCorrosion()
	{
		bActive = false
		InitVars() // forget about old if we remove
	}

	/** 
	 * Return if we should process a corrosion tick
	 * @returns {bool}
	 */
	function ShouldUpdate()
	{
		return Time() >= flNextTick
	}

	/** 
	 * Process a Damage Tick
	 */
	function Tick()
	{
		if (!HasCorrosion())
			return
		if (ShouldRemoveCorrosion())
			return RemoveCorrosion()
		
		flNextTick = Time() + flTickDur
		
		local damage = (iDmgAdd + (m_hOuter.GetMaxHealth() * flDmgPerc)) * m_hOuter.HookMultAttributes("corrosion dmg taken mult")

		// so if we suspect the defaults of 250 add and 0.25 percent, than
		// if we have 20000 hp, we are doing ( 250 + (20000 * (0.25/100)))
		// or ( dmg_add + ( max_hp * ( percent/100 ) ) )
		// but no / 100 since that was handled in MakeCorrosion
		// so the final amount would be (250 + 50) or 300

		if (__CORROSION_DEBUG) printf("%s took Corrosion Damage! Attacker : %s, Weapon : %s, Damage : %f\n", 
			m_hOuter.tostring(), hAttacker.tostring(), hWeapon.tostring(), damage)
		if (!CORROSION_ICON || !CORROSION_ICON.IsValid())
			CORROSION_ICON = CreateKillIcon("infection_acid_puddle")
		m_hOuter.TakeDamageCustom(CORROSION_ICON, hAttacker, hWeapon, Vector(), Vector(), damage, DMG_GENERIC|DMG_PREVENT_PHYSICS_FORCE, 0)
	}
}


/*
  ========================
  === END OF CONSTANTS ===
  ========================
*/

/*
  ======================
  === MISSION MAKERS ===
  ======================
*/
if (!("MissionMakers" in ROOT))
	::MissionMakers <- []

function ROOT::AddMissionMaker( id )
	MissionMakers.append(id)

function ROOT::RemoveMissionMaker( id )
{
	if (MissionMakers.find(id))
		MissionMakers.remove(MissionMakers.find(id))
}
/*
  =============================
  === END OF MISSION MAKERS ===
  =============================
*/

/*
  ======================
  === CVAR FUNCTIONS ===
  ======================
*/
/**
 * @param {string} cvar
 */
function ROOT::IsConvarAllowed( cvar )
	return Convars.IsConVarOnAllowList(cvar)

ROOT.IsCvarAllowed <- ROOT.IsConvarAllowed
/**
 * @param {string} cvar
 */
function ROOT::GetCvarFloat( cvar )
	return Convars.GetFloat(cvar)
/**
 * @param {string} cvar
 */
function ROOT::GetCvarBool( cvar )
	return Convars.GetBool(cvar)
/**
 * @param {string} cvar
 */
function ROOT::GetCvarInt( cvar )
	return Convars.GetInt(cvar)
/**
 * @param {string} cvar
 */
function ROOT::GetCvarStr( cvar )
{
	local ret = Convars.GetStr(cvar)
	if (ret == "hunter2")
		ret = "***PROTECTED***"
	return ret
}
ROOT.GetCvarString <- ROOT.GetCvarStr

function ROOT::GetClientConVar( cvar, entindex )
	return Convars.GetClientConvarValue(cvar, entindex)


/**
 * @param {string} convar
 * @param {any} value
 */
function ROOT::SetCvar( convar, value, admin_notify = false, notify_all = false )
{
	local PrintToChatAll = @(m) ("PrintToChatAll" in ROOT ? PrintToChatAll(m) : ClientPrint(null, 3, m))
	local PrintToAdmins = @(l, m) ("PrintToAdmins" in ROOT ? PrintToAdmins(l, m) : ClientPrint(null, 2, m))
	if (!IsConvarAllowed(convar))
	{
		PrintToChatAll("\x07FF4040:SetCvar: \x01Warning Cvar \"\x03"+convar+"\x01\" is Not on the Allowlist!")
		return
	}

	Convars.SetValue(convar, value)
	if ( notify_all )
		PrintToChatAll("Server cvar \'" + convar + "\' changed to " + value)
	else if ( admin_notify )
		PrintToAdmins(3, "Server cvar \'" + convar + "\' changed to " + value)
}

/*
  =============================
  === END OF CVAR FUNCTIONS ===
  =============================
*/

try {
	IncludeScript("trace_filter")
}
catch (e)
{
	try {
		IncludeScript("chaosmvm/trace_filter")
	}
	catch(_) {
		throw "FAILED TO INCLUDE DEPENDENCY \"trace_filter\"!"
	}
}

::test <- "I ever tell you about the time Keith and I made fireworks? Now, I didn't know shit about chemistry, but Keith figured \"Gasoline burns, doesn't it?\" Heh, third-degree burns on 95 percent of his body. Man, people in the next city over were calling to complain about the smell of burning skin."

/*
  =============================
  === START CLASS FUNCTIONS ===
  =============================
*/

/*
  ======================
  === PLAYER METHODS ===
  ======================
*/
///////////////////////////////////////
function CTFPlayer::PrintToHud( message = "" ) // add default so it wont print "NULL" if left blank
	PrintBetter(this, message, HUD_PRINTCENTER)

function CTFPlayer::PrintToChat( message = "" )
	PrintBetter(this, message, HUD_PRINTTALK)

function CTFPlayer::PrintToConsole( message = "" )
	PrintBetter(this, message, HUD_PRINTCONSOLE)

function CTFPlayer::PrintToHudF( message, ... )
	PrintBetter(this, CleanUpAndFormatString.acall([this, message ? message : "null"].extend(vargv)), HUD_PRINTCENTER)

function CTFPlayer::PrintToChatF( message, ... )
	PrintBetter(this, CleanUpAndFormatString.acall([this, message ? message : "null"].extend(vargv)), HUD_PRINTTALK)

function CTFPlayer::PrintToConsoleF( message, ... )
	PrintBetter(this, CleanUpAndFormatString.acall([this, message ? message : "null"].extend(vargv)), HUD_PRINTCONSOLE)

function CTFPlayer::IsOnGround()
	return GetPropEntity(this, "m_hGroundEntity") != null

function CTFPlayer::GetUserName()
	return GetPropString(this, "m_szNetname")

function CTFPlayer::GetSteamID()
	return GetPropString(this, PROP_PLAYER_STEAMID)

function CTFPlayer::GetUserID()
	return GetPropInt(PlayerManager, "m_iUserID", entindex())

function CTFPlayer::GetHealers()
	return GetPropInt(this, "m_Shared.m_nNumHealers")

/** @param {integer} index */
function CTFPlayer::GetAmmoByIndex( index )
	return GetPropInt(this, PROP_PLAYER_AMMO, index)

function CTFPlayer::GetPrimaryAmmo()
	return GetPropInt(this, PROP_PLAYER_AMMO, TF_AMMO_PRIMARY)

function CTFPlayer::GetSecondaryAmmo()
	return GetPropInt(this, PROP_PLAYER_AMMO, TF_AMMO_SECONDARY)

function CTFPlayer::GetMetal()
	return GetPropInt(this, PROP_PLAYER_AMMO, TF_AMMO_METAL)

function CTFPlayer::IsOverhealed()
	return (GetHealth() > GetMaxBuffedHealth())

function CTFPlayer::GetMaxBuffedHealth()
	return GetPropInt(PlayerManager, "m_iMaxBuffedHealth", entindex())

function CTFPlayer::EyeVector()
	return EyeAngles().Forward()

/** @param {float} offset */
function CTFPlayer::GetFrontOffset( offset )
	return GetOrigin() + (EyeVector() * offset)

/** @param {float} offset */
function CTFPlayer::GetEyeOffset( offset )
	return EyePosition() + (EyeVector() * offset)

/** @param {integer} button */
function CTFPlayer::IsPressingButton( button )
	return ( GetPropInt(this, "m_nButtons") & button ) ? true : false

/**
 * @deprecated Use GetWeaponInSlotNew instead
 */
function CTFPlayer::GetWeaponInSlot( slot = 0 )
	return GetPropEntity(this, "m_hMyWeapons", slot)

/** 
 * @param {integer} index 
 * @param {integer} ammo 
*/
function CTFPlayer::SetAmmoByIndex( index, ammo )
	SetPropInt(this, PROP_PLAYER_AMMO, ammo, index)

/** @param {integer} ammo */
function CTFPlayer::SetPrimaryAmmo( ammo )
	SetPropInt(this, PROP_PLAYER_AMMO, ammo, 1)
/** @param {integer} ammo */
function CTFPlayer::SetSecondaryAmmo( ammo )
	SetPropInt(this, PROP_PLAYER_AMMO, ammo, 2)
/** @param {integer} metal */
function CTFPlayer::SetMetal( metal )
	SetPropInt(this, PROP_PLAYER_AMMO, metal, 3)

function CTFPlayer::ResetHealth()
	SetHealth(GetMaxHealth())

function CTFPlayer::ResetColor()
	AcceptInput("Color", "255 255 255", this, this)

function CTFPlayer::SetColor( color = "255 255 255" )
	AcceptInput("Color", color, this, this)

function CTFPlayer::SetScale( scale = 1.0 )
	SetModelScale(scale, 0)

function CTFPlayer::GetHeads()
	return GetPropInt(this, "m_Shared.m_iDecapitations")
/** @param {integer} num */
function CTFPlayer::SetHeads( num )
	return SetPropInt(this, "m_Shared.m_iDecapitations", num)
/** @param {integer} num */
function CTFPlayer::AddHeads( num )
	return SetPropInt(this, "m_Shared.m_iDecapitations", GetHeads() + num)

function CTFPlayer::IsDead()
	return !IsAlive()

function CTFPlayer::MultiplyGravity( mult )
	SetGravity(GetGravity() * mult)

function CTFPlayer::PlayerFire( action = "", input = "", delay = -1, activator = this, caller = this )
	EntFireNew(this, action, input, delay, activator, caller)

/** 
 * @param {string} input 
 * @param {float} delay 
*/
function CTFPlayer::RunScriptCode( input, delay = -1 )
	RunWithDelay(delay, this.compilestring(input, "Input__runscriptcode"))

function CTFPlayer::GetGroundEntity()
	return GetPropEntity(this, "m_hGroundEntity")

function CTFPlayer::GetFallingVelocity()
	return GetAbsVelocity().z

function CTFPlayer::IsDucking()
	return (GetFlags() & FL_DUCKING) != 0

function CTFPlayer::IsCrouching()
	return IsPressingButton(IN_DUCK)

function CTFPlayer::IsReprogrammed()
	return false

function CTFPlayer::IsBot()
	return false

function CTFPlayer::SetFoodItemCharge( charge )
	SetPropFloat(this, "m_Shared.m_flItemChargeMeter", charge, 1)

function CTFPlayer::TakeUnblockableDamage( damage, attacker = Entities.First( ), inflictor = this, weapon = this)
	TakeDamageCustom(inflictor, attacker, weapon, Vector(0, 0, 1), GetOrigin(), damage, DMG_GENERIC|DMG_PREVENT_PHYSICS_FORCE, TF_DMG_CUSTOM_TRIGGER_HURT)

function CTFPlayer::SetCond( cond, duration = -1 )
	AddCondEx(cond, duration, this)

function CTFPlayer::GetTrackedDamage()
	return GetScope(PlayerManager).m_iDamage[entindex()]

function CTFPlayer::SetTrackedDamage( damage = 0 )
	GetScope(PlayerManager).m_iDamage[entindex()] = damage

function CTFPlayer::GetTrackedHealing()
	return GetScope(PlayerManager).m_iHealing[entindex()]

function CTFPlayer::SetTrackedHealing( healing = 0 )
	GetScope(PlayerManager).m_iHealing[entindex()] = healing

function CTFPlayer::GetTrackedTankDamage()
	return GetScope(PlayerManager).m_iDamageBoss[entindex()]

function CTFPlayer::SetTrackedTankDamage( damage = 0 )
	GetScope(PlayerManager).m_iDamageBoss[entindex()] = damage

/**
 * @param {float|integer} percent
 */
function CTFPlayer::GetPercentHealth( percent )
	return GetHealth() * (percent / 100)
/**
 * @param {float|integer} percent
 */
function CTFPlayer::GetPercentMaxHealth( percent )
	return GetMaxBuffedHealth().tofloat() * (percent.tofloat() / 100)

/**
 * @param {integer} rune
 */
function CTFPlayer::HasRune( rune )
	return GetCurrentRune() == rune

/**
 * @param {CTFWeaponBase|null} weapon
 */
// function CTFPlayer::SetActiveWeapon( weapon )
	// SetPropEntity(this, "m_hActiveWeapon", weapon)

function CTFPlayer::AreViewModelsFlipped()
	return GetClientConVar("cl_flipviewmodels", entindex()).tointeger() == 1

/** 
 * @returns {float}
 */
function CTFPlayer::GetDemomanChargeMeter()
	return GetPropFloat(this, "m_Shared.m_flChargeMeter")
/** 
 * @param {float} num
 */
function CTFPlayer::SetDemomanChargeMeter( num )
	SetPropFloat(this, "m_Shared.m_flChargeMeter", num)

/** 
 * @returns {float}
 */
function CTFPlayer::GetRuneCharge()
	return GetPropFloat(this, "m_Shared.m_flRuneCharge")
/** 
 * @param {float} num
 */
function CTFPlayer::SetRuneCharge( num )
	SetPropFloat(this, "m_Shared.m_flRuneCharge", num)

/**
 * @param {integer} playerclass
 */
function CTFPlayer::IsPlayerClass( playerclass )
	return GetPlayerClass() == playerclass

function CTFPlayer::GetDisguiseClass() 
	return InCond( TF_COND_DISGUISED_AS_DISPENSER ) ? TF_CLASS_ENGINEER : GetPropInt(this, "m_Shared.m_nDisguiseClass")

/**
 * @param {integer} amount
 */
function CTFPlayer::AddHealth( amount )
	SetHealth(GetHealth()+amount)
/**
 * @param {integer} amount
 */
function CTFPlayer::RemoveHealth( amount )
	SetHealth(GetHealth()-amount)
	
function CTFPlayer::IsMedicButtonDown()
	return GetPropFloat(this, "m_flHelpmeButtonPressTime") != 0
	
function CTFPlayer::GetChatColor()
	return (GetTeam() == TF_TEAM_RED) ? TF_TEAM_COLOR_RED : (GetTeam() == TF_TEAM_BLUE ? TF_TEAM_COLOR_BLUE : "")

function CTFPlayer::SetThrowableAmmo( ammo )
	SetPropInt(this, PROP_PLAYER_AMMO, ammo, TF_AMMO_GRENADES2)

/**
 * @returns {bool}
 * @deprecated Use InRespawnRoom(true) instead
 */
function CTFPlayer::InAnyRespawnRoom()
	return InRespawnRoom(true)

/**
 * @param {float} range
 * @returns {[CTFPlayer]}
 * 
 * @deprecated Loop over the `m_aHumans` array and filter by range
 */
function CTFPlayer::GetEveryHumanWithin( range, include_me = false )
	return include_me ? GetAllPlayers(TF_TEAM_PVE_DEFENDERS, range ? [GetOrigin(), range] : range, false) : GetAllPlayers(TF_TEAM_PVE_DEFENDERS, [GetOrigin(), range], false).filter(@(_, value) value != this)
/**
 * @param {float} range
 * @returns {[CTFPlayer|CTFBot]}
 * 
 * @deprecated Loop over the `Players` array and filter by range
 */
function CTFPlayer::GetEveryPlayerWithin( range, include_me = false )
	return include_me ? GetAllPlayers(false, range ? [GetOrigin(), range] : range, false) : GetAllPlayers(false, range ? [GetOrigin(), range] : range, false).filter(@(_, value) value != this)

/**
 * @param {float} range
 * @returns {[CTFBot]}
 * 
 * @deprecated Loop over the `m_aRobots` array and filter by range
 */
function CTFPlayer::GetEveryBotWithin( range )
	return GetAllPlayers(TF_TEAM_PVE_INVADERS, [GetOrigin(), range], false).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, [GetOrigin(), range], false))

/**
 * @returns {bool}
 */
function CTFPlayer::IsMissionMaker()
	return IsInArray(GetPropString(this, PROP_PLAYER_STEAMID), MissionMakers)

function CTFPlayer::ResetPrimaryAmmo()
	SetPrimaryAmmo(GetMaximumPrimaryAmmo())

function CTFPlayer::ResetSecondaryAmmo()
	SetSecondaryAmmo(GetMaximumSecondaryAmmo())

function CTFPlayer::ResetMetal()
	SetMetal(GetMaximumMetal())

/** 
 * @param {float|integer} percent
 */
function CTFPlayer::GivePercentPrimaryAmmo( percent )
	GivePercentAmmo(TF_AMMO_PRIMARY, percent)
/** 
 * @param {float|integer} percent
 */
function CTFPlayer::GivePercentSecondaryAmmo( percent )
	GivePercentAmmo(TF_AMMO_SECONDARY, percent)
/** 
 * @param {float|integer} percent
 */
function CTFPlayer::GivePercentMetal( percent )
	GivePercentAmmo(TF_AMMO_METAL, percent)
/** 
 * @param {float|integer} percent
 */
function CTFPlayer::GivePercentGrenadesAmmo( percent )
	GivePercentAmmo(TF_AMMO_GRENADES1, percent)
/**
 * @param {bool} bool
 */
function CTFPlayer::ToggleGlow( bool )
	SetPropBool(this, "m_bGlowEnabled", bool)
/**
 * @returns {string}
 */
function CTFPlayer::GetLanguage()
	return GetClientConVar("cl_language", entindex())
	
/**
 * @param {string} name
 * @param {string} description
 */
function CTFPlayer::IHTranslateToChat( name, description )
	TranslateToChat("IH_TRANSLATE_ITEM", "%T" + name, "%T" + description)
/**
 * @param {string} item
 */
function CTFPlayer::IHTranslateToChat2( item )
	TranslateToChat("IH_TRANSLATE_ITEM", "%T" + item+"_NAME", "%T" + item+"_DESC")
/** 
 * Translates a message to the players hud
 */
function CTFPlayer::TranslateToHud( ... )
	PrintToHud(GetTranslatedAndFormattedString.acall([this].extend(vargv)))
/** 
 * Translates a message to the players chat
 */
function CTFPlayer::TranslateToChat( ... )
	PrintToChat(GetTranslatedAndFormattedString.acall([this].extend(vargv)))

/**
 * Switches to the weapon in this slot (MAY BE NULL)
 * @param {integer} slot
 * 
 * @deprecated just use `Weapon_Switch` with a weapon
 */
function CTFPlayer::SwitchWeaponSlot( slot )
	Weapon_Switch(this.GetWeaponInSlot(slot))

/**
 * Returns is this player is Minicrit debuffed
 * @returns {bool}
 */
function CTFPlayer::IsMinicritDebuffed()
	return !InCond(TF_COND_DEFENSEBUFF) && InMultiCond([TF_COND_URINE, TF_COND_MARKEDFORDEATH, TF_COND_MARKEDFORDEATH_SILENT, TF_COND_PASSTIME_PENALTY_DEBUFF])
/**
 * Returns if this player is Minicrit Buffed
 * @returns {bool}
 */
function CTFPlayer::IsMinicritBuffed()
	return InMultiCond([TF_COND_OFFENSEBUFF, TF_COND_ENERGY_BUFF, TF_COND_NOHEALINGDAMAGEBUFF, TF_COND_MINICRITBOOSTED_ON_KILL])

function CTFPlayer::HasCritImmunity()
	return InCond(TF_COND_DEFENSEBUFF)
/** 
 * Returns if the player has the passtime ball
 * @returns {bool}
 */
function CTFPlayer::HasPasstimeBall()
	return GetPropBool(this, "m_Shared.m_bHasPasstimeBall")
/** 
 * @returns {float}
 */
function CTFPlayer::GetStealthNoAttackExpireTime()
	return GetPropFloat(this, "m_Shared.tfsharedlocaldata.m_flStealthNoAttackExpire")
/**
 * Returns if our Dead Ringer is ready
 * @returns {bool}
 */
function CTFPlayer::IsFeignDeathReady()
	return GetPropBool(this, "m_Shared.m_bFeignDeathReady")

/** 
 * Returns if we are an Enemy
 * @returns {bool}
 */
function CTFPlayer::IsEnemy()
	return GetTeam() == TF_TEAM_PVE_INVADERS

/*
	Some Funcs can use a different name
 */

CTFPlayer.SetJetpackCharge <- CTFPlayer.SetFoodItemCharge
CTFPlayer.SetRazorbackCharge <- CTFPlayer.SetFoodItemCharge

CTFBot.SetJetpackCharge <- CTFPlayer.SetFoodItemCharge
CTFBot.SetRazorbackCharge <- CTFPlayer.SetFoodItemCharge

CTFPlayer.GenerateAndWearItem <- CTFBot.GenerateAndWearItem

/*
	Multiline Functions
 */

/** 
 * @param {integer} slot
 */
function CTFPlayer::GetWeaponIDXInSlot( slot )
{ 
	local weapon = GetWeaponInSlotNew(slot)
	return weapon ? weapon.GetIDX() : -1 
}
/** 
 * @param {integer} slot
 */
function CTFPlayer::GetWeaponIDXInSlotNew( slot )
{ 
	local weapon = GetWeaponInSlotNew(slot)
	return weapon ? weapon.GetIDX() : -1  
}

function CTFPlayer::GetActiveWeaponIDX()
{ 
	local weapon = GetActiveWeapon()
	return weapon ? weapon.GetIDX() : -1  
}

function CTFPlayer::GetAbilityWeaponIDX()
{ 
	local weapon = GetAbilityWeapon()
	return weapon ? weapon.GetIDX() : -1  
}

/** 
 * @returns {[CTFWeaponBase]|CTFWeaponBase|null}
 */
function CTFPlayer::GetAbilityWeaponIDXs()
{
	local idxs = []
	local weapons = GetAbilityWeapons()
	if (weapons == null)
		return null
	foreach (weapon in weapons)
		idxs.append(weapon.GetIDX())
	
	return idxs.len() == 0 ? null : idxs
}

if (!("__ORIGINAL_RemoveCondEx" in CTFPlayer))
{
	CTFPlayer.__ORIGINAL_RemoveCondEx <- CTFPlayer.RemoveCondEx
	CTFBot.__ORIGINAL_RemoveCondEx <- CTFBot.RemoveCondEx
	function CTFPlayer::RemoveCondEx( cond, ignoreDuration = true )
		__ORIGINAL_RemoveCondEx(cond, ignoreDuration)
	function CTFBot::RemoveCondEx( cond, ignoreDuration = true )
		__ORIGINAL_RemoveCondEx(cond, ignoreDuration)
}

function CTFPlayer::AddTrackedDamage( damage = 0 )
{
	if ( type( GetTrackedDamage( ) ) != "integer" )
	{
		SetTrackedDamage( )
	}
	SetTrackedDamage( GetTrackedDamage( ) + damage )
}

function CTFPlayer::AddTrackedHealing( healing = 0 )
{
	if ( type( GetTrackedHealing( ) ) != "integer" )
	{
		SetTrackedHealing( )
	}
	SetTrackedHealing( GetTrackedHealing( ) + healing )
}

function CTFPlayer::AddTrackedTankDamage( damage = 0 )
{
	if ( type( GetTrackedTankDamage( ) ) != "integer" )
	{
		SetTrackedTankDamage( )
	}
	SetTrackedTankDamage( GetTrackedTankDamage( ) + damage )
}

function CTFPlayer::GetCurrentRune()
{
	if (!IsCarryingRune())
		return RUNE_NONE
	if (InCond(TF_COND_RUNE_STRENGTH))
		return RUNE_STRENGTH
	if (InCond(TF_COND_RUNE_HASTE))
		return RUNE_HASTE
	if (InCond(TF_COND_RUNE_REGEN))
		return RUNE_REGEN
	if (InCond(TF_COND_RUNE_RESIST ))
		return RUNE_RESIST
	if (InCond(TF_COND_RUNE_VAMPIRE ))
		return RUNE_VAMPIRE
	if (InCond(TF_COND_RUNE_REFLECT ))
		return RUNE_REFLECT
	if (InCond(TF_COND_RUNE_PRECISION ))
		return RUNE_PRECISION
	if (InCond(TF_COND_RUNE_AGILITY ))
		return RUNE_AGILITY
	if (InCond(TF_COND_RUNE_KNOCKOUT ))
		return RUNE_KNOCKOUT
	if (InCond(TF_COND_RUNE_KING ))
		return RUNE_KING
	if (InCond(TF_COND_RUNE_PLAGUE ))
		return RUNE_PLAGUE
	if (InCond(TF_COND_RUNE_SUPERNOVA ))
		return RUNE_SUPERNOVA
	return RUNE_NONE
}

function CTFPlayer::GetRuneResistance()
{
	if ( GetCurrentRune() == RUNE_RESIST )
		return 0.5
	if ( GetCurrentRune() == RUNE_VAMPIRE )
		return 0.75
	else return 1.0
}

function CTFPlayer::IsValidReprogramTarget( medics = false )
{
	if (!IsBot())
		return false
	if (HasBotAttribute(USE_BOSS_HEALTH_BAR))
		return false
	if (HasBotTag("HardWired"))
		return false
	if (medics == false && GetPlayerClass() == TF_CLASS_MEDIC)
		return false
	return true
}

function CTFPlayer::Suicide()
{ 
	SetHealth(0)
	TakeUnblockableDamage(INT_MAX) 
}

/** 
 * @param {integer} charge
 */
function CTFPlayer::AddThrowableCharge( charge )
{
	local secondary = GetWeaponInSlotNew(SLOT_SECONDARY)
	local def_time = secondary.GetDefaultChargeTime()
	if (def_time == -1) return;

	def_time *= secondary.GetAttribute("effect bar recharge rate increased", 1)
	if (secondary.GetWeaponClass() == "jar_gas") def_time *= secondary.GetAttribute("mult_item_meter_charge_rate", 1)
	local percent_time = def_time * (charge.tofloat()/100)

	secondary.SetChargeTime(secondary.GetChargeTime() - percent_time)
}
/** 
 * @param {integer} charge
 */
function CTFPlayer::SetThrowableCharge( charge )
{
	local secondary = GetWeaponInSlotNew(SLOT_SECONDARY)
	local def_time = secondary.GetDefaultChargeTime()
	if (def_time == -1) return;

	def_time *= secondary.GetAttribute("effect bar recharge rate increased", 1)
	if (secondary.GetWeaponClass() == "jar_gas") def_time *= secondary.GetAttribute("mult_item_meter_charge_rate", 1)
	local percent_time = def_time * ((100 - charge.tofloat())/100)

	secondary.SetChargeTime(Time() + percent_time)
}

function CTFPlayer::IsUberDraining() 
{
	foreach (weapon in GetAllWeapons()) { 
		if (HasProp(weapon, "m_bChargeRelease"))
			return GetPropBool(weapon, "m_bChargeRelease")
	}
	return false
}

/** 
 * @returns {CTFWeaponBase|null}
 */
function CTFPlayer::GetAbilityWeapon() 
{
	foreach (weapon in GetAllWeapons()) { 
		if (TF_ABILITYS.values().find(weapon.GetIDX()) != null)
			return weapon
	}
	return null
}

/** 
 * @returns {[CTFWeaponBase]|CTFWeaponBase|null}
 */
function CTFPlayer::GetAbilityWeapons() 
{
	local weapons = []
	foreach (weapon in GetAllWeapons()) {
		if (TF_ABILITYS.values().find(weapon.GetIDX()) != null)
			weapons.append(weapon)
	}
	return weapons.len() == 0 ? null : weapons
}

/** 
 * @param {integer} taunt_id
 */
function CTFPlayer::ForceTaunt( taunt_id )
{
	local weapon = CreateByClassname("tf_weapon_bat")
	local active_weapon = GetActiveWeapon()
	StopTaunt(true) // both are needed to fully clear the taunt
	RemoveCond(TF_COND_TAUNTING)
	weapon.DispatchSpawn()
	SetPropInt(weapon, PROP_ITEM_DEF_IDX, taunt_id)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	EnableStringPurge(weapon)
	SetPropEntity(this, "m_hActiveWeapon", weapon)
	SetPropInt(this, "m_iFOV", 0) // fix sniper rifles
	HandleTauntCommand(0)
	SetPropEntity(this, "m_hActiveWeapon", active_weapon)
	weapon.Kill()
}
/** 
 * @type {function}
 * @returns {[CTFWeaponBase|null]}
 */
function CTFPlayer::GetMyWeaponsArray()
{
	local MyWeapons = array(MAX_WEAPONS)
	for (local i = 0; i < MAX_WEAPONS; i++) { MyWeapons[i] = GetWeaponInSlotNew(i) }
	return MyWeapons
}

// ====== TIMESTAMP: 10329.7 ======
// AN ERROR HAS OCCURRED [Script terminated by SQQuerySuspend]
// CALLSTACK
// *FUNCTION [GetWeaponInSlotNew( )] fatcat_library.nut line [2094]
// *FUNCTION [GetAllWeapons( )] fatcat_library.nut line [2110]
// *FUNCTION [HookMultAttributes( )] fatcat_library.nut line [3532]
// *FUNCTION [GameplayThink( )] gameplay-applications.nut line [754]
// LOCALS
// [i] 0
// [weaponSlot] 0
// [slot] 6
// [targetArray] NULL
// [this] instance ([1] player)
// [weapon] instance ([355] tf_weapon_revolver)

/**
 * @param {integer} slot
 * @returns {CTFWeaponBase|null}
 */
function CTFPlayer::GetWeaponInSlotNew( slot )
{
	if (!IsValid() || !this)
		return null

	local targetArray = (slot == SLOT_PRIMARY) ? WearableIDXs.Primarys : ((slot == SLOT_SECONDARY) ? WearableIDXs.Secondarys : null)

	for (local child = targetArray ? FirstMoveChild() : null; child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)

		if (!startswith(child.GetClassname(), "tf_wearable"))
			continue

		if (IsInArray(child.GetIDX(), targetArray))
			return child
	}

	local weapon = this.GetWeaponInSlot(slot)
	if (weapon)
	{
		local weaponSlot = weapon.GetSlot()
		if (GetPlayerClass() == TF_CLASS_ENGINEER && weapon.GetClassname() == "tf_weapon_spellbook")
			weaponSlot = SLOT_PDA2

		if (weaponSlot == slot)
			return EnableStringPurge(weapon)
	}

	for (local i = 0; i < MAX_WEAPONS; i++) 
	{ 
		if (i == slot) continue
		weapon = this.GetWeaponInSlot(i)
		if ( weapon == null ) continue

		local weaponSlot = weapon.GetSlot()
		if (GetPlayerClass() == TF_CLASS_ENGINEER && weapon.GetClassname() == "tf_weapon_spellbook")
			weaponSlot = SLOT_PDA2
		
		if (weaponSlot == slot)
			return EnableStringPurge(weapon)
	}

	return null
}
/** 
 * @returns {[CTFWeaponBase]}
 */
function CTFPlayer::GetAllWeapons()
{
	local list = []
	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		list.append(GetWeaponInSlotNew(i))
	}
	return list.filter(@(_, value) value != null)
}
/**
 * @returns {CTFWeaponBase|null}
 */
function CTFPlayer::GetSpellBook()
{
	foreach (weapon in GetAllWeapons())
	{
		if ( weapon.GetClassname() == "tf_weapon_spellbook" )
			return weapon
	}
	return null
}

function CTFPlayer::InRespawnRoom( any = false )
{	
	// does not solve if touching any though ....
	return GetPropInt(this, "m_Shared.m_iSpawnRoomTouchCount")
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if (!any) { if (respawnroom.GetTeam() != GetTeam()) continue }

		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)

		local trace = {
			start = GetOrigin(),
			end = GetOrigin()
			hullmin = GetPlayerMins()
			hullmax = GetPlayerMaxs()
			mask = CONTENTS_SOLID,
			filter = function( entity )
			{
				if (entity.GetClassname() != "func_respawnroom")
					return TRACE_CONTINUE
				else
					return TRACE_OK_CONTINUE
			}
		}
		TraceHullGather(trace)

		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if (trace.hits.len() != 0 && trace.hits[0].enthit) return true
	}
	return false
}

/* function CTFPlayer::InEnemyRespawnRoom()
{

} */

/**
 * @param {float} range
 * @returns {[CTFBaseBoss]}
 */
function CTFPlayer::GetEveryTankWithin( range )
{
	local list = []
	for (local tank; tank = FindByClassnameWithin(tank, "tank", GetOrigin(), range); )
	{
		if (tank.GetTeam() == TF_TEAM_PVE_INVADERS) list.append(tank)
	}
	return list
}

/**
 * @param {float} range
 * @param {float} damage
 * 
 * @deprecated Use CreateBaseExplosion and filter
 */
function CTFPlayer::DamageEveryTankWithin( range, damage )
{
	for (local tank; tank = FindByClassnameWithin(tank, "tank", GetOrigin(), range); )
	{
		if (tank.GetTeam() == TF_TEAM_PVE_INVADERS) tank.TakeDamage(damage, DMG_GENERIC, this)
	}
}
/**
 * @param {float} range
 * @param {float} damage
 * 
 * @deprecated Use CreateBaseExplosion and filter
 */
function CTFPlayer::DamageEveryBotWithin( range, damage )
{
	foreach (bot in GetEveryBotWithin(range))
		bot.TakeDamage(damage, 0, this)
}

function CTFPlayer::RemoveStun()
{
	SetPropInt(this, "m_Shared.m_flMovementStunTime", 0)
	SetPropInt(this, "m_Shared.m_iStunFlags", 0)
	SetPropInt(this, "m_Shared.m_hStunner", -1)
	SetPropInt(this, "m_Shared.m_iMovementStunAmount", 0)
	SetPropInt(this, "m_Shared.m_iMovementStunParity", 0)
	RemoveCondEx(TF_COND_STUNNED, true)
}
// Are they [Insert Title card here]
function CTFPlayer::IsInvincible()
{
	foreach (Condition in Invincible_Conds)
		if (InCond(Condition)) return true
	return false
}

function CTFPlayer::IsEventJudge()
{
	return IsInArray(GetPropString(this, PROP_PLAYER_STEAMID), [
		// Names as of searching [2/8/26] && [2/14/26] && [2/24/26] && [3/1/26]
		"[U:1:279359900]"	// Automaton Trooper
		"[U:1:28266263]"	// Braindawg
		"[U:1:197828022]"	// Bazooks
		"[U:1:66915592]"	// Claudz
		"[U:1:205635676]"	// pametome
		"[U:1:295552082]"	// Flurbury
		"[U:1:55891323]"	// skg
		"[U:1:36810370]"	// Package O' Lies
		"[U:1:919398610]"	// Kat [uber]
		"[U:1:167092512]"	// OrangeGlazer
		"[U:1:99590462]"	// UltimentM
		"[U:1:419501997]"	// Pasta
		"[U:1:179345871]"	// Kurante
		"[U:1:1086491858]"	// Sergeant Table
		"[U:1:73335243]"	// Magdalene, The Roaring
		"[U:1:1585968943]"	// Skylamama
		"[U:1:1117234744]"	// wbend yout
		"[U:1:1404800684]"	// unsaken
		"[U:1:56932872]"	// Yoovy
		"[U:1:157264909]"	// M1
		"[U:1:879075697]"	// spruce
		"[U:1:141959568]"	// Sleeeepykai
		"[U:1:285143208]"	// Skin King
		"[U:1:1077797916]"	// wooper (real)
		"[U:1:63932876]"	// PDA Expert
		"[U:1:1215461762]"	// NongLyney
		"[U:1:401162912]"	// Conga Dispenser
		"[U:1:83176584]"	// Mince
		"[U:1:112896383]"	// Lemonée
		"[U:1:1075756146]"	// GET ANGRY !!! 	//furuka
		"[U:1:312592019]"	// the fat			//T_TFBot_Eel_New_Jersey
		"[U:1:1104797071]"	// Katsu
	])
}

function CTFPlayer::IsAdmin()
{
	return IsMissionMaker() || IsInArray(GetPropString(this, PROP_PLAYER_STEAMID), [
		"[U:1:969530867]"	// Fatcat
		"[U:1:101345257]"	// ShadowBolt
		"[U:1:1768280682]"	// MiirioKing
		"[U:1:361678739]"	// Cuteamena
	])
}

/**
 * @param {integer} index
 */
function CTFPlayer::HasWeapon( index )
{
	foreach (weapon in GetAllWeapons())
		if (weapon.GetIDX() == index) return true
	return false
}
/**
 * @param {string} classname
 */
function CTFPlayer::HasWeaponClassname( classname )
{
	foreach (weapon in GetAllWeapons())
		if (weapon.GetClassname() == classname) return true
	return false
}
/**
 * @param {integer} index
 * @returns {CTFWeaponBase|null}
 */
function CTFPlayer::GetWeapon( index )
{
	foreach (weapon in GetAllWeapons())
		if (weapon.GetIDX() == index) return weapon
	return null
}
/**
 * @param {string} classname
 * @returns {CTFWeaponBase|null}
 */
function CTFPlayer::GetWeaponClassname( classname )
{
	foreach (weapon in GetAllWeapons())
		if (weapon.GetClassname() == classname) return weapon
	return null
}

function CTFPlayer::RegenerateNoHP( ammo )
{
	local hp = GetHealth()
	Regenerate(ammo)
	SetHealth(hp)
}

if (!("__ORIGINAL_Regenerate" in CTFPlayer))
{
	CTFPlayer.__ORIGINAL_Regenerate <- CTFPlayer.Regenerate
	function CTFPlayer::Regenerate( ammo, hp = true )
	{
		if (hp)
			__ORIGINAL_Regenerate(ammo)
		else
			RegenerateNoHP(ammo)
	}
}


function CTFPlayer::GetMaximumPrimaryAmmo()
{
	local ammo = 32
	local ammo_mult = 1
	local round = false

	local weapon = GetWeaponInSlotNew(SLOT_PRIMARY)
	if (!weapon)
		return ammo
	// Assert(weapon, "CTFPlayer::GetMaximumPrimaryAmmo: Got a NULL weapon")

	local orig_name = weapon.GetClassname()
	local name = weapon.GetClassname()
	if (startswith(orig_name, "tf_weapon_"))
		name = orig_name.slice(10)

	if (name in PRIMARY_AMMO_TABLE)
	{
		ammo = PRIMARY_AMMO_TABLE[name]
		if (ammo == -1)
			return 32
	}

	if (name == "crossbow")
		round = true

	local weapons = GetAllWeapons()
	foreach (weapon in weapons)
	{
		if (weapon.GetAttribute("provide on active", 0) == 1)
		{
			if (GetActiveWeapon() == weapon)
			{
				ammo_mult *= weapon.GetAttribute("hidden primary max ammo bonus", 1)
				ammo_mult *= weapon.GetAttribute("maxammo primary increased", 1)
				ammo_mult *= weapon.GetAttribute("maxammo primary reduced", 1)
			}
		}
		else
		{
			ammo_mult *= weapon.GetAttribute("hidden primary max ammo bonus", 1)
			ammo_mult *= weapon.GetAttribute("maxammo primary increased", 1)
			ammo_mult *= weapon.GetAttribute("maxammo primary reduced", 1)
		}
	}
	if (HasRune(RUNE_HASTE))	
		ammo_mult *= 2
	
	return (round == true ? ceil(ammo * ammo_mult) : (ammo * ammo_mult))
}

function CTFPlayer::GetMaximumSecondaryAmmo()
{
	local ammo = 32
	local ammo_mult = 1
	local round = false

	local weapon = GetWeaponInSlotNew(SLOT_SECONDARY)

	if (!weapon)
		return ammo

	local orig_name = weapon.GetClassname()
	local name = orig_name
	if (startswith(orig_name, "tf_weapon_"))
		name = orig_name.slice(10)

	if (name in SECONDARY_AMMO_TABLE)
	{
		ammo = SECONDARY_AMMO_TABLE[name]
		if (ammo == -1)
			return 0
	}

	if (name == "builder") // sapper
		ammo = GetMaximumPrimaryAmmo()

	local weapons = GetAllWeapons()
	foreach (weapon in weapons)
	{
		if (weapon.GetAttribute("provide on active", 0) == 1)
		{
			if (GetActiveWeapon() == weapon)
			{
				ammo_mult *= weapon.GetAttribute("hidden secondary max ammo penalty", 1)
				ammo_mult *= weapon.GetAttribute("maxammo secondary increased", 1)
				ammo_mult *= weapon.GetAttribute("maxammo secondary reduced", 1)
			}
		}
		else
		{
			ammo_mult *= weapon.GetAttribute("hidden secondary max ammo penalty", 1)
			ammo_mult *= weapon.GetAttribute("maxammo secondary increased", 1)
			ammo_mult *= weapon.GetAttribute("maxammo secondary reduced", 1)
		}
	}
	if (HasRune(RUNE_HASTE))	
		ammo_mult *= 2
	return (round ? ceil(ammo * ammo_mult) : (ammo * ammo_mult))
}

function CTFPlayer::GetMaximumMetal()
{
	if (!this||!IsValid())
		return 0
	local metal = 200
	local metal_mult = 1
	local weapons = GetAllWeapons()
	foreach (weapon in weapons)
	{
		if (weapon.HasAdditiveAttribute("provide on active"))
		{
			if (GetActiveWeapon() == weapon)
			{
				metal_mult *= weapon.GetAttribute("maxammo metal increased", 1)
				metal_mult *= weapon.GetAttribute("maxammo metal reduced", 1)
			}
		}
		else
		{
			metal_mult *= weapon.GetAttribute("maxammo metal increased", 1)
			metal_mult *= weapon.GetAttribute("maxammo metal reduced", 1)
		}
	}
	if (HasRune(RUNE_HASTE))	
		metal_mult *= 2
	return metal * metal_mult
}

function CTFPlayer::GetMaximumGrenades1()
{
	local grenades = 1
	local grenades_mult = 1
	foreach (weapon in GetAllWeapons())
	{
		if (weapon.HasAdditiveAttribute("provide on active"))
		{
			if (GetActiveWeapon() == weapon)
			{
				grenades_mult *= weapon.GetAttribute("maxammo grenades1 increased", 1)
			}
		}
		else
		{
			grenades_mult *= weapon.GetAttribute("maxammo grenades1 increased", 1)
		}
	}
	if (HasRune(RUNE_HASTE))	
		grenades_mult *= 2
	return grenades * grenades_mult
}

function CTFPlayer::GetMaximumGrenades3()
{
	local grenades = 1
	if (HasRune(RUNE_HASTE))	
		grenades *= 2
	return grenades
}

/** 
 * @param {integer} index
 * @param {integer} percent
 * @throws {string} invalid ammo type
 */
function CTFPlayer::GivePercentAmmo( index, percent )
{
	local maximum = 0
	local current = GetAmmoByIndex(index)
	if (index == TF_AMMO_PRIMARY)
		maximum = GetMaximumPrimaryAmmo()
	else if (index == TF_AMMO_SECONDARY)
		maximum = GetMaximumSecondaryAmmo()
	else if (index == TF_AMMO_METAL)
		maximum = GetMaximumMetal()
	else if (index == TF_AMMO_GRENADES1)
		maximum = GetMaximumGrenades1()
	else if (index == TF_AMMO_GRENADES2)
	{
		maximum = 1
		if (InCond(TF_COND_RUNE_HASTE))
			maximum = 2
	}
	else if (index == TF_AMMO_GRENADES3)
		maximum = GetMaximumGrenades3()
	else
		throw "Unknown Ammo Type "+index

	local to_give = maximum * (percent.tofloat() / 100)
	
	if (current + to_give > maximum)
		SetAmmoByIndex(index, maximum)
	else 
		SetAmmoByIndex(index, current + to_give)
}

function CTFPlayer::ResetAmmo()
{
	ResetPrimaryAmmo()
	ResetSecondaryAmmo()
	ResetMetal()
}
/**
 * @param {[integer]} conds
 */
function CTFPlayer::InMultiCond( conds )
{
	foreach (cond in conds)
		if (InCond(cond))
			return true
	
	return false
}
/**
 * @param {integer} index
 */
function CTFPlayer::ForceChangeClass( index, respawn = false )
{
	local old_class = GetPlayerClass()
	if (old_class != TF_CLASS_ENGINEER && index == TF_CLASS_ENGINEER)
		RemoveAllObjects(false)
	SetPlayerClass(index)
	SetPropInt(this, "m_Shared.m_iDesiredPlayerClass", index)
	if (respawn)
		ForceRegenerateAndRespawn()
	else
		Regenerate(true)
}

function CTFPlayer::GetPlayerClassName()
{
	switch (GetPlayerClass())
	{
	case TF_CLASS_SCOUT:			return "Scout"
	case TF_CLASS_SOLDIER: 			return "Soldier"
	case TF_CLASS_PYRO: 			return "Pyro"
	case TF_CLASS_DEMOMAN: 			return "Demoman"
	case TF_CLASS_HEAVYWEAPONS: 	return "Heavy"
	case TF_CLASS_ENGINEER: 		return "Engineer"
	case TF_CLASS_MEDIC: 			return "Medic"
	case TF_CLASS_SNIPER: 			return "Sniper"
	case TF_CLASS_SPY: 				return "Spy"
	default:						return "Unknown!"
	}
}

function CTFPlayer::GetPlayerModelPath()
{
	switch (GetPlayerClass())
	{
	case TF_CLASS_SCOUT:			return "scout"
	case TF_CLASS_SOLDIER: 			return "soldier"
	case TF_CLASS_PYRO: 			return "pyro"
	case TF_CLASS_DEMOMAN: 			return "demo"
	case TF_CLASS_HEAVYWEAPONS: 	return "heavy"
	case TF_CLASS_ENGINEER: 		return "engineer"
	case TF_CLASS_MEDIC: 			return "medic"
	case TF_CLASS_SNIPER: 			return "sniper"
	case TF_CLASS_SPY: 				return "spy"
	default:						return "Unknown!"
	}
}

/**
 * @param {string} string
 */
function CTFPlayer::GetTranslatedString( string )
{
	if (!IsValidPlayer(this))
		return
	local lang = GetLanguage()
	//hmm, mising all translations?
	if (!("TRANSLATION_TABLE" in ROOT))
		return " Missing Translation Table!"

	// we dont have this language translated yet, or its missing
	// default to english
	if (!(lang in TRANSLATION_TABLE))
	{
		lang = "english"
		PrintToHud("Please contact \"The Fatcat\" to assist with adding translations.")
	}
	
	local translation_table = TRANSLATION_TABLE[lang]

	// so... we dont have this string yet, or is misspelled, idk
	if (!(string in translation_table))
		return format(" \x01Missing Translation String for \"\x03%s\x01\"", string.tostring())
	
	return translation_table[string]
}

// only half stolen from Potato's MGE vscript
/**
 * @returns {string}
 */
function CTFPlayer::GetTranslatedAndFormattedString( ... )
{
	if (!IsValidPlayer(this))
		return
	local args = vargv
	local localized_string = args[0]
	local format_args = args.slice(1).apply(@(a) a.tostring())

	// check if any of our formated strings need to be translated
	for (local i = 0; i < format_args.len(); i++)
	{
		if (startswith(format_args[i], "%T"))
			format_args[i] = GetTranslatedString(format_args[i].slice(2))
	}

	local str = GetTranslatedString(localized_string)

	if (args.len() > 1)
		str = format.acall([this, str].extend(format_args))

	if (!endswith(str, "\x01"))
		str = format("%s\x01", str)

	if (!startswith(str, "\x01"))
		str = format("\x01%s", str)
	
	return str
}

/**
 * @param {float} time
 */
function CTFPlayer::SetAbilityTime( time )
{
	local weapon = GetAbilityWeapon()
	if (weapon)
		weapon.SetAbilityTime(time)
}
/**
 * @param {float} time
 */
function CTFPlayer::AddAbilityTime( time )
{
	local weapon = GetAbilityWeapon()
	if (weapon)
		weapon.AddAbilityTime(time)
}

function CTFPlayer::TeamFortress_SetSpeed()
{
	if (InCond(TF_COND_HALLOWEEN_SPEED_BOOST))
	{
		local duration = GetCondDuration(TF_COND_HALLOWEEN_SPEED_BOOST)
		__ORIGINAL_RemoveCondEx(TF_COND_HALLOWEEN_SPEED_BOOST, true)
		SetCond(TF_COND_HALLOWEEN_SPEED_BOOST, duration)
	}
	else
	{
		SetCond(TF_COND_HALLOWEEN_SPEED_BOOST)
		__ORIGINAL_RemoveCondEx(TF_COND_HALLOWEEN_SPEED_BOOST, true)
	}
}

function ROOT::GetGameText()
	return FindByName(null, "GlobalGameText") ? FindByName(null, "GlobalGameText") : SpawnEntityFromTable("game_text", {targetname = "GlobalGameText", holdtime = 0.5})

function CTFPlayer::DisplayHudText( msg = "", clr = false, pos = false, holdtime = false, channel = false )
{
	local text = GetGameText()
	local text_scope = GetScope(text)

	if (!("Last_Message" in text_scope))
		text_scope.Last_Message <- ""


	if (text_scope.Last_Message != msg) text.KeyValueFromString("message", msg)
	if (clr) text.KeyValueFromString("color", clr)
	if (pos)
	{
		text.KeyValueFromFloat("x", pos[0])
		text.KeyValueFromFloat("y", pos[1])
	}
	if (holdtime) text.KeyValueFromFloat("holdtime", holdtime)
	if (channel)	 text.KeyValueFromInt("channel", channel)
	
	text_scope.Last_Message = msg

	text.AcceptInput("Display", "", this, this)

	PurgeString(msg)
}

function CTFPlayer::CalculateEHP()
{
	local HP = GetHealth()

	local BlastMult = 1.0
	local BulletMult = 1.0
	local FireMult = 1.0
	local AllMult = 1.0
	local RangedMult = 1.0
	local MeleeMult = 1.0
	local CritMult = 1.0
	local CondMult = 1.0

	BlastMult 	*= HookMultAttributes("dmg taken from blast increased")
	BlastMult 	*= HookMultAttributes("dmg taken from blast reduced")

	BulletMult 	*= HookMultAttributes("dmg taken from bullets increased")
	BulletMult 	*= HookMultAttributes("dmg taken from bullets reduced")
	BulletMult 	*= HookMultAttributes("CARD: dmg taken from bullets reduced")
	BulletMult 	*= HookMultAttributes("SET BONUS: dmg taken from bullets increased")
			
	FireMult 	*= HookMultAttributes("dmg taken from fire increased")
	FireMult 	*= HookMultAttributes("dmg taken from fire reduced")
	FireMult 	*= HookMultAttributes("SET BONUS: dmg taken from fire reduced set bonus")

	AllMult 	*= HookMultAttributes("dmg taken increased")

	MeleeMult 	*= HookMultAttributes("mult dmgtaken from melee")

	CritMult 	*= HookMultAttributes("dmg taken from crit reduced")
	CritMult 	*= HookMultAttributes("dmg taken from crit increased")
	CritMult 	*= HookMultAttributes("SET BONUS: dmg taken from crit reduced set bonus")

	local weapon = GetActiveWeapon()
	if ( weapon )
	{
		FireMult *= weapon.GetMultAttribute("dmg taken from fire reduced on active")
		MeleeMult *= weapon.GetMultAttribute("dmg from melee increased")
		RangedMult *= weapon.GetMultAttribute("dmg from ranged reduced")

		AllMult *= weapon.GetMultAttribute("mult_dmgtaken_active")
	}
	
	// would love condition providers
	if (InMultiCond([TF_COND_MEDIGUN_UBER_FIRE_RESIST, TF_COND_MEDIGUN_SMALL_FIRE_RESIST]))
		FireMult = 0.0
	if (InMultiCond([TF_COND_MEDIGUN_UBER_BULLET_RESIST, TF_COND_MEDIGUN_SMALL_BULLET_RESIST]))
		BulletMult = 0.0
	if (InMultiCond([TF_COND_MEDIGUN_UBER_BLAST_RESIST, TF_COND_MEDIGUN_SMALL_BLAST_RESIST]))
		BlastMult = 0.0
		
	if (HasCritImmunity())
		CritMult = 0.0

	// Condition Mults
	CondMult *= GetRuneResistance()

	if (InCond(TF_COND_DEFENSEBUFF_HIGH))	//likely unused now
		CondMult *= 0.25
	else if (InMultiCond([TF_COND_DEFENSEBUFF, TF_COND_DEFENSEBUFF_NO_CRIT_BLOCK]))
		CondMult *= 0.65
	
	if (InCond(TF_COND_STEALTHED))
		CondMult *= IsCvarAllowed("tf_stealth_damage_reduction") ? GetCvarFloat("tf_stealth_damage_reduction") : 0.8

	if (IsMinicritDebuffed())
		CondMult *= MATH.Max(0, 1.0 + (0.35 * CritMult))

	if (IsInvincible())
		CondMult = -1.0 // dont want to use 0 as we are dividing

	AllMult = AllMult * CondMult

	if (AllMult == 0) 
		AllMult = -1.0 // dont want to use 0 as we are dividing

	local InfHP = "\x0700bbffInfinite"

	BulletMult = BulletMult * RangedMult
	BlastMult = BlastMult * RangedMult
	FireMult = FireMult * RangedMult


	local BulletHP 	= BulletMult 	<= 0 ? 0 : ceil(HP/BulletMult/AllMult).tointeger()
	local BlastHP 	= BlastMult 	<= 0 ? 0 : ceil(HP/BlastMult/AllMult).tointeger()
	local FireHP 	= FireMult 		<= 0 ? 0 : ceil(HP/FireMult/AllMult).tointeger()
	local MeleeHP 	= MeleeMult 	<= 0 ? 0 : ceil(HP/MeleeMult/AllMult).tointeger()
	// local RangedHP 	= RangedMult 	<= 0 ? 0 : ceil(HP/RangedMult/AllMult).tointeger()
	local AllHP 	= AllMult 		<= 0 ? 0 : ceil(HP/AllMult).tointeger()

	if (BulletHP <= 0) BulletHP = InfHP
	else BulletHP = BulletHP.tostring()

	if (BlastHP <= 0) BlastHP = InfHP
	else BlastHP = BlastHP.tostring()

	if (FireHP <= 0) FireHP = InfHP
	else FireHP = FireHP.tostring()

	if (MeleeHP <= 0) MeleeHP = InfHP
	else MeleeHP = MeleeHP.tostring()

	// if (RangedHP == 0) RangedHP = InfHP
	// else RangedHP = RangedHP.tostring()

	if (AllHP == 0) AllHP = InfHP
	else AllHP = AllHP.tostring()
	
	local formatstring 	=  "\x0800FF00B0 ** ( Counts Most Active Conditions ) **\n"
	
	formatstring 		+= "\x03Bullet: \x04%s \x01| \x03Blast: \x04%s \x01| \x03Fire: \x04%s \x01| \x03Melee: \x04%s \x01\n"
	formatstring 		+= "\x03Crit Resistance: \x04%s%%\x01\n"
	// formatstring 		+= "\x03Melee: \x04%s \x01" //| \x03Ranged: \x04%s\n"
	PrintToChatF(formatstring, BulletHP, BlastHP, FireHP, MeleeHP, ((1.0-CritMult) * 100).tostring()) /* , RangedHP */

	local Printed = false

	if (AllMult <= 0) {
		PrintToChat("\x07FFFF00* \x01You are currently \x07FFFF00unkillable \x01due to a \x0700bbffUniversal Damage Resistance\x01 of \x04100%")
		Printed = true
	}
		
	else if (MeleeMult <= 0 && RangedMult <= 0) {
		PrintToChat("\x07FFFF00* \x01You are currently \x07FFFF00unkillable \x01due to having \x04100%\x01 of both \x0700bbffRanged & Melee Resistance\x01")
		Printed = true
	}
		
	if (AllMult >= 0 && AllMult != 1 && Printed == false)
	{
		local message = ""
		if (AllMult <= 1.00) message = "\x0700bbffUniversal Damage Resistance"
		else 				message = "\x07ff4545Universal Damage Vulnerability"
		PrintToChatF("\x07FFFF00* \x01Your current base health \x04%i\x01 is effectively \x04%s\x01 due to a %s\x01 of \x04%.2f%%.", HP, AllHP, message, fabs(100-(AllMult*100.0)))
	}
}

function CTFPlayer::KillUnknownWeapons()
{
	local my_weps = GetMyWeaponsArray()
	for (local next, current = FirstMoveChild(); current != null; current = next)
	{
		EnableStringPurge(current)
		next = current.NextMovePeer()
		if (startswith(current.GetClassname(), "tf_wearable") || current.GetClassname() == "tf_viewmodel")
			continue
		if (my_weps.find(current) != null)
			continue
		printf("Destroyed unknown Move Child %s\n", current.tostring())
		current.Destroy()
	}
}

/** 
 * @returns {Corrosion}
 */
function CTFPlayer::GetCorrosion()
{
	if (!("Corrosion" in GetScope(this)))
		GetScope(this).Corrosion <- Corrosion(this)

	return GetScope(this).Corrosion
}

/** 
 * @returns {bool}
 */
function CTFPlayer::HasCorrosion()
	return GetCorrosion().HasCorrosion()

/**
 * @returns {bool}
 */
function CTFPlayer::ShouldRemoveCorrosion()
	return IsInvincible() /* || InRespawnRoom() */ || IsDead()

/**
 * Remove our Corrosion 
 */
function CTFPlayer::RemoveCorrosion()
	GetCorrosion().RemoveCorrosion()

if (!("__CORROSION_DEBUG" in ROOT))
	::__CORROSION_DEBUG <- false
/**
 * @param {CTFPlayer} 		attacker
 * @param {CTFWeaponBase} 	weapon
 */
function CTFPlayer::MakeCorrosion( attacker, weapon )
{
	if (IsInvincible())
	{
		RemoveCorrosion()
		return;
	}

	if (HasCorrosion())
		return

	if (__CORROSION_DEBUG) PrintToChatAll(format("Made Corrosion on %s", tostring()))

	SetColor("205 245 135")

	// if DmgPerc == 1.0 then it does 100% dmg
	// the default value is normally 0.25%

	/** @type {Corrosion} */
	local corrosion = GetCorrosion()

	corrosion.Enable()
	corrosion.CreateCorrosion(attacker, weapon)
}

function CTFPlayer::CanHaveCorrosion()
{
	if (HasCorrosion())
		return false
	if (ShouldRemoveCorrosion())
		return false
	if (!IsBot()) // maybe work for non bots?
		return false
	if (HasBotTag("NoCorrode"))
		return false
	return true
}

function IsGasNotValid( gas )
{
	return !GetScope(gas).Attacker || !GetScope(gas).Attacker.IsValid() || GetScope(gas).TimeCreated + 15 <= Time() || IsPointInRespawnRoom(gas.GetOrigin())
}

if (!("GasBombs" in ROOT))
	::GasBombs <- []

function CTFPlayer::MakeCorrosionPuddle()
{
	if (InRespawnRoom())
		return

	// 1. Cleanup invalid bombs
	for (local i = GasBombs.len() - 1; i >= 0; i--)
	{
		if (!GasBombs[i] || !GasBombs[i].IsValid())
			GasBombs.remove(i)
	}

	// 2. Enforce limit by killing the oldest bomb
	if (GasBombs.len() > 3)
	{
		// if your Time() var is above this, then GOD have mercy on you
		local lowest_time = 2e30
		local lowest_bomb_idx = -1
		
		foreach (idx, bomb in GasBombs)
		{
			local bomb_time = GetScope(bomb).TimeCreated
			if (bomb_time < lowest_time)
			{
				lowest_time = bomb_time
				lowest_bomb_idx = idx
			}
		}
		
		if (lowest_bomb_idx != -1)
		{
			local bomb = GasBombs[lowest_bomb_idx]
			if (bomb)
				GetScope(bomb).DestroyGasBomb()
			GasBombs.remove(lowest_bomb_idx)
		}
	}


	local Gasbomb = SpawnEntityFromTable("info_teleport_destination", {targetname = "GasBomb"})
	Gasbomb.SetAbsOrigin(GetOrigin())

	GasBombs.append(Gasbomb)

	local scope = GetScope(Gasbomb)
	local Corrosion = GetCorrosion()

	scope.Weapon 		<- Corrosion.hWeapon
	scope.Attacker 		<- Corrosion.hAttacker
	scope.TimeCreated 	<- Time()
	scope.Particle 		<- SpawnEntityFromTable("info_particle_system", {
		targetname = "GasParticle"
		effect_name = "corrosion_cloud_parent"
		start_active = 1
	})
	scope.Particle.SetAbsOrigin(GetOrigin()+Vector(0, 0, 40))

	local function GasBombThink() {
		if (!self || !self.IsValid())
		{
			if (Particle && Particle.IsValid())
			{
				Particle.AcceptInput("Stop", "", null, null)
				Particle.Destroy()
			}
			
			local idx = GasBombs.find(self)
			if (idx != null) GasBombs.remove(idx)
			return 500
		}

		if (IsGasNotValid(self))
		{
			DestroyGasBomb()
			return 500
		}
		foreach (bot in GetAllPlayers(TF_TEAM_PVE_INVADERS, [self.GetOrigin(), 75], true))
			bot.MakeCorrosion(Attacker, Weapon)
		DebugDrawSphere(self.GetOrigin(), Vector(0, 0, 255), 75, false, 0.15)
		return 0.1
	}

	scope.GasBombThink <- GasBombThink

	local function DestroyGasBomb() {
		local idx = GasBombs.find(self)
		if (idx != null) GasBombs.remove(idx)

		if (Particle && Particle.IsValid())
		{
			Particle.AcceptInput("Stop", "", null, null)
			Particle.Destroy()
		}
				
		self.Destroy()
	}

	scope.DestroyGasBomb <- DestroyGasBomb

	AddThinkToEnt(Gasbomb, "GasBombThink")
	return Gasbomb
}

function CTFPlayer::RollSpell()
{
	local spellbook = GetSpellBook()
	if (!spellbook)
		return
	if (spellbook.GetSpellCharges() != 0)
		return
	spellbook.SetSpellIndex(TF_SPELL_UNKNOWN)
	RunWithDelay(2.1, @() spellbook.SetRandomSpell())
}

/*	PrintTime = {
		owner = player
		func = function( self ) {
			// self is the player, "this" is the table above
			self.PrintToHud(Time())
			return 0.995
		}
	}
	Heal = {
		func = function( self ) {
			self.SetHealth(self.GetHealth() + (self.GetMaxHealth() /10))
			if (self.GetHealth() > self.GetMaxHealth() * 1.5)
			self.SetHealth(self.GetMaxHealth()*1.5)
			return 1
		}
	} 	
*/

function CTFPlayer::SetUpThinkTable()
{
	local scope = GetScope(this)
	if ("ThinkTable" in scope)
		scope.ThinkTable.clear()
	else
		scope.ThinkTable <- {}
		
	local function PlayerThinkTableThink() {
		foreach (_, func_table in ThinkTable)
		{
			if (func_table.NextThinkTime <= Time())
			{
				local result = func_table.func.call(this)
				try { result.tofloat() }
				catch (e) { result = -1	}
				func_table.NextThinkTime = Time() + result
			}
		}
		return -1
	}
	scope.PlayerThinkTableThink <- PlayerThinkTableThink

	AddThinkToEnt(this, "PlayerThinkTableThink")
	if (!("PreservedThinks" in scope))
		GetScope(this).PreservedThinks <- {}
}
/**
 * Adds a Preserved think to the think table that stays after spawning / resupplying
 * 
 * In the think `self` is the player
 * and `this` is the players scope.
 * 
 * @param {function} 	func 		The Think Function.
 * @param {string|null} name 		The Think function name in the ThinkTable ( used for removing a think ). ( Default: null )
 * @param {float} 		offset 		Time offset of the first Think. (Default: 0.0)
 * @returns {string}
 */
function CTFPlayer::AddPreservedThink( func, name = null, offset = 0.0 )
{
	name = name||UniqueString()
	AddThink(func, name, offset)
	GetScope(this).PreservedThinks[name] <- {
		func = func
		offset = offset
	}
	return name
}
/**
 * Adds a think to the think table
 * 
 * In the think `self` is the player
 * and `this` is the players scope.
 * 
 * @param {function} 	func 		The Think Function.
 * @param {string|null} name 		The Think function name in the ThinkTable ( used for removing a think ). ( Default: null )
 * @param {float} 		offset 		Time offset of the first Think. (Default: 0.0)
 * @returns {string}
 */
function CTFPlayer::AddThink( func, name = null, offset = 0.0 )
{
	if (!("ThinkTable" in GetScope(this)))
		SetUpThinkTable()
		
	name = name||UniqueString()
	GetScope(this).ThinkTable[name] <- {
		func = func
		NextThinkTime = Time() + offset
	}
	return name
}
/**
 * @param {string} name
 */
function CTFPlayer::RemoveThink( name )
{
	if (IsNotInScope("ThinkTable", GetScope(this)))
		SetUpThinkTable()
	if (name in GetScope(this).PreservedThinks)
		delete GetScope(this).PreservedThinks[name]
	if (name in GetScope(this).ThinkTable)
		delete GetScope(this).ThinkTable[name]
}
/**
 * @returns {bool}
 */
function CTFPlayer::DiedWithAbility()
	return "DiedWithAbility" in GetScope(this) && GetScope(this).DiedWithAbility == true

function CTFPlayer::FixAmmo()
{
	// if this happens then all shit goes out
	if (!this||!IsValid())
		return
	ResetAmmo()
	foreach (weapon in GetAllWeapons())
	{
		if (weapon.IsWearable())
			continue
		weapon.SetClip1(0)
		if (weapon.HasAdditiveAttribute("auto fires full clip penalty") || weapon.HasAdditiveAttribute("auto fires full clip"))
			weapon.SetClip1(0)
		else 
			weapon.SetClip1(weapon.GetMaxClip1())

		if (weapon.HasAdditiveAttribute("mod use metal ammo type"))
			SetPropInt(weapon, "m_iPrimaryAmmoType", TF_AMMO_METAL)

		if (weapon.HasAdditiveAttribute("throwable starts empty"))
			SetThrowableAmmo(0)
		if (weapon.HasAdditiveAttribute("throwable start charge"))
			SetThrowableCharge(weapon.GetAttribute("throwable start charge", 0))
			

		// Deprecated soon
		if (weapon.HasAdditiveAttribute("item_meter_starts_empty_DISPLAY_ONLY") && weapon.GetAttribute("item_meter_charge_type_3_DISPLAY_ONLY", 0) != 1)
		{
			SetThrowableAmmo(0)
			SetThrowableCharge(weapon.GetAttribute("item_meter_starts_empty_DISPLAY_ONLY", 0).tointeger())
		}
	}
}

function CTFPlayer::RemoveWearables()
{	// Kill all the Children
	for (local child = FirstMoveChild(); child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)
		if (!startswith(child.GetClassname(), "tf_wearable")) continue
		// do not kill wearables if they are needed for weapons!
		if (IsInArray(child.GetIDX(), WearableIDXs.Primarys) || IsInArray(child.GetIDX(), WearableIDXs.Secondarys))
			continue
		
		EntFireNew(child, "Kill")
	}
}

function CTFPlayer::GetMoveChildren()
{
	local children = []
	for (local child = FirstMoveChild(); child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)
		children.append(child)
	}
	return children
}

function CTFPlayer::GetMoveChildrenWeapons()
{
	local children = []
	for (local child = FirstMoveChild(); child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)
		if (IsWeaponClass(child, "tf_weap", true))
			children.append(child)
	}
	return children
}

function CTFPlayer::TransformGHeavy()
{
	if (!this||!IsValid())
		return
	local scope = GetScope(this)
	if ("HeavyTransform" in scope)
		scope.HeavyTransform = true
	else
		scope.HeavyTransform <- true
}

function CTFPlayer::UndoGHeavy()
{
	if (!this||!IsValid())
		return
	local scope = GetScope(this)
	if ("HeavyTransform" in scope)
		scope.HeavyTransform = false
	else
		scope.HeavyTransform <- false
}

function CTFPlayer::IsGHeavy()
	return "HeavyTransform" in GetScope(this) && GetScope(this).HeavyTransform
/**
 * @param {string} ItemName			Internal Item name in items_game.txt
 * @param {bool} swit
 * @param {table} attrib_overrides
 * @param {bool} IsCustom			if this item is from Rafmods `CustomWeapon` block
 */
function CTFPlayer::EquipItem( ItemName, swit = true, attrib_overrides = {}, IsCustom = false )
{
	if (IsCustom)
	{
		AcceptInput("$GiveItem", ItemName, this, this)
		return
	}
	local old_weapons = GetMoveChildrenWeapons()
	local new_item = EquipItemBAD(ItemName)
	if (type(new_item) == "array")
	{
		if (new_item.len() == 0)
			return PrintToChat("\x07FF0000Uh Oh something fucked up")
		new_item = new_item[0]
	}
	local old_item = null
	foreach (wep in old_weapons)
	{
		if (IsWeaponClass(wep, "tf_weap", true) && wep.GetSlot() == new_item.GetSlot())
		{
			old_item = wep
			break
		}
	}

	if (new_item != old_item && old_item)
		old_item.Destroy()

	foreach (attrib, value in attrib_overrides)
	{
		if (type(value) == "string")
		{
			printf("Warning: Cannot apply attribute \"%s\" with value \"%s\"!", attrib, value)
			continue
		}
		new_item.AddAttribute(attrib, value, 0)
	}

	local type = GetPropInt(new_item, "m_iPrimaryAmmoType")
	if (type != -1)
		GivePercentAmmo(type, 100)

	if (swit)
		Weapon_Switch(new_item)

	return

/* 	local weapon = SpawnEntityFromTable(classname, {})

	if (!weapon)
		return

	SetPropInt(weapon, PROP_ITEM_DEF_IDX, idx)
	SetPropBool(weapon, "m_bValidatedAttachedEntity", true)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 1)
	weapon.SetTeam(GetTeam())

	foreach (attrib, value in attrib_overrides)
	{
		weapon.AddAttribute(attrib, value, 0)
	}

	weapon.DispatchSpawn()


	local old_wep = GetWeaponInSlotNew(weapon.GetSlot())
	if (old_wep)
		old_wep.Destroy() */
	/* else if (old_wep && !old_wep.IsWearable())
	{
		local myweaps_idx = GetMyWeaponsArray().find(old_wep)

		old_wep.Destroy()

		if (myweaps_idx != null)
			SetPropEntity(this, "m_hMyWeapons", null, myweaps_idx)
	} */

	/* if (myweaps_idx == null)
	{
		for (local i = 0; i <= MAX_WEAPONS; i++)
		{
			local w = GetPropEntityArray(this, "m_hMyWeapons", i)
			if (w == null || !w.isvalid())
			{
				myweaps_idx = i
				break
			}
		}
	} */

	// Weapon_Equip(weapon)
	// if (swit)
		// Weapon_Switch(weapon)

	// FixAmmo()
}

/* function CTFPlayer::EquipWearableItem( idx, classname_override = false, attrib_overrides = {} )
{
	local dummy = CreateByClassname( "tf_weapon_parachute" )
	SetPropInt( dummy, PROP_ITEM_DEF_IDX, 1101 )
	SetPropBool( dummy, "m_AttributeManager.m_Item.m_bInitialized", true )
	dummy.SetTeam( GetTeam() )
	dummy.DispatchSpawn()
	dummy.SetModelSimple("")
	Weapon_Equip( dummy )

	// SetPropString( dummy, "m_iName", format( "dummy_%d", dummy.entindex() ) )

	local wearable = GetPropEntity( dummy, "m_hExtraWearable" )
	dummy.Kill()

	// SetPropString( wearable, "m_iName", format( "werable_%d", wearable.entindex() ) )

	wearable.SetTeam(GetTeam())
	SetPropInt( wearable, PROP_ITEM_DEF_IDX, idx )
	SetPropBool( wearable, "m_AttributeManager.m_Item.m_bInitialized", true )
	SetPropBool( wearable, "m_bValidatedAttachedEntity", true )

	if (classname_override)
		wearable.KeyValueFromString("classname", classname_override)

	printl(wearable.GetClassname())

	wearable.DispatchSpawn()

	printl(wearable.GetClassname())

	wearable.SetModelSimple(GetItemModelName(idx))

	if (classname_override)
		wearable.KeyValueFromString("classname", classname_override)

	wearable.SetTeam(GetTeam())

	SendGlobalGameEvent( "post_inventory_application", { userid = GetUserID(), early_out = true} )
	wearable.SetOwner(this)

	Weapon_Switch(GetWeaponInSlotNew(SLOT_MELEE))

	PrintToChat(wearable)
	return wearable
} */

/**
 * @param {string} ItemName
 * @returns {CTFWeaponBase|[CTFWeaponBase]|null}
 * 
 * @throws if the weapon generated was invalid
 */
function CTFPlayer::EquipItemBAD( ItemName )
{
	local OldWeapons = GetMoveChildrenWeapons()
	AddEFlags(EFL_NO_MEGAPHYSCANNON_RAGDOLL)  // prevent inf resupply loop
	GenerateAndWearItem(ItemName)
	RemoveEFlags(EFL_NO_MEGAPHYSCANNON_RAGDOLL)
	local NewWeapons = GetMoveChildrenWeapons()

	// PrintArray(OldWeapons)
	// PrintArray(NewWeapons)

	local differ = []

	foreach (wep in NewWeapons)
	{
		if (OldWeapons.find(wep) == null)
			differ.append(wep)
	}

	if (differ != 1)
		throw "No Weapon Found, Shit messed up!"
	else
		return differ[0]
}

function CTFPlayer::GetActiveHealers()
{
	local healers = []
	local array = player.GetTeam() == TF_TEAM_PVE_DEFENDERS ? m_aHumans : m_aRobots
	foreach (player in array)
	{
		if (player.GetPlayerClass() != TF_CLASS_MEDIC)
			continue
		if (player.GetHealTarget() != this)
			continue
		healers.append(player)
	}
	return healers
}
/**
 * @param {float} start
 * @returns {float}
 */
function CTFPlayer::GetOverHealCapMult( start = 1.0 )
{
	local cap_mult = start
	cap_mult *= HookMultAttributes("patient overheal penalty")
	cap_mult *= GetActiveWeapon().GetAttribute("mult_patient_overheal_penalty_active", 1.0)
	return cap_mult
}
/**
 * @param {integer|float} amount
 * @param {float|bool} overheal
 */
function CTFPlayer::HealPlayer( amount, overheal = false, display = true, type = T_HEAL_NONE )
{
	local mult = 1.0
	mult *= HookMultAttributes("healing received penalty")
	mult *= HookMultAttributes("healing received bonus")

	if (type == T_HEAL_HEALER)
	{
		mult *= HookMultAttributes("health from healers reduced")
		mult *= HookMultAttributes("health from healers increased")
		mult *= HookMultAttributes("reduced_healing_from_medics")
		mult *= GetActiveWeapon().GetAttribute("mult_health_fromhealers_penalty_active", 1.0)
		if (HookAdditiveAttributes("mod weapon blocks healing"))
			return // Cannot be healed
	}
	else if (type == T_HEAL_PACK) 
	{
		mult *= HookMultAttributes("health from packs increased")
		mult *= HookMultAttributes("health from packs decreased")
	}

	amount *= mult

	amount = amount.tointeger()

	if (overheal != false && overheal == 1.0 || overheal == true)
		AddHealth(amount)
	else if (overheal != false && overheal > 1.0)
	{
		local max = (GetMaxHealth() * GetOverHealCapMult(overheal.tofloat())).tointeger()
		AddHealth(amount)
		if (GetHealth() > max)
		{
			amount = GetHealth() - max
			SetHealth(max)
		}
	}
	else if (GetHealth() >= GetMaxHealth())
	{
		amount = 0
	}
	else if (GetHealth()+amount >= GetMaxHealth())
	{
		AddHealth(amount)
		amount -= (GetHealth() - GetMaxHealth())
		SetHealth(GetMaxHealth()) // this nukes overheal tbh
	}
	else 
		AddHealth(amount)


	if (display)
		SendGlobalGameEvent("player_healonhit", {
			entindex = entindex()
			amount = amount
			manual = true
		})
}
/**
 * @param {string} attribute
 * @returns {float}
 */
function CTFPlayer::HookMultAttributes( attribute, Mode = 3, def_plr = 1.0, def_wep = 1.0 )
{
	local amount = 1.0
	if (MATH.HasBitFlag(Mode, 1))
		amount *= GetCustomAttribute(attribute, def_plr)
	if (MATH.HasBitFlag(Mode, 2))
	{
		foreach (weapon in GetAllWeapons())
		{
			if (weapon.GetAttribute("provide on active", 0) && weapon != GetActiveWeapon())
				continue
			amount *= weapon.GetAttribute(attribute, def_wep)
		}
	}

	return amount
}
/**
 * @param {string} attribute
 * @returns {float}
 */
function CTFPlayer::HookAdditiveAttributes( attribute, Mode = 3, def_plr = 0, def_wep = 0 )
{
	local amount = 0.0
	if (MATH.HasBitFlag(Mode, 1))
		amount += GetCustomAttribute(attribute, def_plr)
	if (MATH.HasBitFlag(Mode, 2))
	{
		foreach (weapon in GetAllWeapons())
		{
			if (weapon.GetAttribute("provide on active", 0) && weapon != GetActiveWeapon())
				continue
			amount += weapon.GetAttribute(attribute, def_wep)
		}
	}

	return amount
}
/**
 * @param {integer|bool} classidx
 */
function CTFPlayer::GetBaseMovespeed( classidx = false )
{
	switch (classidx||GetPlayerClass()) 
	{
	case TF_CLASS_SCOUT: 		return 400
	case TF_CLASS_SOLDIER: 		return 240
	case TF_CLASS_PYRO: 		return 300
	case TF_CLASS_DEMOMAN: 		return 280
	case TF_CLASS_HEAVYWEAPONS: return 230
	case TF_CLASS_ENGINEER: 	return 300
	case TF_CLASS_MEDIC: 		return 320
	case TF_CLASS_SNIPER: 		return 300
	case TF_CLASS_SPY: 			return 320
	default: 					return 300
	}
	return -1
}
/**
 * @returns {float}
 */
function CTFPlayer::GetMoveSpeed()
{
	local BaseSpeed = GetBaseMovespeed()
	if ( InCond( TF_COND_DISGUISED ) && !IsStealthed() )
		BaseSpeed = MATH.Min(GetBaseMovespeed( GetPropInt(this, "m_Shared.m_nDisguiseClass") ), BaseSpeed)
	local speed = BaseSpeed

	local active = GetActiveWeapon()

	if ( InCond( TF_COND_AIMING ) )
	{
		local AimMax = 0

		if ( GetPlayerClass() == TF_CLASS_HEAVYWEAPONS )
			AimMax = 110
		else if ( active && active.IsBow() )
			AimMax = 160
		else
			AimMax = 80

		if ( active )
		{
			AimMax *= active.GetAttribute("aiming movespeed increased", 1)
			AimMax *= active.GetAttribute("aiming movespeed decreased", 1)
			AimMax *= active.GetAttribute("sniper aiming movespeed decreased", 1)
		}

		speed = MATH.Min( speed, AimMax )
	}

	local WhipBoost = 105.0
	if ( IsConvarAllowed("tf_whip_speed_increase") )
		WhipBoost = GetCvarFloat("tf_whip_speed_increase")


	if ( InCond( TF_COND_SPEED_BOOST ) && speed > 0.0)
		speed += MATH.Min( speed * 0.4, WhipBoost )

	if ( active )
		speed *= active.GetSpeedMod()

	if ( GetPlayerClass() == TF_CLASS_DEMOMAN )
	{
		local Sword = GetWeaponClassname("tf_weapon_sword")
		if ( Sword )
			speed *= Sword.GetSwordSpeedMod()
	}
	if ( InCond( TF_COND_SHIELD_CHARGE ) )
		speed = (IsConvarAllowed("tf_max_charge_speed") && GetCvarFloat("tf_max_charge_speed")) ? GetCvarFloat("tf_max_charge_speed") : 750.0

	if ( !IsMannVsMachineMode() && GetPropBool(this, "m_Shared.m_bCarryingObject") )
		speed *= 0.9

	speed *= HookMultAttributes("move speed bonus")
	speed *= HookMultAttributes("move speed penalty")

	if ( GetPropBool(this, "m_Shared.m_bShieldEquipped") )
		speed *= HookMultAttributes("move speed bonus shield required")

	if ( GetPlayerClass() == TF_CLASS_MEDIC && active )
	{
		// QuickFix stuff
		local flClassResourceLevelMod = active.GetAttribute("move speed bonus resource level", 1.0)
		if ( flClassResourceLevelMod != 1.0 )
		{
			local Medigun = GetWeaponClassname("tf_weapon_medigun")
			if ( Medigun )
				speed *= RemapValClamped( Medigun.GetUberChargePercent(), 0.0, 1.0, 1.0, flClassResourceLevelMod );
		}
	}

	if ( GetPlayerClass() == TF_CLASS_HEAVYWEAPONS && InCond( TF_COND_ENERGY_BUFF ))
	{
		speed *= 1.3;
		MATH.Clamp(speed, 0, BaseSpeed * 1.35)
	}

	if ( GetPlayerClass() == TF_CLASS_SCOUT )
	{	
		local wep = GetWeapon(TF_WEAPON_BABYFACE)
		if ( wep )
			speed *= RemapValClamped( GetScoutHypeMeter(), 0.0, 100.0, 1.0, 1.45 )
	}

	if ( GetCurrentRune() == RUNE_HASTE )
		speed *= 1.3
	if ( GetCurrentRune() == RUNE_AGILITY )
	{
		// light classes get more benefit due to movement speed cap of 520 
		switch ( GetPlayerClass() )
		{
		case TF_CLASS_DEMOMAN:
		case TF_CLASS_SOLDIER:
		case TF_CLASS_HEAVYWEAPONS:
			speed *= 1.4
			break;
		default:
			speed *= 1.5
			break;
		}
	}
	return speed
}
// TODO: Add to Snippets
/**
 * @param {Vector|CBaseEntity} thing
 * @param {bool} center Use center of target instead of origin
 * @returns {float}
 */
function CTFPlayer::DistanceTo( thing, center = false)
{
	if (typeof thing == "Vector")
		return GetOrigin().DistanceTo(thing)
	else if (center)
		return GetCenter().DistanceTo(thing.GetCenter())
	else
		return GetOrigin().DistanceTo(thing.GetOrigin())
}
// TODO: Add to Snippets
/**
 * @returns {CTFPlayer|null}
 */
function CTFPlayer::GetClosestPlayer( team = null, skip = 0)
{
	if (team == null)
		team = GetTeam()
	return GetClosestPlayer(this, team, skip)
}
// TODO: Add to Snippets
/**
 * @param {string} particle
 */
function CTFPlayer::AttachParticle( particle, duration = -1, attachment_point = PATTACH_ABSORIGIN_FOLLOW, attachment_name = "" )
{
	AttachEntityParticle(this, particle, attachment_point, attachment_name)
	if (duration > 0)
		PlayerFire("DispatchEffect", "ParticleEffectStop", duration)
}
/** 
 * Emit a sound to this client only
 * 
 * @param {string} sound
 * @param {table} data
 */
function CTFPlayer::EmitSoundTo( sound, data = {} )
{
	PrecacheSound(sound)
	// is Likely a soundscript, and not Raw Sound
	// if (sound.find(".wav") == null && sound.find(".mp3") == null && sound.find(".ogg") == null)
	// {
	// 	EmitSoundOnClient(sound, this)
	// 	return
	// }

	local sound_data = {
		sound_name = sound
		filter_type = RECIPIENT_FILTER_SINGLE_PLAYER
		entity = this
	}
	if ("channel" in data) 		sound_data.channel <- data.channel
	if ("volume" in data) 		sound_data.volume <- data.volume
	if ("sound_level" in data) 	sound_data.sound_level <- data.sound_level
	if ("flags" in data) 		sound_data.flags <- data.flags
	if ("pitch" in data) 		sound_data.pitch <- data.pitch
	if ("special_dsp" in data) 	sound_data.special_dsp <- data.special_dsp
	if ("delay" in data) 		sound_data.delay <- data.delay
	if ("sound_time" in data) 	sound_data.sound_time <- data.sound_time
	EmitSoundEx(sound_data)
}

function CTFPlayer::PrintConds()
{
	for (local cond = 0; cond <= TF_COND_RANGE; cond++)
		printl("In Cond "+cond+"? "+InCond(cond))
}
/**
 * @param {integer} slot
 */
function CTFPlayer::StripItemSlot( slot )
{
	if (slot == 0)
		return
	slot = slot.tointeger()
	local bit = @(a, b) MATH.HasBitFlag(a,b)
	local wep = null
	if (bit(slot, STRIPSLOT_PRIMARY))
	{
		wep = GetWeaponInSlotNew(SLOT_PRIMARY)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_SECONDARY))
	{
		wep = GetWeaponInSlotNew(SLOT_SECONDARY)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_MELEE))
	{
		wep = GetWeaponInSlotNew(SLOT_MELEE)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_PDA))
	{
		wep = GetWeaponInSlotNew(SLOT_PDA)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_PDA2))
	{
		wep = GetWeaponInSlotNew(SLOT_PDA2)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_ACTION))
	{
		wep = GetWeaponInSlotNew(SLOT_UTILITY)
		if (wep)
			wep.Destroy()
	}
	if (bit(slot, STRIPSLOT_COSMETICS))
		RemoveWearables()

	// update speed from removed items
	RunWithDelay(TEN_TICKS, @() TeamFortress_SetSpeed())
}

function CTFPlayer::CanStomp()
{
	foreach (wep in GetAllWeapons())
	{
		if (wep.CanStomp())
			return true
	}
	return false
}
/**
 * @returns {CTFWeaponBase|[CTFWeaponBase]|null}
 */
function CTFPlayer::GetStompWeapon()
{
	local weps = []
	foreach (wep in GetAllWeapons())
	{
		if (wep.CanStomp())
			weps.append(wep)
	}
	if (weps.len() == 0)
		return null
	else if (weps.len() == 1)
		return weps[0]
	else
		return weps
}
/**
 * @return {[CTFWeaponBase|CEconEntity]}
 */
function CTFPlayer::GetWearables()
{
	local wearables = []
	for (local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
	{
		if (wearable.GetClassname() != "tf_wearable")
			continue
		wearables.append(wearable)
	}
	return wearables
}

/**
 * @return {CTFWeaponBase|CEconEntity|null}
 */
function CTFPlayer::GetWearableByIDX( idx )
{
	local wearables = GetWearables()
	foreach (wearable in wearables)
	{
		if (wearable.GetIDX() == idx)
			return wearable
	}
	return null
}

::TF_CAN_ATTACK_FLAG_GRAPPLINGHOOK <- 0x01

function CTFPlayer::CanAttack( CanAttackFlags = 0 )
{
	if ( IsViewingCYOAPDA() )
		return false

	if ( HasPasstimeBall() )  // Always allow throwing the ball.
		return true

	if ( ( GetStealthNoAttackExpireTime() > Time() && !InCond( TF_COND_STEALTHED_USER_BUFF ) ) || InCond( TF_COND_STEALTHED ) )
	{
		if ( !( CanAttackFlags & TF_CAN_ATTACK_FLAG_GRAPPLINGHOOK ) )
			return false;
	}

	if ( IsFeignDeathReady() )
		return false;

	if ( IsTaunting() )
		return false;

	if ( InCond( TF_COND_PHASE ) == true )
		return false;

	if ( ( GetRoundState() == GR_STATE_TEAM_WIN ) && ( GetWinningTeam() != GetTeam() ) )
		return false;

	if ( InCond( TF_COND_HALLOWEEN_KART ) )
		return false;

	if ( GetCustomAttribute("no_attack", 0) != 0 || (GetActiveWeapon() && GetActiveWeapon().GetAttribute("no_attack", 0) != 0))
		return false

	return true
}

function CTFPlayer::IsTruceValidForEnt()
{
	if ( InRespawnRoom() )
		return false;

	return true;
}

function IsTruceValidForEnt( entity )
{
	if (!entity)
		return false
	else if (entity.IsPlayer())
		return entity.IsTruceValidForEnt()
	else if (entity.GetClassname() == "obj_sentrygun")
		return true
	else
		return GetPropBool(entity, "m_bTruceValidForEnt")
}

function CTFPlayer::ApplyGenericPushbackImpulse( Force, Attacker )
{
	if ( GetCurrentRune() == RUNE_KNOCKOUT || IsImmuneToPushback() )
		return

	if ( Attacker && IsTruceActive() && IsTruceValidForEnt(Attacker) )
	{
		if ( ( Attacker.GetTeam() == TF_TEAM_RED ) || ( Attacker.GetTeam() == TF_TEAM_BLUE ) )
			return
	}
	
	local flScale = 1.0
	flScale *= HookMultAttributes("airblast vulnerability multiplier")
	flScale *= HookMultAttributes("airblast vulnerability multiplier hidden")
	Force *= flScale;

	// if on the ground, require min force to boost you off it
	if ( ( GetFlags() & FL_ONGROUND ) && ( Force.z < TF_JUMP_MIN_SPEED ) )
	{
		Force.z = TF_JUMP_MIN_SPEED
	}
	
	Force.z *= HookMultAttributes("airblast vertical vulnerability multiplier")

	RemoveFlag( FL_ONGROUND )
	AddCondEx(TF_COND_KNOCKED_INTO_AIR, -1, Attacker)

	ApplyAbsVelocityImpulse( Force )
}

/**
 * @param {float} val
 * @param {bool} bForce
 */
function CTFPlayer::AddToSpyCloakMeter( val, bForce )
{
	/**@type {CTFWeaponBase} */
	local watch = GetWeaponClassname("tf_weapon_invis")
	if ( !watch )
		return false;

	if ( !bForce )
	{
		local iNoItemRegen = watch.GetAttribute("mod_cloak_no_regen_from_items", 0)
		if ( iNoItemRegen )
			return false

		// STAGING_SPY
		// Special cloaks only get cloak if not active and receive a smaller portion
		local iNoCloakedPickup = watch.GetAttribute("NoCloakWhenCloaked", 0)
		if ( InCond( TF_COND_STEALTHED ) && iNoCloakedPickup )
			return false
		else
			val *= watch.GetAttribute("ReducedCloakFromAmmo", 1.0)
	}

	local bResult = ( val > 0 && GetSpyCloakMeter() < 100.0 )

	SetSpyCloakMeter( MATH.Clamp( m_flCloakMeter + val, 0.0, 100.0 ))

	return bResult
}

/** 
 * @type {function}
 * @param {CTFPlayer} pTFAttacker
 * @returns {bool}
 */
function CTFPlayer::CheckBlockBackstab( pTFAttacker )
{
	// Resistance blocks backstabs before any items are checked
	if ( GetCurrentRune() == RUNE_RESIST )
		return true

	// Check all items for the attribute that blocks a backstab.
	// Destroy the first item that intercepts the backstab.

	local iBackStabShield = 0
	local ValidWeapon = null
	foreach (/**@type {CTFWeaponBase} */weapon in GetAllWeapons())
	{
		if (weapon.GetAttribute("backstab shield", 0))
		{
			iBackStabShield = 1
			ValidWeapon = weapon
			break
		}
	}
	if (iBackStabShield && ValidWeapon)
	{
		if ((GetPropInt(ValidWeapon, "m_fEffects") & EF_NODRAW) != EF_NODRAW)
		{
			if (ValidWeapon.IsWearable())
			{
				SetPropInt(ValidWeapon, "m_fEffects", GetPropInt(ValidWeapon, "m_fEffects") | EF_NODRAW)
				SetRazorbackCharge(0.0)
			}

			if (IsBot())
				DelayedThreatNotice(pTFAttacker, 0.5)

			return true
		}
	}

	return false;
}


function CTFPlayer::AddTmpDamageBonus( flBonus, flExpiration )
{
	AddCondEx( TF_COND_TMPDAMAGEBONUS, flExpiration, this )
	SetInternalVar("m_flTmpDamageBonusAmount", GetInternalVar("m_flTmpDamageBonusAmount", 1.0) + flBonus)
}

function CTFPlayer::GetInternalVar( var_name, def = 0 )
{
	if (!("Internal_Vars" in GetScope(this)))
		GetScope(this).Internal_Vars <- {}
	if (!(var_name in GetScope(this).Internal_Vars))
		GetScope(this).Internal_Vars[var_name] <- def

	return GetScope(this).Internal_Vars[var_name]
}

function CTFPlayer::SetInternalVar( var_name, value )
{
	GetInternalVar(var_name) // cheeky to fix it up so its not missing
	GetScope(this).Internal_Vars[var_name] = value
}

function CTFPlayer::UseGiantModel( buster = false )
{
	StripItemSlot(STRIPSLOT_COSMETICS)
	if (buster)
	{
		if (GetTeam() == TF_TEAM_RED)
			PlayerFire("SetCustomModelWithClassAnimations", "models/bots/demo/red_sentry_buster_v2.mdl", FIVE_TICKS)
		else
			PlayerFire("SetCustomModelWithClassAnimations", "models/bots/demo/bot_sentry_buster.mdl", FIVE_TICKS)
	}
	else
	{
		local pClass = GetPlayerClass()
		if (pClass == TF_CLASS_SNIPER || pClass == TF_CLASS_ENGINEER || pClass == TF_CLASS_MEDIC || pClass == TF_CLASS_SPY)
			return UseRobotModel()

		local name = GetPlayerModelPath()
		local model_name = format("models/bots/%s_boss/bot_%s_boss.mdl", name, name)
		// printf("Trying to apply Model \"%s\" to player\n", model_name)

		PlayerFire("SetCustomModelWithClassAnimations", model_name, FIVE_TICKS)
	}
}

function CTFPlayer::UseRobotModel()
{
	StripItemSlot(STRIPSLOT_COSMETICS)
	local name = GetPlayerModelPath()
	PlayerFire("SetCustomModelWithClassAnimations", format("models/bots/%s/bot_%s.mdl", name, name), FIVE_TICKS)
}

function CTFPlayer::ShouldDetonate()
{
	if (!this || !IsValid())
		return
	if (swap2(GetPropInt(this, "m_Shared.m_unTauntSourceItemID_Low")) != 65535) // stupid fucking logic
		return
	RunWithDelay(1.9, @() SentryBusterExplode())
}

function CTFPlayer::SentryBusterExplode()
{
	if (!this || !IsValid() || IsDead())
		return
	CreateSentryBusterExplosion({
		owner = this
		center = GetCenter()
	})

	Suicide()
}

function CTFPlayer::MakeBleed( attacker, weapon, duration = -1.0, damage = 4, permanent = false, dmg_type = 34 )
{
	if (!("MakeBleedInternal" in CTFPlayer))
		throw "Cant use CTFPlayer::MakeBleed without CTFPlayer::MakeBleedInternal"
	if (duration == -1.0 && permanent == false)
		permanent = true
	MakeBleedInternal(attacker, weapon, duration, damage, permanent, dmg_type)
}

/** 
 * @returns {CBaseEntity|null}
 */
function ROOT::GetHudHint()
	return FindByName(null, "GlobalHudHint") ? FindByName(null, "GlobalHudHint") : SpawnEntityFromTable("env_hudhint", {targetname = "GlobalHudHint", spawnflags = 0})

//TODO: Use a THINK to handle re sending and ending
function CTFPlayer::DisplayHudHint( text, duration = 10.0, flash = true, Hide = true )
{
	local hint_ent = GetHudHint()
	local hint_scope = GetScope(hint_ent)

	if (!("message" in hint_scope))
		hint_scope.message <- ""

	if (hint_scope.message != text) 
		hint_ent.KeyValueFromString("message", text)
	hint_scope.message = text


	hint_ent.AcceptInput("ShowHudHint", "", this, this)
	if (Hide)
		EntFireNew(hint_ent, "HideHudHint", "", duration, this, this)

	if (flash == true && duration > 2)
		RunWithDelay(2, @() DisplayHudHint(text, duration-2, flash, false))
	else if (duration > 10 && flash == false)
		RunWithDelay(10, @() DisplayHudHint(text, duration-10, flash, false))
}

if (!("_GetCustomAttribute" in CTFPlayer))
{
	CTFPlayer._GetCustomAttribute <- CTFPlayer.GetCustomAttribute
	CTFBot._GetCustomAttribute <- CTFBot.GetCustomAttribute
	/**
	 * Modified version that can hook our custom attributes
	 * @param {string} attrib
	 * @param {float} def
	 * @returns {float}
	 */
	function CTFPlayer::GetCustomAttribute( attrib, def )
	{
		if (!this || !this.IsValid())
			return 0
		if (GET_CUSTOM_ATTRIBUTE(attrib))
		{
			local ret_value = _GetCustomAttribute(attrib, def)
			local attrib_exist = ret_value == _GetCustomAttribute(attrib, RandomInt(0-0x7FFF, 0x7FFF))
			if (attrib_exist)
				return ret_value
			return GET_CUSTOM_PLAYER_ATTRIBUTE_VALUE(this, attrib, def)
		}
		
		return _GetCustomAttribute(attrib, def)
	}
	/**
	 * 
	 * @param {string} attrib
	 * @param {float} def
	 * @returns {float}
	 */
	function CTFBot::GetCustomAttribute( attrib, def )
	{
		if (!this || !this.IsValid())
			return 0
		if (GET_CUSTOM_ATTRIBUTE(attrib))
		{
			local ret_value = _GetCustomAttribute(attrib, def)
			local attrib_exist = ret_value == _GetCustomAttribute(attrib, RandomInt(def.tointeger()+1, def.tointeger()+0x7FFF))
			if (attrib_exist)
				return ret_value
			return GET_CUSTOM_PLAYER_ATTRIBUTE_VALUE(this, attrib, def)
		}

		return _GetCustomAttribute(attrib, def)
	}
}
/** 
 * Cache's the Eyetrace if called multiple times per frame
 * 
 * Based off of GMod Lua version
 * 
 * The Trace is called with the mask `MASK_SHOT` to override this
 * the input table should contain `mask = #` with # being the mask
 * 
 * @param {table} overrides
 * 
 * @returns {table}
 */
function CTFPlayer::GetEyeTrace( overrides = {} )
{
	local scope = GetScope(this)
	if (!("EyeTraceDataCache" in scope))
		scope.EyeTraceDataCache <- {
			data = {},
			tick = 0,
		}

	local should_override = overrides.len() != 0
	local is_filter = "filter" in overrides

	if (should_override == false && is_filter == false)
	{
		if (GetFrameCount() == scope.EyeTraceDataCache.tick)
			return scope.EyeTraceDataCache.data // clone this?
	}

	local trace = {
		start = EyePosition()
		end = EyePosition() + (EyeAngles().Forward() * TRACE_MAX)
		mask = "mask" in overrides ? overrides["mask"] : MASK_SHOT
		ignore = this
	}
	if (is_filter)
		trace.filter <- overrides["filter"]

	if (is_filter == true)
		TraceLineFilter(trace)
	else
		TraceLineEx(trace)

	if (should_override == false)
	{
		scope.EyeTraceDataCache.data.clear() // less garbage?
		scope.EyeTraceDataCache.data = clone trace // using clone so that people can use the raw table without overriding the original

		scope.EyeTraceDataCache.tick = GetFrameCount()
	}
	
	return trace
}

/**
 * Suppress the Medic Calling voice-lines
 */
function CTFPlayer::SuppressMedicTalk() 
{
	local Lines = [
		"%s.Medic0%i"
		"%s.MedicFollow0%i"
	]
	local Name = GetPlayerClassName()

	foreach (sound in Lines) {
		for (local i = 1; i < 9; i++) {
			StopSoundOn(format(sound, Name, i), this)
		}
	}
}

/** 
 * @returns {[CSceneEntity]}
 */
function CTFPlayer::GetSceneEntitys()
{
	local ents = GetAllEntitiesByClassname("instanced_scripted_scene")
	local owned = []

	foreach (scene in ents)
	{
		if (GetPropEntity(scene, "m_hOwner") == this)
			owned.append(scene)
	}

	return owned
}

function CTFPlayer::IsPlayingScene( scene )
{
	local Classname = GetPlayerClassName()
	local Names = []
	if (type(scene) == "array")
	{
		foreach (str in scene)
			Names.append(format("scenes/Player/%s/low/%s.vcd", Classname, str.tostring()))
	}
	else
		Names = [format("scenes/Player/%s/low/%s.vcd", Classname, scene)]

	local SceneEntitys = GetSceneEntitys()

	foreach (scene_entity in SceneEntitys)
	{
		foreach (name in Names)
		{
			// printf("Scene: %s is playing scene %s\n", scene_entity.tostring(), scene_entity.GetSceneFileName())
			// printf("Playing Scene == %s? : %s\n", name, (scene_entity.GetSceneFileName() == name).tostring())
			if (scene_entity.GetSceneFileName() == name)
				return true
		}
	}

	return false
}

function CTFPlayer::IsPlayingMedicScene()
{
	return IsPlayingScene(CallMedicScenes[GetPlayerClass()])
}

// function CTFPlayer::DisplayHudHint( text, duration = 10.0, flash = true, Hide = true )
// {
// 	local hint_ent = GetHudHint()
// 	local hint_scope = GetScope(hint_ent)

// 	if (!("message" in hint_scope))
// 		hint_scope.message <- ""

// 	if (hint_scope.message != text) 
// 		hint_ent.KeyValueFromString("message", text)
// 	hint_scope.message = text

// 	hint_ent.AcceptInput("ShowHudHint", "", this, this)

// 	AddThink(function() {
		
// 	})


// 	if (Hide)
// 		EntFireNew(hint_ent, "HideHudHint", "", duration, this, this)

// 	if (flash == true && duration > 2)
// 		RunWithDelay(@() DisplayHudHint(text, duration-2, flash, false), 2)
// 	else if (duration > 10 && flash == false)
// 		RunWithDelay(@() DisplayHudHint(text, duration-10, flash, false), 10)
// }

// function CTFPlayer::GetTauntIndex()
// {
// 	local low_index = GetPropInt(this, "m_Shared.m_unTauntSourceItemID_Low")
// 	local high_index = GetPropInt(this, "m_Shared.m_unTauntSourceItemID_High")
// 	local swaped = swap2(low_index) // somehow turns into 0 -> 65535
// 	//somehow 28324 == 31413
// 	//53307 == 31348
// 	// if (swapped )
// }

// printl((GetPropInt(Host, "m_Shared.m_unTauntSourceItemID_High") << 32) | GetPropInt(Host, "m_Shared.m_unTauntSourceItemID_Low"))


/* function CTFPlayer::CreateWearable( idx, model )
{
	local dummy = CreateByClassname( "tf_weapon_parachute" )
	SetPropInt( dummy, PROP_ITEM_DEF_IDX, 1101 )
	SetPropBool( dummy, "m_AttributeManager.m_Item.m_bInitialized", true )
	dummy.SetTeam( GetTeam() )
	dummy.DispatchSpawn()
	dummy.SetModelSimple("")
	Weapon_Equip( dummy )

	local wearable = GetPropEntity( dummy, "m_hExtraWearable" )
	dummy.Kill()

	wearable.SetTeam(GetTeam())
	SetPropInt( wearable, PROP_ITEM_DEF_IDX, idx )
	SetPropBool( wearable, "m_AttributeManager.m_Item.m_bInitialized", true )
	SetPropBool( wearable, "m_bValidatedAttachedEntity", true )
	wearable.DispatchSpawn()

	if (model) 
		wearable.SetModelSimple(model)

	wearable.SetTeam(GetTeam())

	SendGlobalGameEvent( "post_inventory_application", { userid = GetUserID() } )
	wearable.SetOwner(this)

	return wearable
} */

/*
  =============================
  === END OF PLAYER METHODS ===
  =============================
*/


::NoFormatToBot <- [
	"PrintToChat"
	"PrintToHud"
	"TranslateToChat"
	"TranslateToHud"
	"GetTranslatedAndFormattedString"
	"GetTranslatedString"
	"GetLanguage"
	"IsAdmin"
	"IsEventJudge"
	"IHTranslateToChat"
	"IsBot"
	"CalculateEHP"
	"GenerateAndWearItem"
	"DisplayHudHint"
]

/*
  ===================
  === BOT METHODS ===
  ===================
*/

// somewhat stolen from ZI
foreach ( key, value in CTFPlayer )
{
	if ( typeof( value ) == "function" && !( key in CTFBot ) )
	{
		if (NoFormatToBot.find(key) != null)
			continue
		CTFBot[ key ] <- value
		// printf("Formatted Function %s to CTFBot\n", key)
	}
}
// funi
function CTFBot::IsBot()
	return true
function CTFBot::IsAdmin()
	return false
function CTFBot::IsEventJudge()
	return false
function CTFBot::IsReprogrammed()
	return InCond(TF_COND_REPROGRAMMED)
/**
 * @param {CTFPlayer} victim
 */
function CTFBot::SayChatterMessage( victim )
{
	local Messages = []
	foreach (Rarity in [ChatterMessages["Commons"], ChatterMessages["Rares"]])
	{
		foreach (message in Rarity)
		{
			local chance 		= "chance" 		in message ? message["chance"].tofloat() 	: 101.0
			local team 			= "team" 		in message ? message["team"] 				: 3
			local requirement 	= "requirement" in message ? message["requirement"] 		: false

			local requirements = []

			if (requirement && requirement.find("|"))
			{
				requirements = split(requirement, "|")
			}

			local Failed = false

			if (MATH.RandomChance() > chance/100 || GetTeam() != team)
				Failed = true

			if (Failed == false && requirement)
			{
				Failed = true
				if (requirements.len() != 0)
				{
					if (requirements[0] == "id")
					{
						if (victim.GetSteamID() == requirements[1])
							Messages.append(message)
					}
				}
				else if (requirement == "Admin")
				{
					if (victim.IsAdmin())
						Messages.append(message)
				}
				else if (requirement == "Judge")
				{
					if (victim.IsEventJudge())
						Messages.append(message)
				}
				else if (requirement == "BrainDawg")
				{
					if (victim.GetSteamID() == "[U:1:28266263]")
						Messages.append(message)
				}
				else throw format("Unknown Requirement in message %s : %s", message["message"], requirement)
			}

			if (Failed == false)
				Messages.append(message)
		}
	}

	if (Messages.len() == 0)
		return

	local MessageData = Messages[RandomInt(0, Messages.len()-1)]
	local FormatData = "format" in MessageData ? MessageData["format"] : null
	local Message = MessageData["message"]
	if (FormatData)
	{
		if (MessageData["format"].find("|"))
			FormatData = split(FormatData, "|")
		else 
			FormatData = [FormatData]
		// ADD CUSTOM FORMAT RULES
		local victim_in = FormatData.find("victim")
		// printl(FormatData.find("victim"))
		// printl(FormatData.find("⤒"))
		if (victim_in != null)
		{
			local msg = victim.GetUserName()
			if (FormatData.find("⤒"))
			{
				msg = msg.toupper()
				FormatData.remove(FormatData.find("⤒"))
			}
			
			FormatData[victim_in] = msg
		}
		
		Message = format.acall([this, Message].extend(FormatData))
	}
	PrintToChatAll(format("%s%s\x01 :  %s", GetChatColor(), GetUserName(), Message))
}

function CTFBot::UndoReprogram( kill = true )
{
	if (!this||!IsValid()||IsDead())
		return

	CreateParticle("drg_cow_explosioncore_charged", GetOrigin()+Vector(0, 0, 8))

	if ("EndReprogramTime" in GetScope(this)) 
		delete GetScope(this).EndReprogramTime

	RemoveCondEx(TF_COND_REPROGRAMMED, true)

	if (kill)
	{
		Suicide()
		SetHealth(0)
		TakeDamage(GetMaxHealth()*100, DMG_GENERIC, FirstEntity())
	}
}

/*
  ==========================
  === END OF BOT METHODS ===
  ==========================
*/

/*
  ==============================
  === CUSTOM ATTRIBUTE STUFF ===
  ==============================
*/
if (!("CUSTOM_ATTRIBUTES_DEFINES" in ROOT))
	::CUSTOM_ATTRIBUTES_DEFINES <- []
if (!("CUSTOM_ATTRIBUTE_WEAPONS" in ROOT))
	::CUSTOM_ATTRIBUTE_WEAPONS <- {}

/**
 * @param {string} attrib
 */
function ROOT::DEFINE_CUSTOM_ATTRIBUTE( attrib )
{
	if (GET_CUSTOM_ATTRIBUTE(attrib) == null)
		CUSTOM_ATTRIBUTES_DEFINES.append(attrib)
}
/**
 * @param {string} attrib
 */
function ROOT::REMOVE_CUSTOM_ATTRIBUTE( attrib )
{
	if (GET_CUSTOM_ATTRIBUTE(attrib) != null)
		CUSTOM_ATTRIBUTES_DEFINES.remove(CUSTOM_ATTRIBUTES_DEFINES.find(attrib))
}
/**
 * @param {integer} idx
 * @param {string} attrib
 * @param {integer|float} value
 */
function ROOT::DEFINE_CUSTOM_WEAPON_ATTRIBUTE( idx, attrib, value )
{
	if (!GET_CUSTOM_ATTRIBUTE(attrib))
		return
	if (!(idx in CUSTOM_ATTRIBUTE_WEAPONS))
		CUSTOM_ATTRIBUTE_WEAPONS[idx] <- {}
	
	CUSTOM_ATTRIBUTE_WEAPONS[idx][attrib] <- value
}
/**
 * @param {integer} idx
 * @param {string} attrib
 */
function ROOT::REMOVE_CUSTOM_WEAPON_ATTRIBUTE( idx, attrib )
{
	if (!GET_CUSTOM_ATTRIBUTE(attrib))
		return
	if (!(idx in CUSTOM_ATTRIBUTE_WEAPONS))
		return
	if (!(attrib in CUSTOM_ATTRIBUTE_WEAPONS[idx]))
		return

	delete CUSTOM_ATTRIBUTE_WEAPONS[idx][attrib]
}

function ROOT::GET_CUSTOM_ATTRIBUTE( attrib )
	return CUSTOM_ATTRIBUTES_DEFINES.find(attrib) != null
/**
 * @param {integer} idx
 * @param {string} attrib
 */
function ROOT::GET_CUSTOM_WEAPON_ATTRIBUTE( idx, attrib )
{
	if (!(idx in CUSTOM_ATTRIBUTE_WEAPONS))
		return false

	return attrib in CUSTOM_ATTRIBUTE_WEAPONS[idx]
}
/**
 * @param {integer} idx
 * @param {string} attrib
 * 
 * @returns {integer|float} Will return def if not found
 */
function ROOT::GET_CUSTOM_ATTRIBUTE_VALUE( idx, attrib, def = 0 )
{
	if (GET_CUSTOM_ATTRIBUTE(attrib) == null)
		return def

	if (!GET_CUSTOM_WEAPON_ATTRIBUTE(idx, attrib))
		return def
	
	return CUSTOM_ATTRIBUTE_WEAPONS[idx][attrib]
}
/**
 * @param {integer} idx
 * @param {string} attrib
 */
// function ROOT::SET_CUSTOM_ATTRIBUTE_VALUE( idx, attrib, def = 0 )
// {
// 	if (GET_CUSTOM_ATTRIBUTE(attrib) == null)
// 		return def

// 	if (!GET_CUSTOM_WEAPON_ATTRIBUTE(idx, attrib))
// 		return def
	
// 	return CUSTOM_ATTRIBUTE_WEAPONS[idx][attrib]
// }
/**
 * @param {CTFPlayer|CTFBot} player
 * @param {string} attrib
 * 
 * @returns {integer|float} Will return def if not found
 */
function ROOT::GET_CUSTOM_PLAYER_ATTRIBUTE_VALUE( player, attrib, def = 0 )
{
	if (GET_CUSTOM_ATTRIBUTE(attrib) == null)
		return def

	if (!("CUSTOM_ATTRIBUTES" in GetScope(player)))
	{
		GetScope(player).CUSTOM_ATTRIBUTES <- {}
		return def
	}

	if (!(attrib in GetScope(player).CUSTOM_ATTRIBUTES))
		return def

	return GetScope(player).CUSTOM_ATTRIBUTES[attrib]
}
/**
 * @param {CTFPlayer|CTFBot} player
 * @param {string} attrib
 * @param {float|integer} value
 */
function ROOT::SET_CUSTOM_PLAYER_ATTRIBUTE_VALUE( player, attrib, value )
{
	if (GET_CUSTOM_ATTRIBUTE(attrib) == null)
		return

	if (!("CUSTOM_ATTRIBUTES" in GetScope(player)))
		GetScope(player).CUSTOM_ATTRIBUTES <- {}

	GetScope(player).CUSTOM_ATTRIBUTES[attrib] <- value
}

// To Use these custom attributes Un-Comment the below function calls

/* 
 * Corrosion
 *
 * Inflicts a Infinite duration Damaging effect
 * Can also drop a puddle when killed
 * 
 * Note: Cannot apply Corrosion to Players
 * 
 * **Note: Requires Gameplay-Applications**
 */
//

// DEFINE_CUSTOM_ATTRIBUTE("corrosion on hit")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion on crit")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion tick duration")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion damage percent")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion damage add")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion drop puddle")

/**
 * Throwable stuff
 * 
 * Used to modify the values of throwables when spawning
 */
// DEFINE_CUSTOM_ATTRIBUTE("throwable starts empty")
// DEFINE_CUSTOM_ATTRIBUTE("throwable start charge")

/**
 * Bleed
 * 
 * Allows Bleed to Crit if the user is Crit-boosted
 */
// DEFINE_CUSTOM_ATTRIBUTE("allow crit bleed")

/**
 * Condition on stomped enemy
 * 
 * Applies this Condition number to the enemy you stomped on, 
 * for a duration
 */
// DEFINE_CUSTOM_ATTRIBUTE("cond on stomped")
// DEFINE_CUSTOM_ATTRIBUTE("cond on stomped duration")

/**
 * Condition on stomp
 * 
 * Applies this Condition number to yourself for this duration on stomp
 */
// DEFINE_CUSTOM_ATTRIBUTE("cond on stomp")
// DEFINE_CUSTOM_ATTRIBUTE("cond on stomp duration")

/**
 * Random Damage Mults
 * 
 * Multiple Damage Multiplier Attributes
 */
// DEFINE_CUSTOM_ATTRIBUTE("stomp dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellskeletons dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellmirv dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellmeteor dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelllightningorb dmg mul")
// DEFINE_CUSTOM_ATTRIBUTE("spellfireball dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelleyeball dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelljump dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellbats dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("halloween kart dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("taunt dmg mult")
// DEFINE_CUSTOM_ATTRIBUTE("taunt dmg mult active")
// DEFINE_CUSTOM_ATTRIBUTE("mult dmg while blast jumping")
// DEFINE_CUSTOM_ATTRIBUTE("mult dmg while airborne")

/**
 * Random Damage taken mults
 * 
 * Multiple Damage Taken Multiplier Attributes
 */
// DEFINE_CUSTOM_ATTRIBUTE("stomp dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellskeletons dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellmirv dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellmeteor dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelllightningorb dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellfireball dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelleyeball dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spelljump dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("spellbats dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("halloween kart dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("bleeding dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("plague dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("fall dmg taken mult")
// DEFINE_CUSTOM_ATTRIBUTE("corrosion dmg taken mult")

/**
 * Stomp
 * 
 * Stomping will now use your falling velocity instead 
 * of the fall damage you would have taken
 */
// DEFINE_CUSTOM_ATTRIBUTE("stomp uses velocity")

/**
 * Explosive Backstab
 * 
 * Create an explosion on Backstab
 */
// DEFINE_CUSTOM_ATTRIBUTE("explosive backstab")
// DEFINE_CUSTOM_ATTRIBUTE("explosive backstab base radius")
// DEFINE_CUSTOM_ATTRIBUTE("explosive backstab radius add")
// DEFINE_CUSTOM_ATTRIBUTE("explosive backstab base damage")
// DEFINE_CUSTOM_ATTRIBUTE("explosive backstab damage add")

/**
 * AddCond on attack
 * 
 * Apply a condition for a duration on attack
 */
// DEFINE_CUSTOM_ATTRIBUTE("add cond on attack")
// DEFINE_CUSTOM_ATTRIBUTE("add cond on attack duration")


/**
 * Spells
 * 
 * Allows getting spells for hitting or kill an enemy
 */
// DEFINE_CUSTOM_ATTRIBUTE("give spell on kill")
// DEFINE_CUSTOM_ATTRIBUTE("give spell on kill max")
// DEFINE_CUSTOM_ATTRIBUTE("give spell on kills needed")
// DEFINE_CUSTOM_ATTRIBUTE("give spell on hit")
// DEFINE_CUSTOM_ATTRIBUTE("give spell on hit max")


/*
  =====================================
  === END OF CUSTOM ATTRIBUTE STUFF ===
  =====================================
*/


/*
  ======================
  === WEAPON METHODS ===
  ======================
*/

/////////
if (!("_GetAttribute" in CTFWeaponBase))
{
	CTFWeaponBase._GetAttribute <- CTFWeaponBase.GetAttribute
	CTFWeaponBase._AddAttribute <- CTFWeaponBase.AddAttribute
	CEconEntity._GetAttribute <- CEconEntity.GetAttribute
	CEconEntity._AddAttribute <- CEconEntity.AddAttribute
	/**
	 * Modified version that can hook our custom attributes
	 * @param {string} attrib
	 * @param {float} def
	 * @returns {float}
	 */
	function CTFWeaponBase::GetAttribute( attrib, def )
	{
		if (!this || !this.IsValid())
			return 0
		if (GET_CUSTOM_ATTRIBUTE(attrib))
			return GET_CUSTOM_ATTRIBUTE_VALUE(GetIDX(), attrib, def)
		
		return _GetAttribute(attrib, def)
	}
	/**
	 * 
	 * @param {string} attrib
	 * @param {float} def
	 * @returns {float}
	 */
	function CEconEntity::GetAttribute( attrib, def )
	{
		if (!this || !this.IsValid())
			return 0
		if (GET_CUSTOM_ATTRIBUTE(attrib))
			return GET_CUSTOM_ATTRIBUTE_VALUE(GetIDX(), attrib, def)

		return _GetAttribute(attrib, def)
	}
	/**
	 * Modified version that can hook our custom attributes
	 * @param {string} attrib
	 * @param {float} value
	 * @param {float} _duration
	 */
	function CTFWeaponBase::AddAttribute( attrib, value, _duration )
	{
		if (!this || !this.IsValid())
			return
		return _AddAttribute(attrib, value _duration)
		// if (GET_CUSTOM_ATTRIBUTE(attrib))
		// 	return GET_CUSTOM_ATTRIBUTE_VALUE(GetIDX(), attrib, def)
		
		// return _GetAttribute(attrib, def)
	}
	/**
	 * Modified version that can hook our custom attributes
	 * @param {string} attrib
	 * @param {float} value
	 * @param {float} _duration
	 */
	function CEconEntity::AddAttribute( attrib, value, _duration )
	{
		if (!this || !this.IsValid())
			return 
		return _AddAttribute(attrib, value _duration)
		// if (GET_CUSTOM_ATTRIBUTE(attrib))
		// 	return GET_CUSTOM_ATTRIBUTE_VALUE(GetIDX(), attrib, def)

		// return _GetAttribute(attrib, def)
	}
}

/**
 * @param {string} attrib
 * @param {float|integer} def_val
 * @deprecated Use HasAdditiveAttribute or HasMultAttribute instead
 */
function CTFWeaponBase::HasAttribute( attrib, def_val )
	return GetAttribute(attrib, def_val) != def_val
/**
 * @param {string} attrib
 */
function CTFWeaponBase::HasAdditiveAttribute( attrib, def = 0 )
	return GetAttribute(attrib, def) != def
/**
 * @param {string} attrib
 */
function CTFWeaponBase::HasMultAttribute( attrib, def = 1.0 )
	return GetAttribute(attrib, def) != def
/**
 * @param {string} attrib
 */
function CTFWeaponBase::GetAdditiveAttribute( attrib, def = 0 )
	return GetAttribute(attrib, def)
/**
 * @param {string} attrib
 */
function CTFWeaponBase::GetMultAttribute( attrib, def = 1.0 )
	return GetAttribute(attrib, def)
/**
 * @returns {integer}
 */
function CTFWeaponBase::GetIDX()
	return GetPropInt(this, PROP_ITEM_DEF_IDX)
/**
 * @returns {float}
 */
function CTFWeaponBase::GetChargeTime()
	return GetPropFloat(this, PROP_CHARGE_TIME)
/**
 * @param {float} time
 */
function CTFWeaponBase::SetChargeTime( time )
	SetPropFloat(this, PROP_CHARGE_TIME, time)

/**
 * @returns {float}
 */
function CTFWeaponBase::GetChargeProgress()
{
	if ( !GetOwner() )
		return 0.0

	local max = ammo_type == TF_AMMO_GRENADES1 ? GetOwner().GetMaximumGrenades1() : GetOwner().GetMaximumGrenades3()
	if ( GetOwner().GetAmmoByIndex(ammo_type) < max )
		return (GetDefaultChargeTime() - (GetPropFloat(this, "m_flEffectBarRegenTime") - Time())) / GetDefaultChargeTime()
	return 1.0
}

/**
 * @returns {float}
 */
function CTFWeaponBase::GetDefaultChargeTime()
{
	switch (GetWeaponClass())
	{
	case "bat" :
		return 10.0
	case "jar":
	case "jar_milk":
		return 20.1 // i dont fucking know why its 20.1
	case "lunchbox":
		return 30.0
	case "jar_gas":
		return 60.0
	case "cleaver":
		return 5.1
	default:
		return -1.0
	}
}


function CTFWeaponBase::IsAbilityWeapon()
	return TF_ABILITYS.values().find(GetIDX()) != null
/**
 * @param {string} AttributeName
 * @param {float} AttributeChange
 * @param {float} StartingValue
 * @param {float} MaxValue
 * @param {float} MinValue
 */
function CTFWeaponBase::CalculateAttributes( AttributeName, AttributeChange, StartingValue, MaxValue, MinValue )
{
	local EndingValue = (GetAttribute(AttributeName, StartingValue) + AttributeChange)

	if (EndingValue <= MaxValue || EndingValue >= MinValue ) { AddAttribute(AttributeName, EndingValue, 0) }
	if (EndingValue > MaxValue) { AddAttribute(AttributeName, MaxValue, 0) }
	if (EndingValue < MinValue) { AddAttribute(AttributeName, MinValue, 0) }
}
/**
 * @param {float} mult_val
 * @param {string} AttributeName
 * @param {float} AttributeChange
 * @param {float} StartingValue
 * @param {float} MaxValue
 * @param {float} MinValue
 */
function CTFWeaponBase::CalculateAttributeChange( mult_val, AttributeName, AttributeChange, StartingValue, MaxValue, MinValue )
{
	local EndingValue = (StartingValue + (AttributeChange * mult_val))

	if (EndingValue <= MaxValue || EndingValue >= MinValue ) { AddAttribute(AttributeName, EndingValue, 0) }
	if (EndingValue > MaxValue) { AddAttribute(AttributeName, MaxValue, 0) }
	if (EndingValue < MinValue) { AddAttribute(AttributeName, MinValue, 0) }
}

/**
 * @param {string} propertyName
 * @param {any} value
 */
function CTFWeaponBase::SetProp( propertyName, value )
	SetPropArray(propertyName, value, 0)
/**
 * @param {string} propertyName
 * @param {any} value
 * @param {integer} index
 */
function CTFWeaponBase::SetPropArray( propertyName, value, index )
{
	if (!HasProp(this, propertyName))
	{
		printf("%s does not have property %s\n", GetClassname(), propertyName)
		return
	}
	if(value == null || value instanceof CBaseEntity)
		return SetPropEntity(this, propertyName, value, index)
	switch (type(value))
	{
	case "string":
		return SetPropString(this, propertyName, value, index)
	case "integer":
		return SetPropInt(this, propertyName, value, index)
	case "float":
		return SetPropFloat(this, propertyName, value, index)
	case "bool":
		return SetPropBool(this, propertyName, value, index)
	case "vector":
		return SetPropVector(this, propertyName, value, index)
	default:
		throw format("Unknown type %s in CTFWeaponBase::SetProp/SetPropArray", type(value))
	}
}
/**
 * @param {integer} index
 */
function CTFWeaponBase::SetSpellIndex( index )
	if (HasProp(this, PROP_SPELL_INDEX)) { SetPropInt(this, PROP_SPELL_INDEX, index) }
/**
 * @returns {integer|null}
 */
function CTFWeaponBase::GetSpellIndex()
	if (HasProp(this, PROP_SPELL_INDEX)) { return GetPropInt(this, PROP_SPELL_INDEX) } else { return null }
/**
 * @returns {integer|null}
 */
function CTFWeaponBase::GetSpellCharges()
	if (HasProp(this, PROP_SPELL_CHARGES)) { return GetPropInt(this, PROP_SPELL_CHARGES) } else { return null }
/**
 * @param {integer} charge
 */
function CTFWeaponBase::SetSpellCharges( charge )
	if (HasProp(this, PROP_SPELL_CHARGES)) { SetPropInt(this, PROP_SPELL_CHARGES, charge) }
/**
 * @param {integer} num
 */
function CTFWeaponBase::IncrementSpellCharge( num )
	if (HasProp(this, PROP_SPELL_CHARGES)) SetPropInt(this, PROP_SPELL_CHARGES, GetSpellCharges() + num)
/**
 * @returns {bool}
 */
function CTFWeaponBase::IsHolstered()
	if (HasProp(this, "m_bHolstered")) { return GetPropBool(this, "m_bHolstered") } else { return false }
/**
 * @param {integer|float} level
 */
function CTFWeaponBase::SetUberChargePercent( level )
	if (HasProp(this, PROP_MEDIGUN_CHARGE)) { SetPropFloat(this, PROP_MEDIGUN_CHARGE, level.tofloat()/100) }
/**
 * @returns {float|null}
 */
function CTFWeaponBase::GetUberChargePercent()
	if (HasProp(this, PROP_MEDIGUN_CHARGE)) { return GetPropFloat(this, PROP_MEDIGUN_CHARGE) } else { return null }
/**
 * @param {integer|float} level
 */
function CTFWeaponBase::IncreaseUberChargePercent( level )
{
	if (HasProp(this, PROP_MEDIGUN_CHARGE))
	{
		SetPropFloat(this, PROP_MEDIGUN_CHARGE, GetUberChargePercent() + level.tofloat()/100)
		local charge = GetUberChargePercent()
		if ( charge > 1.00) SetUberChargePercent(100)
		if ( charge < 0.00) SetUberChargePercent(0)
	}
}
/**
 * @param {float} level
 */
function CTFWeaponBase::DecreaseUberChargePercent( level )
{
	IncreaseUberChargePercent(-level)
	return
}
/**
 * @param {integer} index
 * @param {integer} max
 */
function CTFWeaponBase::ModifySpells( index, max, compared = 1, mod_compare = 1 )
{
	if ((compared % mod_compare) != 0) 
		return

	if (index == TF_SPELL_NONE)
	{
		SetSpellIndex(index)
		RunWithDelay(2.1, @() SetRandomSpell())
		return
	}

	if (GetSpellCharges() == 0)
	{
		SetSpellIndex(index)
		IncrementSpellCharge(1)
	}
	else if (index == GetSpellIndex() && GetSpellCharges() < max)
		IncrementSpellCharge(1)
}

function CTFWeaponBase::IsAbilityReady()
{
	if (!IsAbilityWeapon())
		return false
	if (GetAbilityType() == ABILITY_TIME)
		return GetScope(this).Timestamp <= Time()
	else if (GetAbilityType() == ABILITY_DAMAGE)
		return GetScope(this).DamageNeeded-GetScope(this).CurrentDamage <= 0
}
/**
 * @param {float} time
 */
function CTFWeaponBase::SetAbilityTime( time )
	GetScope(this).Timestamp <- time
/**
 * @param {float} time
 */
function CTFWeaponBase::AddAbilityTime( time )
	SetAbilityTime(Time() + time)
/**
 * @param {float} max_dmg
 */
function CTFWeaponBase::SetAbilityDamage( max_dmg, cur_dmg = 0.0 )
{
	GetScope(this).DamageNeeded <- max_dmg
	GetScope(this).CurrentDamage <- cur_dmg
}
/**
 * @param {integer} dmg
 */
function CTFWeaponBase::AddAbilityDamage( dmg )
	if (!("CurrentDamage" in GetScope(this))) { GetScope(this).CurrentDamage <- dmg } 
	else { GetScope(this).CurrentDamage += dmg }

function CTFWeaponBase::ResetAbilityDamage()
	GetScope(this).CurrentDamage <- 0.0

function CTFWeaponBase::GetAbilityDamage()
	return "CurrentDamage" in GetScope(this) ? GetScope(this).CurrentDamage : 0.0
/**
 * @param {integer} type
 */
function CTFWeaponBase::SetAbilityType( type )
	if (type != ABILITY_REMOVE)
		GetScope(this).__ABILITY_TYPE <- type
	else if ("__ABILITY_TYPE" in GetScope(this)) delete GetScope(this).__ABILITY_TYPE
/**
 * @returns {integer}
 */
function CTFWeaponBase::GetAbilityType()
	return "__ABILITY_TYPE" in GetScope(this) ? GetScope(this).__ABILITY_TYPE : ABILITY_REMOVE

function CTFWeaponBase::IsAbilityActive()
	return "AbilityActive" in GetScope(this) ? GetScope(this).AbilityActive : false

function CTFWeaponBase::SetRandomSpell( rares = true, lower_rares = false )
{
	local spell = RandomInt(TF_SPELL_FIREBALL, rares ? TF_SPELL_SKELETON : TF_SPELL_TELEPORT)
	if (lower_rares && spell > TF_SPELL_TELEPORT && MATH.RandomChance() > 0.333)
	{
		spell = RandomInt(TF_SPELL_FIREBALL, TF_SPELL_TELEPORT)
	}
	SetSpellIndex(spell)
	SetSpellCharges(SpellDefaults[spell+2])
}

function CTFWeaponBase::ShootPosition()
{
	local offset = null
	local zOffset = -3.0
	if (GetOwner()) zOffset = GetOwner().GetFlags() & FL_DUCKING ? 8.0 : -3.0

	local idx = GetIDX()

	switch (idx)
	{
	case 441: // The Cow Mangler
		offset = Vector(23.5, 8.0, zOffset)
		break
	case 513: // The Original
		offset = Vector(23.5, 0.0, zOffset)
		break
	case 18: // Rocket Launcher
	case 127: // The Direct Hit
	case 1104: // The Air Strike
	case 205: // Rocket Launcher (Renamed/Strange)
	case 228: // The Black Box
	case 237: // Rocket Jumper
	case 414: // The Liberty Launcher
	case 658: // Festive Rocket Launcher
	case 730: // The Beggar's Bazooka
	case 800: // Silver Botkiller Rocket Launcher Mk.I
	case 809: // Gold Botkiller Rocket Launcher Mk.I
	case 889: // Rust Botkiller Rocket Launcher Mk.I
	case 898: // Blood Botkiller Rocket Launcher Mk.I
	case 907: // Carbonado Botkiller Rocket Launcher Mk.I
	case 916: // Diamond Botkiller Rocket Launcher Mk.I
	case 965: // Silver Botkiller Rocket Launcher Mk.II
	case 974: // Gold Botkiller Rocket Launcher Mk.II
	case 1085: // Festive Black Box
	case 15006: // Woodland Warrior
	case 15014: // Sand Cannon
	case 15028: // American Pastoral
	case 15043: // Smalltown Bringdown
	case 15052: // Shell Shocker
	case 15057: // Aqua Marine
	case 15081: // Autumn
	case 15104: // Blue Mew
	case 15105: // Brain Candy
	case 15129: // Coffin Nail
	case 15130: // High Roller's
	case 15150: // Warhawk
	case 39: // The Flare Gun
	case 351: // The Detonator
	case 595: // The Manmelter
	case 740: // The Scorch Shot
	case 1081: // Festive Flare Gun
		offset = Vector(23.5, 12.0, zOffset)
		break
	case 56: // Hunstman
	case 1005: // Festive Huntsman
	case 1092: // The Fortified Compound
	case 997: // Rescue Ranger
	case 305: // Crusader's Crossbow
	case 1079: // Festive Crusader's Crossbow
		offset = Vector(23.5, 12.0, -3.0)
		break
	case 442: // The Righteous Bison
	case 588: // The Pomson 6000
		offset = Vector(23.5, 8.0, zOffset)
		break
	case 222: // The Mad Milk
	case 1121: // Mutated Milk
	case 1180: // Gas Passer
	case 58: // Jarate
	case 751: // Festive Jarate
	case 1105: // The Self-Aware Beauty Mark
	case 19: // Grenade Launcher
	case 206: // Grenade Launcher (Renamed/Strange)
	case 308: // The Loch-n-Load
	case 996: // The Loose Cannon
	case 1007: // Festive Grenade Launcher
	case 1151: // The Iron Bomber
	case 15077: // Autumn
	case 15079: // Macabre Web
	case 15091: // Rainbow
	case 15092: // Sweet Dreams
	case 15116: // Coffin Nail
	case 15117: // Top Shelf
	case 15142: // Warhawk
	case 15158: // Butcher Bird
	case 20: // Stickybomb Launcher
	case 207: // Stickybomb Launcher (Renamed/Strange)
	case 130: // The Scottish Resistance
	case 265: // Sticky Jumper
	case 661: // Festive Stickybomb Launcher
	case 797: // Silver Botkiller Stickybomb Launcher Mk.I
	case 806: // Gold Botkiller Stickybomb Launcher Mk.I
	case 886: // Rust Botkiller Stickybomb Launcher Mk.I
	case 895: // Blood Botkiller Stickybomb Launcher Mk.I
	case 904: // Carbonado Botkiller Stickybomb Launcher Mk.I
	case 913: // Diamond Botkiller Stickybomb Launcher Mk.I
	case 962: // Silver Botkiller Stickybomb Launcher Mk.II
	case 971: // Gold Botkiller Stickybomb Launcher Mk.II
	case 1150: // The Quickiebomb Launcher
	case 15009: // Sudden Flurry
	case 15012: // Carpet Bomber
	case 15024: // Blasted Bombardier
	case 15038: // Rooftop Wrangler
	case 15045: // Liquid Asset
	case 15048: // Pink Elephant
	case 15082: // Autumn
	case 15083: // Pumpkin Patch
	case 15084: // Macabre Web
	case 15113: // Sweet Dreams
	case 15137: // Coffin Nail
	case 15138: // Dressed to Kill
	case 15155: // Blitzkrieg
		offset = Vector(16.0, 8.0, -6.0)
		break
	case 17: // Syringe Gun
	case 204: // Syringe Gun (Renamed/Strange)
	case 36: // The Blutsauger
	case 412: // The Overdose
		offset = Vector(16.0, 6.0, -8.0)
		break
	case 812: // The Flying Guillotine
	case 833: // The Flying Guillotine (Genuine)
		offset = Vector(32.0, 0.0, 15.0)
		break
	case 528: // The Short Curcuit
		offset = Vector(40.0, 15.0, -10.0)
		break
	case 44: // Sandman
	case 648: // The Wrap Assassin
		if (!GetOwner())
			return GetOrigin() + Vector(0.0, 0.0, 50.0) + (GetAbsAngles().Forward() * 32.0)
		return GetOwner().GetOrigin() + GetOwner().GetModelScale() *
				(GetOwner().EyeAngles().Forward() * 32.0 + Vector(0.0, 0.0, 50.0))
	default:
		if (!GetOwner())
			return GetOrigin()
		return GetOwner().EyePosition()
	}


	if (GetOwner() && GetOnwer().AreViewModelsFlipped())
		offset.y *= -1

	local eye_angles = GetOwner() ? GetOwner().EyeAngles() : GetAbsAngles()
	local eye_pos = GetOwner() ? GetOwner().EyePosition() : GetOrigin()
	return eye_pos +
			eye_angles.Up() * offset.z +
			eye_angles.Left() * offset.y +
			eye_angles.Forward() * offset.x
}

/**
 * @returns {bool}
 */
function CTFWeaponBase::IsWearable()
	return IsInArray(GetIDX(), WearableIDXs.Primarys) || IsInArray(GetIDX(), WearableIDXs.Secondarys)

// Better and because TF2C does not have this
function CTFWeaponBase::IsMeleeWeapon()
	return GetSlot() == SLOT_MELEE

function CTFWeaponBase::GetWeaponClass()
	return GetClassname().slice(10)

function CTFWeaponBase::IsSniperRifle()
	return startswith(GetWeaponClass(), "sniperrifle")

function CTFWeaponBase::IsBow()
	return startswith(GetWeaponClass(), "compound")

function CTFWeaponBase::IsMinigun()
	return startswith(GetWeaponClass(), "minigun")

function CTFWeaponBase::IsFlamethrower()
	return startswith(GetWeaponClass(), "flamethrower")

function CTFWeaponBase::IsMedigun()
	return startswith(GetWeaponClass(), "medigun")

function CTFWeaponBase::IsKnife()
	return startswith(GetWeaponClass(), "knife")

function CTFWeaponBase::IsSword()
	return startswith(GetWeaponClass(), "sword") || startswith(GetWeaponClass(), "katana")

function CTFWeaponBase::IsBottle()
	return startswith(GetWeaponClass(), "bottle")

function CTFWeaponBase::IsRocketLauncher()
	return startswith(GetWeaponClass(), "rocketlauncher") || startswith(GetWeaponClass(), "particle_cannon")

function CTFWeaponBase::IsPipeLauncher()
	return startswith(GetWeaponClass(), "grenadelauncher") || startswith(GetWeaponClass(), "cannon")

function CTFWeaponBase::IsStickyLauncher()
	return startswith(GetWeaponClass(), "pipebomblauncher")

function CTFWeaponBase::IsStickbomb()
	return startswith(GetWeaponClass(), "stickbomb")

function CTFWeaponBase::IsScattergun()
	return startswith(GetWeaponClass(), "scattergun") || startswith(GetWeaponClass(), "handgun_scout") || startswith(GetWeaponClass(), "soda_popper") || startswith(GetWeaponClass(), "pep_brawler")

function CTFWeaponBase::IsFlaregun()
	return startswith(GetWeaponClass(), "flaregun")

function CTFWeaponBase::IsFish()
	return startswith(GetWeaponClass(), "bat_fish") || startswith(GetWeaponClass(), "slap")


function CTFWeaponBase::GetChargePercent()
{
	if(!IsSniperRifle())
		return 0.0
	return GetPropFloat(this, "m_flChargedDamage") / 150.0
}

/** 
 * @param {float} time
 */
function CTFWeaponBase::SetNextAttack(time)
{
	SetPropFloat(this, "LocalActiveWeaponData.m_flNextPrimaryAttack", time)
}
function CTFWeaponBase::GetNextAttack()
{
	return GetPropFloat(this, "LocalActiveWeaponData.m_flNextPrimaryAttack")
}

function CTFWeaponBase::CanChargeCrit()
{
	if (IsSword() || IsBottle())
		return true
	// else if (IsStickbomb()) //valve moment
		// return true
	return false
}

function CTFWeaponBase::IsZoomed()
{
	if (!IsSniperRifle() || !GetOwner())
		return false
	return GetOwner().GetActiveWeapon() == this && GetOwner().InCond(TF_COND_ZOOMED)
}

function CTFWeaponBase::GetJarateTime()
{
	if (GetPropFloat(this, "m_flChargedDamage") == 0.0)
		return 0.0
	return GetJarateTimeInternal()
}
function CTFWeaponBase::ZoomOut()
{
	/** @type {CTFPlayer|null} */
	local pPlayer = GetOwner()

	if ( !pPlayer )
		return

	pPlayer.RemoveCondEx( TF_COND_AIMING, true )
	pPlayer.TeamFortress_SetSpeed()

	// if we are thinking about zooming, cancel it
	SetPropFloat(this, "m_flUnzoomTime", -1.0)
	SetPropFloat(this, "m_flRezoomTime", -1.0)
	AddAttribute("no_jump", 0, -1)
	SetPropBool(this, "m_bRezoomAfterShot", false)
	SetPropFloat(this, "m_flChargedDamage", 0.0)
}

function CTFWeaponBase::BackstabBlocked()
{
	local pPlayer = GetOwner()
	if ( !pPlayer )
		return

	SetPropFloat(pPlayer, "m_flNextAttack", Time() + 2.0)

	// m_flBlockedTime = gpGlobals->curtime;
	// SendWeaponAnim( ACT_MELEE_VM_STUN );
}

function CTFWeaponBase::GetJarateTimeInternal()
{
	local flMaxJarateTime = GetAttribute("jarate duration", 0.0)
	if ( flMaxJarateTime > 0.0 )
		return MATH.RemapValClamped( GetPropFloat(this, "m_flChargedDamage"), TF_WEAPON_SNIPERRIFLE_DAMAGE_MIN, TF_WEAPON_SNIPERRIFLE_DAMAGE_MAX, 2.0, flMaxJarateTime )

	return 0.0
}


function CTFWeaponBase::GetSpeedMod()
{
	if (!GetAttribute("mod shovel speed boost", 0))
		return 1.0
	local healthRatio = GetHealth().tofloat() / GetMaxHealth().tofloat()
	if ( healthRatio > 0.8 )
		return 1.0
	else if ( healthRatio > 0.6 )
		return 1.1
	else if ( healthRatio > 0.4 )
		return 1.2
	else if ( healthRatio > 0.2 )
		return 1.4
	else
		return 1.6
}

function CTFWeaponBase::GetSwordSpeedMod()
{
	if (!GetOwner())
		return 1.0
	return 1.0 + (MATH.Min( MAX_DECAPITATIONS, GetOwner().GetHeads() ) * 0.08);
}

/**
 * Returns if the weapon is capable of stomping
 */
function CTFWeaponBase::CanStomp()
{
	local canstomp = (GetAttribute("boots falling stomp", 0) != 0 || GetAttribute("thermal_thruster", 0) != 0)
	if (!GetOwner())
		return canstomp
	else if (GetAttribute("provide on active", 0) && GetOwner().GetActiveWeapon() != this)
		return false
	return canstomp
}

function CTFWeaponBase::GetKillComboCount()
	return GetPropInt(this, "NonLocalTFWeaponData.m_nKillComboCount")

/** 
 * @type {function}
 * @param {float} flDelay
 * @returns {float}
 */
function CTFWeaponBase::ApplyFireDelay( flDelay )
{
	local flDelayMult = 1.0
	flDelayMult *= GetAttribute("fire rate penalty", 1.0)
	flDelayMult *= GetAttribute("fire rate bonus", 1.0)
	flDelayMult *= GetAttribute("fire rate penalty HIDDEN", 1.0)
	flDelayMult *= GetAttribute("fire rate bonus HIDDEN", 1.0)
	flDelayMult *= GetAttribute("melee attack rate bonus", 1.0)

	local flComboBoost = GetAttribute("kill combo fire rate boost", 1.0)
	flComboBoost *= GetKillComboCount()

	flDelayMult -= flComboBoost

	// Haste Powerup Rune adds multiplier to fire delay time. Flare guns get double boost
	/** @type {CTFPlayer|null} */
	local pPlayer = GetOwner() && GetOwner().IsPlayer() ? GetOwner() : null
	if ( pPlayer && pPlayer.GetCurrentRune() == RUNE_HASTE )
	{
		if ( pPlayerIsPlayerClass( TF_CLASS_PYRO ) && IsFlaregun() )
			flDelayMult *= 0.25
		else if ( pPlayer.InCond( TF_COND_POWERUPMODE_DOMINANT ) )
			flDelayMult *= 0.75
		else
			flDelayMult *= 0.50
	}
	else if ( pPlayer && ( pPlayer.GetCurrentRune() == RUNE_KING || pPlayer.InCond( TF_COND_KING_BUFFED ) ) )
		flDelayMult *= 0.75

	return flDelay * flDelayMult
}

if (!("CTakeDamageInfo" in ROOT))
	class ::CTakeDamageInfo {}

if (!("KeyValues" in ROOT))
	class ::KeyValues {}

if (!("WeaponData_t" in ROOT))
{
	class ::WeaponData_t
	{
		m_nDamage = 0
		m_nBulletsPerShot = 0
		m_flRange = 0.0
		m_flSpread = 0.0
		m_flPunchAngle = 0.0
		m_flTimeFireDelay = 0.0 			// Time to delay between firing
		m_flTimeIdle = 0.0					// Time to idle after firing
		m_flTimeIdleEmpty = 0.0				// Time to idle after firing last bullet in clip
		m_flTimeReloadStart = 0.0			// Time to start into a reload (ie. shotgun)
		m_flTimeReload = 0.0				// Time to reload
		m_bDrawCrosshair = true				// Should the weapon draw a crosshair
		m_iProjectile = ProjectileType_t.TF_PROJECTILE_NONE	// The type of projectile this mode fires
		m_iAmmoPerShot = 0					// How much ammo each shot consumes
		m_flProjectileSpeed = 0.0			// Start speed for projectiles (nail, etc.); NOTE: union with something non-projectile
		m_flSmackDelay = 0.0				// how long after swing should damage happen for melee weapons
		m_bUseRapidFireCrits = false

		constructor();
	}
}

if (!("itemFlags_t" in ROOT))
{
	class ::itemFlags_t {
		m_pFlagName = ""
		m_iFlagValue = 0
		constructor(name, value) {
			this.m_pFlagName = name
			this.m_iFlagValue = value
		}
	}

	::g_ItemFlags <- [
		itemFlags_t("ITEM_FLAG_SELECTONEMPTY", ITEM_FLAG_SELECTONEMPTY)
		itemFlags_t("ITEM_FLAG_SELECTONEMPTY",	ITEM_FLAG_SELECTONEMPTY)
		itemFlags_t("ITEM_FLAG_NOAUTORELOAD",		ITEM_FLAG_NOAUTORELOAD)
		itemFlags_t("ITEM_FLAG_NOAUTOSWITCHEMPTY", ITEM_FLAG_NOAUTOSWITCHEMPTY)
		itemFlags_t("ITEM_FLAG_LIMITINWORLD",		ITEM_FLAG_LIMITINWORLD)
		itemFlags_t("ITEM_FLAG_EXHAUSTIBLE",		ITEM_FLAG_EXHAUSTIBLE)
		itemFlags_t("ITEM_FLAG_DOHITLOCATIONDMG", ITEM_FLAG_DOHITLOCATIONDMG)
		itemFlags_t("ITEM_FLAG_NOAMMOPICKUPS",	ITEM_FLAG_NOAMMOPICKUPS)
		itemFlags_t("ITEM_FLAG_NOITEMPICKUP",		ITEM_FLAG_NOITEMPICKUP)
	]
}

if (!("FileWeaponInfo_t" in ROOT))
{
	class ::FileWeaponInfo_t
	{
		constructor() {}
		// Each game can override this to get whatever values it wants from the script.
		/** 
		 * @param {KeyValues} pKeyValuesData
		 * @param {string} szWeaponName
		 */
		function Parse( pKeyValuesData, szWeaponName )
		{
			local function GetKey( name, def ) {
				if (name in pKeyValuesData)
					return pKeyValuesData[name]
				else return def
			}
			// Okay, we tried at least once to look this up...
			bParsedScript = true

			// Classname
			szClassName 		= szWeaponName
			// Printable name
			szPrintName 		= GetKey( "printname", WEAPON_PRINTNAME_MISSING )
			// View model & world model
			szViewModel 		= GetKey( "viewmodel", "" )
			szWorldModel 		= GetKey( "playermodel", "" )
			szAnimationPrefix 	= GetKey( "anim_prefix", "" )
			iSlot 				= GetKey( "bucket", 0 )
			iPosition 			= GetKey( "bucket_position", 0 )

			iMaxClip1 			= GetKey( "clip_size", WEAPON_NOCLIP )					// Max primary clips gun can hold (assume they don't use clips by default)
			iMaxClip2 			= GetKey( "clip2_size", WEAPON_NOCLIP )					// Max secondary clips gun can hold (assume they don't use clips by default)
			iDefaultClip1 		= GetKey( "default_clip", iMaxClip1 )			// amount of primary ammo placed in the primary clip when it's picked up
			iDefaultClip2 		= GetKey( "default_clip2", iMaxClip2 )		// amount of secondary ammo placed in the secondary clip when it's picked up
			iWeight 			= GetKey( "weight", 0 )

			iRumbleEffect 		= GetKey( "rumble", -1 )
			
			// LAME old way to specify item flags.
			// Weapon scripts should use the flag names.
			iFlags 				= GetKey( "item_flags", ITEM_FLAG_LIMITINWORLD )

			for ( local i = 0; i < g_ItemFlags.len(); i++ )
			{
				local iVal = GetKey( g_ItemFlags[i].m_pFlagName, -1 );
				if ( iVal == 0 )
				{
					iFlags = iFlags & ~g_ItemFlags[i].m_iFlagValue;
				}
				else if ( iVal == 1 )
				{
					iFlags = iFlags | g_ItemFlags[i].m_iFlagValue;
				}
			}


			bShowUsageHint = ( GetKey( "showusagehint", 0 ) != 0 )
			bAutoSwitchTo = ( GetKey( "autoswitchto", 1 ) != 0 )
			bAutoSwitchFrom = ( GetKey( "autoswitchfrom", 1 ) != 0 )
			m_bBuiltRightHanded = ( GetKey( "BuiltRightHanded", 1 ) != 0 )
			m_bAllowFlipping = ( GetKey( "AllowFlipping", 1 ) != 0 )
			m_bMeleeWeapon = ( GetKey( "MeleeWeapon", 0 ) != 0 )

			// Primary ammo used
			local pAmmo = GetKey( "primary_ammo", "None" )
			if ( pAmmo == "None" )
				szAmmo1 = ""
			else
				szAmmo1 = pAmmo
			iAmmoType = -1
			// iAmmoType = GetAmmoDef()->Index( szAmmo1 );
			
			// Secondary ammo used
			pAmmo = GetKey( "secondary_ammo", "None" );
			if ( pAmmo == "None" )
				szAmmo2 = ""
			else
				szAmmo2 = pAmmo
			iAmmo2Type = -1
			// iAmmo2Type = GetAmmoDef()->Index( szAmmo2 );

			// Now read the weapon sounds
			/* KeyValues *pSoundData = pKeyValuesData->FindKey( "SoundData" );
			if ( pSoundData )
			{
				for ( int i = EMPTY; i < NUM_SHOOT_SOUND_TYPES; i++ )
				{
					local soundname = pSoundData->GetString( pWeaponSoundCategories[i] );
					if ( soundname && soundname[0] )
					{
						Q_strncpy( aShootSounds[i], soundname, MAX_WEAPON_STRING );
					}
				}
			} */
		}

		bParsedScript 		= false
		bLoadedHudElements 	= false

		// SHARED
		szClassName 		= ""
		szPrintName 		= ""			// Name for showing in HUD, etc.

		szViewModel			= ""			// View model of this weapon
		szWorldModel 		= ""		// Model of this weapon seen carried by the player
		szAnimationPrefix 	= ""	// Prefix of the animations that should be used by the player carrying this weapon
		iSlot 				= 0									// inventory slot.
		iPosition			= 0								// position in the inventory slot.
		iMaxClip1			= 0								// max primary clip size (-1 if no clip)
		iMaxClip2			= 0								// max secondary clip size (-1 if no clip)
		iDefaultClip1 		= 0							// amount of primary ammo in the gun when it's created
		iDefaultClip2 		= 0							// amount of secondary ammo in the gun when it's created
		iWeight 			= 0										// this value used to determine this weapon's importance in autoselection.
		iRumbleEffect 		= 0							// Which rumble effect to use when fired? (xbox)
		bAutoSwitchTo 		= false							// whether this weapon should be considered for autoswitching to
		bAutoSwitchFrom 	= false						// whether this weapon can be autoswitched away from when picking up another weapon or ammo
		iFlags 				= 0									// miscellaneous weapon flags
		szAmmo1				= ""			// "primary" ammo type
		szAmmo2				= ""			// "secondary" ammo type

		// Sound blocks
		aShootSounds 		= array(16, "")	

		iAmmoType 			= 0
		iAmmo2Type 			= 0
		m_bMeleeWeapon 		= false		// Melee weapons can always "fire" regardless of ammo.

		// This tells if the weapon was built right-handed (defaults to true).
		// This helps cl_righthand make the decision about whether to flip the model or not.
		m_bBuiltRightHanded = false
		m_bAllowFlipping 	= false	// False to disallow flipping the model, regardless of whether
													// it is built left or right handed.
		// SERVER DLL

	}
}

if (!("CTFWeaponInfo" in ROOT))
{
	class ::CTFWeaponInfo extends FileWeaponInfo_t
	{
		constructor()
		{
			m_WeaponData[0] = FileWeaponInfo_t()
			m_WeaponData[1] = FileWeaponInfo_t()

			m_bGrenade = false
			m_flDamageRadius = 0.0
			m_flPrimerTime = 0.0
			m_bSuppressGrenTimer = false
			m_bLowerWeapon = false

			m_bHasTeamSkins_Viewmodel = false
			m_bHasTeamSkins_Worldmodel = false

			m_szMuzzleFlashModel = ""
			m_flMuzzleFlashModelDuration = 0.0
			m_szMuzzleFlashParticleEffect = ""

			m_szTracerEffect = ""

			m_szBrassModel = ""
			m_bDoInstantEjectBrass = true;

			m_szExplosionSound = ""
			m_szExplosionEffect = ""
			m_szExplosionPlayerEffect = ""
			m_szExplosionWaterEffect = ""

			m_iWeaponType = TF_WPN_TYPE_PRIMARY;
		}

		function destructor() 
		{

		}
		/** 
			 * @param {KeyValues} pKeyValuesData
		 * @param {string} szWeaponName
		 */
		function Parse( pKeyValuesData, szWeaponName ) 
		{
			
			// base.Parse(pKeyValuesData, szWeaponName)

			local function GetKey( name, def ) {
				if (name in pKeyValuesData)
					return pKeyValuesData[name]
				else return def
			}
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_nDamage				= GetKey( "Damage", 0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flRange				= GetKey( "Range", 8192.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_nBulletsPerShot		= GetKey( "BulletsPerShot", 0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flSpread				= GetKey( "Spread", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flPunchAngle			= GetKey( "PunchAngle", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeFireDelay		= GetKey( "TimeFireDelay", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeIdle			= GetKey( "TimeIdle", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeIdleEmpty		= GetKey( "TimeIdleEmpy", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeReloadStart	= GetKey( "TimeReloadStart", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeReload			= GetKey( "TimeReload", 0.0 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_bDrawCrosshair		= GetKey( "DrawCrosshair", 1 ) > 0
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_iAmmoPerShot			= GetKey( "AmmoPerShot", 1 )
			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_bUseRapidFireCrits	= ( GetKey( "UseRapidFireCrits", 0 ) != 0 )

			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_iProjectile = ProjectileType_t.TF_PROJECTILE_NONE
			local pszProjectileType = GetKey( "ProjectileType", "projectile_none" )

			for ( local i = 0; i < ProjectileType_t.TF_NUM_PROJECTILES ; i++ )
			{
				if (pszProjectileType == g_szProjectileNames[i])
				{
					m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_iProjectile = i
					break
				}
			}

			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flProjectileSpeed	= GetKey( "ProjectileSpeed", 0.0 )

			m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flSmackDelay			= GetKey( "SmackDelay", 0.2 )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flSmackDelay		= GetKey( "Secondary_SmackDelay", 0.2 )

			m_bDoInstantEjectBrass = ( GetKey( "DoInstantEjectBrass", 1 ) != 0 );
			local pszBrassModel = GetKey( "BrassModel", NULL );
			if ( pszBrassModel )
				m_szBrassModel = pszBrassModel

			// Secondary fire mode.
			// Inherit from primary fire mode
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_nDamage			= GetKey( "Secondary_Damage", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_nDamage )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flRange			= GetKey( "Secondary_Range", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flRange )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_nBulletsPerShot	= GetKey( "Secondary_BulletsPerShot", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_nBulletsPerShot )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flSpread			= GetKey( "Secondary_Spread", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flSpread )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flPunchAngle		= GetKey( "Secondary_PunchAngle", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flPunchAngle )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flTimeFireDelay	= GetKey( "Secondary_TimeFireDelay", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeFireDelay )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flTimeIdle			= GetKey( "Secondary_TimeIdle", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeIdle )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flTimeIdleEmpty	= GetKey( "Secondary_TimeIdleEmpy", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeIdleEmpty )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flTimeReloadStart	= GetKey( "Secondary_TimeReloadStart", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeReloadStart )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_flTimeReload		= GetKey( "Secondary_TimeReload", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_flTimeReload )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_bDrawCrosshair		= GetKey( "Secondary_DrawCrosshair", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_bDrawCrosshair ) > 0
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_iAmmoPerShot		= GetKey( "Secondary_AmmoPerShot", m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_iAmmoPerShot )
			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_bUseRapidFireCrits	= ( GetKey( "Secondary_UseRapidFireCrits", 0 ) != 0 )

			m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_iProjectile = m_WeaponData[TF_WEAPON_PRIMARY_MODE].m_iProjectile
			pszProjectileType = GetKey( "Secondary_ProjectileType", "projectile_none" )

			for ( local i = 0; i < ProjectileType_t.TF_NUM_PROJECTILES ; i++ )
			{
				if (pszProjectileType == g_szProjectileNames[i])
				{
					m_WeaponData[TF_WEAPON_SECONDARY_MODE].m_iProjectile = i
					break
				}
			}	

			local pszWeaponType = GetKey( "WeaponType", "" )

			switch ( pszWeaponType )
			{
			case "primary":
				m_iWeaponType = TF_WPN_TYPE_PRIMARY
			break
			case "secondary":
				m_iWeaponType = TF_WPN_TYPE_SECONDARY
			break
			case "melee":
				m_iWeaponType = TF_WPN_TYPE_MELEE
			break
			case "grenade":
				m_iWeaponType = TF_WPN_TYPE_GRENADE
			break
			case "building":
				m_iWeaponType = TF_WPN_TYPE_BUILDING
			break
			case "pda":
				m_iWeaponType = TF_WPN_TYPE_PDA
			break
			case "item1":
				m_iWeaponType = TF_WPN_TYPE_ITEM1
			break
			case "item2":
				m_iWeaponType = TF_WPN_TYPE_ITEM2
			break
			}

			// Grenade data.
			m_bGrenade					= ( GetKey( "Grenade", 0 ) != 0 )
			m_flDamageRadius			= GetKey( "DamageRadius", 0.0 )
			m_flPrimerTime				= GetKey( "PrimerTime", 0.0 )
			m_bSuppressGrenTimer		= ( GetKey( "PlayGrenTimer", 1 ) <= 0 )

			m_bLowerWeapon				= ( GetKey( "LowerMainWeapon", 0 ) != 0 )
			m_bHasTeamSkins_Viewmodel	= ( GetKey( "HasTeamSkins_Viewmodel", 0 ) != 0 )
			m_bHasTeamSkins_Worldmodel	= ( GetKey( "HasTeamSkins_Worldmodel", 0 ) != 0 )

			// Model muzzleflash
			local pszMuzzleFlashModel = GetKey( "MuzzleFlashModel", null )
			if ( pszMuzzleFlashModel )
				m_szMuzzleFlashModel = pszMuzzleFlashModel

			m_flMuzzleFlashModelDuration = GetKey( "MuzzleFlashModelDuration", 0.2 )

			local pszMuzzleFlashParticleEffect = GetKey( "MuzzleFlashParticleEffect", null )
			if ( pszMuzzleFlashParticleEffect )
				m_szMuzzleFlashParticleEffect = pszMuzzleFlashParticleEffect

			// Tracer particle effect
			local pszTracerEffect = GetKey( "TracerEffect", null )
			if ( pszTracerEffect )
				m_szTracerEffect = pszTracerEffect


			// Explosion effects (used for grenades)
			local pszSound = GetKey( "ExplosionSound", null )
			if ( pszSound )
				m_szExplosionSound = pszSound

			local pszEffect = GetKey( "ExplosionEffect", null )
			if ( pszEffect )
				m_szExplosionEffect = pszEffect

			pszEffect = GetKey( "ExplosionPlayerEffect", null )
			if ( pszEffect )
				m_szExplosionPlayerEffect = pszEffect

			pszEffect = GetKey( "ExplosionWaterEffect", null )
			if ( pszEffect )
				m_szExplosionWaterEffect = pszEffect

			m_bDontDrop = ( GetKey( "DontDrop", 0 ) > 0 )
		}

		/** 
			 * @param {integer} iWeapon
		 * @returns {WeaponData_t}
		 */
		function GetWeaponData( iWeapon ) { return m_WeaponData[iWeapon] }

		/** @type {[WeaponData_t]} */
		m_WeaponData = array(2)

		m_iWeaponType = 0
		
		// Grenade.
		m_bGrenade = false
		m_flDamageRadius = 0.0
		m_flPrimerTime = 0.0
		m_bLowerWeapon = false
		m_bSuppressGrenTimer = false

		// Skins
		m_bHasTeamSkins_Viewmodel = false
		m_bHasTeamSkins_Worldmodel = false

		// Muzzle flash
		m_szMuzzleFlashModel = ""
		m_flMuzzleFlashModelDuration = 0.0
		m_szMuzzleFlashParticleEffect = ""

		// Tracer
		m_szTracerEffect = ""

		// Eject Brass
		m_bDoInstantEjectBrass = false
		m_szBrassModel = ""

		// Explosion Effect
		m_szExplosionSound = ""
		m_szExplosionEffect = ""
		m_szExplosionPlayerEffect = ""
		m_szExplosionWaterEffect = ""

		m_bDontDrop = false
	}
}

::g_tGlobalWeaponTypesByClass <- {}

/** 
 * @type {function}
 * @returns {CTFWeaponInfo}
 */
function CTFWeaponBase::GetWeaponInfo()
{
	Assert(GetClassname() in g_tGlobalWeaponTypesByClass, "No Weapon info for \""+GetClassname()+"\" !!!!!")
	return g_tGlobalWeaponTypesByClass[GetClassname()]
}

/**
 * @param {CBaseEntity|null} pVictimBaseEntity
 * @param {CTFPlayer|null} pAttacker
 * @param {CTakeDamageInfo} info
 */
function CTFWeaponBase::ApplyOnHitAttributes( pVictimBaseEntity, pAttacker, info )
{
	if ( !pAttacker )
		return

	/**@type {CTFPlayer|null} */
	local pVictim = pVictimBaseEntity && pVictimBaseEntity.IsPlayer() ? pVictimBaseEntity : null

	// Ammo on hit
	local iModAmmoOnHit = GetAttribute("add onhit addammo", 0)
	if ( iModAmmoOnHit > 0 )
	{
		// this will save the value so we can add it after we're doing firing 
		// the projectile and have subtracted the ammo for the current shot
		local flPercentage = iModAmmoOnHit.tofloat() / 100.0

		// No ammo for disguised Spies that are NOT stealthed so you can't use this to check for Spies
		if ( pVictim && 
			 pVictim.IsPlayerClass( TF_CLASS_SPY ) && 
			 pVictim.InCond( TF_COND_DISGUISED ) && 
			 (pVictim.GetDisguiseTeam() != pVictim.GetTeam()) &&
			 !( pVictim.IsStealthed() || pVictim.InCond( TF_COND_STEALTHED_BLINK ) ) )
		{
			flPercentage = 0.0
		}

		if (GetOwner())
			GetOwner().SetInternalVar("m_iAmmoToAdd", GetOwner().GetInternalVar("m_iAmmoToAdd", 0) + flPercentage * info.GetDamage())
	}

	local iExtraDamageOnHit = GetAttribute("extra damage on hit", 0)
	if ( iExtraDamageOnHit )
	{
		// Adds 'Heads'. Reusing this data field
		local iDecap = pAttacker.GetHeads()
		pAttacker.SetHeads( MATH.Min( 200, iDecap + iExtraDamageOnHit ) )
	}

	// Everything else is only for player enemies or Halloween bosses
	// We don't want buildables or the tank doing things like giving health or increasing ubercharge
	// if ( !( pVictim || dynamic_cast< CHalloweenBaseBoss* >( pVictimBaseEntity ) ) )
	// {
	// 	return;
	// }
	//TODO:

	local bIsSpyRevealed = false

	if ( pVictim )
	{
		// Reveal cloaked Spy on hit
		if ( pVictim.IsPlayerClass( TF_CLASS_SPY ) && pVictim.IsStealthed() )
		{
			local iRevealCloakedSpyOnHit = GetAttribute("reveal cloaked victim on hit", 0)
			if ( iRevealCloakedSpyOnHit > 0 )
			{
				pVictim.RemoveInvisibility()
				bIsSpyRevealed = true
			}
		}

		// Reveal disguised Spy on hit
		if ( pVictim.IsPlayerClass( TF_CLASS_SPY ) && pVictim.InCond( TF_COND_DISGUISED ) )
		{
			local iRevealDisguisedSpyOnHit = GetAttribute("reveal disguised victim on hit", 0)
			if ( iRevealDisguisedSpyOnHit > 0 )
			{
				pVictim.RemoveDisguise()
				bIsSpyRevealed = true
			}
		}

		if ( bIsSpyRevealed )
		{
			UTIL_ScreenFade( pVictim, color32(255, 255, 255, 255), 0.25, 0.1, FFADE_IN );
		}

		// On hit attributes don't work when you shoot disguised spies
		if ( pVictim.InCond( TF_COND_DISGUISED ) && pVictim.GetDisguiseTeam() != pVictim.GetTeam() )
			return
	}

	// Or from burn damage
	if ( (info.GetDamageType() & DMG_BURN) )
		return

	// Heal on hits
	local iModHealthOnHit = 0
	iModHealthOnHit += GetAttribute("heal on hit for rapidfire", 0)
	iModHealthOnHit += GetAttribute("selfdmg on hit for rapidfire", 0)
	iModHealthOnHit += GetAttribute("heal on hit for slowfire", 0)
	iModHealthOnHit += GetAttribute("selfdmg on hit for slowfire", 0)
	if ( iModHealthOnHit )
	{
		// Scale Health mod with damage dealt, input being the maximum amount of health possible
		local flScale = MATH.Clamp( info.GetDamage() / info.GetBaseDamage(), 0.0, 1.0 )
		iModHealthOnHit = MATH.Max( 3, ( iModHealthOnHit.tofloat() * flScale ).tointeger() )
	}

	// Charge meter on hit
	local flChargeRefill = GetAttribute("charge meter on hit", 0.00)
	if ( flChargeRefill > 0 )
	{
		if ( pAttacker.GetCurrentRune() != RUNE_NONE )
			flChargeRefill *= 0.2

		pAttacker.SetDemomanChargeMeter( pAttacker.GetDemomanChargeMeter() + flChargeRefill * 100.0 );
	}

	local iSpeedBoostOnHit = GetAttribute("speed_boost_on_hit", 0)
	// Speed on hit
	if ( iSpeedBoostOnHit )
		pAttacker.AddCondEx( TF_COND_SPEED_BOOST, iSpeedBoostOnHit, this )

	if ( pVictim )
	{
		if ( pVictim.InCond( TF_COND_MAD_MILK ) )
		{
			local nAmount = info.GetDamage() * 0.6
			iModHealthOnHit += nAmount;

			/** @type {CTFPlayer|null} */
			local pProvider = null
			if ( pProvider )
			{
				// Show in the medic's UI as primary healing
				SendGlobalGameEvent("player_healed", {
					patient = pAttacker.GetUserID()
					healer = pProvider.GetUserID()
					amount = iModHealthOnHit
				})

				// Give them a little bit of Uber
				local pMedigun = pProvider.GetWeaponClassname("tf_weapon_medigun")
				if ( pMedigun )
				{
					local iHealedAmount = MATH.Max( MATH.Min( pAttacker.GetMaxHealth() - pAttacker.GetHealth(), nAmount ), 0 );

					// On Mediguns, per frame, the amount of uber added is based on 
					// Default heal rate is 24per second, we scale based on that and frametime
					pMedigun.IncreaseUberChargePercent( ( iHealedAmount / 24.0 ) * FrameTime() )
				}
			}
		}
	}

	if ( pAttacker.InCond( TF_COND_REGENONDAMAGEBUFF ) )
	{
		local nAmount = info.GetDamage() * (IsCvarAllowed("tf_dev_health_on_damage_recover_percentage") ? GetCvarFloat("tf_dev_health_on_damage_recover_percentage") : 0.35)
		iModHealthOnHit += nAmount
	}

	if ( iModHealthOnHit != 0)
	{
		if ( iModHealthOnHit > 0 )
			pAttacker.HealPlayer(iModHealthOnHit, false, false, false)
		else 
			pAttacker.TakeDamageEx( pAttacker, pAttacker, this, Vector(), Vector(), abs(iModHealthOnHit), DMG_GENERIC)

		SendGlobalGameEvent("player_healonhit", {
			entindex = pAttacker.entindex()
			weapon_def_index = GetIDX()
			amount = iModHealthOnHit
		})
	}

	// Add ubercharge on hit
	if ( pAttacker.IsPlayerClass( TF_CLASS_MEDIC ) )
	{
		local flUberChargeBonus = GetAttribute("add uber charge on hit", 0.0)
		if ( flUberChargeBonus )
		{
			local pMedigun = GetOwner() ? GetOwner().GetWeaponClassname("tf_weapon_medigun") : null
			if ( pMedigun )
			{
				if ( IsPowerupMode() )
				{
					if ( pAttacker.GetCurrentRune() != RUNE_NONE )
						flUberChargeBonus *= 0.2;
					else 
						flUberChargeBonus *= 0.4;
				}
				pMedigun.IncreaseUberChargePercent( flUberChargeBonus )
			}
		}
	}
	
	// rune charge on hit
	if ( pAttacker.InCond( TF_COND_RUNE_SUPERNOVA ) )
	{
		local flMaxRuneCharge = 400.0;
		local flAdd = info.GetDamage() * ( 100.0 / flMaxRuneCharge )

		pAttacker.SetRuneCharge( pAttacker.GetRuneCharge() + flAdd )
	}

	// Increase Boost on hit
	local iBoostOnDamage = pAttacker.HookAdditiveAttributes("boost on damage")
	if ( iBoostOnDamage != 0 )
	{
		local tf_scout_hype_pep_max = IsCvarAllowed("tf_scout_hype_pep_max") ? GetCvarFloat("tf_scout_hype_pep_max") : 99.0
		local tf_scout_hype_pep_mod = IsCvarAllowed("tf_scout_hype_pep_mod") ? GetCvarFloat("tf_scout_hype_pep_mod") : 1.0
		local tf_scout_hype_pep_min_damage = IsCvarAllowed("tf_scout_hype_pep_min_damage") ? GetCvarFloat("tf_scout_hype_pep_min_damage") : 5.0
		local fHype = MATH.Min( tf_scout_hype_pep_max, pAttacker.GetScoutHypeMeter() + ( MATH.Max( tf_scout_hype_pep_min_damage, info.GetDamage() ) / tf_scout_hype_pep_mod ) )
		pAttacker.SetScoutHypeMeter( fHype )
		pAttacker.TeamFortress_SetSpeed()
	}

	// Procs!
	if ( pVictim )
	{
		// Detemine weapon speed
		// local flFireDelay = ApplyFireDelay( GetWeaponInfo().GetWeaponData( 0 ).m_flTimeFireDelay )
		local flFireDelay = 1.0
		
		// Proc chance for AOE Heal
		local flPPM = GetAttribute("aoe heal chance", 0.0)
		local flProcChance = flFireDelay * (flPPM / 60.0)
		
		if ( MATH.RandomChance() < flProcChance )
			pAttacker.AddCondEx( TF_COND_RADIUSHEAL_ON_DAMAGE, 1.0, this)

		// Proc chance for crit boost
		flPPM = GetAttribute("crits on damage", 0.0)
		flProcChance = flFireDelay * (flPPM / 60.0)
		if ( MATH.RandomChance() < flProcChance )
			pAttacker.AddCondEx( TF_COND_CRITBOOSTED_CARD_EFFECT, 3.0, this)


		// Proc chance for stun
		flPPM = GetAttribute("stun on damage", 0.0)
		flProcChance = flFireDelay * (flPPM / 60.0)
		
		if ( MATH.RandomChance() < flProcChance )
			pVictim.StunPlayer( 3.0, 1.0, TF_STUN_MOVEMENT | TF_STUN_CONTROLS, pAttacker )


		// Proc chance for AOE Blast
		flPPM = GetAttribute("aoe blast on damage", 0.0)
		flProcChance = flFireDelay * (flPPM / 60.0)

		if ( (MATH.RandomChance() < flProcChance) )
		{
			// Stun the source
			local flStunDuration = 2.0
			local flStunAmt = 1.0
			pVictim.StunPlayer( flStunDuration, flStunAmt, TF_STUN_MOVEMENT | TF_STUN_CONTROLS | TF_STUN_NO_EFFECTS, pAttacker )


			pVictim.TakeDamageCustom(pAttacker, pAttacker, this, Vector(), Vector(), 75, DMG_GENERIC, TF_DMG_CUSTOM_BLEEDING)

			// Generate an explosion and look for nearby bots
			CreateBaseExplosion({
				owner = pAttacker
				weapon = this
				origin = pVictim.GetOrigin()
				ignores = [pVictim]
				radius = 150.0 // bloat by 50 because my shit
				damage = 75
				DmgType = DMG_RADIUS_MAX
				OnlyPlayers = true
				/** 
				 * @param {CTFPlayer} pTFPlayer
				 */
				function ExplodeFunc( pTFPlayer )
				{
					if (pTFPlayer.IsDead())
						return
					if (pTFPlayer.IsInvincible())
						return
					if (!pTFPlayer.IsBot()) // disable to work on humans
						return

					pTFPlayer.StunPlayer( flStunDuration, flStunAmt, TF_STUN_MOVEMENT | TF_STUN_CONTROLS | TF_STUN_NO_EFFECTS, pAttacker )
					pTFPlayer.EmitSound( "Weapon_Upgrade.ExplosiveHeadshot" )
				}
			})
		}

	}

	local flAddDamageDoneBonusOnHit = GetAttribute("on hit add percent dmg bonus", 0.0)
	if ( flAddDamageDoneBonusOnHit )
		pAttacker.AddTmpDamageBonus( flAddDamageDoneBonusOnHit, 10.0 )
	
	if ( pVictim )
	{
		local iRageStun = 0
		iRageStun += pAttacker.HookAdditiveAttributes("generate rage on damage")
		iRageStun += pAttacker.HookAdditiveAttributes("engineer rage on dmg")
		if ( iRageStun && pAttacker.IsRageDraining() )
		{
			// MvM: Heavies can purchase a rage-based knockback+stun effect
			if ( pAttacker.IsPlayerClass( TF_CLASS_HEAVYWEAPONS ) )
				pVictim.StunPlayer( 0.25, 1.0, TF_STUN_MOVEMENT | TF_STUN_NO_EFFECTS, pAttacker );
		}

		// Slow enemy on hit, unless they're being healed by a medic
		if ( !pVictim.InCond( TF_COND_HEALTH_BUFF ) )
		{
			local flSlowEnemy = GetAttribute("slow enemy on hit", 0.0)
			if ( flSlowEnemy )
			{
				if ( MATH.RandomChance() < flSlowEnemy )
				{
					// Adjust the stun amount based on distance to the target
					// close range full stun, falls off to zero at 1536 (1024 window size)
					local vecDistance = pVictim.GetOrigin() - pAttackerGetOrigin()
					local flStunAmount = MATH.RemapValClamped( vecDistance.LengthSqr(), (512.0 * 512.0), (1536.0 * 1536.0), 0.60, 0.0 )

					pVictim.StunPlayer( 0.2, flStunAmount, TF_STUN_MOVEMENT, pAttacker );
				}
			}

			flSlowEnemy = GetAttribute("slow enemy on hit major", 0.0)
			if ( flSlowEnemy )
				pVictim.StunPlayer( flSlowEnemy, 0.4, TF_STUN_MOVEMENT, pAttacker );
		}

		// Mark for death on hit.
		local iMarkForDeath = GetAttribute("mark for death", 0)
		if ( iMarkForDeath )
		{
			// Note: this logic isn't perfect, and can do non-obvious things in certain situations. For example,
			// imagine that we've got two scouts -- if the first scout marks someone, and then the second scout marks
			// the same guy, and then the first scout marks someone else, the original victim will lose his marked-
			// for-death status. Conditions don't have any concept of owner. This could be manually tracked for this
			// condition if it becomes a problem.
			local last_target = pAttacker.GetInternalVar("m_pMarkedForDeathTarget", null)
			if (last_target != null && last_target.InCond(TF_COND_MARKEDFORDEATH) )
				last_target.RemoveCondEx( TF_COND_MARKEDFORDEATH, true )

			local tf_dev_marked_for_death_lifetime = IsCvarAllowed("tf_dev_marked_for_death_lifetime") ? GetCvarFloat("tf_dev_marked_for_death_lifetime") : 15.0

			local flDuration = pVictim.IsMiniBoss() ? tf_dev_marked_for_death_lifetime / 2 : tf_dev_marked_for_death_lifetime
			pVictim.AddCondEx( TF_COND_MARKEDFORDEATH, flDuration, pAttacker )

			pAttacker.SetInternalVar( "m_pMarkedForDeathTarget", pVictim )

			// ACHIEVEMENT_TF_MVM_SCOUT_MARK_FOR_DEATH
			if ( IsMannVsMachineMode() )
			{
				if ( pAttacker.IsPlayerClass( TF_CLASS_SCOUT ) && ( GetIDX() == 44 ) )
				{
					if ( pVictim.IsBot() && ( pVictim.GetTeam() == TF_TEAM_PVE_INVADERS ) )
						SendGlobalGameEvent("mvm_scout_marked_for_death", {
							player = pAttacker.entindex()
							// victim = pVictim.entindex()
						})
				}
			}
		}

		// Stun airborne enemies who are half a body length higher than attacker
		local bIsVictimAirborne = !( pVictim.GetFlags() & FL_ONGROUND ) && ( pVictim.GetWaterLevel() == WL_NotInWater );

		local iStunWaistHighAirborne = GetAttribute("mod stun waist high airborne", 0)
		if ( iStunWaistHighAirborne > 0 && bIsVictimAirborne )
		{
			if ( pVictim.GetCenter().z >= pAttacker.EyePosition().z )
			{
				// right in the jimmy!
				pVictim.StunPlayer( iStunWaistHighAirborne, 0.5, TF_STUN_LOSER_STATE | TF_STUN_BOTH, pAttacker );
				pVictim.EmitSound( "Halloween.PlayerScream" );
			}
		}
	}
}

/*
  =============================
  === END OF WEAPON METHODS ===
  =============================
*/

/**
 * @param {integer} ItemID
 */
function ROOT::GetItemModelName( ItemID )
{
	local wearable = CreateByClassname("tf_wearable")
	
	wearable.SetAbsAngles(QAngle(0,0,0))
	SetPropInt(wearable, "m_fEffects", 32)
	wearable.SetSolidFlags(4)
	wearable.SetCollisionGroup(11)
	
	local pootis = ItemID & ( (1 << 16) - 1)
	
	SetPropInt(wearable, PROP_ITEM_DEF_IDX, pootis)
	SetPropInt(wearable, "m_AttributeManager.m_Item.m_bInitialized", 1)
	
	wearable.DispatchSpawn()

	local modelname = wearable.GetModelName()
	wearable.Kill()
	
	return modelname
}

::NoFormatToEcon <- [
	"GetSpellCharges",
	"AddAbilityTime",
	"SetAbilityTime",
	"ModifySpells",
	"SetSpellIndex",
	"GetSpellIndex",
	"DecreaseUberChargePercent",
	"GetUberChargePercent",
	"SetUberChargePercent",
	"IncreaseUberChargePercent",
	"IncrementSpellCharge",
	"SetSpellCharges",
	"SetChargeTime",
	"GetChargeTime",
	"GetDefaultChargeTime",
	"GetSwordSpeedMod",
	"IsSniperRifle",
	"IsBow",
	"IsMinigun",
	"GetSpeedMod",
	"ShootPosition",
]
/*
  ==========================
  === ECONENTITY METHODS ===
  ==========================
*/

foreach ( key, value in CTFWeaponBase )
{
	if ( typeof( value ) == "function" )
	{
		if (NoFormatToEcon.find(key) != null)
			continue
		CEconEntity[ key ] <- value
	}
}

function CEconEntity::IsMeleeWeapon()
	return false

function CEconEntity::GetSlot()
	return -1

/*
  =================================
  === END OF ECONENTITY METHODS ===
  =================================
*/

/*
  ====================
  === TANK METHODS ===
  ====================
*/

function CTFBaseBoss::Disabledamage( events = true )
	SetPropInt(this, "m_takedamage", events ? DAMAGE_EVENTS_ONLY : DAMAGE_NO)
/**
 * @param {integer} perc
 * @param {function} callback
 */
function CTFBaseBoss::RegisterHurtPercentCallback( perc, callback )
{
	local OutputName = format("OnHealthBelow%sPercent", perc.tostring())
	GetScope(this)[OutputName] <- callback
	ConnectOutput(OutputName, OutputName)
}

/*
  ===========================
  === END OF TANK METHODS ===
  ===========================
*/

/*
  =======================
  === NAVMESH METHODS ===
  =======================
*/

// TheNavMesh!
function CNavMesh::GetNav() 
{
	local t = {}
	GetAllAreas(t)
	return t
}
/**
 * @param {table|bool} SavedNav
 * @returns {CTFNavArea}
 */
function CNavMesh::GetLargestArea( NoSpawns = false, SavedNav = false )
{
	local areas = SavedNav ? SavedNav : GetNav()
	local lArea = 0.0
	local lMesh = null
	foreach (_, mesh in areas)
	{
		if (NoSpawns && mesh.IsTFInSpawnroom())
			continue
		local a = mesh.GetArea()
		if (a > lArea)
		{
			lArea = a
			lMesh = mesh
		}
	}
	return lMesh
}

/*
  ==============================
  === END OF NAVMESH METHODS ===
  ==============================
*/

/*
  =======================
  === NAVAREA METHODS ===
  =======================
*/

function CTFNavArea::GetArea()
	return sqrt(GetSizeX()*GetSizeY())

function CTFNavArea::GetLargestSide()
	return GetSizeX() > GetSizeY() ? GetSizeX() : GetSizeY()

function CTFNavArea::IsInTFSpawnroom()
	return HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE) || HasAttributeTF(TF_NAV_SPAWN_ROOM_RED)

// typo moment
CTFNavArea.IsTFInSpawnroom <- CTFNavArea.IsInTFSpawnroom
/*
  ==============================
  === END OF NAVAREA METHODS ===
  ==============================
*/

/*
  ============================
  === CSceneEntity METHODS ===
  ============================
*/

/** 
 * @returns {CBaseEntity|null}
 */
function CSceneEntity::GetOwner()
	return GetPropEntity(this, "m_hOwner")

/** 
 * @param {CBaseEntity|null} owner
 */
function CSceneEntity::SetOwner( owner )
	SetPropEntity(this, "m_hOwner", owner)

function CSceneEntity::GetSceneName()
	return GetPropString(this, "m_iszSceneFile")

function CSceneEntity::GetSceneFileName()
	return GetPropString(this, "m_szInstanceFilename")

/*
  ===================================
  === END OF CSceneEntity METHODS ===
  ===================================
*/

/*
  ============================
  === END OF CLASS METHODS ===
  ============================
*/

/*
  ================================
  === START OF OTHER FUNCTIONS ===
  ================================
*/

/*
  ==========================
  === PRINTING FUNCTIONS ===
  ==========================
*/

function ROOT::CleanUpAndFormatString( msg, ... )
{
	if (msg == null)
		msg = "NULL"
	else 
		msg = msg.tostring()

	local args = vargv

	local leng = args.len()

	for (local i = 0; i < leng; i++) 
	{
		if (args[i] == null)
			args[i] = "NULL"
	}
	// this shit will break at one time
	try {
	if (leng > 0)
		msg = format.acall([this, msg].extend(args))
	}
	catch (e)
		return "SHIT ERRORED OUT!   "+e+"    "+__LINE__

	return msg
}

/**
 * @param {CTFPlayer|null} player
 * @param {any} message
 * @param {integer} level
 */
function ROOT::PrintBetter( player, message, level = HUD_PRINTTALK )
{
	if (message == null)
		message = "null"
	if (typeof message != "string")
		message = message.tostring()
	local PRINT = function( m ) {
		if (m.len() > MAX_CLIENT_PRINT_DATA)
		{
			printl("Warning! a Message is too long!!!")
			printl(m)
		}

		ClientPrint(player, level, m)
	}
	if (message.len() <= MAX_CLIENT_PRINT_DATA)
	{
		PRINT(message)
		return
	}

	local buffer = [{chars = 0, strings = []}]

	local string_buff = split(message, " ")

	local stringidx = 0
	foreach ( string in string_buff )
	{
		local idx = buffer.len() - 1

		if (!("chars" in buffer[idx]))
			buffer[idx].chars <- 0
		if (!("strings" in buffer[idx]))
			buffer[idx].strings <- []

		local chars = buffer[idx].chars
		local strings = buffer[idx].strings

		if (chars + (string.len()+1) > MAX_CLIENT_PRINT_DATA)
		{
			foreach (str in strings)
				buffer[idx].strings[strings.find(str)] = str + " "

			buffer.append({chars = 0, strings = []})

			PRINT(ArrayToString(buffer[idx].strings))
		}

		buffer[idx].chars += (string.len()+1)
		buffer[idx].strings.append(string)

		if (stringidx+1 == string_buff.len())
		{
			foreach (str in strings)
				buffer[idx].strings[strings.find(str)] = str + " "
			PRINT(ArrayToString(buffer[idx].strings))
		}

		stringidx++
	}
}

////// HUD PRINTS //////
function ROOT::PrintToHudAll( msg )
	PrintBetter(null, msg, HUD_PRINTCENTER)
/**
 * @param {string} msg
 */
function ROOT::PrintToHudAllF( msg, ... )
	PrintBetter(null, CleanUpAndFormatString.acall([this, msg].extend(vargv)), HUD_PRINTCENTER)
function ROOT::TranslateToHudAll( ... )
{
	foreach (player in m_aHumans)
		player.TranslateToHud.acall([player].extend(vargv))
}
/**
 * @param {string} msg
 */
function ROOT::PrintToHudAllFilter( msg, filter = [] )
{
	ReCalculatePlayers()
	local plrs = Players.filter(@(_, p) !IsInArray(p, filter))
	foreach (player in plrs)
		player.PrintToHud(msg)
}
///// CHAT PRINTS /////
function ROOT::PrintToChatAll( msg )
	PrintBetter(null, msg, HUD_PRINTTALK)

function ROOT::PrintToChatAllF( msg, ... )
	PrintBetter(null, CleanUpAndFormatString.acall([this, msg].extend(vargv)), HUD_PRINTTALK)

function ROOT::TranslateToChatAll( ... )
{
	foreach (player in m_aHumans)
		player.TranslateToChat.acall([player].extend(vargv))
}
/**
 * @param {string} msg
 */
function ROOT::PrintToChatAllFilter( msg, filter = [] )
{
	ReCalculatePlayers()
	local plrs = Players.filter(@(_, p) !IsInArray(p, filter))
	foreach (player in plrs)
		player.PrintToChat(msg)
}

///// CONSOLE PRINTS /////
function ROOT::PrintToConsoleAll( msg )
	PrintBetter(null, msg, HUD_PRINTCONSOLE)
/**
 * @param {string} msg
 */
function ROOT::PrintToConsoleAllF( msg, ... )
	PrintBetter(null, CleanUpAndFormatString.acall([this, msg].extend(vargv)), HUD_PRINTCONSOLE)

///// OTHER PRINTS /////
function ROOT::PrintToAdmins( level, message )
{
	foreach (player in m_aHumans)
	{
		if (!player.IsAdmin())
			continue
		PrintBetter(player, message, level)
	}
}
/**
 * @param {table} table
 */
function ROOT::PrintTable( table, filter = [] )
	PrintCollection(table, filter)
/**
 * @param {array} array
 */
function ROOT::PrintArray( array, filter = [] )
	PrintCollection(array, filter)
/**
 * @param {class} clas
 */
function ROOT::PrintClass( clas, filter = [] )
	PrintCollection(clas, filter)
/**
 * @param {instance} inst
 */
function ROOT::PrintInstance( inst, filter = [] )
	PrintCollection(inst, filter)
/**
 * @param {table|array|class|instance} collection
 */
function ROOT::PrintCollection( collection, filter = [], indentation = 0, header_prefix = "", indentation_string = "\t" )
{
	local type = typeof collection
	local obj_class = null
	try {
		obj_class = collection.getclass()
		if (collection instanceof CBaseEntity)
			type = "entity"
		else
			type = "instance"
	}
	catch(e) {}

	// printf("got %s for the class of %s\n", obj_class.tostring(), collection.tostring())

	if (type != "table" && type != "array" && type != "class" && type != "instance")
	{
		PrintToConsoleAll("Trying to PrintCollection() a " + type)
		return
	}

	Assert(indentation >= 0, "Indentation Cannot be Negative in PrintCollection()")

	// Calculate indentation
	local indents = ""
	for (local i = 0; i < indentation; i++) {
		indents += indentation_string
	}

	local header_str = ""
	if (typeof header_prefix == "bool")
		header_str = header_prefix ? "" : indents
	else if (typeof header_prefix == "string" && header_prefix != "")
		header_str = header_prefix
	else
		header_str = indents

	PrintToConsoleAll(header_str + collection.tostring() + " " + ((type == "table" || type == "class" || type == "instance") ? "{" : "["))

	local keys_source = collection
	if (type == "instance")
	{
		keys_source = obj_class
	}

	foreach (key, value_in_source in keys_source)
	{
		// Skip internal Squirrel variables and filtered keys
		if (key == "__vname" || key == "__vrefs") continue
		if (IsInArray(key, filter)) continue

		local value = (type == "instance") ? (key in collection ? collection[key] : value_in_source) : value_in_source
		local valType = typeof value
		if (IsInArray(valType, filter)) continue
		
		local itemIndents = indents + indentation_string
		
		// If it's an array, show [index] for clarity
		local keyDisplay = (type == "array") ? "[" + key + "]" : key
		
		if ((valType == "table" || valType == "array" || valType == "class" || (valType == "instance" && !(value instanceof CBaseEntity))) && indentation < 10)
		{
			local prefix = itemIndents + keyDisplay + " : "
			PrintCollection(value, filter, indentation + 1, prefix)
		}
		else if (valType == "function" || valType == "native function")
			PrintToConsoleAll(itemIndents + "function ( " + keyDisplay + " ): " + value)
		else
			PrintToConsoleAll(itemIndents + keyDisplay + " : " + value)
	}
	PrintToConsoleAll(indents + ((type == "table" || type == "class" || type == "instance") ? "}" : "]"))
}

/*
  =================================
  === END OF PRINTING FUNCTIONS ===
  =================================
*/

/*
  =======================================
  === START OF ENTITY DEBUG FUNCTIONS ===
  =======================================
*/

//// Entity Debug
function ROOT::ShowBBOX( entity, rgb = Vector( 255, 0, 0 ), alpha = 5, duration = 5 )
{
	Assert(entity, "ROOT::ShowBBOX Missing Entity")
	DebugDrawBox(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgb.x.tointeger(), rgb.y.tointeger(), rgb.z.tointeger(), alpha,  duration)
}

function ROOT::ShowOBB( entity, rgb = Vector( 255, 0, 0 ), alpha = 5, duration = 5 )
{
	Assert(entity, "ROOT::ShowOBB Missing Entity")
	DebugDrawBoxAngles(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), entity.GetAbsAngles(), Vector(rgb.x, rgb.y, rgb.z), alpha, duration)
}

function ROOT::ShowAABB( entity, rgb = Vector( 255, 0, 0 ), alpha = 5, duration = 5 )
{
	Assert(entity, "ROOT::ShowAABB Missing Entity")
	DebugDrawBox(entity.GetOrigin(),entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgb.x.tointeger(), rgb.y.tointeger(), rgb.z.tointeger(), alpha, duration)
}

function ROOT::DebugDrawTrigger( trigger, color = Vector( 255, 128, 0 ), alpha = 5, duration = 5 )
{
	Assert(trigger, "ROOT::DebugDrawTrigger Missing Trigger")

	if (trigger.GetSolid() == 2)
		DebugDrawBox(trigger.GetOrigin(), GetPropVector(trigger, "m_Collision.m_vecMins"), GetPropVector(trigger, "m_Collision.m_vecMaxs"), color.x.tointeger(), color.y.tointeger(), color.z.tointeger(), alpha, duration)
	else if (trigger.GetSolid() == 3)
		DebugDrawBoxAngles(trigger.GetOrigin(), GetPropVector(trigger, "m_Collision.m_vecMins"), GetPropVector(trigger, "m_Collision.m_vecMaxs"), trigger.GetAbsAngles(), Vector( color.x, color.y, color.z ), alpha, duration)
}
/*
  =====================================
  === END OF ENTITY DEBUG FUNCTIONS ===
  =====================================
*/
// TODO: MOVE TO GENERAL FUNCTIONS
function ROOT::IsListenServer()
	return !IsDedicatedServer()
	
/*
  ========================
  === ENTITY FUNCTIONS ===
  ========================
*/
/// Credit to LizardOfOz in TF2Maps Discord
function ROOT::EnableStringPurge( entity )
{
	if ( !entity )
		return entity
	NetProps.SetPropBool(entity, "m_bForcePurgeFixedupStrings", true)
	return entity
}

function ROOT::CreateByClassname( classname )
	return EnableStringPurge(Entities.CreateByClassname(classname))

function ROOT::FindByClassname( previous, classname )
	return EnableStringPurge(Entities.FindByClassname(previous, classname))
/**
 * @param {string} classname
 * @param {Vector} center
 * @param {integer|float} radius
 */
function ROOT::FindByClassnameNearest( classname, center, radius )
	return EnableStringPurge(Entities.FindByClassnameNearest(classname, center, radius))
/**
 * @param {CBaseEntity|null} previous
 * @param {Vector} center
 */
function ROOT::FindByClassnameWithin( previous, classname, center, radius )
	return EnableStringPurge(Entities.FindByClassnameWithin(previous, classname, center, radius))
/**
 * @param {CBaseEntity|null} previous
 * @param {string} modelname
 */
function ROOT::FindByModel( previous, modelname )
	return EnableStringPurge(Entities.FindByModel(previous, modelname))
/**
 * @param {CBaseEntity|null} previous
 */
function ROOT::FindByName( previous, name )
	return EnableStringPurge(Entities.FindByName(previous, name))
/**
 * @param {string} targetname
 * @param {Vector} center
 * @param {integer|float} radius
 */
function ROOT::FindByNameNearest( targetname, center, radius )
	return EnableStringPurge(Entities.FindByNameNearest(targetname, center, radius))

/**
 * @param {CBaseEntity|null} previous
 * @param {string} targetname
 * @param {Vector} center
 * @param {integer|float} radius
 */
function ROOT::FindByNameWithin( previous, targetname, center, radius )
	return EnableStringPurge(Entities.FindByNameWithin(previous, targetname, center, radius))
/**
 * @param {CBaseEntity|null} previous
 * @param {string} target
 */
function ROOT::FindByTarget( previous, target )
	return EnableStringPurge(Entities.FindByTarget(previous, target))

/**
 * @param {CBaseEntity|null} previous
 * @param {Vector} center
 * @param {integer|float} radius
 */
function ROOT::FindInSphere( previous, center, radius )
	return EnableStringPurge(Entities.FindInSphere(previous, center, radius))


/**
 * @returns {CBaseEntity}
 */
function ROOT::FirstEntity()
	return EnableStringPurge(Entities.First())
/**
 * @param {CBaseEntity} previous
 */
function ROOT::NextEntity( previous )
	return EnableStringPurge(Entities.Next(previous))


if (!("SpawnEntityFromTableOriginal" in ROOT))
   ::SpawnEntityFromTableOriginal <- ::SpawnEntityFromTable
function ROOT::SpawnEntityFromTable( name, keyvalues )
	return EnableStringPurge(SpawnEntityFromTableOriginal(name, keyvalues))
if (!("_AddThinkToEnt" in ROOT))
{
	::_AddThinkToEnt <- AddThinkToEnt
	/**
	 * Override the base AddThinkToEnt with a better function that does purging and allows the 
	 * think function to be a function, by adding it into the entitys scope as __InternalThinkFunc
	 * @param {CBaseEntity} entity
	 * @param {function|string|null} think_func
	 */
	function ROOT::AddThinkToEnt( entity, think_func )
	{
		if (think_func == null)
			think_func = ""
		if (type(think_func) == "string")
		{
			_AddThinkToEnt(entity, think_func)
		}
		else if (type(think_func) == "function")
		{
			local function __InternalThinkFunc() {return think_func()}
			GetScope(entity).__InternalThinkFunc <- __InternalThinkFunc
			_AddThinkToEnt(entity, "__InternalThinkFunc")
		}
		PurgeString(think_func)
		PurgeString(entity)
		PurgeString("__InternalThinkFunc")
	}
}

function ROOT::GetScope( entity )
{
	if (!entity || !entity.IsValid())
		return null
	entity.ValidateScriptScope()
	return entity.GetScriptScope()
}
/**
 * @returns {[CBaseEntity]} Empty Array or Array of CBaseEntity
 */
function ROOT::GetAllEntitiesByClassname( classname )
{
	local list = []
	for (local entity; entity = FindByClassname(entity, classname); )
	{
		if (entity != null) list.append(entity)
	}
	return list
}
/**
 * @param {Vector} center
 * @returns {[CBaseEntity]} Empty Array or Array of CBaseEntity
 */
function ROOT::GetAllEntitiesByClassnameWithin( classname, center, radius )
{
	local list = []
	for (local entity; entity = FindByClassnameWithin(entity, classname, center, radius); )
	{
		if (entity != null) list.append(entity)
	}
	return list
}
/**
 * @param {string} targetname
 * @returns {[CBaseEntity]} Empty Array or Array of CBaseEntity
 */
function ROOT::GetAllEntitiesByTargetname( targetname )
{
	local list = []
	for (local entity; entity = FindByName(entity, targetname); )
	{
		if (entity != null) list.append(entity)
	}
	return list
}
/**
 * @param {string} targetname
 * @param {Vector} center
 * @param {integer|float} radius
 * @returns {[CBaseEntity]} Empty Array or Array of CBaseEntity
 */
function ROOT::GetAllEntitiesByTargetnameWithin( targetname, center, radius )
{
	local list = []
	for (local entity; entity = FindByNameWithin(entity, targetname, center, radius); )
	{
		if (entity != null) list.append(entity)
	}
	return list
}
/**
 * @returns {[CTFPlayer]} Empty Array or Array of CTFPlayer
 */
function ROOT::GetAllPlayers( team = false, radius = false, alive = true )
{
	local players = []
 
	if (type(radius) == "array")
	{
		foreach (player in GetAllEntitiesByClassnameWithin("player", radius[0], radius[1]))
		{
			if (team) { if (player.GetTeam() != team) continue }
			if (alive) { if (!player.IsAlive()) continue }
			
			players.append(player)
		}
	}
	else
	{
		foreach (player in GetAllEntitiesByClassname("player"))
		{
			if (team) { if (player.GetTeam() != team) continue }
			if (alive) { if (!player.IsAlive()) continue }
			
			players.append(player)
		}
	}
	return players
}
/**
 * @returns {[CTFBaseBoss]} Empty Array or Array of CTFBaseBoss
 */
function ROOT::GetEveryTank()
{
	local list = []
	foreach	(tank in GetAllEntitiesByClassname("tank_boss"))
	{
		if (tank != null) list.append(tank)
	}
	return list
}
/**
 * @param {Vector} center
 * @param {integer|float} radius
 * @returns {[CTFBaseBoss]} Empty Array or Array of CTFBaseBoss
 */
function ROOT::GetEveryTankWithin( center, radius )
{
	local list = []
	foreach (tank in GetAllEntitiesByClassnameWithin("tank_boss", center, radius))
	{
		if (tank != null) list.append(tank)
	}
	return list
}

/**
 * @param {CBaseEntity} entity
 */
function ROOT::IsValidEnemy( entity )
{
	if (entity.GetTeam() != TF_TEAM_PVE_INVADERS) 
		return false

	foreach (classname in [ "player", "tank_boss", "obj_dispenser", "obj_sentrygun", "obj_teleporter" ])
	{
		if (entity.GetClassname() == classname)
			return true
	}
	return false
}

/** 
 * @type {function}
 * @param {CBaseEntity|CTFPlayer|CTFBot|null} entity
 * @returns {bool}
 */
function ROOT::IsValidPlayer( entity )
	return entity && entity.IsValid() && entity.IsPlayer()

/**
 * @param {CBaseEntity} entity
 */
function ROOT::IsEntityAProjectile( entity )
	return startswith(entity.GetClassname(), "tf_projectile")
	
function ROOT::CreateTestTank( origin = Vector( 0, 0, 0 ), angles = QAngle( 0, 0, 0 ) )
{
	if (FindByName(null, "Test_Tank"))
		FindByName(null, "Test_Tank").Kill()

	local tank = SpawnEntityFromTable("tank_boss", {
		targetname = "Test_Tank"
		health = (1<<31) - 1
	})
	tank.SetAbsOrigin(origin)
	tank.SetAbsAngles(angles)
	return tank
}
/**
 * @param {CBaseEntity} entity
 * @returns {CTFPlayer|null}
 */
function ROOT::GetBuilder( entity )
	return GetPropEntity(entity, "m_hBuilder")
/**
 * @param {CBaseEntity} entity
 * @returns {CTFPlayer|null}
 */
function ROOT::GetLauncher( entity )
	return GetPropEntity(entity, "m_hLauncher")
/**
 * @param {CBaseEntity} flag
 */
function ROOT::GetFlagStatus( flag )
	return GetPropInt(flag, "m_nFlagStatus")
/**
 * @param {CBaseEntity} entity
 */
function ROOT::GetState( entity )
	return GetPropInt(entity, "m_iState")
/**
 * @param {CBaseEntity} entity
 */
function ROOT::ClearThinks( entity )
{
	SetPropString(entity, "m_iszScriptThinkFunction", "")
	AddThinkToEnt(entity, "")
}
/**
 * @param {CBaseEntity} object
 */
function ROOT::IsBuilding( object )
	return startswith(object.GetClassname(), "obj_")

/**
 * @param {CBaseEntity} object
 */
function ROOT::IsTank( object )
	return endswith(object.GetClassname(), "boss")

/**
 * @param {CBaseEntity} building
 */
function ROOT::IsBuildingValid( building )
{
	if (!building) return false
	EnableStringPurge(building)
	if (!HasProp(building, "m_bServerOverridePlacement")) return false
	return GetPropBool(building, "m_bServerOverridePlacement")
}

/**
 * @param {CBaseEntity} sentry
 */
function ROOT::GetSentryAngles( sentry )
	return QAngle((GetPropFloatArray(sentry, "m_flPoseParameter", 0) * -100 + 50) * DEG2RAD, (GetPropFloatArray(sentry, "m_flPoseParameter", 1) * -360 + 180 + sentry.GetAbsAngles().y) * DEG2RAD, 0)

/**
 * @param {QAngle} Angle
 */
function ROOT::ConvertAngleToEndpoint( Angle, length = 600 )
	return Vector(cos(Angle.Pitch()) * cos(Angle.Yaw()), cos(Angle.Pitch()) * sin(Angle.Yaw()), -sin(Angle.Pitch())) * length

/**
 * @param {CBaseEntity} entity
 * @param {function} callback
 */
function ROOT::SetDestroyCallback( entity, callback )
{
	local scope = GetScope(entity)
	scope.setdelegate({}.setdelegate({
			parent   = scope.getdelegate()
			id       = entity.GetScriptId()
			index    = entity.entindex()
			callback = callback
			_get = function( k )
			{
				return parent[k]
			}
			_delslot = function( k )
			{
				if (k == id)
				{
					entity = EntIndexToHScript(index)
					local scope = GetScope(entity)
					scope.self <- entity
					callback.pcall(scope)
				}
				delete parent[k]
			}
		})
	)
}

/**
 * @param {CBaseEntity|string} target
 * @param {CBaseEntity|null} activator
 * @param {CBaseEntity|null} caller
 */
function ROOT::EntFireNew( target, action, input = "", delay = -1, activator = null, caller = null )
{
	if (typeof target != "string" && target.IsPlayer() && action == "RunScriptCode")
	{
		target.RunScriptCode(input, delay)
		return
	}
		
	if (type(target) == "string")
		DoEntFire(target, action, input, delay, activator, caller)
	else if (type(target) == "instance")
		EntFireByHandle(target, action, input, delay, activator, caller)
	PurgeString(action)
	PurgeString(input)
}

function ROOT::CreateKillIcon( icon )
{
	if (FindByClassname(null, icon))
		return FindByClassname(null, icon)
	local classicon = SpawnEntityFromTable( "info_target", { classname = icon })
	// dont know if we want to Create a class icon forever
	// and access it after puting into a global variable
	// ROOT[icon] <- classicon
	PurgeString(icon)
	return classicon;
}

function ROOT::PurgeString( string )
{
	if (!("TestPurgeString" in FatCatLibSettings))
		SetLibrarySettings()
	if (FatCatLibSettings["TestPurgeString"] == false)
		return

	if ( !string || !( 0 in string ) )
		return

	local temp = CreateByClassname( "info_null" )
	SetPropString( temp, "m_iName", string )
	EnableStringPurge(temp)
	temp.DispatchSpawn()
	// temp.Kill()
}



::Gamerules 		<- FindByClassname(null, "tf_gamerules")
::MvMStats 			<- FindByClassname(null, "tf_mann_vs_machine_stats")
::PlayerManager 	<- FindByClassname(null, "tf_player_manager")
::ObjResource 		<- FindByClassname(null, "tf_objective_resource")
::Worldspawn 		<- FirstEntity()

/**
 * Gets the Current Wave this mission is On.
 * @returns {integer}
 */
function ROOT::GetCurrentWaveNumber()
	return GetPropInt(ObjResource, "m_nMannVsMachineWaveCount")
/**
 * Gets the Total Waves in this Mission.
 * @returns {integer}
 */
function ROOT::GetMaximumWaveNumber()
	return GetPropInt(ObjResource, "m_nMannVsMachineMaxWaveCount")
/**
 * Gets this Population files Name in the scoreboard.
 * @returns {string}
 */
function ROOT::GetPopfileName()
	return GetPropString(ObjResource, "m_iszMvMPopfileName")
/**
 * Sets this Population files Name in the scoreboard.
 * @param {string} name
 */
function ROOT::SetPopfileName( name )
	SetPropString(ObjResource, "m_iszMvMPopfileName", name)

/*
  ===============================
  === END OF ENTITY FUNCTIONS ===
  ===============================
*/

/**
 * @param {CTFPlayer|CBaseEntity} target
 * @param {integer} team 
 */
function ROOT::GetClosestPlayer( target, team = TF_TEAM_BLUE, skip = 0)
{
	local dist_players = {}
	foreach (player in Players)
	{
		if (player == target || player.IsDead())
			continue
		if (player.GetTeam() != team)
			continue
		local dist = target.GetCenter().DistanceTo(player.GetCenter())
		dist_players[player] <- dist
	}
	// PrintArray(dist_players.keys())
	// PrintArray(dist_players.values())
	// PrintArray(dist_players.values().sort())

	local players = dist_players.keys()
	local distances = dist_players.values()
	local close_distances = dist_players.values().sort()

	if (dist_players.len() == 0)
		return target

	while (skip > 0)
	{
		local value = close_distances.remove(0)
		local index = distances.find(value)
		players.remove(index)
		distances.remove(index)
		skip--
	}

	if (close_distances.len() == 0)
		return target

	local closest_distance = close_distances[0]
	local player_index = distances.find(closest_distance)
	local closest = players[player_index]
	// printl(closest)

	// PrintTable(players)
	// PrintArray(distances)
	// PrintArray(close_distances)

	return closest
}


::THINKER_PERSIST <- 0
::THINKER_NO_PERSIST <- 1

function ROOT::CreateThinker( name, think_func, type = THINKER_NO_PERSIST )
{
	local Thinker = FindByName(null, name)
	if (Thinker == null) Thinker = SpawnEntityFromTable( type == THINKER_PERSIST ? "info_target" : "info_teleport_destination", { targetname = name })
	 
	AddThinkToEnt(Thinker, think_func)

	/* if (typeof think_func == "string")
		AddThinkToEnt(Thinker, think_func)
	else if (typeof think_func == "function")
	{
		local function ThinkerThink( ) {think_func( )}
 		GetScope(Thinker).ThinkerThink <- ThinkerThink
		AddThinkToEnt(Thinker, "ThinkerThink")
	} */
	return Thinker
}

function ROOT::GetPlayerReadyCount()
{
	if ( IsWaveStarted() ) 
		return 0

	local ready = 0

	local size = GetPropArraySize( Gamerules, "m_bPlayerReady" )

	for ( local i = 0; i < size; i++ ) 
		if ( GetPropBool( Gamerules, "m_bPlayerReady", i ) )
			ready++

	return ready
}

function ROOT::IsWaveStarted()
{
	if (!FindByClassname(null, "tf_gamerules"))
		return false
	if (!("IsWaveStarted" in GetScope(Gamerules)))
		GetScope(Gamerules).IsWaveStarted <- false
	return GetScope(Gamerules).IsWaveStarted
}

/** 
 * @type {function}
 * @param {CTFPlayer|null} pVictim
 * @param {color32} color
 * @param {float} fade_time
 * @param {float} fade_hold
 * @param {integer} flags
 */
function ROOT::UTIL_ScreenFade( pVictim, color, fade_time, fade_hold, flags )
	ScreenFade( pVictim, color.r, color.g, color.b, color.a, fade_time, fade_hold, flags )

/** 
 * @param {Vector} center
 * @param {float} length
 * @param {integer} r
 * @param {integer} g
 * @param {integer} b
 * @param {bool} noDepthTest
 * @param {float} flDuration
 */
function DebugDrawAxis( center, length, r, g, b, noDepthTest, flDuration)
{
	DebugDrawLine( center + Vector( 0, 0, -length ), center + Vector( 0, 0, length ), r, g, b, noDepthTest, flDuration )
	DebugDrawLine( center + Vector( 0, -length, 0 ), center + Vector( 0, length, 0 ), r, g, b, noDepthTest, flDuration )
	DebugDrawLine( center + Vector( -length, 0, 0 ), center + Vector( length, 0, 0 ), r, g, b, noDepthTest, flDuration )
}

::NDebugOverlay_CircleSegments <- 16

/** 
 * @param {Vector} center
 * @param {float} radius
 * @param {integer} r
 * @param {integer} g
 * @param {integer} b
 * @param {bool} noDepthTest
 * @param {float} flDuration
 * @param {bool} bDrawAxis
 */
function ROOT::DebugDrawSphereInternal( center, radius, r, g, b, noDepthTest, flDuration, bDrawAxis = true, segments = 16)
{
	/** @type {Vector} */
	local edge = Vector(1, 1, 1)
	/** @type {Vector} */
	local lastEdge = Vector()

	local Line = DebugDrawLine
	if (bDrawAxis)
		DebugDrawAxis( center, radius, r, g, b, noDepthTest, flDuration )

	lastEdge = Vector( radius + center.x, center.y, center.z )

	local CircleAngle = 360.0 / NDebugOverlay_CircleSegments.tofloat()

	if (segments != 16)
		CircleAngle = 360.0 / segments.tofloat()

	/** @type {float} */
	local angle = 0.0
	for ( angle = 0.0; angle <= 360.0; angle += CircleAngle )
	{
		edge.x = radius * cos( angle / 180.0 * PI ) + center.x
		edge.y = center.y
		edge.z = radius * sin( angle / 180.0 * PI ) + center.z

		Line( edge, lastEdge, r, g, b, noDepthTest, flDuration )

		lastEdge = edge + Vector()
	}

	lastEdge = Vector( center.x, radius + center.y, center.z )
	for ( angle = 0.0; angle <= 360.0; angle += CircleAngle )
	{
		edge.x = center.x
		edge.y = radius * cos( angle / 180.0 * PI ) + center.y
		edge.z = radius * sin( angle / 180.0 * PI ) + center.z

		Line( edge, lastEdge, r, g, b, noDepthTest, flDuration )

		lastEdge = edge + Vector()
	}

	lastEdge = Vector( center.x, radius + center.y, center.z )
	for ( angle = 90.0; angle <= 450.0; angle += CircleAngle ) // da fuk
	{
		edge.x = radius * cos( angle / 180.0 * PI ) + center.x
		edge.y = radius * sin( angle / 180.0 * PI ) + center.y
		edge.z = center.z

		Line( edge, lastEdge, r, g, b, noDepthTest, flDuration )

		lastEdge = edge + Vector()
	}
}
/** 
 * @param {Vector} p1
 * @param {Vector} p2
 * @param {Vector} p3
 * @param {integer} r
 * @param {integer} g
 * @param {integer} b
 * @param {bool} noDepthTest
 * @param {float} duration
 */
function DebugDrawTriangle( p1, p2, p3, r, g, b, noDepthTest, duration )
{
	DebugDrawLine(p1, p2, r, g, b, noDepthTest, duration)
	DebugDrawLine(p2, p3, r, g, b, noDepthTest, duration)
	DebugDrawLine(p3, p1, r, g, b, noDepthTest, duration)
}

/**
 * From Mr. Burguers on TF2Maps Discord `Username : (cb8493076c75466b9bfca4caaacc22a8)`
 * @param {Vector} center
 * @param {Vector} color
 * @param {float} radius
 * @param {bool} ztest
 * @param {float} duration
 */
function ROOT::DebugDrawSphere( center, color, radius, ztest, duration, rings = 8, segments = 16) 
{
	if (IsDedicatedServer())
		return DebugDrawSphereInternal( center, radius, color.x.tointeger(), color.y.tointeger(), color.z.tointeger(), ztest, duration)
    // local rings = 8
    // local segments = 32
    local v = []
    for (local ring = 0; ring <= rings; ring++) 
	{
        local theta = PI * ring / rings
        for (local segment = 0; segment <= segments; segment++) 
		{
            local phi = 2 * PI * segment / segments
            local offset = Vector(
                sin(theta) * cos(phi),
                sin(theta) * sin(phi),
                cos(theta)
            )
            v.push(center + offset * radius)
        }
    }
    local stride = segments + 1
    for (local ring = 0; ring < rings; ring++) 
	{
        for (local segment = 0; segment < segments; segment++) 
		{
            local i = ring * stride + segment
            local v1 = v[i]
            local v2 = v[i + 1]
            local v3 = v[i + stride]
            DebugDrawLine_vCol( v1, v2, color, ztest, duration )
            DebugDrawLine_vCol( v1, v3, color, ztest, duration )
        }
    }
}



// /** 
//  * @type {function}
//  * @param {Vector} position
//  * @param {Vector} xAxis
//  * @param {Vector} yAxis
//  * @param {integer} r
//  * @param {integer} g
//  * @param {integer} b
//  * @param {bool} bNoDepthTest
//  * @param {float} flDuration
//  */
// function DebugDrawCircle2( position, xAxis, yAxis, radius, r, g, b, bNoDepthTest, flDuration )
// {
// 	local nSegments = 16
// 	local flRadStep = (PI*2.0) / nSegments.tofloat()

// 	local vecLastPosition = Vector()
	
// 	// Find our first position
// 	// Retained for triangle fanning
// 	local vecStart = position + xAxis * radius
// 	local vecPosition = vecStart;

// 	local function Line( start, end, r, g, b, depth, dur ) {DebugDrawLine( start, end, r, g, b, depth, dur )}

// 	// Draw out each segment (fanning triangles if we have an alpha amount)
// 	for ( local i = 1; i <= nSegments; i++ )
// 	{
// 		// Store off our last position
// 		vecLastPosition = vecPosition

// 		// Calculate the new one
// 		local flSin = sin( flRadStep*i )
// 		local flCos = cos( flRadStep*i )
// 		vecPosition = position + (xAxis * flCos * radius) + (yAxis * flSin * radius)

// 		// Draw the line
// 		Line( vecLastPosition, vecPosition, r, g, b, bNoDepthTest, flDuration );

// 		// If we have an alpha value, then draw the fan
// 		if ( i > 1 )
// 			DebugDrawTriangle( vecStart, vecLastPosition, vecPosition, r, g, b, bNoDepthTest, flDuration )
// 	}
// }

// function DebugDrawSphere( position, const QAngle &angles, float radius, int r, int g, int b, int a, bool bNoDepthTest, float flDuration )
// {
// 	// Setup our transform matrix
// 	matrix3x4_t xform;
// 	AngleMatrix( angles, position, xform );
// 	Vector xAxis, yAxis, zAxis;
// 	// default draws circle in the y/z plane
// 	MatrixGetColumn( xform, 0, xAxis );
// 	MatrixGetColumn( xform, 1, yAxis );
// 	MatrixGetColumn( xform, 2, zAxis );
// 	Circle( position, xAxis, yAxis, radius, r, g, b, a, bNoDepthTest, flDuration );	// xy plane
// 	Circle( position, yAxis, zAxis, radius, r, g, b, a, bNoDepthTest, flDuration );	// yz plane
// 	Circle( position, xAxis, zAxis, radius, r, g, b, a, bNoDepthTest, flDuration );	// xz plane
// }

/*
  ================================ 
  === STRING PARSING FUNCTIONS ===
  ================================
*/

/**
 * @param {string} string
 */
function ROOT::StringToArray( string )
{
	local char_array = []
	for (local i = 0; i < string.len(); i++) {
		char_array.push(string.slice(i, i + 1))
	}
	return char_array
}

function ROOT::ArrayToString( array )
{
	local str = ""
	foreach (item in array)
		str += item.tostring()
	return str
}

/**
 * @param {string} string
 * @returns {bool}
 */
function ROOT::IsStringATrigger( string, triggers = ["/", "!"] )
	return IsInArray(StringToArray(string)[0], triggers)
/**
 * @param {string} string
 */
function ROOT::RemoveCommandTrigger( string, triggers = ["/", "!"] )
{
	if (!IsStringATrigger(string, triggers))
		return string
	return ArrayToString(StringToArray(string).slice(1))
}
/**
 * @param {string} string
 * @returns {[string]}
 */
function ROOT::SplitStringBetter( string )
{
	local string_debug = false

	local escape = '`'
	local s_escape = ' '
	local output = []
	local found_prev_escape = false
	local temp_output = ""

	local added_final = false
	foreach (byte in string)
	{
		added_final = false
		if (byte == escape)
		{
			if (string_debug) printf("found special escape char, setting val to "+!found_prev_escape)
			found_prev_escape = !found_prev_escape

			if (temp_output.len() != 0 && temp_output != " ")
			{
				if (string_debug) printf("Added buffer \"%s\" with length %d to the output\n", temp_output, temp_output.len())
				output.append(temp_output)
				temp_output = ""
				added_final = true
			}
		}
		else if (byte == s_escape && found_prev_escape == false)
		{
			if (string_debug) printf("Added buffer \"%s\" to the output\n", temp_output)
			output.append(temp_output)
			temp_output = ""
			added_final = true
		}
		else
		{
			temp_output += byte.tochar()
			if (string_debug) printf("Added char \"%s\" to the buffer \"%s\"\n", byte.tochar(), temp_output)
		}
	}

	if (added_final == false)
	{
		output.append(temp_output)
		if (string_debug) printf("Added final buffer \"%s\" to the output\n", temp_output)
	}

	return output
}

/**
 * @param {string|[string]} trigger
 */
function ROOT::RemoveChatTrigger( trigger )
{
	local errors = []
	if (typeof trigger == "string")
	{
		if (trigger in ChatTriggers)
			delete ChatTriggers[trigger]
	}
	else if (typeof trigger == "array")
	{
		foreach (trig in trigger)
		{
			if (typeof trig != "string")
			{
				errors.append(format("RemoveChatTrigger: Item %s : Unknown Type %s when Removing Chat Trigger", trig.tostring(), typeof trig))
				continue
			}
			if (trig in ChatTriggers)
				delete ChatTriggers[trig]
		}
	}
	else throw format("RemoveChatTrigger: Unknown Type %s when Removing Chat Trigger", typeof trigger)
	if (errors.len() != 0)
		PrintArray(errors)
}

/*
  =======================================
  === END OF STRING PARSING FUNCTIONS ===
  =======================================
*/

/*
  ========================
  === TIMING FUNCTIONS ===
  ========================
*/

function ROOT::dummy_ent() {
	// logic_relay does not take up an edict
	local relay = CreateByClassname("logic_relay")
	relay.ValidateScriptScope()
	return relay
}
/* 
function ROOT::RunWithDelay( func, delay = 0.0 )
{
	if (type(delay) == "function" && type( func ) != "function")
	{
		local temp = func
		func = delay
		delay = temp
	}
	local dummy = dummy_ent()
	GetScope(dummy)["Run"] <- function()
	{
		dummy.Kill()
		func()
	}.bindenv(this)

	EntFireByHandle(dummy, "CallScriptFunction", "Run", delay, null, null)
	return dummy
} */
/** 
 * @param {float|integer|function} 	delay
 * @param {float|integer|function} 	func
 * @returns {CBaseEntity|null}
 */
function ROOT::RunWithDelay( delay, func )
{
	// using `function() {}, delay` is now deprecated, looks bad with long funcs
	if (type(delay) == "function" && type( func ) != "function")
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		/** @type {function} */
		local actual_func = delay
		delay = func
		func = actual_func
	}
	local dummy = dummy_ent()
	GetScope(dummy)["Run"] <- function()
	{
		dummy.Kill()
		try {
			func()
		}
		catch(e) {printf("RunWithDelay: Function failed with %s\n", e)}
	}.bindenv(this == null ? ROOT : this)

	EntFireByHandle(dummy, "CallScriptFunction", "Run", delay, null, null)
	return dummy
}
/**
 * @param {function} on_timer_func
 */
function ROOT::CreateTimer( on_timer_func, first_delay = 0.0 )
{
	local dummy = dummy_ent()
	GetScope(dummy)["Run"] <- function()
	{
		try
		{
			local delay = on_timer_func()

			if (delay == null)
			{
				dummy.Kill()
				return
			}

			// Delays which are less or equal to 0 will be executed in the current tick which leads to an infinite loop
			if (delay <= 0.0)
				delay = 0.01

			EntFireByHandle(dummy, "CallScriptFunction", "Run", delay, null, null)
		}
		catch (err)
		{
			dummy.Kill()
			throw err
		}
	}.bindenv(this)

	EntFireByHandle(dummy, "CallScriptFunction", "Run", first_delay, null, null)
	return dummy
}
/**
 * @param {CBaseEntity} timer
 */
function ROOT::KillTimer( timer )
{
	if (timer.IsValid())
		timer.Kill()
}
/**
 * @param {CBaseEntity} timer
 */
function ROOT::FireTimer( timer )
{
	if (timer.IsValid())
	{
		timer.GetScriptScope()["Run"]()
		KillTimer(timer)
	}
}

/* 
// Example

local fired = false
local timer = CreateTimer(function()
{
	if (!fired)
	{
		printl("This is the first fire")
		fired = true
		// Repeat after 1 second
		return 1.0
	}
	else
	{
		printl("This is not a first fire")
		// repeat after 2 seconds
		return 2.0
	}
// First fire will be after 1 second
}, 1.0)

// Fire and kill the timer after 7 seconds
RunWithDelay(@() printl("Firing and killing a timer..."), 7.0)
RunWithDelay(@() FireTimer(timer), 7.0)
 */

/*
  ===============================
  === END OF TIMING FUNCTIONS ===
  ===============================
*/

/*
  ======================
  === MISC FUNCTIONS ===
  ======================
*/

/**
 * @param {table} scope
 * @deprecated this is cleaner, but uses more jump routines
 */
function ROOT::IsNotInScope( item, scope )
	return (!(item in scope))
/**
 * @param {any} item
 * @deprecated this is cleaner, but slower
 */
function ROOT::IsNotInTable( item, table )
	return (!(item in table))
/**
 * @param {integer} dmg_type
 * @deprecated Do not use! likely to get removed in some later date
 */
function ROOT::IsDamageTypeSpell( dmg_type )
	return dmg_type >= 65 && dmg_type <= 75
/**
 * @param {array} array
 */
function ROOT::IsInArray( item, array )
	return array.find(item) != null


function ROOT::IsPotato()
	return "__potato" in ROOT

function ROOT::IsChaosMvM()
	return "__chaosmvm" in ROOT

/**
 * @param {Vector} point
 */
function ROOT::IsPointInRespawnRoom( point )
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)
		local trace =
		{
			start =     	point
			end =         	point
			mask =        	1
		}
		TraceLineEx(trace)
		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if (trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}
/**
 * @param {Vector} start
 * @param {Vector} min
 * @param {Vector} max
 */
function ROOT::IsHullInRespawnRoom( start, min, max )
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if (respawnroom.GetTeam() != TF_TEAM_PVE_DEFENDERS) continue

		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)
		local trace =
		{
			start =     	start
			end =         	start
			mask =        	1
			hullmin = 		min
			hullmax = 		max
		}
		TraceHull(trace)
		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if (trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}

/**
 * @param {Vector} point1
 * @param {Vector} point2
 */
function ROOT::CanPointSeePoint( point1, point2 )
{
	local trace = {
		start = point1
		end = point2
		mask = MASK_WORLD
	}
	TraceLineEx(trace)
	return !trace.hit
}

/**
 * @param {table} info
 */
function ROOT::EmitGlobalSound( info )
	EmitSoundEx({
		sound_name = info.sound_name
		channel = "channel" in info ? info.channel : 0
		// sound_level = "sound_level" in info ? info.sound_level : 0
		pitch = "pitch" in info ? info.pitch : 100
		// origin = "origin" in info ? info.origin : Vector(0, 0, 0)
		// entity = "entity" in info ? info.entity : null
		filter_type = RECIPIENT_FILTER_GLOBAL
	})

/**
 * @param {string} particle
 * @param {Vector} origin
 * @param {QAngle} angle
 */
function ROOT::CreateParticle( particle, origin, angle = QAngle( -90, 0, 0 ) )
{
	local temp = SpawnEntityFromTable("info_particle_system", {effect_name = particle})
	temp.SetAbsOrigin(origin)
	temp.SetAbsAngles(angle)
	temp.AcceptInput("Start", "", null, null)
	EntFireNew(temp, "Stop", "", THREE_TICKS)
	EntFireNew(temp, "Kill", "", FIVE_TICKS)
	return temp
}

if (!("GlobalParticleSpawner" in ROOT) || GlobalParticleSpawner == null)
{
	::GlobalParticleSpawner <- CreateByClassname("trigger_particle")
	GlobalParticleSpawner.KeyValueFromInt("spawnflags", 64)
}
else if (!GlobalParticleSpawner.IsValid())
{
	::GlobalParticleSpawner <- CreateByClassname("trigger_particle")
	GlobalParticleSpawner.KeyValueFromInt("spawnflags", 64)
}

/**
 * @param {CBaseEntity} entity
 * @param {string} particle
 * @param {integer} attach_type
 * @param {string} attachment_name
 */
function ROOT::AttachEntityParticle( entity, particle, attach_type = PATTACH_ABSORIGIN, attachment_name = "" )
{
	if (entity == null || !entity.IsValid())
		return
	if (GlobalParticleSpawner == null || !GlobalParticleSpawner.IsValid())
	{
		::GlobalParticleSpawner <- CreateByClassname("trigger_particle")
		GlobalParticleSpawner.KeyValueFromInt("spawnflags", 64)
	}
	
	NetProps.SetPropString(GlobalParticleSpawner, "m_iszParticleName", particle)
	NetProps.SetPropString(GlobalParticleSpawner, "m_iszAttachmentName", attachment_name)
	NetProps.SetPropInt(GlobalParticleSpawner, "m_nAttachType", attach_type)
	GlobalParticleSpawner.AcceptInput("StartTouch", "", entity, entity)
}

/**
 * @param {CTFWeaponBase|CEconEntity|null} weapon
 * @param {string} classname
 */
function ROOT::IsWeaponClass( weapon, classname, starts = false )
{
	if (weapon == null || !weapon.IsValid())
		return false
	else if (starts)
		return startswith(weapon.GetClassname(), classname)
	else
		return weapon.GetClassname() == classname
}


/**
 * Creates a Pickup
 * 
 * @param {table} table Look at `Input table` section
 * 
 * # Input table
 * ```sqDoc
 * origin: Vector		// The position where to spawn the Pickup.
 * angles: Vector		// The angles to spawn the Pickup with.
 * velocity: Vector	// The velocity to spawn the Pickup with.
 * team: integer		// Which Team can pick this up.
 * model: string		// The Model for the Pickup.
 * sound: string		// Optional sound to cache and play on pickup.
 * lifetime: float		// How long the Pickup should live for.
 * func: function		// What function to run when the pickup is picked up
 * ```
 */
function ROOT::CreatePickup( table )
{
	if ( type(table) != "table" )
		return null

	PrecacheModel(table.model)
	PrecacheSound(table.sound)
	
	local pickup = SpawnEntityFromTable("item_armor", {
		origin = table.origin
		angles = table.angles
		teamnum = table.team
		spawnflags = (1 << 30) // no bot support
	})

	pickup.SetModel(table.model)
	pickup.SetSolid(SOLID_BBOX)
	pickup.SetMoveType(MOVETYPE_FLYGRAVITY, 1)
	pickup.SetAbsVelocity(table.velocity)

	local function func( ) { if ( Time( ) >= life_time ) {self.Kill()} }

	GetScope(pickup).life_time <- Time() + table.lifetime
	GetScope(pickup).LifeTime <- func
	AddThinkToEnt(pickup, "LifeTime")
	GetScope(pickup).OnPlayerTouch <- table.func
	pickup.ConnectOutput( "OnPlayerTouch", "OnPlayerTouch" )

	return pickup
}

/**
 * The first node is always going to be called what the PathName is
 * all subsequent nodes have _[index]
 * i.e. node 1 is "path", while node 2 is "path_2"
 * @param {table} data
 */
function ROOT::CreateTankPath( data )
{
	foreach (PathName, PathData in data)
	{
		local Paths = {}
		foreach (i, TrackData in PathData)
		{
			Paths[i] <- {}
			Assert("origin" in TrackData, "Missing origin in Path Data! ABORTING!!")

			local origin = TrackData.origin
			local target = "target" in TrackData ? TrackData.target : format("%s_%i", PathName, i + 2)

			// printl(target)
			Paths[i].path_track <- {
				origin		= origin
				targetname 	= i == 0 ? PathName : format("%s_%i", PathName, i + 1)
				target		= target
			}
			foreach (k, v in TrackData)
			{
				if (startswith(k, "OnPass"))
					Paths[i].path_track[k] <- v
			}
			// printl("Created a path_track "+format("%s_%i", PathName, i + 1)+" at "+origin.ToKVString()+" with a target of " +target)
			DebugDrawBox(origin, Vector(-12,-12,-12), Vector(12, 12, 12), 255, 0, 0, 100, 60)
		}
		SpawnEntityGroupFromTable(Paths)
	}
}

::DMG_BIT_NAMES <- {}
DMG_BIT_NAMES[DMG_GENERIC] 				<- "DMG_GENERIC"
DMG_BIT_NAMES[DMG_CRUSH] 				<- "DMG_CRUSH"
DMG_BIT_NAMES[DMG_BULLET] 				<- "DMG_BULLET"
DMG_BIT_NAMES[DMG_SLASH] 				<- "DMG_SLASH"
DMG_BIT_NAMES[DMG_BURN] 				<- "DMG_BURN"
DMG_BIT_NAMES[DMG_VEHICLE] 				<- "DMG_VEHICLE"
DMG_BIT_NAMES[DMG_FALL] 				<- "DMG_FALL"
DMG_BIT_NAMES[DMG_BLAST] 				<- "DMG_BLAST"
DMG_BIT_NAMES[DMG_CLUB] 				<- "DMG_CLUB"
DMG_BIT_NAMES[DMG_SHOCK] 				<- "DMG_SHOCK"
DMG_BIT_NAMES[DMG_SONIC] 				<- "DMG_SONIC"
DMG_BIT_NAMES[DMG_ENERGYBEAM] 			<- "DMG_ENERGYBEAM"
DMG_BIT_NAMES[DMG_PREVENT_PHYSICS_FORCE]<- "DMG_PREVENT_PHYSICS_FORCE"
DMG_BIT_NAMES[DMG_NEVERGIB] 			<- "DMG_NEVERGIB"
DMG_BIT_NAMES[DMG_ALWAYSGIB] 			<- "DMG_ALWAYSGIB"
DMG_BIT_NAMES[DMG_DROWN] 				<- "DMG_DROWN"
DMG_BIT_NAMES[DMG_PARALYZE] 			<- "DMG_PARALYZE"
DMG_BIT_NAMES[DMG_NERVEGAS] 			<- "DMG_NERVEGAS"
DMG_BIT_NAMES[DMG_POISON] 				<- "DMG_POISON"
DMG_BIT_NAMES[DMG_RADIATION] 			<- "DMG_RADIATION"
DMG_BIT_NAMES[DMG_DROWNRECOVER] 		<- "DMG_DROWNRECOVER"
DMG_BIT_NAMES[DMG_ACID] 				<- "DMG_ACID/DMG_CRIT"
DMG_BIT_NAMES[DMG_SLOWBURN] 			<- "DMG_SLOWBURN"
DMG_BIT_NAMES[DMG_REMOVENORAGDOLL] 		<- "DMG_REMOVENORAGDOLL"
DMG_BIT_NAMES[DMG_PHYSGUN] 				<- "DMG_PHYSGUN"
DMG_BIT_NAMES[DMG_PLASMA] 				<- "DMG_PLASMA"
DMG_BIT_NAMES[DMG_AIRBOAT] 				<- "DMG_AIRBOAT"
DMG_BIT_NAMES[DMG_DISSOLVE] 			<- "DMG_DISSOLVE"
DMG_BIT_NAMES[DMG_BLAST_SURFACE] 		<- "DMG_BLAST_SURFACE"
DMG_BIT_NAMES[DMG_DIRECT] 				<- "DMG_DIRECT"
DMG_BIT_NAMES[DMG_BUCKSHOT] 			<- "DMG_BUCKSHOT"
/**
 * @param {integer} bits
 */
function ROOT::PrintDamageBits( bits )
{
	for (local i = 0; i < 32; i++) {
		local bit = 1 << i
		if (bits & bit)
			printl("Damage has "+DMG_BIT_NAMES[bit])
	}
}

function ROOT::IsDamageTaunt( damagecustom )
{
	return damagecustom == TF_DMG_CUSTOM_TAUNTATK_HADOUKEN
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_ARROW_STAB
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_ALLCLASS_GUITAR_RIFF
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_ARMAGEDDON
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_HIGH_NOON
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_BARBARIAN_SWING
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_ENGINEER_ARM_KILL
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_ENGINEER_GUITAR_SMASH
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_TRICKSHOT
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_FENCING
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_GRAND_SLAM
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_GRENADE
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_UBERSLICE
		|| damagecustom == TF_DMG_CUSTOM_TAUNTATK_GASBLAST
}

function ROOT::ToggleSlowDown( amount = 1.0, sound = "", revert_sound = "", revert = 0.0 )
{
	Assert(amount > 0.01, "Cannot set Timescale below 0.01")

	PrecacheSound(sound)
	PrecacheSound(revert_sound)
	local overlay = amount == 1.0 ? "" : "debug/yuv"
	foreach (player in GetAllPlayers(false, false, false))
	{
		player.SetScriptOverlayMaterial(overlay)
		if (sound != "")
			player.EmitSoundTo(sound)

		player.AddCustomAttribute("voice pitch scale", amount, revert*amount)
	}

	SetCvar("host_timescale", amount)

	if (!("Timescale" in ROOT))
		::Timescale <- amount
	else
		Timescale = amount

	if (amount != 1.0 && revert != 0.0)
	{
		RunWithDelay(revert*amount, @() ToggleSlowDown(1.0, revert_sound))
	}
}

::ItemSets <- {}

/**
 * @param {string} name
 * @param {table} set
 */
function ROOT::CreateItemSet( name, set )
	ItemSets[name] <- set

function ROOT::ProccessItemSets( client )
{
	foreach (_name, set in ItemSets)
	{
		if (set.ApplyFor.find(client.GetSteamID()) == null)
			continue
		local targets = []
		if (set.ApplyTo.find("PLAYER") != null)
			targets.append(client)

		foreach (weapon in client.GetAllWeapons())
		{
			if (set.ApplyTo.find(weapon.GetClassname()) != null || set.ApplyTo.find(weapon.GetIDX()) != null)
				targets.append(weapon)
		}
		foreach (weapon in client.GetWearables())
		{
			if (set.ApplyTo.find(weapon.GetClassname()) != null || set.ApplyTo.find(weapon.GetIDX()) != null)
				targets.append(weapon)
		}

		

		foreach (entity in targets)
		{
			local func = "AddAttribute"
			if (entity.IsPlayer())
				func = "AddCustomAttribute"

			local particle_name = ""
			local attachment_name = ""
			local attachment_point = PATTACH_ABSORIGIN

			foreach (attribute, value in set.Attributes)
			{
				if (attribute == "custom particle name")
				{
					particle_name = value
					continue
				}
				if (attribute == "custom particle attachment")
				{
					attachment_name = value
					continue
				}
				if (attribute == "custom attachment point")
				{
					attachment_point = value.tointeger()
					continue
				}
				local val = 0.0
				try {val = value.tofloat()} catch(_) {printl("Failed to convert \""+value+"\" to a float!")}
				entity[func](attribute, val, -1)
				// printf("Appled Attribute %s to %s with a value of %g\n", attribute, entity.tostring(), val)
			}

			if (particle_name != "" && attachment_name != "")
			{
				AttachEntityParticle(entity, particle_name, attachment_point, attachment_name)
			}
		}
	}
}

// CreateItemSet("Master of Chaos", {
// 	ApplyTo = [
// 		940
// 	]
// 	ApplyFor = [
// 		"[U:1:969530867]"
// 		"[U:1:101345257]"
// 	]
// 	Attributes = {
// 		// "custom particle name" : "rocket_trail"
// 		// "custom particle attachment" : ""
// 		// "custom attachment point" : 0
// 	}
// })

::PipeBombClassnames <- [
	"tf_projectile_pipe",
	"tf_projectile_pipe_remote",
	"tf_projectile_jar", 
	"tf_projectile_jar_gas", 
	"tf_projectile_jar_milk",
	"tf_projectile_stun_ball",
	"tf_projectile_ball_ornament",
	"tf_projectile_cleaver",

	"tf_projectile_spellbats",
	"tf_projectile_spellmirv",
	"tf_projectile_spelltransposeteleport",
	"tf_projectile_spellspawnzombie",
	"tf_projectile_spellspawnhorde",
	"tf_projectile_spellspawnboss",
	"tf_projectile_spellkartorb",
	"tf_projectile_spellmeteorshower",

	"tf_projectile_throwable",
	"tf_projectile_throwable_repel",
	"tf_projectile_throwable_brick",
	"tf_projectile_throwable_breadmonster",
]
::RocketClassnames <- [
	"tf_projectile_rocket",
	"tf_projectile_sentryrocket",
	"tf_projectile_arrow",
	"tf_projectile_healing_bolt",
	"tf_projectile_grapplinghook",
	"tf_projectile_energy_ball",
	"tf_projectile_flare",
	"tf_projectile_balloffire",
	"tf_projectile_mechanicalarmorb",

	"tf_projectile_spellfireball",
	"tf_projectile_lightningorb",
]

/**
 * reutrns if an entity is a projectile
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsProjectile( ent )
{
	if (!ent || !ent.IsValid() || !startswith(ent.GetClassname(), "tf_proj"))
		return false
	return true
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsBaseGrenade( ent )
{
	if (!IsProjectile(ent) || !IsInArray(ent.GetClassname(), PipeBombClassnames))
		return false
	return true
}
/** 
 * @param {CBaseEntity|null} ent
 * @returns {bool}
 */
function ROOT::IsBaseRocket( ent )
{
	if (!IsProjectile(ent) || !IsInArray(ent.GetClassname(), RocketClassnames))
		return false
	return true
}

// fix tf2c
if (!("Assert" in ROOT))
{
	function ROOT::Assert( bool, msg = null )
	{
		if (bool)
			return

		if (msg)
			throw "[Assertion Failed]: "+msg
		else
			throw "[Assertion Failed]"
	}
}
// fake parity with TF2C
if (!("ListenToEvent" in ROOT))
{
	function ROOT::ListenToEvent( event, callback, context, prefix = "OnGameEvent" )
	{
		ROOT[context] <- {}
		local function CallFunc( params ) {callback( params )}
		ROOT[context][prefix+"_"+event] <- CallFunc

		__CollectGameEventCallbacks(ROOT[context])
	}
}
if (!("ListenToGameEvent" in ROOT))
{
	function ROOT::ListenToGameEvent( event, callback, context )
		ListenToEvent(event, callback, context)
}
if (!("ListenToScriptEvent" in ROOT))
{
	function ROOT::ListenToScriptEvent( event, callback, context )
		ListenToEvent(event, callback, context, "OnScriptEvent")
}
/*
  =============================
  === END OF MISC FUNCTIONS ===
  =============================
*/

/*
  ==============================
  === BENCHMARKING FUNCTIONS ===
  ==============================
*/

//// Developer?
// RealTime() // returns real time (independent of game) in seconds
// BeginBenchmark() // starts time measurement
// EndBenchmark() // ends time measurement and returns high-precision time elapsed in milliseconds
// PushBenchmark() // pushes current real time onto internal stack (useful for recursive time measurement)
// PopBenchmark() // pops from the stack and returns the high-precision time elapsed in milliseconds
function ROOT::IsBenchmarkLoaded()
	return "BeginBenchmark" in ROOT

function ROOT::StartBenchmark()
{
	if (IsBenchmarkLoaded())
		BeginBenchmark()
	else
		error("Warning Benchmarking is not enabled, please load the extension\n")
}
function ROOT::StopBenchmark()
{
	if (IsBenchmarkLoaded())
		return EndBenchmark()
	else
		error("Warning Benchmarking is not enabled, please load the extension\n")
	return null
}
function ROOT::PrintBenchmarkTime( text = "" )
{
	if (IsBenchmarkLoaded())
		return printf(text + "%.5f ms\n", StopBenchmark())
	else 
		StopBenchmark()
}

/*
  =====================================
  === END OF BENCHMARKING FUNCTIONS ===
  =====================================
*/

/*
  ==========================
  === CONDHOOK FUNCTIONS ===
  ==========================
*/

// TODO: Add to Snippets
/**
 * @param {integer} cond
 * @param {string} name
 * @param {function} func
 */
function ROOT::OnAddCondListener( cond, name, func )
{
	if (!("OnCondPostHooks" in FatCatLibSettings))
		SetLibrarySettings()

	if (FatCatLibSettings["OnCondPostHooks"] == false)
		return printl("Warning! OnCondPostHooks is Disabled")

	local scope = GetScope(FindByName(null, "OnCondition"))
	if (!("OnAddCond" in scope))
	{
		scope.OnAddCond <- array(TF_COND_RANGE)
		for (local i = 0; i < TF_COND_RANGE; i++)
			scope.OnAddCond[i] = {}
	}

	if (name in scope.OnAddCond[cond])
		printl("Warning, Trying to Add an AddCondListener with an already registered name!")

	scope.OnAddCond[cond][name] <- CondListen
}

// scope.OnAddCond = [/* index 0 */ {"noZooming" : player.Suidide}] // 131 total

// TODO: Add to Snippets
/**
 * @param {integer} cond
 * @param {string} name
 * @param {function} func
 */
function ROOT::OnRemoveCondListener( cond, name, func )
{
	if (!("OnCondPostHooks" in FatCatLibSettings))
		SetLibrarySettings()

	if (FatCatLibSettings["OnCondPostHooks"] == false)
		return printl("Warning! OnCondPostHooks is Disabled")
		
	local scope = GetScope(FindByName(null, "OnCondition"))
	if (!("OnRemoveCond" in scope))
	{
		scope.OnRemoveCond <- array(TF_COND_RANGE)
		for (local i = 0; i < TF_COND_RANGE; i++)
			scope.OnRemoveCond[i] = {}
	}

	if (name in scope.OnRemoveCond[cond])
		printl("Warning, Trying to Add an RemoveCondListener with an already registered name!")

	scope.OnRemoveCond[cond][name] <- func
}
// Cool thing i can do, "this" is actually the player >:), ROOT could also work, but this makes sense
/* OnAddCondListener(TF_COND_TAUNTING, "Test" function() {
	StopTaunt(true)
	RemoveCondEx(TF_COND_TAUNTING, true)
	// ApplyAbsVelocityImpulse(Vector(0, 0, 300))
}) */

/*
  =================================
  === END OF CONDHOOK FUNCTIONS ===
  =================================
*/



/**
 * @param {table} trace
 */
function ROOT::DrawTraceHull( trace, starting_color = Vector( 255, 0, 0 ), ending_color = Vector( 0, 0, 255 ) )
{
	local max = "hullmax" in trace ? trace.hullmax : Vector(1, -1, 1)
	local min = "hullmin" in trace ? trace.hullmin : Vector(-1, 1, -1)

	if (!("endpos" in trace))
		trace.endpos <- Vector()

	DebugDrawBox(trace.start, min, max, starting_color.x.tointeger(), starting_color.y.tointeger(), starting_color.z.tointeger(), 30, 30)
	DebugDrawBox(trace.endpos, min, max, ending_color.x.tointeger(), ending_color.y.tointeger(), ending_color.z.tointeger(), 30, 30)

	local diffX = (trace.start.x-trace.endpos.x)
	local diffY = (trace.start.y-trace.endpos.y)
	local diffZ = (trace.start.z-trace.endpos.z)

	local difference = Vector(-1*(diffX), -1*(diffY), -1*(diffZ))
	local repeat = (difference.Length() / 25)
	for (local i = 1; i < repeat.tointeger(); i++) 
	{
		DebugDrawBox(trace.start + (difference * (i.tofloat() / repeat)), min, max, 0, 255, 0, 0, 30)
	}
}
/**
 * @param {table} info1
 * @param {table} info2
 */
function ROOT::DeprecatedWarning( info1, info2 )
	error(format("FatCatLibrary::%s  :  %s on Line %i is running a Deprecated Version of %s\n", info1.func, info2.src, info2.line, info1.func))


function ROOT::PrecacheObject( thing )
{
	local ret = 0
	if (thing.find(".mdl") != null || thing.find(".vmt") != null)
	{
		ret = PrecacheModel(thing)
	}
	else if (thing.find(".wav") != null || thing.find(".mp3") != null)
	{
		ret = PrecacheSound(thing)
		// PrecacheScriptSound(string)
	}
	else 
		throw format("Unknown Object Type in PrecacheObject: \"%s\"", thing)

	if (ret == null)
		return
	else if ( ret == -1 || ret == false )
		throw format("Failed to Precache Object \"%s\"", thing)
}

/*
  ======================
  === MATH FUNCTIONS ===
  ======================
*/

::MATH <- {
	/**
	 * @param {integer} a
	 * @param {integer} b
	 * @deprecated for singular flags use HasBitFlag, for multiple flags use HasBitMask.
	 */
	function BitWise( a, b )
	{
		return (a & b) == b
	}
	/**
	 * returns if `bits` has any of the bits of `flag`.
	 * 
	 * `Note:` for multiple flags use HasBitMask instead.
	 * @param {integer} bits
	 * @param {integer} flag
	 */
	function HasBitFlag( bits, flag )
	{
		return ( bits & flag ) != 0
	}
	/**
	 * returns if `bits` has all of the bits of `mask`.
	 * 
	 * `Note:` for singular flags use HasBitFlag instead.
	 * @param {integer} bits
	 * @param {integer} mask
	 */
	function HasBitMask( bits, mask )
	{
		return ( bits & mask ) == mask
	}

	/**
	 * Returns the Smaller Value
	 * 
	 * `Example:` if a < b, then return a, else return b
	 * @param {integer|float} a
	 * @param {integer|float} b
	 */
	function Min( a, b )
	{
		return (a < b) ? a : b
	}
	/**
	 * Returns the Larger Value
	 * 
	 * `Example:` if a < b, then return b, else return a
	 * @param {integer|float} a
	 * @param {integer|float} b
	 */
	function Max( a, b )
	{
		return (a < b) ? b : a
	}
	/**
	 * Clamps `val` between `min` and `max`
	 * @param {integer|float} val
	 * @param {integer|float} min
	 * @param {integer|float} max
	 */
	function Clamp( val, min, max )
	{
		if ( max < min )
			return max
		else if ( val < min )
			return min
		else if ( val > max )
			return max
		else
			return val
	}
	/**
	 * maps `val` onto `A` - `B`, and then remaps onto
	 * `C` - `D`
	 * 
	 * @param {integer|float} val
	 * @param {integer|float} A
	 * @param {integer|float} B
	 * @param {integer|float} C
	 * @param {integer|float} D
	 */
	function RemapVal( val, A, B, C, D )
	{
		if ( A == B )
			return val >= B ? D : C;
		return C + (D - C) * (val - A) * 1.0 / (B - A);
	}
	/**
	 * @param {integer|float} val
	 * @param {integer|float} A
	 * @param {integer|float} B
	 * @param {integer|float} C
	 * @param {integer|float} D
	 */
	function RemapValClamped( val, A, B, C, D )
	{
		if ( A == B )
			return val >= B ? D : C;
		local cVal = (val - A) / (B - A);
		cVal = MATH.Clamp( cVal, 0.0, 1.0 );

		return C + (D - C) * cVal;
	}
	function ConvertRadiusToSndLvl( radius )
	{
		return (40 + (20 * log10(radius / 36.0))).tointeger()
	}
	/**
	 * @param {integer|float} min
	 * @param {integer|float} max
	 */
	function RandomVec( min, max )
	{
		local v = Vector()
		v.Random(min, max)
		return v
	}
	/**
	 * @param {integer|float} min
	 * @param {integer|float} max
	 */
	function RandomQAngle( min, max )
	{
		local q = QAngle()
		q.Random(min, max)
		return q
	}
	/**
	 * @param {Vector} point1
	 * @param {Vector} point2
	 */
	function Distance( point1, point2 )
	{
		return (point1 - point2).Length()
	}
	function RandomChance()
	{
		return RandomFloat(0, 1)
	}
	/**
	 * @param {integer} num
	 */
	function OneInChance( num )
		return RandomChance() <= (1.0/num.tofloat())

	/**
	 * @returns {integer} The Seconds since 12:00 AM, 0 - 86399
	 */
	function TimeOfDay()
	{
		local cur_time = {}
		LocalTime(cur_time)

		local ActualTime = 0
		ActualTime += cur_time.hour * 60 //MINPERHOUR
		ActualTime += cur_time.minute * 60 //SECPERMIN
		ActualTime += cur_time.second

		return ActualTime
	}
	/**
	 * Used on Normalized vectors to turn that vector into an angle
	 * @param {Vector} Vec
	 * @return Returns the Angle Pointing Towards Vector
	 */
	function VectorAngles( Vec )
	{
		local yaw, pitch
		if ( Vec.y == 0.0 && Vec.x == 0.0 )
		{
			yaw = 0.0
			if (Vec.z > 0.0)
				pitch = 270.0
			else
				pitch = 90.0
		}
		else
		{
			yaw = (atan2(Vec.y, Vec.x) * 180.0 / Pi)
			if (yaw < 0.0)
				yaw += 360.0
			pitch = (atan2(-Vec.z, Vec.Length2D()) * 180.0 / Pi)
			if (pitch < 0.0)
				pitch += 360.0
		}

		return QAngle(pitch, yaw, 0.0)
	}
	/** 
	 * 	hermite basis function for smooth interpolation
	 * 
	 * 	`value` should be between 0 & 1 inclusive
	 * @param {integer|float} value
	 * @returns {integer|float}
	 */
	function SimpleSpline( value )
	{
		local valueSquared = (value * value)
		return (3 * valueSquared - 2 * valueSquared * value)
	}

	/** 
	 * remaps a value in [startInterval, startInterval+rangeInterval] from linear to
	 * spline using SimpleSpline
	 * @param {integer|float} val
	 * @param {integer|float} A
	 * @param {integer|float} B
	 * @param {integer|float} C
	 * @param {integer|float} D
	 * @returns {integer|float}
	 */
	function SimpleSplineRemapVal( val, A, B, C, D )
	{
		if ( A == B )
			return val >= B ? D : C
		local cVal = (val - A) / (B - A)
		return C + (D - C) * SimpleSpline( cVal )
	}
	/** 
	 * remaps a value in [startInterval, startInterval+rangeInterval] from linear to
	 * spline using SimpleSpline
	 * @param {integer|float} val
	 * @param {integer|float} A
	 * @param {integer|float} B
	 * @param {integer|float} C
	 * @param {integer|float} D
	 * @returns {integer|float}
	 */
	function SimpleSplineRemapValClamped( val, A, B, C, D )
	{
		if ( A == B )
			return val >= B ? D : C
		local cVal = (val - A) / (B - A)
		cVal = MATH.Clamp( cVal, 0.0, 1.0 )
		return C + (D - C) * SimpleSpline( cVal )
	}

	/**
	 * Mimic's How valve generates Random Floats
	 */
	function Valve_RandomFloat()
	{
		return RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX
	}

	/** 
	 * @param {float} min
	 * @param {float} max
	 */
	function Valve_RandomInt(min, max)
	{
		min + Valve_RandomFloat() * (max - min)
	}
}

/*
  =============================
  === END OF MATH FUNCTIONS ===
  =============================
*/

/*
  ======================
  === VECTOR METHODS ===
  ======================
*/

/**
 * Returns a new Normalized vector
 * @returns {Vector}
 */
function Vector::Normalize()
{
	local new = this + ::Vector()
	new.Norm()
	return new
}
/**
 * Sets `x`, `y`, and `z` to a Randomized value between `min`, and `max`
 * @param {float} min
 * @param {float} max
 */
function Vector::Random( min, max )
{	//VALVE_RAND_MAX == 0x7FFF
	this.x = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
	this.y = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
	this.z = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
}
/**
 * @param {Vector} point2
 * @returns {float}
 */
function Vector::DistanceTo( point2 )
{
	try {
	return (this-point2).Length()
	}
	catch (e) // da-fuck
	{
		::printl(this)
		::printl(point2)
		::printl(e)
		return -1
	}
}

/*
  =============================
  === END OF VECTOR METHODS ===
  =============================
*/

/*
  ========================
  === VECTOR2D METHODS ===
  ========================
*/
if("Vector2D" in ROOT) { // wacky tf2c does not have it
/**
 * @returns {Vector2D}
 */
function Vector2D::Normalize()
{
	local new = this + ::Vector2D()
	new.Norm()
	return new
}
}
/*
  ===============================
  === END OF VECTOR2D METHODS ===
  ===============================
*/

/*
  ======================
  === QANGLE METHODS ===
  ======================
*/
function QAngle::Random( min, max )
{	//VALVE_RAND_MAX == 0x7FFF
	this.x = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
	this.y = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
	this.z = min + (::RandomInt(0, VALVE_RAND_MAX).tofloat() / VALVE_RAND_MAX) * (max - min)
}
/*
  =============================
  === END OF QANGLE METHODS ===
  =============================
*/

/*
  ============================
  === DEPRECATED FUNCTIONS ===
  ============================
*/
if (!("min" in ROOT))
{
	/**
	 * @deprecated Use MATH.Min instead.
	 */
	function ROOT::min( a, b )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		return (b < a) ? b : a;
	}
}
if (!("max" in ROOT))
{
	/**
	 * @deprecated use MATH.Max instead.
	 */
	function ROOT::max( a, b )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		return (a < b) ? b : a;
	}
}
if (!("clamp" in ROOT))
{
	/**
	 * @deprecated use MATH.Clamp instead.
	 */
	function ROOT::clamp( val, minVal, maxVal )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		if ( maxVal < minVal )
			return maxVal;
		else if ( val < minVal )
			return minVal;
		else if ( val > maxVal )
			return maxVal;
		else
			return val;
	}
}
if (!("remapValue" in ROOT))
{
	/**
	 * @deprecated use MATH.RemapVal instead.
	 */
	function ROOT::remapValue( val, A, B, C, D )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		if ( A == B )
			return val >= B ? D : C;
		return C + (D - C) * (val - A) / (B - A);
	}
}
if (!("remapValueClamped" in ROOT))
{
	/**
	 * @deprecated use MATH.RemapValClamped instead.
	 */
	function ROOT::remapValueClamped( val, A, B, C, D )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		if ( A == B )
			return val >= B ? D : C;
		local cVal = (val - A) / (B - A);
		cVal = clamp( cVal, 0.0, 1.0 );
		return C + (D - C) * cVal;
	}
}
if (!("ConvertRadiusToSndLvl" in ROOT))
{
	/**
	 * @deprecated use MATH.ConvertRadiusToSndLvl instead.
	 */
	function ROOT::ConvertRadiusToSndLvl( radius )
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		return (40 + (20 * log10(radius / 36.0))).tointeger()
	}
}


if (!("GetWeaponInSlot" in ROOT))
{
	/**
	 * @param {CTFPlayer} player
	 * @deprecated use player.GetWeaponInSlotNew instead.
	 */
	function ROOT::GetWeaponInSlot( player, slot = 0 )
	{
		if ( !player ) return null
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		return player.GetWeaponInSlot(slot)
	}
}

if (!("GetTimeOfDay" in ROOT))
{
	/**
	 * @deprecated use MATH.TimeOfDay instead.
	 */
	function ROOT::GetTimeOfDay()
	{
		DeprecatedWarning(getstackinfos(1), getstackinfos(2))
		local cur_time = {}
		LocalTime(cur_time)

		local ActualTime = 0
		ActualTime += cur_time.hour * 60 //MINPERHOUR
		ActualTime += cur_time.minute * 60 //SECPERMIN
		ActualTime += cur_time.second

		return ActualTime
	}
}


/*
  ===================================
  === END OF DEPRECATED FUNCTIONS ===
  ===================================
*/


if (!("CORROSION_ICON" in ROOT))
	::CORROSION_ICON <- CreateKillIcon("infection_acid_puddle")

if (!("SLAM_ICON" in ROOT))
	::SLAM_ICON <- CreateKillIcon("hale_slam_collateral")

if (!("BUSTER_ICON" in ROOT))
	::BUSTER_ICON <- CreateKillIcon("megaton")

/*
  ==================================
  === CUSTOM EXPLOSION FUNCTIONS ===
  ==================================
*/
////

// This tables fucking formatting
/**
 * Creates a base explosion to use
 * 
 * @param {table} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer		// The player to report the damage to.
 * weapon: CTFWeaponBase|null 	// The weapon to give credit to. (Default: null)
 * ignores: [CBaseEntity]		// The Entitys to ignore for the explosion (usually the victim). (Default: [])
 * sound: string			// The sound to play on explosion. (Default: "")
 * radius: float			// The radius of the explosion. (Default: 147.0)
 * origin: Vector			// The origin of the explosion. (Default: Vector(0, 0, 0))
 * damage: float			// The damage dealt at the center. (Default: 90.0)
 * MinDamage: float		// The damage dealt at the edge. (Default: damage/2.0)
 * DamageDeadzone: float		// The radius from the center where zero falloff occurs. (Default: 0.0)
 * particle: string		// The explosion particle. (Default: "")
 * particle_ang: Vector		// The angle of the explosion particle. (Default: QAngle(-90, 0, 0))
 * particle_offset: Vector		// How much to offset the explosion particle spawn. (Default: Vector(0, 0, 0))
 * DmgType: integer		// The damage types to use (add DMG_RADIUS_MAX to ignore damage falloff). (Default: DMG_GENERIC|DMG_BLAST)
 * DmgCustom: integer		// The custom damage type to use.
 * SoundRadius: float		// The radius the sound travels. (Default: radius)
 * SoundDelay: float		// Cooldown between explosion sounds. (Default: 0.5)
 * ExplodeFunc: function		// Callback function for players hit. ( Default: null )
 * FuncBeforeDmg: bool		// If true, call ExplodeFunc before dealing damage. (Default: false)
 * FuncOnIgnore: bool		// If true, call ExplodeFunc on ignored targets. (Default: false)
 * OnlyPlayers: bool		// If true, only collect players to attack. (Default: false)
 * FuncIgnoreObjects: bool		// If true, ignore non-players when calling ExplodeFunc. (Default: false)
 * kill_icon: string		// Override the kill icon in killfeed, forces DmgCustom to 0 (Default: "")
 * ```
 */
function ROOT::CreateBaseExplosion( table )
{
	local owner 			= "owner" 				in table ? table.owner 				: null
	local weapon 			= "weapon" 				in table ? table.weapon 			: null
	local inflictor 		= "inflictor" 			in table ? table.inflictor 			: owner
	local sound 			= "sound" 				in table ? table.sound 				: ""
	local origin 			= "origin" 				in table ? table.origin 			: owner && owner.IsPlayer() ? owner.GetCenter() : Vector()
	local radius 			= "radius" 				in table ? table.radius 			: 147.0
	local damage 			= "damage" 				in table ? table.damage.tofloat() 	: 90.0
	local MinDamage 		= "MinDamage" 			in table ? table.MinDamage	 		: damage.tofloat()/2.0
	local DamageDeadzone 	= "DamageDeadzone" 		in table ? table.DamageDeadzone		: 0.0
	local trace 			= "trace" 				in table ? table.trace	 			: true
	local particle 			= "particle" 			in table ? table.particle 			: ""
	local particle_ang 		= "particle_ang"		in table ? table.particle_ang 		: QAngle(-90, 0, 0)
	local particle_offset 	= "particle_offset"		in table ? table.particle_offset 	: Vector()
	local DmgType 			= "DmgType" 			in table ? table.DmgType 			: DMG_GENERIC|DMG_BLAST
	local DmgCustom 		= "DmgCustom" 			in table ? table.DmgCustom 			: TF_DMG_CUSTOM_TRIGGER_HURT
	local FuncBeforeDmg		= "FuncBeforeDmg"		in table ? table.FuncBeforeDmg 		: false
	local ExplodeFunc		= "ExplodeFunc"			in table ? table.ExplodeFunc		: function( ... ) { /* do what you want on explosion */ }
	local ignores			= "ignores"				in table ? table.ignores			: []
	local OnlyPlayers		= "OnlyPlayers"			in table ? table.OnlyPlayers		: false
	local FuncOnIgnore		= "FuncOnIgnore"		in table ? table.FuncOnIgnore 		: false
	local FuncIgnoreObjects	= "FuncIgnoreObjects"	in table ? table.FuncIgnoreObjects 	: false
	local kill_icon 		= "kill_icon"			in table ? table.kill_icon			: ""

	local SoundRadius 		= "SoundRadius" 		in table ? table.SoundRadius 		: radius
	local SoundDelay 		= "SoundDelay" 			in table ? table.SoundDelay 		: 0.5

	Assert(owner && owner.IsPlayer(), "CreateBaseExplosion currently need a owner")

	local scope = GetScope(owner)
	if (!("LastExplosionTime" in scope))
		scope.LastExplosionTime <- 0

	if (sound != "")
		PrecacheSound(sound)

	// always update the list (could be expensive but this func is not run often)
	ReCalculatePlayers()

	local targets = Players.filter(@(_, p) p.GetTeam() != owner.GetTeam() )

	if (!OnlyPlayers)
	{
		targets.extend(GetAllEntitiesByClassnameWithin("tank_boss", origin, radius).filter(@(_, ent) ent.GetTeam() != owner.GetTeam() ))
		targets.extend(GetAllEntitiesByClassnameWithin("obj*", origin, radius).filter(@(_, ent) ent.GetClassname() != "obj_attachment_sapper").filter(@(_, ent) ent.GetTeam() != owner.GetTeam()))
	}

	local actual_icon = null
	local Temp_icon = false
	if (kill_icon != "")
	{
		if (type(kill_icon) == "string")
		{
			actual_icon = CreateKillIcon(kill_icon)
			Temp_icon = true
		}
	}

	if (actual_icon != null)
		EntFireNew(actual_icon, "Kill", "", 1.0)

	DebugDrawClear()
	foreach (entity in targets)
	{
		local isIgnored = ignores.find(entity) != null
		local delta = entity.GetCenter() - origin
		local distance = delta.Length()

		if (distance > radius)
			continue

		if (trace && !CanPointSeePoint(origin, entity.GetCenter()))
			continue

		if (isIgnored)
		{
			if (FuncOnIgnore && (!FuncIgnoreObjects || entity.IsPlayer()))
				ExplodeFunc(entity)
			continue
		}

		local currentDamage = damage
		if (!MATH.HasBitFlag(DmgType, DMG_RADIUS_MAX))
		{
			if (distance <= DamageDeadzone)
				currentDamage = damage
			else
				currentDamage = MATH.RemapVal(distance, DamageDeadzone, radius, damage, MinDamage)
			// printl("DEBUG: Dist: " + distance + " | Rad: " + radius + " | Deadzone: " + DamageDeadzone + " | Dmg: " + damage + " | MinDmg: " + MinDamage + " | Final: " + currentDamage)
		}
		// DebugDrawText(entity.GetCenter(),currentDamage.tostring(), false, 60)

		if (FuncBeforeDmg && (!FuncIgnoreObjects || entity.IsPlayer())) 
			ExplodeFunc(entity)
		if (kill_icon != "")
			entity.TakeDamageCustom(actual_icon, owner, weapon, Vector(), Vector(), currentDamage, DmgType, 0)
		else
			entity.TakeDamageCustom(inflictor, owner, weapon, Vector(), Vector(), currentDamage, DmgType, DmgCustom)
		if (!FuncBeforeDmg && (!FuncIgnoreObjects || entity.IsPlayer())) 
			ExplodeFunc(entity)
	}

	// DebugDrawCircle(origin, Vector(255, 0, 0), 50, radius, false, 15)
	// DebugDrawCircle(origin+Vector(0,0,1), Vector(0, 0, 255), 50, DamageDeadzone, false, 15)
	DebugDrawSphere(origin, Vector(255, 0, 0), radius, false, 15)
	DebugDrawSphereInternal(origin, DamageDeadzone, 0, 0, 255, false, 15)
	

	if (particle != "")
		CreateParticle(particle, origin+particle_offset, particle_ang)

	if (sound != "" && scope.LastExplosionTime <= Time())
	{
		EmitSoundEx({
			sound_name = sound
			entity = owner
			origin = origin
			sound_level = MATH.ConvertRadiusToSndLvl(SoundRadius)
		})
		DebugDrawSphere(origin, Vector(255, 255, 255), SoundRadius, false, 30, 10)
		scope.LastExplosionTime = Time() + SoundDelay
	}
}
/**
 * @param {table} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer	// The owner of the damage to report it back to.
 * center: Vector		// The position to create the explosion.
 * radius: float		// How big the explosion can hit.
 * maxDmg: float		// The Maximum damage to deal.
 * minDmg: float		// The Minimum damage to deal.
 * ignore: [CBaseEntity]	// What entitys to ignore in the explosion.
 * dmg_Type: integer	// DMG_ type to mark the damage as.
 * sound: string		// Sound to play on explosion.
 * particle: string	// Particle to spawn on explosion.
 * ```
 */
function ROOT::CreateAoE( table )
{
	CreateBaseExplosion({
		owner = table.owner,
		origin = table.center,
		radius = table.radius,
		damage = table.maxDmg,
		MinDamage = table.minDmg,
		ignores = table.ignore,
		DmgType = table.dmg_Type,
		sound = table.sound,
		particle = table.particle
	})
}

/**
 * @param {table} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer	// The owner of the damage to report it back to.
 * weapon: CTFWeaponBase	// The weapon to credit for damage.
 * center: Vector		// The position to create the explosion.
 * radius: float		// How big the explosion can hit.
 * damage: float		// How much damage to deal.
 * ignore: [CBaseEntity]	// What entitys to ignore in the explosion.
 * SoundRadius: float	// Radius in which the sound can be heard
 * func: function		// Function to use on players hit 
 * ```
 */
function ROOT::CreateKnifeAoE( table )
{
	CreateBaseExplosion({
		owner = table.owner,
		weapon = table.weapon,
		origin = table.center,
		radius = table.radius,
		damage = table.damage,
		ignores = table.ignore,
		DmgType = DMG_BLAST|DMG_PREVENT_PHYSICS_FORCE|DMG_RADIUS_MAX,
		sound = "weapons/barret_arm_fizzle.wav",
		particle = "drg_cow_explosioncore_charged",
		SoundRadius = table.SoundRadius
		FuncBeforeDmg = true,
		FuncOnIgnore = true,
		ExplodeFunc = table.func
		FuncIgnoreObjects = true
	})
}

/**
 * @param {table} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer	// The owner of the damage to report it back to.
 * weapon: CTFWeaponBase	// The weapon to credit for damage.
 * center: Vector		// The position to create the explosion.
 * radius: float		// How big the explosion can hit.
 * damage: float		// How much damage to deal.
 * ignore: [CBaseEntity]	// What entitys to ignore in the explosion.
 * ```
 */
function ROOT::CreateSlamAoE( table )
{
	if (!SLAM_ICON || !SLAM_ICON.IsValid())
		SLAM_ICON = CreateKillIcon("hale_slam_collateral")
	CreateBaseExplosion({
		owner = table.owner,
		weapon = table.weapon,
		origin = table.center,
		radius = table.radius,
		damage = table.damage,
		ignores = table.ignore,
		particle_offset = Vector(0, 0, 16)
		DmgType = DMG_RADIUS_MAX|DMG_ALWAYSGIB|DMG_MELEE,
		particle = "chaos_stomp_parent" // PARTICLE MAY NOT BE PACKED
		kill_icon = SLAM_ICON
	})
	PrecacheSound("ambient/explosions/explode_1.wav")
	EmitSoundEx({
		channel 		= 6
		sound_level		= 140

		sound_name		= "ambient/explosions/explode_1.wav"
		entity = table.owner
	})
}

/** 
 * @param {any} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer			// The owner of the damage to report it back to.
 * inflictor: CBaseEntity|null		// The Inflictor to use.
 * center: Vector			// The position to create the explosion at.
 * damage: float			// The Damage of the explosion.
 * radius: float			// The Radius of the explosion (Default: 200)
 * func: function			// the fireball function
 * ```
 */
function ROOT::CreateFireballExplosion( table )
{
	CreateBaseExplosion({
		owner = table.owner,
		weapon = table.owner,
		inflictor = table.inflictor
		origin = table.center,
		radius = "radius" in table ? table.radius : 200
		damage = table.damage,
		DmgCustom = TF_DMG_CUSTOM_SPELL_FIREBALL
		ignores = [],
		DmgType = DMG_RADIUS_MAX|DMG_IGNITE|DMG_BURN,
		FuncBeforeDmg = true
		ExplodeFunc = table.func
		FuncIgnoreObjects = true
	})
}

/** 
 * @param {table} table
 * 
 * # Input table
 * ```sqDoc
 * owner: CTFPlayer	// The owner of the damage to report it back to.
 * center: Vector		// The position to create the explosion at.
 * ```
 */
function ROOT::CreateSentryBusterExplosion( table )
{
	CreateKillIcon("megaton")
	if (!BUSTER_ICON || !BUSTER_ICON.IsValid())
		BUSTER_ICON = CreateKillIcon("megaton")
	CreateBaseExplosion({
		owner = table.owner,
		weapon = table.owner,
		origin = table.center,
		radius = 300,
		damage = 300000,
		ignores = [],
		DmgType = DMG_RADIUS_MAX|DMG_BLAST,
		particle = "fluidSmokeExpl_ring_mvm"
		kill_icon = BUSTER_ICON
	})
}

/*
  =========================================
  === END OF CUSTOM EXPLOSION FUNCTIONS ===
  =========================================
*/

/*
  ==============================
  === CHAT TRIGGER FUNCTIONS ===
  ==============================
*/

if (!("ChatTriggers" in ROOT))
	::ChatTriggers <- {}

/** 
 * Registers a chat command that can be activated with `![command]` or `/[command]`
 * 
 * @param {string|[string]} trigger
 * @param {function} callback
 * @throws {string}
 */
function ROOT::AddChatTrigger( trigger, callback, ... )
{
	local errors = []
	if (typeof trigger == "string")
		ChatTriggers[trigger] <- [callback].extend(vargv)
	else if (typeof trigger == "array")
	{
		foreach (trig in trigger)
		{
			if (typeof trig != "string")
			{
				errors.append(format("AddChatTrigger: Item %s : Unknown Type %s when Registering Chat Trigger", trig.tostring(), typeof trig))
				continue
			}
			ChatTriggers[trig] <- [callback].extend(vargv)
		}
	}
	else throw format("AddChatTrigger: Unknown Type %s when Registering Chat Trigger", typeof trigger)
	if (errors.len() != 0)
		PrintArray(errors)
}
/** 
 * Just `AddChatTrigger` but only allows admins to use it
 * 
 * @type {function}
 * @param {string|[string]} trigger
 * @param {function} callback
 */
function ROOT::RegisterAdminTrigger( trigger, callback )
	AddChatTrigger(trigger, callback, "IsAdmin")

/*
  =====================================
  === END OF CHAT TRIGGER FUNCTIONS ===
  =====================================
*/


/*
  =================================
  === DAMAGE CALLBACK FUNCTIONS ===
  =================================
*/

if (!("RegisteredDmgCallbacks" in ROOT))
	::RegisteredDmgCallbacks <- {
		"player" : {}
		"worldspawn" : {}
	}

function ROOT::ClearDamageCallbacks()
	::RegisteredDmgCallbacks <- {
		"player" : {}
		"worldspawn" : {}
	}
/**
 * @param {string|[string]} entity_name
 * @param {string} callback_name
 * @param {function} callback
 */
function ROOT::RegisterDamageCallback( entity_name, callback_name, callback )
{
	if (typeof entity_name == "array")
	{
		foreach (name in entity_name)
		{
			if (!(name in RegisteredDmgCallbacks))
				RegisteredDmgCallbacks[name] <- {}

			RegisteredDmgCallbacks[name][callback_name] <- callback
		}
	}
	else 
	{
		if (!(entity_name in RegisteredDmgCallbacks))
			RegisteredDmgCallbacks[entity_name] <- {}

		RegisteredDmgCallbacks[entity_name][callback_name] <- callback
	}
}

/**
 * @param {string|[string]} entity_name
 * @param {string} callback_name
 */
function ROOT::RemoveDamageCallback( entity_name, callback_name )
{
	if (typeof entity_name == "string")
	{
		if (IsNotInTable(entity_name, RegisteredDmgCallbacks))
			return

		if (IsInArray(callback_name, RegisteredDmgCallbacks[entity_name].keys()))
			delete RegisteredDmgCallbacks[entity_name][callback_name]

		if (RegisteredDmgCallbacks[entity_name].len() == 0)
			delete RegisteredDmgCallbacks[entity_name]
		return
	}

	if (typeof entity_name != "array")
		return

	foreach (entity in entity_name)
	{
		if (typeof entity != "string")
			continue
		if (IsNotInTable(entity, RegisteredDmgCallbacks))
			continue

		if (IsInArray(callback_name, RegisteredDmgCallbacks[entity].keys()))
			delete RegisteredDmgCallbacks[entity][callback_name]

		if (RegisteredDmgCallbacks[entity].len() == 0)
			delete RegisteredDmgCallbacks[entity]
	}
}
// INNER FUNCTION
/**
 * @param {table} params
 */
function ParamsToDamageCallbackData( params )
{
	return {
		victim 				= params.const_entity
		attacker 			= params.attacker
		inflictor 			= params.inflictor
		weapon 				= params.weapon
		crit_type 			= params.crit_type
		damage_type 		= params.damage_type
		damage_position 	= params.damage_position
		damage 				= params.damage
		damage_custom 		= params.damage_custom
		base_damage 		= params.const_base_damage

		penetration_count	= params.player_penetration_count
		others_damaged		= params.damaged_other_players
	}
}
	

/*
  ========================================
  === END OF DAMAGE CALLBACK FUNCTIONS ===
  ========================================
*/

/*
  ================================
  === PLAYER PARSING FUNCTIONS ===
  ================================
*/

if (!("Players" in ROOT))
	::Players <- []

if (!("m_aHumans" in ROOT))
	::m_aHumans <- []

if (!("m_aRobots" in ROOT))
	::m_aRobots <- []

if (!("PlayerArray" in ROOT))
	::PlayerArray <- []

if (!("HumanArray" in ROOT))
	::HumanArray <- []

if (!("BotArray" in ROOT))
	::BotArray <- []

function ROOT::ValidatePlayers()
{
	local invalid = []

	foreach (player in PlayerArray)
		if ( !player || !player.IsValid() )
			invalid.append( player )

	foreach ( player in invalid ) {

		delete PlayerArray[ player ]

		if ( player in HumanArray )
			delete HumanArray[ player ]

		if ( player in BotArray )
			delete BotArray[ player ]
	}
}

function ROOT::ReCalculatePlayers()
{
	::Players <- GetAllPlayers()
	::m_aRobots <- []
	::m_aHumans <- []
	foreach (player in Players) { if (player.IsBot()) { m_aRobots.append(player) } else { m_aHumans.append(player) } }
}
function ROOT::ValidatePlayerArray()
{
	foreach (player in Players)
	{
		EnableStringPurge(player)
		if (!player || !player.IsValid() || player.GetClassname() != "player")
			return false
	}
	return true	
}

/*
  =======================================
  === END OF PLAYER PARSING FUNCTIONS ===
  =======================================
*/

/*
  ===========================
  === ADVANCED STAT STUFF ===
  ===========================
*/

if (!("m_iDamage" in GetScope(PlayerManager)))
	GetScope(PlayerManager).m_iDamage <- array(MAX_CLIENTS+1, 0)

if (!("m_iDamageBoss" in GetScope(PlayerManager)))
	GetScope(PlayerManager).m_iDamageBoss <- array(MAX_CLIENTS+1, 0)

if (!("m_iHealing" in GetScope(PlayerManager)))
	GetScope(PlayerManager).m_iHealing <- array(MAX_CLIENTS+1, 0)

/*
  ==================================
  === END OF ADVANCED STAT STUFF ===
  ==================================
*/

/*
  ================================
  === SPAWN CALLBACK FUNCTIONS ===
  ================================
*/

if (!("PostSpawnCallbacks" in ROOT))
	::PostSpawnCallbacks <- {}

function ROOT::ClearSpawnCallbacks()
	::PostSpawnCallbacks <- {}

/**
 * @param {string|[string]} entity_name
 * @param {string} callback_name
 * @param {function} callback
 */
function ROOT::RegisterSpawnCallback( entity_name, callback_name, callback )
{
	if (typeof entity_name == "array")
	{
		foreach (name in entity_name)
		{
			if (!(name in PostSpawnCallbacks)) 
				PostSpawnCallbacks[name] <- {}
			PostSpawnCallbacks[name][callback_name] <- callback
		}
	}
	else if (typeof entity_name == "string")
	{
		if (!(entity_name in PostSpawnCallbacks)) 
			PostSpawnCallbacks[entity_name] <- {}
		PostSpawnCallbacks[entity_name][callback_name] <- callback
	}
	else throw format("Unknown Type \"%s\" in SpawnCallback ", typeof entity_name)
}

/** 
 * @type {function}
 * @param {string|[string]} entity_name
 * @param {string} callback_name
 */
function ROOT::RemoveSpawnCallback( entity_name, callback_name )
{
	if (typeof entity_name == "string")
	{
		if (IsNotInTable(entity_name, PostSpawnCallbacks))
			return

		if (IsInArray(callback_name, PostSpawnCallbacks[entity_name].keys()))
			delete PostSpawnCallbacks[entity_name][callback_name]

		if (PostSpawnCallbacks[entity_name].len() == 0)
			delete PostSpawnCallbacks[entity_name]
		return
	}

	if (typeof entity_name != "array")
		return

	foreach (entity in entity_name)
	{
		if (typeof entity != "string")
			continue
		if (IsNotInTable(entity, PostSpawnCallbacks))
			continue

		if (IsInArray(callback_name, PostSpawnCallbacks[entity].keys()))
			delete PostSpawnCallbacks[entity][callback_name]

		if (PostSpawnCallbacks[entity].len() == 0)
			delete PostSpawnCallbacks[entity]
	}
}

CreateThinker("OnEntityPostSpawn" , function() {
	local Ents = []
	foreach (ent_name, _callbacks in PostSpawnCallbacks)
		Ents.extend(GetAllEntitiesByClassname(ent_name))

	foreach (entity in Ents)
	{
		local scope = GetScope(entity)
		if ("SpawnCallbacked" in scope)
			return
		scope.SpawnCallbacked <- true

		foreach (_callback_name, callback in PostSpawnCallbacks[entity.GetClassname()])
		{
			callback(entity)
			// printf("Applied SpawnCallback %s to %s\n", _callback_name.tostring(), entity.tostring())
		}
	}
	return -1
}, THINKER_PERSIST)

/* RegisterSpawnCallback("tf_projectile_rocket", function( entity ) {
	AddThinkToEnt(entity, "ProjectileThink")

	local owner = entity.GetOwner()

	local offset = owner.GetActiveWeapon().ShootPosition()
	entity.SetAbsOrigin(offset)
	// entity.SetAbsAngles(owner.EyeAngles())
	entity.SetForwardVector(Vector(1, 0 ,0))
})
*/

/*
  =======================================
  === END OF SPAWN CALLBACK FUNCTIONS ===
  =======================================
*/

/*
  =============================
  === ONCOND HOOK FUNCTIONS ===
  =============================
*/

if (!("OnCondPostHooks" in FatCatLibSettings))
	SetLibrarySettings()

if (FatCatLibSettings["OnCondPostHooks"] == true) 
{
	CreateThinker("OnCondition", function() {
		local funcScope = GetScope(FindByName(null, "OnCondition"))

		if (!("OnAddCond" in funcScope) || type(funcScope.OnAddCond) != "array")
		{
			funcScope.OnAddCond <- array(TF_COND_RANGE)
			for (local i = 0; i < TF_COND_RANGE; i++)
				funcScope.OnAddCond[i] = {}
		}
		if (!("OnRemoveCond" in funcScope) || type(funcScope.OnRemoveCond) != "array")
		{
			funcScope.OnRemoveCond <- array(TF_COND_RANGE)
			for (local i = 0; i < TF_COND_RANGE; i++)
				funcScope.OnRemoveCond[i] = {}
		}

		for (local CondNum = 0; CondNum < TF_COND_RANGE; CondNum++) 
		{
			local condition = funcScope.OnAddCond[CondNum]
			if (condition.len() == 0)
				continue
			foreach (_name, func in condition)
			{
				foreach (player in Players)
				{
					local scope = GetScope(player)
					if (scope == null)
						continue
					if (!("CheckedAddconds" in scope))
						scope.CheckedAddconds <- array(TF_COND_RANGE, false)
					
					local WasInCond = scope.CheckedAddconds[CondNum]

					if (!WasInCond && player.InCond(CondNum))
					{
						// printl("Called OnAddCond for cond "+CondNum+" Frame: "+GetFrameCount())
						func.call(player)
					}

					scope.CheckedAddconds[CondNum] = player.InCond(CondNum)
				}
			}
		}

		for (local CondNum = 0; CondNum < TF_COND_RANGE; CondNum++) 
		{
			local condition = funcScope.OnRemoveCond[CondNum]
			if (condition.len() == 0)
				continue
			foreach (_name, func in condition)
			{
				foreach (player in Players)
				{
					local scope = GetScope(player)
					if (!("CheckedAddconds" in scope))
						scope.CheckedAddconds <- array(TF_COND_RANGE, false)
					
					local WasInCond = scope.CheckedAddconds[CondNum]

					if (WasInCond && !player.InCond(CondNum))
					{
						// printl("Called OnRemoveCond for cond "+CondNum+" Frame: "+GetFrameCount())
						func.call(player)
					}
					scope.CheckedAddconds[CondNum] = player.InCond(CondNum)
				}
			}
		}

		return -1
	}, THINKER_PERSIST)
}
else if (FindByName(null, "OnCondition"))
	FindByName(null, "OnCondition").Kill()

/*
  ===================================
  === END OF ONCOND HOOK FUNCTIONS ===
  ====================================
*/
/** 
 * @var {CTFPlayer} self
 */
function FireWeaponCheck()
{
	if (self.IsDead())
		return 0.1

	foreach (/**@type {CTFWeaponBase} */wep in self.GetAllWeapons())
	{
		if (wep.GetClassname() == "tf_weapon_flamethrower")
		{	// TF2Classified turns it into a int with -1, 0, and 1
			if (GetPropInt(GetPropEntity(wep, "LocalFlameThrowerData.m_hFlameManager"), "m_bIsFiring") == 1)
			{
				FireScriptEvent("PlayerFireWeapon", {player = self, weapon = wep})
				self.AddCondEx(wep.GetAttribute("add cond on attack", -1).tointeger(), wep.GetAttribute("add cond on attack duration", 1), self)
			}
			continue
		}
		else if ("IsMeleeWeapon" in wep && wep.IsMeleeWeapon())
		{
			if (GetPropInt(self, "m_Shared.m_iNextMeleeCrit") > 0)
			{
				FireScriptEvent("PlayerFireWeapon", {player = self, weapon = wep})
				SetPropInt(self, "m_Shared.m_iNextMeleeCrit", -2)

				self.AddCondEx(wep.GetAttribute("add cond on attack", -1).tointeger(), wep.GetAttribute("add cond on attack duration", 1), self)
			}
			continue
		}

		local scope = GetScope(wep)
		if (!("LastFireTime" in scope))
			scope.LastFireTime <- 0.0

		local FireTime = GetPropFloat(wep, "m_flLastFireTime")
		
		if (FireTime > scope.LastFireTime)
		{
			FireScriptEvent("PlayerFireWeapon", {player = self, weapon = wep})
			self.AddCondEx(wep.GetAttribute("add cond on attack", -1).tointeger(), wep.GetAttribute("add cond on attack duration", 1), self)
			scope.LastFireTime = FireTime
		}
	}
	return -1
}
/** 
 * @var {CTFPlayer} self
 */
function SwapWeaponThink()
{
	if (self.IsDead())
		return 0.1
	local current = self.GetActiveWeapon()
	/** @type {CTFWeaponBase|null} */
	local old = "ActiveWeapon" in this ? ActiveWeapon : null

	if (!("ActiveWeapon" in this))
		this.ActiveWeapon <- null

	if (current == null || !current.IsValid())
		return -1

	if (old == null || !old.IsValid())
	{
		ActiveWeapon = current
		return -1
	}

	// Swapped Weapons
	if (old != current)
	{
		local cannot_deploy = old.GetAttribute("cannot deploy slot # when active", -1)

		if (current.GetSlot() == cannot_deploy)
		{
			self.Weapon_Switch(old)
			self.PrintToHud("Switching to that weapon is Blocked!")
			return -1 // blocked
		}

		FireScriptEvent("PlayerSwapWeapon", {
			old_slot = old.GetSlot()
			new_slot = current.GetSlot()
		})
	}
	
	return -1
}

/*
  =============================
  === CUSTOM EVENT HANDLING ===
  =============================
*/
/** 
 * @type {function}
 * @param {CTFPlayer|CTFBot} player
 */
function ROOT::PostPlayerSpawn( player )
{
	if (!IsValidPlayer(player))
		return
	player.StripItemSlot(player.HookAdditiveAttributes("strip item slot"))

	if (player.HookAdditiveAttributes("use sentrybuster model") > 0)
	{
		player.UseGiantModel(true)
		EmitSoundOn("MVM.SentryBusterIntro", player)
	}
	else if (player.HookAdditiveAttributes("use giant robot model") > 0)
		player.UseGiantModel()
	else if (player.HookAdditiveAttributes("use robot model") > 0)
		player.UseRobotModel()
	else if ((IsMannVsMachineMode() && !player.IsBot()) || !IsMannVsMachineMode())
		player.SetCustomModelWithClassAnimations("")

	if (player.HookAdditiveAttributes("set max health") != 0)
	{
		local to_hp = player.HookAdditiveAttributes("set max health")
		player.AddCustomAttribute(to_hp >= player.GetMaxHealth() ? "max health additive bonus" : "max health additive penalty", to_hp - player.GetMaxHealth(), -1)
		player.SetHealth(to_hp)
	}

	player.SetForcedTauntCam(0)

	if (player.HookAdditiveAttributes("prevent third person") == 0 && player.HookAdditiveAttributes("use third person") > 0)
		player.SetForcedTauntCam(1)

	local slot = -1
	foreach (wep in player.GetAllWeapons())
	{
		if (wep.GetAttribute("force slot on spawn", -1) != -1)
			slot = wep.GetAttribute("force slot on spawn", -1)
	}
	if (slot > -1)
	{
		local wep = player.GetWeaponInSlotNew(slot)
		if (wep && !wep.IsWearable())
			RunWithDelay(0.1, @() player.Weapon_Switch(wep))
	}
	
	foreach (wep in player.GetAllWeapons())
		player.SetCond(wep.GetAttribute("cond on spawn", -1), wep.GetAttribute("cond on spawn duration", -1))

	player.SetCond(player.GetCustomAttribute("cond on spawn", -1), player.GetCustomAttribute("cond on spawn duration", -1))

	FireScriptEvent("player_postspawn", {player = player})
}

	/**
	 * @param {table} params
	 * 
	 * # Input table
	 * ```sqDoc
	 * userid: integer
	 * health: integer // if <= 0, then this will play the killsound
	 * attacker: integer
	 * damageamount: integer
	 * custom: integer
	 * showdisguisedcrit: bool // if our attribute specifically crits disguised enemies we need to show it on the client
	 * crit: bool // legacy only, use bonuseffect
	 * minicrit: bool // legacy only, use bonuseffect
	 * allseecrit: bool
	 * weaponid: integer
	 * bonuseffect: integer // type of damage effect, see constants page.
	 * ```
	 * ## Warning:
	 * A value of 4 is no damage effect. 0 is crits!
 	 */

// Makes Custom Events to listen to
::ChaosCustomEvents <- {
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer
	 * ```
	 */
	function OnGameEvent_post_inventory_application( params )
	{
		local eventdata = clone params

		eventdata.player <- GetPlayerFromUserID(params.userid)

		if (!IsValidPlayer(eventdata.player))
			return

		// Assert(eventdata.player && eventdata.player.IsPlayer(), "post_inventory_application Received a NULL/Non player")

		local scope = GetScope(eventdata.player)
		if (!("HasSpawned" in scope) && !eventdata.player.IsBot())
		{
			local TimeTable = {}
			LocalTime(TimeTable)

			local motd = ""
			switch(TimeTable.month)
			{
			case 1: // January
			break
			case 2: // February
			break
			case 3: // March
			break
			case 4: // April
				if (TimeTable.day == 1)
					motd = "Happy April Fools"
			break
			case 5: // May
			break
			case 6: // June
				motd = "Happy Pride Month!"
			break
			case 7: // July
			break
			case 8: // August
			break
			case 9: // September
			break
			case 10: // October
				motd = "Happy Halloween!"
			break
			case 11: // November
			break
			case 12: // December
				motd = "Merry Christmas!"
			break
			}
			local Override = false
			/** @type {bool | function} */
			local override_func = null
			if ("MOTD_OVERRIDE" in ROOT && MOTD_OVERRIDE != "")
			{
				motd = MOTD_OVERRIDE
				Override = true
			}
			if ("MOTD_FUNC" in ROOT && type(MOTD_FUNC) == "function")
				override_func = MOTD_FUNC

			if (override_func != null)
				RunWithDelay(3.0, @() override_func(eventdata.player)) // always validate the player in this
				
			if (Override)
				RunWithDelay(3.0, @() eventdata.player.PrintToChat(motd))
			else if (motd != "")
				RunWithDelay(3.0, @() eventdata.player.PrintToChatF("\x01\x07E000E0► FatCatLib ◄   \x03%s", motd))
			scope.HasSpawned <- true
		}

		// overridden
		delete eventdata.userid

		if (GetPropBool(eventdata.player, "m_Shared.m_bInUpgradeZone"))
			FireScriptEvent(eventdata.player.IsBot() ? "BotUpgraded" : "HumanUpgraded", eventdata)
		
		FireScriptEvent(eventdata.player.IsBot() ? "BotResupply" : "HumanResupply", eventdata)
	}
	/**
	 * Fired when a player dies. This shows up in the kill feed.
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID who died
	 * victim_entindex: integer
	 * inflictor_entindex: integer // ent index of inflictor (a sentry, for example)
	 * attacker: integer // user ID who killed
	 * weapon : string // weapon name killer used
	 * weaponid: integer // ID of weapon killer used
	 * damagebits: integer // bits of type of damage
	 * customkill: integer // type of custom kill
	 * assister: integer // user ID of assister
	 * weapon_logclassname : string // weapon name that should be printed on the log
	 * stun_flags: integer // victim's stun flags at the moment of death
	 * death_flags: integer // death flags
	 * silent_kill: bool
	 * playerpenetratecount: integer
	 * assister_fallback : string // contains a string to use if "assister" is -1
	 * kill_streak_total: integer // Kill streak count (level)
	 * kill_streak_wep: integer // Kill streak for killing weapon
	 * kill_streak_assist: integer // Kill streak for assister count
	 * kill_streak_victim: integer // Victims kill streak
	 * ducks_streaked: integer // Duck streak increment from this kill
	 * duck_streak_total: integer // Duck streak count for attacker
	 * duck_streak_assist: integer // Duck streak count for assister
	 * duck_streak_victim: integer // (former) duck streak count for victim
	 * rocket_jump: bool // was the victim rocket jumping
	 * weapon_def_index: integer // item def index of weapon killer used
	 * crit_type: integer // Crit type of kill. 0: None 1: Mini 2: Full
	 * ```
	 * #Note:
	 * 
	 * The fields below are now unused, check death_flags instead.
	 * ```sqDoc
	 * dominated: integer // did killer dominate victim with this kill
	 * assister_dominated: integer // did assister dominate victim with this kill
	 * revenge: integer // did killer get revenge on victim with this kill
	 * assister_revenge: integer // did assister get revenge on victim with this kill
	 * first_blood: bool // was this a first blood kill
	 * feign_death: bool // the victim is feign death
	 * ```
	 */
	function OnGameEvent_player_death( params )
	{
		local eventdata = clone params

		local victim = GetPlayerFromUserID(params.userid)
		local attacker = GetPlayerFromUserID(params.attacker)
		local assister = GetPlayerFromUserID(params.assister)

		eventdata.victim 	<- victim
		eventdata.attacker 	<- attacker
		eventdata.assister 	<- assister
		/** @type {string} */
		eventdata.logname 	<- params.weapon_logclassname
		/** @type {integer} */
		eventdata.weaponIDX <- params.weapon_def_index
		eventdata.inflictor <- EntIndexToHScript(params.inflictor_entindex)
		if (attacker && attacker.IsPlayer() && attacker.HasWeapon(eventdata.weaponIDX))
			/** @type {CTFWeaponBase} */
			eventdata.weapon <- attacker.GetWeapon(eventdata.weaponIDX)
		else 
			eventdata.weapon <- null

		if (eventdata.rocket_jump != 0)
			eventdata.rocket_jump <- true
		else
			eventdata.rocket_jump <- false
		
		if ("customkill" in eventdata)
			/** @type {integer} */
			eventdata.custom <- eventdata.customkill
		else
			eventdata.custom <- 0

		if (victim.HasCorrosion())
		{
			local corrosion = victim.GetCorrosion()
			if (corrosion.bMakesPuddle)
				victim.MakeCorrosionPuddle()
			victim.RemoveCorrosion()
		}

		if (IsWeaponClass(eventdata.weapon, "tf_weapon", true) && IsValidPlayer(eventdata.weapon.GetOwner()))
		{
			local weapon = eventdata.weapon
			local owner = weapon.GetOwner()
			local spellbook = owner.GetSpellBook()
			local spellscope = GetScope(spellbook)

			if (weapon.GetAttribute("draw temp hud alert on kill", 0) && IsValidPlayer(owner))
			{	// fucking 2 line tall chars
				owner.DisplayHudHint("██░░█░░██\n█░░░█░░░█\n█░░░█░░░█\n█░░░█░░░█\n█░░░░░░░█\n██░░█░░██", weapon.GetAttribute("draw temp hud alert on kill", 0))
			}

			// local weaponIDX = params.weapon_def_index
			// local logname = params.weapon_logclassname

			local allowed = true
			// foreach (name, idx in SpellWeapons)
			// {
			// 	if (name == logname || idx == weaponIDX)
			// 	{
			// 		allowed = true
			// 		break
			// 	}
			// }

			if ("IsMeleeWeapon" in weapon && weapon.IsMeleeWeapon())
			{	// only allow melee weapons that are melee attacks to give spells
				if (MATH.HasBitFlag(params.damagebits, DMG_CLUB) == false)
					allowed = false
			}

			local grant_spells = weapon.GetAttribute("give spell on kill", -1)
			local grant_spells_max = weapon.GetAttribute("give spell on kill max", 1)
			local grant_spells_kills = weapon.GetAttribute("give spell on kills needed", 0)
			
			if (grant_spells != -1 && allowed && spellbook)
			{
				if (!("m_iKills" in spellscope))
					spellscope.m_iKills <- 0

				spellscope.m_iKills++

				if (grant_spells != -1 && grant_spells_kills == 0)
					spellbook.ModifySpells(grant_spells, grant_spells_max)
				else
					spellbook.ModifySpells(grant_spells, grant_spells_max, spellscope.m_iKills, grant_spells_kills)
			}
		}

		// overridden
		delete eventdata.userid
		delete eventdata.weapon_logclassname
		delete eventdata.inflictor_entindex 
		delete eventdata.weapon_def_index
		// useless
		delete eventdata.victim_entindex 
		delete eventdata.customkill 
		delete eventdata.weaponid 
		if ("duck_streak_victim" in eventdata) 	delete eventdata.duck_streak_victim
		if ("duck_streak_total" 	in eventdata) 	delete eventdata.duck_streak_total
		if ("ducks_streaked" 	in eventdata) 	delete eventdata.ducks_streaked
		if ("duck_streak_assist" in eventdata) 	delete eventdata.duck_streak_assist
		if ("kill_streak_total" 	in eventdata) 	delete eventdata.kill_streak_total
		if ("kill_streak_wep" 	in eventdata) 	delete eventdata.kill_streak_wep
		if ("kill_streak_assist" in eventdata) 	delete eventdata.kill_streak_assist
		if ("kill_streak_victim" in eventdata) 	delete eventdata.kill_streak_victim

		if ("priority" 			in eventdata) 	delete eventdata.priority
		if ("silent_kill" 		in eventdata) 	delete eventdata.silent_kill
		// if you want to check for the below, check `death_flags` instead
		if ("dominated" 			in eventdata) 	delete eventdata.dominated
		if ("assister_dominated" in eventdata) 	delete eventdata.assister_dominated
		if ("revenge" 			in eventdata) 	delete eventdata.revenge
		if ("assister_revenge" 	in eventdata) 	delete eventdata.assister_revenge
		if ("first_blood" 		in eventdata) 	delete eventdata.first_blood
		if ("feign_death" 		in eventdata) 	delete eventdata.feign_death

		if (!HasCustomFlag(eventdata.custom, TF_DMG_CUSTOM_IGNORE_EVENTS))
			FireScriptEvent(victim.IsBot() ? "BotDeath" : "HumanDeath", eventdata)
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
	 * ```sqDoc
	 * const_entity: CBaseEntity	// The entity which took damage.
	 * inflictor: CBaseEntity|null	// The entity which dealt the damage, can be null.
	 * weapon: CBaseEntity|null	// The weapon which dealt the damage, can be null.
	 * attacker: CBaseEntity|null	// The owner of the damage, can be null.
	 * damage: float	// Damage amount.
	 * max_damage: float	// Damage cap.
	 * damage_bonus: float	 // Additional damage (e.g. from crits).
	 * ```
	 * ## Warning:
	 * 
	 * Always 0 because this hook is run before this is calculated.
	 * ```sqDoc
	 * damage_bonus_provider: CBaseEntity|null	// Owner of the damage bonus.
	 * ```
	 * ## Warning:
	 * 
	 * Always null because this hook is run before this is calculated.
	 * ```sqDoc
	 * const_base_damage: float	// Base damage.
	 * damage_force: Vector // Damage force.
	 * damage_for_force_calc: float
	 * ```
	 * ## Bug:
	 * 
	 * This value does not seem to do anything.
	 * ```sqDoc
	 * damage_position: Vector // World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * reported_position: Vector // World position of where the damage supposedly came from.
	 * damage_type: integer // Combination of damage types. See Constants.FDmgType
	 * damage_custom: integer
	 * ```
	 * ## Bug:
	 * 
	 * Because of a code oversight, this value is read-only. Use damage_stats instead which can be read and written.
	 * ```sqDoc
	 * damage_stats: integer // Special damage type. See Constants.ETFDmgCustom. Unlike damage_type, only one custom damage type can be set.
	 * force_friendly_fire: bool // If true, force the damage to friendlyfire, regardless of this entity's and attacker's team.
	 * ```
	 * ## Note:
	 * 
	 * Hitscan/melee will not run OnTakeDamage unless the mp_friendlyfire convar is set to 1.
	 * ```sqDoc
	 * ammo_type: integer // Unused.
	 * player_penetration_count: integer // How many players the damage has penetrated so far.
	 * damaged_other_players: integer // How many players other than the attacker has the damage been applied to. Used for rocket jump damage reduction.
	 * crit_type: integer // Type of crit damage. 0 - None, 1 - Mini, 2 - Full. The numbers correspond to Constants.ECritType.
	 * ```
	 * ## Warning:
	 * 
	 * Always 0 because this hook is run before this is set. You can check for DMG_ACID in damage_type, which is set when the shot will be critical, however, it doesn't show ordinary hits which would be converted to critical ones like Neon Annihilator hitting a soaked target or a Bushwacka hitting with a mini-crit. Alternative would be to check whether the damage is crit in player_hurt event, which also works for mini-crits as well, the downside is that this event happens only after the damage has been dealt so no changes inside the hook are possible.
	 * If you want to force the damage to be critical you need to set DMG_ACID to be included in damage_type:
	 * 
	 * params.damage_type = params.damage_type | Constants.FDmgType.DMG_ACID
	 * For players, if you want to force the damage to be a mini-crit you can add a mini-crit cond to the attacker inside this hook and remove it in player_hurt or npc_hurt respective events afterwards. Example:
	 * 
	 * ## Note:
	 * 
	 * Setting this to 1 makes the damage act as a mini-crit, while producing full crit sounds and visuals, this can be used for cases where the attacker is not a player since only physical aspect of the damage would matter. Setting it to 2 has no effect.
	 * ```sqDoc
	 * early_out: bool // If set to true by the script, the game's damage routine will not run and it will simply return the currently set damage.
	 * ```
	 */
	function OnScriptHook_OnTakeDamage( params )
	{
		if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_INTERNAL))
			return

		local IsCrit = MATH.HasBitFlag(params.damage_type, DMG_CRITICAL) 
		local IsFall = MATH.HasBitFlag(params.damage_type, DMG_FALL)
		local IsCrush = MATH.HasBitFlag(params.damage_type, DMG_CRUSH)
		local IsMelee = MATH.HasBitFlag(params.damage_type, DMG_CLUB)
		
		/** @type {CBaseEntity} */
		local victim = params.const_entity
		/** @type {CBaseEntity|null} */
		local attacker = params.attacker
		/** @type {CBaseEntity|null} */
		local inflictor = params.inflictor

		if (victim == null || !victim.IsValid())
			return

		if (IsCrush && victim.IsPlayer() && victim.HookAdditiveAttributes("crush dmg immunity"))
			params.early_out <- true

		if (params.damage_custom == TF_DMG_CUSTOM_SUICIDE && victim.IsPlayer() && victim.HookAdditiveAttributes("prevent suicide"))
			params.early_out <- true
		
		/** 
		 * @param {CBaseEntity|null} ent
		 * @returns {string}
		 */
		// local function str( ent ) { return ent && ent.IsValid( ) ? ent.tostring( ) : "null"	}

		// local builder = inflictor ? GetBuilder(inflictor.GetOwner()) : null
		// local thrower = HasProp(inflictor, "m_hThrower") ? GetPropEntity(inflictor, "m_hThrower") : null
		// if (thrower == null)
		// 	thrower = GetLauncher(inflictor)
		/* PrintToHudAllF("Inflictor: %s\nWeapon_Owner: %s\nInflictor_Owner: %s\nThrower/Launcher: %s", 
		str(inflictor), 
		params.weapon && params.weapon.IsValid() ? str(params.weapon.GetOwner()) : "null"
		inflictor && inflictor.IsValid() ? str(inflictor.GetOwner()) : "null"
		thrower && thrower.IsValid() ? str(thrower) : "null"
		) */

		// To fix `sentry bullet weapon` and `sentry rocket weapon`
		// if inflictors owner is sentry and is not a sentry rocket
		if (inflictor && inflictor.GetClassname() != "tf_projectile_sentryrocket" && inflictor.GetOwner() && inflictor.GetOwner().GetClassname() == "obj_sentrygun")
		{
			local builder = GetBuilder(inflictor.GetOwner())
			if (builder && builder.IsValid() && builder.IsPlayer())
			{
				inflictor.SetOwner(builder)
				params.damage *= builder.HookMultAttributes("engy sentry damage bonus")
				if (attacker != builder)
				{
					attacker = builder
					params.attacker = builder
				}
				// builder.PrintToHudF("Inflictor: %s  Inflictor_Owner: %s", inflictor.tostring(), inflictor.GetOwner().tostring())
			}
		}

		if(inflictor && "DamageMultiplier" in GetScope(inflictor))
		{
			if("DAMAGE_MULT_DEBUG" in ROOT && DAMAGE_MULT_DEBUG == true)
			{
				printf("Inflictor \"%s\" is giving a dmg mult of %0.3f against \"%s\"\n", inflictor.tostring(), GetScope(inflictor).DamageMultiplier, victim.tostring())
				printf("\tBringing Dmg from %0.2f to %0.2f\n", params.damage.tofloat(), params.damage * GetScope(inflictor).DamageMultiplier)
			}
			params.damage *= GetScope(inflictor).DamageMultiplier
		}

		if(inflictor && "ShouldIgnite" in GetScope(inflictor) && GetScope(inflictor).ShouldIgnite == true && IsValidEnemy(victim))
		{
			local weapon = params.weapon == GetPropEntity(inflictor, "m_hLauncher") ? params.weapon : GetPropEntity(inflictor, "m_hLauncher")
			if(weapon && weapon.IsValid() && weapon.GetOwner() != victim)
			{
				local old_val = weapon.GetAttribute("Set DamageType Ignite", 0)
				weapon.AddAttribute("Set DamageType Ignite", 1, 0)
				if(old_val == 0)
					RunWithDelay(TICK_DUR, @() weapon.RemoveAttribute("Set DamageType Ignite"))
				else
					RunWithDelay(TICK_DUR, @() weapon.AddAttribute("Set DamageType Ignite", old_val, 0))
			}
		}

		// is_suicide_counter
		if (params.damage_custom == TF_DMG_CUSTOM_TELEFRAG && attacker == inflictor && attacker == victim)
		{
			params.early_out <- true
			victim.RemoveCondEx(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED)
			victim.RemoveCondEx(TF_COND_INVULNERABLE)
			victim.RemoveCondEx(TF_COND_INVULNERABLE_WEARINGOFF)
			victim.TakeUnblockableDamage(victim.HookAdditiveAttributes("is suicide counter"), Worldspawn, Worldspawn, Worldspawn)
		}

		if (attacker && attacker.IsPlayer())
		{
			if (params.damage_custom >= TF_DMG_CUSTOM_SPELL_TELEPORT && params.damage_custom <= TF_DMG_CUSTOM_KART)
			{
				local spell_book = attacker.GetSpellBook()
				if (spell_book)
					params.weapon = spell_book
			}
			
			switch(params.damage_custom)
			{
			case TF_DMG_CUSTOM_SPELL_SKELETON:
				params.damage *= attacker.HookMultAttributes("spellskeletons dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_MIRV:
				params.damage *= attacker.HookMultAttributes("spellmirv dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_METEOR:
				params.damage *= attacker.HookMultAttributes("spellmeteor dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_LIGHTNING:
				params.damage *= attacker.HookMultAttributes("spelllightningorb dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_FIREBALL:
				params.damage *= attacker.HookMultAttributes("spellfireball dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_MONOCULUS:
				params.damage *= attacker.HookMultAttributes("spelleyeball dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_BLASTJUMP:
				params.damage *= attacker.HookMultAttributes("spelljump dmg mult")
			break
			case TF_DMG_CUSTOM_SPELL_BATS:
				params.damage *= attacker.HookMultAttributes("spellbats dmg mult")
			break
			case TF_DMG_CUSTOM_KART:
				params.damage *= attacker.HookMultAttributes("halloween kart dmg mult")
			break

			case TF_DMG_CUSTOM_BLEEDING:
				if (!IsWeaponClass(params.weapon, "tf_weapon", true))
					break
				if (IsCrit || attacker.IsCritBoosted() && params.weapon.GetAdditiveAttribute("allow crit bleed"))
				{
					params.damage_type = params.damage_type | DMG_CRITICAL
				}
			break
			case TF_DMG_CUSTOM_BOOTS_STOMP:
				local stomping_weapon = attacker.GetActiveWeapon()
				local secondary = attacker.GetWeaponInSlotNew(SLOT_SECONDARY)

				if (secondary && secondary.IsWearable() && secondary.CanStomp())
					stomping_weapon = secondary

				foreach (weapon in attacker.GetAllWeapons())
				{
					if (weapon.GetAttribute("perfer as stomping weapon", 0))
					{
						stomping_weapon = weapon
						break
					}
				}

				if (stomping_weapon && stomping_weapon.GetAttribute("stomp uses velocity", 0))
				{
					local FallingVel = attacker.GetAbsVelocity().z
					if (!("LastVels" in GetScope(victim)))
						GetScope(victim).LastVels <- []
					foreach (vel in GetScope(attacker).LastVels)
					{
						if (vel.z < FallingVel)
							FallingVel = vel.z
					}

					if (FallingVel >= 0)
						FallingVel = -600

					params.damage = -1 * (FallingVel * stomping_weapon.GetMultAttribute("stomp dmg mult"))
				}
				else
					params.damage *= attacker.HookMultAttributes("stomp dmg mult")

				// local stomp_wep = attacker.GetActiveWeapon()

				// local sec = attacker.GetWeaponInSlotNew(SLOT_SECONDARY)
				// if (sec && sec.IsWearable() && sec.CanStomp())
					// stomp_wep = sec

				params.weapon = stomping_weapon
			break
			case TF_DMG_CUSTOM_BACKSTAB:
				if (!IsWeaponClass(params.weapon, "tf_weapon", true))
					break

				/**@type {CTFWeaponBase} */
				local weapon = params.weapon
				local iExplosiveBackstab = weapon.GetAttribute("explosive backstab", 0)
				if ( iExplosiveBackstab == 0 )
					break;

				local radius = weapon.GetAttribute("explosive backstab base radius", 250) + (iExplosiveBackstab * weapon.GetAttribute("explosive backstab radius add", 0))
				local damage = weapon.GetAttribute("explosive backstab base damage", 3125) + (iExplosiveBackstab * weapon.GetAttribute("explosive backstab damage add", 0))
				CreateKnifeAoE({
					owner = attacker
					weapon = params.weapon
					radius = radius
					damage = damage
					center = victim.GetCenter()
					ignore = [victim]
					SoundRadius = radius * 3
					/**
					 * @param {CTFPlayer|CTFBot|CBaseEntity} player
					 */
					function func( player ) {
						if (!player || !player.IsValid() || !player.IsPlayer())
							return
						player.StunPlayer(MATH.Clamp(iExplosiveBackstab - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, attacker )
					}
				})
			break
			}
			if (ROOT.IsDamageTaunt(params.damage_custom))
			{
				params.damage *= attacker.HookMultAttributes("taunt dmg mult")
				if (attacker.GetActiveWeapon())
					params.damage *= attacker.GetActiveWeapon().GetMultAttribute("taunt dmg mult active")
			}

			if (IsWeaponClass(params.weapon, "tf_weapon", true) && IsValidPlayer(params.weapon.GetOwner()))
			{
				/** @type {CTFWeaponBase} */
				local weapon = params.weapon
				local owner = weapon.GetOwner()
				local spellbook = owner.GetSpellBook()

				if ( IsMelee && ("IsMeleeWeapon" in weapon && weapon.IsMeleeWeapon()) )
				{
					if (IsValidPlayer(owner) && spellbook)
					{
						local grant_spells = weapon.GetAttribute("give spell on hit", -1)

						if (grant_spells != -1)
							spellbook.ModifySpells(grant_spells, weapon.GetAttribute("give spell on hit max", 2))
					}
				}
				else if ( !IsMelee && ("IsMeleeWeapon" in weapon && weapon.IsMeleeWeapon()) == false )
				{
					if (IsValidPlayer(owner) && spellbook)
					{
						local grant_spells = weapon.GetAttribute("give spell on hit", -1)

						if (grant_spells != -1)
							spellbook.ModifySpells(grant_spells, weapon.GetAttribute("give spell on hit max", 2))
					}
				}

				if (weapon.GetAttribute("chance to miss", 0) != 0)
				{
					local chance = weapon.GetAttribute("chance to miss", 0)
					if (MATH.RandomChance() <= chance) // missed
					{
						params.early_out <- true
						CreateParticle("miss_text", victim.GetCenter() + Vector(0,0,32))
					}
				}

				if (weapon.IsSniperRifle() && weapon.GetChargePercent() != 0.0 && weapon.GetAttribute("mult damage from rifle charge", 1 ) != 1.0)
				{
					params.damage *= (weapon.GetChargePercent() + 1) * weapon.GetAttribute("mult damage from rifle charge", 1.0)
				}
			}

			if (attacker.InAirDueToExplosion() && attacker.GetActiveWeapon() && attacker.GetActiveWeapon() == params.weapon)
				params.damage *= attacker.GetActiveWeapon().GetMultAttribute("mult dmg while blast jumping")

			if (!attacker.IsOnGround() && attacker.GetActiveWeapon() && attacker.GetActiveWeapon() == params.weapon)
				params.damage *= attacker.GetActiveWeapon().GetMultAttribute("mult dmg while airborne")
		}

		local weapon = params.weapon

		if (victim.IsPlayer())
		{
			switch(params.damage_custom)
			{
			case TF_DMG_CUSTOM_SPELL_SKELETON:
				params.damage *= victim.HookMultAttributes("spellskeletons dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_MIRV:
				params.damage *= victim.HookMultAttributes("spellmirv dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_METEOR:
				params.damage *= victim.HookMultAttributes("spellmeteor dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_LIGHTNING:
				params.damage *= victim.HookMultAttributes("spelllightningorb dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_FIREBALL:
				params.damage *= victim.HookMultAttributes("spellfireball dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_MONOCULUS:
				params.damage *= victim.HookMultAttributes("spelleyeball dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_BLASTJUMP:
				params.damage *= victim.HookMultAttributes("spelljump dmg taken mult")
			break
			case TF_DMG_CUSTOM_SPELL_BATS:
				params.damage *= victim.HookMultAttributes("spellbats dmg taken mult")
			break
			case TF_DMG_CUSTOM_KART:
				params.damage *= attacker.HookMultAttributes("halloween kart dmg taken mult")
			break

			case TF_DMG_CUSTOM_BLEEDING:
				params.damage *= victim.HookMultAttributes("bleeding dmg taken mult")
				if (victim.InCond(TF_COND_PLAGUE) && weapon == null) // best way to tell so far
					params.damage *= victim.HookMultAttributes("plague dmg taken mult")
			break

			case TF_DMG_CUSTOM_BOOTS_STOMP:
				params.damage *= victim.HookMultAttributes("stomp dmg taken mult")
			break
			}
			if (IsFall && (!attacker || !attacker.IsPlayer()))
			{
				params.damage *= victim.HookMultAttributes("fall dmg taken mult")

				GetScope(victim).FallDamageVel <- victim.GetAbsVelocity().z
				if (victim.HookAdditiveAttributes("fall damage causes aoe"))
				{
					local FallingVel = victim.GetAbsVelocity().z
					if (!("LastVels" in GetScope(victim)))
						GetScope(victim).LastVels <- []
					foreach (vel in GetScope(victim).LastVels)
					{
						if (vel.z < FallingVel)
							FallingVel = vel.z
					}

					weapon = victim.GetActiveWeapon()

					if (weapon == null)
						weapon = victim.GetWeaponInSlotNew(SLOT_MELEE)

					local MIN_FallingVel = weapon.GetAttribute("fall damage causes aoe min speed", 0)

					local AOE_Radius = weapon.GetAttribute("fall damage causes aoe radius", 0)
					if (AOE_Radius == 0)
						AOE_Radius = 300

					local AOE_damage = weapon.GetAttribute("fall damage causes aoe dmg mult", 1)

					// victim.PrintToHud("Falling at: "+FallingVel+"\nWe need less than this: "+MIN_FallingVel)

					if (FallingVel < 0 && victim.GetGroundEntity() && FallingVel <= MIN_FallingVel)
					{
						CreateSlamAoE({
							owner = victim,
							weapon = weapon,
							center = victim.GetOrigin()+Vector(0, 0, 16),
							radius = AOE_Radius,
							damage = abs(FallingVel * AOE_damage),
							ignore = [],
						})
					}
				}
			}
		}

		if (victim.IsPlayer() && attacker && attacker.IsPlayer())
		{
			if (victim.CanHaveCorrosion() && IsWeaponClass(weapon, "tf_weapon", true))
			{
				if (weapon.GetAdditiveAttribute("corrosion on hit") != 0)
					victim.MakeCorrosion(attacker, weapon)
				else if (weapon.GetAdditiveAttribute("corrosion on crit") != 0 && MATH.HasBitFlag(params.damage_type, DMG_CRITICAL))
					victim.MakeCorrosion(attacker, weapon)
				// attacker.PrintToHud("Made Corrosion on " + victim)
			}

			// only available with Sourcemod
			if ("MakeBleedInternal" in CTFPlayer)
			{
				if (IsWeaponClass(weapon, "tf_weapon", true))
				{
					if (weapon.GetAttribute("stackable bleed", 0) != 0)
					{
						local duration = weapon.GetAttribute("stackable bleed duration", 5)

						victim.MakeBleed(attacker, null, duration, weapon.GetAttribute("stackable bleed", 4))
						// victim.MakeBleedInternal(attacker, null, duration, weapon.GetAttribute("stackable bleed", 4), infinite ,TF_DMG_CUSTOM_BLEED)
					}
				}
			}

			switch(params.damage_custom)
			{
			case TF_DMG_CUSTOM_BOOTS_STOMP:
				if (!IsWeaponClass(weapon, "tf_weapon", true))
					break

				if (weapon.GetAdditiveAttribute("cond on stomped"))
					victim.AddCondEx(weapon.GetAdditiveAttribute("cond on stomped", -1), weapon.GetAdditiveAttribute("cond on stomped duration", 1), attacker)

				if (weapon.GetAdditiveAttribute("cond on stomp"))
					attacker.AddCondEx(weapon.GetAdditiveAttribute("cond on stomp", -1), weapon.GetAdditiveAttribute("cond on stomp duration", 1), attacker)
			break
			}
		}

		if (victim.GetClassname() in RegisteredDmgCallbacks && !HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_NO_CALLBACKS))
		{
			foreach (_callback_name, callback in RegisteredDmgCallbacks[victim.GetClassname()])
			{
				local ReturningData = ParamsToDamageCallbackData(clone params)

				// Call the Callback with this table
				callback(ReturningData)

				foreach ( key, value in ReturningData )
					params[key] <- value
			}
		}

		if (weapon && weapon.GetClassname() == "tf_weapon_flamethrower" && victim.IsValid())
			params.damage_position <- victim.GetCenter()

		if (params.damage_position == Vector() && victim.IsValid())
			params.damage_position <- victim.GetCenter()

		// [5/7/26]
		// why do vanilla conditions do this shit
		if (victim.IsValid() && victim.IsPlayer() && !victim.InRespawnRoom() && victim.InCond(TF_COND_INVULNERABLE_WEARINGOFF))
			victim.RemoveCondEx(TF_COND_INVULNERABLE_WEARINGOFF, true)

		// [1/1/26]
		// Shitty Infinite Reflect loop fix
		if (params.damage_custom == TF_DMG_CUSTOM_RUNE_REFLECT)
		{
			if (victim.IsValid() && victim.IsPlayer() && attacker.IsPlayer() && victim.HasRune(RUNE_REFLECT) && attacker.HasRune(RUNE_REFLECT))
			{
				params.damage_type = params.damage_type | DMG_PREVENT_PHYSICS_FORCE
				params.damage_force = Vector(1, 1, 1)
				params.early_out = true
			}
		}

		if ( (params.damage_custom == TF_DMG_CUSTOM_BLEEDING) || (params.damage_custom == TF_DMG_CUSTOM_BURNING) )
			params.damage_type = params.damage_type | DMG_PREVENT_PHYSICS_FORCE

		local eventdata = clone params

		eventdata.victim 							<- victim
		if (victim.IsValid() && victim.IsPlayer()) 
			eventdata.hit_group 					<- GetPropInt(victim, "m_LastHitGroup")
		else 
			eventdata.hit_group 					<- 0
		eventdata.damage_custom 					<- params.damage_stats
		eventdata.base_damage 						<- params.const_base_damage
		eventdata.penetration_count 				<- params.player_penetration_count
		eventdata.others_damaged 					<- params.damaged_other_players

		// useless
		delete eventdata.damage_bonus
		delete eventdata.damage_bonus_provider
		delete eventdata.ammo_type
		delete eventdata.damage_for_force_calc
		delete eventdata.force_friendly_fire
		// delete eventdata.damage_force
		// delete eventdata.reported_position
		delete eventdata.early_out
		delete eventdata.max_damage
		// overridden
		delete eventdata.const_entity
		delete eventdata.damage_stats
		delete eventdata.const_base_damage
		delete eventdata.player_penetration_count
		delete eventdata.damaged_other_players

		if ("DAMAGE_DEBUG" in ROOT && DAMAGE_DEBUG)
		{
			PrintTable(eventdata)
		}

		if (!HasCustomFlag(eventdata.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS))
		{
			if (victim && victim.IsValid() && victim.IsPlayer())
				FireScriptEvent(victim.IsBot() ? "PostTakeDamageBot" : "PostTakeDamageHuman", eventdata)
			else if (victim == Worldspawn)
				FireScriptEvent("PostTakeDamageWorld", eventdata)
			else
				FireScriptEvent("PostTakeDamage", eventdata)
		}
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
	 * ```sqDoc
	 * userid: integer
	 * health: integer // if <= 0, then this will play the killsound
	 * attacker: integer
	 * damageamount: integer
	 * custom: integer
	 * showdisguisedcrit: bool // if our attribute specifically crits disguised enemies we need to show it on the client
	 * crit: bool // legacy only, use bonuseffect
	 * minicrit: bool // legacy only, use bonuseffect
	 * allseecrit: bool
	 * weaponid: integer
	 * bonuseffect: integer // type of damage effect, see constants page.
	 * ```
	 * ## Warning:
	 * A value of 4 is no damage effect. 0 is crits!
 	 */
	function OnGameEvent_player_hurt( params )
	{
		local eventdata = clone params

		local victim 	= GetPlayerFromUserID(params.userid)
		local attacker 	= GetPlayerFromUserID(params.attacker)
		if (!attacker || !attacker.IsPlayer()) return // only player vs player
		eventdata.victim 		<- victim
		eventdata.attacker 		<- attacker
		eventdata.damage 		<- params.damageamount
		eventdata.damage_custom <- params.custom
		eventdata.killed 		<- params.health <= 0 || params.health == null
		if (eventdata.bonuseffect in BONUS_EFFECT_REMAP) eventdata.bonuseffect <- BONUS_EFFECT_REMAP[eventdata.bonuseffect]

		if ("showdisguisedcrit" in eventdata) 	eventdata.showdisguisedcrit <- eventdata.showdisguisedcrit != 0
		else 									eventdata.showdisguisedcrit <- false

		if ("allseecrit" in eventdata) 			eventdata.allseecrit <- eventdata.allseecrit != 0
		else 									eventdata.allseecrit <- false

		/// sdk thing
		// if ("weapon_entindex" in eventdata)
		// {
		// 	local weapon = EntIndexToHScript(eventdata.weapon_entindex)
		// 	eventdata.weapon <- weapon
		// 	if (weapon && weapon.getclass() == CTFWeaponBase)
		// 		weapon.SetClip1(2)
		// }

		if (victim.GetHealth() < 0)
		{// for some reason if health < 0 it defaults to 0, even if it was supposed to get negative
			eventdata.health <- victim.GetHealth()
			eventdata.damage += victim.GetHealth()
			eventdata.over_damage <- abs(victim.GetHealth())
		}
		else eventdata.over_damage <- 0

		if (!attacker.IsBot() && attacker != victim && eventdata.damage > 0 && attacker.GetTeam() != victim.GetTeam())
		{
			if (eventdata.damage > victim.GetMaxHealth())
				attacker.AddTrackedDamage(victim.GetMaxHealth())
			else 
				attacker.AddTrackedDamage(eventdata.damage)
		}

		// overridden
		delete eventdata.userid
		delete eventdata.damageamount
		delete eventdata.custom
		// useless
		if ("priority" 	in eventdata) delete eventdata.priority
		if ("weaponid" 	in eventdata) delete eventdata.weaponid
		if ("crit" 		in eventdata) delete eventdata.crit
		if ("minicrit" 	in eventdata) delete eventdata.minicrit

		if (!HasCustomFlag(eventdata.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS))
			FireScriptEvent(victim.IsBot() ? "PostBotHurt" : "PostHumanHurt", eventdata)
	}
	/**
	 * This event will be sent once when the player entity is created, i.e. they joined the server or they are loading in after a map change. 
	 * In this case, team is equal to 0 (unassigned). Each time afterwards, the event will only be fired when the player spawns alive on red or blue team. 
	 * 
	 * This is also fired once when SourceTV is loaded in.
	 * 
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID who spawned
	 * team: integer // team they spawned on
	 * class: integer // class they spawned as
	 * ```
	 * ## Warning!
	 * 
	 * Cannnot access `class` input using `table.key` syntax. use string indexing instead table["key"].
	 * 
	 * e.x. `params["class"]` instead of `params.class`
	 */
	function OnGameEvent_player_spawn( params )
	{
		local eventdata = clone params

		/**
		 * @type {CTFPlayer|CTFBot}
		 */
		local player = GetPlayerFromUserID(params.userid)
		eventdata.player <- player

		if (!IsValidPlayer(player))
			return

		// if you spawn in you are likely touching a spawn room
		SetPropInt(player, "m_Shared.m_iSpawnRoomTouchCount", 1)

		ClearThinks(player)
		if (!player.IsBot())
		{
			player.SetUpThinkTable()
			if ("PreservedThinks" in GetScope(player) && GetScope(player).PreservedThinks.len() != 0)
			{
				foreach (name, data in GetScope(player).PreservedThinks)
					player.AddPreservedThink(data.func, name, data.offset)
			}

			SetPropInt(player, "m_Shared.m_iNextMeleeCrit", -2)
			player.AddThink(FireWeaponCheck, "FireWeaponCheck")
			player.AddThink(SwapWeaponThink, "SwapWeaponThink")
		}

		// Better func
		RunWithDelay(THREE_TICKS, @() PostPlayerSpawn(player))

		if (player.IsAdmin())
			SetPropInt(player, "m_autoKickDisabled", 1)

		// overridden
		delete eventdata.userid

		if (eventdata.team == TF_TEAM_UNASSIGNED)
		{
			ReCalculatePlayers()
			RunWithDelay(0.1, @() (ReCalculatePlayers()))
			RunWithDelay(1.0, @() (ReCalculatePlayers()))
			RunWithDelay(5.0, @() (ReCalculatePlayers()))
			FireScriptEvent( player.IsBot() ? "BotInitialSpawn" : "HumanInitialSpawn", eventdata)
		}
		else 
			FireScriptEvent( player.IsBot() ? "BotSpawn" : "HumanSpawn", eventdata)
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID on server
	 * team: integer // team id
	 * oldteam: integer // old team id
	 * disconnect: bool // team change because player disconnects
	 * autoteam: bool // true if the player was auto assigned to the team
	 * silent: bool // if true wont print the team join messages
	 * name: string // player's name
	 * ```
	 */
	function OnGameEvent_player_team( params )
	{
		local eventdata = clone params

		local player = GetPlayerFromUserID(params.userid)

		eventdata.player <- player
		if (!IsValidPlayer(player))
			return
		// Assert(player && player.IsPlayer(), "player_team Received a NULL/Non player")

		if (!("m_iDamage" in GetScope(PlayerManager)))
			GetScope(PlayerManager).m_iDamage <- array(MAX_CLIENTS+1, 0)
		if (!("m_iDamageBoss" in GetScope(PlayerManager)))
			GetScope(PlayerManager).m_iDamageBoss <- array(MAX_CLIENTS+1, 0)
		if (!("m_iHealing" in GetScope(PlayerManager)))
			GetScope(PlayerManager).m_iHealing <- array(MAX_CLIENTS+1, 0)

		if (!("BetterStatTracking" in FatCatLibSettings))
			SetLibrarySettings()


		if (FatCatLibSettings["BetterStatTracking"] == true)
		{
			// idk
			if (player.IsBot())
			{
				player.SetTrackedDamage( ) 		// reset to 0
				player.SetTrackedTankDamage( ) 	// reset to 0
				player.SetTrackedHealing( ) 	// reset to 0
			}
		}
		eventdata.username <- eventdata.name

		// overridden
		delete eventdata.userid
		delete eventdata.name

		FireScriptEvent(player.IsBot() ? "BotTeam" : "HumanTeam", eventdata)

		ReCalculatePlayers()
		RunWithDelay(0.1, @() (ReCalculatePlayers()))
		RunWithDelay(1.0, @() (ReCalculatePlayers()))
		RunWithDelay(5.0, @() (ReCalculatePlayers()))
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID on server
	 * text: string // the say text
	 * ```
	 */
	function OnGameEvent_player_say( params )
	{
		local eventdata = {}

		local player = GetPlayerFromUserID(params.userid)
		eventdata.message <- params.text
		eventdata.player <- player

		local text = eventdata.message.tolower() // could be a problem but, ehh, who cares

		FireScriptEvent(player ? ( player.IsBot() ? "BotSay" : "HumanSay") : "ConsoleSay", eventdata)

		if (!IsStringATrigger(text))
			return
			
		local data = SplitStringBetter(RemoveCommandTrigger(text))
		// local data = split(RemoveCommandTrigger(text), " ") // if shit breaks un-comment

		if (data.len() == 0)
			return
		local trigger = data[0]
		data.insert(1, player)

		if (!(trigger in ChatTriggers))
			return

		foreach (Trigger, CallbackInfo in ChatTriggers)
		{
			if (trigger != Trigger)
				continue
			local temp = clone data
			temp.remove(0)
			if (CallbackInfo.len() == 1 || !player)
			{
				CallbackInfo[0].acall([ROOT].extend(temp))
				continue
			}

			local filters = CallbackInfo.slice(1)

			local PassedFilters = false

			foreach (filter in filters)
			{
				if (filter == "IsAdmin" && player.IsAdmin())
					PassedFilters = true
				else if (filter == "IsEventJudge" && player.IsEventJudge())
					PassedFilters = true
			}

			if (PassedFilters)
			{
				CallbackInfo[0].acall([ROOT].extend(temp))
				FireScriptEvent("ChatCommand", {
					command = Trigger
					player = player
					data = data
				})
			}
		}
	}
	/**
	 * Fired when an Engineer building (obj_sentrygun, obj_dispenser, obj_teleporter), base_boss, MvM tank (tank_boss) 
	 * or Halloween enemy (headless_hatman, eyeball_boss, merasmus, tf_zombie) is damaged.
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * entindex: integer // entindex of victim
	 * health: integer // health of victim
	 * attacker_player: integer // user ID of attacking player
	 * weaponid: integer
	 * damageamount: integer // damage done to victim
	 * crit: bool
	 * boss: integer // 1=HHH 2=Monoculus 3=Merasmus
	 * ```
	 */
	function OnGameEvent_npc_hurt( params )
	{
		local eventdata = clone params

		local object = EntIndexToHScript(params.entindex)
		local attacker = GetPlayerFromUserID(params.attacker_player)

		/* if (object.GetClassname() == "base_boss" || object.GetClassname() == "vscript_boss")
		{
			eventdata.health <- object.GetHealth() - params.damageamount
		} */
		eventdata.damage <- params.damageamount
		if (object.GetHealth() < 0)
		{
			// this shits a little because events are shorts and not floats
			eventdata.over_damage <- abs(object.GetHealth())
			eventdata.damage += object.GetHealth()
		}

		if (attacker && attacker.IsPlayer() && !attacker.IsBot() && eventdata.damage > 0 && attacker.GetTeam() != object.GetTeam())
		{
			local damage_func = IsTank(object) ? "AddTrackedTankDamage" : "AddTrackedDamage"
			if (eventdata.damage > object.GetMaxHealth())
				attacker[damage_func](object.GetMaxHealth())
			else 
				attacker[damage_func](eventdata.damage)

		}
		local event_type = "null"

		if (IsBuilding(object))
		{
			if ("crit" in eventdata) delete eventdata.crit
			event_type = "Building"
		}
		else if (endswith(object.GetClassname(), "boss"))
		{
			event_type = startswith(object.GetClassname(),"tank_") ? "Tank" : "BaseBoss"
		}
		if ("boss" in eventdata)
		{
			local BOSSES = [
				""
				"HHH",
				"Monoculus",
				"Merasmus"
			]
			if (eventdata.boss > 0 && eventdata.boss < 3)
				event_type = BOSSES[eventdata.boss]
		}		
		// overridden
		eventdata.object <- object
		eventdata.attacker <- attacker
		if ("crit" 	in eventdata)	eventdata.crit <- eventdata.crit == 1
		else						eventdata.crit <- false
		delete eventdata.entindex
		delete eventdata.attacker_player
		delete eventdata.damageamount
		if ("weaponid" 	in eventdata)	delete eventdata.weaponid
		if ("boss" 		in eventdata) 	delete eventdata.boss


		if (event_type != "null")
		{
			if (eventdata.health > 0)
			{
				FireScriptEvent(event_type+"Hurt", eventdata)
			}
			else
			{
				FireScriptEvent(event_type+"Killed", eventdata)
			}
		}
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * patient: integer // user ID of patient
	 * healer: integer // user ID of healer
	 * amount : integer
	 * ```
	 */
	function OnGameEvent_player_healed( params )
	{
		local eventdata = clone params

		eventdata.patient <- GetPlayerFromUserID(params.patient)
		eventdata.healer <- "healer" in params ? GetPlayerFromUserID(params.healer) : null
		if (!IsValidPlayer(eventdata.patient))
			return
		// Assert(eventdata.patient && eventdata.patient.IsPlayer(), "player_healed Received a NULL/Non player")

		if (eventdata.healer) eventdata.healer.AddTrackedHealing(params.amount)
		FireScriptEvent(eventdata.patient.IsBot() ? "BotHealed" : "HumanHealed", eventdata)
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID on server
	 * reason: string // reason for disconnect e.g. "client disconnect", "[name] timed out."
	 * name: string // player name
	 * networkid: string // player network (i.e steam) id
	 * bot: integer // is a bot
	 * ```
	 */
	function OnGameEvent_player_disconnect( params ) 
	{
		ReCalculatePlayers()
		RunWithDelay(0.1, @() (ReCalculatePlayers()))
		RunWithDelay(1.0, @() (ReCalculatePlayers()))
		RunWithDelay(5.0, @() (ReCalculatePlayers()))

		ValidatePlayers()

		local player = GetPlayerFromUserID(params.userid)
		if (!player)
			return
		player.SetTrackedDamage( ) // reset to 0
		player.SetTrackedTankDamage( ) // reset to 0
		player.SetTrackedHealing( ) // reset to 0


		if ( player in HumanArray )
			delete HumanArray[ player ]
			
		if ( player in BotArray )
			delete BotArray[ player ]

		if ( player in PlayerArray )
			delete PlayerArray[ player ]

		ValidatePlayers()
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID of the builder
	 * object integer // type of object `ObjectType_t`
	 * index: integer // entindex of build object
	 * ```
	 */
	function OnGameEvent_player_builtobject( params )
	{
		local eventdata = clone params
		
		local player = GetPlayerFromUserID(params.userid)
		eventdata.player <- player

		if (!IsValidPlayer(player))
			return
		// Assert(player && player.IsPlayer(), "player_builtobject Received a NULL/Non player")

		local typetable = array(4, "")
		typetable[OBJ_DISPENSER] = "Dispenser"
		typetable[OBJ_TELEPORTER] = "Teleporter"
		typetable[OBJ_SENTRY] = "Sentry"
		typetable[OBJ_SAPPER] = "Sapper"
		local event_name = typetable[params.object]
		event_name += "Built"

		local object = EntIndexToHScript(params.index)
		eventdata.object <- object

		// GetScope(object).m_hBuilder <- player
		// GetScope(object).m_iObjectType <- GetPropInt(object, "m_iObjectType")

		// overridden
		delete eventdata.userid
		delete eventdata.index

		// local scope = GetScope(player)
		// if (!("BuildingsArray" in scope))
			// scope.BuildingsArray <- [ {}, {}, {}, {} ]
		// scope.BuildingsArray[params.object][object.entindex()] <- object
		// printf("Added %s to players object array\n", object.tostring())

		/* GetScope(object).DestroyCallbacks <- [] 
		local function AddDestroyCallback( func ) { DestroyCallbacks.append( func ) }
		GetScope(object).AddDestroyCallback <- AddDestroyCallback

		SetDestroyCallback(object, function() {
			local self = self
			foreach (callback in DestroyCallbacks)
			{
				callback(self)
			}

			local owner = m_hBuilder

			if (owner && owner.IsValid() && owner.IsPlayer())
			{
				local o_scope = GetScope(owner)
				if (!("BuildingsArray" in o_scope))
					return // fucked up somewhere
				local owner_buildings = o_scope.BuildingsArray
				local type = m_iObjectType

				PrintArray(owner_buildings[type])

				local i = 0
				for (i = 0; i <= owner_buildings[type].len() -1; i++)
				{
					local obj = owner_buildings[type][i]
					printf("Object %s [%d]\n", obj.tostring(), i)
					printl(obj == self)
					printl(obj.weakref())
					if (obj == self)
					{
						printf("Removed %s from object array\n", obj.tostring())
						owner_buildings[type].remove(i)
					}
				}
				// local aself = owner_buildings[type].find(self)

				// Assert(aself != null, "more fucked up shit?")
				
				// printf("Removed %s from object array\n", owner_buildings[type][aself].tostring())
				// owner_buildings[type].remove(aself)
			}
		}) */

		FireScriptEvent(event_name, eventdata)
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID who died
	 * attacker: integer // user ID who killed
	 * assister: integer // user ID of assister
	 * weapon: string // weapon name killer used
	 * weaponid: integer // id of the weapon used
	 * objecttype: integer // type of object destroyed
	 * index: integer // entindex of the object destroyed
	 * was_building: bool // was object being built when it died
	 * team: integer // building's team
	 * ```
	 */
	function OnGameEvent_object_destroyed( params )
	{
		local owner = "userid" in params ? GetPlayerFromUserID(params.userid) : null
		local attacker = "attacker" in params ? GetPlayerFromUserID(params.attacker) : null
		local assister = "assister" in params ? GetPlayerFromUserID(params.assister) : null
		local object = EntIndexToHScript(params.index)

		local typetable = array(4, "")
		typetable[OBJ_DISPENSER] = "Dispenser"
		typetable[OBJ_TELEPORTER] = "Teleporter"
		typetable[OBJ_SENTRY] = "Sentry"
		typetable[OBJ_SAPPER] = "Sapper"
		local event_name = typetable[params.objecttype]

		FireScriptEvent(event_name + "Destroyed", {
			owner = owner
			attacker = attacker
			assister = assister
			object = object

			weapon_name = params.weapon
			building = params.was_building
		})

		/* if (owner && owner.IsPlayer())
		{
			local scope = GetScope(owner)
			if (!("BuildingsArray" in scope))
				scope.BuildingsArray <- [ {}, {}, {}, {} ]
			local buildings = scope.BuildingsArray

			PrintTable(buildings[params.objecttype])

			printl(object.entindex() in buildings[params.objecttype])
			if (object.entindex() in buildings[params.objecttype])
			{
				delete buildings[params.objecttype][object.entindex()]
			}
		} */

		// FireScriptEvent(event_name + "")
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID of the object owner
	 * objecttype: integer // type of object removed
	 * index: integer // entindex of the object removed
	 * ```
	 */
	function OnGameEvent_object_detonated( params )
	{
		// local eventdata = {}
		// PrintTable(params)
		local owner = "userid" in params ? GetPlayerFromUserID(params.userid) : null
		local type = params.objecttype
		local object = EntIndexToHScript(params.index)

		local typetable = array(4, "")
		typetable[OBJ_DISPENSER] = "Dispenser"
		typetable[OBJ_TELEPORTER] = "Teleporter"
		typetable[OBJ_SENTRY] = "Sentry"
		typetable[OBJ_SAPPER] = "Sapper"
		local event_name = typetable[params.objecttype]

		FireScriptEvent(event_name + "Detonated", {
			owner = owner
			type = type
			object = object
			detonated = false
		})
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * stunner: integer 
	 * ```
	 * ## Warning:
	 * 
	 * If there's no attacker, this key won't exist (such as being stunned after hitting a wall with a bumper kart)
	 * ```sqDoc
	 * victim: integer
	 * victim_capping: bool
	 * big_stun: bool
	 * ```
	 */
	function OnGameEvent_player_stunned( params )
	{
		local eventdata = clone params
		eventdata.stunner 			<- "stunner" in params ? GetPlayerFromUserID(params.stunner) : null
		eventdata.victim 			<- GetPlayerFromUserID(params.victim)
		eventdata.big_stun 			<- eventdata.big_stun == 1
		eventdata.victim_capping 	<- eventdata.victim_capping == 1

		FireScriptEvent("PlayerStunned", eventdata)
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID on server
	 * ```
	 */
	function OnGameEvent_player_activate( params )
	{
		local player = GetPlayerFromUserID(params.userid)

		if (!player)
			return
		// Assert(player, "player_activate Received a NULL Player!!!")

		if (!(player in player.IsBot() ? BotArray : HumanArray))
		{
			(player.IsBot() ? BotArray : HumanArray).append(player)
		}

		ValidatePlayers()
	}
	/**
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * userid: integer // user ID of player who deflected the object
	 * ownerid: integer // user ID of the owner of the object
	 * weaponid: integer // weapon id (0 means the player in ownerid was pushed)
	 * object_entindex: integer // entindex of the object that got deflected
	 * ```
	 */
	function OnGameEvent_object_deflected( params )
	{
		local object = EntIndexToHScript(params.object_entindex)
		local deflector = GetPlayerFromUserID(params.userid)
		local old_owner = GetPlayerFromUserID(params.ownerid)
		local event_name = "PlayerDeflected"

		if (params.weaponid != 0)
		{
			if (IsBaseRocket(object))
				event_name = "RocketDeflected"
			else if (IsBaseGrenade(object))
				event_name = "GrenadeDeflected"
			else
				event_name = "ObjectDeflected"
		}

		// local function str( obj ) {return obj?obj.tostring():"null"}

		// printf("%s Deflected %s that was shot from %s\n", str(deflector), str(object), str(old_owner))

		// printl("Old Owner: "+old_owner)
		// printl("Object Owner: "+object?object.GetOwner():"null")
		// printl("Object launcher: "+GetPropEntity(object, "m_hLauncher"))

		// fix rafmod homing sentry rockets?
		if (IsBaseRocket(object))
		{
			RunWithDelay(TWO_TICKS, @() FixTheFuckingRockets(object))
		}
		// if (object.GetClassname() == "tf_projectile_sentryrocket" && IsValidPlayer(old_owner))
		// {
		// 	if (old_owner.GetPlayerClass() == TF_CLASS_ENGINEER && old_owner.HookAdditiveAttributes("mod projectile heat seek power") != 0)
		// 	{
		// 		RunWithDelay(TWO_TICKS, @() object.SetAbsVelocity(object.GetAbsAngles().Forward() * object.GetAbsVelocity().Length()))
		// 		RunWithDelay(TWO_TICKS, @() object.SetMoveType(MOVETYPE_FLY, GetPropInt(object, "m_MoveCollide")))
		// 	}
		// }

		FireScriptEvent(event_name, {
			deflector = deflector
			object = object
			old_owner = old_owner
		})
	}

	/**
	 * @param {table} params
	 */
	function OnScriptHook_player_postspawn( params )
	{
		FireScriptEvent(params.player.IsBot() ? "PostBotSpawn" : "PostHumanSpawn", params)
	}

	
	/**
	 * @param {table} _
	 */
	function OnGameEvent_mvm_wave_complete( _ )
	{
		FireScriptEvent("WaveComplete", {})
		GetScope(Gamerules).IsWaveStarted <- false
	}
	/**
	 * @param {table} _
	 */
	function OnGameEvent_mvm_wave_failed( _ )
	{
		FireScriptEvent("WaveFailed", {})
		GetScope(Gamerules).IsWaveStarted <- false
		ToggleSlowDown()
	}
	/**
	 * @param {table} _
	 */
	function OnGameEvent_teamplay_round_start( _ )
		GetScope(Gamerules).IsWaveStarted <- false
	/**
	 * @param {table} _
	 */
	function OnGameEvent_mvm_begin_wave( _ )
		GetScope(Gamerules).IsWaveStarted <- true

	// Initalize Listensers so game wont discard the events

	/**
	 * Fired when a Human touches a resupply cabinet or respawns.
	 * 
	 * `Note:` Fired after HumanUpgraded
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * player: CTFPlayer // The player who resupplied.
	 * ```
	 */
	function OnScriptEvent_HumanResupply( _params ) 				{}
	/**
	 * Fired when a Human Upgrades and Before `HumanResupply`
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * player: CTFPlayer // The player who Upgraded.
	 * ```
	 */
	function OnScriptEvent_HumanUpgraded( _params ) 				{}

	/**
	 * Fired when a Bot touches a resupply cabinet or respawns.
	 * 
	 * `Note:` Fired after BotUpgraded
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * player: CTFPlayer // The bot who resupplied.
	 * ```
	 */
	function OnScriptEvent_BotResupply( _params ) 				{}
	/**
	 * Fired when a Bot Resupplys inside a Upgrade zone. Which is Likely an upgrade.
	 * 
	 * `Note:` i dont think this can actually "fire"
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * player: CTFBot // The bot who Upgraded.
	 * ```
	 */
	function OnScriptEvent_BotUpgraded( _params ) 				{}

	/**
	 * Fired when a bot dies. 
	 *
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CTFBot // The bot that died.
	 * attacker: CBaseEntity|null // The entity that killed the victim.
	 * assister: CBaseEntity|null // The entity that assisted the kill.
	 * weapon: CTFWeaponBase|null // The weapon used to kill.
	 * inflictor: CBaseEntity|null // The entity that dealt the damage (e.g. rocket/sentry).
	 * logname: string // The weapon name or inflictor name that relates to a kill-icon.
	 * damagebits: integer // Damage type bits.
	 * weaponIDX: integer // The definition index of the weapon.
	 * death_flags: integer // See TF_DEATH (ln~ 340).
	 * custom: integer // Custom kill type (e.g. headshot).
	 * stun_flags: integer // The victim's stun flags at the moment of death
	 * rocket_jump: bool // True if the attacker was rocket jumping.
	 * ```
	 */
	function OnScriptEvent_BotDeath( _params ) 					{}
	/**
	 * Fired when a human dies.
	 *  
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CTFPlayer // The human that died.
	 * attacker: CBaseEntity|null // The entity that killed the victim.
	 * assister: CBaseEntity|null // The entity that assisted the kill.
	 * weapon: CBaseEntity|null // The weapon used to kill.
	 * inflictor: CBaseEntity|null // The entity that dealt the damage (e.g. rocket/sentry).
	 * logname: string // The weapon name or inflictor name that relates to a kill-icon.
	 * damagebits: integer // Damage type bits.
	 * weaponIDX: integer // The definition index of the weapon.
	 * death_flags: integer // See TF_DEATH (ln~ 340).
	 * custom: integer // Custom kill type (e.g. headshot).
	 * stun_flags: integer // The victim's stun flags at the moment of death
	 * rocket_jump: bool // True if the attacker was rocket jumping.
	 * ```
	 */
	function OnScriptEvent_HumanDeath( _params ) 					{}

	/**
	 * Fired when a bot is about to take damage (Script Hook).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CTFBot // The bot taking damage.
	 * attacker: CBaseEntity|null // The entity dealing damage.
	 * inflictor: CBaseEntity|null // The entity inflicting damage (weapon/projectile).
	 * weapon: CBaseEntity|null // The weapon used.
	 * damage_position: Vector // World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * damage: float // The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * base_damage: float // The base damage before modifiers.
	 * damage_type: integer // Damage type bits (e.g. DMG_GENERIC).
	 * hit_group: integer // Hitgroup index (e.g. HITGROUP_HEAD).
	 * damage_custom: integer // Custom damage type stats.
	 * crit_type: integer // Crit type (0=None, 1=Mini, 2=Full).
	 * penetration_count: integer // How many players the damage has penetrated so far.
	 * others_damaged: integer // How many players other than the attacker has the damage been applied to.
	 * ```
	 */
	function OnScriptEvent_PostTakeDamageBot( _params ) 			{}
	/**
	 * Fired when a human is about to take damage (Script Hook).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CTFPlayer // The human taking damage.
	 * attacker: CBaseEntity|null // The entity dealing damage.
	 * inflictor: CBaseEntity|null // The entity inflicting damage (weapon/projectile).
	 * weapon: CBaseEntity|null // The weapon used.
	 * damage_position: Vector // World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * damage: float // The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * base_damage: float // The base damage before modifiers.
	 * damage_type: integer // Damage type bits (e.g. DMG_GENERIC).
	 * hit_group: integer // Hitgroup index (e.g. HITGROUP_HEAD).
	 * damage_custom: integer // Custom damage type stats.
	 * crit_type: integer // Crit type (0=None, 1=Mini, 2=Full).
	 * penetration_count: integer // How many players the damage has penetrated so far.
	 * others_damaged: integer // How many players other than the attacker has the damage been applied to.
	 * ```
	 */
	function OnScriptEvent_PostTakeDamageHuman( _params ) 		{}

	/**
	 * Fired when the world is about to take damage (Script Hook).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CBaseEntity // The world taking damage.
	 * attacker: CBaseEntity|null // The entity dealing damage.
	 * inflictor: CBaseEntity|null // The entity inflicting damage (weapon/projectile).
	 * weapon: CBaseEntity|null // The weapon used.
	 * damage_position: Vector // World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * damage: float // The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * base_damage: float // The base damage before modifiers.
	 * damage_type: integer // Damage type bits (e.g. DMG_GENERIC).
	 * damage_custom: integer // Custom damage type stats.
	 * crit_type: integer // Crit type (0=None, 1=Mini, 2=Full).
	 * penetration_count: integer // How many players the damage has penetrated so far.
	 * others_damaged: integer // How many players other than the attacker has the damage been applied to.
	 * ```
	 */
	function OnScriptEvent_PostTakeDamageWorld( _params ) 		{}
	/**
	 * Fired when any other entity is about to take damage (Script Hook).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * victim: CBaseEntity // The entity taking damage.
	 * attacker: CBaseEntity|null // The entity dealing damage.
	 * inflictor: CBaseEntity|null // The entity inflicting damage (weapon/projectile).
	 * weapon: CBaseEntity|null // The weapon used.
	 * damage_position: Vector // World position of where the damage came from. E.g. end position of a bullet or a rocket.
	 * damage: float // The actual damage amount ( Does not count number of bullets or falloff or rampup )
	 * base_damage: float // The base damage before modifiers.
	 * damage_type: integer // Damage type bits (e.g. DMG_GENERIC).
	 * damage_custom: integer // Custom damage type stats.
	 * crit_type: integer // Crit type (0=None, 1=Mini, 2=Full).
	 * penetration_count: integer // How many players the damage has penetrated so far.
	 * others_damaged: integer // How many players other than the attacker has the damage been applied to.
	 * ```
	 */
	function OnScriptEvent_PostTakeDamage( _params ) 				{}

	/**
	 * Fired when a bot is hurt (after damage calculation).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * victim: CTFBot // The bot who was hurt.
	 * attacker: CBaseEntity|null // The entity who attacked.
	 * damage: integer // Final damage amount applied.
	 * health: integer // Remaining health of the victim.
	 * over_damage: integer // Overkill damage (if dead).
	 * damage_custom: integer // Custom damage type.
	 * bonuseffect: integer // Bonus effect (e.g. BONUS_EFFECT_CRIT).
	 * killed: bool // True if this damage killed the victim.
	 * showdisguisedcrit: bool // True if crit should be shown freely.
	 * allseecrit: bool // True if everyone sees the crit.
	 * ```
	 */
	function OnScriptEvent_PostBotHurt( _params ) 				{}
	/**
	 * Fired when a human is hurt (after damage calculation).
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * victim: CTFPlayer // The human who was hurt.
	 * attacker: CBaseEntity|null // The entity who attacked.
	 * damage: integer // Final damage amount applied.
	 * health: integer // Remaining health of the victim.
	 * over_damage: integer // Overkill damage (if dead).
	 * damage_custom: integer // Custom damage type.
	 * bonuseffect: integer // Bonus effect (e.g. BONUS_EFFECT_CRIT).
	 * killed: bool // True if this damage killed the victim.
	 * showdisguisedcrit: bool // True if crit should be shown freely.
	 * allseecrit: bool // True if everyone sees the crit.
	 * ```
	 */
	function OnScriptEvent_PostHumanHurt( _params ) 				{}

	/**
	 * Fired when a bot spawns for the first time.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFBot // The bot who spawned.
	 * class: integer // The class index of the player.
	 * team: integer // The team index.
	 * ```
	 */
	function OnScriptEvent_BotInitialSpawn( _params ) 			{}
	/**
	 * Fired when a bot spawns.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFBot // The bot who spawned.
	 * class: integer // The class index of the player.
	 * team: integer // The team index.
	 * ```
	 */
	function OnScriptEvent_BotSpawn( _params ) 					{}

	/**
	 * Fired when a human spawns for the first time.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The bot who spawned.
	 * class: integer // The class index of the player.
	 * team: integer // The team index.
	 * ```
	 */
	function OnScriptEvent_HumanInitialSpawn( _params ) 			{}
	/**
	 * Fired when a human spawns.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The bot who spawned.
	 * class: integer // The class index of the player.
	 * team: integer // The team index.
	 * ```
	 */
	function OnScriptEvent_HumanSpawn( _params ) 					{}

	/**
	 * Fired when a bot changes team.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFBot // The bot who changed team.
	 * team: integer // The new team index.
	 * oldteam: integer // The old team index.
	 * disconnect: bool // True if player is disconnecting.
	 * autoteam: bool // True if auto-assigned.
	 * silent: bool // True if silent change.
	 * username: string // Username of the client.
	 * ```
	 */
	function OnScriptEvent_BotTeam( _params ) 					{}
	/**
	 * Fired when a human changes team.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The Human who changed team.
	 * team: integer // The new team index.
	 * oldteam: integer // The old team index.
	 * disconnect: bool // True if player is disconnecting.
	 * autoteam: bool // True if auto-assigned.
	 * silent: bool // True if silent change.
	 * username: string // Username of the client.
	 * ```
	 */
	function OnScriptEvent_HumanTeam( _params ) 					{}

	/**
	 * Fired when a bot speaks. (somehow)
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFBot // The bot who spoke.
	 * message: string // The text message.
	 * teamonly: bool // True if team-only chat.
	 * ```
	 */
	function OnScriptEvent_BotSay( _params ) 						{}
	/**
	 * Fired when a player speaks.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The human who spoke.
	 * message: string // The text message.
	 * teamonly: bool // True if team-only chat.
	 * ```
	 */
	function OnScriptEvent_HumanSay( _params ) 					{}
	/**
	 * Fired when the console speaks.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: null // The entity who spoke (always null, leftover from above).
	 * message: string // The text message.
	 * teamonly: bool // True if team-only chat.
	 * ```
	 */
	function OnScriptEvent_ConsoleSay( _params ) 					{}

	/**
	 * Fired when a building is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The building being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_BuildingHurt( _params ) 				{}

	/**
	 * Fired when a tank is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CTFBaseBoss // The tank being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_TankHurt( _params ) 					{}
	/**
	 * Fired when a base boss is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CTFBaseBoss // The base boss being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_BaseBossHurt( _params ) 				{}

	/**
	 * Fired when HHH is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The HHH entity being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_HHHHurt( _params ) 					{}
	/**
	 * Fired when Monoculus is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The Monoculus entity being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_MonoculusHurt( _params ) 				{}
	/**
	 * Fired when Merasmus is hurt.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The Merasmus entity being hurt.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */	
	function OnScriptEvent_MerasmusHurt( _params ) 				{}

	/**
	 * Fired when a building is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The building being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_BuildingKilled( _params ) 				{}
	
	/**
	 * Fired when a tank is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CTFBaseBoss // The tank being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_TankKilled( _params ) 					{}
	/**
	 * Fired when a base boss is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CTFBaseBoss // The base boss being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_BaseBossKilled( _params ) 				{}
	
	/**
	 * Fired when HHH is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The HHH entity being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_HHHKilled( _params ) 					{}
	/**
	 * Fired when Monoculus is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The Monoculus entity being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_MonoculusKilled( _params ) 			{}
	/**
	 * Fired when Merasmus is killed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * object: CBaseEntity // The Merasmus entity being killed.
	 * attacker: CBaseEntity|null // The attacker entity.
	 * damage: integer // Damage amount.
	 * health: integer // How much health the object is currently at (always <= 0).
	 * over_damage: integer // Amount of damage that exceeded the building's remaining health.
	 * crit: bool // If the attack was a Crit (minicrit or full).
	 * ```
	 */
	function OnScriptEvent_MerasmusKilled( _params ) 				{}

	/**
	 * Fired when a bot is healed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * patient: CTFBot // The bot being healed.
	 * healer: CTFPlayer|CBaseEntity|null // The healer entity (e.g. Medic/Dispenser/Kart).
	 * amount: integer // Heal amount.
	 * ```
	 */
	function OnScriptEvent_BotHealed( _params ) 					{}
	/**
	 * Fired when a human is healed.
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * patient: CTFPlayer // The human being healed.
	 * healer: CTFPlayer|CBaseEntity|null // The healer entity (e.g. Medic/Dispenser/Kart).
	 * amount: integer // Heal amount.
	 * ```
	 */
	function OnScriptEvent_HumanHealed( _params ) 				{}

	/**
	 * Fired when a Dispenser is Created
	 *
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The player that created the Dispenser.
	 * object: CBaseEntity|null // The Dispenser that was Created.
	 * ```
	 */
	function OnScriptEvent_DispenserBuilt( _params )				{}
	/**
	 * Fired when a Teleporter is Created
	 *
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The player that created the Teleporter.
	 * object: CBaseEntity|null // The Teleporter that was Created.
	 * ```
	 */
	function OnScriptEvent_TeleporterBuilt( _params )				{}
	/**
	 * Fired when a Sentry is Created
	 *
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The player that created the Sentry.
	 * object: CBaseEntity|null // The Sentry that was Created.
	 * ```
	 */
	function OnScriptEvent_SentryBuilt( _params )					{}
	/**
	 * Fired when a Sapper is Created
	 *
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The player that created the Sapper.
	 * object: CBaseEntity|null // The Sapper that was Created.
	 * ```
	 */
	function OnScriptEvent_SapperBuilt( _params )					{}

	/** 
	 * Fired when a Player is deflected
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * deflector: CBaseEntity|null // The entity that deflected object.
	 * object: CBaseEntity|null // The player that was deflected.
	 * old_owner: CBaseEntity|null // The owner of object before deflection.
	 * ```
	 */
	function OnScriptEvent_PlayerDeflected( _params ) 			{}
	/** 
	 * Fired when a Rocket is deflected
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * deflector: CBaseEntity|null // The entity that deflected object.
	 * object: CBaseEntity|null // The rocket that was deflected.
	 * old_owner: CBaseEntity|null // The owner of object before deflection.
	 * ```
	 */		
	function OnScriptEvent_RocketDeflected( _params ) 			{}
	/** 
	 * Fired when a Grenade is deflected
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * deflector: CBaseEntity|null // The entity that deflected object.
	 * object: CBaseEntity|null // The grenade that was deflected.
	 * old_owner: CBaseEntity|null // The owner of object before deflection.
	 * ```
	 */
	function OnScriptEvent_GrenadeDeflected( _params ) 			{}
	/** 
	 * Fired when a different Object is deflected
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * deflector: CBaseEntity|null // The entity that deflected object.
	 * object: CBaseEntity|null // The entity that was deflected.
	 * old_owner: CBaseEntity|null // The owner of object before deflection.
	 * ```
	 */
	function OnScriptEvent_ObjectDeflected( _params ) 			{}


	/**
	 * Fired when a chat command is used
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * command: string // The chat commmand that was triggered.
	 * player: CTFPlayer|null // The player that triggered this chat command (null for console).
	 * data: table // Any other data the chat command was passed.
	 * ```
	 */
	function OnScriptEvent_ChatCommand( _params )					{}

	/**
	 * Fired when a player is Stunned
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * stunner: CTFPlayer|null // The Player who stunned the victim.
	 * victim: CTFPlayer|null // The Player who got stunned.
	 * big_stun: bool // Wether the stun was a Big Stun.
	 * victim_capping: bool // If the victim was attempting to cap before getting stunned.
	 * ```
	 */
	function OnScriptEvent_PlayerStunned( _params )				{}

	/**
	 * Fired when a wave fails/completes
	 * . . . literally 0 parameters
	 */
	function OnScriptEvent_WaveFailed( _ )						{}
	function OnScriptEvent_WaveComplete( _ )						{}

	/**
	 * Fired whenever a primary or secondary weapon fires
	 * 
	 * **Note:** Melee attacks need to be fixed
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The Player who shot this weapon.
	 * weapon: CTFWeaponBase // The Weapon the player fired.
	 * ```
	 */
	function OnScriptEvent_PlayerFireWeapon( _params )			{}

	/**
	 * Fired After we Handle our Custom Attributes
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFBot // The bot who spawned.
	 * ```
	 */
	function OnScriptEvent_PostBotSpawn( _params )				{}
	/**
	 * Fired After we Handle our Custom Attributes
	 * 
	 * @param {table} _params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The bot who spawned.
	 * ```
	 */
	function OnScriptEvent_PostHumanSpawn( _params )				{}
}
__CollectGameEventCallbacks(ChaosCustomEvents)

/*
  ====================================
  === END OF CUSTOM EVENT HANDLING ===
  ====================================
*/
/** 
 * @param {CBaseEntity|null} rocket
 */
function ROOT::FixTheFuckingRockets( rocket )
{
	if (rocket && rocket.IsValid())
	{
		rocket.SetMoveType(MOVETYPE_FLY, GetPropInt(rocket, "m_MoveCollide"))
	}
}

/*
  ========================
  === LIBRARY COMMANDS ===
  ========================
*/

AddChatTrigger(["lib_version", "lib_versions"], function( _player, ... ) {
	PrintToChatAllF("\x07D000D0► FatCatLib ◄\x03 Version\x01: \x04%s\x01 - \x03sub_version\x01: \x04%s\x01", FatCatLibVersion.version, FatCatLibVersion.sub_version.tostring())

	foreach (item, value in FatCatLibScriptsVersion)
		PrintToChatAllF("\x07D000D0► FatCatLib ◄\x03 %s\x01: \x04%s\x01", item, value)
})

AddChatTrigger("lib_info", function( _player, ... ) {
	PrintToChatAllF("\x07D000D0► FatCatLib ◄\x03 Version\x01: \x04%s\x01 - \x03sub_version\x01: \x04%s\x01", FatCatLibVersion.version, FatCatLibVersion.sub_version.tostring())
})

AddChatTrigger("Test", function( player, ... ) {
	player.PrintToChat("hi")
})

/*
  ===============================
  === END OF LIBRARY COMMANDS ===
  ===============================
*/

/*
  ==============================
  === LIBRARY ADMIN COMMANDS ===
  ==============================
*/

RegisterAdminTrigger("lib_force", function( _, ... ) {
	if ("FatCatLibForce" in ROOT)
		::FatCatLibForce = !FatCatLibForce
	else
		::FatCatLibForce <- true
	PrintToChatAll("\x07D000D0► FatCatLib ◄\x03 Setting Force include flag to \"\x04"+FatCatLibForce.tostring()+"\x03\"\x01.")
})

RegisterAdminTrigger("noclip", function( player, ... ) {
	if (player.GetMoveType() == MOVETYPE_NOCLIP)
		player.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
	else 
		player.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)
})

RegisterAdminTrigger("disable_errors", function( _, ... ) {
	SetLibrarySettings({
		"ConsoleErrors" : true
		"PublicErrors" : false
	})
})

RegisterAdminTrigger("enable_errors", function( _, ... ) {
	SetLibrarySettings({
		"ConsoleErrors" : false
		"PublicErrors" : true
	})
})

RegisterAdminTrigger(["lib_reload", "reload_library"], function( player, ... ) {
	ReloadLibrary()
	player.PrintToChat("Force Reloaded Library")
})

RegisterAdminTrigger("vcvar", function( player, ... ) {
	if (vargv.len() < 1)
		return player.PrintToChat("Incorrect Arguments (cvar_name, [value]). Only cvar_name is needed to Query.")
	local cvar = vargv[0]

	if (!IsConvarAllowed(cvar))
		return player.PrintToChat(FATCATLIB_PREFIX+" Cvar \""+cvar+"\" is Unknown or not Allowed!")

	// query a value
	if (vargv.len() == 1)
	{
		local ret = GetCvarStr(cvar)
		if (ret == "hunter2")
			ret = "***PROTECTED***"
		return player.PrintToChat(format(FATCATLIB_PREFIX+" Querying Cvar \"%s\": \"%s\"", cvar, ret.tostring()))
	}

	SetCvar(cvar, vargv[1])
	return player.PrintToChat(format(FATCATLIB_PREFIX+" Set Cvar \"%s\": \"%s\"", cvar, vargv[1]))
})

RegisterAdminTrigger("purge", function( _, ... ) {
	if (!("TestPurgeString" in FatCatLibSettings))
		SetLibrarySettings()
	local value = FatCatLibSettings["TestPurgeString"]
	SetLibrarySettings({
		"TestPurgeString" : !value
	})
})

RegisterAdminTrigger("test_tank", function( player, ... ) {
	local targetname = "test_Tank"
	local offset = Vector()
	local IsHelicopter = false

	if (vargv.len() != 0)
	{
		if (vargv[0] == "help")
			return player.PrintToChat("Valid Arguments for \"/test_tank\" : [ tank_name, help ], if name has \"helicopter\" in it, a second param can be used as the height to spawn at")
		targetname = vargv[0]

		local offset_height = 0
		if (targetname.find("helicopter") != null || targetname == "helicopter")
		{
			IsHelicopter = true
			offset_height = 128 // default spawn height of helicopter
		}

		if(vargv.len() != 1)
		{
			try {
				offset_height = vargv[1].tofloat()
			}
			catch(e) {}
		}
		offset = Vector(0, 0, offset_height)
	}

	local SpawnPosition = player.GetEyeTrace().pos+offset

	local path = SpawnEntityFromTable("path_track", {})
	path.SetAbsOrigin(SpawnPosition)

	local tank = SpawnEntityFromTable("tank_boss", {
		targetname = targetname.tolower()
		health = (1<<31) - 1
	})
	tank.SetAbsOrigin(SpawnPosition)
	tank.SetAbsAngles(QAngle(0, player.EyeAngles().Yaw(), 0))

	EntFireNew(path, "Kill", "", FIVE_TICKS)

	local interface = tank.GetLocomotionInterface()
	interface.SetSpeedLimit(0)
	interface.SetDesiredSpeed(0)
	interface.Stop()

	RunWithDelay(4.5, @() tank.SetAbsOrigin(SpawnPosition))
	if (IsHelicopter) RunWithDelay(0.1, @() PostHelicopterSpawn(tank))
	EntFireNew(tank, "SetSpeed", "0", 4.5)
	EntFireNew(tank, "SetSpeed", "0", 0.1)
	return player.PrintToChat("Created A Tank with the targetname of \""+targetname.tolower()+"\"")
})

function PostHelicopterSpawn( self )
{
	local scope = GetScope(self)
	scope.flGravity <- 0
	SetPropFloat(self, "m_speed", 0.0)
}

RegisterAdminTrigger("kill_tank", function( player, ... ) {
	if (vargv.len() != 0)
	{
		if (vargv[0] == "help")
			return player.PrintToChat("Valid Arguments for \"/kill_tank\" : [ *, tank_name, help ], or leave blank to kill targeted Tank")
		else if (vargv[0] == "*")
		{
			local tanks = GetAllEntitiesByClassname("tank_boss")
			foreach (tank in tanks)
			{
				if (!(tank instanceof CTFBaseBoss)) // TankExtensions main thinker uses `tank_boss` classname
					continue
				tank.Kill()
			}
			// EntFireNew("tank_boss", "kill")
			return player.PrintToChat("Killed all Tanks")
		}
		else
		{
			local tank = FindByName(null, vargv[0])
			if (tank)
			{
				tank.Kill()
				return player.PrintToChat("Killed Tank's with name \""+vargv[0]+"\"")
			}
			else
				return player.PrintToChat("Failed to find a tank with that name!")
		}
	}


	local trace = player.GetEyeTrace({
		mask = MASK_OPAQUE_AND_NPCS,
		function filter( entity )
		{
			if (entity.GetClassname() == "tank_boss")
				return TRACE_STOP
			else
				return TRACE_CONTINUE
		}
	})

	DebugDrawLine_vCol(trace.start, trace.pos, Vector(255, 0, 0), false, 100)

	if (trace.hit && trace.enthit && trace.enthit.GetClassname() == "tank_boss")
	{
		trace.enthit.Kill()
		return player.PrintToChat("Killed the Aimed Tank")
	}
	return player.PrintToChat("Failed to Kill Test Tank: Not found or Not a Tank")
})

RegisterAdminTrigger("setspell", function( player, ... ) {
	if (vargv.len() != 2)
		return player.PrintToChat("Incorrect Arguments [spell_index, charges] ")
	local book = player.GetSpellBook()

	if (!book)
		return player.PrintToChat("You dont have a Spell Book Stupid!")

	local index = vargv[0].tointeger()
	local charges = vargv[1].tointeger()

	book.SetSpellIndex(index)
	book.SetSpellCharges(charges)
})

RegisterAdminTrigger("uber", function( player, ... ) {
	if (vargv.len() > 1)
		return player.PrintToChat("Incorrect Arguments [uber] ")
	if (!player.HasWeaponClassname("tf_weapon_medigun") || !player.IsPlayerClass(TF_CLASS_MEDIC))
		return player.PrintToChat("No Medigun Stupid!")

	local uber = vargv.len() == 0 ? 100.0 : vargv[0].tofloat()

	player.GetWeaponClassname("tf_weapon_medigun").SetUberChargePercent(uber)

	return player.PrintToChat("Set your uber to "+uber+"%")
})

RegisterAdminTrigger("bot", function( player, ... ) {
	foreach (bot in GetAllPlayers(TF_TEAM_BLUE, false, false))
	{
		if (GetClientConVar("name", bot.entindex()) == "Johnny Silverhand" && bot.IsAlive())
			return player.PrintToChat("Johnny Silverhand is already Alive!")
	}

	local Giant = (vargv.len() != 0 && vargv[0] == "giant")
	local trace = player.GetEyeTrace()

	local bots = GetAllPlayers(TF_TEAM_SPECTATOR, false, false)
	local rand = bots[RandomInt(0, bots.len()-1)]
	if (rand.IsAlive())
	{
		for (local i = 0; i < 20; i++)
		{
			rand = bots[RandomInt(0, bots.len()-1)]
			if (rand.IsDead())
				break

			Assert(i <= 19, "Failed Finding a suitiable bot for Johhny")
		}
	}

	local bot = rand

	bot.ForceChangeClass(TF_CLASS_HEAVYWEAPONS, true)
	bot.SetTeam(TF_TEAM_BLUE)
	RunWithDelay(THREE_TICKS, @() SpawnJohhny(bot, trace.pos + Vector(0, 0, 16), Giant))
})

function SpawnJohhny( bot, pos, Giant = false )
{
	bot.SetTeam(TF_TEAM_BLUE)
	bot.SetAbsOrigin(pos)

	bot.AddCustomAttribute("damage force reduction", 0, -1)
	bot.AddCustomAttribute("cannot taunt", 1, -1)
	bot.AddCustomAttribute("use robot voice", 1, -1)
	bot.AddCustomAttribute("no_attack", 1, -1)
	bot.AddCustomAttribute("no_jump", 1, -1)
	bot.AddCustomAttribute("move speed penalty", 0.01, -1)
	if (!Giant) bot.AddCustomAttribute("cannot be backstabbed", 1, -1)
	if (Giant) bot.AddCustomAttribute("is miniboss", 1, -1)
	bot.AddCustomAttribute("max health additive bonus", 999700, -1)
	bot.AddCustomAttribute("health regen", 50000, -1)
	bot.AddCustomAttribute("cancel falling damage", 1, -1)
	bot.AddCustomAttribute("airblast vulnerability multiplier", 0.001, -1)
	bot.AddCustomAttribute("airblast vertical vulnerability multiplier", 0.001, -1)
	bot.AddCustomAttribute("cannot pick up intelligence", 1, -1)
	bot.UseRobotModel()
	bot.StripItemSlot(STRIPSLOT_SECONDARY|STRIPSLOT_MELEE)
	bot.SetHealth(1000000)
	bot.SetCond(TF_COND_HALLOWEEN_THRILLER)

	bot.GenerateAndWearItem("Upgradeable TF_WEAPON_MINIGUN")
	bot.GetWeaponInSlotNew(SLOT_PRIMARY).AddAttribute("item style override", 1, 0)
	bot.GenerateAndWearItem("Security Shades")
	bot.GenerateAndWearItem("The Purity Fist")
	bot.GenerateAndWearItem("Unusual Cap")

	RunWithDelay(FIVE_TICKS, @() bot.Weapon_Switch(bot.GetWeaponInSlotNew(SLOT_PRIMARY)))

	SetFakeClientConVarValue(bot, "name", "Johnny Silverhand")

	local Cap = bot.GetWearableByIDX(1173)
	if (Cap)
	{
		Cap.AddAttribute("set item tint rgb", 826111, 0)
		Cap.AddAttribute("attach particle effect", 4, 0)
	}

	local function OnDeath() {
		self.SetTeam(TF_TEAM_SPECTATOR)
	}

	GetScope(bot).OnDeath <- OnDeath
	
	bot.AddBotTag("HardWired")
	bot.AddBotAttribute(IGNORE_ENEMIES)
	bot.AddBotAttribute(IGNORE_FLAG)
}

RegisterAdminTrigger("respawn", function( player, ... ) { player.ForceRegenerateAndRespawn( ) } )
/*
  =====================================
  === END OF LIBRARY ADMIN COMMANDS ===
  =====================================
*/

::Errors <- {}
::Error_Cooldown <- 10

// the admins wowow
::TheFatCat		<- "[U:1:969530867]"
::ShadowBolt 	<- "[U:1:101345257]"
seterrorhandler(function( e )
{
	if (e in Errors)
	{
		if (Errors[e] >= Time())
			return // cooldown

		Errors[e] = Time() + Error_Cooldown
	}
	else
		Errors[e] <- Time() + Error_Cooldown

	local STACK = ["FUNCTION STACK:"]
	local s, l = 2
	while (s = getstackinfos (l++))
	{
		if (startswith(s.func, "__") || s.src == "NATIVE")
			continue
		STACK.append(format("%s line [%d]\n", s.src, s.line))
	}
	local temp_stack = [e]
	local function Chat( m ) 
	{
		if ("Discord_SendError" in ROOT)
			temp_stack.append(m)

		if ("PrintToConsoleAll" in ROOT)
			PrintToConsoleAll(m)
		else
			ClientPrint(null, HUD_PRINTCONSOLE, m)
	}
	if (!("ConsoleErrors" in FatCatLibSettings) || !("PublicErrors" in FatCatLibSettings))
		SetLibrarySettings({}) // Init settings to default
	
	local console = FatCatLibSettings.ConsoleErrors
	local public = FatCatLibSettings.PublicErrors

	ReCalculatePlayers()

	if (IsChaosMvM() && "Discord_SendError" in ROOT)
	{
		console = false
		public = false
		Chat = function( m )
		{
			temp_stack.append(m)
		}
	}

	if (public == true)
	{
		// Possible Locations
		//	Potato:
		//	ChaosMvM:
		//	Github Repository:
		local WhereReport = IsPotato() ? "@The Fatcat in #scripting" : (IsChaosMvM() ? "@The Fatcat in #bug-crash-reports" : "The Fatcat's Github Repository")
		
		PrintToChatAllF("\x07FF0000A VSCRIPT ERROR HAS OCCURRED [%s].", e)
		PrintToChatAllF("\x07FF0000Report to Any Higher Ups or %s with a screenshot of the console.", WhereReport)
		foreach (/**@type {CTFPlayer} */plr in Players) {
			plr.DisplayHudText("A VSCRIPT ERROR HAS OCCURRED\nCHECK CONSOLE", "255 0 0", [-1, 0.3], 10, 0)
			plr.DisplayHudText("A VSCRIPT ERROR HAS OCCURRED\nCHECK CONSOLE", "255 0 0", [-1, 0.3], 10, 1)
			plr.DisplayHudText("A VSCRIPT ERROR HAS OCCURRED\nCHECK CONSOLE", "255 0 0", [-1, 0.3], 10, 2)
			plr.DisplayHudText("A VSCRIPT ERROR HAS OCCURRED\nCHECK CONSOLE", "255 0 0", [-1, 0.3], 10, 3)
		}

		foreach (stackinfo in STACK)
		{
			PrintToChatAll(stackinfo)
		}
	}
	if (console == true)
	{
		PrintToAdmins(3, format("\x07FF0000AN ERROR HAS OCCURRED [%s].\nCheck console for details", e))
	}

	if (!IsChaosMvM())
		Chat("\nCurrent Library Version: "+FatCatLibVersion.version+"\n")
	Chat(format("\n====== TIMESTAMP: %g ======\nAN ERROR HAS OCCURRED [%s]", Time(), e))
	Chat("CALLSTACK")
	local s, l = 2
	while (s = getstackinfos(l++))
		Chat(format("*FUNCTION [%s( )] %s line [%d]", s.func, s.src, s.line ))
	Chat("LOCALS")
	if (s = getstackinfos(2))
	{
		foreach (n, v in s.locals)
		{
			local t = type(v)
			t ==    "null" ? Chat(format("[%s] NULL"  , n))    :
			t == "integer" ? Chat(format("[%s] %d"    , n, v)) :
			t ==   "float" ? Chat(format("[%s] %.14g" , n, v)) :
			t ==  "string" ? Chat(format("[%s] \"%s\"", n, v)) :
			t ==  "vector" ? Chat(format("[%s] vector (%s)" , n, v.ToKVString())) :
							 Chat(format("[%s] %s %s" , n, t, v.tostring()))
		}
	}

	if ("Discord_SendError" in ROOT)
		Discord_SendError(temp_stack)

	return
})
PrintToConsoleAll("Included Library Successfully")

function ROOT::FixShittyPlayersBug()
{
	if (IsTF2C()) // prevent for now
		return
	if (!IsMannVsMachineMode())
		return
	if (GetCurrentWaveNumber() > 1)
		return

	if (m_aHumans.len() != 1)
		return

	foreach (player in m_aHumans)
	{
		player.ForceRegenerateAndRespawn()
	}
}

RunWithDelay(0.25, @() FixShittyPlayersBug())