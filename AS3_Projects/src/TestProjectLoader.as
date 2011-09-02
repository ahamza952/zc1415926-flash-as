package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TestProjectLoader extends Sprite
	{
		private var pic3DWall:Pic3DWall2;
		
		public function TestProjectLoader()
		{
			this.pic3DWall = new Pic3DWall2();
			this.addChild(pic3DWall);
			
			this.addEventListener(MouseEvent.CLICK, removePic3DWall);
		}
		
		private function removePic3DWall(evt:MouseEvent):void
		{
			this.removeChild(pic3DWall);
		}
	}
}