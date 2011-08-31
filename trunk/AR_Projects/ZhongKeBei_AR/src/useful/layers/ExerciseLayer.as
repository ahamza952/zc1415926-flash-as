package useful.layers
{
	import caurina.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.display.transfer.Cataclasm;
	import ghostcat.util.Util;
	
	import useful.embedmanager.EmbedManager;
	import useful.layers.WuLengZhu.WuLengZhu;
	
	public class ExerciseLayer extends Sprite
	{
		[Embed(source="assets/exercise.jpg")]
		static public const Exercise:Class;
		
		public var cataclasm:Cataclasm;
		//private var removeItselfTimer:Timer;
		//private var wuLengZhu:WuLengZhu;
		
		public function ExerciseLayer()
		{
			cataclasm = new Cataclasm(new Exercise());
			addChild(Util.createObject(new ResidualScreen(320,460),{blurSpeed:4,fadeSpeed:0.7,children:[cataclasm]}));

			
			addEventListener(MouseEvent.CLICK,onMouseClicked);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//removeEventListener(MouseEvent.CLICK,onMouseClicked);
			//removeItselfTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		
			cataclasm = null;
			//removeItselfTimer = null;
		}
		
		private function onMouseClicked(e:MouseEvent):void
		{
			cataclasm.bomb(new Point(mouseX, mouseY));
			//this.parent.removeChild(this);
			
			//removeItselfTimer = new Timer(4000, 1);
			//removeItselfTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			//removeItselfTimer.start();
			var justMakeADelay:Shape = new Shape();
			Tweener.addTween(justMakeADelay,{
				x:5,
				time:4,
				onComplete:onTimerComplete
			});
			
		}
		
		private function onTimerComplete():void
		{
			//var wuLengZhu:WuLengZhu = new WuLengZhu();
			//this.parent.addChild(wuLengZhu)
		/*	removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK,onMouseClicked);
			removeItselfTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			cataclasm = null;
			removeItselfTimer = null;*/
			this.parent.removeChild(this);
		}
	}
}