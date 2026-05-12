IncludeScript("fatcat_library")

/* // extra to not prevent error
   // remove these when @typedef works
/**
 * @typedef {(integer)} ETFCond
 */

if(!("PrintToServer" in ROOT))
	function ROOT::PrintToServer(m) {PrintToConsoleAll(m)}

::SOURCEMOD_EVENT <- ""
::OnCondHooks <- array(TF_COND_RANGE, null)
::OnRemoveCondHooks <- array(TF_COND_RANGE, null)

::PLUGIN_CONTINUE = 0
::PLUGIN_CHANGED = 1
::PLUGIN_HANDLED = 2

/**
 * Clears Existing CondHooks
 */
function ClearCondHooks()
	for (local i = 0; i < TF_COND_RANGE; i++)
		OnCondHooks[i] = {}

/**
 * Removes a Cond Hook
 * @param {integer} cond
 * @param {string} name
 */
function RemoveCondHook(cond, name)
{
	if(name in OnCondHooks[cond])
		delete OnCondHooks[cond][name]
}

/**
 * Adds a Cond Hook to listen to
 * @param {integer} cond
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
 * @param {integer} cond
 * @param {string} name
 */
function RemoveRemoveCondHook(cond, name)
{
	if(name in OnRemoveCondHooks[cond])
		delete OnRemoveCondHooks[cond][name]
}

/**
 * Adds a RemoveCond Hook to listen to
 * @param {integer} cond
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
		return data
	})
	// this would cancel any condition if you set the cond number to -1
 */

//int client, TFCond cond, float duration, int provider
/**
 * [ Do Not Manually Call ! ]
 * 
 * Hooks Sourcemods TF2_AddCondition to allow vscript to use it
 * @param {integer} client
 * @param {integer} cond
 * @param {float} duration
 * @param {int} provider
 */
function ROOT::ProccessOnCondHooks(client, cond, duration, provider)
{
	local Player = EntIndexToHScript(client)

	local PluginReturn = {
		ReturnType = PLUGIN_CONTINUE, 
		cond = cond
		duration = duration
		provider = provider
	}

	foreach (_name, callback in OnCondHooks[cond])
	{
		local data = {cond = PluginReturn.cond, duration = PluginReturn.duration, provider = PluginReturn.provider}
		if(PluginReturn.ReturnType == PLUGIN_HANDLED)
		{
			local cloned_data = clone data
			callback.call(Player, cloned_data)
			continue
		}
		else
		{
			callback(data)
		}

		if(data.cond == -1)
			PluginReturn.ReturnType = PLUGIN_HANDLED

		if(PluginReturn.ReturnType != PLUGIN_HANDLED)
		{
			if(data.cond != PluginReturn.cond)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.cond = data.cond
			}
			if(data.duration != PluginReturn.duration)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.duration = data.duration
			}
			if(data.provider != PluginReturn.provider)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.duration = data.duration
			}
		}
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

	return PluginReturn
}
/**
 * [ Do Not Manually Call ! ]
 * 
 * Hooks Sourcemods TF2_RemoveCondition to allow vscript to use it
 * @param {integer} client
 * @param {integer} cond
 * @param {float} duration
 * @param {int} provider
 */
function ROOT::ProccessOnRemoveCondHooks(client, cond, duration, provider)
{
	local Player = EntIndexToHScript(client)

	local PluginReturn = {
		ReturnType = PLUGIN_CONTINUE, 
		cond = cond
		duration = duration
		provider = provider
	}

	foreach (_name, callback in OnRemoveCondHooks[cond])
	{
		local data = {cond = PluginReturn.cond, duration = PluginReturn.duration, provider = PluginReturn.provider}
		if(PluginReturn.ReturnType == PLUGIN_HANDLED)
		{
			local cloned_data = clone data
			callback.call(Player, cloned_data)
			continue
		}
		else
		{
			callback(data)
		}

		if(data.cond == -1)
			PluginReturn.ReturnType = PLUGIN_HANDLED

		if(PluginReturn.ReturnType != PLUGIN_HANDLED)
		{
			if(data.cond != PluginReturn.cond)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.cond = data.cond
			}
			if(data.duration != PluginReturn.duration)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.duration = data.duration
			}
			if(data.provider != PluginReturn.provider)
			{
				PluginReturn.ReturnType = PLUGIN_CHANGED
				PluginReturn.duration = data.duration
			}
		}
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

	return PluginReturn
}

function ROOT::SendToSourcemod(...)
{
	SendGlobalGameEvent(SOURCEMOD_EVENT, {
		data = vargv
		manual = true
	})
}
