package viewmodels
{
	import flash.events.EventDispatcher;
	import common.IDestroyable;

	public class BaseViewModel extends EventDispatcher implements IDestroyable
	{
		public function BaseViewModel()
		{
			super();
		}

		public function destroy():void
		{
			// Override in subclasses for cleanup
		}
	}
}