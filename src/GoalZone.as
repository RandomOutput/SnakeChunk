package
{
	import org.flixel.FlxSprite;
	
	public class GoalZone extends FlxSprite
	{
		public function GoalZone(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			loadGraphic(goalZoneImage, false, false, 102, 102);
		}
		
		public function checkSnake(snake:SnakeChunk):Boolean
		{
			if(!snake)
			{
				return false;
			}
			var head:SnakeChunk = snake;
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
				if(tail.x + (tail.width/2) < x || tail.y + (tail.height/2) < y || tail.x + (tail.width/2) + tail.width > x + width || tail.y + (tail.height/2) > y + height)
				{
					return false;
				}
				tail = tail.behind;
			}
			return true;
		}

		//*** Assets ***
		[Embed(source="/images/goal_zone.png")]
		private static var goalZoneImage:Class;

	}


}