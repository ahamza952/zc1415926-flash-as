package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class EarthMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/earth.mp3")]
		static public const EarthMp3:Class;
		static public const EarthMp3Fx:SoundAsset = new EarthMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function EarthMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			player = EarthMp3Fx.play();
			lyrics = new Lyrics("EarthLyric.swf");
			lyrics.x = 160;
			lyrics.y = 430;
			addChild(lyrics);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			player.stop();
			removeChild(lyrics);
			player = null;
			lyrics = null;
		}
	}
}