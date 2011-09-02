package
{
	/**
	 * AUTHOR:张川(zc1415926)
	 * BUGS:1.在pic被点击后，如果动画没有执行完毕就点击其它pic，动画会错乱
	 * TODO:在picx消失时加上一个集体（所有picx现时）alpha减成0(不能变动picxContainer),这个我一真也做不成
	 * TODO:不让每一个次级菜单儿的照片都是从0号pic头上出来
	*/
	//	import XiangCe.PicturePlane;
	
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.CurveModifiers;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	
	[SWF(width="640", height="480")]
	
	public class Pic3DWall21000411 extends Sprite
	{
		//[Embed(source="../assets/Hello.jpg")] static private const Hello:Class;
		
		//private var plane:Plane;
		
		//private var material:TextureMaterial;
		//private var bitmapData:BitmapData;
		private var scene:AlternativaTemplate;
		private var pics:Vector.<Plane>;
		
		private var picXml:XML;
		private var picLoader:Loader;
		
		private var skyTextures:Vector.<TextureMaterial>;
		private var skyBox:Box;
		
		private var textures:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
		//private var texturesPicx:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
		
		private var texturesPicx1:Vector.<Vector.<TextureMaterial>>;
		//private var texturesPicx1Loader:Vector.<MaterialLoader>;
		private var picxAll:Vector.<Vector.<Plane>>;
		private var picxContainer:Vector.<Object3DContainer>;//这个是一维数组
		
		private var pivotDO3D:Object3DContainer = new Object3DContainer();
		private var radius:Number = 200;
		//private var bigPlaneAngleY:Number;
		private var numOfOneLevelPics:uint;
		private var numOfOneLevelPicxs:uint;
		
		//private var picx:Vector.<Plane> = new Vector.<Plane>();
		private var pivotPicxDO3D:Object3DContainer = new Object3DContainer();
		private var picClicked:Boolean = false;//如果想要使当鼠标指到一个照片上circle停止旋转就要用到它
		//private var picxAppearing:Boolean = false;
		private var picxWhichAppearing:Vector.<Boolean>;
		//private var isPicxTweening:Boolean = false;
		
		public function Pic3DWall21000411()
		{
		//	stage.align = StageAlign.TOP_LEFT;
		//	stage.scaleMode = StageScaleMode.EXACT_FIT//NO_SCALE;
			//if (stage) 
				loadXml();//init();//要先加载完成才能进行场景的初始化
			//else addEventListener(Event.ADDED_TO_STAGE, init);
				
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);	
		}
		private function keydownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				trace(" camera.x: "+ scene.camera.x + " camera.y: " + scene.camera.y + " camera.z: " + scene.camera.z);
				trace(" camera.rotationX: " + scene.camera.rotationX + " camera.rotationY: " + scene.camera.rotationY + " camera.rotationZ: " + scene.camera.rotationZ);

			}
		}
		
		private function init(e:Event=null):void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//AlternativaTemplate作成
			scene = new AlternativaTemplate(this);
			//scene.addEventListener(MouseEvent.MOUSE_DOWN, onSceneClick3D);

			//bitmapData = new Hello().bitmapData;
			//material = new TextureMaterial(bitmapData);
			//loadXml();
			//var pivotDO3D:Object3DContainer = new Object3DContainer();
			
			
			
			
			numOfOneLevelPics = picXml.pic.length();
			pics = new Vector.<Plane>();
			//var radius:Number = 200;
			
			for(var i:uint = 0;i < numOfOneLevelPics; i++)
			{
				var rot:Number = 360 * i / numOfOneLevelPics;
				pics[i] = new Plane();
				pics[i].setMaterialToAllFaces(textures[i]);
				
				pics[i].name = textures[i].diffuseMapURL.toString();
				
				pics[i].x = radius * Math.cos(rot * Math.PI / 180);//刚刚这里x和y的表达式反了，费了很大的周折咬咬牙
				pics[i].y = radius * Math.sin(rot * Math.PI / 180);
				
				pics[i].rotationX = 90 * Math.PI / 180;//注意是弧度还是角度
				pics[i].rotationZ = (((i + 1) / numOfOneLevelPics) * 360 + (90 - 360 / numOfOneLevelPics)) * Math.PI / 180;
				
				pics[i].addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver3D);
				pics[i].addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown3D);
				pics[i].addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut3D);
				
				pivotDO3D.addChild(pics[i]);
				
				//trace(pics[i].name);
			}
			
			
		
			scene.container.addChild(skyBox);
			
			/*var plane1:Plane = new Plane(500,500);
			plane1.rotationX = 90 * Math.PI / 180;
			plane1.setMaterialToAllFaces(textures[3]);
			scene.container.addChild(plane1);*/
			//initPicx();
			//pivotDO3D.addChild(pivotPicxDO3D);
			//pivotDO3D.removeChild(pivotPicxDO3D);
			
			/*测试二维数组能不能用
			var aaa:Plane = new Plane();
			aaa.setMaterialToAllFaces(texturesPicx1[4][4]);
			scene.container.addChild(aaa);
			*/
			//scene.container.addChild(picxAll[5][5]);
			
			scene.container.addChild(pivotDO3D);

		//	scene.cameraController.setObjectPosXYZ(0,-500,100);
			//scene.cameraController.setObjectPosXYZ(0,-170,0);
			//scene.cameraController.lookAtXYZ(0, 0, 0);
			//scene.cameraController.disable();
			//scene.cameraController.stopMouseLook();
			//var pivotDO3DController:SimpleObjectController = new SimpleObjectController(stage,pivotDO3D,100);
			//pivotDO3DController.mouseSensitivity = 0;
			//loadXml();//不能放在这儿，使用这个方法里的数据的代码在它之前
			
			scene.onPreRender = function():void {
				pivotDO3D.rotationZ -= 0.5 * Math.PI / 180;
					
				/*if(picClicked == false)一指上去circle就停住不转了
				{
					pivotDO3D.rotationZ -= 0.5 * Math.PI / 180;
					//trace(scene.mouseX.toString() + " " + scene.mouseY.toString());
					//pivotDO3D.rotationZ
				}*/
				//scene.camera.view.width = stage.stageWidth;
				//scene.camera.view.height = stage.stageHeight;
				//scene.cameraController.
				//pivotDO3DController.update();
				//objectController.update();
			}
			scene.startRendering();
		}
		
		private function loadXml():void
		{
			var xmlRequest:URLRequest = new URLRequest("./xml/pictures.xml");
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadComplete);
			xmlLoader.load(xmlRequest);
		}
		
		private function onXmlLoadComplete(e:Event):void
		{
			picXml = new XML(e.target.data);
			trace(picXml);
			
			loadPictures();
			loadSkys();
		}
		
		private function loadSkys():void
		{
			var backMat:TextureMaterial = new TextureMaterial();
			backMat.diffuseMapURL = "pictures/sky/space_env_back.jpg";
			var bottomMat:TextureMaterial = new TextureMaterial();
			bottomMat.diffuseMapURL = "pictures/sky/space_env_bottom.jpg";
			var frontMat:TextureMaterial = new TextureMaterial();
			frontMat.diffuseMapURL = "pictures/sky/space_env_front.jpg";
			var leftMat:TextureMaterial = new TextureMaterial();
			leftMat.diffuseMapURL = "pictures/sky/space_env_left.jpg";
			var rightMat:TextureMaterial = new TextureMaterial();
			rightMat.diffuseMapURL = "pictures/sky/space_env_right.jpg";
			var topMat:TextureMaterial = new TextureMaterial();
			topMat.diffuseMapURL = "pictures/sky/space_env_top.jpg";
			
			skyTextures = new Vector.<TextureMaterial>();
			skyTextures.push(backMat);
			skyTextures.push(bottomMat);
			skyTextures.push(frontMat);
			skyTextures.push(leftMat);
			skyTextures.push(rightMat);
			skyTextures.push(topMat);
			
			var context:LoaderContext = new LoaderContext(true);
			var skyMaterialLoader:MaterialLoader = new MaterialLoader();
			skyMaterialLoader.load(skyTextures, context);
			
			skyBox = new Box(2000,2000,2000,1,1,1,true,false,leftMat,rightMat,backMat,frontMat,bottomMat,topMat);
			
			//box.setMaterialToAllFaces(backMat);
			//		box.setMaterialToAllFaces(new FillMaterial(0x000000));
		}
		
		private function loadPictures():void
		{
			trace("loadPictures");
			for(var i:uint = 0;i < picXml.pic.length();i++)
			{
				var textureMat:TextureMaterial = new TextureMaterial();
				textureMat.diffuseMapURL = picXml.pic[i].@url;//看准调用标签的属性怎么做
				//trace(picXml.pic[i].toString());
				trace(textureMat.diffuseMapURL.toString());
				textures.push(textureMat);
			}
			var context:LoaderContext = new LoaderContext(true);
			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.load(textures, context);
			
			trace(textures.toString());
			
			materialLoader.addEventListener(Event.COMPLETE, loadPicx1);
		}
		
		private function loadPicx1(e:Event=null):void
		{
			trace("loadPicx1");
			texturesPicx1 = new Vector.<Vector.<TextureMaterial>>(picXml.pic.length());
			var context:LoaderContext = new LoaderContext(true);
			
			for(var i:uint = 0;i < picXml.pic.length();i++)
			{
				texturesPicx1[i] = new Vector.<TextureMaterial>(picXml.pic[i].picx.length());
				//var materialLoader:MaterialLoader = new MaterialLoader();
				//texturesPicx1Loader.push(materialLoader);
				
				for(var j:uint = 0;j < picXml.pic[i].picx.length();j++)
				{
					//trace(picXml.pic[i].picx[j]);
					var textureMatPicx:TextureMaterial = new TextureMaterial();
					textureMatPicx.diffuseMapURL = picXml.pic[i].picx[j];//.toString();用这个可能要多费点儿事儿
					texturesPicx1[i][j] = textureMatPicx;
				}
				//texturesPicx1Loader[j].load(texturesPicx1[j], context);
				var materialLoader:MaterialLoader = new MaterialLoader();
				materialLoader.load(texturesPicx1[i], context);
				//可以给每个Loader做一个事件，一个Loader完成了，完成度加一，完成度满了再往下走
			}
			//trace(texturesPicx1.length + " " + texturesPicx1[texturesPicx1.length-1].length);
			
			initPicxAll();
			
		}
		
		/*private function loadPicx(e:Event=null):void//先调一个做实验
		{
			loadPicx1();
			trace("loadPicx");
			
			for(var i:uint = 0;i < picXml.pic[1].picx.length();i++)
			{
				//trace(i);
				var textureMatPicx:TextureMaterial = new TextureMaterial();
				textureMatPicx.diffuseMapURL = picXml.pic[1].picx[i].toString();
				//trace(picXml.pic[0].picx[i]);
				texturesPicx.push(textureMatPicx);
			}
			trace("overLoop");
			var context:LoaderContext = new LoaderContext(true);
			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.load(texturesPicx, context);
			
			materialLoader.addEventListener(Event.COMPLETE, init);
		}*/
		
		/*private function initPicx(e:Event=null):void
		{
			
			//var radius
			for(var i:uint = 0;i < picXml.pic[0].picx.length();i++)
			{
				var rot:Number = 360 * i / picXml.pic[0].picx.length();
				picx[i] = new Plane();
				picx[i].setMaterialToAllFaces(texturesPicx[i]);
				//trace(texturesPicx[i].diffuseMapURL);
				picx[i].x = radius * Math.cos(rot * Math.PI / 180);
				picx[i].y = radius * Math.sin(rot * Math.PI / 180);
				picx[i].z += 150 * (-1 * Math.cos(i * Math.PI));
				trace(-1 * Math.cos(i * Math.PI));
				
				picx[i].rotationX = 90 * Math.PI / 180;//注意是弧度还是角度
				picx[i].rotationZ = (((i + 1) / numOfOneLevelPics) * 360 + (90 - 360 / numOfOneLevelPics)) * Math.PI / 180;
				
				picx[i].alpha = 0;
				
				pivotPicxDO3D.addChild(picx[i]);
				
			}
			pivotDO3D.addChild(pivotPicxDO3D);
			//init();
			
		}*/
		
		private function initPicxAll():void
		{
			trace("initPicxAll");
			
			picxAll = new Vector.<Vector.<Plane>>(picXml.pic.length());//初始化好几个了，就不用push了直接让对应的号的数组元素等于新生成 的就行了
			picxContainer = new Vector.<Object3DContainer>(picXml.pic.length());
			picxWhichAppearing = new Vector.<Boolean>(picXml.pic.length());
			
			pivotDO3D.addChild(pivotPicxDO3D);
			
			for(var i:uint = 0;i < picXml.pic.length();i++)
			{
				picxAll[i] = new Vector.<Plane>(picXml.pic[i].picx.length());
				picxContainer[i] = new Object3DContainer();
				
				for(var j:uint = 0;j < picXml.pic[i].picx.length();j++)
				{
					picxAll[i][j] = new Plane();
					picxAll[i][j].setMaterialToAllFaces(texturesPicx1[i][j]);
					//trace("picxAll: " + "i: " + i + " j: " + j);
					var rot:Number = 360 * j / picXml.pic[i].picx.length();
					numOfOneLevelPicxs = picXml.pic[i].picx.length();
					picxAll[i][j].x = radius * Math.cos(rot * Math.PI / 180);
					picxAll[i][j].y = radius * Math.sin(rot * Math.PI / 180);
					picxAll[i][j].z = 150 * (-1 * Math.cos(i * Math.PI));//150;// * (i + 1);
					
					picxAll[i][j].rotationX = 90 * Math.PI / 180;
					picxAll[i][j].rotationZ = (((j + 1) / numOfOneLevelPicxs) * 360 + (90 - 360 / numOfOneLevelPicxs)) * Math.PI / 180;
					
					picxAll[i][j].alpha = 0;
					/*pivotPicxDO3D.addChild(picxAll[i][j]);
					把这个选项打开要很酷的！*/
					
					picxContainer[i].addChild(picxAll[i][j]);
					picxWhichAppearing[i] = false;
				}
			}
			
			init();
		}
		
		private function onMouseOver3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			picClicked = true;
			//plane.filters =  [new GlowFilter(0x0000FF, 1, 20, 20, 4)];
			/*if(!Tweener.isTweening(plane))
			{
				Tweener.addTween(plane,{
					scaleX:plane.scaleX + 0.2,
					scaleY:plane.scaleY + 0.2,
					//scaleZ:plane.scaleZ + 0.2,
					time:0.2,
					transition:"easeOutElastic"
				});
			}*/
			plane.scaleX += 0.2;
			plane.scaleY += 0.2;
		}
		
		private function onMouseDown3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			//plane.scaleX = 2;
			//plane.scaleY = 2;	
			
			trace(Plane(e.target).name);
			/*if("pictures/Chrysanthemum.jpg" == Plane(e.target).name)
			{
				if(false == picxAppearing)
				{
					//initPicx();
					//pivotDO3D.addChild(pivotPicxDO3D);
					picxAppear();
					picxAppearing = true;
				}
				else
				{
					//pivotDO3D.removeChild(pivotPicxDO3D);
					for(var i:uint = 0;i < picXml.pic[0].picx.length();i++)
					{
						picx[i].alpha = 0;
					}
					picxAppearing = false;
				}
			}*/
			for(var i:uint = 0;i < picxWhichAppearing.length;i++)
			{
				if(true == picxWhichAppearing[i])
				{
					
				//	pivotPicxDO3D.removeChild(picxContainer[i]);//remove不能，这是为什么?
					//picxContainer[i].alpha = 0;
					picxDisappear(i);
					picxWhichAppearing[i] = false;
					
					//trace(picxContainer[i].getChildAt(1));//加上这一行就可以remove之后又add了，但是把它去掉也行了，我也不知道这是为什么
					//trace(i + " " + picxWhichAppearing);
					
					if(picXml.pic[i].@url == Plane(e.target).name)
					{
						return;
					}
				}
			}
			
			for(var i:uint = 0;i < picXml.pic.length();i++)
			{
				if(picXml.pic[i].@url == Plane(e.target).name)
				{
					//trace(i);
					if(false == picxWhichAppearing[i])
					{
						
						pivotPicxDO3D.addChild(picxContainer[i]);
						picxAppear(i);
						picxWhichAppearing[i] = true;
						//trace(i + " " + picxWhichAppearing);
					}
					/*else
					{
						pivotPicxDO3D.removeChild(picxContainer[i]);//remove不能，这是为什么?
						//picxContainer[i].alpha = 0;
						picxDisappear(i);
						picxWhichAppearing[i] = false;
						//trace(picxContainer[i].getChildAt(1));//加上这一行就可以remove之后又add了，但是把它去掉也行了，我也不知道这是为什么
						trace(i + " " + picxWhichAppearing);
					}*/
				}
			}
		}
		
		private function picxAppear(whichPic:uint,whichPicx:uint = 0):void//要传是几号组（从0开始）的图片作为参数
		{
			picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver3D);
			picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut3D);
			
			//trace(picxAll[whichPic][0].z);
			
			
			if(whichPicx < picXml.pic[whichPic].picx.length())
			{
			//	picxContainer[whichPic].addChild(picxAll[whichPic][whichPicx]);
				//trace("whichPic" + " " + whichPic + "whichPicx" + " " + whichPicx);
				//trace(picXml.pic[whichPic].picx);
				Tweener.addTween(picxAll[whichPic][whichPicx],{
					alpha:picxAll[whichPic][whichPicx].alpha + 1,
					time:0.5,
					transition:"easeInQuint",
					onComplete:picxAppear,
					onCompleteParams:[whichPic, ++whichPicx]
				});
			}
			
			if(/*picxAll[whichPic][0].z > 0*/0 != whichPic % 2 && 1 == whichPicx)
			{
				//这里是上边的
				if(-500 == scene.camera.y /*&& 0 < scene.camera.z*/)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ + 180 * Math.PI / 180,
						x:0,
						y:500,
						z:100,
						_bezier:[
							{x:100,y:200,z:100},
							{x:300,y:0,z:200},
							{x:300,y:0,z:0},
						],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,500,100,(scene.camera.rotationX),(scene.camera.rotationY),(scene.camera.rotationZ + 180 * Math.PI / 180)]
						/*onComplete:scene.cameraController.setObjectPosXYZ,
						onCompleteParams:[0, 500, 100],
						onComplete:scene.cameraController.lookAtXYZ,
						onCompleteParams:[0, 0, 0]*/
					});
				}
				if(500 == scene.camera.y)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ - 180 * Math.PI / 180,
						x:0,
						y:-500,
						z:100,
						_bezier:[
							
							{x:500,y:300,z:100},
						],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,-500,100,(scene.camera.rotationX),(scene.camera.rotationY),(scene.camera.rotationZ - 180 * Math.PI / 180)]
					});
				}
				
			}
			
			if(/*1 == whichPicx && picxAll[whichPic][1].z < 0*/0 == whichPic % 2 && 1 == whichPicx)//为什么是1不是0我也不清楚用Controller就可能用0但是直接设传票是0就不能用
			{
				//trace("Down!");
				//scene.cameraController.setObjectPosXYZ(0, -500, -100);
				/**
				 * 下边这个效果也可心做成如果camera已经在下边了，那不就不动了，或是别的什么效果
				 * 可以 用很多东西作为判断条件比如一个Boolean或camera的坐标或它lookat什么位置
				 */
				if(/*-500 == scene.camera.y || */0 < scene.camera.z)
				{
					var bezierY:Number;
					if(scene.camera.y < 0)
					{
						bezierY = -900;
					}
					else
					{
						bezierY = 900;
					}
					
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						x:0,
						y:scene.camera.y,//-500,
						z:-100,
						_bezier:{x:0, y:bezierY, z:300},
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,scene.camera.y,-100,scene.camera.rotationX,scene.camera.rotationY,scene.camera.rotationZ]

						//onComplete:scene.cameraController.setObjectPosXYZ,
						//onCompleteParams:[0, -500, -100]
					});
					
					trace("step1: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
				}
				if(/*0 == scene.camera.x && */-500 == scene.camera.y && -100 == scene.camera.z)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ + 180 * Math.PI / 180,
						x:0,
						y:500,
						z:-100,
						_bezier:[
							{x:600, y:-700, z:50}, 
							{x:800,y:-300,z:200},
							{x:400,y:100,z:300},
							{x:200,y:450,z:100},
							{x:0,y:700,z:0}],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,500,-100,scene.camera.rotationX,scene.camera.rotationY,scene.camera.rotationZ + 180 * Math.PI / 180]

						//onComplete:scene.cameraController.setObjectPosXYZ,
						//onCompleteParams:[0, 500, -100]
					});
					
					trace("step2: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
					
				}
				if(500 == scene.camera.y && -100 == scene.camera.z)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ + 180 * Math.PI / 180,
						x:0,
						y:-500,
						z:-100,
						_bezier:[
							{x:-300,y:400,z:100},
							{x:-700,y:200,z:200},
							{x:-1000,y:200,z:0},
							{x:-600,y:-500,z:-50},
							{x:-200,y:-700,z:-70},
						],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,-500,-100,scene.camera.rotationX,scene.camera.rotationY,scene.camera.rotationZ + 180 * Math.PI / 180]
						
						//onComplete:scene.cameraController.setObjectPosXYZ,
						//onCompleteParams:[0, 500, -100]
					});
					
					trace("step3: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
				}
				
			}
		
			
			//var j:uint = 0;
			/*var i:uint = 8;
			if(i < 8)
			{
				Tweener.addTween(picx[i],{
					alpha:picx[i].alpha + 1,
					time:0.5,
					//delay:1,
					transition:"easeInQuint",
					onComplete:picxAppear,
					onCompleteParams:[++i]
				});
			}*/
			/*for(var i:uint = 0;i < picXml.pic[0].picx.length();i++)
			{
				if(!isTweening)
				{
					Tweener.addTween(picx[i],{alpha:picx[i].alpha + 1,time:4,delay:1});
					isTweening = true;
				}
			}*/
		}
		
		private function picxDisappear(whichPic:uint,whichPicx:uint = 0):void
		{
			for(whichPicx;whichPicx < picXml.pic[whichPic].picx.length();whichPicx++)
			{
				picxAll[whichPic][whichPicx].removeEventListener(MouseEvent3D.MOUSE_OVER,onMouseOver3D);
				picxAll[whichPic][whichPicx].removeEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut3D);
				
				picxAll[whichPic][whichPicx].alpha = 0;
			}
			pivotPicxDO3D.removeChild(picxContainer[whichPic]);
			/**这个方法太卡，暂时不用
			var i = whichPic;//解决本方法传入的whichPic不能传onCompleteParams的问题
			if(whichPicx < picXml.pic[whichPic].picx.length())
			{
				Tweener.addTween(picxAll[whichPic][whichPicx],{
					alpha:picxAll[whichPic][whichPicx].alpha - 1,
					time:0.1,
					onComplete:picxDisappear,
					onCompleteParams:[i,++whichPicx]
				});
			}
			else
			{
				pivotPicxDO3D.removeChild(picxContainer[i]);
			}*/
			
		}
		
		private function onMouseOut3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			//plane.filters = null;
			plane.scaleX = 1;
			plane.scaleY = 1;
			//plane.scaleZ = 1;
			
			picClicked = false;
		}
		
		private function setCamera(camX:Number, camY:Number, camZ:Number, rotX:Number, rotY:Number, rotZ:Number):void
		{
			trace("setCamera");
			scene.camera.x = camX;
			scene.camera.y = camY;
			scene.camera.z = camZ;
			scene.camera.rotationX = rotX;
			scene.camera.rotationY = rotY;
			scene.camera.rotationZ = rotZ;
		}
		private function iCanSeeBezierPoint():void
		{
			var bezierPointMaterial:FillMaterial = new FillMaterial(0x000000);
			
		}
		/*private function onSceneClick3D(e:MouseEvent3D):void
		{
			//if(true == picxAppearing)
			//{
				pivotDO3D.removeChild(pivotPicxDO3D);
				
			//}
		}*/
	}
}

