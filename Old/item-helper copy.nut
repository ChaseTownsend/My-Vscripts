IncludeScript("fatcat_library")
// IncludeScript("Translations")

const item_help_color = "\x08FFFF00DD"
const text_color = "\x08FFFFFFBB"
const item_help_color_header = "\x0826c2ffDD"
const text_color_header = "\x0826beffBB"
const error_color = "\x07D43F3F"

SetScriptVersion("item_helper", "2.0.4")
::helper <- {}

::ItemTranslateTable <- {
	///// Scout
	/// Primary
	"SCATTERGUN" 		: [13, 200, 669, 299, 808, 888, 897, 906, 915, 964, 973, 15002, 15015, 15021, 15029, 15036, 15053, 15065, 15069, 15106, 15107, 15108, 15131, 15151, 15157]
	"FORCENATURE" 		: [45, 1078]
	"SHORTSTOP" 		: [220]
	"SODAPOPPER" 		: [448]
	"BABYFACEBLASTER" 	: [772]
	"BACKSCATTER" 		: [1103]
	/// Secondary
	"PISTOL"			: [22, 23, 209, 160, 294, 15013, 15018, 15035, 15041, 15046, 15056, 15060, 15061, 15100, 15101, 15102, 15126, 15148, 30666]
	"BONK"				: [46, 1145]
	"CRITACOLA"			: [163]
	"MADMILK"			: [222]
	"WINGER"			: [449]
	"PRETTYBOYS"		: [773]
	"CLEAVER"			: [812, 833]
	"MATATEDMILK"		: [1121]
	/// Melee
	"BAT"				: [0, 190, 660, 3066]
	"SANDMAN"			: [44]
	"HOLYMACKEREL"		: [221, 999]
	"CANDYCANE"			: [317]
	"BOSTONBASHSER"		: [325]
	"SUNONASTICK"		: [349]
	"FANOWAR"			: [355]
	"ATOMIZER"			: [450]
	"THREERUNEBLADE"	: [452]
	"UNARMEDCOMBAT"		: [572]
	"WRAPAASSASSIN"		: [648]

	///// Soldier
	/// Primary
	"ROCKETLAUNCHER"	: [18, 205, 658, 800, 809, 889, 898, 907, 916, 965, 974, 10556, 15014, 15028, 1543, 15052, 15057, 15081, 15104, 15105, 15129, 15130, 15150]
	"DIRECTHIT"			: [127]
	"BLACKBOX"			: [28, 1085]
	"ROCKETJUMPER"		: [237]
	"LIBERTYLAUNCHER"	: [414]
	"COWMANGLER"		: [441]
	"ORIGINAL"			: [513]
	"BEGGARSBAZOOKA"	: [730]
	"AIRSTRIKE"			: [1104]
	/// Secondary
	"SHOTGUN_SOLD"		: [10]
	"SHOTGUN"			: [199, 1141, 15003, 15016, 15044, 15047, 15085, 15109, 15132, 15133, 15152]
	"BUFFBANNER"		: [129, 1001]
	"GUNBOATS"			: [133]
	"BATTALIONS"		: [226]
	"CONCHEROR"			: [354]
	"RESERVESHOOTER"	: [415]
	"BISON"				: [442]
	"MANTREADS"			: [444]
	"BASEJUMPER"		: [1101]
	"PANICATTACK"		: [1153]
	/// Melee	
	"SHOVEL"			: [6, 196]
	"EQUALIZER"			: [128]
	"PAINTRAIN"			: [154]
	"HALFZATOICHI"		: [357]
	"MARKETGARDENER"	: [416]
	"DISCIPLINARYACTION": [447]
	"ESCAPEPLAN"		: [775]

	///// Pyro
	/// Primary
	"FLAMETHROWER"		: [21, 208, 659, 798, 807, 887, 896, 905, 914, 963, 972, 15005, 15017, 15030, 15034, 15049, 15054, 15066, 15067, 15068, 15089, 15090, 15115, 15141]
	"BACKBURNER"		: [40, 1146]
	"DEGREASER"			: [215]
	"PHLOGISTINATOR"	: [594]
	"RAINBLOWER"		: [741]
	"DRAGONSFURY"		: [1178]
	"NOSTROMONAPALMER"	: [30474]
	/// Secondary
	"SHOTGUN_PYRO"		: [12]
	"FLAREGUN"			: [39, 1081]
	"DETONATOR"			: [351]
	"MANMELTER"			: [595]
	"SCORCHSHOT"		: [740]
	"THERMALTHRUSTER"	: [1179]
	"GASPASSER"			: [1180]
	/// Melee
	"FIREAXE"			: [2, 192]
	"AXTINGUISHER"		: [38, 1000]
	"HOMEWRECKER"		: [153]
	"POWERJACK"			: [214]
	"BACKSCRATCHER"		: [326]
	"VOLCANOFRAGMENT"	: [348]
	"POSTALPUMMELER"	: [457]
	"MAUL"				: [466]
	"THIRDDEGREE"		: [593]
	"LOLLICHOP"			: [739]
	"NEONANNIHILATOR"	: [813, 834]
	"HOTHAND"			: [1181]

	///// Demo
	/// Primary
	"GRENADELAUNCHER"	: [19, 206, 1007, 15077, 15079, 15091, 15092, 15116, 15117, 15142, 15158]
	"LOCHNLOAD"			: [308]
	"ALIBABA"			: [405]
	"BOOTLEGGER"		: [668]
	"LOOSECANNON"		: [996]
	"IRONBOMBER"		: [1151]
	/// Secondary
	"STICKYBOMB"		: [20, 207, 661, 797, 806, 886, 895, 904, 913, 962, 971, 15009, 15012, 15024, 15038, 15045, 15048, 15082, 15083, 15084, 15113, 15137, 15138, 15155]
	"SCOTTISHRES"		: [130]
	"STICKYJUMPER"		: [265]
	"CHARGINTARGE"		: [131, 1144]
	"SPLENDIDSCREEN"	: [406]
	"TIDETURNER"		: [1099]
	"QUICKIEBOMB"		: [1150]
	/// Melee
	"BOTTLE"			: [1, 191]
	"EYELANDER"			: [132, 266, 1082]
	"SKULLCUTTER"		: [172]
	"CABER"				: [307]
	"CLAIDHEAMHMOR"		: [327]
	"PERSIANPERSUADER"	: [404]
	"NINEIRON"			: [482]
	"SCOTTISHHANDSHAKE"	: [609]

	///// Heavy
	/// Primary
	"MINIGUN"			: [15, 202, 298, 654, 793, 802, 882, 891, 900, 909, 958, 967, 15004, 15020, 15026, 15031, 15040, 15055, 15086, 15087, 15088, 15098, 15099, 15123, 15124, 15125, 15147]
	"NATASCHA"			: [41]
	"BRASSBEAST"		: [312]
	"TOMISLAV"			: [424]
	"HUOHEATER"			: [811]
	"GENUINEHUOHEATER"	: [832]
	/// Secondary
	"SHOTGUN_HVY"		: [11]
	"SANDVICH"			: [42, 863, 1002]
	"DALOKOHSBAR"		: [159]
	"BUFFALOSTEAK"		: [311]
	"FAMILYBUSINESS"	: [425]
	"FISHCAKE"			: [433]
	"SECONDBANANA"		: [1190]
	/// Melee
	"FISTS"				: [5, 195]
	"KILLINGGLOVES"		: [43]
	"GLOVESRUNNING"		: [239, 1084, 1100]
	"WARRIRORSSPIRIT"	: [310]
	"FISTSOFSTEEL"		: [331]
	"EVICTIONNOTICE"	: [426]
	"APOCOFISTS"		: [587]
	"HOLIDAYPUNCH"		: [656]

	///// Engineer
	/// Primary
	"SHOTGUN_ENGI"		: [9]
	"FRONTIERJUSTICE"	: [141, 1004]
	"WIDOWMAKER"		: [527]
	"POMSON"			: [588]
	"RESCUERANGER"		: [997]
	/// Secondary
	"WRANGLER"			: [140, 1086, 30668]
	"SHORTCIRCUIT"		: [528]
	/// Melee
	"WRENCH"			: [7, 169, 197, 662, 795, 804, 884, 893, 902, 911, 960, 969, 15073, 15074, 15075, 15139, 15140, 15114, 15156]
	"GUNSLINGER"		: [142]
	"SOUTHERNHOS"		: [155]
	"JAG"				: [329]
	"EUREKAEFFECT"		: [589]

	///// Medic
	/// Primary
	"SYRINGEGUN"		: [17, 204]
	"BLUTSAUGER"		: [36]
	"CRUSADERSCROSSBOW"	: [305, 1079]
	"OVERDOSE"			: [412]
	/// Secondary
	"MEDIGUN"			: [29, 211, 663, 796, 805, 885, 894, 903, 912, 961, 970, 15008, 15010, 15025, 15039, 15050, 15078, 15097, 15121, 15122, 15123, 15145, 15146]
	"KRITZKRIEG"		: [35]
	"QUICKFIX"			: [411]
	"VACCINATOR"		: [998]
	/// Melee
	"BONESAW"			: [8, 198, 1143]
	"UBERSAW"			: [37, 1003]
	"VITASAW"			: [173]
	"AMPUTATOR"			: [304]
	"SOLEMNVOW"			: [413]

	///// Sniper
	/// Primary
	"SNIPERRIFLE"		: [14, 201, 664, 792, 801, 881, 890, 899, 908, 957, 966, 15000, 15007, 15019, 15023, 15033, 15059, 15070, 15071, 15072, 15111, 15112, 15135, 15136, 15154]
	"MACHINA"			: [526, 30665]
	"HITMANSHEATMAKER"	: [752]
	"AWPERHAND"			: [851]
	"HUNTSMAN"			: [56, 1005]
	"SYDNEYSLEEPER"		: [230]
	"BAZAARBARGAIN"		: [402]
	"FORTIFIEDCOMPOUND"	: [1092]
	"CLASSIC"			: [1098]
	/// Secondary
	"SMG"				: [16, 203, 1149, 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153]
	"RAZORBACK"			: [57]
	"JARATE"			: [58, 1083]
	"DARWIN"			: [231]
	"COZYCAMPER"		: [642]
	"CLEANERSCARBINE"	: [751]
	"BEAUTYMARK"		: [1105]
	/// Melee
	"KUKRI"				: [3, 193]
	"TRIBALMANSSHIV"	: [171]
	"BUSHWACKA"			: [232]
	"SHAHANSHAH"		: [401]
	
	///// Spy
	/// Primary
	"REVOLVER" 			: [24, 210, 161, 1142, 15011, 15027, 15042, 15051, 15062, 15063, 15064, 15103, 15127, 15128, 15149]
	"AMBASSADOR" 		: [61, 1006]
	"LETRANGER" 		: [224]
	"ENFORCER" 			: [460]
	"DIAMONDBACK" 		: [525]
	/// Secondary
	"SAPPER"			: [735, 736, 933, 1080, 1102]
	"RED_TAPE"			: [810, 831]
	/// Melee
	"KNIFE"				: [4, 194, 665, 727, 794, 803, 883, 892, 901, 959, 968, 15062, 15094, 15095, 15096, 15118, 15119, 15143, 15144]
	"YOURETERNALREWARD"	: [225]
	"BIGEARNER"			: [356]
	"WANGAPRICK"		: [461]
	"SHARPDRESSER"		: [638]
	"SPYCICLE"			: [649]
	/// Watch
	"INVISWATCH"		: [30, 297, 947]
	"DEADRINGER"		: [59]
	"CLOAKANDDAGGER"	: [60]


	///// Multiclass Melee
	"FRYINGPAN"			: [264, 1071]
	"SAXXY"				: [423]
	"MEMORYMAKER"		: [954]
	"CONOBJECTOR"		: [474]
	"FREEDOMSTAFF"		: [880]
	"BATOUTTAHELL"		: [939]
	"HAMSHANK"			: [1013]
	"NECROSMASHER"		: [1123]
	"CROSSINGGAURD"		: [1127]
	"PRINNYMACHETE"		: [30758]
}

