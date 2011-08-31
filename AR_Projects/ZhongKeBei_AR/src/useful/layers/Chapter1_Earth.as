package useful.layers
{
	import alternativa.engine3d.containers.DistanceSortContainer;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Sphere;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Alternativa3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.utils.geom.AlternativaGeomUtils;
	
	import examples.support.SimpleCubes_Alternativa3D;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import useful.Parsers.EmbedXmlParser;
	import useful.embedmanager.EmbedManager;
	import useful.layers.lyrics.EarthMp3Lyric;
	import useful.layers.lyrics.Lyrics;
	
	public class Chapter1_Earth extends SimpleCubes_Alternativa3D//Sprite
	{
	//	private static const CUBE_SIZE:Number = 40;
		
		private var view:View;
		private var camera3D:FLARCamera_Alternativa3D;
		private var scene3D:Object3DContainer;
		
		private var bMirrorDisplay:Boolean;
		private var markersByPatternId:Vector.<Vector.<FLARMarker>>;	// FLARMarkers, arranged by patternId
		private var activePatternIds:Vector.<int>;						// list of patternIds of active markers
		private var containersByMarker:Dictionary;						// Cube containers, hashed by corresponding FLARMarker

		//private var whichOrb:String;
		//private var orbsMaterials:Vector.<TextureMaterial>;
		public var earth:Sphere;
		//private var huoXing:Sphere;
		//private var earthLyric:Lyrics;
		//private var earthMp3:Sound;
		//private var player:SoundChannel;
		private var earthMp3Lyric:EarthMp3Lyric;
		
		public function Chapter1_Earth(flarManager:FLARManager, viewportSize:Rectangle)
		{
			
			super(flarManager, viewportSize);
			this.bMirrorDisplay = flarManager.mirrorDisplay;
			
			//loadOrbsMaterials();
			this.init();
			this.initEnvironment(flarManager, viewportSize);

			addEventListener(Event.ADDED_TO_STAGE, onThisAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onThisRemovedFromStage);
			//this.whichOrb = whichOrb;
		}
		
		
		
		
		override public function addMarker (marker:FLARMarker) :void {
			this.storeMarker(marker);
			
			// create a new Cube, and place it inside a container (DistanceSortContainer) for manipulation
			var container:DistanceSortContainer = new DistanceSortContainer();
			//var cube:Box = new Box(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
		//	cube.z = 0.5 * CUBE_SIZE;
			//cube.setMaterialToAllFaces(new FillMaterial(0xFF1919, 1, 1, 0x730000));
			//container.addChild(cube);
		//	var earthBitmap:Bitmap = new Bitmap(new EmbedManager.EarthImage().bitmapData);
			earth = new Sphere(70, 40, 40, false, new TextureMaterial(new EmbedManager.EarthImage().bitmapData));
			earth.rotationX = 90 * Math.PI / 180;
			container.addChild(earth);
			
			try
			{
				getChildIndex(earthMp3Lyric);
			}
			catch(error:ArgumentError)
			{
				earthMp3Lyric = new EarthMp3Lyric();
				addChild(earthMp3Lyric);
			}
			
			//earth.addEventListener(Event.ADDED_TO_STAGE, onEarthAddedToStage);
//			if(player.position == 0)
//			{
//				player = earthMp3.play();
//			}
//			if(earthLyric != null)
			//			{
				//earthLyric = null;
				//earthLyric = new Lyrics("EarthLyric.swf");
//				addChild(earthLyric);
//			}
				//trace("哈哈" + markersByPatternId[0][0]);
					//break;
			/*switch(whichOrb)
			{
				case "earth":
					
				case "huoXing":
					huoXing = new Sphere(100, 20, 20, false, orbsMaterials[4]);
					huoXing.rotationX = 90 * Math.PI / 180;
					container.addChild(huoXing);
					break;
			}*/
			
			this.scene3D.addChild(container);
			
			// associate container with corresponding marker
			this.containersByMarker[marker] = container;
		}
		
	/*	public function playMp3():void
		{
			//earthMp3.play(0, 0, new SoundTransform(1, 0));
			//player = earthMp3.play();
		}
		
		public function stopMp3():void
		{
			player.stop();
			//earthMp3.
			
		}*/
		private function onThisAddedToStage(e:Event):void
		{
			
			try
			{
				getChildIndex(earthMp3Lyric);
			}
			catch(error:ArgumentError)
			{
				//earthMp3Lyric = new EarthMp3Lyric();
			//	if(markersByPatternId.length != 0)
				if(activePatternIds.length !=0)
				addChild(earthMp3Lyric);
			}
//			if(player != null)
//			{
				//if(player.position == 0)
				//player = earthMp3.play();
//			}
			//if(earthLyric != null)
			//{
//				try
//				{
///					this.getChildIndex(earthLyric);
//				}
//				catch(error:ArgumentError)
//				{
					//earthLyric = null;
					//earthLyric = new Lyrics("EarthLyric.swf");
//					addChild(earthLyric);
//				}
				/*if(this.getChildIndex(earthLyric) != null)
				{
					addChild(earthLyric);
				}*/
			//}
			
		}
		public function activeThis(activeMarker:FLARMarker):void
		{
			if(activeMarker != null)
			{
				//chapter1_earth.addMarker(this.activeMarker);
				//var flarMarkerEvent:FLARMarkerEvent = new FLARMarkerEvent("MARKER_ADDED", activeMarker);
				//this.onMarkerAdded(flarMarkerEvent);
				/*flarManager.*///dispatchEvent(flarMarkerEvent);
				this.addMarker(activeMarker);
			}
		}
		/*public function removeThis(activeMarker:FLARMarker):void
		{
			if(activeMarker != null)
			{
				//chapter1_earth.addMarker(this.activeMarker);
				//var flarMarkerEvent:FLARMarkerEvent = new FLARMarkerEvent("MARKER_ADDED", activeMarker);
				//this.onMarkerAdded(flarMarkerEvent);
				flarManager.//dispatchEvent(flarMarkerEvent);
				this.addMarker(activeMarker);
			}
		}*/
		
		private function onThisRemovedFromStage(e:Event):void
		{
			try
			{
				getChildIndex(earthMp3Lyric);
				//removeChild(earthMp3Lyric);
			}
			catch(error:ArgumentError)
			{
				
			}
//			if(player != null/* && player.position != 0*/)
				//if(player.position !=0)
				//{
//					player.stop();
				//}
			//if(earthLyric != null)
			//{
//			try
//			{
//				removeChildAt(getChildIndex(earthLyric));
				//this.getChildIndex(earthLyric);
				//removeChild(earthLyric);
				//earthLyric = null;
				
//			}
//			catch(error:ArgumentError)
//			{
				//addChild(earthLyric);
//			}
				//removeChild(earthLyric);
				//earthLyric = null;
				//earthLyric = new Lyrics("EarthLyric.swf");
			//}	
		//	markersByPatternId.
			if(activePatternIds.length !=0/*markersByPatternId[0][0] != null*/)
			{//目前只有一个图卡就是00
				this.removeMarker(markersByPatternId[0][0]);
			}
			/*if(this.activeMarker != null)
			{
				//chapter1_earth.addMarker(this.activeMarker);
				var flarMarkerEvent:FLARMarkerEvent = new FLARMarkerEvent("MARKER_REMOVED", this.activeMarker);
				//this.onMarkerUpdated(flarMarkerEvent);
				flarManager.dispatchEvent(flarMarkerEvent);
			}*/
		}
		/*private function onEarthAddedToStage(e:Event):void
		{
			earthMp3.play(0, 0, new SoundTransform(1, 0));
		}*/
		
		override public function removeMarker (marker:FLARMarker) :void {
			if (!this.disposeMarker(marker)) { return; }
			
			// find and remove corresponding container
			var container:Object3D = this.containersByMarker[marker];
			if (container) {
				this.scene3D.removeChild(container);
			}
			
			try
			{
				//earthMp3Lyric.player.stop();
				removeChildAt(getChildIndex(earthMp3Lyric));
				earthMp3Lyric = new EarthMp3Lyric();
			}
			catch(error:ArgumentError)
			{
				
			}
			
//			try
//			{
//				removeChildAt(getChildIndex(earthLyric));
				//this.getChildIndex(earthLyric);
				//removeChild(earthLyric);
				//earthLyric = null;
				
//			}
//			catch(error:ArgumentError)
//			{
				//addChild(earthLyric);
//			}
			/*if(earthLyric != null)
			{
				removeChild(earthLyric);
				//earthLyric = null;
			}*/
				//stopMp3();
//			player.stop();
			//player.stop();
			//removeChild(earthLyric);
			
			delete this.containersByMarker[marker]
		}

		
		private function init () :void {
			// set up lists (Vectors) of FLARMarkers, arranged by patternId
			this.markersByPatternId = new Vector.<Vector.<FLARMarker>>();
			
			// keep track of active patternIds
			this.activePatternIds = new Vector.<int>();
			
			// prepare hashtable for associating Cube containers with FLARMarkers
			this.containersByMarker = new Dictionary(true);
			
			/*earthLyric = new Lyrics("EarthLyric.swf");
			earthLyric.x = 160;
			earthLyric.y = 430;
			addChild(earthLyric);
			
			earthMp3 = new Sound(new URLRequest("/useful/layers/lyrics/earth.mp3"));
			player = new SoundChannel();*/
			
			earthMp3Lyric = new EarthMp3Lyric();
			
			//addEventListener(Event.ADDED_TO_STAGE, onThisAdded);
			//addEventListener(Event.REMOVED_FROM_STAGE, onThisRemoved);

		}
		
		private function initEnvironment (flarManager:FLARManager, viewportSize:Rectangle) :void {
			this.scene3D = new Object3DContainer;
			this.camera3D = new FLARCamera_Alternativa3D(flarManager, viewportSize);
			this.scene3D.addChild(this.camera3D);
			
			this.view = new View(viewportSize.width, viewportSize.height);
			this.camera3D.view = this.view;
			
			this.addChild(this.view);
			
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		private function onEnterFrame (evt:Event) :void {
			
			if(this.earth != null)
				earth.rotationY -= 0.1;
		/*	if(this.huoXing != null)
				huoXing.rotationY -= 0.1;*/
			
			this.updateCubes();
			this.camera3D.render();
		}
		
		private function updateCubes () :void {
			// update all Cube containers according to the transformation matrix in their associated FLARMarkers
			var i:int = this.activePatternIds.length;
			var markerList:Vector.<FLARMarker>;
			var marker:FLARMarker;
			var container:Object3D;
			var j:int;
			while (i--) {
				markerList = this.markersByPatternId[this.activePatternIds[i]];
				j = markerList.length;
				while (j--) {
					marker = markerList[j];
					container = this.containersByMarker[marker];
					container.matrix = AlternativaGeomUtils.convertMatrixToAlternativaMatrix(marker.transformMatrix, this.bMirrorDisplay);
				}
			}
		}
		
		private function storeMarker (marker:FLARMarker) :void {
			// store newly-detected marker.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// check for existing list of markers of this patternId...
				markerList = this.markersByPatternId[marker.patternId];
			} else {
				this.markersByPatternId.length = marker.patternId + 1;
			}
			if (!markerList) {
				// if no existing list, make one and store it...
				markerList = new Vector.<FLARMarker>();
				this.markersByPatternId[marker.patternId] = markerList;
				this.activePatternIds.push(marker.patternId);
			}
			// ...add the new marker to the list.
			markerList.push(marker);
		}
		
		private function disposeMarker (marker:FLARMarker) :Boolean {
			// find and remove marker.
			// returns false if marker's patternId is not currently active.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// get list of markers of this patternId
				markerList = this.markersByPatternId[marker.patternId];
			}
			if (!markerList) {
				// patternId is not currently active; something is wrong, so exit.
				return false;
			}
			
			var markerIndex:uint = markerList.indexOf(marker);
			if (markerIndex != -1) {
				markerList.splice(markerIndex, 1);
				if (markerList.length == 0) {
					this.markersByPatternId[marker.patternId] = null;
					var patternIdIndex:int = this.activePatternIds.indexOf(marker.patternId);
					if (patternIdIndex != -1) {
						this.activePatternIds.splice(patternIdIndex, 1);
					}
				}
			}
			
			return true;
		}
	}
}