/**
 * BasicTemplate for Alternativa3D 7.5
 * Alternativa3D 7.5を扱いやすくするためのテンプレートです
 * @author narutohyper & clockmaker
 *
 */
 
import alternativa.engine3d.containers.BSPContainer;
import alternativa.engine3d.containers.ConflictContainer;
import alternativa.engine3d.containers.DistanceSortContainer;
import alternativa.engine3d.containers.KDContainer;
import alternativa.engine3d.containers.LODContainer;
import alternativa.engine3d.controllers.SimpleObjectController;
import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Object3DContainer;
import alternativa.engine3d.core.View;
import flash.display.DisplayObject;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;

import flash.events.Event;

class AlternativaTemplate extends Sprite
{
	/**
	 * 子オブジェクトを最適な方法でソートするコンテナ
	 * 最好的方法来排序容器中的子对象
	 * (ConflictContainer)
	 */
	public static const CONFLICT:String = 'conflict';
	/**
	 * 子オブジェクトをBSP(バイナリ空間分割法)によってソートするコンテナ
	 * 子对象的BSP（二进制空间分割技术）由容器进行排序
	 * (BSPContainer)
	 */
	public static const BSP:String = 'bsp';
	
	/**
	 * 子オブジェクトをカメラからのZ値でソートするコンテナ
	 * 从相机容器的子对象的Z排序
	 * (DistanceSortContainer)
	 */
	public static const ZSORT:String = 'zsort';
	/**
	 * KDツリー(http://ja.wikipedia.org/wiki/Kd%E6%9C%A8)によってソートするコンテナ
	 * KD树
	 * (KDContainer)
	 */
	public static const KD:String = 'kd';
	/**
	 * detalizationと子オブジェクトの距離でソートするコンテナ（詳細は調査中）
	 * (LODContainer)
	 */
	public static const LOD:String = 'lod';
	
