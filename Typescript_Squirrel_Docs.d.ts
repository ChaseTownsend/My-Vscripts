// import "./Ts_Squirrel_Globals.js"

export {}

type table = { [key: string]: any } | null

/**
 * Squirrel equivalent of the C++ Vector class.
 * A three-dimensional vector with overloaded arithmetic operations for both Vectors and scalar values.
 */
interface Vector {
	x: number
	y: number
	z: number
	/**
	 * Returns the sum of both classes' members.
	 * @param {Vector} other
	 * @returns {Vector}
	 */
	_add( other: Vector ): Vector

	/**
	 * Returns the subtraction of both classes' members.
	 * @param {Vector} other
	 * @returns {Vector}
	 */
	_sub( other: Vector ): Vector

	/**
	 * Returns the multiplication of a Vector against a scalar.
	 * @param {number} other
	 * @returns {Vector}
	 */
	 _mul( other: Vector ): Vector

	/**
	 * The vector product of two vectors. Returns a vector orthogonal to the input vectors.
	 * @param {Vector} factor
	 * @returns {Vector}
	 */
	Cross( factor: Vector ): Vector

	/**
	 * The scalar product of two vectors.
	 * @param {Vector} factor
	 * @returns {number}
	 */
	Dot( factor: Vector ): number

	/**
	 * Magnitude of the vector.
	 * @returns {number}
	 */
	Length(): number

	/**
	 * The magnitude of the vector squared.
	 * @returns {number}
	 */
	LengthSqr(): number

	/**
	 * Returns the magnitude of the vector on the x-y plane.
	 * @returns {number}
	 */
	Length2D(): number

	/**
	 * Returns the square of the magnitude of the vector on the x-y plane.
	 * @returns {number}
	 */
	Length2DSqr(): number

	/**
	 * Normalizes the vector in place and returns its length.
	 * @returns {Vector}
	 */
	Norm(): Vector

	/**
	 * Scales the vector magnitude.
	 * @param {number} factor
	 * @returns {Vector}
	 */
	Scale(factor: number): Vector
	/**
	 * Returns a string without separating commas.
	 * @returns {string}
	 */
	ToKVString(): string
	/**
	 * Returns a human-readable string.
	 * @returns {string}
	 */
	tostring(): string
}

/**
 * Squirrel equivalent of the C++ QAngle class.
 * Represents a three-dimensional orientation as Euler angles.
 */
interface QAngle {
	/** Warning! [x] is private and cannot be accessed */
	x: number
	/** Warning! [x] is private and cannot be accessed */
	y: number
	/** Warning! [x] is private and cannot be accessed */
	z: number
	/**
	 * Returns the sum of both classes' members.
	 * @param {QAngle|Vector} other
	 * @returns {QAngle}
	 */
	_add(other: QAngle): QAngle

	/**
	 * Returns the subtraction of both classes' members.
	 * @param {QAngle|Vector} other
	 * @returns {QAngle}
	 */
	_sub(other: QAngle): QAngle

	/**
	 * QAngle multiplied by a number.
	 * @param {number} other
	 * @returns {QAngle}
	 */
	_mul(other: number): QAngle

	/**
	 * @param {string|null} start
	 * @returns {number}
	 */
	_nexti(start: string|null): number

	/**
	 * Returns the Forward Vector of the angles.
	 * @returns {Vector}
	 */
	Forward(): Vector

	/**
	 * Returns the **right** Vector of the angles.
	 *
	 * **Note**: Despite being named "Left", this actually returns the right vector.
	 * @returns {Vector}
	 */
	Left(): Vector

	/**
	 * Returns the pitch angle in degrees.
	 * @returns {number}
	 */
	Pitch(): number

	/**
	 * Returns the roll angle in degrees.
	 * @returns {number}
	 */
	Roll(): number

	/**
	 * Returns a string with the values separated by one space.
	 * @returns {string}
	 */
	ToKVString(): string

	/**
	 * Returns a quaternion representation of the orientation.
	 * @returns {Quaternion}
	 */
	ToQuat(): Quaternion

	/**
	 * Returns the Up Vector of the angles.
	 * @returns {Vector}
	 */
	Up(): Vector

	/**
	 * Returns the yaw angle in degrees.
	 * @returns {number}
	 */
	Yaw(): number
}
interface Vector2D {
	x: number
	y: number
	/**
	 * Returns the sum of both classes' members.
	 * @param {Vector2D} other
	 * @returns {Vector2D}
	 */
	_add(other: Vector2D): Vector2D

	/**
	 * Returns the subtraction of both classes' members.
	 * @param {Vector2D} other
	 * @returns {Vector2D}
	 */
	_sub(other: Vector2D): Vector2D

	/**
	 * Returns the multiplication of a Vector against a scalar.
	 * @param {number} other
	 * @returns {Vector2D}
	 */
	_mul(other: number): Vector2D

	/**
	 * The scalar product of two vectors.
	 * @param {Vector2D} factor
	 * @returns {number}
	 */
	Dot(factor: Vector2D): number

	/**
	 * Magnitude of the vector.
	 * @returns {number}
	 */
	Length(): number

	/**
	 * The magnitude of the vector squared.
	 * @returns {number}
	 */
	LengthSqr(): number

	/**
	 * Normalizes the vector in place and returns its length.
	 * @returns {number}
	 */
	Norm(): number

	/**
	 * Returns a string without separating commas.
	 * @returns {string}
	 */
	ToKVString(): string
}
interface Vector4D {
	x: number

	y: number

	z: number

	w: number

	/**
	 * Returns the sum of both classes' members.
	 * @param {Vector4D} other
	 * @returns {Vector4D}
	 */
	_add(other: Vector4D): Vector4D

	/**
	 * Returns the subtraction of both classes' members.
	 * @param {Vector4D} other
	 * @returns {Vector4D}
	 */
	_sub(other: Vector4D): Vector4D

	/**
	 * Returns the multiplication of a Vector against a scalar.
	 * @param {number} other
	 * @returns {Vector4D}
	 */
	_mul(other: number): Vector4D

	/**
	 * The scalar product of two vectors.
	 * @param {Vector4D} factor
	 * @returns {number}
	 */
	Dot(factor: Vector4D): number

	/**
	 * Magnitude of the vector.
	 * @returns {number}
	 */
	Length(): number

	/**
	 * The magnitude of the vector squared.
	 * @returns {number}
	 */
	LengthSqr(): number

	/**
	 * Normalizes the vector in place and returns its length.
	 * @returns {number}
	 */
	Norm(): number

	/**
	 * Returns a string without separating commas.
	 * @returns {string}
	 */
	ToKVString(): string
}
/**
 * Quaternion represents rotations in three-dimensional space.
 */
interface Quaternion {
	/**
	 * Vector component along the i axis.
	 * @type {number}
	 */
	x: number

	/**
	 * Vector component along the j axis.
	 * @type {number}
	 */
	y: number

	/**
	 * Vector component along the k axis.
	 * @type {number}
	 */
	z: number

	/**
	 * Scalar part.
	 * @type {number}
	 */
	w: number
	/**
	 * @param {Quaternion} other
	 * @returns {Quaternion}
	 */
	_add(other: Quaternion): Quaternion

	/**
	 * @param {Quaternion} other
	 * @returns {Quaternion}
	 */
	_sub(other: Quaternion): Quaternion

	/**
	 * @param {number} other
	 * @returns {Quaternion}
	 */
	_mul(other: number): Quaternion

	/**
	 * The 4D scalar product of two quaternions.
	 * @param {Quaternion} factor
	 * @returns {number}
	 */
	Dot(factor: Quaternion): number

	/**
	 * Returns a quaternion with the complementary rotation.
	 * @returns {Quaternion}
	 */
	Invert(): Quaternion

	/**
	 * Normalizes the quaternion.
	 * @returns {number}
	 */
	Norm(): number

	/**
	 * Recomputes the quaternion from the supplied Euler angles.
	 * @param {number} pitch
	 * @param {number} yaw
	 * @param {number} roll
	 */
	SetPitchYawRoll(pitch: number, yaw: number, roll: number): void

	/**
	 * Returns a string with the values separated by one space.
	 * @returns {string}
	 */
	ToKVString(): string

	/**
	 * Returns the angles resulting from the rotation.
	 * @returns {QAngle}
	 */
	ToQAngle(): QAngle
}

interface CBaseEntity {
	/**
	 * @param {string} key
	 * @param {number} value
	 * @returns {boolean}
	 * @deprecated Behaves the same as `KeyValueFromFloat`, use that instead.
	 */
	__KeyValueFromFloat(key: string, value: number): boolean

	/**
	 * @param {string} key
	 * @param {number} value
	 * @returns {boolean}
	 * @deprecated Behaves the same as `KeyValueFromInt`, use that instead.
	 */
	__KeyValueFromInt(key: string, value: number): boolean
	
	/**
	 * @param {string} key
	 * @param {string} value
	 * @returns {boolean}
	 * @deprecated Behaves the same as `KeyValueFromString`, use that instead.
	 */
	__KeyValueFromString(key: string, value: string): boolean

	/**
	 * @param {string} key
	 * @param {Vector} value
	 * @returns {boolean}
	 * @deprecated Behaves the same as `KeyValueFromVector`, use that instead.
	 */
	__KeyValueFromVector(key: string, value: Vector): boolean

	 /**
	 * Generate a synchronous I/O event. Unlike `EntFireByHandle`, this is processed immediately.
	 * @param {string} input
	 * @param {string|null} param
	 * @param {CBaseEntity|null} activator
	 * @param {CBaseEntity|null} caller
	 * @returns {boolean} `false` if input is a `null`/empty string, or if the input wasn't handled.
	 */
	AcceptInput(input: string, param: string|null, activator: CBaseEntity|null, caller: CBaseEntity|null): boolean

	/**
	 * Adds the supplied flags to the Entity Flags in the entity. (`m_iEFlags` datamap)
	 *
	 * **Note**: Adding `EFL_KILLME` will make the entity unkillable, even on round resets, until the flag is removed.
	 * @param {number} flags See [Constants.FPlayer](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FPlayer)
	 */
	AddEFlags(flags: number): void

	/**
	 * Adds the supplied flags to another separate player-related entity flags system in the entity. (`m_fFlags` datamap)
	 * @param {number} flags See [Constants.FPlayer](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FPlayer)
	 */
	AddFlag(flags: number): void

	/**
	 * Adds the supplied flags to the Solid Flags in the entity. (`m_Collision.m_usSolidFlags` datamap)
	 * @param {number} flags See [Constants.FSolid](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FSolid)
	 */
	AddSolidFlags(flags: number): void

	/**
	 * Apply a Velocity Impulse as a world space impulse vector.
	 * Works for most physics-based objects including dropped weapons and even dropped Sandviches.
	 * @param {Vector} impulse
	 */
	ApplyAbsVelocityImpulse(impulse: Vector): void

	/**
	 * Apply an Angular Velocity Impulse in entity local space.
	 * The direction of the input vector is the rotation axis, and the length is the magnitude of the impulse.
	 * @param {Vector} impulse
	 */
	ApplyLocalAngularVelocityImpulse(impulse: Vector): void

	/**
	 * Acts like the `BecomeRagdoll` input, with the required impulse value applied as a force on the ragdoll.
	 * Does NOT spawn a prop_ragdoll or any other entity.
	 *
	 * **Warning**: These are a special group of ragdolls that never disappear by default.
	 * @param {Vector} impulse
	 * @returns {boolean}
	 */
	BecomeRagdollOnClient(impulse: Vector): boolean

	/**
	 * Sets the player-related entity flags to 0 on an entity, clearing them.
	 */
	ClearFlags(): void

	/**
	 * Sets Solid Flags to 0 on an entity, clearing them.
	 */
	ClearSolidFlags(): void

	/**
	 * Adds an I/O connection that will call the named when the specified output fires.
	 * @param {string} output_name
	 * @param {string} public_name
	 */
	ConnectOutput(output_name: string, public_name: string): void

	/**
	 * Removes the entity. Simply calls `UTIL_Remove`.
	 */
	Destroy(): void

	/**
	 * Disable drawing and transmitting the entity to clients. (adds `EF_NODRAW`)
	 */
	DisableDraw(): void

	/**
	 * Removes a connected script from an I/O event.
	 * @param {string} output_name
	 * @param {string} public_name
	 */
	DisconnectOutput(output_name: string, public_name: string): void

	/**
	 * Alternative dispatch spawn, same as the one in `CEntities`, for convenience.
	 *
	 * **Note**: Calling this on players will cause them to respawn.
	 */
	DispatchSpawn(): void

	/**
	 * Plays a sound from this entity. The sound must be precached first for it to play.
	 *
	 * **Warning**: Looping sounds will not stop on the entity when it's destroyed and will persist forever!
	 * @param {string} sound_name
	 */
	EmitSound(sound_name: string): void

	/**
	 * Enable drawing and transmitting the entity to clients. (removes `EF_NODRAW`)
	 */
	EnableDraw(): void

	/**
	 * Returns the entity index.
	 * @returns {number}
	 */
	entindex(): number

	/**
	 * Returns the entity's eye angles. Acts like `GetAbsAngles` if the entity does not support it.
	 * @returns {QAngle}
	 */
	EyeAngles(): QAngle

	/**
	 * Get vector to eye position - absolute coords. Acts like `GetOrigin` if the entity does not support it.
	 * @returns {Vector}
	 */
	EyePosition(): Vector

	/**
	 * Returns the most-recent entity parented to this one.
	 * @returns {CBaseEntity|null}
	 */
	FirstMoveChild(): CBaseEntity|null

	/**
	 * Get the entity's pitch, yaw, and roll as `QAngle`.
	 * @returns {QAngle}
	 */
	GetAbsAngles(): QAngle

	/**
	 * Returns the current absolute velocity of the entity.
	 * @returns {Vector}
	 */
	GetAbsVelocity(): Vector

	/**
	 * Get the entity's pitch, yaw, and roll as `Vector`.
	 * @returns {Vector}
	 * @deprecated Use `GetAbsAngles` that returns a `QAngle` instead
	 */
	GetAngles(): Vector

	/**
	 * Get the local angular velocity - returns a `Vector` of pitch, yaw, and roll.
	 * @returns {Vector}
	 */
	GetAngularVelocity(): Vector

	/**
	 * Returns any constant velocity currently being imparted onto the entity.
	 * @returns {Vector}
	 */
	GetBaseVelocity(): Vector

	/**
	 * Get a vector containing max bounds, centered on object.
	 * @returns {Vector}
	 */
	GetBoundingMaxs(): Vector

	/**
	 * Get a vector containing max bounds, centered on object, taking the object's orientation into account.
	 * @returns {Vector}
	 */
	GetBoundingMaxsOriented(): Vector

	/**
	 * Get a vector containing min bounds, centered on object.
	 * @returns {Vector}
	 */
	GetBoundingMins(): Vector

