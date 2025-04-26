package factories
{
	import facades.App;
	import models.types.RewardData;
	import models.types.RewardState;
	import models.types.RewardTypes;

	/**
	 * Factory class for creating reward objects.
	 * Extracts creation logic from the RewardModel.
	 */
	public class RewardFactory
	{
		/**
		 * Creates a vector of initial rewards based on configuration.
		 * @return Vector of RewardData objects.
		 */
		public static function createInitialRewards():Vector.<RewardData>
		{
			// Get configuration values with defaults as fallback
			var pattern:Array = App.configManager.getValue("rewards.pattern", [RewardTypes.COINS, RewardTypes.GEMS, RewardTypes.COINS, RewardTypes.GEMS, RewardTypes.COINS, RewardTypes.GEMS, RewardTypes.COINS]);
			var coinAmounts:Array = App.configManager.getValue("rewards.coins", [100, 200, 300, 500, 800, 1000, 2000]);
			var gemAmounts:Array = App.configManager.getValue("rewards.gems", [5, 8, 10, 15, 20, 25, 50]);

			var rewards:Vector.<RewardData> = new Vector.<RewardData>();

			// Create rewards based on pattern
			for (var i:int = 0; i < pattern.length; i++)
			{
				var type:String = pattern[i];
				var amount:int = (type == RewardTypes.COINS) ? coinAmounts[i % coinAmounts.length] : gemAmounts[i % gemAmounts.length];
				rewards.push(new RewardData(type, amount, RewardState.AVAILABLE));
			}
			return rewards;
		}

		public static function createRerolledRewards(existingRewards:Vector.<RewardData>):Vector.<RewardData>
		{
			// Get configuration if provided
			var rewardTypes:Array = App.configManager.getValue("rewards.pattern", ["COINS", "GEMS"]);
			var coinAmounts:Array = App.configManager.getValue("rewards.coins", [100, 200, 300]);
			var gemAmounts:Array = App.configManager.getValue("rewards.gems", [5, 10, 15]);

			var result:Vector.<RewardData> = new Vector.<RewardData>();

			// Create new rewards preserving claimed status
			for each (var card:RewardData in existingRewards)
			{
				if (card.state == models.types.RewardState.CLAIMED)
				{
					// Keep claimed rewards as is
					result.push(card);
				}
				else
				{
					// Generate new reward for unclaimed days
					var rewardType:String = rewardTypes[int(Math.random() * rewardTypes.length)];
					var rewardAmount:int = (rewardType == RewardTypes.COINS) ? coinAmounts[int(Math.random() * coinAmounts.length)] : gemAmounts[int(Math.random() * gemAmounts.length)];
					result.push(new RewardData(rewardType, rewardAmount, card.state));
				}
			}

			return result;
		}
	}
}