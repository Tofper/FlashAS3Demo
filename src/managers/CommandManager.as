package managers
{
	import commands.ICommand;

	/**
	 * CommandManager executes ICommand instances and keeps a history of executed commands.
	 *
	 * Responsibilities:
	 * - Execute commands with optional arguments
	 * - Store a history of executed commands for potential undo/redo
	 */
	public class CommandManager
	{
		private var _history:Array = [];
		private var _maxHistory:int;

		public function CommandManager(maxHistory:int = 100)
		{
			_maxHistory = maxHistory;
		}

		/**
		 * Executes a command and stores it in the history.
		 * @param command ICommand instance to execute.
		 * @return The result of the command's execute method.
		 */
		public function execute(command:ICommand):String
		{
			var result:String = command.execute();

			_history.push(command);
			if (_history.length > _maxHistory)
			{
				_history.shift();
			}

			return result;
		}

		/**
		 * Returns a copy of the command execution history.
		 * @return Array of executed ICommand instances.
		 */
		public function get history():Array
		{
			return _history.concat();
		}

		/**
		 * Clears the command execution history.
		 */
		public function clearHistory():void
		{
			_history = [];
		}
	}
}