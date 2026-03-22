::CTank <- {
	function OnScriptHook_OnTakeDamage(params)
	{
		if(params.const_entity.GetClassname() != "vscript_boss")
			return
		// PrintCollection(params)
	}
	function OnGameEvent_BaseBossHurt(params)
	{
	}
	function OnGameEvent_BaseBossKilled(params)
	{
	}
}
__CollectGameEventCallbacks(CTank)

// const TANK_MODEL = "models/bots/boss_bot/boss_tank.mdl"
// const TANK_MODEL = "models/player/items/taunts/tank/tank.mdl"
const TANK_MODEL = "models/bots/boss_bot/static_boss_tank.mdl"

/* 
[
	{
		pos = Vector()
		name = ""
		next_node = ""
	}
]
 */

::tracks <- [
	{
		pos = Vector(0, -100, -126), 
		name = "track4", 
		next_node = "track1"
	},
	{
		pos = Vector(-70, -500, -126), 
		name = "track3", 
		next_node = "track4"
	},
		{
		pos = Vector(400, -500, -126), 
		name = "track2", 
		next_node = "track3"
	},
	{
		pos = Vector(400, -130, -126), 
		name = "track1", 
		next_node = "track2"
	},
]
// CreatePath(tracks)

function CreatePath(values)
{
	foreach (item in values)
	{
		local track = SpawnEntityFromTable("path_track", {
			targetname 	= "name" in item ? item.name : UniqueString("TRACK:")
			origin 		= "pos" in item ? item.pos : Vector()
		})
		GetScope(track).target_name <- "next_node" in item ? item.next_node : ""
		EntFireNew(track, "RunScriptCode", "GetScope(self).target <- FindByName(null, GetScope(self).target_name)", 0.2)
		EntFireNew(track, "RunScriptCode", "SetPropEntity(self, `m_pnext`, GetScope(self).target)", 0.25)
		EntFireNew(track, "RunScriptCode", "printl(self + ` : ` + GetPropEntity(self, `m_pnext`))", 0.3)
	}
}

function DrawPathTracks()
{
	foreach (track in GetAllEntitiesByClassname("path_track"))
	{
		DebugDrawBox(track.GetOrigin(), Vector(12, 12, 12), Vector(-12, -12, -12), 255, 255, 255, 5, 10)
		if(GetPropEntity(track, "m_pnext") != null)
		{
			DebugDrawLine_vCol(track.GetOrigin(), GetPropEntity(track, "m_pnext").GetOrigin(), Vector(0, 255, 0), false, 10)
		}
	}
}


function CreateCustomTank(params)
{
	local health 	= "health" 		in params ? params.health 		: 1000
	local model 	= "model" 		in params ? params.model 		: TANK_MODEL
	local name 		= "targetname" 	in params ? params.targetname 	: ""
	local starting	= "startnode"	in params ? params.startnode	: ""

	local tank = SpawnEntityFromTable("base_boss", {
		targetname = name
		health = health
		model = model
	})
	tank.KeyValueFromString("classname", "vscript_boss")
	if(typeof starting == "string")
		tank.SetAbsOrigin(FindByName(null, starting).GetOrigin())
	else 
		tank.SetAbsOrigin( starting ? starting.GetOrigin() : Vector() )

	// printl(GetPropVector(tank, "m_Collision.m_vecMins"))
	// printl(GetPropVector(tank, "m_Collision.m_vecMaxs"))

	// Scope info
	local scope = GetScope(tank)

	scope.starting_node <- typeof starting == "string" ? FindByName(null, starting) : starting

	if(scope.starting_node == null)
	{
		printl("Found no Starting Node")
		return tank
	}

	// scope.current_node 	<- scope.starting_node
	scope.next_node 	<- GetPropEntity(scope.starting_node, "m_pnext")

	// Locomotion
	scope.Navigation <- tank.GetLocomotionInterface()
	scope.TrackThink <- function() {
		if(next_node == null)
			return -1

		// Navigation.DriveTo(next_node.GetOrigin())
		Navigation.Approach(next_node.GetOrigin(), 10000)
		Navigation.FaceTowards(next_node.GetOrigin())

		DebugDrawText(self.GetOrigin(), Navigation.GetVelocity().ToKVString(), false, 5)
		
		if(MATH.Distance(self.GetOrigin(), next_node.GetOrigin()) < 100)
		{
			next_node = GetPropEntity(next_node, "m_pnext")
		}
		return -1
	}
	scope.TankThink  <- function() {
		// Assert("TrackThink" in this, "Custom Tank is missing \"TrackThink\" function in scope")
		DebugDrawClear()

		TrackThink()
		DebugDrawTrigger(self)

		Navigation.SetDesiredSpeed(300)
		Navigation.SetSpeedLimit(300)
		self.SetSolid(SOLID_OBB)

		return -1
	}
	AddThinkToEnt(tank, "TankThink")
	return tank
}

function tankthink()
{
	
}