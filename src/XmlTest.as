package

{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.engine.ContentElement;
	
	import zc.PlaneOnStage;
	
	public class XmlTest extends Sprite
	{
		private var picXml:XML;
		private var picLoader:Loader;
		
		private var image:Bitmap;
		
		public var planeOnStage:PlaneOnStage ;
		
		public function XmlTest()
		{
			var xmlRequest:URLRequest = new URLRequest("./xml/pictures.xml");
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadComplete);
			xmlLoader.load(xmlRequest);
			//var xmlPictures:XML = new XML(xmlLoader.data);
			
			//trace(xmlPictures.pic[0].toString());
			/*var picLoader:Loader = new Loader();
			picLoader.load(new URLRequest(picXml.pic[0].toString()));
			
			var image:Bitmap = Bitmap(picLoader.content);
			var bitmap:BitmapData = image.bitmapData;
			addChild(image);*/
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		private function onXmlLoadComplete(e:Event):void
		{
			try
			{
				picXml = new XML(e.target.data);
				trace(picXml);
				trace(picXml.pic.length());
				trace(picXml.pic[0].toString());
				
				picLoader = new Loader();
				picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPicLoadComplete);
				//picLoader.load(new URLRequest(String(picXml.pic[0])));
				//picLoader.load(new URLRequest(picXml.pic[2]));
				picLoader.load(new URLRequest("dfbb.jpg"));
				
			}
			catch(e:TypeError)
			{
				trace( "Could not parse text into XML" );
				trace( e.message );
			}
		}
		private function onPicLoadComplete(e:Event):void
		{
			image = Bitmap(picLoader.content);
			var bitmap:BitmapData = image.bitmapData;
			image.scaleX = 0;
			image.scaleY = 0;
			trace(image);
			addChild(image);
			
			//planeOnStage = new PlaneOnStage(new URLRequest("hvatar.jpg"), "position",300,300,5);
			planeOnStage = new PlaneOnStage(new URLRequest("hvatar.jpg"), "alpha",0,0,10);

			addChild(planeOnStage);
			//trace(planeOnStage.toString());
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			removeChild(planeOnStage);
			//this.planeOnStage.parent.removeChild(planeOnStage.bitmap);
			
			Tweener.addTween(image,{
				scaleX:image.scaleX + 1,
				scaleY:image.scaleY + 1,
				time:3,
				transition:"easeInBounce"
			});
		}
	}
}