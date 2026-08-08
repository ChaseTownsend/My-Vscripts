export {}
declare global {
	type table = { [key: string]: any } | null;
	function getroottable(): table;
	/**
	 * Sets a function in the entity's script to rerun by itself constantly.
	 * Pass `null` as the function name to remove a think function.
	 * The default think interval is 0.1s, unless overridden by returning a different time interval in seconds.
	 * TF2 runs at 66 ticks per second, so the lowest possible interval is 0.015 seconds.
	 * Return `-1` to think every tick.
	 * The highest interval where all clients will interpolate entities is 0.05 (20 times per second).
	 * @param {CBaseEntity} entity
	 * @param {string|null} function_name
	 */
	function AddThinkToEnt(entity: CBaseEntity, function_name: string|null): void

	/**
	 * Test value and if not `true`, throws exception, optionally with message.
	 * @param {boolean} value
	 * @throws {string|null}
	 * @param {string|null} optional_message Defaults to `null`
	 */
	function Assert(value: boolean, optional_message: string|null): void

	/**
	 * Empties the tables of game event callback functions.
	 * @deprecated Do NOT use this! It removes all events including those from other scripts.
	 */
	function ClearGameEventCallbacks(): void

	/**
	 * Create a prop.
	 * @param {classname} classname
	 * @param {Vector} origin
	 * @param {string} model_name
	 * @param {number} activity
	 * @returns {CBaseAnimating|null}
	 */
	function CreateProp(classname: string, origin: Vector, model_name: string, activity: number): CBaseAnimating|null

	/**
	 * Create a scene entity to play the specified scene. Can only be created during map initialization.
	 * @param {string} scene
	 * @returns {CBaseAnimating|null}
	 */
	function CreateSceneEntity(scene: string): CBaseAnimating|null

	/**
	 * The current level of the developer console variable.
	 * @returns {number}
	 */
	function developer(): number

	/**
	 * Dispatches a one-off particle system.
	 *
	 * **Warning**: Does NOT work if called from a player think or `OnTakeDamage` caused by hitscan/melee.
	 * @param {string} name
	 * @param {Vector} origin
	 * @param {Vector} direction
	 */
	function DispatchParticleEffect(name: string, origin: Vector, direction: Vector): void

	/**
	 * @param {any} symbol_or_table
	 * @param {any} item_if_symbol Defaults to `null`
	 * @param {string|null} description_if_symbol Defaults to `null`
	 */
	// function Document(symbol_or_table, item_if_symbol = null, description_if_symbol = null): void

	/**
	 * Generate an entity I/O event.
	 * @param {string} target
	 * @param {string} action
	 * @param {string|null} value
	 * @param {number} delay
	 * @param {CBaseEntity|null} activator
	 * @param {CBaseEntity|null} caller
	 */
	function DoEntFire(target: string, action: string, value: string, delay: number, activator: CBaseEntity|null, caller: CBaseEntity|null): void

	/**
	 * Used internally by IncludeScript
	 * @param {string} file
	 * @param {table|class|instance|null} scope
	 * @returns {boolean}
	 * @hide
	 */
	function DoIncludeScript(file: string, scope: table): boolean

	/**
	 * Execute a script and put all its content for the argument passed to the scope parameter.
	 * The file must have the `.nut` extension.
	 * @param {string} file
	 * @param {table|class|instance|null} scope Defaults to `null`
	 * @returns {boolean}
	 */
	function IncludeScript(file: string, scope: table): boolean 

	/**
	 * Play named sound on an entity using configurations similar to ambient_generic.
	 * @param {string} sound_name
	 * @param {number} volume
	 * @param {number} soundlevel
	 * @param {number} pitch
	 * @param {CBaseEntity} entity
	 */
	function EmitAmbientSoundOn(sound_name: string, volume: number, soundlevel: number, pitch: number, entity: CBaseEntity): void

	/**
	 * Stop named sound on an entity using configurations similar to ambient_generic.
	 * @param {string} sound_name
	 * @param {CBaseEntity} entity
	 */
	function StopAmbientSoundOn(sound_name: string, entity: CBaseEntity): void

	/**
	 * Play a sound with extended parameters.
	 *
	 * See the [EmitSoundEx](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/EmitSoundEx) for more details.
	 * @param {table} params
	 * ## Keys:
	 * ```sqDoc
	 * sound_name: string
	 * channel?: integer
	 * volume?: float
	 * sound_level?: integer
	 * flags?: integer
	 * pitch?: integer
	 * special_dsp?: integer
	 * origin?: Vector
	 * delay?: float,
	 * sound_time?: float
	 * entity?: CBaseEntity|null
	 * speaker_entity?: CBaseEntity|null
	 * filter_type?: integer
	 * filter_param?: integer
	 * ```
	 */
	function EmitSoundEx(params: table): void

	/**
	 * Play named sound on given entity. The sound must be precached first.
	 *
	 * **Warning**: Looping sounds will not stop on the entity when it's destroyed.
	 * @param {string} sound_script
	 * @param {CBaseEntity} entity
	 */
	function EmitSoundOn(sound_script: string, entity: CBaseEntity): void

	/**
	 * Stop named sound on an entity.
	 * @param {string} sound_script
	 * @param {CBaseEntity} entity
	 */
	function StopSoundOn(sound_script: string, entity: CBaseEntity): void

	/**
	 * Play named sound only on the client for the specified player.
	 *
	 * **Note**: Only supports soundscripts.
	 * @param {string} sound_script
	 * @param {CBaseEntity} player
	 */
	function EmitSoundOnClient(sound_script: string, player: CBaseEntity): void

	/**
	 * Wrapper for `DoEntFire()` that sets activator to `null`. Negative delays are clamped to `0`.
	 * @param {string} target
	 * @param {string} action
	 * @param {string|null} value Defaults to `null`
	 * @param {number} delay Defaults to `0.0`
	 * @param {CBaseEntity|null} activator Defaults to `null`
	 */
	function EntFire(target: string, action: string, value: string|null, delay: number, activator: CBaseEntity|null): void

	/**
	 * Generate an entity I/O event by handle. Negative delays are clamped to `0`.
	 *
	 * **Note**: With `0` delay, processed at end of frame. Use `AcceptInput` for instant/synchronous I/O.
	 * @param {CBaseEntity} entity
	 * @param {string} action
	 * @param {string|null} value
	 * @param {number} delay
	 * @param {CBaseEntity|null} activator
	 * @param {CBaseEntity|null} caller
	 */
	function EntFireByHandle(entity: CBaseEntity, aaction: string, value: string|null, delay: number, activator: CBaseEntity|null, caller: CBaseEntity|null): void


	/**
	 * Turn an entity index integer to an HScript representing that entity's script instance.
	 * @param {number} entindex
	 * @returns {CBaseEntity|null}
	 */
	function EntIndexToHScript(entindex: number): CBaseEntity|null

	/**
	 * Reads a string from file located in the game's scriptdata folder.
	 * Returns the string from the file, `null` if no file or file is greater than 16384 bytes.
	 * @param {string} file
	 * @returns {string|null}
	 */
	function FileToString(file: string): string|null

	/**
	 * Fire a game event to a listening callback function in script.
	 *
	 * **Note**: Does not fire an event that the game will pick up. Use `SendGlobalGameEvent` for real events.
	 * @param {string} name
	 * @param {table} params
	 * @returns {boolean}
	 */
	function FireGameEvent(name: string, params: table): boolean

	/**
	 * Fire a script hook to a listening callback function in script.
	 * @param {string} name
	 * @param {table} params
	 * @returns {boolean}
	 */
	function FireScriptHook(name: string, params:table): boolean

	/**
	 * Get the time spent on the server in the last frame. Usually `0.015` (default tickrate).
	 * @returns {number}
	 */
	function FrameTime(): number

	/**
	 * Gets the level of 'developer'.
	 * @returns {number}
	 */
	function GetDeveloperLevel(): number

	/**
	 * Returns the engines current frame count.
	 * @returns {number}
	 */
	function GetFrameCount(): number

	/**
	 * Returns a string that describes the passed in function's signature.
	 * @param {Function} func
	 * @param {string} prefix
	 * @returns {string|null}
	 */
	function GetFunctionSignature(func: Function, prefix: string): string|null

	/**
	 * Get the local player on a listen server.
	 * @returns {CTFPlayer|null} `null` on dedicated servers.
	 */
	function GetListenServerHost(): CTFPlayer|null

	/**
	 * Get the name of the map without extension.
	 * @returns {string}
	 */
	function GetMapName(): string

	/**
	 * Returns the index of the named model.
	 * @param {string} model_name
	 * @returns {number} `-1` if not loaded.
	 */
	function GetModelIndex(model_name: string): number

	/**
	 * Returns the angular velocity of the entity
	 * @param {CBaseEntity} entity
	 * @returns {Vector}
	 * @deprecated Use the `GetPhysAngularVelocity` method on the entity instead.
	 */
	function GetPhysAngularVelocity(entity: CBaseEntity): Vector

	/**
	 * Returns the velocity of the entity
	 * @param {CBaseEntity} entity
	 * @returns {Vector}
	 * @deprecated Use the `GetPhysVelocity` method on the entity instead.
	 */
	function GetPhysVelocity(entity: CBaseEntity): Vector

	/**
	 * Given a user id, return the entity, or `null`.
	 * @param {number} userid
	 * @returns {CTFPlayer|null}
	 */
	function GetPlayerFromUserID(userid: number): CTFPlayer|null

	/**
	 * Returns float duration of the sound.
	 *
	 * **Warning**: Does not work on dedicated servers.
	 * @param {string} sound_name
	 * @param {string|null} actor_model_name
	 * @returns {number}
	 */
	function GetSoundDuration(sound_name: string, actor_model_name: string|null): number

	/**
	 * Returns `true` if this server is a dedicated server.
	 * @returns {boolean}
	 */
	function IsDedicatedServer(): boolean

	/**
	 * Checks if the `model_name` is precached.
	 * @param {string} model_name
	 * @returns {boolean}
	 */
	function IsModelPrecached(model_name: string): boolean

	/**
	 * Checks if the `sound_name` is precached.
	 * @param {string} sound_name
	 * @returns {boolean}
	 */
	function IsSoundPrecached(sound_name: string): boolean

	/**
	 * Is this player/entity a puppet or AI bot.
	 * @param {CTFPlayer} player
	 * @returns {boolean}
	 */
	function IsPlayerABot(player: CTFPlayer): boolean

	/**
	 * Fills out a table with the local time.
	 *
	 * **Warning**: The month will be 1-12 rather than 0-11.
	 * @param {table} result
	 */
	function LocalTime(result: table): void

	/**
	 * Get the current number of max clients set by the maxplayers command.
	 * @returns {number}
	 */
	function MaxClients(): number

	/**
	 * Get a script handle of a player using the player index.
	 * @param {number} index
	 * @returns {CTFPlayer|null}
	 */
	function PlayerInstanceFromIndex(indexnumber: number): CTFPlayer|null

	/**
	 * Precache an entity from KeyValues in a table.
	 * @param {table} keyvalues
	 * @returns {boolean}
	 */
	function PrecacheEntityFromTable(keyvalues: table): boolean

	/**
	 * Precache a studio model or sprite model and return model index.
	 * @param {string} model_name
	 * @returns {number}
	 */
	function PrecacheModel(model_name: string): number

	/**
	 * Precache a soundscript or raw WAV/MP3 sound.
	 * @param {string} sound_name
	 * @returns {boolean}
	 */
	function PrecacheScriptSound(sound_name: string): boolean

	/**
	 * Precache a raw WAV/MP3 sound.
	 * @param {string} sound_name
	 * @returns {boolean}
	 */
	function PrecacheSound(sound_name: string): boolean

	/**
	 * Generate a random floating-point number within a range, inclusive.
	 * @param {number} min
	 * @param {number} max
	 * @returns {number}
	 */
	function RandomFloat(min: number, max: number): number

	/**
	 * Generate a random integer within a range, inclusive.
	 * @param {number} min
	 * @param {number} max
	 * @returns {number}
	 */
	function RandomInt(min: number, max: number): number

	/**
	 * Register as a listener for a game event from script.
	 * @param {string} event_name
	 */
	function RegisterScriptGameEventListener(event_name: string): void

	/**
	 * Register as a listener for a script hook from script.
	 * @param {string} name
	 */
	function RegisterScriptHookListener(name: string): void

	/**
	 * Rotate a QAngle by another QAngle.
	 * @param {QAngle} initial
	 * @param {QAngle} rotation
	 * @returns {QAngle}
	 */
	function RotateOrientation(initial: QAngle, rotation: QAngle): QAngle

	/**
	 * Rotate the input Vector around an origin.
	 * @param {Vector} origin
	 * @param {QAngle} rotation
	 * @param {Vector} input
	 * @returns {Vector}
	 */
	function RotatePosition(origin: Vector, rotation: QAngle, input: Vector): Vector

	/**
	 * Start a customisable screenfade. If no player is specified, applies to all players.
	 * @param {CTFPlayer} player
	 * @param {number} red
	 * @param {number} green
	 * @param {number} blue
	 * @param {number} alpha
	 * @param {number} fade_time
	 * @param {number} fade_hold
	 * @param {number} flags See [Constants.FFADE](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FFADE)
	 */
	function ScreenFade(player: CTFPlayer, red: number, green: number, blue: number, alpha: number, fade_time: number, fade_hold: number, flags: number): void

	/**
	 * Start a customisable screenshake.
	 * @param {Vector} center
	 * @param {number} amplitude
	 * @param {number} frequency
	 * @param {number} duration
	 * @param {number} radius
	 * @param {number} command See [Constants.SHAKE_COMMAND](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#SHAKE_COMMAND)
	 *                          (`0`=start, `1`=stop)
	 * @param {boolean} air_shake
	 */
	function ScreenShake(center: Vector, amplitude: number, frequency: number, duration: number, radius: number, command: number, air_shake: boolean): void

	/**
	 * Returns whether script hooks are currently enabled.
	 * @returns {boolean}
	 */
	function ScriptHooksEnabled(): boolean

	/**
	 * Sends a real game event to everything.
	 * @param {string} event_name
	 * @param {table} params
	 * @returns {boolean}
	 */
	function SendGlobalGameEvent(event_name: string, params: table): boolean

	/**
	 * Issues a command to the local client. Does nothing on dedicated servers.
	 * @param {string} command
	 */
	function SendToConsole(command: string): void

	/**
	 * Issues a command to the server, as if typed in the console.
	 * @param {string} command
	 */
	function SendToServerConsole(command: string): void

	/**
	 * Copy of SendToServerConsole with another name for compatibility.
	 * @param {string} command
	 */
	function SendToConsoleServer(command: string): void 

	/**
	 * Sets a `USERINFO` client ConVar for a fakeclient.
	 * @param {CTFBot} bot
	 * @param {client_convar} cvar
	 * @param {string} value
	 */
	function SetFakeClientConVarValue(bot: CTFBot, cvar: string, value: string): void

	/**
	 * Sets the current skybox texture. The path is relative to `"materials/skybox/"`.
	 * @param {string} texture
	 */
	function SetSkyboxTexture(texture: string): void

	/**
	 * Spawn entity from KeyValues in table.
	 * @param {classname} name
	 * @param {table} keyvalues
	 * @returns {CBaseEntity|null}
	 */
	function SpawnEntityFromTable(name: string, keyvalues: table): CBaseEntity|null

	/**
	 * Hierarchically spawn an entity group from a set of spawn tables.
	 * @param {table} groups
	 * @returns {boolean}
	 */
	function SpawnEntityGroupFromTable(groups: table): boolean

	/**
	 * Stores a string as a file, located in the game's scriptdata folder.
	 *
	 * **Warning**: Performance varies by hardware:  only call at checkpoints.
	 * @param {string} file
	 * @param {string} content
	 */
	function StringToFile(file: string, content: string): void

	/**
	 * Get the current time since map load in seconds.
	 * @returns {number}
	 */
	function Time(): number

	/**
	 * Trace a ray. Return fraction along line that hits world or models.
	 * @param {Vector} start
	 * @param {Vector} end
	 * @param {CBaseEntity|null} ignore
	 * @returns {number}
	 */
	function TraceLine(start: Vector, end: Vector, ignore: CBaseEntity|null): number

	/**
	 * Different version of `TraceLine` that also hits players and NPCs.
	 * @param {Vector} start
	 * @param {Vector} end
	 * @param {CBaseEntity|null} ignore
	 * @returns {number}
	 */
	function TraceLinePlayersIncluded(start: Vector, end: Vector, ignore: CBaseEntity|null): number

	/**
	 * Extended version of `TraceLine`. The passed in table requires to have parameters and will be modified to contain new ones.
	 *
	 * See [TraceLineEx](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/TraceLineEx) for more details
	 *
	 * **Warning**: Setting any input parameters which expect an instance to a primitive type will crash the server.
	 * # Input table
	 * ```sqDoc
	 * start: Vector
	 * end: Vector
	 * mask: integer
	 * ignore: CBaseEntity
	 * ```
	 * # Output table
	 * ```sqDoc
	 * pos: Vector
	 * fraction: float
	 * hit: bool
	 * enthit?: CBaseEntity
	 * startsolid?: bool
	 * allsolid?: bool
	 * startpos: Vector
	 * endpos: Vector
	 * plane_normal?: Vector
	 * plane_dist?: float
	 * surface_name?: string
	 * surface_flags?: integer
	 * surface_props?: integer
	 * ```
	 * @param {table} params
	 * @returns {boolean} `false` if the user didn't specify a valid `start` or `end`, `true` otherwise.
	 *                 You don't need to check this return usually.
	 */
	function TraceLineEx(params: table): boolean

	/**
	 * Trace a box (AABB). The passed in table requires to have parameters and will be modified to contain new ones.
	 *
	 * See [TraceHull](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/TraceHull) for more details
	 *
	 * **Warning**: Setting any input parameters which expect an instance to a primitive type will crash the server.
	 * # Input table
	 * ```sqDoc
	 * start: Vector
	 * end: Vector
	 * hullmin: Vector
	 * hullmax: Vector
	 * mask: integer
	 * ignore: CBaseEntity
	 * ```
	 * # Output table
	 * ```sqDoc
	 * pos: Vector
	 * fraction: float
	 * hit: bool
	 * enthit?: CBaseEntity
	 * startsolid?: bool
	 * allsolid?: bool
	 * startpos: Vector
	 * endpos: Vector
	 * plane_normal?: Vector
	 * plane_dist?: float
	 * surface_name?: string
	 * surface_flags?: integer
	 * surface_props?: integer
	 * ```
	 * @param {table} params
	 * @returns {boolean} `false` if the user didn't specify a valid `start`, `end`, `hullmin` or `hullmax`, `true` otherwise.
	 *                 You don't need to check this return usually.
	 */
	function TraceHull(params: table): boolean

	/**
	 * Generate a string guaranteed to be unique across the life of the script VM.
	 * @param {string} suffix Defaults to `""`
	 * @returns {string}
	 */
	function UniqueString(suffix: string): string

	/**
	 * Internal function called by `UniqueString`
	 * @param {string|null} suffix
	 * @returns {string}
	 * @hide
	 */
	function DoUniqueString(suffix: string|null): string

	/**
	 * Wrapper that registers callbacks for `OnGameEvent_x` and `OnScriptEvent_` functions.
	 * @param {table} scope
	 */
	function __CollectGameEventCallbacks(scope: table): void

	// ============================================================
	// GLOBAL FUNCTIONS - Team Fortress 2
	// ============================================================

	/**
	 * @returns {boolean}
	 */
	function AllowThirdPersonCamera(): boolean

	/**
	 * @returns {boolean}
	 */
	function ArePlayersInHell(): boolean

	/**
	 * May a flag be captured?
	 * @returns {boolean}
	 */
	function FlagsMayBeCapped(): boolean

	/**
	 * Whether to force on MvM-styled upgrades on/off.
	 * @param {number} state `0`=default, `1`=force off, `2`=force on
	 */
	function ForceEnableUpgrades(state: number): number

	/**
	 * Forces payload pushing logic.
	 * @param {number} state `0`=default, `1`=force off, `2`=force on.
	 */
	function ForceEscortPushLogic(state: number): number

	/**
	 * Does the current gamemode have currency?
	 * @returns {boolean}
	 */
	function GameModeUsesCurrency(): boolean

	/**
	 * Does the current gamemode have minibosses?
	 * @returns {boolean}
	 */
	function GameModeUsesMiniBosses(): boolean

	/**
	 * Does the current gamemode have upgrades?
	 * @returns {boolean}
	 */
	function GameModeUsesUpgrades(): boolean

	/**
	 * Get class limit for class.
	 * @param {number} class_number See [Constants.ETFClass](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFClass)
	 * @returns {number}
	 */
	function GetClassLimit(class_number: number): number

	/**
	 * @returns {number}
	 */
	function GetGravityMultiplier(): number

	/**
	 * @returns {boolean}
	 */
	function GetMannVsMachineAlarmStatus(): boolean

	/**
	 * @returns {boolean}
	 */
	function GetOvertimeAllowedForCTF(): boolean

	/**
	 * Get current round state.
	 * @returns {number} See [Constants.ERoundState](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ERoundState)
	 */
	function GetRoundState(): number

	/**
	 * Get the current stopwatch state.
	 * @returns {number} See [Constants.EStopwatchState](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#EStopwatchState)
	 */
	function GetStopWatchState(): number

	/**
	 * Who won!
	 * @returns {number}
	 */
	function GetWinningTeam(): number

	/**
	 * @returns {boolean}
	 */
	function HaveStopWatchWinner(): boolean

	/**
	 * Are we in the pre-match/setup state?
	 * @returns {boolean}
	 */
	function InMatchStartCountdown(): boolean

	/**
	 * Currently in overtime?
	 * @returns {boolean}
	 */
	function InOvertime(): boolean

	/**
	 * @returns {boolean}
	 */
	function IsAttackDefenseMode(): boolean

	/**
	 * Are we in birthday mode?
	 * @returns {boolean}
	 */
	function IsBirthday(): boolean

	/**
	 * Playing competitive?
	 * @returns {boolean}
	 */
	function IsCompetitiveMode(): boolean

	/**
	 * The absence of arena, mvm, tournament mode, etc.
	 * @returns {boolean}
	 */
	function IsDefaultGameMode(): boolean

	/**
	 * Is the given holiday active?
	 * @param {number} holiday See [Constants.EHoliday](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#EHoliday)
	 * @returns {boolean}
	 */
	function IsHolidayActive(holiday: number): boolean

	/**
	 * Playing a holiday map?
	 * @param {number} holiday See [Constants.EHoliday](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#EHoliday)
	 * @returns {boolean}
	 */
	function IsHolidayMap(holiday: number): boolean

	/**
	 * Playing arena mode?
	 * @returns {boolean}
	 */
	function IsInArenaMode(): boolean

	/**
	 * Playing king of the hill mode?
	 * @returns {boolean}
	 */
	function IsInKothMode(): boolean

	/**
	 * Playing medieval mode?
	 * @returns {boolean}
	 */
	function IsInMedievalMode(): boolean

	/**
	 * Are we waiting for some stragglers?
	 * @returns {boolean}
	 */
	function IsInWaitingForPlayers(): boolean

	/**
	 * Playing MvM?
	 * @returns {boolean}
	 */
	function IsMannVsMachineMode(): boolean

	/**
	 * Are players allowed to refund their upgrades?
	 * @returns {boolean}
	 */
	function IsMannVsMachineRespecEnabled(): boolean

	/**
	 * Playing casual?
	 * @returns {boolean}
	 */
	function IsMatchTypeCasual(): boolean

	/**
	 * Playing competitive?
	 * @returns {boolean}
	 */
	function IsMatchTypeCompetitive(): boolean

	/**
	 * No ball games.
	 * @returns {boolean}
	 */
	function IsPasstimeMode(): boolean

	/**
	 * Playing powerup mode?
	 * @returns {boolean}
	 */
	function IsPowerupMode(): boolean

	/**
	 * @returns {boolean}
	 */
	function IsPVEModeActive(): boolean

	/**
	 * If an engineer places a building, will it immediately upgrade?
	 * @returns {boolean}
	 */
	function IsQuickBuildTime(): boolean

	/**
	 * @returns {boolean}
	 */
	function IsTruceActive(): boolean

	/**
	 * @returns {boolean}
	 */
	function IsUsingGrapplingHook(): boolean

	/**
	 * @returns {boolean}
	 */
	function IsUsingSpells(): boolean

	/**
	 * @returns {boolean}
	 */
	function MapHasMatchSummaryStage(): boolean

	/**
	 * @returns {boolean}
	 */
	function MatchmakingShouldUseStopwatchMode(): boolean

	/**
	 * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
	 * @returns {boolean}
	 */
	function PlayerReadyStatus_ArePlayersOnTeamReady(team: number): boolean

	/**
	 * @returns {boolean}
	 */
	function PlayerReadyStatus_HaveMinPlayersToEnable(): boolean

	/**
	 */
	function PlayerReadyStatus_ResetState(): void

	/**
	 * @returns {boolean}
	 */
	function PlayersAreOnMatchSummaryStage(): boolean

	/**
	 * Are points able to be captured?
	 * @returns {boolean}
	 */
	function PointsMayBeCaptured(): boolean

	/**
	 * @param {number} multiplier
	 */
	function SetGravityMultiplier(multiplier: number): void

	/**
	 * @param {boolean} status
	 */
	function SetMannVsMachineAlarmStatus(status: boolean): void

	/**
	 * @param {boolean} state
	 */
	function SetOvertimeAllowedForCTF(state: boolean): void

	/**
	 * @param {boolean} state
	 */
	function SetPlayersInHell(state: boolean): void

	/**
	 * @param {boolean} state
	 */
	function SetUsingSpells(state: boolean): void

	/**
	 * @returns {boolean}
	 */
	function UsePlayerReadyStatusMode(): boolean

	// ============================================================
	// GLOBAL FUNCTIONS - Printing and Drawing
	// ============================================================

	/**
	 * Print a client message. Pass `null` instead of a valid player to send to all clients.
	 * When printing to chat (`HUD_PRINTTALK`), use `\x07RRGGBB` for custom colors.
	 * @param {CTFPlayer|null} player
	 * @param {number} destination See [Constants.EHudNotify](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#EHudNotify)
	 * @param {string} message
	 */
	function ClientPrint(player: CTFPlayer, destination: number, message: string): void

	/**
	 * Draw a debug overlay box.
	 *
	 * **Warning**: Requires developer cvar to be enabled.
	 * @param {Vector} origin
	 * @param {Vector} min
	 * @param {Vector} max
	 * @param {number} r
	 * @param {number} g
	 * @param {number} b
	 * @param {number} alpha
	 * @param {number} duration
	 */
	function DebugDrawBox(origin: Vector, min: Vector, max: Vector, r: number, g: number, b: number, alpha: number, duration: number): void

	/**
	 * Draw a debug oriented box.
	 * @param {Vector} origin
	 * @param {Vector} min
	 * @param {Vector} max
	 * @param {QAngle} direction
	 * @param {Vector} rgb
	 * @param {number} alpha
	 * @param {number} duration
	 */
	function DebugDrawBoxAngles(origin: Vector, min: Vector, max: Vector, direction: QAngle, rgb: Vector, alpha: number, duration: number): void

	/**
	 * Draw a debug forward box.
	 * @param {Vector} center
	 * @param {Vector} min
	 * @param {Vector} max
	 * @param {Vector} forward
	 * @param {Vector} rgb
	 * @param {number} alpha
	 * @param {number} duration
	 */
	function DebugDrawBoxDirection(center: Vector, min: Vector, max: Vector, forward: Vector, rgb: Vector, alpha: number, duration: number): void

	/**
	 * Draw a debug circle.
	 * @param {Vector} center
	 * @param {Vector} rgb
	 * @param {number} alpha
	 * @param {number} radius
	 * @param {boolean} ztest
	 * @param {number} duration
	 */
	function DebugDrawCircle(center: Vector, rgb: Vector, alpha: number, radius: number, ztest: boolean, duration: number): void

	/**
	 * Try to clear all the debug overlay info.
	 */
	function DebugDrawClear(): void

	/**
	 * Draw a debug overlay line.
	 * @param {Vector} start
	 * @param {Vector} end
	 * @param {number} red
	 * @param {number} green
	 * @param {number} blue
	 * @param {boolean} z_test
	 * @param {number} time
	 */
	function DebugDrawLine(start: Vector, end: Vector, red: number, green: number, blue: number, z_test: boolean, time: number): void

	/**
	 * Draw a debug line using color vec.
	 * @param {Vector} start
	 * @param {Vector} end
	 * @param {Vector} rgb
	 * @param {boolean} ztest
	 * @param {number} duration
	 */
	function DebugDrawLine_vCol(start: Vector, end: Vector, rgb: Vector, ztest: boolean, duration: number): void

	/**
	 * Draw text with a line offset.
	 * @param {number} x
	 * @param {number} y
	 * @param {number} line_offset
	 * @param {string} text
	 * @param {number} r
	 * @param {number} g
	 * @param {number} b
	 * @param {number} a
	 * @param {number} duration
	 */
	function DebugDrawScreenTextLine(x: number, y: number, line_offset: number, text: string, r: number, g: number, b: number, a: number, duration: number): void

	/**
	 * Draw text on the screen, starting on the position of origin.
	 * @param {Vector} origin
	 * @param {string} text
	 * @param {boolean} use_view_check
	 * @param {number} duration
	 */
	function DebugDrawText(origin: Vector, text: string, use_view_check: boolean, duration: number): void

	/**
	 * Dumps a scope's contents and expands all tables and arrays.
	 * @param {number} indentation
	 * @param {table} scope
	 */
	function __DumpScope(indentation: number, scope: table): void

	/**
	 * Dumps information about a class or instance.
	 * @param {any} object
	 */
	function DumpObject(object: any): void

	/**
	 * Prints message to console without any line feed after.
	 * @param {any} message
	 */
	function Msg(message: any): void

	/**
	 * Prints message to console with C style formatting. Line feed not included.
	 * @param {string} format
	 * @varargs {any}
	 */
	function printf(format: string, []: any): void

	/**
	 * Prints message to console with a line feed after.
	 * @param {any} message
	 */
	function printl(message: any): void

	/**
	 * Identical to print.
	 * @param {any} message
	 */
	function realPrint(message: any): void

	/**
	 * Have the specified player send a message to chat.
	 * @param {CTFPlayer} player
	 * @param {string} message
	 * @param {boolean} team_only
	 */
	function Say(player: CTFPlayer, message: string, team_only: boolean): void

	/**
	 * Displays a HUD message defined in scripts/titles.txt to all clients.
	 * @param {string} message
	 */
	function ShowMessage(message: string): void
}