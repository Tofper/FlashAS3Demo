package components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import events.ButtonEvent;
	import common.IDestroyable;

	public class BaseButton extends Sprite implements IDestroyable
	{
		protected var labelField:TextField;
		protected var _label:String = "BUTTON";

		public function BaseButton()
		{
			// Draw button background
			var bgWidth:int = 80;
			var bgHeight:int = 32;
			var bgRadius:int = 8;
			var bgColor:uint = 0xF5F5F5;
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(bgColor, 1);
			bg.graphics.lineStyle(2, 0xCCCCCC);
			bg.graphics.drawRoundRect(0, 0, bgWidth, bgHeight, bgRadius);
			bg.graphics.endFill();
			addChild(bg);

			// Create label text
			labelField = new TextField();
			var fmt:TextFormat = new TextFormat("Arial", 20, 0x222222, true);
			labelField.defaultTextFormat = fmt;
			labelField.text = _label;
			labelField.width = bgWidth;
			labelField.height = bgHeight;
			labelField.x = 0;
			labelField.y = 0;
			labelField.selectable = false;
			labelField.mouseEnabled = false;
			labelField.setTextFormat(fmt);
			labelField.autoSize = "center";
			addChild(labelField);

			// Enable button behavior
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
		}

		private function onClickHandler(e:MouseEvent):void
		{
			onClick();
		}

		/**
		 * Override this method in subclasses to handle click logic.
		 */
		protected function onClick():void
		{
			// Default behavior: dispatch generic button click event
			dispatchEvent(new ButtonEvent(ButtonEvent.CLICK, true));
		}

		public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK, onClickHandler);
			cleanup();
		}

		/**
		 * Hook for subclasses: cleans up label field. Subclasses should override and call super.cleanup().
		 */
		protected function cleanup():void
		{
			if (contains(labelField)) removeChild(labelField);
			labelField = null;
		}

		public function set label(value:String):void
		{
			if (_label === value) return;
			_label = value;
			if (labelField)
			{
				labelField.text = _label;
			}
		}
	}
}