	/**
	 * Get a vector containing min bounds, centered on object, taking the object's orientation into account.
	 * @returns {Vector}
	 */
	GetBoundingMinsOriented(): Vector

	/**
	 * Gets center point of the entity in world coordinates.
	 * @returns {Vector}
	 */
	GetCenter(): Vector

	/**
	 * @returns {string}
	 */
	GetClassname(): string

	/**
	 * Gets the current collision group of the entity.
	 * @returns {number} See [Constants.ECollisionGroup](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ECollisionGroup)
	 */
	GetCollisionGroup(): number

	/**
	 * Get the entity's engine flags.
	 * @returns {number} See [Constants.FEntityEFlags](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FEntityEFlags)
	 */
	GetEFlags(): number

	/**
	 * Get the entity's flags.
	 * @returns {number} See [Constants.FPlayer](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FPlayer)
	 */
	GetFlags(): number

	/**
	 * Get the entity as an `EHANDLE`.
	 * @returns {instance}
	 * @deprecated Leftover from earlier versions of VScript.
	 */
	GetEntityHandle(): CBaseEntity

	/**
	 * @returns {number}
	 */
	GetEntityIndex(): number

	/**
	 * Get the forward vector of the entity.
	 *
	 * **Note**: If you intend to get a player's eye forward vector, use `EyeAngles().Forward()` instead.
	 * @returns {Vector}
	 */
	GetForwardVector(): Vector

	/**
	 * Get PLAYER friction, ignored for objects.
	 * @returns {number}
	 */
	GetFriction(): number

	/**
	 * @returns {number}
	 */
	GetGravity(): number

	/**
	 * @returns {number}
	 */
	GetHealth(): number

	/**
	 * Get the right vector of the entity.
	 * @returns {Vector}
	 * @deprecated This is purely for compatibility, use `GetLeftVector` instead
	 */
	GetLeftVector(): Vector

	/**
	 * @returns {QAngle}
	 */
	GetLocalAngles(): QAngle

	/**
	 * @returns {Vector}
	 */
	GetLocalOrigin(): Vector

	/**
	 * Get Entity relative velocity.
	 * @returns {Vector}
	 */
	GetLocalVelocity(): Vector

	/**
	 * @returns {number}
	 */
	GetMaxHealth(): number

	/**
	 * Get a KeyValue class instance on this entity's model.
	 * @returns {CScriptKeyValues}
	 */
	GetModelKeyValues(): CScriptKeyValues

	/**
	 * Returns the name of the model.
	 * @returns {string}
	 */
	GetModelName(): string

	/**
	 * If in hierarchy, retrieves the entity's parent.
	 * @returns {CBaseEntity|null}
	 */
	GetMoveParent(): CBaseEntity|null

	/**
	 * @returns {number}
	 */
	GetMoveType(): number

	/**
	 * Get entity's targetname.
	 * @returns {string}
	 */
	GetName(): string

	/**
	 * This is `GetAbsOrigin` with a funny script name for some reason.
	 * @returns {Vector}
	 */
	GetOrigin(): Vector

	/**
	 * Gets this entity's owner.
	 *
	 * **Note**: This is a wrapper for `m_hOwnerEntity` netprop.
	 * @returns {CBaseEntity|null}
	 */
	GetOwner(): CBaseEntity|null

	/**
	 * @returns {Vector}
	 */
	GetPhysAngularVelocity(): Vector

	/**
	 * @returns {Vector}
	 */
	GetPhysVelocity(): Vector

	/**
	 * Get the entity name stripped of template unique decoration.
	 * @returns {string}
	 */
	GetPreTemplateName(): string

	/**
	 * Get the right vector of the entity.
	 * @returns {Vector}
	 */
	GetRightVector(): Vector

	/**
	 * If in hierarchy, walks up the hierarchy to find the root parent.
	 * @returns {CBaseEntity|null}
	 */
	GetRootMoveParent(): CBaseEntity|null

	/**
	 * Retrieve the unique identifier used to refer to the entity within the scripting system.
	 * @returns {string}
	 */
	GetScriptId(): string

	/**
	 * Retrieve the script-side data associated with an entity.
	 * @returns {table|null}
	 */
	GetScriptScope(): table | null

	/**
	 * Retrieve the name of the current script think func.
	 * @returns {string}
	 */
	GetScriptThinkFunc(): string

	/**
	 * @returns {number} See [Constants.ESolidType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ESolidType)
	 */
	GetSolid(): number

	/**
	 * Returns float duration of the sound.
	 *
	 * **Warning**: Does not work on dedicated servers.
	 * @param {string} sound_name
	 * @param {string|null} actor_model_name Optional and can be left empty.
	 * @returns {number}
	 */
	GetSoundDuration(sound_name: string, actor_model_name: string|null): number

	/**
	 * @returns {number} See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ETFTeam)
	 */
	GetTeam(): number

	/**
	 * Get the up vector of the entity.
	 * @returns {Vector}
	 */
	GetUpVector(): Vector

	/**
	 * @returns {Vector}
	 * @deprecated Use `GetAbsVelocity` instead
	 */
	GetVelocity(): Vector

	/**
	 * This tells you how much of the entity is underwater.
	 * @returns {number} `0`=not underwater, `1`=feet, `2`=waist, `3`=head.
	 */
	GetWaterLevel(): number

	/**
	 * Returns the type of water the entity is currently submerged in.
	 * @returns {number} 32=water, 16=slime.
	 */
	GetWaterType(): number

	/**
	 * Am I alive?
	 * @returns {boolean}
	 */
	IsAlive(): boolean

	/**
	 * @param {number} flag See [Constants.FEntityEFlags](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FEntityEFlags)
	 * @returns {boolean}
	 */
	IsEFlagSet(flag: number): boolean

	/**
	 * Checks whether the entity is a player or not.
	 * @returns {boolean}
	 */
	IsPlayer(): boolean

	/**
	 * @returns {boolean}
	 */
	IsSolid(): boolean

	/**
	 * @param {number} flag See [Constants.FSolid](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FSolid)
	 * @returns {boolean}
	 */
	IsSolidFlagSet(flag: number): boolean

	/**
	 * Checks whether the entity still exists.
	 * Useful when storing entity handles and needing to check if the entity was not deleted.
	 * @returns {boolean}
	 */
	IsValid(): boolean

	/**
	 * Executes KeyValue with a float.
	 *
	 * **Warning**: Does not update the internal network state of the entity.
	 * @param {string} key
	 * @param {number} value
	 * @returns {boolean}
	 */
	KeyValueFromFloat(key: string, value: number): boolean

	/**
	 * Executes KeyValue with an int.
	 *
	 * **Warning**: Does not update the internal network state of the entity.
	 * @param {string} key
	 * @param {number} value
	 * @returns {boolean}
	 */
	KeyValueFromInt(key: string, value: number): boolean

	/**
	 * Executes KeyValue with a string.
	 *
	 * **Warning**: Does not update the internal network state of the entity.
	 * @param {string} key
	 * @param {string} value
	 * @returns {boolean}
	 */
	KeyValueFromString(key: string, value: string): boolean

	/**
	 * Executes KeyValue with a vector.
	 *
	 * **Warning**: Does not update the internal network state of the entity.
	 * @param {string} key
	 * @param {Vector} value
	 * @returns {boolean}
	 */
	KeyValueFromVector(key: string, value: Vector): boolean

	/**
	 * Removes the entity. Equivalent of firing the Kill I/O input, but instantaneous.
	 *
	 * **Warning**: This clears the owner entity before removing.
	 */
	Kill(): void

	/**
	 * Returns the entity's local eye angles.
	 * @returns {QAngle}
	 */
	LocalEyeAngles(): QAngle

	/**
	 * Returns the next entity parented with the entity.
	 * @returns {CBaseEntity|null}
	 */
	NextMovePeer(): CBaseEntity|null

	/**
	 * Precache a model (.mdl) or sprite (.vmt). The extension must be specified.
	 * @param {string} model_name
	 */
	PrecacheModel(model_name: string): void

	/**
	 * Precache a soundscript or raw WAV/MP3 sound. Same as `PrecacheSoundScript`.
	 * @param {string} sound_script
	 */
	PrecacheScriptSound(sound_script: string): void

	/**
	 * Precache a soundscript or raw WAV/MP3 sound. Same as `PrecacheScriptSound`.
	 * @param {string} sound_script
	 */
	PrecacheSoundScript(sound_script: string): void

	/**
	 * @param {number} flags See [Constants.FEntityEFlags](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FEntityEFlags)
	 */
	RemoveEFlags(flags: number): void

	/**
	 * @param {number} flags See [Constants.FPlayer](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FPlayer)
	 */
	RemoveFlag(flags: number): void

	/**
	 * @param {number} flags See [Constants.FSolid](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FSolid)
	 */
	RemoveSolidFlags(flags: number): void

	/**
	 * Set entity pitch, yaw, roll as `QAngle`. Does not work on players, use `SnapEyeAngles` instead.
	 * @param {QAngle} angles
	 */
	SetAbsAngles(angles: QAngle): void

	/**
	 * Sets the current absolute velocity of the entity.
	 * Does nothing on VPhysics objects, use `SetPhysVelocity` instead.
	 * @param {Vector} velocity
	 */
	SetAbsVelocity(velocity: Vector): void

	/**
	 * Sets the absolute origin of the entity.
	 * @param {Vector} origin
	 */
	SetAbsOrigin(origin: Vector): void

	/**
	 * Sets entity angles.
	 * @param {number} pitch
	 * @param {number} yaw
	 * @param {number} roll
	 * @deprecated Use `SetAbsAngles` instead
	 */
	SetAngles(pitch: number, yaw: number, roll: number): void

	/**
	 * Set the local angular velocity.
	 * @param {number} pitch
	 * @param {number} yaw
	 * @param {number} roll
	 */
	SetAngularVelocity(pitch: number, yaw: number, roll: number): void

	/**
	 * Set the current collision group of the entity.
	 * @param {number} group See [Constants.ECollisionGroup](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ECollisionGroup)
	 */
	SetCollisionGroup(group: number): void

	/**
	 * Enables drawing if you pass `true`, disables drawing if you pass `false`.
	 * @param {boolean} toggle
	 */
	SetDrawEnabled(toggle: boolean): void

	/**
	 * @param {number} flags See [Constants.FEntityEFlags](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FEntityEFlags)
	 */
	SetEFlags(flags: number): void

	/**
	 * Set the orientation of the entity to have this forward vector.
	 * @param {Vector} forward
	 */
	SetForwardVector(forward: Vector): void

	/**
	 * @param {number} friction
	 */
	SetFriction(friction: number): void

	/**
	 * Sets a multiplier for gravity. 1 is default gravity.
	 *
	 * **Note**: `0` gravity will not work, use `0.000001` as a workaround.
	 * @param {number} gravity
	 */
	SetGravity(gravity: number): void

	/**
	 * @param {number} health
	 */
	SetHealth(health: number): void

	/**
	 * @param {QAngle} angles
	 */
	SetLocalAngles(angles: QAngle): void

	/**
	 * @param {Vector} origin
	 */
	SetLocalOrigin(origin: Vector): void

	/**
	 * Sets the maximum health this entity can have. Does not update the current health.
	 *
	 * **Note**: Does nothing on players.
	 * @param {number} health
	 */
	SetMaxHealth(health: number): void

	/**
	 * Set a model for this entity.
	 *
	 * **Warning**: Make sure the model was already precached before using this or the game will crash!
	 * @param {string|null} model_name
	 */
	SetModel(model_name: string): void

	/**
	 * @param {number} movetype See [Constants.EMoveType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#EMoveType)
	 * @param {number} movecollide See [Constants.EMoveCollide](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#EMoveCollide)
	 */
	SetMoveType(movetype: number, movecollide: number): void

	/**
	 * @param {Vector} origin
	 * @deprecated Use `SetAbsOrigin` instead
	 */
	SetOrigin(origin: Vector): void

	/**
	 * Sets this entity's owner.
	 *
	 * **Note**: This is a wrapper for `m_hOwnerEntity` netprop.
	 * @param {CBaseEntity|null} entity
	 */
	SetOwner(entity: CBaseEntity|null): void

	/**
	 * @param {Vector} angular_velocity
	 */
	SetPhysAngularVelocity(angular_velocity: Vector): void

	/**
	 * @param {Vector} velocity
	 */
	SetPhysVelocity(velocity: Vector): void

	/**
	 * Sets the bounding box's scale for this entity.
	 *
	 * **Warning**: If any component of `mins`/`maxs` is backwards, the engine will exit with a fatal error.
	 * @param {Vector} mins
	 * @param {Vector} maxs
	 */
	SetSize(mins: Vector, maxs: Vector): void

	/**
	 * @param {number} solid See [Constants.ESolidType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ESolidType)
	 */
	SetSolid(solid: number): void

	/**
	 * @param {number} flags See [Constants.FSolid](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FSolid)
	 */
	SetSolidFlags(flags: number): void

	/**
	 * Sets entity team.
	 *
	 * **Note**: Use `ForceChangeTeam` on players instead.
	 * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ETFTeam)
	 */
	SetTeam(team: number): void

	/**
	 * @param {Vector} velocity
	 * @deprecated Use `SetAbsVelocity` instead
	 */
	SetVelocity(velocity: Vector): void

	/**
	 * Sets how much of the entity is underwater.
	 * @param {number} water_level See [Constants.WATERLEVEL](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#WATERLEVEL)
	 *                              (`0`=not underwater, `1`=feet, `2`=waist, `3`=head)
	 */
	SetWaterLevel(water_level: number): void

	/**
	 * Set the type of water the entity is currently submerged in.
	 * @param {number} water_type `32`=water, `16`=slime.
	 */
	SetWaterType(water_type: number): void

	/**
	 * Stops a sound on this entity.
	 * @param {string} sound_name
	 */
	StopSound(sound_name: string): void

	/**
	 * Deals damage to the entity.
	 * @param {number} damage
	 * @param {number} damage_type See [Constants.FDmgType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FDmgType)
	 * @param {CBaseEntity|null} attacker
	 */
	TakeDamage(damage: number, damage_type: number, attacker: CBaseEntity|null): void

	/**
	 * Extended version of TakeDamage.
	 *
	 * **Note**: If `damage_force` is `Vector(0,0,0)`, the game will automatically calculate it.
	 * @param {CBaseEntity|null} inflictor
	 * @param {CBaseEntity|null} attacker
	 * @param {CBaseEntity|null} weapon
	 * @param {Vector} damage_force
	 * @param {Vector} damage_position
	 * @param {number} damage
	 * @param {number} damage_type See [Constants.FDmgType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FDmgType)
	 */
	TakeDamageEx(inflictor: CBaseEntity|null, attacker: CBaseEntity|null, weapon: CBaseEntity|null, damage_force: Vector, damage_position: Vector, damage: number, damage_type: number): void

