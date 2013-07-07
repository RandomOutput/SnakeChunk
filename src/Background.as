package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	
	public class Background extends FlxGroup
	{
		private static const SHADOW_SPAWN_RATE:int = 5000; //in ticks
		private static const SHADOW_SPAWN_RANGE:int = 500; //in ticks
		private static const SHADOW_SPEED:int = 100;

		private var m_background:FlxSprite;

		private var m_spawnTime:int = 0;

		public function Background()
		{
			super();
			m_background = new FlxSprite();
			m_background.loadGraphic(backgroundImage, true, false, 700, 600);
			m_background.addAnimation("shimmer", [0,1,2], 6, true);
			m_background.play("shimmer");

			add(m_background);

		}

		override public function update():void
		{
			super.update();
			if(m_spawnTime < FlxU.getTicks())
			{
				spawnShadow();
				m_spawnTime = FlxU.getTicks() + Math.floor((Math.random()*SHADOW_SPAWN_RANGE) - SHADOW_SPAWN_RANGE/2) + SHADOW_SPAWN_RATE;
			}
		}

		private function spawnShadow():void
		{
			var swap:int = Math.random() > .5 ? 1 : -1;
			var side:int = Math.random() > .5 ? 1 : -1;

			var shadowPoint:FlxPoint = new FlxPoint();
			var goalPoint:FlxPoint = new FlxPoint();
			var newShadow:FlxSprite = new FlxSprite();
			newShadow.loadGraphic(shadowImage, false, false, 257, 365);

			if(side == -1)//x is in bounds, y is out of bounds
			{
				shadowPoint.y = 300 + swap * (300 + 400);
				shadowPoint.x = Math.random() * (700 - 200);

				goalPoint.y = 300 - swap * (300 + 400);
				shadowPoint.x = Math.random() * (700 - 200);				
			} 
			else //y is in bounds, x is out of bounds.
			{
				shadowPoint.x = 350 + swap * (350 + 400);
				shadowPoint.y = Math.random() * (600 - 200);

				goalPoint.x = 350 - swap * (350 + 400);
				shadowPoint.y = Math.random() * (600 - 200);
			}

			newShadow.x = shadowPoint.x;
			newShadow.y = shadowPoint.y;

			newShadow.velocity.x = (goalPoint.x - shadowPoint.x) / FlxU.getDistance(shadowPoint, goalPoint);
			newShadow.velocity.y = (goalPoint.y - shadowPoint.y) / FlxU.getDistance(shadowPoint, goalPoint);

			add(newShadow);
			
			newShadow.velocity.x *= SHADOW_SPEED;
			newShadow.velocity.y *= SHADOW_SPEED;

			trace("velocityX: " + newShadow.velocity.x);

		}

		[Embed(source="/images/background.png")]
		private static var backgroundImage:Class;

		[Embed(source="/images/shadow_001.png")]
		private static var shadowImage:Class;
	}
}