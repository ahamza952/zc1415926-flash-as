package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EscButton extends MovieClip
	{	
		public function EscButton() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			stop();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			gotoAndStop(2)
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			gotoAndStop(1);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			gotoAndStop(3);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			gotoAndStop(2);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
	}
	
}