	/**
	 * Extended version of `TakeDamageEx` that can apply a custom damage type.
	 * @param {CBaseEntity|null} inflictor
	 * @param {CBaseEntity|null} attacker
	 * @param {CBaseEntity|null} weapon
	 * @param {Vector} damage_force
	 * @param {Vector} damage_position
	 * @param {number} damage
	 * @param {number} damage_type See [Constants.FDmgType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FDmgType)
	 * @param {number} custom_damage_type See [Constants.ETFDmgCustom](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#ETFDmgCustom)
	 */
	TakeDamageCustom(inflictor: CBaseEntity|null, attacker: CBaseEntity|null, weapon: CBaseEntity|null, damage_force: Vector, damage_position: Vector, damage: number, damage_type: number, custom_damage_type: number): void

	/**
	 * Teleports this entity. Set bools to `false` for properties you want unchanged.
	 * @param {boolean} use_origin
	 * @param {Vector} origin
	 * @param {boolean} use_angles
	 * @param {QAngle} angles
	 * @param {boolean} use_velocity
	 * @param {Vector} velocity
	 */
	Teleport(use_origin: boolean, origin: Vector, use_angles: boolean, angles: Vector, use_velocity: boolean, velocity: Vector): void

	/**
	 * Clear the current script scope for this entity.
	 */
	TerminateScriptScope(): void

	/**
	 * @param {number} flags See [Constants.FPlayer](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_publics/Constants#FPlayer)
	 */
	ToggleFlag(flags: number): void

	/**
	 * Create a script scope for an entity if it doesn't already exist.
	 * @returns {boolean}
	 */
	ValidateScriptScope(): boolean
}

/**
 * Script handle class for animatable entities, such as props.
 */
interface CBaseAnimating extends CBaseEntity {
    /**
     * Dispatch animation events to a `CBaseAnimating` entity.
     * @param {CBaseAnimating} entity
     */
    DispatchAnimEvents(entity: CBaseAnimating): void

    /**
     * Find a bodygroup ID by name.
     * @param {string} name
     * @returns {number} `-1` if the bodygroup does not exist.
     */
    FindBodygroupByName(name: string): number

    /**
     * Get an attachment's angles as a `QAngle`, by ID.
     * @param {number} id
     * @returns {QAngle}
     */
    GetAttachmentAngles(id: number): QAngle

    /**
     * Get an attachment's parent bone index by ID.
     * @param {number} id
     * @returns {number}
     */
    GetAttachmentBone(id: number): number

    /**
     * Get an attachment's origin as a `Vector`, by ID.
     * @param {number} id
     * @returns {Vector}
     */
    GetAttachmentOrigin(id: number): Vector

    /**
     * Get the bodygroup value by bodygroup ID.
     * @param {number} id
     * @returns {number}
     */
    GetBodygroup(id: number): number

    /**
     * Get the bodygroup's name by ID.
     * @param {number} id
     * @returns {string}
     */
    GetBodygroupName(id: number): string

    /**
     * Get the bodygroup's name by group and part.
     * @param {number} group
     * @param {number} part
     * @returns {string}
     */
    GetBodygroupPartName(group: number, part: number): string

    /**
     * Get the bone's angles as a `QAngle`, by ID.
     *
     * **Warning**: Bone transforms are cached setting new sequences may cause stale bone data.
     * @param {number} id
     * @returns {QAngle}
     */
    GetBoneAngles(id: number): QAngle

    /**
     * Get the bone's origin `Vector` by ID.
     * **Warning**: See GetBoneAngles warning.
     * @param {number} id
     * @returns {Vector}
     */
    GetBoneOrigin(id: number): Vector

    /**
     * Gets the model's current animation cycle rate. Ranges from `0.0` to `1.0`.
     * @returns {number}
     */
    GetCycle(): number

    /**
     * Get the model's scale.
     * @returns {number}
     */
    GetModelScale(): number

    /**
     * Get the current animation's playback rate.
     * @returns {number}
     */
    GetPlaybackRate(): number

    /**
     * Get the current-playing sequence's ID.
     * @returns {number}
     */
    GetSequence(): number

    /**
     * Get the activity name for a sequence by sequence ID.
     * @param {number} id
     * @returns {string}
     */
    GetSequenceActivityName(id: number): string

    /**
     * Get a sequence duration in seconds by sequence ID.
     * @param {number} id
     * @returns {number}
     */
    GetSequenceDuration(id: number): number

    /**
     * Get a sequence name by sequence ID.
     * @param {number} id
     * @returns {string}
     */
    GetSequenceName(id: number): string

    /**
     * Gets the current skin index.
     * @returns {number}
     */
    GetSkin(): number

    /**
     * Ask whether the main sequence is done playing.
     * @returns {boolean}
     */
    IsSequenceFinished(): boolean

    /**
     * Get the named activity index.
     * @param {string} activity
     * @returns {number} `-1` if the activity does not exist.
     */
    LookupActivity(activity: number): number

    /**
     * Get the named attachment index.
     * @param {string} name
     * @returns {number} `0` if the attachment does not exist.
     */
    LookupAttachment(name: number): number

    /**
     * Get the named bone index.
     * @param {string} bone
     * @returns {number} `-1` if the bone does not exist.
     */
    LookupBone(bone: number): number

    /**
     * Gets the pose parameter's index.
     * @param {string} name
     * @returns {number} `-1` if the pose parameter does not exist.
     */
    LookupPoseParameter(name: string): number

    /**
     * Looks up a sequence by names of sequences or activities.
     * @param {string} name
     * @returns {number} `-1` if not found.
     */
    LookupSequence(name: string): number

    /**
     * Reset a sequence by sequence ID. If the ID is different, switch to the new sequence.
     * @param {number} id
     */
    ResetSequence(id: number): void

    /**
     * Set the bodygroup by ID.
     * @param {number} id
     * @param {number} value
     */
    SetBodygroup(id: number, value: number): void

    /**
     * Sets the model's current animation cycle from `0` to `1`.
     *
     * **Note**: Only works if `m_bClientSideAnimation` is set to `false`.
     * @param {number} cycle
     */
    SetCycle(cycle: number): void

    /**
     * Set a model for this entity. Automatically precaches and maintains sequence/cycle if possible.
     * @param {string|null} model_name
     */
    SetModelSimple(model_name: string|null): void

    /**
     * Changes a model's scale over time. Set `change_duration` to `0.0` to change instantly.
     * @param {number} scale
     * @param {number} change_duration
     */
    SetModelScale(scale: number, change_duration: number): void

    /**
     * Set the current animation's playback rate.
     * @param {number} rate
     */
    SetPlaybackRate(rate: number): void

    /**
     * Sets a pose parameter value.
     * @param {number} id
     * @param {number} value
     * @returns {number} The effective value after clamping or looping.
     */
    SetPoseParameter(id: number, value: number): number

    /**
     * Plays a sequence by sequence ID.
     *
     * **Warning**: Can cause animation stutters. Consider using `ResetSequence` instead.
     * @param {number} id
     */
    SetSequence(id: number): void

    /**
     * Sets the model's skin.
     * @param {number} index
     */
    SetSkin(index: number): void

    /**
     * Stop the current animation (same as `SetPlaybackRate(0.0)`).
     */
    StopAnimation(): void

    /**
     * Advance animation frame to some time in the future with an automatically calculated interval.
     */
    StudioFrameAdvance(): void

    /**
     * Advance animation frame to some time in the future with a manual interval.
     * @param {number} dt
     */
    StudioFrameAdvanceManual(dt: number): void
}

/**
 * Script handle class for any weapon entities that can be part of a player's inventory.
 */
interface CBaseCombatWeapon extends CBaseAnimating {
    /**
     * Can this weapon be selected.
     * @returns {boolean}
     */
    CanBeSelected(): boolean

    /**
     * Current ammo in clip1.
     * @returns {number} `-1` if clip1 is not present.
     */
    Clip1(): number

    /**
     * Current ammo in clip2.
     * @returns {number} `-1` if clip2 is not present.
     */
    Clip2(): number

    /**
     * Default size of clip1.
     * @returns {number} `-1` if clip1 is not present.
     */
    GetDefaultClip1(): number

    /**
     * Default size of clip2.
     * @returns {number} `-1` if clip2 is not present.
     */
    GetDefaultClip2(): number

    /**
     * Max size of clip1.
     * @returns {number} `-1` if clip1 is not present.
     */
    GetMaxClip1(): number

    /**
     * Max size of clip2.
     * @returns {number} `-1` if clip2 is not present.
     */
    GetMaxClip2(): number

    /**
     * Gets the weapon's internal name (not the targetname!)
     *
     * **Warning**: Conflicts with `CBaseEntity`'s `GetName`. Use `CBaseEntity.GetName.call(weapon)` for targetname.
     * @returns {string}
     */
    GetName(): string

    /**
     * Gets the weapon's current position.
     * @returns {number}
     */
    GetPosition(): number

    /**
     * Current primary ammo count.
     * @returns {number}
     */
    GetPrimaryAmmoCount(): number

    /**
     * Returns the primary ammo type.
     * @returns {number}
     */
    GetPrimaryAmmoType(): number

    /**
     * Gets the weapon's print name.
     * @returns {string}
     */
    GetPrintName(): string

    /**
     * Current secondary ammo count.
     * @returns {number}
     */
    GetSecondaryAmmoCount(): number

    /**
     * Returns the secondary ammo type.
     * @returns {number}
     */
    GetSecondaryAmmoType(): number

    /**
     * Gets the weapon's current slot.
     * @returns {number}
     */
    GetSlot(): number

    /**
     * Get the weapon subtype.
     * @returns {number}
     */
    GetSubType(): number

    /**
     * Get the weapon flags.
     * @returns {number}
     */
    GetWeaponFlags(): number

    /**
     * Get the weapon weighting/importance.
     * @returns {number}
     */
    GetWeight(): number

    /**
     * Do we have any ammo?
     * @returns {boolean}
     */
    HasAnyAmmo(): boolean

    /**
     * Do we have any primary ammo?
     * @returns {boolean}
     */
    HasPrimaryAmmo(): boolean

    /**
     * Do we have any secondary ammo?
     * @returns {boolean}
     */
    HasSecondaryAmmo(): boolean

    /**
     * Are we allowed to switch to this weapon?
     * @returns {boolean}
     */
    IsAllowedToSwitch(): boolean

    /**
     * Returns whether this is a melee weapon.
     * @returns {boolean}
     */
    IsMeleeWeapon(): boolean

    /**
     * Force a primary attack.
     *
     * **Warning**: Hitscan and melee weapons require lag compensation information to be present.
     */
    PrimaryAttack(): void

    /**
     * Force a secondary attack.
     *
     * **Warning**: Hitscan and melee weapons require lag compensation information to be present.
     */
    SecondaryAttack(): void

    /**
     * Set current ammo in clip1.
     * @param {number} amount
     */
    SetClip1(amount: number): void

    /**
     * Set current ammo in clip2.
     * @param {number} amount
     */
    SetClip2(amount: number): void

    /**
     * Sets a custom view model for this weapon by model name.
     * @param {string|null} model_name
     */
    SetCustomViewModel(model_name: string|null): void

    /**
     * Sets a custom view model for this weapon by modelindex.
     * @param {number} model_index
     */
    SetCustomViewModelModelIndex(model_index: number): void

    /**
     * Set the weapon subtype.
     * @param {number} subtype
     */
    SetSubType(subtype: number): void

    /**
     * Do we use clips for ammo 1?
     * @returns {boolean}
     */
    UsesClipsForAmmo1(): boolean

    /**
     * Do we use clips for ammo 2?
     * @returns {boolean}
     */
    UsesClipsForAmmo2(): boolean

    /**
     * Do we use primary ammo?
     * @returns {boolean}
     */
    UsesPrimaryAmmo(): boolean

    /**
     * Do we use secondary ammo?
     * @returns {boolean}
     */
    UsesSecondaryAmmo(): boolean

    /**
     * Is this weapon visible in weapon selection?
     * @returns {boolean}
     */
    VisibleInWeaponSelection(): boolean
}

/**
 * This is just multiple inheritance of `CBaseCombatWeapon` and `CEconEntity`
 * with no additional methods added. Here it inherits `CBaseCombatWeapon`
 * and copies `CEconEntity` methods to achieve the same result. (Why C++
 * developers are spreading their broken OOP curse on everyone else?)
 * @extends {CBaseCombatWeapon}
 */
interface CTFWeaponBase extends CBaseCombatWeapon {
    /**
     * Add an attribute to the entity. Set duration to `0` or lower for infinite duration.
     *
     * **Note**: For players use `AddCustomAttribute` instead.
     * @param {string} name
     * @param {number} value
     * @param {number} duration
     */
    AddAttribute(name: string, value: number, duration: number): void

    /**
     * Get an attribute float from the entity.
     * @param {string} name
     * @param {number} default_value
     * @returns {number} `default_value` if not found.
     */
    GetAttribute(name: string, default_value: number): number

    /**
     * Remove an attribute from the entity.
     *
     * **Note**: Static attributes cannot be removed with this method.
     * @param {string} name
     */
    RemoveAttribute(name: string): void

    /**
     * Relinks attributes to provisioners.
     */
    ReapplyProvision(): void
}

/**
 * Animated characters who have vertex flex capability (e.g., facial expressions).
 */
interface CBaseFlex extends CBaseAnimating {
    /**
     * Play the specified .vcd file, causing the related characters to speak and subtitles to play.
     * @param {string} scene_file
     * @param {number} delay
     * @returns {number}
     */
    PlayScene(scene_file: string, delay: number): number
}

/**
 * Combat entities with similar movement capabilities to a player.
 */
interface CBaseCombatCharacter extends CBaseFlex {
    /**
     * Return the last nav area occupied, `null` if unknown.
     * @returns {CTFNavArea|null}
     */
    GetLastKnownArea(): CTFNavArea|null
}

/**
 * Script handle class for player entities.
 */
interface CBasePlayer extends CBaseCombatCharacter {
    /**
     * Whether the player is being forced by SetForceLocalDraw to be drawn.
     * @returns {boolean}
     */
    GetForceLocalDraw(): boolean

    /**
     * Get a vector containing max bounds of the player in local space.
     * @returns {Vector}
     */
    GetPlayerMaxs(): Vector

    /**
     * Get a vector containing min bounds of the player in local space.
     * @returns {Vector}
     */
    GetPlayerMins(): Vector

    /**
     * Gets the current overlay material set by SetScriptOverlayMaterial.
     * @returns {string}
     */
    GetScriptOverlayMaterial(): string

    /**
     * Returns `true` if the player is in noclip mode.
     * @returns {boolean}
     */
    IsNoclipping(): boolean

