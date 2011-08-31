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

		[Embed(source="assets/skyBox/space_env_back.jpg")]
		static public const SkyBoxBack:Class;
		
		[Embed(source="assets/skyBox/space_env_bottom.jpg")]
		static public const SkyBoxBottom:Class;
		
		[Embed(source="assets/skyBox/space_env_front.jpg")]
		static public const SkyBoxFront:Class;
		
		[Embed(source="assets/skyBox/space_env_left.jpg")]
		static public const SkyBoxLeft:Class;
		
		[Embed(source="assets/skyBox/space_env_right.jpg")]
		static public const SkyBoxRight:Class;
		
		[Embed(source="assets/skyBox/space_env_top.jpg")]
		static public const SkyBoxTop:Class;
		
		[Embed(source="assets/tuXingCircle/pasted__blinn10SG-pasted__pTorus2.6.png")]
		static public const TuXingCircleImage:Class;
		
		[Embed(source="/assets/introBackground.jpg")] 
		static public const IntroBackground:Class;
		
		public function EmbedManager()
		{
		}
	}
}