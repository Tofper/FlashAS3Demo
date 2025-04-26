package views.dailyRewads
{
	import common.IDestroyable;
	import components.RerollButton;
	import events.ButtonEvent;
	import events.CardEvent;
	import events.ViewModelEvent;
	import facades.App;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import managers.LayoutManager;
	import managers.LocaleKeys;
	import utils.TextUtils;
	import viewmodels.RewardCardModel;
	import viewmodels.RewardsViewModel;
	import views.dailyRewads.components.CurrencyDisplay;
	import views.dailyRewads.components.RewardCard;

	public class DailyRewardsView extends Sprite implements IDestroyable
	{
		private var _rerollBtn:RerollButton;
		private var _rerollInfo:TextField;
		private var _title:TextField;
		private var _cardRenderers:Vector.<RewardCard> = new <RewardCard>[];
		private var _viewModel:RewardsViewModel;
		private var _currentLayout:String;
		private var _currencyDisplay:CurrencyDisplay;

		public function DailyRewardsView(viewModel:RewardsViewModel)
		{
			this._viewModel = viewModel;
			// Listen for ViewModel updates with a weak reference
			viewModel.addEventListener(ViewModelEvent.UPDATED, onViewModelUpdated, false, 0, true);
			// Listen for layout changes
			App.layoutManager.addEventListener(LayoutManager.LAYOUT_CHANGED, onLayoutChanged, false, 0, true);
			_currentLayout = App.layoutManager.currentLayout;

			// Title
			_title = new TextField();
			_title.defaultTextFormat = new TextFormat("Arial", 32, 0x333333, true);
			_title.text = App.localizationManager.getString(LocaleKeys.DAILY_REWARDS);
			_title.width = 400;
			_title.height = 40;
			_title.x = 40;
			_title.y = 10;
			_title.selectable = false;
			addChild(_title);

			// Currency display (dumb component)
			_currencyDisplay = new CurrencyDisplay();
			_currencyDisplay.x = 40;
			_currencyDisplay.y = 50;
			addChild(_currencyDisplay);

			// Reroll info
			_rerollInfo = new TextField();
			_rerollInfo.defaultTextFormat = new TextFormat("Arial", 16, 0x555555);
			_rerollInfo.width = 400;
			_rerollInfo.height = 24;
			_rerollInfo.x = 40;
			_rerollInfo.y = 200;
			_rerollInfo.selectable = false;
			addChild(_rerollInfo);
			updateRerollInfo();

			// Cards row (initial build)
			buildCards();

			// Reroll button
			_rerollBtn = new RerollButton();
			_rerollBtn.addEventListener(ButtonEvent.CLICK, onRerollClicked, false, 0, true);
			_rerollBtn.x = 40;
			_rerollBtn.y = 230;
			addChild(_rerollBtn);

			// Initial layout
			updateLayout();
		}

		private function buildCards():void
		{
			var cardModels:Array = _viewModel.cardModels;
			// Remove extra cards if rewards shrank
			var card:RewardCard;
			while (_cardRenderers.length > cardModels.length)
			{
				card = _cardRenderers.pop();
				if (contains(card)) removeChild(card);
				card.destroy();
			}
			// Update or create cards
			for (var i:int = 0; i < cardModels.length; i++)
			{
				var model:RewardCardModel = cardModels[i];
				if (i < _cardRenderers.length)
				{
					// Update existing card
					card = _cardRenderers[i];
					card.setModel(model);
				}
				else
				{
					// Create new card
					card = new RewardCard(i + 1, model);
					card.addEventListener(CardEvent.CLAIM, onCardClaimed, false, 0, true);
					_cardRenderers.push(card);
					addChild(card);
				}
			}
		}

		private function onViewModelUpdated(e:ViewModelEvent):void
		{
			// Update currency display
			_currencyDisplay.coins = _viewModel.playerCoins;
			_currencyDisplay.gems = _viewModel.playerGems;
			buildCards();
			updateRerollInfo();
		}

		private function updateRerollInfo():void
		{
			var remaining:int = _viewModel.maxRerolls - _viewModel.rerollCount;
			if (remaining > 0)
			{
				_rerollInfo.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.REROLL_INFO), _viewModel.rerollCount, _viewModel.maxRerolls, remaining);
			}
			else
			{
				_rerollInfo.text = TextUtils.formatText(App.localizationManager.getString(LocaleKeys.REROLL_INFO_NO_LEFT), _viewModel.rerollCount, _viewModel.maxRerolls);
			}
		}

		private function onLayoutChanged(e:Event):void
		{
			_currentLayout = App.layoutManager.currentLayout;
			updateLayout();
		}

		private function updateLayout():void
		{
			// Example: adjust card positions for mobile/normal
			var isMobile:Boolean = (_currentLayout == LayoutManager.LAYOUT_MOBILE);
			var cardSpacing:int = isMobile ? 120 : 160;
			var cardStartX:int = isMobile ? 110 : 140;
			var cardY:int = isMobile ? 350 : 370;
			for (var i:int = 0; i < _cardRenderers.length; i++)
			{
				var card:Sprite = _cardRenderers[i];
				card.x = cardStartX + i * cardSpacing;
				card.y = cardY;
			}
			// Move reroll info and button
			_rerollInfo.x = cardStartX;
			_rerollInfo.y = isMobile ? 140 : 200;
			if (numChildren > 0)
			{
				var rerollBtn:Sprite = getChildAt(numChildren - 1) as Sprite;
				if (rerollBtn)
				{
					rerollBtn.x = cardStartX;
					rerollBtn.y = isMobile ? 170 : 230;
				}
			}
		}

		private function onRerollClicked(e:ButtonEvent):void
		{
			_viewModel.reroll();
		}

		private function onCardClaimed(e:CardEvent):void
		{
			var day:int = e.day;
			var idx:int = day - 1;
			_viewModel.claimReward(idx);
		}

		public function destroy():void
		{
			if (_viewModel)
			{
				_viewModel.removeEventListener(ViewModelEvent.UPDATED, onViewModelUpdated);
				_viewModel = null;
			}
			for each (var card:RewardCard in _cardRenderers)
			{
				if (card)
				{
					card.removeEventListener(CardEvent.CLAIM, onCardClaimed);
					card.destroy();
					if (contains(card)) removeChild(card);
				}
			}
			_cardRenderers.splice(0, _cardRenderers.length);
			_cardRenderers = null;
			if (_rerollInfo && contains(_rerollInfo)) removeChild(_rerollInfo);
			_rerollInfo = null;
			if (App.layoutManager)
			{
				App.layoutManager.removeEventListener(LayoutManager.LAYOUT_CHANGED, onLayoutChanged);
			}
			if (_rerollBtn)
			{
				_rerollBtn.removeEventListener(ButtonEvent.CLICK, onRerollClicked);
				_rerollBtn = null;
			}
		}
	}
}