IncludeScript("fatcat_library")

local kRageBuffFlag_None = 0

enum buff_type
{
	kRageBuffFlag_None = 0x00,
	kRageBuffFlag_OnDamageDealt = 0x01,
	kRageBuffFlag_OnDamageReceived = 0x02,
	kRageBuffFlag_OnMedicHealingReceived = 0x04,
	kRageBuffFlag_OnBurnDamageDealt = 0x08,
	kRageBuffFlag_OnHeal = 0x10
}

// g_RageBuffTypes[iBuffId].m_fRageScale
local g_RageBuffTypes = [
	{ m_fRageScale = 0.0, 	m_nMaxPulses = 10 } // unknown/default
	{ m_fRageScale = 1.0, 	m_nMaxPulses = 10 }	// buff type 1
	{ m_fRageScale = 1.0, 	m_nMaxPulses = 10 }	// buff type 2
	{ m_fRageScale = 1.25,	m_nMaxPulses = 10 }	// buff type 3
	{ m_fRageScale = 1.0,	m_nMaxPulses = 10 }	// buff type 4
	{ m_fRageScale = 1.0,	m_nMaxPulses = 10 }	// pyro rage
	{ m_fRageScale = 1.0,	m_nMaxPulses = 10 }	// medic healing
	{ m_fRageScale = 1.0,	m_nMaxPulses = 10 }	// Start of Custom
]


::spawn <- {
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if (!player) return

		local weapon = player.GetWeaponInSlot(1)
		if(GetWeaponIDX(weapon) == 354)
		{
			weapon.AddAttribute("mod soldier buff type", 7, 0)
			weapon.ValidateScriptScope()
			weapon.GetScriptScope().Think <- function() {
				local Soldier = self.GetOwner()
				local range = 450 // No Way of reading range attribute

				local BannerType = "Condition"
				//local BannerType = "Healing"
				//local BannerType = "Attribute"

				// Condition is [ cond# ]
				// Healing is 	[ health to give, overheal player? ]
				// Attribute is [ Attribute, Attribute value ]

				local value_list = [ 11 ]

				if( !Soldier.IsRageDraining() ) return 0.1

				foreach (player in Soldier.GetEveryPlayerWithin(range, true))
				{
					if(!player.IsValid()) continue
					if(!player.IsAlive()) continue

					if(BannerType == "Condition") player.AddCondEx(value_list[0], 0.125, Soldier)

					if (BannerType == "Healing")
					{
						if(value_list[1]) player.SetHealth(player.GetHealth() + value_list[0])
						else { if (!player.IsOverhealed()) { player.SetHealth(player.GetHealth() + value_list[0]) } }
					}

					if(BannerType == "Attribute") player.AddCustomAttribute(value_list[0], value_list[1], 0.1)
				}

				return 0.1
			}
			AddThinkToEnt(weapon, "Think")

		}
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		local hVictim = params.const_entity
		local hAttacker = params.attacker
		local hWeapon = params.weapon

		if( !hVictim.IsPlayer() )
			return
		
		if( !hAttacker.IsPlayer() )
			return

		if( hWeapon == null )
			return

		local iBuffId = hAttacker.GetWeaponInSlotNew(1).GetAttribute("mod soldier buff type", 0)
		if( iBuffId <= 6)
			return

		// g_RageBuffTypes[iBuffId].m_fRageScale * ((params.damage * hVictim.GetCustomAttribute("rage giving scale", 1)) / 6)
		hAttacker.ModifyRage(g_RageBuffTypes[iBuffId].m_fRageScale * ((params.damage * hVictim.GetCustomAttribute("rage giving scale", 1)) / 6))
	}
}
__CollectGameEventCallbacks(spawn)


::CTFPlayer.ModifyRage <- function( delta )
{
	this.SetRageMeter((this.GetRageMeter() + delta) > 100 ? 100 : this.GetRageMeter() + delta)
}