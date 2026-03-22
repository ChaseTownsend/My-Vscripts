IncludeScript("fatcat_library")

// List of entrys
const TF_WEAPON_WRENCH = 7
const TF_WEAPON_ROCKETLAUNCHER = 18
const TF_WEAPON_HUNTSMAN = 56
const TF_WEAPON_CROSSBOW = 305
const TF_WEAPON_JARATE = -1


local gravity_entity = FindByName(null, "_ProjectileGravityThink")
if( gravity_entity == null ) gravity_entity = SpawnEntityFromTable("info_target", { targetname = "_ProjectileGravityThink" })
AddThinkToEnt(gravity_entity, "GravityAdd")

function GravityAdd()
{
	for (local projectile; projectile = FindByClassname(projectile, "tf_projectile*");)
	{
		local scope = GetScope(projectile)
		if("gravity" in scope) continue

		foreach (classname in [ "tf_projectile_rocket", "tf_projectile_sentryrocket", "tf_projectile_balloffire" ])
		{
			if(projectile.GetClassname() == classname) scope.behavior <- "Rocket"
		}
		if (!("behavior" in scope))
		{
			foreach (classname in [ "tf_projectile_arrow", "tf_projectile_healing_bolt", "tf_projectile_flare", "tf_projectile_syringe" ])
			{
				if(projectile.GetClassname() == classname) scope.behavior <- "Arrow"
			}
		}
		else if (!("behavior" in scope))
		{
			foreach (classname in [ "tf_projectile_jar", "tf_projectile_jar_gas", "tf_projectile_jar_milk" ])
			{
				if(projectile.GetClassname() == classname) scope.behavior <- "Jar"
			}
		}
		if (!("behavior" in scope)) continue // Not one of the above classnames

		NetProps.SetPropBool(projectile, "m_bForcePurgeFixedupStrings", true)


		local launcher = GetLauncher(projectile)
		if ( launcher ) NetProps.SetPropBool(launcher, "m_bForcePurgeFixedupStrings", true)
		local launcherID

		if(!launcher) launcherID = GetBuilder(projectile.GetOwner()).GetWeaponIDXInSlot(MELEE_SLOT)
		else launcherID = launcher.GetIDX()

		// if(launcher.GetTeam() != Constants.ETFTeam.TF_TEAM_PVE_DEFENDERS) continue

		local gravity_applied = false

		switch (launcherID)
		{
			case TF_WEAPON_WRENCH:
			{
				scope.gravity <- 1.5
				scope.acceleration <- 0

				gravity_applied = true
				break
			}
			case TF_WEAPON_ROCKETLAUNCHER:
			{
				scope.gravity <- 5
				scope.acceleration <- 200

				gravity_applied = true
				break
			}

			case TF_WEAPON_HUNTSMAN:
			{
				scope.gravity <- 0
				scope.acceleration <- 0

				gravity_applied = true
				break
			}
			case TF_WEAPON_CROSSBOW:
			{
				scope.gravity <- 0
				scope.acceleration <- 0

				gravity_applied = true
				break
			}

			case TF_WEAPON_JARATE:
			{
				scope.gravity <- 0
				scope.acceleration <- 0

				gravity_applied = true
				break
			}

			case 17:
			{
				scope.gravity <- 0
				scope.acceleration <- 0

				gravity_applied = true
				break
			}

		}

		if( gravity_applied )
		{
			if(scope.behavior == "Jar" /* || scope.behavior ==  */)
				scope.base_z <- projectile.GetPhysVelocity().z
			else
				scope.base_z <- projectile.GetAbsVelocity().z

			AddThinkToEnt(projectile, "GravityThink")
		}
	}
	return -1
}

function GravityThink()
{
	local scope = self.GetScriptScope()
	if(scope.behavior == "Jar" /* || scope.behavior ==  */)
		self.SetPhysVelocity(Vector(self.GetPhysVelocity().x, self.GetPhysVelocity().y, scope.base_z + scope.acceleration))
	else
		self.SetAbsVelocity(Vector(self.GetAbsVelocity().x, self.GetAbsVelocity().y, scope.base_z + scope.acceleration))


	// if(scope.behavior == "Jar" /* || scope.behavior ==  */)
	// 	ClientPrint(null, 4, "Acceleration is " + scope.acceleration + "\nVelocity is " + self.GetPhysVelocity().ToKVString())
	// else
	// 	ClientPrint(null, 4, "Acceleration is " + scope.acceleration + "\nVelocity is " + self.GetAbsVelocity().ToKVString())

	scope.acceleration -= scope.gravity

	return -1
}
