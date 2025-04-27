package commands
{
	import commands.BaseCommand;
	import commands.constants.CommandResult;
	import facades.App;
	import models.RewardModel;
	import providers.GameProvider;
	import models.ModelsNamespace;

	public class RerollRewardsCommand extends BaseCommand
	{
		use namespace ModelsNamespace;

		private var _provider:GameProvider;
		private var _rewardModel:RewardModel;

		public function RerollRewardsCommand()
		{
			_provider = App.provider;
			_rewardModel = _provider.rewardModel;
		}

		override public function execute():String
		{
			// Example: Only allow reroll if not already rerolled today (pseudo logic)
			if (!_rewardModel.canReroll)
			{
				return CommandResult.FAILED;
			}
			_rewardModel.executeReroll();
			return CommandResult.SUCCESS;
		}
	}
}