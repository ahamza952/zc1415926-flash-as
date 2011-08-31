package useful.layers
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import useful.components.Button;
	import useful.embedmanager.EmbedManager;
	
	public class IntroLayer extends Sprite
	{
		private var backButton:Button;
		private var backgroundImage:Bitmap;
		
		public function IntroLayer()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addBackground();
			addBackButton();
		}
		
		private function addBackground():void
		{
			backgroundImage = new Bitmap(new EmbedManager.IntroBackground().bitmapData);
			addChild(backgroundImage);
		}
		
		private function addBackButton():void
		{
			backButton = new Button("Back.swf");
			backButton.x = 161;
			backButton.y = 425;
			backButton.addEventListener(MouseEvent.CLICK, onBackButtonClicked);
			addChild(backButton);
		}
		
		private function onBackButtonClicked(e:MouseEvent):void
		{
			backButton.removeEventListener(MouseEvent.CLICK, onBackButtonClicked);

			this.removeChild(backButton);
			this.removeChild(backgroundImage);
			
			backButton = null;
			backgroundImage = null;
			
			this.parent.removeChild(this);
		}
	}
}