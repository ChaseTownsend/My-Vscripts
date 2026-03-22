IncludeScript("fatcat_library")

local Gravity_Thinker = Entities.FindByName(null, "_GravityThink")
if(Gravity_Thinker == null) Gravity_Thinker = SpawnEntityFromTable("info_target", { targetname = "_GravityThink" })
AddThinkToEnt(Gravity_Thinker, "GravityThink")

function GravityThink()
{
    local players = GetEveryHuman()
    foreach (player in players)
    {
        player.SetGravity(1)
        for (local i = 0; i <= MAX_WEAPONS; i++)
        {
            if (player.GetWeaponIDXInSlot(i) == null) continue

            switch (player.GetWeaponIDXInSlot(i))
            {
                //Neon Annihilator
                case 813:
                {
                    player.SetGravity(player.GetGravity() * 0.25)
                    break
                }
                //Neon Annihilator (Genuine)
                case 834:
                {
                    player.SetGravity(player.GetGravity() * 0.25)
                    break
                }
                //Air Strike
                case 1104:
                {
                    player.SetGravity(player.GetGravity() * 0.15)
                    break
                }
            }
        }
    }
    return 0.05
}