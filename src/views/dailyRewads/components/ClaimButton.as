package views.dailyRewads.components
{
	import components.BaseButton;
	import events.ButtonEvent;
	import providers.GameProvider;
	import models.PlayerModel;
	import managers.LocaleKeys;
	import facades.App;

	public class ClaimButton extends BaseButton
	{
		public function ClaimButton()
		{
			super();
			label = App.localizationManager.getString(LocaleKeys.CLAIM);
		}
	}
}