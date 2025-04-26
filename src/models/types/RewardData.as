package models.types
{
	import models.types.RewardState;
	public class RewardData
	{
		private var _type:String;
		private var _amount:int;
		private var _state:String;

		public function RewardData(type:String, amount:int, state:String = null)
		{
			_type = type;
			_amount = amount;
			_state = state ? state : RewardState.LOCKED;
		}

		public function get type():String  { return _type; }
		public function get amount():int  { return _amount; }
		public function set amount(value:int):void  { _amount = value; }
		public function get state():String { return _state; }
		public function set state(value:String):void { _state = value; }
	}
}