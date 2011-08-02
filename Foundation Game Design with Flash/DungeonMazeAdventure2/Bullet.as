package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Bullet extends MovieClip
	{
		private var _vx:int;
		private var _vy:int;
		
		public function Bullet()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//Set the bullet's velocity
			_vx = 0;
			_vy = -10;
			
			//Set the bullet's start position to be the same as the weapon's
			x = MovieClip(parent).weapon.x;
			y = MovieClip(parent).weapon.y;
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			trace("bullet removed");
		}
		
		private function onEnterFrame(event:Event):void
		{
			rotation += 20;
			
			//Move the bullet
			x += _vx;
			y += _vy;
			
			/*send DungeonOne_Manager's checkCollisionWithEnemies
			method a reference of this object to check
			for collisions with the enemies*/
			MovieClip(parent).checkCollisionWithEnemies(this);
			
			/*Remove the bullet if it moves beyond the top of the stage*/
			if(this.y + this.height / 2 < 0)
			{
				parent.removeChild(this);
			}
		}
	}
}