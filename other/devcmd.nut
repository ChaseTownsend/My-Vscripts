::DevFuncCollect <- {
	function OnGameEvent_player_say(params) {
		local player = GetPlayerFromUserID(params.userid)
		if(player != null)
		{
			if(IsPlayerABot(player))
				return
			if(!player.IsAdmin())
				return
		}
		if(split(params.text, " ")[0] == "-slay")
		{
			local target_class = TF_CLASS_UNDEFINED
			local target_team = TF_TEAM_ANY
			local text = split(params.text, " ")
			printl(split(text[1], "@")[1].tolower())
			switch (split(text[1], "@")[1].tolower())
			{
			case "red": {
				target_team = TF_TEAM_RED
				break
			}
			case "blue": {
				target_team = TF_TEAM_BLUE
				break
			}
			///
			case "scout": {
				target_class = TF_CLASS_SCOUT
				break
			}
			case "soldier": {
				target_class = TF_CLASS_SOLDIER
				break
			}
			case "pyro": {
				target_class = TF_CLASS_PYRO
				break
			}
			case "demo": {
				target_class = TF_CLASS_DEMOMAN
				break
			}
			case "heavy": {
				target_class = TF_CLASS_HEAVYWEAPONS
				break
			}
			case "engineer": {
				target_class = TF_CLASS_ENGINEER
				break
			}
			case "medic": {
				target_class = TF_CLASS_MEDIC
				break
			}
			case "sniper": {
				target_class = TF_CLASS_SNIPER
				break
			}
			case "spy": {
				target_class = TF_CLASS_SPY
				break
			}
			}
			foreach (play in Players)
			{
				if(target_team != TF_TEAM_ANY && play.GetTeam() != target_team)
					continue
				if(target_class != TF_CLASS_UNDEFINED && play.GetPlayerClass() != target_class)
					continue
				if(play == player)
					continue
				if(play.InAnyRespawnRoom())
				{
					if(text.len() > 2 && text[2] == "-inspawn")
						play.TakeDamageEx(null, null, null, Vector(0, 0, 1000), Vector(0, 0, 1), play.GetMaxHealth() * 10, DMG_GENERIC)
				}
				else
					play.TakeDamageEx(null, null, null, Vector(0, 0, 1000), Vector(0, 0, 1), play.GetMaxHealth() * 10, DMG_GENERIC)

				/* if(text.len() > 2 && text[2] == "-inspawn")
				{
					play.TakeDamage(play.GetMaxHealth() * 10, DMG_GENERIC, player)
				}
				else
				{
					if(play.InAnyRespawnRoom())
						continue
					play.TakeDamage(play.GetMaxHealth() * 10, DMG_GENERIC, player)
				} */
			}
			return
			/* if (text[1] == "@red" || text[1] == "@blue")
			{
				// local target_team = TF_TEAM_ANY
				switch (text[1])
				{
					case "@red": {
						target = "TF_TEAM_RED"
						break
					}
					case "@blue": {
						target = "TF_TEAM_BLUE"
						break
					}
				}
				foreach (play in Players)
				{
					if(play.GetTeam() != target)
						continue
					if(play == player)
						continue
					if(text.len() > 2 && text[2] == "-inspawn")
					{
						play.TakeDamage(play.GetMaxHealth() * 10, DMG_GENERIC, player)
					}
					else
					{
						if(play.InAnyRespawnRoom())
							continue
						play.TakeDamage(play.GetMaxHealth() * 10, DMG_GENERIC, player)
					}
				}
			}
			else
			{
				switch (text[1].tolower())
				{
					case "@scout": {
						target = TF_CLASS_SCOUT
						break
					}
					case "@soldier": {
						target = TF_CLASS_SOLDIER
						break
					}
					case "@pyro": {
						target = TF_CLASS_PYRO
						break
					}
					case "@demo": {
						target = TF_CLASS_DEMOMAN
						break
					}
					case "@heavy": {
						target = TF_CLASS_HEAVYWEAPONS
						break
					}
					case "@engineer": {
						target = TF_CLASS_ENGINEER
						break
					}
					case "@medic": {
						target = TF_CLASS_MEDIC
						break
					}
					case "@sniper": {
						target = TF_CLASS_SNIPER
						break
					}
					case "@spy": {
						target = TF_CLASS_SPY
						break
					}
				}
				foreach(play in Players)
				{
					if(!IsPlayerABot(play))
						continue
					if(play.GetPlayerClass() != target.tointeger())
						continue
					play.TakeDamage(play.GetMaxHealth() * 10, DMG_GENERIC, player)
				}
			} */
		}
		if(split(params.text, " ")[0] == "-tele")
		{
			local text = split(params.text, " ")
			if (text[1] == "@red" || text[1] == "@blue")
			{
				local target_team = TF_TEAM_ANY
				switch (text[1])
				{
					case "@red": {
						target_team = TF_TEAM_RED
						break
					}
					case "@blue": {
						target_team = TF_TEAM_BLUE
						break
					}
				}
				printl(target_team)
				foreach (play in Players)
				{
					if(play.GetTeam() != target_team)
						continue
					if(play == player)
						continue
					if(text.len() > 3 && text[3] == "-inspawn")
					{
						play.Teleport(true, player.GetOrigin(), false, QAngle(), false, Vector())
					}
					else
					{
						if(play.InAnyRespawnRoom())
							continue
						play.Teleport(true, player.GetOrigin(), false, QAngle(), false, Vector())
					}
				}
			}
			else if (text[1] == "-class")
			{
				local target_class = TF_CLASS_UNDEFINED
				switch (text[2].tolower())
				{
					case "scout": {
						target_class = TF_CLASS_SCOUT
						break
					}
					case "soldier": {
						target_class = TF_CLASS_SOLDIER
						break
					}
					case "pyro": {
						target_class = TF_CLASS_PYRO
						break
					}
					case "demo": {
						target_class = TF_CLASS_DEMOMAN
						break
					}
					case "heavy": {
						target_class = TF_CLASS_HEAVYWEAPONS
						break
					}
					case "engineer": {
						target_class = TF_CLASS_ENGINEER
						break
					}
					case "medic": {
						target_class = TF_CLASS_MEDIC
						break
					}
					case "sniper": {
						target_class = TF_CLASS_SNIPER
						break
					}
					case "spy": {
						target_class = TF_CLASS_SPY
						break
					}
				}
				foreach(play in Players)
				{
					if(!IsPlayerABot(play))
						continue
					if(play.GetPlayerClass() != target_class)
						continue
					play.Teleport(true, player.GetOrigin(), false, QAngle(), false, Vector())
				}
			}
		}
		if(split(params.text, " ")[0] == "-slap")
		{
			local text = split(params.text, " ")
			local damage = text[1].tointeger()
			if (text[2] == "@red" || text[2] == "@blue")
			{
				local target_team = TF_TEAM_ANY
				switch (text[2])
				{
					case "@red": {
						target_team = TF_TEAM_RED
						break
					}
					case "@blu": {
						target_team = TF_TEAM_BLUE
						break
					}
				}
				foreach (play in Players)
				{
					if(play.GetTeam() != target_team)
						continue
					if(play == player)
						continue
					if(text.len() > 4 && text[4] == "-inspawn")
					{
						play.TakeDamage(damage, DMG_GENERIC, player)
					}
					else
					{
						if(play.InAnyRespawnRoom())
							continue
						play.TakeDamage(damage, DMG_GENERIC, player)
					}
				}
			}
			else if (text[2] == "-class")
			{
				local target_class = TF_CLASS_UNDEFINED
				switch (text[3].tolower())
				{
					case "scout": {
						target_class = TF_CLASS_SCOUT
						break
					}
					case "soldier": {
						target_class = TF_CLASS_SOLDIER
						break
					}
					case "pyro": {
						target_class = TF_CLASS_PYRO
						break
					}
					case "demo": {
						target_class = TF_CLASS_DEMOMAN
						break
					}
					case "heavy": {
						target_class = TF_CLASS_HEAVYWEAPONS
						break
					}
					case "engineer": {
						target_class = TF_CLASS_ENGINEER
						break
					}
					case "medic": {
						target_class = TF_CLASS_MEDIC
						break
					}
					case "sniper": {
						target_class = TF_CLASS_SNIPER
						break
					}
					case "spy": {
						target_class = TF_CLASS_SPY
						break
					}
				}
				foreach(play in Players)
				{
					if(!IsPlayerABot(play))
						continue
					if(play.GetPlayerClass() != target_class)
						continue
					play.TakeDamage(damage, DMG_GENERIC, player)
				}
			}
		}
	}
}
__CollectGameEventCallbacks(DevFuncCollect)