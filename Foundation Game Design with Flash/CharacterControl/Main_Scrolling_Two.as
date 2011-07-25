package  {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class Main_Scrolling_Two extends MovieClip
	{
		
		private var vx:int;
		private var vy:int;
		private var rightInnerBoundary:uint;
		private var leftInnerBoundary:uint;
		private var topInnerBoundary:uint;
		private var bottomInnerBoundary:uint;
		
		public function Main_Scrolling_Two()
		{
			init();
		}
		
		private function init():void
		{
			vx = 0;
			vy = 0;
			rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
			leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4);
			topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4);
			bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);

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

			//Move the player
			player.x += vx;
			player.y += vy;
			
			//Stop player at inner boundary edges
			if(player.x - playerHalfWidth < leftInnerBoundary)
			{
				player.x = leftInnerBoundary + playerHalfWidth;
				rightInnerBoundary = (stage.stageWidth / 2) + (stage.stageWidth / 4);
				background.x -= vx;
			}
			else if(player.x + playerHalfWidth > rightInnerBoundary)
			{
				player.x = rightInnerBoundary - playerHalfWidth;
				leftInnerBoundary = (stage.stageWidth / 2) - (stage.stageWidth / 4);
				background.x -= vx;
			}
			if(player.y - playerHalfHeight < topInnerBoundary)
			{
				player.y = topInnerBoundary + playerHalfHeight;
				bottomInnerBoundary = (stage.stageHeight / 2) + (stage.stageHeight / 4);
				background.y -= vy;
			}
			else if(player.y + playerHalfHeight > bottomInnerBoundary)
			{
				player.y = bottomInnerBoundary - playerHalfHeight;
				topInnerBoundary = (stage.stageHeight / 2) - (stage.stageHeight / 4);
				background.y -= vy;
			}
			
			//Stop background at stage edges
			if(background.x + backgroundHalfWidth < stage.stageWidth)
			{
				background.x = stage.stageWidth - backgroundHalfWidth;
				rightInnerBoundary = stage.stageWidth;
			}
			else if(background.x - backgroundHalfWidth > 0)
			{
				background.x = 0 + backgroundHalfWidth;
				leftInnerBoundary = 0;
			}
			
			if(background.y - backgroundHalfHeight > 0)
			{
				background.y = 0 + backgroundHalfHeight;
				topInnerBoundary = 0;
			}
			else if(background.y + backgroundHalfHeight < stage.stageHeight)
			{
				background.y = stage.stageHeight - backgroundHalfHeight;
				bottomInnerBoundary = stage.stageHeight;
			}
		}
	}
	
}
