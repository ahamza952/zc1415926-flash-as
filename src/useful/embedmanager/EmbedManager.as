package useful.embedmanager
{
	public class EmbedManager
	{
		[Embed(source="/assets/orbs/images.xml", mimeType="application/octet-stream")] 
		static public const OrbsMaterialXml:Class;
		
		[Embed(source="/assets/background1.jpg")] 
		static public const BeginLayerBackground:Class;
		
		[Embed(source="assets/orbs/sun.jpg")]
		static public const SunImage:Class;
		
		[Embed(source="assets/orbs/shuixing.jpg")]
		static public const ShuiXingImage:Class;
		
		[Embed(source="assets/orbs/jinxing.jpg")]
		static public const JinXingImage:Class;
		
		[Embed(source="assets/orbs/earth.jpg")]
		static public const EarthImage:Class;
		
		[Embed(source="assets/orbs/huoxing.jpg")]
		static public const HuoXingImage:Class;
		
		[Embed(source="assets/orbs/muxing.jpg")]
		static public const MuXingImage:Class;
		
		[Embed(source="assets/orbs/tuxing.jpg")]
		static public const TuXingImage:Class;
		
		[Embed(source="assets/orbs/tianwangxing.jpg")]
		static public const TianWangXingImage:Class;
		
		[Embed(source="assets/orbs/haiwangxing.jpg")]
		static public const HaiWangXingImage:Class;
		

		public function EmbedManager()
		{
		}
	}
}