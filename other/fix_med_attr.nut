IncludeScript("fatcat_library")

AddThinkToEnt(Host, "disp_think")

function disp_think() {
	// Host.PrintToHud("Hi")
	foreach (dispenser in GetAllEntitiesByClassname("obj_dispenser"))
	{
		printl(GetPropType(dispenser, "m_hTouchingEntities"))
		Host.PrintToHud("Hi")
	}
	return 5
}

::med_events <- {
	function OnGameEvent_post_inventory_application(params) {
		local scope = GetScope(GetPlayerFromUserID(params.userid))
		scope.Healers <- []
		scope.ThinkTable <- {}
		scope.GetHealers <- function() {
			foreach (player in Players)
			{
				if(player.GetHealTarget() == self)
					Healers.append(player)
			}
		}
		scope.ThinkTable.HealerThink <- {
			LastRun = 0
			delay = 0
			think =	function() {
				local DeadHealers = []
				foreach (Healer in Healers) {
					if(Healer.IsPlayer() && player.GetHealTarget() != self) {
						DeadHealers.append(Healer)
						continue
					}
					// if(Healer.GetClassname() == "obj_dispencer" && GetPropEntityArray(Healer, ""))
					
					if(Healer.IsDead()) {
						local active = self.GetActiveWeapon()
						if(active.GetAttribute("mod medic killed minicrit boost", 0))
							self.AddCondEx(TF_COND_MINICRITBOOSTED_ON_KILL, active.GetAttribute("mod medic killed minicrit boost", 0), Healer)
						
						DeadHealers.append(Healer)
					}

				}
				foreach (Healer in DeadHealers) {
					Healers.remove(Healers.find(Healer))
				}
			}
		}
		scope.MultiThink <- function() {
			foreach (thinktab in ThinkTable) {
				if(thinktab.LastRun <= Time())
				{
					thinktab.think()
					thinktab.LastRun <- Time() + thinktab.delay
				}
			}
		}
		AddThinkToEnt(GetPlayerFromUserID(params.userid), "MultiThink")
	}
}