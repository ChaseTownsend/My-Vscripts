
// ReCalculatePlayers()

// if(!IsValidPlayer(Host)) {
// 	foreach (player in Players) {
// 		if(player.IsAdmin()) {
// 			::Host <- player
// 			break
// 		}
// 	}
// }
::Host <- GetListenServerHost()

::TestTable <- {
	function OnScriptHook_OnTakeDamage(params) {
		local victim = params.const_entity
		if(/* params.const_entity.IsPlayer() &&  */params.inflictor) {
			if(params.inflictor.GetClassname() == "tf_weapon_grenade_mirv_projectile" || params.inflictor.GetClassname() == "tf_weapon_grenade_mirv_bomb") {
				params.early_out <- true
				return
			}
		}

		// PrintTable(params)

		if(victim.GetClassname() == "tf_weapon_grenade_mirv_projectile" && params.weapon && params.weapon.GetClassname() == "tf_weapon_wrench" && victim.GetHealth() >= 0) {
			printl(victim.GetHealth())
			if(victim.GetHealth() == 0) {
				victim.SetHealth(130)
			}
			victim.SetHealth(victim.GetHealth() - params.damage)

			if(victim.GetHealth() > 0)
				params.early_out <- true
				
			// ClientPrint(null, 3, "\x07FF0000FUCK YOU ENGINEER")
			ClientPrint(null, 3, "Mirv hit!")
		}
	}
}
__CollectGameEventCallbacks(TestTable)

// /** 
//  * @var {CTFPlayer} self
//  */
// function fuck() {
// 	local scope = GetScope(self)
// 	// local message = ""
// 	for(local i = 0; i <= 149; i++) {
// 		if((scope.CondDurs[i] == 0.0 || self.GetCondDuration(i) > scope.CondDurs[i]) && self.GetCondDuration(i) != 0.0) 
// 			printf("Condition %d was applied for %.03f seconds\n", i, (self.GetCondDuration(i) != -1 ? self.GetCondDuration(i) + TICK_DUR : self.GetCondDuration(i)))
// 		scope.CondDurs[i] = self.GetCondDuration(i)
// 		// message += i+": " + (self.GetCondDuration(i) != 0.0 ? self.GetCondDuration(i) : "false") + "\n"
// 	}
// 	// PrintToHudAll(message)
// 	self.SetHealth(1)
// 	return -1
// }

// foreach (player in Players) {
// 	if(player == Host)
// 		continue
// 	player.RemoveThink("fuck")
// 	player.AddThink(fuck, "fuck")
// 	GetScope(player).CondDurs <- array(150, 0.0)
// }