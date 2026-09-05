if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("EquipCommand", "1.0.0")



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
	OnPlayerEquip = function( player ) {
		// player.FixAmmo()
		RunWithDelay(0.1, @() player.SetHealth(player.GetMaxHealth()) )
	}
	is_segsegv = true
})
RegisterEquipItem(1105, "The Self-Aware Beauty Mark", "mark", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_SNIPER
	}
	OnPlayerEquip = function( player ) {
		player.FixAmmo()
	}
	is_segsegv = true
})
RegisterEquipItem(1121, "Mutated Milk", "mutated", {
	override_func = function( player ) {
		return player.GetPlayerClass() == TF_CLASS_SCOUT
	}
	OnPlayerEquip = function( player ) {
		player.FixAmmo()
	}
	is_segsegv = true
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


AddChatTrigger("equip" function( player, ... ) {
	if (!player)
		return

	local items_per_page = 5

	if (!player.IsTruelyInSpawn())
	{
		player.PrintToChat("\x07ff4444[►] Can't Change loadout outside of Spawn Room.")
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
			player.PrintToChat("\x07ff4444[►] Incorrect Arguments")
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
			player.PrintToChat("\x07ff4444[►] Incorrect Arguments")
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
		player.PrintToChat("\x07ff4444[►] Fist of Steel Blocks Item Creation!")
		return
	}

	foreach (/**@type {integer} */idx, /**@type {EquipWeaponData} */data in RegisteredItems)
	{
		// printf("Processing Item %s, IDX match? %s, Name match? %s.\n", data.internal_name, (item == idx.tostring()).tostring(), (item == data.make_name).tostring())
		if (item == idx.tostring() || item == data.make_name)
		{
			if (data.override_func(player) == false)
				return player.PrintToChatF("\x07ff4444[►] Failed to Meet Requirements for %s", data.internal_name)
			item_data = data
			break
		}
	}

	if (item_data == null)
		return player.PrintToChatF("\x07ff4444[►] Failed to find any items using Input \"%s\", Try Again", item)

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