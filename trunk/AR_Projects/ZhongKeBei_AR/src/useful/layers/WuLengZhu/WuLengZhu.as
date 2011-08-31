package useful.layers.WuLengZhu {
	
//	import CustomMaterials.TextMaterial;
	
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.containers.ConflictContainer;
	import alternativa.engine3d.containers.DistanceSortContainer;
	import alternativa.engine3d.containers.KDContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.Sorting;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.primitives.Box;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	import flash.system.LoaderContext;
	
	import useful.components.Button;
	import useful.embedmanager.EmbedManager;
	import useful.layers.Chapter1;
	
//	import ssnangua.MovieClipMaterial;
//	import ssnangua.Polygon;
	
	[SWF(width="320", height="450", frameRate="24")]
	public class WuLengZhu extends Sprite {
		
		//[Embed(source="/assets/sum2.jpg")]	static public const Sum1:Class;
		[Embed(source="/assets/q/q1A.jpg")]	static public const Q1A:Class;
		[Embed(source="/assets/q/q2A.jpg")]	static public const Q2A:Class;
		[Embed(source="/assets/q/q3A.jpg")]	static public const Q3A:Class;
		[Embed(source="/assets/q/q4A.jpg")]	static public const Q4A:Class;
		[Embed(source="/assets/q/q5A.jpg")]	static public const Q5A:Class;
	
		[Embed(source="/assets/q/q1B.jpg")]	static public const Q1B:Class;
		[Embed(source="/assets/q/q2B.jpg")]	static public const Q2B:Class;
		[Embed(source="/assets/q/q3B.jpg")]	static public const Q3B:Class;
		[Embed(source="/assets/q/q4B.jpg")]	static public const Q4B:Class;
		[Embed(source="/assets/q/q5B.jpg")]	static public const Q5B:Class;
		
		[Embed(source="/assets/q/q1C.jpg")]	static public const Q1C:Class;
		[Embed(source="/assets/q/q2C.jpg")]	static public const Q2C:Class;
		[Embed(source="/assets/q/q3C.jpg")]	static public const Q3C:Class;
		[Embed(source="/assets/q/q4C.jpg")]	static public const Q4C:Class;
		[Embed(source="/assets/q/q5C.jpg")]	static public const Q5C:Class;
		
		[Embed(source="/assets/right2.jpg")] static public const Right:Class;
		[Embed(source="/assets/wrong4.jpg")] static public const Wrong:Class;
		
		private var rootContainer:KDContainer = new KDContainer();
		private var scene:KDContainer = new KDContainer();
		
		private var camera:Camera3D;
		
		private var mesh:Mesh;
		
		private var meshControler:SimpleObjectController;
		
		//private var question1:Vector.<Plane>;
		
		private var options1A:Mesh;
		private var options2A:Mesh;
		private var options3A:Mesh;
		private var options4A:Mesh;
		private var options5A:Mesh;
		
		private var option1B:Mesh;
		private var option2B:Mesh;
		private var option3B:Mesh;
		private var option4B:Mesh;
		private var option5B:Mesh;
		
		private var option1C:Mesh;
		private var option2C:Mesh;
		private var option3C:Mesh;
		private var option4C:Mesh;
		private var option5C:Mesh;
		
		private var cameraVector3D:Vector3D = new Vector3D(0, 0, 0);
	//	private var rightOrWrongSprite3D:Sprite3D;
		
		private var backButton:Button;
		private var nextButton:Button;
		private var previousButton:Button;
		
		private var skyBox:Box;
		
	//	private var chapter1:Chapter1;
		
		public function WuLengZhu() {
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			

			camera = new Camera3D();
		//	camera.view = new View(stage.stageWidth, stage.stageHeight);
			
			camera.view = new View(320, 460);
			addChild(camera.view);
			//addChild(camera.diagram);
			
			camera.rotationX = -90*Math.PI/180;
			camera.y = -400;
			camera.z = 0;
			rootContainer.addChild(camera);
			
			scene.x += 700;
			scene.y += 400;
			trace("scene.x y z:" + scene.x + " " + scene.y + " " + scene.z);
			rootContainer.addChild(scene);
			
			backButton = new Button("Back.swf");
			backButton.x = 50;
			backButton.y = 420;
			backButton.addEventListener(MouseEvent.CLICK, onBackButtonClicked);
			addChild(backButton);
			
						
			
			
			skyBox = new Box(1000,1000,1000,1,1,1,true,false,
				new TextureMaterial(new EmbedManager.SkyBoxLeft().bitmapData),
				new TextureMaterial(new EmbedManager.SkyBoxRight().bitmapData),
				new TextureMaterial(new EmbedManager.SkyBoxBack().bitmapData),
				new TextureMaterial(new EmbedManager.SkyBoxFront().bitmapData),
				new TextureMaterial(new EmbedManager.SkyBoxBottom().bitmapData),
				new TextureMaterial(new EmbedManager.SkyBoxTop().bitmapData));
			//var wuBianXing:Polygon = new Polygon(5, 170);
			rootContainer.addChild(skyBox);
			
			
			mesh = new Mesh();
			
			var v6:Vertex = mesh.addVertex(150, 0.00, 170.00, 0, 1, "v6");
			var v5:Vertex = mesh.addVertex(46.35, -142.665, 170.00, 0.2,1,  "v5");
			var v4:Vertex = mesh.addVertex(-121.35, -88.17, 170.00, 0.4,1,  "v4");
			var v3:Vertex = mesh.addVertex(-121.35, 88.17, 170.00, 0.6,1,  "v3");
			var v2:Vertex = mesh.addVertex(46.35, 142.665, 170.00, 0.8,1,  "v2");
			var v1:Vertex = mesh.addVertex(150, 0.00, 170.00, 1, 1, "v1");//这个点是在X轴上的，不是在Y轴上
				
			var v66:Vertex = mesh.addVertex(150, 0.00, -30.00, 0, 0, "v66");
			var v55:Vertex = mesh.addVertex(46.35, -142.665, -30.00, 0.2,0,  "v55");
			var v44:Vertex = mesh.addVertex(-121.35,  -88.17, -30.00, 0.4,0,  "v44");
			var v33:Vertex = mesh.addVertex(-121.35, 88.17, -30.00,0.6,0,  "v33");
			var v22:Vertex = mesh.addVertex(46.35, 142.665, -30.00, 0.8,0,  "v22");
			var v11:Vertex = mesh.addVertex(150, 0.00, -30.00, 1,0,  "v11");
			
			
			/*var v6:Vertex = mesh.addVertex(150, 250, 170.00, 1, 1, "v6");
			var v5:Vertex = mesh.addVertex(150, 200, 170.00, 1,0.8,  "v5");
			var v4:Vertex = mesh.addVertex(150, 150, 170.00, 1,0.6,  "v4");
			var v3:Vertex = mesh.addVertex(150, 100, 170.00, 1,0.4,  "v3");
			var v2:Vertex = mesh.addVertex(150, 50, 170.00, 1,0.2,  "v2");
			var v1:Vertex = mesh.addVertex(150, 0.00, 170.00, 1, 0, "v1");//这个点是在X轴上的，不是在Y轴上
			
			var v66:Vertex = mesh.addVertex(150, 250, -30.00, 0, 1, "v66");
			var v55:Vertex = mesh.addVertex(150, 200, -30.00, 0,0.8,  "v55");
			var v44:Vertex = mesh.addVertex(150, 150, -30.00, 0,0.6,  "v44");
			var v33:Vertex = mesh.addVertex(150, 100, -30.00,0,0.4,  "v33");
			var v22:Vertex = mesh.addVertex(150, 50, -30.00, 0,0.2,  "v22");
			var v11:Vertex = mesh.addVertex(150, 0.00, -30.00, 0,0,  "v11");*/
			
			
			
			//mesh.addFaceByIds(["v1", "v2", "v3", "v4", "v5"], new FillMaterial(0xFFFFFF * Math.random()));		
			
			//mesh.addFaceByIds(["v1", "v5", "v55", "v11"]);
			//mesh.addFaceByIds(["v1", "v11", "v55", "v5"]);
			
			
			
			//mesh.addFaceByIds(["v5", "v4", "v44", "v55"]);
			//mesh.addFaceByIds(["v5", "v55", "v44", "v4"]);
			
			//mesh.addFaceByIds(["v4", "v3", "v33", "v44"]);
			//mesh.addFaceByIds(["v4", "v44", "v33", "v3"]);
			
			//mesh.addFaceByIds(["v3", "v2", "v22", "v33"]);
			//mesh.addFaceByIds(["v3", "v33", "v22", "v2"]);
			
			//mesh.addFaceByIds(["v2", "v6", "v66", "v22"]);
			//mesh.addFaceByIds(["v2", "v22", "v66", "v6"]);
			//mesh.addFaceByIds(["v11", "v55", "v44", "v33", "v22"], new FillMaterial(0xFFFFFF * Math.random()));
			
			mesh.addFaceByIds(["v1", "v11", "v22", "v2"]);
			mesh.addFaceByIds(["v1", "v2", "v22", "v11"]);
			
			mesh.addFaceByIds(["v2", "v22", "v33", "v3"]);	
			mesh.addFaceByIds(["v2", "v3", "v33", "v22"]);
			
			mesh.addFaceByIds(["v3", "v33", "v44", "v4"]);			
			mesh.addFaceByIds(["v3", "v4", "v44", "v33"]);
			
			mesh.addFaceByIds(["v4", "v44", "v55", "v5"]);			
			mesh.addFaceByIds(["v4", "v5", "v55", "v44"]);
			
			mesh.addFaceByIds(["v5", "v55", "v66", "v6"]);		
			mesh.addFaceByIds(["v5", "v6", "v66", "v55"]);
			
			//var material:TextureMaterial = new TextureMaterial(new Sum1().bitmapData);
			var material:TextureMaterial = new TextureMaterial();
			material.diffuseMapURL = "assets/sum2.jpg";
			var textures:Vector.<TextureMaterial> = new Vector.<TextureMaterial>;
			textures.push(material);
			var context:LoaderContext = new LoaderContext(true);
			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.load(textures,context);
			material.correctUV = true;
			
			mesh.setMaterialToAllFaces(material);
			
			mesh.calculateFacesNormals();
			mesh.calculateBounds();
			
			mesh.rotationX = Math.PI;
			mesh.rotationZ -= 126 * Math.PI / 180;
			mesh.z += 150;
			
			scene.addChild(mesh);
			
			options1A = new Mesh();
			options1A.name = "option1A";
			options2A = new Mesh();
			options3A = new Mesh();
			options4A = new Mesh();
			options4A.name = "option4A";
			options5A = new Mesh();
			
			var q1:Vertex = options1A.addVertex(170.00, 0.00, -30.00, 1, 0, "q1");
			var q5:Vertex = options1A.addVertex(52.53, -161.68, -30.00, 0, 0, "q5");
			var q55:Vertex = options1A.addVertex(52.53, -161.68, -70.00, 0, 1, "q55");
			var q11:Vertex = options1A.addVertex(170.00, 0.00, -70.00, 1, 1, "q11");

			var q555:Vertex = options2A.addVertex(52.53, -161.68, -30.00, 1, 0, "q555");
			var q4:Vertex = options2A.addVertex(-137.53, -99.92, -30.00, 0, 0, "q4");
			var q44:Vertex = options2A.addVertex(-137.53, -99.92, -70.00, 0, 1, "q44");
			var q5555:Vertex = options2A.addVertex(52.53, -161.68, -70.00, 1, 1, "q5555");

			var q444:Vertex = options3A.addVertex(-137.53, -99.92, -30.00, 1, 0, "q444");
			var q3:Vertex = options3A.addVertex(-137.53, 99.92, -30.00, 0, 0, "q3");
			var q33:Vertex = options3A.addVertex(-137.53, 99.92, -70.00, 0, 1, "q33");
			var q4444:Vertex = options3A.addVertex(-137.53, -99.92, -70.00, 1, 1, "q4444");

			var q333:Vertex = options4A.addVertex(-137.53, 99.92, -30.00, 1, 0, "q333");
			var q2:Vertex = options4A.addVertex(52.53, 161.68, -30.00, 0, 0, "q2");
			var q22:Vertex = options4A.addVertex(52.53, 161.68, -70.00, 0, 1, "q22");
			var q3333:Vertex = options4A.addVertex(-137.53, 99.92, -70.00, 1, 1, "q3333");

			var q222:Vertex = options5A.addVertex(52.53, 161.68, -30.00, 1, 0, "q222");
			var q6:Vertex = options5A.addVertex(170.00, 0.00, -30.00, 0, 0, "q6");
			var q66:Vertex = options5A.addVertex(170.00, 0.00, -70.00, 0, 1, "q66");
			var q2222:Vertex = options5A.addVertex(52.53, 161.68, -70.00, 1, 1, "q2222");
						
			options1A.addFaceByIds(["q1", "q5", "q55", "q11"]);
			options1A.addFaceByIds(["q1", "q11", "q55", "q5"]);
			
			options2A.addFaceByIds(["q555", "q4", "q44", "q5555"]);
			options2A.addFaceByIds(["q555", "q5555", "q44", "q4"]);
			
			options3A.addFaceByIds(["q444", "q3", "q33", "q4444"]);
			options3A.addFaceByIds(["q444", "q4444", "q33", "q3"]);
			
			options4A.addFaceByIds(["q333", "q2", "q22", "q3333"]);
			options4A.addFaceByIds(["q333", "q3333", "q22", "q2"]);
			
			options5A.addFaceByIds(["q222", "q6", "q66", "q2222"]);
			options5A.addFaceByIds(["q222", "q2222", "q66", "q6"]);
			
			//var optionsMaterial:FillMaterial = new FillMaterial(0xFFFFFF * Math.random());
			
			
			options1A.setMaterialToAllFaces(new TextureMaterial(new Q5A().bitmapData));
			options1A.calculateFacesNormals();
			options1A.calculateBounds();
			options1A.useHandCursor = true;
			
			options2A.setMaterialToAllFaces(new TextureMaterial(new Q4A().bitmapData));
			options2A.calculateFacesNormals();
			options2A.calculateBounds();
			options2A.useHandCursor = true;
			//options2A.scaleZ = 0.5;
			
			options3A.setMaterialToAllFaces(new TextureMaterial(new Q3A().bitmapData));
			options3A.calculateFacesNormals();
			options3A.calculateBounds();
			options3A.useHandCursor = true;
			//options3A.scaleZ = 0.5;
			
			options4A.setMaterialToAllFaces(new TextureMaterial(new Q2A().bitmapData));
			options4A.calculateFacesNormals();
			options4A.calculateBounds();
			options4A.useHandCursor = true;
			//options4A.scaleZ = 0.5;
			
			options5A.setMaterialToAllFaces(new TextureMaterial(new Q1A().bitmapData));
			options5A.calculateFacesNormals();
			options5A.calculateBounds();
			options5A.useHandCursor = true;
			//options5A.scaleZ = 0.5;
			options1A.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options1A.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options1A.addEventListener(MouseEvent3D.MOUSE_DOWN, onOptions5AMouseClicked);
			
			options2A.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options2A.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options2A.addEventListener(MouseEvent3D.MOUSE_DOWN, onOptions4AMouseClicked);
			
			options3A.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options3A.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options3A.addEventListener(MouseEvent3D.MOUSE_DOWN, onOptions3AMouseClicked);
			
			options4A.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options4A.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options4A.addEventListener(MouseEvent3D.MOUSE_DOWN, onOptions2AMouseClicked);
			
			options5A.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options5A.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options5A.addEventListener(MouseEvent3D.MOUSE_DOWN, onOptions1AMouseClicked);
			
		/*	
		//	var materialSprite:Sprite = new Sprite();
		//	materialSprite.graphics.beginFill(0x00A2E8);
		//	materialSprite.graphics.drawRect(0,0,112,25);
			
			var textfield:TextField = new TextField();
			textfield.text = "腺嘌呤（A）";
			textfield.background = true;
			textfield.backgroundColor = 0xFF7700;
			textfield.autoSize = TextFieldAutoSize.LEFT;  
			textfield.setTextFormat(new TextFormat("Arial",15));
			textfield.cacheAsBitmap = true;
		//	textfield.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			//	textfield.x = (materialSprite.width - textfield.width) / 2;
			//	textfield.y = (materialSprite.height - textfield.height) / 2;
		//	materialSprite.addChild(textfield);
			
			
		//	materialSprite.x = 100;
		//	materialSprite.y = 100;
		//	addChild(materialSprite);
			
			var bitmapData:BitmapData = new BitmapData(textfield.width, textfield.height, true, 0xaaaaaa);
			bitmapData.draw(textfield);
			var optionsMat:TextureMaterial = new TextureMaterial(bitmapData, false, true, 4, 4);
		//	optionsMat.correctUV = true;
			
			var plane:Plane = new Plane(textfield.width, textfield.height);
			plane.x = options1A.x;
			plane.y = options1A.y;
			plane.z = options1A.z;
			plane.rotationX = 90 * Math.PI / 180;
			var fillmaterial:FillMaterial = new FillMaterial(0xFF7700);
			//fillmaterial
			var textMaterial:TextMaterial = new TextMaterial("我是一个大好人！");
			
			plane.setMaterialToAllFaces(textMaterial);
			//plane.
			rootContainer.addChild(plane);
			*/
			
			
			option1B = options1A.clone() as Mesh;
			option1B.setMaterialToAllFaces(new TextureMaterial(new Q5B().bitmapData));
			option1B.z -= 50;
			
			option2B = options2A.clone() as Mesh;
			option2B.setMaterialToAllFaces(new TextureMaterial(new Q4B().bitmapData));
			option2B.z -= 50;
			
			option3B = options3A.clone() as Mesh;
			option3B.setMaterialToAllFaces(new TextureMaterial(new Q3B().bitmapData));
			option3B.z -= 50;
			
			option4B = options4A.clone() as Mesh;
			option4B.setMaterialToAllFaces(new TextureMaterial(new Q2B().bitmapData));
			option4B.z -= 50;
			
			option5B = options5A.clone() as Mesh;
			option5B.setMaterialToAllFaces(new TextureMaterial(new Q1B().bitmapData));
			option5B.z -= 50;
			
			option1B.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option1B.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option1B.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption5BMouseClicked);
			
			option2B.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option2B.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option2B.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption4BMouseClicked);
			
			option3B.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option3B.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option3B.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption3BMouseClicked);
			
			option4B.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option4B.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option4B.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption2BMouseClicked);
			
			option5B.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option5B.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option5B.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption1BMouseClicked);
			
			option1C = option1B.clone() as Mesh;
			option1C.setMaterialToAllFaces(new TextureMaterial(new Q5C().bitmapData));
			option1C.z -= 50;
			
			option2C = option2B.clone() as Mesh;
			option2C.setMaterialToAllFaces(new TextureMaterial(new Q4C().bitmapData));
			option2C.z -= 50;
			
			option3C = option3B.clone() as Mesh;
			option3C.setMaterialToAllFaces(new TextureMaterial(new Q3C().bitmapData));
			option3C.z -= 50;
			
			option4C = option4B.clone() as Mesh;
			option4C.setMaterialToAllFaces(new TextureMaterial(new Q2C().bitmapData));
			option4C.z -= 50;
			
			option5C = option5B.clone() as Mesh;
			option5C.setMaterialToAllFaces(new TextureMaterial(new Q1C().bitmapData));
			option5C.z -= 50;
			
			option1C.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option1C.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option1C.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption5CMouseClicked);
			
			option2C.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option2C.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option2C.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption4CMouseClicked);
			
			option3C.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option3C.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option3C.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption3CMouseClicked);
			
			option4C.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option4C.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option4C.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption2CMouseClicked);
			
			option5C.addEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option5C.addEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option5C.addEventListener(MouseEvent3D.MOUSE_DOWN, onOption1CMouseClicked);
			
			options1A.rotationZ -= 126 * Math.PI / 180;
			options2A.rotationZ -= 126 * Math.PI / 180;
			options3A.rotationZ -= 126 * Math.PI / 180;
			options4A.rotationZ -= 126 * Math.PI / 180;
			options5A.rotationZ -= 126 * Math.PI / 180;
			
			scene.addChild(options1A);
			scene.addChild(options2A);
			scene.addChild(options3A);
			scene.addChild(options4A);
			scene.addChild(options5A);
			
			option1B.rotationZ -= 126 * Math.PI / 180;
			option2B.rotationZ -= 126 * Math.PI / 180;
			option3B.rotationZ -= 126 * Math.PI / 180;
			option4B.rotationZ -= 126 * Math.PI / 180;
			option5B.rotationZ -= 126 * Math.PI / 180;
			
			scene.addChild(option1B);
			scene.addChild(option2B);
			scene.addChild(option3B);
			scene.addChild(option4B);
			scene.addChild(option5B);
			
			option1C.rotationZ -= 126 * Math.PI / 180;
			option2C.rotationZ -= 126 * Math.PI / 180;
			option3C.rotationZ -= 126 * Math.PI / 180;
			option4C.rotationZ -= 126 * Math.PI / 180;
			option5C.rotationZ -= 126 * Math.PI / 180;
			
			scene.addChild(option1C);
			scene.addChild(option2C);
			scene.addChild(option3C);
			scene.addChild(option4C);
			scene.addChild(option5C);
			
			/*var plane:Plane = new Plane(500, 500);
			plane.setMaterialToAllFaces(new FillMaterial(0xFF7700));
			rootContainer.addChild(plane);*/
			
		//	meshControler = new SimpleObjectController(stage, scene, 200);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onNextButtonClicked(e:MouseEvent):void
		{
			if(!Tweener.isTweening(scene))
			{
				Tweener.addTween(scene,{
					rotationZ:scene.rotationZ - 72 * Math.PI / 180,
					time:1
				});
			}
		}
		
		private function onPreviousButtonClicked(e:MouseEvent):void
		{
			if(!Tweener.isTweening(scene))
			{
				Tweener.addTween(scene,{
					rotationZ:scene.rotationZ + 72 * Math.PI / 180,
					time:1
				});
			}
		}
		
		private function onBackButtonClicked(e:MouseEvent):void
		{
			var chapter1:Chapter1 = new Chapter1();
			this.parent.addChild(chapter1);
			this.parent.removeChild(this);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			
			
			CurveModifiers.init();  
			
			Tweener.addTween(scene,
				{
					//rotationX:scene.rotationX + 720 * Math.PI / 180,
					rotationX:scene.rotationX + 720 * Math.PI / 180,
					x:0,
					y:100,
					z:0,
					_bezier:{x:-500, y:300, z:100},
					time:5,
					//delay:0.5,
					transition:"easeInCubic",
					onComplete:function():void{
						nextButton = new Button("NextButton.swf");
						nextButton.x = 300;
						nextButton.y = 220;
						nextButton.addEventListener(MouseEvent.CLICK, onNextButtonClicked);
						
						
						previousButton = new Button("PreviousButton.swf");
						previousButton.x = 20;
						previousButton.y = 220;
						previousButton.addEventListener(MouseEvent.CLICK, onPreviousButtonClicked);

						addChild(nextButton);
						addChild(previousButton);
					}
				});
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			options1A.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options2A.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options3A.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options4A.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			options5A.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			
			options1A.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options2A.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options3A.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options4A.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			options5A.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			
			/*options1A
			options2A
			options3A
			options4A
			options5A*/
			
			option1B.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option2B.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option3B.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option4B.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option5B.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			
			option1B.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option2B.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option3B.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option4B.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option5B.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			
			/*option1B
			option2B
			option3B
			option4B
			option5B*/
			
			option1C.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option2C.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option3C.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option4C.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			option5C.removeEventListener(MouseEvent3D.MOUSE_OVER, onOption4CMouseOver);
			
			option1C.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option2C.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option3C.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option4C.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			option5C.removeEventListener(MouseEvent3D.MOUSE_OUT, onOption4CMouseOut);
			
			/*option1C
			option2C
			option3C
			option4C
			option5C*/
			
			rootContainer.removeChild(scene);
			scene = null;
			
			/*scene.removeChild(options1A);
			scene.removeChild(options2A);
			scene.removeChild(options3A);
			scene.removeChild(options4A);
			scene.removeChild(options5A);
			
			removeChild(option1B);
			removeChild(option2B);
			removeChild(option3B);
			removeChild(option4B);
			removeChild(option5B);
			
			removeChild(option1C);
			removeChild(option2C);
			removeChild(option3C);
			removeChild(option4C);
			removeChild(option5C);*/
			
		}
		
		private function onOption4CMouseOut(e:MouseEvent3D):void
		{
			//option4C.z -= 5;
			e.target.filters = null;[new GlowFilter(0xFFFF00, 1, 10, 10, 4)];
			
			trace("e.target.name:" + e.target.name);
		}

		private function onOption4CMouseOver(e:MouseEvent3D):void
		{
			//option4C.z += 5;
			e.target.filters = [new GlowFilter(0xFFFF00, 1, 20, 20, 4)];
		}
		
		private function onOption1CMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption2CMouseClicked(e:MouseEvent3D):void
		{
			youAreRight();
		}
		
		private function onOption3CMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption4CMouseClicked(e:MouseEvent3D):void
		{
			youAreRight();
		}
		
		private function onOption5CMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption1BMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption2BMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption3BMouseClicked(e:MouseEvent3D):void
		{
			youAreRight();
		}
		
		private function onOption4BMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOption5BMouseClicked(e:MouseEvent3D):void
		{
			youAreRight();
		}
		
		private function onOptions1AMouseClicked(e:MouseEvent3D):void
		{
			youAreRight();
		}
		
		private function onOptions2AMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOptions3AMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOptions4AMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function onOptions5AMouseClicked(e:MouseEvent3D):void
		{
			youAreWrong();
		}
		
		private function youAreRight():void
		{
			var rightOrWrongSprite3D:Sprite3D = new Sprite3D(250, 332, new TextureMaterial(new Right().bitmapData));
			//var rightOrWrongSprite3D:Bitmap = new Bitmap(new Right().bitmapData)
			
			//trace("camera.x:" + camera.x +"camera.y:"+ camera.y +"camera.z:"+camera.z);
			//trace(scene.localToGlobal(new Vector3D(camera.x, camera.y, camera.z)));
			
			//cameraVector3D = scene.localToGlobal(new Vector3D(camera.x, camera.y, camera.z));
			//trace(scene.rotationZ);	
			
			rightOrWrongSprite3D.x = 0; //cameraVector3D.x;
			rightOrWrongSprite3D.y = -200;
			rightOrWrongSprite3D.z = 0;
			//trace(rightOrWrongSprite3D);
			rightOrWrongSprite3D.width = 3;
			rightOrWrongSprite3D.height = 2.72;
			
			
			rootContainer.addChild(rightOrWrongSprite3D);
			
			scene.visible = false;
			
			Tweener.addTween(rightOrWrongSprite3D,
				{
					width:250,
					height:332,
					time:1,
					transition:"easeInBounce",
					onComplete:disapear,
					onCompleteParams:[rightOrWrongSprite3D]
				
			});
			
			
		}
		
		private function youAreWrong():void
		{
			var rightOrWrongSprite3D:Sprite3D = new Sprite3D(250, 349, new TextureMaterial(new Wrong().bitmapData));
			
			rightOrWrongSprite3D.x = 0; //cameraVector3D.x;
			rightOrWrongSprite3D.y = -200;
			rightOrWrongSprite3D.z = 0;
			//trace(rightOrWrongSprite3D);
			rightOrWrongSprite3D.width = 3;
			rightOrWrongSprite3D.height = 3.49;
			
			
			rootContainer.addChild(rightOrWrongSprite3D);
			
			scene.visible = false;
			
			Tweener.addTween(rightOrWrongSprite3D,
				{
					width:250,
					height:349,
					time:1,
					transition:"easeInBounce",
					onComplete:disapear,
					onCompleteParams:[rightOrWrongSprite3D]
					
				});
			//rightOrWrongSprite3D.x = mesh.x;
			//rightOrWrongSprite3D.y = - 200;
			//rightOrWrongSprite3D.z = mesh.z;
			//trace(rightOrWrongSprite3D);
			//rightOrWrongSprite3D.width = 3;
			//rightOrWrongSprite3D.height = 2.72;
		/*	var rightOrWrongSprite3D:Bitmap = new Bitmap(new Wrong().bitmapData)
			rightOrWrongSprite3D.x = 35;
			rightOrWrongSprite3D.y = 55;
			rightOrWrongSprite3D.alpha = 0;
			
			addChild(rightOrWrongSprite3D);
			
			Tweener.addTween(rightOrWrongSprite3D,
				{
					alpha:1,
					time:2,
					transition:"easeInBounce",
					onComplete:disapear1,
					onCompleteParams:[rightOrWrongSprite3D]
					
				});*/
		}
		
		private function disapear(do3d:Sprite3D):void
		{
			Tweener.addTween(do3d,
				{
					width:0,
					height:0,
					time:1,
					delay:2,//,
					//transition:"l",
					onComplete:removeDo3d,
					onCompleteParams:[do3d]
					
				});
			
		}
	/*	private function disapear1(do3d:Object3D):void
		{
			Tweener.addTween(do3d,
				{
					alpah:0,
					time:2,
					delay:2,//,
					//transition:"l",
					onComplete:removeDo3d,
					onCompleteParams:[do3d]
					
				});
		}*/
		
		private function removeDo3d(do3d:Sprite3D):void
		{scene.visible = true;
			rootContainer.removeChild(do3d);
			
		}
		
		private function onEnterFrame(e:Event):void {

			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
			
			//cameraVector3D = scene.localToGlobal(new Vector3D(camera.x, camera.y, camera.z));
//trace(cameraVector3D);
			skyBox.rotationZ += 0.005;
			
			//meshControler.update();
			camera.render();
		}
		
	}
}
