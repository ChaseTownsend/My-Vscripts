::CONST <- getconsttable()
::ROOT <- getroottable()

::FATCATLIB_PREFIX 		<- "\x07D000D0► FatCatLib ◄\x01 "
::FATCATLIB_CON_PREFIX 	<- "► FatCatLib ◄ "


// lib_version is the current installment of this version
function SetLibraryVersion(lib_version, subversion = 0, force_include = false, developer = false)
{
	local force = false
	if("FatCatLibForce" in ROOT)
		force = FatCatLibForce

	if((force_include || force) || developer)
	{
		printl("Force Included Library")
		::FatCatLibVersion <- {
			version = lib_version
			sub_version = subversion
			forced = "true"
		}
		if(developer == true)
		{
			FatCatLibVersion.developer <- "true"
			PrintToChatAll(FATCATLIB_PREFIX+"\x04DONT FORGET TO DISABLE DEVELOPER MODE!!!\x01")
		}
		return true
	}
	if(!("FatCatLibVersion" in ROOT))
	{
		::FatCatLibVersion <- {
			version = 0
			sub_version = 0
			forced = "false"
		}
	}
	if(FatCatLibVersion.version == lib_version)
	{
		if(FatCatLibVersion.sub_version == subversion)
		{
			printl("Library Version is the same as old version. Not Including")
			return false
		}
		else if( FatCatLibVersion.sub_version > subversion)
		{
			printl("HMMM, decremeting subversion?????????")
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
	// dont think this can be hit
	return false
}
if(!("FatCatLibScriptsVersion" in ROOT))
	::FatCatLibScriptsVersion <- {}

function ROOT::SetScriptVersion(item, version)
{
	::FatCatLibScriptsVersion[item] <- version
}

function SetLibrarySettings(settings_table = {})
{
	if(!("FatCatLibSettings" in ROOT))
		::FatCatLibSettings <- {KillWatchViewmodels = false, KillSoulPacks = false}

	if(!("KillWatchViewmodels" in FatCatLibSettings))
		FatCatLibSettings.KillWatchViewmodels <- false

	if("KillWatchViewmodels" in settings_table)
	{
		if(FatCatLibSettings.KillWatchViewmodels != settings_table.KillWatchViewmodels)
		{
			FatCatLibSettings.KillWatchViewmodels <- settings_table.KillWatchViewmodels
			ClientPrint(null, 3, FATCATLIB_PREFIX+"Set \x03KillWatchViewmodels\x01 to \"\x05" + settings_table.KillWatchViewmodels + "\x01\"\n")
			printl(FATCATLIB_CON_PREFIX+"Set KillWatchViewmodels to \"" + settings_table.KillWatchViewmodels + "\"")
		}
	}
}

if("FatCatLibVersion" in ROOT && "developer" in FatCatLibVersion && FatCatLibVersion.developer == "true")
{
	if("PrintToChatAll" in ROOT)
		PrintToChatAll(FATCATLIB_PREFIX+"\x04DONT FORGET TO DISABLE DEVELOPER MODE!!!\x01")
	else 
		ClientPrint(null, 3, FATCATLIB_PREFIX+"\x04DONT FORGET TO DISABLE DEVELOPER MODE!!!\x01")
}

if (!SetLibraryVersion("1.6.6", 4))
{
	return
}

SetLibrarySettings({
	// If True removes the unused spy watch viewmodel from every bot on spawn
	// -1 Edict per bot
	KillWatchViewmodels = false
})

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

////////////// DEFINES ////////////////
//////// Slot indexs
::SLOT_PRIMARY   <- 0
::SLOT_SECONDARY <- 1
::SLOT_MELEE     <- 2
::SLOT_UTILITY   <- 3
::SLOT_BUILDING  <- 4
::SLOT_PDA       <- 5
::SLOT_PDA2      <- 6
::SLOT_COUNT     <- 7

//////// MathLib
::DEG2RAD	<- 0.0174532924
::RAD2DEG	<- 57.295779513
::FLT_MIN	<- 1.175494e-38
::FLT_MAX	<- 3.402823466e+38
::INT_MIN	<- -2147483648
::INT_MAX	<- 2147483647

//////// MASK'S
::MASK_ALL						<- (0xFFFFFFFF)
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
::TF_TEAM_ANY 					<- -2
::TF_TEAM_INVALID 				<- -1
::TF_TEAM_UNASSIGNED 			<- 0
::TF_TEAM_SPECTATOR 			<- 1
::TF_TEAM_RED 					<- 2
::TF_TEAM_PVE_DEFENDERS 		<- TF_TEAM_RED
::TF_TEAM_BLUE 					<- 3
::TF_TEAM_PVE_INVADERS 			<- TF_TEAM_BLUE
::TF_TEAM_PVE_INVADERS_GIANTS 	<- 4
::TF_TEAM_COUNT 				<- 4
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

///////// Object Types
::OBJ_DISPENSER 				<- 0
::OBJ_TELEPORTER				<- 1
::OBJ_SENTRY 					<- 2
::OBJ_SAPPER 					<- 3

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
::TF_WEAPON_NEON_ANNIHILATOR			<- 813
::TF_WEAPON_NEON_ANNIHILATOR_GENUINE	<- 834
::TF_WEAPON_AIR_STRIKE	 				<- 1104
::TF_WEAPON_NECRO_SMASHER 				<- 1123

///////// Ability Weapon Index's
::TF_ABILITY_BASE 				<- -1
::TF_ABILITY_HEAVY_RAGE 		<- 43
::TF_ABILITY_CHEERS 			<- 1013
::TF_ABILITY_KART 				<- 1123
// ::TF_ABILITY_TELEPORT 			<- 474
::TF_ABILITYS <- {
	TF_ABILITY_BASE 		= -1
	TF_ABILITY_HEAVY_RAGE	= 43
	TF_ABILITY_CHEERS		= 1013
	TF_ABILITY_KART 		= 1123
	// TF_ABILITY_TELEPORT		= 474
}

///////// Misc Taunt Index's
::TF_TAUNT_SECOND_RATE_SORCERY  	<- 30816
::TF_TAUNT_CHEERS 			   		<- 31412
::TF_TAUNT_UNLEASHED_RAGE	   		<- 31441


///// MISC
::MAX_CLIENTS <- MaxClients().tointeger() 
// Should be 51 for
// 40 Bots, 8 Players, 2 Spec, 1 SourceTV
::TF_CLASS_MAXNORMAL <- 9
::MAX_WEAPONS <- 8
::DEFAULT_GRAVITY <- 1.0
::DEFAULT_SIZE <- 1.0
::DEFAULT_COLOR <- "255 255 255"
::Host <- GetListenServerHost()
::SOMETHINGFUCKEDUP <- -1

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


///////////////////////////////////////
function ROOT::CTFPlayer::PrintToHud(message)
	ClientPrint(this, 4, message == null ? "null" : message.tostring())

function ROOT::CTFPlayer::PrintToChat(message)
	ClientPrint(this, 3, message == null ? "null" : message.tostring())

function ROOT::CTFPlayer::IsOnGround()
	return GetPropEntity(this, "m_hGroundEntity") != null

function ROOT::CTFPlayer::GetUserName()
	return GetPropString(this, "m_szNetname")

function ROOT::CTFPlayer::GetSteamID()
	return GetPropString(this, "m_szNetworkIDString")

function ROOT::CTFPlayer::GetUserID()
	return GetPropIntArray(PlayerManager, "m_iUserID", entindex())

function ROOT::CTFPlayer::GetHealers()
	return GetPropInt(this, "m_Shared.m_nNumHealers")

function ROOT::CTFPlayer::GetAmmoByIndex(index)
	return GetPropIntArray(this, "m_iAmmo", index)

function ROOT::CTFPlayer::GetPrimaryAmmo()
	return GetPropIntArray(this, "m_iAmmo", 1)

function ROOT::CTFPlayer::GetSecondaryAmmo()
	return GetPropIntArray(this, "m_iAmmo", 2)

function ROOT::CTFPlayer::GetMetal()
	return GetPropIntArray(this, "m_iAmmo", 3)

function ROOT::CTFPlayer::IsOverhealed()
	return (GetHealth() > GetMaxHealth())

function ROOT::CTFPlayer::EyeVector()
	return EyeAngles().Forward()

function ROOT::CTFPlayer::GetFrontOffset(offset)
	return GetOrigin() + (EyeVector() * offset)

function ROOT::CTFPlayer::GetEyeOffset(offset)
	return EyePosition() + (EyeVector() * offset)

function ROOT::CTFPlayer::IsPressingButton(button)
	return ( GetPropInt(this, "m_nButtons") & button ) ? true : false

function ROOT::CTFPlayer::GetWeaponInSlot(slot = 0)
	return EnableStringPurge(GetPropEntityArray(this, "m_hMyWeapons", slot))

function ROOT::CTFPlayer::GetWeaponIDXInSlot(slot = 0)
	{ local weapon = GetWeaponInSlotNew(slot) ; return weapon ? weapon.GetIDX() : SOMETHINGFUCKEDUP }

function ROOT::CTFPlayer::GetWeaponIDXInSlotNew(slot = 0)
	{ local weapon = GetWeaponInSlotNew(slot) ; return weapon ? weapon.GetIDX() : SOMETHINGFUCKEDUP }

function ROOT::CTFPlayer::GetActiveWeaponIDX()
	{ local weapon = GetActiveWeapon() ; return weapon ? weapon.GetIDX() : SOMETHINGFUCKEDUP }

function ROOT::CTFPlayer::GetAbilityWeaponIDX()
	{ local weapon = GetAbilityWeapon() ; return weapon ? weapon.GetIDX() : SOMETHINGFUCKEDUP }

function ROOT::CTFPlayer::IsPressingButton(button = 1)
	return ( GetPropInt(this, "m_nButtons") & button ) ? true : false

function ROOT::CTFPlayer::SetAmmoByIndex(index, ammo)
	SetPropIntArray(this, "m_iAmmo", ammo, index)

function ROOT::CTFPlayer::SetPrimaryAmmo(ammo)
	SetPropIntArray(this, "m_iAmmo", ammo, 1)

function ROOT::CTFPlayer::SetSecondaryAmmo(ammo)
	SetPropIntArray(this, "m_iAmmo", ammo, 2)

function ROOT::CTFPlayer::SetMetal(metal)
	SetPropIntArray(this, "m_iAmmo", metal, 3)

function ROOT::CTFPlayer::ResetHealth()
	SetHealth(GetMaxHealth())

function ROOT::CTFPlayer::ResetColor()
	AcceptInput("Color", DEFAULT_COLOR, this, this)

function ROOT::CTFPlayer::SetColor(color = DEFAULT_COLOR)
	AcceptInput("Color", color, this, this)

function ROOT::CTFPlayer::SetScale(scale = DEFAULT_SIZE)
	SetModelScale(scale, 0)
// TODO: Add to Snippets
function ROOT::CTFPlayer::IsDead()
	return !IsAlive()
// TODO: Add to Snippets
function ROOT::CTFPlayer::MultiplyGravity(mult)
	SetGravity(GetGravity() * mult)
// TODO: Add to Snippets
function ROOT::CTFPlayer::RunScriptCode(input, delay = -1, activator = this, caller = this)
	EntFireNew(this, "RunScriptCode", input, delay, activator, caller)
// TODO: Add to Snippets
function ROOT::CTFPlayer::GetGroundEntity()
	return GetPropEntity(this, "m_hGroundEntity")
// TODO: Add to Snippets
function ROOT::CTFPlayer::GetFallingVelocity()
	return GetAbsVelocity().z
// TODO: Add to Snippets
function ROOT::CTFPlayer::TakeUnblockableDamage(damage, attacker = Entities.First(), inflictor = Entities.First(), weapon = Entities.First())
	TakeDamageCustom(inflictor, attacker, weapon, Vector(0, 0, 1), Vector(0, 0, 0), damage, DMG_GENERIC, TF_DMG_CUSTOM_TRIGGER_HURT)
// TODO: Add to Snippets
function ROOT::CTFPlayer::Suicide()
	{ SetHealth(1); TakeUnblockableDamage(INT_MAX) }
// TODO: Add to Snippets
function ROOT::CTFPlayer::SetCond(cond, duration = -1)
	AddCondEx(cond, duration, this)

function ROOT::CTFPlayer::IsUberDraining() {
	foreach (weapon in GetAllWeapons()) { 
		if(HasProp(weapon, "m_bChargeRelease"))
			return GetPropBool(weapon, "m_bChargeRelease")
	}
	return false
}

function ROOT::CTFPlayer::GetAbilityWeapon() {
	foreach (weapon in GetAllWeapons()) { 
		if (TF_ABILITYS.values().find(weapon.GetIDX()) != null)
			return weapon
	}
	return null
}

function ROOT::CTFPlayer::ForceTaunt(taunt_id)
{
	local weapon = CreateByClassname("tf_weapon_bat")
	local active_weapon = GetActiveWeapon()
	StopTaunt(true) // both are needed to fully clear the taunt
	RemoveCond(TF_COND_TAUNTING)
	weapon.DispatchSpawn()
	SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taunt_id)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	EnableStringPurge(weapon)
	SetPropEntity(this, "m_hActiveWeapon", weapon)
	SetPropInt(this, "m_iFOV", 0) // fix sniper rifles
	HandleTauntCommand(0)
	SetPropEntity(this, "m_hActiveWeapon", active_weapon)
	weapon.Kill()
}

function ROOT::CTFPlayer::GetMyWeaponsArray()
{
	local MyWeapons = array(MAX_WEAPONS)
	for(local i = 0; i < MAX_WEAPONS; i++) { MyWeapons[i] = GetWeaponInSlot(i) }
	return MyWeapons
}

function ROOT::CTFPlayer::GetWeaponInSlotNew(slot = 0)
{
	local MyWeapons = array(MAX_WEAPONS)

	// sorts items into their slots
	foreach(weapon in GetMyWeaponsArray())
	{
		if( weapon == null ) continue
		GetPlayerClass() == TF_CLASS_ENGINEER && weapon.GetClassname() == "tf_weapon_spellbook" ? MyWeapons[SLOT_PDA2] = weapon : MyWeapons[weapon.GetSlot()] = weapon
	}

	if(!IsValid() || !this)
		return null

	for (local child = FirstMoveChild(); child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)

		if (!startswith(child.GetClassname(), "tf_wearable"))
			continue

		if(IsInArray(child.GetIDX(), WearableIDXs.Primarys))
		{
			MyWeapons[SLOT_PRIMARY] = child
			continue
		}
		if(IsInArray(child.GetIDX(), WearableIDXs.Secondarys))
		{
			MyWeapons[SLOT_SECONDARY] = child
			continue
		}
	}
	return EnableStringPurge(MyWeapons[slot])
}

