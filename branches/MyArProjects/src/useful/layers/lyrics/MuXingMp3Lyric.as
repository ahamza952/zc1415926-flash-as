package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class MuXingMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/muXing.mp3")]
		static public const MuXingMp3:Class;
		static public const MuXingMp3Fx:SoundAsset = new MuXingMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function MuXingMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = MuXingMp3Fx.play();
			lyrics = new Lyrics("MuXingLyric.swf");
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