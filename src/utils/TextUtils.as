package utils {
    public class TextUtils {
        public function TextUtils() {}

        public static function formatText(str:String, ...args):String {
            for (var i:int = 0; i < args.length; i++) {
                str = str.split("{" + i + "}").join(args[i]);
            }
            return str;
        }
    }
} 