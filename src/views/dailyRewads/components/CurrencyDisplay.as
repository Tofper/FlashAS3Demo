package views.dailyRewads.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import common.IDestroyable;
	import common.BaseComponent;
	import managers.LocaleKeys;
	import facades.App;
	import utils.TextUtils;

	public class CurrencyDisplay extends BaseComponent implements IDestroyable
	{
		// Bitmask part constants for this component
		public static const PART_COINS:int = 1 << 3; // 8
		public static const PART_GEMS:int = 1 << 4; // 16

		private var _coinsField:TextField;
		private var _gemsField:TextField;
		private var _coins:int;
		private var _gems:int;

		public function CurrencyDisplay()
		{
			super();
			_coins = 0;
			_gems = 0;
			var fmt:TextFormat = new TextFormat("Arial", 18, 0xFFD700, true);

			_coinsField = new TextField();
			_coinsField.defaultTextFormat = fmt;
			_coinsField.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.COINS_LABEL), _coins);
			_coinsField.width = 120;
			_coinsField.height = 30;
			_coinsField.selectable = false;
			addChild(_coinsField);

			_gemsField = new TextField();
			_gemsField.defaultTextFormat = fmt;
			_gemsField.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.GEMS_LABEL), _gems);
			_gemsField.x = 130;
			_gemsField.width = 120;
			_gemsField.height = 30;
			_gemsField.selectable = false;
			addChild(_gemsField);
		}

		public function set coins(value:int):void
		{
			if (_coins != value)
			{
				_coins = value;
				invalidatePart(PART_COINS);
			}
		}

		public function set gems(value:int):void
		{
			if (_gems != value)
			{
				_gems = value;
				invalidatePart(PART_GEMS);
			}
		}

		override protected function commitProperties():void
		{
			if (isPartInvalid(PART_COINS))
			{
				_coinsField.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.COINS_LABEL), _coins);
			}
			if (isPartInvalid(PART_GEMS))
			{
				_gemsField.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.GEMS_LABEL), _gems);
			}
		}

		public function destroy():void
		{
			if (_coinsField)
			{
				removeChild(_coinsField);
				_coinsField = null;
			}
			if (_gemsField)
			{
				removeChild(_gemsField);
				_gemsField = null;
			}
		}
	}
}