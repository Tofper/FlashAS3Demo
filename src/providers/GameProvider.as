package providers
{
	import facades.App;
	import managers.ConfigManager;
	import models.PlayerModel;
	import models.RewardModel;

	public class GameProvider
	{
		private var _playerProvider:PlayerProvider;
		private var _rewardProvider:RewardProvider;

		public function GameProvider()
		{
			super();
		}

		public function initialize():void
		{
			_playerProvider = new PlayerProvider();
			_rewardProvider = new RewardProvider();
		}

		public function get playerModel():PlayerModel
		{
			return _playerProvider.playerModel;
		}

		public function get rewardModel():RewardModel
		{
			return _rewardProvider.rewardModel;
		}
	}
}