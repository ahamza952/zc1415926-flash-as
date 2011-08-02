package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Player extends MovieClip
	{
		private var _vx:int;
		private var _vy:int;
		private var _hasKey:Boolean;
		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;
		
		public function Player()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void//相当于init
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_vx = 0;
			_vy = 0;
			_hasKey = false;
			_playerHalfWidth = this.width / 2;
			_playerHalfHeight = this.height / 2;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			trace("player removed");
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.UP)
			{
				_vy = -5;
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				_vy = 5;
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				_vx = -5;
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				_vx = 5;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN)
			{
				_vy = 0;
			}
			else if(event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				_vx = 0;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			this.x += _vx;
			this.y += _vy;
			
			if(this.x + _playerHalfWidth > stage.stageWidth)
			{
				this.x = stage.stageWidth - this._playerHalfWidth;
			}
			else if(this.x - _playerHalfWidth < 0)
			{
				this.x = 0 + _playerHalfWidth;
			}
			if(this.y + _playerHalfHeight > stage.stageHeight)
			{
				this.y = stage.stageHeight - _playerHalfHeight;
			}
			else if(this.y - _playerHalfHeight < 0)
			{
				this.y = 0 + _playerHalfHeight;
			}
		}
		
		/**
		 * Getters and setters used for keeping
		 * track of whether the player has the key
		 * 
		 * @return 是否拥有钥匙
		 */
		public function get hasKey():Boolean
		{
			return _hasKey;
		}
		
		public function set hasKey(keyState:Boolean)//不写返回类型
		{
			_hasKey = keyState;
		}
	}
}