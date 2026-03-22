::CONST <- getconsttable()
::ROOT <- getroottable()

function SetLibraryVersion(lib_version, subversion = 0, force_include = false)
{
	if(force_include || ("FatCatLibForce" in ROOT))
	{
		printl("Force Included Library")
		::FatCatLibVersion <- {
			version = lib_version
			sub_version = subversion
			forced = true
		}
		return true
	}
	else
	{
		if(!("FatCatLibVersion" in ROOT))
		{
			::FatCatLibVersion <- {
				version = 0
				sub_version = 0
				forced = false
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
					forced = false
				}
				return true
			}
		}
		else
		{
			::FatCatLibVersion <- {
				version = lib_version
				sub_version = subversion
				forced = false
			}
			return true
		}
	}
	return true
}
if (!SetLibraryVersion("1.2.0", 0))
{
	return
}

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
	ROOT["FoldedNetProps"] <- "Folds all NetProps to Not require 'NetProps.', Except IsValid?"
	foreach (name, method in ::NetProps.getclass())
	{
		if (name != "IsValid")
		{
			ROOT[name] <- method.bindenv(::NetProps)
		}
	}
}

////////////// DEFINES ////////////////
//////// Slot indexs
::PRIMARY_SLOT <- 0
::SECONDARY_SLOT <- 1
::MELEE_SLOT <- 2

//////// MASK'S
::MASK_ALL 						<- 4294967295
::MASK_SOLID 					<- 33570827
::MASK_PLAYERSOLID				<- 33636363
::MASK_NPCSOLID					<- 67125259
::MASK_WATER					<- 16432
::MASK_OPAQUE 					<- 16513
::MASK_OPAQUE_AND_NPCS			<- 33570945
::MASK_BLOCKLOS 				<- 16449
::MASK_BLOCKLOS_AND_NPCS		<- 33570881
::MASK_VISIBLE					<- 24705
::MASK_VISIBLE_AND_NPCS			<- 33579137
::MASK_SHOT						<- 1174421507
::MASK_SHOT_HULL				<- 100679691
::MASK_SHOT_PORTAL				<- 33570819
::MASK_SOLID_BRUSHONLY			<- 16395
::MASK_PLAYERSOLID_BRUSHONLY	<- 81931
::MASK_NPCSOLID_BRUSHONLY		<- 33570827
::MASK_NPCWORLDSTATIC			<- 33554443
::MASK_SPLITAREAPORTAL			<- 48
/// CUSTOM SOLID TYPES
::MASK_CUSTOM_PLAYERSOLID		<- 67190795



//////// SNDLVL's
::SNDLVL_NONE		<- 0
::SNDLVL_20dB		<- 20
::SNDLVL_25dB		<- 25
::SNDLVL_30dB		<- 30
::SNDLVL_35dB		<- 35
::SNDLVL_40dB		<- 40
::SNDLVL_45dB		<- 45	
::SNDLVL_50dB		<- 50
::SNDLVL_55dB		<- 55
::SNDLVL_60dB		<- 60
::SNDLVL_IDLE		<- 60
::SNDLVL_65dB		<- 65 
::SNDLVL_STATIC		<- 65	
::SNDLVL_70dB		<- 70
::SNDLVL_75dB		<- 75
::SNDLVL_NORM		<- 75
::SNDLVL_80dB		<- 80
::SNDLVL_TALKING	<- 80
::SNDLVL_85dB		<- 85
::SNDLVL_90dB		<- 90
::SNDLVL_95dB		<- 95
::SNDLVL_100dB		<- 100
::SNDLVL_105dB		<- 105	
::SNDLVL_110dB		<- 110
::SNDLVL_120dB		<- 120
::SNDLVL_130dB		<- 130
::SNDLVL_GUNFIRE	<- 130
::SNDLVL_140dB		<- 140
::SNDLVL_145dB		<- 145
::SNDLVL_150dB		<- 150
::SNDLVL_180dB		<- 180

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

///////// Misc Weapon Index's
::TF_WEAPON_TRIBALMANS_SHIV				<- 171
::TF_WEAPON_VITA_SAW					<- 173
::TF_WEAPON_WARRIOR_SPIRIT 				<- 310
::TF_WEAPON_CANDY_CANE	 				<- 317
::TF_WEAPON_CLAIDHEAMH_MOR 				<- 327
::TF_WEAPON_FIST_OF_STEEL 				<- 331
::TF_WEAPON_TOMISLAV 					<- 424
::TF_WEAPON_SHORT_CIRCUT				<- 528
::TF_WEAPON_UNARMED_COMBAT				<- 572
::TF_WEAPON_WANGA_PRICK 				<- 574
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
::TF_ABILITY_TEST				<- 0

///////// Misc Taunt Index's
::TF_TAUNT_SECOND_RATE_SORCERY  	<- 30816
::TF_TAUNT_CHEERS 			   		<- 31412
::TF_TAUNT_UNLEASHED_RAGE	   		<- 31441


