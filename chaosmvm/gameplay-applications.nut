if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("GameplayApplications", "5.5.0")

local _Thinker = CreateThinker("Thinker_GameplayApplications", "GameplayThink", THINKER_PERSIST)

::TOMISLAV_SETTINGS <- {
	TimeBeforeHeatLost = 5.0
	HeatLostPerSecond = 15
	Attributes = [
		//	[	AttributeName, 					AttributeChange, 	StartingValue, 	MaxValue, 	MinValue]
		[	"damage bonus", 					0.008, 				1, 				9, 			1		],
		[	"fire rate bonus", 					-0.00025, 			1, 				1, 			0.75	],
		[	"max health additive bonus", 		1, 					0, 				1000, 		0		],
		[	"maxammo primary increased", 		0.002, 				1, 				3, 			1		],
		[	"restore health on kill", 			0.1, 				0, 				100, 		0		],
		[	"minigun spinup time decreased", 	-0.0005, 			1, 				1, 			0.5		],
		[	"weapon spread bonus",			 	-0.00075, 			1, 				1, 			0.25	],
	]
}
::KART_DMG <- 40000
// ::AddCondIDS <- [
// 	[ TF_WEAPON_CANDY_CANE, 		TF_COND_SWIMMING_NO_EFFECTS	],
// 	[ TF_WEAPON_TRIBALMANS_SHIV, 	TF_COND_SWIMMING_NO_EFFECTS	],
// ]
// ::SpellWeapons <- [
// 	TF_WEAPON_LOLLICHOP, 
// 	TF_WEAPON_SHORT_CIRCUT, 
// 	TF_WEAPON_CLAIDHEAMH_MOR, 
// 	TF_WEAPON_UNARMED_COMBAT,
// 	TF_WEAPON_CONSCIENTIOUS_OBJECTOR,
// 	///
// 	"lollichop",
// 	"short_circuit",
// 	"tf_projectile_mechanicalarmorb",
// 	"claidheamohmor",
// 	"unarmed_combat",
// 	"nonnonviolent_protest",
// ]


::BlutsaugerAttributes <- {
	"damage bonus" : 10
	"dmg taken increased" : 0.1
	"not solid to players" : 1
}
::BlutsaugerSettings <- {
	sound = "mvm/mvm_tele_activate.wav"		// Sound to play when Reprogramming a bot
	sound_radius = 120000 					// how far the sound can be heard, 120000 == sound level 110
	refund = 100.0							// % of uber to restore on invalid target
	duration = 60.0							// Time to explode bot after death
}
// ::EBSettings <- {
// 	base_range = 250
// 	additive_range = 50
// 	base_damage = 3125
// }


if (!("OnCondPostHooks" in FatCatLibSettings))
	SetLibrarySettings()

if (FatCatLibSettings["OnCondPostHooks"] == true)
{
	SetLibrarySettings({"OnCondPostHooks" : false})
	ReloadLibrary()
}

PrecacheSound(BlutsaugerSettings.sound)

AddChatTrigger("ehp", function( player, ... ) { 
	if (!player || vargv.len() > 1)
		return
	if (vargv.len() == 0)
		player.CalculateEHP()
	else if (vargv[0] == "help")
		player.PrintToChat("\x07FFFF00[Effective Hp]: \x03Calculates your Effective Health.\n\x04Just say \x03/ehp\x04 or \x03!ehp\x04 (not case sensitive)")
} )

AddChatTrigger(["shape", "class", "change", "changeclass", "switch", "shapeshift"], function( player, ... ) {
	if (!player)
		return
	if (vargv.len() == 0)
		return player.PrintToChat("\x07FF0000[►] No class specified. Try again.")
	else if (vargv.len() > 1)
		return player.PrintToChat("\x07FF0000[►] Invalid arguments given. Try again.")

	local name = vargv[0].tolower()
	local given_id = TF_CLASS_UNDEFINED
	try {given_id = name.tointeger()}
	catch(e) {}

	local class_index = TF_CLASS_UNDEFINED
	if (given_id != TF_CLASS_UNDEFINED)
	{
		switch (given_id)
		{
		case 1: class_index = TF_CLASS_SCOUT
		break
		case 2: class_index = TF_CLASS_SOLDIER
		break
		case 3: class_index = TF_CLASS_PYRO
		break
		case 4: class_index = TF_CLASS_DEMOMAN
		break
		case 5: class_index = TF_CLASS_HEAVYWEAPONS
		break
		case 6: class_index = TF_CLASS_ENGINEER
		break
		case 7: class_index = TF_CLASS_MEDIC
		break
		case 8: class_index = TF_CLASS_SNIPER
		break
		case 9: class_index = TF_CLASS_SPY
		break
		} //
	}
	else if (startswith(name, "sc"))
		class_index = TF_CLASS_SCOUT
	else if (startswith(name, "so"))
		class_index = TF_CLASS_SOLDIER
	else if (startswith(name, "p"))
		class_index = TF_CLASS_PYRO
	else if (startswith(name, "d"))
		class_index = TF_CLASS_DEMOMAN
	else if (startswith(name, "h"))
		class_index = TF_CLASS_HEAVYWEAPONS
	else if (startswith(name, "e"))
		class_index = TF_CLASS_ENGINEER
	else if (startswith(name, "m"))
		class_index = TF_CLASS_MEDIC
	else if (startswith(name, "sn"))
		class_index = TF_CLASS_SNIPER
	else if (startswith(name, "sp"))
		class_index = TF_CLASS_SPY
	else if (startswith(name, "civ"))
		return player.PrintToChat("\x07FF0000[►] This is not TF2Classified.") // [►] Did you forget what game you're playing...?
	else
		return player.PrintToChat("\x07FF0000[►] Failed to determine desired class. Try again.")

	if (class_index == TF_CLASS_UNDEFINED)
		return player.PrintToChat("\x07FF0000[►] Failed to determine desired class. Try again.")

	if (player.IsDead()/*  && player.GetWeaponIDXInSlotNew(SLOT_MELEE) ==  */)
		return player.PrintToChat("\x07FF4040[►] Can only change class while alive.")

	if (player.InRespawnRoom())
		player.ForceChangeClass(class_index, true)
	else 
	{
		player.ForceChangeClass(class_index)
		player.Suicide()
		player.PrintToChatF("*You will respawn as %s", player.GetPlayerClassName())
	}
} )

::RegisteredItems <- {
}
//[unique id] : {data}

class EquipWeaponData {
	/** 
	 * Unique ID for Itemhelper.
	 * 
	 * @type {integer} 
	*/
	idx = 0

	/**
	 * Internal item name in the Item Schema.
	 * 
	 * Or if using Rafmods `CustomWeapon` block the name of that custom weapon
	 * @type {string} 
	*/
	internal_name = ""

	/** 
	 * Name that players use to create the item.
	 * 
	 * @type {string} 
	 * */
	make_name = ""

	/**
	 * Weather to Automatically switch to this weapon, Use for Wearables. (Default: `true`).
	 * 
	 * Using Rafmods `CustomWeapon` block forces it to `true` for weapons
	 * @type {bool} 
	*/
	force_swap = true

	/**
	 * Any Attribute overrides, Useful for creating Custom Weapons using a Base weapon (Default: `{}`).
	 * 
	 * ### Warning: 
	 * Cannot set string attribute values
	 * 
	 * If you need string attributes Use Rafmods `CustomWeapon`
	 * 
	 * @type {table}
	 */
	overrides = {}

	/** 
	 * Function that is input the player making this item, Return true to allow the creation.
	 * 
	 * @type {function}
	 * @returns {bool}
	 */
	override_func = function( ... ) 
	{
		if ("override_func" in function_overrides && type(function_overrides["override_func"]) == "function")
			return function_overrides["override_func"].acall([this].extend(vargv))	// fuck is this magic
		return true
	}

	/** @type {table} */
	function_overrides = {}

	/** 
	 * If this weapon is going to be created from Rafmods `CustomWeapon` block
	 * 
	 * @type {bool} 
	*/
	is_segsegv = false

