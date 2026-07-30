if (!("SetLibraryVersion" in getroottable()) || ("FatCatLibForce" in ROOT && FatCatLibForce == true))
	IncludeScript("fatcat_library")

SetScriptVersion("zapinator", "1.0.0")


RegisterDamageCallback("player", "GameplayPlayer" function( params ) {
	if (HasCustomFlag(params.damage_custom, TF_DMG_CUSTOM_IGNORE_EVENTS) || params.damage_custom == TF_DMG_CUSTOM_TRIGGER_HURT)
		return

	local victim 	= params.victim
	local attacker 	= params.attacker
	local weapon 	= null
	local inflictor	= params.inflictor
	

	if (!attacker)
		return

	weapon = params.weapon

	if (!attacker || !weapon || !inflictor)
		return

	if ( !(startswith(weapon.GetClassname(), "tf_weapon") || startswith(weapon.GetClassname(), "tf_wearable")) )
		return

	if (victim.IsInvincible() || IsPlayerABot(attacker))
		return

    if (!attacker.HasWeapon(30666))
        return
    PrintToChatAll("Hi, startng zapinator code here")
})