///// MISC
::MAX_CLIENTS <- MaxClients().tointeger() 
// Should be 51 for
// 40 Bots, 8 Players, 2 Spec, 1 SourceTV
::MAX_WEAPONS <- 8
::DEFAULT_GRAVITY <- 1.0
::DEFAULT_SIZE <- 1.0

local Invincible_Conds = [
	TF_COND_PHASE,
	TF_COND_INVULNERABLE,
	TF_COND_INVULNERABLE_WEARINGOFF,
	TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED,
	TF_COND_INVULNERABLE_USER_BUFF,
	TF_COND_INVULNERABLE_CARD_EFFECT
]


///////////////////////////////////////
::CTFPlayer.PrintToHud <- function(message)
{
	if(message != null)
	{
		ClientPrint(this, 4, message.tostring())
	}
	else
	{
		ClientPrint(this, 4, "null")
	}
}

::CTFPlayer.PrintToChat <- function(message)
{
	if(message != null)
	{
		ClientPrint(this, 3, message.tostring())
	}
	else
	{
		ClientPrint(this, 3, "null")
	}
}

::CTFPlayer.IsOnGround <- function()
	return GetPropEntity(this, "m_hGroundEntity") != null

::CTFPlayer.GetUserName <- function()
	return GetPropString(this, "m_szNetname")

::CTFPlayer.GetSteamID <- function()
	return GetPropString(this, "m_szNetworkIDString")

::CTFPlayer.GetHealers <- function()
	return GetPropInt(this, "m_Shared.m_nNumHealers")

::CTFPlayer.GetPrimaryAmmo <- function()
	return GetPropIntArray(this, "m_iAmmo", 1)

::CTFPlayer.GetSecondaryAmmo <- function()
	return GetPropIntArray(this, "m_iAmmo", 2)

::CTFPlayer.SetPrimaryAmmo <- function(ammo)
	return SetPropIntArray(this, "m_iAmmo", ammo, 1)

::CTFPlayer.SetSecondaryAmmo <- function(ammo)
	return SetPropIntArray(this, "m_iAmmo", ammo, 2)

::CTFPlayer.ResetHealth <- function()
	this.SetHealth(this.GetMaxHealth())

::CTFPlayer.SetScale <- function(scale)
	this.SetModelScale(scale, 0)

::CTFPlayer.IsOverhealed <- function()
	return (this.GetHealth() > this.GetMaxHealth())

::CTFPlayer.ForceTaunt <- function(taunt_id)
{
	local weapon = CreateByClassname("tf_weapon_bat")
	local active_weapon = this.GetActiveWeapon()
	this.StopTaunt(true) // both are needed to fully clear the taunt
	this.RemoveCond(7)
	weapon.DispatchSpawn()
	SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taunt_id)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
	EnableStringPurge(weapon)
	SetPropEntity(this, "m_hActiveWeapon", weapon)
	SetPropInt(this, "m_iFOV", 0) // fix sniper rifles
	this.HandleTauntCommand(0)
	SetPropEntity(this, "m_hActiveWeapon", active_weapon)
	weapon.Kill()
}


::CTFPlayer.GetWeaponInSlot <- function(slot = 0)
{
	if( slot == null ) return null

	slot = slot.tointeger()

	if( slot >= 9 || slot <= -1 ) return null

	local entity = GetPropEntityArray(this, "m_hMyWeapons", slot)

	EnableStringPurge(entity)

	return entity
}
::CTFPlayer.GetWeaponInSlotNew <- function(slot = 0)
{
	if( slot == null ) return null

	slot = slot.tointeger()

	if( slot >= 9 || slot <= -1 ) return null

	local MyWeapons = array(MAX_WEAPONS)

	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		local item = GetPropEntityArray(this, "m_hMyWeapons", i)
		if(item == null) 
			continue

		MyWeapons[item.GetSlot()] = item
	}

	// Adds wearables to sorted array
	for (local wearable = this.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
	{
		EnableStringPurge(wearable)
		if (!startswith(wearable.GetClassname(), "tf_wearable")) 
			continue
		switch (GetWeaponIDX(wearable))
		{
			/// Primarys
			case 405:
			case 608:
			{
				MyWeapons[0] = wearable
				continue
			}
			/// Secondarys
			case 57:
			case 131:
			case 133:
			case 231:
			case 406:
			case 444:
			case 642:
			case 1099:
			case 1144:
			{
				MyWeapons[1] = wearable
				continue
			}
		}
	}

	EnableStringPurge(MyWeapons[slot])

	return MyWeapons[slot]
}

::CTFPlayer.GetAllWeapons <- function()
{
	local list = []
	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		list.append(this.GetWeaponInSlotNew(i))
	}
	return list
}
::CTFPlayer.GetAllValidWeapons <- function()
{
	local list = []
	for (local i = 0; i < MAX_WEAPONS; i++)
	{
		list.append(this.GetWeaponInSlotNew(i))
	}
	return list.filter(@(index, value) value != null)
}

::CTFPlayer.GetWeaponIDXInSlot <- function(slot = 0)
	return GetWeaponIDX(this.GetWeaponInSlot(slot))

