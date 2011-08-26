/**
 * 程序主入口
 * @author zc1415926
 */
package
{
	//import flash.desktop.NativeApplication;
	//import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	//import flash.events.MouseEvent;
	//import flash.net.URLRequest;
	//import flash.system.fscommand;
	//import flash.utils.ByteArray;
	
	import useful.components.Button;
	import useful.embedmanager.EmbedManager;
	import useful.layers.BeginLayer;
	import useful.layers.Chapter1;
	
	public class Main1 extends Sprite
	{
		private var beginLayer:BeginLayer;
		private var chapter1:Chapter1;
			
		public function Main1()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addBeginLayer();
		}
		
		private function addBeginLayer():void
		{
			beginLayer = new BeginLayer();
			addChild(beginLayer);
			beginLayer.addEventListener(Event.REMOVED_FROM_STAGE, onBeginLayerRemoved);
		}
		
		private function onBeginLayerRemoved(event:Event):void
		{
			/*stage.nativeWindow.close();
			fscommand("quit");
			NativeApplication.nativeApplication.exit();
			var ar:ZhongKeBei_AR = new ZhongKeBei_AR();
			this.parent.addChild(ar);
			this.parent.removeChild(this);*/
			
			chapter1 = new Chapter1();
			addChild(chapter1);
		}
		
	//	private function onBeginButtonClicked(event:MouseEvent):void
		//{
		//	removeBeginLayer();
		//}
		
		private function removeBeginLayer():void
		{
			removeChild(beginLayer);
		}
	}
}