
::TF_CUSTOM_SPELL_NONE <- -1

::TF_CUSTOM_SPELL_DATA <- {
}

::SpellSelectSound <- "kaizo/spellselect_full.mp3"

function CreateCustomSpell( name, data )
{
	if (name in TF_CUSTOM_SPELL_DATA)
	{
		printf("Warning, Spell \"%s\" is already Defined!\n", name)
		delete TF_CUSTOM_SPELL_DATA[name]
	}
		
	TF_CUSTOM_SPELL_DATA[name] <- SpellData(data)
}

/**
 * Description
 * @returns {[int]}
 */
function GetSpellIDXS()
{
	local nums = []
	foreach (_, data in TF_CUSTOM_SPELL_DATA)
	{
		if (data.SpellIDX > 0)
			nums.append(data.SpellIDX)
	}
	return nums
}


class SpellData {
	SpellIDX = 0
	SpellName = "Unknown"
	FireDelay = 0
	CastTime = 0
	CastSound = ""
	SoundData = {}

	DefaultCharge = 0

	IsRare = false

	OnCast = 0
	OnFail = 0

	constructor(data)
	{
		this.SpellIDX 		= data.idx
		this.SpellName 		= "name" in data ? 		data.name : "Fucked up"
		this.FireDelay 		= "delay" in data ? 	data.delay : 0.5
		this.CastTime 		= "casttime" in data ? 	data.casttime : 0
		this.CastSound 		= "castsound" in data ? data.castsound : ""
		this.SoundData 		= "sounddata" in data ? data.sounddata : {}
		this.DefaultCharge 	= "amount" in data ? 	data.amount : 1
		this.IsRare 		= "rare" in data ? 		data.rare : false

		this.OnCast = "OnCast" in data ? data.OnCast : @(...) {}
		this.OnFail = "OnFail" in data ? data.OnFail : @(...) {}
 	}
}

function CTFPlayer::GetCustomSpellBook()
{
	if (!("CustomSpellBook" in GetScope(this)) || GetScope(this).CustomSpellBook == null)
		GetScope(this).CustomSpellBook <- CustomSpellBook(this)

	RemoveThink("SpellbookThink")
	ApplySpellBookThink()
	return GetScope(this).CustomSpellBook
}

// delete GetScope(Host).CustomSpellBook


function CTFPlayer::ApplySpellBookThink()
{
	AddThink(function() {
		// "self" == the player
		// "this" == GetScope(self)

		local Spellbook = self.GetCustomSpellBook()
		local SpellData = Spellbook.FindSpellData()
		local Name = SpellData.SpellName
		local Charges = Spellbook.GetSpellCharges()

		self.DisplayHudText("Active Spell: "+Name+"\nUses Left: "+Charges, "21 124 235", [0.25, 0.75], 0.5, 4)

		local scope = GetScope(self)

		if (!("LastFailSound" in scope))
			scope.LastFailSound <- 0.0

		if (self.IsUsingActionSlot())
		{
			local CastSuccess = Spellbook.UseSpell()
			if (CastSuccess == false && scope.LastFailSound+0.5 < Time())
			{
				self.EmitSoundTo("Player.DenyWeaponSelection")
				// EmitSoundOnClient("Player.DenyWeaponSelection", self)
				scope.LastFailSound <- Time()
			}
			else if (CastSuccess == true)
			{
				scope.LastFailSound <- Time()
			}
		}

		return 0.1
	}, "SpellbookThink")
}

class CustomSpellBook {
	player = null
	ActiveSpell = 0
	SpellCharges = 0
	CastingSpell = false
	RollingSpell = false

	SpellData = null

	LastUseTime = 0.0

	/**
	 * Create this custom spell book
	 * @param {CTFPlayer} _player
	 */
	constructor(_player)
	{
		this.player = _player
		this.ActiveSpell = 0
		this.SpellCharges = 0
		this.LastUseTime = Time()
		this.CastingSpell = false
		this.RollingSpell = false

		this.SpellData = FindSpellData()
	}

	/**
	 * Returns the active Spell charges
	 * @returns {integer}
	 */
	function GetSpellCharges() {return SpellCharges}
	/**
	 * Returns the active Spell index
	 * @returns {integer} 
	 */
	function GetSpellIndex() {return ActiveSpell}
	/**
	 * Set the Number of charges this spell has
	 * @param {integer} charges
	 */
	function SetSpellCharges( charges ) {SpellCharges = charges}
	/**
	 * No Freeloaders here
	 */
	function PayForSpell() { SpellCharges-- }

