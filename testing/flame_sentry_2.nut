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

/**@var {CBaseEntity} self */
function FlameThink() {
	local orig_pos = self.GetOrigin()
	local new_pos = orig_pos + (self.GetAbsVelocity() * (1.00 / 66.0))
	self.SetAbsOrigin( new_pos )

	// if(GetScope(self).Scale <= 0.2)
	// {
	// 	GetScope(self).Scale += 0.01
	// 	self.KeyValueFromFloat("scale", GetScope(self).Scale)
	// }

	// DebugDrawBox(self.GetCenter(), Vector(-12, -12, -12), Vector(12, 12, 12), 0, 255, 0, 1, 0.1)
	// DebugDrawLine_vCol(orig_pos, new_pos, Vector(0, 0, 255), false, 0.1)

	if("NoTrace" in GetScope(self)) {
		GetScope(self).NoTrace--
		if(GetScope(self).NoTrace == 0)
			self.Kill()
		return -1
	}

	local trace = {
		start = orig_pos
		end = new_pos
		hullmin = Vector(-12, -12, -12)
		hullmax = Vector(12, 12, 12)
		mask = MASK_PLAYERSOLID
		ignore = self.GetOwner()
	}
	TraceHull(trace)

	if(trace.hit) {
		local entity = trace.enthit
		if(entity.entindex() == 0) {
			GetScope(self).NoTrace <- 3
		}
		else if (entity.GetTeam() == self.GetOwner().GetTeam()) {

		}
		else
			PrintTable(trace)
	}
	return -1
}
function CreateFlame() {
	local Entity = CreateByClassname("env_sprite")
	Entity.SetAbsOrigin(Vector())
	Entity.KeyValueFromInt("rendermode", 9)
	Entity.DispatchSpawn()
	Entity.KeyValueFromFloat("scale", 0.125)
	GetScope(Entity).Scale <- 0.1

	return Entity
}

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
		local fire = CreateFlame()
		local ang = Vector(cos(Angle.Pitch()) * cos(Angle.Yaw()), cos(Angle.Pitch()) * sin(Angle.Yaw()), -sin(Angle.Pitch()))
		fire.KeyValueFromString("model", "effects/fire_cloud2.vmt")
		fire.SetAbsOrigin(vecEyePos + (ang * 25))
		fire.DispatchSpawn()
		fire.SetAbsAngles(Angle)
		fire.SetForwardVector(ang)
		fire.SetAbsVelocity(fire.GetForwardVector() * 1500)
		fire.SetOwner(self)

		AddThinkToEnt(fire, "FlameThink")

		EntFireNew(fire, "Kill", "", 0.3333)
		scope.CanFireFlame = GetFrameCount() + 3
	}
	
	
	
	return -1
}