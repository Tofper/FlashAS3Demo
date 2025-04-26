package events
{
	import flash.events.Event;

	public class ButtonEvent extends Event
	{
		public static const CLICK:String = "buttonClicked";

		public function ButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ButtonEvent(type, bubbles, cancelable);
		}
	}
}