	/**
	 * Description
	 * @returns {Vector}
	 */
	function GetSpellSetupOrigin()
	{
		local Angles = player.EyeAngles()
		local Right = 7.0
		local Up = -9.0
		local Forward = 3.0

		if (player.AreViewModelsFlipped())
			Right *= -1

		local offset = ( Angles.Up() * Up ) + ( Angles.Left() * Right ) + ( Angles.Forward() * Forward )
	
		return player.EyePosition() + offset
	}

	/**
	 * Play the cast sound to this player
	 */
	function PlayCastSound() { 
		local data = {}
		if ("SoundData" in SpellData)
			data = SpellData.SoundData
		player.EmitSoundTo(SpellData.CastSound, data) 
	}

	/**
	 * Roll a Random spell, if true is passed, always allow a roll, else if false, disallow if they have charges
	 * @param {bool} bypass
	 */
	function RollSpell( bypass = false )
	{
		if (bypass == false && GetSpellCharges() != 0)
			return
		SetSpellIndex(-1)
		SetSpellCharges(0)
		player.EmitSoundTo(SpellSelectSound, {})
		RollingSpell = true
		RunWithDelay(2.5, @() SetRandomSpell()) // compatible with SuperTest
	}

	/**
	 * Sets the spell to a random one, with the default charges listed in the spell data
	 */
	function SetRandomSpell()
	{
		RollingSpell = false
		local valids = GetSpellIDXS()
		SetSpellIndex(valids[RandomInt(0, valids.len()-1)])
		SetSpellCharges(FindSpellData().DefaultCharge)
	}

	/**
	 * Sets the spell index and Spelldata
	 * @param {int} index
	 */
	function SetSpellIndex( index )
	{
		ActiveSpell = index
		SpellData = FindSpellData()
	}

	/**
	 * Returns the spell data for this spell index
	 * @returns {SpellData}
	 */
	function FindSpellData()
	{
		foreach (_, SpellData in TF_CUSTOM_SPELL_DATA)
		{
			if (SpellData.SpellIDX == ActiveSpell)
				return SpellData
		}
	}

	/**
	 * Returns if the player is allowed to use a spell
	 * @returns {bool}
	 */
	function CanUseSpell()
	{
		if (player.InCond( TF_COND_HALLOWEEN_KART ) && !player.CanAttack())
			return false

		if (player.InCond( TF_COND_HALLOWEEN_THRILLER ))
			return false;

		return SpellCharges > 0
	}



	/**
	 * Uses a spell charge to cast this spell
	 * @returns {any} whatever OnCast or OnFail returns
	 */
	function UseSpell()
	{
		if (LastUseTime + SpellData.FireDelay > Time() || CanUseSpell() == false)
		{
			return SpellData.OnFail.call(player, SpellData)
		}

		CastingSpell = true
			
		LastUseTime = Time() + SpellData.CastTime

		local func = function() {
			PayForSpell()
			CastingSpell = false
			SpellData.OnCast.call(player, SpellData)
			PlayCastSound()
			if (SpellCharges == 0)
			{
				SetSpellIndex(0)
			}
		}

		if (SpellData.CastTime == 0)
			return func()

		RunWithDelay(SpellData.CastTime, @() func())
		return true
	}
}

/**
 * Spawns a basic rocket
 * @param {CBaseEntity|null} owner
 * @param {Vector} origin
 * @param {float} velocity
 * @param {CBaseEntity|null} launcher
 * @param {bool|function} explosion_callback
 * @returns {CBaseEntity|null}
 */
function ROOT::CreateRocket( owner, origin, velocity, launcher = null, explosion_callback = false )
{
	local rocket = SpawnEntityFromTable("tf_projectile_rocket", {})

	rocket.SetForwardVector(owner ? owner.EyeVector() : Vector(1, 0, 0))
	rocket.SetAbsVelocity(grenade.GetForwardVector() * velocity)
	rocket.SetAbsOrigin(origin)
	rocket.SetOwner(owner)

	SetPropEntity(rocket, "m_hOwner", owner)
	SetPropEntity(rocket, "m_hLauncher", launcher)
	SetPropEntity(rocket, "m_hOriginalLauncher", launcher)

	rocket.SetTeam(owner ? owner.GetTeam() : TF_TEAM_UNASSIGNED)
	rocket.SetCollisionGroup(TFCOLLISION_GROUP_ROCKET_BUT_NOT_WITH_OTHER_ROCKETS)

	if (explosion_callback)
		SetDestroyCallback(rocket, explosion_callback)

	return rocket
}

