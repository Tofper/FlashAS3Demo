package
{
	import facades.App;
	import flash.display.Sprite;
	import flash.events.Event;
	import managers.AppStateManager;
	import viewmodels.RewardsViewModel;
	import views.dailyRewads.DailyRewardsView;
	import views.dailyRewads.components.CurrencyDisplay;

	/**
	 * Main is the application entry point. It initializes the App facade and sets up the main view when the app is ready.
	 *
	 * Responsibilities:
	 * - Create the App facade and pass the stage
	 * - Listen for app state changes and initialize the main UI when ready
	 */
	public class Main extends Sprite
	{
		private var _app:App;
		private var _rewardsView:DailyRewardsView;
		private var _currencyDisplay:CurrencyDisplay;
		private var _rewardsViewModel:RewardsViewModel;

		/**
		 * Constructs the Main entry point. Waits for the stage if not yet available.
		 */
		public function Main()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		/**
		 * Initializes the application facade and sets up state listeners.
		 * @param e Optional Event if called from ADDED_TO_STAGE.
		 */
		private function init(e:Event = null):void
		{
			// entry point
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_app = new App(stage);
			App.stateManager.addStateListener(onAppStateChanged);
		}

		/**
		 * Called when the app state changes. Sets up the main rewards view when ready.
		 * @param oldState The previous app state.
		 * @param newState The new app state.
		 */
		private function onAppStateChanged(oldState:String, newState:String):void
		{
			if (newState == AppStateManager.STATE_READY)
			{
				// Create RewardsViewModel
				_rewardsViewModel = new RewardsViewModel();
				// Create views
				_rewardsView = new DailyRewardsView(_rewardsViewModel);
				addChild(_rewardsView);
			}
		}
	}
}