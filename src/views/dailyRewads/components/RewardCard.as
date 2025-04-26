package views.dailyRewads.components
{
	import common.BaseComponent;
	import common.IDestroyable;
	import events.ButtonEvent;
	import events.CardEvent;
	import facades.App;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import managers.LocaleKeys;
	import models.types.RewardData;
	import models.types.RewardMeta;
	import models.types.RewardState;
	import models.types.RewardTypes;
	import utils.TextUtils;
	import viewmodels.RewardCardModel;
	import views.dailyRewads.components.ClaimButton;

	public class RewardCard extends BaseComponent implements IDestroyable
	{
		private var _day:int;
		private var _model:RewardCardModel;
		private var _claimBtn:ClaimButton;
		private var _overlay:Sprite;
		private var _hasRevealed:Boolean = false;
		private var _dayLabel:TextField;
		private var _icon:Sprite;
		private var _amountLabel:TextField;
		private var _typeLabel:TextField;
		private var _rarityLabel:TextField;
		private var _claimedLabel:TextField;
		private var _lockLabel:TextField;

		public function RewardCard(day:int, model:RewardCardModel)
		{
			_day = day;
			_model = model;
			var fmt:TextFormat = new TextFormat(CardStyle.FONT_NAME, 20, 0x333333, true);
			_dayLabel = new TextField();
			_dayLabel.defaultTextFormat = fmt;
			_dayLabel.width = CardStyle.CARD_WIDTH;
			_dayLabel.height = 30;
			_dayLabel.y = 6;
			_dayLabel.selectable = false;
			_dayLabel.mouseEnabled = false;
			_dayLabel.autoSize = "center";
			_dayLabel.setTextFormat(fmt);
			addChild(_dayLabel);

			_icon = new Sprite();
			addChild(_icon);

			_amountLabel = new TextField();
			_amountLabel.defaultTextFormat = new TextFormat(CardStyle.FONT_NAME, 28, 0x333333, true);
			_amountLabel.width = CardStyle.CARD_WIDTH;
			_amountLabel.height = 36;
			_amountLabel.y = 150;
			_amountLabel.selectable = false;
			_amountLabel.mouseEnabled = false;
			_amountLabel.multiline = false;
			_amountLabel.wordWrap = false;
			_amountLabel.autoSize = "center";
			addChild(_amountLabel);

			_typeLabel = new TextField();
			_typeLabel.defaultTextFormat = new TextFormat(CardStyle.FONT_NAME, 16, 0x888888, true);
			_typeLabel.width = CardStyle.CARD_WIDTH;
			_typeLabel.height = 22;
			_typeLabel.y = 120;
			_typeLabel.selectable = false;
			_typeLabel.mouseEnabled = false;
			_typeLabel.autoSize = "center";
			addChild(_typeLabel);

			_rarityLabel = new TextField();
			_rarityLabel.defaultTextFormat = new TextFormat(CardStyle.FONT_NAME, 12, 0xAA8800, true);
			_rarityLabel.width = CardStyle.CARD_WIDTH;
			_rarityLabel.height = 16;
			_rarityLabel.y = 190;
			_rarityLabel.selectable = false;
			_rarityLabel.mouseEnabled = false;
			_rarityLabel.autoSize = "center";
			addChild(_rarityLabel);

			_claimedLabel = new TextField();
			_claimedLabel.defaultTextFormat = new TextFormat(CardStyle.FONT_NAME, 22, 0x00AA00, true);
			_claimedLabel.width = CardStyle.CARD_WIDTH;
			_claimedLabel.height = 32;
			_claimedLabel.y = 99;
			_claimedLabel.selectable = false;
			_claimedLabel.mouseEnabled = false;
			_claimedLabel.autoSize = "center";
			addChild(_claimedLabel);

			_claimBtn = new ClaimButton();
			_claimBtn.addEventListener(ButtonEvent.CLICK, handleClaimButtonEvent, false, 0, true);
			_claimBtn.x = 5;
			_claimBtn.y = 192;
			addChild(_claimBtn);

			_overlay = new Sprite();
			_overlay.graphics.beginFill(CardStyle.OVERLAY_COLOR, CardStyle.OVERLAY_ALPHA);
			_overlay.graphics.drawRoundRect(0, 0, CardStyle.CARD_WIDTH, CardStyle.CARD_HEIGHT, CardStyle.CORNER_RADIUS);
			_overlay.graphics.endFill();
			_overlay.visible = false;
			addChild(_overlay);

			_lockLabel = new TextField();
			_lockLabel.defaultTextFormat = new TextFormat(CardStyle.FONT_NAME, 22, 0xFFFFFF, true);
			_lockLabel.width = CardStyle.CARD_WIDTH;
			_lockLabel.height = 32;
			_lockLabel.y = 99;
			_lockLabel.selectable = false;
			_lockLabel.mouseEnabled = false;
			_lockLabel.autoSize = "center";
			_overlay.addChild(_lockLabel);

			invalidatePart(PART_DATA);
			if (stage)
			{
				reveal();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStageReveal, false, 0, true);
			}
		}

		private function onAddedToStageReveal(e:flash.events.Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageReveal);
			reveal();
		}

		public function setModel(model:RewardCardModel):void
		{
			_model = model;
			invalidatePart(PART_DATA);
		}

		override protected function commitProperties():void
		{
			graphics.clear();
			var cardWidth:int = CardStyle.CARD_WIDTH;
			var cardHeight:int = CardStyle.CARD_HEIGHT;
			var cornerRadius:int = CardStyle.CORNER_RADIUS;

			// Cache model and meta for readability
			var rewardModel:RewardCardModel = _model;
			var rewardMeta:RewardMeta = rewardModel.meta;
			var reward:RewardData = rewardModel.reward;
			var rewardState:String = reward.state;

			graphics.beginFill(rewardModel.isCurrentDay ? CardStyle.COLOR_CURRENT_DAY : CardStyle.COLOR_DEFAULT);
			graphics.lineStyle(3, rewardModel.isCurrentDay ? CardStyle.BORDER_CURRENT_DAY : CardStyle.BORDER_DEFAULT);
			graphics.drawRoundRect(0, 0, cardWidth, cardHeight, cornerRadius);
			graphics.endFill();

			_dayLabel.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.DAY_LABEL), _day);

			// Cache graphics for icon
			var iconGraphics:flash.display.Graphics = _icon.graphics;
			iconGraphics.clear();
			var locked:Boolean = (rewardState == RewardState.LOCKED);
			if (locked)
			{
				iconGraphics.beginFill(CardStyle.OVERLAY_COLOR);
				iconGraphics.drawCircle(cardWidth / 2, 55, 22);
				iconGraphics.endFill();
			}
			else if (rewardMeta && rewardMeta.icon)
			{
				if (rewardMeta.id == RewardTypes.COINS)
				{
					iconGraphics.beginFill(0xFFD700);
					iconGraphics.drawCircle(cardWidth / 2, 55, 22);
					iconGraphics.endFill();
				}
				else if (rewardMeta.id == RewardTypes.GEMS)
				{
					iconGraphics.beginFill(0x66CCFF);
					iconGraphics.drawRect(cardWidth / 2 - 18, 37, 36, 36);
					iconGraphics.endFill();
				}
				else
				{
					iconGraphics.beginFill(0xCCCCCC);
					iconGraphics.drawCircle(cardWidth / 2, 55, 22);
					iconGraphics.endFill();
				}
			}

			// Update static elements' visibility and content
			_amountLabel.visible = !locked;
			_typeLabel.visible = !locked;
			_rarityLabel.visible = !locked && rewardMeta && rewardMeta.rarity;
			_claimedLabel.visible = !locked && rewardState == models.types.RewardState.CLAIMED;
			_claimBtn.visible = !locked && rewardState == models.types.RewardState.AVAILABLE;
			_overlay.visible = locked;

			if (!locked)
			{
				_amountLabel.text = String(reward.amount);
				_typeLabel.text = rewardMeta && rewardMeta.label ? rewardMeta.label : (reward.type ? reward.type.toUpperCase() : "");
				if (rewardMeta && rewardMeta.rarity)
					_rarityLabel.text = rewardMeta.rarity;
				if (rewardState == models.types.RewardState.CLAIMED)
					_claimedLabel.text = App.localizationManager.getString(LocaleKeys.CLAIMED);
				if (rewardState == models.types.RewardState.AVAILABLE)
					_claimBtn.label = App.localizationManager.getString(LocaleKeys.CLAIM);
			}
			if (locked)
			{
				_lockLabel.text = App.localizationManager.getString(LocaleKeys.LOCKED);
			}
		}

		private function reveal():void
		{
			if (_hasRevealed) return;
			_hasRevealed = true;
			var entranceAnimProps:Object = {properties: [{prop: "alpha", from: 0, to: 1}, {prop: "y", from: this.y + 60, to: this.y}], duration: 0.5, delay: _day * 80};
			if (App.animationManager)
			{
				App.animationManager.tween(this, entranceAnimProps);
			}
		}

		private function handleClaimButtonEvent(e:events.ButtonEvent):void
		{
			dispatchEvent(new CardEvent(CardEvent.CLAIM, _day, true));
		}

		public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageReveal);
			_claimBtn.removeEventListener(ButtonEvent.CLICK, handleClaimButtonEvent);
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				removeChildAt(i);
			}
			_overlay = null;
			_dayLabel = null;
			_icon = null;
			_amountLabel = null;
			_typeLabel = null;
			_rarityLabel = null;
			_claimedLabel = null;
			_claimBtn.destroy();
			_claimBtn = null;
			_lockLabel = null;
		}
	}
}

class CardStyle
{
	public static const CARD_WIDTH:int = 90;
	public static const CARD_HEIGHT:int = 230;
	public static const CORNER_RADIUS:int = 14;
	public static const COLOR_CURRENT_DAY:uint = 0xE0FFE0;
	public static const COLOR_DEFAULT:uint = 0xFFF8DC;
	public static const BORDER_CURRENT_DAY:uint = 0x33CC33;
	public static const BORDER_DEFAULT:uint = 0xCCCCCC;
	public static const OVERLAY_COLOR:uint = 0x999999;
	public static const OVERLAY_ALPHA:Number = 0.7;
	public static const FONT_NAME:String = "Arial";
}