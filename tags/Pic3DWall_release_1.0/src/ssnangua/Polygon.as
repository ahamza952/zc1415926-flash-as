package ssnangua{
	import alternativa.engine3d.materials.FillMaterial;	// 颜色材质
	import alternativa.engine3d.materials.Material;		// 材质基类
	import alternativa.engine3d.objects.Mesh;			// 空间模型
	import alternativa.engine3d.core.Vertex;			// 顶点
	public class Polygon extends Mesh {
		public function Polygon(num:uint=3, radius1:Number=200, radius2:Number=0, twoSided:Boolean=true, reverse:Boolean=false, bottom:Material=null, top:Material=null) {
			/**
			*
			* Polygon
			* 自定义平面类 - 正多边形*圆*星形
			* @ by ssnangua
			*
			* 参数
			*
			* 边数		num		 :uint		= 3
			* 半径1		radius1	 :Number	= 200
			* 半径2		radius2	 :Number	= 0
			* 双面		twoSided :Boolean	= true
			* 反面		reverse	 :Boolean	= false
			* 底面材质	bottom	 :Material	= null
			* 顶面材质	top		 :Material	= null
			*
			*/
			if(num<3) {
				throw new ArgumentError("边数不能小于3");
			} else if(radius1<0||radius2<0) {
				throw new ArgumentError("半径不能小于0");
			} else { //debug
			if(!radius2) radius2=radius1;		// 半径2赋值
			var currentRadius:Number = radius1;	// 当前半径
			var pitch:Number = 360/num;			// 内角补角
			var angle:Number;					// 弧度
			// 添加顶点
			var vertex:Vector.<Vertex> = new Vector.<Vertex>;	// 顶点集合
			for (var i:uint=0; i<num; i++) {
				currentRadius = (i&1)?radius1:radius2;
				angle = pitch * i * Math.PI/180;
				vertex[i] = this.addVertex(Math.cos(angle)*currentRadius, Math.sin(angle)*currentRadius, 0, 0, 0, 'v'+i);
			}
			// 添加面
			var v:Vertex;
			if(reverse) { // 反面
				v=vertex.shift();
				vertex.reverse();
				vertex.unshift(v);
			}
			this.addFace(vertex, top, 'faceFront');// 正面
			if(twoSided) { // 双面
				v=vertex.shift();
				vertex.reverse();
				vertex.unshift(v); // 反转顶点
				this.addFace(vertex, bottom, 'faceBack');// 背面
			}
			//this.calculateNormals(); // 7.6.0
			this.calculateFacesNormals(); // 7.7.0
			} // end else
		}
	}
}