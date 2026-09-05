
class ::BaseWeaponAbility {
	m_hOuter = null
	m_hOwner = null
	
	class_index = TF_CLASS_UNDEFINED
	weapon_idx = -1
	active_weapon = false

	constructor(outer, data)
	{
		if (IsWeaponClass(outer, "tf_weap", true))
		{
			this.m_hOuter = outer
			this.m_hOwner = outer.GetOwner()
		}

		foreach (key, value in data)
		{
			if (key in this && ["m_hOuter", "m_hOwner"].find(key) == null)
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
	if ("m_WeaponAbility" in scope)
		return scope.m_WeaponAbility
	return null
}

/** 
 * @type {function}
 * @param {BaseWeaponAbility|null} ability
 */
function CTFWeaponBase::SetAbility( ability )
{
	local scope = GetScope(this)
	if (!("m_WeaponAbility" in scope))
		scope.m_WeaponAbility <- ability
	else {
		if (scope.m_WeaponAbility != null && "OnRemove" in scope.m_WeaponAbility)
			scope.m_WeaponAbility.OnRemove()
		scope.m_WeaponAbility = null
		scope.m_WeaponAbility = ability
	}

	if ("OnApply" in ability)
		scope.m_WeaponAbility.OnApply()
}

/** 
 * @param {class|string} clas
 * @param {table} data
 * @throws {string} if inputted class is null, not a `class` or `string`, or not in root if not a `class`
 */
function CTFWeaponBase::CreateAbility( clas, data )
{
	if (clas == null)
		throw "Cannot create an ability with NULL!"

	local isClass = type(clas) == "class"
	if (!isClass && type(clas) != "string")
		throw format("Inputed class %s is NOT a class or string!", clas.tostring())

	if (!isClass && !(clas in ROOT))
		throw format("Tried to create an ability with class %s while said class is not in the ROOT!\n", clas)

	/** @type {BaseWeaponAbility} */
	local ability = null
	if (isClass)
		ability = clas(this, data)
	else
		ability = ROOT[clas](this, data)
	SetAbility(ability)
}