IncludeScript("fatcat_library")
IncludeScript("chaosmvm/translations")

// general Cleanup of extra entitys
foreach (ent in GetAllEntitiesByClassname("fatcat*"))
{
	ent.Destroy()
}

class PlayerData {
	Player = null
	Kills = 0
	Deaths = 0
	Damage = 0.0

	DodgeChance = 0.0
	MoneyCollectionRange = 150

	constructor(p, money = 50.0) {
		if (p.IsBot())
			return

		this.Player = p
		this.Kills = 0
		this.Deaths = 0
		this.Damage = 0.0
		this.Items = {}
		p.SetCurrency(money)
		p.AddPreservedThink(function() {
			p.DisplayHudText(format("Time on Stage: %.0f     Money: %.0f", Time() - RoR2.StartTime, p.GetCurrency()), "255 10 10", [-1, 0.1], 0.15)
			return 0.1
		}, "Stage Hud Think")
	}

	function LoadFromFile()
	{
		throw "TS aint Implemented yet"
	}

	function StoreToFile()
	{
		throw "TS aint Implemented yet"
	}

	function GetItemCount( name ) { return name in Items ? Items[name] : 0 }

	function GiveItem( name, amount = 1 ) {
		if (name in Items)
			Items[name] += amount
		else 
			Items[name] <- amount
	}

	function RemoveItem( name, amount = 1 ) {
		Assert(name in Items, format("Trying to Remove Item %s, But the player does not have any of that Item!", name))
		Items[name] -= amount

		if (Items[name] == 0)
			delete Items[name]
	}

	function DropItem( name ) {
		RoR2.CreateItemAtPos(name, Player.GetOrigin())
	}

	function AdjustDodgeChance() {
		local speeds = GetItemCount("SpeedBoots")
		DodgeChance = MATH.Clamp((speeds * 0.075), 0, 1)
	}

	// "item_name" : amount
	Items = {}
}

class CBaseBreakable {
	Breakable = null

	Health = 0

	/** 
	 * @type {function}
	 * @param {table} data
	 */
	constructor(data)
	{
		this.Breakable = SpawnEntityFromTable("prop_dynamic_override", {model = "models/empty.mdl", disableshadows = true})

		local health = "health" in data ? data.health : INT_MAX
		local solid = "solid" in data ? data.solid : SOLID_OBB
		local classname = "classname" in data ? data.classname : "base_breakable"
		local origin = "origin" in data ? data.origin : Vector()
		local angle = "angle" in data ? data.angle : QAngle(RandomInt(-20, 20), RandomInt(-20, 20), RandomInt(-20, 20))
		local model = "model" in data ? data.model : "models/props_hydro/barrel_crate_half.mdl"
		local modelscale = "scale" in data ? data.scale : 1.0
		local teamnum = "team" in data ? data.team : TF_TEAM_PVE_INVADERS

		local Hits = "hits" in data ? data.Hits : 1


		PrecacheModel(model)

		Breakable.SetHealth(health)
		Breakable.SetMaxHealth(health)
		Breakable.SetSolid(solid) 

		Breakable.KeyValueFromString("classname", classname)
		Breakable.SetAbsOrigin(origin)
		Breakable.SetAbsAngles(angle)
		Breakable.SetModel(model)
		Breakable.SetModelScale(modelscale, 0)

		Breakable.SetTeam(teamnum)

		if("cancel_dmg" in data)
			SetPropInt(Breakable, "m_takedamage", DAMAGE_EVENTS_ONLY)

		this.Health = Hits

		local scope = GetScope(Breakable)

		scope.CustomData <- this
		local function ObjectOnTakeDamage()
		{
			CustomData.OnTakeDamage(activator, caller)
		}
		scope.OnTakeDamage <- ObjectOnTakeDamage
		local function ObjectOnBreak()
		{
			CustomData.OnBreak(activator, caller)
		}
		scope.OnBreak <- ObjectOnBreak

		Breakable.ConnectOutput("OnTakeDamage", "OnTakeDamage")
		Breakable.ConnectOutput("OnBreak", "OnBreak")
		// return Breakable
	}

	/** 
	 * @type {function}
	 * @param {CTFPlayer|CBaseEntity|null} attacker
	 * @returns {bool}
	 */
	function CanTakeDamage(attacker)
	{
		if(!attacker || !attacker.IsValid() || !attacker.IsPlayer() || !Breakable || !Breakable.IsValid())
			return false
		if(Breakable.GetTeam() < TF_TEAM_RED)
			return true
		if(Breakable.GetTeam() == attacker.GetTeam())
			return false
		return true
	}

	/** 
	 * @type {function}
	 * @param {CTFPlayer|CBaseEntity|null} attacker
	 * @param {CBaseAnimating} victim
	 */
	function OnTakeDamage(attacker, victim)
	{
		if(!victim || !victim.IsValid() || !CanTakeDamage(attacker))
			return
		Health--
		if(Health <= 0)
			victim.AcceptInput("Break", "", attacker, victim)
	}