    /**
     * Forces the player to be drawn as if they were in thirdperson.
     * @param {boolean} toggle
     */
    SetForceLocalDraw(toggle: boolean): void

    /**
     * Sets the overlay material that can't be overridden by other overlays.
     * @param {string|null} material
     */
    SetScriptOverlayMaterial(material: string|null): void

    /**
     * Snap the player's eye angles to this.
     * @param {QAngle} angles
     */
    SnapEyeAngles(angles: QAngle): void

    /**
     * Ow! Punches the player's view.
     * @param {QAngle} angle_offset
     */
    ViewPunch(angle_offset: QAngle): void

    /**
     * Resets the player's view punch if the offset stays below the given tolerance.
     * @param {number} tolerance
     */
    ViewPunchReset(tolerance: number): void
}

/**
 * Script handle class for economic equippables (hats and weapons).
 */
interface CEconEntity extends CBaseAnimating {
    /**
     * Add an attribute to the entity. Set duration to `0` or lower for infinite duration.
     *
     * **Note**: For players use `AddCustomAttribute` instead.
     * @param {string} name
     * @param {number} value
     * @param {number} duration
     */
    AddAttribute(name: string, value: number, duration: number): void

    /**
     * Get an attribute float from the entity.
     * @param {string} name
     * @param {number} default_value
     * @returns {number} `default_value` if not found.
     */
    GetAttribute(name: string, default_value: number): number

    /**
     * Remove an attribute from the entity.
     *
     * **Note**: Static attributes cannot be removed with this method.
     * @param {string} name
     */
    RemoveAttribute(name: string): void

    /**
     * Relinks attributes to provisioners.
     */
    ReapplyProvision(): void
}

/**
 * Script handle class for player entities of Team Fortress 2.
 */
interface CTFPlayer extends CBasePlayer {
    /**
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     */
    AddCond(cond: number): void

    /**
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @param {number} duration
     * @param {CBaseEntity|null} provider
     */
    AddCondEx(cond: number, duration: number, provider: CBaseEntity|null): void

    /**
     * Give the player some cash for MvM. New value is bounded between 0-30000.
     * @param {number} amount
     */
    AddCurrency(amount: number): void

    /**
     * Add a custom attribute to the player. Set duration to `0` or lower for infinite.
     *
     * **Note**: Does not work when applied in the `player_spawn` event.
     * @param {string} name
     * @param {number} value
     * @param {number} duration
     */
    AddCustomAttribute(name: string, value: number, duration: number): void

    /**
     * Hides a HUD element(s).
     * @param {number} flags See [Constants.FHideHUD](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FHideHUD)
     */
    AddHudHideFlags(flags: number): void

    /**
     * Apply a view punch along the pitch angle.
     * @param {number} impulse
     * @returns {boolean} `true` if the punch was applied.
     */
    ApplyPunchImpulseX(impulse: number): boolean

    /**
     * Make a player bleed for a set duration of time.
     * @param {number} duration
     */
    BleedPlayer(duration: number): void

    /**
     * Make a player bleed with specific damage per tick and custom damage type.
     * @param {number} duration
     * @param {number} damage
     * @param {boolean} endless
     * @param {number} custom_damage_type See [Constants.ETFDmgCustom](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFDmgCustom)
     */
    BleedPlayerEx(duration: number, damage: number, endless: boolean, custom_damage_type: number): void

    /**
     * Cancels any taunt in progress.
     */
    CancelTaunt(): void

    /**
     * Can the player air dash/double jump?
     * @returns {boolean}
     */
    CanAirDash(): boolean

    /**
     * @returns {boolean}
     */
    CanBeDebuffed(): boolean

    /**
     * @returns {boolean}
     */
    CanBreatheUnderwater(): boolean

    /**
     * Can the player duck?
     * @returns {boolean}
     */
    CanDuck(): boolean

    /**
     * Can the player get wet by jarate/milk?
     * @returns {boolean}
     */
    CanGetWet(): boolean

    /**
     * Can the player jump?
     * @returns {boolean}
     */
    CanJump(): boolean

    /**
     * Can the player move?
     * @returns {boolean}
     */
    CanPlayerMove(): boolean

    /**
     */
    ClearCustomModelRotation(): void

    /**
     */
    ClearSpells(): void

    /**
     * Stops active taunt from damaging or cancels Rock-Paper-Scissors result.
     */
    ClearTauntAttack(): void

    /**
     * Performs taunts attacks if available.
     */
    DoTauntAttack(): void

    /**
     * Force player to drop the flag (intelligence).
     * @param {boolean} silent
     */
    DropFlag(silent: boolean): void

    /**
     * Force player to drop the rune.
     * @param {boolean} apply_force
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     */
    DropRune(apply_force: boolean, team: number): void

    /**
     * Stops a looping taunt (obeys minimum time rules).
     */
    EndLongTaunt(): void

    /**
     * Equips a wearable on the viewmodel.
     * @param {CBaseEntity} entity
     */
    EquipWearableViewModel(entity: CBaseEntity): void

    /**
     */
    ExtinguishPlayerBurning(): void

    /**
     * Makes e.g. a heavy go AAAAAAAAAaAaa like they are firing their minigun.
     */
    FiringTalk(): void

    /**
     * Force player to change their team.
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @param {boolean} full_team_switch
     */
    ForceChangeTeam(team: number, full_team_switch: boolean): void

    /**
     * Force regenerates and respawns the player.
     */
    ForceRegenerateAndRespawn(): void

    /**
     * Force respawns the player.
     */
    ForceRespawn(): void

    /**
     * Get the player's current weapon.
     * @returns {CTFWeaponBase}
     */
    GetActiveWeapon(): CTFWeaponBase

    /**
     * @returns {number}
     */
    GetBackstabs(): number

    /**
     * @returns {number}
     */
    GetBonusPoints(): number

    /**
     * @returns {number}
     */
    GetBotType(): number

    /**
     * @returns {number}
     */
    GetBuildingsDestroyed(): number

    /**
     * @returns {number}
     */
    GetCaptures(): number

    /**
     * Gets the eye height of the player.
     * @returns {Vector}
     */
    GetClassEyeHeight(): Vector

    /**
     * Returns duration of the condition.
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @returns {number} `0` if not applied `-1` if infinite.
     */
    GetCondDuration(cond: number): number

    /**
     * Get an attribute float from the player.
     * @param {string} name
     * @param {number} default_value
     * @returns {number} `default_value` if not found.
     */
    GetCustomAttribute(name: string, default_value: number): number

    /**
     * Get player's cash for MvM.
     * @returns {number}
     */
    GetCurrency(): number

    /**
     * @returns {number}
     */
    GetCurrentTauntMoveSpeed(): number

    /**
     * @returns {number}
     */
    GetDefenses(): number

    /**
     * @returns {number}
     */
    GetDisguiseAmmoCount(): number

    /**
     * @returns {CTFPlayer|null}
     */
    GetDisguiseTarget(): CTFPlayer|null

    /**
     * @returns {number}
     */
    GetDisguiseTeam(): number

    /**
     * @returns {number}
     */
    GetDominations(): number

    /**
     * What entity is the player grappling?
     * @returns {CBaseEntity|null}
     */
    GetGrapplingHookTarget(): CBaseEntity|null

    /**
     * @returns {number}
     */
    GetHeadshots(): number

    /**
     * @returns {number}
     */
    GetHealPoints(): number

    /**
     * Who is the medic healing?
     * @returns {CBaseEntity|null}
     */
    GetHealTarget(): CBaseEntity|null

    /**
     * Gets current hidden HUD elements.
     * @returns {number} See [Constants.FHideHUD](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FHideHUD)
     */
    GetHudHideFlags(): number

    /**
     * @returns {number}
     */
    GetInvulns(): number

    /**
     * @returns {number}
     */
    GetKillAssists(): number

    /**
     * @returns {CTFWeaponBase|null}
     */
    GetLastWeapon(): CTFWeaponBase|null

    /**
     * Get next change class time.
     * @returns {number}
     */
    GetNextChangeClassTime(): number

    /**
     * Get next change team time.
     * @returns {number}
     */
    GetNextChangeTeamTime(): number

    /**
     * Get next health regen time.
     * @returns {number}
     */
    GetNextRegenTime(): number

    /**
     * @returns {number}
     */
    GetPlayerClass(): number

    /**
     * @returns {number}
     */
    GetRageMeter(): number

    /**
     * @returns {number}
     */
    GetResupplyPoints(): number

    /**
     * @returns {number}
     */
    GetRevenge(): number

    /**
     * @returns {number}
     */
    GetScoutHypeMeter(): number

    /**
     * @returns {number}
     */
    GetSpyCloakMeter(): number

    /**
     * @returns {number}
     */
    GetTeleports(): number

    /**
     * Timestamp until a taunt attack lasts. `0` if unavailable.
     * @returns {number}
     */
    GetTauntAttackTime(): number

    /**
     * Timestamp until taunt is stopped.
     * @returns {number}
     */
    GetTauntRemoveTime(): number

    /**
     * Timestamp when kart was reversed. `FLT_MAX` if yet to be done.
     * @returns {number}
     */
    GetVehicleReverseTime(): number

    /**
     * When did the player last call medic. `99999.9` if yet to be done.
     * @returns {number}
     */
    GetTimeSinceCalledForMedic(): number

    /**
     * @param {boolean} remove
     * @param {boolean} refund
     */
    GrantOrRemoveAllUpgrades(remove: boolean, refund: boolean): void

    /**
     * Currently holding an item (e.g. capture flag)?
     * @returns {boolean}
     */
    HasItem(): boolean

    /**
     * Spoofs a taunt command from the player.
     * @param {number} taunt_slot
     */
    HandleTauntCommand(taunt_slot: number): void

    /**
     * @returns {boolean}
     */
    InAirDueToExplosion(): boolean

    /**
     * @returns {boolean}
     */
    InAirDueToKnockback(): boolean

    /**
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @returns {boolean}
     */
    InCond(cond: number): boolean

    /**
     * @returns {boolean}
     */
    IsAirDashing(): boolean

    /**
     * Returns `true` if the taunt will be stopped.
     * @returns {boolean}
     */
    IsAllowedToRemoveTaunt(): boolean

    /**
     * @returns {boolean}
     */
    IsAllowedToTaunt(): boolean

    /**
     * Returns `true` if the player matches this bot type.
     * @param {number} type See [Constants.EBotType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#EBotType)
     * @returns {boolean}
     */
    IsBotOfType(type: number): boolean

    /**
     * Is this player calling for medic?
     * @returns {boolean}
     */
    IsCallingForMedic(): boolean

    /**
     * @returns {boolean}
     */
    IsCarryingRune(): boolean

    /**
     * @returns {boolean}
     */
    IsControlStunned(): boolean

    /**
     * @returns {boolean}
     */
    IsCritBoosted(): boolean

    /**
     * Returns `true` if the player is a puppet or AI bot.
     * @returns {boolean}
     */
    IsFakeClient(): boolean

    /**
     * @returns {boolean}
     */
    IsFireproof(): boolean

    /**
     * @returns {boolean}
     */
    IsFullyInvisible(): boolean

    /**
     * @returns {boolean}
     */
    IsHypeBuffed(): boolean

    /**
     * @returns {boolean}
     */
    IsImmuneToPushback(): boolean

    /**
     * @returns {boolean}
     */
    IsInspecting(): boolean

    /**
     * @returns {boolean}
     */
    IsInvulnerable(): boolean

    /**
     * @returns {boolean}
     */
    IsJumping(): boolean

    /**
     * Is this player an MvM mini-boss?
     * @returns {boolean}
     */
    IsMiniBoss(): boolean

    /**
     * @returns {boolean}
     */
    IsParachuteEquipped(): boolean

    /**
     * Returns `true` if we placed a sapper in the last few moments.
     * @returns {boolean}
     */
    IsPlacingSapper(): boolean

    /**
     * @returns {boolean}
     */
    IsRageDraining(): boolean

    /**
     * @returns {boolean}
     */
    IsRegenerating(): boolean

    /**
     * Returns `true` if we are currently sapping.
     * @returns {boolean}
     */
    IsSapping(): boolean

    /**
     * @returns {boolean}
     */
    IsSnared(): boolean

    /**
     * @returns {boolean}
     */
    IsStealthed(): boolean

    /**
     * @returns {boolean}
     */
    IsTaunting(): boolean

    /**
     * @returns {boolean}
     */
    IsUsingActionSlot(): boolean

    /**
     * @returns {boolean}
     */
    IsViewingCYOAPDA(): boolean

    /**
     * Resupplies a player. If `refill_health_ammo` is set, clears negative conds and gives health/ammo.
     * @param {boolean} refill_health_ammo
     */
    Regenerate(refill_health_ammo: boolean): void

    /**
     * Remove all conditions.
     */
    RemoveAllCond(): void

    /**
     * **Bug**: This does not actually remove all items.
     * It only drops the passtime ball, intelligence, disables radius healing, and hides the Spy invis watch.
     * @param {boolean} unused
     */
    RemoveAllItems(unused: boolean): void

    /**
     * Remove all player objects (e.g. dispensers/sentries).
     * @param {boolean} explode
     */
    RemoveAllObjects(explode: boolean): void

    /**
     * Removes a condition.
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     */
    RemoveCond(cond: number): void

    /**
     * Extended version of `RemoveCond`. Allows forcefully removing the condition.
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @param {boolean} ignore_duration
     */
    RemoveCondEx(cond: number, ignore_duration: boolean): void

    /**
     * Take away money from a player. Lower bounded to `0`.
     * @param {number} amount
     */
    RemoveCurrency(amount: number): void

    /**
     * Remove a custom attribute from the player.
     * @param {string} name
     */
    RemoveCustomAttribute(name: string): void

    /**
     * Undisguise a spy.
     */
    RemoveDisguise(): void

    /**
     * Unhides a HUD element(s).
     * @param {number} flags See [Constants.FHideHUD](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FHideHUD)
     */
    RemoveHudHideFlags(flags: number): void

    /**
     * Un-invisible a spy.
     */
    RemoveInvisibility(): void

    /**
     */
    RemoveTeleportEffect(): void

    /**
     */
    ResetScores(): void

    /**
     */
    RollRareSpell(): void

    /**
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @param {number} duration
     */
    SetCondDuration(cond: number, duration: number): void

    /**
     * Set player's cash for MvM. Does not have any bounds checking.
     * @param {number} amount
     */
    SetCurrency(amount: number): void

    /**
     * @param {number} speed
     */
    SetCurrentTauntMoveSpeed(speed: number): void

    /**
     * Sets a custom player model without animations (model will T-pose).
     * @param {string|null} model_name
     */
    SetCustomModel(model_name: string|null): void

    /**
     * @param {Vector} offset
     */
    SetCustomModelOffset(offset: Vector): void

    /**
     * @param {boolean} toggle
     */
    SetCustomModelRotates(toggle: boolean): void