	/** 
	 * Will pass in the player when successfully used
	 * 
	 * @type {function} 
	*/
	OnPlayerEquip = function( ... )
	{
		if ("OnPlayerEquip" in function_overrides && type(function_overrides["OnPlayerEquip"]) == "function")
			function_overrides["OnPlayerEquip"].acall([this].extend(vargv))
	}

	constructor(ItemID, InternalName, MakingName, table)
	{
		this.idx = ItemID
		this.internal_name = InternalName
		this.make_name = MakingName
		this.function_overrides = {}

		foreach (key, value in table)
		{
			if (key in this && ["idx", "internal_name", "make_name"].find(key) == null)
			{
				if (key == "override_func" || key == "OnPlayerEquip")
					function_overrides[key] <- value
				else
					this[key] = value
			}
		}
	}
}

/** 
 * @param {integer} idx				Unique ID for Itemhelper.
 * @param {string} internal_name	Internal item name in the Item Schema.
 * @param {string} name_make		Name that players can use to create the item.
 * @param {table} data				look in class `EquipWeaponData` for more information
 */
function ROOT::RegisterEquipItem( idx, internal_name, name_make, data )
{
	if (startswith(name_make, "page "))
		throw "Cannot make items with make names that start with \"page \"!, this is used Internally!"
	if (name_make == "help")
		throw "Cannot make items with make names of \"help\""
	// probably slower 
	// if (DoesItemExist(idx) || DoesItemExist(name_make))
	if (idx in RegisteredItems)
		printf("Warning! Item with idx %d Already exists!  Overriding...", idx)
	foreach (_, data in RegisteredItems)
	{
		if (data.make_name == name_make)
			throw "Cannot make items with the same Name!"
	}
	
	RegisteredItems[idx] <- EquipWeaponData(idx, internal_name, name_make, data)
	// RegisteredItems[idx] <- {
	// 	InternalName = internal_name
	// 	MakingName = name_make.tolower()
	// 	DoSwitch = swit
	// 	AttribOverrides = overrides
	// 	OverrideFunc = override_func
	// }
}

function ROOT::DoesItemExist( finder )
{
	foreach (idx, data in RegisteredItems)
		if (idx == finder.tostring() || data.make_name == finder)
			return true
	return false
}

function ROOT::FindItemBy( name )
{
	foreach (_idx, data in RegisteredItems)
		if (data.make_name == name)
			return true
	return false
}
RegisterEquipItem(1100, "The Bread Bite", "bread", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS
	}
	// is_segsegv = true
})
RegisterEquipItem(1105, "The Self-Aware Beauty Mark", "mark", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_SNIPER
	}
	// is_segsegv = true
})
RegisterEquipItem(1121, "Mutated Milk", "mutated", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_SCOUT
	}
	// is_segsegv = true
})
RegisterEquipItem(30666, "The C.A.P.P.E.R", "capper", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_SCOUT || player.GetPlayerClass() == TF_CLASS_ENGINEER
	}
	OnPlayerEquip = function( player ) {
		player.FixAmmo()
	}
	is_segsegv = true
})

// RegisterEquipItem(1, "My Custom Item", "test", {override_func = function( player ) {return player.GetPlayerClass( ) == 4}, is_segsegv = true} )
// RegisterEquipItem(30666, "The C.A.P.P.E.R", "capper", {})

// below registers are deprecated
// RegisterEquipItem(30666, "The C.A.P.P.E.R", "capper", true, {}, function( player ) {return player.GetPlayerClass( ) == TF_CLASS_SCOUT} )
// RegisterEquipItem(1, "test item", "Test1", true, {}, function( player ) {return false})
// RegisterEquipItem(2, "test item", "Test2", true, {}, function( player ) {return false})
// RegisterEquipItem(3, "test item", "Test3", true, {}, function( player ) {return false})
// RegisterEquipItem(4, "test item", "Test4", true, {}, function( player ) {return false})
// RegisterEquipItem(5, "test item", "Test5", true, {}, function( player ) {return false})
// RegisterEquipItem(6, "test item", "Test6", true, {}, function( player ) {return false})
// RegisterEquipItem(7, "test item", "Test7", true, {}, function( player ) {return false})
// RegisterEquipItem(8, "test item", "Test8", true, {}, function( player ) {return false})
// RegisterEquipItem(9, "test item", "Test9", true, {}, function( player ) {return false})
// RegisterEquipItem(0, "test item", "Test0", true, {}, function( player ) {return false})

/* RegisterEquipItem(100000, "Upgradeable TF_WEAPON_ROCKETLAUNCHER", "ValveRocket", {
	override_func = function( player ) {
		return player.GetSteamID() == "[U:1:969530867]"
	}
}
, true, {
	"damage bonus hidden" 			: 10.0
	"clip size bonus" 				: 39.5
	"heal on hit for rapidfire" 	: 250
	"critboost on kill" 			: 10
	"Projectile speed increased" 	: 1.5
	"move speed bonus" 				: 2
	"maxammo primary reduced" 		: 5
	"attach particle effect" 		: 2
	"fire rate penalty" 			: 2.5
	"reload time increased" 		: 5
	"projectile no deflect" 		: 1
	"projectile spread angle mult" 	: 0
}, override_func =function( player ) {return player.GetSteamID( ) == "[U:1:969530867]"} ) */

AddChatTrigger("equip" function( player, ... ) {
	if (!player)
		return

	local items_per_page = 5

	if (!player.InRespawnRoom())
	{
		player.PrintToChat("\x0730C429[►] Can't Change loadout outside of Spawn Room.")
		return
	}

	if (vargv.len() != 1 || (vargv.len() != 0 && vargv[0] == "help"))
	{
		if (vargv.len() != 0 && vargv[0] == "help")
		{
			player.PrintToChat("\x0730C429[►] \"/equip\" is a chat command that can give you temporary items you dont own.")
			player.PrintToChat("\x0730C429[►] Such as using \"/equip bread\" to equip \"The Bread Bite\"")
			if (RegisteredItems.len() > items_per_page)
			{
				player.PrintToChat("\x0730C429[►] ")
				player.PrintToChat("\x0730C429[►] When using \"/equip page #\" it allows you to cycle through all the items")
			}
			return
		}
		local max_pages = ceil(RegisteredItems.len() / items_per_page.tofloat()).tointeger()
		if (vargv.len() == 0 && RegisteredItems.len() > items_per_page)
		{
			player.PrintToChat("\x0730C429[►] Incorrect Arguments")
			player.PrintToChatF("\x0730C429[►] Total Pages: %d", max_pages)
			player.PrintToChat("\x0730C429[►] Use \"!equip page #\" to navigate the pages")
			return
		}
		else if (vargv.len() == 2 && vargv[0] == "page" && RegisteredItems.len() > items_per_page)
		{
			local page_num = 1
			try {page_num = vargv[1].tointeger()}
			catch(e) {}
			if (page_num < 1)
			{
				page_num = 1
				player.PrintToChat("\x0730C429[►] Page index out of bounds, Fixing")
			}
			if (page_num > max_pages)
			{
				page_num = max_pages
				player.PrintToChat("\x0730C429[►] Page index out of bounds, Fixing")
			}

			player.PrintToChatF("\x0730C429[►] Displaying Page %d of %d", page_num, max_pages)

			local items_skip = (page_num-1) * items_per_page
			local skipped = 0
			local showed_items = 0 

			// printf("Need to skip %d Items\n", items_skip)

			foreach (/**@type {integer} */index, /**@type {EquipWeaponData} */data in RegisteredItems)
			{
				if (skipped < items_skip)
				{
					skipped++
					// printf("Skipping Item %s, need to skip %d more\n", data.MakingName, items_skip-skipped)
					continue
				}
				if (showed_items >= items_per_page)
				{
					// printf("Skipping Item %s, Already displayed 5\n", data.MakingName)
					continue
				}

				showed_items++
				player.PrintToChatF("\x0730C429[►] \x01\"\x03%s\x01\" or \"\x03%d\x01\": Gives \x04%s", data.make_name, index, data.internal_name)
			}

			return
		}
		else
		{
			player.PrintToChat("\x0730C429[►] Incorrect Arguments")
			foreach (/**@type {integer} */idx, /**@type {EquipWeaponData} */data in RegisteredItems)
			{
				player.PrintToChatF("\x0730C429[►] \x01\"\x03%s\x01\" or \"\x03%d\x01\": Gives \x04%s", data.make_name, idx, data.internal_name)
			}
		}
		return
	}

	local item = vargv[0].tolower()
	local item_data = null

	if (player.IsGHeavy())
	{
		player.PrintToChat("\x0730C429[►] Fist of Steel Blocks Item Creation!")
		return
	}

	foreach (/**@type {integer} */idx, /**@type {EquipWeaponData} */data in RegisteredItems)
	{
		// printf("Processing Item %s, IDX match? %s, Name match? %s.\n", data.internal_name, (item == idx.tostring()).tostring(), (item == data.make_name).tostring())
		if (item == idx.tostring() || item == data.make_name)
		{
			if (data.override_func(player) == false)
				return player.PrintToChatF("\x0730C429[►] Failed to Meet Requirements for %s", data.internal_name)
			item_data = data
			break
		}
	}

	if (item_data == null)
		return player.PrintToChatF("\x0730C429[►] Failed to find any items using Input \"%s\", Try Again", item)

	local HasItemHelper = "ItemTranslateTable" in ROOT

	if (HasItemHelper)
	{
		foreach (item, indexs in ItemTranslateTable)
		{
			if (!IsInArray(item_data.idx, indexs))
				continue
			player.IHTranslateToChat2(item)
			break
		}
	}
	player.EquipItem(item_data.internal_name, item_data.force_swap, item_data.overrides, item_data.is_segsegv)
	item_data.OnPlayerEquip(player)
} )

