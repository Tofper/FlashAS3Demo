package common
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Flex-style base class for UI components with invalidate/validate pattern and partial invalidation using bitmask flags.
	 * Provides a few basic part constants for common UI scenarios.
	 */
	public class BaseComponent extends Sprite
	{
		private var _propertiesInvalidated:Boolean = false;
		private var _invalidatedParts:int = 0;

		// Bitmask part constants for common UI invalidation scenarios
		protected static const PART_DATA:int = 1 << 0; // 1
		protected static const PART_LAYOUT:int = 1 << 1; // 2
		protected static const PART_STYLE:int = 1 << 2; // 4

		public function BaseComponent()
		{
			super();
			// Optionally, call invalidateProperties() here if needed
		}

		/**
		 * Invalidate a specific part using a bitmask flag.
		 */
		protected function invalidatePart(flag:int):void
		{
			_invalidatedParts |= flag;
			invalidateProperties();
		}

		/**
		 * Check if a specific part is invalidated.
		 */
		protected function isPartInvalid(flag:int):Boolean
		{
			return (_invalidatedParts & flag) != 0;
		}

		/**
		 * Clear all invalidated part flags.
		 */
		protected function clearInvalidatedParts():void
		{
			_invalidatedParts = 0;
		}

		/**
		 * Call this when a property changes and you want to schedule a UI update.
		 */
		protected function invalidateProperties():void
		{
			if (!_propertiesInvalidated)
			{
				_propertiesInvalidated = true;
				if (stage)
				{
					addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				}
				else
				{
					addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
				}
			}
		}

		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		private function onEnterFrame(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_propertiesInvalidated = false;
			validateProperties();
		}

		/**
		 * Triggers the actual update. Override this in subclasses.
		 */
		protected function commitProperties():void
		{
			// To be overridden by subclasses
		}

		/**
		 * Called when properties are invalidated and it's time to update.
		 */
		protected function validateProperties():void
		{
			commitProperties();
			clearInvalidatedParts();
		}
	}
}