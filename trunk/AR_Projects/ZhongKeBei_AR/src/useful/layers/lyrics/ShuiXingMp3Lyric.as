package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class ShuiXingMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/shuiXing.mp3")]
		static public const ShuiXingMp3:Class;
		static public const ShuiXingMp3Fx:SoundAsset = new ShuiXingMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function ShuiXingMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = ShuiXingMp3Fx.play();
			lyrics = new Lyrics("ShuiXingLyric.swf");
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