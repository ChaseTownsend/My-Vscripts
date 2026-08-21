# Library Documentation

Progressivly trying to actually document the functions and stuff i make

## Table of Contents

- [Custom Functions](#Custom-Functions)
	- [Global functions](#Global-Functions)
	- [Redefined functions](#Redefined-Functions)
	- [`CTFPlayer` methods](#CTFPlayer-Methods)
	- [`CTFBot` methods](#CTFBot-Methods)
	 - (Most methods from CTFPlayer are ported to CTFBot)
	 <!-- TODO: List the ones that are not ported -->
	- [`CTFWeaponBase` methods](#CTFWeaponBase-Methods)
	- [`CEconEntity` methods](#CEconEntity-Methods)
	 - (Most methods from CTFWeaponBase are ported to CEconEntity)
	 <!-- TODO: List the ones that are not ported -->
	- [`CTFBaseBoss` methods](#CTFBaseBoss-Methods)
	- [`CNavMesh` methods](#CNavMesh-Methods)
	- [`CTFNavArea` methods](#CTFNavArea-Methods)
- [Custom Classes](#Custom-Classes)
- [Custom Script Events](#Custom-Script-Events)
- [Custom Attributes](#Custom-Attributes)
- [Global Constants](#Global-Constants)
- [Chat Commands](#Chat-Commands)
	- [Admin Commands](#Admin-Commands)

--- 
<!-- End of Table of Contents -->

## Custom Functions

--- 
<!-- End of Custom Functions -->

### Global Functions

--- 
<!-- End of Global Functions -->

### Redefined functions

--- 
<!-- End of Redefined Functions -->

### CTFPlayer Methods
 Custom Methods added to `CTFPlayer`
- [`PrintToHud`](#CTFPlayerPrintToHud)
- [`PrintToChat`](#CTFPlayerPrintToChat)
- [`PrintToConsole`](#CTFPlayerPrintToConsole)
- [`PrintToHudF`](#CTFPlayerPrintToHudF)
- [`PrintToChatF`](#CTFPlayerPrintToChatF)
- [`PrintToConsoleF`](#CTFPlayerPrintToConsoleF)
- [`IsOnGround`](#CTFPlayerIsOnGround)
- [`GetUserName`](#CTFPlayerGetUserName)
- [`GetSteamID`](#CTFPlayerGetSteamID)
- [`GetUserID`](#CTFPlayerGetUserID)
- [`GetHealers`](#CTFPlayerGetHealers)
- [`GetAmmoByIndex`](#CTFPlayerGetAmmoByIndex)
- [`GetPrimaryAmmo`](#CTFPlayerGetPrimaryAmmo)
- [`GetSecondaryAmmo`](#CTFPlayerGetSecondaryAmmo)
- [`GetMetal`](#CTFPlayerGetMetal)
- [`IsOverhealed`](#CTFPlayerIsOverhealed)
- [`GetMaxBuffedHealth`](#CTFPlayerGetMaxBuffedHealth)
- [`EyeVector`](#CTFPlayerEyeVector)
- [`GetFrontOffset`](#CTFPlayerGetFrontOffset)
- [`GetEyeOffset`](#CTFPlayerGetEyeOffset)
- [`IsPressingButton`](#CTFPlayerIsPressingButton)
- [`GetWeaponInSlot`](#CTFPlayerGetWeaponInSlot)
- [`SetAmmoByIndex`](#CTFPlayerSetAmmoByIndex)
- [`SetPrimaryAmmo`](#CTFPlayerSetPrimaryAmmo)
- [`SetSecondaryAmmo`](#CTFPlayerSetSecondaryAmmo)
- [`SetMetal`](#CTFPlayerSetMetal)
- [`ResetHealth`](#CTFPlayerResetHealth)
- [`ResetColor`](#CTFPlayerResetColor)
- [`SetColor`](#CTFPlayerSetColor)
- [`SetScale`](#CTFPlayerSetScale)
- [`GetHeads`](#CTFPlayerGetHeads)
- [`SetHeads`](#CTFPlayerSetHeads)
- [`AddHeads`](#CTFPlayerAddHeads)
- [`IsDead`](#CTFPlayerIsDead)
- [`MultiplyGravity`](#CTFPlayerMultiplyGravity)
- [`PlayerFire`](#CTFPlayerPlayerFire)
- [`RunScriptCode`](#CTFPlayerRunScriptCode)
- [`GetGroundEntity`](#CTFPlayerGetGroundEntity)
- [`GetFallingVelocity`](#CTFPlayerGetFallingVelocity)
- [`IsDucking`](#CTFPlayerIsDucking)
- [`IsCrouching`](#CTFPlayerIsCrouching)
- [`IsReprogrammed`](#CTFPlayerIsReprogrammed) <!-- Different for bots -->
- [`IsBot`](#CTFPlayerIsBot)	<!-- Different for bots -->
- [`SetFoodItemCharge`](#CTFPlayerSetFoodItemCharge)
- [`TakeUnblockableDamage`](#CTFPlayerTakeUnblockableDamage)
- [`SetCond`](#CTFPlayerSetCond)
- [`GetTrackedDamage`](#CTFPlayerGetTrackedDamage)
- [`SetTrackedDamage`](#CTFPlayerSetTrackedDamage)
- [`GetTrackedHealing`](#CTFPlayerGetTrackedHealing)
- [`SetTrackedHealing`](#CTFPlayerSetTrackedHealing)
- [`GetTrackedTankDamage`](#CTFPlayerGetTrackedTankDamage)
- [`SetTrackedTankDamage`](#CTFPlayerSetTrackedTankDamage)
- [`GetPercentHealth`](#CTFPlayerGetPercentHealth)
- [`GetPercentMaxHealth`](#CTFPlayerGetPercentMaxHealth)
- [`HasRune`](#CTFPlayerHasRune)
- [`AreViewModelsFlipped`](#CTFPlayerAreViewModelsFlipped)
- [`GetDemomanChargeMeter`](#CTFPlayerGetDemomanChargeMeter)
- [`SetDemomanChargeMeter`](#CTFPlayerSetDemomanChargeMeter)
- [`GetRuneCharge`](#CTFPlayerGetRuneCharge)
- [`SetRuneCharge`](#CTFPlayerSetRuneCharge)
- [`IsPlayerClass`](#CTFPlayerIsPlayerClass)
- [`GetDisguiseClass`](#CTFPlayerGetDisguiseClass)
- [`AddHealth`](#CTFPlayerAddHealth)
- [`RemoveHealth`](#CTFPlayerRemoveHealth)
- [`IsMedicButtonDown`](#CTFPlayerIsMedicButtonDown)
- [`GetChatColor`](#CTFPlayerGetChatColor)
- [`SetThrowableAmmo`](#CTFPlayerSetThrowableAmmo)
- [`InAnyRespawnRoom`](#CTFPlayerInAnyRespawnRoom)
- [`GetEveryHumanWithin`](#CTFPlayerGetEveryHumanWithin)
- [`GetEveryPlayerWithin`](#CTFPlayerGetEveryPlayerWithin)
- [`GetEveryBotWithin`](#CTFPlayerGetEveryBotWithin)
- [`IsMissionMaker`](#CTFPlayerIsMissionMaker)

- TODO: Below are ones not done

- [`ResetPrimaryAmmo`](#CTFPlayerResetPrimaryAmmo)
- [`ResetSecondaryAmmo`](#CTFPlayerResetSecondaryAmmo)
- [`ResetMetal`](#CTFPlayerResetMetal)
- [`GivePercentPrimaryAmmo`](#CTFPlayerGivePercentPrimaryAmmo)
- [`GivePercentSecondaryAmmo`](#CTFPlayerGivePercentSecondaryAmmo)
- [`GivePercentMetal`](#CTFPlayerGivePercentMetal)
- [`GivePercentGrenadesAmmo`](#CTFPlayerGivePercentGrenadesAmmo)
- [`ToggleGlow`](#CTFPlayerToggleGlow)
- [`GetLanguage`](#CTFPlayerGetLanguage)
- [`IHTranslateToChat`](#CTFPlayerIHTranslateToChat)
- [`IHTranslateToChat2`](#CTFPlayerIHTranslateToChat2)
- [`TranslateToHud`](#CTFPlayerTranslateToHud)
- [`TranslateToChat`](#CTFPlayerTranslateToChat)
- [`SwitchWeaponSlot`](#CTFPlayerSwitchWeaponSlot)
- [`IsMinicritDebuffed`](#CTFPlayerIsMinicritDebuffed)
- [`IsMinicritBuffed`](#CTFPlayerIsMinicritBuffed)
- [`HasCritImmunity`](#CTFPlayerHasCritImmunity)
- [`HasPasstimeBall`](#CTFPlayerHasPasstimeBall)
- [`GetStealthNoAttackExpireTime`](#CTFPlayerGetStealthNoAttackExpireTime)
- [`IsFeignDeathReady`](#CTFPlayerIsFeignDeathReady)
- [`IsEnemy`](#CTFPlayerIsEnemy)
- [`SetJetpackCharge`](#CTFPlayerSetJetpackCharge) <!-- Redefine of SetFoodItemCharge -->
- [`SetRazorbackCharge`](#CTFPlayerSetRazorbackCharge) <!-- Redefine of SetFoodItemCharge -->
- [`GenerateAndWearItem`](#CTFPlayerGenerateAndWearItem) <!-- Redefine from CTFBot onto CTFPlayer -->
- [`GetWeaponIDXInSlot`](#CTFPlayerGetWeaponIDXInSlot)
- [`GetWeaponIDXInSlotNew`](#CTFPlayerGetWeaponIDXInSlotNew) <!-- Exactly the same as GetWeaponIDXInSlot -->
- [`GetActiveWeaponIDX`](#CTFPlayerGetActiveWeaponIDX)
- [`GetAbilityWeaponIDX`](#CTFPlayerGetAbilityWeaponIDX)
- [`GetAbilityWeaponIDXs`](#CTFPlayerGetAbilityWeaponIDXs)
- [`AddTrackedDamage`](#CTFPlayerAddTrackedDamage)
- [`AddTrackedHealing`](#CTFPlayerAddTrackedHealing)
- [`AddTrackedTankDamage`](#CTFPlayerAddTrackedTankDamage)
- [`GetCurrentRune`](#CTFPlayerGetCurrentRune)
- [`GetRuneResistance`](#CTFPlayerGetRuneResistance)
- [`IsValidReprogramTarget`](#CTFPlayerIsValidReprogramTarget)
- [`Suicide`](#CTFPlayerSuicide)
- [`AddThrowableCharge`](#CTFPlayerAddThrowableCharge)
- [`SetThrowableCharge`](#CTFPlayerSetThrowableCharge)
- [`IsUberDraining`](#CTFPlayerIsUberDraining)
- [`GetAbilityWeapon`](#CTFPlayerGetAbilityWeapon)
- [`GetAbilityWeapons`](#CTFPlayerGetAbilityWeapons)
- [`ForceTaunt`](#CTFPlayerForceTaunt)
- [`GetMyWeaponsArray`](#CTFPlayerGetMyWeaponsArray)
- [`GetWeaponInSlotNew`](#CTFPlayerGetWeaponInSlotNew)
- [`GetAllWeapons`](#CTFPlayerGetAllWeapons)
- [`GetSpellBook`](#CTFPlayerGetSpellBook)
- [`InRespawnRoom`](#CTFPlayerInRespawnRoom)
- [`GetEveryTankWithin`](#CTFPlayerGetEveryTankWithin)
- [`DamageEveryTankWithin`](#CTFPlayerDamageEveryTankWithin)
- [`DamageEveryBotWithin`](#CTFPlayerDamageEveryBotWithin)
- [`RemoveStun`](#CTFPlayerRemoveStun)
- [`IsInvincible`](#CTFPlayerIsInvincible) <!-- Are they [Insert Title card here] -->
- [`IsEventJudge`](#CTFPlayerIsEventJudge)
- [`IsAdmin`](#CTFPlayerIsAdmin)
- [`HasWeapon`](#CTFPlayerHasWeapon)
- [`HasWeaponClassname`](#CTFPlayerHasWeaponClassname)
- [`GetWeapon`](#CTFPlayerGetWeapon)
- [`GetWeaponClassname`](#CTFPlayerGetWeaponClassname)
- [`RegenerateNoHP`](#CTFPlayerRegenerateNoHP)
- [`GetMaximumPrimaryAmmo`](#CTFPlayerGetMaximumPrimaryAmmo)
- [`GetMaximumSecondaryAmmo`](#CTFPlayerGetMaximumSecondaryAmmo)
- [`GetMaximumMetal`](#CTFPlayerGetMaximumMetal)
- [`GetMaximumGrenades1`](#CTFPlayerGetMaximumGrenades1)
- [`GetMaximumGrenades3`](#CTFPlayerGetMaximumGrenades3)
- [`GivePercentAmmo`](#CTFPlayerGivePercentAmmo)
- [`ResetAmmo`](#CTFPlayerResetAmmo)
- [`InMultiCond`](#CTFPlayerInMultiCond)
- [`ForceChangeClass`](#CTFPlayerForceChangeClass)
- [`GetPlayerClassName`](#CTFPlayerGetPlayerClassName)
- [`GetTranslatedString`](#CTFPlayerGetTranslatedString)
- [`GetTranslatedAndFormattedString`](#CTFPlayerGetTranslatedAndFormattedString)
- [`SetAbilityTime`](#CTFPlayerSetAbilityTime)
- [`AddAbilityTime`](#CTFPlayerAddAbilityTime)
- [`TeamFortress_SetSpeed`](#CTFPlayerTeamFortress_SetSpeed)
- [`DisplayHudText`](#CTFPlayerDisplayHudText)
- [`CalculateEHP`](#CTFPlayerCalculateEHP)
- [`KillUnknownWeapons`](#CTFPlayerKillUnknownWeapons)
- [`GetCorrosion`](#CTFPlayerGetCorrosion)
- [`HasCorrosion`](#CTFPlayerHasCorrosion)
- [`ShouldRemoveCorrosion`](#CTFPlayerShouldRemoveCorrosion)
- [`RemoveCorrosion`](#CTFPlayerRemoveCorrosion)
- [`MakeCorrosion`](#CTFPlayerMakeCorrosion)
- [`CanHaveCorrosion`](#CTFPlayerCanHaveCorrosion)
- [`MakeCorrosionPuddle`](#CTFPlayerMakeCorrosionPuddle)
- [`RollSpell`](#CTFPlayerRollSpell)
- [`SetUpThinkTable`](#CTFPlayerSetUpThinkTable)
- [`AddPreservedThink`](#CTFPlayerAddPreservedThink)
- [`AddThink`](#CTFPlayerAddThink)
- [`RemoveThink`](#CTFPlayerRemoveThink)
- [`DiedWithAbility`](#CTFPlayerDiedWithAbility)
- [`FixAmmo`](#CTFPlayerFixAmmo)
- [`RemoveWearables`](#CTFPlayerRemoveWearables)
- [`GetMoveChildren`](#CTFPlayerGetMoveChildren)
- [`GetMoveChildrenWeapons`](#CTFPlayerGetMoveChildrenWeapons)
- [`TransformGHeavy`](#CTFPlayerTransformGHeavy)
- [`UndoGHeavy`](#CTFPlayerUndoGHeavy)
- [`IsGHeavy`](#CTFPlayerIsGHeavy)
- [`EquipItem`](#CTFPlayerEquipItem)
- [`EquipItemBAD`](#CTFPlayerEquipItemBAD)
- [`GetActiveHealers`](#CTFPlayerGetActiveHealers)
- [`GetOverHealCapMult`](#CTFPlayerGetOverHealCapMult)
- [`HealPlayer`](#CTFPlayerHealPlayer)
- [`HookMultAttributes`](#CTFPlayerHookMultAttributes)
- [`HookAdditiveAttributes`](#CTFPlayerHookAdditiveAttributes)
- [`GetBaseMovespeed`](#CTFPlayerGetBaseMovespeed)
- [`GetMoveSpeed`](#CTFPlayerGetMoveSpeed)
- [`DistanceTo`](#CTFPlayerDistanceTo)
- [`GetClosestPlayer`](#CTFPlayerGetClosestPlayer)
- [`AttachParticle`](#CTFPlayerAttachParticle)
- [`EmitSoundTo`](#CTFPlayerEmitSoundTo)
- [`PrintConds`](#CTFPlayerPrintConds)
- [`StripItemSlot`](#CTFPlayerStripItemSlot)
- [`CanStomp`](#CTFPlayerCanStomp)
- [`GetStompWeapon`](#CTFPlayerGetStompWeapon)
- [`GetWearables`](#CTFPlayerGetWearables)
- [`GetWearableByIDX`](#CTFPlayerGetWearableByIDX)
- [`CanAttack`](#CTFPlayerCanAttack)
- [`IsTruceValidForEnt`](#CTFPlayerIsTruceValidForEnt)
- [`ApplyGenericPushbackImpulse`](#CTFPlayerApplyGenericPushbackImpulse)
- [`AddToSpyCloakMeter`](#CTFPlayerAddToSpyCloakMeter)
- [`CheckBlockBackstab`](#CTFPlayerCheckBlockBackstab)
- [`AddTmpDamageBonus`](#CTFPlayerAddTmpDamageBonus) <!-- Does Nothing normally -->
- [`GetInternalVar`](#CTFPlayerGetInternalVar)
- [`SetInternalVar`](#CTFPlayerSetInternalVar)
- [`UseGiantModel`](#CTFPlayerUseGiantModel)
- [`UseRobotModel`](#CTFPlayerUseRobotModel)
- [`ShouldDetonate`](#CTFPlayerShouldDetonate) <!-- Used with Rafmod `fire input on taunt` for custom sentry buster -->
- [`SentryBusterExplode`](#CTFPlayerSentryBusterExplode)
- [`MakeBleed`](#CTFPlayerMakeBleed) <!-- Wont work without Sourcemod plugin-->
- [`DisplayHudHint`](#CTFPlayerDisplayHudHint)
- [`GetEyeTrace`](#CTFPlayerGetEyeTrace) <!-- Implementation of GLua's GetEyeTrace where it caches the result for if you call it multiple times per frame -->

<!-- 
- [``](#CTFPlayer)
-->

---


#### <a name="CTFPlayer.PrintToHud">CTFPlayer.PrintToHud</a>
Prints a Message to the players Hud

**Function Signature**<br>
`void CTFPlayer::PrintToHud(string message = "")`

**Example Usage**
```js
player.PrintToHud("Your Shield is on Cooldown!")
```

---

#### <a name="CTFPlayer.PrintToChat">CTFPlayer.PrintToChat</a>
Prints a Message to the players Chat

**Function Signature**<br>
`void CTFPlayer::PrintToChat(string message = "")`

**Example Usage**
```js
player.PrintToChat("Your Shield is on Cooldown!")
```

---

#### <a name="CTFPlayer.PrintToConsole">CTFPlayer.PrintToConsole</a>
Prints a Message to the players Console

**Function Signature**<br>
`void CTFPlayer::PrintToConsole(string message = "")`

**Example Usage**
```js
player.PrintToConsole("Debug: 15% charged")
```

---

#### <a name="CTFPlayer.PrintToHudF">CTFPlayer.PrintToHudF</a>
Prints a Message to the players Hud with 

**Function Signature**<br>
`void CTFPlayer::PrintToHudF(string format, any ...)`

**Example Usage**
```js
player.PrintToHudF("Your %s is on Cooldown!", "Medication")
```

---

#### <a name="CTFPlayer.PrintToChatF">CTFPlayer.PrintToChatF</a>
Prints a Message to the players Chat with formating

**Function Signature**<br>
`void CTFPlayer::PrintToChatF(string format, any ...)`

**Example Usage**
```js
player.PrintToChatF("Your %s is on Cooldown!", "Medication")
```

---

#### <a name="CTFPlayer.PrintToConsoleF">CTFPlayer.PrintToConsoleF</a>
Prints a Message to the players Console with formating

**Function Signature**<br>
`void CTFPlayer::PrintToConsoleF(string format, any ...)`

**Example Usage**
```js
player.PrintToConsoleF("Debug: Wave is %f%% done", 37.21)
```

---

#### <a name="CTFPlayer.IsOnGround">CTFPlayer.IsOnGround</a>
Returns if the player is on the ground.

**Function Signature**<br>
`bool CTFPlayer::IsOnGround()`

**Example Usage**
```js
if (player.IsOnGround())
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetUserName">CTFPlayer.GetUserName</a>
Returns the players Username

**Function Signature**<br>
`string CTFPlayer::GetUserName()`

**Example Usage**
```js
if (player.GetUserName() == "BigBob")
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetSteamID">CTFPlayer.GetSteamID</a>
Returns the players SteamID

**Function Signature**<br>
`string CTFPlayer::GetSteamID()`

**Example Usage**
```js
if (player.GetSteamID() == "[U:1:969530867]")
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetUserID">CTFPlayer.GetUserID</a>
Returns the players UserID to be used with `GetPlayerFromUserID()`

**Function Signature**<br>
`string CTFPlayer::GetUserID()`

**Example Usage**
```js
Players.append(player.GetUserID())
```

---

#### <a name="CTFPlayer.GetHealers">CTFPlayer.GetHealers</a>
Returns the players healing us

**Function Signature**<br>
`[CTFPlayer] CTFPlayer::GetHealers()`

**Example Usage**
```js
foreach (plr in player.GetHealers())
{
	plr.AddCustomAttribute("dmg taken increased", 0.75, 5)
}
```

---

#### <a name="CTFPlayer.GetAmmoByIndex">CTFPlayer.GetAmmoByIndex</a>
Returns the amount of ammo we have for this ammo type.

**Function Signature**<br>
`integer CTFPlayer::GetAmmoByIndex(integer ammo_type)`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetAmmoByIndex(1)+" Primary ammo") // Primary ammo
```

---

#### <a name="CTFPlayer.GetPrimaryAmmo">CTFPlayer.GetPrimaryAmmo</a>
Returns the amount of Primary ammo we have.

**Function Signature**<br>
`integer CTFPlayer::GetPrimaryAmmo()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetPrimaryAmmo()+" Primary ammo")
```

---

#### <a name="CTFPlayer.GetSecondaryAmmo">CTFPlayer.GetSecondaryAmmo</a>
Returns the amount of Secondary ammo we have.

**Function Signature**<br>
`integer CTFPlayer::GetSecondaryAmmo()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetSecondaryAmmo()+" Secondary ammo")
```

---

#### <a name="CTFPlayer.GetMetal">CTFPlayer.GetMetal</a>
Returns the amount of Metal we have.

**Function Signature**<br>
`integer CTFPlayer::GetMetal()`

**Example Usage**
```js
printl("player: "+player+" Has "+player.GetMetal()+" Metal")
```

---

#### <a name="CTFPlayer.IsOverhealed">CTFPlayer.IsOverhealed</a>
Returns if we are Overhealed (hp > max_hp)

**Function Signature**<br>
`bool CTFPlayer::IsOverhealed()`

**Example Usage**
```js
if (player.IsOverhealed())
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetMaxBuffedHealth">CTFPlayer.GetMaxBuffedHealth</a>
Returns the Maximum health we use for Buffing

**Function Signature**<br>
`integer CTFPlayer::GetMaxBuffedHealth()`

**Example Usage**
```js
if (player.GetMaxBuffedHealth() > 300)
{
	// ...
}
```

---

#### <a name="CTFPlayer.EyeVector">CTFPlayer.EyeVector</a>
Returns the Forward EyeAngles

**Function Signature**<br>
`Vector CTFPlayer::EyeVector()`

**Example Usage**
```js
travel_distance = player.EyeVector() * 16.0
```

---

#### <a name="CTFPlayer.GetFrontOffset">CTFPlayer.GetFrontOffset</a>
Returns the position `offset` units in front of our origin using [`EyeVector`](#CTFPlayerEyeVector)

**Function Signature**<br>
`Vector CTFPlayer::GetFrontOffset(float offset)`

**Example Usage**
```js
new_position = player.GetFrontOffset(16)
```

---

#### <a name="CTFPlayer.GetEyeOffset">CTFPlayer.GetEyeOffset</a>
Returns the position `offset` units in front of our `EyePosition` using [`EyeVector`](#CTFPlayerEyeVector)

**Function Signature**<br>
`Vector CTFPlayer::GetEyeOffset(float offset)`

**Example Usage**
```js
new_position = player.GetEyeOffset(16)
```

---

#### <a name="CTFPlayer.IsPressingButton">CTFPlayer.IsPressingButton</a>
Returns if we are pressing this button

**Function Signature**<br>
`bool CTFPlayer::IsPressingButton(integer button)`

**Example Usage**
```js
if (player.IsPressingButton(IN_ATTACK2))
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetWeaponInSlot">CTFPlayer.GetWeaponInSlot</a>
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

#### <a name="CTFPlayer.SetAmmoByIndex">CTFPlayer.SetAmmoByIndex</a>
Sets this Ammo types ammo amount

**Function Signature**<br>
`void CTFPlayer::SetAmmoByIndex(integer index, integer ammo_type)`

**Example Usage**
```js
player.SetAmmoByIndex(1, 32) // Primary ammo : 32
```

---

#### <a name="CTFPlayer.SetPrimaryAmmo">CTFPlayer.SetPrimaryAmmo</a>
Set our Primary ammo amount

**Function Signature**<br>
`void CTFPlayer::SetPrimaryAmmo(integer ammo)`

**Example Usage**
```js
player.SetPrimaryAmmo(32)
```

---

#### <a name="CTFPlayer.SetSecondaryAmmo">CTFPlayer.SetSecondaryAmmo</a>
Set our Secondary ammo amount

**Function Signature**<br>
`void CTFPlayer::SetSecondaryAmmo(integer ammo)`

**Example Usage**
```js
player.SetSecondaryAmmo(32)
```

---

#### <a name="CTFPlayer.SetMetal">CTFPlayer.SetMetal</a>
Set our Metal amount

**Function Signature**<br>
`void CTFPlayer::SetMetal(integer metal)`

**Example Usage**
```js
player.SetMetal(200)
```

---

#### <a name="CTFPlayer.ResetHealth">CTFPlayer.ResetHealth</a>
Reset our Health to the Maximum

**Function Signature**<br>
`void CTFPlayer::ResetHealth()`

**Example Usage**
```js
player.ResetHealth()
```

---

#### <a name="CTFPlayer.ResetColor">CTFPlayer.ResetColor</a>
Reset our Render color

**Function Signature**<br>
`void CTFPlayer::ResetColor()`

**Example Usage**
```js
player.ResetColor()
```

---

#### <a name="CTFPlayer.SetColor">CTFPlayer.SetColor</a>
Set Render color

**Function Signature**<br>
`void CTFPlayer::SetColor(string color = "255 255 255")`

**Example Usage**
```js
player.SetColor("0 0 255") // Joke: [why are you blue]
```

---
- [`IsDead`](#CTFPlayerIsDead)


#### <a name="CTFPlayer.SetScale">CTFPlayer.SetScale</a>
Set our Model Scale instantly

**Function Signature**<br>
`void CTFPlayer::SetScale(float scale = 1.0)`

**Example Usage**
```js
player.SetScale(1.35)
```

---

#### <a name="CTFPlayer.GetHeads">CTFPlayer.GetHeads</a>
Returns the amount of `Heads` we have taken

**Function Signature**<br>
`integer CTFPlayer::GetHeads()`

**Example Usage**
```js
if (player.GetHeads() > 3)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetHeads">CTFPlayer.SetHeads</a>
Set the amount of `Heads` we have taken

**Function Signature**<br>
`void CTFPlayer::SetHeads(integer heads)`

**Example Usage**
```js
player.SetHeads(2)
```

---

#### <a name="CTFPlayer.AddHeads">CTFPlayer.AddHeads</a>
Adds heads to the amount of `Heads` we have taken

**Function Signature**<br>
`void CTFPlayer::AddHeads(integer heads)`

**Example Usage**
```js
player.AddHeads(-1)
```

---

#### <a name="CTFPlayer.IsDead">CTFPlayer.IsDead</a>
Returns if we are actually dead

**Function Signature**<br>
`bool CTFPlayer::IsDead()`

**Example Usage**
```js
if (player.IsDead())
{
	// ...
}
```

---

#### <a name="CTFPlayer.MultiplyGravity">CTFPlayer.MultiplyGravity</a>
Multiply our current gravity by this value

**Function Signature**<br>
`void CTFPlayer::MultiplyGravity(float mult)`

**Example Usage**
```js
player.MultiplyGravity(0.25)
```

---

#### <a name="CTFPlayer.PlayerFire">CTFPlayer.PlayerFire</a>
Calls [`EntFireNew`](#GlobalFuncs.EntFireNew) with `this` (the player) as the target

**Function Signature**<br>
`void CTFPlayer::PlayerFire(string action = "", string|null input = "", float delay = -1, CBaseEntity|null activator = this, CBaseEntity|null caller = this)`

**Example Usage**
```js
player.PlayerFire("SetHealth", "100", 0.1)
```

---

#### <a name="CTFPlayer.RunScriptCode">CTFPlayer.RunScriptCode</a>
Runs `compilestring` with the input and makes the player `Run` the code as itself with a delay

**Function Signature**<br>
`void CTFPlayer::RunScriptCode(string input, float delay = -1)`

**Example Usage**
```js
player.RunScriptCode("SetHealth(GetHealth() + 100)", 0.1)
```

---

#### <a name="CTFPlayer.GetGroundEntity">CTFPlayer.GetGroundEntity</a>
Return our Ground entity (`m_hGroundEntity`)

**Function Signature**<br>
`CBaseEntity|null CTFPlayer::GetGroundEntity()`

**Example Usage**
```js
if (player.GetGroundEntity() == null) // not on ground
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetFallingVelocity">CTFPlayer.GetFallingVelocity</a>
Returns our `z` velocity

**Function Signature**<br>
`float CTFPlayer::GetFallingVelocity()`

**Example Usage**
```js
if (player.GetFallingVelocity() < -600)
{
	// ...
}
```

---

#### <a name="CTFPlayer.IsDucking">CTFPlayer.IsDucking</a>
Return if we are in the ducking state

**Function Signature**<br>
`bool CTFPlayer::IsDucking()`

**Example Usage**
```js
if (player.IsDucking())
{
	// ...
}
```

---

#### <a name="CTFPlayer.IsCrouching">CTFPlayer.IsCrouching</a>
Return is we are holding our crouch button<br>
Usually better than [`IsDucking`](#CTFPlayerIsDucking)

**Function Signature**<br>
`bool CTFPlayer::IsCrouching()`

**Example Usage**
```js
if (player.IsCrouching())
{
	// ...
}
```

---

#### <a name="CTFPlayer.IsReprogrammed">CTFPlayer.IsReprogrammed</a>
Returns if we are Reprogrammed

>[!NOTE]
> Will **ALWAYS** return false for non Robots

**Function Signature**<br>
`bool CTFPlayer::IsReprogrammed()`

**Example Usage**
```js
if (player.IsReprogrammed())
{
	// ...
}
```

---

#### <a name="CTFPlayer.IsBot">CTFPlayer.IsBot</a>
Return if we are a bot

>[!NOTE]
> Will **ALWAYS** return false for non Robots

**Function Signature**<br>
`bool CTFPlayer::IsBot()`

**Example Usage**
```js
if (player.IsBot())
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetFoodItemCharge">CTFPlayer.SetFoodItemCharge</a>
Sets our Food items Charge

**Function Signature**<br>
`void CTFPlayer::SetFoodItemCharge(float charge)`

**Example Usage**
```js
player.SetFoodItemCharge(50)
```

---

#### <a name="CTFPlayer.TakeUnblockableDamage">CTFPlayer.TakeUnblockableDamage</a>
Take Damage that cannot be blocked

**Function Signature**<br>
`void CTFPlayer::TakeUnblockableDamage(float damage, CBaseEntity|null attacker = Entities.First(), CBaseEntity|null attacker inflictor = this, CBaseEntity|null attacker weapon = this)`

**Example Usage**
```js
player.TakeUnblockableDamage(1000)
```

---

#### <a name="CTFPlayer.SetCond">CTFPlayer.SetCond</a>
Sets this condition with `duration` duration

**Function Signature**<br>
`void CTFPlayer::SetCond(integer cond, float duration = -1)`

**Example Usage**
```js
player.SetCond(TF_COND_CRITBOOSTED_USER_BUFF, 10)
```

---

#### <a name="CTFPlayer.GetTrackedDamage">CTFPlayer.GetTrackedDamage</a>
Returns our internal Tracked damage

**Function Signature**<br>
`integer CTFPlayer::GetTrackedDamage()`

**Example Usage**
```js
if (player.GetTrackedDamage() > 1000)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetTrackedDamage">CTFPlayer.SetTrackedDamage</a>
Sets our internal Tracked Damage

**Function Signature**<br>
`void CTFPlayer::SetTrackedDamage(integer damage)`

**Example Usage**
```js
player.SetTrackedDamage(player.GetTrackedDamage() + 10)
```

---

#### <a name="CTFPlayer.GetTrackedHealing">CTFPlayer.GetTrackedHealing</a>
Returns our internal Tracked Healing

**Function Signature**<br>
`integer CTFPlayer::GetTrackedHealing()`

**Example Usage**
```js
if (player.GetTrackedHealing() > 1000)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetTrackedHealing">CTFPlayer.SetTrackedHealing</a>
Sets our internal Tracked Healing 

**Function Signature**<br>
`void CTFPlayer::SetTrackedHealing(integer healing)`

**Example Usage**
```js
player.SetTrackedHealing(player.GetTrackedHealing() + 24)
```

---

#### <a name="CTFPlayer.GetTrackedTankDamage">CTFPlayer.GetTrackedTankDamage</a>
Returns our internal Tracked tank Damage

**Function Signature**<br>
`integer CTFPlayer::GetTrackedTankDamage()`

**Example Usage**
```js
if (player.GetTrackedTankDamage() > 1000)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetTrackedTankDamage">CTFPlayer.SetTrackedTankDamage</a>
Sets our internal Tracked tank Damage 

**Function Signature**<br>
`void CTFPlayer::SetTrackedTankDamage(integer damage)`

**Example Usage**
```js
player.SetTrackedTankDamage(player.GetTrackedTankDamage() + 25)
```

---

#### <a name="CTFPlayer.GetPercentHealth">CTFPlayer.GetPercentHealth</a>
Returns `percent` percent of our current health

**Function Signature**<br>
`float CTFPlayer::GetPercentHealth(float percent)`

**Example Usage**
```js
if (player.GetPercentHealth(50) < 100)
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetPercentMaxHealth">CTFPlayer.GetPercentMaxHealth</a>
Returns `percent` percent of our maximum health

**Function Signature**<br>
`integer CTFPlayer::GetPercentMaxHealth()`

**Example Usage**
```js
if (player.GetPercentMaxHealth(50) < 100)
{
	// ...
}
```

---

#### <a name="CTFPlayer.HasRune">CTFPlayer.HasRune</a>
Returns if we have this Rune.

**Function Signature**<br>
`bool CTFPlayer::HasRune(integer rune)`

**Example Usage**
```js
if (player.HasRune(RUNE_STRENGTH))
{
	// ...
}
```

---

#### <a name="CTFPlayer.AreViewModelsFlipped">CTFPlayer.AreViewModelsFlipped</a>
Returns if our viewmodels are flipped

**Function Signature**<br>
`bool CTFPlayer::AreViewModelsFlipped()`

**Example Usage**
```js
if (player.AreViewModelsFlipped())
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetDemomanChargeMeter">CTFPlayer.GetDemomanChargeMeter</a>
Returns our shield charge meter

**Function Signature**<br>
`float CTFPlayer::GetDemomanChargeMeter()`

**Example Usage**
```js
if (player.GetDemomanChargeMeter() > 50.0)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetDemomanChargeMeter">CTFPlayer.SetDemomanChargeMeter</a>
Sets our shield charge meter

**Function Signature**<br>
`void CTFPlayer::SetDemomanChargeMeter(float percent)`

**Example Usage**
```js
player.SetDemomanChargeMeter(player.GetDemomanChargeMeter() - 25.0)
```

---

#### <a name="CTFPlayer.GetRuneCharge">CTFPlayer.GetRuneCharge</a>
Returns our Supernova rune percent

**Function Signature**<br>
`float CTFPlayer::GetRuneCharge()`

**Example Usage**
```js
if (player.GetRuneCharge() > 50.0)
{
	// ...
}
```

---

#### <a name="CTFPlayer.SetRuneCharge">CTFPlayer.SetRuneCharge</a>
Set the percent of our Supernova rune percent

**Function Signature**<br>
`void CTFPlayer::SetRuneCharge(float percent)`

**Example Usage**
```js
player.SetRuneCharge(player.GetRuneCharge() - 25.0)
```
- [`IsMissionMaker`](#CTFPlayerIsMissionMaker)
---

#### <a name="CTFPlayer.IsPlayerClass">CTFPlayer.IsPlayerClass</a>
Returns if GetPlayerClass() == input value

**Function Signature**<br>
`bool CTFPlayer::IsPlayerClass(int playerclass)`

**Example Usage**
```js
if (player.IsPlayerClass(TF_CLASS_SPY))
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetDisguiseClass">CTFPlayer.GetDisguiseClass</a>
Returns the class the player is disguised as<br>TODO: find what it returns if not disguised

**Function Signature**<br>
`int CTFPlayer::GetDisguiseClass()`

**Example Usage**
```js
if (player.GetDisguiseClass() == TF_CLASS_SCOUT)
{
	// ...
}
```

---

#### <a name="CTFPlayer.AddHealth">CTFPlayer.AddHealth</a>
Simply adds health to the player

**Function Signature**<br>
`void CTFPlayer::AddHealth(int health)`

**Example Usage**
```js
player.AddHealth(10)
```

---

#### <a name="CTFPlayer.RemoveHealth">CTFPlayer.RemoveHealth</a>
Simply removes health from the player

**Function Signature**<br>
`void CTFPlayer::(int health)`

**Example Usage**
```js
player.RemoveHealth(10)
```

---

#### <a name="CTFPlayer.IsMedicButtonDown">CTFPlayer.IsMedicButtonDown</a>
Returns if medic button is being pressed<br><b>BUG:</b> Will not work when the player uses `voicemenu 0 0` instead of `+helpme`!

**Function Signature**<br>
`bool CTFPlayer::IsMedicButtonDown()`

**Example Usage**
```js
if (player.IsMedicButtonDown())
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetChatColor">CTFPlayer.GetChatColor</a>
Returns the color string for the players team

**Function Signature**<br>
`string CTFPlayer::GetChatColor()`

**Example Usage**
```js
player.PrintToChatF("%s%s:\x01Hello from me!", player.GetChatColor(), player.GetUserName())
```

---

#### <a name="CTFPlayer.SetThrowableAmmo">CTFPlayer.SetThrowableAmmo</a>
Set ammo of your throwable. Does nothing with no throwable

**Function Signature**<br>
`void CTFPlayer::SetThrowableAmmo(int ammo)`

**Example Usage**
```js
player.SetThrowableAmmo(0)
```

---

#### <a name="CTFPlayer.InAnyRespawnRoom">CTFPlayer.InAnyRespawnRoom</a>
Returns if the player is in Any respawnroom

**Function Signature**<br>
`bool CTFPlayer::InAnyRespawnRoom()`

>[!CAUTION]
> This Function is **DEPRECATED** and should not be used
> Not Likely to work!

**Example Usage**
```js
if (player.InAnyRespawnRoom())
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetEveryHumanWithin">CTFPlayer.GetEveryHumanWithin</a>
Gets all Human players within a radius

**Function Signature**<br>
`[CTFPlayer] CTFPlayer::GetEveryHumanWithin(float range, bool include_me = false)`

>[!CAUTION]
> This Function is **DEPRECATED** and should not be used
> Loop over the `m_aHumans` array and filter by range

**Example Usage**
```js
local players = player.GetEveryHumanWithin(150.0)
foreach (human in players)
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetEveryPlayerWithin">CTFPlayer.GetEveryPlayerWithin</a>
Gets all players within a radius

**Function Signature**<br>
`[CTFPlayer] CTFPlayer::GetEveryPlayerWithin(float range, bool include_me = false)`

>[!CAUTION]
> This Function is **DEPRECATED** and should not be used
> Loop over the `Players` array and filter by range

**Example Usage**
```js
local players = player.GetEveryPlayerWithin(150.0)
foreach (plr in players)
{
	// ...
}
```

---

#### <a name="CTFPlayer.GetEveryBotWithin">CTFPlayer.GetEveryBotWithin</a>
Gets all players within a radius

**Function Signature**<br>
`[CTFBot] CTFPlayer::GetEveryBotWithin(float range)`

>[!CAUTION]
> This Function is **DEPRECATED** and should not be used
> Loop over the `m_aRobots` array and filter by range

**Example Usage**
```js
local bots = player.GetEveryPlayerWithin(150.0)
foreach (bot in bots)
{
	// ...
}
```

---

#### <a name="CTFPlayer.IsMissionMaker">CTFPlayer.IsMissionMaker</a>
Returns if the player is Added to the MissionMakers array

**Function Signature**<br>
`bool CTFPlayer::IsMissionMaker()`

**Example Usage**
```js
if (player.IsMissionMaker())
{
	// ...
}
```

--- 
<!-- End of CTFPlayer Methods -->

### CTFBot Methods

--- 
<!-- End of CTFBot Methods -->

### CTFWeaponBase Methods

--- 
<!-- End of CTFWeaponBase Methods -->

### CEconEntity Methods

--- 
<!-- End of CEconEntity Methods -->

### CTFBaseBoss Methods

--- 
<!-- End of CTFBaseBoss Methods -->

### CNavMesh Methods

--- 
<!-- End of CNavMesh Methods -->

### CTFNavArea Methods

--- 
<!-- End of CTFNavArea Methods -->

## Custom Classes

### Corrosion 
Corrosion is a custom class implemented to handle most corrosion logic

**Constructor Signature**<br>
`void Corrosion::constructor( CTFPlayer|null hOuter )`

--- 
<!-- End of Corrosion.constructor -->

#### Corrosion Methods

##### <a name="Corrosion.CreateCorrosion">Corrosion.CreateCorrosion</a>
Creates corrosion data, can provide a null weapon if values are passed from `exdata`

**Function Signature**<br>
`void Corrosion::CreateCorrosion( CTFPlayer|null attacker, CTFWeaponBase| nullweapon, table|bool exdata = false )`

--- 
<!-- End of Corrosion.CreateCorrosion -->

##### <a name="Corrosion.Enable">Corrosion.Enable</a>
Enables Corrosion

**Function Signature**<br>
`void Corrosion::Enable()`

--- 
<!-- End of Corrosion.Enable -->

##### <a name="Corrosion.Disable">Corrosion.Disable</a>
Disables Corrosion

**Function Signature**<br>
`void Corrosion::Disable()`

--- 
<!-- End of Corrosion.Disable -->

##### <a name="Corrosion.InitVars">Corrosion.InitVars</a>
Initalize some vars to 0

**Function Signature**<br>
`void Corrosion::InitVars()`

--- 
<!-- End of Corrosion.InitVars -->

##### <a name="Corrosion.InitAllVars">Corrosion.InitAllVars</a>
Initalize all vars to 0

**Function Signature**<br>
`void Corrosion::InitAllVars()`

--- 
<!-- End of Corrosion.InitAllVars -->

##### <a name="Corrosion.HasCorrosion">Corrosion.HasCorrosion</a>
Returns if the corrosion is enabled

**Function Signature**<br>
`bool Corrosion::HasCorrosion()`

--- 
<!-- End of Corrosion.HasCorrosion -->

##### <a name="Corrosion.ShouldRemoveCorrosion">Corrosion.ShouldRemoveCorrosion</a>
Returns if the corrosion should be removed

**Function Signature**<br>
`bool Corrosion::ShouldRemoveCorrosion()`

--- 
<!-- End of Corrosion.ShouldRemoveCorrosion -->

##### <a name="Corrosion.RemoveCorrosion">Corrosion.RemoveCorrosion</a>
Removes the corrosion

**Function Signature**<br>
`void Corrosion::RemoveCorrosion()`

--- 
<!-- End of Corrosion.RemoveCorrosion -->

##### <a name="Corrosion.ShouldUpdate">Corrosion.ShouldUpdate</a>
Returns if this corrosion should proccess an update

**Function Signature**<br>
`bool Corrosion::ShouldUpdate()`

--- 
<!-- End of Corrosion.ShouldUpdate -->

##### <a name="Corrosion.Tick">Corrosion.Tick</a>
Proccess and update and deal damage

**Function Signature**<br>
`void Corrosion::Tick()`

--- 
<!-- End of Corrosion.Tick -->

--- 
<!-- End of Corrosion Methods -->

#### Corrosion Members

##### <a name="Corrosion.m_hOuter">Corrosion.m_hOuter</a>
the Victim of this corrosion

**Signature**<br>
`CTFPlayer|null Corrosion.m_hOuter`

--- 
<!-- End of Corrosion.m_hOuter -->

##### <a name="Corrosion.bActive">Corrosion.bActive</a>
the state of corrosion

**Signature**<br>
`bool Corrosion.bActive`

--- 
<!-- End of Corrosion.bActive -->

##### <a name="Corrosion.hAttacker">Corrosion.hAttacker</a>
the Attacker to report damage to

**Signature**<br>
`CTFPlayer|null Corrosion.hAttacker`

--- 
<!-- End of Corrosion.hAttacker -->

##### <a name="Corrosion.hWeapon">Corrosion.hWeapon</a>
the weapon that deals the dmg

**Signature**<br>
`CTFWeaponBase|null Corrosion.hWeapon`

--- 
<!-- End of Corrosion.hWeapon -->

##### <a name="Corrosion.flNextTick">Corrosion.flNextTick</a>
when the next tick is

**Signature**<br>
`float Corrosion.flNextTick`

--- 
<!-- End of Corrosion.flNextTick -->

##### <a name="Corrosion.flTickDur">Corrosion.flTickDur</a>
how long each tick is

**Signature**<br>
`float Corrosion.flTickDur`

--- 
<!-- End of Corrosion.flTickDur -->

##### <a name="Corrosion.flDmgPerc">Corrosion.flDmgPerc</a>
what percent of victims max hp to deal per tick

**Signature**<br>
`float Corrosion.flDmgPerc`

--- 
<!-- End of Corrosion.flDmgPerc -->

##### <a name="Corrosion.iDmgAdd">Corrosion.iDmgAdd</a>
base dmg per tick

**Signature**<br>
`int Corrosion.iDmgAdd`

--- 
<!-- End of Corrosion.iDmgAdd -->

##### <a name="Corrosion.bMakesPuddle">Corrosion.bMakesPuddle</a>
if we make a puddle on death

**Signature**<br>
`float Corrosion.bMakesPuddle`

--- 
<!-- End of Corrosion.bMakesPuddle -->

--- 
<!-- End of Corrosion Class -->

### color32
Simple implementation of Source engine class version<br>values are limited between 0 - 255

**Constructor Signature**<br>
`void color32::constructor( int r, int g, int b, int alpha = 0 )`

#### color32 Members

##### <a name="color32.r">color32.r</a>
red value

**Signature**<br>
`int color32.r`

--- 
<!-- End of color32.r -->

##### <a name="color32.g">color32.g</a>
green value

**Signature**<br>
`int color32.g`

--- 
<!-- End of color32.g -->

##### <a name="color32.b">color32.b</a>
blue value

**Signature**<br>
`int color32.b`

--- 
<!-- End of color32.b -->

##### <a name="color32.a">color32.a</a>
aplha value

**Signature**<br>
`int color32.a`

--- 
<!-- End of color32.a -->

--- 
<!-- End of color32 Class -->

--- 
<!-- End of Custom Classes -->

## Custom Script Events

--- 
<!-- End of Custom Script Events -->

## Custom Attributes

--- 
<!-- End of Custom Attributes -->

## Global Constants

--- 
<!-- End of Global Constants -->

## Chat Commands

### Lib_version
**Command**<br>
`lib_version`

**Alias's**<br>
`lib_versions`

**Parameters**<br>
0

**Descriptions**<br>
Print the library version and every loaded chaos script's version

--- 
<!-- End of Lib_version command -->

### lib_info
**Command**<br>
`lib_info`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
Print the library version

--- 
<!-- End of lib_info command -->

### Test
**Command**<br>
`Test`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
simply a test command<br>says hi :)

--- 
<!-- End of Test command -->


### Admin Commands
Commands that Admins or mission makers can use

#### lib_force
**Command**<br>
`lib_force`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
Inverts the force load flag

--- 
<!-- End of lib_force command -->

#### noclip
**Command**<br>
`noclip`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
toggles noclip

--- 
<!-- End of noclip command -->

#### disable_errors
**Command**<br>
`disable_errors`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
make errors no longer print to public chat

--- 
<!-- End of disable_errors command -->

#### enable_errors
**Command**<br>
`enable_errors`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
make errors print to public chat

--- 
<!-- End of lib_reload command -->

#### lib_reload
**Command**<br>
`lib_reload`

**Alias's**<br>
`reload_library`

**Parameters**<br>
0

**Descriptions**<br>
forcibly reload the library

--- 
<!-- End of lib_reload command -->

#### vcvar
**Command**<br>
`vcvar`

**Alias's**<br>
None

**Parameters**<br>
Cvar_name, [Value]

**Descriptions**<br>
Query or set a Cvar

--- 
<!-- End of lib_reload command -->

#### purge
**Command**<br>
`purge`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
Test the string purge fix<br>INTERNAL TESTING ONLY

--- 
<!-- End of lib_reload command -->

#### test_tank
**Command**<br>
`test_tank`

**Alias's**<br>
None

**Parameters**<br>
[tank_name], [height]

**Descriptions**<br>
Spawn a tank, at aimed position

--- 
<!-- End of test_tank command -->

#### kill_tank
**Command**<br>
`kill_tank`

**Alias's**<br>
None

**Parameters**<br>
[tank_name | *]

**Descriptions**<br>
If no parameters, kill aimed tank
If specified tank_name, kills tank with that targetname<br>
If *, kill all tanks

--- 
<!-- End of kill_tank command -->

#### setspell
**Command**<br>
`setspell`

**Alias's**<br>
None

**Parameters**<br>
[spell_index], [charges]

**Descriptions**<br>
Sets your spell

--- 
<!-- End of setspell command -->

#### uber
**Command**<br>
`uber`

**Alias's**<br>
None

**Parameters**<br>
[amount]

**Descriptions**<br>
Sets your uber percent to inputed value or 100%

--- 
<!-- End of uber command -->

#### bot
**Command**<br>
`bot`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
Spawn a bot that you can beat to your hearts intent

--- 
<!-- End of bot command -->

#### respawn
**Command**<br>
`respawn`

**Alias's**<br>
None

**Parameters**<br>
0

**Descriptions**<br>
Respawns you instantly

--- 
<!-- End of respawn command -->

--- 
<!-- End of Admin Commands -->

--- 
<!-- End of Chat Commands -->