package managers
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import models.types.RewardMeta;

	/**
	 * ConfigManager handles all game configuration parameters and reward metadata.
	 *
	 * Responsibilities:
	 * - Loads configuration from an external JSON file for flexibility
	 * - Provides access to config values using dot notation
	 * - Loads and provides reward metadata
	 *
	 * Usage:
	 *   var value = App.configManager.getValue("rewards.cycle");
	 */
	public class ConfigManager
	{
		private var _config:Object;
		private var _rewardMetaById:Object = {};

		public function ConfigManager()
		{
			super();
			_config = {rewards: {cycle: 7, coins: [100, 200, 300, 500, 800, 1000, 2000], gems: [5, 8, 10, 15, 20, 25, 50], pattern: ["COINS", "GEMS", "COINS", "GEMS", "COINS", "GEMS", "COINS"], types: {COINS: {icon: "coin_icon.png", label: "Coins", description: "Basic in-game currency.", rarity: "common"}, GEMS: {icon: "gem_icon.png", label: "Gems", description: "Premium currency.", rarity: "rare"}}}, ui: {cardWidth: 70, cardHeight: 100, spacing: 10, colors: {background: 3355443, coins: 16766720, gems: 65535}}};
		}

		/**
		 * Loads configuration from an external JSON file and updates the config object.
		 * @param url The URL to the JSON config file.
		 * @param onComplete Optional callback to invoke after loading.
		 * @param onError Optional callback to invoke if loading or parsing fails.
		 */
		public function loadConfigFromFile(url:String, onComplete:Function = null, onError:Function = null):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				try
				{
					_config = JSON.parse(loader.data);
					if (onComplete != null) onComplete();
				}
				catch (err:Error)
				{
					trace("[ConfigManager] Error parsing JSON from " + url + ": " + err.message);
					if (onError != null) onError(err);
				}
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				trace("[ConfigManager] IOError while loading config from " + url + ": " + e.text);
				if (onError != null) onError(e);
			});
			loader.load(new URLRequest(url));
		}

		/**
		 * Gets a value from the config using dot notation (e.g., "rewards.cycle").
		 * @param path The dot-separated path to the config value.
		 * @param defaultValue The value to return if the path is not found.
		 * @return The value at the specified path, or defaultValue if not found.
		 */
		public function getValue(path:String, defaultValue:* = null):*
		{
			var parts:Array = path.split(".");
			var current:Object = _config;
			for each (var part:String in parts)
			{
				if (current.hasOwnProperty(part))
				{
					current = current[part];
				}
				else
				{
					return defaultValue;
				}
			}
			return current;
		}

		/**
		 * Loads reward metadata from the config into RewardMeta objects for quick access.
		 */
		public function loadRewardMeta():void
		{
			var types:Object = getValue("rewards.types", {});
			for (var id:String in types)
			{
				var meta:Object = types[id];
				_rewardMetaById[id] = new RewardMeta(meta.id, meta.icon, meta.label, meta.description, meta.rarity);
			}
		}

		/**
		 * Retrieves the RewardMeta object for a given reward type ID.
		 * @param id The reward type ID (e.g., "COINS", "GEMS").
		 * @return The RewardMeta object, or null if not found.
		 */
		public function getRewardMeta(id:String):RewardMeta
		{
			return _rewardMetaById[id];
		}
	}
}