	function OnBreak(attacker, victim)
	{
	}

	function Break()
	{
		Breakable.AcceptInput("Break", "", Breakable, Breakable)
	}
}

class CBaseMeleeBreakable extends CBaseBreakable {
	/** 
	 * @type {function}
	 * @param {table} data
	 */
	constructor(data)
	{
		base.constructor(data)
		// Base Stuff
		Breakable.SetCollisionGroup(COLLISION_GROUP_WEAPON) // allow to be hit by melee

		if (!FindByName(null, "MeleeOnly")) {
			local ent = SpawnEntityFromTable("filter_tf_damaged_by_weapon_in_slot", {targetname = "MeleeOnly"})
			SetPropInt(ent, "m_iWeaponSlot", SLOT_MELEE)
		}

		SetPropEntity(Breakable, "m_hDamageFilter", FindByName(null, "MeleeOnly"))
		SetPropString(Breakable, "m_iszDamageFilterName", "MeleeOnly")
	}
}

AddChatTrigger("test_custom", function(player, ...) {
	local breakable = CBaseMeleeBreakable({
		classname = "fatcat_breakable" // so it gets killed
		origin = player.GetEyeTrace().pos
		angle = QAngle()
		scale = 0.5
		cancel_dmg = true
	})
})
AddChatTrigger("test_custom2", function(player, ...) {
	local breakable = CBaseBreakable({
		classname = "fatcat_breakable" // so it gets killed
		origin = player.GetEyeTrace().pos
		angle = QAngle()
		scale = 0.8
		cancel_dmg = true
	})
})

class BaseCrate {
	Crate = null

	/** 
	 * @param {table} data
	 * @returns {CBaseEntity|null}
	 */
	constructor(data) {
		Crate = SpawnEntityFromTable("prop_dynamic_override", {model = "models/empty.mdl", disableshadows = true})
		// Base Stuff
		Crate.SetHealth(INT_MAX)
		Crate.SetMaxHealth(INT_MAX)
		Crate.SetSolid(SOLID_OBB) 
		Crate.SetCollisionGroup(COLLISION_GROUP_WEAPON)

		Crate.KeyValueFromString("classname", "classname" in data ? data.classname : "fatcat_crate_base")
		Crate.SetAbsOrigin("Origin" in data ? data.Origin : Vector())
		Crate.SetAbsAngles("Angle" in data ? data.Angle : QAngle(RandomInt(-20, 20), RandomInt(-20, 20), RandomInt(-20, 20)))
		Crate.SetModel("Model" in data ? data.Model : "models/props_hydro/barrel_crate_half.mdl")
		Crate.SetModelScale("scale" in data ? data.scale : 0.5, 0)

		SetPropEntity(Crate, "m_hDamageFilter", FindByName(null, "MeleeOnly"))
		SetPropString(Crate, "m_iszDamageFilterName", "MeleeOnly")

		local scope = GetScope(Crate)

		scope.NoItem 			<- "NoItem" in data ? data.NoItem : false

		if (!scope.NoItem)
			scope.Item 			<- "Item" in data ? data.Item : "BaseItem"

		scope.Cost 				<- "Cost" in data ? data.Cost : 50.0

		scope.TestInteraction 	<- "TestInteraction" in data ? data.TestInteraction		: function( ... ) {}
		scope.OnPassInteraction <- "OnPassInteraction" in data ? data.OnPassInteraction : function( ... ) {}
		scope.OnFailInteraction <- "OnFailInteraction" in data ? data.OnFailInteraction : function( ... ) {}

		scope.BreakParticle 	<- "BreakParticle" in data ? data.BreakParticle : "mvm_loot_explosion"
		scope.ParticleOffset 	<- "ParticleOffset" in data ? data.ParticleOffset : Vector()
		scope.ParticleAngle 	<- "ParticleAngle" in data ? data.ParticleAngle : false

		scope.BreakSound 		<- "BreakSound" in data ? data.BreakSound : "ui/itemcrate_smash_rare.wav"
		scope.BreakSNDLevel 	<- "BreakSNDLevel" in data ? data.BreakSNDLevel : 75

		// !activator 	= entity that Hurts the object
		// !caller 		= this entity
		scope.OnTakeDamage <- function() {
			Assert(activator && activator.IsPlayer(), "Entity was hurt by a NON PLAYER!")
			if (activator.GetTeam() != TF_TEAM_PVE_DEFENDERS)
				return

			TestInteraction(activator)
		}

		scope.BreakEffects <- function() {
			self = caller
			if (scope.BreakParticle) {
				DispatchParticleEffect( BreakParticle, self.GetOrigin()+ParticleOffset, ParticleAngle ? ParticleAngle : self.GetAbsAngles().Forward() )
			}
			if (scope.BreakSound) {
				EmitSoundEx({
					sound_name = BreakSound
					sound_level = 75
					entity = self
				})
			}
		}

		if (!("TestInteraction" in data)) {
			scope.TestInteraction <- function( activator ) {
				Assert(activator && activator.IsPlayer(), "Entity was hurt by a NON PLAYER!")
				self = caller

				if (activator.GetCurrency() < Cost)
					return OnFailInteraction(activator)

				if (scope.BreakParticle) {
					DispatchParticleEffect( BreakParticle, self.GetOrigin()+ParticleOffset, ParticleAngle ? ParticleAngle : self.GetAbsAngles().Forward() )
				}
				if (scope.BreakSound) {
					EmitSoundEx({
						sound_name = BreakSound
						sound_level = 75
						entity = self
					})
				}
				OnPassInteraction(activator)
				if (GetScope(self).MoneyTag && GetScope(self).MoneyTag.IsValid())
					GetScope(self).MoneyTag.Destroy()
				self.AcceptInput("Break", "", activator, self)
			}
		}
		Crate.ConnectOutput("OnTakeDamage", "OnTakeDamage")
		Crate.ConnectOutput("OnBreak", "BreakEffects")

		SetPropInt(Crate, "m_takedamage", DAMAGE_EVENTS_ONLY)


		scope.NoTag <- "NoTag" in data ? data.NoTag : false

		if (!scope.NoTag) {
			scope.MoneyTag <- null
			scope.NextDistThink <- Time() + 0.1

			scope.CrateThink <- function() {
				if (MoneyTag == null || !MoneyTag.IsValid())
				{
					MoneyTag = SpawnEntityFromTable("point_worldtext", {})
					MoneyTag.KeyValueFromString("classname", "fatcat_crate_text")
					MoneyTag.KeyValueFromInt("orientation", 1)
					MoneyTag.KeyValueFromInt("rendermode", 9)
					MoneyTag.AcceptInput("SetColor", "255 255 255 255", null, null)
				}
				MoneyTag.KeyValueFromFloat("textsize", 6)
				MoneyTag.KeyValueFromString("message", "MsgOverride" in data ? data.MsgOverride : format("Cost $%g ( Melee to Open )", Cost.tofloat()))
				MoneyTag.SetAbsOrigin(self.GetOrigin() + Vector(0, 0, 48))

				if (NextDistThink <= Time())
				{
					// fix this getting bots and bots in spec
					if (FindByClassnameWithin(null, "player", self.GetOrigin(), 450))
						MoneyTag.AcceptInput("SetColor", "255 255 255 255", null, null)
					else 
						MoneyTag.AcceptInput("SetColor", "255 255 255 0", null, null)
					NextDistThink = Time() + 0.25
				}
			}
			AddThinkToEnt(Crate, "CrateThink")
		}
		
		scope.ClearAndDestroy <- function() {
			if (!NoTag)
				MoneyTag.Destroy()
			self.Destroy()
		}

		scope.Data <- this

		return Crate
	}

