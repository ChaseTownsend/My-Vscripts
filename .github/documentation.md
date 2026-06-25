# Library Documentation

Progressivly trying to actually document the functions and stuff i make

## Table of Contents

- Custom Functions
	- Global functions
	- Redefined functions
	- [`CTFPlayer` methods](#CTFPlayer-Methods)
	- `CTFBot` methods 
	 - (Most methods from CTFPlayer are ported to CTFBot)
	 <!-- TODO: List the ones that are not ported -->
	- `CTFWeaponBase` methods
	- `CEconEntity` methods
	 - (Most methods from CTFWeaponBase are ported to CEconEntity)
	 <!-- TODO: List the ones that are not ported -->
	- `CTFBaseBoss` methods
	- `CNavMesh` methods
	- `CTFNavArea` methods
- Script Events
- Custom Attributes
- Global Constants
- Chat Commands
	- Admin Commands

## CTFPlayer-Methods
 Custom Methods added to `CTFPlayer`
- [`PrintToHud`](#CTFPlayer::PrintToHud)
- [`PrintToChat`](#CTFPlayer::PrintToChat)
- [`PrintToConsole`](#CTFPlayer::PrintToConsole)
- [`PrintToHudF`](#CTFPlayer::PrintToHudF)
- [`PrintToChatF`](#CTFPlayer::PrintToChatF)
- [`PrintToConsoleF`](#CTFPlayer::PrintToConsoleF)
- [`IsOnGround`](#CTFPlayer::IsOnGround)
- [`GetUserName`](#CTFPlayer::GetUserName)
- [`GetSteamID`](#CTFPlayer::GetSteamID)
- [`GetUserID`](#CTFPlayer::GetUserID)
- [`GetHealers`](#CTFPlayer::GetHealers)
- [`GetAmmoByIndex`](#CTFPlayer::GetAmmoByIndex)
- [`GetPrimaryAmmo`](#CTFPlayer::GetPrimaryAmmo)
- [`GetSecondaryAmmo`](#CTFPlayer::GetSecondaryAmmo)
- [`GetMetal`](#CTFPlayer::GetMetal)
- [`IsOverhealed`](#CTFPlayer::IsOverhealed)
- [`GetMaxBuffedHealth`](#CTFPlayer::GetMaxBuffedHealth)
- [`EyeVector`](#CTFPlayer::EyeVector)
- [`GetFrontOffset`](#CTFPlayer::GetFrontOffset)
- [`GetEyeOffset`](#CTFPlayer::GetEyeOffset)
- [`IsPressingButton`](#CTFPlayer::IsPressingButton)
- [`GetWeaponInSlot`](#CTFPlayer::GetWeaponInSlot)
- [`SetAmmoByIndex`](#CTFPlayer::SetAmmoByIndex)
- [`SetPrimaryAmmo`](#CTFPlayer::SetPrimaryAmmo)
- [`SetSecondaryAmmo`](#CTFPlayer::SetSecondaryAmmo)
- [`SetMetal`](#CTFPlayer::SetMetal)
- [`ResetHealth`](#CTFPlayer::ResetHealth)
- [`ResetColor`](#CTFPlayer::ResetColor)
- [`SetColor`](#CTFPlayer::SetColor)
- [`SetScale`](#CTFPlayer::SetScale)
- [`GetHeads`](#CTFPlayer::GetHeads)
- [`SetHeads`](#CTFPlayer::SetHeads)
- [`AddHeads`](#CTFPlayer::AddHeads)
- [`IsDead`](#CTFPlayer::IsDead)
- [`MultiplyGravity`](#CTFPlayer::MultiplyGravity)
- [`PlayerFire`](#CTFPlayer::PlayerFire)
- [`RunScriptCode`](#CTFPlayer::RunScriptCode)
- [`GetGroundEntity`](#CTFPlayer::GetGroundEntity)
- [`GetFallingVelocity`](#CTFPlayer::GetFallingVelocity)
- [`IsDucking`](#CTFPlayer::IsDucking)
- [`IsCrouching`](#CTFPlayer::IsCrouching)
- [`IsReprogrammed`](#CTFPlayer::IsReprogrammed) <!-- Different for bots -->
- [`IsBot`](#CTFPlayer::IsBot)	<!-- Different for bots -->
- [`SetFoodItemCharge`](#CTFPlayer::SetFoodItemCharge)
- [`TakeUnblockableDamage`](#CTFPlayer::TakeUnblockableDamage)
- [`SetCond`](#CTFPlayer::SetCond)

- [``](#CTFPlayer::)


### <a name="CTFPlayer::PrintToHud">CTFPlayer::PrintToHud</a>
Prints a Message to the players Hud

**Function Signature**<br>
`void CTFPlayer::PrintToHud(string message = "")`

**Example Usage**
```js
player.PrintToHud("Your Shield is on Cooldown!")
```

---

### <a name="CTFPlayer::PrintToChat">CTFPlayer::PrintToChat</a>
Prints a Message to the players Chat

**Function Signature**<br>
`void CTFPlayer::PrintToChat(string message = "")`

**Example Usage**
```js
player.PrintToChat("Your Shield is on Cooldown!")
```

---

### <a name="CTFPlayer::PrintToConsole">CTFPlayer::PrintToConsole</a>
Prints a Message to the players Console

**Function Signature**<br>
`void CTFPlayer::PrintToConsole(string message = "")`

**Example Usage**
```js
player.PrintToConsole("Debug: 15% charged")
```

---

### <a name="CTFPlayer::PrintToHudF">CTFPlayer::PrintToHudF</a>
Prints a Message to the players Hud with 

**Function Signature**<br>
`void CTFPlayer::PrintToHudF(string format, any ...)`

**Example Usage**
```js
player.PrintToHudF("Your %s is on Cooldown!", "Medication")
```

---

### <a name="CTFPlayer::PrintToChatF">CTFPlayer::PrintToChatF</a>
Prints a Message to the players Chat with formating

**Function Signature**<br>
`void CTFPlayer::PrintToChatF(string format, any ...)`

**Example Usage**
```js
player.PrintToChatF("Your %s is on Cooldown!", "Medication")
```

---

### <a name="CTFPlayer::PrintToConsoleF">CTFPlayer::PrintToConsoleF</a>
Prints a Message to the players Console with formating

**Function Signature**<br>
`void CTFPlayer::PrintToConsoleF(string format, any ...)`

**Example Usage**
```js
player.PrintToConsoleF("Debug: Wave is %f%% done", 37.21)
```

---

### <a name="CTFPlayer::IsOnGround">CTFPlayer::IsOnGround</a>
Returns if the player is on the ground.

**Function Signature**<br>
`bool CTFPlayer::IsOnGround()`

**Example Usage**
```js
if(player.IsOnGround())
{
	// ...
}
```

---

### <a name="CTFPlayer::GetUserName">CTFPlayer::GetUserName</a>
Returns the players Username

**Function Signature**<br>
`string CTFPlayer::GetUserName()`

**Example Usage**
```js
if(player.GetUserName() == "BigBob")
{
	// ...
}
```

---

### <a name="CTFPlayer::GetSteamID">CTFPlayer::GetSteamID</a>
Returns the players SteamID

**Function Signature**<br>
`string CTFPlayer::GetSteamID()`

**Example Usage**
```js
if(player.GetSteamID() == "[U:1:969530867]")
{
	// ...
}
```

---

### <a name="CTFPlayer::GetUserID">CTFPlayer::GetUserID</a>
Returns the players UserID to be used with `GetPlayerFromUserID()`

**Function Signature**<br>
`string CTFPlayer::GetUserID()`

**Example Usage**
```js
Players.append(player.GetUserID())
```

---

### <a name="CTFPlayer::GetHealers">CTFPlayer::GetHealers</a>
Returns the players healing us

**Function Signature**<br>
`[CTFPlayer] CTFPlayer::GetHealers()`

**Example Usage**
```js
foreach(plr in player.GetHealers())
{
	plr.AddCustomAttribute("dmg taken increased", 0.75, 5)
}
```

---

### <a name="CTFPlayer::GetAmmoByIndex">CTFPlayer::GetAmmoByIndex</a>
Returns the amount of ammo we have for this ammo type.

**Function Signature**<br>
`integer CTFPlayer::GetAmmoByIndex(integer ammo_type)`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetAmmoByIndex(1)+" Primary ammo") // Primary ammo
```

---

### <a name="CTFPlayer::GetPrimaryAmmo">CTFPlayer::GetPrimaryAmmo</a>
Returns the amount of Primary ammo we have.

**Function Signature**<br>
`integer CTFPlayer::GetPrimaryAmmo()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetPrimaryAmmo()+" Primary ammo")
```

---

### <a name="CTFPlayer::GetSecondaryAmmo">CTFPlayer::GetSecondaryAmmo</a>
Returns the amount of Secondary ammo we have.

**Function Signature**<br>
`integer CTFPlayer::GetSecondaryAmmo()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetSecondaryAmmo()+" Secondary ammo")
```

---

### <a name="CTFPlayer::GetMetal">CTFPlayer::GetMetal</a>
Returns the amount of Metal we have.

**Function Signature**<br>
`integer CTFPlayer::GetMetal()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetMetal()+" Metal")
```

---

### <a name="CTFPlayer::IsOverhealed">CTFPlayer::IsOverhealed</a>
Returns if we are Overhealed (hp > max_hp)

**Function Signature**<br>
`bool CTFPlayer::IsOverhealed()`

**Example Usage**
```js
if(player.IsOverhealed())
{
	// ...
}
```

---

### <a name="CTFPlayer::GetMaxBuffedHealth">CTFPlayer::GetMaxBuffedHealth</a>
Returns the Maximum health we use for Buffing

**Function Signature**<br>
`integer CTFPlayer::GetMaxBuffedHealth()`

**Example Usage**
```js
if(player.GetMaxBuffedHealth() > 300)
{
	// ...
}
```

---

### <a name="CTFPlayer::EyeVector">CTFPlayer::EyeVector</a>
Returns the Forward EyeAngles

**Function Signature**<br>
`Vector CTFPlayer::EyeVector()`

**Example Usage**
```js
travel_distance = player.EyeVector() * 16.0
```

---

### <a name="CTFPlayer::GetFrontOffset">CTFPlayer::GetFrontOffset</a>
Returns the position `offset` units in front of our origin using [`EyeVector`](#CTFPlayer::EyeVector)

**Function Signature**<br>
`Vector CTFPlayer::GetFrontOffset(float offset)`

**Example Usage**
```js
new_position = player.GetFrontOffset(16)
```

---

### <a name="CTFPlayer::GetEyeOffset">CTFPlayer::GetEyeOffset</a>
Returns the position `offset` units in front of our `EyePosition` using [`EyeVector`](#CTFPlayer::EyeVector)

**Function Signature**<br>
`Vector CTFPlayer::GetEyeOffset(float offset)`

**Example Usage**
```js
new_position = player.GetEyeOffset(16)
```

---

### <a name="CTFPlayer::IsPressingButton">CTFPlayer::IsPressingButton</a>
Returns if we are pressing this button

**Function Signature**<br>
`bool CTFPlayer::IsPressingButton(integer button)`

**Example Usage**
```js
if(player.IsPressingButton(IN_ATTACK2))
{
	// ...
}
```

---

### <a name="CTFPlayer::GetWeaponInSlot">CTFPlayer::GetWeaponInSlot</a>
Returns the weapon at `slot` index of our `m_hMyWeapons` NetProp

**Function Signature**<br>
`CTFWeaponBase|null CTFPlayer::GetWeaponInSlot(integer slot)`

>[!CAUTION]
> This Function is **DEPRECATED** and should not be used
> Use [`GetWeaponInSlotNew`]() instead <!-- TODO: Create Link -->

**Example Usage**
```js
weapon = player.GetWeaponInSlot(SLOT_PRIMARY) // : 0
```

---

### <a name="CTFPlayer::SetAmmoByIndex">CTFPlayer::SetAmmoByIndex</a>
Sets this Ammo types ammo amount

**Function Signature**<br>
`void CTFPlayer::SetAmmoByIndex(integer index, integer ammo_type)`

**Example Usage**
```js
player.SetAmmoByIndex(1, 32) // Primary ammo : 32
```

---

### <a name="CTFPlayer::SetPrimaryAmmo">CTFPlayer::SetPrimaryAmmo</a>
Set our Primary ammo amount

**Function Signature**<br>
`void CTFPlayer::SetPrimaryAmmo(integer ammo)`

**Example Usage**
```js
player.SetPrimaryAmmo(32)
```

---

### <a name="CTFPlayer::SetSecondaryAmmo">CTFPlayer::SetSecondaryAmmo</a>
Set our Secondary ammo amount

**Function Signature**<br>
`void CTFPlayer::SetSecondaryAmmo(integer ammo)`

**Example Usage**
```js
player.SetSecondaryAmmo(32)
```

---

### <a name="CTFPlayer::SetMetal">CTFPlayer::SetMetal</a>
Set our Metal amount

**Function Signature**<br>
`void CTFPlayer::SetMetal(integer metal)`

**Example Usage**
```js
player.SetMetal(200)
```

---

### <a name="CTFPlayer::ResetHealth">CTFPlayer::ResetHealth</a>
Reset our Health to the Maximum

**Function Signature**<br>
`void CTFPlayer::ResetHealth()`

**Example Usage**
```js
player.ResetHealth()
```

---

### <a name="CTFPlayer::ResetColor">CTFPlayer::ResetColor</a>
Reset our Render color

**Function Signature**<br>
`void CTFPlayer::ResetColor()`

**Example Usage**
```js
player.ResetColor()
```

---

### <a name="CTFPlayer::SetColor">CTFPlayer::SetColor</a>
Set Render color

**Function Signature**<br>
`void CTFPlayer::SetColor(string color = "255 255 255")`

**Example Usage**
```js
player.SetColor("0 0 255") // Joke: [why are you blue]
```

---
- [`IsDead`](#CTFPlayer::IsDead)


### <a name="CTFPlayer::SetScale">CTFPlayer::SetScale</a>
Set our Model Scale instantly

**Function Signature**<br>
`void CTFPlayer::SetScale(float scale = 1.0)`

**Example Usage**
```js
player.SetScale(1.35)
```

---

### <a name="CTFPlayer::GetHeads">CTFPlayer::GetHeads</a>
Returns the amount of `Heads` we have taken

**Function Signature**<br>
`integer CTFPlayer::GetHeads()`

**Example Usage**
```js
if(player.GetHeads() > 3)
{
	// ...
}
```

---

### <a name="CTFPlayer::SetHeads">CTFPlayer::SetHeads</a>
Set the amount of `Heads` we have taken

**Function Signature**<br>
`void CTFPlayer::SetHeads(integer heads)`

**Example Usage**
```js
player.SetHeads(2)
```

---

### <a name="CTFPlayer::AddHeads">CTFPlayer::AddHeads</a>
Adds heads to the amount of `Heads` we have taken

**Function Signature**<br>
`void CTFPlayer::AddHeads(integer heads)`

**Example Usage**
```js
player.AddHeads(-1)
```

---

### <a name="CTFPlayer::IsDead">CTFPlayer::IsDead</a>
Returns if we are actually dead

**Function Signature**<br>
`bool CTFPlayer::IsDead()`

**Example Usage**
```js
if(player.IsDead())
{
	// ...
}
```

---

### <a name="CTFPlayer::MultiplyGravity">CTFPlayer::MultiplyGravity</a>
Multiply our current gravity by this value

**Function Signature**<br>
`void CTFPlayer::MultiplyGravity(float mult)`

**Example Usage**
```js
player.MultiplyGravity(0.25)
```

---

### <a name="CTFPlayer::PlayerFire">CTFPlayer::PlayerFire</a>
Calls [`EntFireNew`](#GlobalFuncs.EntFireNew) with `this` (the player) as the target

**Function Signature**<br>
`void CTFPlayer::PlayerFire(string action = "", string|null input = "", float delay = -1, CBaseEntity|null activator = this, CBaseEntity|null caller = this)`

**Example Usage**
```js
player.PlayerFire("SetHealth", "100", 0.1)
```

---

### <a name="CTFPlayer::RunScriptCode">CTFPlayer::RunScriptCode</a>
Runs `compilestring` with the input and makes the player `Run` the code as itself with a delay

**Function Signature**<br>
`void CTFPlayer::RunScriptCode(string input, float delay = -1)`

**Example Usage**
```js
player.RunScriptCode("SetHealth(GetHealth() + 100)", 0.1)
```

---

### <a name="CTFPlayer::GetGroundEntity">CTFPlayer::GetGroundEntity</a>
Return our Ground entity (`m_hGroundEntity`)

**Function Signature**<br>
`CBaseEntity|null CTFPlayer::GetGroundEntity()`

**Example Usage**
```js
if(player.GetGroundEntity() == null) // not on ground
{
	// ...
}
```

---

### <a name="CTFPlayer::GetFallingVelocity">CTFPlayer::GetFallingVelocity</a>
Returns our `z` velocity

**Function Signature**<br>
`float CTFPlayer::GetFallingVelocity()`

**Example Usage**
```js
if(player.GetFallingVelocity() < -600)
{
	// ...
}
```

---

### <a name="CTFPlayer::IsDucking">CTFPlayer::IsDucking</a>
Return if we are in the ducking state

**Function Signature**<br>
`bool CTFPlayer::IsDucking()`

**Example Usage**
```js
if(player.IsDucking())
{
	// ...
}
```

---

### <a name="CTFPlayer::IsCrouching">CTFPlayer::IsCrouching</a>
Return is we are holding our crouch button<br>
Usually better than [`IsDucking`](#CTFPlayer::IsDucking)

**Function Signature**<br>
`bool CTFPlayer::IsCrouching()`

**Example Usage**
```js
if(player.IsCrouching())
{
	// ...
}
```

---

### <a name="CTFPlayer::IsReprogrammed">CTFPlayer::IsReprogrammed</a>
Returns if we are Reprogrammed

>[!NOTE]
> Will **ALWAYS** return false for non Robots

**Function Signature**<br>
`bool CTFPlayer::IsReprogrammed()`

**Example Usage**
```js
if(player.IsReprogrammed())
{
	// ...
}
```

---

### <a name="CTFPlayer::IsBot">CTFPlayer::IsBot</a>
Return if we are a bot

>[!NOTE]
> Will **ALWAYS** return false for non Robots

**Function Signature**<br>
`bool CTFPlayer::IsBot()`

**Example Usage**
```js
if(player.IsBot())
{
	// ...
}
```

---

### <a name="CTFPlayer::SetFoodItemCharge">CTFPlayer::SetFoodItemCharge</a>
Sets our Food items Charge

**Function Signature**<br>
`void CTFPlayer::SetFoodItemCharge(float charge)`

**Example Usage**
```js
player.SetFoodItemCharge(50)
```

---

### <a name="CTFPlayer::TakeUnblockableDamage">CTFPlayer::TakeUnblockableDamage</a>
Take Damage that cannot be blocked

**Function Signature**<br>
`void CTFPlayer::TakeUnblockableDamage(float damage, CBaseEntity|null attacker = Entities.First(), CBaseEntity|null attacker inflictor = this, CBaseEntity|null attacker weapon = this)`

**Example Usage**
```js
player.TakeUnblockableDamage(1000)
```

---

### <a name="CTFPlayer::SetCond">CTFPlayer::SetCond</a>
Sets this condition with `duration` duration

**Function Signature**<br>
`void CTFPlayer::SetCond(integer cond, float duration = -1)`

**Example Usage**
```js
player.SetCond(TF_COND_CRITBOOSTED_USER_BUFF, 10)
```