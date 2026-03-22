IncludeScript("fatcat_library")

::attributes <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		local attacker = params.attacker
		if (!ArePlayersValid(attacker, params.const_entity)) return

		/////////////
		for (local i = 0; i <= 3 ; i++)
		{
			// Initalize Weapon in that slot
			local weapon = attacker.GetWeaponInSlot(i)
			if( !weapon ) continue
			local weaponIDX = attacker.GetWeaponIDXInSlot(i)
			if ( !weaponIDX ) continue

			// Checks if the weapon in that slot is null
			switch ( weaponIDX ) {
				case TF_WEAPON_TOMISLAV:
				{
					if (GetWeaponIDX(params.weapon) != TF_WEAPON_TOMISLAV) continue
					// The Above line checks if the active item (The one that triggered the event)
					// is the same as this item in this slot

					local scope = GetScope(weapon)
					if(IsNotInScope("Hits", scope))
					{
						scope.Hits <- 1
					}
					else
					{
						scope.Hits++
					}

					/// Format is
					// CalculateAttributes(Attribute, Change, Starting, Max, Min, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("damage bonus", 0.005, 1, 11, 1, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("fire rate bonus", -0.00025, 1, 1, 0.75, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("max health additive bonus", 0.5, 0, 255, 0, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("maxammo primary increased", 0.0005, 1, 2.5, 1, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("restore health on kill", 0.025, 0, 100, 0, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("minigun spinup time decreased", -0.00025, 1, 1, 0.5, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("weapon spread bonus", -0.00025, 1, 1, 0.25, weapon)
					////////////////////////////////////////////////////////////
					CalculateAttributes("dmg taken increased", 0.001, 1, 4, 1, weapon)
					////////////////////////////////////////////////////////////
					if(scope.Hits > 1000)
					{
						Weapon.AddAttribute("Set DamageType Ignite", 1, 0)
					}
					if(scope.Hits > 2000)
					{
						Weapon.AddAttribute("ragdolls become ash", 1, 0)
					}
					if(scope.Hits > 3000)
					{
						Weapon.AddAttribute("turn to gold", 1, 0)
					}
				}
			}
		}
	}
	function OnGameEvent_player_spawn(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if (!player || IsPlayerABot(player)) return

		for (local i = 0; i <= MAX_WEAPONS; i++)
		{
			local weaponIDX = player.GetWeaponIDXInSlot(i)
			switch(weaponIDX)
			{
				case TF_WEAPON_TOMISLAV:
				{
					weapon.AddAttribute("damage bonus", 1, 0)
					weapon.AddAttribute("fire rate bonus", 1, 0)
					weapon.AddAttribute("max health additive bonus", 0, 0)
					weapon.AddAttribute("maxammo primary increased", 1, 0)
					weapon.AddAttribute("restore health on kill", 0, 0)
					weapon.AddAttribute("minigun spinup time decreased", 1, 0)
					weapon.AddAttribute("weapon spread bonus", 1, 0)
					weapon.AddAttribute("dmg taken increased", 1, 0)
					weapon.AddAttribute("minicritboost on kill", 3, 0)
					weapon.RemoveAttribute("Set DamageType Ignite")
					weapon.RemoveAttribute("ragdolls become ash")
					weapon.RemoveAttribute("turn to gold")
					player.SetHealth(player.GetMaxHealth())
					player.Regenerate(true)
				}
			}
		}
	}
}
__CollectGameEventCallbacks(attributes)

function ArePlayersValid(Attacker, victim)
{
	if (!Attacker || Attacker.IsBot() || Attacker.GetTeam() != TF_TEAM_PVE_DEFENDERS) return false

	if(IsValidEnemy(victim))
	{
		if(victim.IsPlayer())
		{
			if (victim.IsInvincible()) return false
		}
		return true
	}
	return false
}
function CalculateAttributes(AttributeName, AttributeChange, StartingValue, MaxValue, MinValue, Weapon)
{
	EndingValue = (Weapon.GetAttribute(AttributeName, StartingValue) + AttributeChange)

	if (EndingValue <= MaxValue || EndingValue >= MinValue ) { Weapon.AddAttribute(AttributeName, EndingValue, 0) }
	if (EndingValue > MaxValue) { Weapon.AddAttribute(AttributeName, MaxValue, 0) }
	if (EndingValue < MinValue) { Weapon.AddAttribute(AttributeName, MinValue, 0) }
}