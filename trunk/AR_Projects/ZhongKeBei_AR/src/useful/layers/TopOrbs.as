package useful.layers
{
	import alternativa.engine3d.primitives.Sphere;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import useful.CustomEvent.OrbsEvent;
	import useful.components.Button;
	
	public class TopOrbs extends Sprite
	{
		public var sun:Button = new Button("sun.swf");
		public var shuiXing:Button = new Button("shuiXing.swf");
		private var jinXing:Button = new Button("jinXing.swf");
		private var earth:Button = new Button("earth.swf");
		private var huoXing:Button = new Button("huoXing.swf");
		private var muXing:Button = new Button("muXing.swf");
		private var tuXing:Button = new Button("tuXing.swf");
		private var tianWangXing:Button = new Button("tianWangXing.swf");
		private var haiWangXing:Button = new Button("haiWangXing.swf");
		
		private var velocityX:Number = 0;
		private var preX:Number = 0;
		private var preMouseX:Number = 0;
		private var bigThanZeroVx:Boolean;
		private var accelerationX:Number;
		
		//[SWF(backgroundColor="#000000")]

		public function TopOrbs()
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			var backgroundBitmap:Bitmap = new Bitmap(new BitmapData(1200, 100, false, 0x000000));
			backgroundBitmap.x = -600;
			addChild(backgroundBitmap);
		
			sun.x = -400;
			sun.y = 40;
			sun.name = "sun";
	
			sun.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			addChild(sun);
			
			shuiXing.x = -300;
			shuiXing.y = 40;
			shuiXing.name = "shuiXing";
			shuiXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(shuiXing);
			
			
			jinXing.x = -200;
			jinXing.y = 40;
			jinXing.name = "jinXing";
			jinXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(jinXing);
			
		
			earth.x = -100;
			earth.y = 40;
			earth.name = "earth";
			earth.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(earth);
			
		
			huoXing.x = 0;
			huoXing.y = 40;
			huoXing.name = "huoXing";
			huoXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(huoXing);
			
			
			muXing.x = 100;
			muXing.y = 40;
			muXing.name = "muXing";
			muXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(muXing);
			
		
			tuXing.x = 240;
			tuXing.y = 40;
			tuXing.name = "tuXing";
			tuXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(tuXing);
			
			tianWangXing.x = 380;
			tianWangXing.y = 40;
			tianWangXing.name = "tianWangXing";
			tianWangXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(tianWangXing);
			
			
			haiWangXing.x = 480;
			haiWangXing.y = 40;
			haiWangXing.name = "haiWangXing";
			haiWangXing.addEventListener(MouseEvent.CLICK, onOrbsClicked);
			
			addChild(haiWangXing);
		}
		
		private function onOrbsClicked(e:MouseEvent):void
		{
			trace("!!!!!" + e.currentTarget.name);
		
			switch(e.currentTarget.name)
			{
				case "sun":
					var orbsEvent1:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent1.orbname = "sun";//这一行和下一行的不能换，要是先发事件了，给一个属性赋值也没什么用了
					dispatchEvent(orbsEvent1);
					
					break;
				
				case "shuiXing":
					var orbsEvent2:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent2.orbname = "shuiXing";
					dispatchEvent(orbsEvent2);

					break;
				
				case "jinXing":
					var orbsEvent3:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent3.orbname = "jinXing";
					dispatchEvent(orbsEvent3);
					break;
				
				case "earth":
					var orbsEvent4:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent4.orbname = "earth";
					dispatchEvent(orbsEvent4);
					break;
				
				case "huoXing":
					var orbsEvent5:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent5.orbname = "huoXing";
					dispatchEvent(orbsEvent5);
					break;
				
				case "muXing":
					var orbsEvent6:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent6.orbname = "muXing";
					dispatchEvent(orbsEvent6);
					break;
				
				case "tuXing":
					var orbsEvent7:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent7.orbname = "tuXing";
					dispatchEvent(orbsEvent7);
					break;
				
				case "tianWangXing":
					var orbsEvent8:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent8.orbname = "tianWangXing";
					dispatchEvent(orbsEvent8);
					break;
				
				case "haiWangXing":
					var orbsEvent9:OrbsEvent = new OrbsEvent(OrbsEvent.ORB_CLICK);
					orbsEvent9.orbname = "haiWangXing";
					dispatchEvent(orbsEvent9);
					break;
			}
		}		
		
		private function onMouseDown(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, onMouseDownEnterFrame);
			
			preX = this.x;
			preMouseX = mouseX;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, onMouseDownEnterFrame);
			}
		}
		
		private function onMouseDownEnterFrame(e:Event):void
		{
			accelerationX = 1.2;
			
			this.x += mouseX - preMouseX;
			velocityX = this.x - preX;
			
			if(velocityX > 30)
				velocityX = 30;
			else if(velocityX < -30)
				velocityX = -30;
			
			if(velocityX > 0)
				bigThanZeroVx = true;
			else
				bigThanZeroVx = false;
			
			preMouseX = mouseX;
			preX = this.x;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onMouseDownEnterFrame);
			
			addEventListener(Event.ENTER_FRAME, onMouseUpEnterFrame);
		}
		
		private function onMouseUpEnterFrame(e:Event):void
		{
			this.x += velocityX;
			//trace(velocityX);
			
			if(bigThanZeroVx)
			{
				if(velocityX > 0)
				{
					velocityX -= accelerationX;
				}
				else
				{
					velocityX = 0;
				}
			}
			else
			{
				if(velocityX < 0)
				{
					velocityX += accelerationX;
				}
				else
				{
					velocityX = 0;
				}
			}
			
			if((this.x + this.width / 2) < 320/*this.parent.widthstage.stageWidth*/)
			{
				this.x = stage.stageWidth - this.width / 2;
				velocityX = -velocityX; //+ 1;
					//accelerationX = 2;
					bigThanZeroVx = false;
			}
			else if((this.x - this.width / 2) > 0)
			{
				this.x = 0 + this.width / 2;
				velocityX = -velocityX; //- 1;
					//accelerationX = 2;
					bigThanZeroVx = true;
			}
		}
	}
}