	function SetItem( name = "BaseItem" )
	{
		GetScope(Crate).Item = name
	}
}

class MoneyBarrel extends BaseCrate {
	constructor(data) {
		local new_data = clone data
		new_data.NoTag <- true
		new_data.NoItem <- true
		new_data.Model <- RoR2.BarrelModel
		new_data.Cost <- 25.0
		new_data.scale <- 0.65
		new_data.classname <- "fatcat_barrel_money"
		new_data.TestInteraction <- function( activator ) { 
			Assert(activator && activator.IsPlayer(), "Entity was hurt by a NON PLAYER!")
			self = caller

			OnPassInteraction(activator)
			self.AcceptInput("Break", "", activator, self)
		}
		new_data.OnPassInteraction <- function( player ) { 
			// RoR2.CreateCashAtPos(25 * RoR2.GetMoneyMultiplier(), self.GetOrigin()+Vector(0, 0, 16))
			RoR2.CreateCustomCashAtPos(25 * RoR2.GetMoneyMultiplier(), self.GetOrigin()+Vector(0, 0, 16))

			EmitSoundEx({
				sound_name = "mvm/mvm_bought_upgrade.wav"
				sound_level = 75
				entity = self
			})
		}
		base.constructor(new_data)
	}
}

class BaseItem {
	ItemEnt = null

