package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	public class Door extends MovieClip
	{
		private var _isOpen:Boolean;
		private var _chimes:Chimes;
		private var _soundChannel:SoundChannel;
		
		public function Door()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{				
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_isOpen = false;
			_chimes = new Chimes();
			_soundChannel = new SoundChannel();
			this.visible = true;//别以为这句没有用，要是动态加入的或是其他情况要先确认visible = true
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			trace("door removed");
		}
		
		//Getters and setters
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(doorState:Boolean)
		{
			_isOpen = doorState;
			if(_isOpen)
			{
				_soundChannel = _chimes.play();
				this.visible = false;
			}
			else
			{
				this.visible = true;
			}
		}
	}
}