::CTFPlayer.GetWeaponIDXInSlotNew <- function(slot = 0)
	return GetWeaponIDX(this.GetWeaponInSlotNew(slot))

::CTFPlayer.GetActiveWeaponIDX <- function()
	return GetWeaponIDX(this.GetActiveWeapon())

::CTFPlayer.GetSpellBook <- function()
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weapon = this.GetWeaponInSlot(i)
		if ( !weapon ) continue
		if ( weapon.GetClassname() == "tf_weapon_spellbook" )
		{
			return weapon
		}
	}
}

::CTFPlayer.GetAbilityWeaponIDX <- function()
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weaponIDX = this.GetWeaponIDXInSlot(i)
		if( weaponIDX == null ) continue
		switch (weaponIDX)
		{
			case TF_ABILITY_BASE:
				return TF_ABILITY_BASE

			case TF_ABILITY_TEST:
				return TF_ABILITY_TEST

			case TF_ABILITY_HEAVY_RAGE:
				return TF_ABILITY_HEAVY_RAGE

			case TF_ABILITY_CHEERS:
				return TF_ABILITY_CHEERS

			case TF_ABILITY_KART:
				return TF_ABILITY_KART
		}
	}
	return null
}
::CTFPlayer.GetAbilityWeapon <- function()
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weapon = this.GetWeaponInSlot(i)
		switch (GetWeaponIDX(weapon))
		{
			case TF_ABILITY_BASE:
			case TF_ABILITY_TEST:
			case TF_ABILITY_HEAVY_RAGE:
			case TF_ABILITY_CHEERS:
			case TF_ABILITY_KART:
				return weapon
			case null:
				continue
		}
	}
	return null
}

::CTFPlayer.IsUberDraining <- function()
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weapon = this.GetWeaponInSlot(i)

		if( weapon == null ) continue

		if(weapon.GetClassname() == "tf_weapon_medigun")
			return GetPropBool(weapon, "m_bChargeRelease")
	}
	return false
}

::CTFPlayer.IsPressingButton <- function(button = null)
{
	if( !this.IsValid() || button == null ) return false
	if( GetPropInt(this, "m_nButtons") & button) return true
	return false
}

::CTFPlayer.InRespawnRoom <- function()
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if(respawnroom.GetTeam() != TF_TEAM_PVE_DEFENDERS) continue

		respawnroom.RemoveSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(0)
		local trace =
		{
			start =       this.EyePosition()
			end =         this.EyePosition()
			hullmin =     this.GetPlayerMins()
			hullmax =     this.GetPlayerMaxs()
			mask =        1
		}
		TraceHull(trace)
		respawnroom.AddSolidFlags(FSOLID_NOT_SOLID)
		respawnroom.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS)

		if(trace.hit && trace.enthit == respawnroom) return true
	}
	return false
}

::CTFPlayer.GetEveryHumanWithin <- function(range, include_me = false)
{
	local list = []
	for (local player; player = FindByClassnameWithin(player, "player", this.GetOrigin(), range); )
	{
		if(player == null || player.GetTeam() != this.GetTeam())
		{
			continue
		}
		if(!include_me && player == this)
		{
			continue
		}
		list.append(player)
	}
	return list
}
::CTFPlayer.GetEveryPlayerWithin <- function(range, include_me = false)
{
	local list = []
	for (local player; player = FindByClassnameWithin(player, "player", this.GetOrigin(), range); )
	{
		if(player == null || player.GetTeam() != this.GetTeam())
		{
			continue
		}
		if(!include_me && player == this)
		{
			continue
		}
		list.append(player)
	}
	return list
}
::CTFPlayer.GetEveryTankWithin <- function(range)
{
	local list = []
	for (local tank; tank = FindByClassnameWithin(tank, "tank", this.GetOrigin(), range); )
	{
		if(tank.GetTeam() == TF_TEAM_PVE_INVADERS)
		{
			list.append(tank)
		}
	}
	return list
}
::CTFPlayer.GetEveryBotWithin <- function(range)
{
	local list = []
	for (local bot; bot = FindByClassnameWithin(bot, "player", this.GetOrigin(), range); )
	{
		if(bot != null && IsPlayerABot(bot))
		{
			list.append(bot)
		}
	}
	return list
}
::CTFPlayer.DamageEveryTankWithin <- function(range, damage)
{
	for (local tank; tank = FindByClassnameWithin(tank, "tank", this.GetOrigin(), range); )
	{
		if(tank.GetTeam() == TF_TEAM_PVE_INVADERS)
		{
			tank.TakeDamage(damage, 0, this)
		}
	}
}
::CTFPlayer.DamageEveryBotWithin <- function(range, damage)
{
	for (local bot; bot = FindByClassnameWithin(bot, "player", this.GetOrigin(), range); )
	{
		if(bot != null && IsPlayerABot(bot))
		{
			bot.TakeDamage(damage, 0, this)
		}
	}
}

