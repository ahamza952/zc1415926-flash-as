/**
 *程序起始画面
 * @authoer zc1415926 
 */
package useful.layers
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import useful.components.Button;
	import useful.embedmanager.EmbedManager;
	//import useful.layers.lyrics.EarthMp3Lyric;
	
	public class BeginLayer extends Sprite
	{
		private var beginButton:Button;
		private var introButton:Button;
		private var escButton:Button;
		private var backgroundImage:Bitmap;
		
		//private var earthsound:EarthMp3Lyric;
		
		public function BeginLayer()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		private function onAddedToStage(event:Event):void
		{
			//init();
		//	stage.align = StageAlign.TOP_LEFT;
			addBackground();
			addBeginButton();
			addIntroButton();
			addEscButton();
			
			//earthsound = new EarthMp3Lyric();
			//addChild(earthsound);
		}
		
		private function addBackground():void
		{
		//	//backgroundImage = new Loader();
			//backgroundImage.load(new URLRequest("/assets/background1.jpg"));
			//addChild(backgroundImage);
			backgroundImage = new Bitmap(new EmbedManager.BeginLayerBackground().bitmapData);
			addChild(backgroundImage);
		}
		
		private function addBeginButton():void
		{
			beginButton = new Button("BeginButton.swf");	
			beginButton.x = 160;
			beginButton.y = 310;
			addChild(beginButton);
			
			beginButton.addEventListener(MouseEvent.CLICK, onBeginButtonClicked);
		}
		
		private function addIntroButton():void
		{
			introButton = new Button("IntroButton.swf");
			introButton.x = 160;
			introButton.y = 360;
			addChild(introButton);
			
			introButton.addEventListener(MouseEvent.CLICK, onIntroButtonClicked);
		}
		
		private function addEscButton():void
		{
			escButton = new Button("EscButton.swf");
			escButton.x = 160;
			escButton.y = 410;
			addChild(escButton);
			
			escButton.addEventListener(MouseEvent.CLICK, onEscButtonClicked);
		}
		
		private function onBeginButtonClicked(event:MouseEvent):void
		{
			this.beginButton.removeEventListener(MouseEvent.CLICK, onBeginButtonClicked);
			this.introButton.removeEventListener(MouseEvent.CLICK, onIntroButtonClicked);
			this.escButton.removeEventListener(MouseEvent.CLICK, onEscButtonClicked);
			this.removeChild(backgroundImage);
			this.removeChild(beginButton);
			this.removeChild(introButton);
			this.removeChild(escButton);
			this.backgroundImage = null;
			this.beginButton = null;
			this.introButton = null;
			this.escButton = null;
			
			//removeChild(earthsound);
			
			this.parent.removeChild(this);
			
		}
		
		private function onIntroButtonClicked(event:MouseEvent):void
		{
			var introLayer:IntroLayer = new IntroLayer();
			addChild(introLayer);
		}
		
		private function onEscButtonClicked(event:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
	}
}