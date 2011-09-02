package zc
{
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;

	public class MouseDrag
	{
		public var previousMouseX:Number; 
		public var previousMouseY:Number;
		public var camPitch:Number = 90; 
		public var camYaw:Number = 270; 
		public var isOrbiting:Boolean;
		
		public function MouseDrag()
		{
		}
		public function onMouseDown(e:MouseEvent):void
		{
			isOrbiting = true;
			previousMouseX = e.stageX;
			previousMouseY = e.stageY;
		}
		public function onMouseUp(e:MouseEvent):void
		{
			isOrbiting = false;
		}
		public function onMouseMove(e:MouseEvent):void
		{
			var differenceX:Number = e.stageX - previousMouseX;
			var differenceY:Number = e.stageY - previousMouseY;
			if(isOrbiting)
			{
				camPitch -= differenceY;
				camYaw += differenceX;
				previousMouseX = e.stageX; 
				previousMouseY = e.stageY; 
			}
		}
	}
}