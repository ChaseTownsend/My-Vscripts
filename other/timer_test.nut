local world_spawn_scope = GetScope(Worldspawn)

function RunWithDelay(func, delay = 0.0)
{
	local func_name = UniqueString()
	world_spawn_scope[func_name] <- function[this]()
	{
		delete world_spawn_scope[func_name]
		func()
	}
	
	EntFireByHandle(Worldspawn, "CallScriptFunction", func_name, delay, null, null)
	return func_name
}

function CreateTimer(on_timer_func, first_delay = 0.0)
{
	local func_name = UniqueString()
	world_spawn_scope[func_name] <- function[this]()
	{	
		try
		{
			local delay = on_timer_func()

			if (delay == null)
			{
				delete world_spawn_scope[func_name]
				return
			}

			// Delays which are less or equal to 0 will be executed in the current tick which leads to an infinite loop
			if (delay <= 0.0)
				delay = 0.01

			EntFireByHandle(Worldspawn, "CallScriptFunction", func_name, delay, null, null)
		}
		catch (err)
		{
			delete world_spawn_scope[func_name]
			throw err
		}
	}

	EntFireByHandle(Worldspawn, "CallScriptFunction", func_name, first_delay, null, null)
	return func_name
}

function KillTimer(func_name)
{
	if (func_name in world_spawn_scope)
		delete world_spawn_scope[func_name]
}

function FireTimer(func_name)
{
	if (func_name in world_spawn_scope)
	{
		world_spawn_scope[func_name]()
		KillTimer(func_name)
	}
}

// Example

local fired = false
local timer = CreateTimer(function()
{
	if (!fired)
	{
		printl("This is the first fire")
		fired = true
		// Repeat after 1 second
		return 1.0
	}
	else
	{
		printl("This is not a first fire")
		// repeat after 2 seconds
		return 2.0
	}
// First fire will be after 1 second
}, 1.0)

// Fire and kill the timer after 7 seconds
RunWithDelay(@() printl("Firing and killing a timer..."), 7.0)
RunWithDelay(@() FireTimer(timer), 7.0)