package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;

	public class HuoXingMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/huoXing.mp3")]
		static public const HuoXingMp3:Class;
		static public const HuoXingMp3Fx:SoundAsset = new HuoXingMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function HuoXingMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = HuoXingMp3Fx.play();
			lyrics = new Lyrics("HuoXingLyric.swf");
			lyrics.x = 160;
			lyrics.y = 430;
			addChild(lyrics);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
						
			player.stop();
			removeChild(lyrics);
			player = null;
			lyrics = null;
		}
	}
}