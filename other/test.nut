class Funky  {
    name = ""
    constructor(name)
    {
        this.name = name
    }
}

// PrintClass(Funky)
// printl(Funky("hi").name)

class WeapStat {
    weapon = null
    constructor(weapon, stat, value)
    {
        this.weapon = weapon
        weapon.AddAttribute(stat, value, -1)
    }
}
// PrintClass(WeapStat)

class Player {
    weapons = array(8)
    name = ""

}

function InitPlayer(player, info)
{
    // GetScope(player).Init <- 
}