    /**
     * @param {QAngle} angles
     */
    SetCustomModelRotation(angles: QAngle): void

    /**
     * @param {boolean} toggle
     */
    SetCustomModelVisibleToSelf(toggle: boolean): void

    /**
     * Sets a custom player model with full animations.
     * @param {string|null} model_name
     */
    SetCustomModelWithClassAnimations(model_name: string|null): void

    /**
     * @param {number} count
     */
    SetDisguiseAmmoCount(count: number): void

    /**
     * @param {number} toggle
     */
    SetForcedTauntCam(toggle: number): void

    /**
     * Set the player's target grapple entity.
     * @param {CBaseEntity|null} entity
     * @param {boolean} bleed
     */
    SetGrapplingHookTarget(entity: CBaseEntity|null, bleed: boolean): void

    /**
     * Force HUD hide flags to a value.
     * @param {number} flags See [Constants.FHideHUD](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FHideHUD)
     */
    SetHudHideFlags(flags: number): void

    /**
     * Make this player an MvM mini-boss.
     * @param {boolean} toggle
     */
    SetIsMiniBoss(toggle: boolean): void

    /**
     * Set next change class time.
     * @param {number} time
     */
    SetNextChangeClassTime(time: number): void

    /**
     * Set next change team time.
     * @param {number} time
     */
    SetNextChangeTeamTime(time: number): void

    /**
     * Set next available resupply time.
     * @param {number} time
     */
    SetNextRegenTime(time: number): void

    /**
     * Sets the player class. Updates the player's visuals and model.
     * @param {number} class_index See [Constants.ETFClass](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFClass)
     */
    SetPlayerClass(class_index: number): void

    /**
     * Sets rage meter from 0 - 100.
     * @param {number} percent
     */
    SetRageMeter(percent: number): void

    /**
     * Rig the result of Rock-Paper-Scissors.
     * @param {number} result (`0`=rock, `1`=paper, `2`=scissors)
     */
    SetRPSResult(result: number): void

    /**
     * Sets hype meter from 0 - 100.
     * @param {number} percent
     */
    SetScoutHypeMeter(percent: number): void

    /**
     * Sets cloakmeter from 0 - 100.
     * @param {number} percent
     */
    SetSpyCloakMeter(percent: number): void

    /**
     * Set the timestamp when kart was reversed.
     * @param {number} time
     */
    SetVehicleReverseTime(time: number): void

    /**
     * @param {boolean} toggle
     */
    SetUseBossHealthBar(toggle: boolean): void

    /**
     * Stops current taunt.
     * @param {boolean} remove_prop
     */
    StopTaunt(remove_prop: boolean): void

    /**
     * Stuns the player for a specified duration.
     * @param {number} duration
     * @param {number} move_speed_reduction
     * @param {number} flags See [Constants.TF_STUN](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TF_STUN)
     * @param {CBaseEntity|null} attacker
     */
    StunPlayer(duration: number, move_speed_reduction: number, flags: number, attacker: CBaseEntity|null): void

    /**
     * Performs a taunt if allowed.
     * @param {number} taunt_index See [Constants.FTaunts](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTaunts)
     * @param {number} taunt_concept See [Constants.MP_CONCEPT](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#MP_CONCEPT)
     */
    Taunt(taunt_index: number, taunt_concept: number): void

    /**
     * Make the player attempt to pick up a building in front of them.
     * @returns {boolean}
     */
    TryToPickupBuilding(): boolean

    /**
     * @param {number} skin
     */
    UpdateSkin(skin: number): void

    /**
     * @param {number} cond See [Constants.ETFCond](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFCond)
     * @returns {boolean}
     */
    WasInCond(cond: number): boolean

    /**
     * @param {CTFWeaponBase} weapon
     * @returns {boolean}
     */
    Weapon_CanUse(weapon: CTFWeaponBase): boolean

    /**
     * Equips a weapon in the player. Places it inside the `m_hMyWeapons` array.
     * @param {CTFWeaponBase} weapon
     */
    Weapon_Equip(weapon: CTFWeaponBase): void

    /**
     * @param {CTFWeaponBase} weapon
     */
    Weapon_SetLast(weapon: CTFWeaponBase): void

    /**
     * The same as calling `EyePosition`.
     * @returns {Vector}
     */
    Weapon_ShootPosition(): Vector

    /**
     * Attempts a switch to the given weapon, if present in the player's inventory.
     * @param {CTFWeaponBase} weapon
     */
    Weapon_Switch(weapon: CTFWeaponBase): void
}

/**
 * Script handle class for bot-controlled players (tf_bot).
 *
 * **Note**: Puppet bots do NOT inherit from this class.
 * @extends {CTFPlayer | NextBotCombatCharacter}
 */
interface CTFBot extends CTFPlayer {
    /**
     * Sets attribute flags on this TFBot.
     * @param {number} attribute See [Constants.FTFBotAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFBotAttributeType)
     */
    AddBotAttribute(attribute: number): void

    /**
     * Adds a bot tag.
     * @param {string} tag
     */
    AddBotTag(tag: string): void

    /**
     * Adds weapon restriction flags.
     * @param {number} flags See [Constants.TFBotWeaponRestrictionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBotWeaponRestrictionType)
     */
    AddWeaponRestriction(flags: number): void

    /**
     * Clears all attribute flags on this TFBot.
     */
    ClearAllBotAttributes(): void

    /**
     * Clears bot tags.
     */
    ClearAllBotTags(): void

    /**
     * Removes all weapon restriction flags.
     */
    ClearAllWeaponRestrictions(): void

    /**
     * Clear current focus.
     */
    ClearAttentionFocus(): void

    /**
     * Clear the given behavior flag(s) for this bot.
     * @param {number} flags See [Constants.TFBOT_BEHAVIOR](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBOT_BEHAVIOR)
     */
    ClearBehaviorFlag(flags: number): void

    /**
     * Notice the threat after a delay in seconds.
     * @param {CBaseEntity} threat
     * @param {number} delay
     */
    DelayedThreatNotice(threat: CBaseEntity, delay: number): void

    /**
     * Forces the current squad to be entirely disbanded by everyone.
     */
    DisbandCurrentSquad(): void

    /**
     * Get the nav area of the closest vantage point (within distance).
     * @param {number} max_distance
     * @returns {CTFNavArea|null}
     */
    FindVantagePoint(max_distance: number): CTFNavArea|null

    /**
     * Give me an item!
     * @param {string} item_name
     */
    GenerateAndWearItem(item_name: string): void

    /**
     * Get the given action point for this bot.
     * @returns {CBaseEntity|null}
     */
    GetActionPoint(): CBaseEntity|null

    /**
     * Get all bot tags. The key is the index, and the value is the tag.
     * @param {table} result
     */
    GetAllBotTags(result: table): void

    /**
     * Gets the home nav area of the bot.
     * @returns {CTFNavArea|null}
     */
    GetHomeArea(): CTFNavArea|null

    /**
     * Returns the bot's difficulty level.
     * @returns {number} See [Constants.ETFBotDifficultyType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotDifficultyType)
     */
    GetDifficulty(): number

    /**
     * Gets the max vision range override for the bot.
     * @returns {number}
     */
    GetMaxVisionRangeOverride(): number

    /**
     * Get this bot's current mission.
     * @returns {number} See [Constants.ETFBotMissionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotMissionType)
     */
    GetMission(): number

    /**
     * Get this bot's current mission target.
     * @returns {CBaseEntity|null}
     */
    GetMissionTarget(): CBaseEntity|null

    /**
     * Gets the nearest known sappable target.
     * @returns {CBaseEntity|null}
     */
    GetNearestKnownSappableTarget(): CBaseEntity|null

    /**
     * Get this bot's previous mission.
     * @returns {number} See [Constants.ETFBotMissionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotMissionType)
     */
    GetPrevMission(): number

    /**
     * Return the nav area of where we spawned.
     * @returns {CTFNavArea|null}
     */
    GetSpawnArea(): CTFNavArea|null

    /**
     * Gets our formation error coefficient.
     * @returns {number}
     */
    GetSquadFormationError(): number

    /**
     * Checks if this TFBot has the given attributes.
     * @param {number} attribute See [Constants.FTFBotAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFBotAttributeType)
     * @returns {boolean}
     */
    HasBotAttribute(attribute: number): boolean

    /**
     * Checks if this TFBot has the given bot tag.
     * @param {string} tag
     * @returns {boolean}
     */
    HasBotTag(tag: string): boolean

    /**
     * Return `true` if the given mission is this bot's current mission.
     * @param {number} mission See [Constants.ETFBotMissionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotMissionType)
     * @returns {boolean}
     */
    HasMission(mission: number): boolean

    /**
     * Checks if this TFBot has the given weapon restriction flags.
     * @param {number} flags See [Constants.TFBotWeaponRestrictionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBotWeaponRestrictionType)
     * @returns {boolean}
     */
    HasWeaponRestriction(flags: number): boolean

    /**
     * @returns {boolean}
     */
    IsAmmoFull(): boolean

    /**
     * @returns {boolean}
     */
    IsAmmoLow(): boolean

    /**
     * Is our attention focused right now?
     * @returns {boolean}
     */
    IsAttentionFocused(): boolean

    /**
     * Is our attention focused on this entity.
     * @param {CBaseEntity} entity
     * @returns {boolean}
     */
    IsAttentionFocusedOn(entity: CBaseEntity): boolean

    /**
     * Return `true` if the given behavior flag(s) are set for this bot.
     * @param {number} flags See [Constants.TFBOT_BEHAVIOR](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBOT_BEHAVIOR)
     * @returns {boolean}
     */
    IsBehaviorFlagSet(flags: number): boolean

    /**
     * Returns `true`/`false` if the bot's difficulty level matches.
     * @param {number} difficulty See [Constants.ETFBotDifficultyType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotDifficultyType)
     * @returns {boolean}
     */
    IsDifficulty(difficulty: number): boolean

    /**
     * Checks if we are in a squad.
     * @returns {boolean}
     */
    IsInASquad(): boolean

    /**
     * Return `true` if this bot has a current mission.
     * @returns {boolean}
     */
    IsOnAnyMission(): boolean

    /**
     * Checks if the given weapon is restricted for use on the bot.
     * @param {CBaseEntity} weapon
     * @returns {boolean}
     */
    IsWeaponRestricted(weapon: CBaseEntity): boolean

    /**
     * Makes us leave the current squad (if any).
     */
    LeaveSquad(): void

    /**
     * @param {number} duration Defaults to `-1.0`
     */
    PressAltFireButton(duration: number): void

    /**
     * @param {number} duration Defaults to `-1.0`
     */
    PressFireButton(duration: number): void

    /**
     * @param {number} duration Defaults to `-1.0`
     */
    PressSpecialFireButton(duration: number): void

    /**
     * Removes attribute flags on this TFBot.
     * @param {number} attribute See [Constants.FTFBotAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFBotAttributeType)
     */
    RemoveBotAttribute(attribute: number): void

    /**
     * Removes a bot tag.
     * @param {string} tag
     */
    RemoveBotTag(tag: string): void

    /**
     * Removes weapon restriction flags.
     * @param {number} flags See [Constants.TFBotWeaponRestrictionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBotWeaponRestrictionType)
     */
    RemoveWeaponRestriction(flags: number): void

    /**
     * Set the given action point for this bot.
     * @param {CBaseEntity|null} entity
     */
    SetActionPoint(entity: CBaseEntity|null): void

    /**
     * Sets our current attention focus to this entity.
     * @param {CBaseEntity|null} entity
     */
    SetAttentionFocus(entity: CBaseEntity|null): void

    /**
     * Sets if the bot should automatically jump, and how often.
     * @param {number} min_time
     * @param {number} max_time
     */
    SetAutoJump(min_time: number, max_time: number): void

    /**
     * Set the given behavior flag(s) for this bot.
     * @param {number} flags See [Constants.TFBOT_BEHAVIOR](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#TFBOT_BEHAVIOR)
     */
    SetBehaviorFlag(flags: number): void

    /**
     * Sets the bots difficulty level.
     * @param {number} difficulty See [Constants.ETFBotDifficultyType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotDifficultyType)
     */
    SetDifficulty(difficulty: number): void

    /**
     * Set the home nav area of the bot.
     * @param {CTFNavArea|null} area
     */
    SetHomeArea(area: CTFNavArea|null): void

    /**
     * Sets max vision range override for the bot.
     * @param {number} range
     */
    SetMaxVisionRangeOverride(range: number): void

    /**
     * Set this bot's current mission to the given mission.
     * @param {number} mission See [Constants.ETFBotMissionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotMissionType)
     * @param {boolean} reset_behavior
     */
    SetMission(mission: number, reset_behavior: boolean): void

    /**
     * Set this bot's mission target to the given entity.
     * @param {CBaseEntity|null} entity
     */
    SetMissionTarget(entity: CBaseEntity|null): void

    /**
     * Set this bot's previous mission to the given mission.
     * @param {number} mission See [Constants.ETFBotMissionType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFBotMissionType)
     */
    SetPrevMission(mission: number): void

    /**
     * Sets the scale override for the bot.
     * @param {number} scale
     */
    SetScaleOverride(scale: number): void

    /**
     * Sets if the bot should build instantly.
     * @param {boolean} toggle
     */
    SetShouldQuickBuild(toggle: boolean): void

    /**
     * Sets our formation error coefficient.
     * @param {number} coefficient
     */
    SetSquadFormationError(coefficient: number): void

    /**
     * Returns if the bot should automatically jump.
     * @returns {boolean}
     */
    ShouldAutoJump(): boolean

    /**
     * Returns if the bot should build instantly.
     * @returns {boolean}
     */
    ShouldQuickBuild(): boolean

    /**
     */
    UpdateDelayedThreatNotices(): void


    // Another multiple inheritance
    // From NextBotCombatCharacter
    /**
     * Clear immobile status.
     */
    ClearImmobileStatus(): void

    /**
     * Flag this bot for update.
     * Tip: Use in think to update nextbots faster than nb_update_frequency.
     * @param {boolean} toggle
     */
    FlagForUpdate(toggle: boolean): void

    /**
     * Get this bot's body interface.
     * @returns {INextBotComponent}
     */
    GetBodyInterface(): INextBotComponent

    /**
     * Get this bot's id.
     * @returns {number}
     */
    GetBotId(): number

    /**
     * How long have we been immobile.
     * @returns {number}
     */
    GetImmobileDuration(): number

    /**
     * Return units/second below which this actor is considered immobile.
     * @returns {number}
     */
    GetImmobileSpeedThreshold(): number

    /**
     * Get this bot's intention interface.
     * @returns {INextBotComponent}
     */
    GetIntentionInterface(): INextBotComponent

    /**
     * Get this bot's locomotion interface.
     * @returns {ILocomotion}
     */
    GetLocomotionInterface(): INextBotComponent

