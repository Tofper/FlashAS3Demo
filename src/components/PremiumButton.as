package components
{
	import components.BaseButton;
	import facades.App;
	import managers.LocaleKeys;

	public class PremiumButton extends BaseButton
	{
		public function PremiumButton()
		{
			super();
			label = App.localizationManager.getString(LocaleKeys.CLAIM);
		}
	}
}