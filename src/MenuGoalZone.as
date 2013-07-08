package
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class MenuGoalZone extends FlxSprite
	{
		
		protected var m_gracePeriod:uint;
		
		
		public function MenuGoalZone(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			loadGraphic(goalZoneImage, false, false, 97, 97);
			addAnimation("stage4", [0,1,2,3], 10, true);
			addAnimation("stage3", [4,5,6,7], 10, true);
			addAnimation("stage2", [8,9,10,11], 10, true);
			addAnimation("stage1", [12,13,14,15], 10, true);

			play("stage1");
		}
		
		public override function update():void
		{
			var dist:Number = FlxU.getDistance(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), new FlxPoint(x + (95/2),y + (95/2)));
			
			if(dist <= 76)
			{
				play("stage4");

				if(FlxG.mouse.pressed())
				{
					FlxG.switchState(new PlayState());
				}
			}
			else
			{
				play("stage1");
			}
		}

		//*** Assets ***
		[Embed(source="/images/goal_strip_small.png")]
		private static var goalZoneImage:Class;
		
		

	}


}