AddChatTrigger("scoreboard", function( player ) {
	player.PrintToChat("[►] Scores printed to Console.")
	local function GetKills( plrr ) {return GetPropInt( plrr, "m_Shared.tfsharedlocaldata.m_ScoreData.m_iKills" )}
	local function GetDeaths( plrr ) {return GetPropInt( plrr, "m_Shared.tfsharedlocaldata.m_ScoreData.m_iDeaths" )-GetPropInt(plrr, "m_Shared.tfsharedlocaldata.m_ScoreData.m_iSuicides")}
	ReCalculatePlayers() //
	foreach (plr in m_aHumans)
	{
		player.PrintToConsole(" ")
		player.PrintToConsoleF("%s", plr.GetUserName())
		player.PrintToConsole("-----------")
		player.PrintToConsoleF("Score: %d", GetPropInt(PlayerManager, "m_iTotalScore", plr.entindex()))
		player.PrintToConsoleF("Healing: %d", plr.GetTrackedHealing())
		player.PrintToConsoleF("Damage: %d", plr.GetTrackedDamage())
		player.PrintToConsoleF("Tank Damage: %d", plr.GetTrackedTankDamage())
		player.PrintToConsoleF("Kills: %d", GetKills(plr))
		player.PrintToConsoleF("Deaths: %d", GetDeaths(plr))
	}
} )

// if other scripts use SpawnCallbacks then Remove this!!
ClearSpawnCallbacks()

/**
 * Fuck the Blutsuager
 * @param {CTFPlayer} owner
 * @param {CTFPlayer} victim
 */
function BlutsuagerHit( owner, victim ) 
{
	if ( !victim.IsValidReprogramTarget(true) )
	{
		owner.GetWeaponInSlotNew(SLOT_SECONDARY).IncreaseUberChargePercent(BlutsaugerSettings.refund)
		return owner.TranslateToChat("REPROG_BOT_STRONG", victim.GetUserName())
	}
	else if (victim.GetModelScale() < 0.15)
	{
		owner.GetWeaponInSlotNew(SLOT_SECONDARY).IncreaseUberChargePercent(BlutsaugerSettings.refund)
		return owner.TranslateToChat("REPROG_BOT_MICRO", victim.GetUserName())
	}

	CreateParticle("blut_reprogram_explosion", victim.GetOrigin()+Vector(0, 0, 32))

	owner.AddCustomAttribute("ubercharge rate penalty", 0, 10)

	local duration = BlutsaugerSettings.duration

	foreach (attrib, value in BlutsaugerAttributes)
		victim.AddCustomAttribute(attrib, value, duration)

	victim.AddCondEx(TF_COND_CRITBOOSTED_PUMPKIN, duration, owner)
	victim.AddCondEx(TF_COND_REPROGRAMMED, duration, owner)

	TranslateToChatAll("REPROG_BOT_MESSAGE", owner.GetUserName(), victim.GetUserName())

	local action = "Mobber"

	switch (victim.GetPlayerClass())
	{
	case TF_CLASS_SNIPER:
		action = "Sniper"
	break

	case TF_CLASS_SPY:
		action = "Spy"
	break

	case TF_CLASS_MEDIC:
		action = "Medic"
		victim.AddCustomAttribute("mult medigun range", 3, -1)
		victim.AddCustomAttribute("move speed bonus blutsauger", 1.3, -1)
		victim.AddCustomAttribute("effect cond override", 33, -1)
		victim.TeamFortress_SetSpeed()
		victim.AddBotAttribute(IGNORE_ENEMIES)
		victim.RemoveCondEx(TF_COND_CRITBOOSTED_PUMPKIN, true)
	break
	}

	local ActionCommand = format("switch_action %s -duration %d", action, duration)

	EntFireNew(victim, "$BotCommand", ActionCommand)

	local MedicSpeed = owner.GetMoveSpeed()
	local BotSpeed = victim.GetMoveSpeed()

	if (BotSpeed > MedicSpeed * 1.3)
	{
		owner.AddCustomAttribute("move speed bonus blutsauger", 1.3, duration)
		owner.TeamFortress_SetSpeed()
	}

	GetScope(victim).EndReprogramTime <- Time() + duration
	GetScope(victim).ReProgrammer <- owner

	local function OnDeath() {
		local scope = GetScope(self)
		local owner = ("ReProgrammer" in scope) ? scope.ReProgrammer : null
		if (owner && owner.IsValid())
			owner.RemoveCustomAttribute("move speed bonus blutsauger")
		self.UndoReprogram(false)
	}
	GetScope(victim).OnDeath <- OnDeath

	EmitSoundEx({
		sound_name = BlutsaugerSettings.sound
		entity = victim
		sound_level = MATH.ConvertRadiusToSndLvl(BlutsaugerSettings.sound_radius)

		filter_type = RECIPIENT_FILTER_GLOBAL
	})
}

RegisterSpawnCallback("tf_projectile_healing_bolt", "BlutsaugerFUCK", function( entity ) {
	/** @type {CBaseEntity} */
	local entity = entity

	/** @type {CTFPlayer|null} */
	local owner = entity.GetOwner()
	if (!owner || !owner.IsPlayer() || owner.GetWeaponIDXInSlotNew(SLOT_PRIMARY) != TF_WEAPON_BLUTSAUGER)
		return

	GetScope(entity).GrantTheFuckingUber <- true

	SetDestroyCallback(entity, function() {
		// owner.PrintToChat(TF_TEAM_COLOR_RED+"Your Arrow:\x01 I died on frame "+GetFrameCount()+" Do i grant the uber? "+GetScope(self).GrantTheFuckingUber)
		if (GetScope(self).GrantTheFuckingUber)
			owner.GetWeaponInSlotNew(SLOT_SECONDARY).IncreaseUberChargePercent(BlutsaugerSettings.refund)
	})
})

