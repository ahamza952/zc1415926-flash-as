package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class SunMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/sun.mp3")]
		static public const SunMp3:Class;
		static public const SunMp3Fx:SoundAsset = new SunMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function SunMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = SunMp3Fx.play();
			lyrics = new Lyrics("SunLyric.swf");
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