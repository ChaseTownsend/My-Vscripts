
ReCalculatePlayers()

if(!IsValidPlayer(Host)) {
	foreach (player in Players) {
		if(player.IsAdmin()) {
			::Host <- player
			break
		}
	}
}


/** 
 * @var {CTFPlayer} self
 */
function fuck() {
	local scope = GetScope(self)
	// local message = ""
	for(local i = 0; i <= 149; i++) {
		if((scope.CondDurs[i] == 0.0 || self.GetCondDuration(i) > scope.CondDurs[i]) && self.GetCondDuration(i) != 0.0) 
			printf("Condition %d was applied for %.03f seconds\n", i, (self.GetCondDuration(i) != -1 ? self.GetCondDuration(i) + TICK_DUR : self.GetCondDuration(i)))
		scope.CondDurs[i] = self.GetCondDuration(i)
		// message += i+": " + (self.GetCondDuration(i) != 0.0 ? self.GetCondDuration(i) : "false") + "\n"
	}
	// PrintToHudAll(message)
	self.SetHealth(1)
	return -1
}

foreach (player in Players) {
	if(player == Host)
		continue
	player.RemoveThink("fuck")
	player.AddThink(fuck, "fuck")
	GetScope(player).CondDurs <- array(150, 0.0)
}