package events
{
	import flash.events.Event;

	public class CardEvent extends Event
	{
		public static const CLAIM:String = "cardClaim";
		public var day:int;

		public function CardEvent(type:String, day:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.day = day;
		}

		override public function clone():Event
		{
			return new CardEvent(type, day, bubbles, cancelable);
		}
	}
}