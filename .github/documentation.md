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


### <a name="CTFPlayer.PrintToHud">CTFPlayer.PrintToHud</a>
Prints a Message to the players Hud

**Function Signature**<br>
`void CTFPlayer::PrintToHud(string message = "")`

**Example Usage**
```js
player.PrintToHud("Your Shield is on Cooldown!")
```

---

### <a name="CTFPlayer.PrintToChat">CTFPlayer.PrintToChat</a>
Prints a Message to the players Chat

**Function Signature**<br>
`void CTFPlayer::PrintToChat(string message = "")`

**Example Usage**
```js
player.PrintToChat("Your Shield is on Cooldown!")
```

---

### <a name="CTFPlayer.PrintToConsole">CTFPlayer.PrintToConsole</a>
Prints a Message to the players Console

**Function Signature**<br>
`void CTFPlayer::PrintToConsole(string message = "")`

**Example Usage**
```js
player.PrintToConsole("Debug: 15% charged")
```

---

### <a name="CTFPlayer.PrintToHudF">CTFPlayer.PrintToHudF</a>
Prints a Message to the players Hud with 

**Function Signature**<br>
`void CTFPlayer::PrintToHudF(string format, any ...)`

**Example Usage**
```js
player.PrintToHudF("Your %s is on Cooldown!", "Medication")
```

### <a name="CTFPlayer.PrintToChatF">CTFPlayer.PrintToChatF</a>
Prints a Message to the players Chat with formating

**Function Signature**<br>
`void CTFPlayer::PrintToChatF(string format, any ...)`

**Example Usage**
```js
player.PrintToChatF("Your %s is on Cooldown!", "Medication")
```

### <a name="CTFPlayer.PrintToConsoleF">CTFPlayer.PrintToConsoleF</a>
Prints a Message to the players Console with formating

**Function Signature**<br>
`void CTFPlayer::PrintToConsoleF(string format, any ...)`

**Example Usage**
```js
player.PrintToConsoleF("Debug: Wave is %f%% done", 37.21)
```

### <a name="CTFPlayer.IsOnGround">CTFPlayer.IsOnGround</a>
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

### <a name="CTFPlayer.GetUserName">CTFPlayer.GetUserName</a>
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