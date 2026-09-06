
ReCalculatePlayers()

if(!IsValidPlayer(Host)) {
	foreach (player in Players) {
		if(player.IsAdmin()) {
			::Host <- player
			break
		}
	}
}

/** 
 * @var {CTFPlayer} self
 */
function fuck() {
	local wep = self.GetActiveWeapon()

	local scope = GetScope(wep)
	if(!("Last_Attack" in scope))
		scope.Last_Attack <- 0.0

	if(wep.GetNextAttack() != scope.Last_Attack) {
		local message = "Next Attack : %.04f\n%s Last attack Delta  :  %.04f"

		// message += "\n Reloading : " + GetPropBool(self.GetWeaponInSlotNew(0), "m_bInReload")
		// message += "\nPlayback Rate : " + GetPropInt(wep, "m_nSequence")
		message += "\nButtons : " + GetPropInt(self, "m_nButtons")

		// foreach (weapon in self.GetAllWeapons()) {
			// message += "\n" + GetPropFloat(weapon, "LocalWeaponData.m_flAnimTime")
		// }

		self.PrintToHudF(message, GetPropFloat(self, "m_flNextAttack")-Time(), wep.tostring(), (wep.GetNextAttack() - scope.Last_Attack))
	}
	
	scope.Last_Attack <- wep.GetNextAttack()

	// local Viewmodel = GetPropEntityArray(self, "m_hViewModel", 0)
	// self.PrintToHud(GetPropFloat(Viewmodel, "m_flPlaybackRate"))

	// m_flPlaybackRate

	return -1
}

Host.AddThink(fuck, "fuck")