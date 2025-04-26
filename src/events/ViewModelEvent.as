package events
{
	import flash.events.Event;

	public class ViewModelEvent extends Event
	{
		public static const UPDATED:String = "viewModelUpdated";

		public function ViewModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ViewModelEvent(type, bubbles, cancelable);
		}
	}
}