/* 
foreach (item, idxs in ItemTranslateTable)
{
	if(IsInArray(idx, idxs))
		player.IHTranslateToChat2(item)
} */

::helper <-{
	/////////////////
	function OnGameEvent_HumanTeam(params)
	{
		local player = params.player

		local scope = GetScope(player)

		if(IsNotInScope("spawncount", scope))
			scope.spawncount <- 0

		if(IsNotInScope("SpawnHelper", scope))
			scope.SpawnHelper <- 2

		if(player.IsAdmin())
		{
			scope.SpawnHelper <- 0
		}
	}
	function OnGameEvent_HumanSpawn(params)
	{
		local player = params.player

		local scope = GetScope(player)
		if(params.team == TEAM_UNASSIGNED)
		{
			scope.spawncount <- 0
			scope.SpawnHelper <- player.IsAdmin() ? 0 : 2
			return
		}

		if(IsNotInScope("spawncount", scope))
			scope.spawncount <- 0

		if(IsNotInScope("SpawnHelper", scope))
			scope.SpawnHelper <- 2

		scope.spawncount++
	}
	//////////////////
	function OnGameEvent_HumanResupply(params)
	{
		local player = params.player

		local scope = GetScope(player)

		if(IsNotInScope("spawncount", scope)) 	return
		if(IsNotInScope("SpawnHelper", scope)) 	return
		if(scope.SpawnHelper == 0) return
		if(scope.spawncount <= 0) return

		if(scope.SpawnHelper == 2 || (scope.SpawnHelper == 1 && GetRoundState() != GR_STATE_RND_RUNNING))
		{
			player.TranslateToChat("IH_INCLUDES")

			local weapons = player.GetAllWeapons()
			foreach (weapon in weapons)
			{
				foreach (item, indexs in ItemTranslateTable)
				{
					Assert(typeof indexs == "array", format("%s has a idx not in an array", item))
					if(IsInArray(weapon.GetIDX(), indexs))
						player.IHTranslateToChat2(item)
					player.IHTranslateToChat2(item, 2)
				}
				continue
				switch (weapon.GetIDX())
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
					case 15157: {player.IHTranslateToChat("SCATTERGUN_NAME", "SCATTERGUN_DESC"); break}
					case 45:
					case 1078: {player.IHTranslateToChat("FORCENATURE_NAME", "FORCENATURE_DESC"); break}
					case 220: {player.IHTranslateToChat("SHORTSTOP_NAME", "SHORTSTOP_DESC"); break}
					case 448: {player.IHTranslateToChat("SODAPOPPER_NAME", "SODAPOPPER_DESC"); break}
					case 772: {player.IHTranslateToChat("BABYFACEBLASTER_NAME", "BABYFACEBLASTER_DESC"); break}
					case 1103: {player.IHTranslateToChat("BACKSCATTER_NAME", "BACKSCATTER_DESC"); break}
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
					case 15150: {player.IHTranslateToChat("ROCKETLAUNCHER_NAME", "ROCKETLAUNCHER_DESC"); break}
					case 127: {player.IHTranslateToChat("DIRECTHIT_NAME", "DIRECTHIT_DESC"); break}
					case 228:
					case 1085: {player.IHTranslateToChat("BLACKBOX_NAME", "BLACKBOX_DESC"); break}
					case 237: {player.IHTranslateToChat("ROCKETJUMPER_NAME", "ROCKETJUMPER_DESC"); break}
					case 414: {player.IHTranslateToChat("LIBERTYLAUNCHER_NAME", "LIBERTYLAUNCHER_DESC"); break}
					case 441: {player.IHTranslateToChat("COWMANGLER_NAME", "COWMANGLER_DESC"); break}
					case 513: {player.IHTranslateToChat("ORIGINAL_NAME", "ORIGINAL_DESC"); break}
					case 730: {player.IHTranslateToChat("BEGGARSBAZOOKA_NAME", "BEGGARSBAZOOKA_DESC"); break}
					case 1104: {player.IHTranslateToChat("AIRSTRIKE_NAME", "AIRSTRIKE_DESC"); break}
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
					case 15141: {player.IHTranslateToChat("FLAMETHROWER_NAME", "FLAMETHROWER_DESC"); break}
					case 40:
					case 1146: {player.IHTranslateToChat("BACKBURNER_NAME", "BACKBURNER_DESC"); break}
					case 215: {player.IHTranslateToChat("DEGREASER_NAME", "DEGREASER_DESC"); break}
					case 594: {player.IHTranslateToChat("PHLOGISTINATOR_NAME", "PHLOGISTINATOR_DESC"); break}
					case 741: {player.IHTranslateToChat("RAINBLOWER_NAME", "RAINBLOWER_DESC"); break}
					case 1178: {player.IHTranslateToChat("DRAGONSFURY_NAME", "DRAGONSFURY_DESC"); break}
					case 30474: {player.IHTranslateToChat("NOSTROMONAPALMER_NAME", "NOSTROMONAPALMER_DESC"); break}
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
					case 15158: {player.IHTranslateToChat("GRENADELAUNCHER_NAME", "GRENADELAUNCHER_DESC"); break}
					case 308: {player.IHTranslateToChat("LOCHNLOAD_NAME", "LOCHNLOAD_DESC"); break}
					case 405: {player.IHTranslateToChat("ALIBABA_NAME", "ALIBABA_DESC"); break}
					case 608: {player.IHTranslateToChat("BOOTLEGGER_NAME", "BOOTLEGGER_DESC"); break}
					case 996: {player.IHTranslateToChat("LOOSECANNON_NAME", "LOOSECANNON_DESC"); break}
					case 1151: {player.IHTranslateToChat("IRONBOMBER_NAME", "IRONBOMBER_DESC"); break}
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
					case 15147: {player.IHTranslateToChat("MINIGUN_NAME", "MINIGUN_DESC"); break}
					case 41: {player.IHTranslateToChat("NATASCHA_NAME", "NATASCHA_DESC"); break}
					case 312: {player.IHTranslateToChat("BRASSBEAST_NAME", "BRASSBEAST_DESC"); break}
					case 424: {player.IHTranslateToChat("TOMISLAV_NAME", "TOMISLAV_DESC"); break}
					case 811: {player.IHTranslateToChat("HUOHEATER_NAME", "HUOHEATER_DESC"); break}
					case 832: {player.IHTranslateToChat("GENUINEHUOHEATER_NAME", "GENUINEHUOHEATER_DESC"); break}
					case 9: {player.IHTranslateToChat("SHOTGUN_ENGI_NAME", "SHOTGUN_ENGI_DESC"); break}
					case 141:
					case 1004: {player.IHTranslateToChat("FRONTIERJUSTICE_NAME", "FRONTIERJUSTICE_DESC"); break}
					case 527: {player.IHTranslateToChat("WIDOWMAKER_NAME", "WIDOWMAKER_DESC"); break}
					case 588: {player.IHTranslateToChat("POMSON_NAME", "POMSON_DESC"); break}
					case 997: {player.IHTranslateToChat("RESCUERANGER_NAME", "RESCUERANGER_DESC"); break}
					case 17:
					case 204: {player.IHTranslateToChat("SYRINGEGUN_NAME", "SYRINGEGUN_DESC"); break}
					case 36: {player.IHTranslateToChat("BLUTSAUGER_NAME", "BLUTSAUGER_DESC"); break}
					case 305:
					case 1079: {player.IHTranslateToChat("CRUSADERSCROSSBOW_NAME", "CRUSADERSCROSSBOW_DESC"); break}
					case 412: {player.IHTranslateToChat("OVERDOSE_NAME", "OVERDOSE_DESC"); break}
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
					case 15154: {player.IHTranslateToChat("SNIPERRIFLE_NAME", "SNIPERRIFLE_DESC"); break}
					case 526:
					case 30665: {player.IHTranslateToChat("MACHINA_NAME", "MACHINA_DESC"); break}
					case 752: {player.IHTranslateToChat("HITMANSHEATMAKER_NAME", "HITMANSHEATMAKER_DESC"); break}
					case 851: {player.IHTranslateToChat("AWPERHAND_NAME", "AWPERHAND_DESC"); break}
					case 56:
					case 1005: {player.IHTranslateToChat("HUNTSMAN_NAME", "HUNTSMAN_DESC"); break}
					case 230: {player.IHTranslateToChat("SYDNEYSLEEPER_NAME", "SYDNEYSLEEPER_DESC"); break}
					case 402: {player.IHTranslateToChat("BAZAARBARGAIN_NAME", "BAZAARBARGAIN_DESC"); break}
					case 1092: {player.IHTranslateToChat("FORTIFIEDCOMPOUND_NAME", "FORTIFIEDCOMPOUND_DESC"); break}
					case 1098: {player.IHTranslateToChat("CLASSIC_NAME", "CLASSIC_DESC"); break}
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
					case 15149: {player.IHTranslateToChat("REVOLVER_NAME", "REVOLVER_DESC"); break}
					case 61:
					case 1006: {player.IHTranslateToChat("AMBASSADOR_NAME", "AMBASSADOR_DESC"); break}
					case 224: {player.IHTranslateToChat("LETRANGER_NAME", "LETRANGER_DESC"); break}
					case 460: {player.IHTranslateToChat("ENFORCER_NAME", "ENFORCER_DESC"); break}
					case 525: {player.IHTranslateToChat("DIAMONDBACK_NAME", "DIAMONDBACK_DESC"); break}

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
					case 30666: {player.IHTranslateToChat("PISTOL_NAME", "PISTOL_DESC"); break}
					case 46:
					case 1145: {player.IHTranslateToChat("BONK_NAME", "BONK_DESC"); break}
					case 163: {player.IHTranslateToChat("CRITACOLA_NAME", "CRITACOLA_DESC"); break}
					case 222: {player.IHTranslateToChat("MADMILK_NAME", "MADMILK_DESC"); break}
					case 449: {player.IHTranslateToChat("WINGER_NAME", "WINGER_DESC"); break}
					case 773: {player.IHTranslateToChat("PRETTYBOYS_NAME", "PRETTYBOYS_DESC"); break}
					case 812:
					case 833: {player.IHTranslateToChat("CLEAVER_NAME", "CLEAVER_DESC"); break}
					case 1121: {player.IHTranslateToChat("MATATEDMILK_NAME", "MATATEDMILK_DESC"); break}
					case 10: {player.IHTranslateToChat("SHOTGUN_SOLD_NAME", "SHOTGUN_SOLD_DESC"); break}
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
					case 15152: {player.IHTranslateToChat("SHOTGUN_NAME", "SHOTGUN_DESC"); break}
					case 129:
					case 1001: {player.IHTranslateToChat("BUFFBANNER_NAME", "BUFFBANNER_DESC"); break}
					case 133: {player.IHTranslateToChat("GUNBOATS_NAME", "GUNBOATS_DESC"); break}
					case 226: {player.IHTranslateToChat("BATTALIONS_NAME", "BATTALIONS_DESC"); break}
					case 354: {player.IHTranslateToChat("CONCHEROR_NAME", "CONCHEROR_DESC"); break}
					case 415: {player.IHTranslateToChat("RESERVESHOOTER_NAME", "RESERVESHOOTER_DESC"); break}
					case 442: {player.IHTranslateToChat("BISON_NAME", "BISON_DESC"); break}
					case 444: {player.IHTranslateToChat("MANTREADS_NAME", "MANTREADS_DESC"); break}
					case 1101: {player.IHTranslateToChat("BASEJUMPER_NAME", "BASEJUMPER_DESC"); break}
					case 1153: {player.IHTranslateToChat("PANICATTACK_NAME", "PANICATTACK_DESC"); break}
					case 12: {player.IHTranslateToChat("SHOTGUN_PYRO_NAME", "SHOTGUN_PYRO_DESC"); break}
					case 39:
					case 1081: {player.IHTranslateToChat("FLAREGUN_NAME", "FLAREGUN_DESC"); break}
					case 351: {player.IHTranslateToChat("DETONATOR_NAME", "DETONATOR_DESC"); break}
					case 595: {player.IHTranslateToChat("MANMELTER_NAME", "MANMELTER_DESC"); break}
					case 740: {player.IHTranslateToChat("SCORCHSHOT_NAME", "SCORCHSHOT_DESC"); break}
					case 1179: {player.IHTranslateToChat("THERMALTHRUSTER_NAME", "THERMALTHRUSTER_DESC"); break}
					case 1180: {player.IHTranslateToChat("GASPASSER_NAME", "GASPASSER_DESC"); break}
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
					case 15155: {player.IHTranslateToChat("STICKYBOMB_NAME", "STICKYBOMB_DESC"); break}
					case 130: {player.IHTranslateToChat("SCOTTISHRES_NAME", "SCOTTISHRES_DESC"); break}
					case 265: {player.IHTranslateToChat("STICKYJUMPER_NAME", "STICKYJUMPER_DESC"); break}
					case 131:
					case 1144: {player.IHTranslateToChat("CHARGINTARGE_NAME", "CHARGINTARGE_DESC"); break}
					case 406: {player.IHTranslateToChat("SPLENDIDSCREEN_NAME", "SPLENDIDSCREEN_DESC"); break}
					case 1099: {player.IHTranslateToChat("TIDETURNER_NAME", "TIDETURNER_DESC"); break}
					case 1150: {player.IHTranslateToChat("QUICKIEBOMB_NAME", "QUICKIEBOMB_DESC"); break}
					case 11: {player.IHTranslateToChat("SHOTGUN_HVY_NAME", "SHOTGUN_HVY_DESC"); break}
					case 42:
					case 863:
					case 1002: {player.IHTranslateToChat("SANDVICH_NAME", "SANDVICH_DESC"); break}
					case 159: {player.IHTranslateToChat("DALOKOHSBAR_NAME", "DALOKOHSBAR_DESC"); break}
					case 311: {player.IHTranslateToChat("BUFFALOSTEAK_NAME", "BUFFALOSTEAK_DESC"); break}
					case 425: {player.IHTranslateToChat("FAMILYBUSINESS_NAME", "FAMILYBUSINESS_DESC"); break}
					case 433: {player.IHTranslateToChat("FISHCAKE_NAME", "FISHCAKE_DESC"); break}
					case 1190: {player.IHTranslateToChat("SECONDBANANA_NAME", "SECONDBANANA_DESC"); break}
					case 140:
					case 1086:
					case 30668: {player.IHTranslateToChat("WRANGLER_NAME", "WRANGLER_DESC"); break}
					case 528: {player.IHTranslateToChat("SHORTCIRCUIT_NAME", "SHORTCIRCUIT_DESC"); break}
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
					case 15146: {player.IHTranslateToChat("MEDIGUN_NAME", "MEDIGUN_DESC"); break}
					case 35: {player.IHTranslateToChat("KRITZKRIEG_NAME", "KRITZKRIEG_DESC"); break}
					case 411: {player.IHTranslateToChat("QUICKFIX_NAME", "QUICKFIX_DESC"); break}
					case 998: {player.IHTranslateToChat("VACCINATOR_NAME", "VACCINATOR_DESC"); break}
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
					case 15153: {player.IHTranslateToChat("SMG_NAME", "SMG_DESC"); break}
					case 57: {player.IHTranslateToChat("RAZORBACK_NAME", "RAZORBACK_DESC"); break}
					case 58:
					case 1083: {player.IHTranslateToChat("JARATE_NAME", "JARATE_DESC"); break}
					case 231: {player.IHTranslateToChat("DARWIN_NAME", "DARWIN_DESC"); break}
					case 642: {player.IHTranslateToChat("COZYCAMPER_NAME", "COZYCAMPER_DESC"); break}
					case 751: {player.IHTranslateToChat("CLEANERSCARBINE_NAME", "CLEANERSCARBINE_DESC"); break}
					case 1105: {player.IHTranslateToChat("BEAUTYMARK_NAME", "BEAUTYMARK_DESC"); break}
					case 735:
					case 736:
					case 933:
					case 1080:
					case 1102: {player.IHTranslateToChat("SAPPER_NAME", "SAPPER_DESC"); break}
					case 810:
					case 831: {player.IHTranslateToChat("REDTAPE_NAME", "REDTAPE_DESC"); break}

					// Multiclass Melee
					case 264:
					case 1071: {player.IHTranslateToChat("FRYINGPAN_NAME", "FRYINGPAN_DESC"); break}
					case 423: {player.IHTranslateToChat("SAXXY_NAME", "SAXXY_DESC"); break}
					case 954: {player.IHTranslateToChat("MEMORYMAKER_NAME", "MEMORYMAKER_DESC"); break}
					case 474: {player.IHTranslateToChat("CONOBJECTOR_NAME", "CONOBJECTOR_DESC"); break}
					case 880: {player.IHTranslateToChat("FREEDOMSTAFF_NAME", "FREEDOMSTAFF_DESC"); break}
					case 939: {player.IHTranslateToChat("BATOUTTAHELL_NAME", "BATOUTTAHELL_DESC"); break}
					case 1013: {player.IHTranslateToChat("HAMSHANK_NAME", "HAMSHANK_DESC"); break}
					case 1123: {player.IHTranslateToChat("NECROSMASHER_NAME", "NECROSMASHER_DESC"); break}
					case 1127: {player.IHTranslateToChat("CROSSINGGAURD_NAME", "CROSSINGGAURD_DESC"); break}
					case 30758: {player.IHTranslateToChat("PRINNYMACHETE_NAME", "PRINNYMACHETE_DESC"); break}

					// Melee
					case 0:
					case 190:
					case 660:
					case 30667: {player.IHTranslateToChat("BAT_NAME", "BAT_DESC"); break}
					case 44: {player.IHTranslateToChat("SANDMAN_NAME", "SANDMAN_DESC"); break}
					case 221:
					case 999: {player.IHTranslateToChat("HOLYMACKEREL_NAME", "HOLYMACKEREL_DESC"); break}
					case 317: {player.IHTranslateToChat("CANDYCANE_NAME", "CANDYCANE_DESC"); break}
					case 325: {player.IHTranslateToChat("BOSTONBASHSER_NAME", "BOSTONBASHSER_DESC"); break}
					case 349: {player.IHTranslateToChat("SUNONASTICK_NAME", "SUNONASTICK_DESC"); break}
					case 355: {player.IHTranslateToChat("FANOWAR_NAME", "FANOWAR_DESC"); break}
					case 450: {player.IHTranslateToChat("ATOMIZER_NAME", "ATOMIZER_DESC"); break}
					case 452: {player.IHTranslateToChat("THREERUNEBLADE_NAME", "THREERUNEBLADE_DESC"); break}
					case 572: {player.IHTranslateToChat("UNARMEDCOMBAT_NAME", "UNARMEDCOMBAT_DESC"); break}
					case 648: {player.IHTranslateToChat("WRAPAASSASSIN_NAME", "WRAPAASSASSIN_DESC"); break}
					case 6:
					case 196: {player.IHTranslateToChat("SHOVEL_NAME", "SHOVEL_DESC"); break}
					case 128: {player.IHTranslateToChat("EQUALIZER_NAME", "EQUALIZER_DESC"); break}
					case 154: {player.IHTranslateToChat("PAINTRAIN_NAME", "PAINTRAIN_DESC"); break}
					case 357: {player.IHTranslateToChat("HALFZATOICHI_NAME", "HALFZATOICHI_DESC"); break}
					case 416: {player.IHTranslateToChat("MARKETGARDENER_NAME", "MARKETGARDENER_DESC"); break}
					case 447: {player.IHTranslateToChat("DISCIPLINARYACTION_NAME", "DISCIPLINARYACTION_DESC"); break}
					case 775: {player.IHTranslateToChat("ESCAPEPLAN_NAME", "ESCAPEPLAN_DESC"); break}
					case 2:
					case 192: {player.IHTranslateToChat("FIREAXE_NAME", "FIREAXE_DESC"); break}
					case 38:
					case 1000: {player.IHTranslateToChat("AXTINGUISHER_NAME", "AXTINGUISHER_DESC"); break}
					case 153: {player.IHTranslateToChat("HOMEWRECKER_NAME", "HOMEWRECKER_DESC"); break}
					case 214: {player.IHTranslateToChat("POWERJACK_NAME", "POWERJACK_DESC"); break}
					case 326: {player.IHTranslateToChat("BACKSCRATCHER_NAME", "BACKSCRATCHER_DESC"); break}
					case 348: {player.IHTranslateToChat("VOLCANOFRAGMENT_NAME", "VOLCANOFRAGMENT_DESC"); break}
					case 457: {player.IHTranslateToChat("POSTALPUMMELER_NAME", "POSTALPUMMELER_DESC"); break}
					case 466: {player.IHTranslateToChat("MAUL_NAME", "MAUL_DESC"); break}
					case 593: {player.IHTranslateToChat("THIRDDEGREE_NAME", "THIRDDEGREE_DESC"); break}
					case 739: {player.IHTranslateToChat("LOLLICHOP_NAME", "LOLLICHOP_DESC"); break}
					case 813:
					case 834: {player.IHTranslateToChat("NEONANNIHILATOR_NAME", "NEONANNIHILATOR_DESC"); break}
					case 1181: {player.IHTranslateToChat("HOTHAND_NAME", "HOTHAND_DESC"); break}
					case 1:
					case 191: {player.IHTranslateToChat("BOTTLE_NAME", "BOTTLE_DESC"); break}
					case 132:
					case 266:
					case 1082: {player.IHTranslateToChat("EYELANDER_NAME", "EYELANDER_DESC"); break}
					case 172: {player.IHTranslateToChat("SKULLCUTTER_NAME", "SKULLCUTTER_DESC"); break}
					case 307: {player.IHTranslateToChat("CABER_NAME", "CABER_DESC"); break}
					case 327: {player.IHTranslateToChat("CLAIDHEAMHMOR_NAME", "CLAIDHEAMHMOR_DESC"); break}
					case 404: {player.IHTranslateToChat("PERSIANPERSUADER_NAME", "PERSIANPERSUADER_DESC"); break}
					case 482: {player.IHTranslateToChat("NINEIRON_NAME", "NINEIRON_DESC"); break}
					case 609: {player.IHTranslateToChat("SCOTTISHHANDSHAKE_NAME", "SCOTTISHHANDSHAKE_DESC"); break}
					case 5:
					case 195: {player.IHTranslateToChat("FISTS_NAME", "FISTS_DESC"); break}
					case 43: {player.IHTranslateToChat("KILLINGGLOVES_NAME", "KILLINGGLOVES_DESC"); break}
					case 239:
					case 1084:
					case 1100: {player.IHTranslateToChat("GLOVESRUNNING_NAME", "GLOVESRUNNING_DESC"); break}
					case 310: {player.IHTranslateToChat("WARRIRORSSPIRIT_NAME", "WARRIRORSSPIRIT_DESC"); break}
					case 331: {player.IHTranslateToChat("FISTSOFSTEEL_NAME", "FISTSOFSTEEL_DESC"); break}
					case 426: {player.IHTranslateToChat("EVICTIONNOTICE_NAME", "EVICTIONNOTICE_DESC"); break}
					case 587: {player.IHTranslateToChat("APOCOFISTS_NAME", "APOCOFISTS_DESC"); break}
					case 656: {player.IHTranslateToChat("HOLIDAYPUNCH_NAME", "HOLIDAYPUNCH_DESC"); break}
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
					case 15156: {player.IHTranslateToChat("WRENCH_NAME", "WRENCH_DESC"); break}
					case 142: {player.IHTranslateToChat("GUNSLINGER_NAME", "GUNSLINGER_DESC"); break}
					case 155: {player.IHTranslateToChat("SOUTHERNHOS_NAME", "SOUTHERNHOS_DESC"); break}
					case 329: {player.IHTranslateToChat("JAG_NAME", "JAG_DESC"); break}
					case 589: {player.IHTranslateToChat("EUREKAEFFECT_NAME", "EUREKAEFFECT_DESC"); break}
					case 8:
					case 198:
					case 1143: {player.IHTranslateToChat("BONESAW_NAME", "BONESAW_DESC"); break}
					case 37:
					case 1003: {player.IHTranslateToChat("UBERSAW_NAME", "UBERSAW_DESC"); break}
					case 173: {player.IHTranslateToChat("VITASAW_NAME", "VITASAW_DESC"); break}
					case 304: {player.IHTranslateToChat("AMPUTATOR_NAME", "AMPUTATOR_DESC"); break}
					case 413: {player.IHTranslateToChat("SOLEMNVOW_NAME", "SOLEMNVOW_DESC"); break}
					case 3:
					case 193: {player.IHTranslateToChat("KUKRI_NAME", "KUKRI_DESC"); break}
					case 171: {player.IHTranslateToChat("TRIBALMANSSHIV_NAME", "TRIBALMANSSHIV_DESC"); break}
					case 232: {player.IHTranslateToChat("BUSHWACKA_NAME", "BUSHWACKA_DESC"); break}
					case 401: {player.IHTranslateToChat("SHAHANSHAH_NAME", "SHAHANSHAH_DESC"); break}
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
					case 15144: {player.IHTranslateToChat("KNIFE_NAME", "KNIFE_DESC"); break}
					case 225: {player.IHTranslateToChat("YOURETERNALREWARD_NAME", "YOURETERNALREWARD_DESC"); break}
					case 356: {player.IHTranslateToChat("KUNAI_NAME", "KUNAI_DESC"); break}
					case 461: {player.IHTranslateToChat("BIGEARNER_NAME", "BIGEARNER_DESC"); break}
					case 574: {player.IHTranslateToChat("WANGAPRICK_NAME", "WANGAPRICK_DESC"); break}
					case 638: {player.IHTranslateToChat("SHARPDRESSER_NAME", "SHARPDRESSER_DESC"); break}
					case 649: {player.IHTranslateToChat("SPYCICLE_NAME", "SPYCICLE_DESC"); break}
					case 30:
					case 297:
					case 947: {player.IHTranslateToChat("INVISWATCH_NAME", "INVISWATCH_DESC"); break}
					case 59: {player.IHTranslateToChat("DEADRINGER_NAME", "DEADRINGER_DESC"); break}
					case 60: {player.IHTranslateToChat("CLOAKANDDAGGER_NAME", "CLOAKANDDAGGER_DESC"); break}
					
					//Null description error is unnecessary. Spellbook and PDA items have no alternatives
					//case null: {break}
					// default: {player.PrintToChat(error_color + " [Error]\x01 No Description For Item ID " + GetWeaponIDX(weapon)); break}
				}
			}
			if(scope.SpawnHelper == 2)
				player.TranslateToChat("IH_DIS_MSG_2")
			else
				player.TranslateToChat("IH_DIS_MSG")
		}
	}
	/////////////////////
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)
		local text = split(params.text, " ")

		if(text[0] != "/itemhelp")
			{ if(text[0] != "!itemhelp") return }
		
		if(text.len() != 2)
		{
			player.TranslateToChat("IH_BAD_ARGS")
			return
		}

		local message_value = text[1].tointeger()

		if (message_value > 2 || message_value < 0)
		{
			player.TranslateToChat("IH_OOB_ARG", message_value)
			return
		}

		GetScope(player).SpawnHelper <- message_value
		if(message_value == 0) 
			player.TranslateToChat("IH_DISABLE")
		if(message_value == 1) 
			player.TranslateToChat("IH_WAVE_SETUP")
		if(message_value == 2) 
			player.TranslateToChat("IH_ENABLE")
	}
}
__CollectGameEventCallbacks(helper)