function ROOT::CTFPlayer::GetWeaponInSlotNewTEST(slot = 0)
{
	if(!IsValid() || !this)
		return null

	// 1. Check Wearables (Prioritized - logic overwrites standard slots)
	for (local child = FirstMoveChild(); child; child = child.NextMovePeer())
	{
		EnableStringPurge(child)

		if (!startswith(child.GetClassname(), "tf_wearable"))
			continue

		if (slot == SLOT_PRIMARY && IsInArray(child.GetIDX(), WearableIDXs.Primarys))
			return child // EnableStringPurge already called above
		
		if (slot == SLOT_SECONDARY && IsInArray(child.GetIDX(), WearableIDXs.Secondarys))
			return child
	}

	// 2. Check Standard Weapons
	for(local i = 0; i < MAX_WEAPONS; i++) 
	{ 
		local weapon = GetWeaponInSlot(i)
		if( weapon == null ) continue

		// Determine the *actual* slot this weapon occupies
		local weaponSlot = weapon.GetSlot()
		
		// Handle Engineer Spellbook Exception
		if (GetPlayerClass() == TF_CLASS_ENGINEER && weapon.GetClassname() == "tf_weapon_spellbook")
			weaponSlot = SLOT_PDA2
		
		if (weaponSlot == slot)
			return EnableStringPurge(weapon)
	}

	return null
}

function ROOT::CTFPlayer::GetAllWeapons()
{
	local list = []
	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		list.append(GetWeaponInSlotNew(i))
	}
	return list.filter(@(index, value) value != null)
}
::CTFPlayer.GetAllValidWeapons <- CTFPlayer.GetAllWeapons
/* function ROOT::CTFPlayer::GetAllValidWeapons()
{
	local list = []
	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		list.append(GetWeaponInSlotNew(i))
	}
	return list.filter(@(index, value) value != null)
} */

function ROOT::CTFPlayer::GetSpellBook()
{
	foreach (weapon in GetAllWeapons())
	{
		if ( weapon.GetClassname() == "tf_weapon_spellbook" )
			return weapon
	}
	return null
}


function ROOT::CTFPlayer::InRespawnRoom(any = false)
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if(!any) { if(respawnroom.GetTeam() != GetTeam()) continue }

		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)
		local trace =
		{
			start =       EyePosition()
			end =         EyePosition()
			hullmin =     GetPlayerMins()
			hullmax =     GetPlayerMaxs()
			mask =        CONTENTS_SOLID
		}
		TraceHull(trace)
		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if(trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}
// TODO: Add to Snippets
function ROOT::CTFPlayer::InAnyRespawnRoom()
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)
		local trace =
		{
			start =       EyePosition()
			end =         EyePosition()
			hullmin =     GetPlayerMins()
			hullmax =     GetPlayerMaxs()
			mask =        CONTENTS_SOLID
		}
		TraceHull(trace)
		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if(trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}
// function ROOT::CTFPlayer::GetAllPlayers(team = false, radius = false, alive = true)
	// return GetAllPlayers(team, radius ? [GetOrigin(), radius] : radius, alive)

function ROOT::CTFPlayer::GetEveryHumanWithin(range, include_me = false)
	return include_me ? GetAllPlayers(TF_TEAM_PVE_DEFENDERS, range ? [GetOrigin(), range] : range, false) : GetAllPlayers(TF_TEAM_PVE_DEFENDERS, [GetOrigin(), range], false).filter(@(index, value) value != this)