    /**
     * Get last update tick.
     * @returns {number}
     */
    GetTickLastUpdate(): number

    /**
     * Get this bot's vision interface.
     * @returns {INextBotComponent}
     */
    GetVisionInterface(): INextBotComponent

    /**
     * Return `true` if given entity is our enemy.
     * @param {CBaseEntity} entity
     * @returns {boolean}
     */
    IsEnemy(entity: CBaseEntity|null): boolean

    /**
     * Is this bot flagged for update.
     * @returns {boolean}
     */
    IsFlaggedForUpdate(): boolean

    /**
     * Return `true` if given entity is our friend.
     * @param {CBaseEntity} entity
     * @returns {boolean}
     */
    IsFriend(entity: CBaseEntity): boolean

    /**
     * Return `true` if we haven't moved in a while.
     * @returns {boolean}
     */
    IsImmobile(): boolean
}

/**
 * An interface to manipulate the convars on the server.
 *
 * **Note**: Protected convars (e.g. `rcon_password`) cannot be accessed.
 */
interface Convars {
    /**
     * Returns the convar as a bool. May return `null` if no such convar.
     * @param {string} name
     * @returns {boolean|null}
     */
    GetBool(name: string): boolean|null

    /**
     * Returns the convar value for the entindex as a string. Only works on `FCVAR_USERINFO` convars.
     * @param {string} name
     * @param {number} entindex
     * @returns {string}
     */
    GetClientConvarValue(name: string, entindex: number): string

    /**
     * Returns the convar as an integer. May return `null` if no such convar.
     *
     * **Warning**: The entire convar list is searched each time (slow). Cache results if used often.
     * @param {string} name
     * @returns {number|null}
     */
    GetInt(name: string): number|null

    /**
     * Returns the convar as a string. May return `null` if no such convar.
     *
     * **Warning**: The entire convar list is searched each time (slow). Cache results if used often.
     * @param {string} name
     * @returns {string|null}
     */
    GetStr(name: string): string|null

    /**
     * Returns the convar as a float. May return `null` if no such convar.
     *
     * **Warning**: The entire convar list is searched each time (slow). Cache results if used often.
     * @param {string} name
     * @returns {number|null}
     */
    GetFloat(name: string): number|null

    /**
     * Checks if the convar is allowed to be used (in cfg/vscript_convar_allowlist.txt).
     * @param {string} name
     * @returns {boolean}
     */
    IsConVarOnAllowList(name: string): boolean

    /**
     * Sets the value of the convar. The convar must be in cfg/vscript_convar_allowlist.txt.
     * The original value is saved and reset on map change.
     * @param {string} name
     * @param {number|string|boolean} value
     */
    SetValue(name: string, value: number|string|boolean): void
}

/**
 * An interface to find and iterate over the script handles for the entities in play.
 * Pass `null` to the previous parameter to start an iteration.
 */
interface CEntities {
    /**
     * Creates an entity by classname.
     * @param {string} classname
     * @returns {CBaseEntity|null} `null` if no entity type could be inferred.
     */
    CreateByClassname(classname: string): CBaseEntity|null

    /**
     * Dispatches spawn of an entity. Use this on entities created via `CreateByClassname`.
     * @param {CBaseEntity} entity
     */
    DispatchSpawn(entity: CBaseEntity): void

    /**
     * Find entities by classname. Pass `null` to start, or previous entity to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} classname
     * @returns {CBaseEntity|null}
     */
    FindByClassname(previous: CBaseEntity|null, classname: string): CBaseEntity|null

    /**
     * Find entities by classname nearest to a point within a radius.
     * @param {string} classname
     * @param {Vector} center
     * @param {number} radius
     * @returns {CBaseEntity|null}
     */
    FindByClassnameNearest(classname: string, center: Vector, radius: number): CBaseEntity|null

    /**
     * Find entities by classname within a radius. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} classname
     * @param {Vector} center
     * @param {number} radius
     * @returns {CBaseEntity|null}
     */
    FindByClassnameWithin(previous: CBaseEntity|null, classname: string, center: Vector, radius: number): CBaseEntity|null

    /**
     * Find entities by model keyvalue. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} model_name
     * @returns {CBaseEntity|null}
     */
    FindByModel(previous: CBaseEntity|null, model_name: string): CBaseEntity|null

    /**
     * Find entities by targetname keyvalue. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} targetname
     * @returns {CBaseEntity|null}
     */
    FindByName(previous: CBaseEntity|null, targetname: string): CBaseEntity|null

    /**
     * Find entities by targetname nearest to a point within a radius.
     * @param {string} targetname
     * @param {Vector} center
     * @param {number} radius
     * @returns {CBaseEntity|null}
     */
    FindByNameNearest(targetname: string, center: Vector, radius: number): CBaseEntity|null

    /**
     * Find entities by targetname within a radius. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} targetname
     * @param {Vector} center
     * @param {number} radius
     * @returns {CBaseEntity|null}
     */
    FindByNameWithin(previous: CBaseEntity|null, targetname: string, center: Vector, radius: number): CBaseEntity|null

    /**
     * Find entities by their target keyvalue. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {string} target
     * @returns {CBaseEntity|null}
     */
    FindByTarget(previous: CBaseEntity|null, target: string): CBaseEntity|null

    /**
     * Find entities within a radius. Pass `null` to start, or previous to continue.
     * @param {CBaseEntity|null} previous
     * @param {Vector} center
     * @param {number} radius
     * @returns {CBaseEntity|null}
     */
    FindInSphere(previous: CBaseEntity|null, center: Vector, radius: number): CBaseEntity|null

    /**
     * Begin an iteration over the list of entities. The first entity is always worldspawn.
     * @returns {CBaseEntity}
     */
    First(): CBaseEntity

    /**
     * Returns the next entity after the given one in the list.
     * @param {CBaseEntity} previous
     * @returns {CBaseEntity|null}
     */
    Next(previous: CBaseEntity): CBaseEntity|null
}

/**
 * Script handle class for areas part of the navigation mesh.
 */
interface CTFNavArea {
    /**
     * Add areas that connect TO this area by a ONE-WAY link.
     * @param {CTFNavArea} area
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     */
    AddIncomingConnection(area: CTFNavArea, dir: number): void

    /**
     * Clear TF-specific area attribute bits.
     * @param {number} bits See [Constants.FTFNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFNavAttributeType)
     */
    ClearAttributeTF(bits: number): void

    /**
     * Compute the closest point within the portal between areas.
     * @param {CTFNavArea} to
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @param {Vector} close_pos
     * @returns {Vector}
     */
    ComputeClosestPointInPortal(to: CTFNavArea, dir: number, close_pos: Vector): Vector

    /**
     * Return direction from this area to the given point.
     * @param {Vector} point
     * @returns {number}
     */
    ComputeDirection(point: Vector): number

    /**
     * Connect this area to given area in given direction.
     * @param {CTFNavArea} area
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     */
    ConnectTo(area: CTFNavArea, dir: number): void

    /**
     * Return `true` if other area is on or above this area, but no others.
     * @param {CTFNavArea} area
     * @returns {boolean}
     */
    Contains(area: CTFNavArea): boolean

    /**
     * Return `true` if given point is on or above this area, but no others.
     * @param {Vector} point
     * @returns {boolean}
     */
    ContainsOrigin(point: Vector): boolean

    /**
     * Draw area as a filled rectangle of the given color.
     * @param {number} r
     * @param {number} g
     * @param {number} b
     * @param {number} a
     * @param {number} duration
     * @param {boolean} no_depth_test
     * @param {number} margin
     */
    DebugDrawFilled(r: number, g: number, b: number, a: number, duration: number, no_depth_test: boolean, margin: number): void

    /**
     * Disconnect this area from given area.
     * @param {CTFNavArea} area
     */
    Disconnect(area: CTFNavArea): void

    /**
     * Get random origin within extent of area.
     * @returns {Vector}
     */
    FindRandomSpot(): Vector

    /**
     * Return the n'th adjacent area in the given direction.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @param {number} n
     * @returns {CTFNavArea|null}
     */
    GetAdjacentArea(dir: number, n: number): CTFNavArea|null

    /**
     * Fills a passed in table with all adjacent areas in the given direction.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @param {table} result
     */
    GetAdjacentAreas(dir: number, result: table): void

    /**
     * Get the number of adjacent areas in the given direction.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @returns {number}
     */
    GetAdjacentCount(dir: number): number

    /**
     * Get area attribute bits.
     * @returns {number} See [Constants.FNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FNavAttributeType)
     */
    GetAttributes(): number

    /**
     * Returns the maximum height of the obstruction above the ground.
     * @returns {number}
     */
    GetAvoidanceObstacleHeight(): number

    /**
     * Get center origin of area.
     * @returns {Vector}
     */
    GetCenter(): Vector

    /**
     * Get corner origin of area.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @returns {Vector}
     */
    GetCorner(dir: number): Vector

    /**
     * Return shortest distance between point and this area.
     * @param {Vector} pos
     * @returns {number}
     */
    GetDistanceSquaredToPoint(pos: Vector): number

    /**
     * Returns the door entity above the area.
     * @returns {CBaseAnimating|null}
     */
    GetDoor(): CBaseAnimating|null

    /**
     * Returns the elevator if in an elevator's path.
     * @returns {CBaseAnimating|null}
     */
    GetElevator(): CBaseAnimating|null

    /**
     * Fills table with a collection of areas reachable via elevator from this area.
     * @param {table} result
     */
    GetElevatorAreas(result: table): void

    /**
     * Get area ID.
     * @returns {number}
     */
    GetID(): number

    /**
     * Fills a passed in table with areas connected TO this area by a ONE-WAY link.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @param {table} result
     */
    GetIncomingConnections(dir: number, result: table): void

    /**
     * Returns the area just prior to this one in the search path.
     * @returns {CTFNavArea|null}
     */
    GetParent(): CTFNavArea|null

    /**
     * Returns how we get from parent to us.
     * @returns {number}
     */
    GetParentHow(): number

    /**
     * Get place name if it exists, `null` otherwise.
     * @returns {string|null}
     */
    GetPlaceName(): string|null

    /**
     * Return number of players of given team currently within this area (`0` = any/all).
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @returns {number}
     */
    GetPlayerCount(team: number): number

    /**
     * Return a random adjacent area in the given direction.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @returns {CTFNavArea|null}
     */
    GetRandomAdjacentArea(dir: number): CTFNavArea|null

    /**
     * Return the area size along the X axis.
     * @returns {number}
     */
    GetSizeX(): number

    /**
     * Return the area size along the Y axis.
     * @returns {number}
     */
    GetSizeY(): number

    /**
     * Gets the travel distance to the MvM bomb target.
     * @returns {number}
     */
    GetTravelDistanceToBombTarget(): number

    /**
     * Return Z of area at (x,y) of 'pos'.
     * @param {Vector} pos
     * @returns {number}
     */
    GetZ(pos: Vector): number

    /**
     * Has TF-specific area attribute bits of the given ones.
     * @param {number} bits See [Constants.FTFNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFNavAttributeType)
     * @returns {boolean}
     */
    HasAttributeTF(bits: number): boolean

    /**
     * Has area attribute bits of the given ones.
     * @param {number} bits See [Constants.FNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FNavAttributeType)
     * @returns {boolean}
     */
    HasAttributes(bits: number): boolean

    /**
     * Returns `true` if there's a large, immobile object obstructing this area.
     * @param {number} max_height
     * @returns {boolean}
     */
    HasAvoidanceObstacle(max_height: number): boolean

    /**
     * Return `true` if team is blocked in this area.
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @param {boolean} affects_flow
     * @returns {boolean}
     */
    IsBlocked(team: number, affects_flow: boolean): boolean

    /**
     * Returns `true` if area is a bottleneck.
     * @returns {boolean}
     */
    IsBottleneck(): boolean

    /**
     * Return `true` if given area is completely visible from somewhere in this area.
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @returns {boolean}
     */
    IsCompletelyVisibleToTeam(team: number): boolean

    /**
     * Return `true` if this area is connected to other area in given direction.
     * @param {CBaseEntity} area
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @returns {boolean}
     */
    IsConnected(area: CTFNavArea, dir: number): boolean

    /**
     * Return `true` if this area and given area are approximately co-planar.
     * @param {CBaseEntity} area
     * @returns {boolean}
     */
    IsCoplanar(area: CTFNavArea): boolean

    /**
     * Return `true` if this area is marked to have continuous damage.
     * @returns {boolean}
     */
    IsDamaging(): boolean

    /**
     * Return `true` if this area is badly formed.
     * @returns {boolean}
     */
    IsDegenerate(): boolean

    /**
     * Return `true` if there are no bi-directional links on the given side.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     * @returns {boolean}
     */
    IsEdge(dir: number): boolean

    /**
     * Return `true` if this area is approximately flat.
     * @returns {boolean}
     */
    IsFlat(): boolean

    /**
     * Return `true` if `area` overlaps our 2D extents.
     * @param {CBaseEntity} area
     * @returns {boolean}
     */
    IsOverlapping(area: CTFNavArea): boolean

    /**
     * Return `true` if `pos` is within 2D extents of area.
     * @param {Vector} pos
     * @param {number} tolerance
     * @returns {boolean}
     */
    IsOverlappingOrigin(pos: Vector, tolerance: number): boolean

    /**
     * Return `true` if any portion of this area is visible to anyone on the given team.
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @returns {boolean}
     */
    IsPotentiallyVisibleToTeam(team: number): boolean

    /**
     * Is this area reachable by the given team?
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @returns {boolean}
     */
    IsReachableByTeam(team: number): boolean

    /**
     * Return `true` if this area is approximately square.
     * @returns {boolean}
     */
    IsRoughlySquare(): boolean

    /**
     * Is this nav area marked with the current marking scope?
     * @returns {boolean}
     */
    IsTFMarked(): boolean

    /**
     * Return `true` if area is underwater.
     * @returns {boolean}
     */
    IsUnderwater(): boolean

    /**
     * Returns `true` if area is valid for wandering population.
     * @returns {boolean}
     */
    IsValidForWanderingPopulation(): boolean

    /**
     * Return `true` if area is visible from the given eyepoint.
     * @param {Vector} point
     * @returns {boolean}
     */
    IsVisible(point: Vector): boolean

    /**
     * Mark this area as blocked for team.
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     */
    MarkAsBlocked(team: number): void

    /**
     * Mark this area is damaging for the next 'duration' seconds.
     * @param {number} duration
     */
    MarkAsDamaging(duration: number): void

    /**
     * Marks the obstructed status of the nav area.
     * @param {number} height
     */
    MarkObstacleToAvoid(height: number): void

    /**
     * Removes area attribute bits.
     * @param {number} bits See [Constants.FNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FNavAttributeType)
     */
    RemoveAttributes(bits: number): void

