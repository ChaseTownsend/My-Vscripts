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
}

class Gamerules {
	/** 
	 * @type {CBaseEntity|null} 
	*/
	static m_hOuter = null

	/** 
	 * Table of `BotUpgrade`
	 * 
	 * @type {table}
	*/
	static m_Upgrades = {}

	static m_iBotCurrency = 0
	static m_iStartingCurrency = 0
	static m_iLevelUpCurrency = 0


	static m_iExperienceNeeded = 0
	static m_iExperienceLevel = 0
	static m_iLevel = 0

	/** 
	 * @type {function}
	 * @param {CBaseEntity|null} outer
	 */
	constructor(outer)
	{
		this.m_hOuter = outer
		this.m_Upgrades = {}

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
		m_iExperienceNeeded -= amount
		if(m_iExperienceNeeded <= 0)
			LevelUp()
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
		m_iExperienceNeeded = m_iExperienceLevel + 50 // todo: val
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
		local scope = GetScope(bot)
	}

	function GrantBotUpgrade()
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

local BOT_BODY_UPGRADES = {
	HEALTH_UPGRADE = {
		attribute = "max health additive bonus"
		cap = 5000
		increment = 50
		cost = 300
		default_value = 0
	}
	RES_UPGRADE = {
		attribute = "dmg taken increased"
		cap = 0.1
		increment = -0.15
		cost = 400
		default_value = 1.0
	}
	CRIT_RES_UPGRADE = {
		attribute = "dmg taken from crit reduced"
		cap = 0.1
		increment = -0.30
		cost = 200
		default_value = 1
	}
	SPEED_UPGRADE = {
		attribute = "move speed bonus"
		cap = 1.5
		increment = 0.1
		cost = 100
		default_value = 1
	}
	UNIVERSAL_FIRE_RATE_UPGRADE = {
		attribute = "halloween fire rate bonus"
		cap = 0.2
		increment = -0.2
		cost = 250
		default_value = 1
	}
	UNIVERSAL_RELOAD_SPEED_UPGRADE = {
		attribute = "halloween reload time decreased"
		cap = 0.1
		increment = -0.15
		cost = 200
		default_value = 1
	}
}