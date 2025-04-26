package managers
{
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	/**
	 * AnimationManager provides simple tweening and animation utilities for display objects.
	 *
	 * Responsibilities:
	 * - Tween display object properties over time
	 * - Support delayed and frame-based animations without third-party libraries
	 */
	public class AnimationManager
	{

		public function AnimationManager()
		{
			super();
		}

		/**
		 * Tweens the target Sprite's properties with optional delay.
		 * @param target The Sprite to animate.
		 * @param animProps Animation properties (delay, properties, duration, easing).
		 * @param callback Optional callback to invoke after animation completes.
		 */
		public function tween(target:Sprite, animProps:Object, callback:Function = null):void
		{
			var delayMs:int = animProps.delay || 0;
			var doTween:Function = function():void
			{
				tweenProperties(target, animProps, callback);
			};
			if (delayMs > 0)
			{
				setTimeout(doTween, delayMs);
			}
			else
			{
				doTween();
			}
		}

		/**
		 * Performs a frame-based tween for multiple properties.
		 * @param target The Sprite to animate.
		 * @param animProps Animation properties (properties, duration, easing).
		 * @param callback Optional callback to invoke after animation completes.
		 */
		public function tweenProperties(target:Sprite, animProps:Object, callback:Function = null):void
		{
			var props:Array = animProps.properties || [];
			var duration:Number = animProps.duration || 0.5; // seconds
			var easing:Function = animProps.easing || function(t:Number):Number
			{
				return t;
			};
			var fps:int = 30;
			var totalFrames:int = Math.round(duration * fps);
			var frame:int = 0;
			var startVals:Array = [];
			var endVals:Array = [];
			for each (var propObj:Object in props)
			{
				startVals.push(propObj.from);
				endVals.push(propObj.to);
				target[propObj.prop] = propObj.from;
			}
			var onFrame:Function = function(e:*):void
			{
				frame++;
				var t:Number = frame / totalFrames;
				if (t > 1) t = 1;
				t = easing(t);
				for (var i:int = 0; i < props.length; i++)
				{
					var propName:String = props[i].prop;
					var fromVal:Number = startVals[i];
					var toVal:Number = endVals[i];
					target[propName] = fromVal + (toVal - fromVal) * t;
				}
				if (frame >= totalFrames)
				{
					target.removeEventListener("enterFrame", onFrame);
					if (callback != null) callback();
				}
			};
			target.addEventListener("enterFrame", onFrame);
		}
	}
}