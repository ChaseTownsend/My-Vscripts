
// ReCalculatePlayers()

// if(!IsValidPlayer(Host)) {
// 	foreach (player in Players) {
// 		if(player.IsAdmin()) {
// 			::Host <- player
// 			break
// 		}
// 	}
// }
// ::Host <- GetListenServerHost()

// ::TestTable <- {
// 	function OnScriptHook_OnTakeDamage(params) {
// 		local victim = params.const_entity
// 		if(/* params.const_entity.IsPlayer() &&  */params.inflictor) {
// 			if(params.inflictor.GetClassname() == "tf_weapon_grenade_mirv_projectile" || params.inflictor.GetClassname() == "tf_weapon_grenade_mirv_bomb") {
// 				params.early_out <- true
// 				return
// 			}
// 		}

// 		// PrintTable(params)

// 		if(victim.GetClassname() == "tf_weapon_grenade_mirv_projectile" && params.weapon && params.weapon.GetClassname() == "tf_weapon_wrench" && victim.GetHealth() >= 0) {
// 			printl(victim.GetHealth())
// 			if(victim.GetHealth() == 0) {
// 				victim.SetHealth(130)
// 			}
// 			victim.SetHealth(victim.GetHealth() - params.damage)

// 			if(victim.GetHealth() > 0)
// 				params.early_out <- true
				
// 			// ClientPrint(null, 3, "\x07FF0000FUCK YOU ENGINEER")
// 			ClientPrint(null, 3, "Mirv hit!")
// 		}
// 	}
// }
// __CollectGameEventCallbacks(TestTable)

/** 
 * @param {CTFPlayer} owner
 * @var {CTFWeaponBase} self
 */
function OnPlayerEat(owner) {
	FireScriptEvent("OnPlayerEat", {
		player = owner
		lunchbox = self
	})
	local flIgniteOnEat = self.GetAttribute( "mod ignite on eat", 0 )
	if ( flIgniteOnEat )
		owner.IgnitePlayerEx( flIgniteOnEat )
}

/**
 * @param {CBaseEntity} entity
 */
function LunchboxSpawn(entity)
{
	if ( entity.GetClassname() != "tf_weapon_lunchbox" && entity.GetClassname() != "tf_weapon_lunchbox_drink" )
		return;
	
	Hooks.Add( entity.GetOrCreatePrivateScriptScope(), "ApplyBiteEffects", OnPlayerEat, "OnPlayerEat" );
}

Hooks.Add( this, "OnEntitySpawned", LunchboxSpawn, "LunchboxSpawn" );

::LunchboxEvents <- {
	function OnScriptEvent_OnPlayerEat(params) {
		local player = params.player
		local lunchbox = params.lunchbox

		local attribdata = DecodeAttribAttributeString(lunchbox.GetAttributeString("apply attributes on consume", ""))
		foreach (attribute, data in attribdata) {
			player.AddCustomAttribute(attribute, data[0].tofloat(), data[1])
		}
		local conddata = DecodeAttribCondString(lunchbox.GetAttributeString("apply conds on consume", ""))
		foreach (cond, duration in conddata) {
			player.AddCondEx(cond, duration, lunchbox)
		}
	}
}
__CollectGameEventCallbacks(LunchboxEvents)
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