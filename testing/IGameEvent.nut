class IGameEventKey {
	m_szName = ""
	m_data = null

	constructor(name, data)
	{
		this.m_szName = name
		this.m_data = data
	}
}

class IGameEventListener2 {}

class IGameEvent {
	m_szName = ""
	m_bReliable = false
	m_bLocal = false
	m_bEmpty = false

	m_Keys = {}

	function GetName() { return m_szName } // get event name

	function IsReliable() { return m_bReliable } // if event handled reliable

	function IsLocal() { return m_bLocal } // if event is never networked

	/**
	 * @param {string} keyname
	 * @returns {IGameEventKey|null}
	 */
	function GetKey( keyname )
	{
		local keyidx = m_Keys.find(keyname)
		if(keyidx == null)
			return null
		else return m_Keys[keyidx]
	}

	/**
	 * @param {string} keyname
	 */
	function IsEmpty( keyname = null )
	{
		if( keyname == null )
			return m_bEmpty

		local key = GetKey(keyname)
		if(key == null || key == IGameEventKey("", null))
			return true
		else return false
	}
	/**
	 * @param {string} keyName
	 * @returns {bool}
	 */
	function GetBool( keyName, defaultValue = false ) 
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {integer}
	 */
	function GetInt( keyName, defaultValue = 0 ) 
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {float}
	 */
	function GetFloat( keyName, defaultValue = 0.0 ) 
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {string}
	 */
	function GetString( keyName, defaultValue = "" ) 
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {integer}
	 */
	function GetUint64( keyName, defaultValue = -0 )
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {string}
	 */
	function GetWString( keyName, defaultValue = "" )
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}
	/**
	 * @param {string} keyName
	 * @returns {integer} technically a 64 bit address
	 */
	function GetPtr( keyName, defaultValue = -0 )
	{
		if(IsEmpty(keyName))
			return defaultValue
		else return GetKey(keyName).m_data
	}

	/**
	 * @param {string} keyName
	 * @param {any} data
	 */
	function SetKey( keyName, data ) { m_Keys[keyName] <- IGameEventKey(keyName, data) }

	/**
	 * @param {string} keyName
	 * @param {bool} value
	 */
	function SetBool( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {integer} value
	 */
	function SetInt( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {float} value
	 */
	function SetFloat( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {string} value
	 */
	function SetString( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {integer} value
	 */
	function SetUint64( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {string} value
	 */
	function SetWString( keyName, value ) { SetKey( keyName, value ) }
	/**
	 * @param {string} keyName
	 * @param {integer} value
	 */
	function SetPtr( keyName, value ) { SetKey( keyName, value ) }

	/**
	 * @returns {table}
	 */
	function GetDataKeys() { return m_Keys }

	constructor(name)
	{
		this.m_szName = name
	}

	/**
	 * Description
	 * @param {bool} bDontBroadcast if true, Dont send an actual event, faked with FireGameEvent
	 */
	function InternalFire( bDontBroadcast )
	{
		printl(GetDataKeys())
		if( bDontBroadcast )
			FireGameEvent( m_szName, GetDataKeys() )
		else SendGlobalGameEvent( m_szName, GetDataKeys() )
	}
}

class IGameEventManager2 {
	m_ValidEvents = []

	m_Listensers = {}

	// load game event descriptions from a file eg "resource\gameevents.res"
	function LoadEventsFromFile( filename )
	{
		local length = 0
		// re-do with KeyValues
		foreach (event in filename)
		{
			length++
			if(m_ValidEvents.find(event) == null)
				m_ValidEvents.append(event)
		}
		return length
	}

	// removes all and anything
	function Reset()
	{
		m_ValidEvents = []
		m_Listensers = {}
	}
	/**
	 * adds a listener for a particular event
	 * @param {IGameEventListener2} listener
	 * @param {string} name
	 * @param {bool} bServerSide
	 * @returns {bool}
	 */
	function AddListener( listener, name, bServerSide ) {}

	/**
	 * returns true if this listener is listening to given event
	 * @param {IGameEventListener2} listener
	 * @param {string} name
	 * @returns {bool}
	 */
	function FindListener( listener, name ) {}

	/**
	 * removes a listener 
	 * @param {IGameEventListener2} listener
	 */
	function RemoveListener( listener ) {}

	/**
	 * create an event by name, but doesn't fire it. returns NULL is event is not
	 * known or no listener is registered for it. bForce forces the creation even if no listener is active
	 * @param {string} name
	 * @param {bool} bForce
	 * @returns {IGameEvent|null}
	 */
	function CreateEvent( name, bForce = false )
	{
		if( bForce == false )
		{
			local found = m_ValidEvents.find( name ) != null
			if( found == false )
			{
				foreach ( listener, _data in m_Listensers )
				{
					if( FindListener( listener, name ) )
					{
						found = true
						break
					}
				}
				if( found == false )
					return printf("{IGameEventManager2::CreateEvent} Failed to create an event with name %s as there are no listeners or No Registered Events\n", name)
			}
		}
		return IGameEvent(name)
	}

	/**
	 * fires a server event created earlier, if bDontBroadcast is set, event is not send to clients
	 * @param {IGameEvent} event
	 * @param {bool} bDontBroadcast
	 * @returns {bool}
	 */
	function FireEvent( event, bDontBroadcast = false )
	{
		if ( !event || event.IsEmpty() )
			return false
		event.InternalFire( bDontBroadcast )
		return true
	}

	/**
	 * fires an event for the local client only, should be used only by client code
	 * @param {IGameEvent} event
	 * @returns {bool}
	 */
	function FireEventClientSide( event )
	{
		if ( !event || event.IsEmpty() )
			return false
		event.SetBool("client_only", true)
		FireEvent( event )
		return true
	}

	/**
	 * create a new copy of this event, must be free later
	 * @param {IGameEvent} event
	 * @returns {IGameEvent}
	 */
	function DuplicateEvent( event ) 
	{
		return clone event
	}

	/**
	 * if an event was created but not fired for some reason, it has to be freed, same UnserializeEvent
	 * @param {IGameEvent} event
	 */
	function FreeEvent( event ) {}

	/**
	 * write/read event to/from bitbuffer
	 * @param {IGameEvent} event
	 * @param {bf_write} buf
	 * @returns {bool}
	 */
	function SerializeEvent( event, buf ) {}

	/**
	 * create new KeyValues, must be deleted
	 * @param {bf_read} buf
	 * @returns {IGameEvent}
	 */
	function UnserializeEvent( buf ) {}
}

// ::gameeventmanager <- IGameEventManager2()