function ROOT::CTFPlayer::GetEveryPlayerWithin(range, include_me = false)
	return include_me ? GetAllPlayers(false, range ? [GetOrigin(), range] : range, false) : GetAllPlayers(false, range ? [GetOrigin(), range] : range, false).filter(@(index, value) value != this)

function ROOT::CTFPlayer::GetEveryTankWithin(range)
{
	local list = []
	for (local tank; tank = FindByClassnameWithin(tank, "tank", GetOrigin(), range); )
	{
		if(tank.GetTeam() == TF_TEAM_PVE_INVADERS) list.append(tank)
	}
	return list
}
function ROOT::CTFPlayer::GetEveryBotWithin(range)
	return GetAllPlayers(TF_TEAM_PVE_INVADERS, [GetOrigin(), range], false).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, [GetOrigin(), range], false))

function ROOT::CTFPlayer::DamageEveryTankWithin(range, damage)
{
	for (local tank; tank = FindByClassnameWithin(tank, "tank", GetOrigin(), range); )
	{
		if(tank.GetTeam() == TF_TEAM_PVE_INVADERS) tank.TakeDamage(damage, 0, this)
	}
}
function ROOT::CTFPlayer::DamageEveryBotWithin(range, damage)
{
	foreach(bot in GetEveryBotWithin(range))
	{
		bot.TakeDamage(damage, 0, this)
	}
}

function ROOT::CTFPlayer::RemoveStun()
{
	SetPropInt(this, "m_Shared.m_flMovementStunTime", 0)
	SetPropInt(this, "m_Shared.m_iStunFlags", 0)
	SetPropInt(this, "m_Shared.m_hStunner", -1)
	SetPropInt(this, "m_Shared.m_iMovementStunAmount", 0)
	SetPropInt(this, "m_Shared.m_iMovementStunParity", 0)
	RemoveCondEx(TF_COND_STUNNED, true)
}

function ROOT::CTFPlayer::IsInvincible()
{
	foreach(Condition in Invincible_Conds)
	{
		if(InCond(Condition)) return true
	}
	return false
}

function ROOT::CTFPlayer::IsAdmin()
{
	switch (GetPropString(this, "m_szNetworkIDString"))
	{
		case "[U:1:969530867]":
		case "[U:1:101345257]":
			return true
		default:
			return false
	}
	return false
}

function ROOT::CTFPlayer::HasWeapon(index)
{
	foreach(weapon in GetAllWeapons())
		if(weapon.GetIDX() == index) return true
	return false
}
function ROOT::CTFPlayer::HasWeaponClassname(classname)
{
	foreach (weapon in GetAllWeapons())
		if(weapon.GetClassname() == classname) return true
	return false
}
// TODO: Add to Snippets
function ROOT::CTFPlayer::GetWeapon(index)
{
	foreach(weapon in GetAllWeapons())
		if(weapon.GetIDX() == index) return weapon
	return null
}
// TODO: Add to Snippets
function ROOT::CTFPlayer::GetWeaponClassname(classname)
{
	foreach (weapon in GetAllWeapons())
		if(weapon.GetClassname() == classname) return weapon
	return null
}
function ROOT::CTFPlayer::ResetPrimaryAmmo()
	SetPrimaryAmmo(GetMaximumPrimaryAmmo())

function ROOT::CTFPlayer::ResetSecondaryAmmo()
	SetSecondaryAmmo(GetMaximumSecondaryAmmo())

function ROOT::CTFPlayer::ResetMetal()
	SetMetal(GetMaximumMetal())

