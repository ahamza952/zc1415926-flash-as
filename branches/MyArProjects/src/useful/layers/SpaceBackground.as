package useful.layers
{
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class SpaceBackground extends Object3DContainer
	{
		private var imageLoader:Loader;
		private var backgroundBitmapData:BitmapData;
		
		public function SpaceBackground(imgUrl:String)
		{
			loadImage(imgUrl);
		}
		
		private function loadImage(imgUrl:String):void
		{
			imageLoader = new Loader();
			imageLoader.load(new URLRequest(imgUrl));
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
		}
		
		private function onImageLoaded(e:Event):void
		{
			backgroundBitmapData = e.target.content.bitmapData;
			createSpaceBackground();
		}
		
		private function createSpaceBackground():void
		{
			var mesh:Mesh = new Mesh();
			
			var v1:Vertex = mesh.addVertex(-150, -60, 0, 0, 0, "v1");
			var v2:Vertex = mesh.addVertex(150, -60, 0, 0, 1, "v2");
			var v3:Vertex = mesh.addVertex(150, 100, 0, 0.5, 1, "v3");
			var v4:Vertex = mesh.addVertex(-150, 100, 0, 0, 0.5, "v4");
			var v5:Vertex = mesh.addVertex(150, 200, 150, 1, 1, "v5");
			var v6:Vertex = mesh.addVertex(-150, 200, 150, 1, 0, "v6");
			
			mesh.addFaceByIds(["v1", "v2", "v3", "v4"]);
			mesh.addFaceByIds(["v3", "v5", "v6", "v4"]);
			
			var material:TextureMaterial = new TextureMaterial(backgroundBitmapData);
			mesh.setMaterialToAllFaces(material);
			
			mesh.calculateFacesNormals(true);
			mesh.calculateBounds();
			
			addChild(mesh);
		}
	}
}