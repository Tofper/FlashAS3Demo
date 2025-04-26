package models
{
	import factories.RewardFactory;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import models.types.RewardData;
	import models.types.RewardState;

	public class RewardModel extends EventDispatcher
	{
		private var _rewards:Vector.<RewardData>;
		private var _rerollCount:int = 0;
		private var _maxRerolls:int = 0;
		private var _currentDay:int = 0;

		public static const REWARDS_UPDATED:String = "rewardsUpdated";
		public static const CLAIM_SUCCESS:String = "success";
		public static const CLAIM_ALREADY_CLAIMED:String = "already_claimed";
		public static const CLAIM_NOT_TODAY:String = "not_today";
		public static const CLAIM_INVALID_DAY:String = "invalid_day";

		/**
		 * Constructor for RewardModel, receives all dependencies from outside.
		 */
		public function RewardModel(initialRewards:Vector.<RewardData>, maxRerolls:int = 3, currentDay:int = 3)
		{
			_rewards = initialRewards;
			_maxRerolls = maxRerolls;
			_currentDay = currentDay;
			// Set reward state based on current day
			for (var i:int = 0; i < _rewards.length; i++)
			{
				var reward:RewardData = _rewards[i];
				if (reward.state == RewardState.CLAIMED)
				{
					continue; // Already claimed, do not change
				}
				if (i + 1 > _currentDay)
				{
					reward.state = RewardState.LOCKED;
				}
				else if (i + 1 == _currentDay)
				{
					reward.state = RewardState.AVAILABLE;
				}
			}
		}

		public function get rewards():Vector.<RewardData>
		{
			return _rewards;
		}

		public function get rerollCount():int  { return _rerollCount; }

		public function get maxRerolls():int  { return _maxRerolls; }

		public function get currentDay():int  { return _currentDay; }

		public function get remainingRerolls():int  { return _maxRerolls - _rerollCount; }

		public function get canReroll():Boolean  { return _rerollCount < _maxRerolls; }

		/**
		 * Internal method to perform reroll - exposed for Commands to use.
		 * @return Boolean indicating if reroll was successful.
		 */
		internal function executeReroll():Boolean
		{
			if (!canReroll) return false;

			// Just ask factory for new rewards, passing minimal information
			_rewards = RewardFactory.createRerolledRewards(_rewards);
			_rerollCount++;
			dispatchEvent(new Event(REWARDS_UPDATED));
			return true;
		}

		/**
		 * Internal method to claim a reward - exposed for Commands to use.
		 * @return An object with claim result.
		 */
		internal function executeClaimReward(day:int):Object
		{
			// Validate day index
			if (day < 0 || day >= _rewards.length)
			{
				return {status: CLAIM_INVALID_DAY, reward: null};
			}
			// Validate if the day is current or past
			if (day + 1 > _currentDay)
			{
				return {status: CLAIM_NOT_TODAY, reward: null};
			}
			var card:RewardData = _rewards[day];
			// Check if already claimed
			if (card.state == RewardState.CLAIMED)
			{
				return {status: CLAIM_ALREADY_CLAIMED, reward: null};
			}
			// Claim the reward
			var claimedReward:RewardData = new RewardData(card.type, card.amount, RewardState.CLAIMED);
			card.state = RewardState.CLAIMED;
			// Notify listeners
			dispatchEvent(new Event(REWARDS_UPDATED));
			return {status: CLAIM_SUCCESS, reward: claimedReward};
		}
	}
}