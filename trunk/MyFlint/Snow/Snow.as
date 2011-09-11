package 
{
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.ScaleImageInit;

	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.RandomDrift;

	public class Snow extends MovieClip
	{

		public function Snow()
		{
			var emitter:Emitter2D = new Emitter2D();

			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			addChild(renderer);
			renderer.addEmitter(emitter);

			emitter.counter = new Steady(100);

			emitter.addInitializer(new ImageClass(RadialDot, 2));
			var zone:LineZone = new LineZone(new Point(-5,-5),new Point(505,-5));
			var position:Position = new Position(zone);
			emitter.addInitializer(position);
			var zone2:PointZone = new PointZone(new Point(0,25));
			var velocity:Velocity = new Velocity(zone2);
			emitter.addInitializer(velocity);

			var move:Move = new Move();
			emitter.addAction(move);

			var dzone:RectangleZone = new RectangleZone(-10,-10,520,420);
			var deathZone:DeathZone = new DeathZone(dzone,true);
			emitter.addAction(deathZone);

			var scaleImage:ScaleImageInit = new ScaleImageInit(0.75,2);
			emitter.addInitializer(scaleImage);

			var drift:RandomDrift = new RandomDrift(20, 20);
			emitter.addAction(drift);
			
			emitter.start();
			//emitter.runAhead(10);

		}

	}

}






