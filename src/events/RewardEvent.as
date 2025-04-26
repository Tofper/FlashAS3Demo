package events
{
	import flash.events.Event;

	public class RewardEvent extends Event
	{
		public static const CLAIMED:String = "claimed";
		public static const UPDATED:String = "updated";
		public var value:int;

		public function RewardEvent(type:String, value:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.value = value;
		}

		override public function clone():Event
		{
			return new RewardEvent(type, value, bubbles, cancelable);
		}
	}
}