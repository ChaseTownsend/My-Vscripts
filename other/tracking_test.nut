/////////////



local player_ids = []

local player = GetListenServerHost()
local player_id = NetProps.GetPropString(player, "m_szNetworkIDString")

if(!(player_id in player_ids))
{
	player_ids.push(player_id)
}
for (local i = 0; i < RandomInt(1, 7); i++)
{
	// Generate 1-7 random steam3id's
	player_ids.push("[U:1:" + RandomInt(0, 999999999) + "]")
}
local full_completed_file = FileToString("finished.txt")
local full_completed_ids = split(full_completed_file, ">", true)



local startoffile = "Total People in mission : " + player_ids.len()
local list = startoffile
local completed_people = 0
foreach(id in player_ids)
{
	local incomlist = false
	foreach (completed_id in full_completed_ids)
	{
		if (strip(completed_id) == id)
		{
			incomlist = true
			completed_people++
			// Server log
			printl("Duplicate ID in SERVER, Not adding to list! " + id)
			break
		}
	}
	if (!incomlist)
	{
		// not in the completed list so add to list
		list = list + "\n" + id
	}
}
local endoffile = "Total People who already Completed Mission : " + completed_people + "\nTotal People who have not completed the mission : " + (player_ids.len()-completed_people)
list = list + "\n" + endoffile

local MISSION_NAME = "test"
time <- {}
LocalTime(time)
local FILENAME = time.month + "_" + time.day + "_" + time.year + "_" + time.hour + "-" + time.minute
StringToFile( MISSION_NAME + "/" + FILENAME + ".txt", list)