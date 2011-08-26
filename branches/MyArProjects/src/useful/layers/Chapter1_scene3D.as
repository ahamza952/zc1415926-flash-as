package useful.layers {
	import alternativa.engine3d.containers.DistanceSortContainer;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Sphere;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Alternativa3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.utils.geom.AlternativaGeomUtils;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import useful.CustomEvent.OrbsEvent;
	import useful.Parsers.EmbedXmlParser;
	import useful.components.Button;
	import useful.embedmanager.EmbedManager;
	
	public class Chapter1_scene3D extends Sprite {
		
		private var view:View;
		private var camera3D:FLARCamera_Alternativa3D;
		private var scene3D:Object3DContainer;
		
		private var bMirrorDisplay:Boolean;
		private var markersByPatternId:Vector.<Vector.<FLARMarker>>;	// FLARMarkers, arranged by patternId
		private var activePatternIds:Vector.<int>;						// list of patternIds of active markers
		private var containersByMarker:Dictionary;						// Cube containers, hashed by corresponding FLARMarker
		
	//	private var rightSingle:Button;
		
		private var orbsMaterials:Vector.<TextureMaterial>;
		private var orbsContainer:DistanceSortContainer;
		
		private var sprite3DContainers:Vector.<Object3DContainer>;
		
		private var sun:Sphere;
		
		private var shuiXing:Sphere;
		private var shuiXingToSunLength:Number = 0;
		private var shuiXingAngle:Number = Math.random() * Math.PI;;
		
		private var jinXing:Sphere;
		private var jinXingToSunLength:Number = 0;
		private var jinXingAngle:Number = Math.random() * Math.PI;;
		
		private var earth:Sphere;
		private var earthToSunLength:Number = 0;
		private var earthAngle:Number = Math.random() * Math.PI;;
		
		private var huoXing:Sphere;
		private var huoXingToSunLength:Number = 0;
		private var huoXingAngle:Number = Math.random() * Math.PI;;
		
		private var muXing:Sphere;
		private var muXingToSunLength:Number = 0;
		private var muXingAngle:Number = Math.random() * Math.PI;;
		
		private var tuXing:Sphere;
		private var tuXingToSunLength:Number = 0;
		private var tuXingAngle:Number = Math.random() * Math.PI;
		
		private var tianWuangXing:Sphere;
		private var tianWuangXingToSunLength:Number = 0;
		private var tianWuangXingAngle:Number = Math.random() + Math.PI;//使其出现在正对摄像机的PI~2PI的范围内
		
		private var haiWuangXing:Sphere;
		private var haiWuangXingToSunLength:Number = 0;
		private var haiWuangXingAngle:Number = Math.random() + Math.PI;//使其出现在正对摄像机的PI~2PI的范围内
		
		public var spaceBackground:SpaceBackground;
		
		private var cameraVector3D:Vector3D;
		private var targetVector3D:Vector3D;
		private var camera3DX:Number;
		private var camera3DY:Number;
		private var camera3DLookAtX:Number;
		private var camera3DLookAtY:Number;
		private var camera3DLookAtZ:Number;
		
		public function Chapter1_scene3D (flarManager:FLARManager, viewportSize:Rectangle) {
			this.bMirrorDisplay = flarManager.mirrorDisplay;
			
			loadOrbsMaterials();
			this.init();
			this.initEnvironment(flarManager, viewportSize);
		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		///	rightSingle = new Button("RightSingle.swf");
		//	rightSingle.x = 270;
		//	rightSingle.y = 430;
			
			//加到stage里，就在最上层了，呵呵
		//	stage.addChild(rightSingle);//只有在Event.ADDED_TO_STAGE和REMOVE_FROM_STAGE的handler里才能访问stage
			
		//	rightSingle.addEventListener(MouseEvent.CLICK, onRightSingleClicked);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		//private function onRightSingleClicked(event:MouseEvent):void
		//{
			//this.parent.removeChild(this);测试REMOVE_FROM_STAGE的handler中能不能访问stage结果是能！
			//cube.rotationX++;
		//}
		
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		//	rightSingle.removeEventListener(MouseEvent.CLICK, onRightSingleClicked);
		//	_topOrbs.removeEventListener(OrbsEvent.ORB_CLICK, onTopOrbsClicked);
		//	stage.removeChild(rightSingle);
			//stage.removeChild(_topOrbs);
			//_topOrbs = null;
			if(orbsContainer != null)
			{
				for(var i:int = 0; i < orbsContainer.numChildren; i++)
				{
					orbsContainer.removeChildAt(0);
				}
				
			}
			orbsContainer = null;
		/*	orbsContainer.removeChild(sun);
			orbsContainer.removeChild(shuiXing);
			orbsContainer.removeChild(jinXing);
			orbsContainer.removeChild(earth);
			orbsContainer.removeChild(huoXing);
			orbsContainer.removeChild(muXing);
			orbsContainer.removeChild(tuXing);
			orbsContainer.removeChild(tianWuangXing);
			orbsContainer.removeChild(haiWuangXing);*/
			//container.addChild(spaceBackground);
			
			//container.addChild(orbsContainer);
			spaceBackground = null;
			
		}
		
		private function loadOrbsMaterials():void
		{
			var orbsMaterialsXml:XML = EmbedXmlParser.parseEmbedXml(EmbedManager.OrbsMaterialXml);
			
			orbsMaterials = new Vector.<TextureMaterial>();
			var context:LoaderContext = new LoaderContext(true);
			
			for(var iOrbs:uint = 0; iOrbs < 9; iOrbs++)
			{
				var orbMaterial:TextureMaterial = new TextureMaterial();
				//orbMaterial.diffuseMapURL = orbsMaterialUrls[iOrbs];
				orbMaterial.diffuseMapURL = String(orbsMaterialsXml.pic[iOrbs].@url);
				//trace(orbsMaterialsXml.pic[iOrbs].@url);
				//trace("1234567890");
				//trace(orbMaterial.diffuseMapURL);
				orbsMaterials.push(orbMaterial);
			}
			
			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.load(orbsMaterials, context);
		}
		
		public function addMarker (marker:FLARMarker) :void {
			this.storeMarker(marker);
			
			// create a new Cube, and place it inside a container (DistanceSortContainer) for manipulation
			var container:DistanceSortContainer = new DistanceSortContainer();
			
			orbsContainer = new DistanceSortContainer();
			
			sprite3DContainers = new Vector.<Object3DContainer>();
			//orbsContainer.addChild(sprite3DContainer);
			
			//var cube:Box = new Box(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
			//cube.z = 0.5 * CUBE_SIZE;
			//cube.setMaterialToAllFaces(this.getMaterialByPatternId(marker.patternId));
			//container.addChild(cube);
			trace("getTimer():" + getTimer());
			sun = new Sphere(40, 10, 10);
			sun.setMaterialToAllFaces(orbsMaterials[0]);
			
			shuiXing = new Sphere(0.057 * 20 * 2.5, 10, 10);
			shuiXing.setMaterialToAllFaces(orbsMaterials[1]);
			shuiXing.x = sun.x + 50;
			shuiXingToSunLength = shuiXing.x;
			addTrack(shuiXingToSunLength, 40);
			
			jinXing = new Sphere(0.141 * 20 * 2.5, 10, 10);
			jinXing.setMaterialToAllFaces(orbsMaterials[2]);
			jinXing.x = shuiXing.x + 20;
			jinXingToSunLength = jinXing.x;
			addTrack(jinXingToSunLength, 50);
			
			earth = new Sphere(0.226 * 20 * 2.5, 10, 10);
			earth.setMaterialToAllFaces(orbsMaterials[3]);
			earth.x = jinXing.x + 30;
			earthToSunLength = earth.x;
			addTrack(earthToSunLength, 70);
			
			huoXing = new Sphere(0.125 * 20 * 2.5, 10, 10);
			huoXing.setMaterialToAllFaces(orbsMaterials[4]);
			huoXing.x = earth.x + 30;
			huoXingToSunLength = huoXing.x;
			addTrack(huoXingToSunLength, 70);
			
			muXing = new Sphere(1.606 * 20 * 0.8 , 10, 10);
			muXing.setMaterialToAllFaces(orbsMaterials[5]);
			muXing.x = huoXing.x + 40;
			muXingToSunLength = muXing.x;
			addTrack(muXingToSunLength, 100);
			
			tuXing = new Sphere(1.317 * 20 * 0.8 , 10, 10);
			tuXing.setMaterialToAllFaces(orbsMaterials[6]);
			tuXing.x = muXing.x + 50;
			tuXingToSunLength = tuXing.x;
			addTrack(tuXingToSunLength, 150);
			
			tianWuangXing = new Sphere(0.579 * 20, 10, 10);
			tianWuangXing.setMaterialToAllFaces(orbsMaterials[7]);
			tianWuangXing.x = tuXing.x + 40;
			tianWuangXingToSunLength = tianWuangXing.x;
			addTrack(tianWuangXingToSunLength,200);
			
			haiWuangXing = new Sphere(0.561 * 20, 10, 10);
			haiWuangXing.setMaterialToAllFaces(orbsMaterials[8]);
			haiWuangXing.x = tianWuangXing.x + 30;
			haiWuangXingToSunLength = haiWuangXing.x;
			addTrack(haiWuangXingToSunLength, 250);
			
			
			orbsContainer.addChild(sun);
			orbsContainer.addChild(shuiXing);
			orbsContainer.addChild(jinXing);
			orbsContainer.addChild(earth);
			orbsContainer.addChild(huoXing);
			orbsContainer.addChild(muXing);
			orbsContainer.addChild(tuXing);
			orbsContainer.addChild(tianWuangXing);
			orbsContainer.addChild(haiWuangXing);
			
			orbsContainer.z += 100;
			trace("getTimer():" + getTimer());
			
			
			spaceBackground = new SpaceBackground("/assets/spaceBackground/1.jpg");
			spaceBackground.rotationX -= 20 * Math.PI / 180;
			spaceBackground.y -= 80;
			
			container.addChild(spaceBackground);
			orbsContainer.rotationX = 45 * Math.PI / 180;
			container.addChild(orbsContainer);
			
			camera3DLookAtX = sun.x;
			camera3DLookAtY = sun.y;
			camera3DLookAtZ = sun.z;
			//camera3D.localToGlobal(new Vector3D(globalToLocal3D(
			cameraVector3D = new Vector3D(camera3D.x, camera3D.y, camera3D.z);
			trace("camera3D" + camera3D.x + camera3D.y + camera3D.z);
			trace(orbsContainer.globalToLocal(cameraVector3D));
			
			trace("sun" + sun.x + sun.y + sun.z);
			
			this.scene3D.addChild(container);
			
			//topOrbs.visible = true;
			
			// associate container with corresponding marker
			this.containersByMarker[marker] = container;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
		}
		
		private function addTrack(radius:Number, quantity:uint):void
		{
			var sprite3Dbase:Sprite3D = new Sprite3D(1, 1, new FillMaterial(0xCCCCCC));
			var r:uint = radius;
			var angle:Number = 0;
			
			for(var iCircle:uint = 0; iCircle < (quantity + 1); iCircle++)
			{
				var s:Sprite3D = sprite3Dbase.clone() as Sprite3D;
				s.x = r * Math.cos(angle);
				s.y = r * Math.sin(angle);
				orbsContainer.addChild(s);
				//sprite3Ds.push(s);
				angle = 2 * Math.PI * iCircle / quantity;
			}
		}
		
		public function removeMarker (marker:FLARMarker) :void {
			
			//topOrbs.visible = false;
			
			if (!this.disposeMarker(marker)) { return; }
			
			// find and remove corresponding container
			var container:Object3D = this.containersByMarker[marker];
			if (container) {
				this.scene3D.removeChild(container);
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
			camera3D.diagramAlign = StageAlign.BOTTOM_LEFT;
			addChild(camera3D.diagram);
			
			this.view = new View(viewportSize.width, viewportSize.height);
			this.camera3D.view = this.view;
			view.hideLogo();
			this.addChild(this.view);
			
		//	camera3DX = camera3D.x;
			//camera3DY = camera3D.y;
			
			//camera3D.l
			
			//this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		private function onEnterFrame (evt:Event) :void {
			
			//camera3D.x = camera3DX;
		//	camera3D.y = camera3DY;
		//	camera3D.lookAt(camera3DLookAtX, camera3DLookAtY, camera3DLookAtZ);
			
			this.shuiXing.x = this.shuiXingToSunLength * Math.cos(this.shuiXingAngle);
			this.shuiXing.y = this.shuiXingToSunLength * Math.sin(this.shuiXingAngle);
			this.shuiXing.rotationZ += 0.7 * 1 / 58.65;
			this.shuiXingAngle += 0.1 * 365.24 / 87.7 / 2;
			
			this.jinXing.x = this.jinXingToSunLength * Math.cos(this.jinXingAngle);
			this.jinXing.y = this.jinXingToSunLength * Math.sin(this.jinXingAngle);
			this.jinXing.rotationZ -= 0.7 * 1 / 58.65;
			this.jinXingAngle += 0.1 * 365.24 / 224.70;
			
			this.earth.x = this.earthToSunLength * Math.cos(this.earthAngle);
			this.earth.y = this.earthToSunLength * Math.sin(this.earthAngle);
			this.earth.rotationZ += 0.7;
			this.earthAngle += 0.1;
			
			this.huoXing.x = this.huoXingToSunLength * Math.cos(this.huoXingAngle);
			this.huoXing.y = this.huoXingToSunLength * Math.sin(this.huoXingAngle);
			this.huoXing.rotationZ += 0.7 * 1 / 1.03;
			this.huoXingAngle += 0.1 * 365.24 / 686.98;
			
			this.muXing.x = this.muXingToSunLength * Math.cos(this.muXingAngle);
			this.muXing.y = this.muXingToSunLength * Math.sin(this.muXingAngle);
			this.muXing.rotationZ += 0.7 * 1 / 0.41;
			this.muXingAngle += 0.1 * 365.24 / 4332.59 * 3;
			
			this.tuXing.x = this.tuXingToSunLength * Math.cos(this.tuXingAngle);
			this.tuXing.y = this.tuXingToSunLength * Math.sin(this.tuXingAngle);
			this.tuXing.rotationZ += 0.7 * 1 / 0.44;
			this.tuXingAngle += 0.1 * 365.24 / 10759.5 * 3;
			
			this.tianWuangXing.x = this.tianWuangXingToSunLength * Math.cos(this.tianWuangXingAngle);
			this.tianWuangXing.y = this.tianWuangXingToSunLength * Math.sin(this.tianWuangXingAngle);
			this.tianWuangXing.rotationZ += 0.7 * 1 / 0.67;
			this.tianWuangXingAngle += 0.1 * 365.24 / 30799.10 * 3;
			
			this.haiWuangXing.x = this.haiWuangXingToSunLength * Math.cos(this.haiWuangXingAngle);
			this.haiWuangXing.y = this.haiWuangXingToSunLength * Math.sin(this.haiWuangXingAngle);
			this.haiWuangXing.rotationZ += 0.7 * 1 / 0.65;
			this.haiWuangXingAngle += 0.1 * 365.24 / 60193.20 * 3;
			
			
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