package  {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class Main_ScreenWrapping extends MovieClip{
		
		private var vx:int;
		private var vy:int;
		
		public function Main_ScreenWrapping() {
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
			
			//Move the player
			player.x += vx;
			player.y += vy;
			
			//Screen wrapping
			if(player.x - playerHalfWidth > stage.stageWidth)
			{
				player.x = 0 - playerHalfWidth;
			}
			else if(player.x + playerHalfWidth < 0)
			{
				player.x = stage.stageWidth + playerHalfWidth;
			}
			else if(player.y - playerHalfHeight > stage.stageHeight)
			{
				player.y = 0 - playerHalfHeight;
			}
			else if(player.y + playerHalfHeight < 0)
			{
				player.y = stage.stageHeight + playerHalfHeight;
			}
		}
	}
	
}
