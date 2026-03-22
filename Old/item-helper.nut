IncludeScript("fatcat_library")

const item_help_color = "\x08FFFF00DD"
const text_color = "\x08FFFFFFBB"
const item_help_color_header = "\x0826c2ffDD"
const text_color_header = "\x0826beffBB"
const error_color = "\x07D43F3F"

SetScriptVersion("item_helper", "1.0.0")

::helper <-{
	/////////////////
	function OnGameEvent_player_spawn(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		if(IsPlayerABot(player)) return

		if(params.team != Constants.ETFTeam.TEAM_UNASSIGNED)
		{
			local scope = GetScope(player)
			if(IsNotInScope("spawncount", scope))
				scope.spawncount <- 0

			if(IsNotInScope("SpawnHelper", scope))
				scope.SpawnHelper <- 2

			scope.spawncount++
		}
		else
		{
			local scope = GetScope(player)
			scope.spawncount <- 0
			scope.SpawnHelper <- 2
		}
	}
	//////////////////
	function OnGameEvent_post_inventory_application(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		if(IsPlayerABot(player)) return

		local scope = GetScope(player)

		if(IsNotInScope("spawncount", scope)) 	return
		if(IsNotInScope("SpawnHelper", scope)) 	return
		if(scope.SpawnHelper == 0) return
		if(scope.spawncount <= 0) return

		if(scope.SpawnHelper == 2 || (scope.SpawnHelper == 1 && GetRoundState() != 4))
		{
			player.PrintToChat(item_help_color_header + "[►]"  + text_color_header + " Your loadout includes...")

			local weapons = player.GetAllWeapons()
			foreach (weapon in weapons)
			{
				switch (GetWeaponIDX(weapon))
				{
					// Primary
                    case 13:
                    case 200:
                    case 669:
                    case 799:
                    case 808:
                    case 888:
                    case 897:
                    case 906:
                    case 915:
                    case 964:
                    case 973:
                    case 15002:
                    case 15015:
                    case 15021:
                    case 15029:
                    case 15036:
                    case 15053:
                    case 15065:
                    case 15069:
                    case 15106:
                    case 15107:
                    case 15108:
                    case 15131:
                    case 15151:
                    case 15157: {player.PrintToChat(item_help_color + "[SCATTERGUN] " + text_color + "Standard option for reliable damage. Highly effective at close range."); break}
                    case 45:
                    case 1078: {player.PrintToChat(item_help_color + "[FORCE-A-NATURE] " + text_color + "Enhanced knockback on hit. Slightly lower DPS than Scattergun."); break}
                    case 220: {player.PrintToChat(item_help_color + "[SHORTSTOP] " + text_color + "Insane fire rate and guaranteed crits to wet enemies, but slow reload."); break}
                    case 448: {player.PrintToChat(item_help_color + "[SODA POPPER] " + text_color + "Hold fire to load a quick 4-shot burst."); break}
                    case 772: {player.PrintToChat(item_help_color + "[BABY FACE'S BLASTER] " + text_color + "Hold fire to load a massive burst of up to 200 shots, shredding anything at point-blank range. Has very high recoil however."); break}
                    case 1103: {player.PrintToChat(item_help_color + "[BACK SCATTER] " + text_color + "Full crits on backshots. Does not require ammo and has an endless clip."); break}
					case 18:
					case 205:
					case 658:
					case 800:
					case 809:
					case 889:
					case 898:
					case 907:
					case 916:
					case 965:
					case 974:
					case 10556:
					case 15014:
					case 15028:
					case 15043:
					case 15052:
					case 15057:
					case 15081:
					case 15104:
					case 15105:
					case 15129:
					case 15130:
					case 15150: {player.PrintToChat(item_help_color + "[ROCKET LAUNCHER] " + text_color + "Standard option for reliable damage."); break}
					case 127: {player.PrintToChat(item_help_color + "[DIRECT HIT] " + text_color + "Alt-Fire: Launch a small enemy into the air for an easy minicrit follow-up. Rockets have a small amount of aim assist."); break}
					case 228:
					case 1085: {player.PrintToChat(item_help_color + "[BLACK BOX] " + text_color + "Slow down enemies and inflict bleed. This weapon deals x2 damage against Soldier bots."); break}
					case 237: {player.PrintToChat(item_help_color + "[ROCKET JUMPER] " + text_color + "Slow fire and reload rate, but high damage and large blast radius. Excellent choice for crowd control."); break}
					case 414: {player.PrintToChat(item_help_color + "[LIBERTY LAUNCHER] " + text_color + "Fires a slow-moving rocket that deals massive damage in large area. Very slow reload and low ammo. This weapon automatically fires when loaded."); break}
					case 441: {player.PrintToChat(item_help_color + "[COW MANGLER 5000] " + text_color + "Chance to stun enemies on hit. Charged shot causes resulting burn and bleed damage to stack and crit."); break}
					case 513: {player.PrintToChat(item_help_color + "[ORIGINAL] " + text_color + "Hold fire to load a burst-shot of up to 4 rockets. This weapon automatically fires when loaded."); break}
					case 730: {player.PrintToChat(item_help_color + "[BEGGAR'S BAZOOKA] " + text_color + "Hold fire to load up to 100 rockets before unleashing them in a massive burst. This weapon does NOT overload."); break}
					case 1104: {player.PrintToChat(item_help_color + "[AIR STRIKE] " + text_color + "Load up to 10 rockets before firing all at once in a fixed spread pattern. These rockets automatically seek enemies."); break}
					case 21:
					case 208:
					case 659:
					case 798:
					case 807:
					case 887:
					case 896:
					case 905:
					case 914:
					case 963:
					case 972:
					case 15005:
					case 15017:
					case 15030:
					case 15034:
					case 15049:
					case 15054:
					case 15066:
					case 15067:
					case 15068:
					case 15089:
					case 15090:
					case 15115:
					case 15141: {player.PrintToChat(item_help_color + "[FLAMETHROWER] " + text_color + "Standard option for reliable damage. Gain a short mini-crit boost on kill."); break}
					case 40:
					case 1146: {player.PrintToChat(item_help_color + "[BACKBURNER] " + text_color + "Green Fire - Marks enemies for death and stuns airborne enemies for a short time. This weapon deals x2 damage against Pyro bots."); break}
					case 215: {player.PrintToChat(item_help_color + "[DEGREASER] " + text_color + "Long-range flamethrower dealing high direct damage, but 0 afterburn damage. This flamethrower cannot airblast."); break}
					case 594: {player.PrintToChat(item_help_color + "[PHLOGISTINATOR] " + text_color + "Green Fire - Marks enemies for death and stuns airborne enemies for a short time. Strong against Tanks, but your move speed is reduced."); break}
					case 741: {player.PrintToChat(item_help_color + "[RAINBLOWER] " + text_color + "Long-range flamethrower dealing low direct damage, but high afterburn damage. Also able to instantly destroy Engineer buildings. Airblast is weak, but very fast."); break}
					case 1178: {player.PrintToChat(item_help_color + "[DRAGON'S FURY] " + text_color + "Significantly increased fire rate and airblast rate."); break}
					case 30474: {player.PrintToChat(item_help_color + "[NOSTROMO NAPALMER] " + text_color + "Slow enemies down on hit. Builds 'Mmmph' charge similar to the Phlogistinator, but grants yourself Concheror buff. This flamethrower cannot airblast."); break}
					case 19:
					case 206:
					case 1007:
					case 15077:
					case 15079:
					case 15091:
					case 15092:
					case 15116:
					case 15117:
					case 15142:
					case 15158: {player.PrintToChat(item_help_color + "[GRENADE LAUNCHER] " + text_color + "Standard option for reliable damage."); break}
					case 308: {player.PrintToChat(item_help_color + "[LOCH-N-LOAD] " + text_color + "Slow shots but with high burst damage in a large area. Effective for crowd control."); break}
					case 405: {player.PrintToChat(item_help_color + "[ALI BABA'S WEE BOOTIES] " + text_color + "Enhanced move speed, jump height and shield charges. Offers extra damage resistance, faster shield recharge and higher bash damage."); break}
					case 608: {player.PrintToChat(item_help_color + "[BOOTLEGGER] " + text_color + "Enhanced move speed, jump height and shield charges. Offers massive resistance to melee attacks but vulnerability to critical attacks."); break}
					case 996: {player.PrintToChat(item_help_color + "[LOOSE CANNON] " + text_color + "Load up to 4 cannonballs before firing all at once in a vertical spread pattern. Cannonballs explode on contact with the ground."); break}
					case 1151: {player.PrintToChat(item_help_color + "[IRON BOMBER] " + text_color + "Ignores enemy resistances and gains a short critboost on kill. Does not require ammo and has an endless clip. Projectiles can bounce off of walls and deal 2x damage."); break}
					case 15:
					case 202:
					case 298:
					case 654:
					case 793:
					case 802:
					case 882:
					case 891:
					case 900:
					case 909:
					case 958:
					case 967:
					case 15004:
					case 15020:
					case 15026:
					case 15031:
					case 15040:
					case 15055:
					case 15086:
					case 15087:
					case 15088:
					case 15098:
					case 15099:
					case 15123:
					case 15124:
					case 15125:
					case 15147: {player.PrintToChat(item_help_color + "[MINIGUN] " + text_color + "Standard option for reliable damage. Gain a short mini-crit boost on kill."); break}
					case 41: {player.PrintToChat(item_help_color + "[NATASCHA] " + text_color + "Slow enemies on hit and apply Death Mark."); break}
					case 312: {player.PrintToChat(item_help_color + "[BRASS BEAST] " + text_color + "Higher damage with very slow spin-up. Move speed is crippled while deployed. Able to deflect incoming projectiles."); break}
					case 424: {player.PrintToChat(item_help_color + "[TOMISLAV] " + text_color + "Starts weak, but gradually increases all stats by dealing damage, potentially becoming the strongest weapon available. However all stats are reset on death."); break}
					case 811: {player.PrintToChat(item_help_color + "[HUO-LONG HEATER] " + text_color + "Fires energy beams, igniting enemies on hit"); break}
					case 832: {player.PrintToChat(item_help_color + "[GENUINE HUO-LONG HEATER] " + text_color + "Fires rockets. Guaranteed crits against burning enemies."); break}
					case 9: {player.PrintToChat(item_help_color + "[SHOTGUN - ENGINEER] " + text_color + "Deal x4 damage to your Sentry's target."); break}
					case 141:
					case 1004: {player.PrintToChat(item_help_color + "[FRONTIER JUSTICE] " + text_color + "Insanely fast fire rate. Clip size matches the max revenge crit count. Reloads faster while receiving any healing effect."); break}
					case 527: {player.PrintToChat(item_help_color + "[WIDOWMAKER] " + text_color + "Use 2000 metal to fire a wide shot that pushes enemies away."); break}
					case 588: {player.PrintToChat(item_help_color + "[POMSON 6000] " + text_color + "Inflict bleed and slow enemies down with full auto-aim."); break}
					case 997: {player.PrintToChat(item_help_color + "[RESCUE RANGER] " + text_color + "Uses 20 metal per shot, but never has to reload and increases max metal by 1000."); break}
                    case 17:
					case 204: {player.PrintToChat(item_help_color + "[SYRINGE GUN] " + text_color + "Gain 0.5% Ubercharge per hit."); break}
					case 36: {player.PrintToChat(item_help_color + "[BLUTSAUGER] " + text_color + "DESC"); break}
					case 305:
					case 1079: {player.PrintToChat(item_help_color + "[CRUSADER'S CROSSBOW] " + text_color + "Gain 0.25% Ubercharge per hit, inflict bleed and gain another 0.5% Ubercharge per tick of bleed damage."); break}
					case 412: {player.PrintToChat(item_help_color + "[OVERDOSE] " + text_color + "Requires and consumes 100% Ubercharge to send a homing payload that shuts down all nearby small enemies for up to 15s."); break}
					case 14:
					case 201:
					case 664:
					case 792:
					case 801:
					case 881:
					case 890:
					case 899:
					case 908:
					case 957:
					case 966:
					case 15000:
					case 15007:
					case 15019:
					case 15023:
					case 15033:
					case 15059:
					case 15070:
					case 15071:
					case 15072:
					case 15111:
					case 15112:
					case 15135:
					case 15136:
					case 15154: {player.PrintToChat(item_help_color + "[SNIPER RIFLE] " + text_color + "Fully charged headshot deals 450,000 damage."); break}
					case 526:
					case 30665: {player.PrintToChat(item_help_color + "[MACHINA] " + text_color + "Very slow to charge, but can shred Tanks at full charge. Killing enemies fills a rage meter that grants a 1-second critboost. Pair the critboost with a full charge to instantly destroy most Tanks you'll encounter."); break}
					case 752: {player.PrintToChat(item_help_color + "[HITMAN'S HEATMAKER] " + text_color + "Rapidfire without unscoping. No damage on bodyshot."); break}
					case 851: {player.PrintToChat(item_help_color + "[AWPER HAND] " + text_color + "Fire explosive rounds and generate rage on kills. At 100% rage, press 'reload' to gain increased max health and health regen. Rifle only charges when enemies are in your scope."); break}
					case 56:
					case 1005: {player.PrintToChat(item_help_color + "[HUNTSMAN] " + text_color + "Fire 5 arrows at once. Deal massive burn damage if a Pyro ignites your arrow."); break}
					case 230: {player.PrintToChat(item_help_color + "[SYDNEY SLEEPER] " + text_color + "Fire a special dart that cripples the movement of non-giants and makes enemies unable to receive healing from Medic bots."); break}
					case 402: {player.PrintToChat(item_help_color + "[BAZAAR BARGAIN] " + text_color + "Killing enemies of the same class in a row increases fire rate, stacking up to 3. Killing another class resets the combo."); break}
					case 1092: {player.PrintToChat(item_help_color + "[FORTIFIED COMPOUND] " + text_color + "Reduced damage over Huntsman, but fires faster, penetrates and crits wet enemies."); break}
					case 1098: {player.PrintToChat(item_help_color + "[CLASSIC] " + text_color + "Fire as fast as you can pull the trigger, or charge a single shot with insane explosive headshot power that obliterates all non-giant bots in the area."); break}
					case 24:
					case 210:
					case 161:
					case 1142:
					case 15011:
					case 15027:
					case 15042:
					case 15051:
					case 15062:
					case 15063:
					case 15064:
					case 15103:
					case 15128:
					case 15127:
					case 15149: {player.PrintToChat(item_help_color + "[REVOLVER] " + text_color + "On hit: Apply multiple debuffs, cause enemies to take increased damage for a short time, deplete enemy Medic Ubercharge and force Spy bots to undisguise. Can stun airborne enemies."); break}
					case 61:
					case 1006: {player.PrintToChat(item_help_color + "[AMBASSADOR] " + text_color + "Deal massive headshot damage. Damage is doubled if you are not disguised."); break}
					case 224: {player.PrintToChat(item_help_color + "[L'ETRANGER] " + text_color + "Able to execute any non-giant in a single shot. Zero damage to Giants or Tanks however."); break}
					case 460: {player.PrintToChat(item_help_color + "[ENFORCER] " + text_color + "Ignores damage resistances and stores a crit for every backstab or building destroyed with a Sapper."); break}
					case 525: {player.PrintToChat(item_help_color + "[DIAMONDBACK] " + text_color + "Creates a black hole to pull enemies in."); break}

					// Secondary
					case 22:
                    case 23:
                    case 209:
                    case 160:
                    case 294:
                    case 15013:
                    case 15018:
                    case 15035:
                    case 15041:
                    case 15046:
                    case 15056:
                    case 15060:
                    case 15061:
                    case 15100:
                    case 15101:
                    case 15102:
                    case 15126:
                    case 15148:
					case 30666: {player.PrintToChat(item_help_color + "[PISTOL] " + text_color + "Fire rockets instead of bullets. Highly effective for mobility."); break}
                    case 46:
                    case 1145: {player.PrintToChat(item_help_color + "[BONK! ATOMIC PUNCH] " + text_color + "Supercharged drink, granting invulnerability that doesn't remove your ability to attack."); break}
                    case 163: {player.PrintToChat(item_help_color + "[CRIT-A-COLA] " + text_color + "Supercharged drink, giving full crits."); break}
                    case 163: {player.PrintToChat(item_help_color + "[MAD MILK] " + text_color + "Enemies coated in milk are unable to move."); break}
                    case 449: {player.PrintToChat(item_help_color + "[WINGER] " + text_color + "Unlimited air jumps while active. Fires a single focused shot that always crits while you are airborne. This shot also pushes enemies away."); break}
                    case 773: {player.PrintToChat(item_help_color + "[PRETTY BOY'S POCKET PISTOL] " + text_color + "Fires a slow-moving rocket that deals massive damage in large area. Very slow reload and low ammo."); break}
                    case 812:
                    case 833: {player.PrintToChat(item_help_color + "[FLYING GUILLOTINE] " + text_color + "Yondu's Arrow: Summon a sentient arrow to assist in battle. Alt-Fire: Disruptor mode, -75% damage."); break}
                    case 1121: {player.PrintToChat(item_help_color + "[MUTATED MILK] " + text_color + "Throw grenades... lots of grenades... endless grenades."); break}
					case 10: {player.PrintToChat(item_help_color + "[SHOTGUN - SOLDIER] " + text_color + "Very fast fire rate and crits while rocket jumping."); break}
					case 199:
					case 1141:
					case 15003:
					case 15016:
					case 15044:
					case 15047:
					case 15085:
					case 15109:
					case 15132:
					case 15133:
					case 15152: {player.PrintToChat(item_help_color + "[SHOTGUN] " + text_color + "Standard option for reliable damage."); break}
					case 129:
					case 1001: {player.PrintToChat(item_help_color + "[BUFF BANNER] " + text_color + "Unlimited range and significantly increased duration."); break}
					case 133: {player.PrintToChat(item_help_color + "[GUNBOATS] " + text_color + "Enables bunnyhopping by holding 'jump' key. Gain significant increase to step height. Grants immunity to fall damage."); break}
					case 226: {player.PrintToChat(item_help_color + "[BATTALION'S BACKUP] " + text_color + "Unlimited range and significantly increased duration."); break}
					case 354: {player.PrintToChat(item_help_color + "[CONCHEROR] " + text_color + "Unlimited range and massively increased duration."); break}
					case 415: {player.PrintToChat(item_help_color + "[RESERVE SHOOTER] " + text_color + "Deals a flat 10,000 damage per shot no matter the range with bullet penetration and 3s mini-crits on kill. However this weapon cannot be crit boosted, and cannot damage Tanks."); break}
					case 442: {player.PrintToChat(item_help_color + "[RIGHTEOUS BISON] " + text_color + "Fires a continuous beam of penetrating damage with full auto-aim."); break}
					case 444: {player.PrintToChat(item_help_color + "[MANTREADS] " + text_color + "Major reduction in knockback taken from damage. Air strafing now has massively increased acceleration. Stomp damage buffed and velocity-based."); break}
					case 1101: {player.PrintToChat(item_help_color + "[B.A.S.E. JUMPER] " + text_color + "Able to toggle parachute. Increases resistance to knockback and bullet damage, reducing your vulnerability in the air."); break}
					case 1153: {player.PrintToChat(item_help_color + "[PANIC ATTACK] " + text_color + "For when you need emergency healing. Immediately restores up to 10,000 health on hit. Taking damage with this weapon active has a chance to trigger a brief self-uber."); break}
					case 12: {player.PrintToChat(item_help_color + "[SHOTGUN - PYRO] " + text_color + "Guaranteed crits against burning enemies."); break}
					case 39:
					case 1081: {player.PrintToChat(item_help_color + "[FLARE GUN] " + text_color + "Fires a hitscan attack that penetrates enemies. Damage exponentially increases with each penetrated enemy along the path. Also has a chance to stun enemies on hit."); break}
					case 351: {player.PrintToChat(item_help_color + "[DETONATOR] " + text_color + "Flare has infinite explosion radius and will hit anything within line of sight. Forces all spy bots to uncloak and undisguise. Also great choice for mobility."); break}
					case 595: {player.PrintToChat(item_help_color + "[MANMELTER] " + text_color + "Rapid-fire flares specialized to automatically seek out enemies. Unlimited ammo and no reload."); break}
					case 740: {player.PrintToChat(item_help_color + "[SCORCH SHOT] " + text_color + "Flares automatically seek enemies. On hit: Deal large damage, extinguish the enemy and inflict a strong push force. Your target MUST be on fire, or this attack will do nothing."); break}
					case 1179: {player.PrintToChat(item_help_color + "[THERMAL THRUSTER] " + text_color + "Reduced fuel consumption with no launch delay. Able to redeploy in-air and deal massive stomp damage. Gain a brief critboost on kill."); break}
					case 1180: {player.PrintToChat(item_help_color + "[GAS PASSER] " + text_color + "Gas meter starts empty and resets on death. Deal 150,000 damage to fill the meter. Explode-on-Ignite deals 105,000 damage."); break}
					case 20:
					case 207:
					case 661:
					case 797:
					case 806:
					case 886:
					case 895:
					case 904:
					case 913:
					case 962:
					case 971:
					case 15009:
					case 15012:
					case 15024:
					case 15038:
					case 15045:
					case 15048:
					case 15082:
					case 15083:
					case 15084:
					case 15113:
					case 15137:
					case 15138:
					case 15155: {player.PrintToChat(item_help_color + "[STICKYBOMB LAUNCHER] " + text_color + "Standard option for reliable damage. Able to place 50 bombs."); break}
					case 130: {player.PrintToChat(item_help_color + "[SCOTTISH RESISTANCE] " + text_color + "Bomb takes 5 seconds to arm and fizzles after 10 seconds, but can deal overwhelming damage with good timing and a full charge."); break}
					case 265: {player.PrintToChat(item_help_color + "[STICKY JUMPER] " + text_color + "Creates a shutdown field, stunning all enemies hit by the pulse. (Minibosses are immune to stun)"); break}
					case 131:
					case 1144: {player.PrintToChat(item_help_color + "[CHARGIN' TARGE] " + text_color + "Heavy resistance to BLAST damage, but more vulnerable to FIRE and BULLET damage. Includes extra resistance to knockback and crits."); break}
					case 406: {player.PrintToChat(item_help_color + "[SPLENDID SCREEN] " + text_color + "Heavy resistance to FIRE damage, but more vulnerable to BLAST and BULLET damage. Includes extra resistance to knockback and crits."); break}
					case 1099: {player.PrintToChat(item_help_color + "[TIDE TURNER] " + text_color + "Heavy resistance to BULLET damage, but more vulnerable to FIRE and BLAST damage. Includes extra resistance to knockback and crits."); break}
					case 1150: {player.PrintToChat(item_help_color + "[QUICKIEBOMB LAUNCHER] " + text_color + "Auto-fires stickybombs at an insane rate with very fast arm time. Gain mini-crits on kill."); break}
					case 11: {player.PrintToChat(item_help_color + "[SHOTGUN - HEAVY] " + text_color + "Single shot with high damage, granting 8 seconds of crits on kill."); break}
					case 42:
					case 863:
					case 1002: {player.PrintToChat(item_help_color + "[SANDVICH] " + text_color + "Restore up to 150,000 health. Any damage taken while holding this item active is fatal."); break}
					case 159: {player.PrintToChat(item_help_color + "[DALOKOHS BAR] " + text_color + "Restore up to 20,000 health. If used while below 350 health you'll gain a large overheal. Passively increases damage taken but gives a chance to self-uber on taking damage."); break}
					case 311: {player.PrintToChat(item_help_color + "[BUFFALO STEAK SANDVICH] " + text_color + "Passively grants immunity to critical hits."); break}
					case 425: {player.PrintToChat(item_help_color + "[FAMILY BUSINESS] " + text_color + "Unlimited ammo. Attack rate is doubled while receiving a healing effect. Grants a brief critboost and mini-crit boost on kill."); break}
					case 433: {player.PrintToChat(item_help_color + "[FISHCAKE] " + text_color + "Heavy resistance to BULLET damage, but more vulnerable to FIRE and BLAST damage."); break}
					case 1190: {player.PrintToChat(item_help_color + "[SECOND BANANA] " + text_color + "Heavy resistance to BLAST damage, but more vulnerable to FIRE and BULLET damage."); break}
					case 140:
					case 1086:
					case 30668: {player.PrintToChat(item_help_color + "[WRANGLER] " + text_color + "While active: Increased Sentry damage and double Dispenser range."); break}
					case 528: {player.PrintToChat(item_help_color + "[SHORT CIRCUIT] " + text_color + "Every 10 kills, gain a Lightning Ball spell charge (Requires Spellbook)"); break}
					case 29:
					case 211:
					case 663:
					case 796:
					case 805:
					case 885:
					case 894:
					case 903:
					case 912:
					case 961:
					case 970:
					case 15008:
					case 15010:
					case 15025:
					case 15039:
					case 15050:
					case 15078:
					case 15097:
					case 15121:
					case 15122:
					case 15123:
					case 15145:
					case 15146: {player.PrintToChat(item_help_color + "[MEDI GUN] " + text_color + "Overheal cap raised to x10 the patient's max health. Deploy a long-lasting level 1 Projectile Shield."); break}
					case 35: {player.PrintToChat(item_help_color + "[KRITZKRIEG] " + text_color + "Extended ubercharge duration."); break}
					case 411: {player.PrintToChat(item_help_color + "[QUICK-FIX] " + text_color + "Very fast healing with a level 2 Projectile Shield. Able to build Uber from shield contact damage."); break}
					case 998: {player.PrintToChat(item_help_color + "[VACCINATOR] " + text_color + "Active healing grants you and the patient 100% resistance to base damage of the selected damage type. Ubercharge grants full immunity to the selected damage type for 30 seconds."); break}
					case 16:
					case 203:
					case 1149:
					case 15001:
					case 15022:
					case 15032:
					case 15037:
					case 15058:
					case 15076:
					case 15110:
					case 15134:
					case 15153: {player.PrintToChat(item_help_color + "[SMG] " + text_color + "Able to headshot for greatly increased damage."); break}
					case 57: {player.PrintToChat(item_help_color + "[RAZORBACK] " + text_color + "Very fast recharge and applies Jarate to your attacker."); break}
					case 58:
					case 1083: {player.PrintToChat(item_help_color + "[JARATE] " + text_color + "Instant recharge, slows enemies down."); break}
					case 231: {player.PrintToChat(item_help_color + "[DARWIN'S DANGER SHIELD] " + text_color + "Nearly immune to FIRE damage, but take 50% more damage from BULLET and BLAST."); break}
					case 642: {player.PrintToChat(item_help_color + "[COZY CAMPER] " + text_color + "Minor increase in move speed, max health and health regen. Immune to afterburn."); break}
					case 751: {player.PrintToChat(item_help_color + "[CLEANER'S CARBINE] " + text_color + "Mini-crit boost lasts 30 seconds."); break}
					case 1105: {player.PrintToChat(item_help_color + "[SELF-AWARE BEAUTY MARK] " + text_color + "Rain down holy hellfire with flaming arrows... endlessly."); break}
					case 735:
					case 736:
					case 933:
					case 1080:
					case 1102: {player.PrintToChat(item_help_color + "[SAPPER] " + text_color + "Max stun radius and duration. Fast recharge."); break}
					case 810:
					case 831: {player.PrintToChat(item_help_color + "[RED-TAPE RECORDER] " + text_color + "Instantly destroys Engineer buildings, but can only sap one enemy at a time."); break}

					// Multiclass Melee
					case 264:
					case 1071: {player.PrintToChat(item_help_color + "[FRYING PAN] " + text_color + "Deal x30 damage to enemies of the same class as you and gain crits on kill."); break}
					case 423: {player.PrintToChat(item_help_color + "[SAXXY] " + text_color + "Deal x30 damage to enemies of the same class as you and gain crits on kill."); break}
					case 954: {player.PrintToChat(item_help_color + "[MEMORY MAKER] " + text_color + "Deal x30 damage to enemies of the same class as you and gain crits on kill."); break}
					case 474: {player.PrintToChat(item_help_color + "[CONSCIENTIOUS OBJECTOR] " + text_color + "DescriptionHere"); break}
					case 880: {player.PrintToChat(item_help_color + "[FREEDOM STAFF] " + text_color + "Small chance on taking damage to dodge the attack and become ubered for 3s."); break}
					case 939: {player.PrintToChat(item_help_color + "[BAT OUTTA HELL] " + text_color + "While active, you are invulnerable to all incoming damage and generate a massive overheal pool, but you are completely vulnerable to knockback."); break}
					case 1013: {player.PrintToChat(item_help_color + "[HAM SHANK] " + text_color + "Special Ability: 'Vital Resurgence' -  When available, press your action slot key to instantly gain 10x overheal and become immune to knockback for 20 seconds."); break}
					case 1123: {player.PrintToChat(item_help_color + "[NECRO SMASHER] " + text_color + "Special Ability: 'Vehicular Mannslaughter' -  When available, press your action slot key to enter Bumper-Car mode. While in Bumper-Car mode you are invulnerable, regenerate health and can run enemies over."); break}
					case 1127: {player.PrintToChat(item_help_color + "[CROSSING GUARD] " + text_color + "Gain massive resistance to all melee attacks, including backstabs."); break}
					case 30758: {player.PrintToChat(item_help_color + "[PRINNY MACHETE] " + text_color + "Utility Item - Swing this melee to lunge yourself forward at high speed. Grants immunity to fall damage."); break}

					// Melee
					case 0:
                    case 190:
                    case 660:
                    case 30667: {player.PrintToChat(item_help_color + "[BAT] " + text_color + "Chance to ignore death and teleport to spawn with 1hp."); break}
                    case 44: {player.PrintToChat(item_help_color + "[SANDMAN] " + text_color + "Able to rapidfire baseballs with high capacity and fast recharge, dealing significant burst damage to single targets."); break}
                    case 221:
                    case 999: {player.PrintToChat(item_help_color + "[HOLY MACKEREL] " + text_color + "Able to mark multiple enemies for death."); break}
                    case 317: {player.PrintToChat(item_help_color + "[CANDY CANE] " + text_color + "Utility Item - You have no gravity and can freely fly."); break}
                    case 325: {player.PrintToChat(item_help_color + "[BOSTON BASHER] " + text_color + "High risk / High reward. Able to instakill most small enemies, giving 10 second critboost. Enemies connected via medigun beams are also hit. However any miss is instant death."); break}
                    case 349: {player.PrintToChat(item_help_color + "[SUN-ON-A-STICK] " + text_color + "Chance to stun enemies or receive a short critboost. Hits all enemies connected via medigun beams. However any miss will stun yourself."); break}
                    case 355: {player.PrintToChat(item_help_color + "[FAN O'WAR] " + text_color + "Utility Item - Swing this melee to lunge yourself forward at high speed. Grants immunity to fall damage."); break}
                    case 450: {player.PrintToChat(item_help_color + "[ATOMIZER] " + text_color + "Cannot deal damage with normal attacks, but a successful taunt kill will grant a critboost lasting 3 minutes."); break}
                    case 452: {player.PrintToChat(item_help_color + "[THREE-RUNE BLADE] " + text_color + "Run fast. Very fast... maybe a little too fast."); break}
                    case 572: {player.PrintToChat(item_help_color + "[UNARMED COMBAT] " + text_color + "Every 10 kills, gain a Skeleton minion spell charge (Requires Spellbook)."); break}
                    case 648: {player.PrintToChat(item_help_color + "[WRAP ASSASSIN] " + text_color + "Able to attack incoming projectiles, reflecting them with ease. Also grants immunity to stun."); break}
					case 6:
					case 196: {player.PrintToChat(item_help_color + "[SHOVEL] " + text_color + "Standard option for defense and mobility."); break}
					case 128: {player.PrintToChat(item_help_color + "[EQUALIZER] " + text_color + "Taunt attack deals massive damage and knocks enemies into the air."); break}
					case 154: {player.PrintToChat(item_help_color + "[PAIN TRAIN] " + text_color + "Inflict bleed and slowdown on hit. Grants immunity to fall damage."); break}
					case 357: {player.PrintToChat(item_help_color + "[HALF-ZATOICHI] " + text_color + "Average damage with high health mobility, and increased range."); break}
					case 416: {player.PrintToChat(item_help_color + "[MARKET GARDENER] " + text_color + "High risk/High reward - Successful hit deals massive damage, but if you miss it kills you instead."); break}
					case 447: {player.PrintToChat(item_help_color + "[DISCIPLINARY ACTION] " + text_color + "For reliable banner charging, fills the meter in 3 hits."); break}
					case 775: {player.PrintToChat(item_help_color + "[ESCAPE PLAN] " + text_color + "Taunt attack deals massive damage and grants 30 seconds of crits if it kills."); break}
					case 2:
					case 192: {player.PrintToChat(item_help_color + "[FIRE AXE] " + text_color + "Standard option for defense and mobility."); break}
					case 38:
					case 1000: {player.PrintToChat(item_help_color + "[AXTINGUISHER] " + text_color + "Significantly increased damage against burning enemies."); break}
					case 153: {player.PrintToChat(item_help_color + "[HOMEWRECKER] " + text_color + "Able to instantly destroy Engineer buildings from anywhere with infinite melee range."); break}
					case 214: {player.PrintToChat(item_help_color + "[POWERJACK] " + text_color + "Fast attacks and move speed. Inflict bleed & ignite enemies on hit and gain mini-crits on kill."); break}
					case 326: {player.PrintToChat(item_help_color + "[BACK SCRATCHER] " + text_color + "NoDescription"); break}
					case 348: {player.PrintToChat(item_help_color + "[SHARPENED VOLCANO FRAGMENT] " + text_color + "Chance to stun enemies on hit."); break}
					case 457: {player.PrintToChat(item_help_color + "[POSTAL PUMMELER] " + text_color + "Able to send a small enemy back to spawn with 1 health, removing all of their items and buffs. On miss: Send yourself back to spawn instead."); break}
					case 466: {player.PrintToChat(item_help_color + "[MAUL] " + text_color + "Launch enemies into the sky on hit, but launch yourself on miss."); break}
					case 593: {player.PrintToChat(item_help_color + "[THIRD DEGREE] " + text_color + "Become nearly immune to fire damage while equipped, and gain and additional heavy resistance to all ranged attacks while active."); break}
					case 739: {player.PrintToChat(item_help_color + "[LOLLICHOP] " + text_color + "Every 10 kills, gain a Meteor Storm spell charge (Requires Spellbook)."); break}
					case 813:
					case 834: {player.PrintToChat(item_help_color + "[NEON ANNIHILATOR] " + text_color + "Your gravity is reduced."); break}
					case 1181: {player.PrintToChat(item_help_color + "[HOT HAND] " + text_color + "Launch enemies into the air on hit."); break}
					case 1:
					case 191: {player.PrintToChat(item_help_color + "[BOTTLE] " + text_color + "Standard option for defense and mobility."); break}
					case 132:
					case 266:
					case 1082: {player.PrintToChat(item_help_color + "[EYELANDER] " + text_color + "High damage with quick attacks gaining crits and mini-crits on kill, but cannot be used as hybrid-knight."); break}
					case 172: {player.PrintToChat(item_help_color + "[SCOTSMAN'S SKULLCUTTER] " + text_color + "Deal x10 damage to enemies of the same class as you. Gain crits and mini-crits on kill."); break}
					case 307: {player.PrintToChat(item_help_color + "[ULLAPOOL CABER] " + text_color + "Damage increases as you become injured. Guaranteed crits if your health is below 2%. The explosion from this attack will kill you."); break}
					case 327: {player.PrintToChat(item_help_color + "[CLAIDHEAMH MOR] " + text_color + "Every 10 kills, gain a Monoculus spell charge (Requires Spellbook)."); break}
					case 404: {player.PrintToChat(item_help_color + "[PERSIAN PERSUADER] " + text_color + "When paired with a shield, grants unlimited shield charging. Shield charge cannot be disrupted by sharp turns or bumping into walls, enemies or other obstacles. Grants immunity to stun."); break}
					case 482: {player.PrintToChat(item_help_color + "[NESSIE'S NINE IRON] " + text_color + "NoDescription"); break}
					case 609: {player.PrintToChat(item_help_color + "[SCOTTISH HANDSHAKE] " + text_color + "While active: Resist 99% ranged damage, become immune to knockback and greatly increase max health. However you cannot recover ammo and receive less health from packs."); break}
					case 5:
					case 195: {player.PrintToChat(item_help_color + "[FISTS] " + text_color + "Standard option for defense and mobility. Effective in combat."); break}
					case 43: {player.PrintToChat(item_help_color + "[KILLING GLOVES OF BOXING] " + text_color + "Special Ability: 'Mega-Crush' -  When available, press your action slot key to gain increased move speed, defense and crits for 12s, OR, use while standing on the bomb to instantly send it back to start."); break}
					case 239:
					case 1084: {player.PrintToChat(item_help_color + "[GLOVES OF RUNNING URGENTLY] " + text_color + "While active, able to leap high into the air and deploy a parachute. This parachute remains active when you switch back to your minigun."); break}
					case 310: {player.PrintToChat(item_help_color + "[WARRIOR'S SPIRIT] " + text_color + "Left-click to leap high into the air. Land on enemies to deal massive stomp damage. Removes all primary and secondary ammo."); break}
					case 331: {player.PrintToChat(item_help_color + "[FISTS OF STEEL] " + text_color + "Become a giant Heavy gauntlet with 250,000 health. You are immune to push forces and can deal heavy damage. Removes all primary and secondary ammo. You can only heal from lunchbox items."); break}
					case 426: {player.PrintToChat(item_help_color + "[EVICTION NOTICE] " + text_color + "Gain a rapid healing effect on kill."); break}
					case 587: {player.PrintToChat(item_help_color + "[APOCO-FISTS] " + text_color + "Punches push enemies away."); break}
					case 656: {player.PrintToChat(item_help_color + "[HOLIDAY PUNCH] " + text_color + "While active, all enemies ignore you. Also grants immunity to stun. This weapon cannot deal damage however."); break}
					case 7:
					case 169:
					case 197:
					case 662:
					case 795:
					case 804:
					case 884:
					case 893:
					case 902:
					case 911:
					case 960:
					case 969:
					case 15073:
					case 15074:
					case 15075:
					case 15139:
					case 15140:
					case 15114:
					case 15156: {player.PrintToChat(item_help_color + "[WRENCH] " + text_color + "Standard option for reliable damage."); break}
					case 142: {player.PrintToChat(item_help_color + "[GUNSLINGER] " + text_color + "Able to build a secondary Sentry."); break}
					case 155: {player.PrintToChat(item_help_color + "[SOUTHERN HOSPITALITY] " + text_color + "Replaces normal Sentry with a Flame Sentry. Short ranged, but high damage."); break}
					case 329: {player.PrintToChat(item_help_color + "[JAG] " + text_color + "Your Sentry has unlimited range."); break}
					case 589: {player.PrintToChat(item_help_color + "[EUREKA EFFECT] " + text_color + "While carrying your Sentry Gun, press 'Reload' key to remotely place it on any wall or ceiling within range."); break}
					case 8:
					case 198:
					case 1143: {player.PrintToChat(item_help_color + "[BONESAW] " + text_color + "Standard option for defense and mobility. Gain 10% Uber on hit."); break}
                    case 37:
					case 1003: {player.PrintToChat(item_help_color + "[UBERSAW] " + text_color + "Inflict bleed on hit. Gain 2% Uber on hit."); break}
					case 173: {player.PrintToChat(item_help_color + "[VITA-SAW] " + text_color + "Gain an Overheal spell charge on hit (Requires Spellbook). Gain 5% Uber on hit."); break}
					case 304: {player.PrintToChat(item_help_color + "[AMPUTATOR] " + text_color + "Hit your teammates to transfer your health to them and heal them instantly. Gain 5% Uber on hit."); break}
					case 413: {player.PrintToChat(item_help_color + "[SOLEMN VOW] " + text_color + "Infinite range, hits all enemies connected via Medigun beams and deals x200 damage to Medic bots. Gain 5% Uber for each enemy hit."); break}
					case 3:
					case 193: {player.PrintToChat(item_help_color + "[KUKRI] " + text_color + "Standard option for defense and mobility."); break}
					case 171: {player.PrintToChat(item_help_color + "[TRIBALMAN'S SHIV] " + text_color + "Utility Item - You have no gravity and can freely fly."); break}
					case 232: {player.PrintToChat(item_help_color + "[BUSHWACKA] " + text_color + "Infinite melee range and guaranteed crits against burning enemies."); break}
					case 401: {player.PrintToChat(item_help_color + "[SHAHANSHAH] " + text_color + "Left-click to send yourself flying upward, good for reaching high places. You are also immune to fall damage."); break}
					case 4:
					case 194:
					case 665:
					case 727:
					case 794:
					case 803:
					case 883:
					case 892:
					case 901:
					case 959:
					case 968:
					case 15062:
					case 15094:
					case 15095:
					case 15096:
					case 15118:
					case 15119:
					case 15143:
					case 15144: {player.PrintToChat(item_help_color + "[KNIFE] " + text_color + "While active, the Knife drains your health but grants immunity to ALL damage. Kills restore health. 93,750 Giant backstab damage."); break}
					case 225: {player.PrintToChat(item_help_color + "[YOUR ETERNAL REWARD] " + text_color + "Damage increases as you become injured and crits while your health is below 10%, but only for front stabs. Resist 90% damage."); break}
					case 356: {player.PrintToChat(item_help_color + "[CONNIVER'S KUNAI] " + text_color + "Infinite melee range. 46,875 Giant backstab damage."); break}
					case 461: {player.PrintToChat(item_help_color + "[BIG EARNER] " + text_color + "You have a massive amount of health and 'missed' swings cause you to heal rapidly, however you receive friendly fire from your teammates."); break}
					case 574: {player.PrintToChat(item_help_color + "[WANGA PRICK] " + text_color + "Killing an enemy causes you to immediately enter cloak for a few seconds. You can attack enemies while in this cloak state and chain kills to remain invisible. No disguise."); break}
					case 638: {player.PrintToChat(item_help_color + "[SHARP DRESSER] " + text_color + "Backstabs trigger an explosion, dealing extra damage to nearby targets. 4,688 Giant backstab damage."); break}
					case 649: {player.PrintToChat(item_help_color + "[SPY-CICLE] " + text_color + "'Missed' swing causes you to leap into the air for free surf-stabs, but you cannot disguise. 262,500 Giant backstab damage."); break}
					case 30:
					case 297:
					case 947: {player.PrintToChat(item_help_color + "[INVIS WATCH] " + text_color + "Infinite cloak, +10% faster move speed."); break}
					case 59: {player.PrintToChat(item_help_color + "[DEAD RINGER] " + text_color + "Immune to fall damage, 20% damage resistance, +100% cloak regen rate."); break}
					case 60: {player.PrintToChat(item_help_color + "[CLOAK AND DAGGER] " + text_color + "Instant cloak and decloaking."); break}
					
                    //Null description error is unnecessary. Spellbook and PDA items have no alternatives
                    //case null: {break}
					//default: {player.PrintToChat(error_color + " [Error]\x01 No Description For Item ID " + GetWeaponIDX(weapon)); break}
				}
			}
			if(scope.SpawnHelper == 2)
				player.PrintToChat("\x0826beff66Type '/itemhelp 1' to disable these messages during a wave. \nType '/itemhelp 0' to disable these messages entirely.")
			else
				player.PrintToChat("\x0826beff66Type '/itemhelp 0' to disable these messages. \nType '/itemhelp 2' to Always display this message.")
		}
	}
	/////////////////////
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		local split = split(params.text, " ")

		if(split[0] != "/itemhelp")
		{
			if(split[0] != "!itemhelp") return
		}
		if(split.len() != 2)
		{
			player.PrintToChat(item_help_color_header + "[Item Helper]" + error_color + " {Error}\x01 Incorrect arguments!\n/itemhelp 2 - Enable\n/itemhelp 1 - Enable during Wave Setup only\n/itemhelp 0 - Disable")
			return
		}

		if (split[1].tointeger() > 2 || split[1].tointeger() < 0) player.PrintToChat(item_help_color_header + "[Item Helper]" + error_color + " {Error}\x01 Out Of Bounds Value Set! : " + split[1].tointeger())
		if (split[0] == "/itemhelp" || split[0] == "!itemhelp")
		{
			GetScope(player).SpawnHelper <- split[1].tointeger()
			if(split[1].tointeger() == 0) player.PrintToChat(item_help_color_header + "[►]\x01 Item Helper disabled.")
			if(split[1].tointeger() == 1) player.PrintToChat(item_help_color_header + "[►]\x01 Item Helper enabled on Wave Setup only.")
			if(split[1].tointeger() == 2) player.PrintToChat(item_help_color_header + "[►]\x01 Item Helper enabled.")
		}
	}
}
__CollectGameEventCallbacks(helper)