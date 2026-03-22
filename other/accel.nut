IncludeScript("fatcat_library")

local accel_ent = FindByName(null, "_ProjectileAccelerationThink")
if( accel_ent == null ) accel_ent = SpawnEntityFromTable("info_target", { targetname = "_ProjectileAccelerationThink" })
AddThinkToEnt(accel_ent, "AccelerationAdd")

function AccelerationAdd()
{
	for (local projectile; projectile = FindByClassname(projectile, "tf_projectile*");)
	{
		local scope = GetScope(projectile)
		if("Acceleration" in scope) continue

		if(projectile.GetClassname() != "tf_projectile_rocket") continue

		NetProps.SetPropBool(projectile, "m_bForcePurgeFixedupStrings", true)

		local launcher = GetLauncher(projectile)
		local launcherID = -1

		if( launcher ) launcherID = launcher.GetIDX()
		else launcherID = GetBuilder(projectile.GetOwner()).GetWeaponIDXInSlotNew(MELEE_SLOT)

		switch (launcherID)
		{
			case 18:
			{
				scope.Acceleration <- 15
				scope.Acceleration_mult <- 100
				// scope.base_speed <- projectile.GetAbsVelocity()
				scope.start_time <- Time()
				scope.StartVel <- projectile.GetAbsVelocity()
				AddThinkToEnt(projectile, "AccelerationThink")
				break
			}
		}

	}
}

function AccelerationThink()
{
	self.GetOwner().PrintToHud((self.GetAbsVelocity() - StartVel).Norm().tostring())
	if (this.start_time >= Time())
		return -1
	if(self.GetAbsVelocity().Norm() > Convars.GetFloat("sv_maxvelocity"))
	{
		Convars.SetValue("sv_maxvelocity", Convars.GetFloat("sv_maxvelocity") * 2)

		// ClientPrint(null, 3, "Server cvar \'" + cvar + "\' changed to " + Convars.GetFloat(cvar))
	}
	self.SetAbsVelocity(self.GetAbsVelocity() + (self.GetForwardVector() * this.Acceleration))
	// self.SetAbsVelocity(self.GetAbsVelocity() * this.Acceleration_mult)
	return -1
}