function ROOT::CTFPlayer::GetMaximumPrimaryAmmo()
{
	local ammo = 32
	local ammo_mult = 1
	local round = false

	local weapon = GetWeaponInSlotNew(SLOT_PRIMARY)
	local orig_name = weapon.GetClassname()
	local name = weapon.GetClassname()
	if(startswith(orig_name, "tf_weapon_"))
		name = orig_name.slice(10)
	
	switch (name)
	{
		case "minigun":
		case "flamethrower":
		{
			ammo = 200
			break
		}
		case "crossbow":
		case "syringegun_medic":
		{
			ammo = 150
			round = true
			break
		}
		case "rocketlauncher_fireball":
		{
			ammo = 40
			break
		}
		case "compound_bow":
		case "sniperrifle":
		case "sniperrifle_decap":
		case "sniperrifle_classic":
		{
			ammo = 25
			break
		}
		case "revolver":
		{
			ammo = 24
			break
		}
		case "rocketlauncher":
		case "rocketlauncher_airstrike":
		case "rocketlauncher_directhit":
		{
			ammo = 20
			break
		}
		case "grenadelauncher":
		{
			ammo = 16
			break
		}
		case "drg_pomson":
		case "particle_cannon":
		case "parachute_primary":
		case "tf_wearable":
		{
			return
		}
	}
	foreach (weapon in GetAllWeapons())
	{
		if(weapon.GetAttribute("provide on active", 0) == 1)
		{
			if(GetActiveWeapon() == weapon)
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
	if(IsCarryingRune() && InCond(TF_COND_RUNE_HASTE))	
		ammo_mult *= 2
	
	return (round == true ? ceil(ammo * ammo_mult) : (ammo * ammo_mult))
}

function ROOT::CTFPlayer::GetMaximumSecondaryAmmo()
{
	local ammo = 32
	local ammo_mult = 1
	local round = false

	local weapon = GetWeaponInSlotNew(SLOT_SECONDARY)
	local orig_name = weapon.GetClassname()
	local name = orig_name
	if(startswith(orig_name, "tf_weapon_"))
		name = orig_name.slice(10)

	switch (name)
	{
		case "pistol":
		{
			ammo = 200
			break
		}
		case "smg":
		case "charged_smg":
		{
			ammo = 75
			break
		}
		case "handgun_scout_secondary":
		case "pistol_scout":
		{
			ammo = 36
			break
		}
		case "pipebomblauncher":
		{
			ammo = 24
			break
		}

		case "tf_wearable":
		case "cleaver":
		case "lunchbox_drink":
		case "jar_milk":
		case "buff_item":
		case "raygun":
		case "jar_gas":
		case "flaregun_revenge":
		case "rocketpack":
		case "tf_wearable_demoshield":
		case "lunchbox":
		case "mechanical_arm":
		case "laser_pointer":
		case "medigun":
		case "tf_wearable_razorback":
		case "jar":
		case "sapper":
		{
			return
		}
	}
	foreach (weapon in GetAllWeapons())
	{
		if(weapon.GetAttribute("provide on active", 0) == 1)
		{
			if(GetActiveWeapon() == weapon)
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
	if(IsCarryingRune() && InCond(TF_COND_RUNE_HASTE))	
		ammo_mult *= 2
	return (round ? ceil(ammo * ammo_mult) : (ammo * ammo_mult))
}

function ROOT::CTFPlayer::GetMaximumMetal()
{
	local metal = 200
	local metal_mult = 1
	foreach (weapon in GetAllWeapons())
	{
		if(weapon.HasAttribute("provide on active", 0) == 1)
		{
			if(GetActiveWeapon() == weapon)
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
	if(IsCarryingRune() && InCond(TF_COND_RUNE_HASTE))	
		metal_mult *= 2
	return metal * metal_mult
}

function ROOT::CTFPlayer::ResetAmmo()
{
	ResetPrimaryAmmo()
	ResetSecondaryAmmo()
	ResetMetal()
}

function ROOT::CTFPlayer::InMultiCond(conds)
{
	foreach(cond in conds)
		if(InCond(cond))
			return true
	
	return false
}

function ROOT::CTFPlayer::ForceChangeClass(index)
{
	SetPropInt(this, "m_Shared.m_iDesiredPlayerClass", index)
	SetPlayerClass(index)
	Regenerate(true)
	// ResetHealth()
}

function ROOT::CTFPlayer::ToggleGlow(bool)
	SetPropBool(this, "m_bGlowEnabled", bool)

// TODO: Add to Snippets
function ROOT::CTFPlayer::GetLanguage()
	return GetClientConVar("cl_language", entindex())
// TODO: Add to Snippets
function ROOT::CTFPlayer::GetTranslatedString(string)
{
	local lang = GetLanguage()
	local translated_string = ""
	//hmm, mising all translations?
	if(!("TRANSLATION_TABLE" in ROOT))
		return " MISSING TRANSLATION TABLE!!!!!"

	// we dont have this language translated yet, or its missing
	// default to english
	if(!(lang in TRANSLATION_TABLE))
	{
		lang = "english"
		PrintToHud("Please contact The Fatcat to assist with adding translations. (Use !translate)")
	}
	
	local translation_table = TRANSLATION_TABLE[lang]

	// so... we dont have this string yet, or is misspelled, idk
	if(!(string in translation_table))
		return format(" \x01MISSING TRANSLATION STRING FOR \x01\"\x03%s\x01\"", string.tostring())
	
	return translation_table[string]
}
// TODO: Add to Snippets
function ROOT::CTFPlayer::IHTranslateToChat(name, description)
	TranslateToChat("IH_TRANSLATE_ITEM", "%T" + name, "%T" + description)

// TODO: Add to Snippets
// only half stolen from Potato's MGE vscript
function ROOT::CTFPlayer::GetTranslatedAndFormattedString(...)
{
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
// TODO: Add to Snippets
function ROOT::CTFPlayer::TranslateToChat(...)
	PrintToChat(GetTranslatedAndFormattedString.acall([this].extend(vargv)))
// TODO: Add to Snippets
function ROOT::CTFPlayer::TranslateToHud(...)
	PrintToHud(GetTranslatedAndFormattedString.acall([this].extend(vargv)))

///

function ROOT::CTFPlayer::ResetCorrosion()
	GetScope(this).Corrosion <- {
		hCorrosionAttacker = null
		hCorrosionWeapon = null
		flCorrosionTime = 0.0
		flCorrosionRemoveTime = 0.0
		flCorrosionDmg = 0.0
		bPermanentCorrosion = false
		flCorrosionTickTime = 0.5
	}

function ROOT::CTFPlayer::GetCorrosion()
{
	if( GetScope(this) && "Corrosion" in GetScope(this))
		return GetScope(this).Corrosion
	else
	{
		ResetCorrosion()
		return GetScope(this).Corrosion
	}
}
function ROOT::CTFPlayer::GetCorrosionWeapon()
	return GetCorrosion().hCorrosionWeapon

function ROOT::CTFPlayer::GetCorrosionAttacker()
	return GetCorrosion().hCorrosionAttacker

function ROOT::CTFPlayer::ClearCorrosion()
{
	GetScope(this).Corrosion <- {
		hCorrosionAttacker = null
		hCorrosionWeapon = null
		flCorrosionTime = 0.0
		flCorrosionRemoveTime = 0.0
		flCorrosionDmg = 0.0
		bPermanentCorrosion = false
		flCorrosionTickTime = 0.5
	}
	ResetColor()
	// EntFireNew(this, "Color", "255 255 255")
}
function ROOT::CTFPlayer::MakeCorrosion(Player, Weapon, lifetime, damage = 5, ticktime = 0.5)
{
	if(IsInvincible())
	{
		ClearSingleCorrosion()
		return
	}

	if(Weapon && Weapon.GetIDX() == TF_WEAPON_BLUTSAUGER)
		EntFireNew(this, "Color", BLUTSAUGER_SETTINGS.CorrosionColor)

	local Corrosion = GetCorrosion()

	local flExpireTime = Time() + lifetime.tofloat() + ticktime

	if(	Corrosion.hCorrosionAttacker && Corrosion.hCorrosionAttacker == Player
		&& Corrosion.hCorrosionWeapon && Corrosion.hCorrosionWeapon == Weapon )
	{
		if(flExpireTime > Corrosion.flCorrosionRemoveTime)
		{
			Corrosion.flCorrosionRemoveTime = flExpireTime
		}
		return
	}

	GetScope(this).Corrosion <- {
		hCorrosionAttacker = Player
		hCorrosionWeapon = Weapon
		flCorrosionTime = Time() + ticktime // skip the first tick
		flCorrosionRemoveTime = flExpireTime
		flCorrosionDmg = damage
		bPermanentCorrosion = lifetime == true ? true : false
		flCorrosionTickTime = ticktime
	}
}

function ROOT::CTFPlayer::GetPlayerClassName()
	switch(GetPlayerClass())
	{
		case TF_CLASS_SCOUT:
			return "TF_CLASS_SCOUT"
		case TF_CLASS_SOLDIER:
			return "TF_CLASS_SOLDIER"
		case TF_CLASS_PYRO:
			return "TF_CLASS_PYRO"
		case TF_CLASS_DEMOMAN:
			return "TF_CLASS_DEMOMAN"
		case TF_CLASS_HEAVYWEAPONS:
			return "TF_CLASS_HEAVYWEAPONS"
		case TF_CLASS_ENGINEER:
			return "TF_CLASS_ENGINEER"
		case TF_CLASS_MEDIC:
			return "TF_CLASS_MEDIC"
		case TF_CLASS_SNIPER:
			return "TF_CLASS_SNIPER"
		case TF_CLASS_SPY:
			return "TF_CLASS_SPY"
	}

::NoFormatToBot <- [
	"PrintToChat"
	"PrintToHud"
	"TranslateToChat"
	"TranslateToHud"
	"GetTranslatedAndFormattedString"
	"GetTranslatedString"
	"GetLanguage"
	"IsAdmin"
	"IHTranslateToChat"
]

// somewhat stolen from ZI
foreach ( key, value in CTFPlayer )
{
    if ( typeof( value ) == "function" )
	{
		if(NoFormatToBot.find(key) != null)
			continue
		CTFBot[ key ] <- value
		// printf("Formatted Function %s to CTFBot\n", key)
	}
}


// TODO: Add to Snippets
/////////
function ROOT::CTFWeaponBase::SetGlow(bool)
	SetPropBool(this, "m_bGlowEnabled", bool)

// TODO: Add to Snippets
/////////
function ROOT::CTFWeaponBase::HasAttribute(attrib, def_val)
	return GetAttribute(attrib, def_val) != def_val

// TODO: Add to Snippets
function ROOT::CTFWeaponBase::GetIDX()
	return GetPropInt(this, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

::CEconEntity.GetIDX <- CTFWeaponBase.GetIDX

// TODO: Add to Snippets
function ROOT::CTFWeaponBase::IsAbilityWeapon()
{
	switch (GetIDX())
	{
		case TF_ABILITY_BASE:
		case TF_ABILITY_HEAVY_RAGE:
		case TF_ABILITY_CHEERS:	
		case TF_ABILITY_KART:
			return true

		default:
			return false
	}
}
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::CalculateAttributes(AttributeName, AttributeChange, StartingValue, MaxValue, MinValue)
{
	local EndingValue = (GetAttribute(AttributeName, StartingValue) + AttributeChange)

	if (EndingValue <= MaxValue || EndingValue >= MinValue ) { AddAttribute(AttributeName, EndingValue, 0) }
	if (EndingValue > MaxValue) { AddAttribute(AttributeName, MaxValue, 0) }
	if (EndingValue < MinValue) { AddAttribute(AttributeName, MinValue, 0) }
}
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::CalculateAttributeChange(mult_val, AttributeName, AttributeChange, StartingValue, MaxValue, MinValue)
{
	local EndingValue = (StartingValue + (AttributeChange * mult_val))

	if (EndingValue <= MaxValue || EndingValue >= MinValue ) { AddAttribute(AttributeName, EndingValue, 0) }
	if (EndingValue > MaxValue) { AddAttribute(AttributeName, MaxValue, 0) }
	if (EndingValue < MinValue) { AddAttribute(AttributeName, MinValue, 0) }
}

// TODO: Add to Snippets
function ROOT::CTFWeaponBase::SetProp(propertyName, value)
	SetPropArray(propertyName, value, 0)
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::SetPropArray(propertyName, value, index)
{
	if(!HasProp(this, propertyName))
	{
		printf("%s does not have property %s\n", GetClassname(), propertyName)
		return
	}
	switch (type(value))
	{
		case "string":
		{ 	SetPropStringArray(this, propertyName, value, index); return 	}
		case "integer":
		{ 	SetPropIntArray(this, propertyName, value, index); return 		}
		case "float":
		{ 	SetPropFloatArray(this, propertyName, value, index); return 	}
		case "instance":
		{ 	SetPropEntityArray(this, propertyName, value, index); return 	}
		case "bool":
		{ 	SetPropBoolArray(this, propertyName, value, index); return 		}
		case "vector":
		{ 	SetPropVectorArray(this, propertyName, value, index); return 	}
		default:
			printl("Hmm found " + type(value) + " for CTFWeaponBase::SetProp/SetPropArray")
	}
}
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::SetSpellIndex(index)
	if(HasProp(this, "m_iSelectedSpellIndex")) { SetPropInt(this, "m_iSelectedSpellIndex", index) }
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::GetSpellIndex()
	// return HasProp(this, "m_iSelectedSpellIndex") ? GetPropInt(this, "m_iSelectedSpellIndex") : null
	if(HasProp(this, "m_iSelectedSpellIndex")) { return GetPropInt(this, "m_iSelectedSpellIndex") } else { return null }
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::GetSpellCharges()
	if(HasProp(this, "m_iSpellCharges")) { return GetPropInt(this, "m_iSpellCharges") } else { return null }
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::SetSpellCharges(charge)
	if(HasProp(this, "m_iSpellCharges")) { SetPropInt(this, "m_iSpellCharges", charge) }
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::IncrementSpellCharge(num)
	if(HasProp(this, "m_iSpellCharges")) SetPropInt(this, "m_iSpellCharges", GetSpellCharges() + num)
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::IsHolstered()
	if(HasProp(this, "m_bHolstered")) { return GetPropInt(this, "m_bHolstered") } else { return null }

// TODO: Add to Snippets
function ROOT::CTFWeaponBase::SetUberChargePercent(level)
	if(HasProp(this, "LocalTFWeaponMedigunData.m_flChargeLevel")) SetPropFloat(this, "LocalTFWeaponMedigunData.m_flChargeLevel", level/100)
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::GetUberChargePercent()
	if(HasProp(this, "LocalTFWeaponMedigunData.m_flChargeLevel")) { return GetPropFloat(this, "LocalTFWeaponMedigunData.m_flChargeLevel") } else {return null}
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::IncreaseUberChargePercent(level)
	if(HasProp(this, "LocalTFWeaponMedigunData.m_flChargeLevel")) SetPropFloat(this, "LocalTFWeaponMedigunData.m_flChargeLevel", GetUberChargePercent() + (level/100))
// TODO: Add to Snippets
function ROOT::CTFWeaponBase::DecreaseUberChargePercent(level)
	if(HasProp(this, "LocalTFWeaponMedigunData.m_flChargeLevel")) SetPropFloat(this, "LocalTFWeaponMedigunData.m_flChargeLevel", GetUberChargePercent() - (level/100))

// TODO: Add to Snippets
function ROOT::CTFWeaponBase::ModifySpells(index, max, compared = 1, mod_compare = 1)
{
	if ((compared % mod_compare) != 0) return

	if (GetSpellCharges() == 0)
	{
		SetSpellIndex(index)
		IncrementSpellCharge(1)
	}
	else if (index == GetSpellIndex() && GetSpellCharges() < max)
		IncrementSpellCharge(1)
}

// Older functions, that are Deprecated, but for compatability
// with old scripts, they use the newer versions
function ROOT::GetWeaponInSlot(player = null, slot = 0)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.GetWeaponInSlot(slot)
}
function ROOT::GetWeaponIndexInSlot(player = null, slot = 0)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.GetWeaponIDXInSlot(slot)
}
function ROOT::GetActiveWeaponIDX(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return GetWeaponIDX(player.GetActiveWeapon())
}
function ROOT::GetPlayerSpellBook(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.GetSpellBook()
}
function ROOT::GetAbilityWeaponIndex(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.GetAbilityWeaponIDX()
}
function ROOT::ForceTaunt(player, taunt_id)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	player.ForceTaunt(taunt_id)
}
function ROOT::IsOnGround(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.IsOnGround()
}
function ROOT::GetPlayerName(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.GetUserName()
}
function ROOT::GetPlayerSteamID(player)
{
	if( !player ) return null
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return GetPropString(player, "m_szNetworkIDString")
}
function ROOT::IsPlayerPressingButton(player = null, button = null)
{
	if( !player || !button ) return false
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return player.IsPressingButton(button)
}

///////// Printing functions
// TODO: Add to Snippets
function ROOT::PrintToHudAll(message)
	ClientPrint(null, 4, message == null ? "null" : message.tostring())
// TODO: Add to Snippets
function ROOT::PrintToChatAll(message)
	ClientPrint(null, 3, message == null ? "null" : message.tostring())

// TODO: Add to Snippets
function ROOT::PrintToChatAllFilter(message, filter = [])
{
	foreach (player in GetAllPlayers())
	{
		local filtered = false
		foreach( plr in filter)
		{
			if ( plr == player)
			{
				filtered = true
				break
			}

		}
		if(filtered)
			continue
		else
			ClientPrint(player, 3,  message == null ? "null" : message.tostring())
	}
}
// TODO: Add to Snippets
function ROOT::PrintToHudAllFilter(message, filter = [])
{
	foreach (player in GetAllPlayers())
	{
		local filtered = false
		foreach( plr in filter)
		{
			if ( plr == player)
			{
				filtered = true
				break
			}

		}
		if(filtered)
			continue
		else
			ClientPrint(player, 2,  message == null ? "null" : message.tostring())
	}
}

function ROOT::PrintToAdmins(level, message)
{
	foreach (player in GetEveryHuman())
	{
		if(player.IsAdmin())
		{
			ClientPrint(player, level, message)
		}
	}
}

// PrintTable will now print nested tables
function ROOT::PrintTable(table, filter = [], extra_indent = 0)
{
	if( type(table) != "table")
	{
		printl("Trying to PrintTable() a " + type(table))
		return
	}

	foreach (item, value in table)
	{
		if(item == "__vname" || item == "__vrefs")
			continue
		
		if (filter.len() > 0 && filter.find(item) != null)
		{
			continue
		}
		
		local indents = ""
		for (local i = 0; i < extra_indent; i++) {
			indents += "\t"
		}
		printl(indents + item + " : " + value)

		if(type(value) == "table")
		{
			PrintTable(value, filter, extra_indent + 1)
		}
		if(type(value) == "array")
		{
			PrintArray(value, filter, extra_indent + 1)
		}
	}
}

function ROOT::PrintArray(array, filter = [], extra_indent = 0)
{
	if( type(array) != "array")
	{
		printl("Trying to PrintArray() a " + type(array))
		return
	}

	foreach (item in array)
	{
		if(item == "__vname" || item == "__vrefs")
			continue

		if (filter.len() > 0 && filter.find(item) != null)
		{
			continue
		}
		
		local indents = ""
		for (local i = 0; i < extra_indent; i++) {
			indents += "\t"
		}
		printl(indents + item)

		if(type(item) == "table")
		{
			PrintTable(item, filter, extra_indent + 1)
		}
		if(type(item) == "array")
		{
			PrintArray(item, filter, extra_indent + 1)
		}
	}
}

function ROOT::PrintClass(clas, filter = "")
{
	if( typeof clas != "class")
	{
		printl("Trying to PrintClass() an " + typeof clas)
		return
	}

	foreach (item, value in clas)
	{
		if(typeof value != filter)
		{
			printl(typeof value + "\t" + item + "\t:\t" + value)
		}
	}
}

//// Entity Debug
function ROOT::ShowBBOX(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBox(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgba.x, rgba.y, rgba.z, rgba.w, duration)
}

function ROOT::ShowOBB(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBoxAngles(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), entity.GetAbsAngles(), Vector(rgba.x, rgba.y, rgba.z), rgba.w, duration)
}

function ROOT::ShowAABB(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBox(entity.GetOrigin(),entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgba.x, rgba.y, rgba.z, rgba.w, duration)
}

function ROOT::DebugDrawTrigger(trigger = null, color = Vector4D(255, 128, 0, 1), duration = 5)
{
	if( !trigger ) return

	local origin = trigger.GetOrigin()
	local mins = GetPropVector(trigger, "m_Collision.m_vecMins")
	local maxs = GetPropVector(trigger, "m_Collision.m_vecMaxs")
	if (trigger.GetSolid() == 2)
		DebugDrawBox(origin, mins, maxs, color.x, color.y, color.z, color.w, duration)
	else if (trigger.GetSolid() == 3)
		DebugDrawBoxAngles(origin, mins, maxs, trigger.GetAbsAngles(), Vector( color.x, color.y, color.z ), color.w, duration)
}

/* function ROOT::PrecacheParticle(table)
{
	table.classname <- "info_particle_system"
	return PrecacheEntityFromTable(table)
} */


function ROOT::IsListenServer()
	return !IsDedicatedServer()
	
//// Entity Functions
function ROOT::EnableStringPurge(entity)
{
	if( !entity )
		return
	SetPropBool(entity, "m_bForcePurgeFixedupStrings", true)
	return entity
}

/// Credit to LizardOfOz in TF2Maps Discord
function ROOT::CreateByClassname(classname)
	return EnableStringPurge(Entities.CreateByClassname(classname))

function ROOT::FindByClassname(previous, classname)
	return EnableStringPurge(Entities.FindByClassname(previous, classname))

function ROOT::FindByClassnameWithin(previous, classname, center, radius)
	return EnableStringPurge(Entities.FindByClassnameWithin(previous, classname, center, radius))

function ROOT::FindByClassnameNearest(classname, center,radius)
	return EnableStringPurge(Entities.FindByClassnameNearest(classname, center, radius))

function ROOT::FindByName(previous, name)
	return EnableStringPurge(Entities.FindByName(previous, name))

function ROOT::FindByNameNearest(targetname, center, radius)
	return EnableStringPurge(Entities.FindByNameNearest(targetname, center, radius))

function ROOT::FindByNameWithin(previous, targetname, center, radius)
	return EnableStringPurge(Entities.FindByNameWithin(previous, targetname, center, radius))

if (!("SpawnEntityFromTableOriginal" in ROOT))
   ::SpawnEntityFromTableOriginal <- ::SpawnEntityFromTable
function ROOT::SpawnEntityFromTable(name, keyvalues)
	return EnableStringPurge(SpawnEntityFromTableOriginal(name, keyvalues))
if (!("_AddThinkToEnt" in ROOT))
	::_AddThinkToEnt <- AddThinkToEnt
function ROOT::AddThinkToEnt(entity, think_func)
{
	PurgeString(think_func)
	PurgeString(entity)
	_AddThinkToEnt(entity, think_func)
	PurgeString(think_func)
	PurgeString(entity)
}
function ROOT::CountEdicts()
{
	local count = 0
	for (local ent = Entities.First(); ent != null; ent = Entities.Next(ent))
	{
		EnableStringPurge(ent)
		if (!ent.IsEFlagSet(EFL_SERVER_ONLY)) count++
	}
	return count
}

function ROOT::GetScope(entity)
{
	if(!entity || !entity.IsValid())
		return null
	entity.ValidateScriptScope()
	return entity.GetScriptScope()
}

//// Get Every/All Entitys functions
function ROOT::GetAllEntitiesByClassname(classname)
{
	local list = []
	for (local entity; entity = FindByClassname(entity, classname); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}
function ROOT::GetAllEntitiesByClassnameWithin(classname, center, radius)
{
	local list = []
	for (local entity; entity = FindByClassnameWithin(entity, classname, center, radius); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}
function ROOT::GetAllEntitiesByTargetname(targtetname)
{
	local list = []
	for (local entity; entity = FindByName(entity, targtetname); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}
function ROOT::GetAllEntitiesByTargetnameWithin(targtetname, center, radius)
{
	local list = []
	for (local entity; entity = FindByNameWithin(entity, targtetname, center, radius); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}
// TODO: Add to Snippets
function ROOT::GetAllPlayers(team = false, radius = false, alive = true)
{
	local players = []
 
	if (radius)
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
// TODO: Add to Snippets
// wrapper functions
function ROOT::GetEveryPlayer()
	return GetAllPlayers(false, false, false)

function ROOT::GetEveryPlayerWithin(center, radius)
	return GetAllPlayers(false, [center, radius], false)

function ROOT::GetPlayersOnTeam(teamnum = TF_TEAM_ANY)
	return GetAllPlayers(teamnum, false, false)

function ROOT::GetEveryHuman()
	return GetAllPlayers(TF_TEAM_PVE_DEFENDERS, false, false)

function ROOT::GetEveryHumanWithin(center, radius)
	return GetAllPlayers(TF_TEAM_PVE_DEFENDERS, [center, radius], false)

function ROOT::GetEveryPlayerOnTeam(team)
	return GetAllPlayers(team, false, false)

function ROOT::GetEveryBot()
	return GetAllPlayers(TF_TEAM_PVE_INVADERS, false, false).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, false, false))

function ROOT::GetEveryBotWithin(center, radius)
	return GetAllPlayers(TF_TEAM_PVE_INVADERS, [center, radius], false).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, [center, radius], false))
//
// TODO: Add to Snippets
function ROOT::GetEveryTank()
{
	local list = []
	foreach	(tank in GetAllEntitiesByClassname("tank_boss"))
	{
		if(tank != null) list.append(tank)
	}
	return list
}
// TODO: Add to Snippets
function ROOT::GetEveryTankWithin(center, radius)
{
	local list = []
	foreach (tank in GetAllEntitiesByClassnameWithin("tank_boss", center, radius))
	{
		if(tank != null) list.append(tank)
	}
	return list
}

::Gamerules 		<- FindByClassname(null, "tf_gamerules")
::PlayerManager 	<- FindByClassname(null, "tf_player_manager")
::ObjResource 			<- FindByClassname(null, "tf_objective_resource")
::Worldspawn 		<- FindByClassname(null, "worldspawn")
// TODO: Add to Snippets
function ROOT::GetCurrentWaveNumber()
	return GetPropInt(ObjResource, "m_nMannVsMachineWaveCount")
// TODO: Add to Snippets
function ROOT::GetMaximumWaveNumber()
	return GetPropInt(ObjResource, "m_nMannVsMachineMaxWaveCount")

// TODO: Add to Snippets
function ROOT::GetPopfileName()
	return GetPropString(ObjResource, "m_iszMvMPopfileName")

// TODO: Add to Snippets
function ROOT::SetPopfileName(name)
	SetPropString(ObjResource, "m_iszMvMPopfileName", name)


//// Helps make code look nice
function ROOT::IsNotInScope(item, scope)
	return (!(item in scope))
function ROOT::IsNotInTable(item, table)
	return (!(item in table))
function ROOT::IsDamageTypeSpell(dmg_type)
	return dmg_type >= 65 && dmg_type <= 75
function ROOT::IsInArray(item, array)
	return array.find(item) != null


//// Misc player/entity Functions
function ROOT::IsPointInRespawnRoom(point)
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

		if(trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}
function ROOT::IsHullInRespawnRoom(start, min, max)
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if(respawnroom.GetTeam() != TF_TEAM_PVE_DEFENDERS) continue

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

		if(trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}
// TODO: Add to Snippets
function ROOT::IsValidEnemy(entity)
{
	if(entity.GetTeam() != TF_TEAM_PVE_INVADERS) return false

	foreach(classname in [ "player", "tank_boss", "obj_dispenser", "obj_sentrygun", "obj_teleporter" ])
	{
		if(entity.GetClassname() == classname)
		{
			return true
		}
	}
	return false
}

//// Other Funcs
function ROOT::GetWeaponIDX(weapon = null)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if( !weapon ) return null
	if(!HasProp(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")) return null
	return GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
}

function ROOT::SetSpellIndex(spell_book, index)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if( !spell_book ) return
	if(!HasProp(spell_book, "m_iSelectedSpellIndex")) return
	SetPropInt(spell_book, "m_iSelectedSpellIndex", index)
}

function ROOT::GetSpellIndex(spell_book)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if( !spell_book ) return -2
	if(!HasProp(spell_book, "m_iSelectedSpellIndex")) return -2
	return GetPropInt(spell_book, "m_iSelectedSpellIndex")
}

function ROOT::GetSpellCharges(spell_book)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if( !spell_book ) return 0
	if(!HasProp(spell_book, "m_iSpellCharges")) return 0
	return GetPropInt(spell_book, "m_iSpellCharges")
}

function ROOT::IncrementSpellCharge(spell_book, num)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if( !spell_book ) return
	if(!HasProp(spell_book, "m_iSpellCharges")) return
	SetPropInt(spell_book, "m_iSpellCharges", GetPropInt(spell_book, "m_iSpellCharges") + num)
}

function ROOT::IsHolstered(weapon)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if(!HasProp(weapon, "m_bHolstered")) return false
	return GetPropBool(weapon, "m_bHolstered")
}
// end deprecated
function ROOT::GetBuilder(entity)
{
	EnableStringPurge(entity)
	if(!HasProp(entity, "m_hBuilder")) return null

	local entity = GetPropEntity(entity, "m_hBuilder")
	return EnableStringPurge(entity)
}

function ROOT::GetLauncher(entity)
{
	EnableStringPurge(entity)
	if(!HasProp(entity, "m_hLauncher")) return null

	local entity = GetPropEntity(entity, "m_hLauncher")
	return EnableStringPurge(entity)
}

function ROOT::GetFlagStatus(flag)
{
	if(!flag) return null
	EnableStringPurge(flag)
	if(!HasProp(flag, "m_nFlagStatus")) return null
	return GetPropInt(flag, "m_nFlagStatus")
}
// TODO: Add to Snippets
function ROOT::GetState(entity)
{
	EnableStringPurge(entity)
	if(!HasProp(entity, "m_iState")) return null
	return GetPropInt(entity, "m_iState")
}
// TODO: Add to Snippets
function ROOT::ClearThinks(entity)
{
	SetPropString(entity, "m_iszScriptThinkFunction", "")
	AddThinkToEnt(entity, null)
}
// TODO: Add to Snippets
function ROOT::IsBuildingValid(building)
{
	if(!building) return null
	EnableStringPurge(building)
	if(!HasProp(building, "m_bServerOverridePlacement")) return null
	return GetPropBool(building, "m_bServerOverridePlacement")
}

//// Developer?

function ROOT::SetCvar(convar, value, admin_notify = false, notify_all = false)
{
	if(!Convars.IsConVarOnAllowList(convar))
	{
		PrintToAdmins(3, "\x07FF0000fatcat_library::SetCvar: \x01Warning Cvar \x03" + convar + "\x01 is Not on the Allowlist!")
		PrintToAdmins(2, "fatcat_library::SetCvar: Warning Cvar \"" + convar + "\" is Not on the Allowlist!")
		return
	}

	Convars.SetValue(convar, value)
	if( notify_all )
		PrintToChatAll("Server cvar \'" + convar + "\' changed to " + value)
	else if( admin_notify )
		PrintToAdmins(3, "Server cvar \'" + convar + "\' changed to " + value)
}

// TODO: Add to Snippets
function ROOT::EntFireNew(target, action, input = "", delay = -1, activator = null, caller = null)
{
	PurgeString(action)
	PurgeString(input)
	if(type(target) == "string")
		EntFire(target, action, input, delay, activator)
	else if(type(target) == "instance")
		EntFireByHandle(target, action, input, delay, activator, caller)
	PurgeString(action)
	PurgeString(input)
}
// TODO: Add to Snippets
function ROOT::CreateKillIcon(icon)
{
	local classicon = SpawnEntityFromTable( "point_template", {
        classname = icon
    })
	// dont know if we want to Create a class icon forever
	// and access it after puting into a global variable
	// ROOT[icon] <- classicon
	PurgeString(icon)
    return classicon;
}
function ROOT::PurgeString(string)
{
    if ( !string || !( 0 in string ) )
        return

    local temp = CreateByClassname( "logic_autosave" )
    SetPropString( temp, "m_iName", string )
    SetPropBool( temp, "m_bForcePurgeFixedupStrings", true )
    temp.Kill()
}

// TODO: Add to Snippets
function ROOT::GetClientConVar(cvar, entindex)
	return Convars.GetClientConvarValue(cvar, entindex)


function ROOT::CreateTestTank(origin = Vector(0, 0, 0), angles = QAngle(0, 0, 0))
{
	if(FindByName(null, "Test_Tank"))
		FindByName(null, "Test_Tank").Kill()

	local tank = SpawnEntityFromTable("tank_boss", {
		targetname = "Test_Tank"
		health = (1<<31) - 1
	})
	tank.SetAbsOrigin(origin)
	tank.SetAbsAngles(angles)
	return tank
}
// TODO: Add to Snippets
function ROOT::DrawTraceHull(trace, starting_color = Vector(255, 0, 0), ending_color = Vector(0, 0, 255))
{
	local max = "hullmax" in trace ? trace.hullmax : Vector(1, -1, 1)
	local min = "hullmin" in trace ? trace.hullmin : Vector(-1, 1, -1)

	DebugDrawBox(trace.start, min, max, starting_color.x, starting_color.y, starting_color.z, 30, 30)
	DebugDrawBox(trace.endpos, min, max, ending_color.x, ending_color.y, ending_color.z, 30, 30)

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
// TODO: Add to Snippets
function ROOT::DeprecatedWarning(info1, info2)
	error(format("FatCatLibrary::%s  :  %s on Line %i is running a Deprecated Version of %s\n", info1.func, info2.src, info2.line, info1.func))

function ROOT::IsEntityAProjectile(entity)
	return startswith(entity.GetClassname(), "tf_projectile")
// TODO: Add to Snippets
if("Assert" in ROOT && !("ASSERT" in ROOT))
	::ASSERT <- Assert
//// Math
::MATH <- {
	function BitWise(a, b)
	{
		return (a & b) == b
	}
	function Min(a, b)
	{
		return (b < a) ? b : a
	}
	function Max(a, b)
	{
		return (a < b) ? b : a
	}
	function Clamp( val, minVal, maxVal )
	{
		if ( maxVal < minVal )
			return maxVal;
		else if( val < minVal )
			return minVal;
		else if( val > maxVal )
			return maxVal;
		else
			return val;
	}
	function RemapVal(val, A, B, C, D)
	{
		if ( A == B )
			return val >= B ? D : C;
		return C + (D - C) * (val - A) / (B - A);
	}
	function RemapValClamped(val, A, B, C, D)
	{
		if ( A == B )
			return val >= B ? D : C;
		local cVal = (val - A) / (B - A);
		cVal = MATH.Clamp( cVal, 0.0, 1.0 );

		return C + (D - C) * cVal;
	}
	function ConvertRadiusToSndLvl(radius)
	{
		return (40 + (20 * log10(radius / 36.0))).tointeger()
	}
	function RandomVec3(min, max, type = "int")
	{
		if(type == "int")
			return Vector(RandomInt(min, max), RandomInt(min, max), RandomInt(min, max))
		if(type == "float")
			return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
	}
}
function ROOT::min(a, b)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return (b < a) ? b : a;
}
function ROOT::max(a, b)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return (a < b) ? b : a;
}