/**
 * Spawns a grendade
 * @param {CBaseEntity|null} owner
 * @param {Vector} origin
 * @param {float|integer} velocity
 * @param {CBaseEntity|null} launcher
 * @param {float|integer} damage
 * @param {float|integer} radius
 * @param {bool|function} explosion_callback
 * @returns {CBaseEntity|null}
 */
function ROOT::CreateGrenade( owner, origin, velocity, launcher = null, damage = 100, radius = 146, detonate_time = 0.25, explosion_callback = false )
{
	local grenade = SpawnEntityFromTable("tf_projectile_pipe", {})

	grenade.SetForwardVector(owner ? owner.EyeVector() : Vector(1, 0, 0))
	grenade.SetPhysVelocity(grenade.GetForwardVector() * velocity)
	grenade.SetAbsOrigin(origin)
	grenade.SetOwner(owner)

	SetPropEntity(grenade, "m_hOwner", owner)
	SetPropEntity(grenade, "m_hLauncher", launcher)
	SetPropEntity(grenade, "m_hOriginalLauncher", launcher)
	SetPropFloat(grenade, "m_flDamage", damage)
	SetPropFloat(grenade, "m_DmgRadius", radius)
	SetPropFloat(grenade, "m_flDetonateTime", Time()+detonate_time)

	grenade.SetTeam(owner ? owner.GetTeam() : TF_TEAM_UNASSIGNED)
	grenade.SetCollisionGroup(TFCOLLISION_GROUP_ROCKET_BUT_NOT_WITH_OTHER_ROCKETS)

	if (explosion_callback)
		SetDestroyCallback(rocket, explosion_callback)

	return grenade
}


function ROOT::SpawnFireball( owner, _SpellData )
{
	local Book = owner.GetCustomSpellBook()
	local Source = Book.GetSpellSetupOrigin()

	local trace = {
		start = owner.EyePosition()
		end = Source
		hullmin = Vector(-8, -8, -8)
		hullmax = Vector(8, 8, 8)

		mask = MASK_SOLID_BRUSHONLY
		startsolid = false
	}

	TraceHull(trace)

	if (trace.startsolid)
		return

	local Velocity = 1100 * owner.HookMultAttributes("mult fireball speed")

	local fireball = CreateRocket(owner, Source, Velocity)
	fireball.SetModelScale(0.01, 0.0)

	fireball.AcceptInput("DispatchEffect", "ParticleEffectStop", null, null) // stop trail
	AttachEntityParticle(fireball, "spell_fireball_small_red", PATTACH_ABSORIGIN_FOLLOW, "")

	SetDestroyCallback(fireball, function() {
		CreateParticle("bombinomicon_burningdebris", self.GetOrigin())

		EmitSoundEx({
			sound_name = "Halloween.spell_fireball_impact"
			entity = self
		})

		CreateFireballExplosion({
			owner = self.GetOwner()
			inflictor = self
			center = self.GetOrigin()
			damage = 100
			radius = 200 * owner.HookMultAttributes("mult fireball radius")

			function func( player ) {
				if (player.GetPlayerClass() != TF_CLASS_PYRO && !player.InCond(TF_COND_GAS) && !player.InCond(TF_COND_BURNING))
					player.AddCondEx(TF_COND_GAS, 1, owner)

				local Dir = (player.WorldSpaceCenter() - self.GetOrigin()).Normalize()
				Dir *= 750
				Dir.z = 500
				// DebugDrawText(player.WorldSpaceCenter(), Dir.tostring(), false, 5)

				player.ApplyGenericPushbackImpulse( Dir , self.GetOwner() )
			}
		})
	})
}

function ROOT::SpawnBatBall( _owner, _SpellData )
{
	// local ball = CreateGrenade()
	//TODO: this shit
}

function ROOT::UseSelfHeal( owner, _SpellData )
{
	local origin = owner.GetOrigin()
	owner.AttachParticle("spell_overheal_red")

	local players = GetAllEntitiesByClassnameWithin("player", origin, 300.0) // normally 250, but bloat it out a bit

	foreach (player in players)
	{
		if (player.IsDead())
			continue

		if (!CanPointSeePoint(origin, player.GetOrigin()))
			continue

		local Direction = (player.WorldSpaceCenter() - origin).Normalize()

		if ( player.GetTeam() == owner.GetTeam() )
		{
			local PercHealth = player.GetPercentMaxHealth(20)
			printf("Got 250 for Min, and %f for 20%% of max\n", PercHealth)
			player.HealPlayer(MATH.Max(250.0, PercHealth), true)

			player.AddCondEx(TF_COND_INVULNERABLE_USER_BUFF, 1, owner)
			player.AddCondEx(TF_COND_HALLOWEEN_QUICK_HEAL, 3, owner)
		}
		else
		{
			player.ApplyGenericPushbackImpulse(Direction * 300, owner)
		}
	}
}

