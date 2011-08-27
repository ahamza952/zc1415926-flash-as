package {
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.utils.time.FramerateDisplay;
	
	import examples.support.SimpleCubes_Away3D;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
	 * standard FLARToolkit Away3D example, with our friends the Cubes.
	 * this version displays the cubes, and accepts marker input,
	 * in lovely widescreen format (16:9).
	 * the aspect ratio is set in flarConfig_wide.xml.
	 * 
	 * code is borrowed heavily from Saqoosha, Mikko Haapoja, and Squidder.
	 * http://saqoosha.net/en/flartoolkit/start-up-guide/
	 * http://www.mikkoh.com/blog/?p=182
	 * http://www.squidder.com/2009/03/06/flar-how-to-multiple-instances-of-multiple-markers/#more-285
	 * 
	 * the Away3D platform can be found here:
	 * http://away3d.com/
	 * please note, usage of the Away3D platform is subject to Away3D's licensing.
	 * 
	 * @author	Eric Socolofsky
	 * @url		http://transmote.com/flar
	 */
	public class Piano extends Sprite {
		private var flarManager:FLARManager;
		private var simpleCubes:SimpleCubes_Away3D;
		
		private var sound1:Sound = new Sound();
		private var soundUrl1:URLRequest = new URLRequest("../resources/musics/1.mp3");
		
		private var sound2:Sound = new Sound();
		private var soundUrl2:URLRequest = new URLRequest("../resources/musics/2.mp3");
		
		private var sound3:Sound = new Sound();
		private var soundUrl3:URLRequest = new URLRequest("../resources/musics/3.mp3");
		
		private var sound4:Sound = new Sound();
		private var soundUrl4:URLRequest = new URLRequest("../resources/musics/4.mp3");
		
		private var sound5:Sound = new Sound();
		private var soundUrl5:URLRequest = new URLRequest("../resources/musics/5.mp3");
		
		private var sound6:Sound = new Sound();
		private var soundUrl6:URLRequest = new URLRequest("../resources/musics/6.mp3");
		
		private var sound7:Sound = new Sound();
		private var soundUrl7:URLRequest = new URLRequest("../resources/musics/7.mp3");
		
		private var sound8:Sound = new Sound();
		private var soundUrl8:URLRequest = new URLRequest("../resources/musics/8.mp3");

		public function Piano () {
			
			sound1.load(soundUrl1);
			sound2.load(soundUrl2);
			sound3.load(soundUrl3);
			sound4.load(soundUrl4);
			sound5.load(soundUrl5);
			sound6.load(soundUrl6);
			sound7.load(soundUrl7);
			sound8.load(soundUrl8);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
		}
		
		private function soundLoad():void
		{
			sound1.load(soundUrl1);
			sound2.load(soundUrl2);
			sound3.load(soundUrl3);
			sound4.load(soundUrl4);
			sound5.load(soundUrl5);
			sound6.load(soundUrl6);
			sound7.load(soundUrl7);
			sound8.load(soundUrl8);
		}
		
		private function onAdded (evt:Event) :void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
			
			// pass the path to the FLARManager xml config file into the FLARManager constructor.
			// FLARManager creates and uses a FLARCameraSource by default.
			// the image from the first detected camera will be used for marker detection.
			// also pass an IFLARTrackerManager instance to communicate with a tracking library,
			// and a reference to the Stage (required by some trackers).
			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FLARToolkitManager(), this.stage);
			
			// to switch tracking engines, pass a different IFLARTrackerManager into FLARManager.
			// refer to this page for information on using different tracking engines:
			// http://words.transmote.com/wp/inside-flarmanager-tracking-engines/
			//			this.flarManager = new FLARManager("../resources/flar/flarConfig_wide.xml", new FlareManager(), this.stage);
			//			this.flarManager = new FLARManager("../resources/flar/flarConfig_wide.xml", new FlareNFTManager(), this.stage);
			
			// handle any errors generated during FLARManager initialization.
			this.flarManager.addEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			
			// add FLARManager.flarSource to the display list to display the video capture.
			this.addChild(Sprite(this.flarManager.flarSource));
			
			// begin listening for FLARMarkerEvents.
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			// framerate display helps to keep an eye on performance.
			var framerateDisplay:FramerateDisplay = new FramerateDisplay();
			this.addChild(framerateDisplay);
			
			this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);
		}
		
		private function onFlarManagerError (evt:ErrorEvent) :void {
			this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			trace(evt.text);
			// NOTE: developers can include better feedback to the end user here if desired.
		}
		
		private function onFlarManagerInited (evt:Event) :void {
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			// viewport width/height are hardcoded here, but could also be tied to stageWidth/Height if desired.
			this.simpleCubes = new SimpleCubes_Away3D(this.flarManager, new Rectangle(0, 0, 640, 480));
			
			this.addChild(this.simpleCubes);
			
			// turn off interactivity in simpleCubes
			this.simpleCubes.mouseChildren = false;
		}
		
		private function onMarkerAdded (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] added");
			this.simpleCubes.addMarker(evt.marker);
		}
		
		private function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] updated");
		}
		
		private function onMarkerRemoved (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] removed");
			this.simpleCubes.removeMarker(evt.marker);
			switch(evt.marker.patternId + 1)
			{//TODO:用load方法是不是可以减少播放声音的延迟？
				case 1:
					sound1.play();
					break;
				case 2:
					sound2.play();
					break;
				case 3:
					sound3.play();
					break;
				case 4:
					sound4.play();
					break;
				case 5:
					sound5.play();
					break;
				case 6:
					sound6.play();
					break;
				case 7:
					sound7.play();
					break;
				case 8:
					sound8.play();
					break;
				default:
					break;
			}
		}
		
		/*private function onMarkerRemoved (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] removed");
			this.simpleCubes.removeMarker(evt.marker);
			switch(evt.marker.patternId + 1)
			{//TODO:用load方法是不是可以减少播放声音的延迟？
				case 1:
					sound1.play();
					break;
				case 2:
					sound2.play();
					break;
				case 3:
					sound3.play();
					break;
				case 4:
					sound4.play();
					break;
				case 5:
					sound5.play();
					break;
				case 6:
					sound6.play();
					break;
				case 7:
					sound7.play();
					break;
				case 8:
					sound8.play();
					break;
				default:
					break;
			}
		}
*/	}
}