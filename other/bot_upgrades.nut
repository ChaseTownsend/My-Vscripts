if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")


class BotUpgrade {
	/** 
	 * @type {string} 
	*/
	attribute = ""

	/** 
	 * @type {float} 
	*/
	cap = 0.0

	/** 
	 * @type {float} 
	*/
	increment = 0.0

	/** 
	 * @type {float} 
	*/
	cost = 0.0
	
	/** 
	 * @type {float} 
	*/
	default_value = 0.0

	/** 
	 * @type {function}
	 * @param {table} data
	 */
	constructor(data)
	{
		foreach (key, value in data)
		{
			if(key in this)
				this[key] = value
		}
	}

	function CanBuyUpgrade(money) {return money >= cost}
}

class LevelSystem {
	experience_needed = 0
	experience_for_level = 50
	experience_cap_per_level = 50

	level = 0

	OtherLevelFunc = null

	/** 
	 * @type {function}
	 * @param {integer} cap
	 * @param {integer} per_lvl
	 * @param {function|null} lvl_func
	 */
	constructor(cap, per_lvl, lvl_func = null)
	{
		this.level = 1
		this.experience_for_level = cap
		this.experience_cap_per_level = per_lvl
		this.experience_needed = this.experience_for_level

		if(lvl_func)
			this.OtherLevelFunc = lvl_func
	}

	function AddExp(amount)
	{
		experience_needed -= amount

		if(ShouldLevelup())
		{
			while(ShouldLevelup())
			{
				LevelUp()
			}
		}
	}

	function ShouldLevelup()
	{
		return experience_needed <= 0
	}

	function LevelUp()
	{
		level ++
		experience_for_level += experience_cap_per_level
		// should really be `=` but this should "allow" multiple levels to be givven at once
		experience_needed += experience_for_level

		if(OtherLevelFunc)
			OtherLevelFunc()
	}
}

class Gamerules {
	/** 
	 * @type {CBaseEntity|null} 
	*/
	static m_hOuter = null

	/** 
	 * Table of `BotUpgrade`
	 * 
	 * 
	 * 
	 * @type {table}
	*/
	static m_Upgrades = {}

	/** @type {LevelSystem} */
	static Leveling = null

	static m_iBotCurrency = 0
	static m_iStartingCurrency = 0
	static m_iLevelUpCurrency = 0

	/** 
	 * @type {function}
	 * @param {CBaseEntity|null} outer
	 */
	constructor(outer)
	{
		this.m_hOuter = outer
		this.m_Upgrades = {}

		this.Leveling = LevelSystem(50, 15, LevelUp)

		Setup()
	}

	/** 
	 * @param {integer} amount
	*/
	function AddCurrency(amount)
	{
		m_iBotCurrency += amount
	}

	/** 
	 * @param {integer} amount
	*/
	function AddExperience(amount)
	{
		Leveling.AddExp(amount)
	}

	/** 
	 * @param {integer} amount
	*/
	function SetStartingCash(amount)
	{
		m_iStartingCurrency = amount
		m_iBotCurrency = amount
	}

	/** 
	 * @param {integer} amount
	*/
	function SetPerLevelCash(amount)
	{
		m_iLevelUpCurrency = amount
	}

	/** 
	 * @param {string} name
	 * @param {string} attrib
	 * @param {integer|float} cap
	 * @param {integer|float} inc
	 * @param {integer|float} cost
	 * @param {integer|float} def
	 */
	function DefineUpgrade(name, attrib, cap, inc, cost, def)
	{
		m_Upgrades[name] <- BotUpgrade({
			attribute = attrib,
			cap = cap,
			increment = inc,
			cost = cost,
			default_value = def
		})
	}

	/** 
	 * @param {CTFBot} bot
	 */
	function OnBotDeath(bot)
	{
		AddExperience(GetScope(bot).m_iExperience)
	}

	function LevelUp()
	{
		AddCurrency(m_iLevelUpCurrency)
	}

	function Setup()
	{
	}

	/** 
	 * @param {CTFBot} bot
	 */
	function OnBotSpawn(bot)
	{
		bot.SetCurrency(m_iBotCurrency)
		GrantBotUpgrades(bot)
		// local scope = GetScope(bot)
	}

	/** 
	 * @param {CTFBot} bot
	 */
	function GrantBotUpgrades(bot)
	{
		while (bot.GetCurrency() >= 150)
		{
			
			/* class BotUpgrade {
				cost: float,
				default_value: float,
				attribute: string,
				cap: float,
				increment: float,

				CanBuyUpgrade: function
			} */
			
			foreach (/**@type {string} */_name, /**@type {BotUpgrade}*/upgrade in m_Upgrades)
			{
				if(upgrade.CanBuyUpgrade(bot.GetCurrency()))
				{
					GrantUpgrade(bot, upgrade)
				}
			}
		}
	}

	/** 
	 * @type {function}
	 * @param {CTFBot} bot
	 * @param {BotUpgrade} upgrade
	 */
	function GrantUpgrade(bot, upgrade)
	{
		/* class BotUpgrade {
			cost: float,
			default_value: float,
			attribute: string,
			cap: float,
			increment: float,

			CanBuyUpgrade: function
		} */
		if(default_value == 1.0)
		{
		}
		else if(default_value == 0)
		{

		}
	}
}

::GameruleEntity <- Gamerules(FindByClassname(null, "tf_gamerules"))

Gamerules.SetStartingCash(500)
Gamerules.SetPerLevelCash(500)

Gamerules.DefineUpgrade("health", "max health additive bonus", 5000, 50, 300, 0)
Gamerules.DefineUpgrade("resistance", "dmg taken increased", 0.1, -0.15, 450, 1.0)
Gamerules.DefineUpgrade("crit_res", "dmg taken from crit reduced", 0.1, -0.3, 200, 1.0)
Gamerules.DefineUpgrade("speed", "move speed bonus", 1.6, 0.15, 150, 1.0)
Gamerules.DefineUpgrade("firerate", "halloween fire rate bonus", 0.1, -0.1, 150, 1.0)
Gamerules.DefineUpgrade("reloadrate", "halloween reload time decreased", 0.1, -0.15, 150, 1.0)

// local BOT_BODY_UPGRADES = {
// 	HEALTH_UPGRADE = {
// 		attribute = "max health additive bonus"
// 		cap = 5000
// 		increment = 50
// 		cost = 300
// 		default_value = 0
// 	}
// 	RES_UPGRADE = {
// 		attribute = "dmg taken increased"
// 		cap = 0.1
// 		increment = -0.15
// 		cost = 400
// 		default_value = 1.0
// 	}
// 	CRIT_RES_UPGRADE = {
// 		attribute = "dmg taken from crit reduced"
// 		cap = 0.1
// 		increment = -0.30
// 		cost = 200
// 		default_value = 1
// 	}
// 	SPEED_UPGRADE = {
// 		attribute = "move speed bonus"
// 		cap = 1.5
// 		increment = 0.1
// 		cost = 100
// 		default_value = 1
// 	}
// 	UNIVERSAL_FIRE_RATE_UPGRADE = {
// 		attribute = "halloween fire rate bonus"
// 		cap = 0.2
// 		increment = -0.2
// 		cost = 250
// 		default_value = 1
// 	}
// 	UNIVERSAL_RELOAD_SPEED_UPGRADE = {
// 		attribute = "halloween reload time decreased"
// 		cap = 0.1
// 		increment = -0.15
// 		cost = 200
// 		default_value = 1
// 	}
// }