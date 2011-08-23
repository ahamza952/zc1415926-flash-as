package useful.layers.lyrics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	public class JinXingMp3Lyric extends Sprite
	{
		[Embed(source="/useful/layers/lyrics/jinXing.mp3")]
		static public const JinXingMp3:Class;
		static public const JinXingMp3Fx:SoundAsset = new JinXingMp3() as SoundAsset;
		
		private var player:SoundChannel;
		private var lyrics:Lyrics;
		
		public function JinXingMp3Lyric()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			player = JinXingMp3Fx.play();
			lyrics = new Lyrics("JinXingLyric.swf");
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