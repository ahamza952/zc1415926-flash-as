/**
 * 封闭了加载Button的代码，使从外部看，些类就是一个按钮
 * @zc1415926
 */
package useful.components
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Button extends Sprite
	{	
		public function Button(whichButton:String)
		{
			//stage.align = StageAlign.TOP_LEFT;
			
			var buttonLoader:Loader = new Loader();
			buttonLoader.load(new URLRequest("/useful/components/" + whichButton));
			
			addChild(buttonLoader);
		}
	}
}