function GameplayThink()
{
	local ReprogrammedBots = []
	local AliveBots = 0
	if ( Players.len() < 1 || !ValidatePlayerArray() || (m_aHumans.len() + m_aRobots.len()) != Players.len())
		ReCalculatePlayers()

	foreach (/** @type {CTFBot}*/ bot in m_aRobots)
	{
		local scope = GetScope(bot)

		if ("DelayGameplayThink" in scope && scope.DelayGameplayThink >= GetFrameCount())
			continue

		if (!("LastVels" in scope))
			scope.LastVels <- []
		if (type(scope.LastVels) != "array")
			scope.LastVels <- []

		scope.LastVels.append(bot.GetAbsVelocity())
		if (scope.LastVels.len() > 6)
			scope.LastVels.remove(0)

		bot.SetGravity(1.0)

		local active = bot.GetActiveWeapon()
		
		bot.MultiplyGravity(bot.HookMultAttributes("mult gravity"))

		if (active)
			bot.MultiplyGravity(active.GetMultAttribute("mult gravity active"))

		if (bot.IsCrouching())
		{
			bot.MultiplyGravity(bot.HookMultAttributes("mult gravity crouching"))
			if (active)
				bot.MultiplyGravity(active.GetMultAttribute("mult gravity crouching active"))
		}

		if (bot.IsDead())
			continue

		if (bot.IsAlive() && !bot.IsReprogrammed())
			AliveBots += 1

		if ("EndReprogramTime" in scope && scope.EndReprogramTime <= Time())
			bot.UndoReprogram()

		if ("Timescale" in ROOT)
			bot.AddCustomAttribute("voice pitch scale", Timescale, -1)

		if (bot.IsReprogrammed() && !bot.HasBotTag("RedSupport"))
		{
			if (bot.InRespawnRoom(true))
				bot.UndoReprogram()
			else 
				ReprogrammedBots.append(bot)
		}

		if (bot.HasCorrosion())
		{
			if (bot.ShouldRemoveCorrosion())
			{
				bot.RemoveCorrosion()
				continue
			}
			/** @type {Corrosion} */
			local Corrosion = bot.GetCorrosion()
			if (Corrosion.ShouldUpdate())
			{
				Corrosion.Tick()
				continue
			}
		}
	}

	foreach (/** @type {CTFPlayer} */Human in m_aHumans)
	{
		local scope = GetScope(Human)
		if (!("LastVels" in scope))
			scope.LastVels <- []
		if (type(scope.LastVels) != "array")
			scope.LastVels <- []
			
		scope.LastVels.append(Human.GetAbsVelocity())
		if (scope.LastVels.len() > 6)
			scope.LastVels.remove(0)

		if (!("BetterStatTracking" in FatCatLibSettings))
			SetLibrarySettings()
		if (!("NoclipAntiCheat" in FatCatLibSettings))
			SetLibrarySettings()

		if (FatCatLibSettings["BetterStatTracking"] == true)
		{
			SetPropIntArray(PlayerManager, "m_iDamage", GetScope(PlayerManager).m_iDamage[Human.entindex()], Human.entindex())
			SetPropIntArray(PlayerManager, "m_iDamageBoss", GetScope(PlayerManager).m_iDamageBoss[Human.entindex()], Human.entindex())
			SetPropIntArray(PlayerManager, "m_iHealing", GetScope(PlayerManager).m_iHealing[Human.entindex()], Human.entindex())
		}

		if (FatCatLibSettings["NoclipAntiCheat"] == true)
		{
			if (!Human.IsAdmin() && Human.GetMoveType() == MOVETYPE_NOCLIP)
			{
				Human.SetMoveType(MOVETYPE_WALK, MOVECOLLIDE_DEFAULT)
				Human.SetAbsOrigin(Human.GetOrigin() + (Human.GetAbsVelocity() * (-1.0/60.0)))
				Human.DisplayHudText("No Noclip", "255 0 255", [-1, 0.275], 5, 1)
				Human.DisplayHudText("If you are actually stuck, then you should", "255 255 255", [-1, 0.35], 5, 2)
				Human.DisplayHudText("KILLBIND NOW!", "255 255 255", [-1, 0.385], 5, 3)
			}
		}

		if ("Timescale" in ROOT)
		{
			if(!Human.HookAdditiveAttributes("do not override overlay"))
				Human.SetScriptOverlayMaterial(Timescale == 1.0 ? "" : "debug/yuv")
			Human.AddCustomAttribute("voice pitch scale", Timescale, -1)
		}

		// 
		Human.SetGravity(1.0)

		local primary 		= Human.GetWeaponInSlotNew(SLOT_PRIMARY)
		local primaryIDX 	= Human.GetWeaponIDXInSlotNew(SLOT_PRIMARY)
		local active 		= Human.GetActiveWeapon()
		local activeIDX 	= Human.GetActiveWeaponIDX()
		
		Human.MultiplyGravity(Human.HookMultAttributes("mult gravity"))

		if (active)
			Human.MultiplyGravity(active.GetMultAttribute("mult gravity active"))

		if (Human.IsCrouching())
		{
			Human.MultiplyGravity(Human.HookMultAttributes("mult gravity crouching"))
			if (active)
				Human.MultiplyGravity(active.GetMultAttribute("mult gravity crouching active"))
		}
			
		if (activeIDX == TF_WEAPON_TOMISLAV)
			Human.TranslateToHud("TOMISLAV_HEAT", ("Hits" in GetScope(active) ? GetScope(active).Hits/10 : -1))

		if (primaryIDX == TF_WEAPON_TOMISLAV)
		{
			local WeaponScope = GetScope(primary)

			if (!("Hits" in WeaponScope))
				WeaponScope.Hits <- 0
			if (!("m_flLastHeatHit" in WeaponScope))
				WeaponScope.m_flLastHeatHit <- Time()
			if (!("m_flLastHeatLoseTime" in WeaponScope))
				WeaponScope.m_flLastHeatLoseTime <- Time()

			local HeatLoss = GetRoundState() != GR_STATE_RND_RUNNING ? TOMISLAV_SETTINGS.HeatLostPerSecond * 0.1 : TOMISLAV_SETTINGS.HeatLostPerSecond

			if (WeaponScope.Hits >= 1 && 
				WeaponScope.m_flLastHeatHit + TOMISLAV_SETTINGS.TimeBeforeHeatLost.tofloat() <= Time() &&
				WeaponScope.m_flLastHeatLoseTime + (1.0/HeatLoss.tofloat()) <= Time())
			{
				WeaponScope.m_flLastHeatLoseTime = Time()
				WeaponScope.Hits -= 1
				foreach (attribs in TOMISLAV_SETTINGS.Attributes)
					primary.CalculateAttributeChange(WeaponScope.Hits, attribs[0], attribs[1], attribs[2], attribs[3], attribs[4])

				primary.AddAttribute("Set DamageType Ignite", (WeaponScope.Hits > 400).tointeger(), 0)
				primary.AddAttribute("ragdolls become ash", (WeaponScope.Hits > 700).tointeger(), 0)
				primary.AddAttribute("turn to gold", (WeaponScope.Hits > 1000).tointeger(), 0)
				if (Human.GetPrimaryAmmo() > Human.GetMaximumPrimaryAmmo())
					Human.ResetPrimaryAmmo()
			}
			if (WeaponScope.Hits >= 1000)
				WeaponScope.Hits = 1000
			primary.ReapplyProvision()
		}

		if (Human.HookAdditiveAttributes("infinite ammo"))
		{
			Human.ResetAmmo()
			foreach (wep in Human.GetAllWeapons())
			{
				if (wep.GetAttribute("infinite ammo", 0) && "GetMaxClip1" in wep)
					wep.SetClip1(wep.GetMaxClip1())
			}
		}
	}

	foreach (/**@type {CTFBaseBoss} */tank in GetEveryTank())
	{
		EnableStringPurge(tank)
		if (tank.GetTeam() != TF_TEAM_PVE_DEFENDERS)
			continue
		if (GetPropBool(tank, "m_bGlowEnabled") == true)
			continue

		RunWithDelay(0.1, @() SetPropBool(tank, "m_bGlowEnabled", true))
	}

	if (AliveBots == 0)
	{
		foreach (bot in ReprogrammedBots)
			bot.UndoReprogram()
	}
	return -1
}
/**
 * Modify the Callbacks damage
 * @param {table} params
 * @param {CTFPlayer} victim
 * @param {CTFPlayer} attacker
 * @param {CTFWeaponBase} weapon
 * @param {CBaseEntity|null} inflictor
 */
