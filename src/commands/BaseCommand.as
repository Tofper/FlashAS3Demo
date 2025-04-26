package commands
{

	public class BaseCommand implements ICommand
	{
		public function execute():String
		{
			throw new Error("execute() must be implemented by subclasses and return a CommandResult String.");
		}
	}
}