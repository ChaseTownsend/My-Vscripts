// My Custom Script Library
IncludeScript("fatcat_library")

::Spells <- {
	function OnGameEvent_player_death(params)
	{
		if(!params.attacker) return
		local player = GetPlayerFromUserID(params.attacker)
		if(!player || IsPlayerABot(player)) return

		if(GetPlayerFromUserID(params.userid) == player) return // No Self Kills!

		local Killed_WeaponIDX = params.weapon_def_index
		local Weapon_LogName = params.weapon_logclassname

		if (Weapon_LogName == "lollichop")
		{
			if ((params.kill_streak_wep % 10) != 0) return

			local spell_book = player.GetSpellBook()
			if (!spell_book) return


			local Spell_to_Grant = TF_SPELL_METEOR
			local Spell_Index = GetSpellIndex(spell_book)
			local Spell_Charges = GetSpellCharges(spell_book)

			if (Spell_Charges < 1)
			{
				SetSpellIndex(spell_book, Spell_to_Grant)
				IncrementSpellCharge(spell_book, 1)
				return
			}
			if (Spell_Index == Spell_to_Grant && Spell_Charges < 2) IncrementSpellCharge(spell_book, 1)
		}

		/////////////////////////// SHORT CIRCUIT ///////////////////////////

		if (Killed_WeaponIDX == TF_WEAPON_SHORT_CIRCUT && (Weapon_LogName == "short_circuit" || Weapon_LogName == "tf_projectile_mechanicalarmorb"))
		{
			if ((params.kill_streak_wep % 10) != 0) return

			local spell_book = player.GetSpellBook()
			if (!spell_book) return


			local Spell_to_Grant = TF_SPELL_LIGHTNING
			local Spell_Index = GetSpellIndex(spell_book)
			local Spell_Charges = GetSpellCharges(spell_book)

			if (Spell_Charges < 1)
			{
				SetSpellIndex(spell_book, Spell_to_Grant)
				IncrementSpellCharge(spell_book, 1)
				return
			}
			if (Spell_Index == Spell_to_Grant && Spell_Charges < 2) IncrementSpellCharge(spell_book, 1)
		}

		/////////////////////////// Claidheamh Mòr ///////////////////////////

		if (Killed_WeaponIDX == TF_WEAPON_CLAIDHEAMH_MOR && Weapon_LogName == "claidheamohmor")
		{
			if ((params.kill_streak_wep % 10) != 0) return

			local spell_book = player.GetSpellBook()
			if (!spell_book) return


			local Spell_to_Grant = TF_SPELL_MONOCULUS
			local Spell_Index = GetSpellIndex(spell_book)
			local Spell_Charges = GetSpellCharges(spell_book)

			if (Spell_Charges < 1)
			{
				SetSpellIndex(spell_book, Spell_to_Grant)
				IncrementSpellCharge(spell_book, 1)
				return
			}
			if (Spell_Index == Spell_to_Grant && Spell_Charges < 2) IncrementSpellCharge(spell_book, 1)
		}

		/////////////////////////// Unarmed Combat  ///////////////////////////

		if (Killed_WeaponIDX == TF_WEAPON_UNARMED_COMBAT && Weapon_LogName == "unarmed_combat")
		{
			if ((params.kill_streak_wep % 10) != 0) return

			local spell_book = player.GetSpellBook()
			if (!spell_book) return


			local Spell_to_Grant = TF_SPELL_SKELETON
			local Spell_Index = GetSpellIndex(spell_book)
			local Spell_Charges = GetSpellCharges(spell_book)

			if (Spell_Charges < 1)
			{
				SetSpellIndex(spell_book, Spell_to_Grant)
				IncrementSpellCharge(spell_book, 1)
				return
			}
			if (Spell_Index == Spell_to_Grant && Spell_Charges < 2) IncrementSpellCharge(spell_book, 1)
		}
	}
	function OnScriptHook_OnTakeDamage(params)
	{
		if(!params.attacker) return
		local player = params.attacker
		if (!player || IsPlayerABot(player)) return
		if(params.inflictor.entindex() != player.entindex()) return // inflictor is not the attacker!
		if(params.const_entity == player) return // No Self Hits!

		local Hit_WeaponIDX = GetWeaponIDX(params.weapon)

		// battleneedle
		if (Hit_WeaponIDX == TF_WEAPON_VITA_SAW)
		{
			if (!(params.damage_type & DMG_CLUB)) return

			local spell_book = player.GetSpellBook()
			if (!spell_book) return


			local Spell_to_Grant = TF_SPELL_HEAL
			local Spell_Index = GetSpellIndex(spell_book)
			local Spell_Charges = GetSpellCharges(spell_book)

			if (Spell_Charges < 1)
			{
				SetSpellIndex(spell_book, Spell_to_Grant)
				IncrementSpellCharge(spell_book, 1)
				return
			}
			if (Spell_Index == Spell_to_Grant && Spell_Charges < 5) IncrementSpellCharge(spell_book, 1)
		}
	}


	function OnGameEvent_player_spawn(params)
	{
		if(params.team == Constants.ETFTeam.TEAM_UNASSIGNED) return
		local player = GetPlayerFromUserID(params.userid)
		if (!player || IsPlayerABot(player)) return

		SetUsingSpells(true)
	}
}

__CollectGameEventCallbacks(Spells)