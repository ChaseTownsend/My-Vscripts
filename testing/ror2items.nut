class ItemData {
	ItemIDX = 0
	ItemName = "BaseItem"
	Texture = RoR2.GetSpriteFromItemName("")
	Rarity = Rarity.Unique
	OnApply = null
	PlayerThink = null

	/** 
	 * @param {integer} idx
	 * @param {string} name
	 * @param {function} apply
	 * @param {function} think
	 */
	constructor(idx, name, Rarity, apply, think) {
		this.ItemIDX = idx
		this.ItemName = name
		this.Texture = RoR2.GetSpriteFromItemName(name)
		this.Rarity = Rarity
		this.OnApply = apply
		this.PlayerThink = think
	}
}


enum Rarity {
	Unique,
	Genuine
}

function AddItem(items, name, data)
{
	items[name] <- data
}

function InitItems() {
    local items = {}
    // name : data
	// AddItem(items, "BaseItem")
	items["BaseItem"] <- ItemData(0, "BaseItem", Rarity.Unique, function(plr, count) {
		plr.AddCustomAttribute("max health additive bonus", 35+(25*count), -1)
	}, null)
	items["SpeedBoots"] <- ItemData(0, "SpeedBoots", Rarity.Unique, function(plr, count) {
		plr.AddCustomAttribute("move speed bonus", 1+(0.1*count), -1)
		plr.TeamFortress_SetSpeed()
		RoR2.PlayerToPlayerData(plr).AdjustDodgeChance()
	}, null)
	items["Melee Specialist"] <- ItemData(0, "Melee Specialist", Rarity.Unique, function(plr, count) {
		/** @type {CTFWeaponBase|null} */
		local weapon = plr.GetWeaponInSlotNew(SLOT_MELEE)
		if(!weapon)
			return
		weapon.AddAttribute("CARD: damage bonus", 1+(0.3 * count.tofloat()), 0)
	}, null)
	items["Medival Specialist"] <- ItemData(0, "Medival Specialist", Rarity.Unique, function(plr, count) {
		/** @type {CTFWeaponBase|null} */
		local weapon = plr.GetWeaponInSlotNew(SLOT_MELEE)
		if(!weapon)
			return
		if(count == 1)
		{	// TODO: MAKE IT GIVE LESS AND LESS
			weapon.AddAttribute("melee attack rate bonus", 0.8, 0)
			return
		}

		weapon.AddAttribute("melee attack rate bonus", weapon.GetAttribute("melee attack rate bonus", 1.0) * 0.9, 0)
					
		// .AddAttribute()
		// plr.AddCustomAttribute("move speed bonus", 1+(0.1*count), -1)
		// plr.TeamFortress_SetSpeed()
		// RoR2.PlayerToPlayerData(plr).AdjustDodgeChance()
	}, null)


	foreach (k, v in items) {
		items[k] <- v
		// delete items[k]
	}

	return items
}