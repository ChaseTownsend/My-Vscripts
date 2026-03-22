PrecacheModel("models/props_forest/sawmill_deck1.mdl")

if(FindByName(null, "custompath1"))
	return

// if(!Entities.FindByName(null, "custompath1"))
{
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_12"
	// 	origin = Vector(640, 4325, 384)
	// 	target = "boss_path_2"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_11"
	// 	origin = Vector(565, 4440, 385)
	// 	target = "custompath1_12"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_10"
	// 	origin = Vector(450, 4490, 370)
	// 	target = "custompath1_11"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_9"
	// 	origin = Vector(280, 4460, 350)
	// 	target = "custompath1_10"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_8"
	// 	origin = Vector(-150, 4260, 290)
	// 	target = "custompath1_9"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_7"
	// 	origin = Vector(-620, 3885, 240)
	// 	target = "custompath1_8"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_6"
	// 	origin = Vector(-800, 3860, 225)
	// 	target = "custompath1_7"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_5"
	// 	origin = Vector(-1485, 4130, 190)
	// 	target = "custompath1_6"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_4"
	// 	origin = Vector(-1565, 4300, 150)
	// 	target = "custompath1_5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_3"
	// 	origin = Vector(-1590, 4640, 130)
	// 	target = "custompath1_4"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1_2"
	// 	origin = Vector(-1670, 4770, 130)
	// 	target = "custompath1_3"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath1"
	// 	origin = Vector(-2100, 5200, 140)
	// 	target = "custompath1_2"
	// })

	CreateTankPath({
		"custompath1" : [ 
			{ origin = Vector(-2100, 5200, 140) } 	//start
			{ origin = Vector(-1670, 4770, 130) } 	//_2
			{ origin = Vector(-1590, 4640, 130) } 	//_3
			{ origin = Vector(-1565, 4300, 150) } 	//_4
			{ origin = Vector(-1485, 4130, 190) } 	//_5
			{ origin = Vector(-800, 3860, 225) } 	//_6
			{ origin = Vector(-620, 3885, 240) } 	//_7
			{ origin = Vector(-150, 4260, 290) } 	//_8
			{ origin = Vector(280, 4460, 350) } 	//_9
			{ origin = Vector(450, 4490, 370) } 	//_10
			{ origin = Vector(565, 4440, 385) } 	//_11
			{ origin = Vector(640, 4325, 384)		//_12
			target = "boss_path_2" }
		]
	})
	
	
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath2_3"
	// 	origin = Vector(-30, 3273 388)
	// 	target = "boss_path_3"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath2_2"
	// 	origin = Vector(-100, 3335, 388)
	// 	target = "custompath2_3"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath2"
	// 	origin = Vector(-1300, 3335, 350)
	// 	target = "custompath2_2"
	// })

	CreateTankPath({
		"custompath2" : [ 
			{ origin = Vector(-1300, 3335, 350) } 	//start
			{ origin = Vector(-100, 3335, 388) } 	//_2
			{ origin = Vector(-30, 3273 388) 		//_3
			target = "boss_path_3" }
		]
	})
	
	
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_11"
	// 	origin = Vector(415, 1555, 385)
	// 	target = "boss_path_5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_10"
	// 	origin = Vector(555, 1605, 385)
	// 	target = "custompath3_11"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_9"
	// 	origin = Vector(700, 1780, 385)
	// 	target = "custompath3_10"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_8"
	// 	origin = Vector(840, 1810, 380)
	// 	target = "custompath3_9"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_7"
	// 	origin = Vector(1050, 1750, 310)
	// 	target = "custompath3_8"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_6"
	// 	origin = Vector(1180, 1635, 290)
	// 	target = "custompath3_7"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_5"
	// 	origin = Vector(1480, 1100, 300)
	// 	target = "custompath3_6"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_4"
	// 	origin = Vector(1540, 920, 300)
	// 	target = "custompath3_5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_3"
	// 	origin = Vector(1550, 700, 300)
	// 	target = "custompath3_4"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3_2"
	// 	origin = Vector(1450, 300, 290)
	// 	target = "custompath3_3"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath3"
	// 	origin = Vector(1450, 50, 290)
	// 	target = "custompath3_2"
	// })

	CreateTankPath({
		"custompath3" : [ 
			{ origin = Vector(1450, 50, 290) } 		//start
			{ origin = Vector(1450, 300, 290) } 	//_2
			{ origin = Vector(1550, 700, 300) }		//_3
			{ origin = Vector(1540, 920, 300) }		//_4
			{ origin = Vector(1480, 1100, 300) }	//_5
			{ origin = Vector(1180, 1635, 290) }	//_6
			{ origin = Vector(1050, 1750, 310) }	//_7
			{ origin = Vector(840, 1810, 380) }		//_8
			{ origin = Vector(700, 1780, 385) }		//_9
			{ origin = Vector(555, 1605, 385) }		//_10
			{ origin = Vector(415, 1555, 385) 		//_11
			target = "boss_path_5" }
		]
	})
	
	
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath4_4"
	// 	origin = Vector(-15, -3050, 1500)
	// 	target = "boss_path_28"
	// 	"OnPass#1" : "!activator,SetSpeed,250,-1"
	// 	"OnPass#2" : "!activator,SetSpeed,75,2.5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath4_3"
	// 	origin = Vector(-15, -3300, 1500)
	// 	target = "custompath4_4"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath4_2"
	// 	origin = Vector(-15, -3800, 1500)
	// 	target = "custompath4_3"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath4"
	// 	origin = Vector(800, -4500, 1500)
	// 	target = "custompath4_2"
	// })

	CreateTankPath({
		"custompath4" : [ 
			{ origin = Vector(800, -4500, 1500) } 	//start
			{ origin = Vector(-15, -3800, 1500) } 	//_2
			{ origin = Vector(-15, -3300, 1500) } 	//_3
			{ origin = Vector(-15, -3050, 1500)		//_4
			target = "boss_path_28"
			"OnPass#1" : "!activator,SetSpeed,250,-1"
			"OnPass#2" : "!activator,SetSpeed,75,2.5"
			}
		]
	})
	
	
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_10"
	// 	origin = Vector(475, 1475, 385)
	// 	target = "boss_path_5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_9"
	// 	origin = Vector(540, 1370, 385)
	// 	target = "custompath5_10"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_8"
	// 	origin = Vector(550, 1280, 385)
	// 	target = "custompath5_9"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_7"
	// 	origin = Vector(460, 1020, 385)
	// 	target = "custompath5_8"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_6"
	// 	origin = Vector(480, 860, 385)
	// 	target = "custompath5_7"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_5"
	// 	origin = Vector(580, 760, 385)
	// 	target = "custompath5_6"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_4"
	// 	origin = Vector(900, 530, 385)
	// 	target = "custompath5_5"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_3"
	// 	origin = Vector(940, 440, 385)
	// 	target = "custompath5_4"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_2"
	// 	origin = Vector(940, -480, 385)
	// 	target = "custompath5_3"
	// 	"OnPass" : "!activator,SetSpeed,75,-1"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5_1"
	// 	origin = Vector(860, -830 700)
	// 	target = "custompath5_2"
	// 	"OnPass" : "!activator,SetSpeed,300,-1"
	// })
	// SpawnEntityFromTable("path_track", {
	// 	targetname = "custompath5"
	// 	origin = Vector(860, -3650 2300)
	// 	target = "custompath5_1"
	// 	"OnPass" : "!activator,SetSpeed,5000,5"
	// })

	CreateTankPath({
		"custompath5" : [ 
			{ origin = Vector(860, -3650 2300) 		//start
			"OnPass" : "!activator,SetSpeed,5000,5" }
			{ origin = Vector(860, -830 700) 		//_2
			"OnPass" : "!activator,SetSpeed,300,-1" }
			{ origin = Vector(940, -480, 385) 		//_3
				"OnPass" : "!activator,SetSpeed,75,-1" } 
			{ origin = Vector(940, 440, 385) }		//_4
			{ origin = Vector(900, 530, 385) }		//_5
			{ origin = Vector(580, 760, 385) }		//_6
			{ origin = Vector(480, 860, 385) }		//_7
			{ origin = Vector(460, 1020, 385) }		//_8
			{ origin = Vector(550, 1280, 385) }		//_9
			{ origin = Vector(540, 1370, 385) }		//_10
			{ origin = Vector(475, 1475, 385) 		//_11
			target = "boss_path_5" }
		]
	})
}

//SpawnEntityFromTable("prop_dynamic", {
//targetname = "customprop"
//origin = Vector(880, -3800 2250)
//angles = Vector(0, 0, 0)
//solid = 6
//model = "models/props_forest/sawmill_deck1.mdl"
//})

//local Brush = SpawnEntityFromTable("func_brush", {})
//Brush.SetSize(Vector(1000, -3650, 2300), Vector(880, -4500, 2150))
//Brush.SetSolid(1)// try 0 -> 6