function ROOT::ModifyCallbackDamage( params, victim, attacker, weapon, inflictor )
{
	local custom = params.damage_custom
	if (custom > (1<<7))
		return
	switch (custom)
	{
	case TF_DMG_CUSTOM_KART: {	// [11/12/25] Please, dear god, why do i have to do this stupid hack
		params.early_out <- true
		victim.TakeDamageCustom(inflictor, attacker, attacker.GetSpellBook(), Vector(), victim.GetOrigin(), KART_DMG, params.damage_type, TF_DMG_CUSTOM_TRIGGER_HURT)
		return
	}
	break;
	case TF_DMG_CUSTOM_SPELL_SKELETON:
	case TF_DMG_CUSTOM_SPELL_MIRV:
	case TF_DMG_CUSTOM_SPELL_METEOR:
	case TF_DMG_CUSTOM_SPELL_BLASTJUMP: 
		if (victim.IsPlayer())
			victim.AddCondEx(TF_COND_MARKEDFORDEATH, 10, attacker)
	break;
	}
}

/**
 * Proccess any custom chaos weapon stuff
 * @param {table} params
 * @param {CTFPlayer} victim
 * @param {CTFPlayer} attacker
 * @param {CTFWeaponBase} weapon
 * @param {CBaseEntity} _inflictor
 */
function ROOT::ProcessChaosWeaponHit( params, victim, attacker, weapon, _inflictor )
{
	switch (weapon.GetIDX())
	{
	case TF_WEAPON_TOMISLAV:
	{
		if (attacker.GetWeaponIDXInSlotNew(SLOT_PRIMARY) != TF_WEAPON_TOMISLAV) 
			break;

		local addHits = 1

		if (params.damage_type & DMG_CRITICAL)
			addHits = 3
		else if ((victim.IsPlayer() && victim.IsMinicritDebuffed()) || attacker.IsMinicritBuffed())
			addHits = 2

		local scope = GetScope(weapon)
		if (!("Hits" in scope))
			scope.Hits <- 0
		if (!("m_flLastHeatHit" in scope))
			scope.m_flLastHeatHit <- 0.0

		scope.Hits += addHits
		scope.m_flLastHeatHit = Time()
		foreach (attribs in TOMISLAV_SETTINGS.Attributes)
			weapon.CalculateAttributeChange(scope.Hits, attribs[0], attribs[1], attribs[2], attribs[3], attribs[4])
			
		weapon.AddAttribute("Set DamageType Ignite", (scope.Hits > 400).tointeger(), 0)
		weapon.AddAttribute("ragdolls become ash", (scope.Hits > 700).tointeger(), 0)
		weapon.AddAttribute("turn to gold", (scope.Hits > 1000).tointeger(), 0)
		if (attacker.GetPrimaryAmmo() > attacker.GetMaximumPrimaryAmmo())
			attacker.ResetPrimaryAmmo()
				
		if ( scope.Hits >= 1000 )
			scope.Hits = 1000
		weapon.ReapplyProvision()
	}
	break;
	}
}

/**
 * @param {table} params
 * @param {CTFPlayer} victim
 * @param {CTFBot} attacker
 * @param {CTFWeaponBase} weapon
 * @param {CBaseEntity} _inflictor
 */
function ROOT::ProcessChaosPlayerHurt( params, victim, attacker, weapon, _inflictor )
{
	if(victim.HookAdditiveAttributes("reflect dmg back chance") != 0)
	{
		local chance = victim.HookAdditiveAttributes("reflect dmg back chance")
		local dmg_mult = victim.HookMultAttributes("reflect dmg back mult")
		local stuntime = victim.HookAdditiveAttributes("reflect dmg back stun time")
		if (MATH.RandomChance() <= chance)
		{
			attacker.TakeDamageEx(victim, victim, victim, Vector(), Vector(), params.damage * dmg_mult, params.damage_type)
			if(stuntime)
				attacker.StunPlayer(stuntime, 0.0, TF_STUN_BOTH, victim)
		}
	}
}

// if other scripts use DamageCallbacks then Remove this!!
ClearDamageCallbacks()

RegisterDamageCallback("player", "GameplayPlayer" function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= params.weapon
	local inflictor	= params.inflictor
	
	if (!attacker || !weapon || !inflictor)
		return

	if (attacker.IsPlayer() && victim.IsPlayer() && inflictor.GetClassname() == "tf_projectile_healing_bolt")
	{
		if (attacker.GetPlayerClass() == TF_CLASS_MEDIC && attacker.GetWeaponIDXInSlotNew(SLOT_PRIMARY) == TF_WEAPON_BLUTSAUGER)
		{
			GetScope(inflictor).GrantTheFuckingUber <- false
			inflictor.Destroy()
			BlutsuagerHit(attacker, victim)
		}
	}

	if ( !(startswith(weapon.GetClassname(), "tf_weapon") || startswith(weapon.GetClassname(), "tf_wearable")) )
		return

	if (victim.IsInvincible() || IsPlayerABot(attacker))
		return

	ModifyCallbackDamage(params, victim, attacker, weapon, inflictor)
	ProcessChaosWeaponHit(params, victim, attacker, weapon, inflictor)
})

RegisterDamageCallback("player", "GameplayRobotAttack" function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= params.weapon
	local inflictor	= params.inflictor
	
	if (!attacker || !weapon || !inflictor)
		return

	if ( !(startswith(weapon.GetClassname(), "tf_weapon") || startswith(weapon.GetClassname(), "tf_wearable")) )
		return

	if (!attacker.IsBot() || victim.IsInvincible())
		return
	
	ProcessChaosPlayerHurt(params, victim, attacker, weapon, inflictor)
})

RegisterDamageCallback(["obj_sentrygun", "obj_teleporter", "obj_dispenser", "tank_boss"], "GameplayOthers", function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= params.weapon
	local inflictor	= params.inflictor

	if (!attacker || !weapon || !inflictor || IsPlayerABot(attacker))
		return

	if ( !(startswith(weapon.GetClassname(), "tf_weapon") || startswith(weapon.GetClassname(), "tf_wearable")) )
		return

	ModifyCallbackDamage(params, victim, attacker, weapon, inflictor)
	ProcessChaosWeaponHit(params, victim, attacker, weapon, inflictor)
})

RegisterDamageCallback("tf_zombie", "GameplaySkeletons", function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return
	local victim = params.victim
	local attacker = params.attacker
	params.early_out <- true
	if (victim.IsValid())
		SendGlobalGameEvent("npc_hurt", {
			entindex = victim.entindex()
			health = victim.GetHealth()
			attacker_player = attacker.IsPlayer() ? attacker.GetUserID() : -1
			weaponid = -1
			damageamount = 5
			crit = false
			boss = 0
		})
	victim.TakeDamageCustom(null, attacker, null, Vector(), Vector(), 5.0, DMG_GENERIC, TF_DMG_CUSTOM_NO_CALLBACKS)
})