::CTFPlayer.RemoveStun <- function()
{
	SetPropInt(this, "m_Shared.m_flMovementStunTime", 0)
	SetPropInt(this, "m_Shared.m_iStunFlags", 0)
	SetPropInt(this, "m_Shared.m_hStunner", -1)
	SetPropInt(this, "m_Shared.m_iMovementStunAmount", 0)
	SetPropInt(this, "m_Shared.m_iMovementStunParity", 0)
	this.RemoveCondEx(Constants.ETFCond.TF_COND_STUNNED, true)
}

::CTFPlayer.IsInvincible <- function()
{
	foreach(Condition in Invincible_Conds)
	{
		if(this.InCond(Condition)) return true
	}
	return false
}

::CTFPlayer.IsAdmin <- function()
{
	local SteamID = GetPropString(this, "m_szNetworkIDString")
	if(SteamID == "[U:1:969530867]" || SteamID == "[U:1:101345257]")
	{
		return true
	}
	return false
}

::CTFPlayer.HasWeapon <- function(index)
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weapon = this.GetWeaponInSlot(i)
		if(weapon == null) continue
		if(GetWeaponIDX(weapon) == index) return true
	}
	return false
}
::CTFPlayer.HasWeaponClassname <- function(classname)
{
	for (local i = 0; i <= MAX_WEAPONS; i++)
	{
		local weapon = this.GetWeaponInSlot(i)
		if(weapon == null) continue
		if(weapon.GetClassname() == classname) return true
	}
	return false
}

::CTFPlayer.GetFrontOffset <- function(offset)
{
	return this.GetOrigin() + (this.EyeAngles().Forward() * offset)
}

::CTFPlayer.ResetPrimaryAmmo <- function()
{
	local ammo = 32
	local ammo_mult = 1
	local name = this.GetWeaponInSlotNew(0).GetClassname()
	printl(name.slice(10, name.len))
	switch (split[2])
	{
		case "minigun":
		case "flamethrower":
		{
			ammo = 200
		}
		case "rocketlauncher":
		{
			if(split.len() == 4)
			{
				if(split[3] == "fireball")
				{
					ammo = 40
				}
			}
			else
			{
				ammo = 20
			}
		}
		case "grenadelauncher":
		{
			ammo = 16
		}
	}

	foreach (weapon in this.GetAllValidWeapons())
	{
		if(weapon.GetAttribute("provide on active", 0) == 1)
		{
			if(this.GetActiveWeapon() == weapon)
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
	this.PrintToChat("Set your ammo count to " + (ammo * ammo_mult))
	this.SetPrimaryAmmo((ammo * ammo_mult))
}


/////////
::CTFBot.IsOnGround <- CTFPlayer.IsOnGround
::CTFBot.IsOverhealed <- CTFPlayer.IsOverhealed
::CTFBot.RemoveStun <- CTFPlayer.RemoveStun
::CTFBot.IsInvincible <- CTFPlayer.IsInvincible
::CTFBot.GetWeaponInSlotNew <- CTFPlayer.GetWeaponInSlotNew
::CTFBot.GetAllWeapons <- CTFPlayer.GetAllWeapons
::CTFBot.GetAllValidWeapons <- CTFPlayer.GetAllValidWeapons
::CTFBot.GetHealers <- CTFPlayer.GetHealers

::CTFBaseBoss.SetGlow <- function(bool)
	SetPropBool(this, "m_bGlowEnabled", bool)

// Older functions, that are Deprecated, but for compatability
// with old scripts, they use the newer versions
::GetWeaponInSlot <- function(player = null, slot = 0)
{
	if( !player ) return null
	return player.GetWeaponInSlot(slot)
}
::GetWeaponIndexInSlot <- function(player = null, slot = 0)
{
	if( !player ) return null
	return player.GetWeaponIDXInSlot(slot)
}
::GetActiveWeaponIDX <- function(player)
{
	if( !player ) return null
	return GetWeaponIDX(player.GetActiveWeapon())
}
::GetPlayerSpellBook <- function(player)
{
	if( !player ) return null
	return player.GetSpellBook()
}
::GetAbilityWeaponIndex <- function(player)
{
	if( !player ) return null
	return player.GetAbilityWeaponIDX()
}
::ForceTaunt <- function(player, taunt_id)
{
	if( !player ) return null
	player.ForceTaunt(taunt_id)
}
::IsOnGround <- function(player)
{
	if( !player ) return null
	return player.IsOnGround()
}
::GetPlayerName <- function(player)
{
	if( !player ) return null
	return player.GetUserName()
}
::GetPlayerSteamID <- function(player)
{
	if( !player ) return null
	return GetPropString(player, "m_szNetworkIDString")
}
::IsPlayerPressingButton <- function(player = null, button = null)
{
	if( !player || !button ) return false
	return player.IsPressingButton(button)
}


///////// Printing functions
::PrintToHudAll <- function(message)
	ClientPrint(null, 4, message.tostring())

::PrintToChatAll <- function(message)
	ClientPrint(null, 3, message.tostring())

::PrintToChatAllFilter <- function(message, filter = [])
{
	foreach (player in GetEveryPlayer())
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
			ClientPrint(player, 3, message.tostring())
	}
}
::PrintToHudAllFilter <- function(message, filter = [])
{
	foreach (player in GetEveryPlayer())
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
			ClientPrint(player, 2, message.tostring())
	}
}

