package
{
	import collision.Collision;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DungeonOne_Manager extends MovieClip
	{
		public function DungeonOne_Manager()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			trace("Dungeon removed");
		}
		
		/*Most of game logic is programmed into the 
		onEnterFrame event handler*/
		private function onEnterFrame(event:Event):void
		{
			/*1. If the enemy still exist on the stage,
			check if the player is touching the
			enemies and reduce the player's health meter*/
			if(enemyOne != null)
			{
				if(player.hitTestObject(enemyOne))
				{
					this.health.meter.width--;
				}
			}
			if(enemyTwo != null)
			{
				if(player.hitTestObject(enemyTwo))
				{
					this.health.meter.width--;
				}
			}
			
			/*2. If the player's health meter is less than
			one pixel wide, the player has lost,
			Display the Game Over Screen.
			("GameOver" is a symbol in the Libary").*/
			if(this.health.meter.width < 1)
			{
				var gameOverLost:GameOver = new GameOver();
				gameOverLost.messageDisplay.text = "Game Over" + "\n" + "You Lost!";
				parent.addChild(gameOverLost);
				parent.removeChild(this);
			}
			
			/* 3. If the player is touching the key and
			doesn't have it, pick it up*/
			if(player.hitTestObject(doorKey))
			{
				if(! player.hasKey)
				{
					player.hasKey = true;
					player.addChild(doorKey);
					doorKey.x = 0;
					doorKey.y = 0;
					doorKey.rotation = 300;
				}
			}
			
			/*4. If the player is touching the door and has the
			key, and the door is closed, the open the door.
			Otherwise, the door must block the player*/
			if(player.hitTestObject(doorOne))
			{
				if(player.hasKey)
				{
					if(!doorOne.isOpen)
					{
						doorOne.isOpen = true;
						doorKey.visible = false;
					}
				}
				else
				{
					Collision.block(player, doorOne);
				}
			}
			
			/*5. If the player is touching the weapon, arm the
			weapon and allow the player to carry it*/
			if(player.hitTestObject(weapon))
			{
				weapon.isArmed = true;
				weapon.x = player.x - (player.width / 2);
				weapon.y = player.y;
			}
			
			/*6. If both enemyies are dead, open the second dorr
			otherwise, the door should block the player*/
			if((null == enemyOne) && (null == enemyTwo))
			{
				if(! doorTwo.isOpen)
				{
					doorTwo.isOpen = true;
				}
			}
			else
			{
				Collision.block(player, doorTwo);
			}
			
			/*7. If the player reaches the exit, the game has been
			won.Display the Game Over Screen*/
			if(player.hitTestPoint(exit.x, exit.y, true))
			{
				var gameOverWon:GameOver = new GameOver();
				gameOverWon.messageDisplay.text = "Game Over" + "\n" + "You Won!";
				parent.addChild(gameOverWon);
				parent.removeChild(this);
			}
				
		}
		
		/*8. Public methods that other classes can use to
		check for collisions with objects in the game*/
		
		/*A. Allow the wall objects to check for a collision with the player*/
		public function checkCollisionWithPlayer(wall:MovieClip)
		{
			if(player != null)
			{
				Collision.block(player, wall);
			}
		}
		
		/*B. Allow bullet objects to check for 
		collisions with the enemies*/
		public function checkCollisionWithEnemies(bullet:MovieClip)
		{
			//Enemy One
			if(enemyOne != null)
			{
				if(enemyOne.hitTestPoint(bullet.x, bullet.y, true))
				{
					enemyOne.subObject.meter.width -= 10;
					if(enemyOne.subObject.meter.width < 1)
					{
						enemyOne.subObject.stop();
						this.removeChild(enemyOne);
						enemyOne = null;
					}
					this.removeChild(bullet);
					bullet = null;
				}
			}
			
			//Enemy Two
			if(enemyTwo != null)
			{
				if(enemyTwo.hitTestPoint(bullet.x, bullet.y, true))
				{
					enemyTwo.subObject.meter.width -= 10;
					if(enemyTwo.subObject.meter.width < 1)
					{
						enemyTwo.subObject.stop();
						this.removeChild(enemyTwo);
						enemyTwo = null;
					}
					this.removeChild(bullet);
					bullet = null;
				}
			}
		}
	}
}