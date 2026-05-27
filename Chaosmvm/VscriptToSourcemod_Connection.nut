IncludeScript("fatcat_library")

class ETFCond {}


/* // extra to not prevent error
   // remove these when @typedef works
/**
 * @typedef {(integer)} ETFCond
 */

if(!("PrintToServer" in ROOT))
	function ROOT::PrintToServer(m) {PrintToConsoleAll(m)}

::SOURCEMOD_EVENT <- ""
if(!("OnCondHooks" in ROOT))
{
	::OnCondHooks <- array(TF_COND_RANGE, null)
	for (local i = 0; i < TF_COND_RANGE; i++)
		OnCondHooks[i] = {}

	::OnRemoveCondHooks <- array(TF_COND_RANGE, null)
	for (local i = 0; i < TF_COND_RANGE; i++)
		OnRemoveCondHooks[i] = {}
}

if(!("EntitySpawnHooks" in ROOT))
	::EntitySpawnHooks <- {}

/**
 * Description
 * @param {string} classname
 * @param {function} func
 * @param {string} Eventname
 * @returns {string}
 */
function ROOT::HookEntitySpawn(classname, func, Eventname = null)
{
	local name = Eventname == null ? "EntityHook ["+classname+"]__"+UniqueString() : Eventname
	if (classname in EntitySpawnHooks)
	{
		EntitySpawnHooks[classname][name] <- func
	}
	else
	{
		EntitySpawnHooks[classname] <- {}
		EntitySpawnHooks[classname][name] <- func
	}
	return name
}

/**
 * Removes an Entity Spawn Hook
 * @param {string} classname
 * @param {string} name
 */
function RemoveEntitySpawnHook(classname, name)
{
	if(name in EntitySpawnHooks[classname])
		delete EntitySpawnHooks[classname][name]
}

/**
 * Clears Existing CondHooks
 */
function ClearCondHooks()
	for (local i = 0; i < TF_COND_RANGE; i++)
		OnCondHooks[i] = {}

/**
 * Removes a Cond Hook
 * @param {ETFCond} cond
 * @param {string} name
 */
function RemoveCondHook(cond, name)
{
	if(name in OnCondHooks[cond])
		delete OnCondHooks[cond][name]
}

/**
 * Adds a Cond Hook to listen to
 * @param {ETFCond} cond
 * @param {string} name
 * @param {function} func
 */
function AddCondHook(cond, name, func)
{
	if(name in OnCondHooks[cond])
		PrintToServer("Already a Cond Hook with that name!")
	OnCondHooks[cond][name] <- func
}

/**
 * Clears Existing RemoveCondHooks
 */
function ClearRemoveCondHooks()
	for (local i = 0; i < TF_COND_RANGE; i++)
		OnRemoveCondHooks[i] = {}

/**
 * Removes a RemoveCond Hook
 * @param {ETFCond} cond
 * @param {string} name
 */
function RemoveRemoveCondHook(cond, name)
{
	if(name in OnRemoveCondHooks[cond])
		delete OnRemoveCondHooks[cond][name]
}

/**
 * Adds a RemoveCond Hook to listen to
 * @param {ETFCond} cond
 * @param {string} name
 * @param {function} func
 */
function AddRemoveCondHook(cond, name, func)
{
	if(name in OnRemoveCondHooks[cond])
		PrintToServer("Already a Cond Hook with that name!")
	OnRemoveCondHooks[cond][name] <- func
}
/*
	Example
	AddCondHook(TF_COND_CRITBOOSTED, "NoCrits", function(data) {
		data.cond = -1
	})
 */

//int client, TFCond cond, float duration, int provider
/**
 * [ Do Not Manually Call ! ]
 * 
 * DHooks CTFPlayerShared::AddCondition to allow vscript listen to it
 * @param {integer} client 	EntIndex of client effected
 * @param {ETFCond} cond	
 * @param {float} duration	
 * @param {int} provider	EntIndex of client credited
 */
function ROOT::ProccessOnCondHooks(client, cond, duration, provider)
{
	local Player = EntIndexToHScript(client)

	FireScriptEvent("OnPlayerCond", {
		player = Player
		cond = cond
		duration = duration
		provider = EntIndexToHScript(provider)
	})

	local PluginReturn = {
		cond = cond
		duration = duration
		provider = provider
	}

	foreach (_name, callback in OnCondHooks[cond])
	{
		local data = {cond = PluginReturn.cond, duration = PluginReturn.duration, provider = PluginReturn.provider}

		callback.call(Player, data)

		PluginReturn.cond = data.cond
		PluginReturn.duration = data.duration
		PluginReturn.provider = data.provider
	}

	if(PluginReturn.provider != null && type(PluginReturn.provider) != "integer")
	{
		try{
			PluginReturn.provider = PluginReturn.provider.entindex()
		}
		catch(e) {
			PrintToServer(format("(Warning) Tried to get %s's entindex, but it failed with \"%s\"", PluginReturn.provider.tostring(), e))
			PluginReturn.provider = 0
		}
	}

	if(PluginReturn.provider == null)
		PluginReturn.provider = 0

	return PluginReturn
}
/**
 * [ Do Not Manually Call ! ]
 * 
 * DHooks CTFPlayerShared::RemoveCondition to allow vscript to listen to it
 * @param {integer} client	EntIndex of client effected
 * @param {ETFCond} cond
 */
function ROOT::ProccessOnRemoveCondHooks(client, cond)
{
	local Player = EntIndexToHScript(client)

	FireScriptEvent("OnPlayerRemoveCond", {
		player = Player
		cond = cond
	})

	local PluginReturn = {
		cond = cond
	}
	foreach (_name, callback in OnRemoveCondHooks[cond])
	{
		local data = {cond = PluginReturn.cond}

		callback.call(Player, data)

		PluginReturn.cond = data.cond
	}

	return PluginReturn
}


/* function ROOT::SendToSourcemod(...)
{
	SendGlobalGameEvent(SOURCEMOD_EVENT, {
		data = vargv
		manual = true
	})
} */

function ROOT::ProccessEntitySpawnHooks(entity_index, classname)
{
	FireScriptEvent("OnEntitySpawn", {
		entindex = entity_index
		classname = classname
	})
	local ReturnData = {
		prevent_spawn = false
	}
	// local entity = EntIndexToHScript(entity_index)
	foreach (_, hook in EntitySpawnHooks[classname])
	{
		/**
		 * @type {function}
		 * @param {table} data
		 */
		local hook = hook
		local func_data = {
			entindex = entity_index
			classname = classname
		}
		hook(func_data)

		if(func_data.entindex == -1 || func_data.classname == "")
			ReturnData.prevent_spawn = true
	}
	return ReturnData
}

::CollectEvents <- {
	/**
	 * Fired when the Dynamic Hook is triggered
	 * @param {CTFPlayer|CTFBot|null} player
	 * @param {ETFCond} cond
	 * @param {float} duration
	 * @param {CBaseEntity} provider
	 */
	function OnScriptEvent_OnPlayerCond(_params) 		{}
	/**
	 * Fired when the Dynamic Hook is triggered
	 * @param {CTFPlayer|CTFBot|null} player
	 * @param {ETFCond} cond
	 */
	function OnScriptEvent_OnPlayerRemoveCond(_params) 	{}
	/**
	 * Fired when the Dynamic Hook is triggered
	 * @param {integer} entindex
	 * @param {string} classname
	 */
	function OnScriptEvent_OnEntitySpawn(_params) 		{}
}

__CollectGameEventCallbacks(CollectEvents)

