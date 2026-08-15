
class ::BaseWeaponAbility {
	m_hOuter = null
	m_hOwner = null
	
	class_index = TF_CLASS_UNDEFINED
	weapon_idx = -1
	active_weapon = false

	constructor(outer, data)
	{
		if(IsWeaponClass(outer, "tf_weap", true))
		{

		}

		foreach (key, value in data)
		{
			if(key in this && ["m_hOuter", "m_hOwner"].find(key) == null)
				this[key] = value
		}
	}

	function Think()
	{

	}

	function OnRemove()
	{

	}
}

/** 
 * @type {function}
 * @returns {BaseWeaponAbility|null}
 */
function CTFWeaponBase::GetAbility()
{
	local scope = GetScope(this)
	if("m_WeaponAbility" in scope)
		return scope.m_WeaponAbility
	return null
}

/** 
 * @type {function}
 * @param {BaseWeaponAbility|null} ability
 */
function CTFWeaponBase::SetAbility(ability)
{
	local scope = GetScope(this)
	if(!("m_WeaponAbility" in scope))
		scope.m_WeaponAbility <- ability
	else {
		if(scope.m_WeaponAbility != null && "OnRemove" in scope.m_WeaponAbility)
			scope.m_WeaponAbility.OnRemove()
		scope.m_WeaponAbility = null
		scope.m_WeaponAbility = ability
	}

	if("OnApply" in ability)
			scope.m_WeaponAbility.OnApply()
}

function CTFWeaponBase::CreateAbility(data)
{
	/** @type {BaseWeaponAbility} */
	local ability = null
	ability = BaseWeaponAbility(this, data)
	SetAbility(ability)
}