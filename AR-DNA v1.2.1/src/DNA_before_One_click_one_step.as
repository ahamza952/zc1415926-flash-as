package {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_PV3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.tracker.FLARToolkitManager;
	import com.transmote.flar.utils.geom.PVGeomUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	//import flash.text.CSMSettings;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.osmf.traits.SwitchableTrait;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]

	/**
	 * FLARManager_Tutorial3D demonstrates how to display a Collada-formatted model
	 * using FLARManager, FLARToolkit, and Papervision3D. 
	 * see the accompanying tutorial writeup here:
	 * http://words.transmote.com/wp/flarmanager/inside-flarmanager/loading-collada-models/
	 * 
	 * the collada model used for this example, scout.dae, was produced by Tom Tallian:
	 * http://tomtallian.com
	 * 
	 * @author	Eric Socolofsky
	 * @url		http://transmote.com/flar
	 */
	public class DNA extends Sprite {
		private var flarManager:FLARManager;
		
		private var scene3D:Scene3D;
		private var camera3D:Camera3D;
		private var viewport3D:Viewport3D;
		private var renderEngine:LazyRenderEngine;
		private var pointLight3D:PointLight3D;
		
		private var activeMarker:FLARMarker;
		private var modelContainer:DisplayObject3D;
		
		private var isPlaying:Boolean = false;
		
		private var model:DAE = new DAE(true, "model", true);
		private var model1:DAE = new DAE(true, "model", true);
		private var do3dBase:DisplayObject3D = new DisplayObject3D();
		//private var _dna:Max3DS;
		//private var _earth:DAE = new DAE(true, "model", true);
		private var _board:DAE = new DAE(true, "model", true);
		
		private var _dnax1:DAE = new DAE(true, "model", true);
		private var _dnax2:DAE = new DAE(true, "model", true);
		private var _dnax3:DAE = new DAE(true, "model", true);
		private var _dnax4:DAE = new DAE(true, "model", true);

		
		//private var dnaxBoard1Material:ColorMaterial = new ColorMaterial(0x00A2E8);
		//private var dnaxBoard2Material:ColorMaterial = new ColorMaterial(0x6FFF93);
		private var overBoardMaterial:ColorMaterial = new ColorMaterial(0xE60000);
		//private var _dnaxBoard1:Plane = new Plane(dnaxBoard1Material,50,75);
		//private var _dnaxBoard2:Plane = new Plane(dnaxBoard2Material,50,75);
		private var _dnaxBoard1:Plane = initT();
		private var _dnaxBoard2:Plane = initG();
		private var _dnaxBoard3:Plane = initC();
		private var _dnaxBoard4:Plane = initA();
		
		private var _overBoard:Plane = new Plane(overBoardMaterial,10,20);

		private var dnaContainer:DisplayObject3D = new DisplayObject3D();
		private var isDnaPlaying:Boolean = false;

		private var background:Sound = new Sound(new URLRequest("../resources/musics/OneDayInSpring.mp3"));
		private var backtrans:SoundTransform = new SoundTransform(0.1,0);
		
		private var board1sound:Sound = new Sound(new URLRequest("../resources/musics/board1.mp3"));
		private var board2sound:Sound = new Sound(new URLRequest("../resources/musics/board2.mp3"));
		private var Asound:Sound = new Sound(new URLRequest("../resources/musics/A.mp3"));
		private var Tsound:Sound = new Sound(new URLRequest("../resources/musics/T.mp3"));
		private var Csound:Sound = new Sound(new URLRequest("../resources/musics/C.mp3"));
		private var Gsound:Sound = new Sound(new URLRequest("../resources/musics/G.mp3"));
		

		
		public function DNA () {
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
		}
		
		private function onAdded (evt:Event) :void {
			background.play(0,0,backtrans);
			
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
			//			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FlareManager(), this.stage);
			//			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FlareNFTManager(), this.stage);
			
			// add FLARManager.flarSource to the display list to display the video capture.
			this.addChild(Sprite(this.flarManager.flarSource));
			
			// begin listening for FLARMarkerEvents.
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			this.flarManager.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			// wait for FLARManager to initialize before setting up Papervision3D environment.
			this.flarManager.addEventListener(Event.INIT, this.onFlarManagerInited);
		}
		
		private function onFlarManagerInited (evt:Event) :void {
			this.flarManager.removeEventListener(Event.INIT, this.onFlarManagerInited);
			
			this.scene3D = new Scene3D();
			this.viewport3D = new Viewport3D(this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(this.viewport3D);
			
			this.camera3D = new FLARCamera_PV3D(this.flarManager, new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight));
			
			this.renderEngine = new LazyRenderEngine(this.scene3D, this.camera3D, this.viewport3D);
			
			this.pointLight3D = new PointLight3D();
			this.pointLight3D.x = 1000;
			this.pointLight3D.y = 1000;
			this.pointLight3D.z = -1000;
			
			// load the model.
			// (this model has to be scaled and rotated to fit the marker; every model is different.)
			
			//model.load("../resources/assets/scout.dae");
			//do3dBase.rotationX = 90;
			//do3dBase.rotationZ = 90;
			//model.scale = 0.5;
			
			model1.load("../resources/assets1/dddna7.dae");
			//model1.rotationX = 90;
			//model1.rotationZ = 90;
			//model1.scale = 5;

			_board.load("../resources/assets1/board1.DAE");
			_board.scale = 5;
			_board.localRotationX = 180;
			_board.localRotationZ = -23;
			
			_dnax1.load("../resources/assets1/dnax1.DAE");
			_dnax1.scale = 0.4;
			_dnax1.localRotationX = 180;
			_dnax1.roll(135);
			
			_dnax2.load("../resources/assets1/dnax4.DAE");
			_dnax2.scale = 0.4;
			_dnax2.localRotationX = 180;
			_dnax2.roll(135);
			
			_dnax3.load("../resources/assets1/dnax3.DAE");
			_dnax3.scale = 0.4;
			_dnax3.localRotationX = 180;
			_dnax3.roll(135);
			
			_dnax4.load("../resources/assets1/dnax2.DAE");
			_dnax4.scale = 0.4;
			_dnax4.localRotationX = 180;
			_dnax4.roll(135);
			
			_dnaxBoard1.localRotationY = 180;
			_dnaxBoard1.roll(-90);
			_dnaxBoard2.localRotationY = 180;
			_dnaxBoard2.roll(-90);
			_dnaxBoard3.localRotationY = 180;
			_dnaxBoard3.roll(-90);
			_dnaxBoard4.localRotationY = 180;
			_dnaxBoard4.roll(-90);
			
			_dnax1.scale = 1;
			_dnax2.scale = 1;
			_dnax3.scale = 1;
			_dnax4.scale = 1;

			
			// create a container for the model, that will accept matrix transformations.
			//this.modelContainer = new DisplayObject3D();
			this.modelContainer = new DisplayObject3D();
			//var do3dBase:DisplayObject3D = new DisplayObject3D();
			this.modelContainer.addChild(do3dBase);
			
//			model.addChild(model1);
			//this.modelContainer.addChild(_board);
			
			this.modelContainer.visible = false;
			this.scene3D.addChild(this.modelContainer);
			//dnaIn(model1);
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		
		private function onMarkerAdded (evt:FLARMarkerEvent) :void {
			trace("["+evt.marker.patternId+"] added");
			this.modelContainer.visible = true;
			this.activeMarker = evt.marker;
			if(!isPlaying)
			{
				dnaRotation(model1);
				//dnaIn(model1);
				isPlaying = true;
			}
			
		}
		private function dnaIn(do3d:DisplayObject3D):void
		{
			Tweener.addTween(do3d,{scale:do3d.scale + 20,rotationY:do3d.rotationY - 30,
				rotationZ:do3d.rotationZ + 10,z:do3d.z + 15,y:do3d.y + 200,x:do3d.x - 20,
				time:8,onComplete:boardIn,onCompleteParams:[_board]});
			
		}
		private function boardIn(do3d:DisplayObject3D):void
		{
			board1sound.play();
			//overIn(_overBoard);
			//this.modelContainer.addChild(_board);
			this.modelContainer.addChild(do3d);
			//_earth.addChild(do3d);
			do3d.y = 500;
			
			CurveModifiers.init();  
			
			Tweener.addTween(do3d,{
				rotationX:do3d.rotationX + 720,
				x:0,
				y:-50,
				z:0,
				_bezier:{x:-300,y:100,z:-400},
				time:7,
				transition:"easeInOutQuad",
				onComplete:boardRotation,
				onCompleteParams:[do3d]
			});
			
			
			/*//var boardTimer:Time
			do3d.x = -300;
			do3d.z = 0;
			//_markerNode.addChild(_dna);
			//scene.addChild(do3d);
			_markerNode.addChild(do3d);
			Tweener.addTween(do3d,{x:do3d.x + 3500,time:5,onComplete:boardStay_1,onCompleteParams:[do3d]});
			*/
		}
		
		private function boardRotation(do3d:DisplayObject3D):void
		{
			
			//用delay就省得再加一个stay了
			Tweener.addTween(do3d,{rotationX:do3d.rotationX + 180,time:5,delay:5,transition:"easeInOutCirc"
				,onComplete:boardOut,onCompleteParams:[do3d]
			});
			
		}
		
		private function boardOut(do3d:DisplayObject3D):void
		{
			board2sound.play();
			Tweener.addTween(do3d,{z:do3d.z + 500,time:5,delay:10,transition:"easeInOutCirc",onComplete:boardRemove,onCompleteParams:[do3d]});
			
		}
		
		private function boardRemove(do3d:DisplayObject3D):void//我说怎么remove不了，没在上一名里调用能删去吗，真的是！！
		{
			this.modelContainer.removeChild(do3d);//这样好像不很呀
			/*scene.removeChildByName("_board");
			this.parent.removeChild(this);
			MovieClip(parent).removeMovieClip(this.);
			this.remove(do3d);
			scene.addChild(dnax[0]);
			dnax1In(dnax[0]);*/
			dnax1In(_dnax1);
			//dnax2In(_dnax2);
		}
		
		private function dnax1In(do3d:DisplayObject3D):void
		{
			/*do3d.x = 0;
			do3d.y = 300;
			do3d.z = -500;
			do3d.scale = -30;
			scene.addChild(do3d);
			Tweener.addTween(do3d,{rotationY:do3d.rotationY - 720,scale:do3d.scale + 30,time:2});*/
			
			do3d.x = 0;
			do3d.y = 300;
			do3d.z = -750;
			//do3d.scale = 30;
			//do3d.scale = -30;
			this.do3dBase.addChild(do3d);
			
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY - 1800,
				//scale:do3d.scale - 29,
				x:-50,
				y:0,
				z:-50,
				_bezier:{x:0,y:300,z:500},time:4,transition:"easeInOutCirc",
				onComplete:dnax2In,onCompleteParams:[_dnax2]
				//,onComplete:dnaxBoard1In,onCompleteParams:[_dnaxBoard1]
			});
			Tsound.play();
		}
		
		private function dnax2In(do3d:DisplayObject3D):void
		{
			do3d.x = -100;
			do3d.y = -140;
			//do3d.z = -600;
			do3d.z = 500
			this.modelContainer.addChild(do3d);		
			/*以下是转了一个圈出现的效果
			CurveModifiers.init();
			Tweener.addTween(do3d,{
			x:200,
			y:0,
			z:-500,
			_bezier:{x:-300,y:300,z:-700},
			time:2,
			transition:"easeInOutQuad"
			});*/
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY + 3600,
				x:100,
				y:100,
				z:0,
				_bezier:{x:-100,y:-100,z:-700},
				time:3,
				transition:"easeInOutCirc",
				onComplete:dnaxBoard1In,onCompleteParams:[_dnaxBoard1]
			});
			Gsound.play();
			
		}
		
		private function dnaxBoard1In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = -50;
			do3d.y = -200;
			do3d.z = -50;
			this.modelContainer.addChild(do3d);
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce",
				onComplete:dnaxBoard2In,onCompleteParams:[_dnaxBoard2]});
		
		}
		
		private function dnaxBoard2In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = 100;
			do3d.y = -150;
			do3d.z = 0;
			this.modelContainer.addChild(do3d);
			/*Tweener.addTween(do3d,{scale:do3d.scale + 1,time:2,transition:"easeInBounce",onComplete:dnaxBoard12Remove,onComplete:overIn,onCompleteParams:[_overBoard]});
			可以在执行了补间动画之后执行多少onComplete（也可以没有onCompleteParams）
			*/
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce"
				,onComplete:dnaxBoardStay1,onCompleteParams:[do3d]
			});
		}
		private function dnaxBoardStay1(do3d:DisplayObject3D):void
		{
			Tweener.addTween(do3d,{x:do3d.x + 0,time:7,onComplete:dnaxAnddnaxBoard12Remove});
		}
		
		private function dnaxAnddnaxBoard12Remove():void
		{
			this.do3dBase.removeChild(_dnax1);
			this.modelContainer.removeChild(_dnax2);
			this.modelContainer.removeChild(_dnaxBoard1);
			this.modelContainer.removeChild(_dnaxBoard2);
			//overIn(_overBoard);//测试这个函数是否被执行用，这个方法
			dnaRight(model1);
			
		}
		
		private function dnaRight(do3d:DisplayObject3D):void
		{
			Tweener.addTween(do3d,{y:do3d.y - 20,time:5,delay:1
				,onComplete:dnax3In,onCompleteParams:[_dnax3]});
		}
		
		private function dnax3In(do3d:DisplayObject3D):void
		{
			this.do3dBase.addChild(do3d);
			do3d.x = 0;
			do3d.y = 0;
			do3d.z = 0;
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY - 1800,
				//scale:do3d.scale - 29,
				x:-50,
				y:-20,
				z:0,
				_bezier:{x:50,y:200,z:500},time:4,transition:"easeInOutCirc",onComplete:dnax4In,onCompleteParams:[_dnax4]});
			Csound.play();
		}
		
		private function dnax4In(do3d:DisplayObject3D):void
		{
			this.modelContainer.addChild(do3d);
			do3d.x = 100;
			do3d.y = 0;
			do3d.z = 0;
			
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY + 3600,
				x:100,
				y:0,
				z:0,
				_bezier:{x:-100,y:-100,z:-700},
				time:3,
				transition:"easeInOutCirc"
				,onComplete:dnaxBoard3In,onCompleteParams:[_dnaxBoard3]
			});
			Asound.play();
		}
		
		private function dnaxBoard3In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = -50;
			do3d.y = 150;
			do3d.z = -20;
			this.modelContainer.addChild(do3d);
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce",
				onComplete:dnaxBoard4In,onCompleteParams:[_dnaxBoard4]});
		}
		private function dnaxBoard4In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = 100;
			do3d.y = 180;
			do3d.z = -20;
			this.modelContainer.addChild(do3d);
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce"
				,onComplete:overStay
			});
		}
		
		private function overStay():void
		{
			Tweener.addTween(_overBoard,{x:_overBoard.x + 0,time : 5,
				onComplete:overIn,onCompleteParams:[_overBoard]});
		}
		
		private function overIn(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			this.scene3D.addChild(do3d);
			//do3d.x = 2000;
			do3d.z = 100;
			Tweener.addTween(do3d,{scale:do3d.scale + 50,time:20,
				onComplete:over,onCompleteParams:[do3d]});
		}
		
		private function over(do3d:DisplayObject3D):void
		{
			this.scene3D.removeChild(this.modelContainer);
			Tweener.addTween(do3d,{z:do3d.z - 50,time:2});
		}
		private function dnaRotation(do3d:DisplayObject3D):void
		{
			if(!isDnaPlaying)
			{
				dnaContainer.addChild(do3d);
				do3dBase.addChild(dnaContainer);
				do3d.localRotationZ -= 90;
				dnaIn(dnaContainer);
				isDnaPlaying = true;
			}
			Tweener.addTween(do3d,{rotationY:do3d.rotationY - 360,time:3,transition:"linear",onComplete:dnaRotation,onCompleteParams:[do3d]});
			
		}
		
		private function onMarkerUpdated (evt:FLARMarkerEvent) :void {
			//trace("["+evt.marker.patternId+"] updated");
			this.modelContainer.visible = true;
			this.activeMarker = evt.marker;
		}
		
		private function onMarkerRemoved (evt:FLARMarkerEvent) :void {
			trace("["+evt.marker.patternId+"] removed");
			this.modelContainer.visible = false;
			this.activeMarker = null;
		}
		
		private function onEnterFrame (evt:Event) :void {
			// apply the FLARToolkit transformation matrix to the Cube.
			
			//model.z ++;//把z分别换成x和y用来确定三个轴的正方向
			if (this.activeMarker) {
				this.modelContainer.transform = PVGeomUtils.convertMatrixToPVMatrix(this.activeMarker.transformMatrix);
			}
			
			// update the Papervision3D view.
			this.renderEngine.render();
		}
		private function keyDownHandler(evt:KeyboardEvent):void//EventListener没加对
		{
			if(evt.keyCode == Keyboard.UP)
				modelContainer.x += 5;
			if(evt.keyCode == Keyboard.DOWN)
				modelContainer.y += 5;
			if(evt.keyCode == Keyboard.LEFT)
				modelContainer.z += 5;
			
		}
		private function initT():Plane
		{	
			var materialSprite:Sprite = new Sprite();
			materialSprite.graphics.beginFill(0x00A2E8);
			materialSprite.graphics.drawRect(0,0,112,75);
			
			var textfield:TextField = new TextField();
			textfield.text = "胸腺嘧啶(T)";
			textfield.autoSize = TextFieldAutoSize.LEFT;  
			textfield.setTextFormat(new TextFormat("Arial",15));
			textfield.x = (materialSprite.width - textfield.width) / 2;
			textfield.y = (materialSprite.height - textfield.height) / 2;
			
			materialSprite.addChild(textfield);
			//addChild(materialSprite);
			
			//var material:MovieMaterial = new MovieMaterial(materialSprite);
			var material:MovieMaterial = new MovieMaterial(materialSprite);
			material.smooth = true;
			material.doubleSided = true;
			
			var plane:Plane = new Plane(material);
			//scene.addChild(plane);
			return plane;
		}
		private function initG():Plane
		{	
			var materialSprite:Sprite = new Sprite();
			materialSprite.graphics.beginFill(0x6FFF93);
			materialSprite.graphics.drawRect(0,0,112,75);
			
			var textfield:TextField = new TextField();
			textfield.text = "鸟嘌呤（G）";
			textfield.autoSize = TextFieldAutoSize.LEFT;  
			textfield.setTextFormat(new TextFormat("Arial",15));
			textfield.x = (materialSprite.width - textfield.width) / 2;
			textfield.y = (materialSprite.height - textfield.height) / 2;
			
			materialSprite.addChild(textfield);
			//addChild(materialSprite);
			
			//var material:MovieMaterial = new MovieMaterial(materialSprite);
			var material:MovieMaterial = new MovieMaterial(materialSprite);
			material.smooth = true;
			material.doubleSided = true;
			
			var plane:Plane = new Plane(material);
			//scene.addChild(plane);
			return plane;
		}
		private function initC():Plane
		{	
			var materialSprite:Sprite = new Sprite();
			materialSprite.graphics.beginFill(0x6FFF93);
			materialSprite.graphics.drawRect(0,0,112,75);
			
			var textfield:TextField = new TextField();
			textfield.text = "胞嘧啶（C）";
			textfield.autoSize = TextFieldAutoSize.LEFT;  
			textfield.setTextFormat(new TextFormat("Arial",15));
			textfield.x = (materialSprite.width - textfield.width) / 2;
			textfield.y = (materialSprite.height - textfield.height) / 2;
			
			materialSprite.addChild(textfield);
			//addChild(materialSprite);
			
			//var material:MovieMaterial = new MovieMaterial(materialSprite);
			var material:MovieMaterial = new MovieMaterial(materialSprite);
			material.smooth = true;
			material.doubleSided = true;
			
			var plane:Plane = new Plane(material);
			//scene.addChild(plane);
			return plane;
		}
		private function initA():Plane
		{	
			var materialSprite:Sprite = new Sprite();
			materialSprite.graphics.beginFill(0x00A2E8);
			materialSprite.graphics.drawRect(0,0,112,75);
			
			var textfield:TextField = new TextField();
			textfield.text = "腺嘌呤（A）";
			textfield.autoSize = TextFieldAutoSize.LEFT;  
			textfield.setTextFormat(new TextFormat("Arial",15));
			textfield.x = (materialSprite.width - textfield.width) / 2;
			textfield.y = (materialSprite.height - textfield.height) / 2;
			
			materialSprite.addChild(textfield);
			//addChild(materialSprite);
			
			//var material:MovieMaterial = new MovieMaterial(materialSprite);
			var material:MovieMaterial = new MovieMaterial(materialSprite);
			material.smooth = true;
			material.doubleSided = true;
			
			var plane:Plane = new Plane(material);
			//scene.addChild(plane);
			return plane;
		}
		
	}
}