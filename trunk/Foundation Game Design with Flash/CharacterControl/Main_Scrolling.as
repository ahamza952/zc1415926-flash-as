package  {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class Main_Scrolling extends MovieClip
	{
		
		private var vx:int;
		private var vy:int;
		
		public function Main_Scrolling()
		{
			init();
		}
		
		private function init():void
		{
			vx = 0;
			vy = 0;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown1);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp1);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onKeyDown1(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.LEFT)
			{
				vx = -5;
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				vx = 5;
			}
			else if(event.keyCode == Keyboard.UP)
			{
				vy = -5;
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				vy = 5;
			}
		}
		
		private function onKeyUp1(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				vx = 0;
			}
			else if(event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
			{
				vy = 0;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			//Initialize local variables
			var playerHalfWidth:uint = player.width / 2;
			var playerHalfHeight:uint = player.height / 2;
			var backgroundHalfWidth:uint = background.width / 2;
			var backgroundHalfHeight:uint = background.height / 2;
			
			//Move th background
			background.x += -vx;
			background.y += -vy;
			
			//Stop background at stage edges
			if(background.x + backgroundHalfWidth < stage.stageWidth)
			{
				background.x = stage.stageWidth - backgroundHalfWidth;
			}
			else if(background.x - backgroundHalfWidth > 0)
			{
				background.x = 0 + backgroundHalfWidth;
			}
			
			if(background.y - backgroundHalfHeight > 0)
			{
				background.y = 0 + backgroundHalfHeight;
			}
			else if(background.y + backgroundHalfHeight < stage.stageHeight)
			{
				background.y = stage.stageHeight - backgroundHalfHeight;
			}
		}
	}
	
}