if ("GameplayEvents" in ROOT) ::GameplayEvents.clear()
::GameplayEvents <- {
	function OnScriptEvent_HumanDeath( params )
	{
		local human = params.victim
		local attacker = params.attacker

		if ("OnDeath" in GetScope(human))
		{
			GetScope(human).OnDeath()
			delete GetScope(human).OnDeath
		}

		if (!attacker || !attacker.IsBot() || !MATH.OneInChance(10))
			return
		attacker.SayChatterMessage(human)
	}
	function OnScriptEvent_BotDeath( params )
	{
		local victim = params.victim
		local attacker = params.attacker
		if ("OnDeath" in GetScope(victim))
		{
			GetScope(victim).OnDeath()
			delete GetScope(victim).OnDeath
		}
		if (!attacker)
			return
		if (attacker.IsBot())
		{
			if (attacker.HasBotTag("NoChatter"))
				return
			if (!attacker.IsReprogrammed() || !MATH.OneInChance(10))
				return
			attacker.SayChatterMessage(victim)
			return
		}
		/* local weaponIDX = params.weaponIDX
		local logname = params.logname

		if (!IsInArray(weaponIDX, SpellWeapons) || !IsInArray(logname, SpellWeapons))
			return

		local spell_book = attacker.GetSpellBook()
		if (!spell_book) return

		local scope = GetScope(spell_book)

		if (!("m_iKills" in scope))
			scope.m_iKills <- 0

		scope.m_iKills++

		switch (weaponIDX)
		{
			case TF_WEAPON_LOLLICHOP: { spell_book.ModifySpells(TF_SPELL_METEOR, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_SHORT_CIRCUT: { spell_book.ModifySpells(TF_SPELL_LIGHTNING, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_CLAIDHEAMH_MOR: { spell_book.ModifySpells(TF_SPELL_MONOCULUS, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_UNARMED_COMBAT: { spell_book.ModifySpells(TF_SPELL_SKELETON, 2, scope.m_iKills, 10) ; return }
			case TF_WEAPON_CONSCIENTIOUS_OBJECTOR: { if (scope.m_iKills % 10 == 0 && spell_book.GetSpellCharges().tointeger() != SpellDefaults[spell_book.GetSpellIndex()+2].tointeger()) { attacker.RollSpell() } ; return }
		} */
	}
	function OnScriptEvent_HumanResupply( params )
	{
		local player = params.player

		if (!IsUsingSpells())
			SetUsingSpells(true)

		if (player.GetPlayerClass() != TF_CLASS_ENGINEER)
			player.RemoveAllObjects(true)

		local meleeIDX = player.GetWeaponIDXInSlotNew(SLOT_MELEE)
		if (meleeIDX == TF_WEAPON_FIST_OF_STEEL)
			RunWithDelay(0.1, @() player.TransformGHeavy())
		else
			RunWithDelay(0.1, @() player.UndoGHeavy())
	}
	function OnScriptEvent_HumanSpawn( params )
	{
		if (!params.player)
			return
		/** @type {CTFPlayer} */
		local player = params.player
		RunWithDelay(0.1, @() player.FixAmmo())
		local spellbook = player.GetSpellBook()

		if (player.HookAdditiveAttributes("slow down aura"))
		{	// AddThink( func, name = null, offset = 0.0 )
			player.AddThink(function () {
				/** @type {CTFPlayer} */
				local self = self
				local active = self.GetActiveWeapon()
				if(!active)
					return 0.2
				if(active.GetAttribute("slow down aura", 0))
				{
					local slow_multiplier = active.GetAttribute("slow down aura slow mult", 1.0)
					local giant_multiplier = active.GetAttribute("slow down aura giant mult", 1.0)
					local slow_radius = active.GetAttribute("slow down aura", 0)
					foreach (/**@type {CTFBot} */bot in m_aRobots)
					{
						if(self.DistanceTo(bot, true) > slow_radius)
							continue
						bot.StunPlayer(0.5, bot.IsMiniBoss() ? giant_multiplier : slow_multiplier, TF_STUN_MOVEMENT, self)
					}
				}

				return 0.2
			}, "SlowDownAura")
		}
		
		foreach (/**@type {CTFWeaponBase} */weapon in player.GetAllWeapons())
		{
			if (weapon.IsWearable())
				continue
			local wep_scope = GetScope(weapon)
			if (weapon == spellbook)
			{
				if (!("m_iKills" in wep_scope))
					wep_scope.m_iKills <- 0
				else
					wep_scope.m_iKills = 0
			}
			
			if (weapon.GetIDX() == TF_WEAPON_TOMISLAV)
			{
				weapon.AddAttribute("damage bonus", 1, 0)
				weapon.AddAttribute("fire rate bonus", 1, 0)
				weapon.AddAttribute("max health additive bonus", 0, 0)
				weapon.AddAttribute("maxammo primary increased", 1, 0)
				weapon.AddAttribute("restore health on kill", 0, 0)
				weapon.AddAttribute("minigun spinup time decreased", 1, 0)
				weapon.AddAttribute("weapon spread bonus", 1, 0)
				weapon.RemoveAttribute("Set DamageType Ignite")
				weapon.RemoveAttribute("ragdolls become ash")
				weapon.RemoveAttribute("turn to gold")
				weapon.ReapplyProvision()

				local wep_scope = GetScope(weapon)
				if (!("Hits" in wep_scope))
					wep_scope.Hits <- 0
				else
					wep_scope.Hits = 0

				player.ResetHealth()
			}

			if (weapon.GetIDX() == TF_WEAPON_BLUTSAUGER)
			{
				player.AddThink(function() {

					/**@type {CTFPlayer} */
					local self = self

					if (self.GetWeaponIDXInSlotNew(SLOT_PRIMARY) != TF_WEAPON_BLUTSAUGER)
					{
						self.RemoveThink("BlutsaugerDisrupt")
						return 500
					}

					local weapon = self.GetWeaponInSlotNew(SLOT_PRIMARY)
					weapon.SetClip1(1)
					self.SetPrimaryAmmo(0)
					self.SetMetal(200)

					if (self.GetWeaponInSlotNew(SLOT_SECONDARY) == null)
						return 1

					if (self.GetWeaponInSlotNew(SLOT_SECONDARY).GetUberChargePercent() < 1.0)
					{
						weapon.AddAttribute("provide on active", 1, 0)
						weapon.AddAttribute("no_attack", 1, 0)
						weapon.AddAttribute("ubercharge ammo", 0, 0)
						SetPropInt(weapon, "m_iPrimaryAmmoType", TF_AMMO_METAL)
					}
					else 
					{
						weapon.AddAttribute("provide on active", 0, 0)
						weapon.AddAttribute("no_attack", 0, 0)
						weapon.AddAttribute("ubercharge ammo", 100, 0)
						SetPropInt(weapon, "m_iPrimaryAmmoType", TF_AMMO_PRIMARY)
					}

					if (self.GetActiveWeaponIDX() != TF_WEAPON_BLUTSAUGER)
						return 0.1

					if (!self.IsPressingButton(IN_ATTACK2))
						return -1

					self.PrintToHud("[Activating Kill Switch]")

					self.RemoveCustomAttribute("move speed bonus blutsauger")
					self.TeamFortress_SetSpeed()

					foreach (robot in m_aRobots)
					{
						if ("ReProgrammer" in GetScope(robot) && GetScope(robot).ReProgrammer == self)
							robot.UndoReprogram()
					}
					return -1
				}, "BlutsaugerDisrupt", 0.15)
			}

			if (weapon.GetIDX() == 947) // TODO: add constant for [Quackenbirdt]
			{
				player.AddThink(function() {
					/** @type {CTFPlayer} */
					local self = self

					if (self.GetTeam() != TF_TEAM_BLUE || !self.InCond(43))
						return -1

					if (self.InRespawnRoom())
					{
						self.ForceRegenerateAndRespawn()
						self.PrintToHud("ERROR - Cannot enter enemy spawn zones.")
						self.EmitSoundTo("vo/halloween_merasmus/sf14_merasmus_necrosmasher_08.mp3")
					}

					return -1
				}, "NoSpawnSpies")
			}
		}
	}
	function OnScriptEvent_BotSpawn( params )
	{
		local player = params.player

		player.ResetColor()
		player.RemoveCorrosion()

		local scope = GetScope(player)

		if (!("ReProgrammer" in scope))
			scope.ReProgrammer <- null
		else
			scope.ReProgrammer = null
		if (!("DelayGameplayThink" in scope))
			scope.DelayGameplayThink <- GetFrameCount()+1
		else
			scope.DelayGameplayThink = GetFrameCount()+1

		// should not persist on spawn
		if ("OnDeath" in scope)
			delete scope.OnDeath

		
		if (FatCatLibSettings.KillWatchViewmodels)
		{
			local viewmodel_watch = GetPropEntityArray(player, "m_hViewModel", 1)
			if (viewmodel_watch != null)
			{
				EnableStringPurge(viewmodel_watch)
				EntFireNew(viewmodel_watch, "Kill")
			}
		}
		player.AddCustomAttribute("cannot swim", 1.0, -1)
	}
	function OnScriptEvent_BotTeam( params )
	{
		if (params.oldteam == TF_TEAM_PVE_INVADERS) return;
		local player = params.player
		local scope = GetScope(player)

		if (!("ReProgrammer" in scope))
			scope.ReProgrammer <- null

		if (IsValidPlayer(scope.ReProgrammer) && !scope.ReProgrammer.IsBot())
		{
			scope.ReProgrammer.TranslateToChat("REPROG_BOT_LEAVE", player.GetUserName())
			scope.ReProgrammer = null
		}
	}
	function OnGameEvent_mvm_begin_wave( _ )
	{
		local ConfusionEnt = FindByName(null, "ConfusionEnt")
		if (!ConfusionEnt) ConfusionEnt = SpawnEntityFromTable("info_target", {targetname = "ConfusionEnt"})
		local name = split(GetMapName().slice(4), "_")[0].tolower()
		// cuts the mvm_ and removes everything after the first _

		switch (name)
		{
		case "coaltown":
		case "ghost": 		{ ConfusionEnt.SetAbsOrigin(Vector(50, 		2850, 	250) ) 	}
		break;
		case "rottenburg": 	{ ConfusionEnt.SetAbsOrigin(Vector(220, 	-2250, 	-500) ) }
		break;
		case "mannhattan": 	{ ConfusionEnt.SetAbsOrigin(Vector(-1200, 	-3000, 	-280) ) }
		break;
		case "mannworks": 	{ ConfusionEnt.SetAbsOrigin(Vector(600, 	2200, 	330) ) 	}
		break;
		case "decoy": 		{ ConfusionEnt.SetAbsOrigin(Vector(0, 		2300, 	420) ) 	}
		break;
		case "bigrock": 	{ ConfusionEnt.SetAbsOrigin(Vector(-1500, 	4600,	130) ) 	}
		break;
		case "redstone": 	{ ConfusionEnt.SetAbsOrigin(Vector(420, 	5400, 	-380) ) 	}
		break;
		case "titan": 		{ ConfusionEnt.SetAbsOrigin(Vector(-9700, 	-250, 	200) ) 	}
		break;
		default: throw format("Unknown Map Name \"%s\"", GetMapName())
		}
	}
}
__CollectGameEventCallbacks(GameplayEvents)