	/**
	 * 3dオブジェクト格納するコンテナインスタンス。
	 * 一个三维对象的实例的容器。
	 */
	public var container:Object3DContainer;
	
	/**
	 * ビューインスタンスです。
	 * 视图实例
	 */
	public var view:View;
	
	/**
	 * カメラインスタンスです。
	 */
	public var camera:Camera3D;
	
	/**
	 * カメラコントローラーです。
	 * 相机控制器
	 */
	//public var cameraController:SimpleObjectController;
	
	private var _mc:DisplayObjectContainer;
	private var _viewWidth:int;
	private var _viewHeight:int;
	private var _scaleToStage:Boolean;
	private var _containerType:String;
	
	/**
	 * 新しい Alternativa3DTemplate インスタンスを作成します。
	 * @param    mc
	 * @param    containerType
	 * @param    viewWidth
	 * @param    viewHeight
	 * @param    scaleToStage
	 */
	public function AlternativaTemplate(mc:DisplayObjectContainer,containerType:String=CONFLICT,viewWidth:int=640, viewHeight:int=480, scaleToStage:Boolean = true)
	{
		
		_mc = mc;
		_mc.addChild(this);
		
		_containerType = containerType;
		_viewWidth = viewWidth;
		_viewHeight = viewHeight;
		_scaleToStage = scaleToStage;
		
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	
	/**
	 * 初期化されたときに実行されるイベントです。
	 * 初期化時に実行したい処理をオーバーライドして記述します。
	 */
	protected function atInit():void {}
	
	
	/**
	 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
	 * レンダリング前に実行したい処理をオーバーライドして記述します。
	 */
	protected function atPreRender():void {}
	
	/**
	 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
	 * レンダリング前に実行したい処理をオーバーライドして記述します。
	 */
	private var _onPreRender:Function = function():void{};
	public function get onPreRender():Function { return _onPreRender; }
	public function set onPreRender(value:Function):void
	{
		_onPreRender = value;
	}
	
	/**
	 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
	 * レンダリング後に実行したい処理をオーバーライドして記述します。
	 */
	protected function atPostRender():void {}
	
	/**
	 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
	 * レンダリング後に実行したい処理を記述します。
	 */
	private var _onPostRender:Function = function():void{};
	public function get onPostRender():Function { return _onPostRender; }
	public function set onPostRender(value:Function):void
	{
		_onPostRender = value;
	}
	
	
	/**
	 * レンダリングを開始します。
	 */
	public function startRendering():void
	{
		addEventListener(Event.ENTER_FRAME, onRenderTick);
	}
	
	/**
	 * レンダリングを停止します。
	 */
	public function stopRendering():void
	{
		removeEventListener(Event.ENTER_FRAME, onRenderTick);
	}
	
	/**
	 * シングルレンダリング(レンダリングを一回だけ)を実行します。
	 */
	public function singleRender():void
	{
		onRenderTick();
	}
	
	/**
	 * @private
	 */
	private function init(e:Event = null):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.quality = StageQuality.HIGH;
		
		//Root objectの作成
		if (_containerType == CONFLICT) {
			container = new ConflictContainer();
		} else if (_containerType == BSP) {
			container = new BSPContainer();
		} else if (_containerType == ZSORT) {
			container = new DistanceSortContainer();
		} else if (_containerType == KD) {
			container = new KDContainer();
		} else if (_containerType == LOD) {
			container = new LODContainer();
		}
		//Viewの作成
		view = new View(stage.stageWidth, stage.stageHeight);
		_mc.addChild(view);
		
		//cameraの作成
		camera = new Camera3D();
		camera.view = view;
		camera.x = 0;
		camera.y = -500;
		camera.z = 100;
		
		container.addChild(camera);
		/**
		 * 你这该死的cameraController!
		*/
		// Camera controller
		//cameraController = new SimpleObjectController(stage, camera, 10);
		//cameraController.mouseSensitivity = 0;
		//cameraController.unbindAll();
		//cameraController.lookAtXYZ(0, 0, 0);
		camera.lookAt(0,0,0);
		
		onResize();
		stage.addEventListener(Event.RESIZE, onResize);
		
		atInit();
	}
	
	/**
	 * @private
	 */    
	private function onResize(e:Event = null):void 
	{
		if (_scaleToStage)
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		} 
		else
		{
			view.width = _viewWidth;
			view.height = _viewHeight;
		}
	}
	
	/**
	 * @private
	 */    
	private function onRenderTick(e:Event = null):void 
	{
		atPreRender();
		_onPreRender();
//		cameraController.update();
		camera.render();
		atPostRender();
		_onPostRender();
	}	
}