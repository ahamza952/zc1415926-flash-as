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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	//import org.osmf.traits.SwitchableTrait;
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

		private var model:DAE = new DAE();
		private var model1:DAE = new DAE();
		private var do3dBase:DisplayObject3D = new DisplayObject3D();
		
		private var _board:DAE = new DAE();
		
		private var _dnax1:DAE = new DAE();
		private var _dnax2:DAE = new DAE();
		private var _dnax3:DAE = new DAE();
		private var _dnax4:DAE = new DAE();
		
		private var overBoardMaterial:ColorMaterial = new ColorMaterial(0xE60000);

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
		
		/**
		 * One over,one step.
		 */
		private var clickCount:uint = 0;
		private var onProcessing:Boolean = false;
		
		private var Processing:Sprite = new Sprite();
		
		//[Embed(source="../resources/assets/onProcessing.swf", symbol="Processing")]
		[Embed(source="../resources/assets/onProcessing.jpg")]
		private var OnProcessingSwf:Class;
		
		//[Embed(source="../resources/assets/notOnProcessing.swf", symbol="Processing")]
		[Embed(source="../resources/assets/notOnProcessing.jpg")]
		private var NotOnProcessingSwf:Class;
		
		public function DNA() {
			
			Processing.addChildAt(new OnProcessingSwf(),0);
			Processing.addChildAt(new NotOnProcessingSwf(),1);
			
			Processing.y = stage.stageHeight - Processing.height;
			Processing.x = stage.stageWidth - Processing.width;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
		}
		
		private function onAdded (evt:Event) :void {
			background.play(0,0,backtrans);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
			
			this.flarManager = new FLARManager("../resources/flar/flarConfig.xml", new FLARToolkitManager(), this.stage);
			
			this.addChild(Sprite(this.flarManager.flarSource));
			
			addChild(Processing);
			
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
			this.flarManager.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);//测试在FLARManger中的三个轴用
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
			
			model1.load("../resources/assets/a3dddna8.DAE");

			_board.load("../resources/assets/a3board01.DAE");
			_board.scale = 5;
			_board.localRotationX = 180;
			_board.localRotationZ = -23;
			
			_dnax1.load("../resources/assets/a3dnax1.DAE");
			_dnax1.scale = 0.4;
			_dnax1.localRotationX = 180;
			_dnax1.roll(135);
			
			_dnax2.load("../resources/assets/a3dnax4.DAE");
			_dnax2.scale = 0.4;
			_dnax2.localRotationX = 180;
			_dnax2.roll(135);
			
			_dnax3.load("../resources/assets/a3dnax3.DAE");
			_dnax3.scale = 0.4;
			_dnax3.localRotationX = 180;
			_dnax3.roll(135);
			
			_dnax4.load("../resources/assets/a3dnax2.DAE");
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

			this.modelContainer = new DisplayObject3D();
			this.modelContainer.addChild(do3dBase);
			this.modelContainer.visible = false;
			this.scene3D.addChild(this.modelContainer);

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
			if(!onProcessing){
				/*if(clickCount == 0)
				{
					clickCount++;
				}
				else*/ if(clickCount == 0)//这不是0，因为和非增强现实不一样，第一次显示就有一个onMarkerAdded
				{
					boardIn(_board);
					clickCount++;
				}
				else if(clickCount == 1)
				{
					dnax1In(_dnax1);
					//dnax2In(_dnax2);
					clickCount++;
				}
				else if(clickCount == 2)
				{
					dnaxAnddnaxBoard12Remove();
					clickCount++;
				}
			}
		}
		
		/**
		 * One over,one step.
		 */
		private function dnaIn(do3d:DisplayObject3D):void
		{
			OnProcessing();
			
			Tweener.addTween(do3d,{scale:do3d.scale + 20,rotationY:do3d.rotationY - 30,
				rotationZ:do3d.rotationZ + 10,z:do3d.z + 15,y:do3d.y + 200,x:do3d.x - 20,
				time:6,transition:"easeInOutCubic",onComplete:NotOnProcessing});
			
		}
		private function boardIn(do3d:DisplayObject3D):void
		{
			OnProcessing();
			
			board1sound.play();

			this.modelContainer.addChild(do3d);
			do3d.y = 500;
			
			CurveModifiers.init();  
			
			Tweener.addTween(do3d,{
				rotationX:do3d.rotationX + 720,
				x:0,
				y:-50,
				z:0,
				_bezier:{x:-400,y:-600,z:-1500},
				time:7,
				transition:"easeInOutQuad",
				onComplete:boardRotation,
				onCompleteParams:[do3d]
			});
		}
		
		private function boardRotation(do3d:DisplayObject3D):void
		{
			Tweener.addTween(do3d,{rotationX:do3d.rotationX + 180,time:5,delay:5,transition:"easeInOutCirc"
				,onComplete:boardOut,onCompleteParams:[do3d]
			});
		}
		
		private function boardOut(do3d:DisplayObject3D):void
		{
			board2sound.play();
			Tweener.addTween(do3d,{z:do3d.z + 500,time:5,delay:10,transition:"easeInOutCirc",onComplete:boardRemove,onCompleteParams:[do3d]});
		}
		/**
		 * One over,one step.
		 */
		private function boardRemove(do3d:DisplayObject3D):void//我说怎么remove不了，没在上一名里调用能删去吗，真的是！！
		{
			this.modelContainer.removeChild(do3d);//这样好像不很呀
			NotOnProcessing();
			//dnax1In(_dnax1);
			//dnax2In(_dnax2);
		}
		
		private function dnax1In(do3d:DisplayObject3D):void
		{
			OnProcessing();
			
			do3d.x = -200;
			do3d.y = 0;
			do3d.z = -1500;
			
			this.do3dBase.addChild(do3d);
			
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY - 1800,
				//scale:do3d.scale - 29,
				x:-100,
				y:100,
				z:-300,
				_bezier:{x:-100,y:-100,z:400},time:4,transition:"easeInOutCirc",
				onComplete:dnax2In,onCompleteParams:[_dnax2]
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

			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY + 3600,
				x:100,
				y:100,
				z:-300,
				_bezier:{x:-100,y:-100,z:-2000},
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
			do3d.z = -300;
			this.modelContainer.addChild(do3d);
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce",
				onComplete:dnaxBoard2In,onCompleteParams:[_dnaxBoard2]});
		}
		
		private function dnaxBoard2In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = 100;
			do3d.y = -150;
			do3d.z = -250;
			this.modelContainer.addChild(do3d);

			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce"
				,onComplete:dnaxBoardStay1,onCompleteParams:[do3d]
			});
		}
		/**
		 * One over,one step.
		 */
		private function dnaxBoardStay1(do3d:DisplayObject3D):void
		{
			Tweener.addTween(do3d,{x:do3d.x + 0,time:7,onComplete:NotOnProcessing});
		}
		
		private function dnaxAnddnaxBoard12Remove():void
		{
			OnProcessing();
			
			this.do3dBase.removeChild(_dnax1);
			this.modelContainer.removeChild(_dnax2);
			this.modelContainer.removeChild(_dnaxBoard1);
			this.modelContainer.removeChild(_dnaxBoard2);
			
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
			do3d.z = -3000;
			CurveModifiers.init();
			Tweener.addTween(do3d,{
				rotationY:do3d.rotationY - 3600,
				x:-50,
				y:-20,
				z:-250,
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
				y:100,
				z:-300,
				_bezier:{x:-100,y:-100,z:-2000},
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
			do3d.z = -250;
			this.modelContainer.addChild(do3d);
			Tweener.addTween(do3d,{scale:do3d.scale + 0.5,time:2,transition:"easeInBounce",
				onComplete:dnaxBoard4In,onCompleteParams:[_dnaxBoard4]});
		}
		private function dnaxBoard4In(do3d:DisplayObject3D):void
		{
			do3d.material.doubleSided = true;
			do3d.x = 100;
			do3d.y = 180;
			do3d.z = -300;
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
		/**
		 * One over,one step.
		*/
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
		
		private function OnProcessing():void//防止在动画中出现下一步
		{
			this.onProcessing = true;
			
			/*Processing = Sprite(new OnProcessingSwf());
			Processing.y = stage.stageHeight - Processing.height;
			Processing.x = stage.stageWidth - Processing.width;
			addChild(Processing);*/
			
			/*if(Processing.getChildAt(0))
			{//有没有“替换”ChildAT
				Processing.removeChildAt(0);
			}*/
			//addChild(Processing.getChildAt(1));
			Processing.swapChildrenAt(0, 1);
			//swapChildrenAt(0,1);
		}
		
		private function NotOnProcessing():void
		{
			this.onProcessing = false;
			
			/*Processing = Sprite(new NotOnProcessingSwf());
			Processing.y = stage.stageHeight - Processing.height;
			Processing.x = stage.stageWidth - Processing.width;
			addChild(Processing);*/
			Processing.swapChildrenAt(0, 1);
			//swapChildrenAt(1,0);
			//addChild(Processing.getChildAt(0));
			//addChild(Processing);
		}
		
		private function onEnterFrame (evt:Event) :void {
			if (this.activeMarker) {
				this.modelContainer.transform = PVGeomUtils.convertMatrixToPVMatrix(this.activeMarker.transformMatrix);
			}
			this.renderEngine.render();
		}
		private function keyDownHandler(evt:KeyboardEvent):void//EventListener没加对
		{//测试xyz坐标到底是哪个
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