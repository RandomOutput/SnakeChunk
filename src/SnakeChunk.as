//chunk_pink.png 62x62

package
{
	import flash.geom.Point;
	import PlayState;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class SnakeChunk extends FlxSprite
	{
		public static const PLAYER:int = 1;
		public static const BODY:int = 2;
		public static const RANDOM:int = 3;
		public static const INVADER:int = 4;

		private const PINK_SIZE:int = 41;
		
		private static var s_nextID:int = 0;
		public static var ZERO:FlxPoint = new FlxPoint();
		
		public static const WIDTH:int = 30
		public static const HEIGHT:int = 30;
		
		private var m_mode:int;
		private var m_type:int;
		private var m_lastVelocity:FlxPoint;
		private var m_ahead:SnakeChunk;
		private var m_behind:SnakeChunk;
		private var m_resetTime:uint;
		//for behavior
		private var m_dropTime:uint = 0;
		private var xSwap:int = 1;
		private var ySwap:int = 1;
		
		public var lastY:Number;
		public var lastX:Number;
		
		public var chainID:uint;
		public var chunkID:uint;
		
		public function get nextID():int
		{
			return ++s_nextID;
		}
		
		public function SnakeChunk(X:int, Y:int, mode:int)
		{
			super(X, Y, null);
			lastX = X;
			lastY = Y;

			loadGraphic(pinkChunkImage, false, false, PINK_SIZE, PINK_SIZE);

			m_mode = mode;
			if(m_mode != BODY)
			{
				chainID = nextID;
			}
			chunkID = nextID;
			m_lastVelocity = new FlxPoint(0,0);
		}
		
		public override function update():void
		{
			m_lastVelocity = new FlxPoint(velocity.x, velocity.y);
			lastX = x;
			lastY = y;
			super.update();
			switch(m_mode)
			{
				case PLAYER:
					var newVelocity:FlxPoint = new FlxPoint();
					if(FlxG.keys.UP && !FlxG.keys.DOWN)
					{
						newVelocity.y = Math.max(velocity.y - 5, -100);
					}
					else if(!FlxG.keys.UP && FlxG.keys.DOWN)
					{
						newVelocity.y = Math.max(velocity.x + 5, 100);
					}
					else
					{
						newVelocity.y = velocity.y * .8;
					}
					if(FlxG.keys.LEFT && !FlxG.keys.RIGHT)
					{	
						newVelocity.x = Math.max(velocity.x - 5, -100);
					}
					else if(!FlxG.keys.LEFT && FlxG.keys.RIGHT)
					{
						newVelocity.x = Math.min(velocity.x + 5, 100);
					}
					else
					{
						newVelocity.x = velocity.x * .8;
					}
					/*WORK THIS OUT LATER*/
					//var distance:Number = Math.max(FlxU.getDistance(ZERO, newVelocity), Number.MIN_VALUE);
					//newVelocity.x  /= distance;
				//	newVelocity.y  /= distance;
					//var p:FlxPoint = new FlxPoint(x - m_behind.x, y - m_behind.y);
					//var distance2:Number = Math.max(FlxU.getDistance(ZERO, p), Number.MIN_VALUE);
					var dot:Number =1; //newVelocity.x / distance * p.x / distance + newVelocity.y /distance * p.y / distance;
					velocity.x = newVelocity.x * dot;
					velocity.y = newVelocity.y * dot; 
					break;
				case BODY:
					if(m_ahead != null)
					{
						var distance:Number = Math.max(FlxU.getDistance(new FlxPoint(x, y), new FlxPoint(m_ahead.lastX, m_ahead.lastY)), Number.MIN_VALUE);
						newVelocity = new FlxPoint((m_ahead.lastX - x) / distance, (m_ahead.lastY - y) / distance);
						dot = newVelocity.x * m_ahead.lastVelocity.x + newVelocity.y * m_ahead.lastVelocity.y;
						velocity.x = newVelocity.x * dot * .3 + velocity.x * .7 + (newVelocity.x * (distance - PlayState.SPACER_VAL));
						velocity.y = newVelocity.y * dot * .3 + velocity.y * .7 + (newVelocity.y * (distance - PlayState.SPACER_VAL));
						
						
						
					}
					break;
				case RANDOM:
					if(FlxU.getTicks() > m_resetTime)
					{
						velocity.x = Math.random() - .5;
						velocity.y = Math.random() - .5;
						distance = Math.max(FlxU.getDistance(ZERO, velocity), Number.MIN_VALUE);
						velocity.x =  (velocity.x / distance) * 100;
						velocity.y = (velocity.y / distance)  * 100;
						m_resetTime = FlxU.getTicks() + Math.random() * 3000;
					}
					break;
				case INVADER:
					if(FlxU.getTicks() > m_dropTime)
					{
						velocity.x = xSwap * 200;
						velocity.y = 0;

						if(x > 700 - WIDTH || x < 0)
						{
							xSwap *= -1;
							m_dropTime = FlxU.getTicks() + Math.max(Math.random() * 1500, 250);
						} 
					} 
					else
					{
						velocity.y = ySwap * 100;
						velocity.x = 0;
						if(y > 600 - HEIGHT || y < 0)
						{
							ySwap *= -1;
						}
					}
					break;
			}
			var perpendicular:FlxPoint = new FlxPoint(velocity.y, -velocity.x);
			angle = FlxU.getAngle(ZERO, perpendicular);
			if(x > 700 - WIDTH)
			{
				x = 700 - WIDTH;
				velocity.x *= -.5;
				m_resetTime = 0;
			}
			if(x < 0)
			{
				x = 0;
				velocity.x *= -.5;
				m_resetTime = 0;
			}
			if(y > 600 - HEIGHT)
			{
				y = 600 - HEIGHT;
				velocity.y *= -.5;
				m_resetTime = 0;
			}	
			if(y < 0)
			{
				y = 0;
				velocity.y *= -.5;
				m_resetTime = 0;
			}	
		}
		
		public function get lastVelocity():FlxPoint
		{
			return m_lastVelocity;
		}
		
		public function setBreakType(type:int = RANDOM):void
		{
			m_type = type;

			trace("MODE: " + type);
			
			switch(type)
			{
				case 3:
					loadGraphic(dotChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					break;	
				case 4: 
					loadGraphic(pinkChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					break;
				case 5: 
					loadGraphic(purpleChunkImage, false, false, PINK_SIZE, PINK_SIZE);
					break;
				default:
					makeGraphic(25, 25, 0xffff0000); 
				break;
			}
		}
		
		public function get mode():int
		{
			return m_mode;
		}
		
		public function set mode(newMode:int):void
		{
			m_mode = newMode;
		}
		
		public function set ahead(chunk:SnakeChunk):void
		{
			if(chunk == null)
			{
				m_ahead = null
			}
			else if(m_mode != PLAYER)
			{
				if(m_ahead == null)
				{
					m_ahead = chunk;
					m_mode = BODY;
					setChainID(chunk.chainID);
				}
				else
				{
					trace("AHEAD ALREADY SET");
				}
			}
			else
			{
				trace("CAN'T SET AHEAD ON PLAYER");
			}
		}
		
		public function get ahead():SnakeChunk
		{
			return m_ahead;
		}
		
		public function set behind(chunk:SnakeChunk):void
		{
			if(chunk == null)
			{
				m_behind = null
			}
			else if(m_behind == null)
			{
				m_behind = chunk;
				m_behind.setChainID(chunk.chainID);
			}
			else
			{
				trace("BEHIND ALREADY SET");
			}
		}
		
		public function get behind():SnakeChunk
		{
			return m_behind;
		}
		
		public function setChainID(id:int):void
		{
			if(m_behind != null)
			{
				m_behind.setChainID(id);
			}
			chainID = id;
		}
		
		private function chunk(id:int, chunkSize:int = 2, count:int = 0):void
		{
			if(count > chunkSize)
			{
				split();
			}
			else
			{
				if(m_behind != null)
				{
					m_behind.chunk(id, chunkSize, ++count);
				}
				chainID = id;
			}
		}
		
		public function split():void
		{
			if(m_ahead)
			{
				m_mode = m_type;
				chunk(nextID, int(Math.random() + .5) + 2);
				m_ahead.m_behind = null;
				m_ahead = null;
			}
		}

		//*** Assets ***
		[Embed(source="/images/chunk_pink.png")]
		private static var pinkChunkImage:Class;

		[Embed(source="/images/chunk_purple.png")]
		private static var purpleChunkImage:Class;

		[Embed(source="/images/chunk_dot.png")]
		private static var dotChunkImage:Class;
	}
}