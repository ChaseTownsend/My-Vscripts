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
- [`PrintToHud`](#CTFPlayer.PrintToHud)
- [`PrintToChat`](#CTFPlayer.PrintToChat)
- [`PrintToConsole`](#CTFPlayer.PrintToConsole)
- [`PrintToHudF`](#CTFPlayer.PrintToHudF)
- [`PrintToChatF`](#CTFPlayer.PrintToChatF)
- [`PrintToConsoleF`](#CTFPlayer.PrintToConsoleF)
- [`IsOnGround`](#CTFPlayer.IsOnGround)
- [`GetUserName`](#CTFPlayer.GetUserName)
- [`GetSteamID`](#CTFPlayer.GetSteamID)
- [`GetUserID`](#CTFPlayer.GetUserID)
- [`GetHealers`](#CTFPlayer.GetHealers)
- [``](#CTFPlayer.)


### CTFPlayer.PrintToHud
Prints a Message to the players Hud

**Function Signature**
`void CTFPlayer::PrintToHud(string message = "")`

**Example Usage**
```js
player.PrintToHud("Your Shield is on Cooldown!")
```

---

### CTFPlayer.PrintToChat
Prints a Message to the players Chat

**Function Signature**
`void CTFPlayer::PrintToChat(string message = "")`

**Example Usage**
```js
player.PrintToChat("Your Shield is on Cooldown!")
```

---

### CTFPlayer.PrintToConsole
Prints a Message to the players Console

**Function Signature**
`void CTFPlayer::PrintToConsole(string message = "")`

**Example Usage**
```js
player.PrintToConsole("Debug: 15% charged")
```

---

### CTFPlayer.PrintToHudF
Prints a Message to the players Hud with 

**Function Signature**
`void CTFPlayer::PrintToHudF(string format, any ...)`

**Example Usage**
```js
player.PrintToHudF("Your %s is on Cooldown!", "Medication")
```

### CTFPlayer.PrintToChatF
Prints a Message to the players Chat with formating

**Function Signature**
`void CTFPlayer::PrintToChatF(string format, any ...)`

**Example Usage**
```js
player.PrintToChatF("Your %s is on Cooldown!", "Medication")
```

### CTFPlayer.PrintToConsoleF
Prints a Message to the players Console with formating

**Function Signature**
`void CTFPlayer::PrintToConsoleF(string format, any ...)`

**Example Usage**
```js
player.PrintToConsoleF("Debug: Wave is %f%% done", 37.21)
```

### CTFPlayer.IsOnGround
Returns if the player is on the ground.

**Function Signature**
`bool CTFPlayer::IsOnGround()`

**Example Usage**
```js
// Example Usage
if(player.IsOnGround())
{
  // ...
}
```

### CTFPlayer.GetUserName
Returns the players Username

**Function Signature**
`string CTFPlayer::GetUserName()`

**Example Usage**
```js
if(player.GetUserName() == "BigBob")
{
  // ...
}
```