function ROOT::clamp( val, minVal, maxVal )
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if ( maxVal < minVal )
		return maxVal;
	else if( val < minVal )
		return minVal;
	else if( val > maxVal )
		return maxVal;
	else
		return val;
}
function ROOT::remapValue(val, A, B, C, D)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if ( A == B )
		return val >= B ? D : C;
	return C + (D - C) * (val - A) / (B - A);
}
function ROOT::remapValueClamped(val, A, B, C, D)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	if ( A == B )
		return val >= B ? D : C;
	local cVal = (val - A) / (B - A);
	cVal = clamp( cVal, 0.0, 1.0 );

	return C + (D - C) * cVal;
}
function ROOT::ConvertRadiusToSndLvl(radius)
{
	DeprecatedWarning(getstackinfos(1), getstackinfos(2))
	return (40 + (20 * log10(radius / 36.0))).tointeger()
}
////
function ROOT::CreateAoE(owner, center, radius, maxDmg, minDmg, ignore = [], dmg_Type = DMG_BLAST, sound = "weapons/explode1.wav", particle = "ExplosionCore_Wall")
{
	local scope = GetScope(owner)
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(sound)
	foreach ( target in GetAllPlayers().filter(@(i, p) table.ignore.find(p) == null ) )
	{
		if(target.GetTeam() == table.owner.GetTeam())
			continue

		local delta = target.GetCenter() - center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		local damage = MATH.RemapValue(distance, 0, radius, maxDmg, minDmg)

		target.TakeDamageCustom(owner, owner, null, Vector(0, 0, 0), Vector(0, 0, 0) , damage, dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)

	}
	DebugDrawCircle(ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, radius, false, 15)
	DispatchParticleEffect(particle, center, QAngle(-90, 0, 0).Forward())
	if(scope.LastExplosionTime <= Time())
	{
		EmitSoundEx({
			sound_name = sound
			entity = ignore[0]
			sound_level = MATH.ConvertRadiusToSndLvl(radius)
		})
		scope.LastExplosionTime <- Time() + 0.5
	}
}
function ROOT::CreateAoETable(table = {
	owner = null,
	center = Vector(),
	radius = 100,
	maxDmg = 100,
	minDmg = 45,
	ignore = [],
	dmg_Type = DMG_BLAST,
	sound = "weapons/explode1.wav",
	particle = "ExplosionCore_Wall" })
{
	local scope = GetScope(table.owner)
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(table.sound)
	foreach ( target in GetAllPlayers().filter(@(i, p) table.ignore.find(p) == null ) )
	{
		if(target.GetTeam() == table.owner.GetTeam())
			continue

		local delta = target.GetCenter() - table.center
		local distance = delta.Norm()

		if(distance > table.radius)
			continue

		local damage = MATH.RemapVal(distance, 0, table.radius, table.maxDmg, table.minDmg)

		target.TakeDamageCustom(table.owner, table.owner, null, Vector(0, 0, 0), Vector(0, 0, 0) , damage, table.dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)

	}
	DebugDrawCircle(table.center + Vector(0, 0, 16), Vector(255, 0, 0), 50, table.radius, false, 15)
	DispatchParticleEffect(table.particle, table.center, QAngle(-90, 0, 0).Forward())
	if(scope.LastExplosionTime <= Time())
	{
		EmitSoundEx({
			sound_name = table.sound
			entity = table.owner
			origin = table.center
			sound_level = MATH.ConvertRadiusToSndLvl(table.radius)
		})
		scope.LastExplosionTime <- Time() + 0.5
	}
}
function ROOT::CreateKnifeAoE(owner, weapon, center, radius, damage, ignore = [], dmg_Type = DMG_BLAST, sound = "weapons/barret_arm_fizzle.wav", particle = "drg_cow_explosioncore_charged")
{
	local scope = GetScope(owner)
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(sound)
	foreach ( target in (GetAllPlayers(TF_TEAM_PVE_INVADERS, false, true).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, false, true))).filter(@(i, p) table.ignore.find(p) == null ) )
	{
		local delta = target.GetCenter() - center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		target.TakeDamageCustom(owner, owner, weapon, Vector(0, 0, 0), Vector(0, 0, 0) , damage, dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		target.StunPlayer(MATH.Clamp(weapon.GetAttribute("explosive sniper shot", 0) - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, owner )
	}
	DebugDrawCircle(ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, radius, false, 15)
	DispatchParticleEffect(particle, center, QAngle(-90, 0, 0).Forward())
	if(scope.LastExplosionTime <= Time())
	{
		EmitSoundEx({
			sound_name = sound
			entity = ignore[0]
			sound_level = MATH.ConvertRadiusToSndLvl(radius)
		})
		scope.LastExplosionTime <- Time() + 0.5
	}
}
function ROOT::CreateKnifeAoETable(table = {
	owner = null,
	weapon = null
	center = Vector(),
	radius = 100,
	damage = 100
	ignore = [],
	dmg_Type = DMG_BLAST,
	sound = "weapons/barret_arm_fizzle.wav",
	particle = "drg_cow_explosioncore_charged" })
{
	local scope = GetScope(table.owner)
	if(IsNotInScope("LastEHExplosionTime", scope))
		scope.LastEHExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(table.sound)
	foreach ( target in (GetAllPlayers(TF_TEAM_PVE_INVADERS, false, true).extend(GetAllPlayers(TF_TEAM_PVE_INVADERS_GIANTS, false, true))).filter(@(i, p) table.ignore.find(p) == null ) )
	{
		local delta = target.GetCenter() - table.center
		local distance = delta.Norm()

		if(distance > table.radius)
			continue

		target.TakeDamageCustom(table.owner, table.owner, table.weapon, Vector(0, 0, 0), Vector(0, 0, 0) , table.damage, table.dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		target.StunPlayer(MATH.Clamp(table.weapon.GetAttribute("explosive sniper shot", 0) - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, table.owner )
	}
	DebugDrawCircle(table.ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, table.radius, false, 15)
	DispatchParticleEffect(table.particle, table.center, QAngle(-90, 0, 0).Forward())
	if(scope.LastEHExplosionTime <= Time())
	{
		EmitSoundEx({
			sound_name = table.sound
			entity = table.ignore[0]
			sound_level = MATH.ConvertRadiusToSndLvl(table.radius * 20)
		})
		scope.LastEHExplosionTime <- Time() + 0.5
	}
}
function ROOT::CreatePickup(table = {
	origin = Vector(), 
	angles = Vector(), 
	velocity = Vector()
	team = TF_TEAM_ANY, 
	model = "models/weapons/c_models/c_toolbox/c_toolbox.mdl",
	sound = "player/souls_receive2.wav",
	lifetime = 30
	func = function() {PrintToChatAll("Default Pickup Message")}
	})
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
	// EnableStringPurge(pickup)

	GetScope(pickup).life_time <- Time() + table.lifetime
	GetScope(pickup).LifeTime <- function() { if(Time() >= life_time) {self.Kill()} }
	AddThinkToEnt(pickup, "LifeTime")
	GetScope(pickup).OnPlayerTouch <- table.func
	pickup.ConnectOutput( "OnPlayerTouch", "OnPlayerTouch" )

	return pickup
}

::CPROJ_STATE_KILL 		<- -1
::CPROJ_STATE_REJECT 	<- 0
::CPROJ_STATE_MOVE 		<- 1
::CPROJ_STATE_SET 		<- 2

function ROOT::CreateProjectile(proj_info)
{
	if(!("thinkfunc" in proj_info) || !proj_info.thinkfunc)
		return
	if(!("owner" in proj_info) || !proj_info.owner)
		return
	if(!("model" in proj_info) || !proj_info.model || proj_info.model == "")
		return
	
	PrecacheModel(proj_info.model)

	local flForce = "force" in proj_info ? proj_info.force : 500
	local flDistance = "distance" in proj_info ? proj_info.distance : 0
	local hOwner = proj_info.owner
	// local vOwnerVel = hOwner.GetAbsVelocity()

	local vForward = hOwner.EyeVector()
	local vMove = (vForward * flForce) /* + vOwnerVel */

	local vOrigin = hOwner.EyePosition() + (vForward * flDistance)
	local hProj = CreateByClassname("prop_physics_override")

	hProj.SetModel(proj_info.model)
	hProj.SetAbsOrigin(vOrigin)

	hProj.SetCollisionGroup(TFCOLLISION_GROUP_ROCKET_BUT_NOT_WITH_OTHER_ROCKETS)
	// hProj.SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	local hParticle = null
	if("particle" in proj_info)
	{
		hParticle = SpawnEntityFromTable("info_particle_system", {
			effect_name = proj_info.particle
			start_active = 1
			origin = vOrigin
		})
		EntFireNew(hParticle, "SetParent", "!activator", -1, hProj, hProj)
	}
	hProj.DispatchSpawn()
	hProj.SetPhysVelocity(vMove)
	
	local tScope = GetScope(hProj)

	tScope.m_hOwner 		<- hOwner
	tScope.m_iState 		<- CPROJ_STATE_MOVE
	tScope.m_hParticle 		<- hParticle
	// tScope.m_avSize 		<- ["min" in proj_info ? proj_info.min : Vector( -12, -12, -12 ), "max" in proj_info ? proj_info.max : Vector( 12, 12, 12 )]
	tScope.m_flRadius		<- "radius" in proj_info ? proj_info.radius : 50

	// tScope.m_fThinkFunc		<- proj_info.thinkfunc

	tScope.m_flStartTime 	<- Time()
	tScope.m_flKillMeTime 	<- Time() + (("lifetime" in proj_info) ? proj_info.lifetime : 5)

	tScope.m_flThinkDelay 	<- (("delay" in proj_info) ? proj_info.delay : 0.1)

	if(type(proj_info.thinkfunc) == "function")
	{
		tScope.m_fThinkFunc		<- proj_info.thinkfunc
		AddThinkToEnt(hProj, "m_fThinkFunc")
	}
	else if(type(proj_info.thinkfunc) == "string")
	{
		// tScope.m_fThinkFunc		<- proj_info.thinkfunc
		AddThinkToEnt(hProj, proj_info.thinkfunc)
	}
	else
	{
		printl("errm. . . Something fucked up")
	}

	return hProj;
}

function ROOT::TestProjThink()
{
	if(Time() >= m_flKillMeTime || m_iState == CPROJ_STATE_KILL)
	{
		// printf("Killing %s\n", self.tostring())
		self.Destroy()
		if(m_hParticle)
		{
			EntFireNew(m_hParticle, "Stop")
			m_hParticle.Destroy()
		}
		return FLT_MAX;
	}

	if(m_iState == CPROJ_STATE_MOVE)
	{
/* 		local tTrace = {
			start = self.GetOrigin()
			end = self.GetOrigin()
			hullmin = m_avSize[0]
			hullmax = m_avSize[1]
			filter = self
			make = MASK_SHOT_HULL
		}

		DebugDrawBox(self.GetOrigin(), m_avSize[0], m_avSize[1], 0, 255, 0, 0, 5)

		TraceHull(tTrace)


		if(!tTrace.hit || !("enthit" in tTrace))
			return m_flThinkDelay

		if(tTrace.enthit == m_hOwner)
			return m_flThinkDelay */




		// local victim = FindByClassnameWithin(null, "player", self.GetOrigin(), m_flRadius)
		local victim = null
		foreach (player in Players)
		{
			if(player.GetTeam() == m_hOwner.GetTeam())
				continue
			if(player.IsDead())
				continue
			local delta = player.GetCenter() - self.GetOrigin()
			local dist = delta.Norm()
			if(dist <= m_flRadius)
			{
				victim = player
				break
			}
		}

		// DebugDrawText(self.GetOrigin(), victim ? victim.tostring() : "([-1]:NULL)", false, 5)

		if(/* tTrace.enthit == Worldspawn ||  */victim)
		{
			CreateAoETable({
				owner = m_hOwner,
				center = self.GetOrigin(),
				radius = 100,
				maxDmg = 100,
				minDmg = 45,
				ignore = [m_hOwner],
				dmg_Type = DMG_BLAST,
				sound = "weapons/explode1.wav",
				particle = "ExplosionCore_Wall" }
			)
			m_iState = CPROJ_STATE_KILL
		}
	}
	// return m_flThinkDelay
}


if(!("Players" in ROOT))
	::Players <- []

// TODO: Add to Snippets
function ROOT::ReCalculatePlayers()
	::Players <- GetAllPlayers()


::GrabPlayersEvent <- {
	function OnGameEvent_player_team(params) {
		ReCalculatePlayers()
		EntFireNew("BigNet", "RunScriptCode", "ReCalculatePlayers()", 0.1)
	}
	function OnGameEvent_player_spawn(params) {
		ReCalculatePlayers()
		EntFireNew("BigNet", "RunScriptCode", "ReCalculatePlayers()", 0.1)
	}
	function OnGameEvent_player_disconnect(params) {
		ReCalculatePlayers()
		EntFireNew("BigNet", "RunScriptCode", "ReCalculatePlayers()", 0.1)
	}
}
__CollectGameEventCallbacks(GrabPlayersEvent)

::DevFuncCollect <- {
	function OnGameEvent_player_say(params) {
		local player = GetPlayerFromUserID(params.userid)
		if(player != null)
		{
			if(IsPlayerABot(player))
				return
			if(!player.IsAdmin())
				return
		}
		if(params.text == "--PRINT VERSION--" || params.text == "print lib_version" || params.text == "lib_version")
		{
			PrintToChatAll(format("\x07D000D0► FatCatLib ◄\x03 Version\x01: \x04%s\x01 - \x03sub_version\x01: \x04%i\x01, \x03force_included?\x01 = \x04%s\x01", FatCatLibVersion.version, FatCatLibVersion.sub_version, FatCatLibVersion.forced))
			foreach (item, value in FatCatLibScriptsVersion)
			{
				PrintToChatAll(format("\x07D000D0► FatCatLib ◄\x03 %s\x01: \x04%s\x01", item, value))
			}
		}
		if(params.text == "lib_force true" || params.text == "lib_force" || params.text == "--FORCE INCLUDE THIS SHIT--")
		{
			PrintToChatAll("\x07D000D0► FatCatLib ◄\x03 Setting Force include flag to \"\x04true\x03\"\x01.")
			::FatCatLibForce <- true
		}
		if(params.text == "lib_force false" || params.text == "!lib_force" || params.text == "--DONT FORCE THIS SHIT--")
		{
			PrintToChatAll("\x07D000D0► FatCatLib ◄\x03 Setting Force include flag to \"\x04false\x03\"\x01.")
			::FatCatLibForce <- false
		}
	}
}
__CollectGameEventCallbacks(DevFuncCollect)

::TheFatCat <- "[U:1:969530867]"
::ShadowBolt <- "[U:1:101345257]"
seterrorhandler(function(e)
{
	local Chat = @(m) (printl(m), PrintToAdmins(2, m))
	PrintToAdmins(3, format("\x07FF0000AN ERROR HAS OCCURRED [%s].\nCheck console for details", e))

	Chat(format("\n====== TIMESTAMP: %g ======\nAN ERROR HAS OCCURRED [%s]", Time(), e))
	Chat("CALLSTACK")
	local s, l = 2
	while (s = getstackinfos(l++))
		Chat(format("*FUNCTION [%s()] %s line [%d]", s.func, s.src, s.line))
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
							 Chat(format("[%s] %s %s" , n, t, v.tostring()))
		}
	}
	return
})

printl("Included Library Successfully")

// PrintTable(this)