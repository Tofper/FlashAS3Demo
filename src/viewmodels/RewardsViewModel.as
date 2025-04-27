package viewmodels
{
	import models.ClaimRewardCommand;
	import models.RerollRewardsCommand;
	import events.ViewModelEvent;
	import facades.App;
	import flash.events.Event;
	import managers.CommandManager;
	import models.PlayerModel;
	import models.RewardModel;
	import models.types.RewardData;
	import models.types.RewardMeta;
	import providers.GameProvider;
	import managers.ConfigManager;
	import viewmodels.RewardCardModel;
	import models.ClaimCommandProps;

	public class RewardsViewModel extends BaseViewModel
	{
		private var _provider:GameProvider;
		private var _rewardModel:RewardModel;
		private var _cards:Vector.<RewardData>;
		private var _rerollCount:int = 0;
		private var _maxRerolls:int;
		private var _currentDay:int;
		private var _commandManager:CommandManager;
		private var _configManager:ConfigManager;

		public function RewardsViewModel()
		{
			_provider = App.provider;
			_rewardModel = _provider.rewardModel;
			_commandManager = App.commandManager;
			_configManager = App.configManager;
			_rewardModel.addEventListener(RewardModel.REWARDS_UPDATED, onModelUpdated, false, 0, true);
			_provider.playerModel.addEventListener(PlayerModel.CURRENCY_CHANGED, onPlayerCurrencyUpdated, false, 0, true);
		}

		private function onModelUpdated(e:Event):void
		{
			dispatchEvent(new ViewModelEvent(ViewModelEvent.UPDATED));
		}

		private function onPlayerCurrencyUpdated(e:Event):void
		{
			dispatchEvent(new ViewModelEvent(ViewModelEvent.UPDATED));
		}

		// Exposed state
		public function get cards():Vector.<RewardData>  { return _rewardModel.rewards; }

		public function get rerollCount():int  { return _rewardModel.rerollCount; }

		public function get maxRerolls():int  { return _rewardModel.maxRerolls; }

		public function get currentDay():int  { return _rewardModel.currentDay; }

		public function get remainingRerolls():int  { return _rewardModel.remainingRerolls; }

		public function get canReroll():Boolean  { return _rewardModel.canReroll; }

		public function get playerCoins():int  { return _provider.playerModel.coins; }

		public function get playerGems():int  { return _provider.playerModel.gems; }

		public function get cardModels():Array
		{
			var rewards:Vector.<RewardData> = _rewardModel.rewards;
			var result:Array = [];
			for (var i:int = 0; i < rewards.length; i++)
			{
				var reward:RewardData = rewards[i];
				var meta:RewardMeta = _configManager.getRewardMeta(reward.type);
				var isCurrentDay:Boolean = (i + 1) == _rewardModel.currentDay;
				result.push(new RewardCardModel(reward, meta, isCurrentDay));
			}
			return result;
		}

		// Actions
		public function reroll():void
		{
			if (canReroll)
			{
				_commandManager.execute(RerollRewardsCommand);
			}
		}

		public function claimReward(day:int):void
		{
			var props:ClaimCommandProps = new ClaimCommandProps(day);
			_commandManager.execute(ClaimRewardCommand, props);
		}

		// Cleanup
		override public function destroy():void
		{
			if (_rewardModel)
			{
				_rewardModel.removeEventListener(RewardModel.REWARDS_UPDATED, onModelUpdated);
				_rewardModel = null;
			}
			if (_provider && _provider.playerModel)
			{
				_provider.playerModel.removeEventListener(PlayerModel.CURRENCY_CHANGED, onPlayerCurrencyUpdated);
			}
		}
	}
}