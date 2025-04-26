package facades
{
	import flash.display.Stage;
	import managers.AnimationManager;
	import managers.AppStateManager;
	import managers.CommandManager;
	import managers.ConfigManager;
	import managers.LayoutManager;
	import managers.LocalizationManager;
	import providers.GameProvider;

	/**
	 * The App class serves as the main application facade, managing core services and managers.
	 * It acts as a singleton and provides static access to key managers and providers throughout the app lifecycle.
	 *
	 * Responsibilities:
	 * - Initializes and holds references to core managers (layout, animation, state, command, config, localization)
	 * - Loads configuration and handles app state transitions
	 * - Provides static accessors for global managers and providers
	 */
	public class App
	{
		private var _provider:GameProvider;
		private var _layoutManager:LayoutManager;
		private var _configManager:ConfigManager;
		private var _animationManager:AnimationManager;
		private var _stateManager:AppStateManager;
		private var _commandManager:CommandManager;
		private var _localizationManager:LocalizationManager;

		public static var instance:App;
		private var _stage:Stage;

		/**
		 * Constructs the App facade, initializes all core managers, and begins loading configuration.
		 * @param stage The root Stage for the application.
		 */
		public function App(stage:Stage)
		{
			App.instance = this;
			_stage = stage;
			_layoutManager = new LayoutManager();
			_layoutManager.initialize(_stage);
			_animationManager = new AnimationManager();
			_stateManager = new AppStateManager();
			_stateManager.setState(AppStateManager.STATE_LOADING);
			_stateManager.addStateListener(onAppStateChanged);
			_commandManager = new CommandManager();
			_provider = new GameProvider();
			_configManager = new ConfigManager();
			_configManager.loadConfigFromFile("config.json", onConfigLoaded, onConfigError);
			_localizationManager = new LocalizationManager();
		}

		/**
		 * Called when configuration is successfully loaded. Initializes the game provider and sets app state to READY.
		 */
		private function onConfigLoaded():void
		{
			_provider.initialize();
			_stateManager.setState(AppStateManager.STATE_READY);
		}

		/**
		 * Called if configuration loading fails. Sets app state to ERROR.
		 * @param error The error object or event.
		 */
		private function onConfigError(error:*):void
		{
			_stateManager.setState(AppStateManager.STATE_ERROR);
			// Optionally, show an error message to the user here
		}

		/**
		 * Handles app state changes. Extend this to react to state transitions.
		 * @param oldState The previous state.
		 * @param newState The new state.
		 */
		private function onAppStateChanged(oldState:String, newState:String):void
		{
			// Handle state changes here
			// You can add more logic here based on the state
		}

		public static function get layoutManager():LayoutManager
		{
			return App.instance ? App.instance._layoutManager : null;
		}

		public static function get configManager():ConfigManager
		{
			return App.instance ? App.instance._configManager : null;
		}

		public static function get animationManager():AnimationManager
		{
			return App.instance ? App.instance._animationManager : null;
		}

		public static function get commandManager():CommandManager
		{
			return App.instance ? App.instance._commandManager : null;
		}

		public static function get stateManager():AppStateManager
		{
			return App.instance ? App.instance._stateManager : null;
		}

		public static function get provider():GameProvider
		{
			return App.instance ? App.instance._provider : null;
		}

		public static function get localizationManager():LocalizationManager
		{
			return App.instance ? App.instance._localizationManager : null;
		}
	}
}