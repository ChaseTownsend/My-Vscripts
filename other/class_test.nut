function GetPropSetFunction(type)
{
	switch (type) {
		case "integer": 	{ return SetPropInt }
		case "float":		{ return SetPropFloat }
		case "instance":	{ return SetPropEntity }
		case "vector":		{ return SetPropVector }
		case "bool":		{ return SetPropBool }
		case "string":		{ return SetPropString }
		default: throw format("Warning Unknown Prop Type %s", type)
	}
	return null
}

function GetPropGetFunction(type) {
	switch (type) {
		case "integer": 	{ return GetPropInt }
		case "float":		{ return GetPropFloat }
		case "instance":	{ return GetPropEntity }
		case "vector":		{ return GetPropVector }
		case "bool":		{ return GetPropBool }
		case "string":		{ return GetPropString }
		default: throw format("Warning Unknown Prop Type %s", type)
	}
	return null
}

::CustomPlayers <- {}
class TestPlayer {
	player = null

	function AddPlayer(player)
	{
		if(player == null)
			return
		this.player = player
		return this
	}
}
local test = TestPlayer()
test.AddPlayer(Host)
if(!(Host in CustomPlayers))
	CustomPlayers[Host] <- []
CustomPlayers[Host].push(this)

// CustomPlayers.append(TestPlayer(Host))

return
















::NAN <- fabs(0.0 / 0.0)

function GetPropSetFunction(type)
{
	switch (type) {
		case "integer": 	{ return SetPropInt }
		case "float":		{ return SetPropFloat }
		case "instance":	{ return SetPropEntity }
		case "vector":		{ return SetPropVector }
		case "bool":		{ return SetPropBool }
		case "string":		{ return SetPropString }
		default: throw format("Warning Unknown Prop Type %s", type)
	}
	return null
}

function GetPropGetFunction(type) {
	switch (type) {
		case "integer": 	{ return GetPropInt }
		case "float":		{ return GetPropFloat }
		case "instance":	{ return GetPropEntity }
		case "vector":		{ return GetPropVector }
		case "bool":		{ return GetPropBool }
		case "string":		{ return GetPropString }
		default: throw format("Warning Unknown Prop Type %s", type)
	}
	return null
}

::ChaosPlayers <- []

class ChaosPlayer {
	player = null

	constructor(player_ent)
	{
		// PrintTable(this)
		this.player = player_ent
		/* if("ChaosPlayers" in ROOT)
		{
			if(ChaosPlayers.find(this) != null)
				ChaosPlayers[ChaosPlayers.find(this)] <- this
			else 
				ChaosPlayers.append(this)
		} */
		return this
	}

	function _get ( item ) {
		if(!player || !player.IsValid())
			return NAN

		if(HasProp(this.player, item))
		{
			local func = GetPropGetFunction(GetPropType(this.player, item))
			func(this.player, item)
			/* switch (GetPropType(this.player, item))
			{
				case "integer":
				{
					return GetPropInt(this.player, item)
				}
				case "float":
				{
					return GetPropFloat(this.player, item)
				}
				case "instance":
				{
					return GetPropEntity(this.player, item)
				}
				case "vector":
				{
					return GetPropVector(this.player, item)
				}
				case "bool":
				{
					return GetPropBool(this.player, item)
				}
				case "string":
				{
					return GetPropString(this.player, item)
				}
				default:
					throw format("Warning Unknown Prop Type %s", GetPropType(this.player, item))
			} */
		}

		if(item in this)
			return this[item]

		return NAN
	}
	function _set ( item , value ) {
		if(!player || !player.IsValid())
			return

		return; 

		if(HasProp(this.player, item))
		{
			switch (GetPropType(this.player, item))
			{
				case "integer": 	{ SetPropInt(this.player, item, value) }
				case "float":		{ SetPropFloat(this.player, item, value) }
				case "instance":	{ SetPropEntity(this.player, item, value) }
				case "vector":		{ SetPropVector(this.player, item, value) }
				case "bool":		{ SetPropBool(this.player, item, value) }
				case "string":		{ SetPropString(this.player, item, value) }
				default: throw format("Warning Unknown Prop Type %s", GetPropType(this.player, item))
			}
		}

		if(item in this)
			return this[item]

		return NAN
	}
}


class CustomPlayer {
	player = null

	constructor(player_ent)
	{
		this.player = player_ent
		return this
	}

	function _get ( item ) {
		if(!player || !player.IsValid())
			return NAN

		try {
			return CTFPlayer._get(item)
		}
		catch(e)
		{
			printl(e)
		}

		return 1
		
		if(HasProp(this.player, item))
		{
			switch (GetPropType(this.player, item))
			{
				case "integer":
				{
					return GetPropInt(this.player, item)
				}
				case "float":
				{
					return GetPropFloat(this.player, item)
				}
				case "instance":
				{
					return GetPropEntity(this.player, item)
				}
				case "vector":
				{
					return GetPropVector(this.player, item)
				}
				case "bool":
				{
					return GetPropBool(this.player, item)
				}
				case "string":
				{
					return GetPropString(this.player, item)
				}
				default:
					throw format("Warning Unknown Prop Type %s", GetPropType(this.player, item))
			}
		}

		if(item in this)
			return this[item]

		return NAN
	}
	/* function _set ( item , value ) {
		if(!player || !player.IsValid())
			return

		if(HasProp(this.player, item))
		{
			switch (GetPropType(this.player, item))
			{
				case "integer": 	{ SetPropInt(this.player, item, value) }
				case "float":		{ SetPropFloat(this.player, item, value) }
				case "instance":	{ SetPropEntity(this.player, item, value) }
				case "vector":		{ SetPropVector(this.player, item, value) }
				case "bool":		{ SetPropBool(this.player, item, value) }
				case "string":		{ SetPropString(this.player, item, value) }
				default: throw format("Warning Unknown Prop Type %s", GetPropType(this.player, item))
			}
		}

		if(item in this)
			return this[item]

		return NAN
	} */
}