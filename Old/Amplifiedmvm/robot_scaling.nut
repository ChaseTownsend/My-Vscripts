IncludeScript("fatcat_library")

const FORCE = 0
const HEALTH = 1

local ScalingSets = [
	[/* DUMMY SET 1 */],
	[/* DUMMY SET 2 */],
	[/* DUMMY SET 3 */],
	[/* DUMMY SET 4 */],
	// 5 Waves
	[	
		[1.00,	1.00], 	/* Wave 1 */
		[0.8, 	2.15],	/* Wave 2 */
		[0.55,	4.62],	/* Wave 3 */
		[0.35, 	9.95],	/* Wave 4 */
		[0.15, 	21.35],	/* Wave 5 */
	],
	// 6 Waves
	[	
		[1.00, 	1.00],	/* Wave 1 */
		[0.85, 	1.85],	/* Wave 2 */
		[0.70, 	3.42],	/* Wave 3 */
		[0.55, 	6.35],	/* Wave 4 */
		[0.35, 	11.72],	/* Wave 5 */
		[0.15, 	21.50],	/* Wave 6 */
	],
	// 7 Waves
	[	
		[1.00, 	1.00],	/* Wave 1 */
		[0.9, 	1.65],	/* Wave 2 */
		[0.75, 	2.72],	/* Wave 3 */
		[0.65, 	4.50],	/* Wave 4 */
		[0.50, 	7.41],	/* Wave 5 */
		[0.3, 	12.23],	/* Wave 6 */
		[0.10, 	20.50],	/* Wave 7 */
	],
	// 8 Waves
	[	
		[1.00, 	1.00],	/* Wave 1 */
		[0.90, 	1.55],	/* Wave 2 */
		[0.75, 	2.40],	/* Wave 3 */
		[0.60, 	3.72],	/* Wave 4 */
		[0.50, 	5.75],	/* Wave 5 */
		[0.40, 	9.95],	/* Wave 6 */
		[0.25, 	13.85],	/* Wave 7 */
		[0.10, 	21.00],	/* Wave 8 */
	],
	// 9 Waves
	[	
		[1.00, 	1.00],	/* Wave 1 */
		[0.90, 	1.46],	/* Wave 2 */
		[0.80, 	2.13],	/* Wave 3 */
		[0.70, 	3.11],	/* Wave 4 */
		[0.55, 	4.54],	/* Wave 5 */
		[0.45, 	6.63],	/* Wave 6 */
		[0.30, 	9.68],	/* Wave 7 */
		[0.20, 	14.15],	/* Wave 8 */
		[0.10, 	20.65],	/* Wave 9 */
	],
	// 10 Waves
	[	
		[1.00, 	1.00],	/* Wave 1 */
		[0.90, 	1.40],	/* Wave 2 */
		[0.80, 	1.96],	/* Wave 3 */
		[0.70, 	2.74],	/* Wave 4 */
		[0.60, 	3.84],	/* Wave 5 */
		[0.50, 	5.38],	/* Wave 6 */
		[0.40, 	7.53],	/* Wave 7 */
		[0.30, 	1.054],	/* Wave 8 */
		[0.20, 	14.75],	/* Wave 9 */
		[0.10, 	20.65],	/* Wave 10 */
	],
]
// ScalingSets[max_waves][cur_wave][FORCE]
// ScalingSets[max_waves][cur_wave][HEALTH]

function ApplyScaling()
{
	if(self.HasBotTag("IgnoreScaling") || self.HasBotTag("Scaled!")) return
	local Max_Wave = GetMaximumWaveNumber()
	local cur_wave = GetCurrentWaveNumber()

	local force_mult = ScalingSets[Max_Wave-1][cur_wave-1][FORCE]
	local health_mult = ScalingSets[Max_Wave-1][cur_wave-1][HEALTH] - 1 // for base health mult

	self.AddCustomAttribute("damage force reduction", force_mult, -1)
	self.AddCustomAttribute("rage giving scale", force_mult, -1)
	self.AddCustomAttribute("hidden maxhealth non buffed", self.GetMaxHealth() * health_mult, -1)
	self.SetHealth(self.GetMaxHealth())
	self.AddBotTag("Scaled!")

	/* PrintToChatAll("Added \"damage force reduction\" with value " + force_mult + " To bot " + self)
	PrintToChatAll("Added \"rage giving scale\" with value " + force_mult + " To bot " + self)
	PrintToChatAll("Added \"hidden maxhealth non buffed\" with value " + self.GetMaxHealth() * health_mult + " To bot " + self)
	PrintToChatAll("\n") */
}

::scaling <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(!IsPlayerABot(player)) return

		EntFireByHandle(player, "RunScriptCode", "ApplyScaling()", -1, null, null)
	}
}
__CollectGameEventCallbacks(scaling)