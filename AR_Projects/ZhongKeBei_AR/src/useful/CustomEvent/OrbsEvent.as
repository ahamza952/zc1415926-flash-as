package useful.CustomEvent
{
	import flash.events.Event;
	
	public class OrbsEvent extends Event
	{
		public static const ORB_CLICK:String = "OrbClick";
		private var _orbname:String;
		/*public static const SUN_CLICK:String = "SunClick";
		public static const SHUIXING_CLICK:String = "SuiXingClick";
		public static const JINXING_CLICK:String = "JinXingClick";
		public static const EARTH_CLICK:String = "EarthClick";
		public static const HUOXING_CLICK:String = "HuoXingClick";
		public static const MUXING_CLICK:String = "MuXingClick";
		public static const TUXING_CLICK:String = "TuXingClick";
		public static const TIANWANGXING_CLICK:String = "TianWangXingClick";
		public static const HAIWANGXING_CLICK:String = "HaiWangXingClick";*/
		
		public function OrbsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get orbname():String
		{
			return _orbname;
		}

		public function set orbname(value:String):void
		{
			_orbname = value;
		}

	}
}