    /**
     * Removes all connections in directions to left and right of specified direction.
     * @param {number} dir See [Constants.ENavDirType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ENavDirType)
     */
    RemoveOrthogonalConnections(dir: number): void

    /**
     * Set TF-specific area attributes.
     * @param {number} bits See [Constants.FTFNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FTFNavAttributeType)
     */
    SetAttributeTF(bits: number): void

    /**
     * Set area attribute bits.
     * @param {number} bits See [Constants.FNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FNavAttributeType)
     */
    SetAttributes(bits: number): void

    /**
     * Set place name. Pass `null` to clear.
     * @param {string} name
     */
    SetPlaceName(name: string): void

    /**
     * Mark this nav area with the current marking scope.
     */
    TFMark(): void

    /**
     * Unblocks this area.
     */
    UnblockArea(): void
}

/**
 * An interface to collect nav areas from, especially for pathfinding needs.
 */
interface CNavMesh {
    /**
     * Get nav area from ray.
     * @param {Vector} start_pos
     * @param {Vector} end_pos
     * @param {CTFNavArea|null} ignore_area
     * @returns {CTFNavArea|null}
     */
    FindNavAreaAlongRay(start_pos: Vector, end_pos: Vector, ignore_area: CTFNavArea|null): CTFNavArea|null

    /**
     * Fills a passed in table of all nav areas.
     * @param {table} result Resulting shape: `{"area0": CTFNavArea, "area1": CTFNavArea, ...}`
     */
    GetAllAreas(result: table): void

    /**
     * Fills a passed in table of all nav areas that have the specified attributes.
     * @param {number} bits See [Constants.FNavAttributeType](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#FNavAttributeType)
     * @param {table} result
     */
    GetAreasWithAttributes(bits: number, result: table): void

    /**
     * Given a position in the world, return the nav area closest to or below that height.
     * @param {Vector} origin
     * @param {number} beneath
     * @returns {CTFNavArea|null}
     */
    GetNavArea(origin: Vector, beneath: number): CTFNavArea|null

    /**
     * Get nav area by ID.
     * @param {number} area_id
     * @returns {CTFNavArea|null}
     */
    GetNavAreaByID(area_id: number): CTFNavArea|null

    /**
     * Return total number of nav areas.
     * @returns {number}
     */
    GetNavAreaCount(): number

    /**
     * Fills the table with areas from a path.
     *
     * **Note**: The areas are passed from end area to the start area.
     * @param {CTFNavArea} start_area
     * @param {CTFNavArea} end_area
     * @param {Vector} goal_pos
     * @param {number} max_path_length
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @param {boolean} ignore_nav_blockers
     * @param {table} result
     * @returns {boolean} Whether a path was found.
     */
    GetNavAreasFromBuildPath(start_area: CTFNavArea, end_area: CTFNavArea, goal_pos: Vector, max_path_length: number, team: number, ignore_nav_blockers: boolean, result: table): boolean

    /**
     * Fills a passed in table of nav areas within radius.
     * @param {Vector} origin
     * @param {number} radius
     * @param {table} result
     */
    GetNavAreasInRadius(origin: Vector, radius: number, result: table): void

    /**
     * Fills passed in table with areas overlapping entity's extent.
     * @param {CBaseEntity} entity
     * @param {table} result
     */
    GetNavAreasOverlappingEntityExtent(entity: CBaseEntity, result: table): void

    /**
     * Given a position in the world, return the nav area closest to or below that height.
     * @param {Vector} origin
     * @param {number} max_distance
     * @param {boolean} check_los
     * @param {boolean} check_ground
     * @returns {CTFNavArea|null}
     */
    GetNearestNavArea(origin: Vector, max_distance: number, check_los: boolean, check_ground: boolean): CTFNavArea|null

    /**
     * Fills a passed in table of all obstructing entities.
     * @param {table} result
     */
    GetObstructingEntities(result: table): void

    /**
     * Returns `true` if a path exists.
     * @param {CTFNavArea} start_area
     * @param {CTFNavArea} end_area
     * @param {Vector} goal_pos
     * @param {number} max_path_length
     * @param {number} team See [Constants.ETFTeam](https://developer.valvesoftware.com/wiki/Team_Fortress_2/Scripting/Script_Functions/Constants#ETFTeam)
     * @param {boolean} ignore_nav_blockers
     * @returns {boolean}
     */
    NavAreaBuildPath(start_area: CTFNavArea, end_area: CTFNavArea, goal_pos: Vector, max_path_length: number, team: number, ignore_nav_blockers: boolean): boolean

    /**
     * Compute distance between two areas.
     * @param {CTFNavArea} start_area
     * @param {CTFNavArea} end_area
     * @param {number} max_path_length
     * @returns {number} `-1.0` if can't reach `end_area` from `start_area`.
     */
    NavAreaTravelDistance(start_area: CTFNavArea, end_area: CTFNavArea, max_path_length: number): number

    /**
     * Registers avoidance obstacle.
     * @param {CBaseEntity} entity
     */
    RegisterAvoidanceObstacle(entity: CBaseEntity): void

    /**
     * Unregisters avoidance obstacle.
     * @param {CBaseEntity} entity
     */
    UnregisterAvoidanceObstacle(entity: CBaseEntity): void
}

/**
 * Allows reading and updating the network properties and data-maps of an entity.
 */
interface CNetPropManager {
    /**
     * Returns the size of a netprop array, or `-1`.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {number}
     */
    GetPropArraySize(entity: CBaseEntity, property_name: string): number

    /**
     * Reads an `EHANDLE`-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {CBaseEntity|null} `null` if property is not found.
     */
    GetPropEntity(entity: CBaseEntity, property_name: string): CBaseEntity|null

    /**
     * Reads an `EHANDLE`-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {CBaseEntity|null} `null` if not found.
     */
    GetPropEntityArray(entity: CBaseEntity, property_name: string, array_element: number): CBaseEntity|null

    /**
     * Reads a boolean-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {boolean} `false` if property is not found.
     */
    GetPropBool(entity: CBaseEntity, property_name: string): boolean

    /**
     * Reads a boolean-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {boolean} `false` if not found.
     */
    GetPropBoolArray(entity: CBaseEntity, property_name: string, array_element: number): boolean

    /**
     * Reads a float-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {number} `-1.0` if property is not found.
     */
    GetPropFloat(entity: CBaseEntity, property_name: string): number

    /**
     * Reads a float-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {number} `-1.0` if not found.
     */
    GetPropFloatArray(entity: CBaseEntity, property_name: string, array_element: number): number

    /**
     * Fills in a passed table with property info for the provided entity.
     * @param {CBaseEntity} entity
     * @param {property} property_name
     * @param {number} array_element
     * @param {table} result
     * @returns {boolean}
     */
    GetPropInfo(entity: CBaseEntity, property_name: string, array_element: number, result: table): boolean

    /**
     * Reads an integer-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {number} `-1` if property is not found.
     */
    GetPropInt(entity: CBaseEntity, property_name: string): number

    /**
     * Reads an integer-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {number} `-1` if not found.
     */
    GetPropIntArray(entity: CBaseEntity, property_name: string, array_element: number): number

    /**
     * Reads a string-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {string} Empty string if property is not found.
     */
    GetPropString(entity: CBaseEntity, property_name: string): string

    /**
     * Reads a string-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {string} Empty string if not found.
     */
    GetPropStringArray(entity: CBaseEntity, property_name: string, array_element: number): string

    /**
     * Returns the name of the netprop type as a string.
     * @param {CBaseEntity} entity
     * @param {property} property_name
     * @returns {string|null} `null` if not found.
     */
    GetPropType(entity: CBaseEntity, property_name: string): string|null

    /**
     * Reads a 3D vector-valued netprop.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @returns {Vector} `Vector(0,0,0)` if not found.
     */
    GetPropVector(entity: CBaseEntity, property_name: string): Vector

    /**
     * Reads a 3D vector-valued netprop from an array.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} array_element
     * @returns {Vector} `Vector(0,0,0)` if not found.
     */
    GetPropVectorArray(entity: CBaseEntity, property_name: string, array_element: number): Vector

    /**
     * Fills in a passed table with all props of a specified type.
     * @param {CBaseEntity} entity
     * @param {number} prop_type `0` = SendTable, `1` = DataMap.
     * @param {table} result
     */
    GetTable(entity: CBaseEntity, prop_type: number, result: table): void

    /**
     * Checks if a netprop exists.
     * @param {CBaseEntity} entity
     * @param {property} property_name
     * @returns {boolean}
     */
    HasProp(entity: CBaseEntity, property_name: string): boolean

    /**
     * Sets a netprop to the specified boolean.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {boolean} value
     */
    SetPropBool(entity: CBaseEntity, property_name: string, value: boolean): void

    /**
     * Sets a netprop from an array to the specified boolean.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {boolean} value
     * @param {number} array_element
     */
    SetPropBoolArray(entity: CBaseEntity, property_name: string, value: boolean, array_element: number): void

    /**
     * Sets an `EHANDLE`-valued netprop to reference the specified entity.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {CBaseEntity|null} value
     */
    SetPropEntity(entity: CBaseEntity, property_name: string, value: CBaseEntity): void

    /**
     * Sets an `EHANDLE`-valued netprop from an array to reference the specified entity.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {CBaseEntity|null} value
     * @param {number} array_element
     */
    SetPropEntityArray(entity: CBaseEntity, property_name: string, value: CBaseEntity, array_element: number): void

    /**
     * Sets a netprop to the specified float.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} value
     */
    SetPropFloat(entity: CBaseEntity, property_name: string, value: number): void

    /**
     * Sets a netprop from an array to the specified float.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} value
     * @param {number} array_element
     */
    SetPropFloatArray(entity: CBaseEntity, property_name: string, value: number, array_element: number): void

    /**
     * Sets a netprop to the specified integer.
     *
     * **Warning**: Do not override `m_iTeamNum` netprops on players or Engineer buildings permanently.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} value
     */
    SetPropInt(entity: CBaseEntity, property_name: string, value: number): void

    /**
     * Sets a netprop from an array to the specified integer.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {number} value
     * @param {number} array_element
     */
    SetPropIntArray(entity: CBaseEntity, property_name: string, value: number, array_element: number): void

    /**
     * Sets a netprop to the specified string.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {string|null} value
     */
    SetPropString(entity: CBaseEntity, property_name: string, value: string): void

    /**
     * Sets a netprop from an array to the specified string.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {string|null} value
     * @param {number} array_element
     */
    SetPropStringArray(entity: CBaseEntity, property_name: string, value: string, array_element: number): void

    /**
     * Sets a netprop to the specified vector.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {Vector} value
     */
    SetPropVector(entity: CBaseEntity, property_name: string, value: Vector): void

    /**
     * Sets a netprop from an array to the specified vector.
     * @param {CBaseEntity} entity
     * @param {string} property_name
     * @param {Vector} value
     * @param {number} array_element
     */
    SetPropVectorArray(entity: CBaseEntity, property_name: string, value: Vector, array_element: number): void
}


/**
 * Allows reading and manipulation of entity output data.
 */
interface CScriptEntityOutputs {
    /**
     * Adds a new output to the entity.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @param {string} targetname
     * @param {string} input_name
     * @param {string|null} parameter
     * @param {number} delay
     * @param {number} times_to_fire
     */
    AddOutput(entity: CBaseEntity, output_name: string, targetname: string, input_name: string, parameter: string|null, delay: number, times_to_fire: number): void

    /**
     * Returns the number of array elements.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @returns {number}
     */
    GetNumElements(entity: CBaseEntity, output_name: string): number

    /**
     * Fills the passed table with output information.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @param {table} result
     * @param {number} array_element
     */
    GetOutputTable(entity: CBaseEntity, output_name: string, result: table, array_element: number): void

    /**
     * Returns `true` if an action exists for the output.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @returns {boolean}
     */
    HasAction(entity: CBaseEntity, output_name: string): boolean

    /**
     * Returns `true` if the output exists.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @returns {boolean}
     */
    HasOutput(entity: CBaseEntity, output_name: string): boolean

    /**
     * Removes an output from the entity.
     * @param {CBaseEntity} entity
     * @param {string} output_name
     * @param {string} targetname
     * @param {string} input_name
     * @param {string|null} parameter
     */
    RemoveOutput(entity: CBaseEntity, output_name: string, targetname: string, input_name: string, parameter: string|null): void
}

/**
 * Script handle representation of a model's $keyvalues block.
 */
interface CScriptKeyValues {
    /**
     * Find a sub key by the key name.
     * @param {string} key
     * @returns {CScriptKeyValues|null}
     */
    FindKey(key: string): CScriptKeyValues|null

    /**
     * Return the first sub key object.
     * @returns {CScriptKeyValues|null}
     */
    GetFirstSubKey(): CScriptKeyValues|null

    /**
     * Return the key value as a bool.
     * @param {string} key
     * @returns {boolean}
     */
    GetKeyBool(key: string): boolean

    /**
     * Return the key value as a float.
     * @param {string} key
     * @returns {number}
     */
    GetKeyFloat(key: string): number

    /**
     * Return the key value as an integer.
     * @param {string} key
     * @returns {number}
     */
    GetKeyInt(key: string): number

    /**
     * Return the key value as a string.
     * @param {string} key
     * @returns {string}
     */
    GetKeyString(key: string): string

    /**
     * Return the next neighbor key object.
     * @returns {CScriptKeyValues|null}
     */
    GetNextKey(): CScriptKeyValues|null

    /**
     * Returns `true` if the named key has no value.
     * @param {string} key
     * @returns {boolean}
     */
    IsKeyEmpty(key: string): boolean

    /**
     * Whether the handle belongs to a valid key.
     * @returns {boolean}
     */
    IsValid(): boolean

    /**
     * Releases the contents of the instance.
     */
    ReleaseKeyValues(): void
}

/**
 * Tracks if any player is using voice and for how long.
 */
interface CPlayerVoiceListener {
    /**
     * Returns the number of seconds the player has been continuously speaking.
     * @param {number} player_index
     * @returns {number}
     */
    GetPlayerSpeechDuration(player_index: number): number

    /**
     * Returns whether the player specified is speaking.
     * @param {number} player_index
     * @returns {boolean}
     */
    IsPlayerSpeaking(player_index: number): boolean
}

/**
 * Script handle class for env_entity_maker.
 */
interface CEnvEntityMaker extends CBaseEntity {
    /**
     * Create an entity at the location of the maker.
     */
    SpawnEntity(): void

    /**
     * Create an entity at the location of a specified entity instance.
     * @param {CBaseEntity} entity
     */
    SpawnEntityAtEntityOrigin(entity: CBaseEntity): void

    /**
     * Create an entity at a specified location and orientation.
     * @param {Vector} origin
     * @param {Vector} orientation Euler angle in degrees (pitch, yaw, roll)
     */
    SpawnEntityAtLocation(origin: Vector, orientation: Vector): void

