package zc
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class PlaneOnStage extends Sprite//extends Bitmap不一定这个类就直接返回Bitmap，Bitmap可以是它的一个属性
	{
		//private var tweenType:String;
		private var picLoader:Loader;
		public var bitmap:Bitmap;
		
		private var tweenBitmap:Function = function():void{};
		
		public function PlaneOnStage(urlRequest:URLRequest, 
									 tweenType:String = null, 
									 addX:Number = 0,
									 addY:Number = 0,
									 time:Number = 0
		)
		{
			//this.tweenType = tweentype;
			
			picLoader = new Loader();
			picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPicLoadComplete);
			picLoader.load(urlRequest);
			
			if("position" == tweenType)
			{
				this.tweenBitmap = function():void
				{
					positionTween(addX, addY, time);
				}
			}
			if("alpha" ==  tweenType)
			{
				
				
				this.tweenBitmap = function():void
				{
					bitmap.alpha = 0;
					alphaTween(time);
				}
			}
			
			//this.x = (this.stageWidth - this.width) / 2;
			//this.y = (this.stage.stageHeight - this.height) / 2;
		}
		
		private function onPicLoadComplete(e:Event):void
		{
			
			bitmap = Bitmap(picLoader.content);
			//trace("bitmap.name" + bitmap.name);
			this.addChild(this.bitmap);
			//this.parent.addChild(this.bitmap);
			this.addEventListener(MouseEvent.CLICK, onMouseClicked);
			//Tweener.addTween(bitmap,{scaleX:bitmap.scaleX + 2,scaleY:bitmap.scaleY + 2,time:5});
			
			//this.width = bitmap.width;
			//this.height = bitmap.height;
			
			this.tweenBitmap();
		}
		
		private function onMouseClicked(e:MouseEvent):void
		{
			this.removeChild(this.bitmap);
		}
		
		public function positionTween(addX:Number, addY:Number, tweenTime:Number):void
		{
			Tweener.addTween(bitmap,{
				x:bitmap.x + addX, 
				y:bitmap.y, 
				time:tweenTime
			});
		}
		
		public function alphaTween(tweenTime:Number):void
		{
			Tweener.addTween(bitmap,{
				alpha:bitmap.alpha + 1,
				time:tweenTime
			});
		}
		
		public function get tweenbitmap():Function
		{
			return tweenBitmap;
		}
		
		public function set tweenbitmap(value:Function):void
		{
			this.tweenBitmap = value;
		}
		
	}
}