function ROOT::SpawnPumpkinMirv( _owner, _SpellData )
{
	//TODO: this shit
}

function ROOT::UseBlastJump( owner, _SpellData )
{
	local BlastRadius = 100.0
	BlastRadius *= owner.HookMultAttributes("mult blastjump radius")

	local vel = owner.GetAbsVelocity()
	if (vel.z < 0)
	{
		vel.z = 0
	}
	owner.SetAbsVelocity(vel)

	local Forward = Vector(0, 0, 800)
	Forward *= owner.HookMultAttributes("mult blastjump velocity")
	owner.ApplyAbsVelocityImpulse(Forward)

	local origin = owner.GetOrigin()

	CreateParticle("bombinomicon_burningdebris", origin)
	CreateParticle("heavy_ring_of_fire", origin)

	owner.AttachParticle("rocketjump_smoke", -1, PATTACH_POINT_FOLLOW, "foot_L")
	owner.AttachParticle("rocketjump_smoke", -1, PATTACH_POINT_FOLLOW, "foot_R")

	owner.HealPlayer(MATH.Max(125.0, owner.GetPercentMaxHealth(10)), true)

	local players = GetAllEntitiesByClassnameWithin("player", origin, BlastRadius)

	foreach (player in players)
	{
		if (player.IsDead() || player.GetTeam() == owner.GetTeam())
			continue

		if (!CanPointSeePoint(origin, player.GetOrigin()))
			continue

		local Direction = (player.WorldSpaceCenter() - origin).Normalize()

		player.RemoveFlag( FL_ONGROUND )

		local PushForce = 800.0
		PushForce *= owner.HookMultAttributes("mult blastjump pushforce")

		player.ApplyGenericPushbackImpulse(Direction * PushForce, owner)

		local damage = 20.0
		damage *= owner.HookMultAttributes("mult blastjump damage")
		
		player.TakeDamageCustom(owner, owner, owner.GetActiveWeapon(), Vector(0, 0, 1), origin, damage, DMG_BLAST|DMG_PREVENT_PHYSICS_FORCE, TF_DMG_CUSTOM_SPELL_BLASTJUMP)
	}
}

function ROOT::UseStealthSpell( owner, _SpellData )
{
	owner.HealPlayer(MATH.Max(200, owner.GetPercentMaxHealth(15)), true)
	owner.SetCond(TF_COND_STEALTHED_USER_BUFF, 8.0 * owner.HookMultAttributes("mult stealth duration"))
}

function ROOT::UseTeleportSpell( _owner, _SpellData )
{
	//TODO: this shit
}

function ROOT::UseLightningSpell( _owner, _SpellData )
{
	//TODO: this shit
}

function ROOT::UseMinifySpell( owner, _SpellData )
{
	owner.HealPlayer(MATH.Max(500, owner.GetPercentMaxHealth(30)), true)

	local duration = 20.0 * owner.HookMultAttributes("mult minify duration")

	owner.SetCond(TF_COND_HALLOWEEN_TINY, duration)
	owner.SetCond(TF_COND_HALLOWEEN_SPEED_BOOST, duration)
}

function ROOT::UseMeteorSpell( _owner, _SpellData )
{
	//TODO: this shit
}

function ROOT::UseMonoculusSpell( owner, _SpellData )
{
	local boss = SpawnEntityFromTable("tf_projectile_spellspawnboss" {
		origin = owner.GetOrigin()
	})

	local Angle = owner.EyeAngles()

	local ProjectileSpeed = 1000.0 * owner.HookMultAttributes("mult boss summon projectile speed")

	// fuck ass magic
	/**
	 * @type {Vector}
	 */
	local forward = Angle.Forward() * ProjectileSpeed
	/**
	 * @type {Vector}
	 */
	local Up = Angle.Up() * 200.0
	/**
	 * @type {Vector}
	 */
	local Left = Angle.Left() * RandomFloat( -10.0, 10.0 )
	/**
	 * @type {Vector}
	 */
	local RanUp = Angle.Up() * RandomFloat( -10.0, 10.0 )

	local velocity = ( forward + Up + Left + RanUp )

	boss.SetPhysVelocity(velocity)
	boss.SetAbsAngles(Angle)


	boss.SetOwner(owner)
	SetPropEntity(boss, "m_hLauncher", owner)
	SetPropEntity(boss, "m_hThrower", owner)

	//TODO: this shit
}

