package providers
{
	import models.PlayerModel;

	public class PlayerProvider
	{
		private var _playerModel:PlayerModel;

		public function PlayerProvider()
		{
			_playerModel = new PlayerModel();
		}

		public function get playerModel():PlayerModel
		{
			return _playerModel;
		}
	}
}