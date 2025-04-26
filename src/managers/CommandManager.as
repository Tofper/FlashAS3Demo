package managers {
	import commands.ICommand;

    /**
     * CommandManager executes ICommand instances and keeps a history of executed commands.
     *
     * Responsibilities:
     * - Execute commands with optional arguments
     * - Store a history of executed commands for potential undo/redo
     */
    public class CommandManager {
        private var _history:Array = [];

        public function CommandManager() {}

        /**
         * Executes a command and stores it in the history.
         * @param command The ICommand to execute.
         * @param ...args Optional arguments to pass to the command's execute method.
         * @return The result of the command's execute method.
         */
        public function execute(command:ICommand, ...args):* {
            var result:* = command.execute.apply(command, args);
            _history.push(command);
            return result;
        }

        /**
         * Returns a copy of the command execution history.
         * @return Array of executed ICommand instances.
         */
        public function get history():Array {
            return _history.concat();
        }
    }
}