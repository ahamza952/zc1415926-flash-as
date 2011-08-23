package
{
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.core.MipMapping;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Alternativa3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.flar.utils.geom.AlternativaGeomUtils;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.libspark.flartoolkit.support.alternativa3d.FLARCamera3D;
	
	public class ZhongKeBei_AR extends Sprite
	{
		
		[Embed(source="assets/earthMap.jpg")] static private const EarthMap:Class;
		[Embed(source="assets/moonMap.jpg")] static private const MoonMap:Class;
		[Embed(source="assets/sunMap.jpg")] static private const SunMap:Class;

		
		private var flarManager:FLARManager;
		private var activeMarker:FLARMarker;
		
		private var rootContainer:Object3DContainer;
		private var scene:BSPContainer;
		private var camera:FLARCamera_Alternativa3D;
		
		private var box:Box
		
		private var sunLight:OmniLight;
		
		private var earth:GeoSphere;
		private var moon:GeoSphere;
		private var sun:GeoSphere;
		
		private var earthAngle:Number = 0;
		private var earthToSunLength:int = 200;
		private var earthContainer:Object3DContainer;
		
		private var moonAngle:Number = 0;
		private var moonToEarthLength:int = 90
		
		private var cameraLookX:Number = 0;
		private var cameraLookY:Number = 0;
		private var cameraLookZ:Number = 0;
		
		public function ZhongKeBei_AR()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.flarManager = new FLARManager("flarConfig.xml", new FLARToolkitManager(), this.stage);
			this.addChild(Sprite(this.flarManager.flarSource));
			
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);

		}
		
		private function onMarkerAdded (evt:FLARMarkerEvent) :void {
			trace("["+evt.marker.patternId+"] added");
			this.scene.visible = true;
			this.activeMarker = evt.marker;
		}
		
		private function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			trace("["+evt.marker.patternId+"] updated");
			this.scene.visible = true;
			this.activeMarker = evt.marker;
		}
		
		private function onMarkerRemoved(evt:FLARMarkerEvent):void
		{
			trace("["+evt.marker.patternId+"] removed");
			
			scene.visible = false;
			activeMarker = null;
		}
		
		protected function onFlarManagerInited(event:Event):void
		{
			this.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			rootContainer = new Object3DContainer();
			scene = new BSPContainer();
			camera = new FLARCamera_Alternativa3D(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			addChild(camera.view);
			//addChild(camera.diagram);
			
			//camera.rotationX = -120*Math.PI/180;//
			//camera.y = -800;//
			//camera.z = 400;//
			
			rootContainer.addChild(camera);
			rootContainer.addChild(scene);
			
			init3D();
		}
		
		private function init3D():void
		{
			box = new Box(50, 50, 50);
			box.z += 25;
			box.setMaterialToAllFaces(new FillMaterial(0xFF7700, 1, 1));
			scene.addChild(box);
			
			initObjects();
			
			scene.visible = false;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initObjects():void
		{
			var ambientLight:AmbientLight = new AmbientLight(0x181824);
			scene.addChild(ambientLight);
			
			sunLight = new OmniLight(0xFFFFFF, 800, 1000);
			//sunLight.x += 200;
			scene.addChild(sunLight);
			
			earth = new GeoSphere(25, 4);
			earth.setMaterialToAllFaces(new VertexLightMaterial(new EarthMap().bitmapData, true, true, MipMapping.PER_PIXEL));
			earth.x += earthToSunLength;
			earth.calculateVerticesNormals(true, 0.01);
			scene.addChild(earth);
			
			earthContainer = new Object3DContainer();
			earthContainer.x = earth.x;
			scene.addChild(earthContainer);
			
			moon = new GeoSphere(12, 3);
			moon.setMaterialToAllFaces(new VertexLightMaterial(new MoonMap().bitmapData, true, true, MipMapping.PER_PIXEL));
			moon.x += moonToEarthLength;
			moon.calculateVerticesNormals(true, 0.01)
			earthContainer.addChild(moon);
			
			sun = new GeoSphere(25, 4);
			sun.setMaterialToAllFaces(new TextureMaterial(new SunMap().bitmapData, true, true, MipMapping.PER_PIXEL));
			sun.calculateVerticesNormals(true, 0.01)
			scene.addChild(sun);
		}
		
		private function earthUpdate():void
		{
			earth.x = earthToSunLength * Math.cos(earthAngle);
			earth.y = earthToSunLength * Math.sin(earthAngle);
			earthAngle += 0.01;
			earth.rotationZ += 0.05;
			
			earthContainer.x = earth.x;
			earthContainer.y = earth.y;
			earthContainer.z = earth.z;
		}
		
		private function moonUpdate():void
		{
			moon.x = moonToEarthLength * Math.cos(moonAngle);
			moon.y = moonToEarthLength * Math.sin(moonAngle);
			moonAngle += 0.1;
			moon.rotationZ += 0.05;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(activeMarker)
			{
				scene.matrix = AlternativaGeomUtils.convertMatrixToAlternativaMatrix(activeMarker.transformMatrix);
			}
			
			earthUpdate();
			moonUpdate();
			
			camera.render();
		}
	}
}