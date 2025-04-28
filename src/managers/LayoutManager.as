package managers
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * LayoutManager handles responsive layout logic and notifies listeners when the layout changes.
	 *
	 * Responsibilities:
	 * - Detects and manages layout mode (mobile/normal) based on stage width
	 * - Dispatches layout change events to listeners
	 * - Provides current layout information
	 */
	public class LayoutManager extends EventDispatcher
	{
		public static const BREAKPOINT_MOBILE:int = 900;
		public static const LAYOUT_CHANGED:String = "layoutChanged";
		public static const LAYOUT_MOBILE:String = "mobile";
		public static const LAYOUT_NORMAL:String = "normal";

		private var _currentLayout:String;
		private var _stage:Stage;

		public function LayoutManager()
		{
			super();
		}

		/**
		 * Initializes the LayoutManager with the application stage and sets up resize handling.
		 * @param stage The root Stage for the application.
		 */
		public function initialize(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			updateLayout();
		}

		private function onStageResize(e:Event):void
		{
			updateLayout();
		}

		private function updateLayout():void
		{
			var newLayout:String = (_stage.stageWidth <= BREAKPOINT_MOBILE) ? LAYOUT_MOBILE : LAYOUT_NORMAL;
			if (newLayout != _currentLayout)
			{
				_currentLayout = newLayout;
				dispatchEvent(new Event(LAYOUT_CHANGED));
			}
		}

		/**
		 * Gets the current layout mode ("mobile" or "normal").
		 * @return The current layout string.
		 */
		public function get currentLayout():String
		{
			return _currentLayout;
		}
	}
}