IncludeScript("fatcat_library")

// const CUSTOM_UBER_THINK_DELAY = 0.025
const CUSTOM_UBER_THINK_DELAY = -1

::spawn <- {
	function OnScriptEvent_HumanResupply(params)
	{
		local weapon = params.player.GetWeaponInSlotNew(SLOT_SECONDARY)
		if(weapon.GetIDX() == 29 || weapon.GetIDX() == 961)
		{
			weapon.AddAttribute("uber duration bonus", 0, 0)
			weapon.AddAttribute("ubercharge rate bonus", 100000000, 0)
			weapon.AddAttribute("medigun charge is crit boost", 6, 0)
			weapon.AddAttribute("uber duration bonus", 0, 0)


			GetScope(weapon).UberThink <- function() {
				local medic = self.GetOwner()
				local target = GetPropEntity(self, "m_hHealingTarget")
				if ( target ) SetPropBool(target, "m_bForcePurgeFixedupStrings", true)

				// local ChargeType = "Condition"
				// local ChargeType = "Healing" // Use with low uber duration!, use -7.5
				//local ChargeType = "Attribute"
				local ChargeType = "Funny"

				// Condition is [ cond# ]
				// Healing is 	[ health to give ]
				// Attribute is [ Attribute, Attribute value ]
				local list = [ 50 ]

				if( !medic.IsUberDraining() ) return CUSTOM_UBER_THINK_DELAY
				if( self.IsHolstered() ) return CUSTOM_UBER_THINK_DELAY

				if(ChargeType == "Condition")
				{
					medic.AddCondEx(list[0], CUSTOM_UBER_THINK_DELAY * 3, medic)

					if ( target )
						target.AddCondEx(list[0], CUSTOM_UBER_THINK_DELAY * 3, medic)
				}

				if(ChargeType == "Healing")
				{
					medic.SetHealth(medic.GetHealth() + list[0])

					if ( target )
						target.SetHealth(target.GetHealth() + list[0])
					self.SetUberChargePercent(0.00)
					EntFireByHandle(self, "runscriptcode", "self.SetUberChargePercent(70.0)", 0.05, null, null)
				}

				if(ChargeType == "Attribute")
				{
					medic.AddCustomAttribute(list[0], list[1], CUSTOM_UBER_THINK_DELAY * 2)

					if ( target )
						target.AddCustomAttribute(list[0], list[1], CUSTOM_UBER_THINK_DELAY * 2)
				}

				if(ChargeType == "Funny")
				{
					CreateAoETable({
						owner = medic, 
						center = medic.GetOrigin(), 
						radius = 500,
						maxDmg = 500, 
						minDmg = 500, 
						ignore = [medic, target]
						dmg_Type = DMG_BLAST|DMG_PREVENT_PHYSICS_FORCE,
						sound = "weapons/explode1.wav",
						particle = "ExplosionCore_Wall"
					})
					self.SetUberChargePercent(0.00)

					/* medic.TakeDamageCustom(medic, medic, self, Vector(), Vector(), 100000, DMG_BLAST, TF_DMG_CUSTOM_AEGIS_ROUND)

					if ( target )
						target.TakeDamageCustom(medic, medic, self, Vector(), Vector(), 100000, DMG_BLAST, TF_DMG_CUSTOM_AEGIS_ROUND) */
				}
				return CUSTOM_UBER_THINK_DELAY
			}
			RunWithDelay(@() AddThinkToEnt(weapon, "UberThink"), 0.1)
		}
	}
}
__CollectGameEventCallbacks(spawn)
