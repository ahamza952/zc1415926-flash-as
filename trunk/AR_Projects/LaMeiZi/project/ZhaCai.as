package
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	
	public class ZhaCai extends MovieClip
	{
		
		
		public function ZhaCai()
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			MovieClip(parent).checkCollisionWithPlayer(this);
		}
	}
	
}
