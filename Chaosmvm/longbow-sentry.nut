IncludeScript("fatcat_library")
PrecacheSound("weapons/teleporter_send.wav")
PrecacheSound("weapons/teleporter_receive.wav")

SetScriptVersion("longbow_sentry", "2.0.0")

///// Events! /////
::longbow_events <- {
	function OnScriptEvent_HumanSpawn(params)
	{
		local player = params.player
		if(player.HookAdditiveAttributes("longbow buildings") == 0)
			return
		// if(player.GetWeaponIDXInSlot(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT) return

		player.AddThink(LongbowBuildings, "LongbowBuildings")
	}
}
__CollectGameEventCallbacks(longbow_events)

::FLongbowAllowSentry 		<- 0x1
::FLongbowAllowDispencer 	<- 0x2
::FLongbowAllowTeleporter 	<- 0x4

//// Player Think ////
/** 
 * @var {CTFPlayer} self
 */
function LongbowBuildings()
{
	// if(self.GetWeaponIDXInSlot(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT)
	if(player.HookAdditiveAttributes("longbow buildings") == 0)
	{
		self.RemoveThink("LongbowBuildings")
		return 500
	}

	local m_iMetal = self.GetMetal()
	local building_blueprint = GetPropEntity(self.GetWeaponInSlotNew(SLOT_PDA), "m_hObjectBeingBuilt")
	if(!IsBuildingValid(building_blueprint)) // checks for null building, and "m_bServerOverridePlacement"
		return -1

	local AllowedTypes = player.HookAdditiveAttributes("longbow buildings allowed")
	local AllowFlags = [false, false, false]
	if(MATH.HasBitFlag(AllowedTypes, FLongbowAllowDispencer))
		AllowFlags[OBJ_DISPENSER] = true
	if(MATH.HasBitFlag(AllowedTypes, FLongbowAllowTeleporter))
		AllowFlags[OBJ_TELEPORTER] = true
	if(MATH.HasBitFlag(AllowedTypes, FLongbowAllowSentry))
		AllowFlags[OBJ_SENTRY] = true

	// if(GetPropInt(building_blueprint, "m_iObjectType") != OBJ_SENTRY)
	if(AllowFlags[GetPropInt(building_blueprint, "m_iObjectType")] == false)
		return -1

	local mins = GetPropVector(building_blueprint, "m_Collision.m_vecMins")
	local maxs = GetPropVector(building_blueprint, "m_Collision.m_vecMaxs") + Vector(0, 0, 10)

	// override it for teleporters
	if(GetPropInt(building_blueprint, "m_iObjectType") == OBJ_TELEPORTER)
	{
		mins = Vector(-16.0, -16.0, 0)
		maxs = Vector(16.0, 16.0, 120) // bloat height
	}

	if(!self.IsPressingButton(IN_RELOAD) || !self.IsOnGround())
		return -1

	if(m_iMetal <= 499)
	{
		self.TranslateToHud("LOW_METAL")
		return -1
	}

	local trace =
	{
		start = 	self.EyePosition()
		end = 		self.GetEyeOffset(1190)
		mask =		MASK_CUSTOM_PLAYERSOLID
		hullmin =	mins
		hullmax = 	maxs
		ignore = 	self
	}
	TraceHull(trace)

	if(IsListenServer()) 
		DebugDrawLine_vCol(trace.startpos, trace.endpos, Vector(255, 0, 0), false, 30)

	if(!trace.hit || IsPointInRespawnRoom(trace.endpos)) 
		return -1
	
	local hulltrace =
	{
		start = 	trace.endpos
		end = 		trace.endpos
		mask =		MASK_SHOT_HULL
		hullmin = 	mins
		hullmax =	maxs
	}
	TraceHull(hulltrace)

	if(hulltrace.hit)
	{
		if(IsListenServer()) 
			DebugDrawBox(hulltrace.start, mins, maxs, 255, 0, 255, 0, 60)
		return -1
	}

	self.GetActiveWeapon().PrimaryAttack()

	local particle = SpawnEntityFromTable("info_particle_system", {
		effect_name = "dxhr_sniper_rail_red",
		origin = building_blueprint.GetCenter(),
		start_active = 1
	})
	SetPropEntityArray(particle, "m_hControlPointEnts", building_blueprint, 0)
	SetPropEntityArray(particle, "m_hControlPointEnts", building_blueprint, 1)
	building_blueprint.Teleport(true, trace.endpos, false, QAngle(), false, Vector())

	EntFireNew(particle, "Kill", "", FIVE_TICKS)

	CreateParticle("teleported_red", building_blueprint.GetOrigin())

	if (IsListenServer()) 
		ShowAABB(building_blueprint, Vector4D(255, 125, 0, 0), 10)

	//TEST
	building_blueprint.SetCollisionGroup(TFCOLLISION_GROUP_OBJECT)

	/** 
	 * @var {CTFPlayer} self
	 */
	// local function EurekaThink() {
	// 	if(GetBuilder(self).GetWeaponIDXInSlotNew(SLOT_MELEE) != TF_WEAPON_EUREKA_EFFECT)
	// 	{
	// 		ClearThinks(self)
	// 		return
	// 	}
	// 	foreach (bot in GetAllPlayers(TF_TEAM_PVE_INVADERS, [self.GetCenter(), 100], true))
	// 	{
	// 		if(bot.InCond(TF_COND_INVULNERABLE_HIDE_UNLESS_DAMAGED))
	// 		{
	// 			self.TakeDamage(self.GetMaxHealth() * 10, 0, bot)
	// 			ClearThinks(self)
	// 			return
	// 		}
	// 	}
	// 	return -1
	// }
	// GetScope(building_blueprint).EurekaThink <- EurekaThink
	// AddThinkToEnt(building_blueprint, "EurekaThink")

	EmitSoundEx({
		sound_name = "weapons/teleporter_send.wav"
		entity = self
		volume = 0.5
		sound_level = MATH.ConvertRadiusToSndLvl(1000)
	})
	EmitSoundEx({
		sound_name = "weapons/teleporter_receive.wav"
		entity = building_blueprint
		sound_level = MATH.ConvertRadiusToSndLvl(2500)
	})
	self.SetMetal(m_iMetal - 500)
	return -1
}