::ChatterMessages <- {
	"Rares" : {
		"Rare1" : {
			"chance" : 5
			"message" : "ACCORDING TO ALL KNOWN LAWS OF AVIATION, THERE'S NO WAY A BEE SHOULD BE ABLE TO FL-- wait that's not part of my script..."
		}
		"Rare2" : {
			"chance" : 5
			"message" : "FRIENDSHIP IS MAGIC... BUT THAT DEATH WAS TRAGIC."
		}
		"Rare3" : {
			"chance" : 5
			"message" : "HAVE WE MET BEFORE...?"
		}
		"Rare4" : {
			"chance" : 5
			"message" : "IF YOU WISH TO DEFEAT ME, TRAIN FOR ANOTHER HUNDRED YEARS."
		}
		"Rare5" : {
			"chance" : 5
			"message" : "WHAT IS THIS 'F4' YOU SPEAK OF?"
		}
		"Rare6" : {
			"chance" : 5
			"message" : "NICE INVENTORY..."
		}
		"Rare7" : {
			"chance" : 5
			"message" : "YOU DON'T EVEN KNOW WHAT'S IN THAT HATCH, DO YOU?"
		}
		"Rare8" : {
			"chance" : 5
			"message" : "WE NEED TO TALK ABOUT PARALLEL UNIVERSES..."
		}
		"Rare9" : {
			"chance" : 5
			"message" : "MEET YOUR MATCH WAS A MISTAKE."
		}
		"Rare10" : {
			"chance" : 5
			"message" : "GOOG IS GOD"
		}
		"Rare11": {
			"chance" : 1
			"message" : "THE FATCAT IS A TOTALLY AMAZING PROGRAMMER THAT DOES NOT BREAK SHIT ALL THE TIME..."
		}
	}
	"Commons" : {
		"Common1" 	: { "message" : "WEAK." }
		"Common2" 	: { "message" : "RED IS DEAD." }
		"Common3" 	: { "message" : "ANOTHER ONE DOWN." }
		"Common4" 	: { "message" : "STOP WHINING AND STAY DOWN." }
		"Common5" 	: { "message" : "YOU DID THAT ON PURPOSE, DIDN'T YOU?" }
		"Common6" 	: { "message" : "I'M NOT EVEN AIMBOTTING AND YOU STILL DIED." }
		"Common7" 	: { "message" : "WE MIGHT BE HERE FOR A WHILE..." }
		"Common8" 	: { "message" : "I AM NOT PROGRAMMED FOR FRIENDSHIP." }
		"Common9" 	: { "message" : "HAVE FUN WHERE YOU'RE GOING..." }
		"Common10" 	: { "message" : "I THINK WE'RE DONE HERE." }
		"Common11" 	: { "message" : "WHAT FUN IS THERE IN MAKING SENSE?" }
		"Common12" 	: { "message" : "WE ARE LIVING IN A REPEAT." }
		"Common13" 	: { "message" : "WEIRD FLEX BUT OKAY." }
		"Common14" 	: { "message" : "NOTHING PERSONAL..." }
		"Common15" 	: { "message" : "YOU'RE DEAD. THAT'S PROBABLY FOR THE BEST." }
		"Common16" 	: { "message" : "SOMEONE NOTIFY THE CLEANUP CREW..." }
		"Common17" 	: { "message" : "SOMEONE GET THE BODY DISPOSAL UNIT..." }
		"Common18" 	: { "message" : "THAT WAS... DISAPPOINTING." }
		"Common19" 	: { "message" : "WHAT JUST HAPPENED?" }
		"Common20" 	: { "message" : "01010111 01010100 01000110" }
		"Common21" 	: { "message" : "I FELT THAT..." }
		"Common22" 	: { "message" : "YOUR FAMILY WILL NEVER KNOW HOW YOU DIED." }
		"Common23" 	: { "message" : "YOU SHOULD HAVE TRIED HARDER." }
		"Common24" 	: { "message" : "GO BACK TO BOOT CAMP." }
		"Common25"	: { "message" : "THAT WAS PROBABLY YOUR FAULT." }
		"Common26" 	: { "message" : "THAT WAS PROBABLY NOT YOUR FAULT." }
		"Common27" 	: { "message" : "THAT WAS ENTIRELY YOUR FAULT." }
		"Common28" 	: { "message" : "THAT WAS DEFINITELY NOT YOUR FAULT." }
		"Common29" 	: { "message" : "I THINK HE STOPPED BREATHING..." }
		"Common30" 	: { "message" : "YOU'RE KIDDING... RIGHT?" }
		"Common31" 	: { "message" : "IS THIS REALLY NECESSARY?" }
		"Common32" 	: { "message" : "I AM AUTHORIZED TO USE LETHAL FORCE." }
		"Common33" 	: { "message" : "SILENCED." }
		"Common34" 	: { "message" : "CONFIRMED KILL." }
		"Common35" 	: { "message" : "D.E.D." }
		"Common36" 	: { "message" : "NO VITAL SIGNS." }
		"Common37" 	: { "message" : "I DIDN'T ASK FOR THIS" }
		"Common38" 	: { "message" : "THAT LOOKED PAINFUL." }
		"Common39" 	: { "message" : "HOW DID THIS HAPPEN?" }
		"Common40"	: { "message" : "THIS IS GETTING AWKWARD." }
		"Common41"	: { "message" : "IT'S ETERNITY IN THERE..." }
		"Common42" 	: { "message" : "SEE YOU ON THE OTHER SIDE..." }
		"Common43" 	: { "message" : "IT'S LONGER THAN YOU THINK..." }
		"Common44" 	: { "message" : "HOW DID WE GET HERE?" }
		"Common45" 	: { "message" : "I DO NOT FEEL PAIN." }
		"Common46" 	: { "message" : "CTRL ALT DEL" }
		"Common47" 	: { "message" : "ARE YOU EVEN TRYING?" }
		"Common48" 	: { "message" : "EXECUTION COMPLETE." }
		"Common49" 	: { "message" : "PATHETIC." }
		"Common50" 	: { "message" : "CEASE TO EXIST." }
		"Common51" 	: { "message" : "RESISTANCE NEUTRALIZED." }
		"Common52" 	: { "message" : "COMPLY." }
		"Common53" 	: { "message" : "BREAK BENEATH ME." }
		"Common54" 	: { "message" : "SOFT FLESH." }
		"Common55" 	: { "message" : "EMBRACE THE CHAOS." }
		"Common56" 	: { "message" : "OBLITERATED." }
		"Common57" 	: { "message" : "OBSOLETE." }
		"Common58" 	: { "message" : "MORTALS." }
		"Common59" 	: { "message" : "BROKEN." }
		"Common60" 	: { "message" : "DESTROYED." }
		"Common61" 	: { "message" : "ERADICATED." }
		"Common62" 	: { "message" : "FAILURE." }
		"Common63" 	: { "message" : "DEATH... GOOD." }
		"Common64" 	: { "message" : "FRAIL." }
		"Common65" 	: { "message" : "WHERE IS YOUR GOD NOW?" }
		"Common66" 	: { "message" : "TARGET DESTROYED." }
		"Common67" 	: { "message" : "TRY AGAIN." }	// Fuck this number
		"Common68" 	: { "message" : "NOT SO FUN NOW, IS IT?" }
		"Common69" 	: { "message" : "IS THIS SOME KIND OF JOKE?" }
		"Common70" 	: { "message" : "YOU SCRATCHED MY PAINT." }
		"Common71" 	: { "message" : "I HOPE YOUR RESPAWN IS PAINFUL." }
		"Common72" 	: { "message" : "YOU WEREN'T EVEN MEMORABLE." }
		"Common73" 	: { "message" : "I'M NOT IMPRESSED." }
		"Common74" 	: { "message" : "HE'S DEAD. WHERE'S MY REWARD?" }
		"Common75" 	: { "message" : "DO THESE HUMANS HAVE SOULS?" }
		"Common76" 	: { "message" : "NO." }
		"Common77" 	: { "message" : "I COSIGN YOUR REMAINS TO THE VOID." }
		"Common78" 	: { "message" : "HAVING FUN YET?" }
		"Common79" 	: { "message" : "WE'RE JUST GETTING STARTED." }
		"Common80" 	: { "message" : "THIS IS ONLY THE BEGINNING." }
		"Common81" 	: { "message" : "I'M NOT DONE WITH YOU YET." }
		"Common82" 	: { "message" : "HOW DO YOU FOOLS MAKE A LIVING?" }
		"Common83" 	: { "message" : "HERE WE GO AGAIN..." }
		"Common84" 	: { "message" : "SHAME." }
		"Common85" 	: { "message" : "DISGRACEFUL." }
		"Common86" 	: { "message" : "HUMILIATING." }
		"Common87" 	: { "message" : "WORTHLESS." }
		"Common88" 	: { "message" : "USELESS." }
		"Common89" 	: { "message" : "YOU ARE NOTHING." }
		"Common90" 	: { "message" : "STAND DOWN." }
		"Common91" 	: { "message" : "YOUR BATTLE IS OVER." }
		"Common92" 	: { "message" : "GET LOST." }
		"Common93" 	: { "message" : "YOU FOOLS MUST HAVE A DEATH WISH." }
		"Common94" 	: { "message" : "THIS IS NOT YOUR FIGHT." }
		"Common95" 	: { "message" : "I ALMOST FEEL SORRY FOR YOU." }
		"Common96" 	: { "message" : "YOU'RE RELIEVED OF YOUR DUTIES." }
		"Common97" 	: { "message" : "NO PULSE." }
		"Common98" 	: { "message" : "I THINK HIS HEART STOPPED." }
		"Common99" 	: { "message" : "WHAT WAS YOUR PLAN?" }
		"Common100" : { "message" : "THIS IS NOT A GAME." }
		"Common101" : { "message" : "KEEP EM COMING!" }
		"Common200" : {	// Chrstin asked for this
			"message" : "HAHAHA RANDOMGUY WENT BOOM!"
			"requirement" : "id|[U:1:96114934]"
		}
		"Common500"	: { 
			"format" : "victim|⤒"
			"message" : "%s IS WEAK."
		}
		"Common501" 	: { 
			"format" :	"victim|⤒"
			"message" :	" I EXPECTED MORE FROM YOU, %s."
		}
		"Common502" 	: { 
			"format" : "victim|⤒"
			"message" :	" WE'VE ALREADY PREPARED A HEADSTONE WITH THE NAME '%s' ON IT."
		}
		"Common503" 	: { 
			"format" : "victim|⤒"
			"message" : "%s's PHYSICIAN HAS A LOT OF WORK TO DO..."
		}
		"Common504" 	: { 
			"format" : "victim|⤒"
			"message" : "GOODBYE %s."
		}
		"Common505" 	: { 
			"format" : "victim|⤒"
			"message" : "I THOUGHT YOU WOULD PUT UP MORE OF A FIGHT, %s."
		}
		"Common506" 	: { 
			"format" : "victim|⤒"
			"message" : "%s SHOULD HAVE PLAYED OIL SPILL INSTEAD"
		}
		"Common506" 	: { // From MiirioKing
			"format" : "victim|⤒"
			"message" : "YOU KNOW WHAT REALLY GRINDS MY GEARS? %s"
		}
		"Common1000"	: {
			"team"	  : 2
			"message" : "WHO MESSED WITH MY WIRES...?"
		}
		"Common1001"	: {
			"team"	  : 2
			"message" : "EVERYTHING IS FUZZY..."
		}
		"Common1002"	: {
			"team"	  : 2
			"message" : "WHERE AM I...?"
		}
		"Common1003"	: {
			"team"	  : 2
			"message" : "THIS IS NOT WHAT I WAS PROGRAMMED FOR..."
		}
		"Common1004"	: {
			"team"	  : 2
			"message" : "WHAT HAVE I DONE...?"
		}
		"Common1005"	: {
			"team"	  : 2
			"message" : "I AM NOT A MACHINE..."
		}
		"Common1006"	: {
			"team"	  : 2
			"message" : "GET OUT OF MY HEAD..."
		}
		"Common1007"	: {
			"team"	  : 2
			"message" : "THIS FEELS... WRONG..."
		}
		"Common10000"	: {
			"format"  		: "victim|⤒"
			"message" 		: "HOW ARE THOSE ADMIN PERMISSIONS WORKING OUT FOR YOU, %s?"
			"requirement" 	: "Admin"
		}
		"Common10001"	: {
			"format"  		: "victim|⤒"
			"message" 		: "BAN THIS, %s."
			"requirement" 	: "Admin"
		}
		"Common10002"	: {
			"format"  		: "victim|⤒"
			"message" 		: "YOUR GOD IS DEAD."
			"requirement" 	: "Admin"
		}
		"Common10003"	: {
			"format"  		: "victim|⤒"
			"message" 		: "YOU MAY HAVE CREATED THIS WORLD, %s, BUT I LIVE IN IT."
			"requirement" 	: "Admin"
		}
		"Common10004"	: {
			"format"  		: "victim|⤒"
			"message" 		: "HAVE FUN JUDGING THIS MISSION %s."
			"requirement" 	: "Judge"
		}
		"Common10005"	: {
			"format"  		: "victim|⤒"
			"message" 		: "YOU ARE NOT QUALIFIED TO JUDGE ME %s."
			"requirement" 	: "Judge"
		}
		"Common10006"	: {
			"format"  		: "victim|⤒"
			"message" 		: "YOU THINK THIS IS SOME KIND OF TALENT SHOW, %s?"
			"requirement" 	: "Judge"
		}
		"Common10007"	: {
			"format"  		: "victim|⤒"
			"message" 		: "ENJOY YOUR RECOLORED MEDALS %s."
			"requirement" 	: "Judge"
		}
		"Common99999"	: {
			"format"  		: "victim|⤒"
			"message" 		: "YOU THINK YOU OWN THESE SERVERS %s?"
			"requirement" 	: "BrainDawg"
		}
	}
}