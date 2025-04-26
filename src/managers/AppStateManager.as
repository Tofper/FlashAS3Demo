package managers
{
	/**
	 * AppStateManager manages the current state of the application and notifies listeners of state changes.
	 *
	 * Responsibilities:
	 * - Holds the current app state (e.g., loading, ready, error, animation)
	 * - Allows listeners to subscribe to state changes
	 * - Notifies all listeners when the state changes
	 */
	public class AppStateManager
	{
		public static const STATE_LOADING:String = "loading";
		public static const STATE_READY:String = "ready";
		public static const STATE_ERROR:String = "error";
		public static const STATE_ANIMATION:String = "animation";

		private var _currentState:String = STATE_LOADING;
		private var _listeners:Array = [];

		public function AppStateManager()
		{
			super();
		}

		/**
		 * Gets the current application state.
		 */
		public function get currentState():String  { return _currentState; }

		/**
		 * Sets the application state and notifies all registered listeners.
		 * @param state The new state to set.
		 */
		public function setState(state:String):void
		{
			var oldState:String = _currentState;
			_currentState = state;
			for each (var listener:Function in _listeners)
			{
				listener(oldState, _currentState);
			}
		}

		/**
		 * Adds a listener function to be called on state changes.
		 * @param listener Function with signature (oldState:String, newState:String):void
		 */
		public function addStateListener(listener:Function):void
		{
			_listeners.push(listener);
		}

		/**
		 * Removes a previously added state listener.
		 * @param listener The listener function to remove.
		 */
		public function removeStateListener(listener:Function):void
		{
			var idx:int = _listeners.indexOf(listener);
			if (idx != -1) _listeners.splice(idx, 1);
		}
	}
}