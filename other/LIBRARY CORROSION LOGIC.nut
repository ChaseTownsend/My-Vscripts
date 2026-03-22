function ROOT::CTFPlayer::ResetCorrosion()
	GetScope(this).Corrosion <- {
		hCorrosionAttacker = null
		hCorrosionWeapon = null
		flCorrosionTime = 0.0
		flCorrosionRemoveTime = 0.0
		flCorrosionDmg = 0.0
		bPermanentCorrosion = false
		flCorrosionTickTime = 0.5
	}

function ROOT::CTFPlayer::GetCorrosion()
{
	if( GetScope(this) && "Corrosion" in GetScope(this))
		return GetScope(this).Corrosion
	else
	{
		ResetCorrosion()
		return GetScope(this).Corrosion
	}
}
function ROOT::CTFPlayer::GetCorrosionWeapon()
	return GetCorrosion().hCorrosionWeapon

function ROOT::CTFPlayer::GetCorrosionAttacker()
	return GetCorrosion().hCorrosionAttacker

function ROOT::CTFPlayer::ClearCorrosion()
{
	GetScope(this).Corrosion <- {
		hCorrosionAttacker = null
		hCorrosionWeapon = null
		flCorrosionTime = 0.0
		flCorrosionRemoveTime = 0.0
		flCorrosionDmg = 0.0
		bPermanentCorrosion = false
		flCorrosionTickTime = 0.5
	}
	ResetColor()
	// EntFireNew(this, "Color", "255 255 255")
}
function ROOT::CTFPlayer::MakeCorrosion(Player, Weapon, lifetime, damage = 5, ticktime = 0.5)
{
	if(IsInvincible())
	{
		ClearCorrosion()
		return
	}

	if(Weapon && Weapon.GetIDX() == TF_WEAPON_BLUTSAUGER)
		EntFireNew(this, "Color", BLUTSAUGER_SETTINGS.CorrosionColor)

	local Corrosion = GetCorrosion()

	local flExpireTime = Time() + lifetime.tofloat() + ticktime

	if(	Corrosion.hCorrosionAttacker && Corrosion.hCorrosionAttacker == Player
		&& Corrosion.hCorrosionWeapon && Corrosion.hCorrosionWeapon == Weapon )
	{
		if(flExpireTime > Corrosion.flCorrosionRemoveTime)
		{
			Corrosion.flCorrosionRemoveTime = flExpireTime
		}
		return
	}

	GetScope(this).Corrosion <- {
		hCorrosionAttacker = Player
		hCorrosionWeapon = Weapon
		flCorrosionTime = Time() + ticktime // skip the first tick
		flCorrosionRemoveTime = flExpireTime
		flCorrosionDmg = damage
		bPermanentCorrosion = lifetime == true ? true : false
		flCorrosionTickTime = ticktime
	}
}