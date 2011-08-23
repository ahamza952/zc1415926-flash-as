package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class TuXingMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/tuXing.mp3")]
		static public const TuXingMp3:Class;
		static public const TuXingMp3Fx:SoundAsset = new TuXingMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function TuXingMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = TuXingMp3Fx.play();
			lyrics = new Lyrics("TuXingLyric.swf");
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