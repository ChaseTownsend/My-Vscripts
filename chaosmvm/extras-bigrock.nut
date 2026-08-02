if (FindByName(null, "custompath1"))
	return

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

CreateTankPath({
	"custompath2" : [ 
		{ origin = Vector(-1300, 3335, 350) } 	//start
		{ origin = Vector(-100, 3335, 388) } 	//_2
		{ origin = Vector(-30, 3273 388) 		//_3
		target = "boss_path_3" }
	]
})

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
// TankExt.CreatePaths({
// 	"heli_red1_start" : [
// 		Vector(-832, -3584, 832)	//_1
// 		Vector(-832, -3200, 1088)	//_2
// 		Vector(-192, -1664, 1024)	//_3
// 	]
// })

TankExt.CreateLoopPaths({
	"heli_red1_loop" : [
		Vector(-832, -3584, 832)	//_1
		Vector(-832, -3200, 1088)	//_2
		Vector(-192, -1664, 1024)	//_3
		Vector(1024, -256, 960)		//_4 // start of loop
		Vector(960, 896, 960)		//_5
		Vector(128, 1600, 896)		//_6
		Vector(-512, 1600, 896)		//_7
		Vector(-1152, 320, 896)		//_8
		Vector(-832, -704, 896)		//_9
		Vector(192, -704, 896)		//_10
		Vector(1024, -256, 960)		//_11 // back to loop
	]
})

// TankExt.SetPathConnection(FindByName(null, "heli_red1_start"), hPath2)

/* CreateTankPath({
	"heli_red1" : [ 
		{ origin = Vector(-832, -3584, 832) }	//start
		{ origin = Vector(-832, -3200, 1088) }	//_2
		{ origin = Vector(-192, -1664, 1024) }	//_3
		{ origin = Vector(1024, -256, 960) }	//_4 // start of loop
		{ origin = Vector(960, 896, 960) }		//_5
		{ origin = Vector(128, 1600, 896) }		//_6
		{ origin = Vector(-512, 1600, 896) }	//_7
		{ origin = Vector(-1152, 320, 896) }	//_8
		{ origin = Vector(-832, -704, 896) }	//_9
		{ origin = Vector(192, -704, 896)		//_10
		target = "heli_red1_4" }
	]
})

CreateTankPath({
	"heli_red2" : [ 
		{ origin = Vector(1856, -3008, 1472) }	//start
		{ origin = Vector(1856, -2560, 1600) }	//_2
		{ origin = Vector(1664, -2048, 1728) }	//_3
		{ origin = Vector(1152, -1664, 1600) }	//_4 // start of loop
		{ origin = Vector(-640, -1024, 1280) }	//_5
		{ origin = Vector(-1472, 64, 1280) }	//_6
		{ origin = Vector(-704, 1408, 1280) }	//_7
		{ origin = Vector(256, 1600, 1280) }	//_8
		{ origin = Vector(1088, 832, 1280) }	//_9
		{ origin = Vector(1472, 0, 1216)		//_10
		target = "heli_red2_4" }
	]
}) */

/* function CreateALoopPath(data)
{
	local StartingData = {
		origin = data.Starting.origin
		targetname = data.Starting.name
	}
	foreach (k, v in data.Starting)
	{
		if (startswith(k, "OnPass"))
			StartingData[k] <- v
	}

	local NextData = {
		origin = data.NextNodes[0].origin
		targetname = data.Starting.name
	}
	foreach (k, v in data.NextNodes[0])
	{
		if (startswith(k, "OnPass"))
			NextData[k] <- v
	}
	

	local StartingNode = SpawnEntityFromTable("path_track",StartingData)
	local NextNode = SpawnEntityFromTable("path_track", NextData)

	SetPropEntity(StartingNode, "m_pnext", NextNode)
	SetPropEntity(NextNode, "m_pprevious", StartingNode)
	data.NextNodes.remove(0)

	GetScope(StartingNode).PathData <- data.NextNodes
	StartingNode.Add



	local origin = TrackData.origin
	local target = "target" in TrackData ? TrackData.target : format("%s_%i", PathName, i + 2)

	// printl(target)
	Paths[i].path_track <- {
		origin		= origin
		targetname 	= i == 0 ? PathName : format("%s_%i", PathName, i + 1)
		target		= target
	}
	foreach (k, v in TrackData)
	{
		if (startswith(k, "OnPass"))
			Paths[i].path_track[k] <- v
	}
}

{
	Starting = {origin = Vector(), 
				name = "heli_red1"}
	NextNodes = [
		{ origin = Vector() }		//_2
		{ origin = Vector() }		//_3
		{ origin = Vector() }		//_4
		{ origin = Vector() }		//_5
	]
} */