package commands
{
	import commands.BaseCommand;
	import commands.constants.CommandResult;
	import facades.App;
	import models.PlayerModel;
	import models.RewardModel;
	import models.types.RewardData;
	import models.types.RewardTypes;
	import providers.GameProvider;
	import models.ModelsNamespace;

	public class ClaimRewardCommand extends BaseCommand
	{
		use namespace ModelsNamespace;
		private var _day:int;

		public function ClaimRewardCommand(day:int)
		{
			_day = day;
		}

		override public function execute():String
		{
			var provider:GameProvider = App.provider;
			var rewardModel:RewardModel = provider.rewardModel;
			var playerModel:PlayerModel = provider.playerModel;
			var rewards:Vector.<RewardData> = rewardModel.rewards;

			// Check for invalid day
			if (_day < 0 || _day >= rewards.length)
			{
				return CommandResult.INVALID_DAY;
			}

			var result:Object = rewardModel.executeClaimReward(_day);
			if (result.status == RewardModel.CLAIM_SUCCESS)
			{
				var claimedReward:RewardData = result.reward;
				if (claimedReward.type == RewardTypes.COINS) playerModel.addCoins(claimedReward.amount);
				else if (claimedReward.type == RewardTypes.GEMS) playerModel.addGems(claimedReward.amount);
				return CommandResult.SUCCESS;
			}
			else if (result.status == RewardModel.CLAIM_ALREADY_CLAIMED)
			{
				return CommandResult.ALREADY_CLAIMED;
			}
			else if (result.status == RewardModel.CLAIM_NOT_TODAY)
			{
				return CommandResult.FAILED;
			}
			else if (result.status == RewardModel.CLAIM_INVALID_DAY)
			{
				return CommandResult.INVALID_DAY;
			}
			return CommandResult.FAILED;
		}
	}
}