    /**
     * Create an entity at the location of a named entity.
     * @param {string} targetname
     */
    SpawnEntityAtNamedEntityOrigin(targetname: string): void
}

/**
 * Script handle class for func_tracktrain.
 */
interface CFuncTrackTrain extends CBaseEntity {
    /**
     * Get a position on the track X seconds in the future.
     * @param {number} x
     * @param {number} speed
     * @returns {Vector}
     */
    GetFuturePosition(x: number, speed: number): Vector
}


/**
 * Script handle class for scripted_scene (VCD data).
 */
interface CSceneEntity extends CBaseEntity {
    /**
     * Adds a team (by index) to the broadcast list.
     * @param {number} index
     */
    AddBroadcastTeamTarget(index: number): void

    /**
     * Returns length of this scene in seconds.
     * @returns {number}
     */
    EstimateLength(): number

    /**
     * Given an entity reference such as !target, get actual entity from scene object.
     * @param {string} reference
     * @returns {CBaseEntity|null}
     */
    FindNamedEntity(reference: string): CBaseEntity|null

    /**
     * If this scene is currently paused.
     * @returns {boolean}
     */
    IsPaused(): boolean

    /**
     * If this scene is currently playing.
     * @returns {boolean}
     */
    IsPlayingBack(): boolean

    /**
     * Given a dummy scene name and a vcd string, load the scene.
     * @param {string} scene_name
     * @param {string} scene
     * @returns {boolean}
     */
    LoadSceneFromString(scene_name: string, scene: string): boolean

    /**
     * Removes a team (by index) from the broadcast list.
     * @param {number} index
     */
    RemoveBroadcastTeamTarget(index: number): void
}

interface CCallChainer {
    /**
     * Contains names of unprefixed functions, each with an array of functions to call.
     * @type {table}
     */
    chains: table

    /**
     * Prefix that functions should have to be added into the chains table. Set by the constructor.
     * @type {string}
     */
    prefix: string

    /**
     * If set, seek functions in this scope instead. Set by the constructor.
     * @type {table|null}
     */
    scope: table|null

    /**
     * Creates a CCallChainer object that'll collect functions that have a matching prefix in the given scope.
     * @param {string} function_prefix
     * @param {table|null} scope Defaults to `null`
     */
    constructor(function_prefix: string, scope: table|null): void

    /**
     * Search for all non-native functions with matching prefixes, then push them into the chains table.
     */
    PostScriptExecute(): void

    /**
     * Find an unprefixed name in the chains table and call it with the given arguments.
     * @param {string} event
     * @varargs {any}
     * @returns {boolean}
     */
    Call(event: string, []: any): boolean
}

interface CSimpleCallChainer {
	    /**
     * All functions to be called by the Call() method.
     * @type {any[]}
     */
    chains: any[]

    /**
     * If set, names of non-native functions and prefix must be an exact match. Set by the constructor.
     * @type {boolean}
     */
    exact_match: boolean

    /**
     * Prefix that functions should have to be added into the chain array. Set by the constructor.
     * @type {string}
     */
    prefix: string

    /**
     * If set, seek functions in this scope instead. Set by the constructor.
     * @type {table|null}
     */
    scope: table|null

	/**
     * Creates a CSimpleCallChainer object that'll collect functions that have a matching prefix in the given scope, unless it seek for an exact name match.
     * @param {string} function_prefix
     * @param {table|null} scope Defaults to `null`
     * @param {boolean} exactMatch Defaults to `false`
     */
    constructor(function_prefix: string, scope: table|null, exactMatch: boolean): void

	/**
     * Begin searching for all non-native functions with matching prefixes, then push them into the chain array.
     */
    PostScriptExecute(): void

    /**
     * Call all functions inside the chain array with the given arguments.
     * @varargs {any}
     * @returns {boolean}
     */
    Call([]): boolean
}

/**
 * Script handle class for non-playable combat characters operating under the NextBot system.
 */
interface NextBotCombatCharacter extends CBaseCombatCharacter {
    /**
     * Clear immobile status.
     */
    ClearImmobileStatus(): void

    /**
     * Flag this bot for update.
     * Tip: Use in think to update nextbots faster than nb_update_frequency.
     * @param {boolean} toggle
     */
    FlagForUpdate(toggle: boolean): void

    /**
     * Get this bot's body interface.
     * @returns {INextBotComponent}
     */
    GetBodyInterface(): INextBotComponent

    /**
     * Get this bot's id.
     * @returns {number}
     */
    GetBotId(): number

    /**
     * How long have we been immobile.
     * @returns {number}
     */
    GetImmobileDuration(): number

    /**
     * Return units/second below which this actor is considered immobile.
     * @returns {number}
     */
    GetImmobileSpeedThreshold(): number

    /**
     * Get this bot's intention interface.
     * @returns {INextBotComponent}
     */
    GetIntentionInterface(): INextBotComponent

    /**
     * Get this bot's locomotion interface.
     * @returns {ILocomotion}
     */
    GetLocomotionInterface(): ILocomotion

    /**
     * Get last update tick.
     * @returns {number}
     */
    GetTickLastUpdate(): number

    /**
     * Get this bot's vision interface.
     * @returns {INextBotComponent}
     */
    GetVisionInterface(): INextBotComponent

    /**
     * Return `true` if given entity is our enemy.
     * @param {CBaseEntity} entity
     * @returns {boolean}
     */
    IsEnemy(entity: CBaseEntity): boolean

    /**
     * Is this bot flagged for update.
     * @returns {boolean}
     */
    IsFlaggedForUpdate(): boolean

    /**
     * Return `true` if given entity is our friend.
     * @param {CBaseEntity} entity
     * @returns {boolean}
     */
    IsFriend(entity: CBaseEntity): boolean

    /**
     * Return `true` if we haven't moved in a while.
     * @returns {boolean}
     */
    IsImmobile(): boolean
}

/**
 * Base class intended for custom NPCs. Officially used as part of MvM tank.
 */
interface CTFBaseBoss extends NextBotCombatCharacter {
    /**
     * Sets whether the entity should push away players intersecting its bounding box. On by default.
     * @param {boolean} toggle
     */
    SetResolvePlayerCollisions(toggle: boolean): void
}

/**
 * Base script handle class for any interfaces belonging to a NextBotCombatCharacter entity.
 */
interface INextBotComponent {
    /**
     * Recomputes the component update interval.
     * @returns {boolean}
     */
    ComputeUpdateInterval(): boolean

    /**
     * Returns the component update interval.
     * @returns {number}
     */
    GetUpdateInterval(): number

    /**
     * Resets the internal update state.
     */
    Reset(): void
}

/**
 * The interface for interacting with a specific NextBot's movement brain.
 */
interface ILocomotion extends INextBotComponent {
    /**
     * The primary locomotive method. Move towards goal position.
     * Tip: Put in a think to make the entity move smoothly.
     * @param {Vector} goal
     * @param {number} goal_weight
     */
    Approach(goal: Vector, goal_weight: number): void

    /**
     * Reset stuck status to un-stuck.
     * @param {string} reason
     */
    ClearStuckStatus(reason: string): void

    /**
     * Initiate a jump to an adjacent high ledge.
     * @param {Vector} goal_pos
     * @param {Vector} goal_forward
     * @param {CBaseEntity} obstacle
     * @returns {boolean} `false` if climb can't start.
     */
    ClimbUpToLedge(goal_pos: Vector, goal_forward: Vector, obstacle: CBaseEntity): boolean

    /**
     * Returns `false` if no time has elapsed.
     * @returns {boolean}
     */
    ComputeUpdateInterval(): boolean

    /**
     * Move the bot to the precise given position immediately, updating internal state.
     * @param {Vector} pos
     */
    DriveTo(pos: Vector): void

    /**
     * Rotate body to face towards target.
     * Tip: Put in a think for smooth rotation.
     * @param {Vector} target
     */
    FaceTowards(target: Vector): void

    /**
     * If the locomotor cannot jump over the gap, returns the fraction of the jumpable ray.
     * @param {Vector} from
     * @param {Vector} to
     * @returns {number}
     */
    FractionPotentialGap(from:Vector, to: Vector): number

    /**
     * If the locomotor could not move along the line given, returns the fraction of the walkable ray.
     * @param {Vector} from
     * @param {Vector} to
     * @param {boolean} immediately
     * @returns {number}
     */
    FractionPotentiallyTraversable(from: Vector, to: Vector, immediately: boolean): number

    /**
     * Distance at which we will die if we fall.
     * @returns {number}
     */
    GetDeathDropHeight(): number

    /**
     * Get desired speed for locomotor movement.
     * @returns {number}
     */
    GetDesiredSpeed(): number

    /**
     * Return position of feet - the driving point where the bot contacts the ground.
     * @returns {Vector}
     */
    GetFeet(): Vector

    /**
     * Return the current ground entity or `null` if not on the ground.
     * @returns {CBaseEntity|null}
     */
    GetGround(): CBaseEntity|null

    /**
     * Return unit vector in XY plane describing direction of motion.
     * @returns {Vector}
     */
    GetGroundMotionVector(): Vector

    /**
     * Surface normal of the ground we are in contact with.
     * @returns {Vector}
     */
    GetGroundNormal(): Vector

    /**
     * Return current world space speed in XY plane.
     * @returns {number}
     */
    GetGroundSpeed(): number

    /**
     * Return maximum acceleration of locomotor.
     * @returns {number}
     */
    GetMaxAcceleration(): number

    /**
     * Return maximum deceleration of locomotor.
     * @returns {number}
     */
    GetMaxDeceleration(): number

    /**
     * Return maximum height of a jump.
     * @returns {number}
     */
    GetMaxJumpHeight(): number

    /**
     * Return unit vector describing our direction of motion.
     * @returns {Vector}
     */
    GetMotionVector(): Vector

    /**
     * Get maximum running speed.
     * @returns {number}
     */
    GetRunSpeed(): number

    /**
     * Return current world space speed (magnitude of velocity).
     * @returns {number}
     */
    GetSpeed(): number

    /**
     * Get maximum speed bot can reach, regardless of desired speed.
     * @returns {number}
     */
    GetSpeedLimit(): number

    /**
     * If delta Z is lower than this, we can step up the surface otherwise we have to jump.
     * @returns {number}
     */
    GetStepHeight(): number

    /**
     * Return how long we've been stuck.
     * @returns {number}
     */
    GetStuckDuration(): number

    /**
     * Return Z component of unit normal of steepest traversable slope.
     * @returns {number}: number
     */
    GetTraversableSlopeLimit(): number

    /**
     * Returns time between updates.
     * @returns {number}
     */
    GetUpdateInterval(): number

    /**
     * Return current world space velocity.
     * @returns {Vector}
     */
    GetVelocity(): Vector

    /**
     * Get maximum walking speed.
     * @returns {number}
     */
    GetWalkSpeed(): number

    /**
     * Checks if there is a possible gap that will need to be jumped over.
     * @param {Vector} from
     * @param {Vector} to
     * @returns {number}
     */
    HasPotentialGap(from: Vector, to: Vector): number

    /**
     * Return `true` if this bot can climb arbitrary geometry it encounters.
     * @returns {boolean}
     */
    IsAbleToClimb(): boolean

    /**
     * Return `true` if this bot can jump across gaps in its path.
     * @returns {boolean}
     */
    IsAbleToJumpAcrossGaps(): boolean

    /**
     * Return `true` if given area can be used for navigation.
     * @param {CBaseEntity} area
     * @returns {boolean}
     */
    IsAreaTraversable(area: CBaseEntity): boolean

    /**
     * Return `true` if we have tried to `Approach()` or `DriveTo()` very recently.
     * @returns {boolean}
     */
    IsAttemptingToMove(): boolean

    /**
     * Is jumping in any form.
     * @returns {boolean}
     */
    IsClimbingOrJumping(): boolean

    /**
     * Is climbing up to a high ledge.
     * @returns {boolean}
     */
    IsClimbingUpToLedge(): boolean

    /**
     * Return `true` if the entity handle is traversable.
     * @param {CBaseEntity} entity
     * @param {boolean} immediately
     * @returns {boolean}
     */
    IsEntityTraversable(entity: CBaseEntity, immediately: boolean): boolean

    /**
     * Return `true` if there is a gap at this position.
     * @param {Vector} pos
     * @param {Vector} forward
     * @returns {boolean}
     */
    IsGap(pos: Vector, forward: Vector): boolean

    /**
     * Is jumping across a gap to the far side.
     * @returns {boolean}
     */
    IsJumpingAcrossGap(): boolean

    /**
     * Return `true` if standing on something.
     * @returns {boolean}
     */
    IsOnGround(): boolean

    /**
     * Checks if this locomotor could potentially move along the line given.
     * @param {Vector} from
     * @param {Vector} to
     * @param {boolean} immediately
     * @returns {number}
     */
    IsPotentiallyTraversable(from: Vector, to: Vector, immediately: boolean): boolean

    /**
     * Is running?
     * @returns {boolean}
     */
    IsRunning(): boolean

    /**
     * Is in the middle of a complex action that shouldn't be interrupted.
     * @returns {boolean}
     */
    IsScrambling(): boolean

    /**
     * Return `true` if bot is stuck.
     * @returns {boolean}
     */
    IsStuck(): boolean

    /**
     * Initiate a simple undirected jump in the air.
     */
    Jump(): void

    /**
     * Initiate a jump across an empty volume of space to far side.
     * @param {Vector} goal_pos
     * @param {Vector} goal_forward
     */
    JumpAcrossGap(goal_pos: Vector, goal_forward: Vector): void

    /**
     * Manually run the OnLandOnGround callback.
     * @param {CBaseEntity} ground
     */
    OnLandOnGround(ground: CBaseEntity): void

    /**
     * Manually run the OnLeaveGround callback.
     * @param {CBaseEntity} ground
     */
    OnLeaveGround(ground: CBaseEntity): void

    /**
     * Resets motion, stuck state etc.
     */
    Reset(): void

    /**
     * Set desired movement speed to running.
     */
    Run(): void

    /**
     * Set desired speed for locomotor movement.
     * @param {number} speed
     */
    SetDesiredSpeed(speed: number): void

    /**
     * Set maximum speed bot can reach, regardless of desired speed.
     * @param {number} limit
     */
    SetSpeedLimit(limit: number): void

    /**
     * Set desired movement speed to stopped.
     */
    Stop(): void

    /**
     * Set desired movement speed to walking.
     */
    Walk(): void
}

declare global {
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
	function EntFireByHandle(entity: CBaseEntity, action: string, value: string|null, delay: number, activator: CBaseEntity|null, caller: CBaseEntity|null): void


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
	function PlayerInstanceFromIndex(index: number): CTFPlayer|null

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
	 * @param {string} cvar
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
	 * @param {string} name
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