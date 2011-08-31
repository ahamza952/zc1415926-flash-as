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
	import com.transmote.flar.utils.geom.AlternativaGeomUtils;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import useful.Parsers.EmbedXmlParser;
	import useful.embedmanager.EmbedManager;
	import useful.layers.lyrics.HaiWangXingMp3Lyric;
	
	public class Chapter1_HaiWangXing extends Sprite
	{
		//private static const CUBE_SIZE:Number = 40;
		
		private var view:View;
		private var camera3D:FLARCamera_Alternativa3D;
		private var scene3D:Object3DContainer;
		
		private var bMirrorDisplay:Boolean;
		private var markersByPatternId:Vector.<Vector.<FLARMarker>>;	// FLARMarkers, arranged by patternId
		private var activePatternIds:Vector.<int>;						// list of patternIds of active markers
		private var containersByMarker:Dictionary;						// Cube containers, hashed by corresponding FLARMarker
		
		public var haiWangXing:Sphere;
		
		private var haiWangXingMp3Lyric:HaiWangXingMp3Lyric;
		
		public function Chapter1_HaiWangXing(flarManager:FLARManager, viewportSize:Rectangle)
		{
			this.bMirrorDisplay = flarManager.mirrorDisplay;
			
			this.init();
			this.initEnvironment(flarManager, viewportSize);
			
			addEventListener(Event.ADDED_TO_STAGE, onThisAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onThisRemovedFromStage);
		}
		
		public function addMarker (marker:FLARMarker) :void {
			this.storeMarker(marker);
			
			var container:DistanceSortContainer = new DistanceSortContainer();
			
			haiWangXing = new Sphere(95, 40, 40, false, new TextureMaterial(new EmbedManager.HaiWangXingImage().bitmapData));
			haiWangXing.rotationX = 90 * Math.PI / 180;
			container.addChild(haiWangXing);
			
			try
			{
				getChildIndex(haiWangXingMp3Lyric);
			}
			catch(error:ArgumentError)
			{//!!!!!!!!!!!!!!!!!
				haiWangXingMp3Lyric = new HaiWangXingMp3Lyric();
				addChild(haiWangXingMp3Lyric);
			}
			
			this.scene3D.addChild(container);
			
			// associate container with corresponding marker
			this.containersByMarker[marker] = container;
		}
		
		private function onThisAddedToStage(e:Event):void
		{
			
			try
			{
				getChildIndex(haiWangXingMp3Lyric);
			}
			catch(error:ArgumentError)
			{
				if(activePatternIds.length !=0)
					addChild(haiWangXingMp3Lyric);
			}
			
		}
		
		public function activeThis(activeMarker:FLARMarker):void
		{
			if(activeMarker != null)
			{
				this.addMarker(activeMarker);
			}
		}
		
		private function onThisRemovedFromStage(e:Event):void
		{
			try
			{
				getChildIndex(haiWangXingMp3Lyric);
				//removeChild(earthMp3Lyric);
			}
			catch(error:ArgumentError)
			{
				
			}
			if(activePatternIds.length !=0/*markersByPatternId[0][0] != null*/)
			{
				this.removeMarker(markersByPatternId[0][0]);//目前只有一个图卡就是00
			}
		}

		
		public function removeMarker (marker:FLARMarker) :void {
			if (!this.disposeMarker(marker)) { return; }
			
			// find and remove corresponding container
			var container:Object3D = this.containersByMarker[marker];
			if (container) {
				this.scene3D.removeChild(container);
			}
			
			try
			{
				//earthMp3Lyric.player.stop();
				removeChildAt(getChildIndex(haiWangXingMp3Lyric));
				haiWangXingMp3Lyric = new HaiWangXingMp3Lyric();
			}
			catch(error:ArgumentError)
			{
				
			}
			
			delete this.containersByMarker[marker]
		}
		
		private function init () :void {
			// set up lists (Vectors) of FLARMarkers, arranged by patternId
			this.markersByPatternId = new Vector.<Vector.<FLARMarker>>();
			
			// keep track of active patternIds
			this.activePatternIds = new Vector.<int>();
			
			// prepare hashtable for associating Cube containers with FLARMarkers
			this.containersByMarker = new Dictionary(true);
		}
		
		private function initEnvironment (flarManager:FLARManager, viewportSize:Rectangle) :void {
			this.scene3D = new Object3DContainer;
			this.camera3D = new FLARCamera_Alternativa3D(flarManager, viewportSize);
			this.scene3D.addChild(this.camera3D);
			
			this.view = new View(viewportSize.width, viewportSize.height);
			this.camera3D.view = this.view;
			
			this.addChild(this.view);
			
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			
			haiWangXingMp3Lyric = new HaiWangXingMp3Lyric();
		}
		
		private function onEnterFrame (evt:Event) :void {
			
			/*if(this.earth != null)
			earth.rotationY -= 0.1;*/
			if(this.haiWangXing != null)
				haiWangXing.rotationY -= 0.1;
			
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