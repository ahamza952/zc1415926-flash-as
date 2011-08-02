package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Weapon extends MovieClip
	{
		private var _isArmed:Boolean;
		
		public function Weapon()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//initialize variables
			_isArmed = false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE)
			{
				shootBullet();
			}
		}
		
		private function shootBullet():void
		{
			if(_isArmed)
			{
				parent.addChild(new Bullet());
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			rotation += 2;
		}
		
		//Getters and setters
		public function get isArmed():Boolean
		{
			return _isArmed;
		}
		
		public function set isArmed(weaponState:Boolean)
		{
			_isArmed = weaponState;
		}
	}
}