package useful
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.display.transfer.Cataclasm;
	import ghostcat.util.Util;
	
	import useful.embedmanager.ImageEmbed;
	
	public class YuZou extends Sprite
	{
		//public var c:Class;
		public var s:Cataclasm;
		private var step:int = 1;
		
		public function YuZou()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			//new EnabledSWFScreen(stage/*Sprite(root)*/);
			
			s = new Cataclasm(new ImageEmbed.YuZhou());
			addChild(Util.createObject(new ResidualScreen(600, 480), {blurSpeed:4,fadeSpeed:0.7,children:[s]}));
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClicked);
		}
		
		private function onMouseClicked(event:MouseEvent):void
		{
			//if(step == 0)
				//s.createTris();
			//else 
				s.bomb(new Point(mouseX, mouseY));
			
			step = (++step) % 2;
		}
	}
}