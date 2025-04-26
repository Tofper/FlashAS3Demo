package viewmodels
{
	import models.types.RewardData;
	import models.types.RewardMeta;

	public class RewardCardModel
	{
		public var reward:RewardData;
		public var meta:RewardMeta;
		public var isCurrentDay:Boolean;

		public function RewardCardModel(reward:RewardData, meta:RewardMeta, isCurrentDay:Boolean)
		{
			this.reward = reward;
			this.meta = meta;
			this.isCurrentDay = isCurrentDay;
		}
	}
}