::PrintToAdmins <- function(level, message)
{
	foreach (player in GetEveryHuman())
	{
		if(player.IsAdmin())
		{
			ClientPrint(player, level, message)
		}
	}
}

::PrintTable <- function(table, extra_indent = 0)
{
	if( type(table) != "table")
	{
		printl("Trying to PrintTable() an " + type(table))
		return
	}

	foreach (item, value in table)
	{
		if(type(item) == "table")
		{
			PrintTable(item, extra_indent + 1)
		}
		if(item == "__vname" || item == "__vrefs")
			continue
		
		local indents = ""
		for (local i = 0; i < extra_indent; i++) {
			indents += "\t"
		}
		printl(indents + item + " : " + value)
	}
}

::PrintArray <- function(array, extra_indent = 0)
{
	if( type(array) != "array")
	{
		printl("Trying to PrintArray() an " + type(array))
		return
	}

	foreach (item in array)
	{
		if(type(item) == "table")
		{
			PrintTable(item, extra_indent + 1)
		}
		if(item == "__vname" || item == "__vrefs")
			continue
		
		local indents = ""
		for (local i = 0; i < extra_indent; i++) {
			indents += "\t"
		}
		printl(indents + item)
	}
}

::PrintClass <- function(clas, filter = "")
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
::ShowBBOX <- function(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBox(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgba.x, rgba.y, rgba.z, rgba.w, duration)
}

::ShowOBB <- function(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBoxAngles(entity.GetOrigin(), entity.GetBoundingMins(), entity.GetBoundingMaxs(), entity.GetAbsAngles(), Vector(rgba.x, rgba.y, rgba.z), rgba.w, duration)
}

::ShowAABB <- function(entity = null, rgba = Vector4D(255, 0, 0, 5), duration = 1)
{
	if( !entity ) 
		return
	DebugDrawBox(entity.GetOrigin(),entity.GetBoundingMins(), entity.GetBoundingMaxs(), rgba.x, rgba.y, rgba.z, rgba.w, duration)
}

::DebugDrawTrigger <- function(trigger = null, color = Vector4D(255, 128, 0, 1), duration = 5)
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
//// Entity Functions
::EnableStringPurge <- function(entity)
{
	if( !entity )
		return
	SetPropBool(entity, "m_bForcePurgeFixedupStrings", true)
}

/// Credit to LizardOfOz in TF2Maps Discord
::CreateByClassname <- function(classname)
{
	local entity = Entities.CreateByClassname(classname)
	EnableStringPurge(entity)
	return entity
}

::FindByClassname <- function(previous, classname)
{
	local entity = Entities.FindByClassname(previous, classname)
	EnableStringPurge(entity)
	return entity
}

::FindByClassnameWithin <- function(previous, classname, center, radius)
{
	local entity = Entities.FindByClassnameWithin(previous, classname, center, radius)
	EnableStringPurge(entity)
	return entity
}

::FindByClassnameNearest <- function(classname, center,radius)
{
	local entity = Entities.FindByClassnameNearest(classname, center, radius)
	EnableStringPurge(entity)
	return entity
}

::FindByName <- function(previous, name)
{
	local entity = Entities.FindByName(previous, name)
	EnableStringPurge(entity)
	return entity
}

::FindByNameNearest <- function(targetname, center, radius)
{
	local entity = Entities.FindByNameNearest(targetname, center, radius)
	EnableStringPurge(entity)
	return entity
}

::FindByNameWithin <- function(previous, targetname, center, radius)
{
	local entity = Entities.FindByNameWithin(previous, targetname, center, radius)
	EnableStringPurge(entity)
	return entity
}

if (!("SpawnEntityFromTableOriginal" in getroottable()))
   ::SpawnEntityFromTableOriginal <- ::SpawnEntityFromTable
::SpawnEntityFromTable <- function(name, keyvalues)
{
	local entity = SpawnEntityFromTableOriginal(name, keyvalues)
	EnableStringPurge(entity)
	return entity
}

::CountEdicts <- function()
{
	local count = 0
	for (local ent = Entities.First(); ent != null; ent = Entities.Next(ent))
	{
		EnableStringPurge(ent)
		if (!ent.IsEFlagSet(EFL_SERVER_ONLY)) count++
	}
	return count
}

::GetScope <- function(entity)
{
	entity.ValidateScriptScope()
	return entity.GetScriptScope()
}

