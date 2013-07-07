package
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class GoalZone extends FlxSprite
	{
		public function GoalZone(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			loadGraphic(goalZoneImage, false, false, 88, 88);
			addAnimation("stage4", [0,1,2,3], 10, true);
			addAnimation("stage3", [4,5,6,7], 10, true);
			addAnimation("stage2", [8,9,10,11], 10, true);
			addAnimation("stage1", [12,13,14,15], 10, true);

			play("stage3");
		}
		
		public function checkSnake(snake:SnakeChunk):Boolean
		{
			trace("GO");
			if(!snake)
			{
				return false;
			}
			var head:SnakeChunk = snake;
			var count:int  = 0;
			var count_in:int = 0;
			while(head.ahead != null)
			{
				head = head.ahead;
			}
			if(head.mode != SnakeChunk.PLAYER)
			{
				return false;
			}
			
			var tail:SnakeChunk = head;
			
			while(tail)
			{
				if(FlxCollision.pixelPerfectCheck(tail as FlxSprite, this as FlxSprite))
				{
					count_in++;
				}
				tail = tail.behind;
				count++;
			}

			if(count == count_in)
			{
				play("stage4");
				return true;
			}
			else if(count_in / count >= .5)
			{
				play("stage3");
			}
			else if(count_in > 0)
			{
				play("stage2");
			}
			else
			{
				play("stage1");
			}

			return false;
		}

		//*** Assets ***
		[Embed(source="/images/goal_strip_small.png")]
		private static var goalZoneImage:Class;

	}


}