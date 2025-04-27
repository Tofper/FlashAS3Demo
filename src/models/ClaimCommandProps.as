package models
{
	import commands.ICommandProps;

	public class ClaimCommandProps implements ICommandProps
	{
		private var _day:int;

		public function ClaimCommandProps(day:int)
		{
			_day = day;
		}

		public function get day():int
		{
			return _day;
		}
	}
}