//// Get Every/All Entitys functions
::GetAllEntitiesByClassname <- function(classname)
{
	local list = []
	for (local entity; entity = FindByClassname(entity, classname); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}
::GetAllEntitiesByClassnameWithin <- function(classname, center, radius)
{
	local list = []
	for (local entity; entity = FindByClassnameWithin(entity, classname, center, radius); )
	{
		if(entity != null) list.append(entity)
	}
	return list
}

::GetEveryPlayer <- function()
{
	local list = []
	foreach (player in GetAllEntitiesByClassname("player"))
	{
		if(player != null) list.append(player)
	}
	return list
}
::GetEveryPlayerWithin <- function(center, radius)
{
	local list = []
	foreach (player in GetAllEntitiesByClassnameWithin("player", center, radius))
	{
		if(player != null) list.append(player)
	}
	return list
}

::GetEveryHuman <- function()
{
	local list = []
	foreach	(player in GetAllEntitiesByClassname("player"))
	{
		if(player != null && !IsPlayerABot(player)) list.append(player)
	}
	return list
}
::GetEveryHumanWithin <- function(center, radius)
{
	local list = []
	foreach (player in GetAllEntitiesByClassnameWithin("player", center, radius))
	{
		if(player != null && !IsPlayerABot(player)) list.append(player)
	}
	return list
}

::GetEveryPlayerOnTeam <- function(team)
{
	local list = []
	foreach (player in GetAllEntitiesByClassname("player"))
	{
		if(player != null && player.GetTeam() == team) list.append(player)
	}
	return list
}
::GetEveryBot <- function()
{
	local list = []
	foreach	(player in GetAllEntitiesByClassname("player"))
	{
		if(player != null && IsPlayerABot(player)) list.append(player)
	}
	return list
}
::GetEveryBotWithin <- function(center, radius)
{
	local list = []
	foreach (player in GetAllEntitiesByClassnameWithin("player", center, radius))
	{
		if(player != null && IsPlayerABot(player)) list.append(player)
	}
	return list
}
::GetEveryTank <- function()
{
	local list = []
	foreach	(tank in GetAllEntitiesByClassname("tank_boss"))
	{
		if(tank != null) list.append(tank)
	}
	return list
}
::GetEveryTankWithin <- function(center, radius)
{
	local list = []
	foreach (tank in GetAllEntitiesByClassnameWithin("tank_boss", center, radius))
	{
		if(tank != null) list.append(tank)
	}
	return list
}

::gamerules <- FindByClassname(null, "tf_gamerules")
::resource <- FindByClassname(null, "tf_objective_resource")
::worldspawn <- FindByClassname(null, "worldspawn")

::GetCurrentWaveNumber <- function()
{
	return GetPropInt(resource, "m_nMannVsMachineWaveCount")
}
::GetMaximumWaveNumber <- function()
{
	return GetPropInt(resource, "m_nMannVsMachineMaxWaveCount")
}

//// Helps make code look nice
::IsNotInScope <- function(item, scope)
{
	return (!(item in scope))
}
::IsNotInTable <- function(item, table)
{
	return (!(item in table))
}


//// Misc player/entity Functions
::IsPointInRespawnRoom <- function(point)
{
	foreach (respawnroom in GetAllEntitiesByClassname("func_respawnroom"))
	{
		if(respawnroom.GetTeam() != TF_TEAM_PVE_DEFENDERS) continue

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
::IsHullInRespawnRoom <- function(start, min, max)
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

::IsValidEnemy <- function(entity)
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

::CreatePickup <- function(table = {
	origin = Vector(), 
	angles = Vector(), 
	team = TF_TEAM_ANY, 
	model = "models/weapons/c_models/c_toolbox/c_toolbox.mdl",
	sound = "player/souls_receive2.wav",
	func = function() {PrintToChatAll("Default Pickup Message")}
	})
{
	PrintTable(table)
	if ( type(table) != "table" )
		return null

	PrecacheModel(table.model)
	PrecacheSound(table.sound)
	
	local pickup = SpawnEntityFromTable("item_armor", {
		origin = table.origin
		angles = table.angles
		teamnum = table.team
		spawnflags = (1 << 30)
	})

	pickup.SetModel(table.model)
	pickup.SetSolid(SOLID_BBOX)
	pickup.SetMoveType(MOVETYPE_FLYGRAVITY, 0)
	// EnableStringPurge(pickup)

	GetScope(pickup).OnPlayerTouch <- table.func
	pickup.ConnectOutput( "OnPlayerTouch", "OnPlayerTouch" )

	return pickup
}

::WeaponHasAttribute <- function(weapon, attribute, default_value)
{
	return weapon.GetAttribute(attribute, default_value) == default_value
}

::GetWeaponIDX <- function(weapon = null)
{
	if( !weapon ) return null
	if(!HasProp(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")) return null
	return GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
}

::SetSpellIndex <- function(spell_book, index)
{
	if( !spell_book ) return
	if(!HasProp(spell_book, "m_iSelectedSpellIndex")) return
	SetPropInt(spell_book, "m_iSelectedSpellIndex", index)
}

::GetSpellIndex <- function(spell_book)
{
	if( !spell_book ) return -2
	if(!HasProp(spell_book, "m_iSelectedSpellIndex")) return -2
	return GetPropInt(spell_book, "m_iSelectedSpellIndex")
}

::GetSpellCharges <- function(spell_book)
{
	if( !spell_book ) return 0
	if(!HasProp(spell_book, "m_iSpellCharges")) return 0
	return GetPropInt(spell_book, "m_iSpellCharges")
}

::IncrementSpellCharge <- function(spell_book, num)
{
	if( !spell_book ) return
	if(!HasProp(spell_book, "m_iSpellCharges")) return
	SetPropInt(spell_book, "m_iSpellCharges", GetPropInt(spell_book, "m_iSpellCharges") + num)
}

::IsHolstered <- function(weapon)
{
	if(!HasProp(weapon, "m_bHolstered")) return false
	return GetPropBool(weapon, "m_bHolstered")
}

::GetBuilder <- function(entity)
{
	EnableStringPurge(entity)
	if(!HasProp(entity, "m_hBuilder")) return null

	local entity = GetPropEntity(entity, "m_hBuilder")
	EnableStringPurge(entity)
	return entity
}

::GetLauncher <- function(entity)
{
	EnableStringPurge(entity)
	if(!HasProp(entity, "m_hLauncher")) return null

	local entity = GetPropEntity(entity, "m_hLauncher")
	EnableStringPurge(entity)

	return entity
}

::GetFlagStatus <- function(flag)
{
	if(!flag) return null
	SetPropBool(flag, "m_bForcePurgeFixedupStrings", true)
	if(!HasProp(flag, "m_nFlagStatus")) return null
	return GetPropInt(flag, "m_nFlagStatus")
}

//// Developer?

::SetCvar <- function(convar, value, admin_notify = false, notify_all = false)
{
	if(!Convars.IsConVarOnAllowList(convar))
	{
		PrintToAdmins(3, "\x07FF0000fatcat_library::SetCvar: \x01Warning Cvar \x03" + convar + "\x01 is Not on the Allowlist!")
		PrintToAdmins(2, "fatcat_library::SetCvar: Warning Cvar \"" + convar + "\" is Not on the Allowlist!")
		return
	}

	Convars.SetValue(convar, value)
	if( notify_all )
	{
		PrintToChatAll("Server cvar \'" + convar + "\' changed to " + value)
	}
	else if( admin_notify )
	{
		PrintToAdmins(3, "Server cvar \'" + convar + "\' changed to " + value)
	}
}

::CreateTestTank <- function(origin = Vector(0, 0, 0), angles = QAngle(0, 0, 0))
{
	if(FindByName(null, "Test_Tank"))
		FindByName(null, "Test_Tank").Kill()

	local tank = SpawnEntityFromTable("tank_boss", {
		targetname = "Test_Tank"
		health = 2147483646
	})
	tank.SetAbsOrigin(origin)
	tank.SetAbsAngles(angles)
	return tank
}

::IsNotInScope <- function(item, scope)
{
	return (!(item in scope))
}
::IsNotInTable <- function(item, table)
{
	return (!(item in table))
}

//// Math
::MATH <- {
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
}
::min <- function(a, b)
	return (b < a) ? b : a;

::max <- function(a, b)
	return (a < b) ? b : a;

::clamp <- function( val, minVal, maxVal )
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
::remapValue <- function(val, A, B, C, D)
{
	if ( A == B )
		return val >= B ? D : C;
	return C + (D - C) * (val - A) / (B - A);
}
::remapValueClamped <- function(val, A, B, C, D)
{
	if ( A == B )
		return val >= B ? D : C;
	local cVal = (val - A) / (B - A);
	cVal = clamp( cVal, 0.0, 1.0 );

	return C + (D - C) * cVal;
}
////
::CreateAoE <- function(owner, center, radius, maxDmg, minDmg, ignore = [], dmg_Type = DMG_BLAST, sound = "weapons/explode" + RandomInt(1, 3) + ".wav", particle = "ExplosionCore_Wall")
{
	local scope = GetScope(owner)
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(sound)
	local iNum_hit = 0
	foreach ( target in GetEveryPlayer() )
	{
		if(!target.IsAlive())
			continue

		if(target.GetTeam() == owner.GetTeam())
			continue

		local bIgnored = false
		foreach (player in ignore)
		{
			if(target == player)
			{
				bIgnored = true
				break
			}
		}
		if( bIgnored )
			continue

		local delta = target.GetCenter() - center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		local damage = MATH.RemapValue(distance, 0, radius, maxDmg, minDmg)

		target.TakeDamageCustom(owner, owner, null, Vector(0, 0, 0), Vector(0, 0, 0) , damage, dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		iNum_hit++

	}
	if( iNum_hit != 0 )
	{
		DebugDrawCircle(ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, radius, false, 15)
		DispatchParticleEffect(particle, center, QAngle(-90, 0, 0).Forward())
		if(scope.LastExplosionTime <= Time())
		{
			EmitSoundEx({
				sound_name = sound
				entity = ignore[0]
			})
			scope.LastExplosionTime <- Time() + 0.5
		}
	}
}
::CreateAoETable <- function(table = {
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
	local iNum_hit = 0
	foreach ( target in GetEveryPlayer() )
	{
		if(!target.IsAlive())
			continue

		if(target.GetTeam() == table.owner.GetTeam())
			continue

		local bIgnored = false
		foreach (player in table.ignore)
		{
			if(target == player)
			{
				bIgnored = true
				break
			}
		}
		if( bIgnored )
			continue

		local delta = target.GetCenter() - table.center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		local damage = MATH.RemapValue(distance, 0, table.radius, table.maxDmg, table.minDmg)

		target.TakeDamageCustom(table.owner, table.owner, null, Vector(0, 0, 0), Vector(0, 0, 0) , damage, table.dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		iNum_hit++

	}
	if( iNum_hit != 0 )
	{
		DebugDrawCircle(table.ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, table.radius, false, 15)
		DispatchParticleEffect(table.particle, table.center, QAngle(-90, 0, 0).Forward())
		if(scope.LastExplosionTime <= Time())
		{
			EmitSoundEx({
				sound_name = table.sound
				entity = table.ignore[0]
			})
			scope.LastExplosionTime <- Time() + 0.5
		}
	}
}
::CreateKnifeAoE <- function(owner, weapon, center, radius, damage, ignore = [], dmg_Type = DMG_BLAST, sound = "weapons/barret_arm_fizzle.wav", particle = "drg_cow_explosioncore_charged")
{
	local scope = GetScope(owner)
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(sound)
	local iNum_hit = 0
	foreach ( target in GetEveryPlayer() )
	{
		if(!target.IsAlive())
			continue

		if(target.GetTeam() == owner.GetTeam())
			continue

		local bIgnored = false
		foreach (player in ignore)
		{
			if(target == player)
			{
				bIgnored = true
				break
			}
		}
		if( bIgnored )
			continue

		local delta = target.GetCenter() - center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		target.TakeDamageCustom(owner, owner, weapon, Vector(0, 0, 0), Vector(0, 0, 0) , damage, dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		target.StunPlayer(MATH.Clamp(weapon.GetAttribute("explosive sniper shot", 0) - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, owner )
		iNum_hit++
	}
	if( iNum_hit != 0 )
	{
		DebugDrawCircle(ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, radius, false, 15)
		DispatchParticleEffect(particle, center, QAngle(-90, 0, 0).Forward())
		if(scope.LastExplosionTime <= Time())
		{
			EmitSoundEx({
				sound_name = sound
				entity = ignore[0]
			})
			scope.LastExplosionTime <- Time() + 0.5
		}
	}
}
::CreateKnifeAoETable <- function(table = {
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
	if(IsNotInScope("LastExplosionTime", scope))
		scope.LastExplosionTime <- 0

	DebugDrawClear()
	PrecacheSound(sound)
	local iNum_hit = 0
	foreach ( target in GetEveryPlayer() )
	{
		if(!target.IsAlive())
			continue

		if(target.GetTeam() == table.owner.GetTeam())
			continue

		local bIgnored = false
		foreach (player in table.ignore)
		{
			if(target == player)
			{
				bIgnored = true
				break
			}
		}
		if( bIgnored )
			continue

		local delta = target.GetCenter() - table.center
		local distance = delta.Norm()

		if(distance > radius)
			continue

		target.TakeDamageCustom(table.owner, table.owner, table.weapon, Vector(0, 0, 0), Vector(0, 0, 0) , table.damage, table.dmg_Type, TF_DMG_CUSTOM_TRIGGER_HURT)
		target.StunPlayer(MATH.Clamp(table.weapon.GetAttribute("explosive sniper shot", 0) - 1, 0, 2), 0.6, TF_STUN_MOVEMENT, table.owner )
		iNum_hit++
	}
	if( iNum_hit != 0 )
	{
		DebugDrawCircle(table.ignore[0].GetOrigin() + Vector(0, 0, 16), Vector(255, 0, 0), 50, radius, false, 15)
		DispatchParticleEffect(table.particle, table.center, QAngle(-90, 0, 0).Forward())
		if(scope.LastExplosionTime <= Time())
		{
			EmitSoundEx({
				sound_name = table.sound
				entity = table.ignore[0]
			})
			scope.LastExplosionTime <- Time() + 0.5
		}
	}
}
::CreatePickup <- function(table = {
	origin = Vector(), 
	angles = Vector(), 
	team = TF_TEAM_ANY, 
	model = "models/weapons/c_models/c_toolbox/c_toolbox.mdl",
	sound = "player/souls_receive2.wav",
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
		spawnflags = (1 << 30)
	})

	pickup.SetModel(table.model)
	pickup.SetSolid(SOLID_BBOX)
	pickup.SetMoveType(MOVETYPE_FLYGRAVITY, 0)
	// EnableStringPurge(pickup)

	GetScope(pickup).OnPlayerTouch <- table.func
	pickup.ConnectOutput( "OnPlayerTouch", "OnPlayerTouch" )

	return pickup
}

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