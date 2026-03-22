IncludeScript("fatcat_library")

::respawn <- {
	function OnGameEvent_player_spawn(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local scope = GetScope(player)
		scope.ThinkTable <- {
			PrintTime = {
				owner = player
				LastThinkTime = -1
				delay = 0.995
				func = function(self) {
					// self is the player, "this" is the table above
					self.PrintToHud(Time())
				}
			}
			Heal = {
				delay = 1
				func = function(self) {
					self.SetHealth(self.GetHealth() + (self.GetMaxHealth() /10))
					if(self.GetHealth() > self.GetMaxHealth() * 1.5)
						self.SetHealth(self.GetMaxHealth()*1.5)
				}
			}
			/* Heal = {
				owner = player
				LastThinkTime = Time()
				delay = 0.2
				func = function(self) {
					owner.SetHealth(owner.GetHealth() + 1)
				}
			} */
		}
		foreach (key, func_table in scope.ThinkTable)
		{
			if(IsNotInTable("LastThinkTime", func_table))
			{
				func_table.LastThinkTime <- Time()
				// PrintToChatAll("\x07FF9090Warning\x01, "+key+" had no \"LastThinkTime\" input, Creating Value. . .")
			}
			if(IsNotInTable("delay", func_table))
			{
				func_table.delay <- -1
				PrintToChatAll("\x07FF9090Warning\x01, "+key+" had no \"delay\" input, defaulting to \"-1\"")
			}
			if(IsNotInTable("func", func_table) )
			{
				PrintToChatAll("\x07FF9090Warning\x01, "+key+" is Missing it's \"func\" input, deleting table!")
				delete scope.ThinkTable[key]
				continue
			}
		}
		ClearThinks(player)
		scope.ThinkTableThink <- function() {
			foreach (key, func_table in ThinkTable)
			{
				if(func_table.LastThinkTime + func_table.delay <= Time())
				{
					func_table.func.call(func_table, player)
					func_table.LastThinkTime = Time()
				}
			}
			return -1
		}
		AddThinkToEnt(player, "ThinkTableThink")
	}
}
__CollectGameEventCallbacks(respawn)