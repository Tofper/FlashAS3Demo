package models
{
    import flash.events.Event;
    import flash.events.EventDispatcher;

    public class PlayerModel extends EventDispatcher
    {
        private var _coins:int = 0;
        private var _gems:int = 0;

        public static const CURRENCY_CHANGED:String = "currencyChanged";

        public function PlayerModel() {}

        public function get coins():int { return _coins; }
        public function get gems():int { return _gems; }

        public function setCurrency(coins:int, gems:int):void
        {
            _coins = coins;
            _gems = gems;
            dispatchEvent(new Event(CURRENCY_CHANGED));
        }

        public function addCoins(amount:int):void
        {
            if (amount <= 0) return;
            _coins += amount;
            dispatchEvent(new Event(CURRENCY_CHANGED));
        }

        public function addGems(amount:int):void
        {
            if (amount <= 0) return;
            _gems += amount;
            dispatchEvent(new Event(CURRENCY_CHANGED));
        }
    }
}