	constructor(name, pos) {
		this.ItemEnt = SpawnEntityFromTable("env_sprite", {
			model = RoR2.GetSpriteFromItemName(name)
		})
		ItemEnt.KeyValueFromString("classname", "fatcat_dropped_base")
		ItemEnt.KeyValueFromInt("rendermode", 9)
		GetScope(ItemEnt).Item <- name
		GetScope(ItemEnt).OnCollect <- function( player ) {
			/** @type {PlayerData} */
			local dPlayer = RoR2.PlayerToPlayerData(player)

			dPlayer.GiveItem(Item)

			player.PrintToChat(format("Picked up %s, you now have %i", Item, dPlayer.Items[Item]))

			ClearAndDestroy()

			return true
		}


		ItemEnt.SetAbsOrigin(pos)

		local scope = GetScope(ItemEnt)

		scope.ItemTag <- null
		scope.NextDistThink <- Time() + 0.1

		scope.ItemThink <- function() {
			if (!self || !self.IsValid())
				return
			if (ItemTag == null || !ItemTag.IsValid())
			{
				ItemTag = SpawnEntityFromTable("point_worldtext", {})
				ItemTag.KeyValueFromString("classname", "fatcat_item_text")
				ItemTag.KeyValueFromInt("orientation", 1)
				ItemTag.KeyValueFromInt("rendermode", 9)
				ItemTag.AcceptInput("SetColor", "255 255 255 255", null, null)
			}
			ItemTag.KeyValueFromFloat("textsize", 6)
			ItemTag.KeyValueFromString("message", format("%s\nCall Medic to pick up", GetScope(self).Item))
			ItemTag.SetAbsOrigin(self.GetOrigin() + Vector(0, 0, 48))

			if (NextDistThink <= Time())
			{
				if (FindByClassnameWithin(null, "player", self.GetOrigin(), 300))
					ItemTag.EnableDraw()
				else 
					ItemTag.DisableDraw()
				NextDistThink = Time() + 0.25
			}
		}
		AddThinkToEnt(ItemEnt, "ItemThink")

		scope.ClearAndDestroy <- function() {
			ItemTag.Destroy()
			self.Destroy()
		}
	}
}

enum Rarity {
	Unique,
	Genuine
}

function PrintSceneScenes( ents )
{
	foreach (scene in ents)
	{
		printl(scene)
		printl(GetPropString(scene, "m_iszSceneFile"))
		printl(GetPropString(scene, "m_szInstanceFilename"))
		printl(" ")
	}
}

CreateThinker("OnCalledForMedic", function() {
	local players = GetAllEntitiesByClassname("player")
	foreach (player in players) {
		if (player.IsBot() || !player.IsAlive())
			continue
		local scope = GetScope(player)
		if (!("LastCalledMedicTime" in scope))
			scope.LastCalledMedicTime <- 0.0
		
		if (scope.LastCalledMedicTime + 0.25 >= Time())
			continue
		
		if ((player.IsCallingForMedic() && !player.IsMedicButtonDown()) && !("HadHelpmeWarning" in scope))
		{
			player.PrintToChat("\x07FF8080Warning! \x03It seems your call medic button is `voicemenu 0 0` instead of `+helpme`, this gamemode requires `+helpme`")
			player.DisplayHudText( "Warning! It seems your call medic button is `voicemenu 0 0` instead of `+helpme`, this gamemode requires +helpme", "255 0 0", [-1, 0.75], 10, 4 )
			// player.PrintToHud("Warning! It seems your call medic button is `voicemenu 0 0` instead of `+helpme`, this gamemode requires +helpme")
			scope.HadHelpmeWarning <- true
		}

		if (player.IsMedicButtonDown()) {
			scope.LastCalledMedicTime = Time()
			scope.HadHelpmeWarning <- true
			local result = RoR2.PlayerCallMedic(player)
			if (result)
			{
				player.SuppressMedicTalk()
				RunWithDelay(TICK_DUR, @() player.SuppressMedicTalk())
			}
		}
	}
	return 0.1
}, THINKER_PERSIST)

/** 
 * @type {function}
 * @returns {PlayerData}
 */
function CTFPlayer::ToRoR2Data()
{
	return RoR2.PlayerToPlayerData(this)
}


/* function FindGround( start, distance = 192, custom_mask = MASK_PLAYERSOLID ) {
	local trace = {
		start = start
		end = start+Vector(0, 0, -distance)
		mask = custom_mask
	}
	TraceLineEx(trace)

	return trace.pos
} */

