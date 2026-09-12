IncludeScript("fatcat_library")


::FlameSentryEvents <-{
	function OnScriptEvent_SentryBuilt( params )
	{
		local player = params.player
		if (player.GetWeaponIDXInSlotNew(SLOT_MELEE) != TF_WEAPON_SOUTHERN_HOSPITALITY)
			return

		local sentry = params.object
		if (GetPropBool(sentry, "m_bDisposableBuilding") == true)
			return

		AddThinkToEnt(sentry, "FlameSentry")

		EntFireNew(sentry, "Color", "255 120 50")
		EntFireNew(sentry, "SetModelScale", "1")
		EntFireNew(sentry, "skin", "1")

		local scope = GetScope(sentry)
		local weapon = SpawnEntityFromTable("tf_weapon_flamethrower", {})
		weapon.EnableDraw()
		weapon.SetSolid(SOLID_NONE)

		scope.Weapon <- weapon
	}
	function OnScriptEvent_HumanResupply(params) {
		if (IsListenServer())
		{
			Host.AddCustomAttribute("engy sentry damage bonus", 0.0, -1)
			Host.AddCustomAttribute("engy sentry fire rate increased", 100000, -1)
			Host.AddCustomAttribute("engy sentry radius increased", 0.54545454, -1)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("mod wrench builds minisentry", 1, 0)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("weapon burn dmg increased", 10, 0)
			Host.GetWeaponInSlot(SLOT_MELEE).AddAttribute("bleeding duration", 0, 0)
		}
	}
}
__CollectGameEventCallbacks(FlameSentryEvents)

/**@var {CBaseCombatCharacter} self */
function FlameSentry() {
	if (!self || !self.IsValid())
		return 1
	if (GetPropBool(self, "m_bBuilding")) 
		return -1

	local scope = this

	if(!("CanFireFlame" in scope))
		scope.CanFireFlame <- GetFrameCount()

	// Netprop related veriables
	local hOwner = GetPropEntity(self, "m_hBuilder")
	local m_iShells = GetPropInt(self, "m_iAmmoShells")
	local m_iState = GetPropInt(self, "m_iState")
	local hWeapon = scope.Weapon

	hWeapon.EnableDraw()

	local Angle = QAngle((GetPropFloat(self, "m_flPoseParameter", 0) * -100 + 50) * DEG2RAD, (GetPropFloat(self, "m_flPoseParameter", 1) * -360 + 180 + self.GetAbsAngles().y) * DEG2RAD, 0)
	// Object related variables
	local flPitch 	= Angle.Pitch()
	local flYaw 	= Angle.Yaw()
	local vecEyePos = self.EyePosition()+Vector(0, 0, 6)

	// vecEyePos + ConvertAngleToEndpoint(Angle, 600)-Vector(0, 0, 6)

	// DebugDrawClear()
	DebugDrawLine_vCol(vecEyePos, vecEyePos + ConvertAngleToEndpoint(Angle, 600)-Vector(0, 0, 6), Vector(255, 0, 0), false, 0.1)
	
	local IsWrangled = false
	local IsFiring = false

	IsWrangled = GetPropBool(self, "m_bPlayerControlled")
	if (IsWrangled && hOwner.IsPressingButton(IN_ATTACK) && (hOwner.GetWeaponInSlotNew(SLOT_SECONDARY) == hOwner.GetActiveWeapon()))
		IsFiring = true
	else if (!IsWrangled && m_iState == 2)
		IsFiring = true

	if(IsFiring && CanFireFlame <= GetFrameCount()) {
		hWeapon.SetAbsOrigin(vecEyePos)
		hWeapon.SetAbsAngles(GetSentryAngles(self))

		SetPropEntity(hWeapon, "m_hOwner", hOwner)
		SetPropFloat(hWeapon, "m_flNextPrimaryAttack",0.0)

		local last_ammo = hOwner.GetPrimaryAmmo()
		SetPropBool(hOwner, "m_bLagCompensation", false)
		hWeapon.PrimaryAttack()
		SetPropBool(hOwner, "m_bLagCompensation", true)

		ShowOBB(hWeapon)

		hOwner.SetPrimaryAmmo(last_ammo)
		scope.CanFireFlame = GetFrameCount() + 10
	}
	
	
	
	return -1
}