package  {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main_Character extends MovieClip{

		public function Main_Character() {
			init();
		}
		
		private function init():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		private function onKeyPress(event:KeyboardEvent):void
		{
			if(Keyboard.LEFT == event.keyCode)
			{
				player.x -= 10;
			}
			else if(Keyboard.RIGHT == event.keyCode)
			{
				player.x += 10;
			}
			else if(Keyboard.UP == event.keyCode)
			{
				player.y -= 10;
			}
			else if(Keyboard.DOWN == event.keyCode)
			{
				player.y += 10;
			}
		}

	}
	
}
