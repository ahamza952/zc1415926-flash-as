package
{
	/**
	 * @aouthor:张川(zc1415926)
	 * BUGS:1.在pic被点击后，如果动画没有执行完毕就点击其它pic，动画会错乱
	 * TODO:在picx消失时加上一个集体（所有picx现时）alpha减成0(不能变动picxContainer),这个我一真也做不成
	 * TODO:不让每一个次级菜单儿的照片都是从0号pic头上出来
	 * TODO:通过坐标判断是用哪个动画这一部分的判断条件还要再考虑一下
	 * TODO:解决指向Pic时，本身变大倒影不变大
	 * TODO:goHome换成党旗，来个视频
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
	
	import embedmanager.EmbedManager;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import parsers.EmbedXmlParser;
	
	import ssnangua.Polygon;
	
//	import zc.PlaneOnStage;
	
	[SWF(width="640", height="480")]
	
	public class Pic3DWall2 extends Sprite
	{
		private var scene:AlternativaTemplate;
		private var pics:Vector.<Plane>;
		
		private var picXml:XML;
		private var picLoader:Loader;
		
		private var skyTextures:Vector.<TextureMaterial>;
		private var skyBox:Box;
		
		private var textures:Vector.<TextureMaterial> = new Vector.<TextureMaterial>();
		
		private var texturesPicx1:Vector.<Vector.<TextureMaterial>>;
		private var picxAll:Vector.<Vector.<Plane>>;
		private var picxContainer:Vector.<Object3DContainer>;//这个是一维数组
		
		private var pivotDO3D:Object3DContainer = new Object3DContainer();
		private var pivotPicsDO3D:Object3DContainer = new Object3DContainer();
		//private var pivotPicxDO3D:Object3DContainer = new Object3DContainer();
		
		private var rot:Number;
		private var radius:Number = 200;
		private var numOfOneLevelPics:uint;
		private var numOfOneLevelPicxs:uint;
		
		//private var pivotPicxDO3D:Object3DContainer = new Object3DContainer();
		private var pivotPicxDO3D:Object3DContainer = new Object3DContainer();
		private var picxCircle:Object3DContainer = new Object3DContainer();
	
		private var picClicked:Boolean = false;//如果想要使当鼠标指到一个照片上circle停止旋转就要用到它
		private var picxWhichAppearing:Vector.<Boolean>;
		
		private var backsound:Sound = new Sound(new URLRequest("musics/backsound.mp3"));
		
		private var bigImage:Loader;
		
		//private var picxPositionX:Vector.<int>;
		//private var picxPositionY:Vector.<int>;
		
		private var positionPlanes:Vector.<Plane>;
		private var isShowPicxed:Boolean = false;
		private var picxWhichPic:uint;
		private var picxWhichPicx:uint;
		
		private var goHomeMaterial:FillMaterial = new FillMaterial(0xFF0000);
		private var goHome:Polygon = new Polygon(10, 60, 24, true, false, goHomeMaterial, goHomeMaterial);
		private var goHomePlane:Plane = new Plane(500, 500);
		private var goHomePlane1:Plane;
		
		private var picxDelayTime:Number;
		private var prePicxNum:uint = 0;
		private var aftPicxNum:uint = 0;
		private var preOrAft:Boolean = true;//true=pre,false=aft
		
		private var prePlane:Plane = new Plane();
		private var isFirstInPicx:Boolean = true;
		
		public function Pic3DWall2()
		{
			stage.displayState = "fullScreen";
			
			
			//if (stage) 
				loadXml();//init();//要先加载完成才能进行场景的初始化
			//else addEventListener(Event.ADDED_TO_STAGE, init);
				backsound.play(0, 10, new SoundTransform(0.1, 0));
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);	
			
			bigImage = new Loader();
			
		}
		private function keydownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				trace(" camera.x: "+ scene.camera.x + " camera.y: " + scene.camera.y + " camera.z: " + scene.camera.z);
				trace(" camera.rotationX: " + scene.camera.rotationX + " camera.rotationY: " + scene.camera.rotationY + " camera.rotationZ: " + scene.camera.rotationZ);
			}
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function init(e:Event=null):void
		{
			
			//backsound.load(backsoundUrl);
			//AlternativaTemplate作成
			scene = new AlternativaTemplate(this);

			numOfOneLevelPics = picXml.pic.length();
			pics = new Vector.<Plane>();
			
			for(var i:uint = 0;i < numOfOneLevelPics; i++)
			{
				rot = 360 * i / numOfOneLevelPics;
				pics[i] = new Plane();
				pics[i].setMaterialToAllFaces(textures[i]);
				
				pics[i].name = i.toString();//textures[i].diffuseMapURL.toString();
				
				pics[i].x = radius * Math.cos(rot * Math.PI / 180);//刚刚这里x和y的表达式反了，费了很大的周折咬咬牙
				pics[i].y = radius * Math.sin(rot * Math.PI / 180);
				
				pics[i].rotationX = 90 * Math.PI / 180;//注意是弧度还是角度
				pics[i].rotationZ = (((i + 1) / numOfOneLevelPics) * 360 + (90 - 360 / numOfOneLevelPics)) * Math.PI / 180;
				
				//pics[i].alpha = 0.5;
				
				pics[i].addEventListener(MouseEvent3D.ROLL_OVER, onMouseOver3D);
				pics[i].addEventListener(MouseEvent3D.CLICK, onMouseDown3D);
				pics[i].addEventListener(MouseEvent3D.ROLL_OUT, onMouseOut3D);
				
				pivotPicsDO3D.addChild(pics[i]);
				pivotDO3D.addChild(pivotPicsDO3D);
				
				var shadow:Plane = new Plane();
				//shadow.setMaterialToAllFaces(new TextureMaterial(reflect(textures[i].texture)));
				shadow.setMaterialToAllFaces(textures[i]);
				shadow.alpha = 0.4;
				shadow.scaleY = -1;
				shadow.filters = [new BlurFilter()];
				shadow.rotationX = 90 * Math.PI / 180;
				shadow.rotationZ = (((i + 1) / numOfOneLevelPics) * 360 + (90 - 360 / numOfOneLevelPics)) * Math.PI / 180;
				shadow.x = radius * Math.cos(rot * Math.PI / 180);//刚刚这里x和y的表达式反了，费了很大的周折咬咬牙
				shadow.y = radius * Math.sin(rot * Math.PI / 180);
				shadow.z = -100;
				
				pivotPicsDO3D.addChild(shadow);
				
				
			}
		
			scene.container.addChild(skyBox);
			
			scene.container.addChild(pivotDO3D);
			
			//scene.container.addChild(pivotPicxDO3D);
			
			scene.onPreRender = function():void {
				pivotPicsDO3D.rotationZ -= 0.5 * Math.PI / 180;
				/*if(picClicked == false)一指上去circle就停住不转了
				{
					pivotDO3D.rotationZ -= 0.5 * Math.PI / 180;
					//trace(scene.mouseX.toString() + " " + scene.mouseY.toString());
					//pivotDO3D.rotationZ
				}*/
				//pivotDO3DController.update();
				//objectController.update();
				scene.camera.view.width = stage.stageWidth;
				scene.camera.view.height = stage.stageHeight;
			}
			scene.startRendering();
			
			goHome.addEventListener(MouseEvent3D.ROLL_OVER, onGoHomeOver3D);
			goHome.addEventListener(MouseEvent3D.ROLL_OUT, onGoHomeOut3D);
			goHome.addEventListener(MouseEvent3D.CLICK, onGoHomeDown3D);
			//scene.container.addChild(picxAll[1][2]);//!!!!!!!!!!!!!!!!
		}

		private function loadXml():void
		{
			picXml = parsers.EmbedXmlParser.parseEmbedXml(EmbedManager.PicXml);
			
			loadPictures();
			loadSkys();
		}
		
		private function loadSkys():void
		{
			var backMat:TextureMaterial = new TextureMaterial();
			//backMat.diffuseMapURL = "pictures/sky/snow_positive_z.jpg";
			backMat.diffuseMapURL = "pictures/sky/space_env_back.jpg";
			
			var bottomMat:TextureMaterial = new TextureMaterial();
			//bottomMat.diffuseMapURL = "pictures/sky/snow_negative_y.jpg";
			bottomMat.diffuseMapURL = "pictures/sky/space_env_bottom.jpg";
			
			var frontMat:TextureMaterial = new TextureMaterial();
			//frontMat.diffuseMapURL = "pictures/sky/snow_negative_z.jpg";
			frontMat.diffuseMapURL = "pictures/sky/space_env_front.jpg";
			
			var leftMat:TextureMaterial = new TextureMaterial();
			//leftMat.diffuseMapURL = "pictures/sky/snow_negative_x.jpg";
			leftMat.diffuseMapURL = "pictures/sky/space_env_left.jpg";
			
			var rightMat:TextureMaterial = new TextureMaterial();
			//rightMat.diffuseMapURL = "pictures/sky/snow_positive_x.jpg";
			rightMat.diffuseMapURL = "pictures/sky/space_env_right.jpg";
			
			var topMat:TextureMaterial = new TextureMaterial();
			//topMat.diffuseMapURL = "pictures/sky/snow_positive_y.jpg";
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
		}
		
		private function loadPictures():void
		{
			trace("loadPictures");
			for(var i:uint = 0;i < picXml.pic.length();i++)
			{
				var textureMat:TextureMaterial = new TextureMaterial();
				textureMat.diffuseMapURL = picXml.pic[i].@url;//看准调用标签的属性怎么做
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
				
				for(var j:uint = 0;j < picXml.pic[i].picx.length();j++)
				{
					var textureMatPicx:TextureMaterial = new TextureMaterial();
					textureMatPicx.diffuseMapURL = picXml.pic[i].picx[j];//.toString();用这个可能要多费点儿事儿
					texturesPicx1[i][j] = textureMatPicx;
				}
				var materialLoader:MaterialLoader = new MaterialLoader();
				materialLoader.load(texturesPicx1[i], context);
				//可以给每个Loader做一个事件，一个Loader完成了，完成度加一，完成度满了再往下走
			}
			
			initPicxAll();
		}
		
		private function initPicxAll():void
		{
			//var picxPosition:Vector.<Vector3D> = new Vector.<Vector3D>[new Vector3D(-200, 200, 0), new Vector3D(0, 200, 0), new Vector3D(200, 200, 0),
												//new Vector3D(-200, 0, 0), new Vector3D(0, 0, 0), new Vector3D(200, 0, 0),
												//new Vector3D(-200, -200, 0), new Vector3D(0, -200, 0), new Vector3D(200, -200, 0)];
			//picxPositionX = new Vector.<int>[-200,0,1200,-200,0,1200,-200,0,1200];
		//	picxPositionY = new Vector.<int>[200,200,200,0,0,0,-200,-200,-200];
			pivotDO3D.addChild(pivotPicxDO3D);
			
			positionPlanes = new Vector.<Plane>();
			for(var i:uint = 0; i < 8; i++)
			{
				positionPlanes.push(new Plane);
			}
			positionPlanes[0].x = positionPlanes[3].x = positionPlanes[6].x = -130;
			positionPlanes[1].x = positionPlanes[4].x = positionPlanes[7].x = 0;
			positionPlanes[2].x = positionPlanes[5].x = /*positionPlanes[8].x =*/ 130;
			
			positionPlanes[0].y = positionPlanes[1].y = positionPlanes[2].y = 130;
			positionPlanes[3].y = positionPlanes[4].y = positionPlanes[5].y = 0;
			positionPlanes[6].y = positionPlanes[7].y = -130;
			
			for(var i:uint = 0; i < 8; i++)
			{
				positionPlanes[i].z = -1000;
			}
			
			goHomePlane.setMaterialToAllFaces(new FillMaterial(0xFFFFFF));
			goHomePlane.z = 900;
			goHomePlane.alpha = 0;
			
			/*picxAll[whichPic][0].x = picxAll[whichPic][3].x = picxAll[whichPic][6].x = -200;
			picxAll[whichPic][1].x = picxAll[whichPic][4].x = picxAll[whichPic][7].x = 0;
			picxAll[whichPic][2].x = picxAll[whichPic][5].x = 200;
			
			picxAll[whichPic][0].y = picxAll[whichPic][1].y = picxAll[whichPic][2].y = 200;
			picxAll[whichPic][3].y = picxAll[whichPic][4].y = picxAll[whichPic][5].y = 0;
			picxAll[whichPic][6].y = picxAll[whichPic][7].y =  -200;//picxAll[whichPic][5].y =*/
			
			
			trace("initPicxAll");
			 
			picxAll = new Vector.<Vector.<Plane>>(picXml.pic.length());//初始化好几个了，就不用push了直接让对应的号的数组元素等于新生成 的就行了
			picxContainer = new Vector.<Object3DContainer>(picXml.pic.length());
			picxWhichAppearing = new Vector.<Boolean>(picXml.pic.length());
			
			//pivotDO3D.addChild(pivotPicxDO3D);
			//scene.container.addChild(picxCircle);
			
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
					
				//	picxAll[i][j].x = radius * Math.cos(rot * Math.PI / 180);
				//	picxAll[i][j].y = radius * Math.sin(rot * Math.PI / 180);
				//	picxAll[i][j].z = 150 * (-1 * Math.cos(i * Math.PI));//150;// * (i + 1);
					
					picxAll[i][j].name = i + "&" + j;
					//trace(picxAll[i][j].name);
					
					//picxAll[i][j].rotationX = 90 * Math.PI / 180;
				//	picxAll[i][j].rotationZ = (((j + 1) / numOfOneLevelPicxs) * 360 + (90 - 360 / numOfOneLevelPicxs)) * Math.PI / 180;
					
					//picxAll[i][j].alpha = 0;
					/*pivotPicxDO3D.addChild(picxAll[i][j]);
					把这个选项打开要很酷的！*/

					//picxContainer[i].addChild(picxAll[i][j]);
					//pivotPicxDO3D.addChild(picxContainer[i]);
					
					
					
					picxWhichAppearing[i] = false;
				}
				
			}
			
			init();
		}
		
		private function onMouseOver3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			picClicked = true;
			plane.scaleX += 0.2;
			plane.scaleY += 0.2;
			//plane.alpha = 1;
		}
		
		private function onMouseOut3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			
			plane.scaleX = 1;
			plane.scaleY = 1;
			//plane.alpha = 0.5;
			//plane.scaleZ = 1;
			
			picClicked = false;
		}
		
		private function onMouseDown3D(e:MouseEvent3D):void
		{
			var plane:Plane = e.target as Plane;
			//var whichPic:uint;
			
			trace(Plane(e.target).name);

			
			
			CurveModifiers.init();  
			
			if(0 == uint(plane.name) % 2)
			{
				Tweener.addTween(scene.camera,{
					rotationX:scene.camera.rotationX - 80 * Math.PI / 180,
					x:0,
					y:0,
					z:1000,
					_bezier:{x:0, y:-800, z:500},
					time:3,
					transition:"easeInOutCubic",
					onComplete:showPicxs,
					onCompleteParams:[plane.name]
				});
				
				Tweener.addTween(pivotPicsDO3D,{
					rotationY:pivotPicsDO3D.rotationY + 360 * Math.PI / 180,
					rotationZ:pivotPicsDO3D.rotationZ + 360 * Math.PI / 180,
					time:3,
					transition:"easeInOutCubic"
				});
			}
			else
			{
				Tweener.addTween(scene.camera,{
					//rotationX:scene.camera.rotationX + 100 * Math.PI / 180,
					x:0,
					y:-700,
					z:-600,
					_bezier:{x:0, y:-1000, z:500},
					time:3,
					transition:"easeInOutCubic"//,
					//onComplete:showPicxs,
					//onCompleteParams:[plane.name]
				});
				showPicxs(uint(plane.name));
			}
		}
		
		private function showPicxs(whichPic:uint, whichPicx:uint = 0):void
		{
			trace("showPicxs!!!!!!!!!!!!!!!!!!");
			
			if(0 == uint(whichPic) % 2)
			{
				if(!isShowPicxed)
				{
					for(whichPicx; whichPicx < 8; whichPicx++)
					{
						
						picxAll[whichPic][whichPicx].x = positionPlanes[whichPicx].x;
						picxAll[whichPic][whichPicx].y = positionPlanes[whichPicx].y;
						picxAll[whichPic][whichPicx].z = positionPlanes[whichPicx].z;
						
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OVER, onPicxMouseOver3D);
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OUT, onPicxMouseOut3D);
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.CLICK, onPicxMouseDown3D);
						
						pivotPicxDO3D.addChild(picxAll[whichPic][whichPicx]);
					}
					isShowPicxed = true;
					whichPicx = 0;
				}
				if(whichPicx < 8)
				{
					picxWhichPic = whichPic;
					picxWhichPicx = whichPicx;
					
					var picxTimer:Timer = new Timer(300, 8);
					picxTimer.addEventListener(TimerEvent.TIMER, onPicxTimerTick);
					picxTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onPicxTimerComplete);
					picxTimer.start();
				}
			}
			else
			{
				if(!isShowPicxed)
				{
					numOfOneLevelPics = 8;
					for(whichPicx; whichPicx < 8; whichPicx++)
					{
						rot = 360 * whichPicx / numOfOneLevelPics;
						picxAll[whichPic][whichPicx].x =  5 * radius * Math.cos(rot * Math.PI / 180);//刚刚这里x和y的表达式反了，费了很大的周折咬咬牙
						picxAll[whichPic][whichPicx].y =  5 * radius * Math.sin(rot * Math.PI / 180);
						
						picxAll[whichPic][whichPicx].rotationX = 90 * Math.PI / 180;//注意是弧度还是角度
						picxAll[whichPic][whichPicx].rotationZ = 2 * Math.PI / numOfOneLevelPics * whichPicx + Math.PI / 2;//(((whichPicx + 1) / numOfOneLevelPics) * 360 + (90 - 360 / numOfOneLevelPics)) * Math.PI / 180;

						picxAll[whichPic][whichPicx].z = -500 - 70 * whichPicx;
						
						picxAll[whichPic][whichPicx].alpha = 0;
						
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OVER, onPicxMouseOver3D);
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OUT, onPicxMouseOut3D);
						picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.CLICK, onPicxMouseDown3D);
						
						pivotPicxDO3D.addChild(picxAll[whichPic][whichPicx]);
						
						//scene.container.addChild(picxAll[whichPic][whichPicx]);
						//pivotPicxDO3D.addChild(picxAll[whichPic][whichPicx]);
						pivotPicxDO3D.rotationZ = 6 * 45 * Math.PI / 180;
						
						Tweener.addTween(picxAll[whichPic][whichPicx],{
							x:radius * Math.cos(rot * Math.PI / 180),
							y:radius * Math.sin(rot * Math.PI / 180),
							alpha:1,
							time:1,
							delay:3
						});
						scene.container.addChild(goHome);
						
						goHome.x = 1000;
						//goHome.y = 300;
						goHome.z = -500;
						goHome.rotationX = Math.PI / 2;
						
						Tweener.addTween(goHome,{
							z:-500,
							x:300,
							time:1,
							delay:3
						});
					}
					isShowPicxed = true;
					whichPicx = 0;
				}
				
				picxWhichPic = whichPic;
				picxWhichPicx = whichPicx;
				
				
			}
		}
		
		private function onPicxTimerTick(e:TimerEvent):void
		{
			//for(picxWhichPicx; picxWhichPicx < 8; picxWhichPicx++)
			//{
				Tweener.addTween(picxAll[picxWhichPic][picxWhichPicx],{
					rotationY:3 * Math.random() * 2 * Math.PI,
					rotationX:3 * Math.random() * 2 * Math.PI,
					z:500,
					time:0.7,
					transition:"easeOutCirc"//,
					//onComplete:showPicxs,
					//onCompleteParams:[whichPic, ++whichPicx]
				});
				
				picxWhichPicx++;
			//}
		}
		
		private function onPicxTimerComplete(e:TimerEvent):void
		{
			picxWhichPicx = 0;
			
			for(picxWhichPicx; picxWhichPicx < 8; picxWhichPicx++)
			{
				Tweener.addTween(picxAll[picxWhichPic][picxWhichPicx],{
					rotationY:0,
					rotationX:0,
					time:1,
					delay:1.5
				});
			}
			goHome.x = 200 * Math.random();
			goHome.y = 200 * Math.random();
			//goHome.z = 500;
			goHome.z = 1100;
			
			goHome.rotationX = 0;
			
			scene.container.addChild(goHome);
			
			Tweener.addTween(goHome, {
				x:150,
				y:-170,
				z:500,
				time:1
			});
		}

		/**
		 * 
		 * @param whichPic
		 * @param whichPicx
		 * 
		 */		
		private function picxAppear(whichPic:uint,whichPicx:uint = 0):void//要传是几号组（从0开始）的图片作为参数
		{
			picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OVER, onPicxMouseOver3D);
			picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.ROLL_OUT, onPicxMouseOut3D);
			picxAll[whichPic][whichPicx].addEventListener(MouseEvent3D.CLICK, onPicxMouseDown3D);
			
			pivotPicxDO3D.addChild(picxContainer[whichPic]);
			
			if(whichPicx < picXml.pic[whichPic].picx.length())
			{
				Tweener.addTween(picxAll[whichPic][whichPicx],{
					alpha:picxAll[whichPic][whichPicx].alpha + 1,
					time:0.5,
					transition:"easeInQuint",
					onComplete:picxAppear,
					onCompleteParams:[whichPic, ++whichPicx]
				});
			}
			
			//this.pivotPicsDO3D.alpha = 0.3;
			
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
						z:200,
						_bezier:[
							{x:100,y:200,z:300},
							{x:300,y:0,z:200},
							{x:300,y:0,z:100},
						],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,500,200,(scene.camera.rotationX),(scene.camera.rotationY),(scene.camera.rotationZ + 180 * Math.PI / 180)]
					});
				}
				if(500 == scene.camera.y)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ - 180 * Math.PI / 180,
						x:0,
						y:-500,
						z:200,
						_bezier:[
							{x:300,y:200,z:00},
						],
						time:8,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,-500,200,(scene.camera.rotationX),(scene.camera.rotationY),(scene.camera.rotationZ - 180 * Math.PI / 180)]
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
					});
					
					trace("step1: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
				}
				else if(/*0 == scene.camera.x && */-500 == scene.camera.y /*&& -100 == scene.camera.z*/)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ + 180 * Math.PI / 180,
						x:0,
						y:500,
						z:-100,
						_bezier:[
							{x:450, y:-450, z:-200},
							{x:500, y:0, z:-150},
							{x:450, y:450, z:0}],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,500,-100,scene.camera.rotationX,scene.camera.rotationY,scene.camera.rotationZ + 180 * Math.PI / 180]
					});
					/*Tweener.addTween(scene.camera,{
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
					});*/
					
					trace("step2: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
					
				}
				else if(500 == scene.camera.y /*&& -100 == scene.camera.z*/)
				{
					CurveModifiers.init();
					
					Tweener.addTween(scene.camera,{
						rotationZ:scene.camera.rotationZ - 180 * Math.PI / 180,
						x:0,
						y:-500,
						z:-100,
						_bezier:[
							{x:300,y:400,z:100},
							{x:700,y:200,z:200},
							{x:1000,y:200,z:0},
							{x:600,y:-500,z:-50},
							{x:200,y:-700,z:-70},
						],
						time:5,
						transition:"easeInOutCubic",
						onComplete:setCamera,
						onCompleteParams:[0,-500,-100,scene.camera.rotationX,scene.camera.rotationY,scene.camera.rotationZ + 180 * Math.PI / 180]
					});
					
					trace("step3: " + "camera.x: "+ scene.camera.x + "camera.y: " + scene.camera.y + "camera.z: " + scene.camera.z);
				}
				
			}
		}
		
		private function picxDisappear(whichPic:uint,whichPicx:uint = 0):void
		{
			for(whichPicx;whichPicx < picXml.pic[whichPic].picx.length();whichPicx++)
			{
				picxAll[whichPic][whichPicx].removeEventListener(MouseEvent3D.ROLL_OVER,onPicxMouseOver3D);
				picxAll[whichPic][whichPicx].removeEventListener(MouseEvent3D.ROLL_OUT, onPicxMouseOut3D);
				picxAll[whichPic][whichPicx].removeEventListener(MouseEvent3D.CLICK, onPicxMouseDown3D);
				
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
		
		private function onPicxMouseDown3D(evt:MouseEvent3D):void
		{
			var plane:Plane = evt.target as Plane;
			
			
			if(isFirstInPicx)
			{
				prePlane = plane;
				!isFirstInPicx;
			}
			
			var numOfPlane:Array = plane.name.split("&", 2);
			var i:uint = uint(numOfPlane[0]);
			var j:uint = uint(numOfPlane[1]);
			
			var preNumOfPlane:Array = prePlane.name.split("&", 2);
			var preI:uint = uint(preNumOfPlane[0]);
			var preJ:uint = uint(preNumOfPlane[1]);
			
				
			//trace(numOfPlane);
			//trace(picXml.pic[i].picx[j].@link);
			
			/*if(preOrAft)
			{
				prePicxNum = j;
			}
			else
			{
				aftPicxNum = j;
			}
			preOrAft = !preOrAft;*/
	//		pivotPicxDO3D.rotationZ = 6 * 45 * Math.PI / 180;
			
			bigImage.load(new URLRequest(picXml.pic[i].picx[j].@link));
			bigImage.alpha = 0;
			bigImage.contentLoaderInfo.addEventListener(Event.COMPLETE, onBigImageLoaded);
			trace("bigImage" + bigImage.contentLoaderInfo);
			//bigImage.alpha = 1;
			if(0 == i % 2)
			{
				bigImage.addEventListener(MouseEvent.CLICK, onBigImageClicked);
				picxDelayTime = 0;
			}
			else
			{
				picxDelayTime = 0.8;
				
				//pivotPicxDO3D.rotationZ = -plane.rotationZ;
				
				Tweener.addTween(pivotPicxDO3D,{
					rotationZ:-plane.rotationZ,
					time:1
				});    
			
				Tweener.addTween(scene.camera,{
					z:plane.z,
					time:1
				});
				
				Tweener.addTween(goHome,{
					z:plane.z,
					time:1
				});
				//pivotPicxDO3D.rotationZ += (prePlane.z - plane.z) / 7 * 45 * Math.PI / 180;
				//pivotPicxDO3D.rotationZ -= j * 45 * Math.PI / 180;
				bigImage.addEventListener(MouseEvent.CLICK, onBigImageClicked);
				/*var picxRotationZ:Number;
				if(prePicxNum < aftPicxNum)
				{
					picxRotationZ = + j * 45 * Math.PI / 180;
				}
				else if(prePicxNum > aftPicxNum)
				{
					picxRotationZ = - j * 45 * Math.PI / 180;
				}
				else if(prePicxNum = aftPicxNum)
				{
					picxRotationZ = 0;
				}
				//pivotPicxDO3D.rotationZ -= 45 * Math.PI / 180;
				Tweener.addTween(pivotPicxDO3D,{
					rotationZ:pivotPicxDO3D.rotationZ + picxRotationZ,
					time:1
				});
				
				picxDelayTime = 1;*/
			}
			
			prePlane = plane;
			
		}
		
		private function onBigImageLoaded(evt:Event):void
		{
			bigImage.x = stage.width / 2 - bigImage.width / 2;
			bigImage.y = stage.height / 2 - bigImage.height / 2;
			
			
			
			Tweener.addTween(bigImage,{
				alpha:1,
				time:1,
				delay:picxDelayTime
			});
			addChild(bigImage);
		}
		
		private function onBigImageClicked(evt:MouseEvent):void
		{
			Tweener.addTween(bigImage,{
				alpha:bigImage.alpha - 1,
				time:1,
				onComplete:bigImage.unload
			});
			//bigImage.unload();
			bigImage.removeEventListener(MouseEvent.CLICK, onBigImageClicked);
			//bigImage.alpha = 0;
		}
		
		private function onPicxMouseOver3D(evt:MouseEvent3D):void
		{
			var plane:Plane = evt.target as Plane;
			//picClicked = true;
			var numOfPlane:Array = plane.name.split("&", 2);
			var i:uint = uint(numOfPlane[0]);
			var j:uint = uint(numOfPlane[1]);
			
			picxAll[i][j].scaleX = 1.2;
			picxAll[i][j].scaleY = 1.2;
			
			if(0 == j % 2)
			{
				plane.filters = [new GlowFilter(0x0000FF, 1, 20, 20, 4)];
			}
			else
			{
				plane.filters = [new GlowFilter(0xFFFF00, 1, 20, 20, 4)];
			}
			
			/*if(1 == i % 2)
			{
				pivotPicxDO3D.rotationZ -= j * 45 * Math.PI / 180;
			}*/
				
			//plane.scaleX = 1.2;
			//plane.scaleY = 1.2;
			//	plane.alpha = 1;
		}
		
		private function onPicxMouseOut3D(evt:MouseEvent3D):void
		{
			var plane:Plane = evt.target as Plane;
			
			var numOfPlane:Array = plane.name.split("&", 2);
			var i:uint = uint(numOfPlane[0]);
			var j:uint = uint(numOfPlane[1]);
			
			picxAll[i][j].scaleX = 1;
			picxAll[i][j].scaleY = 1;
			
			plane.filters = null;
			//plane.alpha = 0.5;
			//plane.scaleZ = 1;
			
			//picClicked = false;
		}
		
		private function onGoHomeOver3D(evt:MouseEvent3D):void
		{
			goHomeMaterial.color = 0x0000FF;
		}
		
		private function onGoHomeOut3D(evt:MouseEvent3D):void
		{
			goHomeMaterial.color = 0xFF0000;
		}
		
		private function onGoHomeDown3D(evt:MouseEvent3D):void
		{
			goHomePlane1 = new Plane();
			goHomePlane1 = Plane(goHomePlane.clone());
			
			scene.container.addChild(goHomePlane);
			scene.container.addChild(goHomePlane1);
			
			goHomePlane1.x = 0;
			goHomePlane1.y = -400;
			goHomePlane1.z = scene.camera.z;
			//goHomePlane1.scaleZ = 2;
			goHomePlane1.rotationX = 80 * Math.PI / 180;
			
			Tweener.addTween(goHomePlane1, {
				alpha:1,
				time:1				
			});
			
			Tweener.addTween(goHomePlane, {
				alpha:1,
				time:1,
				onComplete:cameraGoHome//,
				//onCompleteParams:[]

			});
		}
		
		private function cameraGoHome():void
		{
			scene.camera.x = 0;
			scene.camera.y = -500;
			scene.camera.z = 100;
			scene.camera.rotationX =-1.7681918866447772;
			pivotPicsDO3D.rotationY = 0;
			pivotPicsDO3D.rotationZ = 0;
			
			pivotPicxDO3D.rotationZ = 0;
			
			goHomePlane.z = 0;
			goHomePlane.y = -450;
			goHomePlane.rotationX = 80 * Math.PI / 180;

			isFirstInPicx = true;
			
				for(var whichPicx:uint = 0; whichPicx < 8; whichPicx++)
				{
					
				//	picxAll[picxWhichPic][whichPicx].x = positionPlanes[whichPicx].x;
				//	picxAll[picxWhichPic][whichPicx].y = positionPlanes[whichPicx].y;
				//	picxAll[picxWhichPic][whichPicx].z = positionPlanes[whichPicx].z;
					
					picxAll[picxWhichPic][whichPicx].rotationX = 0;
					picxAll[picxWhichPic][whichPicx].rotationY = 0;
					
					picxAll[picxWhichPic][whichPicx].removeEventListener(MouseEvent3D.ROLL_OVER, onPicxMouseOver3D);
					picxAll[picxWhichPic][whichPicx].removeEventListener(MouseEvent3D.ROLL_OUT, onPicxMouseOut3D);
					picxAll[picxWhichPic][whichPicx].removeEventListener(MouseEvent3D.CLICK, onPicxMouseDown3D);
					
					
					pivotPicxDO3D.removeChild(picxAll[picxWhichPic][whichPicx]);
					
					/*	Tweener.addTween(picxAll[whichPic][whichPicx],{
					z:600,
					time:2,
					delay:3
					});*/
				}
				isShowPicxed = false;
				//whichPicx = 0;
			scene.container.removeChild(goHome);
			//白板还在上边难怪突然一下消失
			Tweener.addTween(goHomePlane, {
				alpha:0,
				time:2,
				onComplete:function():void{scene.container.removeChild(goHomePlane);
										goHomePlane.z = 900;
										goHomePlane.y = 0;
										goHomePlane.rotationX  = 0;
				}
			});
			
			Tweener.addTween(goHomePlane1, {
				alpha:0,
				time:2,
				onComplete:function():void{scene.container.removeChild(goHomePlane1);}
			});
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