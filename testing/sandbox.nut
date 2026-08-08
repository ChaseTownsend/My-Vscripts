local Nav = NavMesh.GetNav()

DebugDrawClear()
foreach (_, /**@type {CTFNavArea}*/Mesh in Nav)
{
	local IsBlue = Mesh.HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE)
	local IsRed = Mesh.HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE)

	local text = IsBlue ? "Blue" : (IsRed ? "Red" : "Neutral")

	DebugDrawText(Mesh.GetCenter(), text, false, 100)

	// No Vectors moment
	local Clr = {
		r = 255
		g = 255
		b = 255
	}
 
	if ( IsBlue && !IsRed )
	{
		Clr.r = 0
		Clr.g = 0
	}
	else if ( IsRed && !IsBlue )
	{
		Clr.g = 0
		Clr.b = 0
	}

	Mesh.DebugDrawFilled(Clr.r, Clr.g, Clr.b, 0, 100, false, 0.05)
}