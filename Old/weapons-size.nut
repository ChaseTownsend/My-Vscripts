IncludeScript("fatcat_library")

local Size_Thinker = Entities.FindByName(null, "_SizeThink")
if(Size_Thinker == null) Size_Thinker = SpawnEntityFromTable("info_target", { targetname = "_SizeThink" })
AddThinkToEnt(Size_Thinker, "SizeThink")

function SizeThink()
{
    local players = GetEveryHuman()
    foreach (player in players)
    {
        player.SetModelScale(1, 0)
        for (local i = 0; i <= MAX_WEAPONS; i++)
        {
            if (GetWeaponIDXInSlot(player, i) == null) continue

            switch (GetWeaponIDXInSlot(player, i))
            {
                //Warrior Spirit
				case 310:
                {
                    player.SetModelScale(player.GetModelScale() * 1.25, 0)
                    break
                }
                //Fists Of Steel
                case 331:
                {
                    player.SetModelScale(player.GetModelScale() * 1.75, 0)
                    break
                }
            }
        }
    }
    return 0.05
}