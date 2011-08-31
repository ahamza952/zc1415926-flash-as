package useful.layers
{
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Alternativa3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.flar.utils.geom.AlternativaGeomUtils;
	import com.transmote.utils.time.FramerateDisplay;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import useful.CustomEvent.OrbsEvent;
	import useful.components.Button;
	import useful.layers.Chapter1_scene3D;
	import useful.layers.WuLengZhu.WuLengZhu;
	
	public class Chapter1 extends Sprite
	{
		private var flarManager:FLARManager;
		private var activeMarker:FLARMarker;
		
		private var rootContainer:Object3DContainer;
		private var scene:BSPContainer;
		private var camera:FLARCamera_Alternativa3D;
	//	private var box:Box;
		
		private var chapter1_scene3D:Chapter1_scene3D;
		private var topOrbs:TopOrbs; 
		
		private var chapter1_sun:Chapter1_Sun;
		private var chapter1_shuiXing:Chapter1_ShuiXing;
		private var chapter1_jinXing:Chapter1_JinXing;
		private var chapter1_earth:Chapter1_Earth;
		private var chapter1_huoXing:Chapter1_huoXing;
		private var chapter1_muXing:Chapter1_MuXing;
		private var chapter1_tuXing:Chapter1_TuXing;
		private var chapter1_tianWangXing:Chapter1_TianWangXing;
		private var chapter1_haiWangXing:Chapter1_HaiWangXing;
		
		private var goToQuestions:Button;
		private var goHome:Button;
		
		public function Chapter1()
		{	
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			flarManager = new FLARManager("flarConfig.xml", new FLARToolkitManager(), this.stage);
			
			addChild(Sprite(this.flarManager.flarSource));
			flarManager.flarCameraSource.useDefaultCamera = true;
			
			this.flarManager.addEventListener(ErrorEvent.ERROR, onFlarManagerError);
			
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			
			var framerateDisplay:FramerateDisplay = new FramerateDisplay();
			framerateDisplay.x = 100;
			framerateDisplay.y = 100;
			framerateDisplay.visible = false;
			addChild(framerateDisplay);
			
			this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);
	
			topOrbs = new TopOrbs();	
			stage.addChild(topOrbs);
			topOrbs.addEventListener(OrbsEvent.ORB_CLICK, onTopOrbsClicked);
			
			goToQuestions = new Button("GoToExercise.swf");
			goToQuestions.x = 300;
			goToQuestions.y = 430;
			goToQuestions.addEventListener(MouseEvent.CLICK, onGoToQuestionsClicked);
			stage.addChild(goToQuestions);
			
		/*	goHome = new Button("Home.swf");
			goHome.x = 20;
			goHome.y = 430;
			goHome.addEventListener(MouseEvent.CLICK, onGoHomeClicked);
			stage.addChild(goHome);
*/
			
		}
		
		private function onGoHomeClicked(e:MouseEvent):void
		{
			/*var beginLayer:BeginLayer = new BeginLayer();
			this.parent.addChild(beginLayer);
			
			this.parent.removeChild(this);*/
			
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			removeChild(Sprite(this.flarManager.flarSource));
		//	this.flarManager.flarSource = null;
				
			topOrbs.removeEventListener(OrbsEvent.ORB_CLICK, onTopOrbsClicked);
			stage.removeChild(topOrbs);
			topOrbs = null;
			
			removeChild(camera.view);
			
			rootContainer.removeChild(camera);
			rootContainer.removeChild(scene);		
			
			flarManager = null;
			activeMarker = null;
			rootContainer = null;
			scene = null;
			camera = null;
			
			
			//removeChildAt(2);
			
			chapter1_sun = null;
			chapter1_shuiXing = null;
			chapter1_jinXing = null;
			chapter1_earth = null;
			chapter1_huoXing = null;
			chapter1_muXing = null;
			chapter1_tuXing = null;
			chapter1_tianWangXing = null;
			chapter1_haiWangXing = null;
			
			goToQuestions.removeEventListener(MouseEvent.CLICK, onGoToQuestionsClicked);
			stage.removeChild(goToQuestions);
			goToQuestions = null;
			
			/*goHome.removeEventListener(MouseEvent.CLICK, onGoHomeClicked);
			stage.removeChild(goHome);
			goHome = null;*/
			/*chapter1_sun;
			chapter1_shuiXing;
			chapter1_jinXing;
			chapter1_earth;
			chapter1_huoXing;
			chapter1_muXing;
			chapter1_tuXing;
			chapter1_tianWangXing;
			chapter1_haiWangXing;*/
			//try
			//{
			//	this.parent.getChildIndex(this);
			//	this.parent.removeChild(this);
			//}
			//catch(error:ArgumentError)
			//{
				
			//}
				//this = null;
		}
		
		private function onGoToQuestionsClicked(e:MouseEvent):void
		{
			//this.parent.addChild(new WuLengZhu());
			var wuLengZhu:WuLengZhu = new WuLengZhu();
			this.parent.addChild(wuLengZhu);
			var exerciseLayer:ExerciseLayer = new ExerciseLayer();
			this.parent.addChild(exerciseLayer);

			this.parent.removeChild(this);
			
		}
		private function onFlarManagerError (evt:ErrorEvent) :void 
		{
			this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			trace(evt.text);
			// NOTE: developers can include better feedback to the end user here if desired.
		}
		
		private function onFlarManagerInited (evt:Event) :void 
		{
			this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			chapter1_scene3D = new Chapter1_scene3D(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			addChildAt(chapter1_scene3D, 2);
			
			chapter1_sun = new Chapter1_Sun(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_shuiXing = new Chapter1_ShuiXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_jinXing = new Chapter1_JinXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_earth = new Chapter1_Earth(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_huoXing = new Chapter1_huoXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_muXing = new Chapter1_MuXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_tuXing = new Chapter1_TuXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_tianWangXing = new Chapter1_TianWangXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));
			chapter1_haiWangXing = new Chapter1_HaiWangXing(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.height));


			// turn off interactivity in simpleCubes
			//chapter1_scene3D.mouseChildren = false;
			
						
			// turn off interactivity in simpleCubes
			//this.chapter1_scene3D.mouseChildren = false;
			
			rootContainer = new Object3DContainer();
			scene = new BSPContainer();
			camera = new FLARCamera_Alternativa3D(flarManager, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			camera.view.hideLogo();
			addChild(camera.view);
			
			rootContainer.addChild(camera);
			

			rootContainer.addChild(scene);
			
			scene.visible = false;			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onTopOrbsClicked(e:OrbsEvent):void
		{
			//trace("e.target:" + e.target);
			//trace("e.currentTarget:" + e.currentTarget);
			trace("e.orbname:" + e.orbname);
			switch(e.orbname)
			{
				case "sun":
					removeChildAt(2);
					addChildAt(chapter1_sun, 2);
					chapter1_sun.activeThis(this.activeMarker);
					break;
				case "shuiXing":
					removeChildAt(2);
					addChildAt(chapter1_shuiXing, 2);
					chapter1_shuiXing.activeThis(this.activeMarker);
					break;
				case "jinXing":
					removeChildAt(2);
					addChildAt(chapter1_jinXing, 2);
					chapter1_jinXing.activeThis(this.activeMarker);
					break;
				case "earth":
					//trace("chapter1_scene3D index:"+this.getChildIndex(chapter1_scene3D));

					removeChildAt(2);
					addChildAt(chapter1_earth, 2);
					chapter1_earth.activeThis(this.activeMarker);
					//trace("chapter1_earth index:"+this.getChildIndex(chapter1_earth));

					break;
				case "huoXing":
					/*if(this.activeMarker != null)
					{
						//chapter1_earth.addMarker(this.activeMarker);
												//this.onMarkerUpdated(flarMarkerEvent);
						flarManager.dispatchEvent(flarMarkerEvent);
					}*/
					//var flarMarkerEvent:FLARMarkerEvent = new FLARMarkerEvent("MARKER_REMOVED", this.activeMarker);
					//getChildAt(2).dispatchEvent(flarMarkerEvent);
					
					//SimpleCubes_Alternativa3D(getChildAt(2)).removeMarker(this.activeMarker);//.addMarker(this.activeMarker);
					removeChildAt(2);
					addChildAt(chapter1_huoXing, 2);
					chapter1_huoXing.activeThis(this.activeMarker);
				//	if(this.activeMarker != null)
				//	{
						//chapter1_earth.addMarker(this.activeMarker);
				//		var flarMarkerEvent:FLARMarkerEvent = new FLARMarkerEvent("MARKER_ADDED", this.activeMarker);
						//this.onMarkerAdded(flarMarkerEvent);
				//		flarManager.dispatchEvent(flarMarkerEvent);
				//	}
					break;
				case "muXing":
					removeChildAt(2);
					addChildAt(chapter1_muXing, 2);
					chapter1_muXing.activeThis(this.activeMarker);
					break;
				case "tuXing":
					removeChildAt(2);
					addChildAt(chapter1_tuXing, 2);
					chapter1_tuXing.activeThis(this.activeMarker);
					break;
				case "tianWangXing":
					removeChildAt(2);
					addChildAt(chapter1_tianWangXing, 2);
					chapter1_tianWangXing.activeThis(this.activeMarker);
					break;
				case "haiWangXing":
					removeChildAt(2);
					addChildAt(chapter1_haiWangXing, 2);
					chapter1_haiWangXing.activeThis(this.activeMarker);
					break;
			}
		}
		//private function init3D():
		
		private function onMarkerAdded (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] added");
			this.scene.visible = true;
			this.activeMarker = evt.marker;
			
			if(this.getChildAt(2).hasOwnProperty("spaceBackground"))
				chapter1_scene3D.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("sun"))
				chapter1_sun.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("shuiXing"))
				chapter1_shuiXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("jinXing"))
				chapter1_jinXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("earth")/*chapter1_earth != null*/)
			{
				chapter1_earth.addMarker(evt.marker);
				//chapter1_earth.playMp3();
			}
			if(this.getChildAt(2).hasOwnProperty("huoXing"))
				chapter1_huoXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("muXing"))
				chapter1_muXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("tuXing"))
				chapter1_tuXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("tianWangXing"))
				chapter1_tianWangXing.addMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("haiWangXing"))
				chapter1_haiWangXing.addMarker(evt.marker);
			
		}
		
		private function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] updated");
			this.scene.visible = true;
			this.activeMarker = evt.marker;
			//if(chapter1_scene3D.topOrbs != null)
			//chapter1_scene3D.topOrbs.visible = true;
		}
		
		private function onMarkerRemoved(evt:FLARMarkerEvent):void
		{
			//trace("["+evt.marker.patternId+"] removed");
			
			scene.visible = false;
			activeMarker = null;
			
			//chapter1_scene3D.removeMarker(evt.marker);
			//if(chapter1_scene3D.topOrbs != null)
			//chapter1_scene3D.topOrbs.visible = false;
			/*if(chapter1_scene3D != null)
				chapter1_scene3D.removeMarker(evt.marker);
			
			if(chapter1_sun != null)
				chapter1_sun.removeMarker(evt.marker);
			
			if(chapter1_shuiXing != null)
				chapter1_shuiXing.removeMarker(evt.marker);
			
			if(chapter1_jinXing != null)
				chapter1_jinXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("earth"))
			{
				chapter1_earth.removeMarker(evt.marker);
				//chapter1_earth.stopMp3();
			}
			if(chapter1_huoXing != null)
				chapter1_huoXing.removeMarker(evt.marker);
			
			if(chapter1_muXing != null)
				chapter1_muXing.removeMarker(evt.marker);
			
			if(chapter1_tuXing != null)
				chapter1_tuXing.removeMarker(evt.marker);
			
			if(chapter1_tianWangXing != null)
				chapter1_tianWangXing.removeMarker(evt.marker);
			
			if(chapter1_haiWangXing != null)
				chapter1_haiWangXing.removeMarker(evt.marker);*/
			if(this.getChildAt(2).hasOwnProperty("spaceBackground"))
				chapter1_scene3D.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("sun"))
				chapter1_sun.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("shuiXing"))
				chapter1_shuiXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("jinXing"))
				chapter1_jinXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("earth")/*chapter1_earth != null*/)
			{
				chapter1_earth.removeMarker(evt.marker);
				//chapter1_earth.playMp3();
			}
			if(this.getChildAt(2).hasOwnProperty("huoXing"))
				chapter1_huoXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("muXing"))
				chapter1_muXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("tuXing"))
				chapter1_tuXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("tianWangXing"))
				chapter1_tianWangXing.removeMarker(evt.marker);
			
			if(this.getChildAt(2).hasOwnProperty("haiWangXing"))
				chapter1_haiWangXing.removeMarker(evt.marker);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(activeMarker)
			{
				scene.matrix = AlternativaGeomUtils.convertMatrixToAlternativaMatrix(activeMarker.transformMatrix);
			}
			
			camera.render();
		}
		

	}
}