::RoR2 <- {
	/// Precache Stuff
	PrecacheData = [
		// models 
		"models/empty.mdl"
		"models/props_hydro/barrel_crate_half.mdl"
		"models/props_farm/wooden_barrel.mdl"

		// items
		"materials/backpack/crafting/ticket_large.vmt"
	]
	PrecacheSounds = [
		"ui/itemcrate_smash_rare.wav",
		"mvm/mvm_bought_upgrade.wav"
	]
	CrateModesl = [
		"models/empty.mdl"
		"models/props_hydro/barrel_crate_half.mdl"
	]
	ItemModels = [
		"materials/backpack/crafting/ticket_large.vmt"
	]

	BarrelModel = "models/props_farm/wooden_barrel.mdl"

	/// Player Stuff
	players = {}
	robots = {}


	/** 
	 * @param {CTFPlayer|CTFBot} player
	 * @returns {PlayerData}
	 */
	function AddPlayer( player ) {
		if (!(player.GetUserID() in players))
			players[player.GetUserID()] <- PlayerData(player)
		return players[player.GetUserID()]
	}

	/** 
	 * @param {CTFPlayer} player
	 * @returns {PlayerData}
	 */
	function PlayerToPlayerData( player )
		return player.IsBot() ? AddRobot(player) : AddPlayer(player)

	function AddRobot( bot ) {
		if (!(bot.GetUserID() in robots))
			robots[bot.GetUserID()] <- bot
		return robots[bot.GetUserID()]
	}

	function RemovePlayer( player ) {
		local data = null
		if (player.GetUserID() in players) {
			data = players[player.GetUserID()]
			delete players[player.GetUserID()]
		}
	}

	/** 
	 * @param {CTFPlayer|integer} ent
	 * @returns {PlayerData}
	 */
	function GetPlayer( ent )
	{
		if (type(ent) == "integer")
			return AddPlayer(GetPlayerFromUserID(ent))
		return AddPlayer(ent)
	}

	/// NavMesh
	Nav = {}
	LargestMesh = null
	/// 

	Crates = []
	Money = 50.0

	/// Convars
	ConVars = {}

	function ResetConvars() {
		foreach (cvar, def in ConVars)
			SetValue(cvar, def)
		ConVars.clear()
	}

	function SetConVar( cvar, value, NoChat = false ) {
		if (NoChat) {
			local node = CreateCommentaryNode()
			EntFireNew(node, "Kill", "", TICK_DUR*7)
		}

		if (!IsConvarAllowed(cvar)) {
			PrintToChatAllF("\x07FF4040[RoR2 Warning]\x07FF0000 \x03\"%s\"\x07FF0000 is Not on the Cvar AllowList!", cvar)
			return
		}

		if (!(cvar in ConVars)) 
			ConVars[cvar] <- GetCvarStr(cvar)

		if (GetCvarStr(cvar) != value)
			RunWithDelay(@() Convars.SetValue(cvar, value.tostring()), 0.1)
	}

	CreateCommentaryNode = @() FindByName( null, "commentary" ) || 
	SpawnEntityFromTable("point_commentary_node", {targetname = "commentary", commentaryfile = " ", commentaryfilenohdr = " "})

	function LoadConvarConfig( FILE = "RoR2ConvarConfig.txt" ) {
		local config = FileToString(FILE)
		if (!config) {
			PrintToChatAllF("\x07FF0000[RoR2 FATAL ERROR]\x07FF8080 Config file \"%s\" is Missing or is Too Large!.", FILE)
			return
		}
			
		local seperator = (config.find("\r\n") ? "\r\n" : "\n")
		config = split(config, seperator, true)
		foreach (cvar in config) {
			cvar = split(cvar, ":")
			local Convar = cvar[0]
			local Value = cvar[1]
			SetConVar(Convar, Value, true)
		}
	}

	StartTime = 0.0

	ItemsData = {}


	// TODO: track last money, and save
	function StartUp() {
		Money = 50.0
		StartTime = Time()

		foreach (item in PrecacheData) {
			if (!IsModelPrecached(item))
				PrecacheModel(item)
		}

		foreach (sound in PrecacheSounds) {
			PrecacheSound(sound)
		}

		ItemsData = InitItems()

		//Convars
		LoadConvarConfig()

		// add warning
		if (MaxClients().tointeger() < 33) {

		}


		// worse performance wise, but is only ran once
		local ps = GetAllEntitiesByClassname("player")
		foreach (pl in ps) {
			local func = pl.IsBot() ? AddRobot : AddPlayer
			func(pl)
		}

		if (Nav.len() == 0)
			NavMesh.GetAllAreas(Nav)

		Assert(Nav.len() != 0, "0 NAV AREAS FOUND! did your forget to make/get nav for this map?")

		LargestMesh = NavMesh.GetLargestArea(true, Nav)

		if (!FindByName(null, "MeleeOnly")) {
			local ent = SpawnEntityFromTable("filter_tf_damaged_by_weapon_in_slot", {targetname = "MeleeOnly"})
			SetPropInt(ent, "m_iWeaponSlot", SLOT_MELEE)
		}

		foreach (ent in GetAllEntitiesByClassname("func_respawnroomvisualizer"))
		{
			printl("Killing: "+ent)
			ent.Destroy()
		}

		SpawnCrates()
		SpawnMoneyBarrels()
	}

	function CleanUp() {
		foreach (ent in GetAllEntitiesByClassname("fatcat*"))
		{
			ClearThinks(ent)
			ent.Destroy()
		}

		delete ::RoR2
	}

	function ClearAllBoxes() {
		foreach (crate in Crates)
		{
			if (crate && crate.IsValid())
				GetScope(crate).ClearAndDestroy()
		}
		Crates.clear()
	}

	/** 
	 * @type {function}
	 * @param {function} SpawnFunc
	 * @param {table} exData
	 * @param {integer} tAttempts
	 * @param {integer} MinDistance
	 * @param {integer} ObjectLimit
	 * @param {string} NoCloseEnt
	 * @param {bool} AllowInSpawn
	 * @param {Vector} SpawnOffset
	 * @param {function} ToSpawnCalc
	 * @param {function} MeshFilter
	 * @param {function} PostSpawnFunc
	 */
	function SpawnObjects( SpawnFunc, exData, tAttempts = 200, MinDistance = 200, ObjectLimit = 100, NoCloseEnt = "fatcat_crate*", AllowInSpawn = false, SpawnOffset = Vector(0, 0, -4 ), ToSpawnCalc = @(...) {}, MeshFilter = @(...) {}, PostSpawnFunc = @(...) {})
	{
		// DebugDrawClear()

		local SpawnedOBJs = 0

		foreach (_, Mesh in Nav) {
			if (!MeshFilter(Mesh))
				continue
			local ToSpawn = ToSpawnCalc(Mesh)

			if (ToSpawn == 0)
				continue
			
			// DebugDrawText(Mesh.GetCenter(), format("Area: %g   Num to Spawn: %d", Mesh.GetArea().tofloat(), ToSpawn), true, 1000)

			local Spawned = 0
			local attempts = 0
			while (attempts < tAttempts && Spawned < ToSpawn)
			{
				attempts++

				if (SpawnedOBJs > ObjectLimit)
					break

				local MeshPos = Mesh.FindRandomSpot()

				local pos = Vector(MeshPos.x, MeshPos.y, Mesh.GetZ(MeshPos)) + SpawnOffset

				if (FindByClassnameNearest(NoCloseEnt, pos, MinDistance))
					continue

				if (!AllowInSpawn && IsPointInRespawnRoom(pos))
					continue

				if (MATH.Distance(pos, Mesh.GetCenter()) > Mesh.GetLargestSide()) {
					// DebugDrawText(pos, format("Distance %g Is Greater than largest Side %g!", MATH.Distance(pos, Mesh.GetCenter()), Mesh.GetLargestSide().tofloat()), false, 1000)
					continue
				}


				Spawned++
				SpawnedOBJs++

				local tempData = exData
				tempData.Origin <- pos
				local obj = SpawnFunc(tempData)
				// DebugDrawText(pos, format("LSide: %g   Distance: %g", Mesh.GetLargestSide().tofloat(), MATH.Distance(pos, Mesh.GetCenter())), true, 1000)
				PostSpawnFunc(obj)
			}
		}
	}

	function SpawnCrates() {
		local data = {
			OnPassInteraction = function( player ) {
				BaseItem(GetScope(self).Item, self.GetOrigin()+Vector(0, 0, 40))
				player.RemoveCurrency(GetScope(self).Cost)
			}
			OnFailInteraction = function( player ) {
				player.TranslateToHud("NO_MONEY", GetScope(self).Cost, player.GetCurrency())
			}
			ParticleOffset = Vector(0, 0, 8)
			// Item = GenerateRandomItem()[0] // 0 is name, 1 is data
		}
		SpawnObjects(BaseCrate, data, 50, 250, 25, "fatcat_*", false, Vector(0,0,-4),
		function( /**@type {CTFNavArea} */mesh ) { //spawncalc
			return MATH.Clamp(log10(mesh.GetArea()-249).tointeger() + RandomInt(-1, 1), 0, 5)
		}, 	
		function( /**@type {CTFNavArea} */mesh ) { //meshfilter
			return !mesh.IsTFInSpawnroom() && mesh.GetArea() > 250
		}, 
		function( obj )  { //postspawnfunc
			Crates.append(obj)
			// PrintTable(obj)
			obj.SetItem(GenerateRandomItem()[0])
		})
	}

	function SpawnMoneyBarrels() {
		SpawnObjects(MoneyBarrel, {}, 50, 350, 10, "fatcat_barrel*", false, Vector(0,0,10)
		function( mesh ) { //spawncalc
			local LArea = log10(LargestMesh.GetArea()-50)
			local a = log10(mesh.GetArea()-50)
			local b = MATH.RemapValClamped(a, 0, LArea, 0, 0.5)
			return (RandomFloat(-0.2, 0.8)+b <= 0.3).tointeger()

			// return (RandomFloat(-0.2, 0.8)+MATH.RemapValClamped(log10(mesh.GetArea()-50), 0, log10(LargestMesh.GetArea()-50), 0, 0.5) <= 0.3).tointeger()
			// return 1
		}, 	
		function( mesh ) { //meshfilter
			return !mesh.IsTFInSpawnroom() && mesh.GetArea() > 50
		},
		function( obj )  { //postspawnfunc
		})
	}

	function GetSpriteFromItemName( name = "" ) {
		switch (name) {
		case "BaseItem" : return "materials/backpack/crafting/ticket_large.vmt"
		default : return "materials/backpack/crafting/ticket_large.vmt"
		}
	}

	function PlayerCallMedic( player ) {
		if (player.IsDead())
			return true
		if (PickUpItem(player))
			return true

		return false
	}

	Raritys = {
		Unique = 0.6
		Genuine = 0.3
	}
	/* 
	enum Rarity {
		Unique,
		Genuine
	}
	 */	

	/** 
	 * @returns {array}
	 */
	function GenerateRandomItem()
	{
		local chance = RandomFloat(0.0, 1.0)
		if (chance < Raritys.Genuine && GetItemsofRarity(Rarity.Genuine).len() != 0)
			return GetRandomItemFromRarity(Rarity.Genuine)
		else return GetRandomItemFromRarity(Rarity.Unique)
	}

	/** 
	 * @param {Rarity} rarity
	 * @returns {array}
	 */
	function GetItemsofRarity( rarity )
	{
		local items = []
		foreach ( name, data in ItemsData )
		{
			if (data.Rarity == rarity)
				items.append([name, data])
		}
		return items
	}

	/** 
	 * @param {Rarity} rarity
	 * @returns {array}
	 */
	function GetRandomItemFromRarity( rarity )
	{
		local items = GetItemsofRarity(rarity)
		return items[RandomInt(0, items.len()-1)]
	}

	/** 
	 * @param {CTFPlayer} player
	 * @param {integer} idx
	 * @returns {bool}
	 */
	function PickUpItem( player, idx = -1 ) {
		local item = idx == -1 ? GetItemInRange(player) : EntIndexToHScript(idx)

		// printl("Player "+player+" Is Attempting to pickup an Item")

		if (!item || !item.IsValid())
			return false

		local ItemName = GetScope(item).Item

		local plrItemCount = PlayerToPlayerData(player).GetItemCount(ItemName) + 1

		local data = ItemsData[ItemName]
		if ("OnApply" in data && data["OnApply"] != null)
			data.OnApply(player, plrItemCount)
		if ("PlayerThink" in data && data["PlayerThink"] != null)
			player.AddThink(data["PlayerThink"], null, 0.5)

		return GetScope(item).OnCollect(player)
	}

	function GetItemInRange( player, range = 90.0 )
	{
		local Trace = {
			start = player.EyePosition()
			end = player.EyePosition() + (player.EyeAngles().Forward().Normalize() * range)
			mask = MASK_PLAYERSOLID_BRUSHONLY
			ignore = player
		}
		TraceLineEx(Trace)
		DebugDrawLine_vCol(Trace.start, Trace.pos, Vector(255, 0, 0), false, 10)
		local ent = FindByClassnameNearest("fatcat_dropped*", Trace.pos, range)
		if (ent)
		{
			DebugDrawLine_vCol(Trace.pos, ent.GetOrigin(), Vector(255, 0, 0), false, 10)
			DebugDrawSphereInternal(ent.GetOrigin(), 90, 255, 0, 0, false, 10)
		}
		// else
			// DebugDrawSphereInternal(Trace.pos, 90, 255, 0, 0, false, 10)
		
		return ent
	}

	function GetMoneyMultiplier()
		return 1.0

	function CreateCashAtPos( amount, origin, giveall = true )
	{
		// models/items/currencypack_small.mdl

		local cash = CreateByClassname("item_currencypack_small")
		cash.KeyValueFromInt("spawnflags", (1 << 30))
		cash.SetAbsOrigin(origin)
		cash.DispatchSpawn()
		cash.SetMoveType(MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE)
		SetPropBool(cash, "m_bDistributed", true)

		GetScope(cash).m_nAmount <- amount

		local impulse = MATH.RandomVec(-1, 1)
		impulse.z = 1.0
		cash.SetAbsVelocity(impulse.Normalize() * 250.0)

		// reset these stats because tf2 adds 5 to the total
		SetPropInt(ObjResource, "m_nMvMWorldMoney", 0)
		SetPropInt(MvMStats, "m_runningTotalWaveStats.nCreditsDropped", 0)
		SetPropInt(MvMStats, "m_currentWaveStats.nCreditsDropped", 0)

		GetScope(cash).OnCollect <- function() {
			if (self == null || !self.IsValid())
				self = caller

			if (!activator || !activator.IsValid() || !activator.IsPlayer() || activator.IsBot())
				return false

			/** @type {CTFPlayer} */
			local Collector = activator
			self.StopSound("MVM.MoneyPickup")

			EmitSoundEx({
				sound_name = "MVM.MoneyPickup"
				channel = 0
				sound_level = MATH.ConvertRadiusToSndLvl(2500)
				entity = Collector
				filter_type = RECIPIENT_FILTER_GLOBAL
			})


			if ( Collector.GetPlayerClass() != TF_CLASS_SCOUT ) {
				if (Collector.GetHealth() < Collector.GetMaxHealth()) {
					Collector.HealPlayer(MATH.Clamp((Collector.GetHealth() / 20.0), 25, Collector.GetMaxHealth()), 2, true, T_HEAL_PACK)
				}
				else {
					Collector.HealPlayer(MATH.Clamp((Collector.GetHealth() / 40.0), 25, Collector.GetMaxHealth()), 2, true, T_HEAL_PACK)
				}
			}

			if (giveall) {
				foreach (_, data in RoR2.players) {
					if (!data.Player.IsValid())
						continue
					data.Player.AddCurrency(amount)
				}
			}
			else {
				Collector.AddCurrency(amount)
			}
		}

		cash.ConnectOutput("OnCacheInteraction", "OnCollect")
		return cash
	}

	function CreateCustomCashAtPos( amount, origin, giveall = true )
	{
		// models/items/currencypack_small.mdl
		local cash = CreateByClassname("prop_dynamic_override")

		EntFire("prop_dynamic_override", "Kill")

		cash.SetModelSimple("models/items/currencypack_small.mdl")
		cash.SetModelScale(1.0, 0)
		cash.SetAbsOrigin(origin)
		cash.DispatchSpawn()
		cash.SetMoveType(MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE)
		cash.KeyValueFromString("classname", "fatcat_custom_cash")

		GetScope(cash).m_nAmount <- amount

		local impulse = MATH.RandomVec(-1, 1)
		impulse.z = 1.0
		cash.SetAbsVelocity(impulse.Normalize() * 250.0)
		cash.SetSize(Vector(-10, -10, -10), Vector(10, 10, 10))

		/**@var {CBaseAnimating} self */
		local function CashThink() {
			self.SetAbsAngles(self.GetAbsAngles() + QAngle(0, 1.5, 0))
			if(self.GetAbsAngles().Yaw() > 360)
				self.SetAbsAngles(QAngle())
			return -1
		}
		AddThinkToEnt(cash, CashThink)

		GetScope(cash).OnCollect <- function() {
			if (self == null || !self.IsValid())
				self = caller

			if (!activator || !activator.IsValid() || !activator.IsPlayer() || activator.IsBot())
				return false

			/** @type {CTFPlayer} */
			local Collector = activator
			self.StopSound("MVM.MoneyPickup")

			EmitSoundEx({
				sound_name = "MVM.MoneyPickup"
				channel = 0
				sound_level = MATH.ConvertRadiusToSndLvl(2500)
				entity = Collector
				filter_type = RECIPIENT_FILTER_GLOBAL
			})


			if ( Collector.GetPlayerClass() != TF_CLASS_SCOUT ) {
				if (Collector.GetHealth() < Collector.GetMaxHealth()) {
					Collector.HealPlayer(MATH.Clamp((Collector.GetHealth() / 20.0), 25, Collector.GetMaxHealth()), 2, true, T_HEAL_PACK)
				}
				else {
					Collector.HealPlayer(MATH.Clamp((Collector.GetHealth() / 40.0), 25, Collector.GetMaxHealth()), 2, true, T_HEAL_PACK)
				}
			}

			if (giveall) {
				foreach (_, data in RoR2.players) {
					if (!data.Player.IsValid())
						continue
					data.Player.AddCurrency(amount)
				}
			}
			else {
				Collector.AddCurrency(amount)
			}
		}

		// cash.ConnectOutput("OnCacheInteraction", "OnCollect")
		return cash
	}


	/**
	 * Fired when a bot dies. 
	 *
	 * @param {table} params
	 * 
	 * # Input table
 	 * ```sqDoc
	 * victim: CTFBot // The bot that died.
	 * attacker: CBaseEntity|null // The entity that killed the victim.
	 * assister: CBaseEntity|null // The entity that assisted the kill.
	 * weapon: CTFWeaponBase|null // The weapon used to kill.
	 * inflictor: CBaseEntity|null // The entity that dealt the damage (e.g. rocket/sentry).
	 * logname: string // The weapon name or inflictor name that relates to a kill-icon.
	 * damagebits: integer // Damage type bits.
	 * weaponIDX: integer // The definition index of the weapon.
	 * death_flags: integer // See TF_DEATH (ln~ 340).
	 * custom: integer // Custom kill type (e.g. headshot).
	 * stun_flags: integer // The victim's stun flags at the moment of death
	 * rocket_jump: bool // True if the attacker was rocket jumping.
	 * ```
	 */
	function OnScriptEvent_BotDeath( params ) {
		/** @type {CTFPlayer|null} */
		local player = params.attacker
		if (!player)
			return
		CreateCashAtPos((params.victim.IsMiniBoss() ? 100 : 10) * GetMoneyMultiplier(), params.victim.GetOrigin()+Vector(0, 0, 16))
	}

	/**
	 * Fired when a human spawns.
	 * 
	 * @param {table} params
	 * 
	 * # Input table
	 * ```sqDoc
	 * player: CTFPlayer // The bot who spawned.
	 * class: integer // The class index of the player.
	 * team: integer // The team index.
	 * ```
	 */
	function OnScriptEvent_HumanSpawn( params ) {
		AddPlayer(params.player)
	}

	/** 
	 * @param {CTFPlayer}		player		The player who called for medic.
	 */
	function OnScriptEvent_OnCalledForMedic( params )
	{
		local player = params.player
		RoR2.PlayerCallMedic(player)

		player.SuppressMedicTalk()
		RunWithDelay(@() player.SuppressMedicTalk(), TICK_DUR)
	}


	function OnGameEvent_mvm_mission_complete( _) {CleanUp( )}
	function OnGameEvent_round_end( _) {CleanUp( )}
	function OnGameEvent_game_end( _) {CleanUp( )}
}
__CollectGameEventCallbacks(RoR2)

IncludeScript("testing/RoR2Items")
RoR2.StartUp()