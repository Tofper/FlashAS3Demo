package providers
{
	import facades.App;
	import factories.RewardFactory;
	import managers.ConfigManager;
	import models.RewardModel;
	import models.types.RewardData;

	public class RewardProvider
	{
		private var _rewardModel:RewardModel;
		private var _configManager:ConfigManager;

		public function RewardProvider()
		{
			_configManager = App.configManager;
			initializeRewardModel();
		}

		private function initializeRewardModel():void
		{
			// Get configuration values
			var maxRerolls:int = _configManager.getValue("rewards.maxRerolls", 3);
			var currentDay:int = _configManager.getValue("rewards.currentDay", 3);
			// Create initial rewards using factory (not from RewardModel)
			var initialRewards:Vector.<RewardData> = RewardFactory.createInitialRewards();
			// Create reward model with all dependencies
			_rewardModel = new RewardModel(initialRewards, maxRerolls, currentDay);
		}

		public function get rewardModel():RewardModel
		{
			return _rewardModel;
		}
	}
}