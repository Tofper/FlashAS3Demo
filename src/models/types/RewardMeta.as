package models.types {
    public class RewardMeta {
        public var id:String;
        public var icon:String;
        public var label:String;
        public var description:String;
        public var rarity:String;

        public function RewardMeta(id:String, icon:String, label:String, description:String, rarity:String) {
            this.id = id;
            this.icon = icon;
            this.label = label;
            this.description = description;
            this.rarity = rarity;
        }
    }
} 