function ROOT::UseSkeletonSpell( _owner, _SpellData )
{
	//TODO: this shit
}


CreateCustomSpell("Rolling", { // -1
	idx = -1
	name = "Rolling"
})
CreateCustomSpell("None", { // 0
	idx = 0
	name = "None"
	function OnFail( ... ) {
		return false
	}
})
CreateCustomSpell("Fireball", { // 1
	idx = 1
	name = "Fireball"
	casttime = 0.25
	castsound = "Halloween.spell_fireball_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.SpawnFireball(this, vargv[0])
		return true
	}
})
/* CreateCustomSpell("Bats", { // 2
	idx = 2
	name = "Swarm of Bats"
	casttime = 0.25
	castsound = "Halloween.spell_bat_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.SpawnBatBall(this, vargv[0])
		return true
	}
}) */
CreateCustomSpell("Overheal", { // 3
	idx = 3
	name = "Overheal"
	casttime = 0.25
	castsound = "Halloween.spell_overheal"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseSelfHeal(this, vargv[0])
		return true
	}
})
/* CreateCustomSpell("PumpkinMirv", { // 4
	idx = 4
	name = "Pumpking Mirv"
	casttime = 0.25
	castsound = "Halloween.spell_mirv_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.SpawnPumpkinMirv(this, vargv[0])
		return true
	}
}) */
CreateCustomSpell("BlastJump", { // 5
	idx = 5
	name = "Blast Jump"
	casttime = 0.25
	castsound = "Halloween.spell_blastjump"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseBlastJump(this, vargv[0])
		return true
	}
})
CreateCustomSpell("Stealth", { // 6
	idx = 6
	name = "Stealth"
	casttime = 0.25
	castsound = "Halloween.spell_stealth"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseStealthSpell(this, vargv[0])
		return true
	}
})
/* CreateCustomSpell("Teleport", { // 7
	idx = 7
	name = "Teleport"
	casttime = 0.25
	castsound = "Halloween.spell_teleport"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseTeleportSpell(this, vargv[0])
		return true
	}
}) */
/* CreateCustomSpell("Lightning", { // 8
	idx = 8
	name = "Lightning"
	casttime = 0.25
	castsound = "Halloween.spell_lightning_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseLightningSpell(this, vargv[0])
		return true
	}
}) */
CreateCustomSpell("Minify", { // 9
	idx = 9
	name = "Minify"
	casttime = 0.25
	castsound = "Halloween.spell_athletic"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseMinifySpell(this, vargv[0])
		return true
	}
})
/* CreateCustomSpell("Meteor", { // 10
	idx = 10
	name = "Meteor"
	casttime = 0.25
	castsound = "Halloween.spell_meteor_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseMeteorSpell(this, vargv[0])
		return true
	}
}) */
CreateCustomSpell("Monoculus", { // 11
	idx = 11
	name = "Monoculus"
	casttime = 0.25
	castsound = "Halloween.Merasmus_Spell"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseMonoculusSpell(this, vargv[0])
		return true
	}
})
/* CreateCustomSpell("Skeletons", { // 12
	idx = 12
	name = "Skeletons"
	casttime = 0.25
	castsound = "Halloween.spell_skeleton_horde_cast"
	function OnFail( ... ) {
		return false
	}
	function OnCast( ... ) {
		ROOT.UseSkeletonSpell(this, vargv[0])
		return true
	}
}) */

::SpellEvents <- {
	function OnScriptEvent_HumanSpawn( params )
	{
		local player = params.player

		player.ApplySpellBookThink()

		local book = player.GetCustomSpellBook()
		book.SetSpellIndex(0)
		book.SetSpellCharges(0)
	}
	function OnScriptEvent_BotDeath( params )
	{
		// local victim = params.victim
		local attacker = params.attacker

		if (!attacker || !attacker.IsPlayer())
			return

		local book = attacker.GetCustomSpellBook()

		if (book.CastingSpell == false && book.RollingSpell == false)
		{
			book.RollSpell()
		}
	}
}
__CollectGameEventCallbacks(SpellEvents)