package
{
	import org.flixel.FlxSprite;
	
	public class GoalZone extends FlxSprite
	{
		public function GoalZone(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			makeGraphic(50, 70, 0xff00ff00);
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
				if(tail.x < x || tail.y < y || tail.x + tail.width > x + width || tail.y + tail.height > y + height)
				{
					return false;
				}
				tail = tail.behind;
			}
			return true;
		}
	}
}