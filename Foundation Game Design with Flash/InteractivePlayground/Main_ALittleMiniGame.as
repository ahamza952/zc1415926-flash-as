package 
{

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;

	public class Main_Playground extends MovieClip
	{
		private var vx:int;
		private var vy:int;
		private var score:uint;
		private var collistionHasOccurred:Boolean;

		public function Main_Playground()
		{
			init();
		}
		private function init():void
		{
			//initialize variables
			vx = 0;
			vy = 0;
			score = 0;
			collistionHasOccurred = false;
			
			//initialize objects
			enemy.stop();

			//Add event listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown1);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp1);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onKeyDown1(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT)
			{
				vx = -5;
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				vx = 5;
			}
			else if (event.keyCode == Keyboard.UP)
			{
				vy = -5;
			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				vy = 5;
			}
		}
		private function onKeyUp1(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				vx = 0;
			}
			else if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
			{
				vy = 0;
			}
		}
		private function onEnterFrame(event:Event):void
		{
			//Move the player
			player.x += vx;
			player.y+=vy;
			
			//Collision detection
			if(player.hitTestObject(enemy))
			{
				//messageDisplay.text = "Ouch!!";
				enemy.gotoAndStop(2);
				//health.meter.width--;
				if(health.meter.scaleX > 0)
				{
					health.meter.scaleX -= 0.02;
				}
				if(! collistionHasOccurred)
				{
					score++;
					messageDisplay.text = String(score);
					collistionHasOccurred = true;
				}
			}
			else
			{
				//messageDisplay.text = "No collistion...";
				enemy.gotoAndStop(1);
				collistionHasOccurred = false;
			}
			
			//Check for end of game
			if(health.meter.scaleX <= 0/*.width < 1*/)
			{
				messageDisplay.text = "Game Over!";
			}
			if(score >= 5)
			{
				messageDisplay.text = "You won!";
			}
		}
	}
}