package components
{
	import components.PremiumButton;
	import events.ButtonEvent;
	import managers.LocaleKeys;
	import facades.App;

	public class RerollButton extends PremiumButton
	{

		public function RerollButton()
		{
			super();
			label = App.localizationManager.getString(LocaleKeys.REROLL);
		}
	}
}