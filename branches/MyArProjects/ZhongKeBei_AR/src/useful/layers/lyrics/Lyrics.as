package useful.layers.lyrics
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Lyrics extends Sprite
	{		
		public function Lyrics(whichLyric:String)
		{
			var lyricloader:Loader = new Loader();
			lyricloader.load(new URLRequest("/useful/layers/lyrics/" + whichLyric));
			
			addChild(lyricloader);
		}
	}
}