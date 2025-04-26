package commands
{
	import commands.BaseCommand;
	import commands.constants.CommandResult;

	public class CommandTemplate extends BaseCommand
	{
		override public function execute():String
		{
			// Command logic
			return CommandResult.SUCCESS;
		}
	}
}