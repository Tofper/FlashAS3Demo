package managers
{
	import flash.utils.Dictionary;
	import managers.LocaleKeys;

	/**
	 * LocalizationManager provides localized strings for the application UI.
	 *
	 * Responsibilities:
	 * - Store and retrieve localized strings by key
	 * - Support parameterized string formatting (if implemented)
	 */
	public class LocalizationManager
	{
		private var _strings:Dictionary;

		public function LocalizationManager()
		{
			_strings = new Dictionary();
			// Default mappings
			_strings[LocaleKeys.DAILY_REWARDS] = "DAILY REWARDS";
			_strings[LocaleKeys.REROLL_INFO] = "Rerolls used: {0}/{1} — Remaining: {2}";
			_strings[LocaleKeys.REROLL_INFO_NO_LEFT] = "Rerolls used: {0}/{1} — No rerolls left today";
			_strings[LocaleKeys.COINS_LABEL] = "COINS: {0}";
			_strings[LocaleKeys.GEMS_LABEL] = "GEMS: {0}";
			_strings[LocaleKeys.CLAIMED] = "CLAIMED";
			_strings[LocaleKeys.LOCKED] = "LOCKED";
			_strings[LocaleKeys.CLAIM] = "CLAIM";
			_strings[LocaleKeys.REROLL] = "REROLL";
			_strings[LocaleKeys.DAY_LABEL] = "Day {0}";
		}

		/**
		 * Retrieves the localized string for the given key.
		 * @param key The string key (see LocaleKeys).
		 * @return The localized string, or the key if not found.
		 */
		public function getString(key:String):String
		{
			return _strings[key] || key;
		}
	}
}